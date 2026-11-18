import Diag.Sound.SymEval
import Diag.Standard

/-!
# M3, part 5: soundness of S

`infer_sound`: every conclusion the checker infers is true in the semantics, where the
function symbols `check` and `run` are interpreted as the Lean functions `check` and
`run` themselves. `check_sound` follows.

No step uses the soundness of `check` *inside* the induction. The rule `eval` only
asserts equations about `check`, and `evalTm_sound` covers those by computation. That
is the formal content of "S has no reflection rule".
-/

namespace Diag

@[simp] theorem Fm.denote_not (φ : Fm) (ρ : Nat → Val) : (Fm.not φ).denote ρ ↔ ¬ φ.denote ρ := by
  simp [Fm.not, Fm.denote]

theorem Fm.denote_iff (a b : Fm) (ρ : Nat → Val) :
    (Fm.iff a b).denote ρ ↔ (a.denote ρ ↔ b.denote ρ) := by
  simp only [Fm.iff, Fm.denote]
  exact ⟨fun ⟨h1, h2⟩ => ⟨h1, h2⟩, fun ⟨h1, h2⟩ => ⟨h1, h2⟩⟩

theorem Val.ofBool_eq_tru (b : Bool) : Val.ofBool b = Val.tru ↔ b = true := by
  cases b <;> decide

/-- The size-bound formula means what it says. -/
theorem boundFm_denote (t : Tm) (B : Nat) (ρ : Nat → Val) :
    (boundFm t B).denote ρ ↔ (t.denote ρ).sz ≤ B := by
  simp only [boundFm, Fm.denote, Tm.denote, Op.applyPure, Val.toNat, Val.ofBool_eq_tru]
  exact ⟨fun h => by have := of_decide_eq_true h; omega, fun h => decide_eq_true (by omega)⟩

/-- The conjunction of size bounds gives the hypothesis of `symRunCore_sound`. -/
theorem boundsFm_denote (ρ : Nat → Val) :
    ∀ args : List (Tm × Nat), (boundsFm args).denote ρ →
      ∀ a ∈ args.map (fun (p : Tm × Nat) => (⟨p.1, p.2⟩ : SV)), (a.t.denote ρ).sz ≤ a.b
  | [], _ => by simp
  | (t, B) :: rest, h => by
      simp only [boundsFm, Fm.denote] at h
      intro a ha
      simp only [List.map_cons, List.mem_cons] at ha
      rcases ha with rfl | ha
      · exact (boundFm_denote t B ρ).mp h.1
      · exact boundsFm_denote ρ rest h.2 a ha

theorem Tm.list_denote (ρ : Nat → Val) :
    ∀ ts : List Tm, ((Tm.list ts).denote ρ).toList? = some (ts.map (Tm.denote ρ))
  | [] => by simp [Tm.list, Tm.denote, Val.nil, Val.toList?]
  | t :: ts => by
      simp [Tm.list, Tm.denote, Op.applyPure, Val.toList?, Tm.list_denote ρ ts]

theorem Val.ofBool_cases (b : Bool) : Val.ofBool b = Val.tru ∨ Val.ofBool b = Val.fls := by
  cases b <;> simp [Val.ofBool]

/-- The justification of `boolCases`: a term whose head operation yields a boolean
denotes `true` or `false` (from `Op.applyPure` and `Val.ofBool`). -/
theorem Tm.isBool_denote : ∀ (t : Tm), t.isBool = true → ∀ ρ : Nat → Val,
    t.denote ρ = Val.tru ∨ t.denote ρ = Val.fls
  | .op1 .isPair a, _, ρ => by simp only [Tm.denote, Op.applyPure]; exact Val.ofBool_cases _
  | .op1 .isNat a, _, ρ => by simp only [Tm.denote, Op.applyPure]; exact Val.ofBool_cases _
  | .op2 .eq a b, _, ρ => by simp only [Tm.denote, Op.applyPure]; exact Val.ofBool_cases _
  | .op2 .lt a b, _, ρ => by simp only [Tm.denote, Op.applyPure]; exact Val.ofBool_cases _
  | .op3 .check a b c, _, ρ => by
      simp only [Tm.denote]
      split
      · exact Val.ofBool_cases _
      · simp [Op.applyPure]
  | .bvar _, h, _ | .lit _, h, _ | .ite _ _ _, h, _ | .run _ _ _, h, _ => by simp [Tm.isBool] at h
  | .op1 .eq _, h, _ | .op1 .pair _, h, _ | .op1 .fst _, h, _ | .op1 .snd _, h, _
  | .op1 .plus _, h, _ | .op1 .minus _, h, _ | .op1 .lt _, h, _ | .op1 .sz _, h, _
  | .op1 .check _, h, _ | .op1 .subst _, h, _ => by simp [Tm.isBool] at h
  | .op2 .pair _ _, h, _ | .op2 .fst _ _, h, _ | .op2 .snd _ _, h, _ | .op2 .isPair _ _, h, _
  | .op2 .isNat _ _, h, _ | .op2 .plus _ _, h, _ | .op2 .minus _ _, h, _ | .op2 .sz _ _, h, _
  | .op2 .check _ _, h, _ | .op2 .subst _ _, h, _ => by simp [Tm.isBool] at h
  | .op3 .eq _ _ _, h, _ | .op3 .pair _ _ _, h, _ | .op3 .fst _ _ _, h, _ | .op3 .snd _ _ _, h, _
  | .op3 .isPair _ _ _, h, _ | .op3 .isNat _ _ _, h, _ | .op3 .plus _ _ _, h, _
  | .op3 .minus _ _ _, h, _ | .op3 .lt _ _ _, h, _ | .op3 .sz _ _ _, h, _
  | .op3 .subst _ _ _, h, _ => by simp [Tm.isBool] at h

theorem infer_sound : ∀ (n : Nat) (Γ : List Fm) (pr : Proof) (φ : Fm) (rest : Fin n),
    infer n Γ pr = some (φ, rest) → ∀ ρ : Nat → Val, (∀ ψ ∈ Γ, ψ.denote ρ) → φ.denote ρ := by
  intro n
  induction n using Nat.strongRecOn with
  | _ n ih =>
  intro Γ pr φ rest h ρ hΓ
  cases n with
  | zero => simp [infer] at h
  | succ n =>
  cases pr with
  | hyp i =>
    rw [infer] at h
    simp only [Option.map_eq_some_iff, Prod.mk.injEq] at h
    obtain ⟨φ', hg, rfl, -⟩ := h
    exact hΓ _ (List.mem_of_getElem? hg)
  | impI a q =>
    rw [infer] at h
    split at h
    · rename_i b m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      intro ha
      exact ih n (by omega) (a :: Γ) q b m hq ρ (by
        intro ψ hψ
        rcases List.mem_cons.mp hψ with rfl | hψ
        · exact ha
        · exact hΓ ψ hψ)
    · contradiction
  | impE q r =>
    rw [infer] at h
    split at h
    · rename_i a b m hq
      split at h
      · rename_i a' k hr
        split at h
        · rename_i hc
          simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨rfl, -⟩ := h
          have h1 := ih n (by omega) Γ q _ m hq ρ hΓ
          have h2 := ih m.val (by omega) Γ r a' k hr ρ hΓ
          rw [hc.2] at h2
          exact h1 h2
        · contradiction
      · contradiction
    · contradiction
  | andI q r =>
    rw [infer] at h
    split at h; · contradiction
    rename_i a m hq
    split at h
    · rename_i b k hr
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      exact ⟨ih n (by omega) Γ q a m hq ρ hΓ, ih m.val (by omega) Γ r b k hr ρ hΓ⟩
    · contradiction
  | andL q =>
    rw [infer] at h
    split at h
    · rename_i a b m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      exact (ih n (by omega) Γ q _ m hq ρ hΓ).1
    · contradiction
  | andR q =>
    rw [infer] at h
    split at h
    · rename_i a b m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      exact (ih n (by omega) Γ q _ m hq ρ hΓ).2
    · contradiction
  | exfalso ψ q =>
    rw [infer] at h
    split at h
    · rename_i m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      exact (ih n (by omega) Γ q _ m hq ρ hΓ).elim
    · contradiction
  | dne q =>
    rw [infer] at h
    split at h
    · rename_i ψ m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      have hnn := ih n (by omega) Γ q _ m hq ρ hΓ
      simp only [Fm.denote] at hnn
      exact Classical.byContradiction hnn
    · contradiction
  | allI q =>
    rw [infer] at h
    split at h
    · rename_i hc
      split at h
      · rename_i ψ m hq
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        intro v
        refine ih _ (by omega) _ q ψ m hq (Asg.cons v ρ) ?_
        intro χ hχ
        obtain ⟨χ0, hχ0, rfl⟩ := List.mem_map.mp hχ
        exact (Fm.denote_shift_cons χ0 v ρ).mpr (hΓ χ0 hχ0)
      · contradiction
    · contradiction
  | allE q t =>
    rw [infer] at h
    split at h
    · rename_i ψ m hq
      split at h
      · simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        rw [Fm.denote_inst]
        exact ih n (by omega) Γ q _ m hq ρ hΓ (t.denote ρ)
      · contradiction
    · contradiction
  | refl t =>
    rw [infer] at h
    simp only [Option.some.injEq, Prod.mk.injEq] at h
    obtain ⟨rfl, -⟩ := h
    simp [Fm.denote]
  | rw M q r =>
    rw [infer] at h
    split at h
    · rename_i t u m hq
      split at h
      · rename_i ψ k hr
        split at h
        · rename_i hc
          simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨rfl, -⟩ := h
          have htu : t.denote ρ = u.denote ρ := ih n (by omega) Γ q _ m hq ρ hΓ
          have hψ := ih m.val (by omega) Γ r ψ k hr ρ hΓ
          rw [← hc.2, Fm.denote_inst, htu] at hψ
          rw [Fm.denote_inst]
          exact hψ
        · contradiction
      · contradiction
    · contradiction
  | iteT t e q =>
    rw [infer] at h
    split at h
    · rename_i c m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      have hc : c.denote ρ = Val.tru := ih n (by omega) Γ q _ m hq ρ hΓ
      simp [Fm.denote, Tm.denote, hc]
    · contradiction
  | iteF t e q =>
    rw [infer] at h
    split at h
    · rename_i c m hq
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      have hc : ¬ c.denote ρ = Val.tru := ih n (by omega) Γ q _ m hq ρ hΓ
      simp [Fm.denote, Tm.denote, hc]
    · contradiction
  | eval t u =>
    rw [infer] at h
    split at h
    · split at h; · contradiction
      rename_i v m ht
      split at h; · contradiction
      rename_i w k hu
      split at h
      · rename_i hc
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        simp only [Fm.denote]
        rw [evalTm_sound _ t v m ht ρ, evalTm_sound _ u w k hu ρ, hc.2]
      · contradiction
    · contradiction
  | evalNe t u =>
    rw [infer] at h
    split at h
    · split at h; · contradiction
      rename_i v m ht
      split at h; · contradiction
      rename_i w k hu
      split at h
      · rename_i hc
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        simp only [Fm.denote_not, Fm.denote]
        rw [evalTm_sound _ t v m ht ρ, evalTm_sound _ u w k hu ρ]
        exact hc.2
      · contradiction
    · contradiction
  | boolCases t q r =>
    rw [infer] at h
    split at h
    · rename_i hb
      split at h
      · rename_i t1 φ1 m hq
        split at h
        · rename_i t2 ψ k hr
          split at h
          · rename_i hc
            simp only [Option.some.injEq, Prod.mk.injEq] at h
            obtain ⟨rfl, -⟩ := h
            obtain ⟨-, rfl, rfl, rfl⟩ := hc
            have h1 := ih n (by omega) Γ q _ m hq ρ hΓ
            have h2 := ih m.val (by omega) Γ r _ k hr ρ hΓ
            simp only [Fm.denote, Tm.denote] at h1 h2
            rcases Tm.isBool_denote _ hb ρ with e | e
            · exact h1 e
            · exact h2 e
          · contradiction
        · contradiction
      · contradiction
    · contradiction
  | symRun f code args q =>
    rw [infer] at h
    split at h; · contradiction
    rename_i ψ m hq
    split at h
    · rename_i hc
      split at h
      · rename_i e k hs
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        have hb := ih n (by omega) Γ q ψ m hq ρ hΓ
        rw [hc.2] at hb
        have hrun := symRunCore_sound _ f code _ e k hs ρ (boundsFm_denote ρ args hb)
        simp only [Fm.denote, Tm.denote, Tm.list_denote]
        simp only [List.map_map] at hrun ⊢
        simp only [Function.comp_def] at hrun ⊢
        rw [hrun]
        rfl
      · contradiction
    · contradiction

/-- **Soundness of S.** If the checker accepts `p` as a proof of `φ`, with any fuel,
then `φ` is true under every assignment. -/
theorem check_sound (f : Nat) (p : Val) (φ : Fm) (h : check f p φ.quote = true) :
    ∀ ρ, φ.denote ρ := by
  intro ρ
  unfold check at h
  split at h
  · rw [Fm.decode?_quote] at h
    split at h
    · rename_i pr φ' hp hφ
      simp only [Option.some.injEq] at hφ
      subst hφ
      split at h
      · rename_i g rest hinf
        simp only [decide_eq_true_eq] at h
        subst h
        exact infer_sound _ [] pr g rest hinf ρ (by simp)
      · contradiction
    · contradiction
  · contradiction

/-- The corollary used in M4: an accepted membership certificate makes `K(c)` true. -/
theorem check_member_sound (f : Nat) (κ c : Val)
    (h : check f κ (Standard.member c).quote = true) : ∀ ρ, (Standard.member c).denote ρ :=
  check_sound f κ _ h

end Diag
