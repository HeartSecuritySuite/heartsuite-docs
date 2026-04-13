---
title: "How Script Launchers Work"
weight: 1
description: "Explanation of HeartSuite's secure script launchers and their security benefits."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "security", "interpreters", "launchers"]
type: docs
toc: true
---


## Overview

Certain programs, known as **interpreter programs** (e.g., Python, PHP, Perl, Bash), execute code from files. Without Script Launchers, these interpreters would need broad permissions, creating security risks.

## Security Benefits

HeartSuite allows **individual allowlist entries for script files** (e.g., `script.py`), enabling fine-grained access control per script rather than giving wide permissions to the interpreter.

- Scripts are treated like regular programs: each can have its own permissions.
- Interpreters can even be blocked entirely, ensuring only allowlisted scripts run.

## Using Launchers

To enforce this, HeartSuite provides **Secure Script Launchers** called Secure Script Launchers (e.g., `hs-python-launcher`). These launch the interpreter but apply the script's allowlist entry instead.