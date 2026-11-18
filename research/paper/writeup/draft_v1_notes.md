# Notes on draft v1 (fork 1)

**What changed and why**
- Added a boxed status summary at the top: the verdict and the one question that would reopen the work.
- Reorganized by the dependency between ideas instead of chronology: goal → build → findings → open question → paths → decision.
- Section 1 now opens with the assumption and its "however" (proof search is too expensive).
- Defined the terms a forgetful reader needs: the PD payoffs T/R/P/S, FairBot, Löb, ε-grounding, the Löb trap, semantic membership.
- Moved milestone names and Lean internals into one footnote.
- Findings now use claim-style run-in headings, with almost no bold in the prose.
- Made the hidden binding-executor assumption explicit, as the move behind the main finding. The self-starvation attack is now a concrete worked case.
- Added a figure: a three-regime map with the middle regime dashed and empty.
- Promoted the "hidden-assumption paper" (the bridge note, reframed) to the first path to a paper.

**Lamport sketch.** THEOREM: the scheme works but is distinctive only in the middle regime. P1 search is infeasible → P2 the certificate construction [MC] → P3 necessity applies to everyone → P4 exploitability isn't required → P5 the executor split. WALL: the middle regime exists (P6, leaning). REFLEXIVITY: the hidden-assumption paper faces the same folklore charge; that's stated in §5.

**Connective audit**
- Goal: FairBot is robust, BUT needs search, THEREFORE certificates.
- Build: self-reference is hard, BUT the diagonal lemma avoids it, THEREFORE K; it works, BUT there's no reason why anyone needs it, THEREFORE §3.
- Findings: necessity, BUT it applies to everyone, THEREFORE the criteria; BUT exploitability isn't required, THEREFORE a commitment; BUT an executor is needed, THEREFORE the split.
- Open question: the split leaves one regime, THEREFORE §4.
- Paths and the table: THEREFORE.
- Remaining soft joint: the theory note follows the hidden-assumption paper as an AND (two alternatives).
