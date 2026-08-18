---
title: "Allowlist many hosts without the TUI"
linkTitle: "Batch Allowlisting Tools"
weight: 4
description: "CLI tools for scripted allowlisting when the Dashboard queues are not the right path — image builds, fleets, and repeatable installs."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "allowlist", "tools", "cli"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "batch-allowlisting-tools"
author: Ron Hessing
---

**Overview**: The Dashboard review queues handle allowlisting for routine setup — grouped review, metadata enrichment, and intelligent grouping cover most workflows. The tools below are for scripted deployments and direct allowlist management where CLI access is required.

These CLI tools are the integration points for external control. Central automation — Ansible playbooks, Terraform provisioners, GitOps pipelines, ServiceNow flows, Puppet, or custom scripts — prepares policy data and invokes the tools on each host to apply or harvest allowlists.

See [Central Policy Management and External Control](../../alerts/central-policy-management/) for patterns and examples.

The official `heartsecurity.root_lock` role (narrow post-install declarative management) is the preferred Ansible path for Root Lock-specific concerns. It is commonly composed inside larger provisioning playbooks that also handle OS hardening (e.g. dev-sec collection), installation, and host services.

**When to use these tools:** after Root Lock is installed and initial setup is complete, for additive program lists (stack extras, fleet reuse, role-scoped bootstrap). They are **not** the install-time allowlist baseline path.

For dense fleets, **seed the installer first** (harvest the allowlist from a reference host, package with pre-seed such as `--apo-seed`, then Ansible installs that package) — see [Central Policy Management](../../alerts/central-policy-management/). Do not use a full text dump here to skip multi-hour initial setup; that requires install-time pre-seed, not `batch_record_add.py`.

## batch_record_add.py

`batch_record_add.py` creates allowlist entries in bulk from a plain text file of program paths — one absolute path per line. For each path, it adds the program with `/usr/lib` and `/etc` as default allowed directories. This tool is located in `/.hs/sys/` and requires root:

```bash
# /.hs/sys/batch_record_add.py <file>
```

Where `<file>` contains one absolute program path per line, for example:

```text
/usr/bin/nano
/usr/bin/curl
/usr/bin/wget
```

> [!WARNING]
> `batch_record_add.py` adds programs with hardcoded default directories — no metadata enrichment, no grouping, no per-program review. Use it only when you have independently verified the program list and understand that each entry will be approved with `/usr/lib` and `/etc` access. For standard setup, the Dashboard review queues provide the same result with full context. Do not use this tool as a substitute for install-time baseline packaging, and do not run bulk seeds while initial setup is still running unless you have a deliberate exception.

## hs-manage-allowlist

`hs-manage-allowlist` provides a browser and editor for existing allowlist entries. It is not a review tool — it operates on entries that have already been created. Use it to inspect, modify, or remove existing entries. `hs-manage-allowlist list` is the usual harvest command when a reference host’s reviewed programs should feed a central text seed for other hosts:

```bash
# hs-manage-allowlist --help
```

Both tools require root. Run them from a root shell:

```bash
# sudo -s
```

Exit with Ctrl-D when finished.
