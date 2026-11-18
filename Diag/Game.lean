import Diag.Check

/-!
# The open-source Prisoner's Dilemma

An entry is code plus an attached certificate. Each side runs its own code on the
opponent's (code, certificate) with fuel `T`. Anything other than `C` counts as `D`.
Each side checks the sizes of *both* entries locally. If either entry is oversized
(code > `L` or certificate > `Kmax`), the pairing is out of spec and both play `D`.
The standard K only speaks about opponents within the caps, so this rule is what
makes unexploitability (Theorem B) hold unconditionally.
-/

namespace Diag
open Params

inductive Move | C | D
deriving DecidableEq, Repr

def toMove : Option Val → Move
  | some (.sym "C") => .C
  | _ => .D

structure Entry where
  code : Val
  cert : Val   -- attached data, never inside `code`

/-- Within the size caps of the standard. -/
def Entry.ok (e : Entry) : Bool := decide (e.code.sz ≤ L) && decide (e.cert.sz ≤ Kmax)

/-- The move `me` plays against `opp`. -/
def move (T : Nat) (me opp : Entry) : Move :=
  if me.ok && opp.ok then toMove (run T me.code [opp.code, opp.cert]) else .D

def play (T : Nat) (a b : Entry) : Move × Move :=
  (move T a b, move T b a)

end Diag
