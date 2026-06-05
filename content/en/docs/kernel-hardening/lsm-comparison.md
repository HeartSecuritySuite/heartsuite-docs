---
title: "LSM Comparison: HeartSuite vs SELinux, AppArmor, and TOMOYO"
weight: 35
description: "Comparison of Root Lock by HeartSuite's enforcement model against SELinux, AppArmor, and TOMOYO — focused on bypass-primitive resistance and purpose-fit for containment deployments."
categories: ["Reference"]
tags: ["kernel", "hardening", "SELinux", "AppArmor", "TOMOYO", "LSM", "comparison"]
type: docs
toc: true
---

**Subject:** Root Lock by HeartSuite, kernel 5.19.6  
**Audience:** Security engineers familiar with SELinux, AppArmor, or TOMOYO evaluating HeartSuite for containment or appliance deployments.

---

## The core distinction

SELinux, AppArmor, and TOMOYO all answer the same question: *given that a kernel feature is present, what should a process be allowed to do with it?*

HeartSuite answers a different question: *which kernel features should exist on this system at all?*

This is not a claim that one approach is universally superior. For **single-purpose containment appliances**, removing bypass primitives from the kernel is more reliable than writing policy around them — because policy can be misconfigured, and because certain primitives (BPF, FUSE, overlayfs) can defeat any MAC policy regardless of how carefully it is written.

---

## Comparison Table

| Dimension | HeartSuite 5.19.6 | SELinux | AppArmor | TOMOYO |
|---|---|---|---|---|
| **Enforcement model** | VFS-hook enforcement by purpose-built kernel module; structural (removes capabilities) | Type enforcement + MLS; label-based; process and object contexts | Path-based MAC; per-program profiles | Path-based MAC; learning-mode profiles |
| **Policy language** | None — enforcement is structural | Type Enforcement (.te), policy modules, audit2allow | Profile language, `aa-genprof` | Pathname-based domain rules; built-in learning mode |
| **Policy complexity** | None required | High — thousands of rules for a minimal deployment | Moderate | Low–Moderate |
| **Bypass-primitive removal** | **Yes** — BPF, FUSE, overlayfs, USER_NS, AppArmor, TOMOYO all disabled in kernel | No — BPF, FUSE, overlayfs, USER_NS present | No — BPF, FUSE, overlayfs, USER_NS present | No — BPF, FUSE, overlayfs, USER_NS present |
| **BPF LSM interaction** | N/A — `CONFIG_BPF_SYSCALL=n`; BPF does not exist on this system | Root with `CAP_BPF` can load BPF programs that return allow on every hook, defeating SELinux at runtime | Same — BPF can programmatically override AppArmor hook decisions | Same — BPF can programmatically override TOMOYO hook decisions |
| **Path-confusion resistance** | Structural — `FUSE_FS=n`, `OVERLAY_FS=n` | Policy-dependent; FUSE and overlayfs present; path-derived label resolution is susceptible to overlay path confusion | **Directly affected** — profile matching is path-based; overlayfs and FUSE can present unexpected paths to AppArmor | **Directly affected** — enforcement is path-based; same exposure as AppArmor |
| **Competing LSM interaction** | Sole enforcing MAC. AppArmor and TOMOYO are kernel-disabled. SELinux (where present) fires after HS and can only add restrictions — see [Co-existence](#co-existence) | Can stack with other LSMs (Linux 5.1+); interaction correctness depends on policy coordination | Can stack with SELinux, YAMA, others | Can stack; rarely used in stacked configurations |
| **USER_NS exposure** | `CONFIG_USER_NS=n` — fake-root environments not possible | USER_NS present; policy must account for namespace-derived privilege | USER_NS present; profile model does not natively track namespace context | USER_NS present |
| **Runtime modules loaded** | **0 loaded** (13 available) | Depends on distro | Depends on distro | Depends on distro |
| **Primary use case** | Single-purpose appliance; containment of untrusted code | General-purpose server, government/enterprise multi-user systems | General-purpose desktop/server (Ubuntu/SUSE default) | Introspection, auditing, learning-mode policy generation |
| **Policy misconfiguration risk** | None — no policy to misconfigure | **High** — overly permissive `audit2allow` output is a well-known deployment failure mode | Moderate | Low (learning mode reduces error) |

---

## Bypass primitives: open vs closed

The table below lists the kernel-level bypass vectors most relevant to MAC enforcement. "Closed" means the kernel option is disabled — the attack vector does not exist on the system. "Open" means the feature is present and policy must account for it.

| Bypass vector | HeartSuite 5.19.6 | SELinux | AppArmor | TOMOYO |
|---|---|---|---|---|
| `BPF_SYSCALL` — programmable LSM hook override | **Closed** (`=n`) | Open | Open | Open |
| `FUSE_FS` — path confusion via userspace filesystem | **Closed** (`=n`) | Open | Open | Open |
| `OVERLAY_FS` — `d_path()` mismatch in overlay mounts | **Closed** (`=n`) | Open | Open | Open |
| `USER_NS` — fake root via user namespace | **Closed** (`=n`) | Open | Open | Open |

An attacker who can reach any "Open" primitive has a path to bypass LSM enforcement regardless of how well the policy is written. HeartSuite closes all four vectors above at the kernel config level.

---

## When SELinux, AppArmor, or TOMOYO is the right choice

HeartSuite is not a general-purpose MAC replacement. Choose SELinux, AppArmor, or TOMOYO when:

- You are running a **general-purpose multi-user system** where diverse workloads need fine-grained per-process policy.
- You require **MLS / MCS** (Multi-Level Security / Multi-Category Security) for labeled data separation.
- You need **container runtime support** that depends on USER_NS or overlayfs (Kubernetes, Docker, Podman, LXC).
- Your compliance framework mandates a specific named LSM (e.g., STIG-mandated SELinux).
- You need to audit **permitted accesses**, not just denials — HeartSuite logs every denied file access, socket connection, and sandbox violation with the specific program path and target resource, but successful accesses are not logged. SELinux and TOMOYO can record both. If a full allowed-access trail is also required, SELinux can run alongside HeartSuite on supported deployments — see [Co-existence](#co-existence).

---

## When HeartSuite is the right choice

Choose HeartSuite when:

- You are deploying a **single-purpose appliance** running one or a small set of known workloads.
- Your threat model centers on **containment escape** — a compromised application attempting to break out of its enforcement boundary.
- You want **zero policy surface** — no policy file, no `audit2allow`, no profile to misconfigure.
- BPF tooling, container runtimes, FUSE mounts, and user namespaces are **not part of the system's attack surface** — they are absent from the kernel, not restricted by policy.
- You want a **violation-focused audit trail**: every denied file access, network connection, and sandbox violation is logged with the specific program path and target resource. In Setup Mode, would-be denials are logged and permitted simultaneously — giving full visibility into the policy surface without blocking anything.
- You want independent verifiability: the kernel config SHA-256 is published and measurements are reproducible with an open-source tool.

---

## Co-existence

HeartSuite does not stack with AppArmor or TOMOYO. Both are kernel-disabled (`CONFIG_SECURITY_APPARMOR=n`, `CONFIG_SECURITY_TOMOYO=n`).

**SELinux** behaves differently depending on the deployment OS:

HeartSuite's VFS hooks fire **before** the LSM chain (`security_path_*()` calls). The ordering means:

- If HeartSuite **denies** an operation → the SELinux hook is never reached. HeartSuite is the first and final authority on that call.
- If HeartSuite **allows** an operation → SELinux can still deny it. SELinux can only **add** restrictions to what HeartSuite allows, never grant access HeartSuite denies.

This is intentional and safe. On RHEL/Fedora, SELinux is Enforcing by default; the stacking is additive, not conflicting. On Debian/Ubuntu, no SELinux policy is loaded by default. Either way, HeartSuite's enforcement cannot be bypassed via the SELinux layer.

*RHEL operational note:* As with any new kernel module on RHEL, a targeted SELinux policy entry may be needed for HeartSuite's specific operations. If AVC denials appear, `ausearch -m AVC -ts recent | audit2why` identifies them and `audit2allow` generates the targeted module. HeartSuite's enforcement is unaffected — SELinux operates after HS in the hook chain and cannot override HS decisions.

---

## Further reading

- [Comparison Matrix](../kernel-comparison-matrix-5.19.6/) — Measured kernel-hardening-checker scores: HeartSuite vs Arch linux-hardened vs vanilla defconfig.
- [Auditor Brief](../auditor-brief/) — Residual risks, threat model, and self-reproduction instructions.
- [Procurement Brief](../procurement-brief/) — Decision guide for buyers choosing between hardened kernel options.
