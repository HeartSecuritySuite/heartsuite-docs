---
title: "Stop kmod from loading just any module"
linkTitle: "Restricting Kernel Module Loading"
weight: 5
description: "If kmod can execute, limit which module files it may read before Lockdown. Directory grants under /lib/modules are the real risk."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "kmod", "modules"]
type: docs
aliases:
  - /docs/maintenance/kmod-hardening/
toc: true
---

**Overview**: Root Lock by HeartSuite has no separate `init_module` check for kernel modules, so what kmod may load is what it may read. If `kmod`, `modprobe`, or `insmod` can execute and can read a `.ko` file, that module can be loaded.

If your hardware requires kmod at startup to load device drivers or filesystem modules, kmod must have an allowlist entry. Restrict that entry's file access to only the specific modules it needs before engaging Lockdown. An allowlisted kmod with unrestricted file access can load any module on the machine.

## When no extra work is needed

If `kmod`, `modprobe`, and `insmod` have no allowlist entries, Lockdown refuses to execute them. You can skip the rest of this page.

## When kmod is allowlisted

Some hardware configurations require kmod at startup to dynamically load drivers or filesystem modules the system needs to boot. Once kmod has an allowlist entry, it can execute — and without further restriction, kmod's file access permissions determine which modules it can load.

The hardening step is to narrow those file access permissions to the specific module paths kmod legitimately needs, because an allowlisted kmod with directory-level read under `/lib/modules` can open module files that were never observed during Setup Mode. Under Lockdown, if kmod tries to load a module outside its permitted paths, Root Lock denies the file access before the module can be read.

## Narrow file access before Lockdown

Do this before you type `YES` on Lockdown, because once Lockdown is active the allowlist entries are sealed and changing them takes a [maintenance window](../protecting-during-maintenance/).

When kmod's startup activity appears in the File Access queue (`[f]`) during Setup Mode, approve individual `.ko` paths rather than directory-level access. Approving a directory grants read access to everything under it — including modules not present during observation.

If directory grants under `/lib/modules` are still present when you open Lockdown (`[l]`), seal prep **auto-narrows** them. That panel is advisory and does not ask for `YES`; pressing `[m]` there undoes the narrowing rather than opening Maintenance. Under Lockdown the same inventory is read-only.

Handle any grants left after auto-narrowing in Allowed (`[a]`) or File Access (`[f]`); the Dashboard, not a CLI, is the normal path.

After narrowing, reboot and confirm the machine starts with no unexpected kmod denials in the review queues. Then activate Lockdown (`[l]`).

## What stays sealed after Lockdown

After Lockdown engages:

- **Allowlist entries are sealed** — kmod's entry cannot be modified while Lockdown is active.
- **Startup scripts are sealed** — system-wide shell configuration, systemd unit directories, and cron. Attackers cannot insert scripts that would run before Lockdown re-engages on the next boot and expand kmod's permissions.

Module loading under Lockdown is therefore limited by the program allowlist plus file access on module paths.

## Per-user shell profile coverage

Lockdown seals system-wide shell configuration — `/etc/profile`, environment defaults, and cron — preventing an attacker from planting scripts that run at the next boot and expand kmod's permissions before Lockdown re-engages. Per-user profile files (`~/.bash_profile`, `~/.bash_login`, `~/.profile`, `~/.bashrc`, `~/.inputrc`) are not covered automatically because the correct set depends on your user configuration.

If specific user accounts need that coverage, do it in Setup Mode (before the first Lockdown, or after unseal). The Dashboard has no per-user profile picker, so edit the scripts: uncomment those users' profile lines in `HS_lockdown.sh` and the matching reverse lines in `HS_unlock.sh`. Then lock down from Lockdown (`[l]`).
