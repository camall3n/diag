import Diag.Val
import Diag.Params

/-!
# The DSL: syntax, encoding as values, and the fueled interpreter

* Programs are lists of named first-order functions; the entry point is `main`.
* Programs travel as `Val`s: `Program.quote` / `Program.decode?`, with
  `Program.decode?_quote : decode? (quote p) = some p`.
* `run fuel code args` is the one interpreter, used both for play and (from M3) in
  the semantics of `S`.

## Fuel (step counting)
Every evaluation step costs 1 and leftover fuel is threaded through, so total work
is bounded by the fuel. Operations whose real cost depends on data size (`eq`,
arithmetic, and later `subst`) are charged the sizes of their arguments, and every
result is capped at `Params.V`. So no program, and no certificate evaluated by the
checker, can do much more real work than its fuel.
-/

namespace Diag
open Params

inductive Op where
  | eq | pair | fst | snd | isPair | isNat | plus | minus | lt
  | check  -- check(p, φ, f): S's checker with fuel f, flat cost f   (M2)
  | subst  -- subst(φ, v): put quoted v into φ's free variable       (M2)
deriving DecidableEq, Repr

namespace Op

def name : Op → String
  | eq => "eq" | pair => "pair" | fst => "fst" | snd => "snd"
  | isPair => "isPair" | isNat => "isNat" | plus => "plus" | minus => "minus"
  | lt => "lt" | check => "check" | subst => "subst"

def ofName? : String → Option Op
  | "eq" => some eq | "pair" => some pair | "fst" => some fst | "snd" => some snd
  | "isPair" => some isPair | "isNat" => some isNat | "plus" => some plus
  | "minus" => some minus | "lt" => some lt | "check" => some check
  | "subst" => some subst | _ => none

theorem ofName?_name (o : Op) : ofName? o.name = some o := by
  cases o <;> rfl

/-- Result of an operation together with its extra cost (on top of the 1-step base cost).
`none` on arity or type errors. -/
def apply : Op → List Val → Option (Val × Nat)
  | eq,     [a, b]                 => some (Val.ofBool (a == b), a.sz + b.sz)
  | pair,   [a, b]                 => some (.pair a b, 0)
  | fst,    [.pair a _]            => some (a, 0)
  | snd,    [.pair _ b]            => some (b, 0)
  | isPair, [v]                    => some (Val.ofBool (v matches .pair _ _), 0)
  | isNat,  [v]                    => some (Val.ofBool (v matches .nat _), 0)
  | plus,   [a@(.nat m), b@(.nat n)] => some (.nat (m + n), a.sz + b.sz)
  | minus,  [a@(.nat m), b@(.nat n)] => some (.nat (m - n), a.sz + b.sz)
  | lt,     [a@(.nat m), b@(.nat n)] => some (Val.ofBool (decide (m < n)), a.sz + b.sz)
  -- SCAFFOLD (M1): replace in M2. `check` and `subst` get their real semantics in M2,
  -- when `run` and `check` become one mutual definition.
  | check,  _                      => none
  -- SCAFFOLD (M1): replace in M2.
  | subst,  _                      => none
  | _,      _                      => none

end Op

inductive Expr where
  | var  : String → Expr
  | lit  : Val → Expr
  | op   : Op → List Expr → Expr
  | ite  : Expr → Expr → Expr → Expr   -- takes `then` iff the condition is `sym "true"`
  | let_ : String → Expr → Expr → Expr
  | call : String → List Expr → Expr
deriving Repr

structure Program where
  /-- name, parameters, body -/
  fns : List (String × List String × Expr)
deriving Repr

def Program.lookup (p : Program) (f : String) : Option (List String × Expr) :=
  p.fns.lookup f

/-! ## Encoding programs as values -/

open Val in
mutual
def Expr.quote : Expr → Val
  | .var x      => ofList [.sym "var", .sym x]
  | .lit v      => ofList [.sym "lit", v]
  | .op o es    => ofList [.sym "op", .sym o.name, Expr.quoteList es]
  | .ite c t e  => ofList [.sym "if", c.quote, t.quote, e.quote]
  | .let_ x e b => ofList [.sym "let", .sym x, e.quote, b.quote]
  | .call f es  => ofList [.sym "call", .sym f, Expr.quoteList es]
def Expr.quoteList : List Expr → Val
  | []      => nil
  | e :: es => .pair e.quote (Expr.quoteList es)
end

mutual
def Expr.decode? : Val → Option Expr
  | .pair (.sym "var") (.pair (.sym x) (.sym "nil")) => some (.var x)
  | .pair (.sym "lit") (.pair v (.sym "nil")) => some (.lit v)
  | .pair (.sym "op") (.pair (.sym o) (.pair es (.sym "nil"))) =>
      match Op.ofName? o, Expr.decodeList? es with
      | some o, some es => some (.op o es)
      | _, _ => none
  | .pair (.sym "if") (.pair c (.pair t (.pair e (.sym "nil")))) =>
      match Expr.decode? c, Expr.decode? t, Expr.decode? e with
      | some c, some t, some e => some (.ite c t e)
      | _, _, _ => none
  | .pair (.sym "let") (.pair (.sym x) (.pair e (.pair b (.sym "nil")))) =>
      match Expr.decode? e, Expr.decode? b with
      | some e, some b => some (.let_ x e b)
      | _, _ => none
  | .pair (.sym "call") (.pair (.sym f) (.pair es (.sym "nil"))) =>
      match Expr.decodeList? es with
      | some es => some (.call f es)
      | none => none
  | _ => none
def Expr.decodeList? : Val → Option (List Expr)
  | .sym "nil" => some []
  | .pair e es =>
      match Expr.decode? e, Expr.decodeList? es with
      | some e, some es => some (e :: es)
      | _, _ => none
  | _ => none
end

def symList? : Val → Option (List String)
  | .sym "nil" => some []
  | .pair (.sym x) xs => (symList? xs).map (x :: ·)
  | _ => none

def Program.quoteFn : String × List String × Expr → Val
  | (f, ps, b) => Val.ofList [.sym f, Val.ofList (ps.map .sym), b.quote]

def Program.quote (p : Program) : Val :=
  Val.ofList (p.fns.map Program.quoteFn)

def Program.decodeFns? : Val → Option (List (String × List String × Expr))
  | .sym "nil" => some []
  | .pair (.pair (.sym f) (.pair ps (.pair b (.sym "nil")))) rest =>
      match symList? ps, Expr.decode? b, Program.decodeFns? rest with
      | some ps, some b, some rest => some ((f, ps, b) :: rest)
      | _, _, _ => none
  | _ => none

def Program.decode? (v : Val) : Option Program :=
  (Program.decodeFns? v).map Program.mk

/-! ### Round trip -/

mutual
theorem Expr.decode?_quote : (e : Expr) → Expr.decode? e.quote = some e
  | .var x => by simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?]
  | .lit v => by simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?]
  | .op o es => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Op.ofName?_name, Expr.decodeList?_quoteList es]
  | .ite c t e => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decode?_quote c,
        Expr.decode?_quote t, Expr.decode?_quote e]
  | .let_ x e b => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decode?_quote e, Expr.decode?_quote b]
  | .call f es => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decodeList?_quoteList es]
theorem Expr.decodeList?_quoteList : (es : List Expr) → Expr.decodeList? (Expr.quoteList es) = some es
  | [] => by simp [Expr.quoteList, Expr.decodeList?, Val.nil]
  | e :: es => by
      simp [Expr.quoteList, Expr.decodeList?, Expr.decode?_quote e, Expr.decodeList?_quoteList es]
end

theorem symList?_ofList (xs : List String) : symList? (Val.ofList (xs.map .sym)) = some xs := by
  induction xs with
  | nil => simp [Val.ofList, Val.nil, symList?]
  | cons x xs ih => simp [Val.ofList, symList?, ih]

theorem Program.decodeFns?_quote (fns : List (String × List String × Expr)) :
    Program.decodeFns? (Val.ofList (fns.map Program.quoteFn)) = some fns := by
  induction fns with
  | nil => simp [Val.ofList, Val.nil, Program.decodeFns?]
  | cons d fns ih =>
    obtain ⟨f, ps, b⟩ := d
    rw [List.map_cons, Val.ofList, Program.quoteFn]
    simp only [Val.ofList, Val.nil, Program.decodeFns?, symList?_ofList, Expr.decode?_quote, ih]

theorem Program.decode?_quote (p : Program) : Program.decode? p.quote = some p := by
  simp [Program.decode?, Program.quote, Program.decodeFns?_quote]

/-! ## The interpreter -/

abbrev Env := List (String × Val)

/- `eval p fuel env e` returns the value and the remaining fuel, which is strictly
less than `fuel` (the `Fin fuel`). -/
mutual
def eval (p : Program) : (fuel : Nat) → Env → Expr → Option (Val × Fin fuel)
  | 0, _, _ => none
  | n+1, env, .var x => (env.lookup x).map fun v => (v, ⟨n, by omega⟩)
  | n+1, _, .lit v => some (v, ⟨n, by omega⟩)
  | n+1, env, .op o es =>
    match evalList p n env es with
    | none => none
    | some (vs, m) =>
      match o.apply vs with
      | none => none
      | some (v, c) =>
        if h : c ≤ m.val ∧ v.sz ≤ V then some (v, ⟨m.val - c, by omega⟩) else none
  | n+1, env, .ite c t e =>
    match eval p n env c with
    | none => none
    | some (b, m) =>
      match eval p m.val env (if b = Val.tru then t else e) with
      | none => none
      | some (v, r) => some (v, ⟨r.val, by omega⟩)
  | n+1, env, .let_ x e b =>
    match eval p n env e with
    | none => none
    | some (v, m) =>
      match eval p m.val ((x, v) :: env) b with
      | none => none
      | some (w, r) => some (w, ⟨r.val, by omega⟩)
  | n+1, env, .call f es =>
    match evalList p n env es with
    | none => none
    | some (vs, m) =>
      match p.lookup f with
      | none => none
      | some (ps, body) =>
        if ps.length = vs.length then
          match eval p m.val (ps.zip vs) body with
          | none => none
          | some (w, r) => some (w, ⟨r.val, by omega⟩)
        else none
termination_by fuel _ _ => fuel
/-- Evaluates arguments left to right; costs 1 per argument. -/
def evalList (p : Program) : (fuel : Nat) → Env → List Expr → Option (List Val × Fin (fuel + 1))
  | n, _, [] => some ([], ⟨n, by omega⟩)
  | 0, _, _ :: _ => none
  | n+1, env, e :: es =>
    match eval p n env e with
    | none => none
    | some (v, m) =>
      match evalList p m.val env es with
      | none => none
      | some (vs, r) => some (v :: vs, ⟨r.val, by omega⟩)
termination_by fuel _ _ => fuel
end

/-- **The** interpreter. Decoding the code costs `code.sz` fuel up front; then `main`
is called on `args`. `none` means: out of fuel, malformed code, or a runtime error. -/
def run (fuel : Nat) (code : Val) (args : List Val) : Option Val :=
  if code.sz ≤ fuel then
    match Program.decode? code with
    | none => none
    | some p =>
      match p.lookup "main" with
      | none => none
      | some (ps, body) =>
        if ps.length = args.length then
          (eval p (fuel - code.sz) (ps.zip args) body).map (·.1)
        else none
  else none

end Diag
