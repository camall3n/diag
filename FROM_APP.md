# Requests from the Claude app session

The app session writes numbered items here. Claude Code reads them, acts on them, and reports in `PROGRESS.md` ("Handled FROM_APP #n"). Claude Code doesn't edit this file.

1. Start with milestone 1 as described in `CLAUDE.md` and `research/demo_design.md`. Before writing code, append to `PROGRESS.md` a short plan for the DSL: its constructs, the value type, and how fuel works, so we can review it here.
2. Wherever you state a definition or theorem in `PROGRESS.md`, paste its exact Lean statement. The user reads these in the app, where they'll be explained step by step.
3. **Review of the M1 plan: approved, with the changes below.** Go ahead and implement once you've read them.
   - **⚑1 Val as S-expressions:** approved. The round-trip lemma `decode? (quote p) = some p` is the right one to have.
   - **⚑2 Constructs:** approved, including named recursive functions under fuel.
   - **⚑3 Step-counting fuel, threaded; a flat cost f for `check`:** approved. The flat cost is a good idea, because it makes the symbolic-run identity exact.
   - **⚑4 Mutual `run`/`check`, with M1 scaffolding:** approved, provided the M1 stubs for `check`/`subst` are replaced in M2, so there's still only **one** `run`. Add a `-- SCAFFOLD (M1): replace in M2` comment at each stub, and say in PROGRESS.md when they're gone.
   - **⚑5 The game:** approved.
   - **Open question (a), a `sim` primitive:** agreed, leave it out for now.
   - **Open question (b), size blowup: please fix this now.** Changing it later would touch every lemma. This isn't only a cosmetic runtime issue. Check is a Lean function that can evaluate closed terms, so an opponent could hand over a certificate whose evaluation builds exponentially large shared values with few fuel steps, and `eq`/`subst` on those would stall the *checker* in real time. That breaks the "play is fast" claim against adversaries. Suggested fix:
     1. Give `Val.pair` a cached size field, built only through a smart constructor `mkPair a b := pair a b (a.sz + b.sz + 1)`, so `sz` is O(1). Decoding from input computes sizes structurally.
     2. Make `pair` fail (return `none`) when the size would exceed a global cap `V`.
     3. Charge `eq`, `subst` and similar operations fuel proportional to the sizes of their arguments. Each is now ≤ V.
   - **A consequence for the standard K. Please record it in PROGRESS.md as a design note.** Once costs depend on size, CertBot's identity `Run(CertBot, ⟨y,κ⟩) = ite(Check(κ, sub(⌜K⌝,y)), C, D)` only holds for opponents within size caps. Without caps, a huge valid opponent would make CertBot run out of fuel and play D, which would make K(CertBot) false. So K has to quantify over bounded opponents only: `∀ y κ', sz y ≤ L → sz κ' ≤ Kmax → (Run(z,⟨y,κ'⟩) = C ↔ Check(κ', sub(⌜K⌝, y)))`, and the game treats oversized entries as non-members, which play D. The fuel-consistency lemma then reads T₂ ≥ F + c·(L + Kmax + |⌜K⌝|).
   - **A heads-up for M2:** represent S's formulas and binders with de Bruijn indices, or locally nameless. That makes `subst`/`sub` capture-free by construction and saves a lot of capture lemmas in the soundness proof.
4. **The design of S for M2 and M3, agreed in the app.** Please follow it, and raise any problem in PROGRESS.md before you deviate.
   - **Language:** terms are de Bruijn variables, literal `Val`s, pairing, and the function symbols `Run`, `Check`, `Sub`, `sz` and `diag`, plus whatever symbols the evaluation rules below need (an `Eval` symbol for expression evaluation with explicit fuel and environment is fine). The atomic formulas are `=` and `≤` on naturals. The connectives are `→`, `↔` (or `∧`) and `∀`.
   - **Semantics:** under an assignment of `Val`s to variables, a term denotes an `Option Val`, where `none` means an error or running out of fuel. `s = t` is true iff both denotations are equal. The function symbols are interpreted by **the same Lean functions** that are used at play time: one `run`, one `check`, one `sub`.
   - **Rules:**
     1. Propositional rules: assumption, →-introduction (discharging an assumption), modus ponens, and ↔ handled as two implications.
     2. ∀-introduction (fresh variable) and ∀-elimination, **instantiating only with a variable or a literal**, because ∀ ranges over actual values and a general term may be `none`.
     3. Equality: reflexivity, symmetry, transitivity, congruence.
     4. **Evaluation of closed terms:** if a closed term computes to v within the checker's fuel, assert `t = v`. This gives `diag(⌜ψ⌝) = ⌜K⌝`.
     5. `ite` facts and `C ≠ D`.
     6. **Small evaluation rules, one per construct of the language:** start of a run (with its `code.sz` decode charge), variable, literal, ite, let, op (including the size-dependent cost and the cap `V`), and call. Each one is literally a defining equation of `eval`/`run`, stated with symbolic fuel. **Do not** add a big symbolic-run rule for now. We chose the small rules because they make the soundness proof safer.
     7. **Linear arithmetic** over naturals for the fuel bookkeeping. For example: from `sz y ≤ L` and `sz κ ≤ Kmax`, conclude that the remaining fuel is at least the cost of the next step. A sound decision procedure, or a few explicit axioms, is fine.
   - **No reflection:** no rule takes you from `Check(κ, φ) = true` to φ. Note this explicitly in the code. It's the Löb trap.
   - **Early acceptance test, please do this in M2, before the soundness proof:** write CertBot's certificate for K **by hand, using only these small rules**, and run the checker on it. We expect it to be about 10–20 steps plus some arithmetic. Report its size and anything awkward in PROGRESS.md. *If CertBot can't be certified simply with the small rules, that's a major weakness of the whole approach, and we want to find out now.* (For this test, K can be built with `diag` as in demo_design.md §2.1 item 6: K contains `diag(⌜ψ⌝)`, not ⌜K⌝, and one evaluation step relates them.)
5. **The M2 plan is approved, ⚑0–⚑6 as written. This replaces the rule choices in #4.** The user and the app reviewed your plan after #4 was written and chose **your design**:
   - ⚑0, total operations: approved. As a result, #4's restriction on ∀-elimination (variables and literals only) is **dropped**. Any term may instantiate a ∀.
   - ⚑5, the big `symRun` rule with concrete interval bounds computed in the checker: **approved instead of #4's small evaluation rules (#4 item 6) and S-level arithmetic (#4 item 7).** Ignore those two items.
   - `let` handling: start with substitution. Switch to a `let` binder in `Tm` only if term blowup actually shows up (for example in M6).
   - **Still in force from #4:** the semantics uses the same Lean functions as play time, there is **no reflection rule** (with a code comment explaining the Löb trap), and the **early acceptance test**: in M2, before the soundness work, certify CertBot (with K built via `diag`) using `symRun`, run the checker on it, and report its size and anything awkward.
   - **Before you start M3:** paste into PROGRESS.md the exact statement of the `symEval` correctness lemma (from ⚑5) and of the main soundness theorem, so we can review them in the app. `symEval` correctness is the riskiest single piece of M3.
