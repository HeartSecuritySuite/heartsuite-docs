---
title: "Avoiding Configuration Gaps"
weight: 1
description: "How to restrict maintenance tools like rm during Lockdown to close attack surfaces in high-security environments."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "configuration"]
type: docs
toc: true
---

**Overview**: Lockdown seals HeartSuite Core Secure's configuration with filesystem immutability, but programs like file editors and `rm` remain executable by default. For high-security environments, you can optionally restrict these tools during Lockdown to close additional attack surfaces. The Dashboard's Maintenance screen (`[t]`) guides you through maintenance workflows, and the Mode Switch screen (`[m]`) manages Lockdown status.

## Locking Down Maintenance Tools

Programs like `rm` often need broad write access during maintenance, but in production that same access becomes an attack surface. Disable or restrict these tools while Lockdown is active so a vulnerability in an approved program cannot exploit them. Restore access with `hs-unlock` before any maintenance window — the Dashboard's Maintenance screen (`[t]`) guides you through that process.

> [!WARNING]
> Run `hs-unlock` before maintenance to avoid errors like "could not open file; errno:1."

## Write Access During Lockdown

Database servers and similar programs need write permissions to their data files and directories. Limit allowlist entries to specific paths — do not grant universal write access.

> [!NOTE]
> Database security is handled by the program itself, not HeartSuite Core Secure.

## Programs That Need Broad Access During Lockdown
Some programs (e.g., shutdown routines) need `rm` during operation, but you may want to restrict the full `rm` binary.
- **Solution**: Create a limited copy (`limited_rm`) with restricted permissions.
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
4. Update `hs-unlock` configuration to restore access.

Restore full `rm` for maintenance:
```bash
# sudo mv /usr/bin/rm-orig /usr/bin/rm
```

Now, scripts call `limited_rm` with restricted access during lockdown.
