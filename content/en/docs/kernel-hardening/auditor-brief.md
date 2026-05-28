---
title: "Security Auditor Brief: Kernel Hardening Posture"
weight: 20
description: "Technical assessment of HeartSuite Core Secure kernel 5.19.6 hardening posture for security auditors and red teams — threat model, measured scores, residual risks, and self-reproduction instructions."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "audit", "red-team"]
type: docs
toc: true
---

**Subject:** HeartSuite Core Secure, kernel 5.19.6  
**Config SHA-256:** `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`  
**Measured:** 2026-05-19 using kernel-hardening-checker commit `b9b83a0`  
**Full data:** `kernel-comparison-matrix-5.19.6.md`, `evidence-pack-5.19.6.txt`

---

## Threat Model

HeartSuite's kernel hardening targets one specific threat: **a process on the protected system attempting to bypass the kernel module's VFS-level enforcement**. The design choice is to remove the kernel features that make bypass possible, rather than to harden the kernel against general exploitation.

Design is documented in:
- `docs/security-checklists/kernel_c/sandbox-enforcement.md` — Architectural Invariants section: "Karen disabled 6 kernel CONFIG options that each provide a mechanism to bypass VFS-level enforcement."
- `docs/security-checklists/tooling/deployment-hardening.md` item 1 — per-option rationale for each disable.

---

## What the Measurements Show

### Attack-Surface Reduction

Automated score: **91/132 (68.9%)**  
Reference points (era-matched, same 5.19.x kernel generation): Arch linux-hardened 5.19.11: 77/132 (58.3%). Vanilla upstream defconfig 5.17: 90/132 (68.2%). KSPP target (6.17, version-agnostic intent): 131/132 (99.2%).

HS outperforms production distros and common hardened-distro kernels on this axis. The reason: HS disables `BPF_SYSCALL`, `USER_NS`, `FUSE_FS`, `OVERLAY_FS`, `APPARMOR`, `TOMOYO`, and ~25 additional network/crypto/debug subsystems that Arch and NixOS keep enabled for their general-purpose user bases. These are the subsystems with the most relevant LSM-bypass CVE history.

**Caveat:** the automated checker scores vanilla 5.17 defconfig at 90/132, nearly identical to HS. This is because the checker does not distinguish *intentionally hardened to* a value from *never configured to begin with.* The vanilla defconfig also doesn't enable BPF or AppArmor by default. The operational difference is enforcement: a production system built on a vanilla defconfig will have these features added over time; HS's build procedure enforces the disables regardless.

### Exploit-Resistance (KSPP-style mitigations)

Automated score: **31/109 (28.4%)**  
Reference points (era-matched): Arch linux-hardened 5.19.11: 69/109 (63.3%). Vanilla upstream defconfig 5.17: 29/109 (26.6%). KSPP target (6.17): 93/109 (85.3%).

HS's exploit-resistance posture is at the vanilla upstream baseline. It does not add `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM`, `KFENCE`, `RANDSTRUCT_FULL`, `KSTACK_ERASE`, `MODULE_SIG`, or the other ~57 KSPP mitigations that dedicated hardened kernels enable.

---

## Residual Risks

**1. Kernel memory corruption / exploitation**  
HS provides no additional protection beyond vanilla upstream defaults for heap-based exploits (use-after-free, double-free, type confusion). An attacker who can reach a vulnerable in-kernel code path with sufficient primitive quality has no extra mitigations to contend with beyond `STACKPROTECTOR_STRONG`, `KASLR`, `RANDOMIZE_MEMORY`, and `STRICT_KERNEL_RWX` — all of which are vanilla defaults.

*Attack path:* Any reachable kernel vulnerability with reliable heap-layout control.

**2. IO_URING (5.19.6 specific)**  
`CONFIG_IO_URING=y` in 5.19.6. io_uring retrieves file descriptors via `fget()`, which has no LSM hook, allowing sandboxed processes to perform file operations that bypass HeartSuite's VFS enforcement. This is a known gap in the 5.19.6 config; documented in `HS-DEVIATIONS.md` HS-DEV-005.

*Attack path:* Sandboxed process opens a file descriptor before being sandboxed, then uses io_uring to perform subsequent operations.

**3. kexec (5.19.6 specific)**  
`CONFIG_KEXEC=y` in 5.19.6. A root-privileged process can replace the running kernel via `kexec_load()`, destroying all kernel-resident Lockdown state. This is a Lockdown-bypass primitive.

*Attack path:* Root-level attacker (bypassed Lockdown via another vector, or Lockdown not yet engaged) loads a stock kernel image via `kexec()`.

**4. SELinux runtime state — verified permissive**  
`CONFIG_SECURITY_SELINUX=y` with `CONFIG_DEFAULT_SECURITY_SELINUX=y`. SELinux is compiled-in. Runtime verification on the test VM (2026-05-19) shows:

- `/sys/fs/selinux/enforce` = `0` — permissive mode, no policy loaded
- `/proc/self/attr/current` = `kernel` — initial context, no confinement active
- securityfs is not mounted (no `/sys/kernel/security/lsm` file)

SELinux initializes at boot but does not enforce. HeartSuite is the sole enforcing MAC LSM. dmesg confirms HeartSuite's enforcement is active within 4 seconds of boot.

*Residual note for production:* this relies on runtime service configuration keeping SELinux permissive. Verify `cat /sys/fs/selinux/enforce` = `0` on each production deployment. A loaded SELinux policy that flips to enforcing mode would add a competing LSM to the stack.

**5. MODULE_SIG not enforced**  
`CONFIG_MODULE_SIG=n`. Kernel module signing is not enforced. A root-level attacker can load an arbitrary unsigned kernel module, including one that unloads or bypasses HeartSuite's VFS hooks.

*Mitigating factor:* Lockdown's `kmod` block (when engaged) prevents loading additional modules post-Lockdown, per `project_kmod_operator_procedure_gap` memory. This is an operator-procedure-dependent mitigation, not a config-enforced one.

---

## How to Reproduce These Measurements

Run on any Linux host with Python 3:

```bash
# Clone the checker
git clone --depth 1 https://github.com/a13xp0p0v/kernel-hardening-checker /tmp/khc

# Obtain the HS config (from the HS 5.19.6 kernel package)
# Verify: sha256sum config-5.19.6-HeartSuite-1.0
# Expected: d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc

# Run
python3 /tmp/khc/bin/kernel-hardening-checker -c config-5.19.6-HeartSuite-1.0

# Expected summary: OK - 129 / FAIL - 129
```

To verify the bypass-primitive disables directly:

```bash
grep -E "^(CONFIG_BPF_SYSCALL|CONFIG_IO_URING|CONFIG_FUSE_FS|CONFIG_OVERLAY_FS|\
CONFIG_SECURITY_APPARMOR|CONFIG_SECURITY_TOMOYO|CONFIG_KEXEC[^_])" \
  config-5.19.6-HeartSuite-1.0
```

To verify LSM state on a running HeartSuite VM:

```bash
cat /sys/kernel/security/lsm
cat /proc/cmdline
```
