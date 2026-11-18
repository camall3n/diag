import Diag.CertGen

/-!
# The one-way standard K′ (FROM_APP #8, #9)

  K′(z) :≡ ∀y ∀κ. sz y < L+1 → sz κ < Kmax+1 →
             check(κ, subst(δ′, y), F) = true → run(T, z, [y, κ]) = C

"If an opponent's certificate checks as a proof that it meets K′, I cooperate."
Built with `diag` exactly like K. The binders mirror `Dfm`: κ = 0, y = 1, w = 2, z = 3.

Also defined here is the cautiousness formula KC (for the certified Theorem B′), and the
certificates for CooperateBot and CertBot′.
-/

namespace Diag.Standard
open Diag Params

def DfmP : Fm :=
  .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
    (.imp (.eq (.op3 .check (b 0) (.op2 .subst (.op2 .subst (b 2) (b 2)) (b 1)) (natT F)) truT)
          (.eq (.run (natT T) (b 3) (Tm.list [b 1, b 0])) (.lit C))))))

def KP : Fm := DfmP.inst (.lit DfmP.quote)
def δP : Tm := .op2 .subst (.lit DfmP.quote) (.lit DfmP.quote)
def KPq : Val := KP.quote

theorem diagP_eval : substV DfmP.quote DfmP.quote = KP.quote := substV_quote _ _

def memberP (c : Val) : Fm := KP.inst (.lit c)

theorem subst_KP (c : Val) : substV KP.quote c = (memberP c).quote := substV_quote _ _

/-- CertBot′: `main(opp, cert) = if check(cert, subst(⌜K′⌝, opp), F) then C else D`. -/
def certBotP : Val := (Program.mk [("main", ["opp", "cert"],
  .ite (.op .check [.var "cert", .op .subst [.lit KPq, .var "opp"], .lit (.nat F)])
    (.lit C) (.lit D))]).quote

/-- **KC, cautiousness:** "I cooperate *exactly* when the opponent's K′-certificate checks."
KC refers to ⌜K′⌝ as a literal and never to its own code, so it needs no diagonalization
of its own. Its ← direction is K′(z), and its → direction is cautiousness. -/
def DC : Fm :=
  .all (.all (.imp (boundFm (b 1) L) (.imp (boundFm (b 0) Kmax)
    (Fm.iff (.eq (.run (natT T) (b 2) (Tm.list [b 1, b 0])) (.lit C))
            (.eq (chkAt (b 0) (b 1) (.lit KPq)) truT)))))

def memberC (c : Val) : Fm := DC.inst (.lit c)

/-! ## Certificates -/

/-- K′ certificate for an agent whose `symRun` gives `run = C` outright (CooperateBot). -/
def coopCertP (code : Val) : Proof :=
  .allI <| .allI <| .impI (boundFm (b 1) L) <| .impI (boundFm (b 0) Kmax) <|
    .impI (.eq (chkAt (b 0) (b 1) δP) truT) <|
      .symRun T code symArgs (.andI (.hyp 2) (.andI (.hyp 1) topPf))

/-- K′ certificate for a CertBot′-shaped agent: the ← half of the generic lemma L1. -/
def certPCert (code : Val) : Proof :=
  .allI <| .allI <| .impI (boundFm (b 1) L) <| .impI (boundFm (b 0) Kmax) <|
    .andR <|
      .impE
        (.impE
          (.allE (.allE (.allE L1pf (.lit KPq)) δP)
            (.run (natT T) (.lit code) (Tm.list [b 1, b 0])))
          (.eval (.lit KPq) δP))
        (.symRun T code symArgs (.andI (.hyp 1) (.andI (.hyp 0) topPf)))

/-- KC (cautiousness) certificate for a CertBot′-shaped agent. -/
def cautiousCert (code : Val) : Proof := memberCertWith L1pf KPq (.lit KPq) code

end Diag.Standard
