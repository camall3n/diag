import Diag.Sound.Infer
import Diag.Sound.SizeBound

/-! # Axiom audit for M3 (honesty rule: only Lean's standard axioms) -/

#print axioms Diag.evalTm_sound
#print axioms Diag.symEval_sound
#print axioms Diag.symRunCore_sound
#print axioms Diag.infer_sound
#print axioms Diag.check_sound
#print axioms Diag.check_member_sound
#print axioms Diag.eval_sz_le
