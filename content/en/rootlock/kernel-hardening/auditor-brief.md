---
title: "What a red team should test on this kernel"
linkTitle: "Auditor Brief"
weight: 22
description: "Threat model and residual risks for the kernel that ships, 6.18.9-hs build #43. The Debian 12 guest boot is the 18 August build #37 pack. 5.19.6 remains the legacy pack."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "audit", "red-team"]
type: docs
aliases:
  - /docs/kernel-hardening/auditor-brief/
toc: true
---

**Subject:** Root Lock by HeartSuite — **6.18.9-hs** build **#43** (packaging `6.18.9-HeartSuite-3`). **5.19.6** is the legacy stream.  
**Evidence status:** Checker scores for the kernel that ships are in [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt) (2026-10-02). The Debian 12 guest boot is build **#37**, [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt). The **5.19.6** pack remains the legacy measured stream.  
**Primary stream:** [Hardening matrix for kernel 6.18.9](kernel-comparison-matrix-6.18.9/)  
**Legacy stream:** Config SHA-256 `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc` — measured 2026-05-19, checker `b9b83a0` — [comparison matrix](kernel-comparison-matrix-5.19.6/), [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt)

On the kernel that ships, the BPF syscall is off, `CONFIG_IO_URING=y`, and `CONFIG_KEXEC` is unset.

---

## Threat model

Root Lock targets **a process on the protected system attempting to bypass VFS-level enforcement**. The BPF syscall is off on the 6.18.9-hs kernel that ships, so there is no eBPF program to load. The countermeasure is the allowlist and Lockdown.

---

## What the measurements show (build #43, checker run 2026-10-02)

Tool: [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) commit `e870d0141259f875d3d1b54fef49dec7074e4cac`, 2026-10-02, against packaging config SHA-256 `d6a08a04f4d6734adbafac431c3ebe46d339a495d907f1c6c569959321cc3684`.

Arch linux-hardened **6.18.16-hardened1** and vanilla **6.18.9** `defconfig` are the era-matched 6.18.x peers from the 18 August run of the same checker (no 6.18.9-hardened in the Arch archive). Keep these percentages off the 5.19.6 pack, because its checker commit (`b9b83a0`) counts a different set of items.

### Attack-surface reduction

Automated score: **62/131 (47.3%)**  
Era-matched Arch linux-hardened 6.18.16: 76/131 (58.0%). Era-matched vanilla 6.18.9 defconfig: 88/131 (67.2%). KSPP x86-64 intent: 131/131 (100%).

Build #43 trails both era-matched peers on this axis. Five checks moved to OK since build #37: `CONFIG_BPF_SYSCALL`, `CONFIG_KEXEC`, `CONFIG_KEXEC_FILE`, `CONFIG_CRASH_DUMP`, and `CONFIG_PROC_VMCORE`.

### Exploit-resistance (KSPP-style mitigations)

Automated score: **78/110 (70.9%)**  
Era-matched Arch linux-hardened 6.18.16: 92/110 (83.6%). Era-matched vanilla 6.18.9 defconfig: 56/110 (50.9%). KSPP: 93/110 (84.5%).

This pin scores above vanilla 6.18.9 `defconfig` on this axis. Present: `INIT_ON_ALLOC_DEFAULT_ON`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM`, `SLAB_FREELIST_HARDENED`, `KFENCE`, `MODULE_SIG`. Still missing or unforced: `INIT_ON_FREE_DEFAULT_ON`, `MODULE_SIG_FORCE`, `RANDSTRUCT_FULL`, `KSTACK_ERASE`, `KFENCE_SAMPLE_INTERVAL=0`.

Overall checker: **153/259 (59.1%)**.

### Runtime (Debian 12 guest, 2026-08-18, build #37)

This guest boot was not repeated for build #43. Debian 12 lab guest, `uname -r` **`6.18.9-hs`**, `file` **#37**, vmlinuz SHA-256 `1b44fffb9b570497f19f4c68e170602b542bc84bfe9f49d936c123dc59f5db8a`.

- `/sys/kernel/security/lsm` = `lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm`
- No selinuxfs. `/proc/self/attr/current` = `unconfined`
- dmesg: LSM list above at t+0.05s; `activating Heartsuite service` / monitor ON at t+4s
- Guest `/boot/config-6.18.9-hs` is an **11-line initramfs RD stub**, not the build config. Hash the pin payload config, not that file.

---

## Residual risks

**1. Kernel memory corruption / exploitation**  
Self-protection scores 78/110, well above the vanilla baseline that 5.19.6 sat near, but heap and CFI gaps remain: no `INIT_ON_FREE_DEFAULT_ON`, no `KSTACK_ERASE`, no `RANDSTRUCT_FULL`, KFENCE sample interval 0, IOMMU default is lazy. An attacker who reaches a reliable in-kernel primitive still has those gaps.

**2. Competing LSMs are live**  
The 5.19.6 description (Root Lock as the sole enforcing MAC, SELinux permissive, no securityfs) does not hold on this pin. AppArmor, TOMOYO, Yama, Landlock, BPF LSM, IMA, and EVM initialize. Red-team work must include stacked-LSM interaction (policy denials, IMA, AppArmor profiles), not only Root Lock.

**3. MODULE_SIG is on; MODULE_SIG_FORCE is not**  
`CONFIG_MODULE_SIG=y`, but `CONFIG_MODULE_SIG_FORCE` is not set and `kernel.modules_disabled=0`, so the kernel does not refuse unsigned modules on its own. Lockdown's module-load block covers that gap only once you engage Lockdown, and only for modules loaded after that point.

**4. Can root unseal the allowlist or turn enforcement off?**  
By design, root has no intended path to lift the allowlist seal or turn enforcement off, because there is no agent to kill: the seal and the control paths are enforced in the kernel. Test that contract rather than reading it off the architecture diagram, and confirm on the kernel that ships (`6.18.9-hs`) that additional syscalls and related attributes are gated as well.

The checker percentages measure only the published `.config`, so read them together with this residual-risk list during architecture review.

**5. Allowlist breadth after learning**  
Setup Mode records what programs do, and you approve the resulting allowlist entries. Any entry wider than the workload needs stays in force after Lockdown.

**6. Intentional maintenance and console recovery path**  
Supported recovery of a sealed allowlist requires booting the maintenance kernel and using Dashboard Maintenance to lift immutability flags. That path requires physical or serial-console access — keyboard and monitor, serial port, or cloud provider serial console.

**7. Confused deputy among allowlisted programs**  
Enforcement is per program identity, so an allowlisted program with broad grants can still be abused within those grants.

**8. Portable open flags and size mutation under a read grant**  
By default Root Lock keeps the standard Linux behaviour of `O_RDONLY|O_TRUNC`, so a program with a read grant can still truncate a file when DAC write permission allows it.

---

## How to reproduce these measurements

```bash
git clone https://github.com/a13xp0p0v/kernel-hardening-checker /tmp/khc
git -C /tmp/khc checkout e870d0141259f875d3d1b54fef49dec7074e4cac

# Use the pin payload config — NOT guest /boot/config-6.18.9-hs (11-line stub)
sha256sum config-6.18.9-hs
# Expected: d6a08a04f4d6734adbafac431c3ebe46d339a495d907f1c6c569959321cc3684

python3 /tmp/khc/bin/kernel-hardening-checker -c config-6.18.9-hs
# Expected summary: OK - 153 / FAIL - 106
```

Bypass-primitive greps on the **#43 packaging** config. `CONFIG_BPF_SYSCALL`, `CONFIG_KEXEC`, and `CONFIG_KEXEC_FILE` are unset, so they do not match a `=` line. `CONFIG_IO_URING=y`, `CONFIG_FUSE_FS=y`, `CONFIG_USER_NS=y`, `CONFIG_SECURITY_APPARMOR=y`, `CONFIG_SECURITY_TOMOYO=y`, and `CONFIG_OVERLAY_FS=m`.

```bash
grep -E "CONFIG_(BPF_SYSCALL|IO_URING|FUSE_FS|OVERLAY_FS|SECURITY_APPARMOR|SECURITY_TOMOYO|KEXEC|KEXEC_FILE|USER_NS)" \
  config-6.18.9-hs
```

The `/sys/kernel/security/lsm` reading below is the build #37 guest from 2026-08-18. A #43 guest boot was not recorded.

```bash
uname -r
# 6.18.9-hs
python3 -c "print(open('/sys/kernel/security/lsm').read())"
# lockdown,capability,landlock,yama,apparmor,tomoyo,bpf,ipe,ima,evm
```

Full raw notes: [`evidence-pack-6.18.9.txt`](../evidence-pack-6.18.9.txt). Guest boot: [`evidence-pack-6.18.9-2026-08-18.txt`](../evidence-pack-6.18.9-2026-08-18.txt).
