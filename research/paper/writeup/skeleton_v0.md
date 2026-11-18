# Skeleton for the findings write-up (v0, before reading the reference papers)

Mode note: open mode for choosing what the document *is*; closed from the THEOREM down.

Open-mode notes. Who is the reader? Us, in six months, having forgotten. They want three
things: what we were trying to do, what broke, and the conditions under which picking it
up again would pay off. So this isn't a paper and shouldn't pretend to be. It's closer to a lab
notebook's conclusion page, written as an argument. The temptation will be to spend the two pages
on the Lean construction, since that's the part that's impressive. But that part *works*, and the
reader in six months mostly needs the part that didn't.

## Lamport sketch

THEOREM. The certificate construction works and is machine-checked, but its distinctive feature
(semantic membership: any program *proved* to honor the standard, rather than one exact program
or one escrow address) pays off only in a regime we haven't been able to name: binding execution
where agents can't route the action through a shared contract and must keep their own code. So
park it, and resume only if one of three cheap tests comes back positive.

- P1. Löbian cooperation (FairBot) needs proof *search*, which is infeasible at realistic proof
  lengths. Justification: |Σ|^B with affordable B ≈ 20–28 vs Critch's B ≳ 10^4.
- P2. Shipping a certificate turns search into checking. Naive versions fail (regress,
  self-certification, Löb trap). A diagonal-lemma standard K fixes this.
  Justification: Lean development, [MC], standard three axioms.
- P3. Necessity ("fast + fair + unexploitable is impossible") doesn't single out our approach.
  Justification: the Contrarian diagonal argument is unconditional and applies to every
  feasible agent; the SAT version assumed its hard parts.
- P4. Zero exploitability isn't required for equilibrium. Justification: ε-grounded FairBot is
  an equilibrium (εT + (1−ε)P < R).
- P5. With a binding executor, plain escrow gives Theorems A and B.
  Justification: Monderer–Tennenholtz mediators; one escrow contract.
- P6. Without one, a certified agent can starve itself of the opponent's certificate, which is
  the fair-exchange impossibility, so the floor is ε, the same as grounding.
  Justification: the user's self-starvation attack; Even–Yacobi; Pagnia–Gärtner.
- P7 (leaning). A regime with binding execution but no shared contract, where agents keep
  differing code, exists in practice. Justification: none yet. Candidates: flexHEG-style hardware
  commitments, the bare program-equilibrium model (a model, not a deployment).

COUNTER 1. "Real AI agents will run large, differing programs; one escrow per interaction type
doesn't scale." Bears on P5 and P7.
COUNTER 2. "The cooperative-AI community lists checkable conditional commitments as open."
Bears on audience, not truth (P5).
COUNTER 3. "The Lean artifact has value on its own." Bears on "park it".

LOAD-BEARING WALL: P7. The decision is invariant to everything else; it turns on whether such a
regime exists.

LEMMA (reflexivity). Do P5/P6 also sink the "paths to a paper" we list? Partly. The bridge note
("conditional cooperation is fair exchange") may be folklore among cryptographers, which is the
same charge as P5. It survives only if nobody has written the reduction for this audience.
Unverified.

## But/therefore over the planned prose

1. FairBot is elegant BUT needs search THEREFORE ship proofs instead.
2. Naive shipped proofs regress BUT the diagonal lemma closes the loop THEREFORE K, built in Lean.
3. It works BUT why would anyone need it? THEREFORE necessity.
4. Necessity BUT applies to everyone THEREFORE look at the criteria.
5. Criteria BUT zero exploitability isn't needed THEREFORE reframe as conditional commitment.
6. Conditional commitment BUT escrow does it given an executor, and without one the guarantee
   drops to ε (the self-starvation attack). This is the dead AND the outline flagged; as
   tension: executor ⇒ escrow suffices; BUT no executor ⇒ ε; THEREFORE no regime of our own
   UNLESS P7.
7. THEREFORE the resume conditions are tests of P7 (and of novelty for the side notes).

Weight check: rhetorical weight must *not* go to the construction (beats 1–2). Logical weight is
beat 6/P7. Budget: about a third of a page on the construction, the most space on 3–6, and an
explicit "when to resume" box.
