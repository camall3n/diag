# G2 synthesis: computer science and logic cluster

**Sources.** litF, F11–F20, M07, M11, M14, M16, M21, M24, M27, M32, W07, W13 and W14. Report tags appear in brackets.

**Verification status.** VERIFIED (V) means at least one report says it opened the page. "Abstract" means only the abstract was seen.

**Ratings.** The reports use two scales. The F-reports and litF rate *novelty threat*; the M-reports rate *relevance*. Where the two differ, I give both.

---

## 1. Prior answers to build on (ranked by closeness)

**Unknown, possibly high: "Certificates for joint behavior", Issue #2 in public-observatory/open-source-game-theory.**
- https://github.com/public-observatory/open-source-game-theory/issues/2. **UNVERIFIED**: the fetch failed and repo access was declined [litF].
- The title alone matches our idea. A human should read the issue and the repo README.

### Medium

**Duclaux, Formenti, Cobben, Schölkopf & Jin (2026), "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean", ICML 2026 AI-for-Math workshop.**
- https://icml.cc/virtual/2026/82498. **VERIFIED (abstract only).** OpenReview (Wc5TAIUC8k) and the repo were blocked.
- *What it does:* Lean 4 proof-based OSGT: nine bots, machine-checked pairwise outcome theorems, an LLM pipeline reproving 40 of 45, meta-game equilibria.
- *What it doesn't do (per abstract):* proofs are offline meta-theorems; bots use bounded search; no attached certificates, play-time checker or standard K.
- *Reuse:* its bot library and its LLM pipeline as baselines.
- *Ratings:* medium [F11, F13, F17, F20]; medium-low [F15]; high relevance as a "novelty risk" [M11].

**zhongmingjiang, "Proof of Löbian Cooperation" (PoLC), GitHub, undated.**
- https://github.com/zhongmingjiang/Proof_of_Lobian_Cooperation. **VERIFIED** [litF].
- *What it does:* markdown proposal: PE agents, a neural proposer of bounded-Löb proof terms, a Lean micro-kernel checker.
- *What it doesn't do:* there are no Lean files and no results. Its certificate is a proof about the *pair*, found at play time. Ours is a membership proof each agent attaches about itself.
- *Rating:* medium on priority of the idea, low on substance.

**Bartoletti, Cimoli & Zunino (2013), "A Theory of Agreements and Protection", POST 2013, LNCS 7796:186–205.**
- https://link.springer.com/content/pdf/10.1007/978-3-642-36830-1_10.pdf. **VERIFIED** [litF, F14].
- Journal version: Bartoletti, Cimoli, Pinna & Zunino, JLAMP 85(3), doi:10.1016/j.jlamp.2015.05.001.
- *What it does:* proves that "agreement" (≈ our Thm A) and "protection" (≈ our Thm B) cannot both hold under ordinary causality. Circular enabling ("I do a if you promise b") restores both. All parties may use the same contract.
- *What it doesn't do:* no programs, no carried proofs. Protection depends on obligations being honoured later and on blame.
- *Reuse:* the impossibility result, to motivate self-reference.
- *Ratings:* low threat but high value [litF]; medium [F14].

**Bartoletti & Zunino (2010), "A Calculus of Contracting Processes", LICS 2010:332–341.**
- https://zunino.maths.unitn.it/papers/aCalculusOfContractingProcesses-LICS10.pdf. **VERIFIED.**
- *What it does:* Propositional Contract Logic (PCL) has a handshake rule: from (p↠q)∧(q↠p), infer p∧q. PCL is PSPACE-complete, and its Horn fragment is polynomial [F14].
- *What it doesn't do:* agreement comes from proof search over declared formulas, not from checking proofs about code.
- *Reuse:* frame K as "executable contractual implication". The Horn fragment is a candidate for S.
- *Rating:* medium [litF, F14].

**Chiesa & Tromer (2010), "Proof-Carrying Data and Hearsay Arguments from Signature Cards", ICS 2010; and Bitansky, Canetti, Chiesa & Tromer (2013), STOC 2013.**
- https://ic-people.epfl.ch/~achiesa/docs/CT10.pdf and https://eprint.iacr.org/2012/095.
- **VERIFIED** [F12]. M14 marked Chiesa & Tromer UNVERIFIED.
- *What it does:* a verifier, built with the recursion theorem, accepts inputs whose proofs show that this same verifier accepts. This is the strongest existing text against "self-referential, cheaply checked certificates are new".
- *What it doesn't do:* no strategy. It is well-founded over history, and it needs depth bounds and cryptography.
- *Reuse:* zero-knowledge or succinct K-certificates.
- *Ratings:* medium [F12]; high relevance [M14]; none [litF, F11].

**Ciliberto, Rudi & Tassi (2026), "Proof-Carrying Contracts" (PC2), arXiv:2610.28484.**
- https://arxiv.org/abs/2610.28484v1. **VERIFIED** [litF].
- *What it does:* an "Airlock" checks Lean 4 proofs for each tool call, against a contract.
- *What it doesn't do:* single agent, a third-party checker, no conditionality.
- The authors announce a multi-agent sequel.

**van der Hoek, Witteveen & Wooldridge (2013), "Program equilibrium—a program reasoning approach", IJGT 42:639–671.**
- https://www.cs.ox.ac.uk/people/michael.wooldridge/pubs/ijgt2013.pdf. **VERIFIED** [M11]. It is *not on our known list*.
- *What it does:* temporal-logic guards over the other players' behaviour, framed explicitly as conditional commitments. Deciding coherent outcomes is NP-complete. A circular "iff" can have zero, one or many outcomes.
- *Reuse:* our proofs settle the tension it identifies between semantic and syntactic conditions.
- *Rating:* medium–high relevance.

### Low–medium

- **Ondras (2026), "Lean-Verified Handshake…"** (https://icml.cc/virtual/2026/77909) and **"Axiom-Audited Trustworthy Formalization…"** (https://icml.cc/virtual/2026/82487). **VERIFIED (abstracts only).**
  - Attestation goes through a `TrustedOracle`, and the games are Stag Hunt. No PD, no code certificates.
  - Ondras argues that program-equilibrium constructions are impractical for LLM agents [F11].
  - Ratings: low [F13, F17] to medium [F15, F19].
- **Bai, Tadjouddine & Guo, "Enabling Automatic Certification of Online Auctions", arXiv:1404.0854.** **VERIFIED.**
  - Bidders check the auctioneer's Coq proof of truthfulness: the only "PCC for game-theoretic properties" found, one-way. Don't claim that phrase [litF, F11]. Precursor FACS 2013 venue UNVERIFIED.
- **Gross, Gallagher & Fallenstein (2016), "Löb's Theorem: A functional pearl of dependently typed quining".** https://jasongross.github.io/lob-paper/nightly/lob-preprint.pdf. **VERIFIED.**
  - FairBot in Agda. The bots are proved about; they carry nothing.
  - Ratings: low [F18]; high relevance [M24].
- **Payor (2025), "Working through a small tiling result".** https://www.greaterwrong.com/posts/akuMwu8SkmQSdospi/working-through-a-small-tiling-result. **VERIFIED.**
  - Accepts successors iff they are provably "good_new", a property that refers to itself. Single-agent, with proof search.
  - The closest structural ancestor of K [F17].
- **Imamura (2026), "Bootstrapping Mutual Attestation with Kleene's Second Recursion Theorem", arXiv:2608.20671.** **VERIFIED.**
  - A hardware CliqueBot built with the recursion theorem. It could serve as K's binding layer [F19].
- **Sirer et al. (2011), "Logical Attestation", SOSP.** https://www.sigops.org/s/conferences/sosp/2011/current/2011-Cascais/18-sirer-online.pdf. **VERIFIED.**
  - Guards check proofs supplied by clients in under 1 ms, and labels can certify behaviour. No reciprocity.
  - Ratings: low threat [F12, F20]; high relevance [M27].
- **Appel & Felten (1999), "Proof-Carrying Authentication", CCS.** https://www.cs.princeton.edu/~appel/papers/says.pdf. **VERIFIED** [F11, F12]; M27 marked it UNVERIFIED.
  - The requester proves and the server checks. This gives us the name "proof-carrying cooperation".
- **Hall-Andersen & Schwartzbach (2021), SAGT, arXiv:2107.04393.** **VERIFIED** [M32].
  - Contracts conditioned on contracts; finding subgame-perfect equilibria is PSPACE-hard. Our single fixed K sidesteps that hardness.
- **Canetti, Fiat & Gonczarowski, arXiv:2302.05590.** **VERIFIED** [M14]. Zero-knowledge commitment to hidden mechanisms, one-to-many.
- **DiGiovanni & Clifton, AAAI 2023, arXiv:2204.03484.** **VERIFIED (abstract).** Assumes transparency rather than proofs.
- **Jackson et al. (2021), "Certified Control", arXiv:2104.06178.** **VERIFIED** [M07]. A certificate checked by a small verified monitor; one-way.

### Ancestors (none/low)

Necula's PCC (one-way, non-reflexive, protects the host) [litF, F11, F19, M27]; Appel's FPCC and 2007 "very modal model"; certifying algorithms (McConnell et al. 2011; Alkassar et al.).

---

## 2. Objections and limits raised

1. **Binding: proven text vs running code.** Raised by F19, M27, W07, W13, F15 (§6.2), F12 and M14.
   - Thompson's "Trusting Trust" uses K's own quine ingredient. Replay and relay attacks are also live [W07].
   - *Serious.* Make binding an explicit assumption of Thms A/B.
   - Discharge it with a layered stack: K-certificate, then in-toto/SLSA, then reproducible or attestable builds, a TEE, or Imamura [F19].
2. **Inherent incompleteness.** Raised in [litF, F13, F14, F15, M21, M24].
   - Sources: Maier; Namjoshi & Trefler; honesty is undecidable; Rice.
   - Lemma 5 of McConnell et al.: cheap certificates both for and against would put the problem in NP∩coNP.
   - *Concede.* This supports one-sided K/K′.
3. **The convention costs something, and the cost recurs** [M16, M32, M21, M24, M11].
   - Fragmentation: Oster & Quigley (UNVERIFIED).
   - The checker owner becomes a bottleneck: Dimyadi & Amor; *ASTM v. PRO*.
   - A clearinghouse becomes systemically important.
   - A rich shared representation language is required: CORENET.
   - Different checkers give incompatible fixed points.
   - *Partial answers:*
     - an open standard and checker;
     - Milawa-style bootstrapping [F15, F16];
     - DDC-style diverse checkers or a CakeML-verified binary [F19];
     - equivalence-tolerant standards [M16].
   - Session types and KeyNote show that a shared global specification is an accepted cost [F14, F20].
4. **Simulation agents need no shared checker** (Oesterheld) [M11, M21]. *Medium.*
   - Compare the cost models. F15 classes simulators as Blum–Kannan checkers.
5. **"Cheap" is relative to proof size; producing proofs may be expensive** [M11, M16, F17].
   - Kumar & Fallenstein estimated person-years of work.
   - Mitigations: oracle certificates are about 30× smaller [F11]. P³ shows LLMs co-generating proofs successfully about 72–77% of the time [litF].
6. **Reviewers may say "PCA/PCD with a self-referential predicate"** [F12, M14] or "Duclaux plus certificates".
   - Answer: game semantics, Thms A/B, no cryptography, symmetric peers.
7. **Selecting the fixed point.** "Iff" admits both all-C and all-D [M11, M21, F13].
   - *Disagreement.* M11 says a Löbian or fixed-point argument is needed. M21 says the diagonal lemma suffices once proofs are shipped: a member satisfies K by unfolding, and the certificate grounds it. litF and F13 place the leftover circularity inside K's diagonal definition.
8. **Self-soundness.** S cannot prove its own soundness (Pudlák 1985; Pakhomov) [F16, F17, litF]. Already handled by Lean; say so explicitly.
9. **Mixed strategies.** Monte Carlo algorithms resist deterministic certification [F15]. *Low–medium.*
10. **Privacy.** Code must be open. Possible routes: zk-PCD, Canetti et al., Gabbay, or publishing only the checker [F12, M14, litF, F15].
11. **LLMs act poorly on verified safety** (Bottazzi & Park) [F19]. Hard-wire the checker's verdict.
12. **Only prescriptive or safety-like behaviour formalizes easily** [W14, M16]. K is fully prescriptive.
13. **Unfairness under abort** in sequential mutual disclosure [F20, F12]. Our simultaneity assumption removes this; state it.

---

## 3. Reframings and motivations

- **Proof-carrying commitments / cooperation.** PCC or PCA with symmetric peers and a reflexive shared policy [litF, F11, F12, F20, M11, M27].
- **The certificate as a guard.** A behavioural "iff" is the unsound zero-delay circular assume-guarantee rule (Abadi–Lamport; Agarwal et al.). Time, ▷ and □ are all guards. The certificate removes the cycle between behaviours [litF, F13, F18].
- **K as an interface assertion** in the sense of Namjoshi–Trefler [F13].
- **Agreement plus protection.** Thms A/B achieve what Bartoletti et al. prove needs circularity [litF, F14].
- **Certifying agents.** Witness, simple checker, verified checker [F15].
- **Peer tiling.** Yudkowsky–Herreshoff's Σ/Δ split, made multi-agent. This answers §7 of Fallenstein & Soares [F17].
- **Property-based mutual attestation.** Hash attestation corresponds to CliqueBot; property attestation corresponds to K [F19, M27, W07, W13].
- **Least fixed point vs diagonal grounding.** RT and Carbone et al. ground cycles from below. That pure reciprocity then yields nothing is the report authors' inference. The trust-negotiation deadlock is our problem's twin [F20, F12].
- **Variants of K.** A guarded or step-indexed K, a Payor-based K, and typed membership via TAL or Kavvos [litF, F11, F17, F18, M24].
- **The certificate as a finite coinductive witness** of a simulation regress or of common knowledge [F18].
- **Clique to open class.** Certificates select the cooperative fixed point [M21].
- **Ludics bi-orthogonality** as the ideal that K approximates (source UNVERIFIED) [W14].
- **Motivating examples.**
  - The proof-carrying-agent-actions wave (Gabbay) [litF].
  - LLM PE agents tested only with unit tests (Lin et al.) [litF].
  - Chlipala's "PCC in the Matrix" [F11].
  - "Verify, but Trust" [F12, F19].
  - Singapore's CORENET checker [M16].
  - ERC20 and proof-carrying smart contracts; clearinghouses as certified clubs [M32].

---

## 4. Necessity and impossibility results

1. **Agreement vs protection.** Circularity is needed (Bartoletti, Cimoli & Zunino 2013) [litF, F14].
2. **Unguarded circular assume-guarantee is unsound** (Abadi & Lamport; Rushby's counterexample; zero-delay loops) [F13].
3. **No compositional circular rule is both sound and complete** without auxiliary structure (Maier 2003; Namjoshi & Trefler). This motivates both the convention and incompleteness [litF, F13].
4. **Undecidability.** Honesty and asynchronous session subtyping are undecidable [F14]. Rice-type limits apply to membership [M21, M24].
5. **Verifier-side search is costly.** Compliance checking with programmatic credentials is undecidable or NP-hard (Blaze, Feigenbaum & Strauss 1998) [F20].
6. **Self-trust.** Gödel II and Pudlák 1985: no theory containing Q proves its own consistency, even on a cut. Herbrand variants are no better (Adamowicz; Kołodziejczyk). Self-verification works only below Q (Willard; Pakhomov). So soundness must live in Lean [F16, F17].
7. **Classical logic collapses ↠** [litF].
8. **Two-sided cheap certificates imply NP∩coNP** [F15].
9. **CONN.** No optimal proof system means no universal short-certificate standard [F16].
10. **Recursive PCD needs depth bounds or an oracle** [F12].
11. **Bounded consistency has polynomial-length proofs** (Pudlák): bounded self-trust is cheap, but it needs bookkeeping [litF, F16].
12. **Contrast case.** Assume-admissible synthesis is rectangular without a convention [F13].

---

## 5. Annotated bibliography (V = VERIFIED, U = UNVERIFIED)

**AI / open-source game theory**
- Duclaux et al. 2026: Lean OSGT, offline proofs. V (abstract).
- Ondras 2026 (×2): oracle-based Lean commitments. V (abstract).
- Ciliberto, Rudi & Tassi 2026: single-agent proof-carrying contracts. V.
- PoLC repo: informal Lean-certificate PE. V.
- Issue #2 (public-observatory): U.
- Gabbay 2026 (arXiv:2606.23768): ZK policy certificates for actions. V.
- Emergent Mind PCAA page: lists ~10 papers; multi-party open. V.
- Lin et al. (arXiv:2512.21024): LLM PE code tested with unit tests. V.
- Li et al. P³ (arXiv:2608.09277): LLM program+proof. V.
- Koomullil 2026: Lean certificates for LLM pipelines. V.
- Levine 2026: survey citing Duclaux. V.
- Chlipala 2026: PCC skill trading. V.
- berns 2026 "Verify, but Trust": trust moves to the kernel. V.
- Bottazzi & Park 2026: LLMs and TEE attestation. V.
- Jin et al. Proof-of-Guardrail: K′-like TEE pattern. V.
- Wang (arXiv:2606.04104): governance receipts; dead end. V.
- van der Hoek, Witteveen & Wooldridge 2013: guard-based PE. V.
- Barasz et al. 2014: known. V (abstract).
- Critch 2016/19: known. V (abstract) [M11, M21]; U [W07, M24].
- Tennenholtz 2004: known. U here.
- Oesterheld 2019; Cooper, Oesterheld & Conitzer (arXiv:2412.14570); arXiv:2211.05057: simulation agents and compatibility. U.
- Kalai et al. 2010: commitment folk theorem. U.
- DiGiovanni & Clifton 2023: conditional disclosure. V.
- "A failed solution to open-source game theory": niceness tests miss cooperators. V.
- "Generalized CliqueBots": interface CliqueBot. V (author U).
- "Open-Source Games Are Loopy": informal fixed points. V.

**PCC family**
- Necula 1997: PCC. V [F19, M27]; U [M11, M14, W14].
- Necula & Lee 1996 (OSDI): V.
- Necula & Lee 1998 (PLDI) + retrospective: certifying compiler. V.
- Necula & Rahul 2001: oracle checking. V.
- Appel 2001 FPCC + project page: V.
- Appel, Michael, Stump & Virga 2003: TCB under 2,700 lines. V.
- Wu, Appel & Stump 2003; Appel & McAllester 2001: U.
- Appel, Melliès, Richards & Vouillon 2007: GL model with "later". V.
- Ni & Shao 2006 (XCAP): specs about others' specs. V.
- Morrisett et al. 1999 (TAL): V.
- Appel & Felten 1999: PCA. V.
- Bauer 2003 thesis: cyclic delegation disallowed. V.
- Bauer, Garriss & Reiter 2007: V.
- Whitehead, Abadi & Necula 2004: V.
- Sekar et al. 2003 (model-carrying code): V.
- Bielova et al. 2009: V.
- Drzevitzky et al. 2009 (proof-carrying hardware): V (record).
- Chiesa & Tromer 2010; Chiesa thesis: V.
- Bitansky et al. 2013: V.
- Valiant 2008 (IVC): U.
- Bünz et al. (ePrint 2020/1618): V.
- Dickerson et al. (proof-carrying smart contracts): V.
- Bai, Tadjouddine & Guo: V.
- Bai, Tadjouddine, Payne & Guan: PDF V, venue U.
- Tadjouddine, Guerin & Vasconcelos 2009: U.

**Certifying algorithms**
- McConnell et al. 2011: V.
- Alkassar et al. 2011/2014: verified checkers. V.
- Rizkallah 2015; Mehlhorn slides: V.
- Blum & Kannan 1989; Kratsch et al. 2003: V.
- Völlinger & Akili 2017/18: distributed witnesses. V.
- Korman, Kutten & Peleg 2010 (proof labeling): V.
- Beyer et al. 2016 (witness format): V.
- Namjoshi 2001; Tan, Heule & Myreen 2023; Davis 2009 (Milawa): V.
- Brânzei & Procaccia: V (venue U).
- Azar & Micali 2012: V.

**Contracts and session types**
- Bartoletti & Zunino 2010 + DISI TR: V.
- Bartoletti, Cimoli & Zunino 2013; JLAMP version: V.
- Circular causality 2014/2015: V.
- "Contract agreements via logic" / "Vicious circles": Horn PCL. V.
- Honesty by Typing: V.
- Bartoletti, Tuosto & Zunino 2012: V (venue U).
- Castagna, Gesbert & Padovani; Carpineti et al. 2006; Laneve & Padovani 2007; Bravetti & Zavattaro 2007: V.
- Bravetti, Carbone & Zavattaro: undecidable subtyping. V.
- Honda et al. 1998/2008; Bernardi & Hennessy 2015 (peer compliance); Ciccone & Padovani 2022: V.

**Circular assume-guarantee / control**
- Misra & Chandy 1981; Abadi & Lamport 1995 (1993 version U); McMillan 1999; Rushby 2001; Namjoshi & Trefler 2010; Maier 2003; Viswanathan & Viswanathan 2001: V.
- Agarwal et al. (FMCAD 2015): V (venue inferred).
- Chatterjee & Henzinger 2007; Chatterjee, Henzinger & Jurdziński 2004 (secure equilibria); Brenguier, Raskin & Sankur 2015: V.
- Shiple, Berry & Touati 1996: V (bibliography + slides).
- Benveniste et al. 2018: V [F13], U [M07].
- Elkader et al. 2015; Henzinger, Qadeer & Rajamani 1998: irrelevant. V.
- Saoud, Girard & Fribourg: U.
- Tan, Papachristodoulou & Dimarogonas: V.
- Hobbs et al.; Qin et al.; Wang, Ames & Egerstedt: U.
- Jackson et al. (Certified Control): V.

**Guarded recursion / fixed points**
- Birkedal et al. 2012: V [litF, F18], U [M24].
- Nakano 2000; Clouston & Goré; Iris lecture; nLab; Kavvos 2017/2021; Atkey & McBride 2013; Clouston et al. (arXiv:1501.02925): V.
- Coquand 1994: V (abstract).
- Kozen & Silva 2017; Gupta & Belnap 1993; Barwise & Moss 1996; Capretta; Baston & Capretta 2018; Lescanne & Perrinel; Abramsky & Winschel; Montalvo 2026 (guarded non-monotone uniqueness); Milius & Litak; Guatto 2018: V.
- Gross et al. 2016: V.
- Payor 2023; Critch 2023 (Payor's lemma): V.
- transhumanist_atom_understander 2026: V.
- Demski "Probabilistic Payor Lemma?": U.
- Lawvere 1969: U.
- Yanofsky 2003: V [M21], U [M24].
- Kripke 1975: U.
- Ghani et al. (open games): U.
- Girard, Locus Solum: U.

**Reflection / self-verification**
- Yudkowsky & Herreshoff 2013 (Σ/Δ split); Fallenstein & Kumar 2015; Fallenstein & Soares 2014/2015; Kumar & Fallenstein 2017; Kumar, Arthan, Myreen & Owens 2016: V.
- "Loebian cooperation in the tiling agents problem": V (author U).
- Payor 2025: V.
- Demski "Seeking Collaborators" comment: V.
- Willard 2001/2005/2011/2013: V.
- Pudlák 1985: U (secondary sources only).
- Pudlák 1996/1998/2017: V.
- Adamowicz 2002; Kołodziejczyk 2006; Pakhomov 2019; Pakhomov & Visser 2022; Visser 2026: V.
- Bezboruah & Shepherdson 1976: U.
- Cheng 2020; Diffractor 2018; Harrison 2006; Carneiro (MM0): V.
- Pudlák fin-con; Weaver 2013: U.

**Attestation / supply chain**
- Imamura 2026: V.
- MAGE: V.
- Thompson 1984: V [F19], U [W07].
- Wheeler 2005/2010 (DDC): V.
- Lamb & Zacchiroli; in-toto; SLSA v1.1 (excludes behaviour); Haldar et al. 2004: V.
- Sadeghi & Stüble 2004: V [F19], U [M27, W13].
- Sailer et al. 2004: U.
- Hugenroth et al.; CakeML; CHAINIAC; AGORA; Gudmundsson & Hougaard 2025; RFC 9334: V.
- Knauth et al. (RA-TLS): U.
- 3GPP AKA; Sigstore: U.
- Savage et al.; RFC 3540; Floyd & Fall; Marti et al.; Gil et al.; Waibel et al.; Strobel et al.: behavioural or identity analogues. U.

**Trust management**
- V: Blaze, Feigenbaum & Lacy 1996; Blaze, Feigenbaum & Strauss 1998 (search NP-hard/undecidable); RFC 2704/2693; Binder; RT; SecPAL; S4P ("will" promises); Carbone, Nielsen & Sassone; Krukow & Twigg; OSBE; Li, Li & Winsborough; Winsborough & Li (cyclic deadlock); Balfanz et al. (secret handshakes).
- NAL: V [F12], U [M27].
- Weeks 2001; Hidden Credentials: U.

**Crypto / finance / other**
- Canetti, Fiat & Gonczarowski: V.
- Dodis, Halevi & Rabin; Sun et al.; Ferreira & Weinberg; Ferreira & Parkes: U.
- Hall-Andersen & Schwartzbach: V.
- Gorton 1985: V (abstract).
- Kroszner; Acharya & Bisin; Bahr, Berthold & Elsman: U.
- Dimyadi & Amor; CORENET; *ASTM v. PRO*: V.
- Eastman et al.; Oster & Quigley; EU CPR; Noardo et al.: U.
- Halpern & Pass (costly computation): dead end. V.
- Van Hertum et al. 2016: V (abstract).
- Alpay & Alakkad 2025: V.
- Pagnia & Gärtner: U.

---

## 6. Open leads

**Urgent**
- The full Duclaux paper and repo: does it have play-time certificates or a checker? [F11, F13, F17, F20, M11]
- GitHub issue #2 and its README [litF].
- The full text of Ondras [F19].
- The announced PC2 sequel [litF].

**Not covered**
- Contract automata [litF].
- Session-type duality as a mutual check. F14 covered session types only partly.
- Bravetti–Zavattaro WS-FM 2008 (paywalled) [F14].
- About nine unopened papers on the Emergent Mind page [litF].

**To verify**
- Venues for Bai et al. FACS 2013 and Tadjouddine 2009.
- Saoud, Girard & Fribourg [M07].
- Pagnia & Gärtner [F12].
- Weeks 2001 and Hidden Credentials [F20].
- Pudlák's fin-con and Krajíček–Pudlák 1989 [F16, litF].
- The JSL version of Critch [M11].
- Gross's companion page on the PD [M24].
- The "Giles" origin [F17].
- Demski's probabilistic Payor [F18].
- Weaver 2013 [F17].
- Van Hertum et al., a fixpoint semantics for mutual "says" [F12].
- The blocked orbilu contracts paper [litF].
- Grey's distributed proving [F20].
- All W13 and W14 citations.

**Technical checks**
- Whether reciprocal cycles stay at bottom under RT or Carbone semantics [F20].
- A guarded or step-indexed K, with uniqueness [litF, F11, F18].
- Certificate size under Payor's lemma vs Löb's theorem [F17, F18].
- Oracle-based certificates [F11].
- Lower bounds from proof labeling [F15].
- Rectangularity contrast [F13].
- M21's proposed theorem that "the diagonal lemma suffices with shipped proofs".
