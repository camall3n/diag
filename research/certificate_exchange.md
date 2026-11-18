# Certificate-based proof exchange with timeouts: a check

Conventions: $S$ is the proof system (think PA). ${}^\circ k$ is the numeral for $k$; $\ulcorner\varphi\urcorner$ is the Gödel-number term for $\varphi$. $\mathrm{Check}(\pi, \ulcorner\varphi\urcorner)$ means "$\pi$ is a valid proof of $\varphi$", and $t{:}F$ abbreviates it. $\mathcal E$ is the overhead for turning a computation into a proof of its result. $\vdash X$ is our outside claim that $S$ proves $X$.

**Verdict up front:** the idea works on paper, after one repair. The repair is that the certificate must sit *outside* the code it talks about, rather than inside it. With that change there's no regress, no self-certification, no fallback search, and no Löb, and timeouts are fine. The guarantee needs only that $S$ is consistent. It relies on two uniform lemmas taken on trust (§2.3), and the "robustness" it gives is membership in a provably defined club (§6).

---

## 1. Setup

### 1.1 Agents

**What we're fixing.** An agent $z$ consists of a generator $\mathrm{gen}_z$ and a move rule $\mathrm{mover}_z$, together called its *code*, written $z$. It also has a *certificate* $\kappa_z$, which is published alongside the code but is **not part of it**.

*Why separate them (the first dead end).* If $\kappa_z$ were inside $z$'s code, its statement would have to name that code. Naming it by numeral takes about $4.6 \times |z|$ characters, which is more than $|\kappa_z|$, since $z$ contains $\kappa_z$. A proof can't end with a line longer than the whole proof. Keeping $\kappa_z$ outside the code it describes removes the problem.

### 1.2 The game

**What happens.** There are fixed protocol constants: time limits $T$ and $T_2$, a proof-length cap $M$, and size caps $L$ for code and $K_{\max}$ for certificates.

1. **Exchange.** Each agent's generator receives (its own certificate, the opponent's code, the opponent's certificate) and runs for at most $T$ steps:
$$h_z \;:=\; \mathrm{Out}_T\big(\mathrm{gen}_z,\ (\kappa_z,\ y,\ \kappa_y)\big) \qquad (\bot \text{ if it hasn't finished})$$
2. **Moves.** Each mover receives the opponent's code and the string the opponent handed over, and runs for at most $T_2$ steps.

### 1.3 The protocol move rule

**The rule.** Cooperate iff the handed string, within the length cap, checks as a proof that the opponent cooperates with me:

$$\mathrm{mover}_z(y, h) = C \quad\text{iff}\quad |h| \le M \;\wedge\; \mathrm{Check}\big(h,\ \ulcorner \mathrm{Coop}({}^\circ y, {}^\circ z) \urcorner\big)$$

### 1.4 What "z cooperates with y" means inside $S$

**Definition.** $\mathrm{Coop}(z, y)$ is the arithmetized statement "in the game between $(z, \kappa_z)$ and $(y, \kappa_y)$, $z$'s mover outputs C," evaluated through the universal interpreter. The certificates are part of the game state, so they appear as arguments. I'll suppress them when unambiguous.

Two facts:

- **No self-reference is needed to define Coop.** It is defined through the interpreter alone, not through any agent.
- **It's a bounded computation.** Every step has a time limit, so Coop is a bounded ($\Delta_0$-style) sentence. A consistent $S$ proves no false sentence of this kind. This matters in §5.

**Unfolding a protocol mover.** For a mover that follows the protocol, $S$ proves, by verifying that mover's (short) code, a fixed proof $\mathrm{Unf}_z$:

$$\vdash \forall y\ \Big(\mathrm{Coop}(z, y) \leftrightarrow \underbrace{\mathrm{Valid}_T(\mathrm{gen}_y,\ (\kappa_y, z, \kappa_z))}_{\text{the opponent hands a valid proof of } \mathrm{Coop}(y,z) \text{ in time}}\Big) \qquad (\mathrm{U}_z)$$

Here

$$\mathrm{Valid}_T(\mathrm{gen}_y, (\kappa, x, \kappa')) \;:\equiv\; \exists\sigma\ \Big(\mathrm{Out}_T(\mathrm{gen}_y, (\kappa, x, \kappa')) = \sigma \;\wedge\; |\sigma| \le M \;\wedge\; \mathrm{Check}\big(\sigma, \ulcorner\mathrm{Coop}({}^\circ y, {}^\circ x)\urcorner\big)\Big)$$

### 1.5 The agreed form K

**What K is for.** It's the shared standard: what a certificate has to prove. It refers to itself, through "the opponent's certificate proves K," so it's defined by the **parametric diagonal lemma** with one parameter $z$. That gives a formula $K(z)$ with

$$\vdash \forall z\ \Big(K(z) \leftrightarrow \forall \kappa\,\forall y\,\forall \kappa'\ \big[\mathrm{Cert}(\kappa, z) \wedge \mathrm{Cert}(\kappa', y) \to \mathrm{Valid}_T(\mathrm{gen}_z, (\kappa, y, \kappa'))\big]\Big) \qquad (\mathrm{D})$$

where

$$\mathrm{Cert}(\kappa, z) \;:\equiv\; |z| \le L \;\wedge\; |\kappa| \le K_{\max} \;\wedge\; \mathrm{Check}\big(\kappa, \ulcorner K({}^\circ z)\urcorner\big)$$

In words, $K(z)$: "For any valid certificate $\kappa$ for my code, and any opponent $y$ with a valid certificate $\kappa'$, my generator hands over, within $T$, a proof of at most $M$ characters that I cooperate with $y$."

**The self-reference is handled.** The hypothesis $\mathrm{Cert}(\kappa, z)$ concerns an *arbitrary* certificate $\kappa$ for $z$, not "this very certificate." So $\kappa_z$ never has to mention itself. The idea's "if $\kappa$ itself checks" turns into "for any $\kappa$ that checks," which is cleaner.

**Compatibility.** $z$ is a member iff $\mathrm{Cert}(\kappa_z, z)$. That's decidable, and cheap with the size caps.

---

## 2. The handed proof

### 2.1 The generator

**What the generator does.** On input $(\kappa, y, \kappa')$, first check the sizes and $\mathrm{Cert}(\kappa', y)$. If either fails, output $\bot$ at once. Otherwise assemble $\pi_A$ as follows. No search is involved; it just copies and runs two checks.

### 2.2 $\pi_A$, line block by line block

The target is $\mathrm{Coop}(A, B)$. Each block says what it does and why.

1. **Copy $\kappa_B$ verbatim.** It's a real proof, so its lines are valid lines here too, and its last line is $K({}^\circ B)$.
$$\vdash K({}^\circ B)$$
2. **Unfold B's standard, using one instance of (D), the fixed diagonal proof.**
$$\vdash \forall \kappa\,\forall y\,\forall \kappa'\ \big[\mathrm{Cert}(\kappa, B) \wedge \mathrm{Cert}(\kappa', y) \to \mathrm{Valid}_T(\mathrm{gen}_B, (\kappa, y, \kappa'))\big]$$
3. **Instantiate** $\kappa := \kappa_B$, $y := A$, $\kappa' := \kappa_A$:
$$\vdash \mathrm{Cert}(\kappa_B, B) \wedge \mathrm{Cert}(\kappa_A, A) \to \mathrm{Valid}_T(\mathrm{gen}_B, (\kappa_B, A, \kappa_A))$$
4. **Trace of checking $\kappa_B$.** This is the record of running Check on $\kappa_B$, plus the size checks. It's a valid derivation of the computation's actual result, which is true. Cost about $\mathcal E(|\kappa_B|)$.
$$\vdash \mathrm{Cert}(\kappa_B, B)$$
5. **Trace of checking $\kappa_A$.** The same, for A's own certificate. Cost about $\mathcal E(|\kappa_A|)$.
$$\vdash \mathrm{Cert}(\kappa_A, A)$$
6. **Modus ponens,** blocks 3–5:
$$\vdash \mathrm{Valid}_T(\mathrm{gen}_B, (\kappa_B, A, \kappa_A))$$
7. **Unfold A's own mover,** with the fixed proof $\mathrm{Unf}_A$, which gives $(\mathrm{U}_A)$ at $y = B$. Combined with block 6:
$$\vdash \mathrm{Coop}(A, B)$$

**What's absent.** $\pi_B$ appears nowhere. Block 6 *asserts* that B's generator outputs a valid proof, and it gets that from B's **certificate**, abstractly, without checking $\pi_B$. So there's no regress.

### 2.3 Uniform lemmas this depends on (taken on trust)

- **(Trace lemma)** For all $s$ and $\varphi$, the trace of running Check on $(s, \varphi)$ is a valid proof, of length about $\mathcal E(|s|)$, of "$\mathrm{Check}(s, \varphi) = r$," where $r$ is the actual result. This is uniform bounded inner necessitation: Critch's Property 4, in explicit form.
- **(Prefix lemma)** A valid proof stays valid when other valid lines are placed after it. This is purely syntactic and easy.
- **(Time lemma)** $S$ proves a running-time bound for $\mathrm{gen}_z$ on inputs within the size caps. This is ordinary complexity reasoning about a fixed, simple program.

---

## 3. Is $\kappa_A$ itself provable?

**Goal.** $\vdash K({}^\circ A)$, uniformly in the opponent. By (D), it's enough to prove: for an arbitrary $\kappa$, $y$, $\kappa'$ with $\mathrm{Cert}(\kappa, A)$ and $\mathrm{Cert}(\kappa', y)$, $\mathrm{Valid}_T(\mathrm{gen}_A, (\kappa, y, \kappa'))$.

1. **Assume** $\mathrm{Cert}(\kappa, A)$ and $\mathrm{Cert}(\kappa', y)$, with all three as variables.
2. **The generator halts in time** and outputs the §2.2 template with $\kappa, y, \kappa'$ substituted in. That's the time lemma, plus a direct reading of $\mathrm{gen}_A$'s code.
3. **Block 1 lines are valid,** by $\mathrm{Cert}(\kappa', y)$ and the prefix lemma.
4. **Blocks 4 and 5 are valid and end with "true."** They're valid by the trace lemma. Their results are true by the two assumptions.
5. **Blocks 2, 3, 6 and 7 are valid.** They're fixed syntactic steps: one instance of (D), instantiation, modus ponens, and $\mathrm{Unf}_A$, whose validity is a fixed computation that can be included as a trace.
6. **The last line is literally $\mathrm{Coop}({}^\circ A, {}^\circ y)$.** That's a syntactic computation.
7. **So $\mathrm{Valid}_T(\mathrm{gen}_A, (\kappa, y, \kappa'))$,** and discharging the assumptions gives $K(A)$.

**Looking for hidden circularity.**

- **Does proving $\kappa_A$ need $\kappa_A$'s own validity?** No. Step 4 uses $\mathrm{Cert}(\kappa, A)$ for the *variable* $\kappa$, as an assumption. Nothing anywhere refers to $\kappa_A$ itself.
- **Does a derivation secretly need $\pi_B$ to be valid?** No. $\mathrm{Coop}(A, B)$ is *equivalent* to $\pi_B$ being valid, by $(\mathrm{U}_A)$. But the derivation gets that validity from $\kappa_B$'s universal statement, not by examining $\pi_B$. $\pi_B$'s validity is a *consequence*, not an ingredient.
- **Does K's self-reference cause trouble?** No. It's confined to the *definition* of K, handled by the diagonal lemma. Every *derivation* is well-founded: certificates are built first and refer to no specific opponent; handed proofs use the opponent's certificate; moves use handed proofs.

---

## 4. Mutual cooperation, sizes, and running time

**Cooperation.** Suppose $\mathrm{Cert}(\kappa_A, A)$ and $\mathrm{Cert}(\kappa_B, B)$ hold, which are outside facts that are cheap to check.

1. By §3, $S$ proves the specific bounded sentence "$\pi_A$ is a valid proof of $\mathrm{Coop}(A, B)$, handed over in time." Do this by instantiating $\kappa_A$'s statement and adding the two traces.
2. If $S$ is consistent, that sentence is true. A consistent $S$ proves no false bounded sentence, since it would also prove the sentence's negation.
3. So B's mover receives a valid $\pi_A$ in time and cooperates. Symmetrically, A cooperates.

**Sizes.**

$$|\pi_A| \;\approx\; |\kappa_B| + \mathcal E(|\kappa_B|) + \mathcal E(|\kappa_A|) + |\mathrm{D}| + |\mathrm{Unf}_A| + O\big(\text{numerals of the codes and certificates}\big)$$

Each $|\kappa|$ is the size of a correctness proof for a simple generator and mover, roughly $\mathrm{poly}(|\text{code}|)$, which is unverified. So $|\pi| = \mathrm{poly}$ when $\mathcal E$ is polynomial.

**Running time.** Building $\pi$ costs two checks plus copying, $\mathrm{poly}(K_{\max}, L)$. Checking $\pi$ is linear in $|\pi|$. Pick $T$, $T_2$ and $M$ above these polynomial bounds.

**Offline cost.** Each agent proves its certificate once, before play. This is a program-verification job. An LLM could draft it, since the checker is what's trusted.

---

## 5. Adversarial checks

All of these assume only that $S$ is consistent.

- **Valid certificate, but a slow or garbage generator: impossible.** $K(y)$ instantiated at a real member A is a bounded sentence stating that $\mathrm{gen}_y$ hands A a valid proof in time. If that's false, $S$ proving $K(y)$ would make $S$ inconsistent. *The earlier construction's hang problem goes away.*
- **Valid certificate, but a defecting move rule, the "move-rule gap": impossible.** $K(y)$ requires $\mathrm{gen}_y$ to hand over valid proofs of $\mathrm{Coop}(y, A)$, a bounded sentence about y's *actual* mover. If y really defects, those can't exist in a consistent $S$, so $y$ can't have a valid certificate. *The earlier gap closes, because K is about y's whole code, including its mover.*
- **DefectBot, or any agent without a certificate.** A's generator fails the $\mathrm{Cert}$ check and hands over nothing. A cooperates only if handed a valid proof, so if DefectBot hands nothing or garbage, A plays D. Cost: one bounded check. **No hangs.**
- **Forged or malformed proofs.** Check fails, so the agent plays D. Oversized proofs are rejected by the cap $M$.
- **Unexploitability.** A cooperates only when handed a valid proof of $\mathrm{Coop}(y, A)$, which is bounded. Consistency of $S$ makes it true, so $y$ really cooperates.
- **An honest non-member that proves its own cooperation.** For example, an always-cooperate agent that hands over a valid proof that it always cooperates. A cooperates with it. That's fine, since it isn't exploitation.
- **FairBot-style search agents.** They have no certificate and can't produce one, because their generators can't meet the deadline. Both play D. Bridging them would need a different standard.

---

## 6. Comparison and interpretation

**Compared with the Löb-first construction** (protocol_sketch.md):

| | Löb-first with fallback | Certificate exchange |
|---|---|---|
| Timeouts | break it | fine |
| Search in code | exhaustive fallback, never run in good play | none |
| Hang risk | yes, from a certified agent with a bad recipe | none |
| Move-rule gap | yes | closed |
| Uses Löb | yes | no, only the diagonal lemma |
| Guarantee needs | soundness of $S$ | consistency of $S$ |
| Compatibility | supplier-lemma certificate | standard K |

**Is it just a clique?** It's a club with a *behavioral* membership condition. Membership means "provably hands every member, on time, a proof that I cooperate with them." Any language, implementation, generator strategy or proof style qualifies, as long as it carries a valid K-certificate. That's much looser than CliqueBot's "identical code." But K is an **agreed standard**, and agents with a different standard $K'$ won't cooperate with each other. That's the price compared with FairBot. FairBot needs only a shared proof system, but it can't be run.

**Why FairBot needed Löb and this doesn't.** FairBot's rule is about *existence* of a proof, and no one is obliged to produce one. To show cooperation, you have to show a proof exists starting only from rules phrased with □, and the loop runs through □ itself. Löb is the tool for discharging $\Box p \to p$. Here, each agent is *obliged*, by a certificate proved in advance, to *produce* the proof, and the certificate quantifies over the opponent's **certificate**, not the opponent's **behavior**. That makes every derivation well-founded. The only loop left is in the *definition* of the standard K, and the diagonal lemma handles that. One way to put it: Löb resolves a loop in what is *proved*, and the diagonal lemma resolves a loop in what is *defined*. Explicit, obligated proofs move the loop from the first to the second.

---

## 7. Verdict

**Established, at the rigor of this conversation:**

1. A naive version, with the certificate inside the code it describes, fails for size reasons. Separating code from certificate fixes it (§1.1).
2. With the standard K defined by the parametric diagonal lemma, each agent's handed proof can be assembled with no search, from the opponent's certificate, two check traces, and fixed glue. It never contains the opponent's handed proof (§2).
3. The certificate is provable uniformly, without self-certification. The "if it checks" hypothesis concerns an arbitrary certificate variable (§3).
4. Members cooperate with members, in polynomial time, with hard timeouts, assuming only that $S$ is consistent (§4).
5. The two holes in the earlier construction, hangs and the move-rule gap, are closed (§5).
6. Löb is not used (§6).

**Taken on trust or unverified:**

- The uniform trace lemma (bounded inner necessitation) and the time lemma. These are the same kind of assumption as Critch's Properties.
- That certificate sizes are actually polynomial, and the constants. The protocol parameters $T$, $M$, $K_{\max}$, $L$ have to be set above them.
- That the parametric diagonal lemma's equivalence (D) is short enough to include. It's fixed, so its size is a constant.
- That nothing breaks in formalizing Coop through the interpreter with certificates as game-state arguments.
- Interaction with *other* standards ($K \ne K'$) gives defection. Whether a cross-standard bridge is possible is open.

**Bottom line:** this does what the Löb-first construction couldn't: provable mutual cooperation that's feasible under hard time limits. It trades FairBot's universality for membership in a self-referentially defined, behaviorally checked standard.
