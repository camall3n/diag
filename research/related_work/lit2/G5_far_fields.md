# G5 synthesis: far fields (biology, signalling, treaties, standards, sociology, crime, law, finance)

Sources: litI, wild3, F42, F43*, F44*, M01*–M06, M09, M13, M18, M19, M26, M29, M30, M33, M36, M42, M45, W05, W06, W10, W11*, W12* (* = quota-failed, mostly from memory). VERIFIED = a report here (or a sibling it names) opened the source. Note: summaries.md mislabels M01 (molecular recognition), M03 (automata theory) and M05 (standards history).

**Bottom line.** These fields contain no machine-checkable, behaviour-entailing conditional commitment (litI, F43). They do supply three things. (a) Conceptual ancestors that state Theorems A and B and then fail on *checkability*: Gauthier, Frank, greenbeards, tags. (b) Institutional K's that condition on cheaply checked membership: Montreal Protocol, Nurse Licensure Compact, WADA Art. 15, DPL. (c) A consistent set of objections that sit *outside* the proof: binding, adoption from rarity, governance, third-party harm, false negatives.

---

## 1. Prior answers to build on (ranked by closeness)

**Medium (low–medium in litI/F43; HIGH relevance in M45). Heitzig et al. (2023), arXiv:2307.14267, https://arxiv.org/pdf/2307.14267v1, and Heitzig (2025), *Games* 16(6):58, https://www.mdpi.com/2073-4336/16/6/58. VERIFIED.**
- *Does:* countries submit conditional commitment functions; the mechanism picks the largest consistent profile (strong Nash = core). Modelled on the NPVIC; a footnote reads it as Tennenholtz program equilibrium.
- *Lacks:* conditions on *actions*, not commitments; no certificates or checker; compliance assumed. *Disagreement:* litI says resolution is central, M45 calls it "decentralized".
- *Reuse:* application domain; our checker could replace the resolver and the compliance assumption.
- *Related, VERIFIED (litI).* A LessWrong comment under cousin_it's "Decision theories… part II" gives a parametric CliqueBot for the CCF (code equal except for the CCF).

**Medium. Oesterheld (2022), arXiv:2211.05057. VERIFIED (via F07).** DUPOC, CIMCIC, PrudentBot and εGFB all cooperate with one another; CliqueBot is incompatible with all of them. F44 reframes this as *behavioural* compatibility (expensive search or simulation, works across designs) versus our *interface* compatibility (cheap checking, one standard only). It weakens the claim that a convention is necessary, but it gives us the trade-off framing.

**Medium as conceptual precedent (must cite). Gauthier (1986), *Morals by Agreement*, VERIFIED via Wikipedia; Danielson (1992), VERIFIED (record).** Constrained maximization means cooperating with the similarly disposed and defecting against straightforward maximizers, which is Theorems A and B as a disposition. It relied on "translucency", which critics doubted. We add a fixed-point definition of "similarly disposed" and certified transparency (litI). Capraro & Halpern, arXiv:1410.3363 (VERIFIED, M26), is the partial-translucency bridge.

**Low–medium. Frank's commitment model.** Frank (1988) is UNVERIFIED. Two experimental papers are VERIFIED: Frank, Gilovich & Regan (1993), *Ethology & Sociobiology* 14(4) (litI), and Frank, Gilovich & Regan (1993), *JEP* 7(2), https://gwern.net/doc/economics/1993-frank.pdf (M29). Cooperators prosper only if their dispositions are hard to fake. The pitch from F42 and M29 is "Frank's model with the noise set to zero". Manson et al. (2013, PLOS ONE, VERIFIED) found that brief small talk does not detect defectors, so human translucency is contested.

**Low–medium, institutional analogues of K.** None of these has proofs or self-reference.
- **Nurse Licensure Compact** (Ariz. Rev. Stat. §32-1660, https://www.azleg.gov/ars/32/01660.htm), VERIFIED (M19): recognition extends to "any state that has adopted this compact", with a shared information system; real costs are versioning (re-enactment everywhere) and a six-month withdrawal lag.
- **Montreal vs Kyoto** (Barrett 2008, *OxREP* 24(2)), VERIFIED: trade restrictions on non-parties worked; Kyoto's threshold did not. Membership is cheap to check, compliance is not; certificates merge the two.
- **WADA Code Art. 15**, VERIFIED (wild3): one signatory's sanction binds all; non-signatory decisions count only if Code-consistent.
- **Defensive Patent License** and ***The Satanita*** (1897), VERIFIED (W10): badge = behaviour (pledging is complying); joining binds every member to every other, enforced after the fact.
- **Washington Accord**, VERIFIED (M19): "substantial equivalence of outputs, not structure" ≈ CliqueBot → K.
- **Treaty-Following AI** (law-ai.org), VERIFIED (half read, M45): state agents obey an AI-Guiding Treaty; no mutual conditionality or proofs; flags our binding problem.

**Low (contrasts and machinery), all VERIFIED:** Balfanz et al. 2003 secret handshakes (authority-granted membership, not behaviour); Glaser, Barak & Goldston 2012 (template vs attribute = CliqueBot vs K); Ferreira & Weinberg 2020 (cryptographic commitments for credible auctions); in-toto 2019 (provenance not policy; "in-toto for behaviour", M02); W3C VC 2.0 (verifiable ≠ true); CLS PvP (atomic "I pay iff you pay" via a trusted hub); Southampton 2004 IPD handshake (fakeable shibboleth).

---

## 2. Objections and limits raised

1. **Binding: proven code may differ from running code.** Most-raised objection: litI, wild3 (rapgapB falsebeard), M06, M13 (Smith & Varese impostors), M19, M30, M36, M42 (IMO fraudulent registries; "three identities"), M45, M03, W06, F43. *Serious.* Answer: state binding as an explicit assumption (the checker reads the code that runs; attestation or a referee runner). M42's restatement: "members whose deployed agents are attested to run the proven code". Lehmann et al. show decoupling can occur *downstream of recognition*, so cooperation must come from the same computation that verifies.
2. **Adoption from rarity.** M30, M36 (Gardner & West), M18 (Henrich bistability: a "nobody adopts" equilibrium), M05 (Katz–Shapiro). *Serious for deployment, not for the theorems.* **Reports disagree:** litI reads Gardner & West as saying *facultative* helping greenbeards are favoured at every frequency (and infers membership is never worse than defecting); M30/M36 read the same review as saying most greenbeards are positively frequency-dependent and need clustering, and M36 adds that a lone member pays checking costs for nothing. Answer (our inference): with negligible checking cost a member weakly dominates; concede that adoption needs clustering or seeding.
3. **Rival standards, versioning, lock-in.** M05, F44, litI, M36 (Jansen & van Baalen), M19, M01, M33. *Serious:* under two-way K, v1 and v2 members treat each other as non-members. Answers: F44's "dual-gauge" K′ agent (*unproved; summaries.md says it repeats unproven audit items 3–4*); certified translators built into K (F44 B3); an explicit versioning path (RFC 9413).
4. **Who governs the standard and checker.** M09 (De Filippi; Shapiro's guardians), M13 (protection rents), M33 (Weiner), M42 (forum shopping vs single point of capture), M18 (Rappaport's unquestioned foundation), M05 (Appel: trusted base as common-mode failure). *Moderate.* We minimise the guardian regress (small Lean-verified kernel) but don't eliminate it; propose governance.
5. **Third-party harm and collusion.** M06 (bidding rings, U; Chung & Shi, V; Banchio & Skrzypacz), M30 (Bronstein), M33. *Serious for framing:* "never exploited" covers members only. Concede and scope.
6. **False negatives.** M30 (Reeve), M03 (Rice: the club is intensional; Critch: cutoffs break "exactly"), M19 (Lisbon "accept unless disproven"), M42. *Moderate.* Report missed cooperation and proof-size cutoffs; Theorem A concerns *certified* members.
7. **Producing proofs is hard** (M03): "no other path overrides the action" is a whole-program property. *Moderate.* Checking is cheap, proving is not; agents must be built to be provable.
8. **Specification.** M42 (Salter: COLREGs needed tacit knowledge; Rule 2 mandates departure when necessary), M09 (semantic mimicry), M36 (Lehman et al.: evolved agents game fixed testers). *Moderate:* guarantees are relative to the formal model.
9. **Signalling vs screening/sanctions.** M30, W11 (Archetti et al.), wild3 (Kiers). *Low–moderate.* wild3 suggests handshake plus sanctions.
10. **Identity, Sybils, principals.** M06 (Yokoo; Katz 1991: principal override voids commitment), M45, M36 (Tierra: no clean agent boundary).
11. **Binary vs graded commitment.** M45 (Rowan 2025; Abbott & Snidal), M30, M33 (Bourdieu: proofs remove the open interval generalized reciprocity needs). *Low:* scope to balanced, contract-like reciprocity.
12. **Parochialism and crowding out.** M09 (Kuwabara; Yamagishi's closed clubs), M26, M29. *Low–moderate;* a diffuse reputation layer may help.
13. **Reliable, simultaneous exchange.** M05 (email game), W05/wild3 (CLS needs a trusted hub and a time window). State that the runner delivers both entries atomically.
14. **Prior art** (M03): frame as generalising Tennenholtz's identity check, near Barasz and Oesterheld.

---

## 3. Reframings and motivations

- **Unfakeable greenbeards** (litI, wild3, W06, M01, M30, M36). A certificate is a tag that *is* a proof about behaviour: pleiotropy by construction (csA, FLO1). The Roberts–Sherratt cheater (donation ~74% → 1.5%) cannot exist under Theorem A; falsebeards survive only via checker unsoundness or a binding gap. "Kin by behaviour, not by sequence" (M01).
- **Crozier-proof.** Kin tags lose information once everyone carries them (Scott, Grafen & West 2022); entailing certificates do not (litI). Counterpoint from M30: at fixation the check only excludes outsiders.
- **Revealing or index signals, not handicaps** (Grafen's own category; Penn & Számadó; F42, litI): honesty without waste; a "conventional index"; "anti-proof-of-work"; "tying hands, not sinking costs" (Fearon).
- **Closing the treaty ratification/compliance gap** (Barrett; F43, litI): "entry into force by proof", the checker as mechanised depositary; property-based vs named-list (CTBT) thresholds; N-player K_k as a minimum-participation clause.
- **Template vs attribute verification** (Glaser et al.): CliqueBot vs K. The attribute's usual weakness vanishes because the attribute *is* the target property.
- **Williston's paradox of bilateral promises.** The law escaped its circularity by a special rule; we use a fixed point (litI).
- **Verified superrationality.** In Hofstadter's experiment 14 of 20 defected; the shared commitment could not be checked.
- **Assurance among strangers** (Yamagishi via M09). The certificate is a portable closed tie. Related framings: confidence rather than trust (De Filippi); institution-based trust (Zucker); cooperation without trust (Cook, Hardin & Levi).
- **Minimal group with forgery-proof badges** (Kiyonari 2002; Yamagishi & Kiyonari 2000). Favouritism needs *mutual* knowledge of membership, which the certificate provides (M26, M29, W12).
- **Expectation, not goal** (Pruitt & Kimmel); conditional cooperation without decay (Fischbacher et al.: ~50% conditional cooperators); fear and greed removed for representative agents (Wildschut et al.).
- **Kula without cheating; reciprocity independent of social distance** (Sahlins, M33).
- **A Nurse Licensure Compact for agents** (M19); proof-carrying treaty compliance against Fearon's commitment problem (M45); a verifiable flow-down clause (CSDDD, M02).
- **Removing the waste of hostages and costly signals** (Campana & Varese; Gambetta; M13).
- **K′ as a gateway technology** (David & Bunn; F44, litI). An open standard with adapters, so the requirement weakens from "one standard" to "every pair shares at least one". This is our inference and unproved.
- **Lessons from PKI** (Gutmann): certify behaviour, not identity; keep S and the checker small and frozen.
- **Application hooks.** Humans exploit benevolent AI (Karpus et al. 2021: 36% vs 49% PD cooperation); a provably conditional agent is the alternative. Also hxaro-style insurance among agents and generalized exchange (M33).

---

## 4. Necessity and impossibility results relevant to us

- **Grafen (1990), VERIFIED.** At an honest ESS a *strategic* signal must be costly, and more costly for worse signallers. "Revealing" signals are exempt. We sit in the exempt class (F42).
- **Spence (1973) and Crawford–Sobel (1982), UNVERIFIED.** Under conflict, messages are either costly or coarse. Verifiable messages escape both.
- **Henrich (2009), VERIFIED.** Without credibility-enhancing displays the only stable equilibrium has no costly belief. With them the population is bistable. We remove the premise (inner states are hidden), but bistability carries over as an adoption warning.
- **Chwe (2001), VERIFIED via overview; Rubinstein (1989), UNVERIFIED.** Coordination needs common knowledge. The identity of the standard must be common knowledge, and the exchange reliable.
- **Gardner & West (2010), VERIFIED.** Falsebeards are favoured whenever marker and behaviour can come apart. **Roberts & Sherratt (2002), VERIFIED.** Arbitrary tags fail once tag-carriers may defect. **Crozier's paradox** (Scott et al. 2022 VERIFIED; Rousset & Roze 2007 UNVERIFIED).
- **Campana & Varese (2013), VERIFIED.** Outlaw cooperation requires credible hostage-like commitment. **Smith & Varese (2001), VERIFIED.** Unverifiable reputations attract impostors and produce violent cycles. **Skarbek (2014), UNVERIFIED.** Reputation fails as scale and anonymity grow.
- **Yamagishi/Kiyonari, partly VERIFIED.** In-group cooperation requires mutual knowledge of membership.
- **Rice (1953), UNVERIFIED.** Membership is undecidable, so the club must be defined by certificates. **Critch (2016)**: bounded cutoffs create false negatives. **Appel (2001), UNVERIFIED**: the guarantee is only as strong as the shared trusted base.
- **Farrell & Saloner (1985), VERIFIED.** Excess inertia. **Katz & Shapiro (1985), UNVERIFIED.** Multiple adoption equilibria. **F44 B1 (team inference, unproved).** Two-way K and J cannot share members unless their certified sets coincide.
- **Akbarpour & Li (2020), VERIFIED.** Static, strategy-proof and credible: pick two. **Chung & Shi (2023), VERIFIED.** Side-contract-proofness is impossible alongside user and miner incentive compatibility. **Yokoo et al. (2004), UNVERIFIED.** No efficient false-name-proof mechanism exists.
- **Katz (1991), UNVERIFIED.** Unobservable delegation contracts have no commitment value. This motivates observable code.
- **Avenhaus et al. (2002), VERIFIED.** Probabilistic action-checking needs detection above a payoff threshold. Exact policy-checking removes this, given binding.
- **Barrett (2003), UNVERIFIED.** Threshold clauses work only if non-performance below the threshold is credible. Theorem B supplies that.
- **Hobbes, first-performer problem; Williamson (1983), hostages (both UNVERIFIED).** Ex ante security needs a bond or simultaneity. W11 notes that pure ex ante verification is rare.
- **Reeve (1989), UNVERIFIED.** Every acceptance threshold trades acceptance errors against rejection errors.

---

## 5. Annotated bibliography (deduplicated; V = VERIFIED, U = UNVERIFIED)

*Already known (not re-annotated):* Tennenholtz 2004 (U here); Barasz et al. 2014 (V abstract); Critch 2016 (V); Oesterheld 2019 (U here); Wikipedia "Program equilibrium" (V).

**Biology and signalling**
- Gardner & West 2010, *Evolution*, "Greenbeards". Taxonomy; falsebeards. V
- Queller et al. 2003, *Science*, csA. Tag = behaviour. V
- Lehmann et al. 2024, *iScience*. A falsebeard created downstream of recognition. V
- Gruenheit et al. 2017, *Nat Commun*. Polychromatic tgr loci; many standards coexist. V
- Jansen & van Baalen 2006, *Nature*. A single beard is unstable; many colours cycle. V
- Riolo, Cohen & Axelrod 2001, *Nature*. Tag cooperation. V
- Roberts & Sherratt 2002, *Nature*. Collapse once tag-carriers may defect. V
- Traulsen & Schuster 2003, arXiv. Tag cycles need drift. V
- Scott, Grafen & West 2022, *Nat Commun*. Crozier's paradox. V
- Smukalla et al. 2008, *Cell*. FLO1; partial exclusion of cheaters. V
- Keller & Ross 1998, *Nature*. Gp-9 fire-ant greenbeard with a transferable odour. V
- Kiers et al. 2003, *Nature*. Legume host sanctions. V
- Archetti, Scheuring et al. 2011, *Ecol Lett*. Screening vs signalling. V
- Archetti, Úbeda et al. 2011, *Am Nat*. Partner choice. U
- Bronstein, Wilson & Morris 2003, *Am Nat*. Exploiters from outside the pair. V
- Reeve 1989, *Am Nat*. Acceptance thresholds. U
- Rousset & Roze 2007, *Evolution*. Kin recognition and Crozier's paradox. U
- Hirose et al. 2011, *Science*, and Benabentos et al. 2009. tgr token matching. U
- Hopfield 1974; McKeithan 1995. Kinetic proofreading: accuracy costs energy. U
- Savir & Tlusty 2007. Conformational proofreading. U
- Carter et al., bioRxiv 534321. Vampire bats "raise the stakes". V
- Roberts & Sherratt 1998. The raising-the-stakes model. U
- Grafen 1990, *JTB*. Necessity of cost; the revealing category. V
- Penn & Számadó 2020, *Biol Rev*. Constraint, not cost. V
- Maynard Smith & Harper 1995/2003. Index signals. U
- Zahavi 1975. Handicap principle. U
- Lachmann, Számadó & Bergstrom 2001, *PNAS*. U
- Biernaskie, Grafen & Perry 2014. U
- Számadó 2011; Holman 2012. Bibliographic details checked only. U
- Ray 1991, Tierra. Parasites; no clean agent boundary. U
- Lehman et al. 2020. Digital evolution games its testers. U

**Economics, mechanism design, standards**
- Spence 1973; Crawford & Sobel 1982. U
- Fearon 1997 (tying hands); Fearon 1995 (commitment problem). U
- Dwork & Naor 1992. Proof-of-work. U
- Akbarpour & Li 2020, *Econometrica*. Credibility trilemma. V
- Ferreira & Weinberg 2020, EC. V
- McAfee & McMillan 1992. Bidding rings. U
- Chung & Shi 2023, SODA. V
- Yokoo et al. 2004. False-name bids. U
- Katz 1991, *RAND*. Unobservable contracts. U
- Banchio & Skrzypacz 2022. Algorithmic collusion. U
- Farrell & Saloner 1985. Excess inertia. V
- Farrell & Saloner 1992. Converters. U
- David & Bunn 1988. Gateways (citation V; content U).
- Katz & Shapiro 1985/1994. U
- David 1985 (QWERTY); Liebowitz & Margolis 1990. U
- Puffert 2000. Rail gauge convergence. V
- Sadeghi & Stüble c.2004. Property-based attestation. V (F19)
- RFC 6410. V (wild2)
- RFC 9413. U
- Rubinstein 1989. Email game. U
- Gutmann, "PKI: It's Not Dead". V (venue U)
- Williamson 1983. Hostages. U
- Tabarrok 1998. Dominant assurance contracts. U
- Heckelman 1995; Templeton (votepair). U
- Haugen 2004, *J Sports Econ*. Doping as a PD. V
- Cachon 2003; Saberi et al. 2019; Tachizawa & Wong 2014; Arunachalam & Sadeh 2005. U
- in-toto, USENIX Sec 2019. V
- SLSA/Sigstore. U

**IR, treaties, law**
- Heitzig et al. 2023; Heitzig 2025. V
- LessWrong CCF comment. V
- Heitzig, Lessmann & Zou 2011, *PNAS*. U
- Barrett 2008. V
- Barrett 2003. U
- Carraro, Marchiori & Oreffice 2009. V
- Black, Levi & de Meza 1993. U
- Avenhaus, von Stengel & Zamir 2002. V
- Glaser, Barak & Goldston 2012. V
- Dafoe et al. 2020 §4.3, NPVIC. V via progress_H; arXiv ID U.
- Petrie et al. 2025, flexHEG. V (F34)
- Baker 2023. U
- VCLT Arts. 21 and 24; CTBT Art. XIV; Kyoto Art. 25. U
- Rowan 2025, *IO*. V (abstract)
- Abbott & Snidal 2000. U
- Wasil et al. 2024. U
- "Treaty-Following AI". V (partly read)
- Williston, *Law of Contracts* §103. V
- *The Satanita* 1897. V
- DPL (Ars/Berkeley 2012). V
- Bernstein 1992; Richman. U
- WADA Art. 15 (NZ rules 2027). V
- SCMP on Sochi. V
- McLaren report. U
- Robinson et al. 2007, ABP. V
- VoxEU on CLS. V
- Elliott 2013, BoE. V
- Chicago Fed Letter 223. V
- BIS 2008. U
- Nurse Licensure Compact. V
- Washington Accord. V
- W3C VC 2.0. V
- Open Badges 3.0; Lisbon Convention; EQAR. U
- IMO LEG 111/6 (2024). V
- Choudhury 2026, *Opinio Juris*. V
- Salter 2018, *TransNav*. V
- COLREGs Rule 2; Ringbom 2019; Baumler et al. 2020; Porathe 2019. U
- Hilton v. Guyot; Zschernig v. Miller. U

**Sociology, psychology, anthropology, philosophy**
- Yamagishi & Yamagishi 1994. V (record only)
- Kuwabara 2015, *AJS*. V
- De Filippi et al. 2020. Blog V; article U.
- Zucker 1986; Shapiro 1987; Cook, Hardin & Levi 2005; Bacharach & Gambetta 2001. U
- Campana & Varese 2013. V
- Smith & Varese 2001. V
- Gambetta 2009. V
- Gambetta 1993; Leeson 2007; Skarbek 2014. U
- Chwe 2001. V via Wikipedia
- Henrich 2009. V
- Rappaport 1999; Irons 2001 (title V in Nesse TOC); Iannaccone 1992. U
- Sosis & Bressler 2003. Record V; findings U.
- Bulbulia 2008. Record V; content unknown.
- Nesse (ed.) 2001. TOC V
- Frank 1988. U
- Frank, Gilovich & Regan 1993 (*Ethol Sociobiol*; *JEP*). V
- Manson et al. 2013. V
- Pruitt & Kimmel 1977; Kerr & Kaufman-Gilliland 1994. U
- Balliet 2010. Record V (M26); U (M29).
- Wildschut et al. 2003; Yamagishi & Kiyonari 2000; Yamagishi, Jin & Kiyonari 1999. U
- Kiyonari 2002. V
- Capraro & Halpern. V
- Karpus et al. 2021. V
- Ishowo-Oloko et al. 2019. U
- Fischbacher, Gächter & Fehr 2001. V
- Gouldner 1960; Cosmides & Tooby 1992; Shafir & Tversky 1992. U
- Malinowski 1922, Mauss 1925, Sahlins 1972. V via Wikipedia
- Bourdieu 1977; Weiner 1992; Wiessner 1982; Lévi-Strauss 1969; Parry 1986; Damon 1980. U
- Gräfenhain et al. 2009; Kanngiesser et al. 2017; Warneken & Tomasello 2013; Vaish et al. 2010; Harris & Núñez 1996; Rakoczy et al. 2008; Grueneisen et al. 2015. U
- Gauthier 1986. V
- Danielson 1992. V (record)
- Hofstadter 1985. V
- Yudkowsky & Soares 2017. V
- Hume, *Treatise* 3.2.5; Hobbes, *Leviathan* ch. 14. U

**CS (in this group)**
- Balfanz et al. 2003. V
- Southampton 2004. V
- Oesterheld 2022. V
- Rice 1953; Rabin & Scott 1959; Necula 1997; Appel 2001; Neyman 1985; Rubinstein 1986. U

---

## 6. Open leads (flagged, not checked)

- **Heitzig.** Read the *Games* appendices and the PIK slides for any verification layer, and settle whether resolution is central or decentralized (litI vs M45).
- **VCLT Art. 21 reservation reciprocity.** Possibly a legal "same extent" mirror of Theorem B (F43). Also Barrett 2003 on the credibility of non-performance.
- **Farrell & Saloner 1992 on converters.** Do cheap gateways slow convergence? (F44)
- **Formalise and check in Lean F44's B1 and B2** (two-way exclusivity; a dual-certificate K′ agent keeping A and B). This is currently unproved.
- **Signalling.** Lachmann et al. 2001 and Biernaskie et al. 2014. Also the hard-evidence economics literature (Grossman, Milgrom, Green & Laffont).
- **Legal reciprocity statutes** (*Hilton v. Guyot*, *Zschernig v. Miller*): the cost of checking the other side's policy. Also mutual recognition agreements, Roemer's Kantian equilibrium, Scanlon on promising, and NK-cell "missing-self" recognition (litI).
- **McAfee & McMillan 1992 and Yokoo et al. 2004.** Open them to firm up the collusion and Sybil objections (M06).
- **Bulbulia 2008, "Free love: religious solidarity on the cheap"** (M18). Content unknown.
- **Re-runs of quota-failed reports.** F43, F44, M01–M05, W11 and W12: verify every UNVERIFIED citation above, especially M04 (Warneken & Tomasello, no DOI) and M01 (Hirose 2011).
- **The GPL as a badge = behaviour case.** No GPL source was opened (W10).
- **Whether Riolo et al. forced identical-tag cooperation.** Use the Nature correspondence, not the abstract (litI).
