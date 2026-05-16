---
title: "Script Launchers and Python Setup"
weight: 50
description: "Setting up secure launchers for scripts like Python, Perl, and PHP."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "php", "security", "interpreters"]
type: docs
toc: true
---

**Overview**: Without Secure Script Launchers, every Python, Perl, or PHP script would share the interpreter's permissions — if `python3` is allowed to access the network, every Python script can access the network. Secure Script Launchers solve this by giving each script its own allowlist entry, so you control exactly what each script can do. The Dashboard presents this as Phase 3 when script interpreters are detected on the system.

## In this section

- [How Script Launchers Work](how-launchers-work/) — Security rationale and how Secure Script Launchers enforce script permissions.
- [Configuring Script Launchers](configuring-launchers/) — Direct use for testing and permanent symbolic link setups.
- [Included Script Launchers](included-launchers/) — List of available launchers for Python, Perl, PHP, etc.

Once launchers are configured (or skipped), the Dashboard directs you to Phase 4: File Access Allowlisting via the File Access queue (`[f]`) — see [Allowlisting Basics](../allowlisting/allowlisting-basics/).
