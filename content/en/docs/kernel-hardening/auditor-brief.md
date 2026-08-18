---
title: "What a red team should test on this kernel"
linkTitle: "Auditor Brief"
weight: 22
description: "Hardening posture for auditors and red teams. 6.18.9 is the commercial baseline; measured scores still cite the published 5.19.6 stream."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "audit", "red-team"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite HS kernel — **6.18.9 primary** (commercial baseline, HeartSuite v1.6.4), **5.19.6 legacy**  
**Evidence status:** Published config SHA-256, checker output, and runtime verification exist for the **5.19.6** stream only. The **6.18.9** stream is the current commercial baseline (`6.18.9-HeartSuite-1.0`); measured evidence is in progress — see [Evidence Status](evidence-status/).  
**Primary stream (6.18.9):** [Kernel Hardening Comparison Matrix (6.18.9)](kernel-comparison-matrix-6.18.9/) — structure published; scores pending  
**Legacy stream (5.19.6):** Config SHA-256 `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc` — measured 2026-05-19, kernel-hardening-checker commit `b9b83a0` — [comparison matrix](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

The threat model and measured sections below describe the **published 5.19.6** dataset until `evidence-pack-6.18.9.txt` replaces them. Design intent for 6.18.9 includes disabling `CONFIG_IO_URING` and `CONFIG_KEXEC` (both enabled in 5.19.6).

---

## Threat Model

HeartSuite's kernel hardening targets one specific threat: **a process on the protected system attempting to bypass the kernel module's VFS-level enforcement**. The design choice is to remove the kernel features that make bypass possible, rather than to harden the kernel against general exploitation.

---

## What the measurements show

### Attack-surface reduction

Automated score: **91/132 (68.9%)**  
Reference points (era-matched, same 5.19.x kernel generation): Arch linux-hardened 5.19.11: 77/132 (58.3%). Vanilla upstream defconfig 5.17: 90/132 (68.2%). KSPP target (6.17, version-agnostic intent): 131/132 (99.2%).

HS outperforms production distros and common hardened-distro kernels on this axis. The reason: HS disables `BPF_SYSCALL`, `USER_NS`, `FUSE_FS`, `OVERLAY_FS`, `APPARMOR`, `TOMOYO`, and ~25 additional network/crypto/debug subsystems that Arch and NixOS keep enabled for their general-purpose user bases. These are the subsystems with the most relevant LSM-bypass CVE history.

**Caveat:** the automated checker scores vanilla 5.17 defconfig at 90/132, nearly identical to HS. This is because the checker does not distinguish *intentionally hardened to* a value from *never configured to begin with.* The vanilla defconfig also doesn't enable BPF or AppArmor by default. The operational difference is enforcement: a production system built on a vanilla defconfig will have these features added over time; HS's build procedure enforces the disables regardless.

### Exploit-resistance (KSPP-style mitigations)

Automated score: **31/109 (28.4%)**  
Reference points (era-matched): Arch linux-hardened 5.19.11: 69/109 (63.3%). Vanilla upstream defconfig 5.17: 29/109 (26.6%). KSPP target (6.17): 93/109 (85.3%).

HS's exploit-resistance posture is at the vanilla upstream baseline. It does not add `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM`, `KFENCE`, `RANDSTRUCT_FULL`, `KSTACK_ERASE`, `MODULE_SIG`, or the other ~57 KSPP mitigations that dedicated hardened kernels enable.

---

## Residual risks

**1. Kernel memory corruption / exploitation**  
HS provides no additional protection beyond vanilla upstream defaults for heap-based exploits (use-after-free, double-free, type confusion). An attacker who can reach a vulnerable in-kernel code path with sufficient primitive quality has no extra mitigations to contend with beyond `STACKPROTECTOR_STRONG`, `KASLR`, `RANDOMIZE_MEMORY`, and `STRICT_KERNEL_RWX` — all of which are vanilla defaults.

*Attack path:* Any reachable kernel vulnerability with reliable heap-layout control.

**2. SELinux runtime state — verified permissive**  
`CONFIG_SECURITY_SELINUX=y` with `CONFIG_DEFAULT_SECURITY_SELINUX=y`. SELinux is compiled-in. Runtime verification on the test VM (2026-05-19) shows:

- `/sys/fs/selinux/enforce` = `0` — permissive mode, no policy loaded
- `/proc/self/attr/current` = `kernel` — initial context, no confinement active
- securityfs is not mounted (no `/sys/kernel/security/lsm` file)

SELinux initializes at boot but does not enforce. Root Lock is the sole enforcing MAC LSM. dmesg confirms Root Lock is enforcing within 4 seconds of boot.

*Residual note for production:* this relies on runtime service configuration keeping SELinux permissive. Verify `cat /sys/fs/selinux/enforce` = `0` on each production deployment. A loaded SELinux policy that flips to enforcing mode would add a competing LSM to the stack.

**3. MODULE_SIG not enforced**  
`CONFIG_MODULE_SIG=n`. Kernel module signing is not enforced. A root-level attacker can load an arbitrary unsigned kernel module, including one that unloads or bypasses HeartSuite's VFS hooks.

*Mitigating factor:* Lockdown's `kmod` block (when engaged) prevents loading additional modules post-Lockdown. This is an operator-procedure-dependent mitigation, not a config-enforced one.

**4. Can root unseal the allowlist or turn enforcement off?**  
Root cannot lift the allowlist seal or turn enforcement off. There is no agent to kill, no module to unload, and no LSM to set permissive. Seal and control integrity are kernel-enforced product contracts. What can still go wrong is whether some other kernel path can still write the seal or a HeartSuite control. Check sibling attributes and extra syscalls on the pin you deploy. Do not treat the architecture diagram as the gate list.

*Auditor action:* verify live gates on the **deployed ship pin** with the operator's regression suite or release checklist when available — do not assume completeness from architecture diagrams alone.

**5. Allowlist breadth after learning**  
Setup Mode records observed behaviour; operators ratify grants into the allowlist. Residual risk after Lockdown is not only whether enforcement can be disabled, but whether the ratified allowlist is wider than the intended least-privilege slice (NIST-style residual on configuration scope). Over-broad program, file, or network grants increase blast radius inside an otherwise sealed host.

*Auditor action:* sample allowlist entries against workload role; treat Setup Mode duration and review hygiene as part of control effectiveness, not only kernel config scores.

**6. Intentional maintenance and console recovery path**  
Supported recovery of a sealed allowlist requires booting the maintenance (Non-HS) kernel and using Dashboard Maintenance to lift immutability flags. That path requires physical presence — keyboard and monitor, serial port, or cloud provider serial console. This is intentional and documented; it is not a remote disable of the stoppable-agent class. Residual risk includes any operational process that weakens console or boot-path controls (shared hypervisor console credentials, unattended serial access, unrestricted out-of-band management).

**7. Confused deputy among allowlisted programs**  
Enforcement is per program identity. A process that is correctly allowlisted for a powerful role (package manager, backup helper, orchestration agent) can still be abused within its grants if an attacker controls its inputs or configuration. Residual risk is lateral or deputy misuse inside approved scope, not absence of a kernel gate.

**8. Portable open flags and size mutation under a read grant**  
POSIX leaves combining `O_TRUNC` with a read-only open **undefined**; truncation is guaranteed only with write open modes. Many Linux systems still truncate on `O_RDONLY|O_TRUNC` when DAC write allows; man-page NOTES document this fielded behaviour. By default Root Lock does **not** redefine that UAPI corner: residual risk includes size mutation via that open combination under a **read** file grant when **write** is not granted on the leaf. This is a scoped residual class under allowlist enforcement — not “enforcement is off,” not a Linux CVE to file, and not a claim that root can always wipe everything. Optional future product policy could elevate write-class checks or refuse the combination; that would be an explicit compatibility-owning choice, not the default live-with contract. See [Portable open flags and product policy](portable-open-flags-and-product-policy/).

*Auditor action:* document residual risk acceptance for this corner; sample sensitive leaves that hold read grants only; do not treat kernel.org bug filing as the primary control response.

---

## How to reproduce these measurements

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
grep -E "^(CONFIG_BPF_SYSCALL|CONFIG_FUSE_FS|CONFIG_OVERLAY_FS|\
CONFIG_SECURITY_APPARMOR|CONFIG_SECURITY_TOMOYO)" \
  config-5.19.6-HeartSuite-1.0
```

To verify LSM state on a running HeartSuite VM:

```bash
cat /sys/kernel/security/lsm
cat /proc/cmdline
```
