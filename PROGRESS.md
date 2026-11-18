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
