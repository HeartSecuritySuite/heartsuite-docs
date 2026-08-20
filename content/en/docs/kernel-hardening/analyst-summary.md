---
title: "Kernel hardening in plain language"
linkTitle: "Analyst Summary"
weight: 60
description: "What Root Lock removes from the kernel, why, and how to fact-check the claims — for journalists, analysts, and non-specialists."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "overview"]
type: docs
toc: false
---

*Kernel: Root Lock by HeartSuite 5.19.6. Config hash: `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`. Measured: 2026-05-19.*

---

Root Lock ships a Linux kernel with 9 loadable modules. A standard Debian Linux system typically ships 3,500 to 4,000.

That count is not a capability cut. The kernel is built for one job. Nothing else is included.

Root Lock also disables the kernel features most often used to bypass security controls: BPF (a programmable kernel interface), FUSE (user-space filesystems), overlay filesystems, and competing security policy engines including AppArmor and SELinux. Each of these has been used in documented real-world attacks to escape software sandboxes or override security policies.

On a run of the open-source `kernel-hardening-checker` config linter — the same tool Linux kernel security researchers use — the Root Lock kernel outperforms Arch linux-hardened on attack-surface measures.

Scores, compared on the same 5.19.x kernel generation so they are directly equivalent: **91 out of 132** checks passed by Root Lock versus **77 out of 132** for Arch linux-hardened.

Arch linux-hardened scores lower on this axis because it keeps BPF, FUSE, and AppArmor enabled. Its general-purpose users depend on those features. They also provide paths for bypassing security controls.

**Where Root Lock is not strongest:** Exploit resistance.

When a kernel vulnerability is discovered — a memory bug, a logic flaw — certain protection techniques make it much harder to turn that bug into a working attack. The Root Lock kernel does not include most of those techniques. It scores **31 out of 109** checks on this measure. The era-matched Arch linux-hardened kernel (same kernel generation) scores **69 out of 109** on the same tool.

Root Lock is designed to prevent attacks from bypassing its controls. It is not designed to harden against every possible kernel vulnerability.

The configuration is publicly verifiable. The SHA-256 hash of the kernel configuration file is published. Any qualified security team can reproduce the measurements above using publicly available tools.

---

**For fact-checkers:** All numbers in this summary derive from `evidence-pack-5.19.6.txt` and `kernel-comparison-matrix-5.19.6.md` in this same document section. Tool: [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) at commit `b9b83a0`. Every claim can be independently reproduced.
