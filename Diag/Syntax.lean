import Diag.Val
import Diag.Op

/-!
# Syntax of the object logic S

Terms and formulas use de Bruijn indices: `bvar i` refers to the i-th enclosing `∀`,
and an index that points past every binder is a *loose* (free) variable. Instantiating
loose variable 0 with a closed literal can't capture anything.

The operator nodes have fixed arity (`op1`/`op2`/`op3`) instead of argument lists, so
`DecidableEq` can be derived and sizes cached (`computed_field`). Formula comparison
is charged by size, which matters because the checker must stay fast on adversarial
certificates.
-/

namespace Diag

inductive Tm where
  | bvar : Nat → Tm
  | lit  : Val → Tm
  | op1  : Op → Tm → Tm
  | op2  : Op → Tm → Tm → Tm
  | op3  : Op → Tm → Tm → Tm → Tm
  | ite  : Tm → Tm → Tm → Tm   -- `then` iff the condition is `sym "true"`
  | run  : Tm → Tm → Tm → Tm   -- run(fuel, code, args); `args` denotes a Lisp list
with
  @[computed_field] size : Tm → Nat
    | .bvar _ => 1
    | .lit v => v.sz + 1
    | .op1 _ a => a.size + 1
    | .op2 _ a b => a.size + b.size + 1
    | .op3 _ a b c => a.size + b.size + c.size + 1
    | .ite a b c => a.size + b.size + c.size + 1
    | .run a b c => a.size + b.size + c.size + 1
deriving DecidableEq, Repr

inductive Fm where
  | eq  : Tm → Tm → Fm
  | fls : Fm
  | imp : Fm → Fm → Fm
  | and : Fm → Fm → Fm
  | all : Fm → Fm             -- binds bvar 0
with
  @[computed_field] size : Fm → Nat
    | .eq a b => a.size + b.size + 1
    | .fls => 1
    | .imp a b => a.size + b.size + 1
    | .and a b => a.size + b.size + 1
    | .all a => a.size + 1
deriving DecidableEq, Repr

namespace Tm

/-- Lisp list of terms: `[t₁, t₂] = pair(t₁, pair(t₂, nil))`. -/
def list : List Tm → Tm
  | [] => .lit Val.nil
  | t :: ts => .op2 .pair t (list ts)

/-- Add `d` to every variable index ≥ `c`. -/
def shift (d c : Nat) : Tm → Tm
  | .bvar i => if i < c then .bvar i else .bvar (i + d)
  | .lit v => .lit v
  | .op1 o a => .op1 o (a.shift d c)
  | .op2 o a b => .op2 o (a.shift d c) (b.shift d c)
  | .op3 o a b e => .op3 o (a.shift d c) (b.shift d c) (e.shift d c)
  | .ite a b e => .ite (a.shift d c) (b.shift d c) (e.shift d c)
  | .run a b e => .run (a.shift d c) (b.shift d c) (e.shift d c)

/-- Replace variable `k` with `s` (lifted past `k` binders) and lower the indices above `k`. -/
def instAt (k : Nat) (s : Tm) : Tm → Tm
  | .bvar i => if i < k then .bvar i else if i = k then s.shift k 0 else .bvar (i - 1)
  | .lit v => .lit v
  | .op1 o a => .op1 o (instAt k s a)
  | .op2 o a b => .op2 o (instAt k s a) (instAt k s b)
  | .op3 o a b e => .op3 o (instAt k s a) (instAt k s b) (instAt k s e)
  | .ite a b e => .ite (instAt k s a) (instAt k s b) (instAt k s e)
  | .run a b e => .run (instAt k s a) (instAt k s b) (instAt k s e)

/-- All variable indices are `< k`. -/
def closedAt (k : Nat) : Tm → Bool
  | .bvar i => decide (i < k)
  | .lit _ => true
  | .op1 _ a => a.closedAt k
  | .op2 _ a b => a.closedAt k && b.closedAt k
  | .op3 _ a b e => a.closedAt k && b.closedAt k && e.closedAt k
  | .ite a b e => a.closedAt k && b.closedAt k && e.closedAt k
  | .run a b e => a.closedAt k && b.closedAt k && e.closedAt k

/-- How many times variable `k` occurs. -/
def occ (k : Nat) : Tm → Nat
  | .bvar i => if i = k then 1 else 0
  | .lit _ => 0
  | .op1 _ a => a.occ k
  | .op2 _ a b => a.occ k + b.occ k
  | .op3 _ a b e => a.occ k + b.occ k + e.occ k
  | .ite a b e => a.occ k + b.occ k + e.occ k
  | .run a b e => a.occ k + b.occ k + e.occ k

/-- The head operation always yields a boolean: `eq`, `lt`, `isPair`, `isNat` (via
`Op.applyPure`), and `check` (a `Val.ofBool`, or `false` for a non-numeric fuel). -/
def isBool : Tm → Bool
  | .op1 .isPair _ | .op1 .isNat _ => true
  | .op2 .eq _ _ | .op2 .lt _ _ => true
  | .op3 .check _ _ _ => true
  | _ => false

end Tm

namespace Fm

def iff (a b : Fm) : Fm := .and (.imp a b) (.imp b a)
def not (a : Fm) : Fm := .imp a .fls
/-- A trivially true formula. -/
def top : Fm := .imp .fls .fls

def shift (d c : Nat) : Fm → Fm
  | .eq a b => .eq (a.shift d c) (b.shift d c)
  | .fls => .fls
  | .imp a b => .imp (a.shift d c) (b.shift d c)
  | .and a b => .and (a.shift d c) (b.shift d c)
  | .all a => .all (a.shift d (c + 1))

def instAt (k : Nat) (s : Tm) : Fm → Fm
  | .eq a b => .eq (Tm.instAt k s a) (Tm.instAt k s b)
  | .fls => .fls
  | .imp a b => .imp (instAt k s a) (instAt k s b)
  | .and a b => .and (instAt k s a) (instAt k s b)
  | .all a => .all (instAt (k + 1) s a)

/-- `φ[s/0]`: instantiate loose variable 0. -/
def inst (φ : Fm) (s : Tm) : Fm := instAt 0 s φ

def occ (k : Nat) : Fm → Nat
  | .eq a b => a.occ k + b.occ k
  | .fls => 0
  | .imp a b => a.occ k + b.occ k
  | .and a b => a.occ k + b.occ k
  | .all a => a.occ (k + 1)

/-- `M` has its hole at variable 0, and the other loose variables are the context. Under a
fresh binder x (variable 0, context at 1…), `M.instKeep t` puts `t` in the hole and keeps
the context variables where they are. -/
def instKeep (M : Fm) (t : Tm) : Fm := (M.shift 1 1).inst t

/-- Base premise of `valInd`: `∀x. isPair(x) = false → M(x)`. -/
def valIndBase (M : Fm) : Fm :=
  .all (.imp (.eq (.op1 .isPair (.bvar 0)) (.lit Val.fls)) M)

/-- Step premise of `valInd`: `∀x. isPair(x) = true → M(fst x) → M(snd x) → M(x)`. -/
def valIndStep (M : Fm) : Fm :=
  .all (.imp (.eq (.op1 .isPair (.bvar 0)) (.lit Val.tru))
    (.imp (M.instKeep (.op1 .fst (.bvar 0))) (.imp (M.instKeep (.op1 .snd (.bvar 0))) M)))

/-- `isNat(x) = true`, with x = variable 0. -/
def isNatFm : Fm := .eq (.op1 .isNat (.bvar 0)) (.lit Val.tru)

/-- Step premise of `natInd`: `∀x. isNat(x) = true → M(x) → M(x + 1)`. -/
def natIndStep (M : Fm) : Fm :=
  .all (.imp isNatFm (.imp M (M.instKeep (.op2 .plus (.bvar 0) (.lit (.nat 1))))))

end Fm

/-! ## Proofs

Natural-deduction proof terms. The checker *infers* each proof's conclusion bottom-up
(`infer` in `Diag/Check.lean`), so no search is ever needed. -/

inductive Proof where
  | hyp     : Nat → Proof                  -- the i-th hypothesis (0 = most recent)
  | impI    : Fm → Proof → Proof           -- assume a, prove b  ⊢ a → b
  | impE    : Proof → Proof → Proof        -- a → b, a ⊢ b
  | andI    : Proof → Proof → Proof
  | andL    : Proof → Proof
  | andR    : Proof → Proof
  | exfalso : Fm → Proof → Proof           -- ⊥ ⊢ φ
  | dne     : Proof → Proof                -- ¬¬φ ⊢ φ
  | allI    : Proof → Proof                -- prove φ for a fresh variable 0 ⊢ ∀φ
  | allE    : Proof → Tm → Proof           -- ∀φ ⊢ φ[t/0]  (any term: terms are total)
  | refl    : Tm → Proof                   -- ⊢ t = t
  | rw      : Fm → Proof → Proof → Proof   -- t = u, M[t/0] ⊢ M[u/0]
  | iteT    : Tm → Tm → Proof → Proof      -- c = true ⊢ ite(c,t,e) = t
  | iteF    : Tm → Tm → Proof → Proof      -- c = true → ⊥ ⊢ ite(c,t,e) = e
  | eval    : Tm → Tm → Proof              -- closed t, u evaluating to equal values ⊢ t = u
  | evalNe  : Tm → Tm → Proof              -- closed t, u evaluating to different values ⊢ t = u → ⊥
  /-- `symRun f code args hyps`: `hyps` proves the size bounds `sz tᵢ < Bᵢ + 1` (see
  `boundsFm`), and the checker symbolically evaluates `code` on the `tᵢ`, concluding
  `run(f, code, [t₁…tₙ]) = e`. -/
  | symRun  : Nat → Val → List (Tm × Nat) → Proof → Proof
  /-- `boolCases t p q`: if `p` proves `t = true → φ` and `q` proves `t = false → φ`, then φ.
  Allowed only when `t.isBool`: its head operation always yields a boolean (FROM_APP #9). -/
  | boolCases : Tm → Proof → Proof → Proof
  /-- `valInd M p q`: structural induction over values. From `p ⊢ Fm.valIndBase M` and
  `q ⊢ Fm.valIndStep M`, infer `∀x. M(x)`. `M` has its hole at variable 0. (M8b-1) -/
  | valInd : Fm → Proof → Proof → Proof
  /-- `natInd M p q`: induction over naturals. From `p ⊢ M(0)` and `q ⊢ Fm.natIndStep M`,
  infer `∀x. isNat(x) = true → M(x)`. (M8b-1) -/
  | natInd : Fm → Proof → Proof → Proof
deriving Repr

/-- `sz t < B + 1`, as an S formula. -/
def boundFm (t : Tm) (B : Nat) : Fm :=
  .eq (.op2 .lt (.op1 .sz t) (.lit (.nat (B + 1)))) (.lit Val.tru)

/-- The conjunction of the size bounds a `symRun` needs, ending in `top`. -/
def boundsFm : List (Tm × Nat) → Fm
  | [] => Fm.top
  | (t, B) :: rest => .and (boundFm t B) (boundsFm rest)

/-! ## Encoding as values -/

open Val in
def Tm.quote : Tm → Val
  | .bvar i => ofList [.sym "bvar", .nat i]
  | .lit v => ofList [.sym "lit", v]
  | .op1 o a => ofList [.sym "op1", .sym o.name, a.quote]
  | .op2 o a b => ofList [.sym "op2", .sym o.name, a.quote, b.quote]
  | .op3 o a b c => ofList [.sym "op3", .sym o.name, a.quote, b.quote, c.quote]
  | .ite a b c => ofList [.sym "ite", a.quote, b.quote, c.quote]
  | .run a b c => ofList [.sym "run", a.quote, b.quote, c.quote]

def Tm.decode? : Val → Option Tm
  | .pair (.sym "bvar") (.pair (.nat i) (.sym "nil")) => some (.bvar i)
  | .pair (.sym "lit") (.pair v (.sym "nil")) => some (.lit v)
  | .pair (.sym "op1") (.pair (.sym o) (.pair a (.sym "nil"))) =>
      match Op.ofName? o, Tm.decode? a with
      | some o, some a => some (.op1 o a)
      | _, _ => none
  | .pair (.sym "op2") (.pair (.sym o) (.pair a (.pair b (.sym "nil")))) =>
      match Op.ofName? o, Tm.decode? a, Tm.decode? b with
      | some o, some a, some b => some (.op2 o a b)
      | _, _, _ => none
  | .pair (.sym "op3") (.pair (.sym o) (.pair a (.pair b (.pair c (.sym "nil"))))) =>
      match Op.ofName? o, Tm.decode? a, Tm.decode? b, Tm.decode? c with
      | some o, some a, some b, some c => some (.op3 o a b c)
      | _, _, _, _ => none
  | .pair (.sym "ite") (.pair a (.pair b (.pair c (.sym "nil")))) =>
      match Tm.decode? a, Tm.decode? b, Tm.decode? c with
      | some a, some b, some c => some (.ite a b c)
      | _, _, _ => none
  | .pair (.sym "run") (.pair a (.pair b (.pair c (.sym "nil")))) =>
      match Tm.decode? a, Tm.decode? b, Tm.decode? c with
      | some a, some b, some c => some (.run a b c)
      | _, _, _ => none
  | _ => none

open Val in
def Fm.quote : Fm → Val
  | .eq a b => ofList [.sym "eq", a.quote, b.quote]
  | .fls => ofList [.sym "fls"]
  | .imp a b => ofList [.sym "imp", a.quote, b.quote]
  | .and a b => ofList [.sym "and", a.quote, b.quote]
  | .all a => ofList [.sym "all", a.quote]

def Fm.decode? : Val → Option Fm
  | .pair (.sym "eq") (.pair a (.pair b (.sym "nil"))) =>
      match Tm.decode? a, Tm.decode? b with
      | some a, some b => some (.eq a b)
      | _, _ => none
  | .pair (.sym "fls") (.sym "nil") => some .fls
  | .pair (.sym "imp") (.pair a (.pair b (.sym "nil"))) =>
      match Fm.decode? a, Fm.decode? b with
      | some a, some b => some (.imp a b)
      | _, _ => none
  | .pair (.sym "and") (.pair a (.pair b (.sym "nil"))) =>
      match Fm.decode? a, Fm.decode? b with
      | some a, some b => some (.and a b)
      | _, _ => none
  | .pair (.sym "all") (.pair a (.sym "nil")) =>
      match Fm.decode? a with
      | some a => some (.all a)
      | none => none
  | _ => none

theorem Tm.decode?_quote : (t : Tm) → Tm.decode? t.quote = some t
  | .bvar i => by simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?]
  | .lit v => by simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?]
  | .op1 o a => by
      simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?, Op.ofName?_name, Tm.decode?_quote a]
  | .op2 o a b => by
      simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?, Op.ofName?_name, Tm.decode?_quote a,
        Tm.decode?_quote b]
  | .op3 o a b c => by
      simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?, Op.ofName?_name, Tm.decode?_quote a,
        Tm.decode?_quote b, Tm.decode?_quote c]
  | .ite a b c => by
      simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?, Tm.decode?_quote a,
        Tm.decode?_quote b, Tm.decode?_quote c]
  | .run a b c => by
      simp [Tm.quote, Val.ofList, Val.nil, Tm.decode?, Tm.decode?_quote a,
        Tm.decode?_quote b, Tm.decode?_quote c]

theorem Fm.decode?_quote : (φ : Fm) → Fm.decode? φ.quote = some φ
  | .eq a b => by simp [Fm.quote, Val.ofList, Val.nil, Fm.decode?, Tm.decode?_quote]
  | .fls => by simp [Fm.quote, Val.ofList, Val.nil, Fm.decode?]
  | .imp a b => by
      simp [Fm.quote, Val.ofList, Val.nil, Fm.decode?, Fm.decode?_quote a, Fm.decode?_quote b]
  | .and a b => by
      simp [Fm.quote, Val.ofList, Val.nil, Fm.decode?, Fm.decode?_quote a, Fm.decode?_quote b]
  | .all a => by simp [Fm.quote, Val.ofList, Val.nil, Fm.decode?, Fm.decode?_quote a]

def tmNatList (l : List (Tm × Nat)) : Val :=
  Val.ofList (l.map fun (t, B) => Val.ofList [t.quote, .nat B])

def tmNatList? : Val → Option (List (Tm × Nat))
  | .sym "nil" => some []
  | .pair (.pair t (.pair (.nat B) (.sym "nil"))) rest =>
      match Tm.decode? t, tmNatList? rest with
      | some t, some rest => some ((t, B) :: rest)
      | _, _ => none
  | _ => none

open Val in
def Proof.quote : Proof → Val
  | .hyp i => ofList [.sym "hyp", .nat i]
  | .impI a p => ofList [.sym "impI", a.quote, p.quote]
  | .impE p q => ofList [.sym "impE", p.quote, q.quote]
  | .andI p q => ofList [.sym "andI", p.quote, q.quote]
  | .andL p => ofList [.sym "andL", p.quote]
  | .andR p => ofList [.sym "andR", p.quote]
  | .exfalso a p => ofList [.sym "exfalso", a.quote, p.quote]
  | .dne p => ofList [.sym "dne", p.quote]
  | .allI p => ofList [.sym "allI", p.quote]
  | .allE p t => ofList [.sym "allE", p.quote, t.quote]
  | .refl t => ofList [.sym "refl", t.quote]
  | .rw m p q => ofList [.sym "rw", m.quote, p.quote, q.quote]
  | .iteT t e p => ofList [.sym "iteT", t.quote, e.quote, p.quote]
  | .iteF t e p => ofList [.sym "iteF", t.quote, e.quote, p.quote]
  | .eval t u => ofList [.sym "eval", t.quote, u.quote]
  | .evalNe t u => ofList [.sym "evalNe", t.quote, u.quote]
  | .symRun f c args p => ofList [.sym "symRun", .nat f, c, tmNatList args, p.quote]
  | .boolCases t p q => ofList [.sym "boolCases", t.quote, p.quote, q.quote]
  | .valInd m p q => ofList [.sym "valInd", m.quote, p.quote, q.quote]
  | .natInd m p q => ofList [.sym "natInd", m.quote, p.quote, q.quote]

def Proof.decode? : Val → Option Proof
  | .pair (.sym "hyp") (.pair (.nat i) (.sym "nil")) => some (.hyp i)
  | .pair (.sym "impI") (.pair a (.pair p (.sym "nil"))) =>
      match Fm.decode? a, Proof.decode? p with
      | some a, some p => some (.impI a p)
      | _, _ => none
  | .pair (.sym "impE") (.pair p (.pair q (.sym "nil"))) =>
      match Proof.decode? p, Proof.decode? q with
      | some p, some q => some (.impE p q)
      | _, _ => none
  | .pair (.sym "andI") (.pair p (.pair q (.sym "nil"))) =>
      match Proof.decode? p, Proof.decode? q with
      | some p, some q => some (.andI p q)
      | _, _ => none
  | .pair (.sym "andL") (.pair p (.sym "nil")) => (Proof.decode? p).map .andL
  | .pair (.sym "andR") (.pair p (.sym "nil")) => (Proof.decode? p).map .andR
  | .pair (.sym "exfalso") (.pair a (.pair p (.sym "nil"))) =>
      match Fm.decode? a, Proof.decode? p with
      | some a, some p => some (.exfalso a p)
      | _, _ => none
  | .pair (.sym "dne") (.pair p (.sym "nil")) => (Proof.decode? p).map .dne
  | .pair (.sym "allI") (.pair p (.sym "nil")) => (Proof.decode? p).map .allI
  | .pair (.sym "allE") (.pair p (.pair t (.sym "nil"))) =>
      match Proof.decode? p, Tm.decode? t with
      | some p, some t => some (.allE p t)
      | _, _ => none
  | .pair (.sym "refl") (.pair t (.sym "nil")) => (Tm.decode? t).map .refl
  | .pair (.sym "rw") (.pair m (.pair p (.pair q (.sym "nil")))) =>
      match Fm.decode? m, Proof.decode? p, Proof.decode? q with
      | some m, some p, some q => some (.rw m p q)
      | _, _, _ => none
  | .pair (.sym "iteT") (.pair t (.pair e (.pair p (.sym "nil")))) =>
      match Tm.decode? t, Tm.decode? e, Proof.decode? p with
      | some t, some e, some p => some (.iteT t e p)
      | _, _, _ => none
  | .pair (.sym "iteF") (.pair t (.pair e (.pair p (.sym "nil")))) =>
      match Tm.decode? t, Tm.decode? e, Proof.decode? p with
      | some t, some e, some p => some (.iteF t e p)
      | _, _, _ => none
  | .pair (.sym "eval") (.pair t (.pair u (.sym "nil"))) =>
      match Tm.decode? t, Tm.decode? u with
      | some t, some u => some (.eval t u)
      | _, _ => none
  | .pair (.sym "evalNe") (.pair t (.pair u (.sym "nil"))) =>
      match Tm.decode? t, Tm.decode? u with
      | some t, some u => some (.evalNe t u)
      | _, _ => none
  | .pair (.sym "symRun") (.pair (.nat f) (.pair c (.pair args (.pair p (.sym "nil"))))) =>
      match tmNatList? args, Proof.decode? p with
      | some args, some p => some (.symRun f c args p)
      | _, _ => none
  | .pair (.sym "boolCases") (.pair t (.pair p (.pair q (.sym "nil")))) =>
      match Tm.decode? t, Proof.decode? p, Proof.decode? q with
      | some t, some p, some q => some (.boolCases t p q)
      | _, _, _ => none
  | .pair (.sym "valInd") (.pair m (.pair p (.pair q (.sym "nil")))) =>
      match Fm.decode? m, Proof.decode? p, Proof.decode? q with
      | some m, some p, some q => some (.valInd m p q)
      | _, _, _ => none
  | .pair (.sym "natInd") (.pair m (.pair p (.pair q (.sym "nil")))) =>
      match Fm.decode? m, Proof.decode? p, Proof.decode? q with
      | some m, some p, some q => some (.natInd m p q)
      | _, _, _ => none
  | _ => none

/-! ## Substitution on encoded formulas (the `subst` primitive) -/

/-- `substV ⌜φ⌝ v = ⌜φ[lit v/0]⌝`; `nil` if the first argument doesn't decode. -/
def substV (φv v : Val) : Val :=
  match Fm.decode? φv with
  | some φ => (φ.inst (.lit v)).quote
  | none => Val.nil

/-- The substitution lemma at the level of codes. -/
theorem substV_quote (φ : Fm) (v : Val) : substV φ.quote v = (φ.inst (.lit v)).quote := by
  simp [substV, Fm.decode?_quote]

end Diag
