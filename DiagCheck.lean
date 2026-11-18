import Diag

/-!
# `diagcheck`: the M6 runner (trusted verdicts, untrusted explanations)

    lake exe diagcheck <candidate.sexp> <K|KP>

The candidate file holds `(program …)` and `(proof …)` as S-expression data. The runner
compiles them, takes the statement K(@self) or K′(@self), and asks the one `check`.
It prints one JSON object: the verdict, the sizes, the minimum checker fuel, a reason
for any rejection (from `diagnose`, which explains but never decides), and the
candidate's moves against the reference entries.
-/

open Diag Diag.Front Diag.Standard Diag.Params

def jstr (s : String) : String :=
  "\"" ++ ((s.replace "\\" "\\\\").replace "\"" "\\\"" |>.replace "\n" " ") ++ "\""

def statement : String → Val → Option Fm
  | "K", c => some (member c)
  | "KP", c => some (memberP c)
  | _, _ => none

/-- Smallest checker fuel ≤ F that accepts (binary search). -/
def fuelNeeded (cert φ : Val) : Option Nat :=
  if !check F cert φ then none else
  let rec go (lo hi : Nat) : Nat → Nat
    | 0 => hi
    | n + 1 =>
      if hi ≤ lo + 1 then hi
      else
        let mid := (lo + hi) / 2
        if check mid cert φ then go lo mid n else go mid hi n
  some (go 0 F 64)

def proofNodes : Proof → Nat
  | .hyp _ | .refl _ | .eval _ _ | .evalNe _ _ => 1
  | .impI _ p | .andL p | .andR p | .exfalso _ p | .dne p | .allI p | .allE p _
  | .iteT _ _ p | .iteF _ _ p | .symRun _ _ _ p => proofNodes p + 1
  | .impE p q | .andI p q | .rw _ p q | .boolCases _ p q | .valInd _ p q | .natInd _ p q =>
    proofNodes p + proofNodes q + 1

def refs : List (String × Entry) :=
  [("CertBot", ⟨certBot, (memberCert certBot).quote⟩),
   ("CertBotP", ⟨certBotP, (certPCert certBotP).quote⟩),
   ("CooperateBot", ⟨Examples.cooperateBot.code, (coopCertP Examples.cooperateBot.code).quote⟩),
   ("DefectBot", Examples.defectBot)]

def mv : Move → String | .C => "C" | .D => "D"

def process (src std : String) : Except String String := do
  let forms ← read src
  let progSX ← match forms.find? (fun | .list (.atom "program" :: _) => true | _ => false) with
    | some p => pure p
    | none => throw "no (program …) form"
  let pfSX ← match forms.find? (fun | .list [.atom "proof", _] => true | _ => false) with
    | some (.list [_, p]) => pure p
    | _ => throw "no (proof …) form"
  let prog ← compileProgram progSX
  let code := prog.quote
  let φ ← match statement std code with
    | some φ => pure φ
    | none => throw s!"unknown standard {std}"
  let pf ← compilePf [] [] code pfSX
  let cert := pf.quote
  let e : Entry := ⟨code, cert⟩
  -- Certified = the checker accepts AND the entry is within the caps (Theorems A/B need both).
  let checkerAccepts := check F cert φ.quote
  let accepted := checkerAccepts && e.ok
  let reason : String :=
    if accepted then ""
    else if !e.ok then s!"entry over the size caps: code {code.sz} (cap {L}), cert {cert.sz} (cap {Kmax}); checker verdict on the certificate alone: {checkerAccepts}"
    else match diagnose [] pf with
      | some msg => msg
      | none => match infer bigFuel [] pf with
        | some (g, _) =>
          if g = φ then s!"checker fuel F = {F} exhausted"
          else s!"the proof is valid but proves a different statement: {showFm g}"
        | none => "rejected"
  let fuel := match fuelNeeded cert φ.quote with | some n => toString n | none => "null"
  let moves := refs.map fun (n, r) =>
    s!"{jstr n}: {jstr (mv (move T e r) ++ "/" ++ mv (move T r e))}"
  let selfPlay := mv (move T e e)
  return "{" ++ ", ".intercalate [
    s!"\"status\": \"ok\"", s!"\"standard\": {jstr std}",
    s!"\"accepted\": {accepted}", s!"\"checker_accepts\": {checkerAccepts}", s!"\"within_caps\": {e.ok}", s!"\"code_size\": {code.sz}", s!"\"cert_size\": {cert.sz}",
    s!"\"proof_nodes\": {proofNodes pf}", s!"\"fuel_needed\": {fuel}", s!"\"reason\": {jstr reason}",
    s!"\"self_play\": {jstr selfPlay}",
    "\"moves\": {" ++ ", ".intercalate moves ++ "}"] ++ "}"

/-- Compile a candidate file to an entry (play doesn't depend on the standard). -/
def loadEntry (src : String) : Except String Entry := do
  let forms ← read src
  let progSX ← match forms.find? (fun | .list (.atom "program" :: _) => true | _ => false) with
    | some p => pure p
    | none => throw "no (program …) form"
  let pfSX ← match forms.find? (fun | .list [.atom "proof", _] => true | _ => false) with
    | some (.list [_, p]) => pure p
    | _ => throw "no (proof …) form"
  let code := (← compileProgram progSX).quote
  return ⟨code, (← compilePf [] [] code pfSX).quote⟩

def main (args : List String) : IO UInt32 := do
  match args with
  | "--tournament" :: files =>
    let mut es : Array (String × Entry) := #[]
    for f in files do
      match loadEntry (← IO.FS.readFile f) with
      | .ok e => es := es.push ("LLM:" ++ ((f.splitOn "/").reverse.getD 1 f), e)
      | .error _ => pure ()
    let all := es ++ refs.toArray
    let rows := all.toList.map fun (n, a) =>
      jstr n ++ ": [" ++ ", ".intercalate (all.toList.map fun (_, b) => jstr (mv (move T a b))) ++ "]"
    IO.println ("{\"names\": [" ++ ", ".intercalate (all.toList.map (jstr ·.1)) ++ "], \"rows\": {" ++
      ", ".intercalate rows ++ "}}")
    return 0
  | [file, std] =>
    let src ← IO.FS.readFile file
    match process src std with
    | .ok json => IO.println json; return 0
    | .error e =>
      IO.println ("{\"status\": \"compile_error\", \"accepted\": false, \"reason\": " ++ jstr e ++ "}")
      return 0
  | _ => IO.eprintln "usage: diagcheck <candidate.sexp> <K|KP>"; return 1
