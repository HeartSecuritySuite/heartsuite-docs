---
title: "Kernel Security Transparency"
weight: 107
description: "CVE status for the HeartSuite Core Secure kernel — precise status and technical rationale for each relevant vulnerability, including Not Affected entries where the vulnerable code path is absent by design."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
type: docs
toc: true
---

**Overview**: Vulnerability scanners match on kernel version strings — when a scanner sees a kernel older than the version that introduced an upstream fix, it may flag the system as affected regardless of whether the vulnerable code path is compiled in. This page lists kernel CVEs relevant to HeartSuite Core Secure, with the exact status and technical reason for each. Auditors and compliance teams can reference it directly when reviewing scanner output.

## CVE Status

| CVE | Component | Status | Details |
|-----|-----------|--------|---------|
| [CVE-2026-31431](#cve-2026-31431) | algif_aead (AF_ALG) | Not Affected | Vulnerable code path not compiled in; Lockdown closes remaining paths |

## CVE-2026-31431

**Status**: Not Affected  
**Component**: algif_aead — the in-kernel AEAD interface exposed by the AF_ALG socket family (`CONFIG_CRYPTO_USER_API_AEAD`)  
**Upstream fix**: Linux 6.12.85 (LTS), 6.18.22 (LTS), 6.19.12 (LTS)

This CVE describes a privilege escalation through the AF_ALG socket interface. An attacker who can open an AF_ALG socket reaches `algif_aead_copy_sgl()`, exploits a copy-on-write failure in the scatter-gather list handling, and gains root.

`CONFIG_CRYPTO_USER_API_AEAD` is not compiled into the HeartSuite Core Secure kernel. The AF_ALG socket family is not available. An attempt to open an AF_ALG socket returns `EAFNOSUPPORT` — there is no `algif_aead` code present in the running kernel and therefore no reachable code path. The HeartSuite Core Secure kernel predates the upstream fix versions listed above, but the fix is not required: the fix removes a vulnerability in code that was never compiled in.

Lockdown closes the remaining question. Even if the code path were present, Lockdown — `chattr +i` filesystem immutability combined with the HeartSuite Core Secure kernel refusing runtime changes to the allowlist — removes every useful action root can take after gaining privilege. The kernel refuses to clear immutable flags. Mount operations are blocked in Secure Mode + Lockdown. Writes to the audit log are blocked. Root cannot modify the allowlist, add a backdoor, or persist across a reboot.

See [Deployment Scenarios → Production Servers](../introduction/deployment-scenarios/) for the architectural context of how Lockdown interacts with a privilege escalation reaching root.

## Scanner Guidance

When a scanner flags HeartSuite Core Secure for a CVE listed as Not Affected on this page, the result is a version-string match: the scanner has identified a kernel version older than the upstream fix but has not evaluated whether the vulnerable code path is compiled in.

Share this page with your auditor or scanner vendor as the primary reference. For compliance teams that require a configuration-level proof, the relevant kernel config flag can be confirmed on the HeartSuite Core Secure host:

```bash
$ grep CONFIG_CRYPTO_USER_API_AEAD /boot/config-$(uname -r)
CONFIG_CRYPTO_USER_API_AEAD=n
```

The result `CONFIG_CRYPTO_USER_API_AEAD=n` confirms the vulnerable code path is not compiled into the running kernel.
