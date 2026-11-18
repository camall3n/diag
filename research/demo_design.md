# A practical demo: LLMs generating provably cooperating programs

**Goal.** Show that an LLM can write a program *and* a machine-checkable certificate, such that any two certified programs provably cooperate, and no certified program can be exploited. The coordination is a shared standard fixed in advance. No referee runs at play time: each agent checks the other's certificate locally. Every guarantee rests on the soundness (or consistency) of a checker, and nothing else.

**Status of this environment.** Lean 4 can't be installed here. The `elan` installer downloads from GitHub, but the toolchain host `release.lean-lang.org` is refused by the network policy (403), and I didn't try to work around that. GHC isn't installed either. So this document is a design plus a build plan, and there's no compiled prototype.

---

## 0. Existing work and code

| What | Status | Reusable? |
|---|---|---|
| Duclaux, Formenti, Cobben, Schölkopf, Jin, *Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean* (ICML 2026 workshop; OpenReview Wc5TAIUC8k) | Lean 4 outcome theorems for 9 bots; an agentic pipeline that turns natural-language strategy descriptions into Lean-verified outcome theorems, reproving 40 of 45 | **Evidence that LLMs can produce this kind of proof.** No public repository was linked on the ICML page. The proofs are *offline outcome analyses*, not certificates that agents check at play time. |
| `digama0/lean4lean` | The Lean kernel written in Lean; active (last commit Oct 2026); its metatheory and verification are partial | It's an in-Lean checker for option (b). There's no full soundness proof, so it can't remove trust. |
| `machine-intelligence/provability` (MIRI modal agents) | Haskell, about 3.3k lines, last commit 2015; GL fixed-point solver | A baseline for option (c). |
| *Lean-Verified Handshake* (ICML 2026, OpenReview aBuH5q4WxK) | A commitment wrapper in Lean | It assumes a `TrustedOracle` typeclass, a trusted party, which is exactly what we want to avoid. |

---

## 1. The key simplification

**What changed from CertBot.** CertBot (`certbot_theorem.md`) needed *handed proofs*, one per opponent, because its object theory $S$ was PA-strength and the only thing assumed about it was consistency. That only makes *bounded* sentences trustworthy, so every guarantee had to be reduced to bounded, per-opponent facts.

**The simplification.** If $S$ is a *small* object logic whose **soundness is proved** in a stronger metatheory, here Lean, then a certificate for the universal statement "my mover cooperates with exactly the certified opponents" can be trusted directly. The standard then needs no handed proofs and no Löb:

$$K(z) \;:\equiv\; \forall y\,\forall \kappa'\ \Big(\mathrm{Run}\big(z, \langle y, \kappa'\rangle\big) = C \;\leftrightarrow\; \mathrm{Check}\big(\kappa',\ \mathrm{Sub}(\ulcorner K\urcorner, y)\big)\Big)$$

In words: "I cooperate with an opponent exactly when its certificate is a valid proof that it satisfies this same standard."

**Why the self-reference is harmless.** $K$ refers to its own code $\ulcorner K\urcorner$. In a *deep embedding*, where formulas are Lean data, that's built by an ordinary Lean function `diag`, as in the diagonal lemma. No program contains its own numeral: programs contain the fixed constant $\ulcorner K\urcorner$, and certificates, kept outside the code, contain the program's numeral.

**The Löb trap, and why we avoid it.** If the *same* system whose checker appears in $K$ also contained the axiom "if my checker accepts a proof of $K(y)$, then $K(y)$," then by Löb it would prove $K(y)$ for *every* $y$, including DefectBot. That makes it unsound. The fix is to keep two levels. $S$, the object logic, holds the certificates. Lean, the metatheory, proves that $S$ is sound. Lean never reflects on itself.

---

## 2. Option (a), recommended: a small object logic, deep-embedded in Lean

### 2.1 The pieces

1. **A DSL and a fuel-bounded interpreter.** A tiny first-order functional language over strings and naturals: `let`, `if`, string operations, function calls, and two primitives, `check(p, φ, f)` and `sub(φ, n)`. `run : Fuel → Code → Args → Option Value` is a total Lean function. *Why fuel:* every program halts, and a sandboxed opponent can't hang you.
2. **The game.** An entry is (code, certificate). The outcome is `(run T₂ A.mover ⟨B, κ_B⟩, run T₂ B.mover ⟨A, κ_A⟩)`. Anything other than `C` within the fuel counts as `D`.
3. **The object logic $S$.** First-order formulas over strings and naturals, with function symbols interpreted as the Lean functions `Run`, `Check`, `Sub` and the string operations. The rules:
   - ordinary first-order rules (∀-introduction and elimination, propositional reasoning, equality);
   - an **evaluation rule**: a *closed* atomic equation may be asserted if Lean's evaluator confirms it within a fuel bound;
   - a **symbolic-run rule**: $\mathrm{Run}(c, \vec x) = e$, where $e$ is the partial evaluation of the code literal $c$ on variable inputs, computed by the checker;
   - a few axioms about `ite` and $C \ne D$.
4. **The checker.** `check : Fuel → Proof → Formula → Bool`, a Lean function. *Why fuel here too:* a proof could otherwise ask the checker to evaluate `Check` on itself and never stop.
5. **Semantics and soundness, a Lean theorem.**
$$\mathtt{check}\ f\ p\ \varphi = \mathtt{true} \;\Rightarrow\; [\![\varphi]\!]$$
Here `Check` is interpreted as the very Lean function `check`. The proof is by induction on fuel and on the proof. This is the core of the build, and the only place where real metatheory happens.
6. **The standard $K$.** A concrete `Formula` value built with `diag`. Inside $K$, "$\ulcorner K\urcorner$" isn't a literal string, because $K$ can't contain its own code. It's a short term $\delta$, of the form `sub(c, c)`, that *evaluates* to $\ulcorner K\urcorner$, as in the diagonal lemma. Two Lean lemmas go with it: $\delta$ evaluates to $\ulcorner K\urcorner$, and `sub ⌜K⌝ y` is exactly $K(y)$. CertBot's certificate uses one evaluation step to identify the literal $\ulcorner K\urcorner$ in its code with $\delta$.
7. **CertBot.** Its mover is `if check(κ', sub(⌜K⌝, y), F) then C else D`, which contains the fixed constant $\ulcorner K\urcorner$.

### 2.2 The meta-theorems, proved in Lean with no `native_decide`

- **Theorem A (members cooperate).** If $\mathtt{check}\ \kappa_A\ (K\,A)$ and $\mathtt{check}\ \kappa_B\ (K\,B)$, then the outcome is $(C, C)$.
  *Proof:* soundness gives $[\![K\,A]\!]$. Instantiate at $(B, \kappa_B)$: A plays C iff $\kappa_B$ checks, which it does. B symmetrically.
- **Theorem B (unexploitable).** If $\kappa_A$ checks and A plays C, then B plays C.
  *Proof:* A plays C, so $\kappa_B$ checks as a proof of $K(B)$. Soundness gives $[\![K\,B]\!]$, so B plays C iff $\kappa_A$ checks, which it does.

**What the guarantees rest on:** Lean's kernel, which checks these proofs, and the correspondence between the Lean functions that run at play time and those in the semantics. They're literally the same functions.

### 2.3 What the LLM has to produce

- **Agent code** in the DSL, in any style: CertBot itself, refactored versions, agents with helper functions, caching, or other internal structure.
- **A certificate**, an $S$-proof of $K(z)$ for that code. For CertBot this is about five steps: ∀-introduction, symbolic run, the `ite` lemma. For agents with different code it needs real reasoning: case splits, lemmas about helpers, equivalence of control flow.
- **Nothing else.** The standard, the checker, and the meta-theorems are written once by people, verified in Lean, and shared.

The LLM works in a loop with the checker, which gives a yes/no answer plus where the proof fails. An adversarial test: ask an LLM to write an agent that defects in some case and still certify it. The checker should reject every attempt, and by Theorem B, no certified agent can exploit a member.

### 2.4 Where a hidden cheat could creep in

| Risk | Guard |
|---|---|
| A reflection axiom about the system's own checker (the Löb trap) | $S$ and the metatheory are separate. $S$ has no reflection rule. |
| A checker that never halts, for example when a proof makes it check itself | Fuel in `check`; soundness is proved by induction on fuel |
| `native_decide` or `#eval` used inside the meta-theorems | Forbidden there; compiled evaluation is allowed only at play time |
| The runtime interpreter differs from the one in the semantics | Use one Lean function `run` for both |
| `sub ⌜K⌝ y` isn't exactly $K(y)$ | A Lean lemma |
| A certificate stored inside the code it describes | Certificates are attached data, as in CertBot §1.1 |
| A referee creeping in, such as a central registry | None. Each mover calls `check` locally. The shared items are the language's interpreter and checker: a standard, not a party. |
| Inconsistent fuel constants | Mover fuel $T_2 \ge$ the fuel needed to call `check` with fuel $F$, plus overhead, stated as a lemma |

### 2.5 Size and effort estimates (to be measured)

- Lean code: DSL and interpreter about 200 lines; $S$ and checker about 400; semantics and soundness about 500–900, which is the hard part; $K$, `diag`, and the meta-theorems about 200; examples about 200. That's roughly 1.5–2k lines in total.
- Certificates: tens of proof steps for simple agents, more for creative ones. Checking them takes milliseconds.
- Play-time cost: one `check` per side, polynomial in the certificate size.

---

## 3. Option (b): Lean itself as the object logic

**The idea.** Certificates are real Lean proofs, where LLMs are strongest, checked at play time by a Lean kernel.

**The difficulties, honestly stated:**

1. **$K$ has to talk about a checker as a function.** In Lean, that means an in-Lean kernel, `lean4lean`, applied to an environment that contains $K$'s own declaration as data. It's doable, but intricate.
2. **The Löb trap.** A meta-theorem needs "if the kernel accepts a proof of $K(y)$, then $K(y)$." Stated as an axiom *of the same system the kernel checks*, Löb makes it prove $K(\mathrm{DefectBot})$, which is unsound. The honest version has two levels: certificates are proofs in *base* Lean, and the guarantee is proved in "Lean + soundness of base Lean for this family," which is consistent if Lean is sound.
3. **There's no proof that lean4lean is faithful.** The trust would be "lean4lean implements a sound kernel," which is currently an assumption.

**Verdict:** this is the most attractive option for LLM tooling, but it has the most moving parts and the most room for subtle mistakes. It's a good *second* step, once (a) works.

---

## 4. Option (c): modal agents as a baseline

**The idea.** Agents are formulas of provability logic GL. Each agent runs the GL fixed-point solver, MIRI's 2015 Haskell code, on the pair of formulas to work out the outcome. The LLM writes modal agents.

- **Guarantee:** correctness of the solver, which is unverified, plus the Kripke-semantics theorems.
- **No certificates or standard** beyond "submit a modal formula."
- **Limitation:** agents are restricted to modal formulas, and the solver is unverified. It's a useful sanity baseline, and it shows the "restrict the agents" route next to the "share a standard" route.

---

## 5. Recommendation and build plan

**Build option (a), with the membership standard $K$ from §1.** It's the smallest design that is fully honest: the guarantees are Lean theorems, there's no referee, and no step in it is taken on trust.

1. **Milestone 1:** the DSL, the fueled interpreter, and the game. Run DefectBot against CooperateBot.
2. **Milestone 2:** $S$'s syntax, proof objects, and the fueled checker. Check toy proofs.
3. **Milestone 3:** semantics and the soundness theorem, with no `sorry` and no `native_decide`. *This is the critical milestone.*
4. **Milestone 4:** `diag`, $K$, the substitution lemma, and Theorems A and B.
5. **Milestone 5:** CertBot and its certificate. Play the standard tournament: CertBot against itself, DefectBot, CooperateBot, forged certificates.
6. **Milestone 6, the LLM loop:** prompt an LLM for (a) varied members (refactored, differently structured) together with certificates, and (b) adversarial attempts. Report how often members are certified, the certificate sizes, and that every adversarial attempt is rejected.
7. **Optional extensions:**
   - a one-directional standard ("if certified, I cooperate") with unexploitability certified separately, which lets members also cooperate with honest non-members;
   - the CertBot handed-proof variant, for PA-strength $S$ with consistency as the only assumption;
   - option (b).

**What it demonstrates:** with a standard engineered in advance, an LLM can produce programs together with proofs, any two such programs provably cooperate, none can be exploited, and play is fast. Every guarantee is machine-checked once, at the level of the standard.
