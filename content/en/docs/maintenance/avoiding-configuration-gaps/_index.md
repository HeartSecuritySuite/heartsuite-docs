---
title: "Avoiding Configuration Gaps"
weight: 1
description: "How HS_lockdown.sh disables file editors during Lockdown, and how to extend the same protection to rm, cp, and mv so a compromised approved program cannot use them for damage."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "configuration"]
type: docs
toc: true
---

**Overview**: Lockdown seals HeartSuite Core Secure's configuration with filesystem immutability. The shipped `HS_lockdown.sh` script also disables common file editors (`nano`, `vim`, `sed`, `ed`) by removing their execute bit and making them immutable. For tools that must stay available during Lockdown — `rm`, `cp`, `mv` — `HS_lockdown.sh` supports an optional setup where you rename the original and replace it with a restricted copy before Lockdown engages, so a vulnerability in an approved program cannot use them for damage. The Dashboard's Maintenance screen (`[t]`) guides you through maintenance workflows, and the Mode Switch screen (`[m]`) manages Lockdown status.

## Locking Down Maintenance Tools

Programs like `rm` often need broad write access during maintenance, but in production that same access becomes a way for a compromised approved program to do damage. Restrict these tools using the rename pattern below so a vulnerability in an approved program cannot turn them against the system. Restore access with `HS_unlock.sh` before any maintenance window — the Dashboard's Maintenance screen (`[t]`) does this for you as Step 1 of the guided Lockdown maintenance flow.

> [!WARNING]
> After Lockdown is disengaged, files that `HS_lockdown.sh` sealed against change stay sealed until `HS_unlock.sh` runs. The Dashboard's Maintenance screen (`[t]`) does this for you as Step 1. If you skip it and try to write, you'll see "could not open file; errno:1" — run `HS_unlock.sh` or use the Dashboard's `[u]` action and try again.

## Write Access During Lockdown

A database server needs write access to its data files. In Setup Mode, approve write access from the Dashboard's File Access queue (`[f]`) for those specific paths only — never grant universal write access. If the database server is later compromised in production, the allowlist still limits its writes to the approved paths.

> [!NOTE]
> Database security is handled by the program itself, not HeartSuite Core Secure.

## Programs That Need Broad Access During Lockdown
Some programs (e.g., shutdown routines) need `rm` during operation, but you may want to restrict the full `rm` binary.
- Create a limited copy (`limited_rm`) with restricted permissions.
- Configure scripts to use the copy during Lockdown.

Setup steps:
1. Copy `rm` to `limited_rm` and rename original to `rm-orig`:
   ```bash
   # sudo cp /usr/bin/rm /usr/bin/limited_rm
   # sudo mv /usr/bin/rm /usr/bin/rm-orig
   # sudo ln -sf /usr/bin/limited_rm /usr/bin/rm
   ```
2. Reboot and allowlist `limited_rm` from the Dashboard's Programs queue (`[p]`).
3. Update the Lockdown configuration to disable `rm-orig` and make both immutable.
4. Update `HS_unlock.sh` (a user-customisable script) to reverse the changes when Lockdown is disengaged.

Restore full `rm` for maintenance:
```bash
# sudo mv /usr/bin/rm-orig /usr/bin/rm
```

During Lockdown, scripts use `limited_rm` with restricted access.
