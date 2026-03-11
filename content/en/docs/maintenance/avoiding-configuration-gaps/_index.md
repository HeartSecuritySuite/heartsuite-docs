---
title: "Avoiding Configuration Gaps"
weight: 1
description: "Strategies to prevent security gaps during maintenance and configuration."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "configuration"]
type: docs
toc: true
---

# Avoiding Gaps in Your HeartSuite Configuration

Many whitelisted programs (e.g., file editors, rm) are useful during maintenance but should be locked down during normal operation to prevent attacks.

## Locking Down Maintenance Tools
- Programs like `rm` often need broad write access for maintenance.
- In production (lockdown), disable or restrict them to block misuse via vulnerabilities.

**Example**: Remove execution privileges from `rm` and make it immutable in `HS_lockdown.sh`. Unlock with `HS_unlock.sh` for maintenance.

> [!WARNING]
> Run `HS_unlock.sh` before maintenance to avoid errors like "could not open file; errno:1."

## Handling Programs Needing Write Access in Lockdown
- Database servers need write permissions to their data files/directories.
- Limit to specific paths—do not allow universal writes.
- Note: Database security is handled by the program itself, not HeartSuite.

## Special Cases: Programs Requiring Broad Access During Lockdown
Some programs (e.g., shutdown routines) need `rm` during operation.
- **Solution**: Create a limited copy (`limited_rm`) with restricted permissions.
- Configure scripts to use the copy in lockdown.

Setup steps:
1. Copy `rm` to `limited_rm` and rename original to `rm-orig`:
   ```bash
   # sudo cp /usr/bin/rm /usr/bin/limited_rm
   # sudo mv /usr/bin/rm /usr/bin/rm-orig
   # sudo ln -sf /usr/bin/limited_rm /usr/bin/rm
   ```
2. Reboot and whitelist with `hs-os-boot-setup.py`.
3. Update `HS_lockdown.sh` to disable `rm-orig` and make both immutable.
4. Update `HS_unlock.sh` to restore access.

Restore full `rm` for maintenance:
```bash
# sudo mv /usr/bin/rm-orig /usr/bin/rm
```

Now, scripts call `limited_rm` with restricted access during lockdown.