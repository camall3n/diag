import Diag.Sound.Infer

/-!
# M4: what K means, and Theorems A and B

`member_denote` unfolds the semantics of `K(c)` into a plain Lean statement about the
one `run` and the one `check`. It uses the diagonal lemma `diag_eval` (δ evaluates to
⌜K⌝) and the substitution lemma `subst_K` (`subst(⌜K⌝, y) = ⌜K(y)⌝`).

Theorems A and B are then stated about `play`, the function used at play time. Their
only hypotheses are that the certificates check, which is exactly what each player
computes locally.
-/

namespace Diag
open Standard Params

theorem toMove_eq_C (r : Option Val) : toMove r = .C ↔ r.getD Val.bot = C := by
  cases r with
  | none => simp [toMove, Val.bot, C]
  | some v =>
    by_cases hv : v = .sym "C"
    · subst hv; simp [toMove, C]
    · have : toMove (some v) = .D := by
        unfold toMove
        split
        · rename_i h; simp at h; exact absurd h hv
        · rfl
      simp [this, C, hv]

/-- **What K says.** `c` is a member iff, against every opponent `y` with certificate `κ`
within the size caps, `c` plays `C` exactly when `κ` checks as a proof that `y` is a
member. -/
theorem member_denote (c : Val) (ρ : Nat → Val) :
    (member c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
      ((run T c [y, κ]).getD Val.bot = C ↔ check F κ (member y).quote = true) := by
  have hd := diag_eval
  show (K.inst (.lit c)).denote ρ ↔ _
  rw [Fm.denote_inst, K, Fm.denote_inst]
  generalize hq : Dfm.quote = q at hd
  simp only [Dfm, Fm.denote, Fm.denote_iff, boundFm_denote]
  apply forall_congr'; intro y
  apply forall_congr'; intro κ
  simp only [Tm.denote, b, natT, truT, Asg.cons, Tm.list, Op.applyPure, Val.toList?,
    Option.map, Val.nil]
  rw [hd, subst_K, Val.ofBool_eq_tru]

/-- A membership certificate that checks makes `K(c)` hold, as a plain Lean statement. -/
theorem member_of_check {c κ : Val} (h : check F κ (member c).quote = true) :
    ∀ y κ' : Val, y.sz ≤ L → κ'.sz ≤ Kmax →
      ((run T c [y, κ']).getD Val.bot = C ↔ check F κ' (member y).quote = true) :=
  (member_denote c (fun _ => Val.nil)).mp (check_member_sound F κ c h (fun _ => Val.nil))

/-- The certificate of an entry checks as a proof that the entry is a member. -/
def Certified (e : Entry) : Prop := check F e.cert (member e.code).quote = true

theorem move_eq_C (me opp : Entry) :
    move T me opp = .C ↔
      me.ok = true ∧ opp.ok = true ∧ (run T me.code [opp.code, opp.cert]).getD Val.bot = C := by
  unfold move
  cases hm : me.ok <;> cases ho : opp.ok <;> simp [toMove_eq_C]

theorem Entry.ok_iff (e : Entry) : e.ok = true ↔ e.code.sz ≤ L ∧ e.cert.sz ≤ Kmax := by
  simp [Entry.ok]

/-- **Theorem A (members cooperate).** Two certified entries within the size caps play
(C, C). -/
theorem theoremA (a b : Entry) (ha : a.ok = true) (hb : b.ok = true)
    (hca : Certified a) (hcb : Certified b) :
    play T a b = (.C, .C) := by
  have hA := member_of_check hca
  have hB := member_of_check hcb
  obtain ⟨ha1, ha2⟩ := (Entry.ok_iff a).mp ha
  obtain ⟨hb1, hb2⟩ := (Entry.ok_iff b).mp hb
  have m1 : move T a b = .C :=
    (move_eq_C a b).mpr ⟨ha, hb, (hA b.code b.cert hb1 hb2).mpr hcb⟩
  have m2 : move T b a = .C :=
    (move_eq_C b a).mpr ⟨hb, ha, (hB a.code a.cert ha1 ha2).mpr hca⟩
  simp [play, m1, m2]

/-- **Theorem B (members are unexploitable).** If a certified entry plays C, its
opponent plays C too, whoever the opponent is. -/
theorem theoremB (a b : Entry) (hca : Certified a) (h : (play T a b).1 = .C) :
    (play T a b).2 = .C := by
  have hA := member_of_check hca
  obtain ⟨ha, hb, hrun⟩ := (move_eq_C a b).mp h
  obtain ⟨ha1, ha2⟩ := (Entry.ok_iff a).mp ha
  obtain ⟨hb1, hb2⟩ := (Entry.ok_iff b).mp hb
  -- a played C, so b's certificate checks; by soundness, b is a member
  have hcb : Certified b := (hA b.code b.cert hb1 hb2).mp hrun
  have hB := member_of_check hcb
  -- so b plays C against a exactly when a's certificate checks, and it does
  exact (move_eq_C b a).mpr ⟨hb, ha, (hB a.code a.cert ha1 ha2).mpr hca⟩

end Diag

#print axioms Diag.member_denote
#print axioms Diag.theoremA
#print axioms Diag.theoremB
