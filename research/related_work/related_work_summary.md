# Related work: merged summary (searched 2026-11-18)

Source reports, with full citations and URLs:
- `litA.md`: program equilibrium, LLM agents, cryptography
- `litB.md`: attestation and proof-carrying code
- `litC.md`: AI-safety self-trust and logic
- `litD.md`: circular verification, multi-agent commitments, institutions
- `lit_survey.md`: the earlier, broader survey

Every item was found online by the search agents. Items still to verify by hand are listed at the end.

**Our contribution in one line:** program-equilibrium agents that cooperate by *checking an attached certificate* about the opponent's own code, against a *self-referential membership standard* (K, two-way; K′, one-way) defined with the diagonal lemma. Trust is placed one level up (a small proof system, proved sound in Lean, with no reflection over variable proofs). Everything runs under explicit resource caps, is machine-checked, and has members that LLMs can generate.

**Verdict.** No published work combines these ideas. Each ingredient has precedent in isolation. The only real precursor is an informal LessWrong comment (gRR, c. 2010–12) that proposed proof-passing with a diagonal predicate and then dropped it over compatibility worries. A 2026 research agenda (public-observatory, issue #2) poses mutually conditional certificates as an *open question*.

---

## Organized by how each line of work differs from ours

### 1. Agents *search* for proofs at play time (Löbian or provability-based)
- Barasz, Christiano, Fallenstein, Herreshoff, LaVictoire, Yudkowsky 2014, *Robust Cooperation in the PD* (arXiv 1401.5577); LaVictoire et al. 2014 (MIPC workshop).
- Critch 2019, *Parametric bounded Löb* (JSL 84(4); arXiv 1602.04184), and the corrected hypothesis (X post, 28 Jul 2026, credited to Levine).
- Critch 2023, *Modal fixpoint cooperation without Löb* (Payor's lemma), LessWrong; transhumanist_atom_understander 2026, *From FairBot to other cooperation conditions by substitution*, LessWrong.
- Levine 2026, *Math for AI Safety* (arXiv 2609.15289): open problem MAIS-O1 on overhead and the threshold k̂.
- Duclaux, Formenti, Cobben, Schölkopf, Jin 2026, *Proving Your Way to Cooperation* (ICML AI4Math workshop): Lean formalization in which bounded proof search is an axiomatized oracle; LLMs reprove 40 of 45 outcome theorems.
- **Difference:** they rely on existence and exhaustive search, costing |Σ|^B, with thresholds that aren't explicit. We check a certificate in polynomial time, with no Löb.

### 2. Agents *simulate* each other
- Oesterheld 2019, *Robust program equilibrium* (Theory and Decision 86(1)); Oesterheld 2022, *Compatibility of different robust program equilibria* (arXiv 2211.05057): proof-based and simulation-based FairBots cooperate with each other, which bears on our bridging question.
- Cooper, Oesterheld, Conitzer 2025, *Characterising simulation-based program equilibria* (AAAI; arXiv 2412.14570).
- **Difference:** behavior is checked by running the opponent, with ε-randomization to break the regress, not by checking a proof.

### 3. Trust based on *identity* or *syntax*
- Tennenholtz 2004, *Program equilibrium* (GEB 49(2)): CliqueBot-style syntactic equality.
- Chen & Zhang 2022, **MAGE** (USENIX Security), and the Apache Teaclave mutual-attestation docs. They state our self-reference cycle exactly (two enclaves can't each hard-code the other's hash). MAGE solves it with a *hash-level* fixed point (a closed group defined by identity); Teaclave uses a trusted third party.
- Arsen 2026, *Generalized CliqueBots*, LessWrong: membership by equality on probe interfaces; proof-based instances still search.
- **Difference:** membership is defined by *what code is*. Ours is defined by *what code provably does*, and it is certified.

### 4. Trust rests on a *third party or oracle*
- Ondras 2026, *Lean-Verified Handshake* and *Axiom-Audited… Commitment in Lean* (ICML 2026 workshops): a `TrustedOracle` assumption, in Stag Hunt.
- Teaclave auditors, and TTP-based property-based attestation (Sadeghi & Stüble 2004).
- **Difference:** there is no referee in our design. Each agent checks locally, and the only shared things are the standard and the checker.

### 5. Proof-carrying, but *one-way* and *non-strategic*
- Necula 1997, *Proof-carrying code* (POPL); Appel 2001, *Foundational PCC* (soundness of the safety policy proved in a logical framework, which is our two-level trust); Wu, Appel, Stump 2003.
- Appel & Felten 1999, *Proof-carrying authorization*; Bauer et al. 2002.
- Sirer et al. 2011, *Logical attestation / Nexus* (SOSP): the client proves and the guard checks, for behavioral properties.
- Ciliberto, Rudi, Tassi 2026, *Proof-Carrying Contracts* (arXiv 2610.28484): per-action proofs checked by a small Lean-backed "Airlock". In its own words, it never looks inside the agent.
- Proof-carrying outputs for LLMs (Koomullil 2026, arXiv 2605.16407; Avni, Dolev, Yagudaev, Yung 2026, IACR ePrint 2026/994; Wang 2026, arXiv 2606.04104).
- bryjnar 2017, *Zero-Knowledge Cooperation*, LessWrong: prove a property of hidden code. Informal.
- **Difference:** a single prover facing a single verifier, with no mutual obligation and no self-referential standard.

### 6. *Single-agent* self-trust, with soundness proved one level up
- Yudkowsky & Herreshoff 2013, *Tiling agents and the Löbian obstacle*; Fallenstein & Soares 2014 (AGI), suggester–verifier: check a supplied proof rather than search; Fallenstein & Soares 2015, *Vingean Reflection*.
- Fallenstein & Kumar 2015, *Proof-producing reflection for HOL* (ITP): mechanized one-level-up soundness gating self-replacement. This is the closest to our trust architecture.
- Harrison 2006 (IJCAR), HOL plus an axiom proves Con(HOL); the Candle and CakeML self-verification line.
- **Difference:** an agent trusting itself or its successor, not two strategic agents trusting each other.

### 7. The same circularity, resolved *differently*
- Circular assume-guarantee: McMillan 1999; Abadi & Lamport 1995, *Conjoining specifications*; Maier 2003. These are resolved by induction over time or by lattice side conditions.
- Wan & Singh 2005 (AAMAS): commitment cycles in multi-agent systems, resolved by protocol.
- Li et al. 2003/2005: cyclic trust-negotiation policies, resolved cryptographically. Yu, Winslett, Seamons 2001 (CCS): families of interoperable negotiation strategies, the nearest analogue to K, but membership is *assumed*, not certified.
- Ohtsuki & Iwasa 2004, self-referential "good standing"; Carbone, Nielsen, Sassone 2003, trust as a fixed point. These are tracked over repeated play or computed, not certified.
- **Difference:** we route each obligation through the other side's *fixed certificate* and close the loop *definitionally*, with the diagonal lemma.

### 8. LLMs in program games, without formal guarantees
- Sistla & Kleiman-Weiner 2025, *Evaluating LLMs in open-source games* (NeurIPS; arXiv 2512.00371). They leave open whether LLM-generated code can meet machine-checkable proofs, which our milestone 6 addresses.
- Hewson 2026, *Program games for LLMs* (Substack); Glass 2026, *Open-strategy dictator game* (arXiv 2608.14913); Wyse et al. 2026, *Self-negotiated contracts* (arXiv 2607.22750).

### 9. Informal precursors and open questions to cite
- **gRR**, comment on cousin_it, *AI cooperation in practice*, LessWrong (post 30 Jul 2010; comment c. 2010–12): proof-passing plus a diagonal `ChecksOut` predicate, abandoned over compatibility between diagonalizations. That is our bridging question.
- **public-observatory / open-source-game-theory, issue #2, "Certificates for joint behavior"** (c. Oct 2026): poses mutually conditional certificates as an open research question, framed around global safety properties.
- *Proof of Collusion* shortform (author and date unverified): exchanging compressed proofs of commitments, framed as a collusion risk.

---

## Suggested positioning (draft)
> Proof-carrying code meets program equilibrium. Prior proof-based agents *search* for proofs (Barasz et al.; Critch), simulation-based agents *run* each other (Oesterheld), and attestation-based systems trust *identity* (MAGE) or a *third party* (Teaclave, Ondras). We give agents that *check* attached certificates about each other's behavior, against a membership standard closed by the diagonal lemma rather than by Löb, with trust placed one level up as in foundational PCC and HOL reflection. This turns an informal 2010 idea (gRR) into a feasible, machine-checked construction, and answers a recently posed open question (public-observatory #2) in the case of the Prisoner's Dilemma.

## To verify by hand before claiming priority
1. The exact date of gRR's comment, and its wording.
2. The full text of public-observatory issue #2 and the rest of that agenda (the repo was unreachable from our tools).
3. The author and date of the *Proof of Collusion* shortform.
4. zhongmingjiang, *Proof of Löbian Cooperation* (GitHub, only partly readable), and namin/lean-loeb.
5. Critch, Dennis, Russell 2022 (arXiv 2208.07006), whose full text wasn't checked for a certificate mechanism.
6. Forward citations of Barasz 2014, Critch 2019 and Necula 1997 via Semantic Scholar or Google Scholar (the API was blocked here, so keyword search only).
