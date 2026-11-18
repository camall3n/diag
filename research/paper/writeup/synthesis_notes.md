# Synthesis notes (v1–v5 → draft_final)

## Verdicts on each draft

- **v1** made the big change, and it held for the rest of the chain. It replaced v0's chronological memo with a dependency-ordered document: a status box with the verdict, then the goal, what we built, what we found, the open question, the paths and the decision table. The binding-executor assumption became the headline, and the three-regime figure was added. It defined the PD payoffs, FairBot and Löb. Weakness: the paths were three parallel items (a dead AND). It also said the LLM "wrote 8 of 8 members correctly" and that exclusivity implies K and K′ members defect against each other. That second claim is an overclaim.
- **v2** kept the structure and fixed the joints. The paths became conditional on the middle box (empty / either way / occupied), which is the chain's best structural fix. It also checked the pilot numbers and added Peters & Szentes with a "not re-read" flag.
- **v3** wrote for the forgetful reader. It added definitions (Löb in a clause, |Σ| and the 2^128 budget, DefectBot, CliqueBot, the ε-grounding mechanism, what "one-way" means), scoped each claim as machine-checked, on paper or measured, pointed to the repository files, and credited the self-starvation attack to Cam. It separated exclusivity (proved) from the K-versus-K′ (D,D) result (observed).
- **v4** tightened. It added the size-cap scope to Theorems A and B (a real fix), split the proved results from the measured ones, and folded the open question into §3. It cut the Löb gloss, the ε-grounding mechanism and the learning-goal aside, and reintroduced a causal overclaim: "as a consequence" of exclusivity.
- **v5** fixed v4's overclaim (the real reason is that each checks against its own standard), added two technical lessons (the caps rule and `boolCases`), defined flexHEG, corrected the DiGiovanni et al. claim, and renamed §3 "Why we parked it".

## What the chain converged on

All five kept the structure, the figure, the decision table, the "hidden assumption" framing, the conditional paths and the reflexivity BUT (the folklore charge applies to the bridge note too). Each later fork found and fixed real factual or scoping errors. None restructured.

## What oscillated (judgment calls for Cam)

1. **Definitions versus length.** v3 added the Löb gloss and the ε-grounding mechanism; v4 cut them. I restored both, because they're for the six-months-later reader.
2. **Credit for the attack.** "Cam's self-starvation attack" (v3) versus "we call this" (v5). I kept the credit.
3. **Whether the open question gets its own section** (v1–v3) or ends §3 (v4–v5). I kept it merged, since it reads as a THEREFORE.
4. **The learning goal.** v3 included it and v4 cut it. I restored one clause, because the outline lists it as half the motivation (D5).
5. **Units.** v1 and v5 say certificates have "1.7k–50k nodes". That's wrong: these are `sz` values, and CertBot's certificate has 31 proof nodes (PROGRESS line 244). Fixed.

## Where the final draft comes from

It starts from v5 and adds:
- v3's glosses (Löb, ε-grounding) and its credit for the attack;
- an exact statement of the 5 ms timing (CertBot vs CertBot, interpreted, PROGRESS line 248);
- a corrected unit for certificate size;
- a compressed version of the technical-lessons paragraph, to fit 3 pages.

## Skeleton check on the final draft

THEOREM: the construction works, but has no regime of its own unless the middle box (binding executor, no shared contract, own code) is occupied. WALL: that box, and it is leaning, with no example found. REFLEXIVITY: the hidden-assumption note faces the same folklore charge; that is stated in §4, and the table gives the test for it.

The but/therefore audit is clean at every section joint. The theory-note paragraph is a mild AND, labeled "in either case".
