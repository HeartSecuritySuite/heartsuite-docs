# HeartSuite advisory feeds (`static/advisories/`)

Machine-readable HS kernel advisory artefacts for procurement, GRC, and vulnerability-management automation.

Hugo serves this directory at the site root (default `staticDir`). JSON files are available at:

| File | URL |
|------|-----|
| Catalogue | https://docs.heartsecsuite.com/advisories/index.json |
| CONFIG-gate Not-Affected SBOM | https://docs.heartsecsuite.com/advisories/hs-cve-config-sbom.json |
| OSV feed | https://docs.heartsecsuite.com/advisories/osv.json |
| CycloneDX SBOM | https://docs.heartsecsuite.com/advisories/sbom.cyclonedx.json |

## Publication pipeline

On each annotated **`hs-v*`** release tag in [heartsuite-core-secure](https://github.com/HeartSecuritySuite/heartsuite-core-secure), the **Publish advisory feeds** workflow (`.github/workflows/advisories.yml`):

1. Checks out this docs repo alongside Core Secure.
2. Runs `test_cve_config_crosswalk.py --sbom-out=…` — **must PASS** (no CONFIG drift).
3. Optionally runs `tools/generate_osv_from_cve_sbom.py` and `tools/generate_cyclonedx_sbom.py` when those tools exist in the Core Secure checkout.
4. Writes `index.json` (catalogue schema `hs-advisory-catalog/v1`) and copies all JSON artefacts here.
5. Commits to `main` (requires `HEARTSUITE_DOCS_WRITE_TOKEN` on the Core Secure repo).

If the crosswalk gate fails at release time, feeds are **not** updated — fix `tools/hs_config_parity.py` or the [Kernel Security Transparency](../../content/en/docs/security/index.md) page before tagging.

## Schemas

- **`hs-cve-config-sbom.json`** — `hs-cve-config-sbom/v1`. Validated CONFIG `not set` claims tied to CVE groups from the transparency page. Produced by `tests/manifest/test_cve_config_crosswalk.py`.
- **`osv.json`** — OSV schema entries derived from the CONFIG SBOM and transparency data (when the generator tool is present).
- **`sbom.cyclonedx.json`** — CycloneDX bill of materials for the coordinated release bundle (when the generator tool is present).
- **`index.json`** — Feed catalogue with release tag, HeartSuite version, kernel base, and per-feed publication flags.

OVAL XML definitions for OpenSCAP are **not** in this directory yet; see [Supply Chain and Advisory Feeds](https://docs.heartsecsuite.com/docs/kernel-hardening/supply-chain-and-advisories/).

Human-readable CVE status remains authoritative on the [Kernel Security Transparency](https://docs.heartsecsuite.com/docs/security/) page.