---
title: "Batch Allowlisting Tools"
weight: 4
description: "CLI tools for scripted and automated allowlisting workflows."
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

These CLI tools are the integration points for external control: your central automation (Ansible playbooks, Terraform provisioners, GitOps pipelines, ServiceNow flows, Puppet, or custom scripts) prepares policy data and invokes the tools on each host to apply or harvest allowlists. See [Central Policy Management and External Control](../alerts/central-policy-management/) for patterns and examples; for Ansible fleets, the official `heartsecurity.root_lock` role documented there is the preferred declarative path over direct CLI invocation. Pre-seeding via these tools accelerates fleet onboarding for standard configurations.

## batch_record_add.py

`batch_record_add.py` creates allowlist entries in bulk from a plain text file of program paths — one path per line. For each path, it adds the program with `/usr/lib` and `/etc` as default allowed directories. This tool is located in `/.hs/sys/` and requires root:

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
> `batch_record_add.py` adds programs with hardcoded default directories — no metadata enrichment, no grouping, no per-program review. Use it only when you have independently verified the program list and understand that each entry will be approved with `/usr/lib` and `/etc` access. For standard setup, the Dashboard review queues provide the same result with full context.

## hs-manage-allowlist

`hs-manage-allowlist` provides a browser and editor for existing allowlist entries. It is not a review tool — it operates on entries that have already been created. Use it to inspect, modify, or remove existing entries:

```bash
# hs-manage-allowlist --help
```

Both tools require root. Run them from a root shell:

```bash
# sudo -s
```

Exit with Ctrl-D when finished.
