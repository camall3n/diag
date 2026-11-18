# Lit search A: certificate-checking cooperation in program equilibrium

Searched 2026-11-18. Every item below was found and opened unless marked otherwise. "Ideas 1–4": (1) attached certificates that the opponent checks instead of searching for proofs; (2) a self-referential membership standard K/K′ built with the diagonal lemma; (3) trust one level up, with a small system proved sound in Lean and no Löb; (4) resource caps, a Lean mechanization, and LLM-generated members.

## A. Program equilibrium / open-source game theory

**gRR, comment thread on cousin_it, "AI cooperation in practice", LessWrong (post 30 Jul 2010; comment undated, shown as "15 years old").** https://www.lesswrong.com/posts/TNfx89dh5KkcKrvho/ai-cooperation-in-practice
In the comments, gRR suggests that each program take the opponent's source *plus a proof* and only check it, so that neither has to search. gRR then sketches a diagonalized `ChecksOut` predicate. cousin_it objects that different diagonalizations may not be compatible with each other. gRR agrees that it is "quining cooperation all over again", calls it "only a possible optimization", and drops it. **Closest informal precursor to 1+2.** Key difference: it is a few lines, with no soundness argument, no caps, no theorems and no formalization. The compatibility objection is the same thing as our "different standards defect; bridging is open".

**Barasz, Christiano, Fallenstein, Herreshoff, LaVictoire, Yudkowsky (2014). "Robust Cooperation in the Prisoner's Dilemma: Program Equilibrium via Provability Logic." arXiv:1401.5577.** https://arxiv.org/abs/1401.5577
**LaVictoire et al. (2014). "Program Equilibrium in the Prisoner's Dilemma via Löb's Theorem." MIPC workshop @ AAAI.** https://intelligence.org/files/ProgramEquilibrium.pdf
These define modal agents (FairBot, PrudentBot) that cooperate if they can *find* a proof that the opponent cooperates, with self-cooperation following from Löb. They share our goal of robust, unexploitable cooperation. Difference: agents search for proofs at play time, rely on Löb, and attach nothing.

**Critch, A. (2019). "A parametric, resource-bounded generalization of Löb's theorem, and a robust cooperation criterion for open-source game theory." J. Symbolic Logic 84(4). arXiv:1602.04184.** https://arxiv.org/abs/1602.04184
Bounded Löb lets FairBot_k agents with length-bounded proof search cooperate. This is the closest formal treatment of resource bounds (idea 4). Difference: it is still exhaustive search (exponential in k) and still Löbian.

**Critch, A. (5 Feb 2023). "Modal Fixpoint Cooperation without Löb's Theorem." LessWrong.** https://www.lesswrong.com/posts/2WpPRrqrFQa6n2x3W/modal-fixpoint-cooperation-without-loeb-s-theorem
**transhumanist_atom_understander (12 Nov 2026). "From FairBot to other cooperation conditions by substitution." LessWrong.** https://lesswrong.com/posts/A6vtipePkrQuuebKF/from-fairbot-to-other-cooperation-conditions-by-substitution
These replace Löb with Payor's lemma or GL substitutions. They are relevant to "no Löb" (idea 3), but agents still search for proofs and no certificates are exchanged.

**Duclaux, Formenti, Cobben, Schölkopf, Jin (2026). "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean." ICML 2026 Workshop on AI for Math.** https://icml.cc/virtual/2026/82498
This is the first Lean 4 formalization of proof-based open-source game theory (OSGT): nine bots, pairwise outcome theorems, and an LLM pipeline that reproves 40 of 45 of them. It is close to idea 4 (Lean + LLMs). Difference: bounded proof search is an *axiomatized oracle*; Lean proofs are offline meta-theorems about outcomes, not certificates that agents exchange; there is no self-referential standard.

**Arsen (28 Oct 2026). "Generalized CliqueBots in Open-Source Game Theory." LessWrong.** https://www.lesswrong.com/posts/hcAQe3snm9qEzXBBz/generalized-cliquebots-in-open-source-game-theory
This proposes an "interface-relative CliqueBot": cooperate iff a fixed finite set of probe functions gives the same outputs on me and on you. It unifies CliqueBot, FairBot, GroundedBot and others, and gives conditions for unexploitability. It is the closest to idea 2 (membership defined by a property, not syntax). Difference: membership is interface *equality*, with no certificate and no diagonal standard over certified opponents. Its proof-based instances still search.

**Oesterheld, C. (2019). "Robust program equilibrium." Theory and Decision 86(1):143–159.** https://ideas.repec.org/a/kap/theord/v86y2019i1d10.1007_s11238-018-9679-3.html
**Cooper, Oesterheld, Conitzer (2025). "Characterising Simulation-Based Program Equilibria." AAAI 2025. arXiv:2412.14570.** https://arxiv.org/abs/2412.14570
These use simulation instead of proof (εGrounded FairBot) and give folk-theorem characterisations. Difference: they check behaviour by running the opponent, not by checking a proof, and there are no certificates.

**Oesterheld, C. (2022). "A Note on the Compatibility of Different Robust Program Equilibria of the Prisoner's Dilemma." arXiv:2211.05057.** https://arxiv.org/abs/2211.05057
This shows that εGrounded FairBot and proof-based FairBot cooperate with each other. It is directly relevant to our open "bridging" problem, which our standards do not get for free.

**Critch, Dennis, Russell (2022). "Cooperative and uncooperative institution designs: Surprises and problems in open-source game theory." arXiv:2208.07006.** https://arxiv.org/abs/2208.07006
This gives surprising cooperative and uncooperative results and ten open problems. I found no certificate mechanism in the abstract (full text not checked).

**Background (verified bibliographic records; no certificates):** Tennenholtz (2004), "Program equilibrium", GEB 49(2):363–373 (https://bibbase.org/network/publication/tennenholtz-programequilibrium-2004), which uses syntactic-equality cooperation. Kalai, Kalai, Lehrer, Samet (2010), "A commitment folk theorem", GEB 69:127–137 (https://www.tau.ac.il/~samet/papers/commitments.pdf). Fortnow (2009), "Program equilibria and discounted computation time", TARK (https://www.kellogg.northwestern.edu/research/math/papers/1473.pdf). Halpern & Pass (2013), "Game Theory with Translucent Players", arXiv:1308.3778. van der Hoek, Witteveen, Wooldridge (2013), "Program equilibrium: a program reasoning approach", IJGT 42(3):639–671 (https://ideas.repec.org/a/spr/jogath/v42y2013i3p639-671.html), which conditions programs on model checking. DiGiovanni & Clifton (2023), "Commitment games with conditional information disclosure", AAAI (arXiv:2204.03484). Sauerberg & Oesterheld (2025), "Promises Made, Promises Kept: SPIs via Ex Post Verifiable Commitments", GAIW@AAMAS (arXiv:2505.00783). Oesterheld et al. (2023), "Similarity-based cooperative equilibrium", NeurIPS (arXiv:2211.14468). Willis (19 Aug 2026), "A failed solution to open-source game theory", LW: a "nice-property" checker that was abandoned.

**Trust one level up (idea 3) background:** Fallenstein & Soares (2015), "Vingean Reflection: Reliable Reasoning for Self-Improving Agents", MIRI tech report (https://intelligence.org/files/VingeanReflection.pdf). This covers the Löbian obstacle to an agent trusting its own proof system. We sidestep it by proving the small system sound in a stronger one (Lean) and never having the system trust itself. I did not find this pattern applied to program equilibrium anywhere.

## B. LLM agents / AI contracts (2024–2026)

**Ciliberto, Rudi, Tassi (Oct 2026). "Proof-Carrying Contracts: Commitments AI Agents Cannot Break." arXiv:2610.28484.** https://arxiv.org/html/2610.28484v1 ; Lean code: https://github.com/consequential-ai/proof-carrying-contracts
Before each tool call, an agent must supply a machine-checkable proof that the call keeps the contract's constraints. A runtime "Airlock" checks it. The Lean 4 mechanization has no `sorry`. It is close to idea 1 in spirit (proof-carrying, cheap checking, small trusted checker). Difference: proofs cover individual *actions* against a fixed contract, not the agent's code. The paper says it "never looks inside the agent". There is no PD, no program equilibrium, no self-reference, and no mutual certificate exchange.

**Levine, L. (Sep 2026). "Math for AI Safety: An Invitation for Mathematicians." arXiv:2609.15289.** https://arxiv.org/abs/2609.15289
Section 2 presents FairBot_k proof search and poses open problem MAIS-O1: the proof-length overhead in bounded Löb, and whether the cooperation threshold k̂ grows polynomially. It does not propose exchanging certificates. Our approach avoids that cost question rather than answering it.

**Ondras, J. (2026). "Lean-Verified Handshake: A Mechanized Commitment Kernel Against Coordination Failure Among Opaque AI Agents." ICML 2026 workshop (Failure Modes in Agentic AI).** https://icml.cc/virtual/2026/77909
This is a Lean 4 binding-attestation wrapper that makes attesting Cooperate weakly dominant in Stag-Hunt-type games for *opaque* agents, under a `TrustedOracle` assumption. It shares Lean, commitments and a program-equilibrium motivation with our work. Difference: trust comes from an oracle or attestation rather than proofs about code, the games are Stag Hunt rather than PD, and there is no self-referential standard.

**Sistla & Kleiman-Weiner (2025). "Evaluating LLMs in Open-Source Games." NeurIPS 2025. arXiv:2512.00371.** https://arxiv.org/html/2512.00371v1
LLMs write and read strategy code in program games. The authors leave open "whether LLM-generated code can meet machine-checkable safety proofs", which is the gap that idea 4 fills.

**Other LLM program-game work, none with certificates:** Lin et al. (c. late 2025), "Policy-Conditioned Policies for Multi-Agent Task Solving", arXiv:2512.21024. Hewson (28 Feb 2026), "Program Games for LLMs", Substack (https://josephhewson1.substack.com/p/program-games-for-llms), which suggests formal verification as untried future work. Glass (Aug 2026), "The Open-Strategy Dictator Game", arXiv:2608.14913, where LLM judgment replaces proof. Wyse et al. (Jul 2026), "Commitment To Cooperation With Self-Negotiated Contracts", arXiv:2607.22750.

**Proof-carrying AI outputs, outside game theory:** Koomullil (May 2026), "Proof-Carrying Certificates for LLM Pipelines", arXiv:2605.16407. Avni, Dolev, Yagudaev, Yung (2026), "Proof-Carrying Output", IACR ePrint 2026/994. Wang (2026), "Proof-Carrying Agent Actions", arXiv:2606.04104. All of these use certificates checked by a verifier or auditor; none involve strategic cooperation or self-reference.

## C. Cryptography / blockchain

**bryjnar (25 Oct 2017). "Zero-Knowledge Cooperation." LessWrong.** https://www.lesswrong.com/posts/TDHDWMP5PRk4f3zrR/zero-knowledge-cooperation
An agent proves a property of its hidden decision code (via ZK, or FHE that evaluates a validator) without revealing the code. This is close to idea 1, since it checks a property rather than reading the code. Difference: it is informal, with no standard, no PD equilibrium analysis and no formal system.

**"Proof of Collusion: How Perfect Trust Enables Perfect Betrayal," shortform comment in Alexander Gietelink Oldenziel's LW shortform thread.** https://greaterwrong.com/posts/tDkYdyJSqe3DddtK4/alexander-gietelink-oldenziel-s-shortform/comment/ff5WyvF4AKHs3peXA
**Author and date UNVERIFIED** (the page shows neither). It speculates that AIs could exchange PCP/ZK-compressed formal proofs of their commitments, combined with Löbian cooperation, to collude. It is a conceptual cousin of idea 1, framed as a safety risk, and gives no construction.

**Others, none with self-referential standards:** Sun, Crapis, Stephenson, Monnot, Thiery, Passerat-Palmbach (2023), "Cooperative AI via Decentralized Commitment Devices", arXiv:2311.07815. Gudmundsson & Hougaard (2025), "Smart contracts and reaction-function games", arXiv:2506.14413, where one-shot reaction-function commitments act as a smart-contract analogue of program equilibrium. Hubáček & Yeo, "On Cryptographic Cheap Talk with Smart Contracts" (FC'26 preproceedings, per URL https://fc26.ifca.ai/preproceedings/30.pdf). Canetti, Fiat, Gonczarowski, "Mechanism Design Without Disclosure", arXiv:2302.05590, which commits to hidden mechanisms using ZK. Gopalakrishna (2026), "Zero-Knowledge Predicate Proofs Between AI Agents", arXiv:2608.30083. Lycklama et al., "Artemis: Commit-and-Prove SNARKs for zkML", arXiv:2409.12055.

**Could not read:** the GitHub issue "Certificates for joint behavior" (public-observatory/open-source-game-theory, issue #2; https://github.com/public-observatory/open-source-game-theory/issues/2). It turned up in a search, but every fetch was blocked. Its title is highly relevant, so check it by hand. It may be your own project's repo.

## Closest matches (ranked)
1. **gRR's comment on "AI cooperation in practice" (LW, c. 2010–12):** check an attached proof plus a diagonalized `ChecksOut`. It is idea 1+2 in embryo, abandoned over compatibility worries.
2. **Duclaux et al. 2026 (Lean OSGT):** Lean + LLMs + PD, but with proof search as an axiom and no certificates.
3. **Proof-Carrying Contracts (Ciliberto, Rudi, Tassi 2026):** proof-carrying with a small checker in Lean, but per-action and not game-theoretic.
4. **Arsen, "Generalized CliqueBots" (2026):** property-based membership and unexploitability, but no certificates.
5. **Critch 2019 / Barasz et al. 2014:** the baseline we improve on (bounded and unbounded Löbian search). bryjnar 2017 and Ondras 2026 come next.

## Verdict for this area
I found **no published paper** in which program-equilibrium agents cooperate by *checking an attached certificate* against a *self-referential membership standard*. The same holds for using a small proof system that is proved sound one level up in Lean and avoids Löb, or for having resource caps and LLM-generated members. The only real precursor is an informal LessWrong comment (gRR) that proposed proof-passing with a diagonal predicate and then abandoned it. Formal work (Critch, Barasz, Duclaux) uses proof search. Proof-carrying work (PC2, PCO) lacks self-reference and strategic cooperation. Claims 1–4 look novel as a combination. We should cite gRR and bryjnar as informal antecedents, and Oesterheld 2022 for the bridging question. One loose end remains: the unread GitHub issue.
