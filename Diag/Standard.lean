import Diag.Game

/-!
# The standard K, CertBot, and CertBot's certificate (M2 acceptance test)

K is built with the diagonal construction. `Dfm` has two loose variables, `w` (index 0)
and `z` (index 1). Instantiating `w` with the literal `⌜Dfm⌝` gives `K`, whose only
loose variable is `z`. Inside `K` the term `δ := subst(⌜Dfm⌝, ⌜Dfm⌝)` *evaluates* to
`⌜K⌝` (`diag_eval`), but `K` doesn't contain its own code literally.

  K(z) :≡ ∀y ∀κ. sz y < L+1 → sz κ < Kmax+1 →
            (run(T, z, [y, κ]) = C ↔ check(κ, subst(δ, y), F) = true)
-/

namespace Diag.Standard
open Diag Params

def C : Val := .sym "C"
def D : Val := .sym "D"

private def b (i : Nat) : Tm := .bvar i
private def natT (n : Nat) : Tm := .lit (.nat n)
private def truT : Tm := .lit Val.tru

/-- The formula to diagonalize. Inside the two binders, κ = 0, y = 1, w = 2 and z = 3. -/
def Dfm : Fm :=
  .all (.all (
    .imp (boundFm (b 1) L)
    (.imp (boundFm (b 0) Kmax)
      (Fm.iff (.eq (.run (natT T) (b 3) (Tm.list [b 1, b 0])) (.lit C))
              (.eq (.op3 .check (b 0) (.op2 .subst (.op2 .subst (b 2) (b 2)) (b 1)) (natT F))
                   truT)))))

/-- The standard: one loose variable, z (the agent's own code). -/
def K : Fm := Dfm.inst (.lit Dfm.quote)

/-- The closed term inside K that evaluates to ⌜K⌝. -/
def δ : Tm := .op2 .subst (.lit Dfm.quote) (.lit Dfm.quote)

/-- The diagonal lemma, at the level of codes: δ evaluates to ⌜K⌝. -/
theorem diag_eval : substV Dfm.quote Dfm.quote = K.quote := substV_quote _ _

/-- "The program with code `c` is a member": `K(c)`. -/
def member (c : Val) : Fm := K.inst (.lit c)

/-- The substitution lemma: `subst(⌜K⌝, c) = ⌜K(c)⌝`. -/
theorem subst_K (c : Val) : substV K.quote c = (member c).quote := substV_quote _ _

/-! ## CertBot -/

def Kq : Val := K.quote

/-- `main(opp, cert) = if check(cert, subst(⌜K⌝, opp), F) then C else D`. -/
def certBotProg : Program :=
  ⟨[("main", ["opp", "cert"],
    .ite (.op .check [.var "cert", .op .subst [.lit Kq, .var "opp"], .lit (.nat F)])
      (.lit C) (.lit D))]⟩

def certBot : Val := certBotProg.quote

/-! ## CertBot's certificate, written by hand

The context inside the two `allI`s and two `impI`s is `[A2, A1]` (hypothesis 0 is the
most recent), where `A1 = sz y < L+1` and `A2 = sz κ < Kmax+1`, with κ = `bvar 0`
and y = `bvar 1`. -/

/-- `run(T, CertBot, [y, κ])` -/
def R : Tm := .run (natT T) (.lit certBot) (Tm.list [b 1, b 0])
/-- CertBot's check, with the literal ⌜K⌝ (as in its code). -/
def chkL : Tm := .op3 .check (b 0) (.op2 .subst (.lit Kq) (b 1)) (natT F)
/-- The same check with δ (as in K). -/
def chkD : Tm := .op3 .check (b 0) (.op2 .subst δ (b 1)) (natT F)
/-- What `symRun` should produce for CertBot. -/
def E : Tm := .ite chkL (.lit C) (.lit D)

def topPf : Proof := .impI .fls (.hyp 0)
def symArgs : List (Tm × Nat) := [(b 1, L), (b 0, Kmax)]
/-- `R = E` by symbolic run. `i` and `j` are the positions of A1 and A2 in the context. -/
def symR (i j : Nat) : Proof :=
  .symRun T certBot symArgs (.andI (.hyp i) (.andI (.hyp j) topPf))

/-- `x = C` with the hole at `bvar 0` (context variables shifted by 1). -/
def M2 : Fm := .eq (b 0) (.lit C)
/-- `R = x` -/
def M1 : Fm := .eq (R.shift 1 0) (b 0)
/-- The goal with the hole in place of ⌜K⌝. -/
def M : Fm :=
  Fm.iff (.eq (R.shift 1 0) (.lit C))
    (.eq (.op3 .check (b 1) (.op2 .subst (b 0) (b 2)) (natT F)) truT)

/-- R = C → chkL = true. If chkL ≠ true, then R = E = D, so C = D, which is absurd. -/
def PA : Proof :=
  .impI (.eq R (.lit C)) <|
    .dne <| .impI (Fm.not (.eq chkL truT)) <|
      -- context: [chkL ≠ true, R = C, A2, A1]
      .impE (.evalNe (.lit D) (.lit C))
        (.rw M2 (.iteF (.lit C) (.lit D) (.hyp 0))     -- E = D  turns  E = C  into  D = C
          (.rw M2 (symR 3 2) (.hyp 1)))                -- R = E  turns  R = C  into  E = C

/-- chkL = true → R = C, because R = E = C. -/
def PB : Proof :=
  .impI (.eq chkL truT) <|
    -- context: [chkL = true, A2, A1]
    .rw M1 (.iteT (.lit C) (.lit D) (.hyp 0)) (symR 2 1)   -- E = C  turns  R = E  into  R = C

def certBotCert : Proof :=
  .allI <| .allI <| .impI (boundFm (b 1) L) <| .impI (boundFm (b 0) Kmax) <|
    .rw M (.eval (.lit Kq) δ) (.andI PA PB)    -- ⌜K⌝ = δ: swap the literal for δ

def certBotEntry : Entry := ⟨certBot, certBotCert.quote⟩

end Diag.Standard
