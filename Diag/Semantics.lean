import Diag.Check

/-!
# Semantics of S (definitions; the theorems are M3)

Terms denote values *totally*, under an assignment `ρ` of values to variables. The
function symbols are interpreted by **the same Lean functions** used at play time:
`check` by `Diag.check`, `run` by `Diag.run` (with `none ↦ ⊥`), and `subst` and the
data operations by `Op.applyPure`. There's no fuel at this level: every function called
is already total.
-/

namespace Diag

/-- Extend an assignment with a new variable 0 (entering a `∀`). -/
def Asg.cons (v : Val) (ρ : Nat → Val) : Nat → Val
  | 0 => v
  | i + 1 => ρ i

def Tm.denote (ρ : Nat → Val) : Tm → Val
  | .bvar i => ρ i
  | .lit v => v
  | .op1 o a => (o.applyPure [a.denote ρ]).1
  | .op2 o a b => (o.applyPure [a.denote ρ, b.denote ρ]).1
  | .op3 o a b c =>
    match o, c.denote ρ with
    | .check, .nat f => Val.ofBool (Diag.check f (a.denote ρ) (b.denote ρ))
    | _, vc => (o.applyPure [a.denote ρ, b.denote ρ, vc]).1
  | .ite c t e => if c.denote ρ = Val.tru then t.denote ρ else e.denote ρ
  | .run f c a =>
    match f.denote ρ, (a.denote ρ).toList? with
    | .nat g, some as => (Diag.run g (c.denote ρ) as).getD Val.bot
    | _, _ => Val.bot

def Fm.denote (ρ : Nat → Val) : Fm → Prop
  | .eq a b => a.denote ρ = b.denote ρ
  | .fls => False
  | .imp a b => a.denote ρ → b.denote ρ
  | .and a b => a.denote ρ ∧ b.denote ρ
  | .all a => ∀ v : Val, a.denote (Asg.cons v ρ)

end Diag
