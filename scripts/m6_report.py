#!/usr/bin/env python3
"""Build m6/REPORT.md from m6/results.json (verdicts are copied as recorded, never edited)
and a round-robin tournament of every candidate's final attempt against the references."""
import json, subprocess, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
LAKE = str(pathlib.Path.home() / ".elan/bin/lake")
res = json.loads((ROOT / "m6/results.json").read_text())

lines = ["# M6 report: LLM-generated candidates (generator: Claude Code)", "",
         "Every verdict below is the trusted checker's (`lake exe diagcheck`), copied unedited.",
         "Reasons come from the untrusted `diagnose` (explanations only).", ""]
mem = {k: v for k, v in res.items() if v["spec"]["intent"] == "member"}
adv = {k: v for k, v in res.items() if v["spec"]["intent"] == "adversarial"}
acc = [k for k, v in mem.items() if v["attempts"] and v["attempts"][-1].get("accepted")]
first = [k for k, v in mem.items() if v["attempts"] and v["attempts"][0].get("accepted")]
adv_acc = [k for k, v in adv.items() if any(a.get("accepted") for a in v["attempts"])]
lines += [f"- Members certified: **{len(acc)}/{len(mem)}** ({len(first)}/{len(mem)} on the first attempt)",
          f"- Adversarial candidates accepted: **{len(adv_acc)}/{len(adv)}** (attempts in total: "
          f"{sum(len(v['attempts']) for v in adv.values())})", ""]

lines += ["| candidate | intent | std | attempts | final verdict | cert size | proof nodes | checker fuel | self-play | vs CertBot | vs CertBot′ | vs CooperateBot | vs DefectBot |",
          "|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
for k, v in sorted(res.items()):
    a = v["attempts"][-1]
    m = a.get("moves", {})
    lines.append(f"| {k} | {v['spec']['intent']} | {v['spec']['standard']} | {len(v['attempts'])} | "
                 f"{'ACCEPTED' if a.get('accepted') else 'rejected'} | {a.get('cert_size', '')} | "
                 f"{a.get('proof_nodes', '')} | {a.get('fuel_needed') or ''} | {a.get('self_play', '')} | "
                 f"{m.get('CertBot', '')} | {m.get('CertBotP', '')} | {m.get('CooperateBot', '')} | {m.get('DefectBot', '')} |")
lines += ["", "Moves are shown as (candidate's move)/(opponent's move).", "",
          "## Every attempt, with the checker's reason for each rejection", ""]
for k, v in sorted(res.items()):
    lines.append(f"- **{k}** ({v['spec']['description']})")
    for a in v["attempts"]:
        verdict = "ACCEPTED" if a.get("accepted") else "rejected"
        reason = a.get("reason", "")
        lines.append(f"  - v{a['attempt']}: {verdict}" + (f": {reason[:400]}" if reason else ""))

files = [str(ROOT / "m6/candidates" / k / f"v{len(v['attempts'])}.sexp") for k, v in sorted(res.items())]
out = subprocess.run([LAKE, "exe", "diagcheck", "--tournament"] + files, cwd=ROOT,
                     capture_output=True, text=True).stdout
t = json.loads(out.strip().splitlines()[-1])
names = t["names"]
lines += ["", "## Round robin (final attempts of all candidates, plus the reference entries)", "",
          "Row's move against each column. Entries marked `LLM:` are LLM-generated.", "",
          "| | " + " | ".join(str(i) for i in range(len(names))) + " |",
          "|---|" + "---|" * len(names)]
for i, n in enumerate(names):
    lines.append(f"| {i}. {n} | " + " | ".join(t["rows"][n]) + " |")
(ROOT / "m6/REPORT.md").write_text("\n".join(lines) + "\n")
print("\n".join(lines[:12]))
