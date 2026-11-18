# Draft v3 notes (fork 3)

I kept v2's structure. It already follows the big-picture recommendation: a verdict box, the implicit assumption, a figure for the executor split, and a decision table. The changes target the reader who has forgotten everything, and the scoping of claims.

**Definitions added:**
- Löb's theorem, in one clause.
- |Σ| and B, plus the 2^128 budget behind "affordable".
- DefectBot.
- CertBot, in a footnote.
- CliqueBot.
- Oesterheld's ε-grounding mechanism.
- B_φ, and the two hypotheses M8 assumed (v2 said only "two hard steps").
- What "one-way" K′ means: only the "if" direction, so CooperateBot qualifies.

**Scoping, as machine-checked vs argued vs measured:**
- §2 says it is machine-checked, with the timings and pilot marked "Measured, not proved".
- §3 opens by saying its arguments are on paper.

**Overclaim fixed.** v2 said exclusivity implies that K- and K′-members defect against each other. The repository shows exclusivity (no program is both) and, separately, the *observed* result CertBot vs CertBot′ = (D,D). v3 now states these as separate facts.

**Other changes:**
- The self-starvation attack is credited to Cam (the session notes say "the user's") and named, so it can be referred to later.
- The footnote now points to the files: `Diag/KernelChecked.lean`, `m6/REPORT.md`, and the A′/B′ theorem names.
- The learning goal is noted in one line. The outline lists it as half the motivation, and it matters for the decision to resume.
- I removed the duplicated "in hindsight" lesson from §4 and folded it into the closing paragraph, where it explains the advice.
- Tighter section spacing keeps it to 3 pages, with the figure.

**Connective audit (v3):**
- Box → §1: BUT (the assumption).
- §1: FairBot elegant BUT search, THEREFORE checking.
- §2: self-reference BUT regress or Löb trap, THEREFORE diagonal. Results, then "works BUT no reason".
- §3:
  - necessity BUT beside the point;
  - THEREFORE criteria must justify themselves, BUT unexploitability doesn't;
  - THEREFORE commitment, BUT it needs an executor.
- §4: THEREFORE no regime unless the middle box.
- §5: THEREFORE the paths depend on it. The reflexivity BUT (the folklore charge) is now explicit.
- §6: tests.
- Closing paragraph: lessons, as a BUT about the order of work.

The one residual AND is inside §2: the list of results followed by the pilot. That is acceptable as an inventory.
