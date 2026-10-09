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

**Overview**: This page is the status of kernel CVEs on the Root Lock kernel you boot. `uname -r` is `6.18.9-hs`. Kernel 5.19.6 is an archived line. A CVE in an application you run, such as a web server, an FTP server, a database, or a CI server, is outside this list. If that program is on your allowlist, its bug fires in that program.

<div class="cve-hero-statement">
<p class="cve-hs-lead">On the kernel you boot, most of these kernel CVEs have no path.</p>
</div>

<div class="cve-hero">
<div class="row text-center g-4">
<div class="col-md-4">
<div class="cve-hero-card cve-hero-neutralized">
<p class="cve-hero-number text-success">{{< cve-stat type="neutralized" >}}</p>
<p class="cve-hero-label">Score on Root Lock <strong>0.0</strong></p>
<p class="cve-hero-detail">The program that reaches the bug has no allowlist entry, or the hardware is not in the machine.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-contained">
<p class="cve-hero-number text-teal">{{< cve-stat type="reachable" >}}</p>
<p class="cve-hero-label">Open on the kernel you boot</p>
<p class="cve-hero-detail">These stay on the patch date. The scored rows are in the table below. One open row is not given a 0.0.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-compiled">
<p class="cve-hero-number text-info">{{< cve-stat type="compiled-out" >}}</p>
<p class="cve-hero-label">Not affected</p>
<p class="cve-hero-detail">The option is unset, so that code is not in the kernel you boot.</p>
</div>
</div>
</div>
</div>

| State | What it means | Where to read it |
|-------|----------------|------------------|
| **Not affected** | That option is unset, so the vulnerable code is absent. | [Disabled features](disabled-features/) |
| **Affected** | The code is in the kernel you boot. The row stays on the patch date. | The table below, then the write-up |
| **Fixed** | 6.18.9-hs already has the upstream fix. | [Compiled-in CVEs](compiled-in-cves/) |

On this kernel the BPF syscall is off, so there is no eBPF program to load. Each row was read from the published build configuration and the kernel source. No exploit was run to produce these rows.

The long write-ups also print a Score on Root Lock beside the status word. That figure is a CVSS environmental score for one deployment. When the bug can be reached only through a program that has no allowlist entry, that program does not run and the catalog prints 0.0. The catalog also prints 0.0 when the hardware the bug needs is not in the machine. Approving the missing program makes that row Affected. The number for the seven rows below is in the note at the end of this page.

## Residuals (non-zero Score on Root Lock)

These seven CVEs are **Affected** on 6.18.9-hs. The base score is the upstream score. Full write-ups: [Compiled-in CVEs](compiled-in-cves/). The environmental figure for this table is in the [note at the end of this page](#note-on-scores-on-root-lock-and-deployment-tuning).

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

These seven stay on the patch date in your policy. The fix arrives in a Root Lock bundle. A program you already approved can hit a bug in this table. It can read the files it was granted, and it can panic the kernel. It does not start a program that has no allowlist entry. The next boot loads the allowlist saved on disk. Filing the row does not close it.

## The Four Assessment Gates

Every entry on this page was checked by reading the build configuration and the kernel source, in this order. Nothing was assumed about what is compiled in, and a scanner result was not taken as the answer. A person checks the row before it is published. The check does not include running an exploit against a Root Lock host. A lab attack test is a separate kind of evidence.

**Gate 1 — Is the vulnerable code compiled in?** The Root Lock kernel configuration is checked against the relevant `CONFIG_` option. If the option is not set, the vulnerable code is not in the kernel you boot. The check stops here as **Not affected**, whatever the kernel version string says.

**Gate 2 — Does Root Lock's outbound connection control cover the attack path?** For a CVE that uses a socket, Root Lock checks outbound `connect()` calls. A path that reaches the kernel by creating a socket, by `sendmsg` or `recvmsg`, or by crypto inside the kernel is outside that check, and the write-up says so.

**Gate 3 — Can the program that reaches this bug run?** The allowlist is checked on every program start, whether or not Lockdown is on. A program with no allowlist entry does not run. That covers a program the attacker drops, and it covers a bug that can be reached only through a particular program, such as `tc` or `bpftool`. If that program has no entry, the catalog prints 0.0. Under Lockdown the allowlist file is immutable, so no new entry can be added after Lockdown. This gate does not apply when the CVE is reached from a program already on the allowlist. A bug in an allowlisted Apache or PHP process is that case: the bug runs inside a program you approved, the row is Affected, and it stays on the patch date. A program you approved runs, including one that arrived in an update you accepted, and it can start only a program that already has an entry. What Root Lock refuses next is a program, a file, or a destination that program was never granted.

**Gate 4 — What can root actually do under Lockdown?** When a CVE gives an attacker root, Lockdown applies a further limit. The kernel refuses to clear the immutable flag on a file (`chattr -i` is refused). `mount()`, `fsmount()`, and `move_mount()` are refused. The next boot loads the allowlist saved on disk, so a change that lived only in memory is gone. Clearing Lockdown takes a reboot from the physical console or the serial console onto the maintenance kernel. SSH cannot make that pick. SSH remains how you administer the host before and after that step. Those limits hold on the kernel you boot.

Reading files and reading memory during the live session stay open. Sending the files off the host depends on an approved program that can open a connection, such as `curl`. The bug can panic the kernel. Firmware, the machine's management controller, and a physical attack on the boot chain are outside this page. Disk encryption is what protects the data on disk. An Affected entry says so where that is the case.

## Scanner Guidance

When a scanner flags Root Lock for a CVE listed as Not affected, the result is a version-string match. The scanner has found a kernel version older than the upstream fix and has not checked whether the vulnerable code is in the kernel you boot.

The steps for recording an exception, for the maintenance kernel, and for the published advisory feeds are on [CVE Hygiene for Scanners](../kernel-hardening/cve-hygiene-for-scanners/).

Share this section and the [Disabled features](disabled-features/) list with your scanner vendor when you dispute a row. The proof is the published build configuration for the kernel you boot, not the version string. On 6.18.9-hs the file `/boot/config-6.18.9-hs` is an 11-line stub, so a search of that file does not show whether the option is set. The configuration to use is the one named on [Evidence Status](../kernel-hardening/evidence-status/).

## How to read the backstop sections

On the write-ups, the backstop is the limit that still applies after the bug fires. The write-ups name two controls, and a boot latch sits in front of both.

The allowlist is checked on every program start, whether or not Lockdown is on. A program with no allowlist entry does not run.

The latch is `heartsuite-kernel-latch.service`. Early in every Root Lock kernel boot, before the network is configured and before sshd starts, it loads the netfilter modules the firewall needs and sets `kernel.modules_disabled=1`. Root Lock is not running yet in that window, so the allowlist is not what stops those loads. Until the next reboot, a later modprobe stays refused. The latch does not unload a module already in memory. `HS_lockdown.sh` writes the same setting again, where that setting exists, in case the latch service is masked. OpenRC has no latch service and gets that write only when Lockdown is applied.

For a bug that lives only in a module that was not loaded at boot, the latch is the control the write-up is naming. An option set to `=m` stays on the patch date. Not affected is the word for an option that is unset. Code built in with `=y`, and code in a module that did load, is in the running kernel.

### Note on Scores on Root Lock and deployment tuning

File the seven rows above as Affected. Score on Root Lock is a second number for one deployment: 7.1 HIGH when the allowlist already includes a program that can send data off the host, such as `curl` or `wget`, and 6.1 MEDIUM when you have confirmed that it includes none of those. The row stays on the patch date either way. The detail below is the CVSS environmental vector behind those two figures.

They are published at 7.1 HIGH for an allowlist that already holds an outbound networking utility such as `curl`, `wget`, outbound `ssh`, `nc`, or `python3` with sockets. A live session can read files and send them off the host through that utility, so Modified Confidentiality stays High (`MC:H`). Modified Integrity is None (`MI:N`): a new program does not run, the allowlist stays as loaded, and the session ends at reboot. Modified Availability stays High (`MA:H`) because the bug can panic the kernel. The vector is `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/MC:H/MI:N/MA:H`, which is 7.1 HIGH.

If you have confirmed that your allowlist holds none of those utilities, the same vector with `MC:L` is 6.1 MEDIUM. A live session can read files, and carrying them off the host then takes the console. The published figure stays 7.1 until you have confirmed that.

An allowlist with no process-mutation utilities (`kill`, `pkill`, or init-system control beyond what Root Lock itself uses) can treat the userspace part of a disruption as `MA:L`. A kernel panic does not depend on the allowlist, so the published figure keeps `MA:H`.

Catalog rows marked fixed on 6.18.9-hs keep the archived 5.19.6 score.

### Note on Not-exploitable entries that depend on allowlist composition

A row prints 0.0 when the program that reaches the bug has no allowlist entry. That program does not run, so the path is not reached on a host that has not approved it. Setup Mode fills the allowlist from the programs your services actually run. If you approve the program, file the row as Affected and keep it on the patch date. Not affected stays the word for an option that is unset.

Module loads after boot are the other control: `kernel.modules_disabled`, written by the boot latch.

- `modprobe`, `insmod`, and `kmod` load kernel modules. On Debian 12 these resolve to `kmod`. Once the latch has run, a later modprobe stays refused. CVE-2024-36883 stays at 0.0 because no new module can finish its network setup after the latch. The latch does not unload a module already in memory.
- `tc` (iproute2) changes traffic-control settings. Allowlisting it makes CVE-2025-37914, CVE-2025-37915, CVE-2025-37923, CVE-2025-22121, and the other traffic-control rows Affected.
- `bpftool`, `trace-cmd`, `perf`, and programs that write kernel trace data are kernel instrumentation. Allowlisting them makes the tracing rows, including CVE-2024-38588, Affected.
- `dmsetup`, raw block-device tools, and `cryptsetup` mappings created after boot change block storage. Same shape.
- `ip xfrm`, `setkey`, strongSwan, libreswan, or any IKE daemon sets up an encrypted network tunnel. Allowlisting any of these makes that path reachable and makes CVE-2026-43284 Affected at its base score of 8.8 HIGH.
- `e4defrag`, or any extent-defragmentation tool, reaches ext4 online defragmentation. Allowlisting it makes CVE-2024-26704 Affected at its base score of 7.8 HIGH.

If you run a development or debug host and you need one of these tools, file the matching catalog row as Affected. The kernel refuses a program that has no allowlist entry. The tool you approved is itself the way in.
