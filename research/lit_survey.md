# Annotated bibliography: bounded / feasible proof-based cooperation and proof exchange

Each item is tagged for relevance to (i) feasibility and time bounds, (ii) proof exchange, (iii) Löb with explicit proofs. Every item below was found online; caveats are marked **[uncertain]**.

## A. Follow-ups to Barasz et al. 2014 and Critch 2016/2019

1. **LaVictoire, Fallenstein, Yudkowsky, Bárász, Christiano, Herreshoff.** "Program Equilibrium in the Prisoner's Dilemma via Löb's Theorem." MIPC workshop at AAAI 2014. https://mipc.inf.ed.ac.uk/2014/papers/mipc2014_lavictoire_etal.pdf
   The short workshop version of the modal-agents paper. (i) It says plainly that the agents cannot be computed in practice and that FiniteFairBot (proof length ≤ N) may need "intractably long computations". Their Haskell evaluator computes outcomes efficiently, but it does this at the level of GL, not by running the agents. This is the earliest admission of your critique.

2. **Critch, Dennis, Russell.** "Cooperative and uncooperative institution designs: Surprises and problems in open-source game theory." arXiv:2208.07006 (2022). https://arxiv.org/abs/2208.07006
   Gives surprising cooperation and defection outcomes for open-source agents and lists ten open problems. From the abstract alone I could not tell whether it addresses time bounds (**[uncertain]**; only the abstract and metadata were checked).

3. **Critch.** "Modal Fixpoint Cooperation without Löb's Theorem." LessWrong/Alignment Forum, 5 Feb 2023. https://www.lesswrong.com/posts/2WpPRrqrFQa6n2x3W/modal-fixpoint-cooperation-without-loeb-s-theorem
   Uses Payor's lemma (if ⊢ □(□x→x)→x then ⊢ x) to get cooperation from necessitation, distributivity and modus ponens alone. The cooperation proof is about three times shorter than the Löb route (~6 lines vs ~18). (i)/(iii) Shorter certificates are directly useful for proof exchange. It does not analyse running time.

4. **Garrabrant.** "Prisoners' Dilemma with Costs to Modeling." Alignment Forum, 5 Jun 2018. https://www.alignmentforum.org/posts/XjMkPyaPYTf7LrKiT/prisoners-dilemma-with-costs-to-modeling
   Charges agents a penalty proportional to the modal depth of their code. With small penalties, the only pure equilibrium is defection, but a mixed CooperateBot/FairBot/PrudentBot equilibrium recovers the FairBot payoff. (i) The cost is an abstract depth penalty, not the cost of proof search.

5. **Duclaux, Formenti, Cobben, Schölkopf, Jin.** "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean." ICML 2026 workshop (3rd AI for Math). https://icml.cc/virtual/2026/82498 ; OpenReview https://openreview.net/forum?id=Wc5TAIUC8k
   The first Lean 4 formalization of proof-based OSGT: nine bots with machine-checked pairwise outcome theorems, an LLM pipeline that re-proves 40 of the 45, and an enumeration of the Nash equilibria of the meta-game. (iii) Machine-checked outcome proofs are exactly the objects a proof-exchange protocol would pass between agents. Which bots are covered, and whether bounded Löb is included, was not visible in the abstract (**[uncertain]**).

6. **Levine.** "Math for AI Safety: An Invitation for Mathematicians." arXiv:2609.15289 (Sep 2026). https://arxiv.org/abs/2609.15289
   Problem MAIS-O1 asks for the least overhead F_S(k,|P|) in bounded Löb and for an explicit threshold k̂ at which two FairBot_k agents cooperate. It suggests computing the smallest working k empirically. The acknowledgments report that an AI auditor found a **gap in the published proof of Critch's bounded Löb theorem**, that Critch corrected a hypothesis (X post, 28 Jul 2026), and that a version is now proved in Lean. The nature of the gap is not described (**[uncertain]**; I did not find the X post). (i) This is the clearest statement that concrete bounds are still open.

## B. Time-bounded or feasible proof-based cooperation; cost of proof search

7. **Fortnow.** "Program Equilibria and Discounted Computation Time." Northwestern CMS-EMS Discussion Paper 1473, 2008 (also TARK 2009 per Critch's citation; **[uncertain]**: dblp page blocked). https://www.kellogg.northwestern.edu/research/math/papers/1473.pdf
   Payoffs are discounted by δ^t, where t is the program's running time. This gives a folk theorem over general Turing machines. (i) It is the main existing model that charges for time inside program equilibrium, but its cooperative programs are syntactic (code comparison), not proof-based.

8. **Fortnow, Santhanam.** "Bounding Rationality by Discounting Time." arXiv:0911.3162 (2009). https://arxiv.org/abs/0911.3162
   Extends time-discounting to general games and ties the existence of equilibria to average-case hardness. (i) A template for making "feasible" precise.

9. **Krajíček, Pudlák.** "Propositional proof systems, the consistency of first order theories and the complexity of computations." JSL 54(3):1063–1079, 1989. https://www.karlin.mff.cuni.cz/~krajicek/scan10.pdf
   Relates short proofs of bounded consistency Con_T(n) to optimal proof systems. It recalls Pudlák's polynomial upper bound and Friedman's n^ε lower bound. (i) This is the proof-complexity machinery behind bounded Löb's overhead. It also separates the *existence* of short proofs from *finding* them, which is the very distinction your critique depends on.

10. **Oesterheld, Demski, Conitzer.** "A Theory of Bounded Inductive Rationality." TARK 2023, EPTCS 379. arXiv:2307.05068. https://arxiv.org/abs/2307.05068
    Agents test efficiently computable hypotheses instead of proving theorems, and the paper proves a folk theorem for such learners. (i) A feasible alternative that drops proof altogether.

No paper I found gives a polynomial-*time* Löbian cooperation result. See Gaps.

## C. Simulation-based alternatives

11. **Oesterheld.** "Robust Program Equilibrium." Theory and Decision 86(1), 2019. DOI 10.1007/s11238-018-9679-3. https://link.springer.com/article/10.1007/s11238-018-9679-3
    ε-grounded FairBot: cooperate with probability ε, otherwise simulate the opponent and copy its action. Against itself it halts with probability 1. (i) It is cheap when simulation is cheap, and it needs no proofs at all.

12. **Oesterheld.** "A Note on the Compatibility of Different Robust Program Equilibria of the Prisoner's Dilemma." arXiv:2211.05057 (2022). https://arxiv.org/abs/2211.05057
    Shows that ε-grounded FairBot and proof-based FairBot cooperate with each other. (ii) Mixed populations of checkers and simulators can still interoperate.

13. **Cooper, Oesterheld, Conitzer.** "Characterising Simulation-Based Program Equilibria." AAAI 2025. arXiv:2412.14570. https://arxiv.org/abs/2412.14570
    Generalises εGroundedπBot. It proves a folk theorem with shared randomness and gives a characterisation without it. (i) Unmemoised runtime can be infinite in expectation. With memoisation it is polynomial in 1/min ε, given polynomial-time policies. This is the most explicit runtime analysis in the area.

14. **Kovařík, Oesterheld, Conitzer.** "Game Theory with Simulation of Other Players." IJCAI 2023, pp. 2800–2807. https://www.ijcai.org/proceedings/2023/0312.pdf
    Treats simulation as an action with cost c and maps out how equilibria change with c. (i) An explicit cost model for "looking inside" the opponent.

15. **Kovařík, Oesterheld, Conitzer.** "Recursive Joint Simulation in Games." arXiv:2402.08128 (venue **[uncertain]**). https://arxiv.org/abs/2402.08128
    Shows that nested joint simulation is equivalent to a discounted repeated game. (iii) The nesting is a well-founded analogue of the circularity in proof exchange.

16. **Oesterheld, Treutlein, Grosse, Conitzer, Foerster.** "Similarity-based cooperative equilibrium." NeurIPS 2023. https://proceedings.neurips.cc/paper_files/paper/2023/hash/4d0b6303d4a4811445f69f357bf6def5-Abstract.html
    Observing a single similarity score is enough to support the cooperative outcomes of full transparency. (ii) This is a minimal "certificate".

## D. Proof exchange, certificates, verifiable commitments

17. **Necula.** "Proof-carrying code." POPL 1997, pp. 106–119.
    The classic split: an untrusted producer builds the proof and a consumer checks it cheaply. (ii) This is the architectural template for your protocol. (Citation verified via the reference list of item 18.)

18. **Ciliberto, Rudi, Tassi.** "Proof-Carrying Contracts: Commitments AI Agents Cannot Break." arXiv:2610.28484 (Oct 2026). https://arxiv.org/abs/2610.28484
    Before each tool call, the agent must supply a Lean 4 proof that the call preserves a contract. A small checker (the "Airlock") verifies the proof before running the call. (ii) This is the closest recent work to proof exchange. However, it covers **one agent under one contract**, defers multi-party exchange to later work, and does not cite Löb or FairBot. It notes the search-vs-checking asymmetry only qualitatively.

19. **DiGiovanni, Clifton.** "Commitment Games with Conditional Information Disclosure." AAAI 2023. arXiv:2204.03484. https://arxiv.org/abs/2204.03484
    Program-equilibrium-style conditional commitments for agents with private information. It proves a folk theorem and gives an ε-Bayesian implementation. (ii) Relevant if exchanged proofs should reveal only part of each agent.

20. **bryjnar.** "Zero-Knowledge Cooperation." LessWrong, 25 Oct 2017. https://lesswrong.com/posts/TDHDWMP5PRk4f3zrR
    Proposes proving "I am a cooperator" without revealing one's source, via FHE and a validator. (ii) An informal precursor of exchanging proofs about one's own program. It does not mention Löb.

21. **Dodis, Halevi, Rabin.** "A Cryptographic Solution to a Game Theoretic Problem." CRYPTO 2000, pp. 112–130. (Verified via a LessWrong review: https://www.lesswrong.com/posts/FjbwBbwzy9Cred6Gg)
    Replaces a trusted mediator with a protocol that uses zero-knowledge proofs. (ii) Shows that verifiable protocols can stand in for trust in a game-theoretic setting.

22. **Sistla, Kleiman-Weiner.** "Evaluating LLMs in Open-Source Games." NeurIPS 2025. arXiv:2512.00371. https://arxiv.org/abs/2512.00371
    LLMs read strategy code (above 85% accuracy at predicting cooperation) and write adaptive programs. (i) Here the agents comprehend code heuristically rather than searching for proofs.

23. **berns.** "Verify, but Trust." LessWrong, 17 Apr 2026. https://www.lesswrong.com/posts/2RQHoZrCoqXiLg4TM/verify-but-trust-1
    Separates trust in the checking "kernel" from trust in the "context" (whether the spec matches real intent). (ii) A conceptual caveat for proof exchange: a checked proof only certifies the formal statement it proves.

24. **[uncertain, unvetted]** GitHub essay "Proof of Löbian Cooperation: A Peer-to-Peer Explicit Recursive Alignment Protocol for Autonomous Agents" (no named author; repo zhongmingjiang/Proof_of_Lobian_Cooperation). https://github.com/zhongmingjiang/Proof_of_Lobian_Cooperation
    Claims a Lean-based peer-to-peer Löbian protocol, but contains no compiled proofs. Listed only so you know it exists; I would not cite it.

## E. Justification logic, GL with explicit proofs, circularity

25. **Artemov.** "Explicit provability and constructive semantics." Bull. Symb. Logic 7(1):1–36, 2001. https://www.cambridge.org/core/journals/bulletin-of-symbolic-logic/article/abs/explicit-provability-and-constructive-semantics/F89DDB2A5642225222F0454B2DDFDF48
    The Logic of Proofs (LP). (iii) Foundation for t:F.

26. **Shamkanov.** "A realization theorem for the Gödel–Löb provability logic." Sb. Math. 207(9):1344–1360, 2016. DOI 10.1070/SM8667.
    A justification counterpart of GL with normal realizations, built using cyclic proofs. **Note:** arXiv:1401.4002 is a *different* paper, Shamkanov, "Circular proofs for the Gödel–Löb provability logic," Mat. Zametki 96(4):609–622, 2014.

27. **Iemhoff.** "Reasoning in circles." arXiv:2112.15028 (2022, Visser Liber Amicorum). https://arxiv.org/abs/2112.15028
    Proves "GL = circular K4" for ordinary two-sided sequent calculi, without infinitary proofs. (iii) The cleanest finitary statement of when circularity is sound.

28. **Nogina.** "On Logic of Formal Provability and Explicit Proofs" (GLA = GL + LP). arXiv:1405.2559. https://arxiv.org/abs/1405.2559 ; and **Fitting**, "A Second GL Justification Logic," author's note, 2020. https://id144254.securedata.net/melvinfitting/bookspapers/pdf/papers/GLJustification.pdf
    GLA lets explicit proofs and implicit provability coexist, which is close to an "I check your term t; PA proves my reasoning" protocol. Fitting explains why realizing the Löb axiom needs different terms for its occurrences of X.

29. **Kavvos.** "Intensionality, Intensional Recursion, and the Gödel–Löb Axiom." IfCoLog J. Logics Appl. 8(8):2287–2312, 2021. arXiv:1703.01288. https://arxiv.org/abs/1703.01288 ; **Nakano**, "A Modality for Recursion," LICS 2000, pp. 255–266; **Gross, Gallagher, Fallenstein**, "Löb's Theorem: A functional pearl of dependently typed quining" (ICFP 2016 submission draft). https://people.csail.mit.edu/jgross/personal-website/papers/2016-lob-icfp-2016-draft.pdf
    These read GL/Löb computationally: the Löb axiom acts as a typing rule for (intensional or guarded) recursion. (iii) They are the natural place to look for a well-founded semantics of circular proof exchange, where each agent's proof term is a guarded fixpoint.

I found no work that connects cyclic proofs to mutual reference *between agents*.

## Gaps (what appears not to have been done)

- **No time-bounded Löbian cooperation.** Every proof-based result bounds proof *length*. No paper gives polynomial-time agents that achieve robust (non-syntactic) proof-based cooperation. Concrete bounds for bounded Löb (F_S, k̂) are posed as open (Levine 2026), and the published proof is reported to have needed repair.
- **No proof-exchange FairBot.** I found no paper where agents hand each other proofs and cooperate iff the handed proof checks. Proof-Carrying Contracts (2026) is single-agent with no mutual conditioning, and Lean OSGT (2026) proves outcomes offline rather than exchanging them. The circularity of mutual proof exchange, and its game-theoretic robustness (exploitability by agents who send false proofs, or no proof), appear unstudied.
- **No bridge from cyclic proofs or justification-GL to agents.** Shamkanov/Iemhoff circular proofs and Kavvos/Nakano guarded recursion have not been applied to the inter-agent setting.
- **Runtime comparison.** Cooper et al. analyse simulation runtime, but nobody compares proof checking, proof search and simulation costs within one model (e.g., Fortnow-style δ^t discounting applied to Löbian agents).
