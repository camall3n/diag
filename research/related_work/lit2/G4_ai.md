# G4 (AI cluster) synthesis

Sources merged: litH, wild4, verified_by_app, F31–F41, M08, M10, M17, M28, M34, M44, W15.

**Status key:**
- **[V]**: at least one report says it opened the source. This is often only the abstract page.
- **[U]**: no report opened it, or it was cited from memory.

No status upgraded. M-reports rate "relevance", not closeness. *(My inference)* marks my own additions.

**Group verdict:** no report found play-time-checked proof certificates for a self-referential standard with A/B-style theorems. Several works name the gap (Hammond et al., Dafoe et al., Hewson, Sistla & Kleiman-Weiner, DiGiovanni et al., flexHEG, Kundu et al.).

---

## 1. Prior answers to build on (ranked by closeness)

**1. Duclaux, Formenti, Cobben, Schölkopf & Jin (2026). "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean." ICML 2026 AI-for-Math workshop. https://icml.cc/virtual/2026/82498 [V, abstract page only]**
- *What it does:* claims the first Lean 4 formalization of proof-based OSGT. Nine bots that use bounded proof search, machine-checked outcome theorems for every pair, and the Nash equilibria of the PD meta-game.
- *What it lacks:* the proofs are offline meta-theorems about a fixed roster. There are no certificates carried at play time, no open standard K, and no bounded-cost checker.
- *What we can reuse:* the bot set as a benchmark, the Lean definitions, and their LLM pipeline as a comparison for our pilot.
- **Disagreements:**
  - Rating: MEDIUM in F31, F32 and litH. HIGH in F36 (provisional, second-hand), F37 and M17.
  - The LLM pipeline: F32, F37, M17 and litH say the page reports that an LLM pipeline re-proves 40 of 45 pairwise outcomes. verified_by_app saw *manually written* proofs and no 40/45 figure, and traces that figure to sub-agents quoting Levine.
- Unread: full paper (OpenReview Wc5TAIUC8k) and repository.

**2. DiGiovanni, Clifton & Macé (2025). "Safe Pareto Improvements for Expected Utility Maximizers in Program Games." AAMAS 2025. https://arxiv.org/abs/2403.05103 [V]**
- *What it does:* "renegotiation programs" wrap any default program. They play an agreed Pareto improvement iff the counterpart carries the same renegotiation structure.
- *What it lacks:* it *assumes* that templates can be checked syntactically and that programs halt, and it lists template checking as future work (F38, F31). verified_by_app did not re-check this point.
- *What we can reuse:* K as the missing membership test. Their default-vs-non-renegotiator fallback is our K′.
- Rating: MEDIUM (F38), LOW (F31).

**3. Kundu, Tewolde, Berker, Brown & Conitzer (2026). "Do LLMs Take Care of Their Own? Similarity Signals Can Induce Cooperation." https://arxiv.org/pdf/2608.12125 [V]**
- *What it does:* LLMs cooperate in one-shot PDs when told their co-player is "similar". The authors warn that fabricated signals could be used to manipulate them.
- *What it lacks:* the signals cannot be verified, and there are no commitments.
- *What we can reuse:* a baseline for our pilot, and the pitch "from similarity signals to similarity proofs".
- Rating: MEDIUM (F41).

**4. Ondras, J. (2026). "Lean-Verified Handshake: A Mechanized Commitment Kernel Against Coordination Failure Among Opaque AI Agents." https://icml.cc/virtual/2026/77909 [V abstract]. Companion paper: "Axiom-Audited Trustworthy Formalization of Game-Theoretic Commitment in Lean." https://icml.cc/virtual/2026/82487 [V abstract]**
- *What it does:* a binding-attestation wrapper, formalized in Lean. Attesting Cooperate weakly dominates in Stag-Hunt-ordered games. Trust is placed in a `TrustedOracle`.
- *What it lacks:* reading the opponent's code, any "iff you commit" structure, and the PD.
- *What we can reuse:* the `#print axioms` axiom audit, applied to our checker's soundness proof.
- Rating: LOW (F32), MEDIUM (F37), "high as positioning" (M17).
- Citation conflict: F31 assigns 82487 to the wrapper paper, but the other reports assign it to the companion paper.

**5. Kalai, Kalai, Lehrer & Samet (2010). "A commitment folk theorem." *GEB* 69:127–137. https://www.tau.ac.il/~samet/papers/commitments.pdf [V by M44; F35 and F38 had not opened it]**
- *What it does:* commitment devices condition on the opponent's *device*, not on its action. This avoids the circularity problem and gives a folk theorem.
- *What it lacks:* cheap verification, and embedding in arbitrary agents.
- *What we can reuse:* the formal justification for conditioning on a certificate.
- M44 rates its relevance HIGH.

**6. Gross, Gallagher & Fallenstein (c. 2016). "Löb's Theorem: A functional pearl of dependently typed quining." https://people.csail.mit.edu/jgross/personal-website/papers/lob-paper/html/lob.html [V; authors from memory]**
- *What it does:* encodes PD bots in Agda and derives FairBot cooperation via Löb's theorem.
- *What it lacks:* the bots are not executable, since that would need proof search.
- *What we can reuse:* the framing "standard = type, membership = inhabitation".
- M17 rates its relevance HIGH.

**7. Alexander, S. "The Demiurge's Older Brother" (c. 2011; reposted 2017). https://slatestarcodex.com/2017/03/21/repost-the-demiurges-older-brother/ [V]**
- *What it does:* a superintelligence destroys any superintelligence "that has not precommitted that". This is a self-referential club precommitment that acts as a Schelling point.
- *What it lacks:* trust comes from simulation, not proof.
- M10 rates its relevance HIGH, as framing.

**8. Tegmark & Omohundro (2023). "Provably safe systems." https://arxiv.org/abs/2309.01933 [V]**
- *What it does:* the AI writes the proof and a small checker verifies it. According to litH, §8 argues informally that this could defuse PD-like dilemmas.
- *What it lacks:* the setup is one-way only.
- *What we can reuse:* our result makes §8 formal for the one-shot PD.
- Rating: LOW–MEDIUM (litH). F36 treats it as a dead end, based on the abstract only.

**9–11 (LOW, all [V]):**
- **Singh c. 2014**, "Commitments in multiagent systems: Some history…", https://www.csc2.ncsu.edu/faculty/mpsingh/papers/mas/Commitments-for-MAS.pdf (book details U). C(A, B, C(B, A, goods, pay), goods) is a commitment whose antecedent is a commitment. It has no symmetry and no fixed point. Reuse: K in AAMAS notation.
- **Wan & Singh 2005**, AAMAS, https://www.csc2.ncsu.edu/faculty/mpsingh/papers/mas/aamas-05-wan-singh.pdf. Cycles of hard dependencies (on acts) are unsatisfiable, while soft ones (on promises) can be met. K's cycle is soft.
- **Petrie, Aarne, Ammann & Dalrymple 2025**, flexHEG, App. B and fn. 20, https://arxiv.org/abs/2506.15093. Proposes chip commitments made "if the other makes the same commitment" and calls them hard to do on-device. Reuse: motivation, and a host for the checker.

**Also LOW, but reusable** (all [V]):
- Oesterheld & Conitzer's SPI paper: K can replace its source-equality check.
- Sistla & Kleiman-Weiner, arXiv:2512.00371: a testbed of deceptive LLM code.
- Payor 2023: a lemma that may shorten our certificates.
- orthonormal 2012: its "prove the proof exists" gap disappears once proofs are shipped.
- Bai et al.: one-way PCC for auctions.
- DiGiovanni & Clifton 2023: "disclose iff certified". M28 rates its relevance HIGH.

---

## 2. Objections and limits raised

1. **Binding gap: the proved code may not be the code that runs.**
   - *Raised by:* Sun et al. and Clifton 2019 (F33); F34 (flexHEG); M08 (Farah/Ganis); M10 (Asimov, Liu); W15 ("a TTP in disguise"); F38; F39.
   - *Seriousness:* HIGH.
   - *Answer:* concede it as a non-goal. Layer the scheme: identity → integrity → execution (TEE attestation, Proof-of-Guardrail, flexHEG) → policy (K).
   - *Disagreement:* litH says Chan et al.'s binding requirement is met "by construction". *(My inference: that means binding to the code presented, not to the code that runs.)*
2. **"Arbitrary agents" overstates the claim.**
   - *Raised by:* M08 (Jonas & Kording: full wiring access did not reveal function; Crockett: a commitment must govern every action channel); M28 (Goldwasser et al. 2021); flexHEG App. A.
   - *Seriousness:* HIGH.
   - *Answer:* narrow the claim to an arbitrary core behind a certified decision wrapper. Supporting framings: the "cooperation shield" (F36) and the scaffold result (F38, from Oesterheld et al. 2026).
3. **Dual use: collusion and extortion.**
   - *Raised by:* Hammond et al. (litH, F33); Levine (F36, F37); F41 (ethnocentrism literature: Hartshorn; García; Bruner).
   - *Seriousness:* HIGH.
   - *Answer:* make K′ the default; treat the choice of standard as a policy lever; prove that K cannot express threats (F33 leaves this open).
4. **Convention cost and incompatible standards.**
   - *Raised by:* Chan et al. (litH); DiGiovanni & Clifton (F38); Oesterheld 2022 [U] (F32, M44); Genicot & Ray (M34, subgroup deviation); F40 (an adoption handshake is irreducible).
   - *Seriousness:* MEDIUM.
   - *Answer:* make the kernel the convention, so many standards can share one checker (M17). Treat agreement as pure coordination (F38). Use A2A `required` extensions or ERC-8004 validators (F39). Cite Jennings 1993 (F35).
5. **Proof-based cooperation is impractical or undecidable (Rice's theorem).**
   - *Raised by:* Cooper et al.; Lin et al.; Levine's open problem MAIS-O1.
   - *Answer:* the author ships the proof and the receiver only checks it. Every report sees this as our main selling point.
6. **Information leakage.**
   - *Raised by:* M28 and F38. "Never exploited" covers payoffs only.
   - *Seriousness:* MEDIUM.
   - *Answer:* a zero-knowledge version of K (Canetti–Fiat–Gonczarowski; Gabbay; GMR [U]).
7. **Checker soundness and prover bugs.**
   - *Raised by:* M44; berns (F37).
   - *Seriousness:* MEDIUM.
   - *Answer:* a Lean soundness proof plus an axiom audit. Concede that trust relocates to the kernel.
8. **Unanswered by every report:**
   - Rigidity: a certified policy cannot be renegotiated (Hammond et al., F33).
   - K reduces to Tennenholtz "one level up" if it just means "the checker accepts" (M44). *(My inference: Theorems A/B, plus syntactically different members, are the answer.)*
9. **A semantic standard still needs Löb** (M44). Answer: bounded Löb, Payor's lemma (F31), or guarded fixed points (M17).
10. **Reputation suffices** (M08, citing King-Casas [U]; M34, citing Coate & Ravallion). LOW–MEDIUM. Answer: claim the niche of one-shot first encounters (F39).
11. **Unstated assumptions:** computational boundedness (M28, Dodis et al.) and simultaneous delivery (W15, Halpern–Moses). Answer: state both explicitly.

---

## 3. Reframings and motivations

- **Proof-carrying cooperation:** a third paradigm after syntax and simulation, which moves proof search from the receiver to the author (F31, F32, F36, F37, M17, M28, M44). Lineage: Necula, Appel, Chlipala, Bai et al. Related: "three ways to check membership", i.e. syntax, behaviour/simulation, or certified semantics (F38, litH).
- **Commitments about commitments:** K = C(me, you, Cert_K(you), C). It is a metacommitment that "bottoms out" (Singh 1999); its soft cycle resolves (Wan & Singh); compliance holds by construction rather than by monitoring (Venkatraman & Singh) (litH, F35).
- **Game and decision theory:**
  - Certified SPIs (F38).
  - Certified subjunctive dependence, i.e. FDT without logical counterfactuals (F40).
  - Transparency is not enough, because reflective-oracle agents play Nash (F40).
  - Avoid bounded Löb rather than quantify it, which answers MAIS-O1 (F32, F37).
  - Standard = guarded fixed-point type, with the kernel as the convention (M17).
- **Infrastructure and governance:**
  - Behavioural Agent Cards, with policy as a fourth layer, and AP2-style reciprocal mandates (F39, litH).
  - "Provably safe" goes multi-agent (Tegmark & Omohundro; Dalrymple et al.).
  - The National Popular Vote Interstate Compact as a real K-like pledge (litH via Dafoe et al.).
  - A software meta-commitment for flexHEG (F34).
- **Tags (F41):** binding is necessary and certificates make it free, which gives perfect assortment. "From similarity signals to similarity proofs."
- **Pledges in general (wild4):**
  - Existence (Lawvere), selection (Löb, greatest fixed points, Gilbert) and verification (behaviour, not syntax).
  - "Costly + public = credible" (Gambetta, Chwe).
  - Copyleft as a self-referential pledge.
- **Information (M28):**
  - "Disclose iff certified"; zero-knowledge membership; proof-carrying data for agent networks.
  - Dodis–Halevi–Rabin: verifiable computation replaces a mediator, so aim beyond the PD.
- **Insurance (M34):** supply the commitment that limited-commitment risk-sharing lacks. AIUC-1 and reciprocal exchanges are live "certify, then admit" institutions.
- **Fiction (M10):** Dark Forest's chain of suspicion; Asimov's "Evidence" (behaviour cannot reveal built-in constraints); AI 2027's costly shared successor.
- **W15:** three walls (epistemic, incentive, simultaneity), which inspectable self-referential commitments get past.
- **Gap quotes:**
  - Hammond et al. §3.5.3.
  - Dafoe et al. §4.3, "languages for commitment contracts".
  - Hewson.
  - A2A's "opaque execution".
  - VET's admission that the decision process is not verified.
- **Pilot hints:**
  - Certify a small wrapper with the LLM inside the default branch (F38).
  - LLM-enacted commitments are brittle (Rengert et al.).
  - Benchmarks: Sistla & Kleiman-Weiner, Kundu et al., Duclaux et al.

---

## 4. Necessity / impossibility results

**Program equilibrium and decision theory:**
- **Cooper, Oesterheld & Conitzer 2025 [V]:** without shared randomness, simulation programs cannot reach the full folk theorem. Whether certificates escape this is open (F33, F36).
- **Fallenstein, Taylor & Christiano 2015 [V]:** transparent causal reasoners play Nash, so they defect in the one-shot PD (F40's reading).
- **Kalai et al. 2010 [V]:** positive result. Devices that condition on devices yield a folk theorem.

**Tags and assortment:**
- **Traulsen & Nowak 2007 [V]:** genetic tag cooperation needs one gene encoding both tag and strategy, so binding is necessary.
- **Shutters & Hales 2013 [V]:** cheaters who show the tag but never cooperate drive cooperation to 0%.
- **Antal et al. 2009 [V]:** unbound similarity needs b/c ≈ 2.16 or more.
- **Fletcher & Doebeli 2009 [V]:** altruism requires assortment. Theorems A/B give an assortment of 1 (F41's mapping).

**Commitment cycles and monitoring:**
- **Wan & Singh 2005 [V]:** cycles made only of hard dependencies are unsatisfiable.
- **Venkatraman & Singh 1999 [V]:** monitoring can only falsify compliance, never establish it.

**Coordination and exchange:**
- **Halpern & Moses 1990 [V]:** common knowledge is unattainable over unreliable channels.
- **Fair exchange is impossible without a trusted third party** (Even & Yacobi; Pagnia & Gärtner) [U]. W15: this holds only for deterministic exchange between opaque parties over lossy channels.

**Complexity:**
- **SPI existence is NP-complete** (Oesterheld & Conitzer) [V].
- **Inferring safe improvements is co-NP-complete** (arXiv:2511.21262) [V].
- **Recursive joint simulation is equivalent to the repeated game** (Kovarik et al.) [V].

**Verification, informal and other:**
- **Rice's theorem:** deciding properties of code is undecidable, but checking a supplied proof is not (F31, F32, F37).
- **Goldwasser et al. 2021 [V]:** cheap verification of ML holds only for some classes.
- **Baumann 2018 [V]:** behaviour cannot make cost-free commitments credible.
- **"Prediction Based Robust Cooperation" [V]:** agents must first coordinate on the framework itself.
- **flexHEG App. A [V]:** the key properties cannot be specified for on-device enforcement.
- **Dafoe et al. [V]:** unconditional commitments cannot solve the PD.
- **Risk-sharing:** without commitment, full risk-sharing is unreachable (Coate & Ravallion [record V]; Kocherlakota [U]). Stable groups have a size limit (Genicot & Ray [V]).
- **Lawvere/Yanofsky [V]:** guarantees that a fixed point exists, but does not select one.

---

## 5. Annotated bibliography (deduplicated)

Works fully annotated in §1 are listed by name only.

**Program equilibrium and proof-based cooperation**
- Duclaux 2026 [V abs]; Ondras ×2 [V abs]; Kalai et al. 2010 [V]; DiGiovanni, Clifton & Macé 2025 [V]; DiGiovanni & Clifton 2023 [V]; Gross et al. [V]: see §1.
- Known to us: Barasz et al. 2014 [V]; Critch bounded Löb [V per M44, U per M17]; Tennenholtz, Howard, Oesterheld 2019 [U contents]
- Peters & Szentes 2012, diagonal contracts [U contents]
- Oesterheld 2022, compatibility of robust program equilibria [U]
- Löb-free constructions: Critch 2023 (Payor-based); Payor 2023 [V]
- Simulation and SPI results: Cooper et al. 2025; Oesterheld & Conitzer SPI (2021 or 2022); Kovarik et al. (2402.08128); Oesterheld & Conitzer 2025 (2511.21262) [V]
- [U]: Kovarik et al. IJCAI 2023; Sauerberg & Oesterheld 2024
- Other OSGT: Todorov et al. 2026 (parametric); Ahrenbach (Löb-safe logics); Arsen 2026 (generalized CliqueBots); orthonormal 2012 (proof-search TDT); "A failed solution to OSGT" (opened by F32, not by F37); "Open Strategy Dictator Game" [V]; LessWrong tag list [V list; posts U]
- Levine 2026, MAIS-O1 [V]

**LLM agents**
- Sistla & Kleiman-Weiner; Kundu et al.; Hewson 2026 (names the gap) [V]
- Lin et al., PIBR (Rice objection) [V]
- Meulemans et al. 2026 (similarity inferred from behaviour) [V]
- Oesterheld, Riché et al. 2026 (LLM surrogate goals) [V]
- Behavioural commitment experiments, no proofs: Rengert et al.; Yan et al.; Wyse et al.; GenCoord; Bańka & Chudziak; Willis et al. [V]
- Background: Madmon & Tennenholtz; Tewolde (CoopEval); Hammond & Adam-Day; Albayaydh & Zhao [V]
- [U]: Nathani; Jha; Eberhardinger

**Agendas and governance**
- Gap-naming agendas: Dafoe et al. 2020; Hammond et al. 2025 (44 or 45 authors, depending on the report); Chan et al. 2025 [all V]
- Conitzer & Oesterheld 2023 [V abs]
- Binding gap: Clifton 2019; Sun et al. 2023 [V]
- DiGiovanni 2026, CLR [V]
- One-way proof architecture: Tegmark & Omohundro; Dalrymple et al. [V]
- Brundage et al. [V partial]
- Compute and treaty verification, no reciprocity: Shavit; Wasil et al.; Scher & Thiergart; Scher et al. 2025; Ansari; Scholefield et al. ("conditional" means a threshold trigger) [V]
- flexHEG trio [V; two abstract-only]
- [U]: Chan et al. 2024 (IDs); Moon et al. (RAND); Baker; South et al.; Jia et al.; Askell et al.; Oesterheld's dissertation proposal

**MAS commitments**
- Singh 1998 (social semantics), 1999 (metacommitments), 2008, c. 2014; Wan & Singh; Venkatraman & Singh [V]
- Commitment formalisms, none self-referential: El Kholy et al. 2015; Wang et al. 2009 (guarded); Cavedon et al.; Chopra thesis; Telang et al. 2019; Azorus [V]
- Jennings 1993 (commitments + conventions) [V abs]
- Castelfranchi 1995 [metadata only] and 1997 [V abs]
- [U]: Baldoni et al. (year); Fornara & Colombetti; Yolum & Singh; Mallya & Singh; Chesani et al.; Cohen & Levesque

**Proof-carrying code and formal methods**
- Necula & Lee 1996 [V final section]
- PCC for agents or AI: Chlipala 2026; berns 2026 (kernel/context split); Bai et al.; Gabbay 2026 [V]
- Canetti, Fiat & Gonczarowski [V]
- Offline MAS/RL verification, low: Akintunde et al.; Kouvaros et al.; Wooldridge et al.; Marzari et al.; Elsayed-Aly et al.; Christoffersen et al.; Zhou, Wu & Yang [V]
- Lean/LLM econ, none: two EconCSLibs (Garg; Bei et al.); math-xmum; Liu, Guo & Conitzer; Lyu & Li; Ramos & Soria; Mensfelt et al. [V]
- [U]: Necula 1997; Necula & Lee 1998; Appel; Nakano; Birkedal et al.; @elazarg/GameTheory; arXiv:2605.00081

**Industry protocols** (they attest identity, integrity or execution, never policy)
- A2A v0.2.1; ERC-8004; Proof-of-Guardrail; VET; TrustTrack; Zhou 2026; Kroehl; AP2 [V]
- Acharya [V abs]
- A2A v1 signed cards [primary U; secondary V]
- [U]: MCP, Visa TAP, Mastercard, x402, ACP, sigstore-a2a; Ciliberto et al.

**Decision theory**
- FDT [V]; Soares & Fallenstein [V]; Dai 2009 [V, partial]
- Reflective oracles [V]
- "Prediction Based Robust Cooperation" [V; author U]
- Levinstein & Soares [partly V]
- Hintze; TDT 2010; Rice; 5-and-10/Troll Bridge [U]

**Greenbeards**
- Traulsen & Nowak; Shutters & Hales; Hammond & Axelrod; Hartshorn et al.; Antal et al.; García et al. ("evil green beards"); Bruner; Fletcher & Doebeli; Sinervo et al. [all V]
- Biernaskie et al.; Madgwick et al.; Keller & Ross; Hales & Arteconi [V abs]
- Grafen 1998; West & Gardner 2010; Hamilton 1964 [U]

**Cryptography and information**
- Dodis, Halevi & Rabin [V]
- Goldwasser et al. 2021 [V]
- Halpern & Moses [V]
- GMR; Chiesa & Tromer; Valiant; Even & Yacobi; EGL 1985; Pagnia & Gärtner; Asokan et al.; Cleve [U]

**Neuroscience**
- Jonas & Kording [V]; Crockett et al. [V]; Farah et al. [partly V]
- Ganis; King-Casas; Rilling; Nave et al. [U]

**Insurance**
- Coate & Ravallion [record V]
- Genicot & Ray [V abs]
- AIUC-1 via NBC [V]
- Kocherlakota; Bloch et al.; reciprocal exchanges; Ben-Shahar & Logue [U]

**Fiction:** Alexander [V]; Quantum Thief [V via Wikipedia]; AI 2027 [primary U]; Dark Forest, Asimov's "Evidence", *Three Worlds Collide* [U]

**Pragmatics, category theory and trust**
- Yanofsky [V]; van Benthem & Sarenac [V]; Gonczarowski & Moses [V]; Eckardt [V abs]; SEP "Grice" [V]; Tabarrok [V abs]; Chwe [Wikipedia V]
- Gilbert [U; Miller's review V]; Bacharach & Gambetta [U; Cook's introduction V]
- Barwise 1988; Searle; Williamson 1983; Raub & Weesie; Schelling; Clark & Marshall [U]

---

## 6. Open leads

1. **Duclaux et al.: full text and repository.** Do any bots carry certificates that are checked at play time? Also settle the 40/45 conflict. Flagged by F31, F32, F36, F37, M17 and verified_by_app.
2. **Ondras: full texts**, to check for a variant where a proof is shipped (M17).
3. **public-observatory OSGT issue #2**, "Certificates for joint behavior": still unread. litH says not to retry attaching it from the agent side.
4. **Citing-paper sweeps:** Hammond et al. (F33 calls this "the main remaining risk"); Sistla & Kleiman-Weiner and Duclaux et al. (F32); SPI work by Sauerberg, Treutlein and Macé (F38); EC 2023–26 (F31).
5. **Oesterheld 2022 (2211.05057)** on rival standards (F32, M44). Also AXRP 49 and the "Logical Handshakes" post (F31).
6. **5-and-10 / Troll Bridge and Issa Rice's comparison:** do these confirm that our agents do no self-referential search at run time? (F40)
7. **Technical checks:** Cooper et al.'s n-player limit (F33, F36); whether K can express threats (F33); Payor's lemma (F31); a guarded "later" (M17); Arsen's local completeness (F32); a K vs K′ evolutionary simulation (F41).
8. **Unchecked items:**
   - RAND game model, ZK warhead verification, Reuel et al. (F34).
   - "IDs for AI Systems", the MCP and payment specs, the A2A v1 spec (litH, F39).
   - Pagnia & Gärtner's reduction (W15).
   - Barwise, Gilbert, Bacharach & Gambetta (wild4).
   - Ciliberto et al. (verified_by_app); AI 2027 (M10); arXiv:2605.00081 (F37).
9. **No source found for wild4's "greatest fixed point of a committed-toward modality".** This is a gap, not a lead to a source.
