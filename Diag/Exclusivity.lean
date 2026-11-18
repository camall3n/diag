import Diag.TheoremsP
import Diag.Examples

/-!
# M7: exclusivity: K is closed, K′ is open (FROM_APP #10)

Given a K′-certified CooperateBot (its certificate within the caps), **no** code
satisfies both K and K′. The proof:
1. CooperateBot is not a K-member: against DefectBot with the certificate `nil` it plays C,
   but `check` rejects `nil` (it doesn't decode as a proof). This is shown by unfolding `check`.
2. If `c` met K′, then with CooperateBot's K′ certificate, `c` cooperates with CooperateBot.
3. If `c` also met K, then CooperateBot's certificate would check as a proof of
   K(CooperateBot), and by soundness CooperateBot would be a K-member, contradicting 1.
No `native_decide`; concrete facts are proved by unfolding.
-/

namespace Diag
open Standard Params

abbrev coopCode : Val := Examples.cooperateBot.code

/-- `nil` is never accepted: it doesn't decode as a proof. -/
theorem check_nil (f : Nat) (φ : Val) : check f Val.nil φ = false := by
  unfold check
  split
  · have : Proof.decode? Val.nil = none := by simp [Val.nil, Proof.decode?]
    simp [this]
  · rfl

/-- CooperateBot plays C against everyone, with fuel T. -/
theorem run_coop (y κ : Val) : run T coopCode [y, κ] = some C :=
  Examples.run_constBot C T y κ (by decide)

/-- Step 1: CooperateBot is not a K-member. -/
theorem coop_not_member (ρ : Nat → Val) : ¬ (member coopCode).denote ρ := by
  intro h
  have hK := (member_denote coopCode ρ).mp h Examples.defectBot.code Val.nil (by decide) (by decide)
  rw [run_coop, check_nil] at hK
  simp at hK

/-- **Exclusivity.** If CooperateBot has a K′ certificate that checks and is within the
cap, then no code `c` (in or out of the caps) satisfies both K and K′. -/
theorem exclusivity (κco : Val) (hsz : κco.sz ≤ Kmax)
    (hco : check F κco (memberP coopCode).quote = true)
    (c : Val) (ρ : Nat → Val) : ¬ ((member c).denote ρ ∧ (memberP c).denote ρ) := by
  rintro ⟨hK, hKP⟩
  -- Step 2: by K′, c cooperates with CooperateBot (whose K′ certificate checks)
  have hC : (run T c [coopCode, κco]).getD Val.bot = C :=
    (memberP_denote c ρ).mp hKP coopCode κco (by decide) hsz hco
  -- Step 3: by K, CooperateBot's certificate then checks as a proof of K(CooperateBot)
  have hchk : check F κco (member coopCode).quote = true :=
    ((member_denote c ρ).mp hK coopCode κco (by decide) hsz).mp hC
  exact coop_not_member ρ (check_member_sound F κco coopCode hchk ρ)

/-- The same statement about entries: a K′-certified CooperateBot entry within the caps
rules out any code being both a K-member and a K′-member. -/
theorem exclusivity_entry (e : Entry) (hcode : e.code = coopCode) (hok : e.ok = true)
    (hcert : CertifiedP e) (c : Val) (ρ : Nat → Val) :
    ¬ ((member c).denote ρ ∧ (memberP c).denote ρ) := by
  obtain ⟨-, hsz⟩ := (Entry.ok_iff e).mp hok
  unfold CertifiedP at hcert
  rw [hcode] at hcert
  exact exclusivity e.cert hsz hcert c ρ

-- The hypothesis is met in practice (runtime check, not a meta-theorem):
#eval check F (coopCertP coopCode).quote (memberP coopCode).quote
#eval decide ((coopCertP coopCode).quote.sz ≤ Kmax)

#print axioms Diag.check_nil
#print axioms Diag.coop_not_member
#print axioms Diag.exclusivity
#print axioms Diag.exclusivity_entry

end Diag
