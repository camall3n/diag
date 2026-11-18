import Diag.StandardP
import Diag.Examples

/-!
# M6: a named-variable front end (untrusted)

Candidates (agent code + certificate) are plain **S-expression data**, never Lean code,
so a candidate can't influence the verdict. This file reads them, compiles named
variables and hypotheses to de Bruijn indices, and produces a `Program` and a `Proof`.
The verdict always comes from the trusted `check`. `diagnose` only explains a rejection,
by locating the first proof node that `infer` rejects.

## Program syntax
  (program (define (main opp cert) BODY) (define (f x y) BODY) ...)
  BODY: identifier (variable) | number | "string" | @C @D @true @false @nil @K @KP @F
        | (q RAW) | (if c t e) | (let x e body) | (OP args…) | (f args…)
  OP ∈ eq pair fst snd isPair isNat plus minus lt sz check subst

## Certificate syntax: a proof of the statement chosen by the runner (K or K′ of @self)
  terms:    variable | number | @self @delta @deltaP @C @D @true @false @K @KP @F @T @L @Kmax
            | (q RAW) | (ite c t e) | (run f code arg…) | (list t…) | (OP t…)
  formulas: false | true | (= t u) | (-> A B) | (and A B) | (iff A B) | (not A)
            | (forall x A) | (bound t B)          ; bound: sz t < B + 1
  proofs:   (hyp h) | (intro h A P) | (mp P Q) | (have h A P Q)
            | (and-intro P Q) | (and-l P) | (and-r P) | (exfalso A P) | (dne P)
            | (forall-intro x P) | (forall-elim P t) | (refl t) | (rw x M P Q)
            | (ite-t t e P) | (ite-f t e P) | (eval t u) | (eval-ne t u)
            | (bool-cases t P Q) | (trivial)
            | (sym-run f code ((t B h) …))       ; h names the hypothesis proving (bound t B)
-/

namespace Diag.Front
open Diag Standard Params

instance : Inhabited Val := ⟨Val.nil⟩

inductive SX where
  | atom : String → SX
  | num  : Nat → SX
  | str  : String → SX
  | list : List SX → SX
deriving Repr, Inhabited

/-! ## Reader -/

partial def tokenize (cs : List Char) (cur : String) (acc : Array String) : Array String :=
  let flush (a : Array String) : Array String := if cur.isEmpty then a else a.push cur
  match cs with
  | [] => flush acc
  | c :: rest =>
    if c == ';' then tokenize (rest.dropWhile (· != '\n')) "" (flush acc)
    else if c == '(' || c == ')' then tokenize rest "" ((flush acc).push (String.singleton c))
    else if c.isWhitespace then tokenize rest "" (flush acc)
    else if c == '"' then
      let str := rest.takeWhile (· != '"')
      tokenize (rest.drop (str.length + 1)) "" ((flush acc).push ("\"" ++ String.ofList str))
    else tokenize rest (cur.push c) acc

mutual
partial def parseSX : List String → Except String (SX × List String)
  | [] => .error "unexpected end of input"
  | "(" :: rest => parseList rest []
  | ")" :: _ => .error "unexpected ')'"
  | t :: rest =>
    if t.startsWith "\"" then .ok (.str (t.drop 1).toString, rest)
    else match t.toNat? with
      | some n => .ok (.num n, rest)
      | none => .ok (.atom t, rest)
partial def parseList : List String → List SX → Except String (SX × List String)
  | [], _ => .error "missing ')'"
  | ")" :: rest, acc => .ok (.list acc.reverse, rest)
  | toks, acc => do
    let (x, rest) ← parseSX toks
    parseList rest (x :: acc)
end

partial def parseAll (toks : List String) (acc : List SX) : Except String (List SX) :=
  match toks with
  | [] => .ok acc.reverse
  | _ => do
    let (x, rest) ← parseSX toks
    parseAll rest (x :: acc)

def read (s : String) : Except String (List SX) := parseAll (tokenize s.toList "" #[]).toList []

partial def SX.toVal : SX → Val
  | .atom s => .sym s
  | .str s => .sym s
  | .num n => .nat n
  | .list xs => Val.ofList (xs.map SX.toVal)

partial def SX.show : SX → String
  | .atom s => s
  | .str s => "\"" ++ s ++ "\""
  | .num n => toString n
  | .list xs => "(" ++ " ".intercalate (xs.map SX.show) ++ ")"

/-! ## Constants and programs -/

def constVal : String → Option Val
  | "@C" => some C | "@D" => some D | "@true" => some Val.tru | "@false" => some Val.fls
  | "@nil" => some Val.nil | "@K" => some Kq | "@KP" => some KPq
  | "@F" => some (.nat F) | "@T" => some (.nat T) | "@L" => some (.nat L)
  | "@Kmax" => some (.nat Kmax)
  | "@CertBot" => some certBot | "@CertBotP" => some certBotP
  | "@CooperateBot" => some Examples.cooperateBot.code | "@DefectBot" => some Examples.defectBot.code
  | _ => none

def natConst : SX → Except String Nat
  | .num n => .ok n
  | .atom a => match constVal a with
    | some (.nat n) => .ok n
    | _ => .error s!"expected a number, got {a}"
  | x => .error s!"expected a number, got {x.show}"

partial def compileExpr : SX → Except String Expr
  | .num n => .ok (.lit (.nat n))
  | .str s => .ok (.lit (.sym s))
  | .atom a =>
    match constVal a with
    | some v => .ok (.lit v)
    | none => if a.startsWith "@" then .error s!"unknown constant {a}" else .ok (.var a)
  | .list [.atom "q", v] => .ok (.lit v.toVal)
  | .list [.atom "if", c, t, e] => return .ite (← compileExpr c) (← compileExpr t) (← compileExpr e)
  | .list [.atom "let", .atom x, e, bd] => return .let_ x (← compileExpr e) (← compileExpr bd)
  | .list (.atom f :: args) => do
    let as ← args.mapM compileExpr
    match Op.ofName? f with
    | some o => .ok (.op o as)
    | none => .ok (.call f as)
  | x => .error s!"bad expression {x.show}"

def compileDefine : SX → Except String (String × List String × Expr)
  | .list [.atom "define", .list (.atom f :: ps), body] => do
    let ps ← ps.mapM fun | .atom p => .ok p | x => .error s!"bad parameter {x.show}"
    return (f, ps, ← compileExpr body)
  | x => .error s!"bad definition {x.show}"

def compileProgram : SX → Except String Program
  | .list (.atom "program" :: defs) => return ⟨← defs.mapM compileDefine⟩
  | x => .error s!"expected (program …), got {x.show}"

/-! ## Terms, formulas, proofs with names -/

def idxOf (x : String) : List String → Option Nat
  | [] => none
  | y :: ys => if x == y then some 0 else (idxOf x ys).map (· + 1)

partial def compileTm (vs : List String) (self : Val) : SX → Except String Tm
  | .num n => .ok (.lit (.nat n))
  | .str s => .ok (.lit (.sym s))
  | .atom a =>
    match idxOf a vs with
    | some i => .ok (.bvar i)
    | none =>
      match a with
      | "@self" => .ok (.lit self)
      | "@delta" => .ok δ
      | "@deltaP" => .ok δP
      | _ => match constVal a with
        | some v => .ok (.lit v)
        | none => .error s!"unbound variable {a}"
  | .list [.atom "q", v] => .ok (.lit v.toVal)
  | .list [.atom "ite", c, t, e] =>
    return .ite (← compileTm vs self c) (← compileTm vs self t) (← compileTm vs self e)
  | .list (.atom "run" :: f :: c :: args) => do
    return .run (← compileTm vs self f) (← compileTm vs self c) (Tm.list (← args.mapM (compileTm vs self)))
  | .list (.atom "list" :: args) => return Tm.list (← args.mapM (compileTm vs self))
  | .list (.atom o :: args) => do
    let as ← args.mapM (compileTm vs self)
    match Op.ofName? o, as with
    | some o, [a] => .ok (.op1 o a)
    | some o, [a, b] => .ok (.op2 o a b)
    | some o, [a, b, c] => .ok (.op3 o a b c)
    | _, _ => .error s!"bad term {(SX.list (.atom o :: args)).show}"
  | x => .error s!"bad term {x.show}"

partial def compileFm (vs : List String) (self : Val) : SX → Except String Fm
  | .atom "false" => .ok .fls
  | .atom "true" => .ok Fm.top
  | .list [.atom "=", a, b'] => return .eq (← compileTm vs self a) (← compileTm vs self b')
  | .list [.atom "->", a, b'] => return .imp (← compileFm vs self a) (← compileFm vs self b')
  | .list [.atom "and", a, b'] => return .and (← compileFm vs self a) (← compileFm vs self b')
  | .list [.atom "iff", a, b'] => return Fm.iff (← compileFm vs self a) (← compileFm vs self b')
  | .list [.atom "not", a] => return Fm.not (← compileFm vs self a)
  | .list [.atom "forall", .atom x, a] => return .all (← compileFm (x :: vs) self a)
  | .list [.atom "bound", t, bB] => return boundFm (← compileTm vs self t) (← natConst bB)
  | x => .error s!"bad formula {x.show}"

def hypIdx (hs : List String) (h : String) : Except String Nat :=
  match idxOf h hs with
  | some i => .ok i
  | none => .error s!"unknown hypothesis {h}"

partial def compilePf (vs hs : List String) (self : Val) : SX → Except String Proof
  | .list [.atom "hyp", .atom h] => return .hyp (← hypIdx hs h)
  | .list [.atom "intro", .atom h, a, p] =>
    return .impI (← compileFm vs self a) (← compilePf vs (h :: hs) self p)
  | .list [.atom "mp", p, q] => return .impE (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "have", .atom h, a, p, q] =>
    return .impE (.impI (← compileFm vs self a) (← compilePf vs (h :: hs) self q))
      (← compilePf vs hs self p)
  | .list [.atom "and-intro", p, q] => return .andI (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "and-l", p] => return .andL (← compilePf vs hs self p)
  | .list [.atom "and-r", p] => return .andR (← compilePf vs hs self p)
  | .list [.atom "exfalso", a, p] => return .exfalso (← compileFm vs self a) (← compilePf vs hs self p)
  | .list [.atom "dne", p] => return .dne (← compilePf vs hs self p)
  | .list [.atom "forall-intro", .atom x, p] => return .allI (← compilePf (x :: vs) hs self p)
  | .list [.atom "forall-elim", p, t] => return .allE (← compilePf vs hs self p) (← compileTm vs self t)
  | .list [.atom "refl", t] => return .refl (← compileTm vs self t)
  | .list [.atom "rw", .atom x, m, p, q] =>
    return .rw (← compileFm (x :: vs) self m) (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "ite-t", t, e, p] =>
    return .iteT (← compileTm vs self t) (← compileTm vs self e) (← compilePf vs hs self p)
  | .list [.atom "ite-f", t, e, p] =>
    return .iteF (← compileTm vs self t) (← compileTm vs self e) (← compilePf vs hs self p)
  | .list [.atom "eval", t, u] => return .eval (← compileTm vs self t) (← compileTm vs self u)
  | .list [.atom "eval-ne", t, u] => return .evalNe (← compileTm vs self t) (← compileTm vs self u)
  | .list [.atom "bool-cases", t, p, q] =>
    return .boolCases (← compileTm vs self t) (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "trivial"] => .ok topPf
  | .list [.atom "val-ind", .atom x, m, p, q] =>
    return .valInd (← compileFm (x :: vs) self m) (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "nat-ind", .atom x, m, p, q] =>
    return .natInd (← compileFm (x :: vs) self m) (← compilePf vs hs self p) (← compilePf vs hs self q)
  | .list [.atom "sym-run", f, code, .list args] => do
    let f ← natConst f
    let code ← match ← compileTm vs self code with
      | .lit v => pure v
      | _ => throw "sym-run: the code must be a literal (e.g. @self)"
    let triples ← args.mapM fun
      | .list [t, bB, .atom h] => do
        return ((← compileTm vs self t), (← natConst bB), (← hypIdx hs h))
      | x => throw s!"sym-run: bad argument {x.show}, expected (term bound hyp)"
    let hyps := triples.foldr (fun (_, _, i) acc => Proof.andI (.hyp i) acc) topPf
    return .symRun f code (triples.map fun (t, bB, _) => (t, bB)) hyps
  | x => .error s!"bad proof {x.show}"

/-! ## Diagnosis (explanations only) -/

def showVal (v : Val) : String := if v.sz > 40 then s!"<literal, size {v.sz}>" else toString v

partial def showTm : Tm → String
  | .bvar i => s!"#{i}"
  | .lit v => showVal v
  | .op1 o a => s!"{o.name}({showTm a})"
  | .op2 o a b' => s!"{o.name}({showTm a}, {showTm b'})"
  | .op3 o a b' c => s!"{o.name}({showTm a}, {showTm b'}, {showTm c})"
  | .ite c t e => s!"ite({showTm c}, {showTm t}, {showTm e})"
  | .run f c a => s!"run({showTm f}, {showTm c}, {showTm a})"

partial def showFm : Fm → String
  | .eq a b' => s!"{showTm a} = {showTm b'}"
  | .fls => "⊥"
  | .imp a b' => s!"({showFm a} → {showFm b'})"
  | .and a b' => s!"({showFm a} ∧ {showFm b'})"
  | .all a => s!"∀.{showFm a}"

def ruleName : Proof → String
  | .hyp _ => "hyp" | .impI _ _ => "intro" | .impE _ _ => "mp" | .andI _ _ => "and-intro"
  | .andL _ => "and-l" | .andR _ => "and-r" | .exfalso _ _ => "exfalso" | .dne _ => "dne"
  | .allI _ => "forall-intro" | .allE _ _ => "forall-elim" | .refl _ => "refl"
  | .rw _ _ _ => "rw" | .iteT _ _ _ => "ite-t" | .iteF _ _ _ => "ite-f" | .eval _ _ => "eval"
  | .evalNe _ _ => "eval-ne" | .symRun _ _ _ _ => "sym-run" | .boolCases _ _ _ => "bool-cases"
  | .valInd _ _ _ => "val-ind" | .natInd _ _ _ => "nat-ind"

def bigFuel : Nat := 2 ^ 30

def children (Γ : List Fm) : Proof → List (List Fm × Proof)
  | .impI a q => [(a :: Γ, q)]
  | .allI q => [(Γ.map (Fm.shift 1 0), q)]
  | .impE q r | .andI q r | .rw _ q r | .boolCases _ q r | .valInd _ q r | .natInd _ q r =>
    [(Γ, q), (Γ, r)]
  | .andL q | .andR q | .exfalso _ q | .dne q | .allE q _ | .iteT _ _ q | .iteF _ _ q
  | .symRun _ _ _ q => [(Γ, q)]
  | _ => []

/-- The first (innermost) proof node that `infer` rejects, with what its premises prove. -/
partial def diagnose (Γ : List Fm) (p : Proof) : Option String :=
  match infer bigFuel Γ p with
  | some _ => none
  | none =>
    let cs := children Γ p
    match cs.findSome? (fun (g, q) => diagnose g q) with
    | some msg => some msg
    | none =>
      let prem := cs.map fun (g, q) => match infer bigFuel g q with
        | some (φ, _) => showFm φ
        | none => "?"
      let extra := match p with
        | .hyp i => s!" (no hypothesis #{i})"
        | .symRun f _ _ _ => s!" (symbolic run of the code failed: unsupported shape, recursion on symbolic data, or cost bound > {f})"
        | .eval _ _ | .evalNe _ _ => " (terms not closed, evaluation failed, or the values don't match the rule)"
        | _ => ""
      some s!"rule `{ruleName p}` rejected{extra}; premises prove: [{"; ".intercalate prem}]"

/-! ## Emitting compiled candidates as Lean source (untrusted)

Used to kernel-check M6 candidates: the emitted definitions *are* the data the kernel
checks, so the faithfulness of this printer doesn't affect what the theorems state. Known
large literals are printed by name to keep the source small. -/

def namedVals (self : String × Val) : List (String × Val) :=
  [self, ("Kq", Kq), ("KPq", KPq), ("certBot", certBot), ("certBotP", certBotP),
   ("Val.tru", Val.tru), ("Val.fls", Val.fls), ("Val.nil", Val.nil)]

def leanStr (s : String) : String :=
  "\"" ++ ((s.replace "\\" "\\\\").replace "\"" "\\\"") ++ "\""

partial def Val.toLean (named : List (String × Val)) (v : Val) : String :=
  match named.find? (fun (_, w) => w.sz == v.sz && w == v) with
  | some (n, _) => n
  | none => match v with
    | .nat n => s!"(.nat {n})"
    | .sym x => s!"(.sym {leanStr x})"
    | .pair a b => s!"(.pair {Val.toLean named a} {Val.toLean named b})"

partial def Tm.toLean (named : List (String × Val)) (t : Tm) : String :=
  if t == δ then "δ" else if t == δP then "δP" else
  match t with
  | .bvar i => s!"(.bvar {i})"
  | .lit v => s!"(.lit {Val.toLean named v})"
  | .op1 o a => s!"(.op1 .{o.name} {Tm.toLean named a})"
  | .op2 o a b => s!"(.op2 .{o.name} {Tm.toLean named a} {Tm.toLean named b})"
  | .op3 o a b c => s!"(.op3 .{o.name} {Tm.toLean named a} {Tm.toLean named b} {Tm.toLean named c})"
  | .ite a b c => s!"(.ite {Tm.toLean named a} {Tm.toLean named b} {Tm.toLean named c})"
  | .run a b c => s!"(.run {Tm.toLean named a} {Tm.toLean named b} {Tm.toLean named c})"

partial def Fm.toLean (named : List (String × Val)) : Fm → String
  | .eq a b => s!"(.eq {Tm.toLean named a} {Tm.toLean named b})"
  | .fls => ".fls"
  | .imp a b => s!"(.imp {Fm.toLean named a} {Fm.toLean named b})"
  | .and a b => s!"(.and {Fm.toLean named a} {Fm.toLean named b})"
  | .all a => s!"(.all {Fm.toLean named a})"

partial def Proof.toLean (named : List (String × Val)) : Proof → String
  | .hyp i => s!"(.hyp {i})"
  | .impI a p => s!"(.impI {Fm.toLean named a} {Proof.toLean named p})"
  | .impE p q => s!"(.impE {Proof.toLean named p} {Proof.toLean named q})"
  | .andI p q => s!"(.andI {Proof.toLean named p} {Proof.toLean named q})"
  | .andL p => s!"(.andL {Proof.toLean named p})"
  | .andR p => s!"(.andR {Proof.toLean named p})"
  | .exfalso a p => s!"(.exfalso {Fm.toLean named a} {Proof.toLean named p})"
  | .dne p => s!"(.dne {Proof.toLean named p})"
  | .allI p => s!"(.allI {Proof.toLean named p})"
  | .allE p t => s!"(.allE {Proof.toLean named p} {Tm.toLean named t})"
  | .refl t => s!"(.refl {Tm.toLean named t})"
  | .rw m p q => s!"(.rw {Fm.toLean named m} {Proof.toLean named p} {Proof.toLean named q})"
  | .iteT t e p => s!"(.iteT {Tm.toLean named t} {Tm.toLean named e} {Proof.toLean named p})"
  | .iteF t e p => s!"(.iteF {Tm.toLean named t} {Tm.toLean named e} {Proof.toLean named p})"
  | .eval t u => s!"(.eval {Tm.toLean named t} {Tm.toLean named u})"
  | .evalNe t u => s!"(.evalNe {Tm.toLean named t} {Tm.toLean named u})"
  | .symRun f c args p =>
    let as := ", ".intercalate (args.map fun (t, bB) => s!"({Tm.toLean named t}, {bB})")
    s!"(.symRun {f} {Val.toLean named c} [{as}] {Proof.toLean named p})"
  | .boolCases t p q => s!"(.boolCases {Tm.toLean named t} {Proof.toLean named p} {Proof.toLean named q})"
  | .valInd m p q => s!"(.valInd {Fm.toLean named m} {Proof.toLean named p} {Proof.toLean named q})"
  | .natInd m p q => s!"(.natInd {Fm.toLean named m} {Proof.toLean named p} {Proof.toLean named q})"

partial def Expr.toLean (named : List (String × Val)) : Expr → String
  | .var x => s!"(.var {leanStr x})"
  | .lit v => s!"(.lit {Val.toLean named v})"
  | .op o es => s!"(.op .{o.name} [{", ".intercalate (es.map (Expr.toLean named))}])"
  | .ite c t e => s!"(.ite {Expr.toLean named c} {Expr.toLean named t} {Expr.toLean named e})"
  | .let_ x e b => s!"(.let_ {leanStr x} {Expr.toLean named e} {Expr.toLean named b})"
  | .call f es => s!"(.call {leanStr f} [{", ".intercalate (es.map (Expr.toLean named))}])"

def Program.toLean (named : List (String × Val)) (p : Program) : String :=
  let fns := p.fns.map fun (f, ps, b) =>
    s!"({leanStr f}, [{", ".intercalate (ps.map leanStr)}], {Expr.toLean named b})"
  s!"⟨[{",\n    ".intercalate fns}]⟩"

end Diag.Front
