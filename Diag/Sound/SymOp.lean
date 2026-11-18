import Diag.Sound.EvalTm

/-! # M3, part 3: symbolic operations are sound -/

namespace Diag

/-- A symbolic value is within its size bound under `ρ`. -/
def SV.ok (ρ : Nat → Val) (a : SV) : Prop := (a.t.denote ρ).sz ≤ a.b

def SV.den (ρ : Nat → Val) (a : SV) : Val := a.t.denote ρ

/-! ## Lists -/

theorem lookup_map_snd {β γ : Type} (f : β → γ) (x : String) :
    ∀ l : List (String × β), (l.map fun p => (p.1, f p.2)).lookup x = (l.lookup x).map f
  | [] => rfl
  | (y, b) :: l => by
      simp only [List.map_cons, List.lookup_cons]
      split <;> simp_all [lookup_map_snd f x l]

theorem mem_of_lookup {β : Type} (x : String) :
    ∀ (l : List (String × β)) (b : β), l.lookup x = some b → (x, b) ∈ l
  | [], _, h => by simp at h
  | (y, c) :: l, b, h => by
      simp only [List.lookup_cons] at h
      split at h
      · rename_i hxy
        simp at h hxy; subst h; subst hxy; simp
      · exact List.mem_cons_of_mem _ (mem_of_lookup x l b h)

theorem mapM_lit? : ∀ (args : List SV) (vs : List Val), args.mapM SV.lit? = some vs →
    ∀ ρ, args.map (SV.den ρ) = vs
  | [], vs, h, ρ => by simp at h; simp [h]
  | a :: args, vs, h, ρ => by
      simp only [List.mapM_cons, Option.bind_eq_bind] at h
      cases ha : SV.lit? a with
      | none => simp [ha] at h
      | some v =>
        cases hr : args.mapM SV.lit? with
        | none => simp [ha, hr] at h
        | some ws =>
          simp [ha, hr] at h
          subst h
          have : a.den ρ = v := by
            rcases a with ⟨t, b⟩
            cases t <;> simp [SV.lit?] at ha
            subst ha; simp [SV.den, Tm.denote]
          simp [this, mapM_lit? args ws hr ρ]

/-! ## Size bounds -/

theorem substV_sz_le (φv v : Val) (bv : Nat) (h : v.sz ≤ bv) :
    (substV φv v).sz ≤ substBound φv bv := by
  unfold substV substBound
  cases hd : Fm.decode? φv with
  | none => simp
  | some f =>
    simp only
    have e := Fm.sz_quote_instAt_lit v f 0
    have : f.occ 0 * v.sz ≤ f.occ 0 * bv := Nat.mul_le_mul_left _ h
    unfold Fm.inst
    simp only [Val.nil_sz] at e
    omega

theorem sz_fst_le (v : Val) (b : Nat) (h : v.sz ≤ b) :
    (match v with | .pair a _ => a | _ => Val.nil).sz ≤ max b 4 := by
  cases v <;> simp at h ⊢ <;> omega

theorem sz_snd_le (v : Val) (b : Nat) (h : v.sz ≤ b) :
    (match v with | .pair _ c => c | _ => Val.nil).sz ≤ max b 4 := by
  cases v <;> simp at h ⊢ <;> omega

theorem sz_plus_le (a b : Val) (ba bb : Nat) (ha : a.sz ≤ ba) (hb : b.sz ≤ bb) :
    (Val.nat (a.toNat + b.toNat)).sz ≤ max ba bb + 1 := by
  have h1 := Val.sz_toNat a
  have h2 := Val.sz_toNat b
  have h3 := log2_add_le a.toNat b.toNat
  simp only [Val.sz_nat] at *
  omega

theorem sz_minus_le (a b : Val) (ba : Nat) (ha : a.sz ≤ ba) :
    (Val.nat (a.toNat - b.toNat)).sz ≤ max ba 1 := by
  have h1 := Val.sz_toNat a
  have h3 := log2_mono (Nat.sub_le a.toNat b.toNat)
  simp only [Val.sz_nat] at *
  omega

theorem sz_sz_le (v : Val) (b : Nat) (h : v.sz ≤ b) : (Val.nat v.sz).sz ≤ b.log2 + 1 := by
  simp only [Val.sz_nat]
  have := log2_mono h
  omega

/-! ## Symbolic operations

`OpCheckCase o vs` holds when `eval` routes an operation to the real checker. -/

def OpCheckCase (o : Op) (vs : List Val) : Prop :=
  o = .check ∧ ∃ pv φv f, vs = [pv, φv, .nat f]

/-- The pure case: `symOp`'s result denotes what `applyPure` computes, within its bounds. -/
theorem symOp_pure {o : Op} {args : List SV} {r : SV} {c w : Nat} (ρ : Nat → Val)
    (h : symOp o args = some ((r, c), w)) (hok : ∀ a ∈ args, a.ok ρ)
    (hnc : ¬ OpCheckCase o (args.map (SV.den ρ))) :
    (o.applyPure (args.map (SV.den ρ))).1 = r.t.denote ρ ∧
    (o.applyPure (args.map (SV.den ρ))).2 ≤ c ∧ r.ok ρ ∧ r.b ≤ Params.V := by
  unfold symOp at h
  split at h
  · -- all literal: computed
    rename_i vs hvs
    have hoc : o ≠ .check := by intro hc; simp [hc] at hvs
    have hvs' : args.mapM SV.lit? = some vs := by simpa [hoc] using hvs
    rw [mapM_lit? args vs hvs' ρ]
    rcases hap : o.applyPure vs with ⟨v, c0⟩
    rw [hap] at h
    simp only at h
    split at h
    · rename_i hV
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨⟨rfl, rfl⟩, -⟩ := h
      exact ⟨by simp [Tm.denote], Nat.le_refl _, by simp [SV.ok, Tm.denote], hV⟩
    · contradiction
  · -- symbolic
    split at h
    · rename_i hlen
      split at h
      · rename_i t b c' ht hb hc'
        split at h
        · rename_i hbV
          simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨⟨rfl, rfl⟩, -⟩ := h
          refine ⟨?_, ?_, ?_, hbV⟩
          · -- denotation
            match args, ht with
            | [a], ht => simp [opTm] at ht; subst ht; simp [Tm.denote, SV.den]
            | [a, b'], ht => simp [opTm] at ht; subst ht; simp [Tm.denote, SV.den]
            | [a, b', e], ht =>
              simp [opTm] at ht; subst ht
              simp only [Tm.denote, List.map]
              split
              · exact absurd ⟨rfl, a.t.denote ρ, b'.t.denote ρ, _, by simp [SV.den]; assumption⟩ hnc
              · rfl
          · -- cost
            match o, args, hc' with
            | .eq, [a, b'], hc' | .plus, [a, b'], hc' | .minus, [a, b'], hc' | .lt, [a, b'], hc' =>
              simp [opCost] at hc'; subst hc'
              have := hok a (by simp); have := hok b' (by simp)
              simp [Op.applyPure, SV.ok, SV.den] at *; omega
            | .subst, [a, b'], hc' =>
              simp [opCost] at hc'; subst hc'
              have := hok a (by simp); have := hok b' (by simp)
              simp [Op.applyPure, SV.ok, SV.den] at *; omega
            | .check, [a, b', e], hc' =>
              simp only [Op.applyPure]
              omega
            | .pair, [a, b'], _ | .fst, [a], _ | .snd, [a], _ | .isPair, [a], _
            | .isNat, [a], _ | .sz, [a], _ => simp [Op.applyPure]
            | .eq, [], _ | .eq, [_], _ | .eq, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .pair, [], _ | .pair, [_], _ | .pair, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .plus, [], _ | .plus, [_], _ | .plus, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .minus, [], _ | .minus, [_], _ | .minus, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .lt, [], _ | .lt, [_], _ | .lt, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .subst, [], _ | .subst, [_], _ | .subst, _ :: _ :: _ :: _, _ => simp [Op.applyPure]
            | .fst, [], _ | .fst, _ :: _ :: _, _ => simp [Op.applyPure]
            | .snd, [], _ | .snd, _ :: _ :: _, _ => simp [Op.applyPure]
            | .isPair, [], _ | .isPair, _ :: _ :: _, _ => simp [Op.applyPure]
            | .isNat, [], _ | .isNat, _ :: _ :: _, _ => simp [Op.applyPure]
            | .sz, [], _ | .sz, _ :: _ :: _, _ => simp [Op.applyPure]
            | .check, _, _ => simp [Op.applyPure]
          · -- size
            simp only [SV.ok]
            have hden : (o.applyPure (args.map (SV.den ρ))).1 = t.denote ρ := by
              match args, ht with
              | [a], ht => simp [opTm] at ht; subst ht; simp [Tm.denote, SV.den]
              | [a, b'], ht => simp [opTm] at ht; subst ht; simp [Tm.denote, SV.den]
              | [a, b', e], ht =>
                simp [opTm] at ht; subst ht
                simp only [Tm.denote, List.map]
                split
                · exact absurd ⟨rfl, a.t.denote ρ, b'.t.denote ρ, _, by simp [SV.den]; assumption⟩ hnc
                · rfl
            rw [← hden]
            match o, args, hb with
            | .eq, [a, b'], hb | .lt, [a, b'], hb =>
              simp [opBound] at hb; subst hb; simp only [Op.applyPure]; exact Val.sz_ofBool _
            | .isPair, [a], hb | .isNat, [a], hb =>
              simp [opBound] at hb; subst hb; simp only [Op.applyPure]; exact Val.sz_ofBool _
            | .check, [a, b', e], hb =>
              simp [opBound] at hb; subst hb; simp only [Op.applyPure]; decide
            | .pair, [a, b'], hb =>
              simp [opBound] at hb; subst hb
              have := hok a (by simp); have := hok b' (by simp)
              simp [Op.applyPure, SV.ok, SV.den] at *; omega
            | .fst, [a], hb =>
              simp [opBound] at hb; subst hb
              exact sz_fst_le _ _ (hok a (by simp))
            | .snd, [a], hb =>
              simp [opBound] at hb; subst hb
              exact sz_snd_le _ _ (hok a (by simp))
            | .plus, [a, b'], hb =>
              simp [opBound] at hb; subst hb
              exact sz_plus_le _ _ _ _ (hok a (by simp)) (hok b' (by simp))
            | .minus, [a, b'], hb =>
              simp [opBound] at hb; subst hb
              exact sz_minus_le _ _ _ (hok a (by simp))
            | .sz, [a], hb =>
              simp [opBound] at hb; subst hb
              exact sz_sz_le _ _ (hok a (by simp))
            | .subst, [⟨.lit φ, ba⟩, b'], hb =>
              simp [opBound] at hb; subst hb
              exact substV_sz_le _ _ _ (hok b' (by simp))
            | .subst, [⟨.bvar _, _⟩, _], hb | .subst, [⟨.op1 _ _, _⟩, _], hb
            | .subst, [⟨.op2 _ _ _, _⟩, _], hb | .subst, [⟨.op3 _ _ _ _, _⟩, _], hb
            | .subst, [⟨.ite _ _ _, _⟩, _], hb | .subst, [⟨.run _ _ _, _⟩, _], hb =>
              simp [opBound] at hb
            | .eq, [], hb | .eq, [_], hb | .eq, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .lt, [], hb | .lt, [_], hb | .lt, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .pair, [], hb | .pair, [_], hb | .pair, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .plus, [], hb | .plus, [_], hb | .plus, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .minus, [], hb | .minus, [_], hb | .minus, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .subst, [], hb | .subst, [_], hb | .subst, _ :: _ :: _ :: _, hb => simp [opBound] at hb
            | .isPair, [], hb | .isPair, _ :: _ :: _, hb => simp [opBound] at hb
            | .isNat, [], hb | .isNat, _ :: _ :: _, hb => simp [opBound] at hb
            | .fst, [], hb | .fst, _ :: _ :: _, hb => simp [opBound] at hb
            | .snd, [], hb | .snd, _ :: _ :: _, hb => simp [opBound] at hb
            | .sz, [], hb | .sz, _ :: _ :: _, hb => simp [opBound] at hb
            | .check, [], hb | .check, [_], hb | .check, [_, _], hb
            | .check, _ :: _ :: _ :: _ :: _, hb => simp [opBound] at hb
        · contradiction
      · contradiction
    · contradiction

/-- The checker case: `symOp` on `check` with a numeric fuel literal produces the
term whose value is exactly what `eval` computes, and charges at least `f`. -/
theorem symOp_check {args : List SV} {r : SV} {c w : Nat} (ρ : Nat → Val)
    {pv φv : Val} {f : Nat}
    (h : symOp .check args = some ((r, c), w)) (hv : args.map (SV.den ρ) = [pv, φv, .nat f]) :
    r.t.denote ρ = Val.ofBool (check f pv φv) ∧ f ≤ c ∧ r.ok ρ := by
  unfold symOp at h
  simp only [ite_true] at h
  match args, hv with
  | [a, b, e], hv =>
    simp only [List.map, List.cons.injEq, and_true] at hv
    obtain ⟨ha, hb, he⟩ := hv
    simp only [List.length, Op.arity, ite_true, List.map, opTm] at h
    rcases e with ⟨et, eb⟩
    cases et with
    | lit ev =>
      simp [SV.den, Tm.denote] at he; subst he
      simp [opBound, opCost] at h
      obtain ⟨-, ⟨rfl, rfl⟩, -⟩ := h
      refine ⟨?_, Nat.le_refl _, ?_⟩
      · simp [Tm.denote, SV.den] at ha hb ⊢; rw [ha, hb]
      · simp only [SV.ok]; exact Val.sz_ofBool _
    | bvar _ | op1 _ _ | op2 _ _ _ | op3 _ _ _ _ | ite _ _ _ | run _ _ _ =>
      simp [opBound, opCost] at h

end Diag
