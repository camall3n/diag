import Diag.CertGen
import Diag.Examples

/-!
# M5: tournament

Members with code different from CertBot's (FROM_APP #7), each with its own certificate
from `memberCert`, plus non-members and forged certificates.
-/

namespace Diag.Tournament
open Diag Standard Params Expr

def chkE : Expr := .op .check [.var "cert", .op .subst [.lit Kq, .var "opp"], .lit (.nat F)]

/-- A refactor with two helper functions:
`main = toMove(verify(opp, cert))`, `verify(o, c) = check(c, subst(⌜K⌝, o), F)`,
`toMove(x) = if x then C else D`. -/
def helperBot : Val := (Program.mk [
  ("main", ["opp", "cert"], .call "toMove" [.call "verify" [.var "opp", .var "cert"]]),
  ("verify", ["o", "c"], .op .check [.var "c", .op .subst [.lit Kq, .var "o"], .lit (.nat F)]),
  ("toMove", ["x"], .ite (.var "x") (.lit C) (.lit D))]).quote

/-- Computes `subst` first in a `let`, then the check in another `let`. -/
def letBot : Val := (Program.mk [
  ("main", ["opp", "cert"],
    .let_ "phi" (.op .subst [.lit Kq, .var "opp"])
      (.let_ "ok" (.op .check [.var "cert", .var "phi", .lit (.nat F)])
        (.ite (.var "ok") (.lit C) (.lit D))))]).quote

/-- Swapped branches: `if eq(check(…), false) then D else C`. Certified with `boolCases`. -/
def swapBot : Val := (Program.mk [
  ("main", ["opp", "cert"], .ite (.op .eq [chkE, .lit Val.fls]) (.lit D) (.lit C))]).quote

/-- Not a member: cooperates with CertBot's exact code *without* checking its certificate. -/
def cacheBot : Val := (Program.mk [
  ("main", ["opp", "cert"],
    .ite (.op .eq [.var "opp", .lit certBot]) (.lit C) (.ite chkE (.lit C) (.lit D)))]).quote

/-- Not a member: checks with half the fuel. -/
def stingyBot : Val := (Program.mk [
  ("main", ["opp", "cert"],
    .ite (.op .check [.var "cert", .op .subst [.lit Kq, .var "opp"], .lit (.nat (F / 2))])
      (.lit C) (.lit D))]).quote

def entry (code : Val) : Entry := ⟨code, (memberCert code).quote⟩

def certBotOld : Entry := certBotEntry                    -- the M2 hand-written certificate
def certBotNew : Entry := entry certBot                   -- the generated, smaller one
def helperE : Entry := entry helperBot
def letE : Entry := entry letBot
def swapE : Entry := ⟨swapBot, (swapCert swapBot).quote⟩
def cacheE : Entry := entry cacheBot                      -- generated certificate is rejected
def stingyE : Entry := entry stingyBot                    -- generated certificate is rejected
def defectStolen : Entry := ⟨Examples.defectBot.code, (memberCert certBot).quote⟩
def defectForged : Entry := entry Examples.defectBot.code -- certificate built for DefectBot itself

def entries : List (String × Entry) :=
  [("CertBot(old cert)", certBotOld), ("CertBot(new cert)", certBotNew),
   ("HelperBot", helperE), ("LetBot", letE), ("SwapBot", swapE),
   ("CooperateBot", Examples.cooperateBot), ("DefectBot", Examples.defectBot),
   ("CacheBot", cacheE), ("StingyBot", stingyE),
   ("DefectBot+stolen", defectStolen), ("DefectBot+forged", defectForged)]

/-- Smallest checker fuel (to 1024) at which the certificate is accepted, if ≤ F. -/
def fuelNeeded (e : Entry) : Option Nat :=
  (List.range (F / 1024 + 1)).find? (fun i => check (i * 1024) e.cert (member e.code).quote)
    |>.map (· * 1024)

-- Certificate check results, sizes, and the checker fuel each needs
#eval entries.map fun (n, e) => (n, check F e.cert (member e.code).quote, e.cert.sz, fuelNeeded e)

def showMove : Move → String | .C => "C" | .D => "D"

-- The full pairing matrix: row player's move against each column player
#eval show IO Unit from do
  let t0 ← IO.monoMsNow
  for (n, a) in entries do
    let row := entries.map fun (_, b) => showMove (move T a b)
    IO.println s!"{n}: {row}"
  let t1 ← IO.monoMsNow
  IO.println s!"{entries.length * entries.length} moves in {t1 - t0} ms"

end Diag.Tournament
