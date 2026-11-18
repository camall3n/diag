import Diag.Sound.SymEval

/-!
# M8b-2a: the invariant that replaces the cap V

Every operation is charged its result's size (`spendOp`), so a value can only be as large
as the fuel spent building it. `eval_sz_le`: if the fuel, the environment's values and the
program's literals are all bounded by `B` (with `B ≥ 6`, the size of a boolean), then every
value `eval` returns is bounded by `B`. So no program, and no certificate evaluated by the
checker, can build values larger than its fuel and its inputs, even with heavy sharing.
-/

namespace Diag

mutual
/-- All literals in an expression have size ≤ `B`. -/
def Expr.LitsLe (B : Nat) : Expr → Prop
  | .var _ => True
  | .lit v => v.sz ≤ B
  | .op _ es => Expr.LitsLeList B es
  | .ite c t e => c.LitsLe B ∧ t.LitsLe B ∧ e.LitsLe B
  | .let_ _ e b => e.LitsLe B ∧ b.LitsLe B
  | .call _ es => Expr.LitsLeList B es
def Expr.LitsLeList (B : Nat) : List Expr → Prop
  | [] => True
  | e :: es => e.LitsLe B ∧ Expr.LitsLeList B es
end

/-- All literals in all function bodies have size ≤ `B`. -/
def Program.LitsLe (p : Program) (B : Nat) : Prop :=
  ∀ f ps body, p.lookup f = some (ps, body) → body.LitsLe B

def EnvLe (B : Nat) (env : Env) : Prop := ∀ x w, (x, w) ∈ env → w.sz ≤ B

theorem envLe_lookup {B : Nat} {env : Env} (h : EnvLe B env) (h6 : 6 ≤ B) (x : String) :
    ((env.lookup x).getD Val.nil).sz ≤ B := by
  cases hl : env.lookup x with
  | none => simp; omega
  | some w => simpa using h x w (mem_of_lookup x env w hl)

def SizeOK (p : Program) (B k : Nat) : Prop :=
  (∀ env e v (r : Fin k), eval p k env e = some (v, r) → EnvLe B env → e.LitsLe B → v.sz ≤ B) ∧
  (∀ env es vs (r : Fin (k + 1)), evalList p k env es = some (vs, r) → EnvLe B env →
    Expr.LitsLeList B es → ∀ v ∈ vs, v.sz ≤ B)

theorem eval_sz_le_all (p : Program) (B : Nat) (h6 : 6 ≤ B) (hp : p.LitsLe B) :
    ∀ k, k ≤ B → SizeOK p B k := by
  intro k
  induction k using Nat.strongRecOn with
  | _ k ih =>
  intro hkB
  constructor
  · intro env e v r h henv he
    cases k with
    | zero => simp [eval] at h
    | succ n =>
    cases e with
    | var x =>
      rw [eval] at h; simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h; exact envLe_lookup henv h6 x
    | lit w =>
      rw [eval] at h; simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h; exact he
    | op o es =>
      rw [eval] at h
      split at h; · contradiction
      rename_i vs m hl
      split at h
      · split at h
        · simp only [Option.some.injEq, Prod.mk.injEq] at h
          obtain ⟨rfl, -⟩ := h; exact Nat.le_trans (Val.sz_ofBool _) h6
        · contradiction
      · obtain ⟨rfl, hc, -⟩ := (spendOp_some h)
        have := m.isLt
        omega
    | ite c t e =>
      rw [eval] at h
      split at h; · contradiction
      rename_i b m hc
      split at h; · contradiction
      rename_i w r' hb
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      obtain ⟨_, ht, hee⟩ := he
      exact (ih m.val (by omega) (by omega)).1 env _ _ r' hb henv (by split <;> assumption)
    | let_ x e0 b =>
      rw [eval] at h
      split at h; · contradiction
      rename_i w m he0
      split at h; · contradiction
      rename_i w' r' hb
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      obtain ⟨hle0, hleb⟩ := he
      have hw := (ih n (by omega) (by omega)).1 env e0 w m he0 henv hle0
      refine (ih m.val (by omega) (by omega)).1 ((x, w) :: env) b _ r' hb ?_ hleb
      intro y u hm
      rcases List.mem_cons.mp hm with heq | hm'
      · simp at heq; obtain ⟨-, rfl⟩ := heq; exact hw
      · exact henv y u hm'
    | call f es =>
      rw [eval] at h
      split at h; · contradiction
      rename_i vs m hl
      have hvs := (ih n (by omega) (by omega)).2 env es vs m hl henv he
      split at h
      · simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h; simp; omega
      · rename_i ps body hf
        split at h; · contradiction
        rename_i w' r' hb
        simp only [Option.some.injEq, Prod.mk.injEq] at h
        obtain ⟨rfl, -⟩ := h
        refine (ih m.val (by omega) (by omega)).1 (ps.zip vs) body _ r' hb ?_ (hp f ps body hf)
        intro y u hm
        exact hvs u (List.of_mem_zip hm).2
  · intro env es vs r h henv hes
    cases es with
    | nil =>
      rw [evalList] at h; simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h; simp
    | cons e es =>
      cases k with
      | zero => simp [evalList] at h
      | succ n =>
      rw [evalList] at h
      split at h; · contradiction
      rename_i v m he
      split at h; · contradiction
      rename_i vs' r' hes'
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      obtain ⟨rfl, -⟩ := h
      obtain ⟨hle, hles⟩ := hes
      have hv := (ih n (by omega) (by omega)).1 env e v m he henv hle
      have hvs := (ih m.val (by omega) (by omega)).2 env es vs' r' hes' henv hles
      intro u hu
      rcases List.mem_cons.mp hu with rfl | hu'
      · exact hv
      · exact hvs u hu'

/-- **The size invariant.** If the fuel, the environment and the program's literals are all
bounded by `B ≥ 6`, then every value `eval` returns is bounded by `B`. -/
theorem eval_sz_le (p : Program) (B : Nat) (h6 : 6 ≤ B) (hp : p.LitsLe B)
    (fuel : Nat) (hf : fuel ≤ B) (env : Env) (henv : EnvLe B env) (e : Expr) (he : e.LitsLe B)
    (v : Val) (r : Fin fuel) (h : eval p fuel env e = some (v, r)) : v.sz ≤ B :=
  (eval_sz_le_all p B h6 hp fuel hf).1 env e v r h henv he

#print axioms Diag.eval_sz_le

end Diag
