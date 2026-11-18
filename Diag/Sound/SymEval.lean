import Diag.Sound.SymOp

/-! # M3, part 4: symbolic evaluation is sound (`symEval_sound`, `symRunCore_sound`) -/

namespace Diag

def SEnv.denote (ρ : Nat → Val) (σ : SEnv) : Env := σ.map fun p => (p.1, p.2.t.denote ρ)

def SEnv.Bounded (ρ : Nat → Val) (σ : SEnv) : Prop := ∀ x sv, (x, sv) ∈ σ → sv.ok ρ

theorem SEnv.lookup_denote (ρ : Nat → Val) (σ : SEnv) (x : String) :
    (SEnv.denote ρ σ).lookup x = (σ.lookup x).map (fun sv => sv.t.denote ρ) := by
  unfold SEnv.denote; exact lookup_map_snd (fun sv => sv.t.denote ρ) x σ

theorem SEnv.denote_zip (ρ : Nat → Val) (ps : List String) (args : List SV) :
    SEnv.denote ρ (ps.zip args) = ps.zip (args.map (SV.den ρ)) := by
  induction ps generalizing args with
  | nil => simp [SEnv.denote]
  | cons x ps ih =>
    cases args with
    | nil => simp [SEnv.denote]
    | cons a args => simp [SEnv.denote, SV.den] at *; exact ih args

theorem SEnv.bounded_zip (ρ : Nat → Val) (ps : List String) (args : List SV)
    (h : ∀ a ∈ args, a.ok ρ) : SEnv.Bounded ρ (ps.zip args) :=
  fun _ sv hm => h sv (List.of_mem_zip hm).2

theorem dite_pos' {c : Prop} [Decidable c] {α : Sort _} {t : c → α} {e : ¬c → α} (h : c) :
    dite c t e = t h := by simp [h]

theorem spendOp_eq {n : Nat} (o : Op) (vs : List Val) (m : Fin n)
    (h1 : (o.applyPure vs).2 ≤ m.val) (h2 : (o.applyPure vs).1.sz ≤ Params.V) :
    ∃ k : Fin n, spendOp o vs m = some ((o.applyPure vs).1, k) ∧
      k.val = m.val - (o.applyPure vs).2 := by
  unfold spendOp
  rcases hap : o.applyPure vs with ⟨v, c⟩
  rw [hap] at h1 h2
  simp only at h1 h2 ⊢
  rw [dite_pos' ⟨h1, h2⟩]
  exact ⟨_, rfl, rfl⟩

/-- `symEval_sound`, in the form proved by induction. -/
def SymEvalOK (p : Program) (ρ : Nat → Val) (k : Nat) : Prop :=
  ∀ (σ : SEnv) (e : Expr) (r : SV) (c : Nat) (rest : Fin k),
    symEval p k σ e = some ((r, c), rest) → SEnv.Bounded ρ σ →
    ∀ fuel, c ≤ fuel → ∃ rem : Fin fuel,
      eval p fuel (SEnv.denote ρ σ) e = some (r.t.denote ρ, rem) ∧ fuel - c ≤ rem.val ∧ r.ok ρ

def SymEvalListOK (p : Program) (ρ : Nat → Val) (k : Nat) : Prop :=
  ∀ (σ : SEnv) (es : List Expr) (args : List SV) (c : Nat) (rest : Fin (k + 1)),
    symEvalList p k σ es = some ((args, c), rest) → SEnv.Bounded ρ σ →
    ∀ fuel, c ≤ fuel → ∃ rem : Fin (fuel + 1),
      evalList p fuel (SEnv.denote ρ σ) es = some (args.map (SV.den ρ), rem) ∧
      fuel - c ≤ rem.val ∧ ∀ a ∈ args, a.ok ρ

theorem symEval_sound_all (p : Program) (ρ : Nat → Val) :
    ∀ k, SymEvalOK p ρ k ∧ SymEvalListOK p ρ k := by
  intro k
  induction k using Nat.strongRecOn with
  | _ k ih =>
  constructor
  · ------------------------------------------------------------------ expressions
    intro σ e r c rest h hσ fuel hc
    cases k with
    | zero => simp [symEval] at h
    | succ n =>
    cases e with
    | var x =>
      rw [symEval] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
      refine ⟨⟨f', by omega⟩, ?_, by simp, ?_⟩
      · rw [eval, SEnv.lookup_denote]
        cases σ.lookup x <;> simp [SV.nil, Tm.denote]
      · cases hl : σ.lookup x
        · simp [SV.nil, SV.ok, Tm.denote]
        · simp only [Option.getD_some]; exact hσ x _ (mem_of_lookup x σ _ hl)
    | lit v =>
      rw [symEval] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
      exact ⟨⟨f', by omega⟩, by rw [eval]; simp [Tm.denote], by simp,
        by simp [SV.ok, Tm.denote]⟩
    | op o es =>
      rw [symEval] at h
      split at h; · contradiction
      rename_i args cl m hl
      split at h; · contradiction
      rename_i r' c' w hop
      split at h
      · rename_i hw
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨⟨rfl, rfl⟩, -⟩ := h
        obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
        obtain ⟨rem1, he, hrem1, hok⟩ :=
          (ih n (by omega)).2 σ es args cl m hl hσ f' (by omega)
        rw [eval, he]
        simp only
        by_cases hcc : OpCheckCase o (args.map (SV.den ρ))
        · obtain ⟨rfl, pv, φv, f, hv⟩ := hcc
          obtain ⟨hden, hfc, hrok⟩ := symOp_check ρ hop hv
          rw [hv]
          simp only
          have hf : f ≤ rem1.val := by omega
          rw [dite_pos' hf]
          exact ⟨⟨rem1.val - f, by omega⟩, by simp [hden], by simp; omega, hrok⟩
        · obtain ⟨hden, hcost, hrok, hbV⟩ := symOp_pure ρ hop hok hcc
          split
          · rename_i pv φv f heq
            exact absurd ⟨rfl, pv, φv, f, heq⟩ hcc
          · rename_i o' _ _ _
            obtain ⟨k, hk, hkv⟩ := spendOp_eq o' (args.map (SV.den ρ)) rem1 (by omega)
              (by rw [hden]; exact Nat.le_trans hrok hbV)
            rw [hk, hden]
            exact ⟨k, rfl, by omega, hrok⟩
      · contradiction
    | ite c0 t e =>
      rw [symEval] at h
      split at h; · contradiction
      rename_i cv cc m hcs
      split at h
      · -- literal condition
        rename_i v hlit
        split at h; rotate_left; · contradiction
        rename_i r' rc k hb
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨⟨rfl, rfl⟩, -⟩ := h
        obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
        obtain ⟨rem1, he, hrem1, -⟩ := (ih n (by omega)).1 σ c0 cv cc m hcs hσ f' (by omega)
        rw [hlit] at he
        simp only [Tm.denote] at he
        obtain ⟨rem2, he2, hrem2, hok2⟩ :=
          (ih m.val (by omega)).1 σ _ r' rc k hb hσ rem1.val (by omega)
        refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, hok2⟩
        rw [eval, he]
        simp only [he2]
      · -- symbolic condition: both branches
        rename_i ct hnl
        split at h; · contradiction
        rename_i tv tc k ht
        split at h; · contradiction
        rename_i ev ec j hev
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨⟨rfl, rfl⟩, -⟩ := h
        obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
        obtain ⟨rem1, he, hrem1, -⟩ := (ih n (by omega)).1 σ c0 cv cc m hcs hσ f' (by omega)
        rw [eval, he]
        simp only
        by_cases hb : cv.t.denote ρ = Val.tru
        · obtain ⟨rem2, he2, hrem2, hok2⟩ :=
            (ih m.val (by omega)).1 σ t tv tc k ht hσ rem1.val (by omega)
          simp only [hb, ite_true, he2]
          refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, ?_⟩
          · simp [Tm.denote, hb]
          · simp only [SV.ok, Tm.denote, hb, ite_true]; exact Nat.le_trans hok2 (Nat.le_max_left _ _)
        · obtain ⟨rem2, he2, hrem2, hok2⟩ :=
            (ih k.val (by omega)).1 σ e ev ec j hev hσ rem1.val (by omega)
          simp only [hb, ite_false, he2]
          refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, ?_⟩
          · simp [Tm.denote, hb]
          · simp only [SV.ok, Tm.denote, hb, ite_false]
            exact Nat.le_trans hok2 (Nat.le_max_right _ _)
    | let_ x e0 b =>
      rw [symEval] at h
      split at h; · contradiction
      rename_i ve ce m hes
      split at h; · contradiction
      rename_i vb cb k hbs
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
      obtain ⟨rem1, he, hrem1, hok1⟩ := (ih n (by omega)).1 σ e0 ve ce m hes hσ f' (by omega)
      have hσ' : SEnv.Bounded ρ ((x, ve) :: σ) := by
        intro y sv hm
        rcases List.mem_cons.mp hm with heq | hm'
        · simp at heq; obtain ⟨-, rfl⟩ := heq; exact hok1
        · exact hσ y sv hm'
      obtain ⟨rem2, he2, hrem2, hok2⟩ :=
        (ih m.val (by omega)).1 ((x, ve) :: σ) b vb cb k hbs hσ' rem1.val (by omega)
      refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, hok2⟩
      rw [eval, he]
      simp only [SEnv.denote, List.map_cons] at he2 ⊢
      simp only [he2]
    | call f es =>
      rw [symEval] at h
      split at h; · contradiction
      rename_i args cl m hl
      split at h
      · -- unknown function
        rename_i hnf
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨⟨rfl, rfl⟩, -⟩ := h
        obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
        obtain ⟨rem1, he, hrem1, -⟩ :=
          (ih n (by omega)).2 σ es args cl m hl hσ f' (by omega)
        refine ⟨⟨rem1.val, by omega⟩, ?_, by simp; omega, by simp [SV.nil, SV.ok, Tm.denote]⟩
        rw [eval, he]
        simp [hnf, SV.nil, Tm.denote]
      · rename_i ps body hf
        split at h; · contradiction
        rename_i r' rc k hbs
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨⟨rfl, rfl⟩, -⟩ := h
        obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
        obtain ⟨rem1, he, hrem1, hok⟩ :=
          (ih n (by omega)).2 σ es args cl m hl hσ f' (by omega)
        obtain ⟨rem2, he2, hrem2, hok2⟩ :=
          (ih m.val (by omega)).1 (ps.zip args) body r' rc k hbs
            (SEnv.bounded_zip ρ ps args hok) rem1.val (by omega)
        refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, hok2⟩
        rw [eval, he]
        rw [SEnv.denote_zip] at he2
        simp [hf, he2]
  · ------------------------------------------------------------------ argument lists
    intro σ es args c rest h hσ fuel hc
    cases es with
    | nil =>
      rw [symEvalList] at h
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      exact ⟨⟨fuel, by omega⟩, by rw [evalList]; simp, by simp, by simp⟩
    | cons e es =>
      cases k with
      | zero => simp [symEvalList] at h
      | succ n =>
      rw [symEvalList] at h
      split at h; · contradiction
      rename_i v c1 m he1
      split at h; · contradiction
      rename_i vs cs k hes
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      obtain ⟨f', rfl⟩ : ∃ f', fuel = f' + 1 := ⟨fuel - 1, by omega⟩
      obtain ⟨rem1, he, hrem1, hok1⟩ := (ih n (by omega)).1 σ e v c1 m he1 hσ f' (by omega)
      obtain ⟨rem2, he2, hrem2, hok2⟩ :=
        (ih m.val (by omega)).2 σ es vs cs k hes hσ rem1.val (by omega)
      refine ⟨⟨rem2.val, by omega⟩, ?_, by simp; omega, ?_⟩
      · rw [evalList, he]
        simp only [he2]
        rfl
      · intro a ha
        rcases List.mem_cons.mp ha with rfl | ha'
        · exact hok1
        · exact hok2 a ha'

/-- **Correctness of symbolic evaluation.** If `symEval` succeeds with runtime cost
bound `c` and the variables are within their size bounds, then the real `eval`, with
any fuel ≥ `c`, succeeds, returns exactly the result term's value, uses at most `c`
fuel, and the value is within the computed size bound. -/
theorem symEval_sound (p : Program) (ρ : Nat → Val) (k : Nat) (σ : SEnv) (e : Expr)
    (r : SV) (c : Nat) (rest : Fin k)
    (hs : symEval p k σ e = some ((r, c), rest)) (hσ : SEnv.Bounded ρ σ)
    (fuel : Nat) (hc : c ≤ fuel) :
    ∃ rem : Fin fuel, eval p fuel (SEnv.denote ρ σ) e = some (r.t.denote ρ, rem) ∧
      fuel - c ≤ rem.val ∧ (r.t.denote ρ).sz ≤ r.b :=
  (symEval_sound_all p ρ k).1 σ e r c rest hs hσ fuel hc

theorem symRunCore_sound (k f : Nat) (code : Val) (args : List SV) (e : Tm) (rest : Fin (k + 1))
    (hs : symRunCore k f code args = some (e, rest)) (ρ : Nat → Val)
    (hb : ∀ a ∈ args, (a.t.denote ρ).sz ≤ a.b) :
    run f code (args.map fun a => a.t.denote ρ) = some (e.denote ρ) := by
  unfold symRunCore at hs
  split at hs; rotate_left; · contradiction
  rename_i hk
  split at hs; · contradiction
  rename_i p hp
  split at hs; · contradiction
  rename_i ps body hm
  split at hs; rotate_left; · contradiction
  rename_i hlen
  split at hs; rotate_left; · contradiction
  rename_i r c j hsym
  split at hs; rotate_left; · contradiction
  rename_i hcost
  simp only [Option.some.injEq, Prod.mk.injEq] at hs
  obtain ⟨rfl, -⟩ := hs
  obtain ⟨rem, he, -, -⟩ := symEval_sound p ρ _ (ps.zip args) body r c j hsym
    (SEnv.bounded_zip ρ ps args hb) (f - code.sz) (by omega)
  rw [SEnv.denote_zip] at he
  unfold run
  rw [dite_pos' (by omega), hp]
  simp only [hm, List.length_map, hlen, ite_true]
  have : (args.map fun a => a.t.denote ρ) = args.map (SV.den ρ) := rfl
  rw [this, he]

end Diag
