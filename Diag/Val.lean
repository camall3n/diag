/-!
# Values

S-expressions with a cached size. `sz` is a `computed_field`: logically it is the
structural definition below, and at runtime it is stored in every node, so reading
it is O(1) even for values with heavy sharing. Every value a program builds is kept
below the global cap `Params.V` (see `Diag/Lang.lean`).
-/

namespace Diag

inductive Val where
  | nat  : Nat → Val
  | sym  : String → Val
  | pair : Val → Val → Val
with
  /-- Size of a value. Atoms cost their bit- or character-length, plus 1. -/
  @[computed_field] sz : Val → Nat
    | .nat n    => n.log2 + 1
    | .sym s    => s.length + 1
    | .pair a b => a.sz + b.sz + 1
deriving DecidableEq, Repr

namespace Val

def tru : Val := .sym "true"
def fls : Val := .sym "false"
def nil : Val := .sym "nil"
def ofBool (b : Bool) : Val := if b then tru else fls

/-- Lisp-style list: `[a, b] = pair a (pair b nil)`. -/
def ofList : List Val → Val
  | []      => nil
  | v :: vs => .pair v (ofList vs)

theorem sz_pos (v : Val) : 0 < v.sz := by
  cases v <;> simp [sz]

partial def toStr : Val → String
  | .nat n => toString n
  | .sym s => s
  | .pair a b =>
    let rec tail : Val → String
      | .sym "nil" => ")"
      | .pair x y => " " ++ toStr x ++ tail y
      | v => " . " ++ toStr v ++ ")"
    "(" ++ toStr a ++ tail b

instance : ToString Val := ⟨toStr⟩

end Val
end Diag
