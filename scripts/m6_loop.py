#!/usr/bin/env python3
"""M6: the LLM loop with a pluggable generator backend.

Each candidate lives in m6/candidates/<name>/ with a spec.json:
  {"intent": "member" | "adversarial", "standard": "K" | "KP", "description": "..."}
and attempts v1.sexp, v2.sexp, ... (program + certificate as S-expression data).

The loop asks the backend for attempt i (given the checker's feedback on earlier
attempts), runs the trusted checker (`lake exe diagcheck`), records every verdict
unedited, and stops a member at its first accepted attempt.

Backends:
  claude-code (default): the attempts are files written by Claude Code acting as the
      generator. Attempt i+1 exists only if it wrote one after reading attempt i's feedback.
  api: placeholder for a script that calls a model. Disabled until the user approves
      using an API key and spending credits.
"""
import json, subprocess, sys, pathlib, argparse

ROOT = pathlib.Path(__file__).resolve().parent.parent
CAND = ROOT / "m6" / "candidates"
CHECK = [str(pathlib.Path.home() / ".elan/bin/lake"), "exe", "diagcheck"]


class Backend:
    name = "abstract"
    def attempt(self, cand_dir, spec, i, history):
        """Return the path of attempt i (1-based), or None if there is none."""
        raise NotImplementedError


class ClaudeCodeBackend(Backend):
    name = "claude-code"
    def attempt(self, cand_dir, spec, i, history):
        p = cand_dir / f"v{i}.sexp"
        return p if p.exists() else None


class ApiBackend(Backend):
    name = "api"
    def attempt(self, cand_dir, spec, i, history):
        # Would build a prompt from spec + docs (Diag/Front.lean syntax) + the feedback in
        # `history`, call a model, save the reply as v{i}.sexp, and return its path.
        raise SystemExit("API backend disabled: ask the user before using an API key.")


def run_checker(path, standard):
    out = subprocess.run(CHECK + [str(path), standard], cwd=ROOT, capture_output=True, text=True)
    try:
        return json.loads(out.stdout.strip().splitlines()[-1])
    except Exception:
        return {"status": "runner_error", "accepted": False, "reason": out.stderr[-500:]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--backend", default="claude-code", choices=["claude-code", "api"])
    ap.add_argument("only", nargs="*")
    args = ap.parse_args()
    backend = ClaudeCodeBackend() if args.backend == "claude-code" else ApiBackend()
    results = {}
    for d in sorted(CAND.iterdir()):
        if not d.is_dir() or (args.only and d.name not in args.only):
            continue
        spec = json.loads((d / "spec.json").read_text())
        history = []
        i = 1
        while True:
            p = backend.attempt(d, spec, i, history)
            if p is None:
                break
            r = run_checker(p, spec["standard"])
            r["attempt"] = i
            history.append(r)
            print(f"{d.name} v{i}: accepted={r.get('accepted')} {r.get('reason', '')[:160]}")
            if r.get("accepted") and spec["intent"] == "member":
                break
            i += 1
        results[d.name] = {"spec": spec, "backend": backend.name, "attempts": history}
    out = ROOT / "m6" / "results.json"
    old = json.loads(out.read_text()) if out.exists() else {}
    old.update(results)
    out.write_text(json.dumps(old, indent=1, ensure_ascii=False))
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
