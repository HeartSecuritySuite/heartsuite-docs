---
title: "Verification Log"
weight: 70
description: "Cross-check record confirming that every quantitative claim in the kernel-hardening deliverables resolves to a cited source."
categories: ["Reference"]
tags: ["kernel", "hardening", "verification"]
type: docs
toc: true
---

**Run date:** 2026-05-19  
**Checker commit:** b9b83a0  
**Config SHA-256:** `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`

---

## Claim-by-claim cross-check

### Quantitative claims (must trace to evidence-pack or checker JSON)

| Claim | Deliverable | Evidence source |
|---|---|---|
| HS overall: 129 OK / 129 FAIL | Matrix §1, Auditor §2, Community | evidence-pack §7 (checker output) |
| HS attack-surface: 91/132 (68.9%) | Matrix §2, Auditor §2, Procurement table, Research §Empirical, Community | evidence-pack §8 |
| HS exploit-resistance: 31/109 (28.4%) | Matrix §3, Auditor §2, Research §Empirical, Community | evidence-pack §8 |
| Vanilla 5.17: 90/132 on attack surface | Matrix §2, Research §Empirical, Community | evidence-pack §8 |
| Arch lh 5.19.11: 77/132 attack surface (era-matched) | Matrix Part 1, Auditor §2, Procurement table, Research §Empirical | evidence-pack §8 (ERA-MATCHED section) |
| Arch lh 6.15: 76/132 attack surface (cross-version ref) | Research cross-version table | evidence-pack §8 (CROSS-VERSION section) |
| NixOS hardened 6.12: 61/132 attack surface (cross-version) | Research cross-version table | evidence-pack §8 (CROSS-VERSION section) |
| KSPP target: 131/132 attack surface | Matrix Part 1, Procurement table | evidence-pack §8 |
| Arch lh 5.19.11: 69/109 exploit-resistance (era-matched) | Matrix Part 1, Auditor §2, Procurement table, Research §Empirical | evidence-pack §8 (ERA-MATCHED section) |
| Arch lh 6.15: 90/109 exploit-resistance (cross-version ref) | Research cross-version table | evidence-pack §8 (CROSS-VERSION section) |
| NixOS hardened 6.12: 88/109 exploit-resistance (cross-version) | Research cross-version table | evidence-pack §8 (CROSS-VERSION section) |
| 9 loadable .ko files | Matrix §6, Procurement table, Analyst | evidence-pack §2 (ls output) |
| 334 modules.builtin entries | Matrix §6 | evidence-pack §2 |
| ~3,500–4,000 Debian loadable modules | Matrix §6, Analyst | HS-DEVIATIONS.md HS-DEV-003 Reason col: "5.19.6 baseline of 5050 lines / 134KB / 13 modules" (13 = HS; Debian figure from same entry: "11439 lines / 282KB / 3776 modules") |
| BPF_SYSCALL=n, FUSE_FS=n, OVERLAY_FS=n, APPARMOR=n, TOMOYO=n | Matrix §4, Auditor §Bypass, Procurement table, Community | evidence-pack §3 (grep output) |
| IO_URING=y (gap), KEXEC=y (gap) | Matrix §4, Auditor §Residual 2+3, Community | evidence-pack §3 |
| YAMA, LOCKDOWN_LSM, LANDLOCK, IMA, EVM all =n | Matrix §5, Procurement table | evidence-pack §4 |
| SELinux compiled-in, DEFAULT_SECURITY_SELINUX=y | Matrix §5, Auditor §Residual 4 | evidence-pack §5 |
| RETPOLINE, RETHUNK, CPU_IBPB_ENTRY, CPU_IBRS_ENTRY present | Matrix §7 | evidence-pack §6 |
| 30 options HS passes that Arch fails | Matrix §2, Research | evidence-pack §9 |
| 15 options Arch passes that HS fails | Matrix §2, Research | evidence-pack §10 |
| MODULE_SIG=n | Auditor §Residual 5 | evidence-pack §11 (grep: `# CONFIG_MODULE_SIG is not set`) |
| Config SHA-256 | All deliverables header | evidence-pack §1 (`sha256sum` output) |
| Checker commit b9b83a0 | All deliverables header | evidence-pack §1 (`git log --oneline -1` on /tmp/kernel-hardening-checker) |

### Qualitative claims (must cite path:line in HS docs)

| Claim | Deliverable | Citation |
|---|---|---|
| HeartSuite fires hooks before the LSM chain; redundant LSMs add attack surface | Auditor §Threat Model | `docs/security-checklists/tooling/deployment-hardening.md` item 1, APPARMOR row |
| BPF root with CAP_BPF can override MAC | Auditor §Residual, Procurement, Research | `docs/security-checklists/tooling/deployment-hardening.md` item 1, BPF_SYSCALL row |
| io_uring uses fget() with no LSM hook | Auditor §Residual 2, Research rationale | `docs/security-checklists/tooling/deployment-hardening.md` item 1, IO_URING row |
| FUSE allows path confusion | Research rationale | `docs/security-checklists/tooling/deployment-hardening.md` item 1, FUSE_FS row |
| Overlay d_path() mismatch | Research rationale | `docs/security-checklists/tooling/deployment-hardening.md` item 1, OVERLAY_FS row |
| kexec destroys Lockdown state | Auditor §Residual 3, Matrix §4 | `docs/security-checklists/tooling/deployment-hardening.md` item 1, KEXEC row |
| HS-DEV-005 resolves IO_URING/KEXEC in 6.18.x | Auditor §Residual 2+3, Matrix §4 | `docs/porting/HS-DEVIATIONS.md` HS-DEV-005 |
| Deviation registry parity enforced mechanically | Research §vanilla equivalence | `docs/porting/HS-DEVIATIONS.md` "How to add a new entry" §5 + PATCH_RELEASE.md Step 3c check 6 |
| 5.19.6 baseline: 5050 lines, 13 modules (HS vs Debian's 3776 modules) | Matrix §6 footnote | `docs/porting/HS-DEVIATIONS.md` HS-DEV-003 Reason column |

---

## Consistency check across deliverables

| Fact | Auditor | Procurement | Research | Community | Analyst |
|---|---|---|---|---|---|
| HS attack-surface score | 91/132 ✓ | 91/132 ✓ | 91/132 ✓ | 91/132 ✓ | "91 out of 132" ✓ |
| HS exploit-resistance score | 31/109 ✓ | 31/109 ✓ | 31/109 ✓ | 31/109 ✓ | "31 out of 109" ✓ |
| Arch lh era-matched (5.19.11) | 77/132 / 69/109 ✓ | 77/132 / 69/109 ✓ | 77/132 / 69/109 ✓ | 77/132 ✓ | 77/132 / 69/109 ✓ |
| IO_URING gap noted | §Residual 2 ✓ | (omitted — correct, not a product decision for buyers) | §Design §Q4 ✓ | §gaps ✓ | (omitted — correct for audience) |
| BPF=n | §Bypass ✓ | table ✓ | §rationale ✓ | §design ✓ | body ✓ |
| 9 modules | (not stated — correct, detail for auditors not needed) | table ✓ | (not stated) | (not stated) | body ✓ |
| MODULE_SIG gap | §Residual 5 ✓ | (omitted — correct for audience) | (not stated) | (not stated) | (omitted — correct) |
| NixOS removed from nixpkgs | (not relevant to audit) | footnote in broader table ✓ | noted in cross-version tables ✓ | §design ✓ | (not stated — correct for audience) |
| Version-skew disclosed | era-matched note ✓ | era-matched note ✓ | ERA-MATCHED vs CROSS-VERSION sections ✓ | §design ✓ | "same kernel generation" ✓ |

No contradictions found across the five deliverables.

---

## Resolved items (originally open, closed 2026-05-19)

| Item | Resolution |
|---|---|
| SELinux runtime state | Verified on hs-test-debian-12: `/sys/fs/selinux/enforce`=`0` (permissive). securityfs not mounted; no `/sys/kernel/security/lsm` file. HeartSuite confirmed sole enforcing MAC LSM via dmesg. Evidence-pack §5 updated with full trace. |
| `lsmod` on running VM | `lsmod` output is empty — 0 modules loaded at runtime. The 9 .ko files are available but unused in this deployment state. Evidence-pack §2 updated. |
| 1.0 vs 2.0 config diff | Diff is 7 lines: toolchain version headers only. No security-relevant option differs. Evidence-pack §1 documents both hashes. |
| Version-skew in reference configs | Resolved. Bundled configs in checker are 6.12–6.15; not comparable to HS 5.19.6. Era-matched reference obtained: Arch linux-hardened 5.19.11 config from `gitlab.archlinux.org/archlinux/packaging/packages/linux-hardened.git` @ tag `5.19.11.hardened1-1` (SHA256: `da1664e5dbb7f3131e52e9c16505f9158b318f0eff12692615625a325a8f5240`). All deliverables now use era-matched scores for direct comparison and cross-version bundled configs for orientation only. |
| NixOS linux_hardened status | Noted in all deliverables: removed from nixpkgs 2025 due to lack of maintenance. Bundled 6.12.50 config in checker is a historical snapshot. |

## Remaining open items

| Item | Required action |
|---|---|
| Second-host checker re-run | Run checker on a different machine against the same config; confirm output is byte-identical (modulo timestamps) — reproducibility proof for external auditors |
| Production deployment SELinux | Each production deployment should independently verify `cat /sys/fs/selinux/enforce` = `0`; evidence-pack §5 caveat documents this |
