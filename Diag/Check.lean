import Diag.Lang

/-!
# The interpreter and S's checker: one mutual definition

`run` (the DSL interpreter) and `check` (S's proof checker) call each other:
* programs call `check` through the primitive `check(p, φ, f)`;
* the checker evaluates closed terms (rule `eval`), and those may contain `run` and `check`.

So they are defined together, by well-founded recursion on a single fuel. Every call
into another function of the block gets strictly less fuel, and leftover fuel is
threaded through, so `run fuel …` and `check fuel …` do at most about `fuel` steps of
work, even on adversarial code and certificates.

There is exactly **one** `run` and **one** `check`. They are used at play time
(`Diag/Game.lean`) and they interpret the function symbols of S in the semantics (M3).

The symbolic evaluator `symEval` (for the rule `symRun`) comes first. It doesn't call
anything in the mutual block.
-/

namespace Diag
open Params

/-! ## Symbolic evaluation (for `Proof.symRun`)

A symbolic value is a term together with an upper bound on the size of the value it
denotes. `symEval` runs the DSL on symbolic values: calls are inlined, `let` is
substituted, an `ite` on a literal condition picks its branch, an `ite` on a symbolic
condition becomes a term `ite`, and pure operations on literal arguments are computed.
Alongside the result it computes an upper bound on the **runtime** fuel the real `eval`
uses. The rule only succeeds if that bound fits the run's fuel and every intermediate
size bound is ≤ `V`, so the real run can't fail and returns exactly the result term's
value. (That is the `symEval` correctness lemma, M3.) -/

structure SV where
  t : Tm
  b : Nat   -- upper bound on the size of the denoted value
deriving Repr

abbrev SEnv := List (String × SV)

def SV.nil : SV := ⟨.lit Val.nil, Val.nil.sz⟩

def SV.lit? : SV → Option Val
  | ⟨.lit v, _⟩ => some v
  | _ => none

/-- Upper bound on `(substV φ v).sz` for every `v` with `v.sz ≤ bv`. -/
def substBound (φ : Val) (bv : Nat) : Nat :=
  match Fm.decode? φ with
  | some f => (f.inst (.lit Val.nil)).quote.sz + f.occ 0 * bv
  | none => Val.nil.sz

/-- Upper bound on the size of an operation's result, given bounds on its arguments.
`none` means the rule gives up. -/
def opBound : Op → List SV → Option Nat
  | .eq, [_, _] | .lt, [_, _] | .isPair, [_] | .isNat, [_] | .check, [_, _, _] => some 6
  | .pair, [a, b] => some (a.b + b.b + 1)
  | .fst, [a] | .snd, [a] => some (max a.b 4)
  | .plus, [a, b] => some (max a.b b.b + 1)
  | .minus, [a, _] => some (max a.b 1)
  | .sz, [a] => some (a.b.log2 + 1)
  | .subst, [⟨.lit φ, _⟩, v] => some (substBound φ v.b)
  | _, _ => none

/-- Upper bound on an operation's extra cost (on top of the 1-step base cost). -/
def opCost : Op → List SV → Option Nat
  | .eq, [a, b] | .plus, [a, b] | .minus, [a, b] | .lt, [a, b] | .subst, [a, b] =>
      some (a.b + b.b)
  | .check, [_, _, ⟨.lit (.nat f), _⟩] => some f
  | .check, [_, _, ⟨.lit _, _⟩] => some 0
  | .check, _ => none
  | _, _ => some 0

def opTm : Op → List Tm → Option Tm
  | o, [a] => some (.op1 o a)
  | o, [a, b] => some (.op2 o a b)
  | o, [a, b, c] => some (.op3 o a b c)
  | _, _ => none

/-- A symbolic operation application: `((result, extra runtime cost), checker work)`.
The checker's own work is the operation's cost when it computes a literal result.
Otherwise it's the work of `opBound` (decoding a literal formula for `subst`). -/
def symOp (o : Op) (args : List SV) : Option ((SV × Nat) × Nat) :=
  match (if o = .check then none else args.mapM SV.lit?) with
  | some vs =>
    -- all arguments are literals and the operation is pure: compute it
    let (v, c) := o.applyPure vs
    if v.sz ≤ V then some ((⟨.lit v, v.sz⟩, c), c) else none
  | none =>
    if args.length = o.arity then
      match opTm o (args.map SV.t), opBound o args, opCost o args with
      | some t, some b, some c =>
        let work := match o, args with
          | .subst, [⟨.lit φ, _⟩, _] => φ.sz
          | _, _ => 0
        if b ≤ V then some ((⟨t, b⟩, c), work) else none
      | _, _, _ => none
    else none

/- `symEval p fuel σ e = some ((r, cost), rest)`: `r` is the symbolic result, `cost` an
upper bound on the runtime fuel used by `eval`, and `rest` the checker's own
leftover fuel. -/
mutual
def symEval (p : Program) : (fuel : Nat) → SEnv → Expr → Option ((SV × Nat) × Fin fuel)
  | 0, _, _ => none
  | n+1, σ, .var x => some (((σ.lookup x).getD SV.nil, 1), ⟨n, by omega⟩)
  | n+1, _, .lit v => some ((⟨.lit v, v.sz⟩, 1), ⟨n, by omega⟩)
  | n+1, σ, .op o es =>
    match symEvalList p n σ es with
    | none => none
    | some ((args, c), m) =>
      match symOp o args with
      | none => none
      | some ((r, c'), w) =>
        if h : w ≤ m.val then some ((r, 1 + c + c'), ⟨m.val - w, by omega⟩) else none
  | n+1, σ, .ite c t e =>
    match symEval p n σ c with
    | none => none
    | some ((cv, cc), m) =>
      match cv.t with
      | .lit v =>
        match symEval p m.val σ (if v = Val.tru then t else e) with
        | some ((r, rc), k) => some ((r, 1 + cc + rc), ⟨k.val, by omega⟩)
        | none => none
      | ct =>
        match symEval p m.val σ t with
        | none => none
        | some ((tv, tc), k) =>
          match symEval p k.val σ e with
          | none => none
          | some ((ev, ec), j) =>
            some ((⟨.ite ct tv.t ev.t, max tv.b ev.b⟩, 1 + cc + max tc ec), ⟨j.val, by omega⟩)
  | n+1, σ, .let_ x e b =>
    match symEval p n σ e with
    | none => none
    | some ((ve, ce), m) =>
      match symEval p m.val ((x, ve) :: σ) b with
      | none => none
      | some ((vb, cb), k) => some ((vb, 1 + ce + cb), ⟨k.val, by omega⟩)
  | n+1, σ, .call f es =>
    match symEvalList p n σ es with
    | none => none
    | some ((args, c), m) =>
      match p.lookup f with
      | none => some ((SV.nil, 1 + c), ⟨m.val, by omega⟩)
      | some (ps, body) =>
        match symEval p m.val (ps.zip args) body with
        | none => none
        | some ((r, rc), k) => some ((r, 1 + c + rc), ⟨k.val, by omega⟩)
termination_by fuel _ _ => fuel
def symEvalList (p : Program) : (fuel : Nat) → SEnv → List Expr →
    Option ((List SV × Nat) × Fin (fuel + 1))
  | n, _, [] => some (([], 0), ⟨n, by omega⟩)
  | 0, _, _ :: _ => none
  | n+1, σ, e :: es =>
    match symEval p n σ e with
    | none => none
    | some ((v, c), m) =>
      match symEvalList p m.val σ es with
      | none => none
      | some ((vs, cs), k) => some ((v :: vs, 1 + c + cs), ⟨k.val, by omega⟩)
termination_by fuel _ _ => fuel
end

/-- Symbolic `run f code args`. It succeeds only if the decode charge plus the runtime
cost bound fit in `f`. -/
def symRunCore (fuel : Nat) (f : Nat) (code : Val) (args : List SV) :
    Option (Tm × Fin (fuel + 1)) :=
  if h : code.sz ≤ fuel then
    match Program.decode? code with
    | none => none
    | some p =>
      match p.lookup "main" with
      | none => none
      | some (ps, body) =>
        if ps.length = args.length then
          match symEval p (fuel - code.sz) (ps.zip args) body with
          | some ((r, c), k) => if code.sz + c ≤ f then some (r.t, ⟨k.val, by omega⟩) else none
          | none => none
        else none
  else none

/-- Pure operation with its cost charged and the size cap enforced. -/
def spendOp {n : Nat} (o : Op) (vs : List Val) (m : Fin n) : Option (Val × Fin n) :=
  let (v, c) := o.applyPure vs
  if h : c ≤ m.val ∧ v.sz ≤ V then some (v, ⟨m.val - c, by omega⟩) else none

/-! ## The mutual block -/

abbrev Env := List (String × Val)

mutual

/-- DSL expression evaluation. It returns the value and the leftover fuel, which is
strictly less than `fuel`. It fails only by running out of fuel or exceeding the cap `V`. -/
def eval (p : Program) : (fuel : Nat) → Env → Expr → Option (Val × Fin fuel)
  | 0, _, _ => none
  | n+1, env, .var x => some ((env.lookup x).getD Val.nil, ⟨n, by omega⟩)
  | n+1, _, .lit v => some (v, ⟨n, by omega⟩)
  | n+1, env, .op o es =>
    match evalList p n env es with
    | none => none
    | some (vs, m) =>
      match o, vs with
      | .check, [pv, φv, .nat f] =>
        -- flat cost f: fails unless f steps remain, then returns exactly `check f pv φv`
        if h : f ≤ m.val then some (Val.ofBool (check f pv φv), ⟨m.val - f, by omega⟩)
        else none
      | _, _ => spendOp o vs m
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
      | none => some (Val.nil, ⟨m.val, by omega⟩)
      | some (ps, body) =>
        match eval p m.val (ps.zip vs) body with
        | none => none
        | some (w, r) => some (w, ⟨r.val, by omega⟩)
termination_by fuel _ _ => fuel

/-- Evaluates arguments left to right, costing 1 per argument. -/
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

/-- **The** interpreter. Decoding the code costs `code.sz` fuel up front, and then `main`
is called on `args`. `none` means: out of fuel, over the size cap, malformed code, no
`main`, or the wrong number of arguments. -/
def run (fuel : Nat) (code : Val) (args : List Val) : Option Val :=
  if _h : code.sz ≤ fuel then
    match Program.decode? code with
    | none => none
    | some p =>
      match p.lookup "main" with
      | none => none
      | some (ps, body) =>
        if ps.length = args.length then
          match eval p (fuel - code.sz) (ps.zip args) body with
          | some (v, _) => some v
          | none => none
        else none
  else none
termination_by fuel
decreasing_by have := Val.sz_pos code; omega

/-- **The** checker of S: does the certificate `p` decode to a proof whose conclusion
(in the empty context) is the formula that `φ` decodes to? Decoding is charged
`p.sz + φ.sz`, and proof checking gets the rest of the fuel. -/
def check (fuel : Nat) (p φ : Val) : Bool :=
  if _h : p.sz + φ.sz ≤ fuel then
    match Proof.decode? p, Fm.decode? φ with
    | some pr, some f =>
      match infer (fuel - (p.sz + φ.sz)) [] pr with
      | some (g, _) => decide (g = f)
      | none => false
    | _, _ => false
  else false
termination_by fuel
decreasing_by have := Val.sz_pos p; omega

/-- Evaluation of a closed term, which is the computational content of the rule `eval`.
`run k …` and `check k …` are charged a flat `k`. -/
def evalTm : (fuel : Nat) → Tm → Option (Val × Fin fuel)
  | 0, _ => none
  | _+1, .bvar _ => none
  | n+1, .lit v => some (v, ⟨n, by omega⟩)
  | n+1, .op1 o a =>
    match evalTm n a with
    | none => none
    | some (va, m) =>
      match spendOp o [va] m with
      | some (v, k) => some (v, ⟨k.val, by omega⟩)
      | none => none
  | n+1, .op2 o a b =>
    match evalTm n a with
    | none => none
    | some (va, m) =>
      match evalTm m.val b with
      | none => none
      | some (vb, k) =>
        match spendOp o [va, vb] k with
        | some (v, j) => some (v, ⟨j.val, by omega⟩)
        | none => none
  | n+1, .op3 o a b c =>
    match evalTm n a with
    | none => none
    | some (va, m) =>
      match evalTm m.val b with
      | none => none
      | some (vb, k) =>
        match evalTm k.val c with
        | none => none
        | some (vc, j) =>
          match o, vc with
          | .check, .nat f =>
            if h : f ≤ j.val then some (Val.ofBool (check f va vb), ⟨j.val - f, by omega⟩)
            else none
          | _, _ =>
            match spendOp o [va, vb, vc] j with
            | some (v, i) => some (v, ⟨i.val, by omega⟩)
            | none => none
  | n+1, .ite c t e =>
    match evalTm n c with
    | none => none
    | some (vc, m) =>
      match evalTm m.val (if vc = Val.tru then t else e) with
      | some (v, k) => some (v, ⟨k.val, by omega⟩)
      | none => none
  | n+1, .run f c a =>
    match evalTm n f with
    | none => none
    | some (vf, m) =>
      match evalTm m.val c with
      | none => none
      | some (vc, k) =>
        match evalTm k.val a with
        | none => none
        | some (va, j) =>
          match vf, va.toList? with
          | .nat g, some as =>
            if h : g ≤ j.val then
              some ((run g vc as).getD Val.bot, ⟨j.val - g, by omega⟩)
            else none
          | _, _ => some (Val.bot, ⟨j.val, by omega⟩)
termination_by fuel _ => fuel

/-- Infers the conclusion of a proof in context `Γ` (hypothesis 0 is the most recent).

**No reflection rule (the Löb trap).** No rule turns `check(p, ⌜φ⌝, f) = true` into `φ`.
The rule `eval` may prove the *equation* `check(p, ⌜φ⌝, f) = true`, which is just a true
fact about the Lean function `check`. If S could also conclude φ from it, then by Löb's
theorem S would prove `K(DefectBot)`, and S would be unsound. Soundness of S is proved
one level up, in Lean (M3), and never inside S. -/
def infer : (fuel : Nat) → List Fm → Proof → Option (Fm × Fin fuel)
  | 0, _, _ => none
  | n+1, Γ, .hyp i => (Γ[i]?).map fun φ => (φ, ⟨n, by omega⟩)
  | n+1, Γ, .impI a q =>
    match infer n (a :: Γ) q with
    | some (b, m) => some (.imp a b, ⟨m.val, by omega⟩)
    | none => none
  | n+1, Γ, .impE q r =>
    match infer n Γ q with
    | some (.imp a b, m) =>
      match infer m.val Γ r with
      | some (a', k) =>
        if h : a.size ≤ k.val ∧ a' = a then some (b, ⟨k.val - a.size, by omega⟩) else none
      | none => none
    | _ => none
  | n+1, Γ, .andI q r =>
    match infer n Γ q with
    | none => none
    | some (a, m) =>
      match infer m.val Γ r with
      | some (b, k) => some (.and a b, ⟨k.val, by omega⟩)
      | none => none
  | n+1, Γ, .andL q =>
    match infer n Γ q with
    | some (.and a _, m) => some (a, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, Γ, .andR q =>
    match infer n Γ q with
    | some (.and _ b, m) => some (b, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, Γ, .exfalso φ q =>
    match infer n Γ q with
    | some (.fls, m) => some (φ, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, Γ, .dne q =>
    match infer n Γ q with
    | some (.imp (.imp φ .fls) .fls, m) => some (φ, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, Γ, .allI q =>
    -- the hypotheses don't mention the fresh variable 0: shift them past it
    if h : (Γ.map Fm.size).sum ≤ n then
      match infer (n - (Γ.map Fm.size).sum) (Γ.map (Fm.shift 1 0)) q with
      | some (φ, m) => some (.all φ, ⟨m.val, by omega⟩)
      | none => none
    else none
  | n+1, Γ, .allE q t =>
    match infer n Γ q with
    | some (.all φ, m) =>
      if h : φ.size + 1 ≤ m.val then some (φ.inst t, ⟨m.val - (φ.size + 1), by omega⟩)
      else none
    | _ => none
  | n+1, _, .refl t => some (.eq t t, ⟨n, by omega⟩)
  | n+1, Γ, .rw M q r =>
    match infer n Γ q with
    | some (.eq t u, m) =>
      match infer m.val Γ r with
      | some (ψ, k) =>
        if h : 2 * M.size + ψ.size + 1 ≤ k.val ∧ M.inst t = ψ then
          some (M.inst u, ⟨k.val - (2 * M.size + ψ.size + 1), by omega⟩)
        else none
      | none => none
    | _ => none
  | n+1, Γ, .iteT t e q =>
    match infer n Γ q with
    | some (.eq c (.lit (.sym "true")), m) => some (.eq (.ite c t e) t, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, Γ, .iteF t e q =>
    match infer n Γ q with
    | some (.imp (.eq c (.lit (.sym "true"))) .fls, m) =>
      some (.eq (.ite c t e) e, ⟨m.val, by omega⟩)
    | _ => none
  | n+1, _, .eval t u =>
    if h : t.size + u.size ≤ n ∧ t.closedAt 0 = true ∧ u.closedAt 0 = true then
      match evalTm (n - (t.size + u.size)) t with
      | none => none
      | some (v, m) =>
        match evalTm m.val u with
        | none => none
        | some (w, k) =>
          if h2 : v.sz + w.sz ≤ k.val ∧ v = w then
            some (.eq t u, ⟨k.val - (v.sz + w.sz), by omega⟩)
          else none
    else none
  | n+1, _, .evalNe t u =>
    if h : t.size + u.size ≤ n ∧ t.closedAt 0 = true ∧ u.closedAt 0 = true then
      match evalTm (n - (t.size + u.size)) t with
      | none => none
      | some (v, m) =>
        match evalTm m.val u with
        | none => none
        | some (w, k) =>
          if h2 : v.sz + w.sz ≤ k.val ∧ v ≠ w then
            some (Fm.not (.eq t u), ⟨k.val - (v.sz + w.sz), by omega⟩)
          else none
    else none
  | n+1, Γ, .symRun f code args q =>
    match infer n Γ q with
    | none => none
    | some (φ, m) =>
      if h : (boundsFm args).size + φ.size ≤ m.val ∧ φ = boundsFm args then
        match symRunCore (m.val - ((boundsFm args).size + φ.size)) f code
            (args.map fun (t, B) => ⟨t, B⟩) with
        | some (e, k) =>
          some (.eq (.run (.lit (.nat f)) (.lit code) (Tm.list (args.map Prod.fst))) e,
            ⟨k.val, by omega⟩)
        | none => none
      else none
termination_by fuel _ _ => fuel

end

end Diag
