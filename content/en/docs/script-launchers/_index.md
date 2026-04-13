---
title: "Script Launchers and Python Setup"
weight: 60
description: "Setting up secure launchers for scripts like Python and Perl."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "security", "interpreters"]
type: docs
toc: true
---

**Overview**: Scripts (e.g., Python) need special launchers for fine-grained security—regular interpreters would over-share permissions. This appears as Phase 3 on the Dashboard with guided setup and suggested next step.

HeartSuite provides Secure Script Launchers to apply per-script permissions instead of granting broad access to interpreters like Python or Perl. This ensures only allowlisted scripts run securely.

## Key Guides
Dive into specific setup and reference areas:
- [How Script Launchers Work](how-launchers-work/) - Security rationale and how Secure Script Launchers enforce script permissions.
- [Configuring Script Launchers](configuring-launchers/) - Direct use for testing and permanent symbolic link setups.
- [Included Script Launchers](included-launchers/) - List of available launchers for Python, Perl, PHP, etc.
