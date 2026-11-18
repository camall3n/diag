import Diag.Tournament
import Diag.StandardP

/-!
# Tournament with both standards (FROM_APP #8, #9)

The game is the same for both standards. A standard only determines which statement a
player checks the opponent's certificate against. K-members check `member` (K);
K′-members check `memberP` (K′).
-/

namespace Diag.TournamentP
open Diag Standard Params Tournament

def certBotPE : Entry := ⟨certBotP, (certPCert certBotP).quote⟩
def coopPE : Entry := ⟨Examples.cooperateBot.code, (coopCertP Examples.cooperateBot.code).quote⟩
def defectForgedP : Entry := ⟨Examples.defectBot.code, (coopCertP Examples.defectBot.code).quote⟩

def entriesP : List (String × Entry) :=
  [("CertBot (K)", certBotNew), ("HelperBot (K)", helperE), ("SwapBot (K)", swapE),
   ("CertBot′ (K′)", certBotPE), ("CooperateBot (K′ cert)", coopPE),
   ("DefectBot", Examples.defectBot), ("DefectBot+forged K′", defectForgedP)]

-- Which certificates check: (under K, under K′), plus the size
#eval entriesP.map fun (n, e) =>
  (n, check F e.cert (member e.code).quote, check F e.cert (memberP e.code).quote, e.cert.sz)

-- CertBot′'s cautiousness certificate (KC), checked offline for Theorem B′
#eval check F (cautiousCert certBotP).quote (memberC certBotP).quote

#eval show IO Unit from do
  for (n, a) in entriesP do
    let row := entriesP.map fun (_, b) => showMove (move T a b)
    IO.println s!"{n}: {row}"

end Diag.TournamentP
