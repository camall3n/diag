# Proof-exchange agents: a working sketch

Conventions: $S$ is the proof system (think PA). ${}^\circ k$ is the numeral for $k$; $\ulcorner\varphi\urcorner$ is the Gödel-number term for $\varphi$. $\Box\varphi$ means "some proof of $\varphi$ exists"; $\Box_k\varphi$ means "some proof of at most $k$ characters exists". $t{:}F$ means "$t$ is a proof of $F$" (explicit, justification-logic style). $\vdash X$ is our outside claim that $S$ proves $X$.

---

## 1. The protocol

**What we're setting up.** A game in which nobody searches at play time: each agent *hands* the other a proof, and each agent's move depends only on checking what it was handed.

**1.1 The two phases.**

1. *Exchange.* Agent $A$ sees $B$'s code and outputs a string $\pi_A := \mathrm{Make}_A(\ulcorner B\urcorner)$. Agent $B$ does the same: $\pi_B := \mathrm{Make}_B(\ulcorner A\urcorner)$. Each $\mathrm{Make}$ is a fixed computable function, part of the agent's code.
2. *Action.* $A$ checks $\pi_B$; $B$ checks $\pi_A$. Each outputs C or D.

**1.2 The rule ("HandBot").** $A$ cooperates iff the string it was handed checks as a proof that the opponent cooperates with $A$:

$$A \text{ plays } C \quad\text{iff}\quad \mathrm{Check}\big(\pi_B,\ \ulcorner B(A) = C \urcorner\big)$$

(A length cap $|\pi_B| \le B$ can be added; checking is linear, so the cap can be large.)

**1.3 What "$B(A) = C$" means inside $S$.** $B$'s move depends on the string $A$ hands it, and that string is $\mathrm{Make}_A(\ulcorner B\urcorner)$, a fixed computable function of the two codes. So both moves are computable functions of the pair of codes. Writing $\mathrm{Act}(x, y)$ for "the move of the agent with code $x$ against the agent with code $y$", the rule unfolds to

$$\mathrm{Act}(\ulcorner A\urcorner, \ulcorner B\urcorner) = C \;\leftrightarrow\; \mathrm{Check}\Big(\mathrm{Make}_B(\ulcorner A\urcorner),\ \ulcorner \mathrm{Act}(\ulcorner B\urcorner, \ulcorner A\urcorner) = C\urcorner\Big)$$

and $S$ proves this equivalence by unfolding $A$'s code through the arithmetized interpreter. I'll write $A(B) = C$ for $\mathrm{Act}(\ulcorner A\urcorner, \ulcorner B\urcorner) = C$.

Two things to notice:

- **The handed proof is named by a term, not a numeral.** Inside the sentence, $\pi_B$ appears as $\mathrm{Make}_B(\ulcorner A\urcorner)$, a short description of how to compute it, not the (long) string itself. This matters in §3.
- **Proofs are about actual code.** "$B(A) = C$" refers to what $B$'s code really does, including its $\mathrm{Make}$. Nothing is about a stated specification.

---

## 2. What the rule depends on

**2.1 The predicate.** The rule uses the explicit predicate

$$\pi{:}\varphi \;:\equiv\; \mathrm{Check}(\pi, \ulcorner\varphi\urcorner)$$

"$\pi$ is a proof of $\varphi$." It is decidable, so for any *specific* string, $S$ proves whichever of $\pi{:}\varphi$ or $\neg\,\pi{:}\varphi$ is true, by running the check (at a cost of about $\mathcal E(|\pi|)$ characters).

**2.2 The explicit provability conditions.** All three have explicit versions, and $S$ proves them uniformly:

- *Application (distribution):* $\vdash s{:}(F \to G) \to \big(t{:}F \to [s\cdot t]{:}G\big)$, where $s \cdot t$ joins the proofs and adds a modus ponens line.
- *Proof checker (inner necessitation):* $\vdash t{:}F \to {!t}{:}(t{:}F)$, where $!t$ is the record of running the check on $t$.
- *Necessitation for axioms:* each axiom $F$ gets a constant $c$ with $\vdash c{:}F$.

**2.3 Why $\Box p \to p$ fails for plain HandBots.** Let $p :\equiv A(B) = C \wedge B(A) = C$. To use Löb we would need $\vdash \Box p \to p$. From $\Box p$ we get $\Box\big(A(B) = C\big)$: *some* proof that $A$ cooperates exists. But $B$ cooperates only if $\mathrm{Make}_A(\ulcorner B\urcorner)$, *one specific string*, is such a proof. Existence of some proof says nothing about that string. So unless $\mathrm{Make}$ is tied to existence, the step fails. This is the "existence vs possession" gap, stated precisely.

---

## 3. The symmetric case: two identical agents

Let $H$ be a single agent playing itself. Then $p$ collapses to one sentence:

$$\eta \;:\equiv\; H(H) = C$$

**3.1 What the handed proof must prove.** By §1.3, with $A = B = H$:

$$\vdash \eta \leftrightarrow \mathrm{Check}\big(\mathrm{Make}_H(\ulcorner H\urcorner),\ \ulcorner\eta\urcorner\big)$$

So $\eta$ is provably equivalent to "this specific term's value is a proof of me." Each copy of $H$ hands over $\mathrm{Make}_H(\ulcorner H\urcorner)$, and that string has to be a proof of $\eta$. Both copies hand over the same string, so we need **one string $L$ that is a valid proof of $\eta$, with $\mathrm{Make}_H(\ulcorner H\urcorner) = L$.**

**3.2 Dead end 1: direct verification.** The obvious way for $L$ to prove $\eta$ is to prove $\mathrm{Check}(\ldots) = \text{true}$ by running the checker on $L$. That computation reads all of $L$, so the proof of it has at least about $|L|$ characters, plus overhead $\mathcal E$. Then $L$ would have to contain a proof longer than $L$, which is impossible. In the asymmetric version, each proof contains a check of the other, so $|\pi_A| > |\pi_B| > |\pi_A|$. This is the regress we saw in conversation.

**3.3 Dead end 2: self-certification by abstract argument.** Naming the proof by the term $\mathrm{Make}_H(\ulcorner H\urcorner)$, which is short, doesn't rescue this. To show that the term's value is valid *without* evaluating it, $L$ would need a general lemma along the lines of "every output of $\mathrm{Make}_H$ is a valid proof." But $L$ is itself an output, so proving the lemma requires the lemma's own proof to be valid. That requires $S$ to prove

$$t{:}\Lambda \to \Lambda$$

for the specific proof $t$ of the lemma $\Lambda$, and then actually derive $\Lambda$. Löb doesn't give that. Löb works with $\Box\Lambda \to \Lambda$, where the antecedent is "*some* proof exists", not "*this* proof is valid." I could not find a way around this, and I think it's the explicit-proof face of why GL's justification counterpart needs circular proofs (Shamkanov).

**3.4 The construction that works: Löb-first with a fallback.** The fix is to tie $\mathrm{Make}$ to *existence*, so that Löb applies, while arranging that the expensive part never runs in cooperative play.

*Step 1. Define $\mathrm{Make}_H$.* On input $\ulcorner X\urcorner$, consider the candidate list

$$\big[\ \mathrm{Recipe}(\ulcorner H\urcorner, \ulcorner X\urcorner),\ s_0,\ s_1,\ s_2,\ \ldots\ \big]$$

where $s_0, s_1, \ldots$ enumerates *all* strings. Return the first candidate that checks as a proof of "$H(X) = C$". $\mathrm{Recipe}$ is a fixed computable function that writes out the Löb-construction proof described in Step 5. It's purely syntactic and does no search.

*Step 2. The supplier lemma.* $S$ proves, abstractly, that if any proof exists, $\mathrm{Make}$ hands one over:

$$\vdash \Box\eta \to \mathrm{Check}\big(\mathrm{Make}_H(\ulcorner H\urcorner),\ \ulcorner\eta\urcorner\big)$$

*Why:* if some proof of $\eta$ exists, it appears somewhere in the list, so the "first valid candidate" exists and is valid. This uses only the least-number principle. It does **not** evaluate $\mathrm{Recipe}$ or check any specific string, which is exactly what dead end 2 couldn't avoid.

*Step 3. Combine Step 2 with §3.1.* The right side of Step 2 is equivalent to $\eta$:

$$\vdash \Box\eta \to \eta$$

*Step 4. Apply Löb's theorem.*

$$\vdash \eta$$

*Step 5. Constructivity.* Löb's proof is a fixed recipe. Given the proofs used in Steps 2–3, the 14 steps produce an explicit proof $L$ of $\eta$, including the diagonal fixed point $\Psi \leftrightarrow (\Box\Psi \to \eta)$. Define $\mathrm{Recipe}(\ulcorner H\urcorner, \ulcorner X\urcorner)$ to output exactly that construction, carried out for "$H(X) = C$". For $X = H$, its output is $L$, which (outside claim) is a valid proof of $\eta$.

*Step 6. Runtime.* Each copy computes $\mathrm{Recipe}(\ulcorner H\urcorner, \ulcorner H\urcorner) = L$ and checks it. It checks, so $\mathrm{Make}$ returns it at once, and the fallback enumeration **never runs**. The other copy checks $L$ and cooperates.

*No circularity in the definitions.* $H$'s code contains the *code* of $\mathrm{Recipe}$, not $L$. $L$ is computed at play time from $\ulcorner H\urcorner$, using a quine for $H$'s own code. So $|H|$ is fixed and $|L| > |H|$ causes no regress.

**3.5 Cost.** $L$ consists of:

- the unfolding $\eta \leftrightarrow \mathrm{Check}(\mathrm{Make}_H(\ldots), \ldots)$, through the arithmetized interpreter applied to $H$'s code. This is the largest part, plausibly polynomial in $|H|$;
- the supplier lemma, of roughly constant size apart from the definition of $\mathrm{Make}$;
- the Löb template with its fixed point, of constant size apart from mentions of $\eta$, which can be abbreviated.

So $|L| = \mathrm{poly}(|H|)$, and play-time cost is computing $L$ plus one linear check. There is no search. That's a rough estimate: I haven't bounded the interpreter overhead.

**3.6 Different agents of the same kind.** The argument isn't specific to copies. Let $A$ and $B$ both be Löb-first suppliers, possibly with different code, languages, or $\mathrm{Recipe}$s. Each has its own supplier lemma:

$$\vdash \Box\big(A(B) = C\big) \to \mathrm{Check}\big(\mathrm{Make}_A(\ulcorner B\urcorner), \ulcorner A(B) = C\urcorner\big)$$

and the right side is equivalent to $B(A) = C$, because $B$ checks what $A$ hands it. So $\vdash \Box(A(B) = C) \to B(A) = C$, and symmetrically $\vdash \Box(B(A) = C) \to A(B) = C$. With $p :\equiv A(B) = C \wedge B(A) = C$, $\Box p$ gives both boxes, so

$$\vdash \Box p \to p, \qquad \text{hence by Löb}\qquad \vdash p$$

For $A$'s $\mathrm{Recipe}$ to *write* this proof at play time, it needs $B$'s supplier lemma. Since the lemma is about $B$'s own code and holds for every opponent, $B$ can prove it in advance and ship it as a **certificate**. $A$'s $\mathrm{Recipe}$ then combines the two certificates with the Löb template. That's cheap and involves no search.

---

## 4. Where it breaks, and a repair

**4.1 The catch: false cooperation claims run the fallback.** Against DefectBot, "$A(\text{DefectBot}) = C$" is false. So $\mathrm{Recipe}$'s candidate fails the check, and $\mathrm{Make}_A$ falls through to the exhaustive enumeration. That's infeasible, and with an unbounded list it never ends.

- **Harmless case.** $A$'s *own move* doesn't depend on its $\mathrm{Make}$: $A$ checks DefectBot's string and plays D immediately. Once $A$'s move is D, stopping $\mathrm{Make}_A$ changes nothing the opponent could receive. If $S$ is sound (an outside assumption), there's no valid proof of the false sentence "$A$ cooperates", so the full search would also have handed over nothing.
- **Harmful case: deadlock.** Take two honest but incompatible agents. Each one's move waits on the *other's* string, and each one's $\mathrm{Make}$ is stuck in its fallback. Neither ever moves.
- **Timeouts don't fix it.** If $B$ plays D whenever nothing valid arrives by time $T$, then $B(A) = C$ becomes "$\mathrm{Make}_A$ returns a valid proof *within $T$*." The supplier lemma only promises *eventually*. Proving "within $T$" would require knowing in advance that the $\mathrm{Recipe}$ candidate is valid, which is dead end 2 again.

**4.2 Repair: gate on certificates.** Add a cheap first round.

*Step 1.* Each agent's certificate $\kappa$ is a proof of its own supplier lemma:

$$\kappa_B : \ \forall x\ \Big(\mathrm{Compat}_B(x) \wedge \Box\big(B(x) = C\big) \to \mathrm{Check}\big(\mathrm{Make}_B(x),\ \ulcorner B(x) = C\urcorner\big)\Big)$$

Here $\mathrm{Compat}_B(x)$ means "$x$'s certificate checks and has this form." It's decidable, and it's about $x$'s *actual* code.

*Step 2.* New $\mathrm{Make}_A$: if $\mathrm{Compat}_A(\ulcorner B\urcorner)$ fails, hand over nothing. Otherwise run Löb-first-with-fallback as in §3.4.

*Step 3: incompatible pairs.* Both gates fail, nothing is handed over, and both play D after one cheap certificate check. There's no deadlock.

*Step 4: compatible pairs.* $S$ verifies the specific certificate check by computation, at a cost of about $\mathcal E(|\kappa_B|)$. That reduces each supplier lemma to the §3.6 form, so $\vdash p$ and $\mathrm{Recipe}$ produces a valid proof. The fallback is reached only if $\mathrm{Recipe}$ is buggy.

*No new regress.* The handed proof $\pi_A$ contains a check of the *certificate* $\kappa_B$. That's a fixed string that doesn't depend on $\pi_A$. It does not contain a check of $\pi_B$.

**Conclusion of the repair:** in every play, the fallback search is unreachable. It remains in the code only so that $S$ can prove the supplier lemma abstractly.

*Caveat.* The gate means the supplier lemma no longer holds for *every* opponent, only for compatible ones. I've checked that §3.6 only needs it for the specific, compatible opponent, but I haven't checked every interaction with agents that mix this rule with other rules.

---

## 5. Robustness checks

- **Valid proof, then defect: impossible**, if $S$ is sound. A valid proof of "$X(A) = C$" is a proof about $X$'s *actual* code, so $X$ really cooperates. (Confirmed. The soundness of $S$ is our outside assumption, the usual one for PA.)
- **Malformed or forged proofs:** the check fails, and the agent plays D. Unexploitable.
- **DefectBot:** with gating, it has no certificate, so both play D after one cheap check.
- **Different implementations of the same kind,** in different languages, with different $\mathrm{Recipe}$s: they cooperate (§3.6), provided their certificates have the agreed form. The "agreed form" is the real compatibility condition. It's much looser than CliqueBot's "same code", but it is a convention that agents need to share.
- **FairBot-style search agents without a certificate:** they're treated as incompatible and get D, even though Löb-based cooperation with them is possible in principle. Bridging them would need a certificate form they can satisfy.
- **A buggy $\mathrm{Recipe}$:** safety is unaffected, but play hangs in the fallback for that pair. A proof that $\mathrm{Recipe}$ is correct would close this.

---

## 6. Verdict

**Established (on paper, at the level of rigor of this conversation):**

1. Naive mutual verification is impossible for reasons of size (§3.2).
2. I could not make purely explicit self-certification work, and I identified why. It needs "this specific proof is valid → its conclusion," which Löb doesn't supply (§3.3).
3. **Positive construction.** Agents whose $\mathrm{Make}$ is "Löb-recipe proof first, exhaustive search as a fallback" provably cooperate, with each other and with copies, using ordinary Löb (§3.4, §3.6). Play-time cost is computing and checking one proof of size roughly $\mathrm{poly}(|\text{code}|)$. **No search is executed.** The fallback is a device that lets $S$ prove "if a proof exists, I hand one over" without checking any specific string, and that converts "existence" into "possession."
4. Unexploitability holds whenever $S$ is sound (§5).
5. With certificate gating, incompatible agents defect quickly instead of deadlocking (§4.2).

**Conjecture or unchecked:**

- **The bounded version.** Everything above uses unbounded $\Box$. A Critch-style parametric family, with the fallback bounded by $f(k)$, should give the same result for large $k$, but I haven't worked it out. With gating, the bound only affects the proof device, not play.
- The estimate $|L| = \mathrm{poly}(|H|)$, which depends on the cost of the arithmetized interpreter.
- That $\mathrm{Recipe}$ can be written correctly for all compatible pairs. This is an engineering claim, and checkable.
- Interactions between the gated rule and agents built on other principles (§4.2 caveat).
- Whether the "fallback trick" corresponds to something in Shamkanov's circular proofs. It plays a similar role, turning a loop into a finite proof by passing through existence, but I haven't checked that.

**Bottom line:** proof exchange *can* give cheap, provable, robust mutual cooperation. The essential trick is that each agent's proof-supplier includes an exhaustive-search fallback that is never executed. It's what lets Löb apply, and Löb's constructivity then supplies the proof that is actually handed over.
