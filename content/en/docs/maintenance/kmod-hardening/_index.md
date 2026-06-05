---
title: "Restricting Kernel Module Loading"
weight: 4
description: "How to limit kmod's file access permissions to specific modules before Lockdown engages, for deployments where kmod is allowlisted."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "kmod", "modules"]
type: docs
toc: true
---

**Overview**: HeartSuite Root Lock does not add `kmod`, `modprobe`, or `insmod` to the allowlist during installation — in Lockdown, none of them can execute, and no additional configuration is needed for module loading on a standard deployment. If your hardware requires kmod at startup to load device drivers or filesystem modules, kmod must have an allowlist entry. In that case, restrict kmod's file access permissions to only the specific modules it needs before engaging Lockdown. An allowlisted kmod with unrestricted file access can load any module on the system.

## Default deployments: no action required

If kmod, modprobe, and insmod have no allowlist entries, HeartSuite Root Lock refuses to execute them in Lockdown. No module-loading hardening is needed — skip this page.

## When kmod is allowlisted

Some hardware configurations require kmod at startup to dynamically load drivers or filesystem modules the system needs to boot. Once kmod has an allowlist entry, it can execute — and without further restriction, kmod's file access permissions determine which modules it can load.

The hardening step is to narrow those file access permissions to the specific module paths kmod legitimately needs. If kmod attempts to load a module outside its permitted paths, HeartSuite Root Lock blocks the file access in Lockdown before the module can be read.

## Restricting kmod's file access permissions

Do this before engaging Lockdown. Once Lockdown is active, allowlist entries are sealed and cannot be modified without a [maintenance window](../protecting-during-maintenance/).

When kmod's startup activity appears in the **File Access queue (`[f]`)** during Setup Mode, approve individual `.ko` file paths rather than directory-level access. Approving a directory grants kmod read access to everything under it — including modules not present during observation. Approving specific file paths limits kmod to exactly what it accessed during Setup Mode.

If kmod already has directory-level file access permissions, use `hs-manage-allowlist` to remove the broad entries and re-add specific paths. See `hs-manage-allowlist --help` for usage.

After narrowing kmod's file access permissions, reboot and confirm the system starts normally with no kmod access denials in the review queues. Then activate Lockdown from the Lockdown button (`[m]`). If kmod still has directory-level access at that point, the Lockdown confirmation surfaces an advisory before the YES prompt — you have one more opportunity to act before the configuration is sealed.

## Per-user shell profile coverage

Lockdown seals system-wide shell configuration — `/etc/profile`, environment defaults, and cron — preventing an attacker from planting scripts that run at the next boot and expand kmod's permissions before Lockdown re-engages. Per-user profile files (`~/.bash_profile`, `~/.bash_login`, `~/.profile`, `~/.bashrc`, `~/.inputrc`) are not covered automatically because the correct set depends on your user configuration.

If your deployment requires coverage for specific user accounts, enable the commented-out entries for those users in `HS_lockdown.sh` before engaging Lockdown.

## How Lockdown reinforces the restriction

After Lockdown engages, three layers protect against module-loading attacks:

- **Allowlist entries are sealed** — kmod's allowlist entry cannot be modified while Lockdown is active. An attacker cannot add new module paths even with root access.
- **Startup scripts are sealed** — Lockdown seals system-wide shell configuration, systemd unit directories, and cron. Attackers cannot insert scripts that would run before Lockdown re-engages on the next boot and expand kmod's permissions.
- **Kernel-level block** — Lockdown blocks new module loads at the kernel level, independently of the allowlist.
