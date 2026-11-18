import Diag.Syntax
import Diag.Params

/-!
# The DSL: syntax, encoding as values, and the primitive operations

* Programs are lists of named first-order functions; the entry point is `main`.
* Programs travel as `Val`s: `Program.quote` / `Program.decode?`, with
  `Program.decode?_quote : decode? (quote p) = some p`.
* The interpreter `run` lives in `Diag/Check.lean`, in one mutual definition with S's
  checker, because each calls the other.

## Fuel (step counting)
Every evaluation step costs 1 and leftover fuel is threaded through, so total work
is bounded by the fuel. Operations whose real cost depends on data size (`eq`,
arithmetic, and later `subst`) are charged the sizes of their arguments, and every
result is charged its own size (no fixed cap since M8b). So no program, and no certificate
evaluated by the checker, can do much more real work than its fuel.
-/

namespace Diag
open Params

/-- Lisp list → list of values. -/
def Val.toList? : Val → Option (List Val)
  | .sym "nil" => some []
  | .pair v rest => (Val.toList? rest).map (v :: ·)
  | _ => none

def Val.toNat : Val → Nat
  | .nat n => n
  | _ => 0

/-- What a failed `run` denotes inside S's terms. -/
def Val.bot : Val := .sym "⊥"

/-- **Total** semantics of the primitive operations, apart from `check` (⚑0): the result,
plus an extra cost on top of the 1-step base cost. Wrong arities and wrong types give
default values (`nil`, `false`, 0), so DSL programs fail only by running out of fuel.

`check` is not routed here when it has 3 arguments and a numeric fuel: `eval` (Check.lean)
and `Tm.denote` (M3) call the real checker. Every other use of `check` gives `false`. -/
def Op.applyPure : Op → List Val → Val × Nat
  | .eq,     [a, b]  => (Val.ofBool (a == b), a.sz + b.sz)
  | .pair,   [a, b]  => (.pair a b, 0)
  | .fst,    [v]     => (match v with | .pair a _ => a | _ => Val.nil, 0)
  | .snd,    [v]     => (match v with | .pair _ b => b | _ => Val.nil, 0)
  | .isPair, [v]     => (Val.ofBool (v matches .pair _ _), 0)
  | .isNat,  [v]     => (Val.ofBool (v matches .nat _), 0)
  | .plus,   [a, b]  => (.nat (a.toNat + b.toNat), a.sz + b.sz)
  | .minus,  [a, b]  => (.nat (a.toNat - b.toNat), a.sz + b.sz)
  | .lt,     [a, b]  => (Val.ofBool (decide (a.toNat < b.toNat)), a.sz + b.sz)
  | .sz,     [v]     => (.nat v.sz, 0)
  | .subst,  [φ, v]  => (substV φ v, φ.sz + v.sz)
  | .check,  _       => (Val.fls, 0)
  | _,       _       => (Val.nil, 0)

inductive Expr where
  | var  : String → Expr
  | lit  : Val → Expr
  | op   : Op → List Expr → Expr
  | ite  : Expr → Expr → Expr → Expr   -- takes `then` iff the condition is `sym "true"`
  | let_ : String → Expr → Expr → Expr
  | call : String → List Expr → Expr
deriving Repr

structure Program where
  /-- name, parameters, body -/
  fns : List (String × List String × Expr)
deriving Repr

def Program.lookup (p : Program) (f : String) : Option (List String × Expr) :=
  p.fns.lookup f

/-! ## Encoding programs as values -/

open Val in
mutual
def Expr.quote : Expr → Val
  | .var x      => ofList [.sym "var", .sym x]
  | .lit v      => ofList [.sym "lit", v]
  | .op o es    => ofList [.sym "op", .sym o.name, Expr.quoteList es]
  | .ite c t e  => ofList [.sym "if", c.quote, t.quote, e.quote]
  | .let_ x e b => ofList [.sym "let", .sym x, e.quote, b.quote]
  | .call f es  => ofList [.sym "call", .sym f, Expr.quoteList es]
def Expr.quoteList : List Expr → Val
  | []      => nil
  | e :: es => .pair e.quote (Expr.quoteList es)
end

mutual
def Expr.decode? : Val → Option Expr
  | .pair (.sym "var") (.pair (.sym x) (.sym "nil")) => some (.var x)
  | .pair (.sym "lit") (.pair v (.sym "nil")) => some (.lit v)
  | .pair (.sym "op") (.pair (.sym o) (.pair es (.sym "nil"))) =>
      match Op.ofName? o, Expr.decodeList? es with
      | some o, some es => some (.op o es)
      | _, _ => none
  | .pair (.sym "if") (.pair c (.pair t (.pair e (.sym "nil")))) =>
      match Expr.decode? c, Expr.decode? t, Expr.decode? e with
      | some c, some t, some e => some (.ite c t e)
      | _, _, _ => none
  | .pair (.sym "let") (.pair (.sym x) (.pair e (.pair b (.sym "nil")))) =>
      match Expr.decode? e, Expr.decode? b with
      | some e, some b => some (.let_ x e b)
      | _, _ => none
  | .pair (.sym "call") (.pair (.sym f) (.pair es (.sym "nil"))) =>
      match Expr.decodeList? es with
      | some es => some (.call f es)
      | none => none
  | _ => none
def Expr.decodeList? : Val → Option (List Expr)
  | .sym "nil" => some []
  | .pair e es =>
      match Expr.decode? e, Expr.decodeList? es with
      | some e, some es => some (e :: es)
      | _, _ => none
  | _ => none
end

def symList? : Val → Option (List String)
  | .sym "nil" => some []
  | .pair (.sym x) xs => (symList? xs).map (x :: ·)
  | _ => none

def Program.quoteFn : String × List String × Expr → Val
  | (f, ps, b) => Val.ofList [.sym f, Val.ofList (ps.map .sym), b.quote]

def Program.quote (p : Program) : Val :=
  Val.ofList (p.fns.map Program.quoteFn)

def Program.decodeFns? : Val → Option (List (String × List String × Expr))
  | .sym "nil" => some []
  | .pair (.pair (.sym f) (.pair ps (.pair b (.sym "nil")))) rest =>
      match symList? ps, Expr.decode? b, Program.decodeFns? rest with
      | some ps, some b, some rest => some ((f, ps, b) :: rest)
      | _, _, _ => none
  | _ => none

def Program.decode? (v : Val) : Option Program :=
  (Program.decodeFns? v).map Program.mk

/-! ### Round trip -/

mutual
theorem Expr.decode?_quote : (e : Expr) → Expr.decode? e.quote = some e
  | .var x => by simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?]
  | .lit v => by simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?]
  | .op o es => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Op.ofName?_name, Expr.decodeList?_quoteList es]
  | .ite c t e => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decode?_quote c,
        Expr.decode?_quote t, Expr.decode?_quote e]
  | .let_ x e b => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decode?_quote e, Expr.decode?_quote b]
  | .call f es => by
      simp [Expr.quote, Val.ofList, Val.nil, Expr.decode?, Expr.decodeList?_quoteList es]
theorem Expr.decodeList?_quoteList : (es : List Expr) → Expr.decodeList? (Expr.quoteList es) = some es
  | [] => by simp [Expr.quoteList, Expr.decodeList?, Val.nil]
  | e :: es => by
      simp [Expr.quoteList, Expr.decodeList?, Expr.decode?_quote e, Expr.decodeList?_quoteList es]
end

theorem symList?_ofList (xs : List String) : symList? (Val.ofList (xs.map .sym)) = some xs := by
  induction xs with
  | nil => simp [Val.ofList, Val.nil, symList?]
  | cons x xs ih => simp [Val.ofList, symList?, ih]

theorem Program.decodeFns?_quote (fns : List (String × List String × Expr)) :
    Program.decodeFns? (Val.ofList (fns.map Program.quoteFn)) = some fns := by
  induction fns with
  | nil => simp [Val.ofList, Val.nil, Program.decodeFns?]
  | cons d fns ih =>
    obtain ⟨f, ps, b⟩ := d
    rw [List.map_cons, Val.ofList, Program.quoteFn]
    simp only [Val.ofList, Val.nil, Program.decodeFns?, symList?_ofList, Expr.decode?_quote, ih]

theorem Program.decode?_quote (p : Program) : Program.decode? p.quote = some p := by
  simp [Program.decode?, Program.quote, Program.decodeFns?_quote]

end Diag
