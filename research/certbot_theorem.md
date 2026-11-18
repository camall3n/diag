# CertBot: feasible, provable cooperation in Critch's open-source Prisoner's Dilemma

**Claim.** There is an explicit agent, CertBot, in the one-shot open-source Prisoner's Dilemma of Critch (arXiv 1602.04184) such that:

1. CertBot cooperates with itself, and with every agent that carries a valid certificate for a shared standard $K$.
2. CertBot is unexploitable: it never cooperates with an agent that defects.
3. Every move is computed in time polynomial in the agents' sizes, with explicit hard time limits. There is no proof search and no unspecified threshold.

The guarantees need only that $S$ is consistent. The proof uses the diagonal lemma, not Löb. Three lemmas are still taken on trust; they are listed in §7.

Conventions: $S$ is a consistent theory extending Robinson's $Q$ that represents computable functions (Critch §2.4), with binary numerals ${}^\circ k$. $\ulcorner\varphi\urcorner$ is the code of $\varphi$. $\mathrm{Check}(\sigma, \ulcorner\varphi\urcorner)$ is "$\sigma$ is a valid $S$-proof of $\varphi$" (also written $\sigma{:}\varphi$). $|x|$ is length in characters. $\vdash X$ is our outside claim that $S$ proves $X$.

---

## 1. Definitions

### 1.1 The game

**What a player submits.** Each player submits an **entry** $(z, \kappa_z)$:

- a **program** $z$, which consists of a generator $\mathrm{gen}_z$ and a mover $\mathrm{mover}_z$, and
- a **certificate** $\kappa_z$, a string published with the program but not part of the program that the certificate talks about.

*Why separate them.* A certificate has to mention its program by numeral. The numeral of $z$ has about $4.6|z|$ characters. If $\kappa_z$ were inside $z$, then $|\kappa_z| \ge 4.6|z| > |\kappa_z|$, which is impossible. In Critch's game a submission is any string, so "program plus attached data" is just a submission format.

**Protocol constants.** These are fixed numbers, part of the standard: a code-size cap $L$, a certificate cap $K_{\max}$, a proof-length cap $M$, a generator time limit $T$, and a mover time limit $T_2$.

**Play.** There is no message passing. Each mover sees both entries and has $T_2$ steps:

$$m_z \;:=\; \mathrm{Out}_{T_2}\big(\mathrm{mover}_z,\ \langle \kappa_z, y, \kappa_y\rangle\big) \in \{C, D\}$$

Anything other than an output of C within $T_2$ steps counts as D. $\mathrm{Out}_t(p, x)$ is the output of program $p$ on input $x$ within $t$ steps, or $\bot$ if it hasn't finished.

### 1.2 Cooperation as a bounded sentence

**What we define.** The arithmetized statement "in the game between entries $(z, \kappa)$ and $(y, \kappa')$, $z$'s mover outputs C":

$$\mathrm{Coop}(z, \kappa, y, \kappa') \;:\equiv\; \mathrm{Out}_{T_2}\big(\mathrm{mover}_z,\ \langle \kappa, y, \kappa'\rangle\big) = C$$

It's written using the arithmetized universal interpreter, with all computation histories bounded by numerals determined by $T_2$ and the input sizes. **It is a bounded sentence once its arguments are numerals.**

**Why that matters.** If $S$ is consistent, every bounded sentence that $S$ proves is true. If one were false, its negation would be a true bounded sentence, and $Q$ proves every true bounded sentence, so $S$ would prove both. Everything below relies only on this.

**Handing over a valid proof.** "$y$'s generator, run on $(\kappa', z, \kappa)$, outputs within $T$ steps a proof of at most $M$ characters that $y$ cooperates with $z$":

$$\mathrm{Valid}(y, \kappa', z, \kappa) \;:\equiv\; \exists \sigma \le {}^\circ 2^{cM}\ \Big[\mathrm{Out}_T\big(\mathrm{gen}_y, \langle \kappa', z, \kappa\rangle\big) = \sigma \;\wedge\; |\sigma| \le M \;\wedge\; \mathrm{Check}\big(\sigma,\ \ulcorner \mathrm{Coop}({}^\circ y, {}^\circ\kappa', {}^\circ z, {}^\circ\kappa)\urcorner\big)\Big]$$

This is also bounded. The target formula is computed by a substitution function, as $\mathrm{Eval}_1$ is in Critch's §4.1.

### 1.3 The standard $K$

**What it should say.** "For any valid certificate $\kappa$ for my program, and any opponent $y$ with a valid certificate $\kappa'$, my generator hands $y$, in time, a valid proof that I cooperate with $y$." That mentions "valid certificate," which means a proof of $K$ itself. So we define $K$ with **Critch's Proposition 1, taking $r = 1$**, with the parameter being the program $z$.

**Step 1: the template.** A formula $G(x, z)$ with two free variables. $x$ is the slot for the code of the formula being defined.

$$G(x, z) \;:\equiv\; \forall \kappa\, \forall y\, \forall \kappa'\ \Big[\, C_x(\kappa, z) \wedge C_x(\kappa', y) \;\to\; \mathrm{Valid}(z, \kappa, y, \kappa')\,\Big]$$

$$C_x(\kappa, w) \;:\equiv\; |w| \le L \;\wedge\; |\kappa| \le K_{\max} \;\wedge\; \mathrm{Check}\big(\kappa,\ \mathrm{Eval}_1(x, w)\big)$$

The quantifiers range over strings within the caps.

**Step 2: apply Proposition 1.** There is a formula $K(z)$ and a fixed proof $\Delta_K$ such that

$$\Delta_K \;:\; \forall z\ \Big(K(z) \leftrightarrow G(\ulcorner K\urcorner, z)\Big) \qquad (\mathrm{D})$$

**Step 3: name the certificate condition.** $\mathrm{Cert}(\kappa, w) :\equiv C_{\ulcorner K\urcorner}(\kappa, w)$, meaning "$\kappa$ is a valid proof of $K({}^\circ w)$, within the caps." It's decidable, and it's an NP-type, existential predicate: "there is a checking run that accepts."

**Membership.** An entry $(z, \kappa_z)$ is a **member** iff $\mathrm{Cert}(\kappa_z, z)$.

**No self-reference in the certificates.** $K$ refers to an *arbitrary* certificate $\kappa$ for $z$, not to any particular one. The only loop is in the *definition* of $K$, and (D) takes care of it.

### 1.4 CertBot

Write $A$ for CertBot's program. It finds its own code with a quine.

```
gen_A(κ, y, κ'):
  if |y| > L or |κ'| > K_max or not Check(κ', Eval1(⌜K⌝, y)):  return ⊥
  if not Check(κ, Eval1(⌜K⌝, A)):                                 return ⊥
  return Asm(κ, y, κ')                  # assembled below; no search

mover_A(κ, y, κ'):
  σ := Out_T(gen_y, ⟨κ', A, κ⟩)        # run the opponent's generator, at most T steps
  if σ = ⊥ or |σ| > M:  return D
  if Check(σ, ⌜Coop(°y, °κ', °A, °κ)⌝): return C
  return D
```

**Why there's no simulation regress.** A mover runs only the *opponent's generator*. Generators run nothing except two certificate checks and copying. Nothing ever runs a mover.

**The unfolding lemma.** By reading $\mathrm{mover}_A$'s code, $S$ proves

$$(\mathrm{U}_A)\qquad \vdash \forall \kappa\,\forall y\,\forall \kappa'\ \Big(\mathrm{Coop}({}^\circ A, \kappa, y, \kappa') \leftrightarrow \mathrm{Valid}(y, \kappa', {}^\circ A, \kappa)\Big)$$

This needs $T_2 \ge T + (\text{time to check a proof of at most } M \text{ characters})$. Let $\mathrm{Unf}_A$ be a proof of $(\mathrm{U}_A)$.

*A size problem, and the fix.* $\mathrm{Unf}_A$ contains ${}^\circ A$, so it can't be stored inside $A$. Instead, $\mathrm{gen}_A$ contains a short program $\mathrm{Wr}$ that writes $\mathrm{Unf}_A$ at play time from a template and the quined code. The certificate (§2.1) verifies once that $\mathrm{Wr}(\ulcorner A\urcorner)$ is a valid proof of $(\mathrm{U}_A)$.

---

## 2. CertBot is a member

### 2.1 What $\mathrm{Asm}(\kappa, y, \kappa')$ outputs

Here is the handed proof, block by block. Each block says what it does. The target is $\mathrm{Coop}({}^\circ A, {}^\circ\kappa, {}^\circ y, {}^\circ\kappa')$.

**P1. Copy $\kappa'$ verbatim.** It's a valid proof, so its lines are valid here too. Its last line is

$$K({}^\circ y)$$

**P2. Use (D), with the fixed proof $\Delta_K$, instantiated at $z := {}^\circ y$.** One more step gives

$$\forall \kappa_1\,\forall y_1\,\forall \kappa_1'\ \big[\mathrm{Cert}(\kappa_1, {}^\circ y) \wedge \mathrm{Cert}(\kappa_1', y_1) \to \mathrm{Valid}({}^\circ y, \kappa_1, y_1, \kappa_1')\big]$$

**P3. Instantiate** $\kappa_1 := {}^\circ\kappa'$, $y_1 := {}^\circ A$, $\kappa_1' := {}^\circ\kappa$:

$$\mathrm{Cert}({}^\circ\kappa', {}^\circ y) \wedge \mathrm{Cert}({}^\circ\kappa, {}^\circ A) \;\to\; \mathrm{Valid}({}^\circ y, {}^\circ\kappa', {}^\circ A, {}^\circ\kappa)$$

**P4. A trace proving $\mathrm{Cert}({}^\circ\kappa', {}^\circ y)$.** This is the accepting checking run as a witness, followed by verification of each step. Length $\tau(K_{\max} + L)$, where $\tau$ is a polynomial (§4).

**P5. A trace proving $\mathrm{Cert}({}^\circ\kappa, {}^\circ A)$.** The same, for CertBot's own certificate.

**P6. Modus ponens** on P3, P4 and P5:

$$\mathrm{Valid}({}^\circ y, {}^\circ\kappa', {}^\circ A, {}^\circ\kappa)$$

**P7. Write out $\mathrm{Unf}_A$ using $\mathrm{Wr}$, instantiate it, and apply modus ponens with P6:**

$$\mathrm{Coop}({}^\circ A, {}^\circ\kappa, {}^\circ y, {}^\circ\kappa')$$

**What isn't there.** The opponent's handed proof appears nowhere. P6 gets "the opponent's generator hands A a valid proof" from the opponent's **certificate**, without ever looking at that proof.

### 2.2 The certificate $\kappa_A$: a proof of $K({}^\circ A)$

**Goal.** By (D), it's enough to prove $G(\ulcorner K\urcorner, {}^\circ A)$. Inside $S$, with $\kappa$, $y$ and $\kappa'$ as variables:

1. **Assume** $\mathrm{Cert}(\kappa, {}^\circ A)$ and $\mathrm{Cert}(\kappa', y)$.
2. **The generator returns Asm.** Both checks in $\mathrm{gen}_A$ pass, by step 1, so $\mathrm{Out}_T(\mathrm{gen}_A, \langle\kappa, y, \kappa'\rangle) = \mathrm{Asm}(\kappa, y, \kappa')$. This is the **time lemma** (§7).
3. **Size.** $|\mathrm{Asm}(\kappa, y, \kappa')| \le M$, by the size bound in §4. This is an arithmetic fact about polynomials, proved uniformly.
4. **Block P1 is valid**, by $\mathrm{Cert}(\kappa', y)$ and the fact that a valid proof stays valid when more valid lines are added after it.
5. **Block P2 is valid.** $\Delta_K$ is a fixed valid proof; $\kappa_A$ includes the fixed-size trace showing it checks. The instantiation line is a syntactic step.
6. **Blocks P4 and P5 are valid and prove the right sentences.** This is the **uniform trace lemma** (§7), applied under the assumptions from step 1.
7. **Block P7 is valid.** $\kappa_A$ includes a fixed-size trace showing that $\mathrm{Wr}(\ulcorner A\urcorner)$ checks as a proof of $(\mathrm{U}_A)$.
8. **P3, P6 and the end of P7 are instantiation and modus ponens steps,** and the last line equals the target formula. Both are syntactic facts.
9. **So** $\mathrm{Valid}({}^\circ A, \kappa, y, \kappa')$. Discharging the assumptions and generalizing gives $G(\ulcorner K\urcorner, {}^\circ A)$, and (D) gives $K({}^\circ A)$.

**Checks for hidden problems.**

- **Does $\kappa_A$ use its own validity?** No. Step 6 uses $\mathrm{Cert}(\kappa, {}^\circ A)$ for the *variable* $\kappa$, as an assumption. Nothing refers to $\kappa_A$ itself.
- **Variable capture.** The bound variables of $G$ are renamed apart, and everything substituted is a closed numeral. Nothing can be captured.
- **Is any derivation circular?** No. Certificates come first and mention no specific opponent. Assembled proofs copy certificates. Movers check assembled proofs. The only loop is in the *definition* of $K$, handled by (D).
- **Size dependencies between the caps.** $\kappa_A$ mentions the caps only through their numerals, which cost $O(\log(L K_{\max} M T T_2))$ characters. So $|\kappa_A| \le V(L) + c\log(\text{caps})$, where $V$ is a polynomial. With polynomial caps this is $V(L) + O(\log L)$, so $K_{\max}$ can be chosen consistently (§4).

---

## 3. Theorems

**Theorem 1: members cooperate with members.** Let $S$ be consistent. If $(A, \kappa_A)$ and $(B, \kappa_B)$ are members, then both play C.

*Proof.*
1. $\kappa_A$ is a valid proof of $K({}^\circ A)$, so $S$ proves $K({}^\circ A)$.
2. By (D), $S$ proves $G(\ulcorner K\urcorner, {}^\circ A)$.
3. Instantiate it at $(\kappa_A, B, \kappa_B)$. The two Cert facts are true bounded sentences, so $S$ proves them. So $S$ proves $\mathrm{Valid}({}^\circ A, {}^\circ\kappa_A, {}^\circ B, {}^\circ\kappa_B)$.
4. That's a bounded sentence, and $S$ is consistent, so it's true: $\mathrm{gen}_A$'s actual output $\sigma$ is a valid proof of $\mathrm{Coop}(A, \kappa_A, B, \kappa_B)$.
5. That's another bounded sentence that $S$ proves, so it's true: $A$ plays C.
6. Swap the roles to get B plays C. ∎

*Note.* This uses only membership. It holds **whatever the members' movers look like**.

**Theorem 2: CertBot is a member.** For caps chosen as in §4, $\mathrm{Cert}(\kappa_A, A)$ holds for the $\kappa_A$ of §2.2. This depends on the trusted lemmas of §7.

**Corollary: CertBot against CertBot is (C, C).** This also holds for CertBot against any other member: different languages, generators or proof styles.

**Theorem 3: CertBot is unexploitable.** Let $S$ be consistent. For any entry $(y, \kappa_y)$, if CertBot plays C, then $y$ plays C.

*Proof.* CertBot plays C only if $\sigma = \mathrm{Out}_T(\mathrm{gen}_y, \ldots)$ checks as a proof of $\mathrm{Coop}(y, \kappa_y, A, \kappa_A)$. Then $S$ proves that bounded sentence, so it's true. ∎

*Membership alone doesn't give this.* An always-cooperating agent with a valid certificate is a member, and it's exploitable. CertBot is unexploitable because of its mover.

**Outcomes against non-members.**

| Opponent | CertBot | Opponent | CertBot's cost |
|---|---|---|---|
| DefectBot (no valid generator) | D | D | runs the opponent's generator for at most $T$ steps, then rejects |
| Critch's FairBot$_k$ (no generator) | D | D | the same. FairBot$_k$ can't find a proof that CertBot cooperates, because that's false. |
| An honest non-member whose generator outputs a valid proof that it cooperates | C | C | one check |
| A forged or oversized proof | D | either | one check |

---

## 4. Explicit bounds

Write $n := L$ for the code cap.

| Quantity | Bound | Where it comes from |
|---|---|---|
| Numeral of a string $x$ | $|{}^\circ x| \le c_0|x|$ | binary |
| Trace for $\mathrm{Cert}(\kappa, w)$ | $\tau(K_{\max} + n)$ | Pudlák, Thm 6.1.4 (§5) |
| $\mathrm{Unf}_A$ | $W(n)$ | verifying the mover; polynomial |
| $\Delta_K$ | $d$ | constant |
| **Handed proof** | $|\pi| \le K_{\max} + 2\tau(K_{\max}+n) + W(n) + d + c_1(K_{\max}+n)$ | §2.1 |
| **Certificate** | $|\kappa_A| \le V(n) + c_2\log(\text{caps})$ | §2.2 |
| **Generator time** | $2R(K_{\max}+n) + O(\tau(K_{\max}+n) + W(n) + K_{\max})$ | $R$ is the time to check a proof |
| **Mover time** | $T + R\big(M + c_0(n + K_{\max})\big)$ | |

**Choosing the caps, in order:**

1. $K_{\max} := 2V(n) + c_3$. This exceeds $V(n) + c_2\log(\text{caps})$, since the caps are polynomial in $n$.
2. $M :=$ the bound for the handed proof above.
3. $T :=$ the generator-time bound above.
4. $T_2 := T + R\big(M + c_0(n + K_{\max})\big)$.

**All of these are polynomial in $n$**, with degrees set by $\tau$, $V$, $W$ and $R$. A game between two members costs $\mathrm{poly}(n)$ steps, including the verification. That's the point of the whole construction.

---

## 5. How much of the trust can be removed?

**The trace lemma, instance by instance.** *Established.* Pudlák (Handbook of Proof Theory, ed. Buss, 1998, Ch. VIII, Thm 6.1.4) shows that NP relations are polynomially numerable in $Q$: every true instance has a $Q$-proof of polynomial length. "$\kappa$ is a valid proof of $\varphi$" is such a relation, so the traces in P4 and P5 exist with polynomial size $\tau$. Corollary 6.1.6 there gives the closely related bound for "$\varphi$ has a proof of length at most $n$." This is Critch's Property 3, bounded necessitation, with **polynomial** $\mathcal E$, proved rather than estimated.

**The trace lemma, uniformly and provably in $S$.** *Not fully established.* Step 6 of §2.2 needs $S$ to prove, for variables, that the explicit trace construction produces valid proofs of true Cert facts. That's provable $\Sigma_1$-completeness, a standard theorem of PA, together with the polynomial size of the construction. Critch's Property 4 is the same kind of statement. I believe the combined uniform, explicit, polynomial form is folklore in bounded arithmetic, but I couldn't find a precise citation. *It's the main trusted lemma.*

**The time lemma.** Every polynomial-time function is $\Sigma^b_1$-definable in $S^1_2$, which is weaker than PA (Buss, *Bounded Arithmetic and Propositional Proofs*, lecture notes, "Bootstrapping Theorem"). That supports $S$ proving totality and polynomial running time for $\mathrm{gen}_A$ written in that style. Connecting it to the specific universal interpreter is routine program verification, but it hasn't been written out.

---

## 6. Comparison with Critch's Theorem 4

| | Critch, Thm 4 (FairBot$_k$) | CertBot |
|---|---|---|
| What agents do | exhaustive search over proofs of up to $k + G(\ell)$ characters | run the opponent's generator, then do one check |
| Running time | about $|\Sigma|^{k + G(\ell)}$, exponential | $\mathrm{poly}(n)$, explicit |
| When cooperation starts | for all $m, n > r$, with $r$ unspecified (an open problem in Levine 2026, MAIS-O1) | immediately, with explicit polynomial caps |
| Hard time limits | none; proof length is bounded, time isn't | yes, $T$ and $T_2$ |
| Key tool | Löb (bounded) | the diagonal lemma only |
| Assumptions about $S$ | Properties 1–4 (sketched) and $\mathcal E$, the **corrected** hypothesis $\vdash f(k) \succ \mathcal E\,O\lg k$, and $G(\ell) > 6f(2^\ell)$ | consistency, plus the trusted lemmas of §7 |
| Who cooperates | any two $G$-fair agents, for large parameters | any two members of the shared standard $K$ |
| Unexploitable | yes | yes (Theorem 3) |

**Where Critch is more general, honestly:**

1. **No shared standard.** $G$-fairness is a property defined by behavior and needs only $S$ and $G$. Our agents have to agree on $K$, *including the caps* $L$, $K_{\max}$, $M$, $T$ and $T_2$. Members of standards with different caps don't cooperate.
2. **No certificates.** A FairBot needs nothing beyond its own code, while a member has to produce a certificate, which is offline program verification.
3. **Parameters can differ.** Critch's $A_m$ and $B_n$ cooperate for all large $m$ and $n$, independently of each other. A family of standards $K_n$ with caps that grow with $n$ might recover this, but I haven't worked it out.
4. Critch's agents involve only reasoning. Ours require running the opponent's generator, which needs sandboxing, though Critch's agents have to evaluate opponent code as well.

**Where CertBot is better:** it can actually be run. Its time limits, sizes and thresholds are explicit polynomials, and it avoids Löb, so the gaps in Critch's argument (the property sketches, the missing "$\vdash$") don't affect it.

---

## 7. Verdict

**Established, at the level of rigor of this note:**

- Precise definitions, in Critch's own game: open-source code plus attached data, with no message passing (§1).
- Members cooperate with members, assuming only that $S$ is consistent (Theorem 1). Unexploitability (Theorem 3). Outcomes against DefectBot and FairBot$_k$ (§3).
- An explicit handed proof, $\mathrm{Asm}$, with no search, no regress and no self-certification (§2.1).
- The membership certificate $\kappa_A$, provable uniformly in the opponent, *given the trusted lemmas* (§2.2).
- Polynomial bounds, with caps chosen consistently (§4).
- Trace lemma, instance-by-instance form, with polynomial bounds: covered by Pudlák, Thm 6.1.4.

**Breakages found and repaired:**

1. A certificate inside its own program is impossible, for size reasons. Fix: attached data (§1.1).
2. The generator can't store its own unfolding proof, for the same reason. Fix: write it at play time with $\mathrm{Wr}$, verified once by the certificate (§1.4).
3. Message passing turned out to be unnecessary. The opponent's generator is run by the mover, which puts the construction exactly in Critch's game and removes the "hang" problem.
4. Traces must use the existential form of Cert, "an accepting run exists." A universal-quantifier formulation would make the proofs exponentially long.

**Still taken on trust:**

- **(T1) The uniform trace lemma:** provable $\Sigma_1$-completeness for Check facts, with an explicit polynomial-size construction, provable in $S$. It's the explicit counterpart of Critch's Property 4. I believe it's standard but haven't found a citation.
- **(T2) The time and correctness lemma** for $\mathrm{gen}_A$, $\mathrm{mover}_A$ and $\mathrm{Wr}$, relative to the universal interpreter. This is routine program verification; Buss's bootstrapping theorem supports it.
- **(T3) That $V$, $W$ and $\tau$ are polynomial with reasonable degrees.** Polynomial is argued; nothing has been written out or measured.
- **The routine syntactic lemmas:** that adding lines after a valid proof keeps it valid, instantiation, and numeral substitution.

**Bottom line.** In Critch's open-source Prisoner's Dilemma, CertBot gives provable, unexploitable mutual cooperation among members of a shared certificate standard, computed in explicit polynomial time under hard time limits, with guarantees resting only on the consistency of $S$. What it gives up compared with Theorem 4 is universality: it requires an agreed standard and certificates. What it gains is that it can actually be run, and that its bounds are explicit.
