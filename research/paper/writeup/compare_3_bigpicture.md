# Comparison 3: the big picture

Same papers (FM, MSA, LD, FP) and v0.

## One question, asked early, answered all the way through

Each of the four papers has a one-sentence thesis that the whole structure serves:
- **FM:** goal counting is uninformative because actions touch many variables; macros with focused effects fix that.
- **MSA:** learned abstractions needn't be Markov; inverse models plus contrastive learning are sufficient conditions, and you can train for them.
- **LD:** you can *detect* non-Markovianity from value functions alone (two λs disagree) and *mitigate* it by minimizing the disagreement.
- **FP:** relevance should be analyzed at the level of facts, not variables, and each refinement provably preserves optimal plans.

v0's thesis is spread across the whole memo. It is three claims in sequence: the construction works; nothing distinguishes it; the deciding question is whether a certain regime exists. A collaborator can extract that, but only after reading to the end.

## The shape that recurs: an implicit assumption, made explicit

Three of the four papers are built on the same move. The field relies on an assumption it doesn't check, and the paper makes that assumption explicit and gives a tool to check or enforce it:
- MSA: RL assumes the state is Markov; learned abstractions break it silently.
- LD: same assumption, now with a test for when it fails.
- FM: goal counting assumes subgoals are independent; focused macros make that closer to true.
- FP is the exception (a refinement rather than an exposed assumption), though it too begins from "existing approaches are overly conservative".

**This is the most important big-picture observation for our write-up.** Our project's real finding has exactly this shape, and v0 doesn't present it that way. Program-equilibrium results (FairBot, Critch, Oesterheld, our CertBot) silently assume a **binding executor**: the code you read is the code that runs, and both moves happen. Make that assumption explicit and the landscape reorganizes:
- with an executor, plain escrow already gives the two guarantees we proved;
- without one, conditional cooperation is fair exchange, and its impossibility result puts the floor at ε, the same price as ε-grounding.

The outline's §7 loose thread ("if every program-equilibrium result silently assumes a binding runner, is the field's real question how small the shared convention can be?") is the spine of a Cam-style paper, not a loose thread. In v0 it appears only as the dead end that sinks us. In Cam's style it would be the headline, and our construction would become the worked example that made the assumption visible.

That also answers the user's question about "paths to a paper". The bridge note *is* this paper. v0 lists it third-hand as "workshop-sized" with folklore risk. The folklore risk is real, but the framing is the one Cam's best papers use.

## Concrete before abstract

Each paper makes the problem felt with a small concrete case before formalizing: Minecraft axe vs cake (FP), the four-state non-Markov abstraction (MSA), the T-maze (LD), the suitcase lock (FM). The example then recurs.

v0 has no running example. The obvious one is the self-starvation attack: two certified agents, one blocks its inbox, the other is exploited. It is small, vivid, and it carries the whole argument (the guarantee depends on delivery, which depends on an executor). A second, smaller example is CertBot vs CertBot′, which play (D, D) though both are "cooperative". It shows the convention cost.

## Promises and delivery

Their intros tell the reader what they will get and in what order. LD's contributions list escalates: detect, then mitigate in a tabular setting, then scale. By page 2 the reader knows the destination. v0's reader learns the destination ("the load-bearing question") on page 2 of 2.5. For a decision memo the destination should come first: a short summary saying "this is parked, here is the single question that would unpark it, here is what we have".

## Proportion: where the weight sits

In Cam's papers, the share of space roughly tracks the share of contribution: method and theory get the most, related work and conclusion the least.

In v0, the construction gets about a quarter, failures about a quarter, and the wall a paragraph. By the skeleton's own analysis the wall is the load-bearing step, so it is under-weighted relative to the rule I set for myself. The "lessons" paragraph is process advice that belongs in an appendix or a separate note.

## What not to copy

These papers are written to persuade reviewers that something works. Our document has a different job: tell future collaborators whether and when to resume, including what didn't work. So:
- Keep the explicit negative results. Cam's papers don't have them, but the user asked for them ("document what problems we ran into").
- Keep a decision table. It has no analogue in the four papers, but it is the most useful thing for the six-months-later reader.
- Don't adopt a full Background section with formal tuples; two pages can't afford it. Do adopt the *function* of Background: define every term a reader who has forgotten needs, in a sentence each.

## Growth over time, at the big-picture level

FM states a hypothesis and tests it. MSA builds a careful conceptual case against near neighbors. LD poses a crisp two-part question and answers it in escalating settings. FP makes a series of small observations, each provably safe, each handing off to the next.

The trend is toward a clearer, single question and toward each section doing exactly one job with an explicit handoff. That trend also matches what the argument-skeleton method asks for, so the two point the same way.

## Big-picture recommendation

Rewrite v0 as a short paper-shaped memo:
1. A summary paragraph with the verdict and the one question that would reopen the work.
2. Introduction: the implicit assumption (binding execution) and the however.
3. The idea and what we built (compact; theorems named; Lean details in footnotes).
4. What we found, organized as claims with evidence and scope, using the self-starvation attack as the running example, and a figure for the executor 2×2.
5. The open question and the paths that depend on it.
6. A decision table, with the hypotheses record as a compact appendix table.

Each joint should be a but or a therefore.
