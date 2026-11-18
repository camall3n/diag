import Diag.Exclusivity
import Diag.TournamentP

/-!
# Kernel-checked certification and game outcomes (FROM_APP #19, audit item 2)

Until now, "CertBot's certificate checks" and the tournament outcomes were established by
`#eval`, which trusts the Lean compiler. Here they are **theorems checked by Lean's kernel**:
`decide +kernel` makes the kernel evaluate the very same `run`/`check` definitions. No
`#eval`, no `native_decide` and no compiled code are involved.

`run`, `check` and the rest of the mutual block are defined by well-founded recursion,
which Lean marks irreducible by default. `unseal` lifts that for these proofs only. It
changes no definition, adds no axiom, and the kernel still checks every step. Lean 4.36's
kernel reduces the well-founded recursion directly, so no structurally recursive "twin" is
needed.

Measured (Apple Silicon): CertBot's certificate in about 0.6 s and 500 MB. CertBot vs CertBot
(two full certificate checks inside the interpreter) plus the 11×11 matrix in about 4.2 s
and 830 MB.
-/

set_option maxRecDepth 1000000

namespace Diag.KernelChecked
open Diag Standard Params Tournament TournamentP

-- For the rest of this file only, the kernel may unfold the well-founded definitions.
unseal Diag.eval Diag.evalList Diag.run Diag.check Diag.evalTm Diag.infer Diag.symEval Diag.symEvalList

/-- CertBot's generated certificate checks: `Certified` for CertBot, kernel-checked. -/
theorem certBot_certified : Certified certBotNew := by
  unfold Certified; decide +kernel

/-- The M2 hand-written certificate checks too. -/
theorem certBotOld_certified : Certified certBotOld := by
  unfold Certified; decide +kernel

theorem certBot_ok : certBotNew.ok = true := by decide

/-- **CertBot vs CertBot = (C, C)**, from Theorem A plus the kernel-checked certification. -/
theorem certBot_vs_certBot : play T certBotNew certBotNew = (.C, .C) :=
  theoremA _ _ certBot_ok certBot_ok certBot_certified certBot_certified

/-- The same outcome by direct kernel evaluation of the game (both certificate checks are run
inside the interpreter). -/
theorem certBot_vs_certBot_eval : play T certBotNew certBotNew = (.C, .C) := by decide +kernel

/-- Exclusivity's hypothesis: CooperateBot's K′ certificate checks. -/
theorem coop_hco : check F (coopCertP coopCode).quote (memberP coopCode).quote = true := by
  decide +kernel

/-- **Exclusivity, unconditional:** no code satisfies both K and K′. -/
theorem exclusivity_unconditional (c : Val) (ρ : Nat → Val) :
    ¬ ((member c).denote ρ ∧ (memberP c).denote ρ) :=
  exclusivity (coopCertP coopCode).quote (by decide) coop_hco c ρ

/-- The M5 tournament matrix (11 entries, incl. forged/stolen certificates), kernel-checked. -/
theorem m5_matrix : (entries.map fun (_, a) => entries.map fun (_, b) => move T a b) =
  [[.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .C, .C, .C, .C, .C, .C],
   [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D],
   [.C, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.D, .C, .C, .C, .C, .D, .D, .D, .D, .D, .D],
   [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D],
   [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D]] := by decide +kernel

/-- The mixed-standard tournament (K and K′ entries), kernel-checked, including
CertBot vs CertBot′ = (D, D) (the bridging question) and CertBot′ vs CooperateBot = (C, C). -/
theorem mixed_matrix : (entriesP.map fun (_, a) => entriesP.map fun (_, b) => move T a b) =
  [[.C, .C, .C, .D, .D, .D, .D],
   [.C, .C, .C, .D, .D, .D, .D],
   [.C, .C, .C, .D, .D, .D, .D],
   [.D, .D, .D, .C, .C, .D, .D],
   [.C, .C, .C, .C, .C, .C, .C],
   [.D, .D, .D, .D, .D, .D, .D],
   [.D, .D, .D, .D, .D, .D, .D]] := by decide +kernel

#print axioms Diag.KernelChecked.certBot_certified
#print axioms Diag.KernelChecked.certBot_vs_certBot
#print axioms Diag.KernelChecked.certBot_vs_certBot_eval
#print axioms Diag.KernelChecked.coop_hco
#print axioms Diag.KernelChecked.exclusivity_unconditional
#print axioms Diag.KernelChecked.m5_matrix
#print axioms Diag.KernelChecked.mixed_matrix

end Diag.KernelChecked
