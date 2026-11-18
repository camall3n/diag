# Comparison 1: style, organization and tone

Reference papers, roughly in chronological order:
- **FM**: *Efficient Black-Box Planning Using Macro-Actions with Focused Effects* (Brown/IBM, IJCAI-style, about 2021).
- **MSA**: *Learning Markov State Abstractions for Deep RL* (NeurIPS 2021).
- **LD**: *Mitigating Partial Observability … via the Lambda Discrepancy* (NeurIPS 2024, many authors).
- **FP**: *Simplifying Planning Tasks with Fact-Level Relevance Analysis* (AAAI 2026, Berkeley).

Mine: **v0** (`draft_v0.tex`), a findings memo.

Two of these are planning-venue two-column papers (FM, FP) and two are NeurIPS single-column (MSA, LD). Some differences below are venue conventions and some look like growth. I say which, where I can tell.

## Organization

**Theirs.** All four use the standard arc: abstract, intro, background with formal definitions, method, experiments, related work, conclusion. Related work moves around for a reason:
- MSA puts it *early*, as §3, with five subsections, because the reader has to see where Markov abstraction sits among bisimulation, pixel prediction, inverse models, contrastive learning and kinematic inseparability before the method makes sense. That's a crowded NeurIPS field.
- FM, LD and FP put it *at the end*, short and mostly historical, because the idea is self-motivating once the problem is stated.

Each section introduces one idea. FP is the clearest case: "Preserving Action Applicability", then "From Variable-Level to Fact-Level Analysis", then "The Power of Fact-Level Analysis", then "Reachability and Relevance Iteration". Each is a single algorithmic step, with a theorem guaranteeing it is safe.

**Mine.** It's a memo, and the paragraph headers say so: "The goal", "What we built", "What broke", "The load-bearing question", "Paths to a paper", "When to pick this up". There is no background section and no definitions. The organization is chronological ("what broke, in order") rather than conceptual. Chronology fits a lab notebook. Cam's papers never organize by chronology; they organize by the dependency between ideas.

## Openings

**Theirs.** Every paper opens with a broad, true statement about the field, then turns with "However":
- MSA: "A fundamental assumption of reinforcement learning in MDPs is that the relevant decision process is, in fact, Markov. However, when MDPs have rich observations…"
- LD: "Reinforcement learning algorithms typically rely on the assumption that… However, when state information is only partially observable, how can an agent learn…, and how can it detect when it has found one?"
- FM: "The difficulty of deterministic planning increases exponentially with search-tree depth. Black-box planning presents an even greater challenge…"
- FP: "Planning problems described in formal languages often contain information that is irrelevant… Consequently, modern planners prune (some)…"

This is but/therefore at the very top: an assumption, BUT it can fail, THEREFORE our question. Three of the four abstracts name an **assumption** that practice relies on.

**Mine.** v0 opens with the setup ("Two programs that can read each other's source play a one-shot Prisoner's Dilemma") and then the idea. There's no stated assumption and no "however" until the construction is done. The turn the reader most needs ("working wasn't enough") comes a third of a page in.

## Tone

**Theirs.**
- Plain, confident, declarative, first-person plural.
- Mild warmth now and then: "We are encouraged…", "Surprisingly…", "simple yet powerful", "dramatically".
- Never self-flagellating. Limitations are stated as facts with scope ("Except in the case of Depot…", "(and never worse)", "in tested environments").
- Hedges are calibrated words ("often", "typically", "we suspect", "in principle"), not apologies.
- The reader is addressed as a capable colleague who doesn't yet know the problem.

**Mine.**
- More editorial and more self-critical: "We spent most of the effort defending the wrong wall"; "The trouble is that working wasn't enough". That honesty is the point of a findings memo, but the register comes from our conversations (the argument-skeleton vocabulary: "load-bearing", "wall") and won't read naturally to a collaborator who wasn't there.
- Insider vocabulary throughout: M8, M8b, CertBot, Contrarian, FROM_APP, App–Code, `unseal`, "the self-starvation attack". Cam's papers coin terms too ("representation gap", "effect size", "focused", "λ-discrepancy", "effective MDP model"), but each is *defined and italicized on first use*, and there are few of them.

## Visual and typographic style

**Theirs.**
- A Figure 1 on page 1 or 2 shows the whole idea: FP's nested plan sets, MSA's sensor/abstraction pipeline and architecture, LD's T-maze and network, FM's suitcase lock.
- Bold appears in tables (best results) and in run-in headings, rarely in prose. Italic marks defined terms and contrastive emphasis ("*only* appropriate for *Markov* states").
- Proofs in FP are boxed; algorithms carry comments.

**Mine.**
- No figure.
- Heavy bold in running prose ("**Theorem A:**", "**binding execution**", "**can't route…**").
- Two bullet lists, one numbered list and a table in two-and-a-half pages. Proportionally that's far more scaffolding than any of the four papers, which are almost entirely paragraphs (LD's numbered contribution list is the exception and is set off on purpose).

## What looks like growth over time (FM → FP)

- **FM (earliest)** is a bit conversational ("One might wonder whether…", "Surprisingly, we found that BFWS did not…"). It is explicitly hypothesis-driven ("We hypothesize that if each action modifies only a small number of state variables… If our hypothesis above is correct, we expect…").
- **MSA** carries the most conceptual exposition. It builds a small counterexample (the four-state MDP with a non-Markov abstraction) to make the problem felt before solving it. "This is especially unsatisfying…" is the most emotive sentence in the set, and it is earned by the example.
- **LD** frames the problem as a *question* in the abstract and gives a clean three-step contributions list (detect → mitigate in a tabular setting → scale). The escalation is the structure.
- **FP (latest)** is the tightest. It has short sections, each beginning "Our first observation is…" or "Our next observation is…". Transitions are explicit therefores: "Theorem 1 guarantees that (1)… and (2)…. The former ensures solution quality; the latter, solution validity. What remains is to choose which actions to keep." That last sentence is a THEREFORE that hands the reader to the next section. FP is the paper that best embodies the but/therefore discipline at the paragraph level.

Venue explains part of this: planning papers are proof- and algorithm-led, NeurIPS papers motivation- and curve-led. But FP's paragraph-level transitions are tighter than FM's at the same kind of venue, so some of it is Cam getting better.

## Takeaways for the rewrite (style level)

1. Open with the assumption and the "however", not with the setup.
2. Organize by dependency between ideas, not by the order things happened. A short hypotheses table can carry the chronology for the record.
3. Define every term a forgetful collaborator needs (program equilibrium, FairBot, Löb, payoffs T/R/P/S, ε-grounding, fair exchange), and coin few names.
4. Cut bold in prose; italicize defined terms on first use.
5. Keep the honesty but change the register from self-critique to calibrated statement of scope.
6. Consider one figure that shows the whole finding.
7. Use FP-style transitions: each paragraph ends by handing the reader a question the next one answers.
