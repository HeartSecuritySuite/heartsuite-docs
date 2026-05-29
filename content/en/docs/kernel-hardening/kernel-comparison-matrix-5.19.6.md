---
title: "Kernel Hardening Comparison Matrix"
weight: 10
description: "Objective comparison of HeartSuite Core Secure 5.19.6 kernel configuration against industry hardened kernels and standard references, using kernel-hardening-checker (commit b9b83a0)."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "comparison"]
type: docs
toc: true
---

**Subject:** HeartSuite Core Secure, kernel 5.19.6  
**Config SHA-256:** `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`  
**Tool:** [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) commit `b9b83a0`, run 2026-05-19  
**Source file:** `evidence-pack-5.19.6.txt`

---

## Part 1 — Measured comparison (same kernel era)

All three configs below are built from the 5.19.x kernel tree. Checker scores are directly comparable — same Kconfig namespace, same option universe.

| Config | Source | Kernel | Overall | Attack-surface | Exploit-resistance |
|---|---|---|---|---|---|
| **HS 5.19.6** | HS canonical config (SHA256: `d67caa6…`) | 5.19.6 | **129/258 (50.0%)** | **91/132 (68.9%)** | 31/109 (28.4%) |
| Arch linux-hardened | gitlab.archlinux.org/archlinux/packaging/packages/linux-hardened @ tag `5.19.11.hardened1-1` | 5.19.11 | 158/258 (61.2%) | 77/132 (58.3%) | **69/109 (63.3%)** |
| Vanilla x86_64 defconfig | Bundled in kernel-hardening-checker | 5.17.1 | 126/258 (48.8%) | 90/132 (68.2%) | 29/109 (26.6%) |

### Reading the table

- **Attack-surface** measures how many dangerous kernel features are disabled. Higher = more things turned off.
- **Exploit-resistance** measures how many defensive mitigations against memory bugs are enabled. Higher = harder to exploit.
- These two axes are **largely independent** and optimized for different threat models.

### What this shows

HS leads on attack-surface (91 vs 77 vs 90): it disables `BPF_SYSCALL`, `FUSE_FS`, `OVERLAY_FS`, `SECURITY_APPARMOR`, `SECURITY_TOMOYO`, and `USER_NS` — all of which Arch linux-hardened keeps enabled for its general-purpose user base.

Arch linux-hardened leads on exploit-resistance (69 vs 31): it enables `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `INIT_ON_ALLOC_DEFAULT_ON`, `INIT_ON_FREE_DEFAULT_ON`, `SLAB_FREELIST_RANDOM`, and `MODULE_SIG` — all absent in HS 5.19.6.

Vanilla defconfig is the baseline: it does about as well as HS on attack-surface (most things aren't enabled by default) but even worse on exploit-resistance.

### Bypass-primitive disables — side by side

| Option | HS 5.19.6 | Arch lh 5.19.11 | Notes |
|---|---|---|---|
| `CONFIG_BPF_SYSCALL` | **=n** | =y | BPF LSM can override all MAC decisions |
| `CONFIG_IO_URING` | =y | =y | io_uring bypasses VFS hooks via `fget()` |
| `CONFIG_FUSE_FS` | **=n** | =m | FUSE allows path-confusion attacks |
| `CONFIG_OVERLAY_FS` | **=n** | =m | Overlay `d_path()` breaks sandbox lookup |
| `CONFIG_SECURITY_APPARMOR` | **=n** | =y | Redundant LSM adds attack surface |
| `CONFIG_SECURITY_TOMOYO` | **=n** | =y | Same rationale as AppArmor |
| `CONFIG_KEXEC` | =y | **=n** | kexec destroys Lockdown state |
| `CONFIG_MODULE_SIG` | =n | **=y** | Unsigned modules can unload HeartSuite |

HS: 5/8 disabled. Arch lh: 3/8 disabled (different 3). **Neither disables all eight.**

### Exploit-resistance mitigations — side by side

| Mitigation | HS 5.19.6 | Arch lh 5.19.11 |
|---|---|---|
| `INIT_ON_ALLOC_DEFAULT_ON` | =n | **=y** |
| `INIT_ON_FREE_DEFAULT_ON` | =n | **=y** |
| `HARDENED_USERCOPY` | =n | **=y** |
| `FORTIFY_SOURCE` | =n | **=y** |
| `SLAB_FREELIST_RANDOM` | =n | **=y** |
| `KFENCE` | =n | =n |
| `RANDSTRUCT_FULL` | =n | =n |
| `KSTACK_ERASE` | =n | =n |
| `MODULE_SIG` / `MODULE_SIG_FORCE` | =n / =n | **=y** / =n |

---

## Part 2 — Qualitative orientation (cross-project)

These projects were not scored with the checker in this analysis — either because their configs were unavailable for the 5.19 era, because they are paywalled, or because a meaningful config was not locatable. Characterizations are drawn from each project's public documentation and design goals.

| Project | Bypass Prevention | Exploit Resistance | Module Footprint | Availability | Primary Use Case |
|---|---|---|---|---|---|
| **HeartSuite 5.19.6** | **Very High** — BPF/FUSE/OVERLAY/AppArmor/TOMOYO/USER_NS all disabled | Low — vanilla upstream baseline | **~9 modules** (measured) | Commercial | Containment of untrusted code on dedicated appliance |
| Arch linux-hardened 5.19.11 | Moderate — keeps BPF, FUSE, AppArmor, USER_NS | **High** — HARDENED_USERCOPY, FORTIFY, INIT_ON_ALLOC, SLAB_FREELIST | Hundreds | Free, open-source | General-purpose hardened desktop/server |
| NixOS linux_hardened | Moderate | **High** | Hundreds | **Removed from nixpkgs 2025** (lack of maintenance) | Was: reproducible hardened NixOS systems |
| grsecurity / PaX | High | **Very High** — RBAC + PaX heap/stack protections | Large | Paid subscription | Maximum exploit resistance; enterprise |
| CLIP OS (ANSSI) | High — minimal modules + BPF disabled | High — KSPP-style mitigations | ~400 | Public (archived) | Government/high-security Linux platform |
| Hardened Gentoo | Moderate | High | Large | Free, open-source | Reproducible hardened Gentoo systems |
| GrapheneOS | High — Android-targeted bypass removal | **Very High** — extensive Android hardening patches | Android-specific | Free, open-source | Hardened Android (not x86/server) |
| Kicksecure / Whonix | Low–Moderate | Low–Moderate — mostly OS-level hardening, not kernel patches | Standard Debian | Free, open-source | Privacy-focused Debian derivative |

**Notes on the qualitative table:**

- "Bypass Prevention" = removal of subsystems that can circumvent MAC/LSM enforcement.
- "Exploit Resistance" = mitigations against kernel memory bugs (heap, stack, pointer corruption).
- NixOS `linux_hardened` was removed from nixpkgs in 2025 due to lack of maintenance — it is no longer an active project. The bundled config in kernel-hardening-checker (6.12.50-hardened1) is a historical snapshot.
- CLIP OS: the public CLIP OS project is archived. The ANSSI team published their kernel configs; they are accessible at the archived CLIP OS documentation.
- grsecurity requires a paid subscription; their config is not publicly available for automated analysis.
- GrapheneOS targets Android hardware (aarch64); its hardening is not directly applicable to x86 server deployments.

---

## Part 3 — LSM stack and module count (measured)

| Metric | HS 5.19.6 | Source |
|---|---|---|
| Modules loaded at runtime | **0** (lsmod empty) | Runtime measurement |
| Loadable .ko files shipped | 9 | Runtime measurement |
| modules.builtin entries | 334 | Runtime measurement |
| SELinux at runtime | Permissive (`enforce=0`) | Runtime measurement — `/sys/fs/selinux/enforce` |
| Active enforcing MAC LSM | HeartSuite | Runtime measurement — dmesg enforcement trace |
| Alt-LSMs (YAMA, LANDLOCK, IMA, EVM, LOCKDOWN_LSM) | All disabled | Config grep |

---

## Part 4 — CPU mitigations (5.19.6 naming)

5.19.6 uses pre-6.1 option names. Checker reports these as FAIL (uses the 6.1+ `CONFIG_MITIGATION_*` names). Mitigations confirmed present:

| Mitigation | 5.19.6 option | Value |
|---|---|---|
| Spectre v2 (retpoline) | `CONFIG_RETPOLINE` | =y |
| Return thunk | `CONFIG_RETHUNK` | =y |
| IBPB on kernel entry | `CONFIG_CPU_IBPB_ENTRY` | =y |
| IBRS on kernel entry | `CONFIG_CPU_IBRS_ENTRY` | =y |
| IBT compiler support | `CONFIG_CC_HAS_IBT` | =y |

---

## Summary

| Dimension | HS 5.19.6 | Arch lh 5.19.11 (era-matched) |
|---|---|---|
| Overall checker score | 50.0% | 61.2% |
| Attack-surface reduction | **68.9%** | 58.3% |
| Exploit-resistance | 28.4% | **63.3%** |
| Bypass-primitive disables (of 8 key) | 5/8 | 3/8 (different set) |
| KEXEC disabled | No | **Yes** |
| MODULE_SIG enforced | No | **Yes** |
| BPF_SYSCALL disabled | **Yes** | No |
| FUSE/OVERLAY disabled | **Yes** | No |
| Runtime modules loaded | **0** | Not measured |
