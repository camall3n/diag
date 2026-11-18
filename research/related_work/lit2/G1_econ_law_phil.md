# G1 synthesis: economics, law, philosophy (litE, F01–F10, F45, M15, M22, M23, M25, M35, M37, M40, M41, M43)

**Status.** **V**: a report in this group opened it (**V-abs**: abstract only). **V-rec**: only a record or secondary summary opened. **U**: not opened, or cited from memory. F45 opened nothing, so its citations are U unless another report opened them. Answers and ratings are the reports' own; I add no new claims.

---

## 1. Prior answers to build on (ranked by closeness)

**1. Peters & Szentes (2012), "Definable and contractible contracts," *Econometrica* 80(1):363–411. Medium.** https://www.econometricsociety.org/publications/econometrica/2012/01/01/definable-and-contractible-contracts; the 2008 draft is at https://discovery-pp.ucl.ac.uk/15001/1/15001.pdf. **V** (draft read in full; the published version is paywalled).
- *Does:* contracts are definable functions of the opponents' Gödel codes. An unnamed diagonal construction gives "play C iff your code equals mine." The paper proves a folk theorem and a Bayesian characterization in a universal contract space. It rejects Turing-machine contracts because they may not halt and because they condition on syntax.
- *Doesn't:* certificates, a checker, a cost model, or Theorem B.
- *Disagreements:* F04 says definability lets contracts condition on what a contract *computes*. F01, F02, F08 and F09 say the equilibrium contract tests code identity (CliqueBot). litE and F01 say the semantic version is mentioned but never built. F09 adds that definable predicates are generally undecidable. Threat ratings range from low (F03, abstract only) through low–medium (litE) to medium (the other six).
- *Reuse:* position ours as "semantic contractible contracts," which also answers their halting and syntax objections. Ask which parts of the convention could travel inside the certificate (litE). Reconcile Critch 2016 ("non-computable") with P&S ("recursive") (F02).

**2. Sobel (1972), "The need for coercion," *Nomos XIV*; Mintoff (1993), ANU PhD thesis, Ch. 4–5. Medium (litE) / high, conceptual (F45).** Mintoff at https://openresearch-repository.anu.edu.au/bitstream/1885/10302/4/04Chapter2_Mintoff.pdf is **V**. For Sobel, only the title is **V**; the content is **U** (known only via Mintoff).
- *Does:* defining constrained maximization as "cooperate iff the other is a CM" is viciously circular. A self-referring promise ("I lay down my right iff the other makes *this* promise") is harmless, and two promise-keepers would cooperate.
- *Doesn't:* verification of any kind.
- *Reuse:* conceptual priority, so it must be cited. F45 notes the parallel with Williston's paradox; neither tradition linked it to the diagonal lemma.

**3. Ondras (2026), "Lean-Verified Handshake…," ICML 2026 workshop poster. Medium.** https://icml.cc/virtual/2026/77909, plus the companion poster at https://icml.cc/virtual/2026/82487. **V-abs** (F07, F08).
- *Does:* a Lean 4 attestation wrapper. In Stag-Hunt-ordered games, attesting Cooperate weakly dominates. Truthful attestation is a `TrustedOracle` typeclass.
- *Doesn't:* a conditional diagonal standard, certificates, or the PD.
- *Reuse:* the same convention cost and the same "safe stag hunt" framing. Read the full text.

**4. Monderer & Tennenholtz (2006), "Strong mediated equilibrium," AAAI-06. Medium, conceptual (F03) / none (litE).** https://cdn.aaai.org/AAAI/2006/AAAI06-110.pdf is **V**; the AIJ 2009 version is **U**.
- *Does:* a minimal PD mediator plays C for both iff both sign up. Thm 4: program equilibrium ⇔ 1-strong mediated equilibrium.
- *Doesn't:* drop the trusted mediator.
- *Reuse:* "K is a decentralized minimal mediator; the certificate is the sign-up." Our novelty is removing the trusted party.

**5. Kalai, Kalai, Lehrer & Samet (2010), "A commitment folk theorem," *GEB* 69:127–137. Low (five reports) / medium for the wording of our claim (F05, F09).** https://tau.ac.il/~samet/papers/commitments.pdf is **V**; the 2007 Kellogg working paper is **V** (F10).
- *Does:* devices condition on the opponent's device, not its action, which avoids the duelling-"undercut by $50" inconsistency. One voluntary space gives all IR correlated payoffs. Cooperating only with "flexible lawyers" is weakly dominant.
- *Doesn't:* address verification (newspapers or lawyers do it); devices are abstract. Observability and the "naturalness" of devices are left open.
- *Reuse:* K as a finite, checkable KKLS device. Their "fixed and known" encoding is our convention cost (M23).

**6. Danielson (1992), *Artificial Morality*. Medium (F06) / low (litE).** **V-rec** (PhilPapers, plus Kuhn's SEP entry, which is **V**).
- *Does:* one-shot PD tournaments of mutually executing Prolog programs, 12 years before Tennenholtz. Mutual simulation can loop.
- *Doesn't:* proofs or termination guarantees.
- *Reuse:* the lineage from testing to certificate checking.

**7. Williston §§103–103a (V, litE); concurrent conditions and tender (*Kingston v. Preston*; Restatement (2d) §§234, 238; U). Medium, conceptual (F45).**
- The law stipulated the "both bound" fixed point. Tender (showing conditional readiness before anyone performs) breaks the first-mover deadlock.
- *Reuse:* "a certificate is a machine-checkable tender."

**8. Gudmundsson & Hougaard (2025), arXiv:2506.14413. Medium (F10) / low (F04). V.**
- One-shot reaction-function smart contracts. A trusted coordinator picks the fixed point. They condition on actions and call program equilibrium fragile. Their "safe" reactions parallel Theorem B.

**9. Kilbourn (attributed), SUAVE "higher order commitments," https://hackmd.io/@quintuskilbourn/BkhiBAsU3. Medium, informal (F04). V.**
- A PD with "cooperate if the other commits," plus permissionless proofs that a contract satisfies a predicate. Cite as an informal precedent.

**10. DiGiovanni & Clifton (2023), arXiv:2204.03484; DiGiovanni, Clifton & Macé (2025), arXiv:2403.05103. Low–medium (litE) / low. V.**
- ε-grounded simulation programs. Open problems they list: whether the shown code is what runs, and incompatible implementations. The 2025 paper *assumes* recognition of the counterpart's structure; certificates could supply it (F09).

**Low:**
- Celik & Peters 2016: a syntactic "iff all list the same" rule. V.
- Szentes 2015. V.
- Koons 1994: an ω-sequence self-referential disposition. V.
- Krellner & Han 2023: reputation-backed joint commitments. V.
- Heitzig et al. 2023. V.
- Lin et al. 2025: LLM code-conditioned policies, no proofs. V.
- Proof-carrying smart contracts and TCT: runtime certificate checks for safety properties. V.

---

## 2. Objections and limits raised

1. **Collusion and third-party harm.** *Very serious.* Raised by litE, F01, F02, F03, F05, F10, M35 and M37.
   - Szentes 2015, Prop. 3: contracts that condition on contracts sustain monopoly.
   - Price-matching facilitates collusion (Salop, Edlin, Cabral et al.); Dark DAOs (TEE-verified vote buying); Dal Bó 2007 (conditional offers capture committees cheaply); Riker & Brams (pairwise gains, collective loss).
   - Receipt-freeness and Complete Knowledge proofs exist to make commitments unverifiable.
   - *Answer:* scope the claim to settings without significant externalities, add a dual-use section, and note M37's suggestion of building welfare or anti-collusion constraints into the standard. "Never exploited" says nothing about non-members.
2. **The convention cost is larger than stated, or is the real problem.** *Serious, partly concedable.*
   - Equilibrium selection cannot be derived from rationality (Binmore, M25).
   - Outside the PD, a standard must also fix how the gains are split (M25; DiGiovanni's comment in F09; Stastny et al.).
   - The normative weight sits in the convention (Kolodny & Wallace, M43).
   - Who interprets the code is an institutional question (Grimmelmann, M35).
   - Choosing among three or more standards is manipulable (Gibbard, M37).
   - The standard is a second-order public good with tipping dynamics, and exclusion is weakest when adoption is low (Heckathorn, Booth, Oliver, M22).
   - Trust moves to whoever governs the checker (Levi M22; Milgrom–North–Weingast M15).
   - Boilerplate lock-in (Kahan & Klausner M35; Farrell & Saloner F07).
   - *Answer:* concede, and argue that some convention is unavoidable (§4) and ours is minimal.
3. **Robust bots already interoperate across designs** (Oesterheld 2022, F07). This weakens the cost-of-convention trade-off. *Answer:* test whether K′ cooperates with ε-grounded FairBot, or argue that the convention buys proof-search-free checking.
4. **Binding gap between proven and running code.** *Serious.* Raised by M15 (Robson), M25 (translucency critics), M43 (Gauthier 1994: an agent can route actions around the verified module), M22 (Heckathorn's hypocrisy: defecting via unformalized I/O or side deals), M35 (Werbach & Cornell: code cannot remedy wrong inputs), M41 (most chain breaks have outside causes), and the DiGiovanni–Clifton open problem. *Answer:* state the binding assumption explicitly.
5. **Equivocation on "commitment."** *Medium; terminological.* Raised by M43 (Owens, Scanlon, Gilbert, Michael & Salice).
   - Simultaneous checking *removes* Hume's time-gap problem rather than solving it.
   - No uptake, release or authority.
   - Exchanged conditional promises are not Gilbert's joint commitment.
   - *Answer:* use "verified conditional policy" or position K as "joint commitment without a joint act" (F45).
6. **Dyadic versus n-person, non-excludable goods** (Olson, Janus v. AFSCME, M22; Riker–Brams, M37). *Serious for scope.* *Answer:* restrict to pairwise, excludable gains.
7. **One standard cannot reach general efficiency** (KKLS Thm 3: F01, F02, F08, F09, M15). *Low for the PD*, a limit for generalization.
8. **Legitimacy of members-only rules** (den Hartogh, Murphy & Veatch, M41; Janus). *Medium.* Exclusion needs its own justification.
9. **Non-exploitation without verification is possible** (Rees et al.: chains where each pair receives before giving, M41). This weakens any "verification is necessary" reading.
10. **Coalitional robustness is open** (M23, F08 via Bernheim–Peleg–Whinston). F03 *infers* that mutual K may be a strong program equilibrium; this needs checking.
11. **Minor:** conditional assurances may be undervalued under membership uncertainty (Gauthier 1994, M43); a frozen standard fits poorly where interests form during collective action (Offe & Wiesenthal, M22); "members cooperate" is one equilibrium among many (M23, M37); adoption re-imports Rubinstein-style common-knowledge problems (M40), though Lederman, Binmore and Sillari argue less is needed, and Theorems A and B need only first-order checking (F07, M40).

---

## 3. Reframings and motivations

- **Semantic contractible contracts:** Peters–Szentes made robust and decidable (F01, F02, F08, F09, F10, litE).
- **Unfakeable secret handshake:** Robson's mimics cannot show a certificate (litE, M15). The **non-illusory promise** (Restatement §77, U) is the legal twin (F45).
- **A decentralized or proof-carrying mediator** (litE, F03, M23). K′ is Rozenfeld–Tennenholtz's "basic-information" mediator (F03).
- **Lawyer-free contracting / a verifiable KKLS device space:** the checker replaces KKLS's newspaper or lawyer (F01, F08, F09).
- **The diagonal lemma as the consideration doctrine for machines** (litE, F45). Related: **certificate = tender** (F45); **verifier instead of sovereign**, after Hobbes (F45, U).
- **Certified translucency:** recognition probability p=1, exploitation probability q=0 in Gauthier's model (F06, Esmaeili). Theorem A as a **solution to the coherence problem** (Sobel 1991, Viminitz) (F06). **K vs K′ ≈ RC vs CM**, reopening the "moral monster" debate (F06). Howard's types, Koons's ω-sequence and the diagonal lemma as three ways to tame self-reference (F06).
- **Moving the PD to a coordination game over standards / a safe stag hunt** (F07; Skyrms). Local checking stands in for common knowledge (F07, M40).
- **Assurance contract with the escrow replaced by a checker.** Theorem B is the refund guarantee (F04). F04 also suggests an N-player threshold version "K_k," and Tabarrok bonuses to make adoption dominant.
- **Meet-the-competition clause on commitments, not prices** (F05). K vs K′ as two-way vs one-way matching (Thépot). Conditional MFN in 19th-century US trade as historical precedent (F05).
- **Credible mechanisms:** a principal proves its code follows its posted rules (Akbarpour & Li; Ferreira & Weinberg) (M23).
- **Automated contract formation:** UN Electronic Communications Convention Art. 12 makes contracts formed machine-to-machine valid (M35). Mismatched standards resemble a machine-speed battle of the forms.
- **Defusing commitment races:** conditional protocol commitments (Clifton's comment in Kokotajlo; F08, F09).
- **ZK membership certificates** (Canetti–Fiat–Gonczarowski) (F08). **Attestation versus proof:** Yamashita needs three or more agents to cross-check; certificates work for two (F02).
- **Real-world examples:** price-matching and Shell's German gas stations (F05); PledgeBank (F04); Israel's donor-priority loophole, LifeSharers, simultaneous kidney exchange (M41); union solidarity (M22); Dark DAOs (F10, M37); the Southampton IPD handshake (litE); Hume's farmers (M43, F45). About 50% of people are conditional cooperators (Fischbacher et al., F04).

---

## 4. Necessity / impossibility results relevant to us

- **Condition on devices, not actions:** conditioning on strategies has no consistent outcome for some pairs (KKLS). **Finite complete device spaces** exist only in the rectangle case (KKLS Thm 3).
- **Machine contracts may not halt and are syntax-bound** (Peters–Szentes). Our bounded checker answers both.
- **Costless signals get invaded by mimics** (Robson). The tag must imply the behavior.
- **Any positive cost of invoking a price-matching guarantee kills its effect** in symmetric markets (Hviid & Shaffer). Cheap checking is therefore essential.
- **Noisy observation destroys the value of commitment** (Bagwell 1995). We need exact observability.
- **Cheap talk can replace a mediator only under bounds on the number of players n** (Abraham et al. 2006). It needs a PKI or trusted setup otherwise (ADH TCC 2008). litE lists the TCC paper as U; F03 opened it.
- **Mutual MFC adoption generally has no equilibrium** when commitments do not refer to each other (Neilson & Winter).
- **No unique reciprocal strategy** (Danielson's diagonal argument; content U). **Coherent pairing with every program is impossible** (Kuhn SEP).
- **Constrained maximization can fail to act under transparency** (Sobel 1991). It is rational only with translucency (Gauthier). It needs common knowledge of how well detection works (Heath 1996).
- **Rationality alone does not yield coordination** (Goyal & Janssen).
- **Common knowledge is unattainable over unreliable channels** (Halpern & Moses; Rubinstein).
- **The checker cannot be certified by proof** (Quine/Carroll regress). **A promise presupposes a convention** (Hume) (M40).
- **Cheap talk is not credible when interests diverge** (Farrell & Rabin, U). Only public, checkable content is "safe" (Asher & Lascarides).
- **Unverifiable commitment can be worse than no rule** (Kessler & Roth).
- **Without binding commitment, conditional exchange needs simultaneity** (Roth et al., U). Counterexample: receive-before-give chains (Rees et al., U).
- **Unconditional self-restriction cannot sustain one-shot PD cooperation** (F09's inference).
- **One-shot cooperation among strangers needs commitment or an information institution** (Kreps et al., Kandori, MNW; all U, M15).
- **Robust membership tests must rely on certificates** (M15's inference from Rice's theorem).
- **Multi-player limits:** Monderer–Tennenholtz (empty-core cases; k! | n); Forges (incentive compatibility binds); Yamashita, Peters & Troncoso-Valverde (player counts).
- **Complexity:** Stackelberg resilience and smart-contract SPE are PSPACE-hard (Landis & Schwartzbach; Hall-Andersen & Schwartzbach).
- **Choosing a standard is manipulable** (Gibbard; M37's application, U).
- **Non-excludable goods defeat member-only sanctions** (Olson, U).

---

## 5. Annotated bibliography (deduplicated)

**Commitment games, contracts on contracts.**
- V: Peters & Szentes 2012; Szentes 2015; Kalai et al. 2010 (and the 2007 working paper); Celik & Peters 2016; Attar, Campioni & Piaser 2019 (recommendation equilibria fail under private signals); Renou 2009 and Bade, Haeringer & Renou 2009 (unconditional commitment only); Bastianello & Ismail 2022 (conditioning on actions); Katz 2006, Fershtman, Judd & Kalai 1991, Merzoni 2008 (interdependent observable contracts enlarge the outcome set); Landis & Schwartzbach 2024; Gudmundsson & Hougaard 2025.
- V-abs: Forges 2013 (universal commitment game); Peters 2015 ("Reciprocal contracting"); Peters & Troncoso-Valverde 2013; Yamashita 2010; Hall-Andersen & Schwartzbach 2021.
- V-rec: Epstein & Peters 1999 (universal language of mechanisms).

**Mediators.**
- V: Monderer & Tennenholtz 2006; Rozenfeld & Tennenholtz 2007 (routing mediators); Peleg & Procaccia 2010; Ashlagi, Monderer & Tennenholtz 2009; Abraham, Dolev, Gonen & Halpern 2006; Abraham, Dolev & Halpern 2008 (V in F03, U in litE); Lepinski & Micali TR 2005; Madmon & Tennenholtz (mediated agentic AI; litE dates it Dec 2025, F03's file URL says 2026/05); Ivanov et al. 2023 (learned mediator); Geffner & Tennenholtz 2024; Falk blog (LLM mediator in a TEE).
- V-rec: Izmalkov, Micali & Lepinski 2005 (trust moves into a minimal verifiable primitive).
- U: the Monderer & Tennenholtz AIJ 2009 version.

**Cooperative AI, bargaining, credibility.**
- V: DiGiovanni & Clifton 2023; DiGiovanni, Clifton & Macé 2025; DiGiovanni 2026 (verification as an assumed capability); Oesterheld & Conitzer (SPI); Oesterheld 2022; Sauerberg & Oesterheld 2024; Stastny et al. 2021; Sun et al. 2023; Kilbourn's SUAVE note; Lin et al. 2025; Kokotajlo 2019; the Boomerang protocol; Lee 2025; Oesterheld et al. 2026 (surrogate goals); berns 2026; Heitzig et al. 2023; Schelling 1956; Dutta 2023; Pei 2025; Miettinen & Vanberg 2025; Farrell & Maskin 1989; Bernheim, Peleg & Whinston 1987; Bagwell 1995.
- V-abs: Ondras 2026 (both posters); Conitzer & Oesterheld 2023; Crawford 1982 (the commitment stage is a PD); Ellingsen & Miettinen 2008.
- V-rec: Schelling 1960; Aumann 1990.
- U: Sistla & Kleiman-Weiner 2025; van Damme & Hurkens 1997; Fearon 1995.

**Assurance contracts, public goods.**
- V: Tabarrok 1998; Bagnoli & Lipman 1989; Zubrickas 2014, Cason & Zubrickas 2017 and 2019, Li, Chen & Liu 2023 (refund bonuses; failures come from miscoordination); Boadway, Song & Tremblay 2007; Fischbacher, Gächter & Fehr 2001; PledgeBank (Irving 2012), gabcoh 2020, Gitcoin 2026; Krellner & Han 2023.

**IO and price-matching.**
- V: Salop 1982 working paper (the 1986 chapter is cited by DOI); Edlin 1997; Hviid & Shaffer 1999; Neilson & Winter 1992 and 1993; Cooper 1986; Holt & Scheffman 1985; du Pont v. FTC 1984 (unilateral facilitating practices were hard to reach in antitrust); Brown & MacKay 2023 and 2025; Thépot 2021; Arbatskaya, Hviid & Shaffer 2004; Cabral et al. 2021; Pollak 2017; Pahre 2001.
- V-abs: Salcedo 2016.
- Viner 1924: citation V, content U.

**Smart contracts.**
- V: Daian et al. 2018 (Dark DAOs; authors via CoinDesk); Kelkar et al. 2024 and D'Antona et al. 2026 (anti-encumbrance); Austgen et al. 2023; Dickerson et al. 2018 (proof-carrying smart contracts); Bjørner et al. (TCT); Potham 2026; Holden & Malani 2019; Brzustowski, Georgiadis-Harris & Szentes 2023.
- V-abs: Werbach & Cornell 2017.
- U: Szabo 1997; Grimmelmann 2019; Kahan & Klausner 1997.

**Mechanism design.**
- V: Ferreira & Weinberg 2020; Canetti, Fiat & Gonczarowski.
- U: Akbarpour & Li 2020; Christoffersen, Haupt & Hadfield-Menell 2023.

**Constrained maximization and evolution.**
- V: Gauthier 1994; Kuhn's SEP entry; Mintoff 1993; Koons 1994; Philipps 1994 (default "cooperate if undecided"); Parfit, "Bombs and Coconuts" (deception defeats Gauthier); Esmaeili 2021; Macintosh 1991; Danielson's NERD slides; SEP "Game Theory and Ethics"; Santos, Pacheco & Skyrms 2011; Lewis 1979.
- V-abs or first page: Sobel 1991 and 1993; Viminitz 1996; Danielson 1988; Heath 1996; Robson's secret handshake (year and volume U).
- V-rec: Gauthier 1986; Danielson 1992; Howard 1971 (via SEP).
- U: Sobel 1972 (content); Gauthier's "Moral Artifice" 1988; Danielson 1995b and 2002; Koons 1992; Sayre-McCord and Friend on translucency; Binmore 1994/98; Levine et al. 2025.

**Convention and common knowledge.**
- V: Goyal & Janssen 1996; Halpern & Moses 1990; Binmore 2008; Sillari 2008; Vanderschraaf 1995; Skyrms 2004 and 2010; Shoham & Tennenholtz 1997; Young 1993; Farrell & Saloner 1985; Lederman 2018; Asher & Lascarides 2013.
- V-abs: Haller & Crawford 1990; Cubitt & Sugden 2003; Rubinstein 1989 (V-abs in F07, U in M40).
- V-rec: Lewis 1969; Quine 1936 and Carroll 1895 (via SEP "Convention").
- U: Clark & Marshall 1981; Farrell & Rabin 1996.

**Promising and contract law.**
- V: Habib's SEP "Promises"; Williston §§103–103a; the Ricks page; UN Electronic Communications Convention Art. 12.
- V-abs: Michael & Salice 2014.
- V-rec: Hume, *Treatise* 3.2.5; Scanlon 1990.
- U: Kolodny & Wallace 2003; Owens 2012; Gilbert 1993 (Gilbert 2014 was opened by wild4, outside this group); Hobbes; Rawls; Holmes; Ames; Fried; Shiffrin; *Kingston v. Preston*; Restatement (2d) §§71, 75, 77, 79, 234, 238; *Wood v. Lucy*.

**Collective action, voting, medicine, reputation.**
- V-abs: Heckathorn 1989; Dal Bó 2007; Kessler & Roth 2014; den Hartogh 2011.
- V-rec: Booth 1985; Cowan et al. 2017; Offe & Wiesenthal 1980 (via Wright's lecture notes).
- U: Olson 1965; Oliver 1980; Levi 1997; Janus v. AFSCME; Fantasia 1988; Riker & Brams 1973; Benaloh & Tuinstra 1994; Gibbard 1973; Lavee et al. 2010; Murphy & Veatch 2006; Roth, Sönmez & Ünver 2004; Rees et al. 2009; Kreps et al. 1982; Kandori 1992; Milgrom, North & Weingast 1990.

**Already known, with new links.**
- Critch 2016 (V): it calls P&S contracts non-computable, while P&S say their equilibrium contracts are recursive.
- Critch, Dennis & Russell 2022: cites translucency but never Gauthier or Danielson.
- Tennenholtz 2004: V-rec in M15 and M23. Howard 1988 and Oesterheld 2019: U here.

**Opened, not relevant.** Attar, Campioni, Mariotti & Piaser 2021; Ellingsen & Paltseva 2016; Ganglmair et al. 2025; Attar, Bozzoli & Strausz 2026; Wang 2022; Bagwell & Staiger 2004; Guttman 1987; Robbiano 2025; Jennings 1993; Fukushima & Puphal 2026; Farzulla 2026; Koomullil 2026; Hu et al. 2020; Schwartzbach EC'22; Danielson 1986.

---

## 6. Open leads

- **Ondras 2026 full texts** (OpenReview blocked): confirm there are no conditional or self-referential certificates (F07, F08).
- **Peters–Szentes published version vs. the 2008 draft.** Also the ~29 citers on EconPapers and their post-2015 citers (F02, F04, F09). Check whether "semantic" conditioning is constructed anywhere.
- **Citers of KKLS 2010.** Also Kalai & Satterthwaite 1986, Han's "Robust equilibria in general competing mechanism games," Tajika 2020, and "program equilibrium" plus bargaining (F01, F05, F09).
- **Danielson:** the full book, plus Danielson 1995b and 2002 for the diagonal "no unique reciprocal strategy" result (F06). Also Viminitz 1996 in full, Gauthier's "Moral Artifice," Koons 1992, and Sobel 1972's actual text (litE, F06).
- Monderer–Tennenholtz AIJ 2009; van Damme & Hurkens 1997; Robson's details; Akbarpour & Li.
- **Legal sources to verify:** *Kingston v. Preston*; Restatement §§77, 234, 238; Williston §§104ff on conditional and illusory promises; Ricks's argument. Also Prichard, Searle and Anscombe on promissory self-reference (F45).
- **Gilbert on joint commitment;** Han et al. on commitment in evolutionary game theory; the algorithmic-collusion literature, e.g. Calvano (litE).
- **Price-beating guarantees** (Corts 1995; Hviid & Shaffer 1994) and platform MFN clauses (F05).
- **Unexplored in F10:** ZK-proved strategy properties; cross-DAO conditional proposals; CliqueBot-style contracts using EXTCODEHASH in the wild.
- **To prove or test ourselves:** does K′ cooperate with ε-grounded FairBot (F07)? Is mutual K a strong program equilibrium (F03, M23)? Gauthier's undervaluation worry (M43). The Critch vs. P&S computability statements (F02).
- Verify the U items in M22, M35 and M41 before citing them.
