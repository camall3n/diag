import Diag.Game

/-! # Example bots (M1) -/

namespace Diag.Examples
open Diag Expr

def C : Expr := lit (.sym "C")
def D : Expr := lit (.sym "D")

/-- A bot whose `main(opp, cert)` is `body`, plus helper functions. -/
def bot (body : Expr) (helpers : List (String × List String × Expr) := []) : Entry :=
  { code := (Program.mk (("main", ["opp", "cert"], body) :: helpers)).quote
    cert := Val.nil }

def defectBot : Entry := bot D
def cooperateBot : Entry := bot C

/-- Loops forever: `main = loop()`, `loop() = loop()`. Runs out of fuel, so plays D. -/
def loopBot : Entry := bot (call "loop" []) [("loop", [], call "loop" [])]

/-- Tries to build a huge value by repeated doubling, `grow(x) = grow(pair(x, x))`.
Each doubling is charged the new value's size, so it runs out of fuel after about 20 steps
instead of using exponential memory or time. -/
def growBot : Entry :=
  bot (call "grow" [lit (.nat 0)])
    [("grow", ["x"], call "grow" [op .pair [var "x", var "x"]])]

/-- Cooperates iff the opponent's code has an even number of functions, which exercises
recursion, `let`, `if` and arithmetic. -/
def parityBot : Entry :=
  bot (let_ "n" (call "len" [var "opp"])
        (ite (call "even" [var "n"]) C D))
    [("len", ["l"], ite (op .isPair [var "l"])
                      (op .plus [lit (.nat 1), call "len" [op .snd [var "l"]]])
                      (lit (.nat 0))),
     ("even", ["n"], ite (op .eq [var "n", lit (.nat 0)]) (lit Val.tru)
                      (ite (op .eq [var "n", lit (.nat 1)]) (lit Val.fls)
                        (call "even" [op .minus [var "n", lit (.nat 2)]])))]

open Params in
#eval play T defectBot cooperateBot   -- expect (D, C)
open Params in
#eval play T cooperateBot cooperateBot -- expect (C, C)
open Params in
#eval play T loopBot cooperateBot      -- expect (D, C)
open Params in
#eval play T growBot cooperateBot      -- expect (D, C)
open Params in
#eval play T parityBot defectBot       -- defectBot has 1 function: (D, D)
open Params in
#eval play T parityBot parityBot       -- parityBot has 3 functions: (D, D)
open Params in
#eval play T parityBot loopBot         -- loopBot has 2 functions: (C, D)

theorem eval_lit_val (p : Program) (env : Env) (v w : Val) :
    ∀ m (r : Fin m), eval p m env (lit v) = some (w, r) → w = v
  | 0, r, _ => r.elim0
  | m+1, r, h => by simp [eval] at h; exact h.1.symm

theorem eval_lit_ne_none (p : Program) (env : Env) (v : Val) :
    ∀ m, 0 < m → eval p m env (lit v) ≠ none
  | m+1, _ => by simp [eval]

/-- A constant bot `main(opp, cert) = v` returns `v` whenever the fuel exceeds the size
of its code (decoding costs `code.sz`, and evaluating the literal costs 1 step). -/
theorem run_constBot (v : Val) (fuel : Nat) (opp cert : Val)
    (h : (bot (lit v)).code.sz < fuel) :
    run fuel (bot (lit v)).code [opp, cert] = some v := by
  simp only [bot] at h ⊢
  unfold run
  split
  · simp only [Program.decode?_quote, Program.lookup, List.lookup, beq_self_eq_true,
      List.length_cons, List.length_nil, List.zip_cons_cons, List.zip_nil_right, ite_true]
    split
    · next heq => exact congrArg some (eval_lit_val _ _ _ _ _ _ heq)
    · next heq => exact absurd heq (eval_lit_ne_none _ _ _ _ (by omega))
  · next hn => exact absurd (Nat.le_of_lt h) hn

/-- The M1 demo as a theorem, proved by unfolding the definitions (no `native_decide`). -/
theorem defect_vs_cooperate : play Params.T defectBot cooperateBot = (.D, .C) := by
  have hD : (bot D).code.sz < Params.T := by decide
  have hC : (bot C).code.sz < Params.T := by decide
  have okD : defectBot.ok = true := by decide
  have okC : cooperateBot.ok = true := by decide
  simp only [play, move, okD, okC, Bool.and_self, ite_true]
  rw [defectBot, cooperateBot, D, C] at *
  rw [run_constBot _ _ _ _ hD, run_constBot _ _ _ _ hC]
  rfl

#print axioms defect_vs_cooperate

end Diag.Examples
