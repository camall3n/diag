/-!
# Primitive operations

Shared by the DSL (`Expr.op`) and by S's terms (`Tm.op1/op2/op3`), so that `check`
and `subst` in a formula are exactly the DSL primitives.
-/

namespace Diag

inductive Op where
  | eq | pair | fst | snd | isPair | isNat | plus | minus | lt | sz
  | check  -- check(p, φ, f): S's checker with fuel f; flat cost f
  | subst  -- subst(φ, v): instantiate the formula φ's loose variable 0 with the literal v
deriving DecidableEq, Repr

namespace Op

def name : Op → String
  | eq => "eq" | pair => "pair" | fst => "fst" | snd => "snd"
  | isPair => "isPair" | isNat => "isNat" | plus => "plus" | minus => "minus"
  | lt => "lt" | sz => "sz" | check => "check" | subst => "subst"

def ofName? : String → Option Op
  | "eq" => some eq | "pair" => some pair | "fst" => some fst | "snd" => some snd
  | "isPair" => some isPair | "isNat" => some isNat | "plus" => some plus
  | "minus" => some minus | "lt" => some lt | "sz" => some sz | "check" => some check
  | "subst" => some subst | _ => none

theorem ofName?_name (o : Op) : ofName? o.name = some o := by
  cases o <;> rfl

/-- The number of arguments. Other arities are legal in the DSL and give a default result. -/
def arity : Op → Nat
  | fst | snd | isPair | isNat | sz => 1
  | check => 3
  | _ => 2

end Op
end Diag
