import Diag.Standard

/-!
# M5: smaller certificates, generated for any K-member whose code symbolically
# evaluates to `ite(check(κ, subst(⌜K⌝, y), F), C, D)`

FROM_APP #6/#7, option (a). The reasoning is factored into a small generic lemma

  L1 :≡ ∀k ∀k' ∀x. k = k' → x = ite(chk(k), C, D) → (x = C ↔ chk(k') = true)
  where chk(z) := check(κ, subst(z, y), F),

proved once with no large literals. It is then instantiated with k := ⌜K⌝ (literal),
k' := δ and x := run(T, code, [y, κ]), and discharged with `eval(⌜K⌝ = δ)` and `symRun`.
Each large literal appears exactly once.

This is untrusted: it only builds a `Proof`, and the checker decides.
-/

namespace Diag.Standard
open Diag Params

/-- `check(κ, subst(z, y), F)` -/
def chkAt (κ y z : Tm) : Tm := .op3 .check κ (.op2 .subst z y) (natT F)
def iteCD (c : Tm) : Tm := .ite c (.lit C) (.lit D)

/-! Inside L1 (under the outer y = 1, κ = 0 and its own three binders):
k = 2, k' = 1, x = 0, κ = 3, y = 4. -/

def L1body : Fm :=
  .imp (.eq (b 2) (b 1))
    (.imp (.eq (b 0) (iteCD (chkAt (b 3) (b 4) (b 2))))
      (Fm.iff (.eq (b 0) (.lit C)) (.eq (chkAt (b 3) (b 4) (b 1)) truT)))

/-- `x = ite(chk(k'), C, D)` from hypotheses `k = k'` (index i) and `x = ite(chk(k), C, D)`
(index j). The motive's hole is variable 0, so every other variable shifts by 1. -/
def hxE (i j : Nat) : Proof :=
  .rw (.eq (b 1) (iteCD (chkAt (b 4) (b 5) (b 0)))) (.hyp i) (.hyp j)

def chk' : Tm := chkAt (b 3) (b 4) (b 1)

/-- x = C → chk(k') = true -/
def L1PA : Proof :=
  .impI (.eq (b 0) (.lit C)) <|
    .dne <| .impI (Fm.not (.eq chk' truT)) <|
      -- context: [chk' ≠ true, x = C, x = E_k, k = k', …]
      .impE (.evalNe (.lit D) (.lit C))
        (.rw (.eq (b 0) (.lit C)) (.iteF (.lit C) (.lit D) (.hyp 0))
          (.rw (.eq (b 0) (.lit C)) (hxE 3 2) (.hyp 1)))

/-- chk(k') = true → x = C -/
def L1PB : Proof :=
  .impI (.eq chk' truT) <|
    -- context: [chk' = true, x = E_k, k = k', …]
    .rw (.eq (b 1) (b 0)) (.iteT (.lit C) (.lit D) (.hyp 0)) (hxE 2 1)

def L1pf : Proof :=
  .allI <| .allI <| .allI <|
    .impI (.eq (b 2) (b 1)) <| .impI (.eq (b 0) (iteCD (chkAt (b 3) (b 4) (b 2)))) <|
      .andI L1PA L1PB

/-- The membership certificate built from a generic lemma `lem` (shaped like L1), for a
standard whose code literal is `kq` and whose diagonal term is `d` (`eval` proves
`kq = d`). -/
def memberCertWith (lem : Proof) (kq : Val) (d : Tm) (code : Val) : Proof :=
  .allI <| .allI <| .impI (boundFm (b 1) L) <| .impI (boundFm (b 0) Kmax) <|
    .impE
      (.impE
        (.allE (.allE (.allE lem (.lit kq)) d)
          (.run (natT T) (.lit code) (Tm.list [b 1, b 0])))
        (.eval (.lit kq) d))
      (.symRun T code symArgs (.andI (.hyp 1) (.andI (.hyp 0) topPf)))

/-- The membership certificate for any `code` whose `symRun` gives
`ite(check(κ, subst(⌜K⌝, y), F), C, D)`. -/
def memberCert (code : Val) : Proof := memberCertWith L1pf Kq δ code

/-! ## Swapped branches: `if eq(check(…), false) then D else C` (uses `boolCases`)

  L2 :≡ ∀k ∀k' ∀x. k = k' → x = ite(eq(chk(k), false), D, C) → (x = C ↔ chk(k') = true) -/

def fT : Tm := .lit Val.fls
def iteSw (c : Tm) : Tm := .ite (.op2 .eq c fT) (.lit D) (.lit C)

def hxE2 (i j : Nat) : Proof :=
  .rw (.eq (b 1) (iteSw (chkAt (b 4) (b 5) (b 0)))) (.hyp i) (.hyp j)

/-- `eq(chk', false) = true` from `chk' = false` (hypothesis 0). -/
def eqFalsePf : Proof :=
  -- symmetry: false = chk'
  let symPf : Proof := .rw (.eq (b 0) (chk'.shift 1 0)) (.hyp 0) (.refl chk')
  .rw (.eq (.op2 .eq (b 0) fT) truT) symPf (.eval (.op2 .eq fT fT) truT)

/-- x = C → chk(k') = true, by cases on the boolean chk(k'). -/
def L2PA : Proof :=
  .impI (.eq (b 0) (.lit C)) <|
    .boolCases chk' (.impI (.eq chk' truT) (.hyp 0)) <|
      .impI (.eq chk' fT) <|
        -- context: [chk' = false, x = C, x = E_k, k = k', …]
        .exfalso (.eq chk' truT) <|
          .impE (.evalNe (.lit D) (.lit C))
            (.rw (.eq (b 0) (.lit C)) (.iteT (.lit D) (.lit C) eqFalsePf)   -- E' = D
              (.rw (.eq (b 0) (.lit C)) (hxE2 3 2) (.hyp 1)))                -- E' = C

/-- chk(k') = true → x = C, because then eq(chk', false) is not true. -/
def L2PB : Proof :=
  .impI (.eq chk' truT) <|
    -- context: [chk' = true, x = E_k, k = k', …]
    let notE : Proof :=
      .impI (.eq (.op2 .eq chk' fT) truT) <|
        .impE (.evalNe (.op2 .eq truT fT) truT)
          (.rw (.eq (.op2 .eq (b 0) fT) truT) (.hyp 1) (.hyp 0))
    .rw (.eq (b 1) (b 0)) (.iteF (.lit D) (.lit C) notE) (hxE2 2 1)

def L2pf : Proof :=
  .allI <| .allI <| .allI <|
    .impI (.eq (b 2) (b 1)) <| .impI (.eq (b 0) (iteSw (chkAt (b 3) (b 4) (b 2)))) <|
      .andI L2PA L2PB

def swapCert (code : Val) : Proof := memberCertWith L2pf Kq δ code

end Diag.Standard
