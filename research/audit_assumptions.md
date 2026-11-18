# Audit: assumed vs proved (2026-11-18)

## Lean: clean
- No sorry/axiom/native_decide/implemented_by. `partial def` only in Front.lean (untrusted front end; its output is re-checked).
- check_sound, check_member_sound, member_denote, diag_eval/subst_K, theoremA, theoremB, theoremA', theoremB' are proved outright (only the standard axioms).
- theoremB'_sem assumes `Cautious`, but theoremB' discharges it with a checked certificate. OK.

## Assumed, not proved
1. Necessity: both (i) hB and (ii) hShort are structure fields. Neither is proved for any real system. (i) fails for large φ under the fixed fuel cap T.
2. Concrete certification facts are only #eval'd (compiled code), never kernel-proved:
   - `check F certBotCert (member certBot) = true` (Acceptance.lean, Tournament.lean)
   - exclusivity's `hco` (CooperateBot's K′ certificate)
   So "CertBot vs CertBot = (C, C)" trusts the Lean compiler, the same trust native_decide needs, which we banned.

## Prose claims made in chat or notes, unproved
3. "Any two different two-way standards with members are disjoint." Only K vs K′ is proved (exclusivity).
4. "One-way standards are bridgeable with several certificates." Not proved.
5. "Certificates are a natural *minimal* restriction." No theorem for "minimal".
6. Critch-infeasibility estimates assume exhaustive proof search. Smarter search could find these particular proofs fast. The necessity theorem is worst-case only.
7. ε-grounded FairBot cost claims (divergence when the opponent simulates ≥2×) are a back-of-envelope estimate, not checked against Oesterheld.
8. "Explicit reflection for t needs a proof of size ≥ |t|." Unsourced; verify.
9. M6 "LLMs can generate certified members": the generator was Claude Code itself, not an independent model.
