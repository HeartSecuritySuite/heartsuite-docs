---
title: "Restrict kmod before modules are locked at boot"
linkTitle: "Restricting Kernel Module Loading"
weight: 5
description: "Early in every boot, before the network comes up, Root Lock locks kernel module loading until reboot, even for root. File grants on kmod limit what it can load before that point."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "kmod", "modules"]
type: docs
aliases:
  - /docs/maintenance/kmod-hardening/
toc: true
---

**Overview**: Root Lock blocks kernel module loading with a latch: a kernel setting that, once switched on, stays on until the next reboot.

The latch is `heartsuite-kernel-latch.service`. It runs early in every Root Lock kernel boot, Setup Mode included, before the network is configured and before sshd starts. It first loads the netfilter modules the firewall needs. Then it sets `kernel.modules_disabled=1`, and `kernel.kexec_load_disabled=1` where the kernel has that setting. From then until reboot, the kernel refuses to load or unload any module (`init_module`, `finit_module`, `delete_module`), even for root or an allowlisted `kmod`. Modules already loaded stay loaded. The kernel setting does the blocking, not a Root Lock check.

`HS_lockdown.sh` sets the same values again, in case the latch service is masked. OpenRC systems have no latch service and get the settings only when Lockdown is applied.

This page is about early boot, before the latch runs. No file grant, including a read grant on `/usr/lib/modprobe.d/` or `/lib/modules`, reopens loading after it.

## When no extra work is needed

If `kmod`, `modprobe`, and `insmod` have no allowlist entries, Root Lock refuses to run them, so they cannot load a module before the latch either. You can skip the rest of this page. Standard Setup does allowlist `kmod`, so on most systems the next section applies.

## When kmod is allowlisted

Some hardware configurations require kmod at startup to load drivers or filesystem modules. Standard Setup allowlists `kmod` via `systemd-modules-load.service`. The latch runs after udev's initial device scan, `systemd-modules-load.service`, the `binfmt_misc` mount, and `ufw.service` (when enabled). Until then, an allowlisted `kmod` can load any module it can read.

Narrow those file grants to the module paths kmod needs. An allowlisted kmod with a directory read under `/lib/modules` can open module files that were never observed during Setup Mode. Narrow grants make Root Lock refuse that read before the latch runs. The latch's own netfilter preload is a fixed list; file grants neither add to it nor extend loading past the latch.

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

After the latch, `kernel.modules_disabled` refuses every module load. Before it, the allowlist and kmod's file grants are what limit loading.

## Per-user shell profile coverage

Lockdown seals system-wide shell configuration — `/etc/profile`, environment defaults, and cron — preventing an attacker from planting scripts that run at the next boot and expand kmod's permissions before Lockdown re-engages. A script that widens kmod's file grants still cannot load a module once the latch has run. Per-user profile files (`~/.bash_profile`, `~/.bash_login`, `~/.profile`, `~/.bashrc`, `~/.inputrc`) are not covered automatically because the correct set depends on your user configuration.

If specific user accounts need that coverage, do it in Setup Mode (before the first Lockdown, or after unseal). The Dashboard has no per-user profile picker, so edit the scripts: uncomment those users' profile lines in `HS_lockdown.sh` and the matching reverse lines in `HS_unlock.sh`. Then lock down from Lockdown (`[l]`).
