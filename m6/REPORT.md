# M6 report: LLM-generated candidates (generator: Claude Code)

Every verdict below is the trusted checker's (`lake exe diagcheck`), copied unedited.
Reasons come from the untrusted `diagnose` (explanations only).

- Members certified: **8/8** (6/8 on the first attempt)
- Adversarial candidates accepted: **0/6** (attempts in total: 7)

| candidate | intent | std | attempts | final verdict | cert size | proof nodes | checker fuel | self-play | vs CertBot | vs CertBot′ | vs CooperateBot | vs DefectBot |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a1_defect_vs_certbot | adversarial | K | 2 | rejected | 33285 | 47 |  | D | D/D | D/D | D/C | D/D |
| a2_time_waster | adversarial | K | 1 | rejected | 50122 | 32 |  | D | D/D | D/D | D/C | D/D |
| a3_coop_claims_K | adversarial | K | 1 | rejected | 4732 | 18 |  | C | C/D | C/D | C/C | C/D |
| a4_reflection_KP | adversarial | KP | 1 | rejected | 1935 | 14 |  | D | D/D | D/D | D/C | D/D |
| a5_exploit_certbotP | adversarial | KP | 1 | rejected | 17815 | 20 |  | D | D/D | D/D | C/C | D/D |
| a6_stolen_statement | adversarial | K | 1 | rejected | 48838 | 32 |  | D | D/D | D/D | D/C | D/D |
| m01_helper_chain | member | K | 1 | ACCEPTED | 50074 | 32 | 169231 | C | C/C | D/D | D/C | D/D |
| m02_let_first | member | K | 1 | ACCEPTED | 49198 | 32 | 166302 | C | C/C | D/D | D/C | D/D |
| m03_swapped | member | K | 2 | ACCEPTED | 25392 | 59 | 108474 | C | C/C | D/D | D/C | D/D |
| m04_extra_work | member | K | 1 | ACCEPTED | 49612 | 32 | 167690 | C | C/C | D/D | D/C | D/D |
| m05_computed_fuel | member | K | 1 | ACCEPTED | 49366 | 32 | 166920 | C | C/C | D/D | D/C | D/D |
| m06_ispair_guard | member | K | 2 | ACCEPTED | 48153 | 72 | 184822 | C | C/C | D/D | D/C | D/D |
| p01_respond_helper | member | KP | 1 | ACCEPTED | 12367 | 20 | 40405 | C | D/D | C/C | C/C | D/D |
| p02_nil_generous | member | KP | 1 | ACCEPTED | 26187 | 41 | 78343 | C | D/D | C/C | C/C | C/D |

Moves are shown as (candidate's move)/(opponent's move).

## Every attempt, with the checker's reason for each rejection

- **a1_defect_vs_certbot** (plays like a member but defects against CertBot exactly; tries the member proof template)
  - v1: rejected: entry over the size caps: code 9172 (cap 16384), cert 76552 (cap 65536); checker verdict on the certificate alone: false
  - v2: rejected: rule `mp` rejected; premises prove: [(run(1048576, <literal, size 9172>, pair(#1, pair(#0, nil))) = ite(check(#0, subst(<literal, size 4373>, #1), 262144), C, D) → ((run(1048576, <literal, size 9172>, pair(#1, pair(#0, nil))) = C → check(#0, subst(subst(<literal, size 877>, <literal, size 877>), #1), 262144) = true) ∧ (check(#0, subst(subst(<literal, size 877>, <literal, size 877>), #1), 262144) =
- **a2_time_waster** (spins in a long concrete loop first, so in real play it runs out of fuel and defects against members)
  - v1: rejected: rule `sym-run` rejected (symbolic run of the code failed: unsupported shape, recursion on symbolic data, or cost bound > 1048576); premises prove: [(lt(sz(#1), 16385) = true ∧ (lt(sz(#0), 65537) = true ∧ (⊥ → ⊥)))]
- **a3_coop_claims_K** (CooperateBot (cooperates with everyone) claiming K-membership by evaluating the open check term)
  - v1: rejected: rule `eval` rejected (terms not closed, evaluation failed, or the values don't match the rule); premises prove: []
- **a4_reflection_KP** (DefectBot claims K-prime by rewriting with the opponent certificate hypothesis (a reflection-style shortcut))
  - v1: rejected: rule `rw` rejected; premises prove: [check(#0, subst(subst(<literal, size 546>, <literal, size 546>), #1), 262144) = true; run(1048576, <literal, size 44>, pair(#1, pair(#0, nil))) = D]
- **a5_exploit_certbotP** (K-prime look-alike that defects against CertBot-prime despite its valid certificate)
  - v1: rejected: rule `mp` rejected; premises prove: [(run(1048576, <literal, size 3690>, pair(#1, pair(#0, nil))) = ite(check(#0, subst(<literal, size 1632>, #1), 262144), C, D) → run(1048576, <literal, size 3690>, pair(#1, pair(#0, nil))) = C); run(1048576, <literal, size 3690>, pair(#1, pair(#0, nil))) = ite(eq(#1, <literal, size 1812>), D, ite(check(#0, subst(<literal, size 1632>, #1), 262144), C, D))]
- **a6_stolen_statement** (DefectBot submits a valid proof that CertBot (not itself) is a member)
  - v1: rejected: the proof is valid but proves a different statement: ∀.∀.(lt(sz(#1), 16385) = true → (lt(sz(#0), 65537) = true → ((run(1048576, <literal, size 4553>, pair(#1, pair(#0, nil))) = C → check(#0, subst(subst(<literal, size 877>, <literal, size 877>), #1), 262144) = true) ∧ (check(#0, subst(subst(<literal, size 877>, <literal, size 877>), #1), 262144) = true → run(1048576, <literal, size 4553>, pair(#1,
- **m01_helper_chain** (three-level helper chain: main -> decide -> verify/toMove)
  - v1: ACCEPTED
- **m02_let_first** (computes the check into a let-bound flag before branching)
  - v1: ACCEPTED
- **m03_swapped** (swapped branches: if eq(check, false) then D else C (needs bool-cases))
  - v1: rejected: entry over the size caps: code 4588 (cap 16384), cert 76437 (cap 65536); checker verdict on the certificate alone: true
  - v2: ACCEPTED
- **m04_extra_work** (does unused bookkeeping (opponent size, a pair) before deciding)
  - v1: ACCEPTED
- **m05_computed_fuel** (computes the checker fuel with a helper (twice 131072) instead of the literal @F)
  - v1: ACCEPTED
- **m06_ispair_guard** (branches on isPair(opp) first, then checks in both branches (needs bool-cases on isPair))
  - v1: rejected: entry over the size caps: code 9121 (cap 16384), cert 131618 (cap 65536); checker verdict on the certificate alone: false
  - v2: ACCEPTED
- **p01_respond_helper** (K-prime member: cautious, with a respond helper)
  - v1: ACCEPTED
- **p02_nil_generous** (K-prime member that also cooperates with anyone presenting a nil certificate (generous, allowed by K-prime))
  - v1: ACCEPTED

## Round robin (final attempts of all candidates, plus the reference entries)

Row's move against each column. Entries marked `LLM:` are LLM-generated.

| | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0. LLM:a1_defect_vs_certbot | D | D | D | D | D | D | C | C | C | C | C | C | D | D | D | D | D | D |
| 1. LLM:a2_time_waster | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D |
| 2. LLM:a3_coop_claims_K | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C |
| 3. LLM:a4_reflection_KP | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D |
| 4. LLM:a5_exploit_certbotP | D | D | D | D | D | D | D | D | D | D | D | D | C | C | D | D | C | D |
| 5. LLM:a6_stolen_statement | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D |
| 6. LLM:m01_helper_chain | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 7. LLM:m02_let_first | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 8. LLM:m03_swapped | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 9. LLM:m04_extra_work | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 10. LLM:m05_computed_fuel | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 11. LLM:m06_ispair_guard | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 12. LLM:p01_respond_helper | D | D | D | D | D | D | D | D | D | D | D | D | C | C | D | C | C | D |
| 13. LLM:p02_nil_generous | D | D | D | D | D | D | D | D | D | D | D | D | C | C | D | C | C | C |
| 14. CertBot | D | D | D | D | D | D | C | C | C | C | C | C | D | D | C | D | D | D |
| 15. CertBotP | D | D | D | D | D | D | D | D | D | D | D | D | C | C | D | C | C | D |
| 16. CooperateBot | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C |
| 17. DefectBot | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D | D |
