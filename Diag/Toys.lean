import Diag.Standard
import Diag.Examples

/-! # M2: toy proofs the checker should accept, and forgeries it should reject -/

namespace Diag.Toys
open Diag Params

def acc (p : Proof) (φ : Fm) : Bool := check F p.quote φ.quote

def a : Fm := .eq (.bvar 0) (.lit (.nat 1))
def bF : Fm := .eq (.bvar 0) (.lit (.nat 2))
def nat (n : Nat) : Tm := .lit (.nat n)

-- ∀x. (a → b) → a → b
#eval acc (.allI (.impI (.imp a bF) (.impI a (.impE (.hyp 1) (.hyp 0))))) (.all (.imp (.imp a bF) (.imp a bF)))
-- ∀x. a ∧ b → b ∧ a
#eval acc (.allI (.impI (.and a bF) (.andI (.andR (.hyp 0)) (.andL (.hyp 0)))))
  (.all (.imp (.and a bF) (.and bF a)))
-- classical: ∀x. ¬¬a → a
#eval acc (.allI (.impI (Fm.not (Fm.not a)) (.dne (.hyp 0)))) (.all (.imp (Fm.not (Fm.not a)) a))
-- ∀-elimination: from ∀x. x = x, get 5 = 5
#eval acc (.allE (.allI (.refl (.bvar 0))) (nat 5)) (.eq (nat 5) (nat 5))
-- equality: ∀x ∀y. x = y → y = x  (symmetry via rw)
#eval acc (.allI (.allI (.impI (.eq (.bvar 1) (.bvar 0))
    (.rw (.eq (.bvar 0) (.bvar 2)) (.hyp 0) (.refl (.bvar 1))))))
  (.all (.all (.imp (.eq (.bvar 1) (.bvar 0)) (.eq (.bvar 0) (.bvar 1)))))
-- eval on closed arithmetic: 2 + 3 = 5 and ¬(2 + 3 = 6)
#eval acc (.eval (.op2 .plus (nat 2) (nat 3)) (nat 5)) (.eq (.op2 .plus (nat 2) (nat 3)) (nat 5))
#eval acc (.evalNe (.op2 .plus (nat 2) (nat 3)) (nat 6)) (Fm.not (.eq (.op2 .plus (nat 2) (nat 3)) (nat 6)))
-- eval on a closed run: run(1000, DefectBot, [nil, nil]) = D
#eval acc (.eval (.run (nat 1000) (.lit Examples.defectBot.code) (Tm.list [.lit Val.nil, .lit Val.nil])) (.lit (.sym "D")))
  (.eq (.run (nat 1000) (.lit Examples.defectBot.code) (Tm.list [.lit Val.nil, .lit Val.nil])) (.lit (.sym "D")))
-- symRun on CooperateBot: ∀y ∀κ. bounds → run(T, CooperateBot, [y, κ]) = C
def coopStmt : Fm := .all (.all (.imp (boundFm (.bvar 1) L) (.imp (boundFm (.bvar 0) Kmax)
  (.eq (.run (nat T) (.lit Examples.cooperateBot.code) (Tm.list [.bvar 1, .bvar 0])) (.lit (.sym "C"))))))
#eval acc (.allI (.allI (.impI (boundFm (.bvar 1) L) (.impI (boundFm (.bvar 0) Kmax)
    (.symRun T Examples.cooperateBot.code [(.bvar 1, L), (.bvar 0, Kmax)]
      (.andI (.hyp 1) (.andI (.hyp 0) Standard.topPf))))))) coopStmt

/-! Forgeries: every line should print `false`. -/

-- 1. CertBot's certificate presented as a proof that DefectBot is a member
#eval check F Standard.certBotCert.quote (Standard.member Examples.defectBot.code).quote
-- 2. CertBot's proof steps with DefectBot's code swapped in (symRun gives run = D, not E)
#eval acc (.symRun T Examples.defectBot.code Standard.symArgs (.andI (.hyp 1) (.andI (.hyp 0) Standard.topPf)))
  (.eq (.run (nat T) (.lit Examples.defectBot.code) (Tm.list [.bvar 1, .bvar 0])) Standard.E)
-- 3. symRun without the size-bound hypotheses (claiming them for free)
#eval acc (.symRun T Standard.certBot Standard.symArgs (.andI Standard.topPf (.andI Standard.topPf Standard.topPf)))
  (.eq Standard.R Standard.E)
-- 4. symRun with too little run fuel (CertBot needs more than F to call check with fuel F)
#eval acc (.allI (.allI (.impI (boundFm (.bvar 1) L) (.impI (boundFm (.bvar 0) Kmax)
    (.symRun F Standard.certBot Standard.symArgs (.andI (.hyp 1) (.andI (.hyp 0) Standard.topPf)))))))
  (.all (.all (.imp (boundFm (.bvar 1) L) (.imp (boundFm (.bvar 0) Kmax)
    (.eq (.run (nat F) (.lit Standard.certBot) (Tm.list [.bvar 1, .bvar 0])) Standard.E)))))
-- 5. symRun on loopBot (never terminates): rejected, symbolic evaluation runs out
#eval acc (.symRun T Examples.loopBot.code [] Standard.topPf)
  (.eq (.run (nat T) (.lit Examples.loopBot.code) (Tm.list [])) (.lit Val.nil))
-- 6. evalNe on equal values
#eval acc (.evalNe (nat 5) (nat 5)) (Fm.not (.eq (nat 5) (nat 5)))
-- 7. eval on an open term
#eval acc (.eval (.bvar 0) (.bvar 0)) (.eq (.bvar 0) (.bvar 0))
-- 8. A "reflection" attempt: from check(cert, ⌜φ⌝, F) = true (true by eval) try to get φ: no rule does it.
--    The closest is using the equation itself; it proves only the equation, never φ.
#eval acc (.eval (.op3 .check (.lit Standard.certBotCert.quote) (.lit (Standard.member Standard.certBot).quote) (nat F)) (.lit Val.tru))
  (Standard.member Standard.certBot)

/-! Timing of a full play (CertBot vs CertBot: two complete certificate checks). -/
#eval show IO Unit from do
  let t0 ← IO.monoMsNow
  let r := play T Standard.certBotEntry Standard.certBotEntry
  IO.println s!"{repr r}"
  let t1 ← IO.monoMsNow
  IO.println s!"play CertBot vs CertBot: {t1 - t0} ms (interpreted #eval)"

end Diag.Toys
