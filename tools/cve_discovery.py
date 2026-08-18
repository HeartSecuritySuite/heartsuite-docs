#!/usr/bin/env python3
"""Discover Linux kernel HIGH/CRITICAL CVEs missing from the Docsy security page.

This is discovery only. It does not run the 4-gate kernel review
(docs/internal/cve-review-brief.md). Gates need the derived production
.config and allowlist seeds on a machine that has the HeartSuite kernel
trees. GitHub Actions must not invent Status / Score on HeartSuite.

Usage:
    python3 tools/cve_discovery.py
    python3 tools/cve_discovery.py --weeks 8 --out /tmp/cve-discovery.md

Exit codes:
    0  no missing HIGH/CRITICAL in the window
    2  missing IDs written to the report (draft-PR signal)
    1  fetch/parse failure
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
PAGE = REPO / "content/en/docs/security/index.md"
NVD = "https://services.nvd.nist.gov/rest/json/cves/2.0"
UA = "heartsuite-cve-discovery/1.0"


def page_ids(text: str) -> set[str]:
    return set(re.findall(r"CVE-20\d{2}-\d+", text))


def nvd_fetch(params: dict, start: int = 0) -> dict:
    q = dict(params)
    q["startIndex"] = start
    q["resultsPerPage"] = 200
    url = NVD + "?" + urllib.parse.urlencode(q)
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read())


def collect(params: dict) -> list[dict]:
    hits: list[dict] = []
    start = 0
    while True:
        data = nvd_fetch(params, start)
        total = data.get("totalResults", 0)
        vulns = data.get("vulnerabilities", [])
        for v in vulns:
            cve = v["cve"]
            metrics = cve.get("metrics", {})
            score = sev = None
            for k in ("cvssMetricV31", "cvssMetricV30"):
                if metrics.get(k):
                    d = metrics[k][0].get("cvssData", {})
                    score = d.get("baseScore")
                    sev = d.get("baseSeverity")
                    break
            desc = (cve.get("descriptions") or [{}])[0].get("value", "")
            hits.append(
                {
                    "id": cve["id"],
                    "published": cve.get("published"),
                    "score": score,
                    "sev": sev,
                    "desc": desc.replace("\n", " ")[:180],
                }
            )
        if start + len(vulns) >= total or not vulns:
            break
        start += len(vulns)
        time.sleep(0.8)
    return hits


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--weeks", type=int, default=8)
    p.add_argument("--out", type=Path, default=REPO / "cve-discovery-report.md")
    args = p.parse_args()

    if not PAGE.exists():
        print(f"missing page: {PAGE}", file=sys.stderr)
        return 1

    documented = page_ids(PAGE.read_text())
    end = datetime.now(timezone.utc)
    start = end - timedelta(weeks=args.weeks)
    window = {
        "virtualMatchString": "cpe:2.3:o:linux:linux_kernel",
        "pubStartDate": start.strftime("%Y-%m-%dT00:00:00.000"),
        "pubEndDate": end.strftime("%Y-%m-%dT23:59:59.000"),
    }

    hits: list[dict] = []
    try:
        for sev in ("CRITICAL", "HIGH"):
            hits.extend(collect({**window, "cvssV3Severity": sev}))
            time.sleep(0.8)
    except Exception as exc:
        print(f"NVD fetch failed: {exc}", file=sys.stderr)
        return 1

    by_id = {h["id"]: h for h in hits}
    missing = sorted(
        (h for h in by_id.values() if h["id"] not in documented),
        key=lambda h: h.get("published") or "",
    )

    ts = end.strftime("%Y-%m-%dT%H:%M:%SZ")
    lines = [
        f"# CVE discovery report — {ts}",
        "",
        "Discovery only. Do **not** merge Status / Score on HeartSuite from this file.",
        "Each ID still needs the 4-gate review in `cve-review-brief.md` against the",
        "derived 5.19.6 and 6.18.9-hs configs on a machine that has those trees.",
        "",
        f"- Window: last {args.weeks} weeks ({window['pubStartDate']} .. {window['pubEndDate']})",
        f"- Page unique CVE IDs: {len(documented)}",
        f"- NVD HIGH+CRITICAL kernel CPE hits: {len(by_id)}",
        f"- Missing from page: {len(missing)}",
        "",
    ]
    if not missing:
        lines.append("No missing HIGH/CRITICAL kernel CVEs in this window.")
    else:
        lines += [
            "| CVE | Published | Score | First line |",
            "|-----|-----------|-------|------------|",
        ]
        for h in missing:
            pub = (h.get("published") or "")[:10]
            desc = (h.get("desc") or "").replace("|", "/")
            lines.append(f"| {h['id']} | {pub} | {h.get('score')} {h.get('sev') or ''} | {desc} |")
        lines += [
            "",
            "Next: on the kernel host run",
            "`python3 cve_orchestrator.py --recent-weeks "
            + str(args.weeks)
            + " --patch-only`",
            "then apply only the human-reviewed patch to this page.",
        ]

    args.out.write_text("\n".join(lines) + "\n")
    print(f"wrote {args.out} missing={len(missing)}")
    return 2 if missing else 0


if __name__ == "__main__":
    sys.exit(main())
