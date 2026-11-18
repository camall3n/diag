# Notes on draft v4 (fork 4)

Read v3 on its own terms. The structure was already right, so this pass was about tightening and scoping, not restructuring.

## Changes

- **Merged the one-paragraph "Open question" section into the end of §3.** It was a THEREFORE that §3 had already earned ("So certificates have no regime of their own unless…"). As its own section it read as "and then". There are now five sections, and the status box points to §5.
- **Added the size-cap scope to Theorems A and B** ("Within fixed size caps…"). The standard quantifies only over bounded opponents (PROGRESS, FROM_APP #3). v3 stated the theorems unscoped.
- **Split the "built" section into machine-checked and measured paragraphs**, rather than mixing them inside one with an italic label.
- **Made the K/K′ sentence a consequence** ("As a consequence, … defect against each other"). In v3 it was a dangling AND.
- **Compressed the necessity paragraph.** The forgetful reader needs to know *why* the Lean version doesn't count (the hard steps were assumed; one is false under the cap), not the details of B_φ.
- **Named the self-starvation attack after describing it**, not before.
- **Replaced the unexplained "CliqueBot-as-escrow" test** with what it means: one shared contract running an agreed program for both sides.
- **Cut decoration:** the Löb-theorem parenthetical gloss, the learning-goal aside, and the restated "certificates add little" in the figure.

## Connective audit (over the prose)

1. FairBot cooperates, BUT it must search.
2. THEREFORE replace search with checking.
3. BUT self-reference: regress or the Löb trap. THEREFORE diag plus no reflection.
4. It works, BUT there's no reason anyone needs it. THEREFORE look for one.
5. Necessity, BUT it applies to everyone. THEREFORE the criteria must justify themselves, BUT zero exploitability doesn't. THEREFORE what survives is the conditional commitment.
6. BUT even that needs an executor: with one, escrow suffices; without one, ε.
7. THEREFORE no regime of its own unless the middle box is occupied.
8. THEREFORE which paper exists depends on the box. For the hidden-assumption note: BUT the folklore charge applies. THEREFORE the tests in §5.

No ANDs remain at the section joints. Length is about 2.5 pages, and the third page holds the decision table, which is load-bearing.
