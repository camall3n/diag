import Diag.Game

/-!
# M8: the necessity theorem (FROM_APP #12, #13)

**Abstract core.** In any open-source game with opponents `B φ` that cooperate exactly
when the propositional formula φ is satisfiable, and where satisfiability yields a short
proof that `B φ` cooperates, an agent that is both *fair* (it cooperates whenever a short
proof exists that the opponent cooperates with it) and *unexploitable* (it cooperates only
with opponents that cooperate back) plays C against `B φ` exactly when φ is satisfiable.
So computing its move decides SAT.

**Paper statement** (on paper only; complexity classes are not formalized here). Suppose
φ ↦ B_φ is computable in polynomial time (so |B_φ| is polynomial in |φ|) and the agent is
deterministic. Then: if P ≠ NP, no deterministic agent running in time polynomial in its
opponent's size is both fair and unexploitable. This uses P ≠ NP only. It claims no
exponential lower bound and makes no use of ETH. Without a time bound, a fair and
unexploitable agent can exist (see the toy instance below), so the theorem is about
*cost*, not impossibility.

**Caveats.**
1. *Fairness is relative to a proof system P* (`Short` = "a short P-proof exists"). The
   theorem holds for any P satisfying (ii), `hShort`. That includes PA and every system that
   efficiently simulates PA: a stronger system is a stronger demand, because if P′
   efficiently simulates P, then P′-fair ⇒ P-fair. In PA, (ii) holds via a general lemma
   ("if some assignment satisfies φ, the search returns C"), proved once by induction, plus
   the witness and its check. **Whether (ii) holds for our object logic S is open.** We don't
   know that short S-proofs of "B_φ cooperates" are missing. We only know that the obvious
   routes in S (`eval`/`symRun`) cost about as much as the search itself, and ruling out
   short S-proofs would be a proof-complexity lower bound we don't have. Our standards K and
   K′ are not "fair" in this sense, whatever the proof system: they demand a certificate of
   one specific statement, not cooperation with every opponent that has a short proof of
   cooperating.
2. *The hard opponents are slow*: B_φ runs an exhaustive search. The theorem concerns
   the agent's cost of deciding its move against them.
-/

namespace Diag.Necessity

/-- An abstract open-source game with a family of opponents `B φ` indexed by formulas. -/
structure Setting where
  Prog    : Type
  Formula : Type
  SAT     : Formula → Prop
  /-- `outcome a b`: a's move against b. -/
  outcome : Prog → Prog → Move
  /-- "A proof of length ≤ p(|b|) exists that b cooperates with a". The polynomial length
  bound is built into this predicate. -/
  Short   : Prog → Prog → Prop
  B       : Formula → Prog
  /-- (i) `B φ` ignores its opponent and plays C iff φ is satisfiable. -/
  hB      : ∀ φ a, outcome (B φ) a = .C ↔ SAT φ
  /-- (ii) Satisfiable ⇒ a short proof that `B φ` cooperates exists. -/
  hShort  : ∀ φ a, SAT φ → Short a (B φ)
  /-- `Short` means a *true* short proof of cooperation: it is sound. The necessity proof
  never uses this field. It is there so that `Fair` reads honestly ("cooperate with whoever
  provably, and therefore actually, cooperates with me"). -/
  hSound  : ∀ a b, Short a b → outcome b a = .C

namespace Setting
variable (S : Setting)

/-- Fair: cooperate with every opponent with a short proof that it cooperates with you. -/
def Fair (a : S.Prog) : Prop := ∀ b, S.Short a b → S.outcome a b = .C

/-- Unexploitable: play C only against opponents that play C back. -/
def Unexploitable (a : S.Prog) : Prop := ∀ b, S.outcome a b = .C → S.outcome b a = .C

/-- **Necessity.** A fair, unexploitable agent's move against `B φ` decides SAT(φ). -/
theorem necessity (a : S.Prog) (hf : S.Fair a) (hu : S.Unexploitable a) (φ : S.Formula) :
    S.outcome a (S.B φ) = .C ↔ S.SAT φ :=
  ⟨fun h => (S.hB φ a).mp (hu _ h), fun h => hf _ (S.hShort φ a h)⟩

/-- Decision form: the boolean "a plays C against `B φ`" equals the boolean SAT(φ). -/
theorem necessity_decide (a : S.Prog) (hf : S.Fair a) (hu : S.Unexploitable a)
    (φ : S.Formula) [Decidable (S.SAT φ)] :
    decide (S.outcome a (S.B φ) = .C) = decide (S.SAT φ) := by
  rw [Bool.eq_iff_iff]
  simp only [decide_eq_true_eq]
  exact S.necessity a hf hu φ

end Setting

/-! ## Non-vacuity: a tiny concrete instance (all hypotheses hold together) -/

/-- Toy programs: one agent, and an opponent `b φ` for each "formula" φ : Bool. -/
inductive TProg | agent | b (φ : Bool)

def toutcome : TProg → TProg → Move
  | .b φ, _ => if φ then .C else .D
  | .agent, .b φ => if φ then .C else .D
  | .agent, .agent => .C

def toy : Setting where
  Prog := TProg
  Formula := Bool
  SAT φ := φ = true
  outcome := toutcome
  Short a b := toutcome b a = .C          -- "a (trivially short) proof exists" ↔ true
  B := .b
  hB φ a := by cases φ <;> simp [toutcome]
  hShort φ a h := by subst h; simp [toutcome]
  hSound _ _ h := h

/-- In the toy setting, the agent is fair and unexploitable (no time bound there, so this
doesn't contradict the paper statement), and the necessity theorem applies. -/
theorem toy_agent_fair : toy.Fair .agent := by
  intro b h
  cases b with
  | agent => rfl
  | b φ => exact h

theorem toy_agent_unexploitable : toy.Unexploitable .agent := by
  intro b h
  cases b with
  | agent => rfl
  | b φ => cases φ <;> simp_all [toy, toutcome]

example : toy.outcome .agent (toy.B true) = .C ↔ toy.SAT true :=
  toy.necessity .agent toy_agent_fair toy_agent_unexploitable true

#print axioms Diag.Necessity.Setting.necessity
#print axioms Diag.Necessity.Setting.necessity_decide
#print axioms Diag.Necessity.toy_agent_fair
#print axioms Diag.Necessity.toy_agent_unexploitable

end Diag.Necessity
