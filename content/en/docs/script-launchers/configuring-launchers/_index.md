---
title: "Configuring Script Launchers"
weight: 2
description: "Setting up HeartSuite script launchers for secure script execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "security", "interpreters"]
type: docs
toc: true
---

## Configuring Script Launchers

There are two main ways to use Script Launchers:

### Direct Use (For Testing)
Run the launcher directly to test scripts.

1. Configure the launcher to point to the interpreter:
   ```bash
   # /.hs/sys/hs-secure-script-launcher-manager add -t PYTHON3 -i /usr/bin/python3
   ```
   (Points `hs-python-launcher` to Python3.)

2. Launch scripts using the launcher:
   ```bash
   # hs-python-launcher /.hs/sys/hs-os-boot-setup.py
   ```

This applies the script's allowlist; direct `python3` uses the interpreter's allowlist.

**Tip**: Use direct launcher for initial testing.

### Redirecting Symbolic Links (Permanent Setup)
Make the interpreter's symbolic link point to the launcher for seamless use.

1. Configure the launcher:
   ```bash
   # /.hs/sys/hs-secure-script-launcher-manager add -t PYTHON3 -i /usr/bin/python3.10
   ```

2. Redirect the link:
   ```bash
   # ln -sf /usr/bin/hs-python-launcher /usr/bin/python3
   ```

Now, any `python3` command launches via `hs-python-launcher`, using the script's allowlist.