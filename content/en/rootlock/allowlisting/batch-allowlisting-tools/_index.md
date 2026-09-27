---
title: "Allowlist many hosts without the Dashboard"
linkTitle: "Batch Allowlisting Tools"
weight: 4
description: "CLI tools for scripted allowlisting when the Dashboard queues are not the right path — image builds, fleets, and repeatable installs."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "allowlist", "tools", "cli"]
type: docs
aliases:
  - /docs/allowlisting/batch-allowlisting-tools/
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "batch-allowlisting-tools"
---

**Overview**: The Dashboard review queues handle allowlisting for routine setup, because grouped review and metadata enrichment give you the context to approve each program. The two command-line tools below are for scripted deployments and for managing allowlist entries directly when you work from a shell instead of the Dashboard.

These tools are also where external control plugs in. Central automation — Ansible playbooks, Terraform provisioners, GitOps pipelines, ServiceNow flows, Puppet, or custom scripts — prepares policy data and runs the tools on each host to apply or harvest allowlists. See [Central Policy Management and External Control](../../alerts/central-policy-management/) for patterns and examples.

For Ansible, the preferred path is the official `heartsecurity.root_lock` role, which declares allowlist programs and mode transitions on hosts where Root Lock is already installed. It is commonly composed inside larger provisioning playbooks that also handle OS hardening (e.g. dev-sec collection), installation, and host services.

**When to use these tools:** after Root Lock is installed and initial setup is complete, to add program lists — extras for your application stack, a list reused across hosts, or a bootstrap list scoped to a server role. A new host gets its full allowlist from an install-time baseline instead: harvest the baseline from a reference host, package it with installer pre-seed such as `--apo-seed`, and let Ansible install that package. Only that baseline shortens the multi-hour initial setup, because it carries each program's grants as well as its path. See [Two ways to seed the allowlist](../../alerts/central-policy-management/#two-ways-to-seed-the-allowlist).

Both tools live in `/.hs/sys/`, which is not on `PATH`, and both need root.

## batch_record_add.py

`batch_record_add.py` creates allowlist entries in bulk from a plain text file of program paths — one absolute path per line. For each path, it adds the program with `/usr/lib` and `/etc` as default allowed directories:

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
> `batch_record_add.py` approves every listed program with the same hardcoded directories and skips the metadata enrichment, grouping, and per-program review the Dashboard queues provide. Use it only for a program list you have verified independently, knowing that each entry gets `/usr/lib` and `/etc` access. Wait until initial setup has finished before you run it, unless you have a specific reason to seed earlier.

## hs-app-perm-orders-manager

`/.hs/sys/hs-app-perm-orders-manager` browses and edits allowlist entries directly, without the review context of the Dashboard queues. Use it to inspect, add, modify, or remove entries. `list` prints one row per entry (`Record # => program :: is interpreter?`), and `view -a` adds each program's directories and network destinations. For a central text seed with one program path per line, harvest with `get_allowlist_programs()` from the `limited_tools` Python API instead — see [Central Policy Management](../../alerts/central-policy-management/). The full command reference:

```bash
# /.hs/sys/hs-app-perm-orders-manager --help
```

Run both tools from a root shell:

```bash
# sudo -s
```

Exit with Ctrl-D when finished.
