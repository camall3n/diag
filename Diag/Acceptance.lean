import Diag.Standard
import Diag.Examples

/-! # M2 acceptance test: CertBot's hand-written certificate, run through the checker -/

namespace Diag.Acceptance
open Diag Standard Params

-- What symRun produces for CertBot, by itself:
#eval (symRunCore F T certBot [⟨.bvar 1, L⟩, ⟨.bvar 0, Kmax⟩]).map (·.1 == E)

-- The certificate's conclusion, compared with the statement K(CertBot):
#eval (infer F [] certBotCert).map (fun (g, _) => g == member certBot)

-- The checker, exactly as CertBot calls it at play time:
#eval check F certBotCert.quote (member certBot).quote

-- Sizes: K, CertBot's code, the certificate, and the statement it proves
#eval (Kq.sz, certBot.sz, certBotCert.quote.sz, (member certBot).quote.sz)

-- The tournament
open Examples in
#eval
  let dB : Entry := ⟨defectBot.code, certBotCert.quote⟩   -- DefectBot with a forged (stolen) certificate
  [ ("CertBot vs CertBot",      play T certBotEntry certBotEntry),
    ("CertBot vs DefectBot",    play T certBotEntry defectBot),
    ("CertBot vs CooperateBot", play T certBotEntry cooperateBot),
    ("CertBot vs DefectBot+stolen cert", play T certBotEntry dB) ]

end Diag.Acceptance
