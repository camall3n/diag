# draft_v5 notes (fork 5)

v4 already had the right structure: a status box, the hidden-assumption framing, a three-regime figure, and a decision table. So I made targeted edits rather than a restructure.

## Changes

- **Fixed a causal overclaim.** v4 said CertBot under K and under K′ defect against each other "as a consequence" of exclusivity. PROGRESS says the actual reason is that each checks the other's certificate against its own standard. That is now stated as an interoperability problem.
- **Added two technical lessons** to §2, because the user asked for the problems we ran into, not only the conceptual ones:
  - "Certified" means the checker accepts *and* the entry is within the caps; the M6 runner bug violated this.
  - S couldn't use negated tests until the `boolCases` rule.
  Both come from PROGRESS.
- **Corrected the DiGiovanni et al. claim** to match the confirmed reading in the synthesis: they *assume* syntactic template verification and leave relaxing that assumption to future work. Updated the decision-table row to match.
- **Defined flexHEG** for a reader who wasn't in the sessions (Petrie et al. 2025; chip commitments "if the other makes the same commitment", which the authors call hard on-device).
- **Renamed §3** from "What we found" to "Why we parked it", a claim heading in the style of Cam's papers.

## Connective audit

- Goal: search is infeasible, THEREFORE check certificates.
- Built: BUT self-reference, THEREFORE diagonal lemma, no reflection. The lessons are a BUT (the caps and boolean gaps).
- "Works, BUT no reason anyone needs it", THEREFORE the search for a reason.
- Necessity BUT doesn't single us out, THEREFORE examine the criteria; zero exploitability BUT not required, THEREFORE the commitment; BUT it needs an executor, THEREFORE three regimes; the middle one is empty UNLESS someone finds a case.
- Paths: THEREFORE they depend on the box. The reflexivity BUT (folklore) is present.
- The table, THEREFORE the "if we return" lessons.

The theory-note paragraph is the one mild AND; it's acceptable because it's explicitly "in either case".
