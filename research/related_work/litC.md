# LitC: Prior art for certificate-checking program-equilibrium agents (agent foundations and logic)

Every item below was found and checked on the web. Items marked **[UNVERIFIED]** were found but their content could not be read in full.

## A. AI safety / agent foundations

**1. Yudkowsky, E. & Herreshoff, M. (2013). "Tiling Agents for Self-Modifying AI, and the Löbian Obstacle." MIRI draft.** http://intelligence.org/files/TilingAgentsDraft.pdf (discussion: https://www.greaterwrong.com/posts/gnxDNEtkEo3sfeyPn/tiling-agents-for-self-modifying-ai-opfai-2)
This paper names the Löbian obstacle: an agent that proves things in T cannot license a successor that also uses T. It proposes workarounds such as descending theory hierarchies and parametric polymorphism. *Closeness:* this is the problem our idea 3 addresses. *Difference:* it covers a single agent and its successors, and its fixes change the trusted theory rather than moving trust to a separate checked object system S.

**2. Fallenstein, B. & Soares, N. (2014). "Problems of self-reference in self-improving space-time embedded intelligence." AGI 2014, LNCS 8598 (doi 10.1007/978-3-319-09274-4_3).** https://intelligence.org/wp-content/uploads/2014/05/Fallenstein-Soares-Problems-of-self-reference-in-self-improving-space-time-embedded-intelligence.pdf
This paper defines the **suggester–verifier** architecture. An untrusted suggester returns an action together with a formal proof that the action is at least as good as a fallback, and the agent only checks that proof in T. It also covers T_n hierarchies and an ascending chain of sound theories. *Closeness:* this is the clearest prior case of "check a supplied proof instead of searching for one" (our idea 1). *Difference:* the proof comes from one's own subsystem, not from an opponent. There is no game, no self-referential membership standard, and nothing is mechanized.

**3. Fallenstein, B. & Soares, N. (2015). "Vingean Reflection: Reliable Reasoning for Self-Improving Agents." MIRI tech report 2015-2.** https://intelligence.org/files/VingeanReflection.pdf
A survey of proof-based reasoning about smarter successors, including model polymorphism (§6.3). *Closeness and difference:* same framing as item 2. It is single-agent and contains no certificates exchanged between peers.

**4. Fallenstein, B. & Kumar, R. (2015). "Proof-producing reflection for HOL, with an application to model polymorphism." ITP 2015, LNCS 9236 (doi 10.1007/978-3-319-22102-1_11).** https://www.openphilanthropy.org/files/Grants/MIRI/Fallenstein_Kumar_2015.pdf
In HOL4 the authors build an inner model of HOL inside outer HOL. Using large-cardinal assumptions, they prove a reflection principle ("if ⌜φ⌝ is provable in inner HOL then φ"). They then build a self-replacing system that installs a new version only when given a proof that the version is safe. *Closeness:* the **nearest technical analogue to idea 3**. It is a machine-checked, one-level-up soundness proof of an inner proof system, used to get around Gödel/Löb, with installation gated on a supplied proof. *Difference:* the inner system is full HOL plus cardinal assumptions rather than a small S without reflection. The setting is single-agent self-replacement with no multi-agent game and no diagonal standard K.

**5. Barasz, M., Christiano, P., Fallenstein, B., Herreshoff, M., LaVictoire, P. & Yudkowsky, E. (2014). "Robust Cooperation in the Prisoner's Dilemma: Program Equilibrium via Provability Logic." arXiv:1401.5577.** https://arxiv.org/abs/1401.5577 . Companion paper: LaVictoire et al., "Program Equilibrium in the Prisoner's Dilemma via Löb's Theorem," MIPC 2014 workshop: https://mipc.inf.ed.ac.uk/2014/papers/mipc2014_lavictoire_etal.pdf
These papers introduce FairBot and PrudentBot, modal agents that cooperate when they find a proof that the opponent cooperates. Mutual cooperation follows from Löb. *Closeness:* this is the baseline we replace. *Difference:* agents search for proofs, and cooperation rests on Löb rather than on checking a certificate.

**6. Critch, A. (2019). "A parametric, resource-bounded generalization of Löb's theorem, and a robust cooperation criterion for open-source game theory." J. Symbolic Logic 84(4) (doi 10.1017/jsl.2017.42); arXiv:1602.04184.** https://arxiv.org/abs/1602.04184
This paper proves a bounded Löb's theorem so that FairBots with limited proof search still cooperate. *Closeness:* matches our use of resource caps (idea 4). *Difference:* it still relies on proof search plus (bounded) Löb, with no attached proofs.

**7. Critch, A. (2022). "Löb's Lemma: an easier approach to Löb's Theorem," LessWrong, 24 Dec 2022.** https://lesswrong.com/posts/AkGvmJ6WE5sXjuwnC . **Critch, A. (2023). "Modal Fixpoint Cooperation without Löb's Theorem," LessWrong, 5 Feb 2023.** https://www.lesswrong.com/posts/2WpPRrqrFQa6n2x3W
The 2023 post uses Payor's lemma, ⊢□(□x→x)→x ⇒ ⊢x, to prove group cooperation for agents A ↔ □(□A→B) without an auxiliary Löb fixpoint. *Closeness:* shares our goal of "cooperation without Löb". *Difference:* it still rests on provability (□). Our move is to replace □ with an explicit certificate check, so the remaining loop becomes a definition (diagonal lemma).

**8. Duclaux, C., Formenti, R., Cobben, P., Schölkopf, B. & Jin, Z. (2026). "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean." ICML 2026 workshop (3rd AI for Math).** https://icml.cc/virtual/2026/82498 (OpenReview id Wc5TAIUC8k, which I could not fetch)
The first Lean 4 formalization of proof-based open-source game theory (OSGT). It covers nine bots with machine-checked outcome theorems and an LLM pipeline that re-proves 40 of 45 pairwise outcomes. *Closeness:* **very close on idea 4** (Lean, Prisoner's Dilemma bots, machine-checked). *Difference:* the bots condition on bounded proof search. Proofs are written for analysis and are not attached certificates checked at play time. There is no K standard and no small inner system S.

**9. Schmidhuber, J. (2003). "Gödel Machines: Self-Referential Universal Problem Solvers Making Provably Optimal Self-Improvements." arXiv:cs/0309048.** https://arxiv.org/abs/cs/0309048
A Gödel machine rewrites itself only after its own proof searcher proves the rewrite useful. *Difference:* the proofs are self-found and self-trusted, the setting is single-agent, and the Löbian issue is not addressed.

**10. Demski, A. & Garrabrant, S. (2019). "Embedded Agency." arXiv:1902.09469.** https://arxiv.org/abs/1902.09469
A survey that includes robust delegation and Vingean reflection. It is background only and has no certificate mechanism.

**11. Other OSGT works checked, none close:** Oesterheld, "Robust program equilibrium," *Theory and Decision* 86 (2019), simulation-based (https://link.springer.com/10.1007/s11238-018-9679-3). van der Hoek, Witteveen & Wooldridge, "Program equilibrium—a program reasoning approach," *IJGT* 42 (2013), temporal-logic guards (https://www.cs.ox.ac.uk/people/michael.wooldridge/pubs/ijgt2013.pdf). Critch, Dennis & Russell, arXiv:2208.07006 (2022). cousin_it, "AI cooperation in practice," LessWrong 2010 (bounded proof search with diagonal lemma and Löb). Arsen, "Generalized CliqueBots in OSGT," LessWrong, Oct 2026: interface-equality cliques with no membership proofs, though conceptually a "membership standard" (https://www.lesswrong.com/posts/hcAQe3snm9qEzXBBz). Levine, "Math for AI safety," arXiv:2609.15289 (2026): no certificate exchange.

**12. Code repositories (informal, not peer reviewed):**
- *CharlesCNorton/tiling-verified* (https://github.com/CharlesCNorton/tiling-verified). Rocq formalization of a GLP-style provability tower for tiling agents, where level n+1 proves Con(level n), plus FairBot/PrudentBot. It is one-level-up trust like idea 3, but in modal style with no certificates.
- *zhongmingjiang/Proof_of_Lobian_Cooperation* (https://github.com/zhongmingjiang/Proof_of_Lobian_Cooperation). Informal position paper, "Proof of Löbian Cooperation: A Peer-to-Peer Explicit Recursive Alignment Protocol." It names a "minimal Lean 4 micro-kernel" as trusted checker but is still Löb/FairBot-based and contains no mechanized proofs. **[UNVERIFIED in detail]**: the full text was unreadable, so it is unclear whether agents pass certificates.
- *namin/lean-loeb* ("The Löbian obstacle to self-modifying systems, as Lean 4 theorems"). **[UNVERIFIED]**: rate-limited, seen only as a search title.
- GitHub issue "Certificates for joint behavior" (public-observatory/open-source-game-theory #2). **[UNVERIFIED]**: the title matches the topic, but the content could not be read because repo access was declined. **Check this manually; it could be close to idea 1.**

## B. Logic

**13. Willard, D. (2001). "Self-verifying axiom systems, the incompleteness theorem and related reflection principles." JSL 66(2) (doi 10.2307/2695030).**
Weak arithmetics that prove their own consistency. *Difference:* this is the "trust oneself in a weak system" route. We avoid self-trust entirely.

**14. Harrison, J. (2006). "Towards self-verification of HOL Light." IJCAR 2006, LNCS 4130 (doi 10.1007/11814771_17).** https://www.cl.cam.ac.uk/~jrh13/papers/holhol.pdf
This paper proves Con(HOL−∞) in HOL and Con(HOL) in HOL plus a large-cardinal axiom I, by a soundness induction over a deep embedding. *Closeness:* this is exactly the "**soundness one level up**" pattern of idea 3, for a prover kernel. *Difference:* no agents or games are involved.

**15. Davis, J. & Myreen, M. (2015). "The reflective Milawa theorem prover is sound (down to the machine code that runs it)." J. Automated Reasoning.** https://www.cl.cam.ac.uk/~mom22/2015-jar-milawa.pdf . **Abrahamsson, O., Myreen, M., Kumar, R. & Sewell, T. (2022). "Candle: A Verified Implementation of HOL Light." ITP 2022, LIPIcs 237 (doi 10.4230/LIPIcs.ITP.2022.3).**
These are verified checkers whose soundness is proved in an outer system. They support the engineering side of idea 3 but have no game-theoretic use.

**16. Boutin, S. (1997). "Using reflection to build efficient and certified decision procedures." TACS 1997, LNCS 1281 (doi 10.1007/BFb0014565).**
Proof by reflection: a checker is proved sound once and then run. Our pattern ("Lean proves S sound, then runs checkS on certificates") is this technique applied to agents.

**17. Necula, G. (1997). "Proof-Carrying Code." POPL '97, 106–119 (doi 10.1145/263699.263712).**
Untrusted code ships with a safety proof that the consumer checks with a small trusted checker. *Closeness:* the **direct systems ancestor of idea 1**. *Difference:* the policy is fixed and non-self-referential, and there is no strategic or mutual setting.

**18. Yanofsky, N. (2003). "A Universal Approach to Self-Referential Paradoxes, Incompleteness and Fixed Points." Bull. Symbolic Logic 9(3); arXiv:math/0305282.** https://arxiv.org/abs/math/0305282 . **Abramsky, S. & Zvesper, J. "From Lawvere to Brandenburger–Keisler: interactive forms of diagonalization and self-reference." arXiv:1006.0992** (published in J. Comput. Syst. Sci., c. 2015; volume not checked).
Yanofsky unifies diagonal arguments through Lawvere's theorem. Abramsky and Zvesper apply the Lawvere fixpoint to *interactive epistemic* settings, giving an impossibility result for belief models. *Difference:* both are used for impossibility, not for building a cooperative standard. Neither applies Lawvere or Kleene to define a program-equilibrium membership predicate like K.

**19. Justification logic.** Yavorskaya (Sidon), T. (2006). "Multi-agent Explicit Knowledge." CSR 2006, LNCS 3967 (doi 10.1007/11753728_38). Shamkanov, D. (2016). "A realization theorem for the Gödel–Löb provability logic." Sb. Math. 207(9):1344–1360 (https://www.mathnet.ru/eng/sm8667).
Yavorskaya studies two interacting explicit-evidence (proof-term) systems. Shamkanov gives explicit proof terms realizing GL. *Closeness:* this is the logical counterpart of "replace □ with explicit certificates." Shamkanov's realization of GL is a potential bridge to why our K needs no Löb. *Difference:* no games and no agents trusting each other's certificates. **I found no paper applying justification logic to program equilibrium.**

## Closest matches (ranked)
1. **Fallenstein & Soares 2014 (suggester–verifier)**: check a supplied proof instead of searching for one. Single-agent, not a game.
2. **Fallenstein & Kumar 2015 (HOL4 reflection, model polymorphism)**: mechanized one-level-up soundness of an inner prover, used to sidestep Gödel/Löb when gating self-replacement on a supplied proof. Closest to idea 3.
3. **Duclaux et al. 2026 (Lean OSGT)**: Lean-mechanized Prisoner's Dilemma bots. Still proof-search/Löbian, with no certificates or K.
4. **Necula 1997 PCC + Harrison 2006**: the systems and logic ancestors of ideas 1 and 3 respectively, outside game theory.
5. **Critch 2023 (Payor) / Critch 2019 (bounded Löb)**: Löb-free cooperation via a different route (still provability-based), plus resource bounds.
(Not checked, possibly close: the public-observatory issue "Certificates for joint behavior"; zhongmingjiang's position paper.)

## Verdict for this area
Each ingredient has precedent in isolation:
- checking a supplied proof (PCC; suggester–verifier)
- soundness proved one level up for an inner checker (Harrison; Fallenstein–Kumar; Candle)
- resource-bounded cooperation (Critch)
- Lean-mechanized OSGT (Duclaux et al. 2026)

I found **no verified work** that combines them in multi-agent program equilibrium. In particular, I found nothing with (i) opponents attaching certificates that are checked at play time, or (ii) a diagonal-lemma-defined membership standard K whose loop is definitional rather than provability-based. Ideas 1–2 together appear novel in this literature. Ideas 3–4 are novel in application but well-precedented in technique, so cite Fallenstein–Kumar, Harrison, Necula and Duclaux et al. Two GitHub items were only partly readable and should be checked before claiming priority.
