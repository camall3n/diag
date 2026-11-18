import Diag.Theorems
import Diag.StandardP

/-! # Theorems for the one-way standard K′: A′, B′ (semantic and certified) -/

namespace Diag
open Standard Params

/-- **What K′ says.** If an opponent within the caps has a certificate that checks as a
proof of K′, then `c` plays C against it. -/
theorem memberP_denote (c : Val) (ρ : Nat → Val) :
    (memberP c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
      check F κ (memberP y).quote = true → (run T c [y, κ]).getD Val.bot = C := by
  have hd := diagP_eval
  show (KP.inst (.lit c)).denote ρ ↔ _
  rw [Fm.denote_inst, KP, Fm.denote_inst]
  generalize hq : DfmP.quote = q at hd
  simp only [DfmP, Fm.denote, boundFm_denote]
  apply forall_congr'; intro y
  apply forall_congr'; intro κ
  simp only [Tm.denote, b, natT, truT, Asg.cons, Tm.list, Op.applyPure, Val.toList?,
    Option.map, Val.nil]
  rw [hd, subst_KP, Val.ofBool_eq_tru]

/-- **What KC says** (cautiousness, certified). -/
theorem memberC_denote (c : Val) (ρ : Nat → Val) :
    (memberC c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
      ((run T c [y, κ]).getD Val.bot = C ↔ check F κ (memberP y).quote = true) := by
  show (DC.inst (.lit c)).denote ρ ↔ _
  rw [Fm.denote_inst]
  simp only [DC, Fm.denote, Fm.denote_iff, boundFm_denote]
  apply forall_congr'; intro y
  apply forall_congr'; intro κ
  simp only [Tm.denote, b, natT, truT, chkAt, Asg.cons, Tm.list, Op.applyPure, Val.toList?,
    Option.map, Val.nil, KPq]
  rw [subst_KP, Val.ofBool_eq_tru]

def CertifiedP (e : Entry) : Prop := check F e.cert (memberP e.code).quote = true

theorem memberP_of_check {c κ : Val} (h : check F κ (memberP c).quote = true) :
    ∀ y κ' : Val, y.sz ≤ L → κ'.sz ≤ Kmax →
      check F κ' (memberP y).quote = true → (run T c [y, κ']).getD Val.bot = C :=
  (memberP_denote c (fun _ => Val.nil)).mp (check_sound F κ _ h (fun _ => Val.nil))

/-- **Theorem A′.** Two certified K′-members within the caps play (C, C). -/
theorem theoremA' (a b : Entry) (ha : a.ok = true) (hb : b.ok = true)
    (hca : CertifiedP a) (hcb : CertifiedP b) : play T a b = (.C, .C) := by
  obtain ⟨ha1, ha2⟩ := (Entry.ok_iff a).mp ha
  obtain ⟨hb1, hb2⟩ := (Entry.ok_iff b).mp hb
  have m1 : move T a b = .C :=
    (move_eq_C a b).mpr ⟨ha, hb, memberP_of_check hca b.code b.cert hb1 hb2 hcb⟩
  have m2 : move T b a = .C :=
    (move_eq_C b a).mpr ⟨hb, ha, memberP_of_check hcb a.code a.cert ha1 ha2 hca⟩
  simp [play, m1, m2]

/-- `c` cooperates only with opponents whose K′-certificate checks. -/
def Cautious (c : Val) : Prop := ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
  (run T c [y, κ]).getD Val.bot = C → check F κ (memberP y).quote = true

/-- **Theorem B′ (semantic).** A cautious, certified K′-member can't be exploited. -/
theorem theoremB'_sem (a b : Entry) (hca : CertifiedP a) (hc : Cautious a.code)
    (h : (play T a b).1 = .C) : (play T a b).2 = .C := by
  obtain ⟨ha, hb, hrun⟩ := (move_eq_C a b).mp h
  obtain ⟨ha1, ha2⟩ := (Entry.ok_iff a).mp ha
  obtain ⟨hb1, hb2⟩ := (Entry.ok_iff b).mp hb
  have hcb : CertifiedP b := hc b.code b.cert hb1 hb2 hrun
  exact (move_eq_C b a).mpr ⟨hb, ha, memberP_of_check hcb a.code a.cert ha1 ha2 hca⟩

/-- **Theorem B′ (certified).** Cautiousness is itself certified, by a KC-certificate κc
that is checked offline (the entry still carries one certificate, its K′ certificate). -/
theorem theoremB' (a b : Entry) (κc : Val) (hc : check F κc (memberC a.code).quote = true)
    (hca : CertifiedP a) (h : (play T a b).1 = .C) : (play T a b).2 = .C := by
  have hC := (memberC_denote a.code (fun _ => Val.nil)).mp
    (check_sound F κc _ hc (fun _ => Val.nil))
  exact theoremB'_sem a b hca (fun y κ h1 h2 hr => (hC y κ h1 h2).mp hr) h

#print axioms Diag.memberP_denote
#print axioms Diag.memberC_denote
#print axioms Diag.theoremA'
#print axioms Diag.theoremB'_sem
#print axioms Diag.theoremB'

end Diag
