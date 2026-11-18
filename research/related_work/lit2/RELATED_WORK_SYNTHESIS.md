# Related-work synthesis: verifiable conditional commitments between programs

**Date:** 2026-11-18.

**Inputs:** CONTEXT.md; the five group syntheses in `synth/` (G1 economics, law and philosophy; G2 CS and logic; G3 crypto and distributed systems; G4 AI; G5 far fields); and `verified_by_app.md`, the lead researcher's own checks, which **override** everything else where they conflict. No web searches were run for this document.

**Status key:**
- **V**: a report or the lead says it opened the source.
- **V-abs**: only the abstract or landing page was opened.
- **V-rec**: only a catalogue record or a secondary account was opened.
- **U**: nobody opened it, or it was cited from memory.

Where groups disagree, I use the best status any report claims and note the disagreement, unless the lead's file says otherwise. "V" means the source exists as cited. It does not mean every claim attributed to it was checked in the full text.

**[inference]** marks my own synthesis.

**Claim (stated without the mechanism):** programs can carry verifiable conditional commitments, of the form "I cooperate iff you make the same commitment", that are cheap to check.

**Honest scope (where the reviews converged):** only the commitment-making part of an agent must be provable. Its core can be arbitrary, and sits in the default branch.

---

## 1. Bottom line

**Has anyone done this?** No source found by roughly 90 sub-reports has the full combination:
- an agent carries a proof certificate of membership in a diagonally defined standard ("I cooperate iff your certificate validly proves you are a member");
- a small, Lean-verified checker checks the certificate at play time, with no proof search;
- two theorems hold: agreement (Thm A) and non-exploitation (Thm B).

**What is genuinely new [inference]:**
- the proof travels with the agent, so checking is cheap and decidable;
- membership is semantic, so programs with different code can cooperate;
- the checker's soundness is machine-proved;
- only the diagonal lemma is needed, not Löb.

**Closest work:**
- Duclaux et al. 2026: Lean proof-based open-source game theory, but with offline, hand-written, per-pair proofs and proof-searching agents.
- Peters & Szentes 2012: diagonal contracts on code, without verification.
- Sobel 1972 / Mintoff 1993: the self-referring promise.
- Bartoletti, Cimoli & Zunino 2013: agreement plus protection requires circular contracts.

**Main concession:** the binding executor is a trusted third party.

**Still unread:** GitHub issue #2, the full Duclaux paper, and Ciliberto et al.

---

## 2. The closest prior answers, ranked

**Ranking [inference]:** by how many of these features a work shares with ours:
1. a self-referential conditional standard;
2. a carried certificate;
3. cheap checking;
4. agreement-plus-protection theorems;
5. agents that are programs.

| # | Work | What it does | What it lacks vs. us | What we can reuse | Status |
|---|---|---|---|---|---|
| 1 | Duclaux, Formenti, Cobben, Schölkopf & Jin 2026 (ICML workshop) | First Lean 4 formalization of proof-based OSGT. Nine programs; hand-written, machine-checked proofs of every pairwise outcome; Nash equilibria of the PD meta-game | Proofs are offline and per pair. Agents use bounded proof search. No carried certificates, no open standard | Bot library as a benchmark; Lean definitions | V-abs (lead) |
| 2 | Peters & Szentes 2012, *Econometrica* | Contracts as definable functions of Gödel codes; diagonal "C iff your code equals mine"; folk theorem | No certificates, checker, cost model or Thm B. The equilibrium contract tests code *identity* (reports disagree on this) | "Semantic contractible contracts"; answers their halting/syntax objection | V (2008 draft) |
| 3 | Sobel 1972; Mintoff 1993 (ANU thesis, ch. 4–5) | "Cooperate iff the other is a CM" is viciously circular; a self-referring promise is harmless | Any verification | Conceptual priority | Mintoff V; Sobel content U |
| 4 | Bartoletti, Cimoli & Zunino 2013 (POST); Bartoletti & Zunino 2010 (LICS) | Agreement (≈A) and protection (≈B) are incompatible under ordinary causality; circular contracts restore both; PCL handshake rule | No programs, no carried proofs; agreement found by proof search; protection only after the fact | Motivation for self-reference; Horn PCL as a candidate S | V |
| 5 | Chiesa & Tromer 2010 (PCD); Bitansky et al. 2013 | A verifier, built via the recursion theorem, accepts proofs that it itself accepts | No game; well-founded over history; uses cryptography | Succinct or ZK certificates; pre-empt "PCD + self-reference" | V |
| 6 | van der Hoek, Witteveen & Wooldridge 2013 (IJGT) | Program equilibrium with temporal-logic guards, framed as conditional commitments. A circular "iff" has 0, 1 or many outcomes; deciding is NP-complete | No certificates | We resolve their semantic/syntactic tension. **Not on our known list** | V |
| 7 | DiGiovanni, Clifton & Macé 2025 (AAMAS) | Renegotiation programs: if default vs. default is inefficient, call a renegotiation routine | *Assumes* the counterpart's structure is recognized ("template checking is future work" is not re-checked by the lead) | K as the recognition test; their fallback ≈ K′ | V (lead) |
| 8 | Ondras 2026, "Lean-Verified Handshake" (+ poster 82487, possibly related) | Lean 4 binding-attestation wrapper; attesting C weakly dominates in Stag-Hunt-ordered games; `#print axioms` audit | No code reading, no "iff", no PD; truth sits in a `TrustedOracle` | Axiom audit; "safe stag hunt" | V-abs (lead) |
| 9 | Kalai, Kalai, Lehrer & Samet 2010 (*GEB*) | Devices condition on the opponent's *device*, not its action; commitment folk theorem | Verification by newspapers or lawyers; devices are abstract | K as a finite, checkable device | V |
| 10 | Monderer & Tennenholtz 2006 (AAAI) | Minimal PD mediator plays C for both iff both sign up; program equilibrium ⇔ 1-strong mediated equilibrium | Trusted mediator | "Decentralized mediator; certificate = sign-up" | V |
| 11 | Heitzig et al. 2023; Heitzig 2025 (*Games*) | Conditional commitment functions modelled on the NPVIC; largest consistent profile | Conditions on actions; compliance assumed | Treaty application | V |
| 12 | zhongmingjiang, "Proof of Löbian Cooperation" (GitHub, undated) | Markdown proposal: neural bounded-Löb proof terms, Lean micro-kernel | No Lean files or results; pairwise proof found at play time; Löb-based | Idea-priority citation | V |
| 13 | Gabbay 2026 (attribution per G2), arXiv 2606.23768 | Actions carry succinct certificates of an agreed predicate; contrasts itself with PCC | One-way; no game | ZK route | V (lead) |
| 14 | Payor 2025, "small tiling result" | Accepts successors iff provably "good_new", a self-referring property | Single agent; proof search | Structural ancestor of K | V |
| 15 | Kundu, Tewolde, Berker, Brown & Conitzer 2026 | LLMs cooperate when told the co-player is "similar"; warns of fabricated signals | Signals unverifiable | Pilot baseline | V |
| 16 | Oesterheld 2022, arXiv 2211.05057 | Robust bots (DUPOC, CIMCIC, PrudentBot, εGFB) inter-cooperate; CliqueBot is compatible with none | Search or simulation; no certificates | Behavioural vs. interface compatibility | V (G5); U in G2, G4 |
| 17 | Gauthier 1986; Danielson 1992 | Constrained maximization = A/B as a disposition (via "translucency"); Prolog PD tournaments | No fixed point; no checkable transparency | Lineage | V-rec both |
| 18 | Bai, Tadjouddine & Guo, arXiv 1404.0854 | Bidders check the auctioneer's Coq proof of truthfulness | One-way | Don't claim "PCC for game properties" | V |
| 19 | Dickerson et al. 2018, "Proof-Carrying Smart Contracts" | Validators check proofs against a published spec | No counterparty checks | Governance of the spec | V |
| 20 | Ciliberto, Rudi & Tassi 2026, arXiv 2610.28484 | Reportedly: Lean proofs checked per tool call in an "Airlock"; multi-agent sequel announced | Reportedly: single agent | Binding layer | **U** (lead could not fetch or find it; litF and litG claimed they opened it) |
| 21 | Issue #2, "Certificates for joint behavior" (public-observatory/open-source-game-theory) | Unknown; the title matches | Unknown | Unknown | **U** |

### Notes on the top ten

**1. Duclaux et al.** is closest in artifact and community.
- The abstract the lead saw describes **manually written**, offline, per-pair proofs about nine proof-searching bots.
- The "LLM pipeline re-proves 40 of 45" figure is **not** in that abstract. It traces to Levine via sub-agents, so treat it as U.
- Their theorems are *about* agents; ours are *carried by* agents. Position our checker as the play-time complement to their meta-time library.

**2. Peters & Szentes** already have Gödel-coded diagonal contracts and a folk theorem.
- They reject Turing-machine contracts because such contracts may not halt and can only condition on syntax. A bounded checker over a proof, against a semantic standard, answers both.
- Reports disagree on whether their contracts condition on what code *computes* (F04) or only on code identity (F01, F02, F08, F09).
- To reconcile: Critch 2016 calls their contracts non-computable, while P&S say their equilibrium contracts are recursive (F02).

**3. Sobel / Mintoff** have the philosophical core.
- Defining a constrained maximizer as "cooperate iff the other is one" is viciously circular.
- A promise that refers to *itself* ("iff the other makes *this* promise") is harmless.
- Our diagonal lemma formalizes that promise. F45 links it to Williston's paradox of bilateral promises. Only Mintoff was opened.

**4. Bartoletti et al. 2013** prove that agreement and protection cannot both hold without circularity.
- Our Theorems A and B are exactly that pair, so this is our best formal motivation.
- Their PCL handshake rule ((p↠q)∧(q↠p) ⊢ p∧q) is "contractual implication". Its Horn fragment is polynomial, so it is a candidate design for S.

**5. Chiesa & Tromer's PCD** is the strongest existing text against "self-referential, cheaply checked certificates are new".
- Answer: we add game semantics, Theorems A/B, symmetric peers, and no cryptography.
- Report ratings range from none (litF, F11) to high relevance (M14).

**6. van der Hoek et al.** is the most important work *not on our known list*.
- It frames program equilibrium as conditional commitments, with "iff" guards.
- It shows that a circular "iff" has zero, one or many coherent outcomes, and that deciding coherence is NP-complete.
- Our certificates pick out the cooperative outcome without global reasoning.

**7. DiGiovanni, Clifton & Macé** assume agents can recognize a counterpart's renegotiation structure; K supplies the test. DiGiovanni & Clifton 2023 leave open whether the code shown is the code that runs. That is our binding objection (§4.1).

**8. Ondras** puts the truth of attestations in a `TrustedOracle`, and studies Stag Hunts, not the PD. Ondras also argues that program-equilibrium constructions are impractical for LLM agents (F11); a checker with no proof search answers that.

**9. Kalai et al.**: conditioning on devices avoids inconsistency.
- Their Thm 3 says complete finite device spaces are degenerate. This motivates a standard defined by proofs rather than by a list.
- Their "fixed and known" encoding is our convention cost.

**10. Monderer & Tennenholtz** make the trusted-third-party issue explicit: K is their minimal mediator, made decentralized.

---

## 3. Lineages

### Program equilibrium / OSGT

We complete a three-way split in how membership is checked (F38, litH):
- **by syntax:** Tennenholtz 2004; CliqueBot; the hash-based hardware CliqueBots MAGE and Imamura 2026;
- **by simulation or proof search:** Barasz et al. 2014; Critch; Oesterheld 2019 and 2022; Duclaux 2026;
- **by carried proof:** ours.

Key citations:
- Duclaux et al. 2026.
- van der Hoek et al. 2013.
- Oesterheld 2022.
- Cooper, Oesterheld & Conitzer (arXiv 2412.14570). Their folk-theorem limit for simulators may or may not bind certificate agents.
- Gross, Gallagher & Fallenstein 2016: "standard = type, membership = inhabitation".

**What we change: no Löb.** Our Lean development settles that the construction needs **only the diagonal lemma**, not Löb's theorem.
- The diagonal lemma defines K.
- A member satisfies K by unfolding the definition.
- The attached certificate is the concrete proof the opponent checks. M21 describes this mechanism correctly.

Reports that say Löb or bounded Löb is needed are **mistaken about our scheme**. These are M44 (G4), M11 (G2) and PoLC's design. They describe FairBot-style agents that *search* for proofs.

### Commitment games and contracts (economics)

Ours is a verifiable case of contracts that condition on contracts. Key citations:
- Peters & Szentes 2012.
- Kalai et al. 2010.
- Monderer & Tennenholtz 2006.
- Szentes 2015, Prop. 3: contracts on contracts sustain monopoly, a collusion warning.
- Gudmundsson & Hougaard 2025: reaction-function smart contracts that select (C,C) *by assumption*. Our Thm A *derives* it.

The philosophy branch supplies A and B as dispositions, and the old "translucency" objection, which certificates answer with recognition probability 1. That branch is Gauthier, Danielson, and Sobel/Mintoff.

### Proof-carrying code and data; certified control

Ours is PCC made **mutual, symmetric and reflexive**. In PCC a host checks a producer against the host's own policy. Here each peer checks the other against a shared policy that refers to itself. Key citations:
- Necula 1997.
- Appel & Felten 1999, which suggests the name "proof-carrying cooperation".
- Appel 2001: a small trusted base.
- Chiesa & Tromer 2010.
- McConnell et al. 2011: certifying algorithms.
- Jackson et al. 2021: a certificate checked by a small verified monitor.

The nearest one-way precedents are Bai et al. and Gabbay 2026.

### Fair exchange and atomic commitment

This lineage gives our main *necessity* result.
- Theorems A and B are the effectiveness and fairness properties of fair exchange.
- Fair exchange needs a trusted third party (TTP).
- The simultaneous, binding runner of program equilibrium **is** that TTP (ten G3 reports).

Key citations:
- the Pagnia, Vogt & Gärtner survey;
- Even, Goldreich & Lempel 1985, which has priority on the phrase "committed if you exhibit a witness";
- Herlihy 2018;
- Halpern & Moses 1990.

Our convention replaces the TTP's *judgment*, not its *delivery*.

### Cooperative AI and LLM agents

Several agendas name the gap without filling it:
- Dafoe et al. 2020 §4.3 ("languages for commitment contracts");
- Hammond et al. 2025 §3.5.3;
- Chan et al. 2025;
- flexHEG (Petrie et al. 2025), whose App. B proposes chip commitments "if the other makes the same commitment" and calls them hard on-device.

Other key citations:
- the one-way ancestor: Tegmark & Omohundro 2023;
- empirical neighbours: Kundu et al. 2026; Lin et al.; Sistla & Kleiman-Weiner 2025;
- MAS commitment notation: Singh's metacommitments and Wan & Singh 2005.

### Biology, sociology and law

- **Biology:** a certificate is an *unfakeable greenbeard*, where tag = proof of behaviour (Gardner & West 2010; Queller et al. 2003). Unbound tags collapse (Roberts & Sherratt 2002; Traulsen & Nowak 2007), which supports the binding requirement.
- **Sociology:** Yamagishi's "assurance, not trust": the certificate is a portable closed tie.
- **Law and institutions:** the Nurse Licensure Compact, the Defensive Patent License and WADA Art. 15 condition on cheaply checked membership, but have no proofs and no self-reference (G5).

---

## 4. Objections we must address

Ranked by how often and how seriously they were raised.

### 4.1 Proven code vs. running code (binding)

**Raised in all five groups**; the most frequent objection.
- G1: M15, M22, M25, M35, M41, M43 (Gauthier 1994: actions routed around the verified module); DiGiovanni–Clifton.
- G2: F12, F15, F19, M14, M27, W07, W13 (Thompson's "Trusting Trust" uses K's own quine ingredient; replay attacks).
- G3: wild1, F22, F26, F27, F29, M20, M31, M38, M39.
- G4: F33, F34, F38, F39, M08, M10, W15.
- G5: litI, wild3, M03, M06, M13, M19, M30, M36, M42, M45, W06, F43.

**Answer: concede binding as an explicit assumption of Theorems A and B.**
- Discharge it in layers: identity → integrity → execution (attestation, TEEs, reproducible builds, Imamura's recursion-theorem attestation, Ciliberto's "Airlock" [U]) → policy (K).
- Wording (M42): "members whose deployed agents are attested to run the proven code."
- Lehmann et al. 2024 show decoupling can arise *after* recognition. So the action must come from the same computation that checks.

### 4.2 The binding executor is the trusted third party (atomic delivery)

**Raised by:** wild1, wild2, litG, F21, F23, F24, M20, M31, M39, W08 (G3); W15 (G4); M05, W05, wild3 (G5). Halpern–Moses version (M20): if A's certificate is lost but B's arrives, A is exploited.

**Answer: concede.** Simultaneous, binding delivery costs nothing inside the model and is a real requirement outside it. Get these details right:
- Even–Yacobi holds even under synchrony, so what rescues us is simultaneity plus binding, not timing (F21).
- Fair exchange is *incomparable* to consensus (Orzan & Torabi Dashti), contrary to paraphrases in M20, M31 and M39.
- We guarantee the *decision*, not atomic *transfer* (M31).
- Strong fairness holds in the model; deployment gets weak fairness or deposits (Bentov–Kumaresan). [inference] M39 and litG/F23/F24 are both right, about different settings.
- Sequential reveal gives fairness without balance (Chadha et al.; F22). This matters in asymmetric games.

### 4.3 Collusion and third-party harm

**Raised by:**
- G1: litE, F01, F02, F03, F05, F10, M35, M37 (Szentes 2015; price-matching; Dark DAOs; Dal Bó 2007).
- G3: litG, wild1, F21, F25, F27, F28, F29.
- G4: Hammond et al.; Levine; F41.
- G5: M06 (Chung & Shi; bidding rings), M30, M33.

**Very serious for framing:** "never exploited" protects members only.

**Answer:**
- Scope the claim to settings with negligible externalities, and add a dual-use section.
- Make K′ the default.
- Treat the choice of standard as a governance lever; anti-collusion constraints could go inside the standard (M37).
- Open: can K express threats? (F33)

### 4.4 Convention and adoption: stable at zero adopters

**Raised by:**
- G1: M22 (tipping; exclusion is weakest at low adoption), M25, M37, M43.
- G2: M11, M16, M21, M24, M32.
- G3: wild1, wild2, M38, M39.
- G4: Chan et al.; F38; F40; M34 (Genicot & Ray).
- G5: M05, M18 (Henrich's bistability, including a stable "nobody adopts" state), M30, M33, M36, F44.

Sub-problems:
- under two-way K, rival versions treat each other as non-members (F44);
- whoever governs the checker inherits trust (Levi; Milgrom, North & Weingast; Szabo);
- lock-in.

G5 disagrees on Gardner & West. litI reads them as saying facultative greenbeards are favoured at every frequency; M30 and M36 read them as saying greenbeards need clustering.

**Answer: partly concede.**
- Some convention is unavoidable (§6: the TTP result; Goyal & Janssen); ours is minimal.
- [inference] With negligible checking cost, K′ membership weakly dominates. Two-way K needs clustering or seeding.
- Make the *kernel* the convention, so standards can share it (M17).
- Pin the standard and checker by hash, and give it a versioning path. Lesson from the Nurse Licensure Compact: re-enactment is costly.
- F44's "dual-gauge" K′ is **unproved**.

Related challenge: robust bots interoperate *without* a convention (Oesterheld 2022). Answer: the convention buys checking with no proof search. Test whether K′ cooperates with εGFB.

### 4.5 "Arbitrary agents" is overstated

**Raised by:** M08 (Jonas & Kording; Crockett: a commitment must govern every action channel), M28 (Goldwasser et al. 2021), flexHEG App. A (G4); M03 (G5); M43 (G1).

**Answer: accept the narrower claim**, which is now our scope.
- Only the commitment-making wrapper must be provable. An arbitrary core, such as an LLM, can sit in the default branch: the "cooperation shield" (F36) and the scaffold result (F38, citing Oesterheld et al. 2026).
- The wrapper must control every action channel; this is part of the binding assumption (§4.1).

### 4.6 "Cheap" covers checking, not proving

**Raised by:** M11, M16, F17 (G2; Kumar & Fallenstein estimated person-years); M03 (G5).

**Answer: concede.** Agents must be built to be provable. Mitigations:
- oracle certificates (Necula & Rahul), about 30× smaller;
- joint program+proof generation by LLMs (P³, about 72–77%);
- our small LLM pilot.

### 4.7 Incompleteness and false negatives

**Raised by:** litF, F13, F14, F15, M21, M24 (G2); M03, M19, M30, M42 (G5).

Membership is undecidable (Rice), so some cooperative programs carry no certificate.

**Answer: concede.** Thm A concerns *certified* members. McConnell's Lemma 5 explains why the claim is one-sided.

### 4.8 Information leaks

**Raised by:** F12, F15, M14, litF (G2); M28, F38 (G4). Open code reveals strategy; "never exploited" covers payoffs only.

**Answer:** future work on zero-knowledge K-certificates (Canetti, Fiat & Gonczarowski; Gabbay 2026; zk-PCD). These would cost far more than 10^5 steps (F27).

### 4.9 Quantum or unreadable code

**Raised by:** M12, F27 (G3). Quantum or ZK checks are expensive, and "never exploited" is relative to what the checker sees (the quantum-PD dispute; Eisert et al. 1999).

**Answer:** scope the claim to classical programs. [inference] Unreadable code *favours* shipped proofs over inspection (M12). But verifying them needs verifiable-computation machinery (Mahadev 2018), and the cost claim would not transfer.

### 4.10 Mistaken: "a semantic standard needs Löb" / "which fixed point?"

**Raised by:** M44 (G4); M11 (G2).

**Answer:** our Lean development shows the diagonal lemma suffices.
- The checker's verdict on a concrete certificate decides the action.
- There is no proof search, so Löb has nothing to do. This agrees with M21, litF and F13.
- The proposed fixes (bounded Löb, Payor, guarded fixed points) are unnecessary for us.

### 4.11 Lower-frequency objections

- **"Commitment" equivocation** (M43, M12). Answer: say "verified conditional policy", or "joint commitment without a joint act" (F45).
- **Rigidity: a certified policy cannot renegotiate** (Hammond et al.). No report answered this.
- **"Tennenholtz one level up"** (M44). [inference] A/B hold across *syntactically different* members.
- **n-person goods, coalitions, Sybils** (M20, M22, M37, F30). Answer: restrict to pairwise, excludable gains; restate B as t-immunity. Whether mutual K is a strong program equilibrium is open.
- **Self-soundness** (Pudlák). Handled, because soundness is proved in Lean; say so.
- **The checker as a single point of failure** (M20, M39). Answer: keep it small and audited; concede that trust moves to the kernel (berns 2026).
- **Reputation suffices** (M08, M34). Answer: our niche is one-shot first encounters.

---

## 5. Reframings and real-world analogues for the introduction

**National Popular Vote Interstate Compact.** A pledge that binds only once enough others make the same pledge.
- Sources: Dafoe et al. 2020 §4.3 (V via progress_H; arXiv ID U); Heitzig et al. 2023 (V).
- Caveat: this is a threshold trigger, not exactly "iff".

**Nurse Licensure Compact.** Recognition extends to "any state that has adopted this compact".
- Costs: re-enactment and a six-month withdrawal lag.
- Source: Ariz. Rev. Stat. §32-1660 (V, M19).

**TCAS II.** Machines exchange "I climb iff you descend" with no referee, though nobody is tempted to defect.
- Source: FAA TCAS II v7.1 (V, W09).
- Related: Narkawicz & Muñoz 2011 prove in PVS that algorithms meeting shared criteria coordinate (V).

**Defensive Patent License; *The Satanita* (1897).** The badge *is* the behaviour, and joining binds every member to every other (V, W10).

**WADA Code Art. 15.** One signatory's sanction binds all (V, wild3).

**Tender in contract law.** Under concurrent conditions, tender shows conditional readiness and breaks the first-mover deadlock. Slogan: "a certificate is a machine-checkable tender" (F45).
- Sources: *Kingston v. Preston* and Restatement (2d) §§234, 238 (U); Williston §§103–103a, on bilateral promises (V).

**Greenbeards and falsebeards.** A certificate is an unfakeable greenbeard; Theorem B excludes falsebeards.
- Sources: Gardner & West 2010 (V); Queller et al. 2003 (V); Roberts & Sherratt 2002 (V).
- Slogan: "from similarity signals to similarity proofs" (after Kundu et al. 2026, V).

**Grafen's revealing signals.** Honest *strategic* signals must be costly; *revealing* signals are exempt. Certificates give "honesty without waste".
- Sources: Grafen 1990 (V); Penn & Számadó 2020 (V).

**Trust vs. assurance.** Certificates give strangers assurance.
- Sources: Yamagishi & Yamagishi 1994 (V-rec); Kuwabara 2015 (V); Cook, Hardin & Levi (U).

**Credible mechanisms.** A principal proves its code follows its posted rules.
- Sources: Akbarpour & Li 2020 (V in G5, U in G1; its trilemma: static, strategy-proof, credible, pick two); Ferreira & Weinberg 2020 (V).

**Others:**
- proof-carrying cooperation (Appel & Felten);
- "the TTP is the semantics" (F24);
- the leaderless atomic swap, "hashlock → prooflock" (Herlihy 2018);
- semantic contractible contracts (Peters & Szentes);
- the decentralized minimal mediator (Monderer & Tennenholtz);
- an assurance contract whose escrow is a checker, with Thm B as the refund (Tabarrok 1998);
- Montreal vs. Kyoto: membership is cheap to check, compliance is not, and certificates merge the two (Barrett 2008, V);
- template vs. attribute verification (Glaser, Barak & Goldston 2012, V);
- verified superrationality: in Hofstadter 1985, 14 of 20 defected (V);
- "Frank's commitment model with zero noise" (Frank, Gilovich & Regan 1993, V);
- "The Demiurge's Older Brother" (Alexander, V).

---

## 6. Necessity and impossibility results

| Result | Source (status) | Implication for us |
|---|---|---|
| Fair exchange is impossible without a TTP | Even & Yacobi 1980; Pagnia & Gärtner 1999 (primaries U); Pagnia–Vogt–Gärtner survey (V); Avoine et al. (V) | Name the runner as the TTP; the convention replaces only its judgment |
| Coordinated action needs common knowledge, which is unattainable over unreliable channels | Halpern & Moses 1990 (V); Rubinstein 1989 (V in G3) | Assume atomic delivery. Pin the standard by hash. A/B need only first-order checking (F07, M40) |
| Atomic swaps need leaders forming a feedback vertex set | Herlihy 2018 (V) | [inference] Simultaneity removes the leader, but simultaneity is itself the TTP |
| No circular assume-guarantee rule is sound and complete without extra structure | Maier 2003 (V); Abadi & Lamport (V) | A behavioural "iff" is unsound, and certificates break the cycle. Incompleteness forces one-sidedness |
| Agreement and protection need circularity | Bartoletti, Cimoli & Zunino 2013 (V) | Main formal motivation |
| Cycles of hard dependencies are unsatisfiable; soft ones can be met | Wan & Singh 2005 (V) | K's cycle is soft (on certificates) |
| Monitoring can falsify compliance but never establish it | Venkatraman & Singh 1999 (V) | Compliance by proof, not monitoring |
| Checker regress | Quine 1936 / Carroll 1895 via SEP (V-rec) | A trusted base is unavoidable; keep it small and audited |
| No theory containing Q proves its own consistency, even on a cut | Pudlák 1985 (U, secondary only); Pudlák later work, Pakhomov, Willard (V) | S cannot self-certify; soundness lives in Lean |
| Cheap two-sided certificates ⇒ NP∩coNP | McConnell et al. 2011, Lemma 5 (V) | Only "member" certificates |
| Complete finite device spaces are degenerate | Kalai et al. 2010, Thm 3 (V) | A proof-defined, open-ended standard |
| Machine contracts may not halt and are syntax-bound | Peters & Szentes 2012 (V) | Bounded proof checking answers both |
| Falsebeards win when marker and behaviour can come apart; unbound tags collapse | Gardner & West 2010; Roberts & Sherratt 2002; Traulsen & Nowak 2007; Shutters & Hales 2013 (V) | Binding is necessary; certificates must *entail* behaviour |
| Honest strategic signals are costly unless they reveal | Grafen 1990 (V) | We are in the exempt class |
| Any positive cost of invoking a guarantee kills it | Hviid & Shaffer 1999 (V) | Cheap checking is essential |
| Bistability; excess inertia | Henrich 2009; Farrell & Saloner 1985 (V) | Adoption warning |
| Simulators miss the full folk theorem without shared randomness | Cooper, Oesterheld & Conitzer (V, G4) | Open whether certificates escape this |
| Compliance checking with search is NP-hard or undecidable | Blaze, Feigenbaum & Strauss 1998 (V) | Ship the proofs |
| Equilibria of contracts on contracts are hard | Hall-Andersen & Schwartzbach 2021 (V; reports differ: NP/Σₖᴾ vs. PSPACE) | One fixed K sidesteps this |
| Rationality alone does not yield coordination | Goyal & Janssen 1996 (V) | The convention is necessary |

---

## 7. Open leads to check next (prioritized)

1. **Duclaux et al., full paper and repository** (OpenReview Wc5TAIUC8k).
   - Are any certificates checked at play time?
   - Confirm the hand-written proofs and settle the 40/45 claim.
   - This is the biggest novelty risk.
2. **GitHub issue #2, "Certificates for joint behavior"** (public-observatory/open-source-game-theory), plus the README.
   - Unread, and the title matches our idea.
   - A human should read it; litH advises not retrying from the agent side.
3. **Ciliberto, Rudi & Tassi 2026** (arXiv 2610.28484).
   - First confirm it exists: the lead's fetch was blocked and search didn't find it.
   - Then look for the multi-agent sequel.
4. **Sobel 1972 / Mintoff 1993, exact wording**, for a precise priority citation.
5. **The "Proof of Löbian Cooperation" repo.** Date, author, commit history, and any Lean files. This fixes its priority date.
6. **Ondras, full texts.** Relation to poster 82487; any variant where proofs are shipped.
7. **DiGiovanni, Clifton & Macé.** Confirm the "template checking as future work" claim.
8. **Citing-paper sweeps:**
   - Hammond et al. (F33: the main remaining risk);
   - the roughly 29 citers of Peters & Szentes;
   - KKLS 2010;
   - Duclaux et al.;
   - Sistla & Kleiman-Weiner.
9. **Our own Lean checks:**
   - K′ vs. εGFB;
   - whether mutual K is a strong program equilibrium;
   - whether K can express threats;
   - F44's two-way exclusivity and dual-gauge K′;
   - an n-player K_k;
   - whether commit-then-reveal suffices.
10. **Bridging sources:**
    - Kremer & Raskin 2002;
    - Izmalkov, Lepinski & Micali, TCC 2008, "Verifiably secure devices";
    - the Heitzig *Games* appendices (central vs. decentralized resolution).
11. **Legal sources:** *Kingston v. Preston*; Restatement (2d) §§77, 234, 238; Williston §§104ff.
12. **Re-run the quota-failed reports** (F43, F44, F45, M01–M05, W11, W12) and verify their U citations.

**Deprioritized, since we use no Löb:** certificate size under Payor vs. Löb; guarded or step-indexed variants of K; probabilistic Payor.

---

## 8. Master bibliography

This list is deduplicated and covers every work cited above; the long tail is in `synth/G1`–`G5`. Each entry gives the status, then the URL where a report recorded one.

### Program equilibrium / OSGT

- Duclaux, Formenti, Cobben, Schölkopf & Jin 2026: V-abs (lead). https://icml.cc/virtual/2026/82498
- Ondras 2026, "Lean-Verified Handshake": V-abs (lead). https://icml.cc/virtual/2026/77909
- "Axiom-Audited Trustworthy Formalization of Game-Theoretic Commitment in Lean" (author not confirmed; the lead calls it "possibly related"): V-abs. https://icml.cc/virtual/2026/82487
- zhongmingjiang, PoLC: V. https://github.com/zhongmingjiang/Proof_of_Lobian_Cooperation
- Issue #2: U. https://github.com/public-observatory/open-source-game-theory/issues/2
- van der Hoek, Witteveen & Wooldridge 2013: V. https://www.cs.ox.ac.uk/people/michael.wooldridge/pubs/ijgt2013.pdf
- DiGiovanni, Clifton & Macé 2025: V (lead). https://arxiv.org/abs/2403.05103
- DiGiovanni & Clifton 2023: V. https://arxiv.org/abs/2204.03484
- Oesterheld 2022 (arXiv 2211.05057): V (G5)
- Cooper, Oesterheld & Conitzer (arXiv 2412.14570): V (G4)
- Oesterheld & Conitzer, SPI: V
- Gross, Gallagher & Fallenstein 2016: V. https://jasongross.github.io/lob-paper/nightly/lob-preprint.pdf
- Payor 2025: V. https://www.greaterwrong.com/posts/akuMwu8SkmQSdospi/working-through-a-small-tiling-result
- Payor 2023 / Critch 2023: V
- Fallenstein, Taylor & Christiano 2015: V
- Danielson 1992: V-rec
- Tennenholtz 2004 (already known): U / V-rec
- Barasz et al. 2014 (already known): V-abs
- Critch 2016 (already known): V
- Oesterheld 2019 (already known): U

### Commitment games, contracts, mediators

- Peters & Szentes 2012: V. https://doi.org/10.3982/ECTA8375 (draft: https://discovery-pp.ucl.ac.uk/15001/1/15001.pdf)
- Szentes 2015: V
- Kalai, Kalai, Lehrer & Samet 2010: V. https://www.tau.ac.il/~samet/papers/commitments.pdf
- Monderer & Tennenholtz 2006: V. https://cdn.aaai.org/AAAI/2006/AAAI06-110.pdf
- Gudmundsson & Hougaard 2025 (arXiv 2506.14413): V
- Hall-Andersen & Schwartzbach 2021 (arXiv 2107.04393): V
- Heitzig et al. 2023: V. https://arxiv.org/pdf/2307.14267v1
- Heitzig 2025: V. https://www.mdpi.com/2073-4336/16/6/58
- Kilbourn (attributed), SUAVE note: V. https://hackmd.io/@quintuskilbourn/BkhiBAsU3
- Akbarpour & Li 2020: V (G5) / U (G1)
- Ferreira & Weinberg 2020: V
- Tabarrok 1998: V (G1) / U (G3, G5)
- Hviid & Shaffer 1999: V
- Goyal & Janssen 1996: V
- Farrell & Saloner 1985: V
- Abraham, Dolev, Gonen & Halpern 2006: V

### Philosophy and law

- Mintoff 1993: V. https://openresearch-repository.anu.edu.au/bitstream/1885/10302/4/04Chapter2_Mintoff.pdf
- Sobel 1972: title V, content U
- Gauthier 1986: V-rec
- Gauthier 1994: V
- Williston §§103–103a: V
- *Kingston v. Preston*; Restatement (2d) §§77, 234, 238: U
- *The Satanita*: V
- Defensive Patent License: V
- Hofstadter 1985: V
- Quine 1936 / Carroll 1895 (via SEP): V-rec

### Proof-carrying code and data, certified control, logic

- Necula 1997: V
- Appel & Felten 1999: V. https://www.cs.princeton.edu/~appel/papers/says.pdf
- Appel 2001: V
- Necula & Rahul 2001: V
- Chiesa & Tromer 2010: V. https://ic-people.epfl.ch/~achiesa/docs/CT10.pdf
- Bitansky et al. 2013: V. https://eprint.iacr.org/2012/095
- McConnell et al. 2011: V
- Jackson et al. 2021 (arXiv 2104.06178): V
- Sirer et al. 2011: V. https://www.sigops.org/s/conferences/sosp/2011/current/2011-Cascais/18-sirer-online.pdf
- Bai, Tadjouddine & Guo (arXiv 1404.0854): V
- Dickerson et al. 2018: V. https://www.paulgazzillo.com/papers/wtsc18.pdf
- Imamura 2026 (arXiv 2608.20671): V
- MAGE (arXiv 2008.09501): V
- Thompson 1984: V
- Gabbay 2026 (arXiv 2606.23768): V (lead)
- Ciliberto, Rudi & Tassi 2026 (arXiv 2610.28484): **U** (lead)
- Canetti, Fiat & Gonczarowski (arXiv 2302.05590): V
- P³ (arXiv 2608.09277): V
- Bartoletti & Zunino 2010: V. https://zunino.maths.unitn.it/papers/aCalculusOfContractingProcesses-LICS10.pdf
- Bartoletti, Cimoli & Zunino 2013: V. https://link.springer.com/content/pdf/10.1007/978-3-642-36830-1_10.pdf
- Maier 2003: V
- Abadi & Lamport 1995: V
- Blaze, Feigenbaum & Strauss 1998: V
- Pudlák 1985: U
- Pudlák 1996/98/2017: V
- Pakhomov 2019: V
- Willard: V
- Rice 1953: U

### Fair exchange and distributed systems

- Pagnia, Vogt & Gärtner survey: V
- Even & Yacobi 1980: U
- Pagnia & Gärtner 1999: U
- Even, Goldreich & Lempel 1985: V
- Orzan & Torabi Dashti 2008: V
- Avoine et al.: V
- Chadha et al.: V
- Bentov & Kumaresan 2014: V
- Herlihy 2018 (arXiv 1801.09515): V
- Halpern & Moses 1990: V
- Rubinstein 1989: V (G3) / U (G5)
- Izmalkov, Micali & Lepinski 2005: V
- Narkawicz & Muñoz 2011: V
- FAA TCAS II v7.1: V

### Cooperative AI and LLM agents

- Dafoe et al. 2020: V (arXiv ID U)
- Hammond et al. 2025: V
- Chan et al. 2025: V
- flexHEG (Petrie et al. 2025): V. https://arxiv.org/abs/2506.15093
- Tegmark & Omohundro 2023: V. https://arxiv.org/abs/2309.01933
- Kundu et al. 2026: V. https://arxiv.org/pdf/2608.12125
- Lin et al. (arXiv 2512.21024): V
- Sistla & Kleiman-Weiner (arXiv 2512.00371): V (G4) / U (G1, G3)
- Levine 2026: V
- berns 2026: V
- Clifton 2019: V
- Singh c. 2014: V. https://www.csc2.ncsu.edu/faculty/mpsingh/papers/mas/Commitments-for-MAS.pdf
- Wan & Singh 2005: V. https://www.csc2.ncsu.edu/faculty/mpsingh/papers/mas/aamas-05-wan-singh.pdf
- Venkatraman & Singh 1999: V
- Goldwasser et al. 2021: V
- Alexander, "Demiurge's Older Brother": V. https://slatestarcodex.com/2017/03/21/repost-the-demiurges-older-brother/

### Biology, signalling, sociology, institutions

- Gardner & West 2010: V
- Queller et al. 2003: V
- Roberts & Sherratt 2002: V
- Traulsen & Nowak 2007: V
- Shutters & Hales 2013: V
- Lehmann et al. 2024: V
- Grafen 1990: V
- Penn & Számadó 2020: V
- Henrich 2009: V
- Frank, Gilovich & Regan 1993: V. https://gwern.net/doc/economics/1993-frank.pdf
- Frank 1988: U
- Yamagishi & Yamagishi 1994: V-rec
- Kuwabara 2015: V
- Cook, Hardin & Levi: U
- Barrett 2008: V
- Glaser, Barak & Goldston 2012: V
- Nurse Licensure Compact: V. https://www.azleg.gov/ars/32/01660.htm
- WADA Art. 15: V

---
## Addendum: corrections from the research report (2026-11-18, overrides the above)
- **Ciliberto, Rudi & Tassi, "Proof-Carrying Contracts: Commitments AI Agents Cannot Break", arXiv 2610.28484 (20 Oct 2026): VERIFIED** (abstract opened). The agent supplies a Lean-checkable proof that a requested operation preserves agreed constraints. An execution system (the "Airlock") checks it, with an agent-to-system gate, not between peers, and no conditionality on a counterparty's commitment. Closeness: medium. Repo: github.com/consequential-ai/proof-carrying-contracts.
- **Sobel 1972 / Mintoff 1993: NOT confirmed.** No primary text seen contains an "I cooperate iff you make this same promise" construction. Do NOT cite them for it until it's checked against the text (leads: Sobel 1972 §2.131 and p. 174; Mintoff thesis ch. 3). Remove them from the "closest work" list for now.
- **DiGiovanni, Clifton & Macé (AAMAS 2025): CONFIRMED** from the opened PDF. They state that relaxing the assumption that players can syntactically verify a program follows a template is left to future work. They also compare coordinating on a selection function to coordinating on the programming language. That's the clearest statement of the gap we fill.
- **Duclaux et al. 2026: CONFIRMED** (abstract): nine programs, offline per-pair machine-checked proofs, and an agentic pipeline that re-proves 40/45 outcome theorems; agents call an axiomatized bounded proof-search oracle and carry no certificates at play time. Authors: Duclaux, Formenti, Cobben, Schölkopf, Jin; repo github.com/ColombanD/open-source-game-theory (not opened).
- **GitHub issue #2 (public-observatory/open-source-game-theory): still UNCONFIRMED** (search snippets only; the user can't find the repo). The snippets say it poses mutually conditional commitments with certificates of a global safety invariant as an open question. Treat it as a lead only.
- **Wolpert:** low closeness. Game mining (Bono & Wolpert; arXiv 2401.02353) uses third-party-enforced outcome-contingent contracts and explicitly defers Kalai-style conditional commitments to future work. The persona model (Wolpert, Jamison, Newth & Harré 2010/2011) assumes an unmodeled honest-signaling mechanism, which certificates could supply. Ramirez, Nagel, Wolpert & Jost (2023, 2025) cover binding-contract manipulation and extortion (commitment cuts both ways); their 2025 paper defers commitments made in reference to other commitments (Harrenstein 2007; folk theorem Katz 1991). New leads: **Harrenstein 2007; Katz 1991**.

## Correction (2026-11-18, later): GitHub issue #2 is NOT to be cited
The user couldn't find github.com/public-observatory/open-source-game-theory on GitHub or any search engine. The app ran four targeted searches (the repo name, the exact issue title, the GitHub organization, and the issue's supposed content) and found no page referencing it. Every earlier mention traces back to search "snippets" reported by sub-agents or the research tool, never to an opened page. Treat it as nonexistent (likely confabulated). Remove it from all lists, and don't cite it.
