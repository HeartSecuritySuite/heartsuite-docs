---
title: "Kernel hardening in plain language"
linkTitle: "Analyst Summary"
weight: 60
description: "Checker scores for the legacy 5.19.6 kernel, and how to fact-check them."
categories: ["Reference"]
tags: ["kernel", "hardening", "security", "overview"]
type: docs
aliases:
  - /docs/kernel-hardening/analyst-summary/
toc: false
---

*Kernel: Root Lock by HeartSuite 5.19.6. Config hash: `d67caa637263c33ce939b7eef867f0695d60d11d285d6694a7f5567e73ba6fbc`. Measured: 2026-05-19.*

---

> **Note:** 5.19.6 is the withdrawn k5 line, kept for lab re-proof on Debian 11 and Ubuntu 20.04. It has no customer support. New installs on every supported distribution run 6.18.9-hs, whose posture is in [Hardening matrix for kernel 6.18.9](../kernel-comparison-matrix-6.18.9/).

On a run of the open-source `kernel-hardening-checker` config linter — the same tool Linux kernel security researchers use — the Root Lock 5.19.6 kernel outperforms Arch linux-hardened on attack-surface measures.

Scores, compared on the same 5.19.x kernel generation so they are directly equivalent: **91 out of 132** checks passed by Root Lock versus **77 out of 132** for Arch linux-hardened.

**Where Root Lock is not strongest:** Exploit resistance.

When a kernel vulnerability is discovered — a memory bug, a logic flaw — certain protection techniques make it much harder to turn that bug into a working attack. The Root Lock kernel does not include most of those techniques, so it scores **31 out of 109** checks on this measure. The era-matched Arch linux-hardened kernel (same kernel generation) scores **69 out of 109** on the same tool.

Root Lock is designed to stop attacks from bypassing its controls rather than to harden the kernel against every possible vulnerability.

The configuration is publicly verifiable: the SHA-256 hash of the kernel configuration file is published, so any qualified security team can reproduce the measurements above with publicly available tools.

---

**For fact-checkers:** All numbers in this summary derive from [`evidence-pack-5.19.6.txt`](../evidence-pack-5.19.6.txt) and [Hardening scores: 5.19.6](kernel-comparison-matrix-5.19.6/) in this section. Tool: [kernel-hardening-checker](https://github.com/a13xp0p0v/kernel-hardening-checker) at commit `b9b83a0`. Every claim can be independently reproduced.
