import Diag.Semantics

/-!
# M3, part 1: basic lemmas

`log2` facts for the size bounds, the de Bruijn substitution lemmas for the semantics,
and the exact size of `subst`'s result (used by `substBound`).
-/

namespace Diag

/-! ## log2 -/

theorem lt_pow_log2 (m : Nat) : m < 2 ^ (m.log2 + 1) := by
  rcases Nat.eq_zero_or_pos m with rfl | hm
  · simp [Nat.log2_zero]
  · exact (Nat.log2_lt (by omega)).mp (by omega)

theorem log2_mono {m n : Nat} (h : m ≤ n) : m.log2 ≤ n.log2 := by
  rcases Nat.eq_zero_or_pos m with rfl | hm
  · simp [Nat.log2_zero]
  · have h1 := Nat.log2_self_le (n := m) (by omega)
    have h2 := lt_pow_log2 n
    have : 2 ^ m.log2 < 2 ^ (n.log2 + 1) := by omega
    have := (Nat.pow_lt_pow_iff_right (by decide : 1 < 2)).mp this
    omega

theorem log2_add_le (m n : Nat) : (m + n).log2 ≤ max m.log2 n.log2 + 1 := by
  rcases Nat.eq_zero_or_pos (m + n) with h | h
  · rw [h, Nat.log2_zero]; omega
  · have hm : 2 ^ (m.log2 + 1) ≤ 2 ^ (max m.log2 n.log2 + 1) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have hn : 2 ^ (n.log2 + 1) ≤ 2 ^ (max m.log2 n.log2 + 1) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have h1 := lt_pow_log2 m
    have h2 := lt_pow_log2 n
    have hk : m + n < 2 ^ (max m.log2 n.log2 + 1 + 1) := by
      rw [Nat.pow_succ]; omega
    have := (Nat.log2_lt (by omega)).mpr hk
    omega

/-! ## Value sizes -/

@[simp] theorem Val.sz_nat (n : Nat) : (Val.nat n).sz = n.log2 + 1 := by simp [Val.sz]
@[simp] theorem Val.sz_sym (s : String) : (Val.sym s).sz = s.length + 1 := by simp [Val.sz]
@[simp] theorem Val.sz_pair (a b : Val) : (Val.pair a b).sz = a.sz + b.sz + 1 := by simp [Val.sz]

theorem Val.sz_toNat (v : Val) : (Val.nat v.toNat).sz ≤ v.sz := by
  cases v <;> simp [Val.toNat, Nat.log2_zero] <;> exact Nat.succ_le_of_lt (Val.sz_pos _)

theorem Val.sz_ofBool (b : Bool) : (Val.ofBool b).sz ≤ 6 := by
  cases b <;> decide

@[simp] theorem Val.nil_sz : Val.nil.sz = 4 := by decide

/-! ## Assignments -/

/-- The assignment seen by a term after `shift d c`. -/
def shiftAsg (ρ : Nat → Val) (d c : Nat) : Nat → Val :=
  fun i => if i < c then ρ i else ρ (i + d)

/-- The assignment seen by a term after `instAt k s`. -/
def instAsg (ρ : Nat → Val) (k : Nat) (s : Tm) : Nat → Val :=
  fun i => if i < k then ρ i else if i = k then s.denote (fun j => ρ (j + k)) else ρ (i - 1)

theorem shiftAsg_cons (ρ : Nat → Val) (v : Val) (d c : Nat) :
    shiftAsg (Asg.cons v ρ) d (c + 1) = Asg.cons v (shiftAsg ρ d c) := by
  funext i
  cases i with
  | zero => simp [shiftAsg, Asg.cons]
  | succ i =>
    simp only [shiftAsg, Asg.cons]
    by_cases h : i < c
    · simp [h]
    · have : i + 1 + d = (i + d) + 1 := by omega
      simp [h, this]

theorem Tm.denote_shift (d c : Nat) (ρ : Nat → Val) :
    ∀ t : Tm, (t.shift d c).denote ρ = t.denote (shiftAsg ρ d c)
  | .bvar i => by
      unfold Tm.shift shiftAsg
      by_cases h : i < c <;> simp [h, Tm.denote]
  | .lit v => by simp [Tm.shift, Tm.denote]
  | .op1 o a => by simp [Tm.shift, Tm.denote, Tm.denote_shift d c ρ a]
  | .op2 o a b => by
      simp [Tm.shift, Tm.denote, Tm.denote_shift d c ρ a, Tm.denote_shift d c ρ b]
  | .op3 o a b e => by
      simp [Tm.shift, Tm.denote, Tm.denote_shift d c ρ a, Tm.denote_shift d c ρ b,
        Tm.denote_shift d c ρ e]
  | .ite a b e => by
      simp [Tm.shift, Tm.denote, Tm.denote_shift d c ρ a, Tm.denote_shift d c ρ b,
        Tm.denote_shift d c ρ e]
  | .run a b e => by
      simp [Tm.shift, Tm.denote, Tm.denote_shift d c ρ a, Tm.denote_shift d c ρ b,
        Tm.denote_shift d c ρ e]

theorem Fm.denote_shift (d : Nat) :
    ∀ (φ : Fm) (c : Nat) (ρ : Nat → Val), (φ.shift d c).denote ρ ↔ φ.denote (shiftAsg ρ d c)
  | .eq a b, c, ρ => by simp [Fm.shift, Fm.denote, Tm.denote_shift]
  | .fls, c, ρ => by simp [Fm.shift, Fm.denote]
  | .imp a b, c, ρ => by
      simp [Fm.shift, Fm.denote, Fm.denote_shift d a c ρ, Fm.denote_shift d b c ρ]
  | .and a b, c, ρ => by
      simp [Fm.shift, Fm.denote, Fm.denote_shift d a c ρ, Fm.denote_shift d b c ρ]
  | .all a, c, ρ => by
      simp only [Fm.shift, Fm.denote]
      exact forall_congr' fun v => by
        rw [Fm.denote_shift d a (c + 1) (Asg.cons v ρ), shiftAsg_cons]

theorem instAsg_cons (ρ : Nat → Val) (v : Val) (k : Nat) (s : Tm) :
    instAsg (Asg.cons v ρ) (k + 1) s = Asg.cons v (instAsg ρ k s) := by
  funext i
  cases i with
  | zero => simp [instAsg, Asg.cons]
  | succ i =>
    simp only [instAsg, Asg.cons]
    by_cases h1 : i < k
    · simp [h1]
    · by_cases h2 : i = k
      · subst h2
        simp only [Nat.lt_irrefl, ite_false, ite_true]
        congr 1
      · have h3 : ¬ i + 1 < k + 1 := by omega
        have h4 : ¬ i + 1 = k + 1 := by omega
        simp only [h1, h2, h3, h4, ite_false]
        obtain ⟨j, rfl⟩ : ∃ j, i = j + 1 := ⟨i - 1, by omega⟩
        simp

theorem Tm.denote_instAt (k : Nat) (s : Tm) (ρ : Nat → Val) :
    ∀ t : Tm, (Tm.instAt k s t).denote ρ = t.denote (instAsg ρ k s)
  | .bvar i => by
      unfold Tm.instAt instAsg
      by_cases h1 : i < k
      · simp [h1, Tm.denote]
      · by_cases h2 : i = k
        · subst h2
          simp [Tm.denote, Tm.denote_shift]
          unfold shiftAsg
          simp
        · simp [h1, h2, Tm.denote]
  | .lit v => by simp [Tm.instAt, Tm.denote]
  | .op1 o a => by simp [Tm.instAt, Tm.denote, Tm.denote_instAt k s ρ a]
  | .op2 o a b => by
      simp [Tm.instAt, Tm.denote, Tm.denote_instAt k s ρ a, Tm.denote_instAt k s ρ b]
  | .op3 o a b e => by
      simp [Tm.instAt, Tm.denote, Tm.denote_instAt k s ρ a, Tm.denote_instAt k s ρ b,
        Tm.denote_instAt k s ρ e]
  | .ite a b e => by
      simp [Tm.instAt, Tm.denote, Tm.denote_instAt k s ρ a, Tm.denote_instAt k s ρ b,
        Tm.denote_instAt k s ρ e]
  | .run a b e => by
      simp [Tm.instAt, Tm.denote, Tm.denote_instAt k s ρ a, Tm.denote_instAt k s ρ b,
        Tm.denote_instAt k s ρ e]

theorem Fm.denote_instAt (s : Tm) :
    ∀ (φ : Fm) (k : Nat) (ρ : Nat → Val), (φ.instAt k s).denote ρ ↔ φ.denote (instAsg ρ k s)
  | .eq a b, k, ρ => by simp [Fm.instAt, Fm.denote, Tm.denote_instAt]
  | .fls, k, ρ => by simp [Fm.instAt, Fm.denote]
  | .imp a b, k, ρ => by
      simp [Fm.instAt, Fm.denote, Fm.denote_instAt s a k ρ, Fm.denote_instAt s b k ρ]
  | .and a b, k, ρ => by
      simp [Fm.instAt, Fm.denote, Fm.denote_instAt s a k ρ, Fm.denote_instAt s b k ρ]
  | .all a, k, ρ => by
      simp only [Fm.instAt, Fm.denote]
      exact forall_congr' fun v => by
        rw [Fm.denote_instAt s a (k + 1) (Asg.cons v ρ), instAsg_cons]

/-- Instantiation is substitution in the semantics. -/
theorem Fm.denote_inst (φ : Fm) (t : Tm) (ρ : Nat → Val) :
    (φ.inst t).denote ρ ↔ φ.denote (Asg.cons (t.denote ρ) ρ) := by
  unfold Fm.inst
  rw [Fm.denote_instAt]
  have : instAsg ρ 0 t = Asg.cons (t.denote ρ) ρ := by
    funext i
    cases i with
    | zero => simp [instAsg, Asg.cons]
    | succ i => simp [instAsg, Asg.cons]
  rw [this]

/-- Shifting past a fresh variable doesn't change the meaning. -/
theorem Fm.denote_shift_cons (φ : Fm) (v : Val) (ρ : Nat → Val) :
    (φ.shift 1 0).denote (Asg.cons v ρ) ↔ φ.denote ρ := by
  rw [Fm.denote_shift]
  have : shiftAsg (Asg.cons v ρ) 1 0 = ρ := by
    funext i; simp [shiftAsg, Asg.cons]
  rw [this]

/-! ## The size of `subst`'s result -/

theorem Tm.sz_quote_instAt_lit (k : Nat) (v : Val) :
    ∀ t : Tm, (Tm.instAt k (.lit v) t).quote.sz + t.occ k * Val.nil.sz =
      (Tm.instAt k (.lit Val.nil) t).quote.sz + t.occ k * v.sz
  | .bvar i => by
      unfold Tm.instAt Tm.occ
      by_cases h1 : i < k
      · have : i ≠ k := by omega
        simp [h1, this]
      · by_cases h2 : i = k
        · subst h2; simp [Tm.shift, Tm.quote, Val.ofList, Val.nil]; omega
        · simp [h1, h2]
  | .lit w => by simp [Tm.instAt, Tm.occ]
  | .op1 o a => by
      have := Tm.sz_quote_instAt_lit k v a
      simp [Tm.instAt, Tm.occ, Tm.quote, Val.ofList] at *; omega
  | .op2 o a b => by
      have := Tm.sz_quote_instAt_lit k v a
      have := Tm.sz_quote_instAt_lit k v b
      simp [Tm.instAt, Tm.occ, Tm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .op3 o a b e => by
      have := Tm.sz_quote_instAt_lit k v a
      have := Tm.sz_quote_instAt_lit k v b
      have := Tm.sz_quote_instAt_lit k v e
      simp [Tm.instAt, Tm.occ, Tm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .ite a b e => by
      have := Tm.sz_quote_instAt_lit k v a
      have := Tm.sz_quote_instAt_lit k v b
      have := Tm.sz_quote_instAt_lit k v e
      simp [Tm.instAt, Tm.occ, Tm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .run a b e => by
      have := Tm.sz_quote_instAt_lit k v a
      have := Tm.sz_quote_instAt_lit k v b
      have := Tm.sz_quote_instAt_lit k v e
      simp [Tm.instAt, Tm.occ, Tm.quote, Val.ofList, Nat.add_mul] at *; omega

theorem Fm.sz_quote_instAt_lit (v : Val) :
    ∀ (φ : Fm) (k : Nat), (φ.instAt k (.lit v)).quote.sz + φ.occ k * Val.nil.sz =
      (φ.instAt k (.lit Val.nil)).quote.sz + φ.occ k * v.sz
  | .eq a b, k => by
      have := Tm.sz_quote_instAt_lit k v a
      have := Tm.sz_quote_instAt_lit k v b
      simp [Fm.instAt, Fm.occ, Fm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .fls, k => by simp [Fm.instAt, Fm.occ]
  | .imp a b, k => by
      have := Fm.sz_quote_instAt_lit v a k
      have := Fm.sz_quote_instAt_lit v b k
      simp [Fm.instAt, Fm.occ, Fm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .and a b, k => by
      have := Fm.sz_quote_instAt_lit v a k
      have := Fm.sz_quote_instAt_lit v b k
      simp [Fm.instAt, Fm.occ, Fm.quote, Val.ofList, Nat.add_mul] at *; omega
  | .all a, k => by
      have := Fm.sz_quote_instAt_lit v a (k + 1)
      simp [Fm.instAt, Fm.occ, Fm.quote, Val.ofList] at *; omega

end Diag
