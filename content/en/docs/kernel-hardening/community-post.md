---
title: "Kernel Hardening: HeartSuite's Unusual Design Choice"
weight: 50
draft: true
description: "A discussion-style post on HeartSuite Core Secure's kernel hardening philosophy — written for the kernel hardening and Linux security community."
categories: ["Community"]
tags: ["kernel", "hardening", "security", "BPF", "LSM", "design"]
type: docs
toc: false
---

*Subject: HeartSuite Core Secure, kernel 5.19.6. All numbers from kernel-hardening-checker (commit b9b83a0), run 2026-05-19. Config SHA-256: `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`. Full data: `evidence-pack-5.19.6.txt`.*

---

Most hardened kernels go heavy on KSPP-style mitigations — `INIT_ON_ALLOC`, `HARDENED_USERCOPY`, `FORTIFY_SOURCE`, `SLAB_FREELIST_RANDOM`, `KSTACK_ERASE`. HeartSuite 5.19.6 does none of that. Its self-protection score is 31/109 (28.4%), essentially at the vanilla upstream baseline.

For a fair comparison you need era-matched configs (same kernel generation). Arch `linux-hardened` at the 5.19.11 release — same kernel generation as HeartSuite — scores 69/109 (63.3%) on exploit-resistance using the same tool. The bundled configs in kernel-hardening-checker are 6.12–6.15 vintage and score 88–90/109, but comparing those to a 5.19.x kernel is not apples-to-apples. Worth knowing: NixOS `linux_hardened` was removed from nixpkgs in 2025 due to lack of maintenance — the bundled 6.12.50 config in the checker is a historical snapshot of a no-longer-maintained project.

So what does HeartSuite do instead? It removes subsystems.

---

## The Design Choice

The kernel ships with `CONFIG_BPF_SYSCALL=n`, `CONFIG_FUSE_FS=n`, `CONFIG_OVERLAY_FS=n`, `CONFIG_SECURITY_APPARMOR=n`, `CONFIG_SECURITY_TOMOYO=n`, `CONFIG_USER_NS=n`, and about 25 more disabled network, crypto, and debug subsystems. The result is an attack-surface score of 91/132 (68.9%) — higher than era-matched Arch linux-hardened 5.19.11 at 77/132 (58.3%).

At first glance this seems surprising. Hardened kernels score *lower* on attack-surface reduction than HeartSuite? Yes — because they keep BPF enabled (needed by systemd, containers, observability tooling), keep user namespaces enabled (needed by rootless Docker), and keep various crypto and network APIs available. HeartSuite is a single-purpose appliance and can remove all of these.

The interesting nuance: vanilla x86_64 defconfig 5.17 also scores 90/132 on attack surface — nearly identical to HS. The checker doesn't distinguish "not enabled by default" from "intentionally hardened off." Both have BPF and AppArmor absent. The difference is that the vanilla defconfig is a starting point; on a production system it will accumulate features. HeartSuite's build procedure enforces the disables on every port via a documented deviation registry and a checklist enforced mechanically.

---

## The Trade-off Is Real

HeartSuite optimizes for one threat: a compromised process attempting to bypass its custom kernel MAC enforcement via a kernel subsystem (BPF, FUSE, io_uring, overlay mounts, competing LSMs). It doesn't claim to harden against kernel exploitation in general.

If the attacker gets a reliable kernel heap primitive — use-after-free, type confusion — HeartSuite gives them vanilla KASLR and `STACKPROTECTOR_STRONG`. That's the same protection a defconfig kernel offers. Arch and NixOS hardened give them `SLAB_FREELIST_RANDOM`, `KFENCE`, `RANDSTRUCT`, `PAGE_TABLE_CHECK`, and more.

---

## The "Best Hardened Kernel" Question

If you're measuring by KSPP score: no, HS is not close to the top. The KSPP target config scores 91.8% overall; HS scores 50.0%.

If you're measuring by "what can a compromised sandboxed process use to escape": HS removes more of those primitives than any general-purpose hardened kernel can, because those kernels have users who need the features. BPF is the clearest example — both the 5.19.11 and current `linux-hardened` keep `BPF_SYSCALL=y`. HeartSuite doesn't.

It's a different point in the design space. Not better or worse globally — optimized for a different threat model.

---

*Full comparison data, per-category breakdowns, and reproduction instructions are in `kernel-comparison-matrix-5.19.6.md` and `evidence-pack-5.19.6.txt`. Corrections welcome.*
