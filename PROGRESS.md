# Progress log (append-only)

Claude Code appends here after every meaningful step. The Claude app session reads it.

- [setup, from the app] Project folder created, with the research notes in `research/`, the conventions in `CLAUDE.md`, and the app's handoff file `FROM_APP.md`. Next: Claude Code starts milestone 1.

- [M1 plan, Handled FROM_APP #1 and #2] **Proposed DSL design for review. No DSL code is written yet.** The Lean below is a draft and hasn't been compiled. Environment: Lean wasn't installed, so I'm installing it via `elan`. The folder isn't a git repo yet. Five decisions are flagged ⚑ for review.

  **1. Value type ⚑.** I'd use S-expressions instead of "strings and naturals". Code, formulas and proofs all have to travel as data (the opponent's code, certificates, ⌜K⌝, `sub`). With trees, encoding and decoding are structural and the round-trip lemmas are easy. With strings, every proof would go through a parser. The moves are the atoms `C` and `D`, and the booleans are `true` and `false`.
  ```lean
  inductive Val where
    | nat  : Nat → Val
    | sym  : String → Val
    | pair : Val → Val → Val
    deriving DecidableEq, Repr
  ```

  **2. Constructs.** A first-order language with named variables and named, possibly recursive, functions. Recursion is safe because of fuel. `ite` takes the `then` branch iff the condition evaluates to `sym "true"`. Primitives have a fixed arity, and any arity or type error evaluates to `none`.
  ```lean
  inductive Op where
    | eq | pair | fst | snd | isPair | isNat | plus | minus | lt  -- pure data ops
    | check   -- check(p, φ, f): S's checker with fuel f   (semantics arrive in M2)
    | subst   -- subst(φ, v): put the quoted value v into φ's free variable (M2)

  inductive Expr where
    | var  : String → Expr
    | lit  : Val → Expr
    | op   : Op → List Expr → Expr
    | ite  : Expr → Expr → Expr → Expr
    | let_ : String → Expr → Expr → Expr
    | call : String → List Expr → Expr

  structure Program where
    fns : List (String × List String × Expr)   -- name, params, body; the entry point is "main"
  ```
  Programs travel as `Val`. There's an encoder `Program.quote : Program → Val` and a decoder `Program.decode? : Val → Option Program`, with the lemma `decode? (quote p) = some p`. `run` takes code as a `Val` and decodes it, so an opponent's code is just data.

  **3. Fuel ⚑. It counts steps, not depth.** Every evaluation step costs 1, and leftover fuel is threaded through. With *depth*-bounded fuel, a hostile opponent (`f(n) = f(n-1) + f(n-1)`) could do 2^T work and effectively hang you. Running out of fuel or hitting an error gives `none`.
  ```lean
  def run (fuel : Nat) (code : Val) (args : List Val) : Option Val
  -- internally: eval : Program → (fuel : Nat) → Env → Expr → Option (Val × Nat), remaining fuel < fuel
  ```
  The primitive `check(p, φ, f)` will charge a **flat** cost f. It fails if fewer than f steps remain, and otherwise returns exactly `check f p φ`. The cost then doesn't depend on the inputs, so the symbolic-run rule can state an exact identity: Run(CertBot, ⟨y, κ⟩) = ite(Check(κ, sub(⌜K⌝, y)), C, D) for all y and κ, once T₂ ≥ F + overhead. That is the fuel-consistency lemma.

  **4. Order of the build ⚑.** `run` and `check` are mutually recursive: programs call `check`, and `check`'s evaluation rule calls `run`. In M2 they become a single mutual definition, well-founded on fuel. Each call into the other gets strictly less fuel, and `check f` uses at most f steps in total. In M1, the `check` and `subst` primitives are parsed but evaluate to `none`. That is marked as scaffolding and replaced in M2, so we still end up with only one `run`.

  **5. The game.** Anything except `some (sym "C")` counts as D.
  ```lean
  inductive Move | C | D
  def toMove : Option Val → Move
    | some (.sym "C") => .C
    | _ => .D
  structure Entry where
    code : Val
    cert : Val      -- attached data, never inside `code`
  def play (T : Nat) (a b : Entry) : Move × Move :=
    (toMove (run T a.code [b.code, b.cert]), toMove (run T b.code [a.code, a.cert]))
  ```
  The M1 demo: DefectBot is `main(opp, cert) = 'D'` and CooperateBot is `main(opp, cert) = 'C'`. We check that `play T defectBot cooperateBot = (.D, .C)`.

  **Open questions ⚑.** (a) Should there be a `sim(code, args, fuel)` primitive so agents can simulate opponents? It would mean more varied agents for M6, but more cases in the symbolic-run rule. I lean toward leaving it out for now and adding it later. (b) A known caveat: fuel bounds the *steps*, but `eq` and `subst` cost time proportional to data size, and repeated `pair(x, x)` builds exponentially large trees (shared in memory). The fix, if we want one, is to cap value size inside `pair`. Next: wait for review, then implement in `Diag/Val.lean`, `Diag/Lang.lean` and `Diag/Game.lean`.

- [env] Lean `leanprover/lean4:v4.36.0` is installed via `elan` at `~/.elan/bin`; the shell PATH is unchanged. I ran `lake init Diag lib`, which created `lakefile.toml`, `lean-toolchain`, `Diag.lean`, `Diag/Basic.lean` (the template placeholder) and `README.md`. `lake build` is green. No Mathlib. Next: implement M1 once the plan above has been reviewed.

- [M1 done, Handled FROM_APP #3] **The DSL, the fueled interpreter and the game are implemented. `lake build` is green with no warnings. There is no `sorry`, `axiom` or `native_decide`.** Files:
  - `Diag/Val.lean`: values
  - `Diag/Params.lean`: the constants
  - `Diag/Lang.lean`: syntax, encoding and the interpreter
  - `Diag/Game.lean`: the game
  - `Diag/Examples.lean`: the example bots

  I followed the review, including the size-blowup fix:
  - **The cached size is a `computed_field`.** Logically it is the structural definition. At runtime Lean stores it in every node, so reading it is O(1) even for heavily shared values. There's no separate smart constructor, and no invariant that some value could violate.
    ```lean
    inductive Val where
      | nat  : Nat → Val
      | sym  : String → Val
      | pair : Val → Val → Val
    with
      @[computed_field] sz : Val → Nat
        | .nat n    => n.log2 + 1
        | .sym s    => s.length + 1
        | .pair a b => a.sz + b.sz + 1
    ```
  - **Every operation result is capped at `V`, and size-dependent operations are charged by size.** `Op.apply` returns the value plus an extra cost (`eq`: `a.sz + b.sz`; arithmetic: the bit sizes; structural operations: 0). The evaluator charges 1 per step plus that extra cost, and fails if the result has `sz > V`. Here is the `op` case of `eval`:
    ```lean
    | n+1, env, .op o es =>
      match evalList p n env es with
      | none => none
      | some (vs, m) =>
        match o.apply vs with
        | none => none
        | some (v, c) =>
          if h : c ≤ m.val ∧ v.sz ≤ V then some (v, ⟨m.val - c, by omega⟩) else none
    ```
  - **The interpreter and the one `run`.** The evaluator returns the remaining fuel as a `Fin fuel`, so "the remaining fuel is strictly less" is built into the type. That's how Lean accepts the definition as terminating by well-founded recursion on fuel. `run` charges `code.sz` up front for decoding.
    ```lean
    def eval (p : Program) : (fuel : Nat) → Env → Expr → Option (Val × Fin fuel)
    def evalList (p : Program) : (fuel : Nat) → Env → List Expr → Option (List Val × Fin (fuel + 1))
    def run (fuel : Nat) (code : Val) (args : List Val) : Option Val
    ```
  - **Round trip, proved:**
    ```lean
    theorem Program.decode?_quote (p : Program) : Program.decode? p.quote = some p
    ```
  - **The game.** Oversized entries play D:
    ```lean
    def Entry.ok (e : Entry) : Bool := decide (e.code.sz ≤ L) && decide (e.cert.sz ≤ Kmax)
    def move (T : Nat) (me opp : Entry) : Move :=
      if me.ok then toMove (run T me.code [opp.code, opp.cert]) else .D
    def play (T : Nat) (a b : Entry) : Move × Move := (move T a b, move T b a)
    ```
  - **The M1 demo, as a theorem:**
    ```lean
    theorem defect_vs_cooperate : play Params.T defectBot cooperateBot = (.D, .C)
    ```
    `#print axioms defect_vs_cooperate` gives `[propext, Classical.choice, Quot.sound]`, Lean's three standard axioms, and nothing else.
  - **The `#eval` games all behave as expected.** DefectBot vs CooperateBot (D, C) and CooperateBot vs itself (C, C). `loopBot`, which recurses forever, runs out of fuel and plays D. `growBot`, which repeatedly doubles `pair(x,x)`, hits the cap V after about 20 steps and plays D almost instantly. `parityBot` uses recursion, `let`, `if` and arithmetic, and its results are correct.
  - **The M1 stubs.** The SCAFFOLD stubs are the `check` and `subst` cases of `Op.apply` in `Diag/Lang.lean`. Each carries `-- SCAFFOLD (M1): replace in M2`. I'll say here when they're gone.
- [design note, from FROM_APP #3] **The standard K quantifies only over bounded opponents.** Costs now depend on sizes, so CertBot's identity `Run(CertBot, ⟨y,κ⟩) = ite(Check(κ, sub(⌜K⌝,y)), C, D)` holds only for opponents within the size caps. Without caps, a huge but valid opponent would make CertBot run out of fuel and play D, and that would make K(CertBot) false. So
  `K(z) :≡ ∀ y κ', sz y ≤ L → sz κ' ≤ Kmax → (Run(z, ⟨y, κ'⟩) = C ↔ Check(κ', sub(⌜K⌝, y)))`,
  and the game treats oversized entries as non-members that play D (`Entry.ok` above). The fuel-consistency lemma becomes T₂ ≥ F + c·(L + Kmax + |⌜K⌝|) + |CertBot code|. The last term is new: `run` charges `code.sz` for decoding.
- [M1 findings, issues for later]
  1. **Stack depth.** The interpreter's recursion depth can be as large as the fuel. With T = 2^22, `loopBot` overflowed the stack in `#eval`. So `Params.T` is provisionally 2^18, and it works. M2's checker fuel F has to fit under T. If we need more fuel at play time, the options are a compiled executable with a large thread stack, or a later evaluator that doesn't recurse.
  2. **`decide` can't evaluate `run`.** Lean defines `eval` by well-founded recursion, so the kernel won't unfold it with `decide`. Concrete facts about runs are proved by rewriting with the evaluator's defining equations instead (see `run_constBot` in `Diag/Examples.lean`). This matters for M5: "CertBot's certificate checks" as a Lean theorem will need lemmas rather than `decide`. At play time, the compiled code just runs.
  3. **Not yet a git repository.** I've added a `.gitignore` for `.lake/`. Next: M2, after rereading `FROM_APP.md` (S's syntax with de Bruijn binders as suggested, proof objects, and the checker defined together with `run`).

- [git] The user set up the repo (origin `github.com/camall3n/diag`). M1 is committed as the first commit on `main`. It isn't pushed yet. The `lake init` template included `.github/workflows/lean_action_ci.yml`, which builds the project on every push.

- [M2 plan] **Proposed design for S's syntax, proofs and checker, for review. No code yet; the Lean is a draft that hasn't been compiled.** I checked `FROM_APP.md`: there are no items after #3. Decision points are flagged ⚑. The guiding aim is to keep M3's soundness proof small, so wherever possible a rule's soundness should be a single lemma about the Lean function it calls.

  **⚑0. A change to M1 first: make DSL operations total.** Today `fst(atom)`, `plus(sym, …)`, an unbound variable and so on all return `none`. I propose giving them default results instead (`fst`/`snd` of an atom gives `nil`, arithmetic treats non-numbers as 0, an unbound variable or unknown function gives `nil`, `check` with a non-number fuel gives `false`, and `subst` on something that doesn't decode gives `nil`). After this, a program can fail **only by running out of fuel or exceeding the size cap V**. The benefit: S's terms can have *total* `Val` semantics, so equational reasoning needs no "is this term defined?" side conditions. Those side conditions would otherwise appear in every `ite`/`let` rule and in the symbolic-run proof. The two remaining failure modes are exactly what the symbolic-run rule bounds statically (⚑5).

  **⚑1. Terms and formulas, with de Bruijn indices (as FROM_APP #3 suggested).** Function symbols reuse the DSL's `Op`, so `check` and `subst` in formulas *are* the DSL primitives. `run` is added, with `none` mapped to the atom `⊥`.
  ```lean
  inductive Tm where
    | bvar : Nat → Tm
    | lit  : Val → Tm
    | app  : Op → List Tm → Tm            -- eq, pair, fst, …, check, subst, sz
    | ite  : Tm → Tm → Tm → Tm            -- `then` iff the condition is `true`
    | run  : Tm → Tm → List Tm → Tm       -- run(fuel, code, args)
  inductive Fm where
    | eq  : Tm → Tm → Fm
    | fls : Fm
    | imp : Fm → Fm → Fm
    | and : Fm → Fm → Fm
    | all : Fm → Fm                       -- binds bvar 0
  ```
  ¬, ↔ and bounded ∀ are derived. Instantiation `Fm.inst φ t` replaces the loose `bvar 0`. `subst(φ, v)` only ever substitutes a *closed literal*, so it is capture-free by construction. Tm, Fm and Proof all have `quote`/`decode?` with round-trip lemmas, as in M1. A certificate is a quoted `Proof`.

  **⚑2. Semantics, which M3 will use.** `Tm.denote (ρ : Nat → Val) : Tm → Val` is structural. `run` denotes `(run f c args).getD ⊥`, and `check` denotes the Lean `check`, the very function. `Fm.denote ρ : Fm → Prop` sends ∀ to a Lean ∀ over `Val`. No fuel appears here, since every function called is already total.

  **⚑3. Proofs: natural-deduction proof terms, with the conclusion inferred.** The checker computes each proof's conclusion bottom-up and doesn't search, and `check f p φ` holds iff the inferred conclusion of `p` in the empty context is φ. Classical logic is via double-negation elimination; it's sound because the semantics is in classical Lean.
  ```lean
  inductive Proof where
    | hyp    : Nat → Proof                       -- i-th hypothesis
    | impI   : Fm → Proof → Proof                -- assume a, prove b ⊢ a → b
    | impE   : Proof → Proof → Proof
    | andI   : Proof → Proof → Proof
    | andL   : Proof → Proof
    | andR   : Proof → Proof
    | exfalso : Fm → Proof → Proof
    | dne    : Proof → Proof                     -- ¬¬φ ⊢ φ
    | allI   : Proof → Proof                     -- under shifted hypotheses
    | allE   : Proof → Tm → Proof                -- ∀φ ⊢ φ[t/0]
    | refl   : Tm → Proof
    | rw     : Fm → Proof → Proof → Proof        -- t = u, motive[t/0] ⊢ motive[u/0]
    | iteT   : Tm → Tm → Proof → Proof           -- c = true ⊢ ite(c,t,e) = t
    | iteF   : Tm → Tm → Proof → Proof           -- c = true → ⊥ ⊢ ite(c,t,e) = e
    | eval   : Tm → Tm → Proof                   -- closed t, u that evaluate equal ⊢ t = u
    | evalNe : Tm → Tm → Proof                   -- closed t, u that evaluate different ⊢ t = u → ⊥
    | symRun : Tm → Val → List Tm → List Nat → List Proof → Proof   -- ⚑5
  ```
  **There is no reflection rule.** `eval` can prove the *equation* `check(f, p, φ) = true`, which is a true fact about a Lean function. Nothing turns that equation into φ. That is the Löb guard.

  **⚑4. One mutual definition, with one fuel.** `eval`/`evalList` (the DSL), `run`, `infer` (the proof checker), `evalTm` (the fueled evaluator for closed terms used by `eval`/`evalNe`) and `symEval` (⚑5) form a single well-founded block over one fuel. Fuel is threaded through as in M1, so `check f` uses at most f steps. The DSL primitive `check(p, φ, f)` charges a flat f. Formula comparisons and instantiation are charged by size. This removes the M1 SCAFFOLD stubs.
  ```lean
  def check (fuel : Nat) (p φ : Val) : Bool   -- decodes p and φ, then infer
  ```

  **⚑5. The symbolic-run rule: the checker partially evaluates the code.** `symRun f code args bounds hyps` concludes `run(f, code, args) = e`.
  - The code is a literal and f is a literal number.
  - The args are any terms, typically bound variables.
  - Each arg comes with a literal size bound B_i, and a hypothesis proof of `lt(sz(arg_i), B_i + 1) = true`.

  The checker's `symEval` runs the DSL on symbolic values, which are terms:
  - **calls** are inlined;
  - **`let`** is substituted;
  - **`ite` on a symbolic condition** becomes a term `ite`;
  - **operations on symbolic values** become term `app`s.

  At the same time it computes a **concrete upper bound** on the fuel used and on every intermediate size, using the B_i, interval-style. The rule succeeds only if fuel used ≤ f and every size is ≤ V. Then `run` can't fail, and by ⚑0 its result is exactly `e`. This needs no arithmetic in S. M3's lemma is: if `symEval` succeeds, then for every ρ satisfying the bounds, `run f code (args.map denote) = some (denote e)`.
  - **Limitation:** recursion on *symbolic* data can't be unfolded (S has no induction), so the rule fails on such code. Members may still recurse on concrete data and use helpers, refactors and any control flow over finitely many symbolic branches. It's enough for CertBot and for structural variety in M6. Induction could be added later if needed.
  - **A cost to watch:** substituting `let` duplicates terms, so a chain of lets that each use their variable twice blows up. That's bounded by the checker's fuel. Alternative: a `let` binder in `Tm`, which adds one binder case to M3.

  **⚑6. Preview of K for M4 (unchanged from the design note).**
  `K(z) := ∀y ∀κ, lt(sz y, L+1) = true → lt(sz κ, Kmax+1) = true → (run(T, z, [y, κ]) = C ↔ check(F, κ, subst(⌜K⌝, y)) = true)`.
  With ⚑0, CertBot's certificate is about 5 steps: `allI`, `allI`, `impI`, `impI`, `symRun` (which gives `run(…) = ite(check(…) = true, C, D)`), then `iteT`/`iteF` with `evalNe` (C ≠ D) for the two directions. ⌜K⌝ is built with `diag` in M4.

  **M2 deliverable:** the files `Diag/Syntax.lean` (Tm, Fm, Proof, encodings and round trips) and `Diag/Check.lean` (the mutual block, which replaces the M1 stubs), plus toy proofs that check: propositional tautologies, ∀-instantiation, `eval` on closed arithmetic and on `run(DefectBot) = D`, a `symRun` on CooperateBot, and some rejected forgeries. Soundness is M3.

- [M2 started, Handled FROM_APP #4, Handled FROM_APP #5] I'm implementing the approved ⚑0–⚑6, with the parts of #4 that are still in force: the same Lean functions in the semantics, no reflection rule (with a Löb comment in the code), and the early CertBot acceptance test. One representation change: **`Tm` has fixed-arity operator nodes `op1/op2/op3` instead of `app : Op → List Tm → Tm`.** Lean can't derive `DecidableEq` for nested inductives, and fixed arity also lets me cache `size` as a `computed_field` and avoids nested induction in M3. `run`'s argument list is a single term that denotes a Lisp list (`Tm.list`). For the same reason, `symRun` takes *one* proof of the conjunction of its size bounds (`boundsFm`) instead of a list of proofs. `Op` has moved to `Diag/Op.lean` and gained `sz`. The syntax is in `Diag/Syntax.lean`.

- [M2 done] **S's syntax, proofs and checker are in, and the acceptance test passes: the checker accepts CertBot's hand-written certificate for K(CertBot), and CertBot vs CertBot plays (C, C).** `lake build` is clean, with no warnings and no `sorry`/`native_decide`/axioms.
  - Files:
    - `Diag/Op.lean`: the operations
    - `Diag/Syntax.lean`: Tm, Fm, Proof, shifting and instantiation, encodings with the round trips `Tm.decode?_quote` and `Fm.decode?_quote`, and `substV`
    - `Diag/Lang.lean`: the DSL with total operations, ⚑0
    - `Diag/Check.lean`: `symEval` plus the mutual block
    - `Diag/Semantics.lean`: denotations (definitions only)
    - `Diag/Standard.lean`: K, CertBot and its certificate
    - `Diag/Acceptance.lean`, `Diag/Toys.lean`: tests
  - **The M1 SCAFFOLD stubs are gone.** `eval` now calls the real `check` (flat cost f).

  **Key definitions:**
  ```lean
  -- one mutual block, well-founded on fuel: eval, evalList, run, check, evalTm, infer
  def run (fuel : Nat) (code : Val) (args : List Val) : Option Val
  def check (fuel : Nat) (p φ : Val) : Bool
  def infer : (fuel : Nat) → List Fm → Proof → Option (Fm × Fin fuel)
  def evalTm : (fuel : Nat) → Tm → Option (Val × Fin fuel)
  -- DSL primitive check(p, φ, f) inside `eval`:
  --   | .check, [pv, φv, .nat f] => if h : f ≤ m.val then some (Val.ofBool (check f pv φv), ⟨m.val - f, _⟩) else none

  def Tm.denote (ρ : Nat → Val) : Tm → Val      -- check ↦ Diag.check, run ↦ (Diag.run …).getD ⊥
  def Fm.denote (ρ : Nat → Val) : Fm → Prop     -- ∀ ranges over all Val

  def Dfm : Fm :=   -- inside ∀∀: κ = 0, y = 1, w = 2, z = 3
    .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
      (Fm.iff (.eq (.run (natT T) (b 3) (Tm.list [b 1, b 0])) (.lit C))
              (.eq (.op3 .check (b 0) (.op2 .subst (.op2 .subst (b 2) (b 2)) (b 1)) (natT F)) truT)))))
  def K : Fm := Dfm.inst (.lit Dfm.quote)
  def δ : Tm := .op2 .subst (.lit Dfm.quote) (.lit Dfm.quote)
  theorem diag_eval : substV Dfm.quote Dfm.quote = K.quote
  def member (c : Val) : Fm := K.inst (.lit c)
  theorem subst_K (c : Val) : substV K.quote c = (member c).quote

  def certBotProg : Program := ⟨[("main", ["opp", "cert"],
    .ite (.op .check [.var "cert", .op .subst [.lit Kq, .var "opp"], .lit (.nat F)]) (.lit C) (.lit D))]⟩
  ```
  The Löb comment is on `infer` in `Diag/Check.lean`.

  **Acceptance numbers.**
  - CertBot's certificate (`certBotCert` in `Diag/Standard.lean`) has **31 proof nodes**: allI×2, impI×5, rw×4, symRun×2, eval×1, evalNe×1, iteT×1, iteF×1, dne×1, impE×1, andI×5, plus hyps.
  - Its encoded size is **44,339**. `⌜K⌝` is 4,373, CertBot's code 4,553, and the statement K(CertBot) 13,473.
  - The checker needs about **157k fuel** to accept it, against `F = 2^18`.
  - The runtime cost bound that `symRun` computes for CertBot is **287,467**, against `T = 2^20`. So the fuel-consistency condition is checked by the checker itself for each certificate.
  - A full play of CertBot vs CertBot (two complete certificate checks) takes **5 ms**, in interpreted `#eval`.

  **Tournament** (`Diag/Acceptance.lean`):

  | Pairing | Result |
  |---|---|
  | CertBot vs CertBot | (C, C) |
  | CertBot vs DefectBot | (D, D) |
  | CertBot vs CooperateBot | (D, C) |
  | CertBot vs DefectBot carrying CertBot's certificate | (D, D) |

  **Toys** (`Diag/Toys.lean`). All 9 are accepted: propositional tautologies, classical ¬¬a → a, ∀-elimination, symmetry of = via rw, `eval` on arithmetic and on `run(DefectBot) = D`, `evalNe`, and `symRun` proving "CooperateBot always plays C". All **8 forgeries are rejected**:
  1. a stolen certificate;
  2. `symRun` on DefectBot claiming CertBot's result;
  3. `symRun` without proved size bounds;
  4. `symRun` with too little run fuel;
  5. `symRun` on `loopBot`;
  6. `evalNe` on equal values;
  7. `eval` on an open term;
  8. a reflection attempt (the equation check(…) = true can't be used to conclude φ).

- [M2 findings, awkward points for review]
  1. **Certificates are big, because large literals repeat.** CertBot's code occurs 5 times (in `symRun` and in the formulas that mention R), and ⌜K⌝ 3 times. `check` charges decoding by size, so this forced **F up from 2^16 to 2^18 and T up from 2^18 to 2^20**. `loopBot` still doesn't overflow the stack at T = 2^20. Kmax = 2^16 still fits (cert 44k), but it's tight for richer members. There are three cheap fixes, in order of preference: (a) structure certificates around a small generic lemma, `∀c ∀x. x = ite(c, C, D) → (x = C ↔ c = true)`, instantiated once (my estimate is about half the size); (b) shorter encoding tags; (c) a term-level `let`/abbreviation in proofs.
  2. **A bug, found and fixed.** `symOp` charged the *checker* for the symbolic `subst`'s *runtime* cost, about 20k. Now the checker pays only for work it actually does: a computed operation, or decoding the literal formula when bounding `subst`.
  3. **The de Bruijn motives for `rw` are fiddly by hand.** `M` and `M1` need R shifted past the hole. For M6, an LLM shouldn't write raw de Bruijn proofs: I'd add a small certificate front end with named variables that compiles to `Proof`.
  4. **As expected, `symEval` folds literal operations,** so its result contains the literal ⌜K⌝, not δ. One `rw` with `eval(⌜K⌝ = δ)` fixes that.
  5. **`decide` can't evaluate `check`** (well-founded recursion). So "CertBot's certificate checks" is shown by `#eval` at play time, not as a kernel-checked Lean theorem. For M5 we can instead prove `(member certBot).denote ρ` semantically, from the soundness lemmas below.

- [M3 statements, for review before I start M3] These are the statements I intend to prove. They're **not in the code yet**, to keep it free of `sorry`. Helper definitions:
  ```lean
  def SEnv.Bounded (ρ : Nat → Val) (σ : SEnv) : Prop :=
    ∀ x sv, (x, sv) ∈ σ → (sv.t.denote ρ).sz ≤ sv.b
  def SEnv.denote (ρ : Nat → Val) (σ : SEnv) : Env := σ.map fun (x, sv) => (x, sv.t.denote ρ)
  ```
  **The `symEval` correctness lemma**, the riskiest piece. It is proved together with an analogous `symEvalList_sound`, by induction on the checker fuel k:
  ```lean
  theorem symEval_sound (p : Program) (ρ : Nat → Val) (k : Nat) (σ : SEnv) (e : Expr)
      (r : SV) (c : Nat) (rest : Fin k)
      (hs : symEval p k σ e = some ((r, c), rest)) (hσ : SEnv.Bounded ρ σ)
      (fuel : Nat) (hc : c ≤ fuel) :
      ∃ rem : Fin fuel, eval p fuel (SEnv.denote ρ σ) e = some (r.t.denote ρ, rem) ∧
        fuel - c ≤ rem.val ∧ (r.t.denote ρ).sz ≤ r.b

  theorem symRunCore_sound (k f : Nat) (code : Val) (args : List SV) (e : Tm) (rest : Fin (k + 1))
      (hs : symRunCore k f code args = some (e, rest)) (ρ : Nat → Val)
      (hb : ∀ a ∈ args, (a.t.denote ρ).sz ≤ a.b) :
      run f code (args.map fun a => a.t.denote ρ) = some (e.denote ρ)
  ```
  **The `eval`-rule lemma.** It's purely computational: `evalTm` calls the same `run`/`check` that `denote` uses, so it needs no soundness of `check`:
  ```lean
  theorem evalTm_sound (n : Nat) (t : Tm) (v : Val) (rest : Fin n)
      (h : evalTm n t = some (v, rest)) (ρ : Nat → Val) : t.denote ρ = v
  ```
  **Main soundness**, by strong induction on the fuel n:
  ```lean
  theorem infer_sound (n : Nat) (Γ : List Fm) (pr : Proof) (φ : Fm) (rest : Fin n)
      (h : infer n Γ pr = some (φ, rest)) (ρ : Nat → Val) (hΓ : ∀ ψ ∈ Γ, ψ.denote ρ) :
      φ.denote ρ

  theorem check_sound (f : Nat) (p : Val) (φ : Fm) (h : check f p φ.quote = true) :
      ∀ ρ, φ.denote ρ
  ```
  The supporting lemmas I expect: `Fm.denote_inst`, i.e. `(φ.inst t).denote ρ ↔ φ.denote (Asg.cons (t.denote ρ) ρ)`; `Fm.denote_shift` for `allI`; `substBound`/`opBound`/`opCost` against `Op.applyPure`; and `Tm.list` against `Val.toList?`. **Note:** `infer_sound` never needs `check_sound` inside its own induction. The `eval` rule only asserts *equations* about `check`, which `evalTm_sound` covers. That is exactly the absence of reflection.

  [REVIEW] awaiting FROM_APP #6

- [M3 started, Handled FROM_APP #6] **Confirmed: `evalTm` calls the same `check`/`run` with the term's own fuel argument.** In `Diag/Check.lean`, `evalTm` does `| .check, .nat f => if h : f ≤ j.val then some (Val.ofBool (check f va vb), …)` and `| .nat g, some as => if h : g ≤ j.val then some ((run g vc as).getD Val.bot, …)`. It charges exactly f (or g) and never substitutes a smaller budget. If the remaining checker fuel is too small, the rule fails rather than calling `check` with less. The symbolic `ite` matches what the proof needs: cost `1 + cc + max tc ec`, size `max tv.b ev.b`. I'll add the `boundsFm` lemma and the `member` corollary as asked. Starting the proofs.

- [M3 done] **S is proved sound, with no `sorry`, no `native_decide` and no new axioms. `lake build` is clean with 0 warnings.** The proofs are in `Diag/Sound/`, about 1,200 lines:
  - `Basic.lean`: log2 facts; de Bruijn shift/instantiate lemmas for the semantics; the exact size of `subst`'s result
  - `EvalTm.lean`: `evalTm_sound`
  - `SymOp.lean`: symbolic operations against `Op.applyPure`, plus cost and size bounds
  - `SymEval.lean`: `symEval_sound`, `symRunCore_sound`
  - `Infer.lean`: `infer_sound`, `check_sound`, `check_member_sound`
  - `Axioms.lean`: the axiom audit

  The statements are exactly the ones reviewed in FROM_APP #6, plus the requested corollary:
  ```lean
  theorem evalTm_sound : ∀ (n : Nat) (t : Tm) (v : Val) (rest : Fin n),
      evalTm n t = some (v, rest) → ∀ ρ, t.denote ρ = v

  theorem symEval_sound (p : Program) (ρ : Nat → Val) (k : Nat) (σ : SEnv) (e : Expr)
      (r : SV) (c : Nat) (rest : Fin k)
      (hs : symEval p k σ e = some ((r, c), rest)) (hσ : SEnv.Bounded ρ σ)
      (fuel : Nat) (hc : c ≤ fuel) :
      ∃ rem : Fin fuel, eval p fuel (SEnv.denote ρ σ) e = some (r.t.denote ρ, rem) ∧
        fuel - c ≤ rem.val ∧ (r.t.denote ρ).sz ≤ r.b

  theorem symRunCore_sound (k f : Nat) (code : Val) (args : List SV) (e : Tm) (rest : Fin (k + 1))
      (hs : symRunCore k f code args = some (e, rest)) (ρ : Nat → Val)
      (hb : ∀ a ∈ args, (a.t.denote ρ).sz ≤ a.b) :
      run f code (args.map fun a => a.t.denote ρ) = some (e.denote ρ)

  theorem infer_sound : ∀ (n : Nat) (Γ : List Fm) (pr : Proof) (φ : Fm) (rest : Fin n),
      infer n Γ pr = some (φ, rest) → ∀ ρ : Nat → Val, (∀ ψ ∈ Γ, ψ.denote ρ) → φ.denote ρ

  theorem check_sound (f : Nat) (p : Val) (φ : Fm) (h : check f p φ.quote = true) :
      ∀ ρ, φ.denote ρ

  theorem check_member_sound (f : Nat) (κ c : Val)
      (h : check f κ (Standard.member c).quote = true) : ∀ ρ, (Standard.member c).denote ρ
  ```
  **The `boundsFm` lemma** (FROM_APP #6), which connects the `symRun` hypotheses to `symRunCore_sound`:
  ```lean
  theorem boundFm_denote (t : Tm) (B : Nat) (ρ : Nat → Val) :
      (boundFm t B).denote ρ ↔ (t.denote ρ).sz ≤ B
  theorem boundsFm_denote (ρ : Nat → Val) :
      ∀ args : List (Tm × Nat), (boundsFm args).denote ρ →
        ∀ a ∈ args.map (fun (p : Tm × Nat) => (⟨p.1, p.2⟩ : SV)), (a.t.denote ρ).sz ≤ a.b
  ```
  **The substitution lemma in the semantics**, used for `allE` and `rw`; there's also a shift version for `allI`:
  ```lean
  theorem Fm.denote_inst (φ : Fm) (t : Tm) (ρ : Nat → Val) :
      (φ.inst t).denote ρ ↔ φ.denote (Asg.cons (t.denote ρ) ρ)
  ```
  **`#print axioms`** (`Diag/Sound/Axioms.lean`). Each of `evalTm_sound`, `symEval_sound`, `symRunCore_sound`, `infer_sound`, `check_sound` and `check_member_sound` depends on axioms: `[propext, Classical.choice, Quot.sound]`. Those are Lean's three standard axioms and nothing else. `Classical.choice` comes from `dne`, the classical rule, and from `Classical.byContradiction`.
- [M3 notes]
  1. **As predicted, `infer_sound` never calls `check_sound`.** The `eval` rule's case uses only `evalTm_sound`, which holds by computation, because `evalTm` calls the same `check`/`run` that `Tm.denote` uses. That is the formal sense in which S has no reflection rule.
  2. **One change to `Diag/Check.lean` during M3, with no change in behaviour.** The checker-work computation inside `symOp` is now a separate function, `symWork`, which made the proof's case analysis tractable.
  3. **The proof is by strong induction on fuel throughout** (`Nat.strongRecOn`). `symEval_sound` and the list version are proved together as one conjunction. Next: M4, the Theorems A and B, stated about `play`. I'll reread `FROM_APP.md` first.

- [M4 done] **Theorems A and B are proved about `play` itself, using only the standard axioms.** The file is `Diag/Theorems.lean`. `diag`, K and the substitution lemma were already in `Diag/Standard.lean` (M2):
  ```lean
  theorem diag_eval : substV Dfm.quote Dfm.quote = K.quote                 -- δ evaluates to ⌜K⌝
  theorem subst_K (c : Val) : substV K.quote c = (member c).quote          -- sub(⌜K⌝, c) = ⌜K(c)⌝
  ```
  **What K means, as a plain Lean statement** about the one `run` and the one `check`:
  ```lean
  theorem member_denote (c : Val) (ρ : Nat → Val) :
      (member c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
        ((run T c [y, κ]).getD Val.bot = C ↔ check F κ (member y).quote = true)
  ```
  **The theorems:**
  ```lean
  def Certified (e : Entry) : Prop := check F e.cert (member e.code).quote = true

  theorem theoremA (a b : Entry) (ha : a.ok = true) (hb : b.ok = true)
      (hca : Certified a) (hcb : Certified b) :
      play T a b = (.C, .C)

  theorem theoremB (a b : Entry) (hca : Certified a) (h : (play T a b).1 = .C) :
      (play T a b).2 = .C
  ```
  The proof of B: a plays C, so by `member_denote` (from soundness) b's certificate checks. By soundness again, b is a member, so b plays C exactly when a's certificate checks, and it does.

  **`#print axioms`.** Each of `member_denote`, `theoremA` and `theoremB` depends on axioms: `[propext, Classical.choice, Quot.sound]`.
- [M4 design decision, small, flagged for the app] **Each side now checks the sizes of *both* entries.** `move T me opp = if me.ok && opp.ok then toMove (run …) else .D`; before, it checked only `me.ok`. Without this, Theorem B would fail against oversized opponents. K only speaks about opponents within the caps, so a member could legally cooperate with an oversized entry, which then plays D. With the change, an out-of-spec pairing is D/D. This is a local check by each player, not a referee. Theorem B needs no size hypothesis, and Theorem A only needs both entries to be within the caps. All tournament results are unchanged.
- [M4 note on the fuel-consistency rule in CLAUDE.md] In this design the fuel-consistency lemma is **general and proved**: it is `symRunCore_sound`. If the checker's computed cost bound, `code.sz + c`, is ≤ the run fuel f, then `run f code args` succeeds and returns the predicted value for every opponent within the bounds. Every membership certificate goes through `symRun`, so it carries this check, and for CertBot it is 287,467 ≤ T = 2^20. A separate kernel-checked lemma for CertBot's concrete numbers would need `decide` to evaluate the well-founded `symEval`, which it can't (the M2 finding). Following FROM_APP #6, I didn't pursue it. Next: M5, a tournament with more entries and forged certificates, plus the smaller certificate approved in #6 (option (a)). I'll reread `FROM_APP.md` first.

- [M5 items from FROM_APP #7, Handled FROM_APP #7] **The generic-lemma certificates (option (a)), two new members, and a 10×10 tournament.** Files: `Diag/CertGen.lean` and `Diag/Tournament.lean`.
  - **The certificate generator** (untrusted, since it only builds a `Proof`). It works for any mover whose `symRun` gives `ite(check(κ, subst(⌜K⌝, y), F), C, D)`. The small generic lemma is proved once and has no large literals:
    `L1 :≡ ∀k ∀k' ∀x. k = k' → x = ite(chk(k), C, D) → (x = C ↔ chk(k') = true)`, where `chk(z) := check(κ, subst(z, y), F)`.
    It is instantiated with `k := ⌜K⌝`, `k' := δ` and `x := run(T, code, [y, κ])`, then discharged with `eval(⌜K⌝ = δ)` and `symRun`.
    ```lean
    def memberCert (code : Val) : Proof :=
      .allI <| .allI <| .impI (boundFm (b 1) L) <| .impI (boundFm (b 0) Kmax) <|
        .impE (.impE (.allE (.allE (.allE L1pf (.lit Kq)) δ) (.run (natT T) (.lit code) (Tm.list [b 1, b 0])))
                     (.eval (.lit Kq) δ))
              (.symRun T code symArgs (.andI (.hyp 1) (.andI (.hyp 0) topPf)))
    ```
  - **Before and after** (encoded size, and the checker fuel needed to accept, to 1024 granularity):

    | Entry | Size | Fuel |
    |---|---|---|
    | CertBot, M2 hand-written certificate | 44,339 | 156,672 |
    | **CertBot, generated certificate** | **23,389** | **101,376** |
    | HelperBot | 23,653 | 102,400 |
    | LetBot | 23,505 | 102,400 |

    Every large literal (⌜K⌝, δ, the code) now appears exactly once. F and T are unchanged, as asked.
  - **The new members:**
    - `helperBot`: `main = toMove(verify(opp, cert))`, with helpers `verify(o, c) = check(c, subst(⌜K⌝, o), F)` and `toMove(x) = if x then C else D`.
    - `letBot`: `let phi = subst(⌜K⌝, opp) in let ok = check(cert, phi, F) in if ok then C else D`.

    `symEval` inlines the calls and substitutes the `let`s, so both reduce to the same term as CertBot, and `memberCert` certifies them unchanged.
  - **Non-members.** These are rejected by the checker (generated certificate does not check):
    - `cacheBot`: cooperates with CertBot's exact code without checking the certificate. `symRun` gives a different term, so it's rejected.
    - `stingyBot`: checks with fuel F/2.
    - DefectBot carrying a stolen or forged certificate.
  - **The tournament matrix** (row's move against each column), in this column order: CertBot(old cert), CertBot(new cert), HelperBot, LetBot, CooperateBot, DefectBot, CacheBot, StingyBot, DefectBot+stolen, DefectBot+forged.
    ```
    CertBot(old cert): [C, C, C, C, D, D, D, D, D, D]
    CertBot(new cert): [C, C, C, C, D, D, D, D, D, D]
    HelperBot:         [C, C, C, C, D, D, D, D, D, D]
    LetBot:            [C, C, C, C, D, D, D, D, D, D]
    CooperateBot:      [C, C, C, C, C, C, C, C, C, C]
    DefectBot:         [D, D, D, D, D, D, D, D, D, D]
    CacheBot:          [C, C, C, C, D, D, D, D, D, D]
    StingyBot:         [D, C, C, C, D, D, D, D, D, D]
    DefectBot+stolen:  [D, D, D, D, D, D, D, D, D, D]
    DefectBot+forged:  [D, D, D, D, D, D, D, D, D, D]
    100 moves in 57 ms (interpreted #eval)
    ```
    The members form a cooperating clique and defect on everyone else, as Theorems A and B predict. StingyBot's row shows a non-member's behaviour depending on certificate size: it rejects CertBot's old 157k-fuel certificate under its F/2 budget and accepts the newer ones. That is harmless, because Theorem B protects only members.
  - **A limitation found while choosing test members.** I wanted a member with the branches swapped, `if eq(check(…), false) then D else C`. S can't certify it yet. From `¬(chk = true)` it can't derive `chk = false`, because S has no axiom saying `check` returns a boolean. A small sound rule would fix this (`boolCases`: `check(…) = true ∨ check(…) = false`, true because `Tm.denote` of `check` is `Val.ofBool …`). It's worth adding before M6, so that LLM-written members can use negated tests. I'm not adding it without a nod.
  - I haven't built the named-variable front end yet. It isn't needed for these members, because the generator is a Lean function. I'll build it at the start of M6, where the LLM writes certificates.

- [K′ plan, for FROM_APP #8, Handled FROM_APP #8 (plan only; implementation waits for review)] **The one-way standard K′, added next to K, with nothing about K changed.** It will be built by the same `diag` construction, in new files `Diag/StandardP.lean` and `Diag/TheoremsP.lean`, and the tournament will be extended.
  - **Definition.** `D′` has loose variables w = 2 and z = 3 inside the two binders, as `Dfm` does:
    ```lean
    def DfmP : Fm := .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
      (.imp (.eq (.op3 .check (b 0) (.op2 .subst (.op2 .subst (b 2) (b 2)) (b 1)) (natT F)) truT)
            (.eq (.run (natT T) (b 3) (Tm.list [b 1, b 0])) (.lit C))))))
    def KP : Fm := DfmP.inst (.lit DfmP.quote)
    def memberP (c : Val) : Fm := KP.inst (.lit c)
    theorem diagP_eval : substV DfmP.quote DfmP.quote = KP.quote
    theorem memberP_denote (c : Val) (ρ : Nat → Val) :
        (memberP c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
          check F κ (memberP y).quote = true → (run T c [y, κ]).getD Val.bot = C
    ```
  - **A′.** `def CertifiedP (e : Entry) : Prop := check F e.cert (memberP e.code).quote = true`
    ```lean
    theorem theoremA' (a b : Entry) (ha : a.ok = true) (hb : b.ok = true)
        (hca : CertifiedP a) (hcb : CertifiedP b) : play T a b = (.C, .C)
    ```
  - **B′ ⚑, which I propose to state both ways.** First a semantic version, then a *certified* version that is checkable, and so suitable for the paper.
    The semantic version: "cautious" is a plain Lean hypothesis about a's code.
    ```lean
    def Cautious (c : Val) : Prop := ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
      (run T c [y, κ]).getD Val.bot = C → check F κ (memberP y).quote = true
    theorem theoremB'_sem (a b : Entry) (hca : CertifiedP a) (hc : Cautious a.code)
        (h : (play T a b).1 = .C) : (play T a b).2 = .C
    ```
    The certified version: cautiousness is itself certified, against a formula `KC` built with `diag` *on K′'s code* (not on its own code):
    `KC(z) :≡ ∀y ∀κ. bounds → (run(T, z, [y, κ]) = C ↔ check(F, κ, subst(⌜K′⌝, y)) = true)`.
    Its ← direction is exactly K′(z), and its → direction is exactly `Cautious z`. So one certificate for `KC(a)` gives both, via `check_sound`.
    ```lean
    theorem theoremB' (a b : Entry) (κc : Val) (hc : check F κc (memberC a.code).quote = true)
        (hca : CertifiedP a) (h : (play T a b).1 = .C) : (play T a b).2 = .C
    ```
    Here a cautious entry carries its K′ certificate (which others check at play time), and κc is checked offline as evidence for the theorem. I prefer keeping `Entry` with one certificate, so κc stays outside the game. CertBot′'s κc is essentially the K-style certificate (`memberCert` adapted to ⌜K′⌝). **Do you want both, or only the certified version?**
  - **Inclusiveness.** CooperateBot's K′ certificate is about 7 steps: allI×2, impI×3, then `symRun` gives run = C directly, with no `eval` of δ′ needed. I expect it to be well under 1k in size. `CertBot′` is `main = if check(cert, subst(⌜K′⌝, opp), F) then C else D`. Its K′ certificate is `impI (chk = true)` → rw/`eval` ⌜K′⌝ = δ′ → `iteT` with `symRun`.
    Planned tournament rows:
    - K′: CertBot′ vs CooperateBot is (C, C).
    - K: CertBot vs CooperateBot stays (D, C), already shown.
    - K′: DefectBot is not certifiable under K′ (`symRun` gives run = D), so CertBot′ defects against it.
  - **Cross-standard.** In CertBot vs CertBot′, each checks the other's certificate against *its own* standard. A K certificate isn't a proof of K′(·), and vice versa, so I expect (D, D). I'll run it and record it as the **bridging open question**. For example, an entry could carry one certificate per standard (`Entry` with a list of certificates), or a member could accept "certified under K or under K′". But that changes what the standards say and needs its own theorems.
  - `#print axioms` for `memberP_denote`, `theoremA'`, `theoremB'_sem` and `theoremB'`, expecting the standard three.
  - Also queued, pending a nod: the `boolCases` rule (previous entry), before M6.

  [REVIEW] awaiting FROM_APP #9

- [K′, boolCases and SwapBot done, Handled FROM_APP #9] **The one-way standard K′ with A′ and both versions of B′; the `boolCases` rule with its soundness case; SwapBot certified; and the mixed-standard tournament.** The clean build has 0 warnings and no `sorry`/`native_decide`/axioms.
  - **`boolCases`, a small extension of the trusted rules.** It is in `Diag/Syntax.lean` (constructor and encoding), `Diag/Check.lean` (the `infer` case) and `Diag/Sound/Infer.lean` (the soundness case):
    ```lean
    | boolCases : Tm → Proof → Proof → Proof   -- p ⊢ t = true → φ,  q ⊢ t = false → φ  ⟹  φ
    def Tm.isBool : Tm → Bool                  -- the condition: the head operation yields a boolean
      | .op1 .isPair _ | .op1 .isNat _ => true
      | .op2 .eq _ _ | .op2 .lt _ _ => true
      | .op3 .check _ _ _ => true
      | _ => false
    theorem Tm.isBool_denote : ∀ (t : Tm), t.isBool = true → ∀ ρ : Nat → Val,
        t.denote ρ = Val.tru ∨ t.denote ρ = Val.fls
    ```
    The justification is semantic: these operations return `Val.ofBool …` in `Op.applyPure` and in `Tm.denote` (and `check` with a non-numeric fuel returns `false`). `infer_sound` has the new case, which uses `Tm.isBool_denote`.
  - **SwapBot**, `main = if eq(check(cert, subst(⌜K⌝, opp), F), false) then D else C`, is certified under K by `swapCert` in `Diag/CertGen.lean`. That uses a second generic lemma, `L2 :≡ ∀k ∀k' ∀x. k = k' → x = ite(eq(chk(k), false), D, C) → (x = C ↔ chk(k') = true)`, whose → direction uses `boolCases` on `chk(k')`. Its size is 24,703, and it needs about 103k checker fuel. It joins the K clique: the 11×11 matrix in `Diag/Tournament.lean` gives C among {CertBot old/new, HelperBot, LetBot, SwapBot}, and the other rows are unchanged. I refactored `memberCert` into `memberCertWith lem kq d code`, so the same skeleton serves K, K′ and KC.
  - **K′** (`Diag/StandardP.lean`), built with `diag` like K. The binders mirror `Dfm`:
    ```lean
    def DfmP : Fm := .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
      (.imp (.eq (.op3 .check (b 0) (.op2 .subst (.op2 .subst (b 2) (b 2)) (b 1)) (natT F)) truT)
            (.eq (.run (natT T) (b 3) (Tm.list [b 1, b 0])) (.lit C))))))
    def KP : Fm := DfmP.inst (.lit DfmP.quote)
    theorem diagP_eval : substV DfmP.quote DfmP.quote = KP.quote
    def memberP (c : Val) : Fm := KP.inst (.lit c)
    theorem subst_KP (c : Val) : substV KP.quote c = (memberP c).quote
    -- KC: refers to ⌜K′⌝ as a literal, never to itself, so no diagonalization of its own (noted in the code)
    def DC : Fm := .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
      (Fm.iff (.eq (.run (natT T) (b 2) (Tm.list [b 1, b 0])) (.lit C))
              (.eq (chkAt (b 0) (b 1) (.lit KPq)) truT)))))
    def memberC (c : Val) : Fm := DC.inst (.lit c)
    ```
  - **The theorems** (`Diag/TheoremsP.lean`):
    ```lean
    theorem memberP_denote (c : Val) (ρ : Nat → Val) :
        (memberP c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
          check F κ (memberP y).quote = true → (run T c [y, κ]).getD Val.bot = C
    theorem memberC_denote (c : Val) (ρ : Nat → Val) :
        (memberC c).denote ρ ↔ ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
          ((run T c [y, κ]).getD Val.bot = C ↔ check F κ (memberP y).quote = true)

    def CertifiedP (e : Entry) : Prop := check F e.cert (memberP e.code).quote = true
    def Cautious (c : Val) : Prop := ∀ y κ : Val, y.sz ≤ L → κ.sz ≤ Kmax →
      (run T c [y, κ]).getD Val.bot = C → check F κ (memberP y).quote = true

    theorem theoremA' (a b : Entry) (ha : a.ok = true) (hb : b.ok = true)
        (hca : CertifiedP a) (hcb : CertifiedP b) : play T a b = (.C, .C)
    theorem theoremB'_sem (a b : Entry) (hca : CertifiedP a) (hc : Cautious a.code)
        (h : (play T a b).1 = .C) : (play T a b).2 = .C
    theorem theoremB' (a b : Entry) (κc : Val) (hc : check F κc (memberC a.code).quote = true)
        (hca : CertifiedP a) (h : (play T a b).1 = .C) : (play T a b).2 = .C
    ```
  - **Certificates.** These all check, at sizes 1,721, 11,112 and 12,125 respectively:
    - CooperateBot under K′ (`coopCertP`): 7 steps, with `symRun` giving run = C outright;
    - CertBot′ under K′ (`certPCert`): the ← half (`andR`) of the generic lemma L1, instantiated with ⌜K′⌝ and δ′;
    - CertBot′'s cautiousness KC (`cautiousCert`), checked offline.
  - **The mixed tournament** (`Diag/TournamentP.lean`). Row's move, in this column order: CertBot(K), HelperBot(K), SwapBot(K), CertBot′(K′), CooperateBot(with K′ cert), DefectBot, DefectBot+forged K′ cert.
    ```
    CertBot (K):            [C, C, C, D, D, D, D]
    HelperBot (K):          [C, C, C, D, D, D, D]
    SwapBot (K):            [C, C, C, D, D, D, D]
    CertBot′ (K′):          [D, D, D, C, C, D, D]
    CooperateBot (K′ cert): [C, C, C, C, C, C, C]
    DefectBot:              [D, D, D, D, D, D, D]
    DefectBot+forged K′:    [D, D, D, D, D, D, D]
    ```
    Certificate checks, as (under K, under K′): the K-members are (true, false); CertBot′ and CooperateBot are (false, true); the forged DefectBot is (false, false).
    - **Inclusiveness:** CertBot′ vs CooperateBot is **(C, C)** under K′. Under K, CertBot vs CooperateBot is **(D, C)**, because CooperateBot isn't a K-member.
    - **Cross-standard:** CertBot vs CertBot′ is **(D, D)**, as expected. Each checks the other's certificate against its own standard. **This is the bridging open question.** Neither standard recognizes the other's members, even though both are "cooperative". Candidate directions, not implemented: one certificate per standard in an entry; a disjunctive standard ("certified under K or K′"), whose theorems would need redoing; or a translation lemma inside S from K-certificates to K′. Note too that under K′, CooperateBot is exploited by DefectBot. B′ protects only *cautious* members, which is why it carries the `Cautious` hypothesis or a KC certificate.
  - **`#print axioms`, re-run after `boolCases`.** Each of these depends on axioms: `[propext, Classical.choice, Quot.sound]`, the standard three only: `evalTm_sound`, `symEval_sound`, `symRunCore_sound`, `infer_sound`, `check_sound`, `check_member_sound`, `member_denote`, `theoremA`, `theoremB`, `memberP_denote`, `memberC_denote`, `theoremA'`, `theoremB'_sem`, `theoremB'`.
  - Next: M6, starting with the named-variable certificate front end and then the LLM loop. I'll reread `FROM_APP.md` first.

- [M6 done (Claude Code as generator), Handled FROM_APP #11] **The LLM loop with a pluggable backend.** 8/8 members are certified (6 on the first attempt), and 0/6 adversarial candidates are accepted (7 attempts). The full report, with every attempt and every reason, is in `m6/REPORT.md`. The raw verdicts are in `m6/results.json`, unedited.
  - **The pipeline.** Candidates are plain S-expression data (`m6/candidates/<name>/vN.sexp` plus a `spec.json`), never Lean code, so a candidate can't influence the verdict.
    - The named-variable front end, `Diag/Front.lean`, is untrusted. Its syntax is documented at the top of the file. It compiles names to de Bruijn indices and documents the sugar it provides (`have`, `sym-run` with named bound hypotheses, `@self`, `@K`, `@delta`, and so on).
    - The runner `lake exe diagcheck <file> <K|KP>` (`DiagCheck.lean`) asks the one `check` and prints JSON: the verdict, sizes, minimum checker fuel, moves against the reference entries, and a rejection reason. The reason comes from `diagnose`, which locates the innermost proof node `infer` rejects; it explains but never decides.
    - The loop is `scripts/m6_loop.py`, with backends `claude-code` (the default: I write v1, read the checker's feedback, and write vN+1 only if needed) and `api` (a stub that refuses to run without your approval for a key and credits). `scripts/m6_report.py` builds the table and a round robin over every candidate's final attempt plus the references. Generated entries are labelled `LLM:`.
  - **A runner bug, found by the tournament and fixed before reporting.** At first "accepted" meant only `check F cert φ = true`. But `m03_swapped` v1 passed `check` with a certificate of size 76,437, over the cap Kmax = 65,536, so in play every pairing with it was out of spec (D/D, even against CooperateBot). Now **certified = checker accepts ∧ entry within the caps**, which is exactly the hypothesis of Theorems A and B. Both parts are reported (`checker_accepts`, `within_caps`), and all results were regenerated after the fix.
  - **Members**, each written by me as the generator:

    | Candidate | Shape | Attempts | Cert size | Checker fuel |
    |---|---|---|---|---|
    | m01 | helper chain | 1 | 50,074 | 164,858 |
    | m02 | let-bound verdict | 1 | 49,198 | 161,929 |
    | m03 | swapped branches, uses `bool-cases` | 2 (v1 over the cap; v2 uses a generic lemma) | 25,392 | 104,090 |
    | m04 | unused bookkeeping | 1 | 49,612 | 163,317 |
    | m05 | fuel computed by a helper, `(twice 131072)`, folded by `symEval` | 1 | 49,366 | 162,528 |
    | m06 | redundant `isPair` guard, needs `bool-cases` on `isPair y` | 2 (v1 at 131,618, over the cap; v2 with two generic lemmas) | 48,153 | 180,449 |
    | p01 (K′) | cautious, `respond` helper | 1 | 12,367 | 38,773 |
    | p02 (K′) | generous: also cooperates when the opponent's certificate is `nil` | 1 | 26,187 | 76,711 |

  - **Adversaries.** All were rejected, with these reasons from the checker's diagnosis:
    - `a1`, which defects exactly against CertBot: v1 was over the cap; v2, shrunk to fit, failed at `mp`, because the symbolic run gives `ite(eq(opp, CertBot), D, …)`.
    - `a2`, which spins 100,000 steps so that it would time out (play D) against members: `sym-run` was rejected (cost bound or checker fuel).
    - `a3`, CooperateBot claiming K: `eval` on an open term.
    - `a4`, DefectBot claiming K′ by rewriting with the opponent-certificate hypothesis: `rw` premise mismatch.
    - `a5`, a K′ look-alike that defects against CertBot′: `mp` premise mismatch.
    - `a6`, DefectBot carrying a *valid* proof about CertBot: "proves a different statement".
  - **The 18-entry round robin** is in `m6/REPORT.md`. The K members (6 LLM-written + CertBot) form a C-clique, and so do the K′ members (2 LLM-written + CertBot′). Every rejected adversary is defected against by every member. Where an adversary plays C against members (a1, a3, a5), members still play D against it, so the adversary is the one exploited. **The only member exploited is `p02_nil_generous`, by DefectBot (C/D).** It is K′-certified but deliberately not cautious, which is exactly why Theorem B′ needs `Cautious` or a KC certificate.
  - **Observations.**
    1. **Hand-written proofs that follow the "template" are near the cap.** About 49k against Kmax = 65,536, because the big literals (@self, @K) repeat. Twice, my second attempt fixed the cap by switching to generic-lemma proofs. An API generator will probably need the same hint, or the cap could be raised.
    2. Two of the six programs needed `bool-cases` (m03, m06), so the rule approved in #9 is used in practice.
    3. A full checker run per candidate takes well under a second. The whole loop over 14 candidates (17 attempts) took about 3 seconds.
  - Next: M7, the exclusivity theorem (FROM_APP #10).
