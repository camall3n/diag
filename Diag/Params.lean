/-!
# Global constants of the standard

Provisional values; the fuel-consistency lemma (M4/M5) will pin down `T`.
-/
namespace Diag.Params

/-- Cap on the size of an entry's code. -/
def L : Nat := 2 ^ 14
/-- Cap on the size of an entry's certificate. -/
def Kmax : Nat := 2 ^ 16
/-- Fuel for one move. -/
def T : Nat := 2 ^ 20

/-- Fuel for one `check` in the standard K. -/
def F : Nat := 2 ^ 18

end Diag.Params
