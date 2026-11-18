import Diag.Toys

/-! # M8b-1: tests of the induction rules (rule shapes and forgeries) -/

namespace Diag.InductionToys
open Diag Toys

def M : Fm := .eq (.bvar 0) (.bvar 0)     -- M(x) :≡ x = x, hole at variable 0

def valBase : Proof := .allI (.impI (.eq (.op1 .isPair (.bvar 0)) (.lit Val.fls)) (.refl (.bvar 0)))
def valStep : Proof :=
  .allI (.impI (.eq (.op1 .isPair (.bvar 0)) (.lit Val.tru))
    (.impI (M.instKeep (.op1 .fst (.bvar 0))) (.impI (M.instKeep (.op1 .snd (.bvar 0))) (.refl (.bvar 0)))))
def natBase : Proof := .refl (.lit (.nat 0))
def natStep : Proof :=
  .allI (.impI Fm.isNatFm (.impI M (.refl (.op2 .plus (.bvar 0) (.lit (.nat 1))))))

-- accepted: ∀x. x = x by structural induction, and ∀x. isNat(x) = true → x = x by induction on ℕ
#eval acc (.valInd M valBase valStep) (.all M)
#eval acc (.natInd M natBase natStep) (.all (.imp Fm.isNatFm M))
-- forgeries (should print false): the step proof given as the base; conclusions claimed without the
-- isNat guard; a premise for a different motive
#eval acc (.valInd M valStep valStep) (.all M)
#eval acc (.natInd M natBase natStep) (.all M)
#eval acc (.valInd (.eq (.bvar 0) (.lit (.nat 0))) valBase valStep) (.all (.eq (.bvar 0) (.lit (.nat 0))))

end Diag.InductionToys
