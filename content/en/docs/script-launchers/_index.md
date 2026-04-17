---
title: "Script Launchers and Python Setup"
weight: 60
description: "Setting up secure launchers for scripts like Python and Perl."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "security", "interpreters"]
type: docs
toc: true
---

**Overview**: Without Secure Script Launchers, every Python or Perl script would share the interpreter's permissions — if `python3` is allowed to access the network, every Python script can access the network. Secure Script Launchers solve this by giving each script its own allowlist entry, so you control exactly what each script can do. The Dashboard presents this as Phase 3 when script interpreters are detected on the system.

## In This Section

- [How Script Launchers Work](how-launchers-work/) — Security rationale and how Secure Script Launchers enforce script permissions.
- [Configuring Script Launchers](configuring-launchers/) — Direct use for testing and permanent symbolic link setups.
- [Included Script Launchers](included-launchers/) — List of available launchers for Python, Perl, PHP, etc.
