# Prior art check: "If P != NP, no polynomial-time agent is both fair and unexploitable"

Checked 2026-11-18. Every item below was opened and read; quotes are from the fetched text. "Not found" means the parts I read (sometimes a truncated rendering) did not contain it.

## A. Program equilibrium / open-source game theory

1. **Barasz, Christiano, Fallenstein, Herreshoff, LaVictoire, Yudkowsky (2014).** "Robust Cooperation in the Prisoner's Dilemma: Program Equilibrium via Provability Logic." arXiv:1401.5577. https://arxiv.org/abs/1401.5577
   Defines unexploitability exactly as we do. It also says the agents are "very far from efficient" and warns of "intractably long computations" even in finitary versions. No complexity-theoretic lower bound and no mention of NP. So it states the cost informally but does not argue it is unavoidable.

2. **LaVictoire et al. (2014).** "Program Equilibrium in the Prisoner's Dilemma via Löb's Theorem." MIPC workshop (AAAI 2014). https://mipc.inf.ed.ac.uk/2014/papers/mipc2014_lavictoire_etal.pdf
   This is the short version of item 1 and repeats the same caveat about "computationally intractable" oracle agents. No hardness argument.

3. **Critch (2019).** "A parametric, resource-bounded generalization of Löb's theorem, and a robust cooperation criterion for open-source game theory." *J. Symbolic Logic* 84(4):1368–1381. DOI 10.1017/jsl.2017.42. arXiv:1602.04184.
   Defines G-fairness, the property our "fair" generalizes. It discusses resource bounds only through proof length, plus linear-time proof *checking*. I found no runtime lower bound and no mention of NP or polynomial time.

4. **Critch, Dennis, Russell (2022).** "Cooperative and uncooperative institution designs: Surprises and problems in open-source game theory." arXiv:2208.07006.
   §4.2 notes that alphabetical proof search is "terribly inefficient, taking exponential time in the length of the proof." It says this has been "noted as potentially prohibitive" (citing Oesterheld 2019), and then argues that heuristic search can be fast for specific matchups. It also mentions "a trade-off between flexibility on implementation standards and speed of verification." That is the closest qualitative relative of our claim, but there is no theorem and no P/NP. Open Problems 4 and 9 (an efficient DUPOC; a computationally bounded PrudentBot) treat efficiency as open, which suggests the authors did not regard our impossibility as known.

5. **Oesterheld (2019).** "Robust program equilibrium." *Theory and Decision* 86(1):143–159. DOI 10.1007/s11238-018-9679-3.
   Says the benefits of proof-based programs "come at the cost of being computationally expensive." It uses this to motivate the simulation-based ε-GroundedFairBot. The claim is informal, with no lower bound.

6. **Oesterheld (2022).** "A Note on the Compatibility of Different Robust Program Equilibria of the Prisoner's Dilemma." arXiv:2211.05057.
   Mentions Critch's bounded proof search and that unbounded provability is undecidable. It says nothing about complexity.

7. **Cooper, Oesterheld, Conitzer (2025).** "Characterising Simulation-Based Program Equilibria." AAAI 2025. arXiv:2412.14570.
   Uses Rice's theorem to show that a semantic property is undecidable, then switches to a syntactic check. It also analyzes simulation runtime. No NP lower bound for recognizing cooperators. Our result is the polynomial-time analogue of their kind of Rice-style remark.

8. **Fortnow (2009).** "Program Equilibria and Discounted Computation Time." TARK 2009 (Northwestern CMS-EMS DP 1473). https://www.kellogg.northwestern.edu/research/math/papers/1473.pdf
   Discounts payoffs by δ^t, so computation time is penalized. It does not analyze how hard it is to tell that an opponent cooperates, and has no P/NP. (Note: arXiv:0911.3162 is a different paper, Fortnow & Santhanam, "Bounding Rationality by Discounting Time".)

9. **van der Hoek, Witteveen, Wooldridge (2013).** "Program equilibrium—a program reasoning approach." *IJGT* 42:639–671.
   Shows that deciding whether coherent outcomes exist is NP-complete (by reduction from SAT) and that counting them is #P-complete. That is hardness for the *analyst* of the outcome, not a lower bound on what an agent can do. It is related only in spirit.

10. **Kovařík, Oesterheld, Conitzer (2023).** "Game Theory with Simulation of Other Players." IJCAI 2023. arXiv:2305.11261.
    Shows that deciding whether simulation creates an equilibrium that Pareto-dominates every Nash equilibrium is co-NP-hard. Again this is hardness of equilibrium analysis, not of the agent.

11. **Levine (2026).** "Math for AI Safety: An Invitation for Mathematicians." arXiv:2609.15289.
    Open problem MAIS-O1 asks whether the bounded-Löb threshold grows polynomially, which is about proof *length*. The paper never mentions NP or P vs NP. Our argument would complement it: even if proofs are short, *finding* them cannot be polynomial for an unexploitable fair agent unless P = NP.

12. **Duclaux, Formenti, Cobben, Schölkopf, Jin (2026).** "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean." ICML 2026 AI for Math Workshop. https://icml.cc/virtual/2026/82498
    A Lean formalization. No complexity content.

## B. Bounded provability is NP-complete (the ingredient)

13. **Gödel's 1956 letter to von Neumann.** It asks how much time is needed to decide whether a formula has a proof of length n. Secondary sources:
    - Sipser, "The History and Status of the P versus NP Question," STOC 1992.
    - Urquhart, "Von Neumann, Gödel and Complexity Theory," *Bull. Symb. Logic* 16(4):516–530, 2010.

14. **Buss (1995).** "On Gödel's theorems on lengths of proofs II: Lower bounds for recognizing k symbol provability." In *Feasible Mathematics II*, Birkhäuser, pp. 57–90. https://mathweb.ucsd.edu/~sbuss/ResearchWeb/godeltwo/index.html
    Proves that k-symbol provability is NP-complete, even for propositional logic.
    Supporting sources: Aaronson, "Why Philosophers Should Care About Computational Complexity" (arXiv:1108.1791, §3.1), and Buss's 2021 Tübingen slides "Gödel and the Lengths of Proofs."
    Our argument is close to a corollary of this result. It adds the observation that unexploitability blocks the escape route "cooperate more often than required." I did not find this ingredient applied to proof-based agents in any game-theory paper.

## C. LessWrong / Alignment Forum

15. **cousin_it, "AI cooperation in practice" (LessWrong, 2010-07-30).** https://www.lesswrong.com/posts/TNfx89dh5KkcKrvho/ai-cooperation-in-practice
    The closest informal precedent I found. User "apophenia" comments that shortcutting the agent's bounded proof search, so as to establish "not provable in N steps," is a coNP-type question, so speeding it up for SAT-like cases is tied to P vs NP. That is the same intuition. But it is a comment rather than a statement, it is about speeding up one specific agent's search, it has no fair/unexploitable framing, and it has no B_φ reduction.

16. **Garrabrant, "Modal SAT: Introduction" (2015-08-08)** and **"Modal SAT: Self Cooperation" (2015-08-10).** https://www.lesswrong.com/posts/5bd75cc58225bf0670374fef/modal-sat-introduction
    Claims NP-hardness for *designing* a modal agent that elicits cooperation from given C-agents and defects against given D-agents, including a non-exploitable variant. The hardness of agent *synthesis* over a finite list is a different problem from our lower bound on an agent's own runtime.

17. **Other posts, no complexity content:**
    - Garrabrant, "Prisoners' Dilemma with Costs to Modeling" (2018-06-05): charges ε × modal depth.
    - cousin_it, "Bounded versions of Gödel's and Löb's theorems" (2012-06-27): says the proof search takes exp(g(n)) steps.
    - Arsen, "Generalized CliqueBots in Open-Source Game Theory" (2026-10-28): says "proof search can be ridiculously slow."

## D. Game theory with computational costs

18. **Halpern & Pass**, "Algorithmic rationality: Game theory with costly computation," *J. Econ. Theory* 156 (2015), arXiv:1412.2993; and "Game Theory with Translucent Players," arXiv:1308.3778.
    Both are frameworks for computational costs and transparency. Neither has program-equilibrium hardness results or anything about recognizing cooperators.

19. **Papadimitriou & Yannakakis**, "On complexity as bounded rationality," STOC 1994.
    I verified only the bibliographic record. It is about automaton-size limits in the repeated prisoner's dilemma and is not on point.

## Technical caveat worth stating in the write-up

Fairness needs a proof of length at most p(|B_φ|) that B_φ cooperates whenever φ is satisfiable. A naive PA proof that simulates the search would be exponentially long. The short proof is: exhibit the satisfying assignment, then apply a uniform lemma, proved once, that "search(φ) = C iff some assignment satisfies φ." Instantiating that lemma for φ should cost poly(|φ|) symbols. This is standard, but it should be stated, ideally with B_φ written so that its correctness lemma is schematic.

## Verdict

**Folklore-but-unstated.** The pieces are well known:
- bounded provability is NP-complete (Gödel 1956, Buss 1995);
- FairBot-style agents are "intractable" or "computationally expensive" (Barasz et al. 2014, Oesterheld 2019, Critch–Dennis–Russell 2022);
- an informal 2010 LessWrong comment links shortcutting bounded proof search to P vs NP.

I found no source that states the theorem "fair + unexploitable + polynomial-time implies P = NP," or the B_φ reduction, or the conclusion that feasible unexploitable agents must restrict whom they cooperate with (for example, to opponents that supply certificates). Present it as a simple observation with these citations, not as a deep new result.
