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
