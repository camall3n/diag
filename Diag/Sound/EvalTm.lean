import Diag.Sound.Basic

/-! # M3, part 2: the `eval` rule computes the semantics -/

namespace Diag

theorem spendOp_some {n : Nat} {o : Op} {vs : List Val} {m : Fin n} {v : Val} {k : Fin n}
    (h : spendOp o vs m = some (v, k)) :
    v = (o.applyPure vs).1 ∧ (o.applyPure vs).2 + (o.applyPure vs).1.sz ≤ m.val ∧
      k.val = m.val - ((o.applyPure vs).2 + (o.applyPure vs).1.sz) := by
  unfold spendOp at h
  split at h
  rename_i v' c' heq
  rw [heq]
  split at h
  · rename_i hc
    simp only [Option.some.injEq, Prod.mk.injEq] at h
    obtain ⟨rfl, rfl⟩ := h
    exact ⟨rfl, hc, rfl⟩
  · contradiction

theorem evalTm_sound : ∀ (n : Nat) (t : Tm) (v : Val) (rest : Fin n),
    evalTm n t = some (v, rest) → ∀ ρ, t.denote ρ = v := by
  intro n
  induction n using Nat.strongRecOn with
  | _ n ih =>
  intro t v rest h ρ
  match n, t with
  | 0, _ => simp [evalTm] at h
  | _+1, .bvar _ => simp [evalTm] at h
  | n+1, .lit w => simp [evalTm] at h; simp [Tm.denote, h.1]
  | n+1, .op1 o a =>
    rw [evalTm] at h
    split at h
    · contradiction
    · rename_i va m ha
      split at h
      · rename_i w k hs
        simp at h; obtain ⟨rfl, -⟩ := h
        simp [Tm.denote, ih n (by omega) a va m ha ρ, (spendOp_some hs).1]
      · contradiction
  | n+1, .op2 o a b =>
    rw [evalTm] at h
    split at h; · contradiction
    rename_i va m ha
    split at h; · contradiction
    rename_i vb k hb
    split at h
    · rename_i w j hs
      simp at h; obtain ⟨rfl, -⟩ := h
      simp [Tm.denote, ih n (by omega) a va m ha ρ, ih m.val (by omega) b vb k hb ρ,
        (spendOp_some hs).1]
    · contradiction
  | n+1, .op3 o a b c =>
    rw [evalTm] at h
    split at h; · contradiction
    rename_i va m ha
    split at h; · contradiction
    rename_i vb k hb
    split at h; · contradiction
    rename_i vc j hc
    have ea := ih n (by omega) a va m ha ρ
    have eb := ih m.val (by omega) b vb k hb ρ
    have ec := ih k.val (by omega) c vc j hc ρ
    split at h
    · split at h
      · simp at h; obtain ⟨rfl, -⟩ := h
        simp [Tm.denote, ea, eb, ec]
      · contradiction
    · rename_i hne
      split at h
      · rename_i w i hs
        simp at h; obtain ⟨rfl, -⟩ := h
        simp only [Tm.denote, ea, eb, ec]
        exact (spendOp_some hs).1.symm
      · contradiction
  | n+1, .ite c t e =>
    rw [evalTm] at h
    split at h; · contradiction
    rename_i vc m hc
    have ec := ih n (by omega) c vc m hc ρ
    split at h
    · rename_i w k hw
      simp at h; obtain ⟨rfl, -⟩ := h
      simp only [Tm.denote, ec]
      by_cases hcond : vc = Val.tru
      · simp only [hcond, ite_true] at hw ⊢
        exact ih m.val (by omega) _ _ k hw ρ
      · simp only [hcond, ite_false] at hw ⊢
        exact ih m.val (by omega) _ _ k hw ρ
    · contradiction
  | n+1, .run f c a =>
    rw [evalTm] at h
    split at h; · contradiction
    rename_i vf m hf
    split at h; · contradiction
    rename_i vc k hc
    split at h; · contradiction
    rename_i va j ha
    have ef := ih n (by omega) f vf m hf ρ
    have ec := ih m.val (by omega) c vc k hc ρ
    have ea := ih k.val (by omega) a va j ha ρ
    simp only [Tm.denote, ef, ec, ea]
    split at h
    · rename_i g as hl
      split at h
      · simp at h; obtain ⟨rfl, -⟩ := h
        simp [hl]
      · contradiction
    · rename_i hne
      simp at h; obtain ⟨rfl, -⟩ := h
      split
      · rename_i g as hl
        exact absurd hl (hne g as rfl)
      · rfl

end Diag
