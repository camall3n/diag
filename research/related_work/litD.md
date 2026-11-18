# Lit search D: circular assume-guarantee, MAS commitments and certification, and institutions

Every citation was checked against a publisher, arXiv or author page. **[unverified]** marks a detail that could not be confirmed.

## A. Formal verification: making circular reasoning sound

**A1. K. L. McMillan, "Circular Compositional Reasoning about Liveness," CHARME 1999, LNCS 1703, pp. 342–346.** https://link.springer.com/doi/10.1007/3-540-48153-2_30
A circular assume-guarantee rule in which each component's correctness is assumed while proving the others. It is made sound by induction over time and extended to liveness. *Closeness:* it is the classic resolution of "A is fine if B is, and B if A" (idea 2). *Difference:* the loop is broken by time-induction over a shared execution, not by pointing at a fixed certificate. There are no strategic agents and no self-referential standard.

**A2. M. Abadi, L. Lamport, "Conjoining Specifications," ACM TOPLAS 17(3):507–534, 1995.** https://www.microsoft.com/en-us/research/publication/conjoining-specifications/
Mutual composition of open-system specs E ⊳ M becomes sound by requiring M to hold one step longer than E. *Difference:* the setting is non-strategic, with no certificates and no fixed-point-defined class.

**A3. K. S. Namjoshi, R. J. Trefler, "On the Completeness of Compositional Reasoning," CAV 2000, LNCS 1855, pp. 139–153** (https://link.springer.com/doi/10.1007/10722167_14). **P. Maier, "Compositional Circular Assume-Guarantee Rules Cannot Be Sound and Complete," FoSSaCS 2003, LNCS 2620** (https://researchportal.hw.ac.uk/en/publications/compositional-circular-assume-guarantee-rules-cannot-be-sound-and/), plus Maier's lattice-theoretic PhD thesis (Saarland 2003; https://www.cs.stir.ac.uk/~cpm/papers/Maier_PhD2003.txt).
These works give the meta-theory of when circular rules are sound or complete. Maier justifies such rules lattice-theoretically, using "non-blockingness" side conditions. *Closeness:* this is the nearest "fixed points justify circular rules" work. *Difference:* the fixed point is in the semantics of composition, not in a diagonal definition of a membership standard.

**A4. C. B. Jones, "Tentative Steps Toward a Development Method for Interfering Programs," ACM TOPLAS 5(4):596–619, 1983** (https://eprints.ncl.ac.uk/158160). **A. Benveniste et al., "Contracts for System Design," Foundations and Trends in EDA 12(2–3), 2018** (https://nowpublishers.com/article/Details/EDA-053).
Rely-guarantee reasoning and assume-guarantee contract algebras: published conditional-behavior specs. *Difference:* these are design-time artifacts checked by an integrator. They are not exchanged and checked by rival agents at play time.

**A5. K. Chatterjee, T. A. Henzinger, "Assume-Guarantee Synthesis," TACAS 2007.** https://ptolemy.berkeley.edu/projects/chess/pubs/240.html
Co-synthesis is cast as a non-zero-sum game in which each process meets its own spec first and only then tries to violate the other's. It is solved via secure equilibria. *Closeness:* the clearest assume-guarantee/equilibrium bridge. *Difference:* synthesis is central, on game graphs, with no program transparency, certificates or self-reference.

**A6. Multi-agent contract synthesis.** A. Anand, S. P. Nayak, A.-K. Schmuck, "Contract-Based Distributed Synthesis in Two-Objective Parity Games," arXiv 2307.06212 (ACM DOI 10.1145/3641513.3650123; venue probably HSCC 2024 **[unverified]**). R. Dewes, R. Dimitrova, "Contract-based Design and Verification of Multi-Agent Systems with Quantitative Temporal Requirements," AAAI 2025 (arXiv 2412.13114). R. Brenguier, J.-F. Raskin, O. Sankur, "Assume-Admissible Synthesis," arXiv 1507.00623 (2015; venue **[unverified]**).
These papers compute mutually dependent per-agent assume-guarantee contracts, so that each agent can act independently and the combination is still safe. Dewes and Dimitrova's soundness proof handles assumptions built from the others' guarantees by step-wise induction. *Closeness:* the closest "assume-guarantee + multi-agent + game" work. *Difference:* these are co-designed controllers on finite graphs, with no one-shot dilemma, no adversarially checked proof certificates and no diagonal fixed point.

**A7. M. Carbone, M. Nielsen, V. Sassone, "A Formal Model for Trust in Dynamic Networks," SEFM 2003, pp. 54–61** (https://eprints.soton.ac.uk/262294/). It builds on S. Weeks, "Understanding Trust Management Systems," IEEE S&P 2001 (**checked only through Carbone et al.'s references**).
Trust policies that refer to one another are resolved as the *least fixed point* of all local policies. *Closeness:* circular "I trust you if…" closed by a fixed point. *Difference:* the fixed point is computed over a trust lattice. There are no incentives and no proofs about code.

**A8. Proof-carrying code.** G. C. Necula, "Proof-Carrying Code," POPL 1997, pp. 106–119 (doi:10.1145/263699.263712). A. W. Appel, "Foundational Proof-Carrying Code," LICS 2001, pp. 247–258 (https://www.cs.princeton.edu/~appel/fpcc.html). R. Sekar et al., "Model-Carrying Code," SOSP 2003, pp. 15–28.
Code ships with a proof (or a behavioral model) that a small trusted checker validates. FPCC shrinks the trusted base to a minimal checker plus a foundational logic. *Closeness:* the direct ancestor of ideas 1 and 3. *Difference:* the checker is a host enforcing a fixed safety policy, not a strategic peer, and there is no mutual or self-referential standard.

## B. Multi-agent systems: commitments, institutions, certified agents

**B1. M. P. Singh, "An Ontology for Commitments in Multiagent Systems," AI and Law 7:97–113, 1999; M. Venkatraman, M. P. Singh, "Verifying Compliance with Commitment Protocols," JAAMAS 2:217–236, 1999.**
Commitments are public, first-class objects, and compliance is checked from observed interactions. *Difference:* compliance is judged after the fact from behavior, not by checking proofs before play.

**B2. F. Wan, M. P. Singh, "Formalizing and Achieving Multiparty Agreements via Commitments," AAMAS 2005.** https://www.csc2.ncsu.edu/faculty/mpsingh/papers/mas/aamas-05-wan-singh.pdf
Analyzes cycles of conditional commitments ("I ship if you pay; I pay if you ship"). It proves that hard cycles are unsatisfiable and breaks them with protocols (2PC, unconditional or conditional yield). Promise-on-promise cycles are explicitly left out of scope. *Closeness:* exactly our circularity, stated in agent terms. *Difference:* it resolves the loop by yielding or atomicity, not by referencing certificates plus a fixed point.

**B3. Institutions and certified agents.** M. Esteva et al., "On the Formal Specification of Electronic Institutions," LNCS (AMEC), 2001 (doi:10.1007/3-540-44682-6_8). L. A. Dennis, M. Fisher, M. Webster, R. H. Bordini, "Model Checking Agent Programming Languages," Automated Software Engineering 19, 2012. M. Fisher, L. A. Dennis, M. Webster, "Verifying Autonomous Systems," CACM 56(9), 2013.
Rules are enforced by the institution, and individual BDI agents are certified by third parties. *Difference:* agents do not exchange certificates or condition their behavior on them.

**B4. M. J. Gabbay, "Cryptographic Certificates of Validity for Trustworthy AI," arXiv 2606.23768, 2026; V. Haldar, D. Chandra, M. Franz, "Semantic Remote Attestation," USENIX VM '04, pp. 29–41.**
An agent's action, or a platform's code, carries a checkable proof or attestation of a high-level property. *Closeness:* idea 1. *Difference:* verification runs one way, with no game and no mutual or self-referential condition.

**B5. Lean formalizations of open-source game theory (2026, very close).**
- C. Duclaux, R. Formenti, P. Cobben, B. Schölkopf, Z. Jin, "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean," ICML 2026 AI for Math Workshop (https://icml.cc/virtual/2026/82498). It formalizes nine proof-search bots in Lean 4 with machine-checked pairwise outcome theorems and an LLM reproving pipeline, then enumerates the equilibria of the PD meta-game. *Difference:* the agents *search for* proofs in the style of Barasz et al. (arXiv 1401.5577, 2014). They do not *check attached certificates*, and there is no diagonal standard K and no in-Lean soundness proof for an object-level certificate logic.
- J. Ondras, "Lean-Verified Handshake…," ICML 2026 Failure Modes Workshop (https://icml.cc/virtual/2026/77909), and "Axiom-Audited Trustworthy Formalization of Game-Theoretic Commitment in Lean," ICML 2026 AI for Math Workshop (https://icml.cc/virtual/2026/82487). A Lean-verified attestation wrapper makes attesting Cooperate weakly dominant in Stag-Hunt games, with oracle trust isolated in a typeclass. *Difference:* trust comes from an oracle or TEE, not from proofs about opponent code, and there is no self-reference.

**B6. Context.** A. Dafoe et al., "Open Problems in Cooperative AI," arXiv 2012.08630, 2020. A. DiGiovanni, J. Clifton, "Commitment Games with Conditional Information Disclosure," AAAI 2023, 37(5):5616–5623. A. Haupt et al., "Formal Contracts Mitigate Social Dilemmas in Multi-Agent RL," arXiv 2208.10469. These are conditional commitments or contracts, not proof certificates.

## C. Economics and institutions (lighter pass)

**C1. M. Kandori, "Social Norms and Community Enforcement," RES 59(1):63–80, 1992; H. Ohtsuki, Y. Iwasa, "How Should We Define Goodness? Reputation Dynamics in Indirect Reciprocity," J. Theor. Biol., 2004 (doi:10.1016/j.jtbi.2004.06.005).**
"Good standing" is self-referential: you are good if you help good agents and refuse bad ones. *Closeness:* the structurally nearest analogue of K. *Difference:* standing is tracked through observed reputation over repeated play, not certified one-shot by proof.

**C2. W. Nordhaus, "Climate Clubs," AER 105(4):1339–1370, 2015; S. Barrett, "Self-Enforcing International Environmental Agreements," Oxford Economic Papers 46:878–894, 1994.**
Coalitions that are stable because members sanction non-members. *Difference:* membership is a policy enforced through payoffs, not a self-referential, proof-checked property. I found no formal model of mutual-recognition or certification standards with a self-referential membership condition.

## Closest matches (ranked)
1. **Duclaux et al. 2026:** the same game and the same tool (Lean), but proof search, not certificate checking, and no K.
2. **Ondras 2026 (two papers):** Lean-verified commitment wrapper for cooperation, but oracle trust and no self-reference.
3. **Wan & Singh 2005, plus McMillan 1999, Abadi–Lamport 1995 and Maier 2003:** the same circularity, resolved by protocols, time-induction or lattice side-conditions.
4. **Necula 1997 / Appel 2001 (PCC/FPCC):** the origin of ideas 1 and 3, but without strategy or mutuality.
5. **Ohtsuki–Iwasa 2004 and Carbone–Nielsen–Sassone 2003:** self-referential "goodness" or trust closed by a fixed point, but resolved dynamically or computed, not certified.

## Verdict for this area
Each ingredient has precedent: sound circular assume-guarantee rules, PCC with a minimal trusted checker, commitment cycles in MAS, self-referential standing norms, and (in 2026 workshops) Lean formalizations of proof-based PD agents. **I found no work that combines them the way we do.** Agents attach proof certificates about their own code; an adversarial peer checks them at play time; the mutual obligation is routed through the other's fixed certificate; the definitional loop is closed by a diagonal-lemma membership standard; and the checker's soundness is proved in Lean. This looks novel as a synthesis. We should cite PCC/FPCC, the circular assume-guarantee line, Wan & Singh, and the 2026 Lean OSGT papers as the nearest neighbours.
