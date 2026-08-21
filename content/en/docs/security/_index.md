---
title: "Kernel Security Transparency"
linkTitle: "Kernel Security Transparency"
weight: 107
description: "How Root Lock by HeartSuite scores kernel CVEs: absent surface is 0.0, live paths keep a residual. Catalog and disabled-feature groups are child pages."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
type: docs
markup:
  tableOfContents:
    startLevel: 2
    endLevel: 2
---

<div class="cve-hero-statement">
<p class="cve-hs-lead">Root Lock by HeartSuite was designed to contain only what is necessary.<br>A 0.0 score means the attack surface is absent, not that every CVE is neutralized.</p>
<p class="cve-hs-stat"><strong>{{< cve-stat type="neutralized" >}}</strong> high and critical CVEs — Score on Root Lock <strong>0.0</strong> (absent surface).</p>
</div>

**Overview**: Every kernel CVE relevant to Root Lock — what it can do, what it cannot, and why.

The **Score on Root Lock** column is a CVSS v3.1 Environmental Score for a Root Lock deployment: the risk on this kernel, not the theoretical worst case.

Where the attack surface is absent — hardware not present, trigger not installed, feature not compiled in — the score is 0.0 regardless of Base Score. Where the code path is reachable, Lockdown bounds new execution and sealed-allowlist writes; residual scores stay non-zero.

Scores use CR=M, IR=M, AR=M with no Temporal adjustments.

- [Compiled-in CVEs](compiled-in-cves/) — per-CVE write-ups and the full score table
- [Disabled features](disabled-features/) — compiled-out groups and config gates

## CVE Status

<div class="cve-hero">
<div class="row text-center g-4">
<div class="col-md-4">
<div class="cve-hero-card cve-hero-neutralized">
<p class="cve-hero-number text-success">{{< cve-stat type="neutralized" >}}</p>
<p class="cve-hero-label">High &amp; Critical CVEs reduced to Score on Root Lock <strong>0.0</strong></p>
<p class="cve-hero-detail">Attack surface absent by design.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-contained">
<p class="cve-hero-number text-teal">{{< cve-stat type="reachable" >}}</p>
<p class="cve-hero-label">CVEs with reachable code paths</p>
<p class="cve-hero-detail">Live residual. Lockdown bounds post-exploitation; the score stays non-zero.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-compiled">
<p class="cve-hero-number text-info">{{< cve-stat type="compiled-out" >}}</p>
<p class="cve-hero-label">Additional CVEs</p>
<p class="cve-hero-detail">Kernel features never compiled in.</p>
</div>
</div>
</div>
</div>

### Which kernel these scores apply to

Scores apply to the Root Lock kernel: **5.19.6-HeartSuite** and **6.18**. Compiled-out rows (BPF, FUSE, and similar gates) are the product claim. Where the two lines differ, the entry states both.

**Score on Root Lock** is a product-specific environmental figure. Compiled-out maps to VEX-style **Not Affected**. Reachable + Lockdown bounds maps to **Affected, mitigated**.

## What malware can and cannot do on this system

### Blocked

- **Persistence across reboot.** No service, cron job, init script running new code, or kernel module added by the attacker survives a reboot. The allowlist is populated only at boot from your authorized sources; any in-memory tampering is wiped on the next boot.

> **Supply-chain compromise: contained, not prevented.**
> If malware arrives inside a trusted update, Root Lock does not block it from running — it was authorized. What Root Lock does enforce is the blast radius. The malware cannot launch processes outside the allowlist, cannot reach unallowlisted network destinations, and cannot install additional code. A compromised supplier gets one program slot, not the system.

- **New program execution.** The kernel refuses to run any program not in the Lockdown allowlist, regardless of root privilege. Backdoors, custom exploit tools, droppers, and post-exploitation frameworks cannot run.
- **Kernel module loading post-boot.** On Debian 12, `modprobe` and `insmod` are symlinks to `kmod`, which is added to the allowlist during standard Setup Mode via `systemd-modules-load.service`. Lockdown's file-access enforcement denies `kmod` access to `/usr/lib/modprobe.d/` by default — module loading fails at the file-read stage before any module can be loaded. Module-based rootkits cannot be installed.
- **Allowlist modification at runtime.** The runtime allowlist lives in kernel memory and is not modifiable post-boot. The on-disk allowlist file is `chattr +i` immutable; Lockdown blocks `FS_IOC_SETFLAGS` so root cannot strip the immutable flag.
- **Mounting new filesystems.** Lockdown blocks `mount()`, `fsmount()`, and `move_mount()` after boot. Bind-mounts and remounts to shadow allowlisted paths are refused.

### Bounded by allowlist composition

- **Data exfiltration.** Reading data is not constrained — root with kernel-context primitives can read any file. *Sending* data off-host is bounded by which networked utilities are in your allowlist. Deployments with no outbound networking utilities allowlisted have no in-band exfiltration path.
- **Service disruption.** Root can panic the kernel via syscall primitives or `kill -9` allowlisted services. Availability hardening is a separate control; Root Lock does not prevent denial-of-service.
- **Lateral movement.** Attackers can pivot through whatever the allowlisted process tree permits, but cannot extend that tree. New processes outside the allowlist do not run.

Under Lockdown the kernel decides, per program, whether it can run, which files it can read or write, and which destinations it can reach. By design, remote root does not change that while the machine is running. The files are immutable. The kernel refuses the write. Recovery is the maintenance kernel via physical or serial-console access.

### Out of scope

- **Sensitive-data disclosure during the live session.** A root attacker can read disk content while the session is active. Confidentiality during the breach is the role of disk encryption, not Lockdown.
- **Hardware-level and pre-boot threats.** Firmware compromise, baseboard management exploits, and physical attacks on the boot chain are outside the Root Lock attack surface.
- **Misconfigured allowlists.** If you allowlist tools you should not — `modprobe`, `bpftool`, networked exfiltration utilities — outcomes move from "Blocked" to "Bounded" and from "Bounded" to "Allowed." See the [deployment-tuning note](#note-on-scores-on-root-lock-and-deployment-tuning).

## Residuals (non-zero Score on Root Lock)

These compiled-in paths keep a live residual. Full write-ups: [Compiled-in CVEs](compiled-in-cves/). Compiled-out groups: [Disabled features](disabled-features/).

| CVE | Component | Base Score | Score on Root Lock | Status |
|-----|-----------|-----------|-----------------|--------|
| [CVE-2026-46281](compiled-in-cves/#cve-2026-46281) | vmalloc — virtually contiguous allocator (`CONFIG_MMU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 6.18.9-hs — Lockdown limits post-exploitation; Not Affected on 5.19.6 |
| [CVE-2026-64600](compiled-in-cves/#cve-2026-64600) | XFS reflink / copy-on-write (`CONFIG_XFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 6.18.9-hs — Lockdown limits post-exploitation; Not Affected on 5.19.6 |
| [CVE-2026-53119](compiled-in-cves/#cve-2026-53119) | ACPI WMI bus (`CONFIG_ACPI_WMI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not Affected on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2026-53120](compiled-in-cves/#cve-2026-53120) | PCI `driver_override` (`CONFIG_PCI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.5 HIGH</span> | Affected — Lockdown limits post-exploitation |
| [CVE-2026-53129](compiled-in-cves/#cve-2026-53129) | ext4 mbcache (`CONFIG_FS_MBCACHE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">6.1 HIGH</span> | Affected — Lockdown limits post-exploitation |
| [CVE-2026-53233](compiled-in-cves/#cve-2026-53233) | netdev RX bind (`CONFIG_NET_DEVMEM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not Affected on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2026-52992](compiled-in-cves/#cve-2026-52992) | ADFS filesystem (`CONFIG_ADFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not exploitable — feature not compiled on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2023-2236, CVE-2022-3910](compiled-in-cves/#cve-2023-2236-cve-2022-3910) | io_uring | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.1–7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
| [CVE-2024-35886](compiled-in-cves/#cve-2024-35886) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44985](compiled-in-cves/#cve-2024-44985) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44986](compiled-in-cves/#cve-2024-44986) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44987](compiled-in-cves/#cve-2024-44987) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-47701](compiled-in-cves/#cve-2024-47701) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49882](compiled-in-cves/#cve-2024-49882) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49883](compiled-in-cves/#cve-2024-49883) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49884](compiled-in-cves/#cve-2024-49884) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49889](compiled-in-cves/#cve-2024-49889) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-48956](compiled-in-cves/#cve-2022-48956) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-53170](compiled-in-cves/#cve-2024-53170) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_SCSI=y`; Lockdown limits post-exploitation |
| [CVE-2025-21863](compiled-in-cves/#cve-2025-21863) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
| [CVE-2025-40364](compiled-in-cves/#cve-2025-40364) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
| [CVE-2025-38550](compiled-in-cves/#cve-2025-38550) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-38572](compiled-in-cves/#cve-2025-38572) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-39866](compiled-in-cves/#cve-2025-39866) | VFS writeback subsystem | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — writeback always active; Lockdown limits post-exploitation |
| [CVE-2022-50432](compiled-in-cves/#cve-2022-50432) | kernfs subsystem (`CONFIG_KERNFS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_KERNFS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53473](compiled-in-cves/#cve-2023-53473) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-50496](compiled-in-cves/#cve-2022-50496) | device mapper (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_BLK_DEV_DM=y`; Lockdown limits post-exploitation |
| [CVE-2022-50546](compiled-in-cves/#cve-2022-50546) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-38586](compiled-in-cves/#cve-2024-38586) | Realtek r8169 Ethernet driver (`CONFIG_R8169`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_R8169=y`; Lockdown limits post-exploitation |
| [CVE-2022-50423](compiled-in-cves/#cve-2022-50423) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2024-36971](compiled-in-cves/#cve-2024-36971) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-38577](compiled-in-cves/#cve-2024-38577) | RCU tasks subsystem (`CONFIG_TASKS_RCU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_TASKS_RCU=y`; Lockdown limits post-exploitation |
| [CVE-2024-50055](compiled-in-cves/#cve-2024-50055) | core kernel (`CONFIG_BASE_FULL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_BASE_FULL=y`; Lockdown limits post-exploitation |
| [CVE-2024-56600](compiled-in-cves/#cve-2024-56600) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-56601](compiled-in-cves/#cve-2024-56601) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2025-22121](compiled-in-cves/#cve-2025-22121) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-49865](compiled-in-cves/#cve-2022-49865) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_IPV6=y`; base I:N, Lockdown limits post-exploitation persistence |
| [CVE-2023-3567](compiled-in-cves/#cve-2023-3567) | virtual terminal (VT) (`CONFIG_VT`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_VT=y`; base I:N, Lockdown limits post-exploitation persistence |
| [CVE-2022-48689](compiled-in-cves/#cve-2022-48689) | TCP receive zerocopy (`CONFIG_INET`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_INET=y`; Lockdown reduces MI: High→Low (AC:H base) |
| [CVE-2025-39702](compiled-in-cves/#cve-2025-39702) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_IPV6=y`; Lockdown reduces MI: High→Low (AC:H base) |
| [CVE-2023-6531](compiled-in-cves/#cve-2023-6531) | Unix domain sockets (`CONFIG_UNIX`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_UNIX=y`; Lockdown reduces MI: High→Low (AC:H base) |


## How to read the backstop sections

Root Lock runs **two independent kernel-level controls**, and the per-CVE entries reference both. They are not peers in a list — one is load-bearing, one is defense-in-depth, and the distinction matters when reading residual risk:

- **Lockdown (load-bearing).** `hs_sandbox_caching.c` enforces the SPF allowlist on every `execve`. This check runs unconditionally — it is **not** gated by `HS_lockdown_state` — so it continues to refuse non-allowlisted programs even if an attacker with arbitrary kernel write clears Lockdown. The only Lockdown-conditional behavior in this file is an additional log-file write block; the allowlist match itself is independent.
- **Lockdown (defense-in-depth).** `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`. While that atomic is nonzero, `kernel/ioctl.c:561,568` returns EPERM on `FS_IOC_GETFLAGS`/`FS_IOC_SETFLAGS` (closing the `chattr -i` path that would otherwise let root strip immutability from the allowlist file), and `kernel/namespace.c:4218,4300,4453` returns EPERM on all mount paths. There are five `HS_locked_down()` check sites total in the kernel — none in `fs/` or `net/` — so Lockdown is an API-gate layer, not an in-line corruption boundary.

**The load-bearing control against persistence and lateral expansion is Lockdown's allowlist.** Even in the worst case where an attacker chains a kernel UAF into arbitrary write and clears `HS_lockdown_state`, they still cannot run new programs, modify the allowlist, install backdoors, or survive a reboot, because the allowlist check is not on the same state machine. They regain only the ability to mount filesystems and set immutable flags — meaningful but bounded.

Per-CVE entries on [Compiled-in CVEs](compiled-in-cves/) name the bug, then state which of these two layers limits its post-exploitation impact and how.

### Why this is unusual

Most kernel hardening tools gate enforcement on a single state variable that an attacker with arbitrary kernel write can clear in one instruction. Root Lock does not work that way. **Lockdown's allowlist is consulted on every `execve` regardless of Lockdown's state** — there is no kill-switch an attacker can flip. Even in the worst case examined in this catalog, the system continues to refuse new code execution.

### Note on Scores on Root Lock and deployment tuning

The Scores on Root Lock published in this catalog assume a **worst-case allowlist composition** — i.e., that your Lockdown allowlist contains common utilities including networked tools (`curl`, `wget`, `ssh` outbound, `nc`, `python` with sockets, etc.). Under that assumption, an attacker who reaches root via one of the Affected CVEs retains a confidentiality impact of HIGH (`MC:H`) because they can read sensitive data and pipe it out via an already-allowlisted networked utility. This is the conservative, deployment-agnostic floor.

If you run a tighter allowlist, you may legitimately credit a lower MC. Specifically:

- **Allowlist contains zero outbound-networking utilities** (no `curl`, `wget`, outbound `ssh`, `nc`, scripting languages with socket access, etc.): `MC:L` becomes defensible — the attacker can read on disk but has no in-band exfiltration path within Lockdown's allowlist. Out-of-band (physical-console, side-channel) exfiltration remains possible; that's why the credit is L, not N.
- **Allowlist contains zero process-mutation utilities** (no `kill`, `pkill`, init-system control surfaces beyond what Root Lock itself uses): `MA:L` becomes defensible for the disruption-via-userspace component, though kernel-level availability impact (panics, OOM via syscalls) is independent of allowlist composition and keeps `MA:H` for any CVE that grants kernel-context primitives.

These are deployment-specific reductions and are **not** baked into the published Scores on Root Lock. If you have hardened your allowlist accordingly, you can recompute your deployment-specific score by adjusting `MC` and/or `MA` in the modified vector. The published scores are correct for any deployment that has not affirmatively confirmed the tighter conditions above.

### Note on Not-exploitable entries that depend on allowlist composition

Several Not-exploitable entries justify their 0.0 Score on Root Lock with phrasing of the form *"X not in allowlist."* These claims are accurate for any Root Lock deployment built through the standard Setup Mode workflow, where the allowlist is populated from production service activity. Utilities not invoked during that workflow would not be added to the allowlist. Specifically, the following utilities should not be allowlisted on a production Root Lock deployment:

- `modprobe`, `insmod` / `kmod` — kernel module loading. On Debian 12, these resolve to `kmod`, which standard Setup Mode does allowlist; the protection is Lockdown's file-access enforcement denying `kmod` access to `/usr/lib/modprobe.d/`. Granting `kmod` that access reverts CVE-2024-36883 (and any other module-loading-dependent CVE) to **Affected**.
- `tc` (iproute2 traffic control) — qdisc/filter manipulation. Allowlisting reverts CVE-2025-37914 / 37915 / 37923 / 22121 and other `NET_SCHED` CVEs to **Affected**.
- `bpftool`, `trace-cmd`, `perf`, debugfs/tracefs writers — kernel instrumentation. Allowlisting reverts the kprobe / tracing / perf CVE cluster (CVE-2024-38588 etc.) to **Affected**.
- `dmsetup`, raw block-device tools, `cryptsetup` mappings created post-boot — block-layer mutation. Same shape.
- `ip xfrm`, `setkey`, strongSwan, libreswan, or any IKE daemon — XFRM management. Allowlisting any of these enables XFRM security association setup, making `esp_output` reachable and reverting CVE-2026-43284 to **Affected 8.8 HIGH**.
- `e4defrag` or any extent-defragmentation tool — ext4 online defragmentation. Allowlisting reverts CVE-2024-26704 to **Affected 7.8 HIGH**.

If you run a development, debug, or instrumentation-heavy deployment and legitimately need any of the above, treat the corresponding Not-exploitable entries as **Affected** for your environment, and apply the standard Affected backstop logic (Lockdown's allowlist still refuses *unknown* programs, but the now-allowlisted utility is itself the trigger). The "Not exploitable" classifications are correct for Root Lock deployments; they are not universal.

## Scanner Guidance

When a scanner flags Root Lock for a CVE listed as Not Affected, the result is a version-string match: the scanner has identified a kernel version older than the upstream fix but has not evaluated whether the vulnerable code path is compiled in.

For the full verification workflow (maintenance-kernel exceptions, scanner configuration, audit evidence, and published OSV feeds), see [CVE Hygiene for Scanners](../kernel-hardening/cve-hygiene-for-scanners/).

Share this section and the [disabled-features](disabled-features/) catalog with your scanner vendor as the reference for any disputed CVE entry. For a configuration-level proof, confirm the config gate on the Root Lock host:

```bash
grep CONFIG_<GATE> /boot/config-$(uname -r)
```

Replace `CONFIG_<GATE>` with the config gate listed in the relevant section. An `=n` result confirms that gate is not compiled into the running kernel.

## The Four Assessment Gates

Every entry in this catalog was verified source-first. No assumptions were made about what is compiled in, and no scanner output was taken at face value. The assessment follows four gates in order:

**Gate 1 — Is the vulnerable code compiled in?** The Root Lock kernel configuration is checked directly against the relevant `CONFIG_` option. If the option is not set, the vulnerable code does not exist in the running kernel. The assessment stops here as Not Affected regardless of kernel version string.

**Gate 2 — Does Root Lock's outbound connection control cover the attack path?** For socket-based CVEs, Root Lock intercepts outbound `connect()` calls only. Attack paths that reach the kernel through socket creation, `sendmsg`, `recvmsg`, or kernel-internal crypto interfaces are not covered by this control and are noted accordingly.

**Gate 3 — Can an exploit program run?** Under Lockdown, the program allowlist is made filesystem-immutable. No new program entries can be added. An attacker-dropped exploit program has no allowlist entry and cannot execute. This gate does not apply to CVEs exploitable from within an already-running, allowlisted process.

**Gate 4 — What can root actually do under Lockdown?** When a CVE achieves root privilege, Lockdown applies a further constraint. The kernel refuses to clear filesystem immutable flags (`chattr -i` is blocked at the syscall level). All three mount syscall variants are blocked. Clearing Lockdown takes a reboot from physical or serial-console access onto the maintenance kernel. SSH is not enough. Seal and control integrity are product contracts on the pin you run.

The two residual risks that Lockdown does not close are in-memory data exfiltration (reading live process memory) and availability impact (crashing the system). These are noted in affected entries where relevant.
