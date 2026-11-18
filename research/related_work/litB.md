# Lit search B: Attestation, Trust Negotiation, Proof-Carrying X

Our ideas, for reference: (1) each agent publishes code plus a certificate, and the opponent only checks it; (2) a self-referential membership standard K defined with the diagonal lemma, so members cooperate with members and can't be exploited; (3) two-level trust: a small object system, proved sound in Lean, that never trusts its own checker; (4) resource caps, with everything machine-checked in Lean.
Every item below was found and checked online (title, authors, venue). Where a DOI or page range could not be confirmed, it is left out.

## A. Attestation and trust negotiation

**Sadeghi, A.-R. & Stüble, C. "Property-based Attestation for Computing Platforms: Caring about properties, not mechanisms." NSPW 2004.** https://download.hrz.tu-darmstadt.de/pub/FB20/Dekanat/Publikationen/TRUST/SadStu2004.pdf
The platform attests to a *property* (e.g. isolation, privacy compliance) rather than its exact configuration hash. A trusted third party certifies which configurations have which properties. *Closeness:* this is the same "behavior, not hash" move as idea 1. *Difference:* the property certificate comes from a TTP, not a proof checked locally. It is one-directional, there is no self-referential standard, and there is no game theory.

**Haldar, V., Chandra, D. & Franz, M. "Semantic Remote Attestation: A Virtual Machine Directed Approach to Trusted Computing." USENIX VM '04, pp. 29–41.** https://static.usenix.org/events/vm04/tech/haldar.html
A trusted language VM attests high-level, dynamic program properties to remote parties. Demos include a P2P protocol. *Closeness:* idea 1 (behavioral attestation). *Difference:* trust rests on the VM's runtime inspection and enforcement, not on a checkable proof. It is not a mutual fixed-point standard.

**Sirer, E.G., de Bruijn, W., Reynolds, P., Shieh, A., Walsh, K., Williams, D. & Schneider, F.B. "Logical attestation: an authorization architecture for trustworthy computing." SOSP 2011, pp. 249–264. DOI 10.1145/2043556.2043580.** https://www.sigops.org/s/conferences/sosp/2011/current/2011-Cascais/18-sirer-online.pdf
Nexus OS: attested labels ("P says S") in an authorization logic (NAL). These include an "analytic" basis for trust, i.e. PCC-style analysis of what a program can do. The client builds the proof (derivation is undecidable) and the guard only checks it, which is tractable. *Closeness:* very close to idea 1's "search offline, check at runtime" split, and to behavioral attestation. *Difference:* it is an access-control setting (requester to guard), not symmetric mutual play. There is no diagonal or self-referential standard, and no game theory.

**Chen, G. & Zhang, Y. "MAGE: Mutual Attestation for a Group of Enclaves without Trusted Third Parties." USENIX Security 2022, pp. 4095–4110.** https://www.usenix.org/conference/usenixsecurity22/presentation/chen-guoxing (arXiv 2008.09501)
This paper states the self-reference problem exactly. If enclave A must hard-code B's measurement and vice versa, then embedding either one changes the other. MAGE gets around this without a TTP: each enclave's final segment is shared and holds the intermediate SHA-256 states of all group members, so each enclave can rebuild its peers' measurements. *Closeness:* this is the systems version of the hash-equality "CliqueBot" fixed point. It is mutual and local, with no TTP. *Difference:* trust is in *identity* (an exact hash in a pre-fixed group), not a *behavioral* property. Membership is closed and fixed at build time, there are no proofs, and there is no game theory. It is a good foil for the motivation behind K.

**Apache Teaclave. "Mutual Attestation: Why and How" (project documentation, undated).** https://teaclave.apache.org/docs/mutual-attestation
This page states the same circularity ("impossible to decide which enclave is to be built first"). It breaks the loop by compiling in the public keys of trusted auditors, who sign the enclave measurements. *Difference:* a TTP is used, and trust is identity-based.

**Winsborough, W.H., Seamons, K.E. & Jones, V.E. "Automated trust negotiation." DISCEX 2000. DOI 10.1109/DISCEX.2000.824965.**
This paper founded ATN: strangers exchange credentials step by step, with each disclosure guarded by policies that depend on what the other side has disclosed. *Closeness:* mutual trust that depends on the other side. *Difference:* trust is in attribute credentials signed by authorities, not proofs about code behavior.

**Yu, T., Winslett, M. & Seamons, K.E. "Interoperable strategies in automated trust negotiation." ACM CCS 2001, pp. 146–155. DOI 10.1145/501983.502004.** https://www.comp.nus.edu.sg/~cs6203/guidelines/topic7/interoperable-strategies-automated-trust-negotiation.pdf
This paper defines the Disclosure Tree Strategy (DTS) *family*: all strategies that are no more cautious than DTS. It proves that any two members of the family negotiate as well as if both used the same strategy. *Closeness:* this is the closest analog to idea 2's "members succeed with members", i.e. a standard defined over a strategy class. *Difference:* the family is defined by a partial order, not self-referentially. Membership is *assumed*, never certified or checked at run time. Exploitation is not studied and there is no game theory.

**Li, N., Du, W. & Boneh, D. "Oblivious Signature-Based Envelope." PODC 2003, pp. 182–189.** https://www.cs.purdue.edu/homes/ninghui/abstracts/osbe_podc03.html
**Li, J., Li, N. & Winsborough, W.H. "Automated Trust Negotiation Using Cryptographic Credentials." ACM CCS 2005.** https://www.cs.purdue.edu/homes/ninghui/papers/catn_ccs05.pdf
These papers name *cyclic policy interdependency* explicitly: A reveals a credential only if B does, and B only if A does. Plain ATN fails in that case. They break the cycle with cryptography (OSBE / secure function evaluation), so a credential is usable only by a holder of the matching credential. *Closeness:* this is a mutual-dependency deadlock resolved by a symmetric mechanism, like the cycle that K's diagonal construction resolves. *Difference:* it is about confidentiality of attribute credentials, not cooperation conditioned on behavior. There is no self-reference in the policy itself and no provability logic.

(Searches for attestation × game theory returned only defender-vs-attacker scheduling games, e.g. Roy et al., arXiv 2109.07724. These are unrelated to mutual cooperation.)

## B. Proof-carrying code, authorization, data

**Necula, G.C. "Proof-Carrying Code." POPL 1997, pp. 106–119. DOI 10.1145/263699.263712.**
The code producer attaches a formal safety proof, and the consumer checks it with a small, fast checker against its own safety policy. *Closeness:* this is the core of idea 1 (ship a proof, check it cheaply). *Difference:* it is one-directional (host checks untrusted code), with a fixed, non-self-referential safety policy and no strategic interaction.

**Appel, A.W. "Foundational Proof-Carrying Code." LICS 2001, pp. 247–256.** https://www.cs.princeton.edu/~appel/papers/fpcc.pdf
This removes the trusted verification-condition generator and type system. Safety is defined directly in higher-order logic plus a machine semantics, so the policy's soundness is itself proved in the logical framework. *Closeness:* this is the clearest precedent for idea 3 (shrink the TCB and prove soundness of the object-level rules one level up). *Difference:* it is one-way and not game-theoretic. FPCC is about memory and type safety, not a reflexive standard. It does not stress "the object system never trusts its own checker", the Löbian concern specific to self-referential agents.

**Wu, D., Appel, A.W. & Stump, A. "Foundational Proof Checkers with Small Witnesses." PPDP 2003, pp. 264–274. DOI 10.1145/888251.888276.**
This is a proof checker with small witnesses whose proof rules come with machine-checkable soundness proofs. *Closeness:* idea 3 (a small checked system plus a soundness proof). *Difference:* the same as FPCC; there is no mutual or self-referential use.

**Appel, A.W. & Felten, E.W. "Proof-Carrying Authentication." ACM CCS 1999, pp. 52–62. DOI 10.1145/319709.319718.**
**Bauer, L., Schneider, M.A. & Felten, E.W. "A General and Flexible Access-Control System for the Web." USENIX Security 2002.** https://www.usenix.org/legacy/event/sec02/bauer.html
The authorization logic is higher-order and undecidable, so the client must build and submit a proof, and the server only checks it. This became "proof-carrying authorization" (PCA). *Closeness:* the same reason for "the prover ships, the checker checks" as idea 1 (proving is undecidable or expensive, checking is cheap). *Difference:* it is client-to-server and the proofs are about *authority/credentials*, not the prover's own code behavior. It is not mutual and has no fixed-point standard. (Bauer, Garriss & Reiter, "Distributed proving in access-control systems," IEEE S&P 2005, pp. 81–95, distributes proof *construction*, which is still not mutual behavioral trust.)

**Sekar, R. et al. "Model-Carrying Code." SOSP 2003.** https://www.cs.rochester.edu/meetings/sosp2003/papers/p214-sekar.pdf
Code ships with a behavioral model that the consumer checks against its policy. Conformance is enforced at run time, not proved, and the relation is one-way.

**Chiesa, A. & Tromer, E. "Proof-Carrying Data and Hearsay Arguments from Signature Cards." ICS 2010.** https://projects.csail.mit.edu/pcd
Every message in a distributed computation carries a succinct proof that it and its whole history satisfy a compliance predicate. Proofs build on earlier proofs recursively. *Closeness:* local checking of attached proofs between mutually distrusting parties, plus recursion (proofs about proof-carrying inputs). *Difference:* it is a cryptographic argument system about data provenance, with a fixed external compliance predicate. There is no self-referential standard and no strategic analysis.

**Bai, W., Tadjouddine, E.M., Payne, T.R. & Guan, S.U. "A Proof-Carrying Code Approach to Certificate Auction Mechanisms." FACS 2013, LNCS 8348, pp. 23–40.** https://cgi.csc.liv.ac.uk/~trp/Publications_files/FACS2013Revise.pdf
An auctioneer publishes a Coq specification and proofs of strategy-proofness, and bidder agents check them with a standalone checker before joining. *Closeness:* this is the only PCC × game-theory item found: certified *game-theoretic* properties, checked locally by agents. *Difference:* it is one-way (mechanism to bidders), concerns a mechanism rather than a peer's strategy, and is not self-referential.

**Recent, adjacent (2026):**
- Ondras, J., "Lean-Verified Handshake: A Mechanized Commitment Kernel Against Coordination Failure Among Opaque AI Agents," ICML 2026 workshop poster (https://icml.cc/virtual/2026/77909). An attestation wrapper, mechanized in Lean, for Stag-Hunt games that rests on an oracle-trust assumption. It has no code-plus-certificate checking and no self-referential standard.
- Duclaux, C. et al., "Proving Your Way to Cooperation: Formalizing Proof-Based Open Source Game Theory in Lean," ICML 2026 AI4Math workshop (https://icml.cc/virtual/2026/82498). It formalizes *proof-search* OSGT agents in Lean, and its abstract does not mention certificates. This is outside this area but directly adjacent: **flag it for the OSGT search.**
- Avni, Dolev, Yagudaev & Yung, "Proof-Carrying Output," IACR ePrint 2026/994. One-way proofs attached to AI outputs.

## Closest matches (ranked)

1. **Chen & Zhang, MAGE (2022)** and the **Teaclave docs**. They state precisely the mutual-trust self-reference cycle that idea 2 addresses. MAGE solves it locally with a hash fixed point (identity, closed group), while Teaclave uses a TTP. Neither uses behavioral properties or proofs.
2. **Sirer et al., Logical Attestation / Nexus (2011)**. Behavioral (analytic) attestation with "client proves, guard checks" in a logic. It is one-way authorization with no reflexive standard.
3. **Necula PCC (1997) + Appel FPCC (2001) / Wu–Appel–Stump (2003)**. These are the direct precedents for ideas 1 and 3 (ship a proof, check it cheaply, prove the soundness of the small system one level up). They are one-way and non-strategic.
4. **Yu–Winslett–Seamons, interoperable ATN strategy families (2001)**. A "members interoperate with members" standard over strategies. Membership is assumed, not certified, and it is not self-referential or game-theoretic.
5. **Appel–Felten PCA (1999) / Bauer et al. (2002)**, and the **Li et al. cyclic-ATN line (2003/2005)**. The first has the proof-submission rationale. The second gives explicit treatment of cyclic mutual policies, resolved cryptographically.

## Verdict for this area

The building blocks are well established, and our work should cite them. Shipping proofs that are cheap to check (PCC/PCA/Nexus), attesting behavior instead of hashes (PBA, SRA, logical attestation), shrinking the trusted base with soundness proved in a meta-logic (FPCC), and recognizing that mutual attestation is circular (MAGE, Teaclave, cyclic ATN) all have direct precedents. I found **no** work in systems security or PL that combines them as we do: a *symmetric* setting where each party publishes a proof about its *own code's behavior*, membership is defined *self-referentially* (diagonal lemma) as "cooperate exactly with those whose certificate proves membership", and the result is game-theoretic: mutual cooperation plus unexploitability in the PD. The existing answers to the circularity are identity-level fixed points (MAGE), TTPs (Teaclave, PBA), or cryptographic hiding (OSBE), never behavioral self-reference. The one PCC × game-theory paper (Bai et al.) is one-way. Our novelty claim in this area is safe. Position the work as "PCC/FPCC meets program equilibrium; a behavioral, proof-based answer to MAGE's mutual-attestation cycle."
