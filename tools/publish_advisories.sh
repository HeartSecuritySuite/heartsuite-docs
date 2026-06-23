#!/usr/bin/env bash
# SPDX-License-Identifier: LicenseRef-HeartSuite-ELA
# Copyright (C) 2026 Heart Security Suite, LLC
#
# Publish HeartSuite advisory artefacts into this docs repo (static/advisories/).
#
# Pipeline:
#   1. test_cve_config_crosswalk.py --sbom-out  → hs-cve-config-sbom/v1 JSON
#   2. generate_osv_from_cve_sbom.py             → OSV per-CVE + osv/all.json
#   3. generate_cyclonedx_sbom.py (heartsuite)   → CycloneDX bundle SBOM
#   4. index.json catalogue                      → served at /advisories/
#
# Environment (optional):
#   HS_CORE_SECURE_REPO   Path to github-heartsuite-core-secure checkout
#   HS_HEARTSUITE_REPO    Path to heartsuite checkout (CycloneDX generator)
#   HS_DOCS_REPO          Path to this docs repo (defaults to repo root)
#   HS_KERNEL_VERSION     e.g. 6.18.9-HeartSuite-1.0
#   HS_RELEASE_TAG        e.g. hs-v1.6.4-kernel-6.18.9
#   HS_ADVISORY_FEED_BASE_URL  Published URL prefix (default: docs site /advisories)
#
# Exit codes:
#   0 = published
#   1 = crosswalk DRIFT or no CVE rows
#   2 = setup error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_REPO="${HS_DOCS_REPO:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
CORE_REPO="${HS_CORE_SECURE_REPO:-$(cd "${DOCS_REPO}/../github-heartsuite-core-secure" && pwd)}"
HS_REPO="${HS_HEARTSUITE_REPO:-$(cd "${DOCS_REPO}/../heartsuite" && pwd)}"

CROSSWALK="${CORE_REPO}/tests/manifest/test_cve_config_crosswalk.py"
OSV_GEN="${CORE_REPO}/tools/generate_osv_from_cve_sbom.py"
CDX_GEN="${HS_REPO}/tools/generate_cyclonedx_sbom.py"
MANIFEST="${HS_REPO}/dist/heartsuite-install.sh.manifest"

DEST="${DOCS_REPO}/static/advisories"
STAGING="$(mktemp -d)"

cleanup() {
  rm -rf "${STAGING}"
}
trap cleanup EXIT

KERNEL_VERSION="${HS_KERNEL_VERSION:-6.18.9-HeartSuite-1.0}"
RELEASE_TAG="${HS_RELEASE_TAG:-hs-v1.6.4-kernel-6.18.9}"
FEED_BASE="${HS_ADVISORY_FEED_BASE_URL:-https://docs.heartsecsuite.com/advisories}"
PUBLISHED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

if [[ ! -f "${CROSSWALK}" ]]; then
  echo "ERROR: crosswalk gate not found: ${CROSSWALK}" >&2
  exit 2
fi
if [[ ! -f "${OSV_GEN}" ]]; then
  echo "ERROR: OSV generator not found: ${OSV_GEN}" >&2
  exit 2
fi

SBOM="${STAGING}/hs-cve-config-sbom.json"
export HS_DOCS_REPO="${DOCS_REPO}"

echo "==> CVE↔CONFIG crosswalk → SBOM (must PASS)"
python3 "${CROSSWALK}" "--sbom-out=${SBOM}"

echo "==> OSV generation"
python3 "${OSV_GEN}" "${SBOM}" \
  --out-dir "${STAGING}/feed" \
  --kernel-version "${KERNEL_VERSION}" \
  --release-tag "${RELEASE_TAG}" \
  --feed-base-url "${FEED_BASE}"

OSV_COUNT="$(find "${STAGING}/feed/osv" -maxdepth 1 -name 'CVE-*.json' 2>/dev/null | wc -l)"

if [[ "${OSV_COUNT}" -eq 0 ]]; then
  echo "ERROR: OSV generator produced zero CVE records" >&2
  exit 1
fi

CDX_PUBLISHED=false
if [[ -f "${CDX_GEN}" && -f "${MANIFEST}" ]]; then
  echo "==> CycloneDX SBOM"
  python3 "${CDX_GEN}" \
    --manifest "${MANIFEST}" \
    --pyproject "${HS_REPO}/pyproject.toml" \
    --requirements "${HS_REPO}/requirements.txt" \
    --output-dir "${STAGING}"
  CDX_PUBLISHED=true
else
  echo "WARNING: skipping CycloneDX (generator or manifest missing)" >&2
fi

echo "==> index.json catalogue"
CDX_FLAG="false"
if ${CDX_PUBLISHED}; then
  CDX_FLAG="true"
fi
export STAGING RELEASE_TAG KERNEL_VERSION FEED_BASE PUBLISHED_AT OSV_COUNT CDX_FLAG
python3 - <<'PY'
import json
import os
from pathlib import Path

staging = Path(os.environ["STAGING"])
release_tag = os.environ["RELEASE_TAG"]
kernel_version = os.environ["KERNEL_VERSION"]
feed_base = os.environ["FEED_BASE"]
published_at = os.environ["PUBLISHED_AT"]
osv_count = int(os.environ["OSV_COUNT"])
cdx_published = os.environ["CDX_FLAG"] == "true"

hs_version = release_tag.replace("hs-v", "").split("-kernel-")[0]
kernel_base = release_tag.split("-kernel-", 1)[-1] if "-kernel-" in release_tag else None

def feed(feed_id, path, fmt, description, published, extra=None):
    entry = {
        "id": feed_id,
        "format": fmt,
        "path": path,
        "url": feed_base.rstrip("/") + path.removeprefix("/advisories"),
        "description": description,
        "published": published,
    }
    if extra:
        entry.update(extra)
    return entry

feeds = [
    feed(
        "hs-cve-config-sbom",
        "/advisories/hs-cve-config-sbom.json",
        "hs-cve-config-sbom/v1",
        "Not-Affected CONFIG gate manifest validated against tools/hs_config_parity.py",
        True,
    ),
    feed(
        "osv-bundle",
        "/advisories/osv/all.json",
        "OSV",
        "OSV bundle for HS kernel Not-Affected CONFIG-gated CVEs (custom HeartSuite ecosystem)",
        True,
        {"entry_count": osv_count, "alias_path": "/advisories/osv.json"},
    ),
]
if cdx_published:
    feeds.append(
        feed(
            "cyclonedx-sbom",
            "/advisories/sbom.cyclonedx.json",
            "CycloneDX-1.5",
            "Coordinated bundle SBOM (kernel + userspace enforcement stack, v0.1 scope)",
            True,
        )
    )

doc = {
    "schema": "hs-advisory-catalog/v1",
    "release_tag": release_tag,
    "heartsuite_version": hs_version,
    "kernel_version": kernel_version,
    "kernel_base": kernel_base,
    "published_at": published_at,
    "gate_status": "PASS",
    "site": "https://docs.heartsecsuite.com",
    "feeds": feeds,
}
with open(staging / "index.json", "w", encoding="utf-8") as f:
    json.dump(doc, f, indent=2)
    f.write("\n")
PY

echo "==> Copy to ${DEST}"
mkdir -p "${DEST}/osv"
cp "${SBOM}" "${DEST}/hs-cve-config-sbom.json"
cp "${STAGING}/feed/manifest.json" "${DEST}/manifest.json"
cp -a "${STAGING}/feed/osv/." "${DEST}/osv/"
cp "${STAGING}/index.json" "${DEST}/index.json"
cp "${DEST}/osv/all.json" "${DEST}/osv.json"

if ${CDX_PUBLISHED}; then
  KERNEL_SHORT="$(echo "${KERNEL_VERSION}" | sed 's/-HeartSuite.*//')"
  CDX_SRC="${STAGING}/heartsuite-${KERNEL_SHORT}.cdx.json"
  if [[ -f "${CDX_SRC}" ]]; then
    cp "${CDX_SRC}" "${DEST}/heartsuite-${KERNEL_SHORT}.cdx.json"
    cp "${CDX_SRC}" "${DEST}/sbom.cyclonedx.json"
  fi
fi

echo "Published ${OSV_COUNT} OSV record(s); gate_status=PASS"
echo "Feed root: ${DEST}"
echo "URLs after deploy:"
echo "  ${FEED_BASE}/index.json"
echo "  ${FEED_BASE}/hs-cve-config-sbom.json"
echo "  ${FEED_BASE}/osv/all.json"
echo "  ${FEED_BASE}/osv.json (alias)"
if ${CDX_PUBLISHED}; then
  echo "  ${FEED_BASE}/sbom.cyclonedx.json"
fi