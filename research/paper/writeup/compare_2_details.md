# Comparison 2: details

Same papers and abbreviations as `compare_1_style.md` (FM, MSA, LD, FP; v0 = my draft).

## Sentences

- **Length.** Theirs mostly run 15 to 30 words, one main clause, with occasional asides set off by em dashes ("—without access to reward feedback—", "—that we explore in this paper—"). v0 packs more into each sentence, often with a parenthetical and a list ("the closest are A (…), B (…), C (…), and D (…)"). Theirs rarely list more than three items in a sentence. When they do, it's a citation run, not claims.
- **Topic sentences carry the claim.** For example: "But learned abstract state representations are not necessarily Markov, even when built on top of MDPs." (MSA) and "Our first observation is that instead of reasoning at the level of variables, we can reason at the level of facts." (FP) The paragraph then justifies it. v0 often puts the claim at the end, after a colon or "So".
- **Connectives they actually use:** "However,", "But", "Consequently,", "Thus,", "Instead,", "In other words,", "Note that", "Ideally,", "Alternatively,", "Unfortunately,", "By contrast,", "Fortunately,". The "Ideally… Alternatively… The challenge is that…" sequence in LD's intro is a compact way to dismiss the existing approaches. v0 leans on "So", colons, and "and".
- **"Note that"** appears in all four, introducing a caveat or a non-obvious consequence. It's Cam's standard way to add a qualification without breaking the flow. v0 has no equivalent and puts caveats in their own paragraphs or labels ("Caveat:").
- **i.e. / e.g.** Frequent and parenthetical in all four ("(i.e. facts)", "(e.g. via relaxed reachability)"). They are a natural fit for defining in passing.

## Claims, evidence, hedging

- They distinguish **proved** from **shown empirically** in nearly every abstract: "We formally prove… We show empirically…" (FP), "we prove that the λ-discrepancy is exactly zero for all MDPs… We also demonstrate empirically…" (LD), "We introduce a novel set of conditions and prove that they are sufficient… We empirically evaluate…" (MSA). Our project has a three-way split (machine-checked in Lean, argued on paper, empirical/pilot) that maps onto this directly. v0 mixes them within paragraphs.
- **Quantified results:** "reduces actions by up to 99%, facts and variables by up to 90%, and solves 50 more problems" (FP); "an order of magnitude" (FM). v0 has numbers (5 ms, 1.7k to 50k, 8/8, 0/6) but buries them in bullets.
- **Scope is attached to the claim, not appended:** "frequently performs significantly better (and never performs worse)" (LD); "almost always non-zero for a broad class of partially observable environments" (LD). v0's scoping is separate ("Caveat: snippet-level searches confabulated…").
- **Footnotes** carry technicalities (FP: "Technically, we should write PRUNE ∘ RELEVANCE-V, but we omit…"; MSA: the ground-state terminology). v0 has none. Footnotes would hold the Lean-internals detail (`unseal`, `decide +kernel`, theorem names) that a collaborator might want but that interrupts the argument.

## Definitions and notation

- All four introduce a formal tuple in Background (Π = ⟨V, A, s0, G, cost⟩; M = (X, A, R, T, γ); POMDP with Ω, Φ). Definitions are numbered and named: "Definition 1 (Justified Action)", "Definition 2 (Markov State Abstraction)". Theorems likewise, followed by a sentence saying what the theorem *buys*: "Theorem 1 guarantees that…".
- Defined terms are *italicized* on first use: *facts*, *representation gap*, *Markov assumption*, *effective MDP model*, *macro-action*, *effect size*, *causally linked*.
- v0 uses T, P, R in "εT + (1−ε)P < R" without ever saying they are the PD payoffs. It also never defines FairBot formally, Löb's theorem, the diagonal lemma, "fuel", or fair exchange. A collaborator returning in six months needs these.

## Figures, tables, captions

- Captions tell the reader what to conclude. "Adding focused macros leads to a significant performance improvement over primitive-actions alone. Random macros have the opposite effect." (FM). "Fact-based relevance analysis results in additional pruning." (FP). "The λ-discrepancy auxiliary objective (LD) improves performance over recurrent (RNN) and memoryless PPO." (LD).
- MSA's Figure 2 is a *tiny counterexample* (four states, two actions) used to make the problem concrete. Our analogue is the self-starvation attack, a two-agent message diagram. It could be a figure: A sends its certificate, B blocks its inbox, A cooperates and B defects.
- FP's Figure 1 is a *nested-sets diagram* showing which plans each method preserves. Our analogue is a 2×2 of {executor: yes/no} × {what certificates buy}: with an executor, escrow already gives A and B; without one, the fair-exchange impossibility gives an ε floor. The empty cell (binding execution, no shared contract, own code) is the wall. That would be the memo's Figure 1.

## Citations and related work

- Citations are integrated into sentences as actors: "Nebel, Dimopoulos, and Koehler (1997) pointed out that…", "Castro (2020) introduced a further relaxation…". Each related-work paragraph ends with a contrast sentence: "Our approach can be thought of as a useful compromise between these two extremes." (MSA), "Our method is more general than these methods, as it is designed to handle…" (FM).
- v0 cites by list. "The closest are…" with four parentheticals. Cam would give each a clause of contrast.
- None of the four cites unverified material. Ours has a known confabulation and several unverified claims. The paper convention would be to cite only what was opened, and to say so in a footnote.

## Section headings

- Some headings are claims: "Focused Actions Improve the Goal-Count Heuristic", "Focused Actions Improve Planning Efficiency" (FM), "The Power of Fact-Level Analysis" (FP), "Detecting Partial Observability" (LD). Others are plain topics ("Background", "Related Work").
- v0 headings are memo-speak ("What broke, in order", "The load-bearing question"). Claim headings would suit a findings memo well: "Necessity does not single out certificates", "With an executor, escrow suffices", "Without one, the floor is ε".

## Micro-level habits worth adopting

- Begin a paragraph with "Ideally," to state what one would want, then "The challenge is that…" (LD).
- "We begin by examining why…" then "We hypothesize that…" then "If our hypothesis above is correct, we expect…" (FM). That is exactly our H1–H15 record, written as prose.
- End a section with "What remains is to…" (FP).
- Use "In other words," to restate a formal statement plainly (MSA, LD).
- Bracket honesty: "(and never worse)".

## Habits in v0 to drop

- Bold in running prose.
- "Caveat:" labels.
- Colons as punchlines.
- Lists of three or four for cadence.
- Sentences that start with "So".
- Parenthetical lists of citations without contrast.
- Insider milestone names (M6, M8b) in the main text. Move them to a footnote or an appendix table that maps to the repository.
