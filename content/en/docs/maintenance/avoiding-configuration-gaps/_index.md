---
title: "Avoiding Configuration Gaps"
weight: 1
description: "Strategies to prevent security gaps during maintenance and configuration."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "configuration"]
type: docs
toc: true
---

**Overview**: This is an advanced hardening guide. Lockdown seals HeartSuite's configuration with filesystem immutability, but programs like file editors and `rm` remain executable by default. For high-security environments, you can optionally restrict these tools during Lockdown to close additional attack surfaces. The Dashboard's Maintenance screen (`[t]`) guides you through maintenance workflows, and the Mode Switch screen (`[m]`) manages Lockdown status.

## Locking Down Maintenance Tools
- Programs like `rm` often need broad write access for maintenance.
- In production (lockdown), disable or restrict them to block misuse via vulnerabilities.

**Example**: Remove execution privileges from `rm` and make it immutable when Lockdown is applied. Restore access with `hs-unlock` for maintenance. The Dashboard displays the current lockdown status and guides you through unlocking when maintenance is needed.

> [!WARNING]
> Run `hs-unlock` before maintenance to avoid errors like "could not open file; errno:1."

## Handling Programs Needing Write Access in Lockdown
- Database servers need write permissions to their data files/directories.
- Limit to specific paths—do not allow universal writes.
- Note: Database security is handled by the program itself, not HeartSuite.

## Optional Hardening: Programs Requiring Broad Access During Lockdown
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
