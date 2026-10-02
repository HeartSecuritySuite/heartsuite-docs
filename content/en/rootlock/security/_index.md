---
title: "Kernel Security Transparency"
linkTitle: "Kernel Security Transparency"
weight: 107
description: "How Root Lock by HeartSuite scores kernel CVEs: absent surface is 0.0, live paths keep a residual. Catalog and disabled-feature groups are child pages."
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

<div class="cve-hero-statement">
<p class="cve-hs-lead">Root Lock by HeartSuite was designed to contain only what is necessary.<br>A 0.0 score means the attack surface is absent, not that every CVE is neutralized.</p>
<p class="cve-hs-stat"><strong>{{< cve-stat type="neutralized" >}}</strong> high and critical CVEs — Score on Root Lock <strong>0.0</strong> (absent surface).</p>
</div>

**Overview**: Every kernel CVE relevant to Root Lock — what it can do, what it cannot, and why.

The **Score on Root Lock** column is a CVSS v3.1 Environmental Score for a Root Lock deployment: the risk on this kernel, not the theoretical worst case.

Where the attack surface is absent — hardware not present, trigger not installed, feature not compiled in — the score is 0.0 regardless of Base Score. Where the code path is reachable, the score stays non-zero because the bug can still be triggered; under Lockdown, the attacker who triggers it still cannot run new programs or write to the sealed allowlist.

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
<p class="cve-hero-detail">On 6.18.9-hs the code path is still open, so the score stays non-zero. Rows fixed on this kernel are left out of the count.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-compiled">
<p class="cve-hero-number text-info">{{< cve-stat type="compiled-out" >}}</p>
<p class="cve-hero-label">Additional CVEs</p>
<p class="cve-hero-detail">Unset on the kernel you boot.</p>
</div>
</div>
</div>
</div>

### Which kernel these scores apply to

Scores on this page apply to **6.18.9-hs**. 5.19.6 is an archived kernel line. A row is Not Affected only where that option is unset on the kernel you boot, because only then is the vulnerable code absent. On 6.18.9-hs, the BPF syscall is off, so there is no eBPF program to load.

**Score on Root Lock** is a product-specific environmental figure. Compiled-out maps to VEX-style **Not Affected**. A reachable code path whose impact Lockdown limits maps to **Affected, mitigated**.

## What malware can and cannot do on this system

### Blocked under Lockdown

- **Persistence across reboot.** No service, cron job, init script running new code, or kernel module added by the attacker survives a reboot. The next boot loads your on-disk allowlist. In-memory tampering is wiped on that boot. A kernel write that changes the on-disk file is what the next boot loads.
- **New program execution.** The kernel refuses to run any program not in the Lockdown allowlist, regardless of root privilege. Backdoors, custom exploit tools, droppers, and post-exploitation frameworks cannot run.
- **Kernel module loading post-boot.** On Debian 12, `modprobe` and `insmod` are symlinks to `kmod`, which is added to the allowlist during standard Setup Mode via `systemd-modules-load.service`. Lockdown's file-access enforcement denies `kmod` access to `/usr/lib/modprobe.d/` by default — module loading fails at the file-read stage before any module can be loaded. Module-based rootkits cannot be installed.
- **Allowlist modification at runtime.** The runtime allowlist lives in kernel memory and is not modifiable post-boot. The on-disk allowlist file is `chattr +i` immutable; Lockdown blocks `FS_IOC_SETFLAGS` so root cannot strip the immutable flag.
- **Mounting new filesystems.** Lockdown blocks `mount()`, `fsmount()`, and `move_mount()` after boot. Bind-mounts and remounts to shadow allowlisted paths are refused.

> **Supply-chain compromise: contained, not prevented.**
> If malware arrives inside a trusted update, it runs, because you authorized that program. Root Lock still limits what it can reach: it can launch only allowlisted processes, connect only to allowlisted network destinations, and cannot install additional code. A compromised supplier gets one program slot, not the system.

### Bounded by allowlist composition

- **Data exfiltration.** Reading data is not constrained — root with kernel-context primitives can read any file. *Sending* data off-host is bounded by which networked utilities are in your allowlist. Deployments with no outbound networking utilities allowlisted have no in-band exfiltration path.
- **Service disruption.** Root can panic the kernel via syscall primitives or `kill -9` allowlisted services. Availability hardening is a separate control; Root Lock does not prevent denial-of-service.
- **Lateral movement.** Attackers can pivot through whatever the allowlisted process tree permits, but cannot extend that tree. New processes outside the allowlist do not run.

Under Lockdown the kernel decides, per program, whether it can run, which files it can read or write, and which destinations it can reach. By design, remote root cannot change those decisions while the machine is running, because the allowlist files are immutable and the kernel refuses the write. Recovery is the maintenance kernel via physical or serial-console access.

### Out of scope

- **Sensitive-data disclosure during the live session.** A root attacker can read disk content while the session is active. Confidentiality during the breach is the role of disk encryption, not Lockdown.
- **Hardware-level and pre-boot threats.** Firmware compromise, baseboard management exploits, and physical attacks on the boot chain are outside the Root Lock attack surface.
- **Misconfigured allowlists.** If you allowlist tools you should not — `modprobe`, `bpftool`, networked exfiltration utilities — outcomes move from "Blocked" to "Bounded" and from "Bounded" to "Allowed." See the [deployment-tuning note](#note-on-scores-on-root-lock-and-deployment-tuning).

## Residuals (non-zero Score on Root Lock)

These seven CVEs keep a non-zero Score on Root Lock on 6.18.9-hs. Full write-ups: [Compiled-in CVEs](compiled-in-cves/). Groups whose option is unset: [Disabled features](disabled-features/).

The [Score on Root Lock](#note-on-scores-on-root-lock-and-deployment-tuning) below is the score for 6.18.9-hs on a standard allowlist with no outbound networking utilities. Modified Confidentiality is Low, Modified Integrity is None, and Modified Availability stays High: 6.1 MEDIUM. The finding stays on the patch date in your policy. The fix arrives in a Root Lock bundle. Lockdown limits what an attacker can do after the bug fires.

The io_uring CVEs in the catalog are already fixed on 6.18.9-hs.

### Memory (1 CVE)

| CVE | Component | Base Score | Score on Root Lock |
|-----|-----------|------------|--------------------|
| [CVE-2026-46281](compiled-in-cves/#cve-2026-46281) | vmalloc — virtually contiguous allocator (`CONFIG_MMU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |

### Filesystems (3 CVEs)

| CVE | Component | Base Score | Score on Root Lock |
|-----|-----------|------------|--------------------|
| [CVE-2026-64600](compiled-in-cves/#cve-2026-64600) | XFS reflink / copy-on-write (`CONFIG_XFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |
| [CVE-2026-53129](compiled-in-cves/#cve-2026-53129) | ext4 mbcache (`CONFIG_FS_MBCACHE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |
| [CVE-2026-52992](compiled-in-cves/#cve-2026-52992) | ADFS filesystem (`CONFIG_ADFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |

### Networking (1 CVE)

| CVE | Component | Base Score | Score on Root Lock |
|-----|-----------|------------|--------------------|
| [CVE-2026-53233](compiled-in-cves/#cve-2026-53233) | netdev RX bind (`CONFIG_NET_DEVMEM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |

### Core kernel (2 CVEs)

| CVE | Component | Base Score | Score on Root Lock |
|-----|-----------|------------|--------------------|
| [CVE-2026-53119](compiled-in-cves/#cve-2026-53119) | ACPI WMI bus (`CONFIG_ACPI_WMI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |
| [CVE-2026-53120](compiled-in-cves/#cve-2026-53120) | PCI `driver_override` (`CONFIG_PCI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-warning text-dark">6.1 MEDIUM</span> |

## How to read the backstop sections

Root Lock runs two kernel controls, and the per-CVE entries refer to both. The allowlist check runs on every program start, whether or not Lockdown is on. A kernel write can change Lockdown state in memory. Root from userspace cannot clear it. A program with no allowlist entry does not run.

Per-CVE entries on [Compiled-in CVEs](compiled-in-cves/) name the bug, then state which of these two controls limits what an attacker can do after the bug fires.

### Why this is unusual

Many kernel controls sit on one switch an attacker can clear with a kernel write. Root Lock checks the allowlist on every program start, whether or not Lockdown is on, so clearing Lockdown leaves program start closed.

### Note on Scores on Root Lock and deployment tuning

The seven residuals above are the published Score on Root Lock for 6.18.9-hs. They use a standard allowlist with no outbound networking utilities (`curl`, `wget`, outbound `ssh`, `nc`, or `python` with sockets). A live session can still read files. Sending them off the host takes one of those utilities. A console or side channel can still carry data out, so Modified Confidentiality is Low (`MC:L`). Modified Integrity is None (`MI:N`): a new program does not run, the allowlist stays as loaded, and the session ends at reboot. Modified Availability stays High (`MA:H`) because the bug can panic the kernel. The vector is `CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/MC:L/MI:N/MA:H`, which is 6.1 MEDIUM.

An allowlist that already contains one of those outbound utilities puts Modified Confidentiality back to High. The same vector with `MC:H` is 7.1 HIGH. That figure belongs to that allowlist.

An allowlist with no process-mutation utilities (`kill`, `pkill`, or init-system control beyond what Root Lock itself uses) can treat the userspace part of a disruption as `MA:L`. A kernel panic does not depend on the allowlist, so the published score keeps `MA:H`.

Catalog rows marked fixed on 6.18.9-hs keep the archived 5.19.6 score.

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

Share this section and the [disabled-features](disabled-features/) catalog with your scanner vendor as the reference for any disputed CVE entry. The proof is the pin config — the build configuration published for the kernel you boot — not a version string. On 6.18.9-hs the guest file `/boot/config-6.18.9-hs` is a stub, so `grep` of that file does not confirm the gate. See [Evidence Status](../kernel-hardening/evidence-status/).

## The Four Assessment Gates

Every entry in this catalog was verified source-first. No assumptions were made about what is compiled in, and no scanner output was taken at face value. The assessment follows four gates in order:

**Gate 1 — Is the vulnerable code compiled in?** The Root Lock kernel configuration is checked directly against the relevant `CONFIG_` option. If the option is not set, the vulnerable code does not exist in the running kernel. The assessment stops here as Not Affected regardless of kernel version string.

**Gate 2 — Does Root Lock's outbound connection control cover the attack path?** For socket-based CVEs, Root Lock intercepts outbound `connect()` calls only. Attack paths that reach the kernel through socket creation, `sendmsg`, `recvmsg`, or kernel-internal crypto interfaces are not covered by this control and are noted accordingly.

**Gate 3 — Can an exploit program run?** Under Lockdown, the program allowlist is made filesystem-immutable, so no new entries can be added and an exploit program the attacker drops has no entry and cannot execute. This gate does not apply to CVEs exploitable from within an already-running, allowlisted process.

**Gate 4 — What can root actually do under Lockdown?** When a CVE achieves root privilege, Lockdown applies a further constraint. The kernel refuses to clear filesystem immutable flags (`chattr -i` is blocked at the syscall level). All three mount syscall variants are blocked. Clearing Lockdown takes a reboot from physical or serial-console access onto the maintenance kernel; SSH cannot unseal, although it remains how you administer the host before and after that step. Seal and control integrity are product contracts on the pin you run.

The two residual risks that Lockdown does not close are in-memory data exfiltration (reading live process memory) and availability impact (crashing the system). These are noted in affected entries where relevant.
