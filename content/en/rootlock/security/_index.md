---
title: "Kernel Security Transparency"
linkTitle: "Kernel Security Transparency"
weight: 107
description: "Kernel CVE status on 6.18.9-hs: Not affected, Affected, or Fixed. Open rows stay on the patch date."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
type: docs
aliases:
  - /docs/security/
markup:
  tableOfContents:
    startLevel: 2
    endLevel: 2
---

**Overview**: This page is the status of kernel CVEs on the Root Lock kernel you boot. `uname -r` is `6.18.9-hs`. Kernel 5.19.6 is an archived line. A CVE in an application you run, such as a web server or a database, is outside this list. If that program is on your allowlist, its bug still fires.

| State | What it means | Where to read it |
|-------|----------------|------------------|
| **Not affected** | That option is unset, so the vulnerable code is absent. | [Disabled features](disabled-features/) |
| **Affected** | The code is in the kernel you boot. The row stays on the patch date. | The table below, then the write-up |
| **Fixed** | 6.18.9-hs already has the upstream fix. | [Compiled-in CVEs](compiled-in-cves/) |

On this kernel the BPF syscall is off, so there is no eBPF program to load. The guest file `/boot/config-6.18.9-hs` is an 11-line stub, and a `grep` of it is not the proof. The proof is the build configuration named on [Evidence Status](../kernel-hardening/evidence-status/). These rows were read from that configuration and the kernel source. No exploit was run to produce them.

The long write-ups also print a Score on Root Lock. That figure is a CVSS environmental score for one deployment. It sits beside the status word. It is not a second status.

## Residuals (non-zero Score on Root Lock)

These seven CVEs are **Affected** on 6.18.9-hs. The base score is the upstream score. Full write-ups: [Compiled-in CVEs](compiled-in-cves/). The environmental figure for this table is in the [note below](#note-on-scores-on-root-lock-and-deployment-tuning).

| CVE | Component | State | Base score |
|-----|-----------|-------|------------|
| [CVE-2026-46281](compiled-in-cves/#cve-2026-46281) | vmalloc (`CONFIG_MMU`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-64600](compiled-in-cves/#cve-2026-64600) | XFS reflink (`CONFIG_XFS_FS`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-53129](compiled-in-cves/#cve-2026-53129) | ext4 mbcache (`CONFIG_FS_MBCACHE`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-52992](compiled-in-cves/#cve-2026-52992) | ADFS (`CONFIG_ADFS_FS`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-53233](compiled-in-cves/#cve-2026-53233) | netdev RX bind (`CONFIG_NET_DEVMEM`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-53119](compiled-in-cves/#cve-2026-53119) | ACPI WMI (`CONFIG_ACPI_WMI`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |
| [CVE-2026-53120](compiled-in-cves/#cve-2026-53120) | PCI `driver_override` (`CONFIG_PCI`) | **Affected** | <span class="badge badge-cve-high">7.8 HIGH</span> |

The io_uring CVEs in the catalog are already fixed on 6.18.9-hs. `CONFIG_IO_URING` stays set, so a later io_uring finding stays on the patch date.

These seven stay on the patch date in your policy. The fix arrives in a Root Lock bundle. A program you already approved can hit a bug in this table, and the bug can panic the kernel. Filing the row does not close it.

## How to read the backstop sections

The per-CVE write-ups name two controls, and a boot latch sits in front of both.

The allowlist is checked on every program start, whether or not Lockdown is on. A program with no allowlist entry does not run.

The latch is `heartsuite-kernel-latch.service`. Early in every Root Lock kernel boot, before the network is configured and before sshd starts, it loads the netfilter modules the firewall needs and sets `kernel.modules_disabled=1`. Until the next reboot, a later modprobe stays refused. The latch does not unload a module already in memory. `HS_lockdown.sh` writes the same value again, where the node exists, in case the latch service is masked. OpenRC has no latch service and gets that write only when Lockdown is applied.

For a bug that lives only in a module that was not loaded at boot, the latch is the control the write-up is naming. An option set to `=m` stays on the patch date. Not affected is the word for an unset option. Code built in with `=y`, and code in a module that did load, is in the running kernel.

## Scanner Guidance

When a scanner flags a Not affected row, it matched the upstream version string. The status is the option on [Disabled features](disabled-features/). The guest file `/boot/config-6.18.9-hs` is an 11-line stub, so a `grep` of that file is not the proof. Share that page with your scanner vendor when you dispute a row. The workflow for the exception register is [CVE Hygiene for Scanners](../kernel-hardening/cve-hygiene-for-scanners/).

## The Four Assessment Gates

Read the Affected table first. These four checks are how that word was chosen.

**Compiled in.** The build configuration is checked for the `CONFIG_` option. When the option is unset, the code is absent and the state is Not affected.

**Outbound connections.** The check on this kernel covers outbound `connect()`. A bug reached through socket creation, `sendmsg`, `recvmsg`, or an in-kernel crypto interface is outside that check.

**A new program.** A program with no allowlist entry does not run. A bug inside a program you already approved, such as a web server on the allowlist, runs in that program. That program can read and write the files it was granted.

**After the bug fires.** The allowlist file is immutable, and the kernel refuses the write that would clear that flag. Mounts are refused. Clearing Lockdown takes a reboot from the physical console or the serial console onto the maintenance kernel. SSH cannot make that pick. The bug can panic the kernel.

### Note on Scores on Root Lock and deployment tuning

Score on Root Lock is a CVSS v3.1 environmental figure in the long catalog. It is not the status word. The seven Affected rows above stay on the patch date either way.

They are published at 7.1 HIGH for an allowlist that already holds an outbound networking utility such as `curl`, `wget`, outbound `ssh`, `nc`, or `python3` with sockets. A live session can read files and send them off the host through that utility, so Modified Confidentiality stays High (`MC:H`). Modified Integrity is None (`MI:N`): a new program does not run, the allowlist stays as loaded, and the session ends at reboot. Modified Availability stays High (`MA:H`) because the bug can panic the kernel. The vector is `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/MC:H/MI:N/MA:H`, which is 7.1 HIGH.

If you have confirmed that your allowlist holds none of those utilities, the same vector with `MC:L` is 6.1 MEDIUM. The published figure stays 7.1 until you have confirmed that.

An allowlist with no process-mutation utilities (`kill`, `pkill`, or init-system control beyond what Root Lock itself uses) can treat the userspace part of a disruption as `MA:L`. A kernel panic does not depend on the allowlist, so the published figure keeps `MA:H`.

Catalog rows marked fixed on 6.18.9-hs keep the archived 5.19.6 score.

### Note on Not-exploitable entries that depend on allowlist composition

Several catalog rows print 0.0 because a tool is not on the allowlist. That figure matches a host whose Setup Mode did not record the tool, because the allowlist is filled from production service activity. It is not the word Not affected. If you allowlist the tool, file the row as Affected.

Module loads after boot are the other control: `kernel.modules_disabled`, written by the boot latch.

- `modprobe`, `insmod`, and `kmod` load kernel modules. On Debian 12 these resolve to `kmod`. Once the latch has run, a later modprobe stays refused. CVE-2024-36883 stays at 0.0 because no new module can register pernet operations after the latch. The latch does not unload a module already in memory.
- `tc` (iproute2 traffic control) changes qdisc and filter state. Allowlisting it makes CVE-2025-37914, CVE-2025-37915, CVE-2025-37923, CVE-2025-22121, and the other `NET_SCHED` rows Affected.
- `bpftool`, `trace-cmd`, `perf`, and writers of debugfs or tracefs are kernel instrumentation. Allowlisting them makes the kprobe, tracing, and perf rows, including CVE-2024-38588, Affected.
- `dmsetup`, raw block-device tools, and `cryptsetup` mappings created after boot are block-layer changes. Same shape.
- `ip xfrm`, `setkey`, strongSwan, libreswan, or any IKE daemon sets up an XFRM security association. Allowlisting any of these makes `esp_output` reachable and makes CVE-2026-43284 Affected at its base score of 8.8 HIGH.
- `e4defrag`, or any extent-defragmentation tool, reaches ext4 online defragmentation. Allowlisting it makes CVE-2024-26704 Affected at its base score of 7.8 HIGH.

If you run a development or debug host and you need one of these tools, file the matching catalog row as Affected. The kernel refuses a program that has no allowlist entry. The tool you approved is itself the way in.
