# diag: LLM-generated, provably cooperating programs (Lean 4)

## What this project is

We are building a small, fully honest demo of this claim: given a standard agreed in advance, an LLM can write a program together with a machine-checkable certificate. Any two certified programs then provably cooperate in the open-source Prisoner's Dilemma, and no certified program can be exploited. Play is fast: no proof search, just one certificate check per side.

The design is **option (a)** in `research/demo_design.md`. Read it first. In short:

- **A tiny DSL** with a fuel-bounded interpreter `run`, which is a total Lean function.
- **A small object logic S**, deep-embedded as Lean data, with a fuel-bounded checker `check`.
- **A Lean proof that S is sound.** If `check` accepts a proof of φ, then ⟦φ⟧ holds, with S's `Check` symbol interpreted as the Lean function `check` itself.
- **The standard K**, built with `diag` (the diagonal lemma): "I cooperate with an opponent exactly when its certificate checks as a proof that it satisfies K."
- **Theorems A and B**, proved in Lean: members cooperate with members, and members are unexploitable.
- **CertBot**, plus an LLM loop that produces varied members and adversarial attempts.

Background notes in `research/`:
- `certbot_theorem.md`: the PA-strength, handed-proof version.
- `certificate_exchange.md` and `protocol_sketch.md`: how we got here.
- `lit_survey.md`: related work.

## Working with the Claude app session (important)

The user works side by side with a Claude app session, which renders math and discusses ideas. That session can't see your terminal, only the files in this folder. So:

1. **`PROGRESS.md` is append-only.** After every meaningful step (finishing a milestone or sub-step, a design decision, a dead end, a blocker), add a bullet of 1–3 plain-English lines covering what you did, what you found, and what's next. Include file paths, and the exact Lean statements of any key definitions or theorems, so the app can explain them. Never rewrite earlier entries.
2. **`FROM_APP.md` holds requests from the app session.** Read it when a session starts, before each new milestone, and whenever the user says "check the app notes." When you act on an item, say so in `PROGRESS.md` (for example, "Handled FROM_APP #3"). Don't edit `FROM_APP.md` yourself.
3. **Ask the user before any significant departure from the design,** and record the decision in `PROGRESS.md`.

## Honesty rules (from `demo_design.md` §2.4)

These are non-negotiable:

- No `sorry` and no new `axiom`s.
- No `native_decide`, and no `#eval`, in any meta-theorem. Run `#print axioms` on the soundness theorem and on Theorems A and B, and paste the results into `PROGRESS.md`.
- Use **one** `run` function both for the semantics and for play.
- S has **no reflection rule** about its own checker. That's the Löb trap: it would make every program a member.
- Certificates are data attached to the code. They are never stored inside the code they describe.
- Fuel constants have to be consistent. State it as a lemma: mover fuel ≥ the cost of calling `check` with fuel F, plus overhead.

## Milestones

1. DSL, fueled interpreter, and the game. Run DefectBot against CooperateBot.
2. S's syntax, proof objects, and the fueled checker. Check toy proofs.
3. Semantics and **soundness**, with no `sorry` and no `native_decide`. *This is the critical milestone.*
4. `diag`, K, the substitution lemma, and Theorems A and B.
5. CertBot and its certificate. Tournament: CertBot against itself, DefectBot, CooperateBot, and forged certificates.
6. LLM loop: varied members plus adversarial attempts. Report certification rate, certificate sizes, and rejections.
7. Optional: a one-directional standard, the handed-proof variant, and Lean itself as S (option b).

## Environment

- Lean 4 via `elan`, with a `lake` project. Avoid Mathlib unless it's clearly needed, and justify it in `PROGRESS.md` if you add it.
- Keep the build green. Commit with git after each milestone, if the user has set up a repository.
