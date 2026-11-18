import Diag.KernelChecked

/-!
# Kernel-checked M6 candidates (optional item from FROM_APP #20)

The definitions below were emitted by `lake exe diagcheck --emit-lean` from three
LLM-generated M6 candidate files. The emitted definitions are themselves the data the
kernel checks, so the theorems are about exactly these programs and certificates.
-/

set_option maxRecDepth 1000000

namespace Diag.KernelCheckedM6
open Diag Standard Params TournamentP

unseal Diag.eval Diag.evalList Diag.run Diag.check Diag.evalTm Diag.infer Diag.symEval Diag.symEvalList

/-- Emitted from `m6/candidates/m03_swapped/v2.sexp` (LLM-generated M6 candidate). -/
def swapProg : Program := ⟨[("main", ["opp", "cert"], (.ite (.op .eq [(.op .check [(.var "cert"), (.op .subst [(.lit Kq), (.var "opp")]), (.lit (.nat 262144))]), (.lit Val.fls)]) (.lit (.sym "D")) (.lit (.sym "C"))))]⟩
def swapCode : Val := swapProg.quote
def swapCert : Proof :=
  (.allI (.allI (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 1)) (.lit (.nat 16385))) (.lit Val.tru)) (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 0)) (.lit (.nat 65537))) (.lit Val.tru)) (.impE (.impI (.all (.all (.all (.imp (.eq (.bvar 2) (.bvar 1)) (.imp (.eq (.bvar 0) (.ite (.op2 .eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 2) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.fls)) (.lit (.sym "D")) (.lit (.sym "C")))) (.and (.imp (.eq (.bvar 0) (.lit (.sym "C"))) (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru))) (.imp (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.eq (.bvar 0) (.lit (.sym "C")))))))))) (.impE (.impE (.allE (.allE (.allE (.hyp 0) (.lit Kq)) δ) (.run (.lit (.nat 1048576)) (.lit swapCode) (.op2 .pair (.bvar 1) (.op2 .pair (.bvar 0) (.lit Val.nil))))) (.eval (.lit Kq) δ)) (.symRun 1048576 swapCode [((.bvar 1), 16384), ((.bvar 0), 65536)] (.andI (.hyp 2) (.andI (.hyp 1) (.impI .fls (.hyp 0))))))) (.allI (.allI (.allI (.impI (.eq (.bvar 2) (.bvar 1)) (.impI (.eq (.bvar 0) (.ite (.op2 .eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 2) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.fls)) (.lit (.sym "D")) (.lit (.sym "C")))) (.impE (.impI (.eq (.bvar 0) (.ite (.op2 .eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.fls)) (.lit (.sym "D")) (.lit (.sym "C")))) (.andI (.impI (.eq (.bvar 0) (.lit (.sym "C"))) (.boolCases (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.impI (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.hyp 0)) (.impI (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.fls)) (.exfalso (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.impE (.evalNe (.lit (.sym "D")) (.lit (.sym "C"))) (.rw (.eq (.bvar 0) (.lit (.sym "C"))) (.iteT (.lit (.sym "D")) (.lit (.sym "C")) (.rw (.eq (.op2 .eq (.bvar 0) (.lit Val.fls)) (.lit Val.tru)) (.rw (.eq (.bvar 0) (.op3 .check (.bvar 4) (.op2 .subst (.bvar 2) (.bvar 5)) (.lit (.nat 262144)))) (.hyp 0) (.refl (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))))) (.eval (.op2 .eq (.lit Val.fls) (.lit Val.fls)) (.lit Val.tru)))) (.rw (.eq (.bvar 0) (.lit (.sym "C"))) (.hyp 2) (.hyp 1)))))))) (.impI (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.rw (.eq (.bvar 1) (.bvar 0)) (.iteF (.lit (.sym "D")) (.lit (.sym "C")) (.impI (.eq (.op2 .eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.fls)) (.lit Val.tru)) (.impE (.evalNe (.op2 .eq (.lit Val.tru) (.lit Val.fls)) (.lit Val.tru)) (.rw (.eq (.op2 .eq (.bvar 0) (.lit Val.fls)) (.lit Val.tru)) (.hyp 1) (.hyp 0))))) (.hyp 1))))) (.rw (.eq (.bvar 1) (.ite (.op2 .eq (.op3 .check (.bvar 4) (.op2 .subst (.bvar 0) (.bvar 5)) (.lit (.nat 262144))) (.lit Val.fls)) (.lit (.sym "D")) (.lit (.sym "C")))) (.hyp 1) (.hyp 0)))))))))))))
def swapEntry : Entry := ⟨swapCode, swapCert.quote⟩

/-- Emitted from `m6/candidates/p02_nil_generous/v1.sexp` (LLM-generated M6 candidate). -/
def nilGenProg : Program := ⟨[("main", ["opp", "cert"], (.ite (.op .eq [(.var "cert"), (.lit Val.nil)]) (.lit (.sym "C")) (.ite (.op .check [(.var "cert"), (.op .subst [(.lit KPq), (.var "opp")]), (.lit (.nat 262144))]) (.lit (.sym "C")) (.lit (.sym "D")))))]⟩
def nilGenCode : Val := nilGenProg.quote
def nilGenCert : Proof :=
  (.allI (.allI (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 1)) (.lit (.nat 16385))) (.lit Val.tru)) (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 0)) (.lit (.nat 65537))) (.lit Val.tru)) (.impI (.eq (.op3 .check (.bvar 0) (.op2 .subst δP (.bvar 1)) (.lit (.nat 262144))) (.lit Val.tru)) (.impE (.impI (.eq (.op3 .check (.bvar 0) (.op2 .subst (.lit KPq) (.bvar 1)) (.lit (.nat 262144))) (.lit Val.tru)) (.impE (.impI (.eq (.run (.lit (.nat 1048576)) (.lit nilGenCode) (.op2 .pair (.bvar 1) (.op2 .pair (.bvar 0) (.lit Val.nil)))) (.ite (.op2 .eq (.bvar 0) (.lit Val.nil)) (.lit (.sym "C")) (.ite (.op3 .check (.bvar 0) (.op2 .subst (.lit KPq) (.bvar 1)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D"))))) (.boolCases (.op2 .eq (.bvar 0) (.lit Val.nil)) (.impI (.eq (.op2 .eq (.bvar 0) (.lit Val.nil)) (.lit Val.tru)) (.rw (.eq (.run (.lit (.nat 1048576)) (.lit nilGenCode) (.op2 .pair (.bvar 2) (.op2 .pair (.bvar 1) (.lit Val.nil)))) (.bvar 0)) (.iteT (.lit (.sym "C")) (.ite (.op3 .check (.bvar 0) (.op2 .subst (.lit KPq) (.bvar 1)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D"))) (.hyp 0)) (.hyp 1))) (.impI (.eq (.op2 .eq (.bvar 0) (.lit Val.nil)) (.lit Val.fls)) (.impE (.impI (.eq (.run (.lit (.nat 1048576)) (.lit nilGenCode) (.op2 .pair (.bvar 1) (.op2 .pair (.bvar 0) (.lit Val.nil)))) (.ite (.op3 .check (.bvar 0) (.op2 .subst (.lit KPq) (.bvar 1)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D")))) (.rw (.eq (.run (.lit (.nat 1048576)) (.lit nilGenCode) (.op2 .pair (.bvar 2) (.op2 .pair (.bvar 1) (.lit Val.nil)))) (.bvar 0)) (.iteT (.lit (.sym "C")) (.lit (.sym "D")) (.hyp 3)) (.hyp 0))) (.rw (.eq (.run (.lit (.nat 1048576)) (.lit nilGenCode) (.op2 .pair (.bvar 2) (.op2 .pair (.bvar 1) (.lit Val.nil)))) (.bvar 0)) (.iteF (.lit (.sym "C")) (.ite (.op3 .check (.bvar 0) (.op2 .subst (.lit KPq) (.bvar 1)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D"))) (.impI (.eq (.op2 .eq (.bvar 0) (.lit Val.nil)) (.lit Val.tru)) (.impE (.evalNe (.lit Val.fls) (.lit Val.tru)) (.rw (.eq (.bvar 0) (.lit Val.tru)) (.hyp 1) (.hyp 0))))) (.hyp 1)))))) (.symRun 1048576 nilGenCode [((.bvar 1), 16384), ((.bvar 0), 65536)] (.andI (.hyp 3) (.andI (.hyp 2) (.impI .fls (.hyp 0))))))) (.rw (.eq (.op3 .check (.bvar 1) (.op2 .subst (.bvar 0) (.bvar 2)) (.lit (.nat 262144))) (.lit Val.tru)) (.eval δP (.lit KPq)) (.hyp 0))))))))
def nilGenEntry : Entry := ⟨nilGenCode, nilGenCert.quote⟩

/-- Emitted from `m6/candidates/a1_defect_vs_certbot/v2.sexp` (LLM-generated M6 candidate). -/
def adv1Prog : Program := ⟨[("main", ["opp", "cert"], (.ite (.op .eq [(.var "opp"), (.lit certBot)]) (.lit (.sym "D")) (.ite (.op .check [(.var "cert"), (.op .subst [(.lit Kq), (.var "opp")]), (.lit (.nat 262144))]) (.lit (.sym "C")) (.lit (.sym "D")))))]⟩
def adv1Code : Val := adv1Prog.quote
def adv1Cert : Proof :=
  (.allI (.allI (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 1)) (.lit (.nat 16385))) (.lit Val.tru)) (.impI (.eq (.op2 .lt (.op1 .sz (.bvar 0)) (.lit (.nat 65537))) (.lit Val.tru)) (.impE (.impI (.all (.all (.all (.imp (.eq (.bvar 2) (.bvar 1)) (.imp (.eq (.bvar 0) (.ite (.op3 .check (.bvar 3) (.op2 .subst (.bvar 2) (.bvar 4)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D")))) (.and (.imp (.eq (.bvar 0) (.lit (.sym "C"))) (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru))) (.imp (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.eq (.bvar 0) (.lit (.sym "C")))))))))) (.impE (.impE (.allE (.allE (.allE (.hyp 0) (.lit Kq)) δ) (.run (.lit (.nat 1048576)) (.lit adv1Code) (.op2 .pair (.bvar 1) (.op2 .pair (.bvar 0) (.lit Val.nil))))) (.eval (.lit Kq) δ)) (.symRun 1048576 adv1Code [((.bvar 1), 16384), ((.bvar 0), 65536)] (.andI (.hyp 2) (.andI (.hyp 1) (.impI .fls (.hyp 0))))))) (.allI (.allI (.allI (.impI (.eq (.bvar 2) (.bvar 1)) (.impI (.eq (.bvar 0) (.ite (.op3 .check (.bvar 3) (.op2 .subst (.bvar 2) (.bvar 4)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D")))) (.impE (.impI (.eq (.bvar 0) (.ite (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D")))) (.andI (.impI (.eq (.bvar 0) (.lit (.sym "C"))) (.dne (.impI (.imp (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) .fls) (.impE (.evalNe (.lit (.sym "D")) (.lit (.sym "C"))) (.rw (.eq (.bvar 0) (.lit (.sym "C"))) (.iteF (.lit (.sym "C")) (.lit (.sym "D")) (.hyp 0)) (.rw (.eq (.bvar 0) (.lit (.sym "C"))) (.hyp 2) (.hyp 1))))))) (.impI (.eq (.op3 .check (.bvar 3) (.op2 .subst (.bvar 1) (.bvar 4)) (.lit (.nat 262144))) (.lit Val.tru)) (.rw (.eq (.bvar 1) (.bvar 0)) (.iteT (.lit (.sym "C")) (.lit (.sym "D")) (.hyp 0)) (.hyp 1))))) (.rw (.eq (.bvar 1) (.ite (.op3 .check (.bvar 4) (.op2 .subst (.bvar 0) (.bvar 5)) (.lit (.nat 262144))) (.lit (.sym "C")) (.lit (.sym "D")))) (.hyp 1) (.hyp 0)))))))))))))
def adv1Entry : Entry := ⟨adv1Code, adv1Cert.quote⟩

/-- m03_swapped (swapped branches, uses `bool-cases`) is a certified K-member … -/
theorem swap_certified : Certified swapEntry := by unfold Certified; decide +kernel
theorem swap_ok : swapEntry.ok = true := by decide
/-- … so by Theorem A it cooperates with CertBot. -/
theorem swap_vs_certBot : play T swapEntry Tournament.certBotNew = (.C, .C) :=
  theoremA _ _ swap_ok KernelChecked.certBot_ok swap_certified KernelChecked.certBot_certified

/-- p02_nil_generous is a certified K′-member, and cooperates with CertBot′ by Theorem A′ … -/
theorem nilGen_certified : CertifiedP nilGenEntry := by unfold CertifiedP; decide +kernel
theorem nilGen_vs_certBotP : play T nilGenEntry certBotPE = (.C, .C) := by decide +kernel
/-- … but, being generous rather than cautious, it is exploited by DefectBot (allowed by K′;
Theorem B′ protects only cautious members). -/
theorem nilGen_vs_defectBot : play T nilGenEntry Examples.defectBot = (.C, .D) := by decide +kernel

/-- The adversarial candidate a1 (defects exactly against CertBot) is rejected by the checker. -/
theorem adv1_rejected : check F adv1Cert.quote (member adv1Code).quote = false := by decide +kernel

/-- The emitted certificates have exactly the sizes the M6 runner recorded (m6/REPORT.md). -/
theorem emitted_sizes : (swapCert.quote.sz, nilGenCert.quote.sz, adv1Cert.quote.sz) =
    (25392, 26187, 33285) := by decide +kernel

#print axioms swap_certified
#print axioms swap_vs_certBot
#print axioms nilGen_certified
#print axioms nilGen_vs_defectBot
#print axioms adv1_rejected

end Diag.KernelCheckedM6
