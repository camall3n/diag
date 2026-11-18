# Paper skeleton: feasible, verified cooperation between source-aware agents

*Built with the modes and argument-skeleton skills. §1 was written in **open mode**. At the marker before §2 I **shifted to closed mode** to build and audit the skeleton.*

---

## 1. Candidate framings (open mode)

**F1. "Feasibility forces conventions."** The paper opens with the theorem: if P ≠ NP, no polynomial-time agent is both fair and unexploitable. So FairBot's cost is intrinsic, not a weakness of its algorithm. A feasible agent has to restrict whom it cooperates with to a class it can decide quickly. The natural class is opponents who *supply the witness*. We build that standard, machine-check it, and show LLMs can join it.
*Strongest objection:* the theorem only shows that you must *restrict*. It doesn't show that you must *agree*. A single agent could restrict unilaterally, say to "opponents whose cooperation a fixed tactic can prove," with no agreement at all. Also, the hard opponents are slow, and fairness needs a proof system with induction, which is not our setting.

**F2. "Proof-carrying code meets program equilibrium."** This is the engineering story. Agents *check* certificates instead of *searching* for proofs. A self-referential standard K is closed by the diagonal lemma, trust sits one level up as in foundational PCC, and everything is done in Lean, with LLM-generated members.
*Strongest objection:* "This is a convention, and gRR proposed it in about 2010–12. cousin_it already pointed out that differently encoded versions won't interoperate." Novelty would then rest on execution.

**F3. "Where the loop lives."** This is the conceptual story. Making proofs *obligatory and explicit* moves the self-reference from what is *proved*, where Löb and search are needed, to what is *defined*, where the diagonal lemma suffices. The price is precise: existence-based standards are robust to encoding (fixed points are unique up to provable equivalence, de Jongh–Sambin), and explicit-certificate standards are not, though they gain feasibility.
*Strongest objection:* the trade-off is argued, not proved. "Robustness to encoding is lost" is an observation plus a citation, not a theorem about our system.

**F4. Deflationary.** "We give a feasible, machine-checked instance of gRR's informal idea, with LLM-written members." That's honest, and it's a workshop paper.
*Strongest objection:* "incremental."

*A stepping stone I don't adopt as the framing:* membership is a *recursive type*, certificates are *typing derivations*, CertBot *type-checks* where FairBot *infers*, and the diagonal lemma plays the role of the fixed point that defines a recursive type. It may make a good explanatory analogy in the introduction.

**Pick: F1 as the spine, F3 as the conceptual core, F2 as the content, and F4's honesty in the limitations.** F1 gives the paper a reason to exist that survives "it's just a convention", but only if the gap between "restrict" and "agree" is closed (see §2, P4). F3 is the intellectual payoff that reviewers from logic will value. The weak joint is therefore known in advance, and the skeleton is built around it.

*— shifted to closed mode here —*

---

## 2. The skeleton (proof sketch)

**THEOREM (paper-level).** Feasible, unexploitable, proof-based cooperation between independently written agents needs a shared standard about who supplies the witness. A certificate standard closed by the diagonal lemma, with trust placed one level up, achieves it. Its guarantees are machine-checked, and LLMs can produce members.

Status tags: **[MC]** machine-checked in Lean (standard axioms only) · **[A]** argued on paper · **[E]** empirical · **[C]** conjectured · **[T]** trusted assumption.

| # | Premise | Justification | Depends on | Status |
|---|---|---|---|---|
| P1 | Löbian (FairBot-style) cooperation requires *finding* a proof. Its exhaustive search costs about $\lvert\Sigma\rvert^{B}$, which is infeasible at realistic $B$ ($2^{128}$ steps covers $B \approx 28$). | Critch 2019 (with the "⊢" fix); our estimates; Levine's MAIS-O1 | n/a | [A] |
| P2 | **Necessity.** If P ≠ NP, no polynomial-time agent is both fair (cooperates whenever a polynomial-length proof of the opponent's cooperation exists) and unexploitable. | Reduction from SAT through $B_\varphi$. The abstract core is milestone M8 [MC, pending]; the complexity step is [A]. | the proof system has induction | [A]→[MC] |
| P3 | So any feasible, unexploitable agent has to cooperate with an *efficiently decidable* subclass of the "provably cooperative" opponents. | Restating P2: the agent's cooperate-set is a polynomial-time set | P2 | [A] |
| **P4** | **Two independently designed agents mutually cooperate only if each falls in the other's decidable class. Guaranteeing that for *unknown* counterparts requires a shared class: an agreement. The natural maximal choice is "the opponent supplies an NP-witness of its own cooperation", in other words certificates.** | The find/check asymmetry of NP. Shown by examples (TemplateBot, CacheBot); not proved in general. | P3 | **[A]/[C]** |
| P5 | Naive certificates fail: mutual verification regresses, self-certification is circular ($\vdash t{:}\varphi\to\varphi$ only through proofs as long as $t$), and reflection over *variable* proofs is the Löb trap (it would certify DefectBot). | Our notes; LP's explicit reflection versus □-reflection | n/a | [A] |
| P6 | Standard $K(z)$: "within the caps, I cooperate ⟺ the opponent's certificate checks as a proof of $K(\text{opponent})$", defined by the diagonal lemma. One-way variant $K'$. | `diag_eval`, `member_denote`, `memberP_denote` | n/a | [MC] |
| P7 | The small system $S$ is sound, and the evaluation rule asserts only *equations* about `check`, so there is no reflection. | `infer_sound`, `check_sound`; `#print axioms` gives the standard three | n/a | [MC] |
| P8 | Members cooperate (A, A′). Members are unexploitable (B), and cautious $K'$-members are too (B′, in semantic and certified forms). | `theoremA/B/A'/B'`, `theoremB'_sem` | P6, P7 | [MC] |
| P9 | $K$ is closed and $K'$ is open: no program is a member of both, given a certified CooperateBot. | `exclusivity` | P6, P7 | [MC] |
| P10 | Play is fast: certificates of about 1.7k–50k, checker fuel of at most about 180k, about 5 ms per game, about 57 ms for 100 moves. Agents in different styles, with helpers, lets and swapped branches, are certified. | M2, M5 and M6 runs | P6–P8 | [E] |
| P11 | An LLM can write members together with certificates (8/8, 6 on the first attempt), and the checker rejects every adversarial attempt (0/6 accepted). | M6, `m6/results.json` (uncurated) | P7 | [E]; generator not independent |
| P12 | Runtime certificate checks run compiled code; the open-source model assumes the code run is the code shown. | Lean compiler trust; attestation could supply the second | n/a | [T] |

**COUNTERS.**
- **C1, "it's just a convention / a CliqueBot."** Bears on P4 and P6. *Answer:* P2–P4 (no convention-free feasible option) and P8 (membership is behavioral, and Theorem A holds whatever the movers are).
- **C2, "gRR proposed this in about 2010–12."** Bears on novelty, not on any premise. *Answer:* the precursor was informal, unresolved (circular, with no proof provenance) and abandoned. We supply P5–P11.
- **C3, "different encodings won't interoperate" (cousin_it).** Bears on P4 and P6. *Answer:* we **concede** it and sharpen it into the F3 trade-off (existence-based standards are robust to encoding but infeasible; explicit ones are feasible but syntactic), and point to network effects.
- **C4, "the necessity theorem is in a different setting"** (slow opponents, induction needed). Bears on P2's link to P6–P8. *Answer:* the theorem constrains *any* agent in Critch's setting, CertBot included. CertBot escapes because it is unfair by design. State both settings explicitly.
- **C5, "the LLM evidence isn't independent."** Bears on P11. *Answer:* an independent-model run through the API backend (still missing).

C1 and C3 bear on the *same* premise, P4, in parallel. Under the skill's convergence test, that is redundant pressure on one joint.

**LOAD-BEARING WALL: P4, the step from "must restrict" (P3) to "must agree on witness-supplying" (P4).** The paper's claim to be more than "PCC applied to the Prisoner's Dilemma" survives C1 *if and only if* P4 holds. P2 alone answers "why not FairBot" but not "why a *standard*". **Logical and rhetorical weight diverge.** A draft would naturally spend its energy on P6–P8, the impressive Lean construction, but those establish that the convention *works*, not why one is *needed*. The wall is P4, which is currently argued and not proved.

**LEMMA (reflexivity: do our demolition charges destroy our own proposal?)**
- The *search* charge (P1, P2): CertBot never searches, and its per-move cost is bounded by fuel ([MC] caps, [E] timings). ✓
- The *regress, self-certification and Löb trap* charges (P5): obligations go through fixed certificates, the loop is definitional (diag), and $S$ has no reflection over variable proofs. ✓ [MC]
- The *syntactic-compatibility* charge (C3) **does apply to us.** The lemma holds only partially, and the paper must say so. The mitigation, network effects plus exclusivity showing that bridges must be designed in, is a *BUT*, not a refutation.
- The *necessity* charge (P2): it doesn't apply, because CertBot gives up fairness on purpose. That is the point of P3 and P4. ✓

---

## 3. But/therefore audit of the section order

Draft order: Intro · Background · Construction · Theorems · Implementation · LLM · Related work · Limitations.

| Joint | Connective | Fix |
|---|---|---|
| Background → Construction | **AND** (dead) | Insert the necessity section between them. Background ends: Löbian cooperation is elegant **BUT** needs search (P1). **THEREFORE** we ask whether search is avoidable (§3). |
| Necessity → certificates | **AND** (slack ligament: "must restrict" *and* "we use certificates") | Make P4 explicit: **THEREFORE** the agents must agree on a decidable class, and the canonical one is "supplies a witness". *This is the same joint the Lamport pass flagged as the load-bearing wall. Convergence: both lenses land on P4.* |
| Certificates → Construction | should be **BUT** | Naive certificates regress or self-certify, or fall into the Löb trap (P5), **THEREFORE** the diagonal-lemma standard and the two-level trust. |
| Theorems → Implementation | **AND** (sequence) | Theorems hold conditional on certificates that check, **BUT** are such certificates small and cheap? **THEREFORE** sizes and timings. |
| Implementation → LLM | **AND** | Cheap to check, **BUT** who writes them? **THEREFORE** the LLM loop. |
| LLM → Related work | **AND** (classic dead "related work" block) | Move related work up as positioning within §2 (search / simulate / identity / TTP / one-way PCC), and keep only the lineage (PREFIX → property X → gRR) as a short "precursors" paragraph near the limitations. |
| → Limitations | **BUT** | It works, **BUT** it's a convention, sensitive to encoding, and closed ($K$) or open ($K'$) without bridges (exclusivity). **THEREFORE** future work on designed-in bridges, and attestation as the complement for "code run = code shown". |

---

## 4. Section outline

1. **Introduction.** *Claim:* source-aware agents can cooperate feasibly and verifiably, but only by agreeing on who supplies the proof. Content: the one-shot PD; FairBot's elegance and its cost; the find/check asymmetry as the thesis; the contributions list; an optional recursive-type analogy.
2. **Background and positioning.** *Claim:* every existing route to robust cooperation either searches, simulates, trusts identity or trusts a third party. Content: program equilibrium; Löb/FairBot; Critch's bounded Löb (with the "⊢" fix); Oesterheld's simulation; CliqueBot/quining and MAGE; Ondras/Teaclave; PCC/FPCC/PCA (one-way). **Table 1:** approaches versus {checks, mutual, feasible, behavioral, no third party}.
3. **Necessity.** *Claim:* if P ≠ NP, no feasible agent is both fair and unexploitable, so any feasible unexploitable agent must restrict its cooperation (P2, P3), and coordination between independent agents needs a shared restriction (P4). Content: definitions; $B_\varphi$; the theorem (abstract core [MC] once M8 is done); the setting caveats (induction, slow opponents); P4 as a proposition with argument, stated honestly as a conjecture if no proof is found.
4. **Why naive certificates fail.** *Claim:* handing over proofs reintroduces the loop in three forms (P5). Content: the size regress; self-certification and explicit reflection (LP's $t{:}F\to F$ versus □); the Löb trap.
5. **The construction.** *Claim:* a diagonal-lemma standard with trust one level up closes the loop definitionally (P6, P7). Content: the DSL and fuel; $S$ (rules, total semantics, no reflection over variables); diag and $K$, $K'$; CertBot. **Figure 1:** the two-level trust architecture.
6. **Guarantees.** *Claim:* members cooperate, are unexploitable, and $K$/$K'$ are mutually exclusive (P8, P9). Content: Theorems A, B, A′, B′ and exclusivity, with Lean statements and the axiom audit; the F3 trade-off (explicit versus existence-based fixed points).
7. **Implementation and evaluation.** *Claim:* certificates are small, play takes milliseconds, and LLMs can write members (P10, P11). Content: sizes and fuel (**Table 2**); tournaments (**Figure 2:** an 18×18 matrix); the LLM loop (**Table 3:** attempts, sizes and rejection reasons); the adversarial suite.
8. **Limitations, precursors and future work.** *Claim:* the price is coordination, made precise. Content: the convention and encoding sensitivity (cousin_it), the closed/open standards and bridging, the trust assumptions (P12), the toy game, the non-independent generator; the precursor lineage (2009 PREFIX → "property X" → gRR) and public-observatory #2 as an open question we partly answer.
9. **Conclusion.**

---

## 5. Risks and open decisions

**Weak joints.**
1. **P4 (the load-bearing wall) is argued, not proved.** *Options:* (a) look for a theorem of the form "for every polynomial-time unexploitable A there is a polynomial-time unexploitable B, provably cooperative, such that A and B don't mutually cooperate", which would make agreement necessary; (b) state P4 as a conjecture and weaken the title claim to "restriction is necessary; agreement is the natural way to coordinate restrictions." *Decision for the user.*
2. **Setting alignment for P2.** The necessity theorem needs slow opponents and a proof system with induction (PA), while our construction uses a fueled game and $S$, which has no induction. The paper needs one sentence that bridges the two (the theorem constrains every agent in the general setting; CertBot lives within it because it is unfair). Check that the CertBot guarantees hold against *unbounded* opponents as well.
3. **C3 concession.** Losing robustness to encoding is real, and the paper should own it. Consider proving a small result, for example two semantically identical standards with different encodings having disjoint member sets, analogous to exclusivity.

**Likely reviewer objections, with planned answers.** "Convention/CliqueBot" (P2–P4, P8). "gRR did it" (informal, abandoned; we resolve circularity and provenance and add proofs). "Toy game" (one-shot PD is the field's standard; extensions are future work). "Trusting the compiler" (optional hash-cached kernel checks). "Code run = code shown" (an inherited assumption; attestation is complementary).

**Missing before submission.**
- An **independent LLM test**: a different model, given only the public spec, through the API backend (it needs the user's key).
- A **prior-art check on the necessity theorem** (the complexity of program equilibria and of FairBot; Fortnow 2009, etc.).
- The **exact date** of gRR's comment and a closer read of public-observatory #2.
- **M8**: the abstract necessity core in Lean.
- Measured polynomial degrees, or at least empirical scaling of certificate size against code size.
- **No ETH anywhere**; use P ≠ NP only.
