# G3 synthesis: cryptography, distributed systems, fair exchange, TEEs, banking/aviation analogues

Sources: litG, wild1, wild2, F21–F30, M12, M20, M31, M38, M39, W08, W09. VERIFIED = at least one report says it opened the source (sometimes only the abstract); UNVERIFIED = none did. "[inference]" marks my own synthesis. M-series reports rate *relevance of an objection*; F-series rate novelty threat.

**Headline.** No report found the full scheme anywhere. The group's main contribution is a **necessity result**: Theorems A and B are the effectiveness and fairness properties of fair exchange, which requires a TTP. The program-equilibrium runner (simultaneous, binding execution) is that TTP. Ten reports make this point.

---

## 1. Prior answers to build on (ranked by closeness)

### Medium

1. **Ondras, J. (2026). "Lean-Verified Handshake: A Mechanized Commitment Kernel Against Coordination Failure Among Opaque AI Agents." ICML 2026 workshop poster. https://icml.cc/virtual/2026/77909**. VERIFIED (litG).
   - *Does:* wraps opaque LLM agents in a Lean 4 attestation layer whose trust sits in a `TrustedOracle` typeclass. In Stag Hunts, attesting C weakly dominates.
   - *Lacks:* code reading, self-reference, "iff", and the PD.
   - *Reuse:* cite and contrast (PD + checked proof vs Stag Hunt + oracle).

2. **Ciliberto, C., Rudi, A. & Tassi, E. (2026). "Proof-Carrying Contracts: Commitments AI Agents Cannot Break." arXiv:2610.28484. https://arxiv.org/html/2610.28484v1**. VERIFIED (litG).
   - *Does:* each tool call carries a Lean-checked proof of contract compliance, checked inside an attested "Airlock".
   - *Lacks:* it is unilateral, single-agent, and has no game.
   - *Reuse:* the Airlock closes our certified-vs-running gap. MEDIUM on framing, LOW on result.

3. **Peters, M. & Szentes, B. (2012). "Definable and Contractible Contracts." *Econometrica* 80(1):363–411. https://doi.org/10.3982/ECTA8375**. VERIFIED (F25).
   - *Does:* a Gödel-coded reciprocal contract, built by self-application, plays C iff the opponent's code matches. It proves a folk theorem and argues for conditioning on function, not syntax.
   - *Lacks:* verification. Its checking is not cheap and not decidable.
   - *Reuse:* certificates make a cheap, decidable fragment of their semantic conditioning. MEDIUM.

4. **Kalai, A.T., Kalai, E., Lehrer, E. & Samet, D. (2010). "A commitment folk theorem." *GEB* 69:127–137. https://www.tau.ac.il/~samet/papers/commitments.pdf**. VERIFIED (F25, F30).
   - *Does:* devices condition on the opponent's *device*, which avoids circularity.
   - *Reuse:* Thm 3 (complete finite device spaces are degenerate) motivates an open-ended, proof-defined standard (F25).
   - *Ratings disagree:* MEDIUM (F30), LOW (F25), low–medium (M39).

5. **Canetti, R., Fiat, A. & Gonczarowski, Y.A. (2023/2026). "Mechanism Design Without Disclosure." arXiv:2302.05590**. VERIFIED.
   - *Does:* ZK proofs of properties of a hidden committed mechanism. §5.4 covers players' hidden strategies.
   - *Lacks:* it is one-sided and not conditional or self-referential.
   - *Reuse:* a template for ZK membership in K.
   - *Ratings disagree:* MEDIUM (F28), LOW (litG, F25, F27).

6. **Falk, J. "LLMs as Trusted Mediators: A Path Beyond Coordination…"** (EA Forum per F29; Substack, credited "Falk / Claude Opus 4.5", per litG). Undated. VERIFIED.
   - *Does:* a TEE-hosted mediator, tied to Tennenholtz and conditional offers.
   - *Lacks:* it is centralized, with no theorems or checker.
   - *Ratings disagree:* MEDIUM (F29), LOW (litG).

### Low–medium

7. **Dickerson, Gazzillo, Herlihy, Saraph & Koskinen (2018). "Proof-Carrying Smart Contracts." WTSC 2018. https://www.paulgazzillo.com/papers/wtsc18.pdf**. VERIFIED.
   - *Does:* every validator checks a proof against a published spec φ. This is the closest mechanism-level precedent.
   - *Lacks:* the spec is about the contract's own safety. No contract checks a counterparty.
   - *Reuse:* its governance rule (proof-only upgrades; changing φ needs a vote) fits our convention (F26).
   - *Ratings:* LOW–MED (litG, F26), LOW (F25).

8. **Gudmundsson, J. & Hougaard, J.L. (2025/26). "Smart contracts and reaction-function games." arXiv:2506.14413**. VERIFIED.
   - *Does:* "cooperate iff the other does" has two fixed points, and the paper selects (C,C) *by assumption*, through a central contract. It calls program equilibrium fragile. Our Theorem A *derives* (C,C).
   - *Ratings:* LOW–MED (litG), LOW (others).
   - *Reports disagree:* litG, F24 and F25 say it cites Tennenholtz; F27 and F29 say it doesn't.

9. **Narkawicz, A. & Muñoz, C. (2011). "State-based implicit coordination and applications." NASA/TP-2011-217067**. VERIFIED (M38).
   - *Does:* proves in PVS that any two algorithms meeting coordinated criteria coordinate: membership by property, not identical code. M38: "closest real-world analogue".
   - *Lacks:* proofs are checked at design time, and there is no "iff member" clause.

### Low (lineage to cite)

10. **PCC:** Necula, POPL 1997 (VERIFIED, wild2); Necula & Lee, OSDI '96 (VERIFIED, F27); Appel, FPCC, LICS 2001 (VERIFIED, F27). Our architecture is "mutual, self-referential PCC".
11. **Herlihy (2018). "Atomic Cross-Chain Swaps." PODC, arXiv:1801.09515.** VERIFIED. "No conforming party underwater" corresponds to Theorem B, and "all conform ⇒ all transfer" to Theorem A.
12. **Chatterjee & Henzinger (2007); Chatterjee & Raman (2012).** VERIFIED (F21). Secure equilibria are the strongest formal analogue of A/B, but they are synthesised jointly rather than certified.
13. **Even, Goldreich & Lempel (1985), CACM 28(6).** VERIFIED (F22). "Committed to C if you exhibit a witness": prior art for the *phrase*. Their witness is a secret, not a proof of reciprocity.
14. **Chen & Zhang (2020), MAGE, arXiv:2008.09501.** VERIFIED (wild1). In mutual enclave attestation the hashes depend on each other in a cycle, broken by a hash fixed point. A hardware CliqueBot.
15. **bryjnar (2017), "Zero-Knowledge Cooperation," LessWrong.** VERIFIED. An FHE validator that leaves open *what* to validate.
16. **"Proof of Collusion" (LessWrong shortform comment).** Page VERIFIED, author UNVERIFIED. Informally states our motivation and its collusion risk.
17. **Izmalkov, Micali & Lepinski (2005), FOCS.** VERIFIED (F30). Strategic equivalence to an ideal mediated game, a template for stating what K achieves.
18. **DiGiovanni & Clifton (2023), AAAI, arXiv:2204.03484.** VERIFIED. Conditional disclosure that leaves the crypto implementation open. F27 gives the title as "…information *revelation*", AAAI 2022.
19. **Lin et al., arXiv:2512.21024.** VERIFIED. LLMs read opponents' code without certificates, the opposite bet to ours. LOW–MED for the pilot (litG).
20. **TCAS II (FAA v7.1 intro).** VERIFIED (W09). Machines exchange "I climb iff you descend" with no referee. Deep structurally, but there is no temptation to defect.

---

## 2. Objections and limits raised

- **O1. Hidden TTP (fair-exchange impossibility).** Raised by wild1, wild2, litG, F21, F23, F24, M20, M31, M39 and W08. Severity: high for deployment, nil inside the model.
  - *Answer:* concede it as an explicit assumption. The convention replaces only the TTP's *judgment* (litG).
  - *Nuances:* Even–Yacobi holds even under synchrony, so what rescues us is simultaneity plus binding, not timing (F21). Fair exchange is *incomparable* to consensus (Orzan & Torabi Dashti), contrary to paraphrases in M20, M31 and M39. The guarantee covers the *decision*, not atomic *execution* of transfers (M31).
- **O2. Lost messages break Theorem B.** M20 (Halpern–Moses): if B's certificate arrives and A's is lost, A is exploited. Severity: high. *Answer:* Theorem B assumes atomic delivery by the runner.
- **O3. The standard must be common knowledge.** M31, F23 (Rubinstein unravelling). *Answer:* pin K and the checker by hash, and check exactly.
- **O4. Certified code ≠ running code ≠ acting principal.** Raised by:
  - wild1 (Thompson);
  - F22 (ASW replay attack, so bind the certificate to the exact code);
  - F26 and F27 (Nisan's identity gap);
  - F29 (Clifton's "credibility gaps"; Schlegel & Sun);
  - litG (Gopalakrishna; Proof-of-Guardrail);
  - M20 (attestation TOCTTOU);
  - M39 (Coker et al.);
  - M38 (Überlingen);
  - M31 (the KYC analogy).

  Severity: high outside the model. *Answer:* compose with attestation, an Airlock or verified compilation (F26, F29).
- **O5. Sequential reveal gives an advantage.** F22 (Chadha: K gives fairness always, but balance only under simultaneous reveal; harmless in the PD, not in asymmetric games). F21 (peer-to-peer submission is a simultaneous-broadcast problem; commit-then-reveal "probably" suffices, unproved). F24 (HTLC free option; sore-loser attacks). Severity: medium.
- **O6. Dual use: collusion, bribery, extortion.** litG (Dark DAOs; Kelkar), wild1 (Southampton), F21 (Goharshady), F25/F27 (Stackelberg attacks), F27/F28 ("Proof of Collusion"), F29. Severity: medium–high. *Answer:* state K's implications for third parties. K′ is a governance lever.
- **O7. The single checker is a single point of failure.** M39 (Szabo: one soundness bug becomes a universal exploit, and the maintainer a CA-like chokepoint); M20 (a self-referential policy enlarges the TCB). *Answer:* a small, Lean-verified checker (Appel lineage). Norman–Shmatikov found hand-proved protocol fairness broken under model checking (F22). PCSC-style governance.
- **O8. No collateral, so at best weak fairness.** M39 (Williamson, UNVERIFIED; Asokan). *Answer:* inside the model, binding gives strong fairness. In deployment, add deposits (Bentov–Kumaresan).
- **O9. Byzantine faults, coalitions, Sybils.** M20 (BAR and Douceur, both UNVERIFIED), F30 (non-members colluding to share or forge certificates). *Answer:* restate B as t-immunity; k-resilience is open.
- **O10. Rival standards don't compose.** M38 (NASA criteria), M39 (equilibrium selection), wild1 (tag cycles), wild2 (gauge lock-in). This makes the convention cost real and necessary.
- **O11. "Never exploited" is relative to what the checker sees and what K admits.** M38 (ACAS), M12 (the quantum-PD dispute).
- **O12. Substrate gaps and terminology.** F26 (EVMYulLean lacks code-inspecting opcodes); F27 and M12 (ZK or quantum checks cost far more than 10^5 steps); M12 ("commitment" is not a cryptographic commitment); F22 (EGL has priority on the phrase).

**Disagreement.** M39 says only weak, after-the-fact fairness is possible. litG, F23 and F24 say strong fairness holds in program equilibrium because the runner is the TTP. [inference] Both hold: M39 is right about deployment, the others about the model.

---

## 3. Reframings and motivations

- **Fair exchange of cooperation**: the convention replaces the TTP's judgment, making "the cost is a convention" a necessity (litG, F23, F24). "The TTP is the semantics" (F24).
- **Leaderless atomic swap**: Herlihy needs leaders forming a feedback vertex set; the fixed point needs none. "Hashlock → prooflock" (F24).
- **Contract signing in one round / EGL with the witness replaced by a proof of reciprocity**. Certificates as options (BGMR). Abuse-free by universality (GJM): K is identity-free (F22).
- **Optimistic fair exchange with the arbiter compiled out** (F21). **Atomic commit for agents**, where K vs K′ maps to fair vs rational exchange; **common knowledge from a finite certificate** (F23).
- **Mutual self-referential PCC / proof-carrying strategies / interaction-time PCC** (wild2, F26, F27). Convention = shared TCB (F27). K′ = a Proofgold bounty (F26).
- **Two verification layers**: attestation checks which code runs, the certificate what it does (litG, F29).
- **Privacy spectrum**: open source + certificate → ZK proof of K → FHE validator (F28, litG).
- **IML strategic equivalence**; "commitment, not communication"; t-immunity (F30). Selecting the good fixed point (litG, F25).
- **Greenbeards**: falsebeards are what B excludes; the hard part is unfakeability, not conditionality (wild2). Unbound tags collapse (wild1).
- **Parables**: RFC 1143 (looping reciprocity rules fixed by a provable machine); the IETF two-implementations rule (wild2).
- **Pre-verified reciprocity in practice**: CLS Bank (an intermediary plus a 5-hour window; funding under 1% of gross). Per W08, the price is always a third party, capital or synchronisation. Kidney-exchange simultaneity and NEAD chains; SALT I's non-concealment meta-promise (W09).
- **Economics / quantum**: Kocherlakota's "money is memory" assumes no commitment (M31). Unreadable, copy-protected code favours shipped proofs (M12).
- **Calls for this artifact**: Sun et al. 2023, Chan et al. 2025, Clifton 2019, berns 2026.

---

## 4. Necessity / impossibility results

- **Fair exchange:**
  - Even & Yacobi 1980 (UNVERIFIED primary; via Pagnia–Vogt–Gärtner).
  - Pagnia & Gärtner 1999 (UNVERIFIED primary): an FLP reduction under asynchrony with benign failures.
  - Torabi Dashti & Mauw separate the two lines.
  - Fair exchange is incomparable to consensus (Orzan & Torabi Dashti).
  - Cleve 1986 (UNVERIFIED), with Gordon et al. 2008 as a partial escape.
  - With security modules, fair exchange ≡ biased consensus (Avoine et al.).
  - Impossibility of balance (Chadha et al.).
  - Rational exchange without a TTP needs reliable networks and large punishments (Buttyán et al.).
- **Knowledge and commit:**
  - Coordinated action requires common knowledge, which is unattainable over unreliable or imprecise channels (Halpern & Moses 1990).
  - Almost-common knowledge fails (Rubinstein 1989).
  - FLP 1985; Skeen 1981 (nonblocking commit).
- **Rational crypto:**
  - A known round bound unravels (Halpern & Teague).
  - Cryptographic cheap talk can't always implement a mediator without empty threats (Hubáček, Nielsen & Rosen).
- **Blockchains:**
  - Swaps need a strongly connected digraph and leaders forming a feedback vertex set (Herlihy).
  - Cross-chain communication needs a TTP (Zamyatin; abstract only).
  - Escrow needs a TTP or irrational punishers, or else permits extortion (Goharshady).
  - Sore-loser attacks can only be hedged (Xue & Herlihy).
  - An HTLC is a free option (Han et al.).
- **Commitment:**
  - Complete finite device spaces are degenerate (Kalai et al. Thm 3).
  - Proofs of knowledge can't exclude encumbrance (Kelkar et al.).
  - Obligate greenbeards need b/c > 1/p (Gardner & West).
  - Rival criteria don't auto-compose (NASA, M38).
- **Hardness:**
  - Hall-Andersen & Schwartzbach: litG reports NP-complete for one contract and Σₖᴾ-hard for k; F25 reports PSPACE-hard SPE. The reports differ.
  - Deciding Stackelberg resilience is hard in general (Landis & Schwartzbach).
  - Lin et al. call verification of arbitrary policies undecidable.
- **UNVERIFIED:** Douceur (Sybil), Mayers / Lo–Chau, Barak et al. (VBB).
- [inference] One-shot simultaneity plus binding execution is what dissolves these sequential impossibilities; state it as a headline assumption.

---

## 5. Annotated bibliography

V = VERIFIED, U = UNVERIFIED. Works annotated in §1 get short notes here.

**Commitment / program games / AI agents**
- Ondras 2026: oracle-based Stag-Hunt kernel. V
- Ciliberto et al. 2026: unilateral proof-carrying tool calls. V
- Peters & Szentes 2012: Gödel-coded contracts. V
- Kalai et al. 2010: device-conditioned commitments. V
- Gudmundsson & Hougaard: reaction functions. V
- Hall-Andersen & Schwartzbach 2021: contracts as tree cuts. V
- Landis & Schwartzbach: Stackelberg resilience. V. Their "Stackelberg Attacks on Auctions": V. "Side contract commitment attacks": U
- Bastianello & Ismail 2022: conditional strategy equilibrium. V
- DiGiovanni & Clifton 2023. V
- Sauerberg & Oesterheld 2025: ex post verifiable SPIs. V (venue U)
- Lin et al.: LLM policy-conditioned policies. V
- Sistla & Kleiman-Weiner 2025. U
- Cooper et al. (arXiv:2412.14570): n-player simulation PE. U
- Tennenholtz 2004: body not reopened. U here
- Falk: TEE mediator. V
- bryjnar 2017. V
- "Proof of Collusion": V page, U author
- Christiano 2010: FHE AI boxes. V
- berns 2026: kernel/context split. V
- Clifton 2019: credibility gaps. V
- Chan et al. 2025: agent infrastructure. V
- Sun et al. 2023: commitment devices get gamed. V
- CoopEval; Huang et al.; Wyse et al.; Ramírez et al.; Flashbots FRP-38: LLM/contract dilemmas. V

**PCC and verified contracts**
- Necula 1997. V
- Necula & Lee 1996. V. Their 1998 paper: U
- Appel 2001: FPCC. V. Appel et al. 2003: U
- Dickerson et al. 2018. V
- Bjørner et al.: runtime theorem checks at ~0.5% overhead. V
- Bhargavan et al. 2016: F* contracts. V (abstract)
- Grossman et al. 2018: ECF. V
- Dave et al.: DeepSEA. V
- Krijnen et al.: translation certificates. V
- ConCert. V (abstract)
- EVMYulLean 2026: no code-inspecting opcodes. V
- Proofgold 2022: on-chain checker with a 1.5×10⁸-step cap. V
- Tolmach et al. survey. V
- Holden & Malani 2019. V
- virgilgr Medium: deposit "game warping". V
- KEVM; Hirai; CheckMate; Bräm et al.: U

**Fair exchange / contract signing**
- Pagnia, Vogt & Gärtner survey (46(1) 2003 per litG). V
- Pagnia & Gärtner 1999: U. Even & Yacobi 1980: U
- Torabi Dashti & Mauw 2010. V
- Orzan & Torabi Dashti 2008. V
- Asokan, Shoup & Waidner 1998 (EUROCRYPT and S&P): V. Asokan, Schunter & Waidner 1997: U. Asokan thesis: V
- Micali, invisible TTPs. V
- Boneh et al. 2003: verifiably encrypted signatures. V
- Chen, Kudla & Paterson 2004: concurrent signatures. V
- EGL 1985. V
- BGMR 1990: probabilistic options. V (abstract)
- GJM 1999: abuse-freeness. V
- Chadha et al.: balance. V
- Kähler, Küsters & Wilke 2006: tie-break sensitivity. V
- Kremer & Raskin 2002. U
- Norman & Shmatikov 2002; PRISM contract_egl. V
- Mitchell CS259 slides. V
- Avoine et al. V
- Gordon et al. 2008. V. Cleve 1986: U
- ePrint 2023/585. V
- Brice et al. 2024: rationality replaces the TTP. V
- Chatterjee & Henzinger; Chatterjee & Raman. V
- Buttyán et al.: rational exchange. V
- Groce & Katz 2012. V
- Bentov & Kumaresan 2014: claim-or-refund. V
- Goharshady 2021. V
- Pagnia et al. 2000: trusted mobile-agent environments. V (abstract). Vogt et al. 2001: U
- Hevia & Micciancio 2005; Arapinis et al.: simultaneous broadcast. V
- Hubáček & Yeo: crypto cheap talk with contracts. V
- Oxford "Fair Exchange in the blockchain". V
- Blum; Tedrick; Boneh–Naor; Garay–MacKenzie; Shmatikov–Mitchell; Chadha–Kanovich–Scedrov: U

**Distributed systems / swaps**
- Halpern & Moses 1990. V
- Rubinstein 1989. V
- FLP 1985. V
- Skeen 1981. V
- Gray & Lamport 2004: Paxos Commit. V
- Gray 1978; Hadzilacos; Moses & Tuttle; Dwork & Moses; Monderer & Samet; Lewis 1969; Morris 2002: U
- Herlihy 2018. V
- Imoto et al. V
- Tier Nolan 2013: first hashlock swap. V
- Zakhary et al.: witness contract. V
- Herlihy, Liskov & Shrira 2019. V
- Han, Lin & Yu 2019. V
- Xu et al. 2021. V
- Xue & Herlihy 2021. V
- Thyagarajan et al. 2022. V (news)
- Zamyatin et al. 2021. V (abstract)
- Lightning; AMHL; ZK contingent payments: U
- Banks et al. 2021: attestation review. V
- Coker et al. 2011: U. Douceur 2002: U. BAR 2005: U
- Abraham et al. 2006: (k,t)-robustness. V

**TEE / ZK / obfuscation**
- MAGE. V
- Thompson 1984. V (summary)
- Daian et al. 2018: Dark DAOs. V
- Kelkar et al. 2024: encumbrance. V
- NDAI 2025. V (abstract)
- Proof-of-Guardrail 2026. V
- Shumailov et al. 2025. V
- Gopalakrishna 2026: source-integrity gap. V
- Schlegel & Sun: Conditional Recall. V
- Rowstron 2026: Agentic Witnessing. V
- D-MUTRA; Trusted Compute Units; Proof of Trusted Execution; zk-Agreements: U
- Canetti, Fiat & Gonczarowski. V
- Gennaro, Gentry & Parno 2010. V
- Pinocchio. V
- Cheesecloth: ZK proofs about real code take ~37h. V
- ZKSMT 2024. V
- ZK model checking 2026. V
- Jain & Jin: iO via proofs. V
- Bitansky, Paneth & Rosen 2015. V (litG; F28 couldn't open it)
- Neural Interactive Proofs. V
- Halpern, Pass & Seeman; Halpern & Pass 2011. V
- Chiesa & Tromer PCD; Ong & Vadhan; Barak et al.: U
- Canidio & Danos (dead end). V

**Rational cryptography**
- Halpern & Teague 2004. V
- IML 2005. V
- Lepinski & Micali 2005: untrusted verifiable referee. V
- Dodis, Halevi & Rabin 2000. V
- Hubáček, Nielsen & Rosen 2013. V
- Katz 2008. V
- Garay et al. 2013. V
- ILM "Verifiably secure devices" 2008; Halpern & Pass 2008; Kol & Naor; Gordon & Katz; Lysyanskaya & Triandopoulos; Asharov & Lindell; Ong et al. 2009: U

**Banking / economics**
- CLS Group (Wikipedia). V
- Assurance contract (Wikipedia). V
- Tabarrok 1998; Olson 1965: U
- Kocherlakota 1998. V
- Bech & Garratt 2006: V. 2003: U
- Morris & Shin; Diamond & Dybvig: U
- Szabo, TTPs Are Security Holes. V
- Williamson 1983. U

**Aviation**
- Narkawicz & Muñoz 2011. V
- Muñoz et al. 2010; Dowek et al. 2005: U
- SKYbrary ACAS. V
- FAA TCAS II v7.1. V
- Überlingen page: U
- Tomlin et al. 1998; Jeannin et al. 2015: U

**Quantum**
- Eisert et al. 1999. V
- Mahadev 2018. V
- Aaronson 2009. V
- Fitzsimons & Kashefi. V (abstract)
- Benjamin & Hayden; Broadbent et al.; Vidick & Zhang; Šupić & Bowles; Mayers; Gutoski & Watrous; Ying; Isabelle QHL: U

**Biology / ALife / standards / other**
- Gardner & West 2010. V
- Queller et al. 2003. V
- Reyburn et al. 1997. V
- McKeithan 1995. V
- Riolo et al. 2001 and reply. V. Roberts & Sherratt 2002: U
- Southampton 2004 release. V (collusion detail U). arXiv:1810.03793: U
- Missler et al.; Song et al.; Rilling et al.: weak analogies. V
- RFC 854, 1143, 6410. V
- Puffert 2000. V
- Rees et al. 2009: NEAD chain. V
- SALT I summary. V

---

## 6. Open leads

- **Kremer & Raskin 2002**: game analysis of abuse-freeness, a likely bridge to strategic games. "Worth opening next" (F22).
- **Izmalkov, Lepinski & Micali, TCC 2008, "Verifiably secure devices"**: may be close to our checker (F30).
- **CheckMate**: the "priority follow-up" (F26).
- **Sistla & Kleiman-Weiner 2025**: a possible medium threat to the LLM pilot (F25).
- **A search linking program equilibrium to coordinated attack and common knowledge** was never run (F23).
- **ZK contingent payment thread**: "pay iff a proof checks"; reopen (F24).
- **Primaries not yet opened:** the Pagnia–Gärtner TR, Even–Yacobi, the full text of ePrint 2019/1128, the OpenReview version of Ondras, and D-MUTRA (litG).
- **Further sources:** Chiesa–Tromer PCD, Appel's checker size, Ong & Vadhan, witness encryption (F27, F28); Liquefaction, Ekiden, Town Crier, flexHEG (F29); EF's Lean zkEVM (F26); Muñoz 2010 and the Überlingen BFU report (M38).
- **Unproved technical points:**
  - whether commit-then-reveal suffices (F21);
  - safety under composition (Garay et al.; F30);
  - k-resilience against colluding non-members (F30);
  - a verified K-member EVM contract despite EVMYulLean's gap (F26);
  - Halpern & Pass on costly computation, for putting the 10^5-step check into utilities (F30).
