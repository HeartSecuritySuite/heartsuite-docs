---
title: "Kernel Security Transparency"
weight: 107
description: "CVE status for the HeartSuite Core Secure kernel — precise status and technical rationale for each relevant vulnerability, including Not Affected entries where the vulnerable code path is absent by design."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
type: docs
markup:
  tableOfContents:
    startLevel: 2
    endLevel: 2
---

<div class="cve-hero-statement">
<p class="cve-hs-lead">HeartSuite Core Secure was designed to contain only what is necessary.<br>Everything else was never there to begin with.</p>
<p class="cve-hs-stat"><strong>{{< cve-stat type="neutralized" >}}</strong> high and critical CVEs — Score on HeartSuite <strong>0.0</strong>.</p>
</div>

Every kernel CVE relevant to HeartSuite Core Secure — what it can do, what it cannot, and why.

The **Score on HeartSuite** column shows the CVSS v3.1 Environmental Score for a HeartSuite Core Secure deployment — the actual risk on your system, not the theoretical worst case. Where the attack surface is absent — hardware not present, trigger not installed — the Score on HeartSuite is 0.0 regardless of Base Score. Where the code path is reachable, MI is reduced from High to Low: Lockdown's allowlist refuses new code execution and blocks allowlist modification. Scores are computed using CR=M, IR=M, AR=M with no Temporal adjustments.

## CVE Status

<div class="cve-hero">
<div class="row text-center g-4">
<div class="col-md-4">
<div class="cve-hero-card cve-hero-neutralized">
<p class="cve-hero-number text-success">{{< cve-stat type="neutralized" >}}</p>
<p class="cve-hero-label">High &amp; Critical CVEs reduced to Score on HeartSuite <strong>0.0</strong></p>
<p class="cve-hero-detail">Attack surface absent by design.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-contained">
<p class="cve-hero-number text-warning">{{< cve-stat type="reachable" >}}</p>
<p class="cve-hero-label">CVEs with reachable code paths</p>
<p class="cve-hero-detail">Even with root, the system refuses new code. No persistence. No survival after reboot.</p>
</div>
</div>
<div class="col-md-4">
<div class="cve-hero-card cve-hero-compiled">
<p class="cve-hero-number text-secondary">1,000+</p>
<p class="cve-hero-label">Additional CVEs</p>
<p class="cve-hero-detail">Kernel features never compiled in.</p>
</div>
</div>
</div>
</div>

### Understanding CVE Scores in HeartSuite

CVEs are rated by severity (e.g., HIGH means a score of 7+). A "0.0" score here means HeartSuite fully neutralizes the vulnerability—it's not reachable. A "non-zero" score means the flaw can still be exploited in HS, but its impact is limited, often to temporary effects that a reboot clears. This helps you see real risks clearly.

## What malware can and cannot do on this system

Across every reachable CVE in this document, the answer is the same — and short.

### Blocked

- **Persistence across reboot.** No service, cron job, init script running new code, or kernel module added by the attacker survives a reboot. The allowlist is populated only at boot from your authorized sources; any in-memory tampering is wiped on the next boot.

> **Supply-chain compromise: contained, not prevented.**  
> If malware arrives inside a trusted update, HeartSuite does not block it from running — it was authorized. What HeartSuite does enforce is the blast radius. The malware cannot launch processes outside the allowlist, cannot reach unallowlisted network destinations, and cannot install additional code. A compromised supplier gets one program slot, not the system.

- **New program execution.** The kernel refuses to run any program not in the Lockdown allowlist, regardless of root privilege. Backdoors, custom exploit tools, droppers, and post-exploitation frameworks cannot run.
- **Kernel module loading post-boot.** On Debian 12, `modprobe` and `insmod` are symlinks to `kmod`, which is added to the allowlist during standard Setup Mode via `systemd-modules-load.service`. Lockdown's file-access enforcement denies `kmod` access to `/usr/lib/modprobe.d/` by default — module loading fails at the file-read stage before any module can be loaded. Module-based rootkits cannot be installed.
- **Allowlist modification at runtime.** The runtime allowlist lives in kernel memory and is not modifiable post-boot. The on-disk allowlist file is `chattr +i` immutable; Lockdown blocks `FS_IOC_SETFLAGS` so root cannot strip the immutable flag.
- **Mounting new filesystems.** Lockdown blocks `mount()`, `fsmount()`, and `move_mount()` after boot. Bind-mounts and remounts to shadow allowlisted paths are refused.

### Bounded by allowlist composition

- **Data exfiltration.** Reading data is not constrained — root with kernel-context primitives can read any file. *Sending* data off-host is bounded by which networked utilities are in your allowlist. Deployments with no outbound networking utilities allowlisted have no in-band exfiltration path.
- **Service disruption.** Root can panic the kernel via syscall primitives or `kill -9` allowlisted services. Availability hardening is a separate control; HS does not prevent denial-of-service.
- **Lateral movement.** Attackers can pivot through whatever the allowlisted process tree permits, but cannot extend that tree. New processes outside the allowlist do not run.

Under Lockdown, the kernel controls three things per program — whether it can execute, which files it can read or write, and which network destinations it can reach — and holds those controls regardless of user privilege, including root. The allowlist is sealed — immutable on disk, refused at runtime by the kernel itself: no program or user, including root, can modify it while the system is running.

### Out of scope

- **Sensitive-data disclosure during the live session.** A root attacker can read disk content while the session is active. Confidentiality during the breach is the role of disk encryption, not Lockdown.
- **Hardware-level and pre-boot threats.** Firmware compromise, baseboard management exploits, and physical attacks on the boot chain are outside the HS attack surface.
- **Misconfigured allowlists.** If you allowlist tools you should not — `modprobe`, `bpftool`, networked exfiltration utilities — outcomes move from "Blocked" to "Bounded" and from "Bounded" to "Allowed." See the [deployment-tuning note](#note-on-scores-on-heartsuite-and-deployment-tuning).

> **The reason the answer is the same for every reachable CVE in this document is that HeartSuite's enforcement is structural, not state-based.** Most kernel hardening products gate enforcement on a state variable that an attacker with arbitrary kernel write can clear in a single instruction. Lockdown's allowlist is consulted on every `execve` regardless of any state variable. There is no kill-switch.

| CVE | Component | Base Score | Score on HeartSuite | Status |
|-----|-----------|-----------|-----------------|--------|
| [CVE-2024-47685](#cve-2024-47685) | nf_reject_ipv6 | <span class="badge bg-danger">9.1 CRITICAL</span> | <span class="badge badge-erased">0.0</span> | Score on HeartSuite 0.0 — trigger not present in default configuration |
| [CVE-2022-41674, CVE-2022-42719, CVE-2022-42720](#cve-2022-41674-cve-2022-42719-cve-2022-42720) | mac80211 | <span class="badge badge-cve-high">8.8 / 8.1 / 7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2026-23193](#cve-2026-23193) | Linux iSCSI target (`CONFIG_ISCSI_TARGET`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ISCSI_TARGET` not compiled |
| [CVE-2026-43284](#cve-2026-43284) | XFRM/IPv6 ESP (`CONFIG_XFRM`, `CONFIG_INET6_ESP`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `esp_output` unreachable; no XFRM SA can be established; IPsec management tools absent from HS allowlist; Dirty Frag chain broken (rxrpc absent) |
| [CVE-2023-0266](#cve-2023-0266) | ALSA PCM | <span class="badge badge-cve-high">7.9 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2026-31431](#cve-2026-31431) | algif_aead (AF_ALG) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Code not compiled in |
| [CVE-2026-43500](#cve-2026-43500) | rxrpc (`CONFIG_AF_RXRPC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_AF_RXRPC` not compiled; Dirty Frag chain cannot execute on HeartSuite Core Secure |
| [CVE-2022-4139](#cve-2022-4139) | i915 GPU | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2023-2236, CVE-2022-3910](#cve-2023-2236-cve-2022-3910) | io_uring | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.1–7.3 HIGH</span> | Affected — Lockdown reduces persistence and integrity impact; confidentiality and availability remain HIGH |
| [CVE-2023-52530](#cve-2023-52530) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2023-52612](#cve-2023-52612) | kernel crypto framework — scomp interface (`CONFIG_CRYPTO`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `CONFIG_INET_IPCOMP` not compiled; no compression algorithm registered; `scomp_acomp_comp_decomp()` unreachable |
| [CVE-2024-26704](#cve-2024-26704) | ext4 filesystem — online defragmentation (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `EXT4_IOC_MOVE_EXT` ioctl only reached by defrag tools; none in HS allowlist |
| [CVE-2024-26842](#cve-2024-26842) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | UFS flash storage absent on x86 server |
| [CVE-2022-48662](#cve-2022-48662) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2024-26934](#cve-2024-26934) | USB core (`CONFIG_USB`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no USB interface device on headless server; race condition unreachable |
| [CVE-2022-48702](#cve-2022-48702) | EMU10K1 audio driver (`CONFIG_SND_EMU10K1`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | `CONFIG_SND_EMU10K1` not set |
| [CVE-2022-48695](#cve-2022-48695) | mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | `CONFIG_SCSI_MPT3SAS` not set |
| [CVE-2024-35789](#cve-2024-35789) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2024-35886](#cve-2024-35886) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2023-52835](#cve-2023-52835) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2023-52868](#cve-2023-52868) | thermal management (`CONFIG_THERMAL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — thermal sysfs not in allowlist; Lockdown prevents modification |
| [CVE-2024-38588](#cve-2024-38588) | kprobes (`CONFIG_KPROBES`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — kprobe registration not in allowlist; Lockdown prevents modification |
| [CVE-2024-40901](#cve-2024-40901) | LSI/Avago mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPT3SAS` not set |
| [CVE-2024-41092](#cve-2024-41092) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2024-42136](#cve-2024-42136) | CD-ROM subsystem (`CONFIG_CDROM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | CD-ROM drive absent on server |
| [CVE-2024-44985](#cve-2024-44985) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44986](#cve-2024-44986) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44987](#cve-2024-44987) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-46673](#cve-2024-46673) | Adaptec aacraid SCSI driver (`CONFIG_SCSI_AACRAID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_AACRAID` not set |
| [CVE-2024-46746](#cve-2024-46746) | AMD SFH HID driver (`CONFIG_AMD_SFH_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_AMD_SFH_HID` not set |
| [CVE-2024-46798](#cve-2024-46798) | ALSA rawmidi subsystem (`CONFIG_SND_RAWMIDI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_RAWMIDI` not compiled |
| [CVE-2024-46849](#cve-2024-46849) | Amlogic Meson ASoC driver (`CONFIG_SND_MESON_CARD_UTILS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — driver not compiled in |
| [CVE-2024-47682](#cve-2024-47682) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — non-conformant VPD firmware absent; standard SAS/SATA drives conform to SCSI spec |
| [CVE-2024-47701](#cve-2024-47701) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49852](#cve-2024-49852) | Emulex EFC FC driver (`CONFIG_SCSI_EFCT`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_EFCT` not compiled |
| [CVE-2024-49882](#cve-2024-49882) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49883](#cve-2024-49883) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49884](#cve-2024-49884) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49889](#cve-2024-49889) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49960](#cve-2024-49960) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown |
| [CVE-2024-49983](#cve-2024-49983) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown |
| [CVE-2024-50007](#cve-2024-50007) | ASIHPI soundcard driver (`CONFIG_SND_ASIHPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_ASIHPI` not compiled |
| [CVE-2022-48951](#cve-2022-48951) | ALSA SoC layer (`CONFIG_SND_SOC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_SOC` not compiled |
| [CVE-2022-48956](#cve-2022-48956) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2022-49022](#cve-2022-49022) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2022-49023](#cve-2022-49023) | cfg80211 wireless framework (`CONFIG_CFG80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2024-53170](#cve-2024-53170) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_SCSI=y`; Lockdown limits post-exploitation |
| [CVE-2024-53173](#cve-2024-53173) | NFS v4 client (`CONFIG_NFS_V4`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `mount()` blocked by Lockdown; no NFS v4 share reachable on HS |
| [CVE-2024-53214](#cve-2024-53214) | VFIO subsystem (`CONFIG_VFIO`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_VFIO` not compiled |
| [CVE-2024-53227](#cve-2024-53227) | Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_BFA_FC` not compiled |
| [CVE-2024-53239](#cve-2024-53239) | 6fire USB audio driver (`CONFIG_SND_USB_6FIRE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_USB_6FIRE` not compiled |
| [CVE-2024-56609](#cve-2024-56609) | Realtek rtw88 WiFi driver (`CONFIG_RTW88`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_RTW88` not compiled |
| [CVE-2024-56631](#cve-2024-56631) | SCSI generic driver (`CONFIG_CHR_DEV_SG`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `/dev/sg*` not in allowlist; Lockdown prevents modification |
| [CVE-2024-57899](#cve-2024-57899) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — 32-bit-specific vulnerability; HS kernel is x86_64 |
| [CVE-2025-21863](#cve-2025-21863) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IO_URING=y`; Lockdown limits post-exploitation |
| [CVE-2023-52930](#cve-2023-52930) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2023-52988](#cve-2023-52988) | Intel HDA audio driver (`CONFIG_SND_HDA_INTEL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no audio hardware present |
| [CVE-2025-22083](#cve-2025-22083) | vhost-SCSI driver (`CONFIG_VHOST_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_VHOST_SCSI` not compiled |
| [CVE-2025-40364](#cve-2025-40364) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IO_URING=y`; Lockdown limits post-exploitation |
| [CVE-2025-37738](#cve-2025-37738) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown; crafted xattr image cannot be mounted |
| [CVE-2022-49789](#cve-2022-49789) | IBM Z Fibre Channel driver (`CONFIG_ZFCP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ZFCP` not compiled |
| [CVE-2022-49842](#cve-2022-49842) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2023-53037](#cve-2023-53037) | Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPI3MR` not set |
| [CVE-2023-53039](#cve-2023-53039) | Intel ISH HID driver (`CONFIG_INTEL_ISH_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_INTEL_ISH_HID` not compiled |
| [CVE-2023-53065](#cve-2023-53065) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2025-37861](#cve-2025-37861) | Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPI3MR` not set |
| [CVE-2025-37979](#cve-2025-37979) | Qualcomm sc7280 ASoC driver (`CONFIG_SND_SOC_SC7280`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_SOC_SC7280` not compiled |
| [CVE-2022-49934](#cve-2022-49934) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2025-38206](#cve-2025-38206) | exFAT filesystem (`CONFIG_EXFAT_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_EXFAT_FS` not compiled |
| [CVE-2025-38239](#cve-2025-38239) | LSI MegaRAID SAS driver (`CONFIG_MEGARAID_SAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_MEGARAID_SAS` not set |
| [CVE-2025-38389](#cve-2025-38389) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2025-38494](#cve-2025-38494) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No USB HID input devices on headless server |
| [CVE-2025-38550](#cve-2025-38550) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-38563](#cve-2025-38563) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2025-38565](#cve-2025-38565) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2025-38572](#cve-2025-38572) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-38699](#cve-2025-38699) | Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_BFA_FC` not compiled |
| [CVE-2025-38729](#cve-2025-38729) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2025-39788](#cve-2025-39788) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | UFS flash storage absent on x86 server |
| [CVE-2023-53257](#cve-2023-53257) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2023-53282](#cve-2023-53282) | Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_LPFC` not compiled |
| [CVE-2023-53285](#cve-2023-53285) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — raw block device write tool absent from HS allowlist |
| [CVE-2023-53320](#cve-2023-53320) | Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPI3MR` not set |
| [CVE-2023-53322](#cve-2023-53322) | QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_QLA_FC` not compiled |
| [CVE-2022-50378](#cve-2022-50378) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Amlogic Meson ARM SoC GPU absent |
| [CVE-2025-39841](#cve-2025-39841) | Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_LPFC` not compiled |
| [CVE-2025-39864](#cve-2025-39864) | cfg80211 wireless framework (`CONFIG_CFG80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2025-39866](#cve-2025-39866) | VFS writeback subsystem | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — writeback always active; Lockdown limits post-exploitation |
| [CVE-2022-50422](#cve-2022-50422) | SAS libsas library (`CONFIG_SCSI_SAS_LIBSAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_SAS_LIBSAS` not set |
| [CVE-2022-50432](#cve-2022-50432) | kernfs subsystem (`CONFIG_KERNFS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_KERNFS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53473](#cve-2023-53473) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53510](#cve-2023-53510) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | UFS flash storage absent on x86 server |
| [CVE-2022-50488](#cve-2022-50488) | BFQ I/O scheduler (`CONFIG_IOSCHED_BFQ`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_IOSCHED_BFQ` not compiled |
| [CVE-2022-50496](#cve-2022-50496) | device mapper (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_BLK_DEV_DM=y`; Lockdown limits post-exploitation |
| [CVE-2022-50546](#cve-2022-50546) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53640](#cve-2023-53640) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2023-53676](#cve-2023-53676) | Linux iSCSI target (`CONFIG_ISCSI_TARGET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ISCSI_TARGET` not compiled |
| [CVE-2025-71075](#cve-2025-71075) | Adaptec aic94xx SAS driver (`CONFIG_SCSI_AIC94XX`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_AIC94XX` not set |
| [CVE-2026-23078](#cve-2026-23078) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2026-23089](#cve-2026-23089) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2026-23191](#cve-2026-23191) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2026-23208](#cve-2026-23208) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2026-23216](#cve-2026-23216) | Linux iSCSI target (`CONFIG_ISCSI_TARGET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ISCSI_TARGET` not compiled |
| [CVE-2025-71238](#cve-2025-71238) | QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_QLA_FC` not compiled |
| [CVE-2026-31581](#cve-2026-31581) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2024-38586](#cve-2024-38586) | Realtek r8169 Ethernet driver (`CONFIG_R8169`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_R8169=y`; Lockdown limits post-exploitation |
| [CVE-2024-38630](#cve-2024-38630) | watchdog timer subsystem (`CONFIG_WATCHDOG`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — watchdog daemon not in allowlist; Lockdown prevents modification |
| [CVE-2024-39463](#cve-2024-39463) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `mount()` blocked by Lockdown; no 9P filesystem on HS deployments |
| [CVE-2024-40956](#cve-2024-40956) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Intel IAX/DSA accelerator hardware absent |
| [CVE-2022-48867](#cve-2022-48867) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Intel IAX/DSA accelerator hardware absent |
| [CVE-2024-46759](#cve-2024-46759) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | ADC128D818 I2C ADC chip absent |
| [CVE-2022-49029](#cve-2022-49029) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | IBM Power Management Extension hardware absent |
| [CVE-2024-50127](#cve-2024-50127) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-50131](#cve-2024-50131) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2024-53057](#cve-2024-53057) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-56606](#cve-2024-56606) | AF_PACKET sockets (`CONFIG_PACKET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `CAP_NET_RAW` not in allowlist; Lockdown prevents modification |
| [CVE-2025-21692](#cve-2025-21692) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2022-49892](#cve-2022-49892) | ftrace / function tracer (`CONFIG_FTRACE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2022-49921](#cve-2022-49921) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2023-53111](#cve-2023-53111) | loop block device (`CONFIG_BLK_DEV_LOOP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `/dev/loop*` not in allowlist; Lockdown prevents modification |
| [CVE-2025-37914](#cve-2025-37914) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2025-37923](#cve-2025-37923) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2025-38369](#cve-2025-38369) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Intel IAX/DSA accelerator hardware absent |
| [CVE-2025-38548](#cve-2025-38548) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Corsair Commander Pro hardware absent |
| [CVE-2022-50320](#cve-2022-50320) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — FPDT crash requires malformed firmware; not reachable on standard OEM hardware |
| [CVE-2023-53395](#cve-2023-53395) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — AML exploit requires crafted firmware; ACPI tables read-only after boot |
| [CVE-2022-50423](#cve-2022-50423) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2026-23378](#cve-2026-23378) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-36971](#cve-2024-36971) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-38577](#cve-2024-38577) | RCU tasks subsystem (`CONFIG_TASKS_RCU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_TASKS_RCU=y`; Lockdown limits post-exploitation |
| [CVE-2024-40958](#cve-2024-40958) | network namespaces (`CONFIG_NET_NS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `CLONE_NEWNET` not in allowlist; Lockdown prevents modification |
| [CVE-2024-41039](#cve-2024-41039) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2024-46713](#cve-2024-46713) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2024-46852](#cve-2024-46852) | DMA-BUF shared buffer (`CONFIG_DMA_SHARED_BUFFER`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no DRM/GPU device on headless server |
| [CVE-2022-48950](#cve-2022-48950) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `perf_event_paranoid=3`; no perf tooling in allowlist |
| [CVE-2022-49026](#cve-2022-49026) | Intel e100 Fast Ethernet driver (`CONFIG_E100`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — Intel Pro/100 NIC not present on modern server hardware |
| [CVE-2024-50055](#cve-2024-50055) | core kernel (`CONFIG_BASE_FULL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_BASE_FULL=y`; Lockdown limits post-exploitation |
| [CVE-2024-50112](#cve-2024-50112) | x86_64 architecture (`CONFIG_X86_64`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — LAM not implemented in Linux 5.19.x; introduced in 6.2 |
| [CVE-2024-56600](#cve-2024-56600) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-56601](#cve-2024-56601) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-56616](#cve-2024-56616) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | DisplayPort MST display hardware absent |
| [CVE-2022-48701](#cve-2022-48701) | USB audio driver (`CONFIG_SND_USB_AUDIO`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | `CONFIG_SND_USB_AUDIO` not set |
| [CVE-2024-36916](#cve-2024-36916) | block I/O cost controller (`CONFIG_BLK_CGROUP_IOCOST`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — iocost cgroup paths not in allowlist; Lockdown prevents modification |
| [CVE-2024-38560](#cve-2024-38560) | Brocade bfa SCSI driver (`CONFIG_SCSI_BFA`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_BFA` not set |
| [CVE-2024-40978](#cve-2024-40978) | QLogic qedi iSCSI driver (`CONFIG_SCSI_QEDI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_QEDI` not set |
| [CVE-2024-46747](#cve-2024-46747) | Cougar HID driver (`CONFIG_HID_COUGAR`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_HID_COUGAR` not set |
| [CVE-2024-50278](#cve-2024-50278) | dm-cache (`CONFIG_DM_CACHE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_DM_CACHE` not compiled |
| [CVE-2024-50279](#cve-2024-50279) | dm-cache (`CONFIG_DM_CACHE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_DM_CACHE` not compiled |
| [CVE-2024-53147](#cve-2024-53147) | FAT/exFAT filesystem (`CONFIG_FAT_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — Lockdown blocks `mount()`; no adversary-controlled FAT volume on HS |
| [CVE-2024-53150](#cve-2024-53150) | USB audio driver (`CONFIG_SND_USB_AUDIO`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SND_USB_AUDIO` not compiled |
| [CVE-2024-56663](#cve-2024-56663) | cfg80211 wireless stack (`CONFIG_CFG80211`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no WiFi NIC present |
| [CVE-2025-21993](#cve-2025-21993) | iSCSI iBFT driver (`CONFIG_ISCSI_IBFT`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ISCSI_IBFT` not set |
| [CVE-2025-22121](#cve-2025-22121) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2025-37785](#cve-2025-37785) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown; crafted ext4 image cannot be mounted |
| [CVE-2022-49865](#cve-2022-49865) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_IPV6=y`; base I:N, Lockdown limits post-exploitation persistence |
| [CVE-2025-38103](#cve-2025-38103) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No USB HID input devices on headless server |
| [CVE-2025-38249](#cve-2025-38249) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2025-38556](#cve-2025-38556) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No USB HID input devices on headless server |
| [CVE-2025-39757](#cve-2025-39757) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2025-39760](#cve-2025-39760) | USB core (`CONFIG_USB`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no USB device on headless server; descriptor parsing path unreachable |
| [CVE-2022-50306](#cve-2022-50306) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown |
| [CVE-2023-53321](#cve-2023-53321) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2023-53376](#cve-2023-53376) | Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPI3MR` not set |
| [CVE-2023-53392](#cve-2023-53392) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No USB HID input devices on headless server |
| [CVE-2023-53521](#cve-2023-53521) | SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set |
| [CVE-2023-53675](#cve-2023-53675) | SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set |
| [CVE-2026-23076](#cve-2026-23076) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2026-23318](#cve-2026-23318) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2023-3268](#cve-2023-3268) | relay filesystem (`CONFIG_RELAY`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — debugfs relay not in allowlist; Lockdown prevents modification |
| [CVE-2023-3567](#cve-2023-3567) | virtual terminal (VT) (`CONFIG_VT`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_VT=y`; base I:N, Lockdown limits post-exploitation persistence |
| [CVE-2024-26593](#cve-2024-26593) | Intel SMBus I2C controller (`CONFIG_I2C_I801`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — no I2C tool in allowlist; Lockdown prevents modification |
| [CVE-2024-34777](#cve-2024-34777) | DMA map benchmark (`CONFIG_DMA_MAP_BENCHMARK`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_DMA_MAP_BENCHMARK` not compiled in HS kernel |
| [CVE-2024-49860](#cve-2024-49860) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — malformed ACPI _STR firmware absent; standard OEM firmware conforms to spec |
| [CVE-2022-49799](#cve-2022-49799) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2025-37879](#cve-2025-37879) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `mount()` blocked by Lockdown; no 9P filesystem on HS deployments |
| [CVE-2025-39869](#cve-2025-39869) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Texas Instruments eDMA hardware absent |
| [CVE-2024-36883](#cve-2024-36883) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — pernet race requires module loading; kmod's access to modprobe.d blocked by Lockdown file-access enforcement |
| [CVE-2024-50193](#cve-2024-50193) | x86_64 architecture (`CONFIG_X86_64`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — perf_event_open() blocked by perf_event_paranoid=3 |
| [CVE-2024-26654](#cve-2024-26654) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-erased">0.0</span> | No audio hardware present |
| [CVE-2024-26939](#cve-2024-26939) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2022-48689](#cve-2022-48689) | TCP receive zerocopy (`CONFIG_INET`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_INET=y`; Lockdown reduces MI: High→Low (AC:H base) |
| [CVE-2025-39702](#cve-2025-39702) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_IPV6=y`; Lockdown reduces MI: High→Low (AC:H base) |
| [CVE-2023-6531](#cve-2023-6531) | Unix domain sockets (`CONFIG_UNIX`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-warning text-dark">6.5 MEDIUM</span> | Affected — `CONFIG_UNIX=y`; Lockdown reduces MI: High→Low (AC:H base) |
| [CVE-2023-51043](#cve-2023-51043) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no DRM/GPU device on headless server |
| [CVE-2025-37915](#cve-2025-37915) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-0775](#cve-2024-0775) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">6.7 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `mount(MS_REMOUNT)` blocked by Lockdown; ext4 remount entry point unreachable |
| [CVE-2024-0841](#cve-2024-0841) | hugetlbfs (`CONFIG_HUGETLBFS`) | <span class="badge bg-warning text-dark">6.6 MEDIUM</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — mount() blocked by Lockdown; hugetlbfs mount path unreachable |

Over 1,000 CVEs across 178 disabled-feature groups are listed in [Not Affected — Disabled Features](#not-affected-disabled-features) below.

#### How to read the backstop sections

HeartSuite Core Secure runs **two independent kernel-level controls**, and the entries below reference both. They are not peers in a list — one is load-bearing, one is defense-in-depth, and the distinction matters when reading residual risk:

- **Lockdown (load-bearing).** `hs_sandbox_caching.c` enforces the SPF allowlist on every `execve`. This check runs unconditionally — it is **not** gated by `HS_lockdown_state` — so it continues to refuse non-allowlisted programs even if an attacker with arbitrary kernel write clears Lockdown. The only Lockdown-conditional behavior in this file is an additional log-file write block; the allowlist match itself is independent.
- **Lockdown (defense-in-depth).** `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`. While that atomic is nonzero, `kernel/ioctl.c:561,568` returns EPERM on `FS_IOC_GETFLAGS`/`FS_IOC_SETFLAGS` (closing the `chattr -i` path that would otherwise let root strip immutability from the allowlist file), and `kernel/namespace.c:4218,4300,4453` returns EPERM on all mount paths. There are five `HS_locked_down()` check sites total in the kernel — none in `fs/` or `net/` — so Lockdown is an API-gate layer, not an in-line corruption boundary.

**The load-bearing control against persistence and lateral expansion is Lockdown's allowlist.** Even in the worst case where an attacker chains a kernel UAF into arbitrary write and clears `HS_lockdown_state`, they still cannot run new programs, modify the allowlist, install backdoors, or survive a reboot, because the allowlist check is not on the same state machine. They regain only the ability to mount filesystems and set immutable flags — meaningful but bounded.

Per-CVE entries below name the bug, then state which of these two layers limits its post-exploitation impact and how. The standard backstop paragraph is intentionally short: it points back here rather than re-litigating the architecture in every entry.

##### Why this is unusual

Most kernel hardening products gate enforcement on a single state variable that an attacker with arbitrary kernel write can clear in one instruction. HeartSuite Core Secure does not work that way. **Lockdown's allowlist is consulted on every `execve` regardless of Lockdown's state** — there is no kill-switch an attacker can flip. Even in the worst case examined anywhere in this document, the system continues to refuse new code execution. That is the property that makes the per-CVE backstops below short, calm, and identical: the answer is the same for every CVE, because the answer is structural.

##### Note on Scores on HeartSuite and deployment tuning

The Scores on HeartSuite published in this document assume a **worst-case allowlist composition** — i.e., that your Lockdown allowlist contains common utilities including networked tools (`curl`, `wget`, `ssh` outbound, `nc`, `python` with sockets, etc.). Under that assumption, an attacker who reaches root via one of the Affected CVEs retains a confidentiality impact of HIGH (`MC:H`) because they can read sensitive data and pipe it out via an already-allowlisted networked utility. This is the conservative, deployment-agnostic floor.

If you run a tighter allowlist, you may legitimately credit a lower MC. Specifically:

- **Allowlist contains zero outbound-networking utilities** (no `curl`, `wget`, outbound `ssh`, `nc`, scripting languages with socket access, etc.): `MC:L` becomes defensible — the attacker can read on disk but has no in-band exfiltration path within Lockdown's allowlist. Out-of-band (physical-console, side-channel) exfiltration remains possible; that's why the credit is L, not N.
- **Allowlist contains zero process-mutation utilities** (no `kill`, `pkill`, init-system control surfaces beyond what HS itself uses): `MA:L` becomes defensible for the disruption-via-userspace component, though kernel-level availability impact (panics, OOM via syscalls) is independent of allowlist composition and keeps `MA:H` for any CVE that grants kernel-context primitives.

These are deployment-specific reductions and are **not** baked into the published Scores on HeartSuite in this document. If you have hardened your allowlist accordingly, you can recompute your deployment-specific score by adjusting `MC` and/or `MA` in the modified vector. The published scores are correct for any deployment that has not affirmatively confirmed the tighter conditions above.

##### Note on Not-exploitable entries that depend on allowlist composition

Several Not-exploitable entries below justify their 0.0 Score on HeartSuite with phrasing of the form *"X not in allowlist."* These claims are accurate for any HeartSuite deployment built through the standard Setup Mode workflow, where the allowlist is populated from production service activity. Utilities not invoked during that workflow would not be added to the allowlist. Specifically, the following utilities should not be allowlisted on a production HeartSuite Core Secure deployment:

- `modprobe`, `insmod` / `kmod` — kernel module loading. On Debian 12, these resolve to `kmod`, which standard Setup Mode does allowlist; the protection is Lockdown's file-access enforcement denying `kmod` access to `/usr/lib/modprobe.d/`. Granting `kmod` that access reverts CVE-2024-36883 (and any other module-loading-dependent CVE) to **Affected**.
- `tc` (iproute2 traffic control) — qdisc/filter manipulation. Allowlisting reverts CVE-2025-37914 / 37915 / 37923 / 22121 and other `NET_SCHED` CVEs to **Affected**.
- `bpftool`, `trace-cmd`, `perf`, debugfs/tracefs writers — kernel instrumentation. Allowlisting reverts the kprobe / tracing / perf CVE cluster (CVE-2024-38588 etc.) to **Affected**.
- `dmsetup`, raw block-device tools, `cryptsetup` mappings created post-boot — block-layer mutation. Same shape.
- `ip xfrm`, `setkey`, strongSwan, libreswan, or any IKE daemon — XFRM management. Allowlisting any of these enables XFRM security association setup, making `esp_output` reachable and reverting CVE-2026-43284 to **Affected 8.8 HIGH**.
- `e4defrag` or any extent-defragmentation tool — ext4 online defragmentation. Allowlisting reverts CVE-2024-26704 to **Affected 7.8 HIGH**.

If you run a development, debug, or instrumentation-heavy deployment and legitimately need any of the above, treat the corresponding Not-exploitable entries in this document as **Affected** for your environment, and apply the standard Affected backstop logic (Lockdown's allowlist still refuses *unknown* programs, but the now-allowlisted utility is itself the trigger). The "Not exploitable" classifications below are correct for HeartSuite Core Secure deployments; they are not universal.

### CVE-2026-31431

**Status**: Not Affected  
**Component**: algif_aead — the in-kernel AEAD interface exposed by the AF_ALG socket family (`CONFIG_CRYPTO_USER_API_AEAD`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org); NVD assessment pending  
**Upstream fix**: Linux 6.12.85 (LTS), 6.18.22 (LTS), 6.19.12 (LTS)

This CVE describes a privilege escalation through the AF_ALG socket interface. An attacker who can open an AF_ALG socket reaches `algif_aead_copy_sgl()`, exploits a copy-on-write failure in the scatter-gather list handling, and gains root.

`CONFIG_CRYPTO_USER_API_AEAD` is not compiled into the HeartSuite Core Secure kernel. The AF_ALG socket family is not available. An attempt to open an AF_ALG socket returns `EAFNOSUPPORT` — there is no `algif_aead` code present in the running kernel and therefore no reachable code path. The HeartSuite Core Secure kernel predates the upstream fix versions listed above, but the fix is not required: the fix removes a vulnerability in code that was never compiled in.

Lockdown closes the remaining question. Even if the code path were present, Lockdown — `chattr +i` filesystem immutability combined with the HeartSuite Core Secure kernel refusing runtime changes to the allowlist — removes every useful action root can take after gaining privilege. The kernel refuses to clear immutable flags. Mount operations are blocked in Lockdown. Writes to the audit log are blocked. Root cannot modify the allowlist, add a backdoor, or persist across a reboot.

See [Deployment Scenarios → Production Servers](../introduction/deployment-scenarios/) for the architectural context of how Lockdown interacts with a privilege escalation reaching root.

### CVE-2026-43284

**Status**: Not exploitable  
**Component**: XFRM framework and IPv6 ESP (`CONFIG_XFRM`, `CONFIG_INET6_ESP`)  
**Base Score**: 8.8 HIGH — NVD full vector assessment pending  
**Score on HeartSuite**: 0.0 — `esp_output` is unreachable; no XFRM security association can be established on a default HeartSuite Core Secure deployment  
**Upstream fix**: merged; backported to active stable series by 2026-05-09 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a write-what-where condition in the `esp_output` page-write path. The vulnerable code is at `net/ipv6/esp6.c:524`: `tail = page_address(page) + pfrag->offset` followed by `esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto)`. If `pfrag->offset` is corrupted or attacker-influenced, the trailer write reaches an arbitrary kernel page address. The identical pattern exists in `net/ipv4/esp4.c:489` (`CONFIG_INET_ESP`, not compiled), but the absence of IPv4 ESP is irrelevant — `esp6.c` carries the same code. The bug is one half of the "Dirty Frag" exploit chain; chaining it with CVE-2026-43500 produces a deterministic privilege escalation.

`CONFIG_INET6_ESP=y` is compiled in and `esp6.c:524` is present in the running kernel. The `esp_output` function is called only when the kernel encrypts an outgoing packet that matches a configured XFRM security association. With no security association configured, `esp_output` is never reached — by any user, at any privilege level. Configuring a XFRM security association requires XFRM management tooling: `ip xfrm` (iproute2), `setkey`, strongSwan, libreswan, or an equivalent IKE daemon. None of these are in the HeartSuite Core Secure default allowlist. Under Lockdown, the allowlist is `chattr +i` immutable and `FS_IOC_SETFLAGS` returns `EPERM` for all callers — root cannot add management tools and therefore cannot establish a security association. The `esp_output` page-write path is unreachable for the lifetime of the boot.

The Dirty Frag chain has no second link on this system regardless: `CONFIG_AF_RXRPC` is not compiled (see CVE-2026-43500).

The trigger cannot be reached on any default HeartSuite Core Secure deployment.

If your deployment adds XFRM management tooling (`ip xfrm`, `setkey`, strongSwan, libreswan, or an equivalent IKE daemon) to the HS allowlist, a security association can be established and `esp_output` becomes reachable. In that configuration this CVE applies at its base score of 8.8 HIGH. Treat it as Affected and apply the standard backstop logic.

### CVE-2026-43500

**Status**: Not Affected  
**Component**: rxrpc — RxRPC transport protocol (`CONFIG_AF_RXRPC`)  
**Base Score**: 7.8 HIGH — NVD full vector assessment pending  
**Upstream fix**: merged; backported to active stable series by 2026-05-09 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a local privilege escalation through an out-of-bounds write in the rxrpc transport protocol implementation. It is the second half of the "Dirty Frag" exploit chain (paired with CVE-2026-43284); chaining both produces a deterministic privilege escalation to root.

`CONFIG_AF_RXRPC` is not compiled into the HeartSuite Core Secure kernel. The rxrpc address family is not available; an attempt to open an `AF_RXRPC` socket returns `EAFNOSUPPORT`. The vulnerable code in `net/rxrpc/` is entirely absent from the running kernel. The HeartSuite Core Secure kernel predates the upstream fix, but the fix is not required: there is no reachable code path for this bug on any HeartSuite Core Secure deployment. The Dirty Frag chain has no second link on this system.

The trigger cannot be reached on any HeartSuite Core Secure deployment.

### CVE-2024-47685

**Status**: Score on HeartSuite 0.0 — trigger not present in default configuration
**Component**: nf_reject_ipv6 — IPv6 netfilter TCP RST generation (`CONFIG_NF_REJECT_IPV6`, `CONFIG_IP6_NF_TARGET_REJECT`)  
**Base Score**: 9.1 CRITICAL (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:H)  
**Score on HeartSuite**: 0.0 — trigger not present; HeartSuite installs no ip6tables REJECT rules  
**Upstream fix**: Linux 4.19.323, 5.4.285, 5.10.227, 5.15.168, 6.1.113, 6.6.54, 6.10.13, 6.11.2 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an information disclosure in the IPv6 netfilter TCP reset path. When the kernel sends a TCP RST packet in response to a connection rejected by an ip6tables rule, `nf_reject_ip6_tcphdr_put()` allocates a TCP header via `skb_put()` without zeroing the buffer. The function then writes every field in the header explicitly except the four reserved bits (`th->res1`) in byte 12. Those bits retain whatever value was in the allocated kernel memory region. The RST packet is sent with that uninitialized content on the wire.

`CONFIG_NF_REJECT_IPV6=y` and `CONFIG_IP6_NF_TARGET_REJECT=y` are compiled in. The code path exists in this kernel. The vulnerable function has five callers across the kernel source. In this configuration only `ip6t_REJECT.c` is compiled — the remaining four callers (`nft_reject_ipv6`, `nft_reject_inet`, `nft_reject_bridge`, `nft_reject_netdev`) are all gated by `CONFIG_NF_TABLES`, which is not set. Reaching the vulnerable code therefore requires an active ip6tables rule using `REJECT --reject-with tcp-reset` on IPv6 traffic. The HeartSuite Core Secure install scripts and service unit contain no ip6tables rules of any kind. If you manually add such a rule, this path becomes exposed.

Lockdown does not patch the vulnerability mechanism — the kernel still places uninitialized bits into the packet header if the path is reached. However, the program allowlist and Lockdown together make the triggering condition unreachable in practice.

To trigger this CVE, you must first add an ip6tables rule with `REJECT --reject-with tcp-reset`. That requires running `ip6tables` with root privilege. In Lockdown, HeartSuite's program allowlist is enforced at the kernel level for every user including root: a program without a valid allowlist entry cannot execute regardless of the caller's privilege level. Network management utilities such as `ip6tables` have no allowlist entry on a production HeartSuite deployment, so root cannot run them and the rule cannot be added.

Lockdown closes the remaining path. Even if an attacker gained root and attempted to add `ip6tables` to the allowlist first, Lockdown blocks every mechanism for doing so: `FS_IOC_SETFLAGS` (the ioctl used by `chattr`) returns `EPERM` for all callers during lockdown, so immutable flags cannot be cleared from the allowlist database files; `mount()`, `fsmount()`, and `move_mount()` all return `EPERM`, blocking any bind-mount or remount workaround; and the HeartSuite reactivation path is disabled, preventing the service from being reconfigured to accept new entries.

The result is a two-layer guarantee: the program allowlist prevents the trigger from being established, and Lockdown ensures the allowlist cannot be modified to enable the tools that would establish it. A 9.1 CRITICAL CVE that requires setting up an ip6tables REJECT rule becomes unreachable by any user, including root, once Lockdown is in force.

### CVE-2022-41674, CVE-2022-42719, CVE-2022-42720

**Status**: Not exploitable
**Component**: mac80211 — 802.11 wireless stack (`CONFIG_MAC80211`)  
**Base Scores**: CVE-2022-42719: 8.8 HIGH (AV:A); CVE-2022-41674: 8.1 HIGH (AV:A); CVE-2022-42720: 7.8 HIGH (AV:A)  
**Score on HeartSuite**: 0.0 — no WiFi hardware present; attack vector (frame injection via wireless NIC) has no path to execution  
**Affected range**: Linux 5.19.x before 5.19.16  
**Upstream fix**: Linux 5.4.218–219, 5.10.148–149, 5.15.74, 5.19.16, 6.0.2

These three CVEs cover memory corruption in the mac80211 multi-BSSID scanning path, exploitable by an attacker who can inject 802.11 management frames:

- **CVE-2022-41674** (CVSS 8.1) — buffer overflow in `ieee80211_bss_info_update()` in `net/mac80211/scan.c` triggered by a crafted beacon or probe response with a malformed multi-BSSID element
- **CVE-2022-42719** (CVSS 8.8) — use-after-free when parsing a multi-BSSID element, exploitable to crash the kernel or gain privilege
- **CVE-2022-42720** (CVSS 7.8) — refcounting bugs in multi-BSS handling reachable through the same scanning path

`CONFIG_MAC80211=y` is compiled in and 5.19.6 is within the affected version range for all three. The entry point is `ieee80211_scan_rx()` in `net/mac80211/rx.c`, which has a single caller: the hardware NIC interrupt RX path. A physical WiFi NIC must be present, registered, and receiving frames for any of these paths to execute. `CONFIG_MAC80211_HWSIM` (software WiFi simulator) is not set. On server deployments without a WiFi interface the code paths are unreachable.

If exploited on a deployment with WiFi hardware, all three CVEs lead to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

HeartSuite makes the allowlist database files immutable before Lockdown is engaged. Once Lockdown is active, `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Lockdown's allowlist adds a further constraint on program execution: every execution is checked at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor program they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

### CVE-2023-0266

**Status**: Not exploitable
**Component**: ALSA PCM — in-kernel sound subsystem (`CONFIG_SND`)  
**Base Score**: 7.9 HIGH (AV:L/AC:H/PR:L/UI:N/S:C/C:H/I:H/A:H)  
**Score on HeartSuite**: 0.0 — no audio hardware present; no `/dev/snd` devices; ioctl path unreachable  
**Affected range**: Linux 5.16 through 6.1.5  
**Upstream fix**: Linux 4.14.303, 4.19.270, 5.4.229, 5.10.163, 5.15.88, 6.1.6 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a use-after-free in the ALSA PCM control interface. `SNDRV_CTL_IOCTL_ELEM_READ` and `SNDRV_CTL_IOCTL_ELEM_WRITE` (32-bit compat variants) are missing locks that allow a local user to trigger a use-after-free and gain elevated privilege.

`CONFIG_SND=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable code requires an ALSA-accessible sound device. Server deployments without audio hardware have no `/dev/snd` devices and no reachable path to this ioctl.

If exploited on a deployment with audio hardware, the CVE achieves local privilege escalation to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. Once Lockdown is active, `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Lockdown's allowlist adds a further constraint on program execution: every execution is checked at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor program they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

### CVE-2022-4139

**Status**: Not exploitable
**Component**: i915 GPU driver (`CONFIG_DRM_I915`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**Score on HeartSuite**: 0.0 — no i915 GPU present; GPU context entry point unreachable  
**Affected range**: Linux 5.16 through 6.0.10  
**Upstream fix**: Linux 5.4.226, 5.10.157, 5.15.81, 6.0.11 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an incorrect TLB flush in the Intel i915 GPU driver. When GPU memory mappings are changed, a missing or incorrect TLB invalidation can leave stale translation entries active, allowing writes to land in the wrong physical pages. This can corrupt kernel memory and is exploitable by a local user with access to a GPU context to gain elevated privilege.

`CONFIG_DRM_I915=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable path requires an Intel i915 GPU to be present and accessible. Deployments without i915 hardware have no reachable path to this driver.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2023-2236, CVE-2022-3910

**Status**: Affected  
**Component**: io_uring — asynchronous I/O subsystem (`CONFIG_IO_URING`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**Score on HeartSuite**: 7.1–7.3 HIGH — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High; score stays within the HIGH band  
**Affected ranges**: CVE-2023-2236: 5.19 through 6.0.10; CVE-2022-3910: 5.18 through 5.19.10  
**Upstream fix**: CVE-2023-2236: 6.0.11; CVE-2022-3910: 5.19.11 (5.19 branch is EOL for CVE-2023-2236; CVE-2022-3910 fix was in-branch but 5.19.6 predates it)

**What this means for an attacker:**

Both CVEs describe use-after-free conditions in io_uring's fixed file management, exploitable by a local user to gain root:

- **CVE-2023-2236** — double `fput()` in the `io_install_fixed_file()` path. When an async open operation installs a fixed file and encounters an error, `io_install_fixed_file()` calls `fput(file)` at its error label; the caller then calls `fput(file)` a second time. The file's reference count reaches zero while the object is still referenced, producing a use-after-free.
- **CVE-2022-3910** — improper reference count update in io_uring's fixed file handling that leads to a use-after-free and local privilege escalation.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IO_URING=y` is compiled in. The `io_uring_setup` syscall has no capability gate — any local user can create an io_uring ring and reach both vulnerable paths. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

These constraints are why the Score on HeartSuite reflects a reduced MI (High→Low): root cannot modify the allowlist, cannot install persistent backdoors, and cannot survive a reboot. Confidentiality and Availability impacts remain High, reflecting that an attacker with a live root session can still read data and disrupt services within the bounds of already-permitted processes.

A more sophisticated exploit could use the kernel use-after-free to directly corrupt kernel data structures before surfacing in userspace. In that scenario Lockdown's API-level restrictions are not the binding constraint — the corruption happens below the layer where those checks operate. This is why the Score on HeartSuite does not reach 0.0: the io_uring path is reachable by any local user, and pre-userspace kernel corruption is outside the scope of what Lockdown addresses.

### CVE-2024-0775

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 6.7 MEDIUM (AV:L/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `mount(MS_REMOUNT)` blocked by Lockdown; ext4 remount entry point unreachable
**Affected range**: kernels through 6.7.2, 6.6.15, 6.1.79, 5.15.148, 5.10.211, 5.4.270, 4.19.308 (5.19 branch is EOL; no backport)
**Upstream fix**: Linux 6.7.3, 6.6.16, 6.1.80, 5.15.149, 5.10.212, 5.4.271, 4.19.309

This CVE describes a use-after-free in the `__ext4_remount()` error path in `fs/ext4/super.c`. When a remount operation fails and rolls back to saved options, the function restores quota file name pointers via `rcu_assign_pointer(sbi->s_qf_names[i], old_opts.s_qf_names[i])` and then frees the displaced current pointer via `kfree(to_free[i])`. If the success path has already freed those names at the earlier `kfree(old_opts.s_qf_names[i])` call, the error path operates on already-freed memory. The CVE requires `CAP_SYS_ADMIN` (implicit in `PR:H`) because `mount(MS_REMOUNT)` is a privileged operation.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. `__ext4_remount()` is reached exclusively via `mount(MS_REMOUNT)` — a privileged operation that Lockdown blocks unconditionally. `do_mount()` returns `EPERM` whenever `HS_locked_down()` is true (`kernel/namespace.c:4218`), so root cannot call `mount()` at all; the CVE's entry point is blocked at the syscall level before any ext4 code is reached. In Lockdown, the allowlist additionally prevents execution of any exploit program that would invoke the remount path.

### CVE-2023-52530

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present; WoWLAN path unreachable
**Affected range**: kernels through 6.7.3, 6.6.18, 6.1.81, 5.15.150, 5.10.214, 5.4.273, 4.19.311 (5.19 branch is EOL; no backport)
**Upstream fix**: Linux 6.7.4, 6.6.19, 6.1.82, 5.15.151, 5.10.215, 5.4.274, 4.19.312

This CVE describes a use-after-free in the mac80211 WoWLAN (Wake on Wireless LAN) GTK rekey path. When `ieee80211_gtk_rekey_add()` installs a new group temporal key, it calls `ieee80211_key_link()`. If the new key is identical to the one already installed — the KRACK protection path — `ieee80211_key_link()` frees the new key via `ieee80211_key_free_unused(key)` and returns `0` to signal that the reinstall was silently accepted. `ieee80211_gtk_rekey_add()` treats the `0` return as success, skips the error branch, and returns `&key->conf` — a pointer into the object that was just freed. The caller receives a dangling pointer to freed `ieee80211_key` memory.

`CONFIG_MAC80211=y` is compiled in. The entry point `ieee80211_gtk_rekey_add()` guards itself with `WARN_ON(!local->wowlan)`: it requires WoWLAN to be active, which in turn requires a WiFi NIC with WoWLAN firmware support, a wireless interface, and an active station association. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and neither the rekey path nor any other mac80211 code path is reachable.

If exploited on a deployment with WiFi hardware and WoWLAN active, the CVE leads to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Lockdown's allowlist adds a further constraint on program execution: every execution is checked at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor program they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

### CVE-2023-52612

**Status**: Not exploitable
**Component**: kernel crypto framework — scomp interface (`CONFIG_CRYPTO`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_INET_IPCOMP` not compiled; no compression algorithm registered; `scomp_acomp_comp_decomp()` unreachable
**Affected range**: kernels prior to stable fixes in the 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8-rc; backported across active stable series

This CVE describes a buffer overflow in the kernel software compression (`scomp`) interface in `crypto/scompress.c`. The `scomp_acomp_comp_decomp()` function uses a per-CPU scratch buffer of `SCOMP_SCRATCH_SIZE` bytes as working space. If the caller provides a `req->dst` scatter list smaller than `SCOMP_SCRATCH_SIZE`, the function still caps `req->dlen` to `SCOMP_SCRATCH_SIZE` and then copies the full output — up to that size — into `req->dst` via `scatterwalk_map_and_copy()`. No check verifies that `req->dst` can hold `req->dlen` bytes before the copy. A caller who controls `req->dst` and triggers a compression or decompression that fills the scratch buffer can write beyond the end of the destination scatter list.

The `scomp` interface is the software-side of the kernel's `acomp` (asynchronous compression) API. It is not a general-purpose path used by dm-crypt, TLS, or cipher operations — it exists exclusively to service IPsec compression transforms (IPCOMP, RFC 3173). `scomp_acomp_comp_decomp()` is only reached when a compression algorithm is registered with the scomp backend and a caller submits a request to it. On HeartSuite Core Secure there are no such callers and no such registrations:

- `# CONFIG_INET_IPCOMP is not set` — the IPv4/IPv6 IPsec compression module is not compiled; no IPCOMP transform can be configured
- `# CONFIG_CRYPTO_DEFLATE is not set` — DEFLATE not compiled; not registered with scomp
- `# CONFIG_CRYPTO_LZ4 is not set` — LZ4 not compiled; not registered with scomp
- `# CONFIG_CRYPTO_ZSTD is not set` — ZSTD not compiled; not registered with scomp

With no compression algorithm registered, the scomp backend has no handler to dispatch to. `CONFIG_CRYPTO=y` means the crypto framework is present, but framework presence is not trigger reachability. The trigger cannot be reached on any HeartSuite Core Secure deployment.

### CVE-2024-26654

**Status**: Not exploitable
**Component**: ALSA AICA Dreamcast sound driver (`CONFIG_SND_AICA`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a use-after-free caused by a circular scheduling race between `dreamcastcard->timer` and `spu_dma_work` in the AICA Yamaha sound chip driver (`sound/sh/aica.c`). The timer callback `aica_period_elapsed()` schedules `spu_dma_work` via `schedule_work()`; the work handler then re-arms the timer via `mod_timer()`. `spu_begin_dma()` independently schedules the work and arms the timer in the same call. These two execution paths can race against each other and against card teardown, producing a use-after-free on the `snd_card_aica` object while the timer or work item is still pending.

`CONFIG_SND_AICA` is not set in the HeartSuite Core Secure kernel. `sound/sh/aica.c` is gated by `obj-$(CONFIG_SND_AICA)` in `sound/sh/Makefile` and is not compiled. There is no AICA driver code present in the running kernel — not merely absent hardware, but absent code. An attempt to reach this path has no code to execute. The HeartSuite Core Secure kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.

### CVE-2024-26704

**Status**: Not exploitable
**Component**: ext4 filesystem — online defragmentation (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `EXT4_IOC_MOVE_EXT` ioctl only reached by defragmentation tools; none in HS allowlist
**Affected range**: kernels prior to stable fixes in the 6.8.x, 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8; backported across active stable series

This CVE describes a use-after-free in `ext4_move_extents()` in `fs/ext4/move_extent.c`, reachable via the `EXT4_IOC_MOVE_EXT` ioctl. The function moves file extents between an original inode and a donor inode. If the first move operation fails, `o_start` has not advanced past `orig_blk`, so `*moved_len` is set to zero. Preallocation blocks set up for `orig_inode` and `donor_inode` are discarded only when `*moved_len` is non-zero — the guard at `move_extent.c:692`. With `*moved_len == 0`, those preallocations are never discarded, leaving stale preallocation state that produces a use-after-free when the preallocations are later released. The `EXT4_IOC_MOVE_EXT` ioctl requires only write access to the file — no `CAP_SYS_ADMIN`, consistent with the `PR:L` CVSS score.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. The `EXT4_IOC_MOVE_EXT` ioctl is the sole entry point to the vulnerable `ext4_move_extents()` path; it is invoked by extent-defragmentation tools (`e4defrag`) and not by normal filesystem read or write operations. No defragmentation tool appears in the HS allowlist, and the kernel blocks any process without an allowlist entry from executing. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

If your deployment adds `e4defrag` or any other extent-defragmentation tool to the HS allowlist, the `EXT4_IOC_MOVE_EXT` ioctl becomes reachable and this CVE applies at its base score of 7.8 HIGH. Treat it as Affected and apply the standard backstop logic.

### CVE-2024-26842

**Status**: Not exploitable
**Component**: UFS host controller driver (`CONFIG_SCSI_UFSHCD`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an out-of-bounds memory access in the UFS host controller driver's MCQ (Multi-Circular Queue) mode. When `task_tag >= 32` and `sizeof(unsigned int) == 4`, the expression `1U << task_tag` is undefined behaviour in C — shifting a 32-bit value by 32 or more positions. In practice this produces incorrect bitmask values in the per-queue task tracking, allowing the computed mask to index outside the valid task range and corrupt adjacent memory.

`CONFIG_SCSI_UFSHCD` is not set in the HeartSuite Core Secure kernel. The UFS host controller driver is not compiled, and no UFS source files are present under `drivers/scsi/ufs/` in the kernel tree. The prior claim that "ufshcd is compiled in but never bound to hardware" was incorrect — the driver does not exist in the running kernel image at all. The HeartSuite Core Secure kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.

### CVE-2022-48662

**Status**: Not exploitable
**Component**: Intel i915 DRM driver — i915_perf (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no Intel display GPU present
**Affected range**: Linux 5.19.x before 5.19.16; 5.15.x before 5.15.74; earlier stable series also affected
**Upstream fix**: Linux 5.19.16, 5.15.74, 5.10.148, 5.4.218, 4.19.263 (fix landed within the 5.19 branch before it reached EOL; 5.19.6 predates it)

This CVE describes a use-after-free in the i915 performance monitoring subsystem (`i915_perf.c`). During OA register reconfiguration, `i915_perf` iterates `i915->gem.contexts.list` under `i915->gem.contexts.lock`. For each entry it acquires a reference via `kref_get_unless_zero()` and then **drops the spin lock** to call `gen8_configure_context()`. After the call it re-acquires the lock and calls `list_safe_reset_next(ctx, cn, link)` to advance the iteration cursor — dereferencing `ctx->link`. The assumption is that holding a reference prevents the context from being unlinked. It does not: a concurrent thread can remove `ctx` from the list while its refcount is non-zero. When `list_safe_reset_next` dereferences `ctx->link` after the lock is re-acquired, it reads from freed or repurposed list-head memory.

`CONFIG_DRM_I915=y` is compiled in and 5.19.6 falls within the affected range. No Intel integrated or discrete display GPU is present on a server deployment. Without GPU hardware, DRM device nodes are not created and the i915_perf entry point is unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

If exploited on a deployment with i915 hardware, the CVE leads to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Lockdown's allowlist adds a further constraint on program execution: every execution is checked at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor program they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

### CVE-2024-26934

**Status**: Not exploitable
**Component**: USB core (`CONFIG_USB`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no USB interface device on headless HS server; deadlock race unreachable
**Affected range**: 4.11–6.8
**Upstream fix**: 6.8.2 series

Among the attribute file callback routines in `drivers/usb/core/sysfs.c`, `interface_authorized_store()` is the only one that acquires a device lock on an ancestor device. It delegates immediately to `usb_deauthorize_interface()` (`drivers/usb/core/message.c`), which takes `device_lock(dev->parent)` first (line 1792) and then `device_lock(dev)` (line 1795). This lock ordering diverges from other USB subsystem paths, creating an ABBA deadlock when a concurrent bind or configuration operation holds the interface device lock and waits to acquire the parent lock while `usb_deauthorize_interface()` holds the parent lock and waits for the child. The deadlock stalls the USB subsystem and can produce a kernel hang. The HS 5.19.6 kernel carries the unpatched `interface_authorized_store()` at `drivers/usb/core/sysfs.c:1172` and the unchanged `usb_deauthorize_interface()` at `drivers/usb/core/message.c:1792`.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. Triggering the ABBA deadlock race requires writing to the `/sys/.../authorized` sysfs attribute of an enumerated USB interface device while a concurrent USB operation is in progress. HeartSuite Core Secure runs on headless server hardware with no external USB devices connected; no USB interface device is enumerated, so the sysfs path does not exist and the race condition is unreachable. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-26939

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no Intel display GPU present
**Affected range**: pre-6.8
**Upstream fix**: 6.8 series

Object debugging tools were sporadically reporting illegal attempts to free a still-active i915 VMA object when parking a GT believed to be idle: `[161.359441] ODEBUG: free active object type: i915_active`. When the GPU's Graphics Tile (GT) transitions to the parked (powered-down) state, `i915_vma_parked()` (`drivers/gpu/drm/i915/i915_vma.c:1729`) iterates the `gt->closed_vma` list of VMAs marked for deferred destruction. For each candidate it calls `i915_gem_object_trylock()` (line 1758) and, on success, calls `i915_vma_destroy()` (line 1760) immediately — without checking whether the VMA's embedded `i915_active` tracker has reached zero. If outstanding GPU command-buffer work still holds a live reference through that tracker, the object is freed while completion callbacks continue to dereference it, producing a use-after-free with attacker-controlled timing on the GPU side.

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes are not created and the GT power-management paths that call `i915_vma_parked()` are never reached. The environmental score reflects this: the vulnerable code path is structurally unreachable on the deployed hardware configuration.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-48689

**Status**: Affected
**Component**: TCP receive zerocopy (`CONFIG_INET`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)
**Affected range**: 4.14–pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

A syzbot report identified a misuse of pfmemalloc page status in TCP zerocopy receive paths. In `tcp_zerocopy_receive()` (`net/ipv4/tcp.c:2086`), socket buffer fragment pages are collected into a batch (line 2178: `page = skb_frag_page(frags)`) and mapped directly into userspace via `vm_insert_pages()`. No `page_is_pfmemalloc()` check is performed before adding a fragment page to the batch. Pages allocated from pfmemalloc reserves (used to break memory-pressure deadlocks in the network receive path) carry special lifecycle accounting; mapping them into userspace circumvents that accounting. A local attacker who can induce a pfmemalloc allocation into the TCP receive path can map a reserve page into their own address space, potentially corrupting page refcount state in ways that lead to privilege escalation.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP zerocopy receive path (`TCP_ZEROCOPY_RECEIVE` ioctl on a connected socket) is reachable by any local user with network access. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-48701

**Status**: Not exploitable
**Component**: USB audio driver (`CONFIG_SND_USB_AUDIO`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

There may be a bad USB audio device with a USB ID of (0x04fa, 0x4201) and fewer than 4 interfaces; an out-of-bounds read bug occurs when the USB audio stream parser iterates altsettings. The Dallas DS4201 workaround at `sound/usb/stream.c:1108` unconditionally caps `num = 4` regardless of how many altsettings the device actually reports. If a malicious or malformed device presents that USB ID with fewer than 4 altsettings, the loop at line 1111 accesses `iface->altsetting[i]` beyond the bounds of the array, leaking kernel memory.

`CONFIG_SND_USB_AUDIO` is not set in the HS 5.19.6 configuration. The USB audio driver — including the vulnerable `sound/usb/stream.c` altsetting parser — is not compiled into the kernel image. A USB device with this ID cannot be claimed by any USB audio driver, and the vulnerable code path does not exist on this system.

### CVE-2022-48702

**Status**: Not exploitable
**Component**: EMU10K1 audio driver (`CONFIG_SND_EMU10K1`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

The voice allocator sometimes begins allocating from near the end of the array and then wraps around; however `snd_emu10k1_pcm_channel_alloc()` accesses the voices array without the wrapping modulo that the allocator itself uses. The round-robin allocator in `sound/pci/emu10k1/voice.c:42` uses `i %= NUM_G` to keep indices in bounds, but `sound/pci/emu10k1/emupcm.c:127` assigns multichannel voices as `&emu->voices[epcm->voices[0]->number + i]` with no `% NUM_G` guard. When the allocator places the first voice near the end of the 64-entry array and more than one voice is requested, the addition exceeds array bounds, producing an out-of-bounds read and write that can corrupt adjacent kernel memory.

`CONFIG_SND_EMU10K1` is not set in the HS 5.19.6 configuration. The EMU10K1 driver — including the vulnerable `sound/pci/emu10k1/emupcm.c` channel allocator — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-48695

**Status**: Not exploitable
**Component**: mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

A use-after-free occurs during controller reset in the mpt3sas firmware event cleanup path. In `drivers/scsi/mpt3sas/mpt3sas_scsih.c`, the reset handler iterates queued firmware events and calls `cancel_work_sync()` on each. When `cancel_work_sync()` returns non-zero (the work was never executed), the handler calls `fw_event_work_put()` at line 3752 to release the work's reference — then unconditionally calls `fw_event_work_put()` again at line 3754. This double decrement underflows the `kref` reference count, freeing the `fw_event_work` object while other paths may still hold pointers to it.

`CONFIG_SCSI_MPT3SAS` is not set in the HS 5.19.6 configuration. The mpt3sas driver — including the vulnerable firmware event cleanup path — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-35789

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

When moving a station out of a VLAN and deleting the VLAN afterwards, the fast_rx entry still holds a pointer to the VLAN's netdev, which can cause use-after-free. In `net/mac80211/cfg.c`, the station change path at line 1949 calls `__ieee80211_check_fast_rx_iface(vlansdata)`, which builds a new `fast_rx` structure with `dev = vlansdata->dev` (the target VLAN's netdev). The original VLAN's fast_rx is cleared at line 1955 via `ieee80211_clear_fast_rx(sta)`, but that function uses RCU: the old `fast_rx` object — containing `dev = original_vlan->dev` — is not freed until after a grace period. If the original VLAN interface is deleted before that grace period expires, any CPU still reading the old fast_rx entry will dereference a freed netdev. The HS 5.19.6 kernel carries the unpatched station change path at `net/mac80211/cfg.c:1939–1970`.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-35886

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

**What this means for an attacker:**

syzkaller reported infinite recursive calls of `fib6_dump_done()` during netlink socket destruction. From the log, syzkaller sent an AF_UNSPEC RTM_GETROUTE message, and then closed the netlink socket. The IPv6 FIB dump handler at `net/ipv6/ip6_fib.c:652` hooks the callback destructor by setting `cb->done = fib6_dump_done` (saving the original callback in `cb->args[3]`). When the netlink socket closes, netlink core invokes the destructor, calling `fib6_dump_done()` at line 570. This function calls `cb->done(cb)` — but `cb->done` is now `fib6_dump_done` itself, creating infinite recursion that exhausts the kernel stack. The HS 5.19.6 kernel carries the unpatched FIB dump callback at `net/ipv6/ip6_fib.c:645–684`.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Triggering the infinite recursion requires sending an `AF_UNSPEC RTM_GETROUTE` netlink message and then closing the socket — reachable by any local user with a netlink socket. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-52835

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist
**Affected range**: pre-fix
**Upstream fix**: 6.8 series

When perf-record with a large AUX area, e.g. 4GB, it fails with: `#perf record -C 0 -m ,4G -e arm_spe_0// -- sleep 1 failed to mmap with 12 (Cannot allocate memory)`. The perf AUX area mmap handler in `kernel/events/core.c:6269–6345` calculates memory accounting limits and calls `rb_alloc_aux()` to allocate the backing pages. For very large AUX areas (gigabytes), the accounting arithmetic at line 6285 (`user_locked += user_extra`) can underflow or produce incorrect values when `user_extra` is extremely large (e.g., 1M pages for 4GB). The mmap() still succeeds despite the accounting failure, allowing unprivileged users to bypass RLIMIT_MEMLOCK restrictions and exhaust kernel memory. The HS 5.19.6 kernel carries the unpatched AUX area accounting at `kernel/events/core.c:6269–6345`.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-52868

**Status**: Not exploitable
**Component**: thermal management (`CONFIG_THERMAL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — thermal sysfs not accessible in HS allowlist; Lockdown blocks the trigger
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

The `dev->id` value comes from `ida_alloc()`, so it is a number between zero and INT_MAX. In `drivers/thermal/thermal_core.c`, this ID is formatted into fixed-size `THERMAL_NAME_LENGTH` (20-byte) buffers using `sprintf()`. At line 681, `sprintf(dev->attr_name, "cdev%d_trip_point", dev->id)` produces a string of the form `"cdev<N>_trip_point"`. For large IDs, the full string exceeds 20 bytes: `"cdev2147483647_trip_point"` is 25 characters plus a null terminator (26 bytes total), overflowing `attr_name` by 6 bytes. The same overflow applies at line 690 for `sprintf(dev->weight_attr_name, "cdev%d_weight", dev->id)`, which produces up to 22 bytes into a 20-byte buffer. Both overflows corrupt adjacent kernel heap memory and can be leveraged for privilege escalation.

`CONFIG_THERMAL=y` is compiled in and 5.19.6 falls within the affected range. Thermal management is present on all x86 servers for CPU temperature control. Triggering the overflow requires registering a thermal cooling device with a sufficiently large ID — this path requires access to the thermal sysfs interface, which is not included in the HS allowlist. On a HeartSuite Core Secure system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the thermal registration interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-36916

**Status**: Not exploitable
**Component**: block I/O cost controller (`CONFIG_BLK_CGROUP_IOCOST`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — iocost cgroup paths not in HS allowlist; Lockdown blocks the trigger
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

UBSAN catches undefined behavior in blk-iocost, where sometimes `iocg->delay` is shifted right by a number that is too large, resulting in undefined behavior on some architectures. Two sites in `block/blk-iocost.c` are affected: line 1338 computes `iocg->delay >> div64_u64(tdelta, USEC_PER_SEC)`, where the divisor is elapsed time in seconds — if the delay has been active for 64 or more seconds, the shift amount reaches or exceeds 64, which is undefined behavior for a 64-bit type under the C standard. Line 2112 performs `iocg->delay >> nr_cycles`, where `nr_cycles` can similarly exceed 63. On x86 the shift wraps, but on other architectures the result is indeterminate. Incorrect delay values can bypass I/O throttling controls or cause the cgroup I/O cost model to make scheduling decisions based on garbage data.

`CONFIG_BLK_CGROUP_IOCOST=y` is compiled in and 5.19.6 falls within the affected range. The blk-iocost controller is active whenever cgroups are in use with I/O cost weighting enabled. Configuring iocost requires writing to cgroup control files under `/sys/fs/cgroup/` — no cgroup management tool that exposes iocost configuration appears in the HS allowlist. On a HeartSuite Core Secure system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the iocost configuration path. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-38560

**Status**: Not exploitable
**Component**: Brocade bfa SCSI driver (`CONFIG_SCSI_BFA`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

Currently, we allocate a `nbytes`-sized kernel buffer and copy `nbytes` from userspace to that buffer. In `drivers/scsi/bfa/bfad_bsg.c`, the BSG passthrough handler at line 3373 allocates `kzalloc(bsg_data->payload_len, GFP_KERNEL)` where `payload_len` comes directly from the user-supplied BSG request structure, with no upper-bound validation. Line 3379 then calls `copy_from_user(..., bsg_data->payload_len)` using the same unchecked value. An attacker with access to the BSG device node can supply an oversized `payload_len` to exhaust kernel memory or, with a carefully chosen value, produce a heap overflow.

`CONFIG_SCSI_BFA` is not set in the HS 5.19.6 configuration. The Brocade bfa Fibre Channel HBA driver — including the vulnerable `bfad_bsg.c` BSG handler — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-38588

**Status**: Not exploitable
**Component**: kprobes (`CONFIG_KPROBES`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — kprobe registration not in HS allowlist; Lockdown blocks the exploitation trigger
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `kernel/trace/ftrace.c`, `ftrace_location()` at line 1577 calls `lookup_rec(ip, ip)` at line 1583 to obtain a `dyn_ftrace *rec` pointer without holding `ftrace_lock`. On a concurrent path, module unloading frees the pages that back ftrace records for module functions. If a module is removed between the `lookup_rec()` return and the `return rec->ip` dereference at line 1594, the pointer references freed memory. The race is reached through the kprobe registration path: `check_kprobe_address_safe()` → `check_ftrace_location()` → `ftrace_location()` — all called without the lock that serialises ftrace record lifetime.

`CONFIG_KPROBES=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` to register a kprobe — the attack path runs through `check_kprobe_address_safe()` → `check_ftrace_location()` → `ftrace_location()`. No HeartSuite Core Secure HeartSuite Core Secure deployment permits any service to register kprobes. Without an allowlist entry covering the kprobes interface, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-40901

**Status**: Not exploitable
**Component**: LSI/Avago mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/scsi/mpt3sas/mpt3sas_scsih.c`, the `pd_handles` bitmap is allocated as `(ioc->facts.MaxDevHandle / 8)` bytes (rounded up) via `kzalloc()` at `mpt3sas_base.c:8312`. The `test_bit()` function accesses bitmaps in `unsigned long`-sized units (8 bytes on 64-bit kernels). When the allocation is smaller than `sizeof(unsigned long)` — for example a single byte when `MaxDevHandle` is 8 — calls such as `test_bit(sas_device->handle, ioc->pd_handles)` at line 1942 and `test_bit(handle, ioc->pd_handles)` at line 4106 read 7 bytes beyond the heap allocation, producing a slab out-of-bounds read.

`CONFIG_SCSI_MPT3SAS` is not set in the HS 5.19.6 configuration. The LSI/Avago mpt3sas SAS/SATA/NVMe HBA driver — including the vulnerable `mpt3sas_scsih.c` bitmap access paths — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-40978

**Status**: Not exploitable
**Component**: QLogic qedi iSCSI driver (`CONFIG_SCSI_QEDI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/scsi/qedi/qedi_debugfs.c`, `qedi_dbg_do_not_recover_cmd_read()` at line 128 calls `sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover)` where `buffer` is the `char __user *` argument passed directly from the debugfs file read handler. `sprintf()` writes to a kernel virtual address rather than staging data in a kernel buffer first; on a system with SMAP (Supervisor Mode Access Prevention) enabled, the kernel write to a userspace pointer faults immediately and panics the kernel. The correct fix is to stage into a kernel buffer and use `simple_read_from_buffer()` to copy to userspace.

`CONFIG_SCSI_QEDI` is not set in the HS 5.19.6 configuration. The QLogic qedi iSCSI HBA driver — including the vulnerable `qedi_dbg_do_not_recover_cmd_read()` debugfs handler — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-41092

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no Intel display GPU present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In the i915 GT reset path, `intel_gt_handle_error()` at `intel_reset.c:1309` calls `synchronize_srcu_expedited()` at line 1285 on `gt->reset.backoff_srcu` to drain concurrent SRCU readers before the GPU reset proceeds. The GuC engine failure worker (`reset_fail_worker_func` at `intel_guc_submission.c:4485`) queues via `queue_work()` at line 4545 and calls `intel_gt_handle_error()` asynchronously. A race between this deferred reset path and the hangcheck heartbeat — as reproduced by `igt@i915_selftest@live@hangcheck` on ADL-P (GuC submission) — can reach `reset_prepare_engine()` at `intel_reset.c:743` and the WW-mutex backoff context via `i915_gem_ww_ctx_backoff()` (`i915_gem_ww.c:42`) after the owning structure has already been freed, producing a use-after-free.

`CONFIG_DRM_I915=y` is compiled in and HS 5.19.6 falls within the affected range. No Intel integrated or discrete display GPU is present on a standard Debian 11 server deployment. Without display hardware the DRM device nodes are not created, the GPU submission paths are not initialised, and the GuC engine failure worker that triggers this race is never scheduled. The vulnerable code path cannot be reached.

On a HeartSuite system with this hardware installed, Lockdown's constraints would still apply after any escalation: `FS_IOC_SETFLAGS` returns EPERM (`kernel/ioctl.c:561–569`), every mount path returns EPERM (`kernel/namespace.c:4218, 4300, 4453`), and allowlist modification is blocked at `hs_sandbox_caching.c:1942`. Lockdown independently prevents any unauthorised program — including a backdoor dropped post-exploit — from executing regardless of file ownership or capability bits.

### CVE-2024-42136

**Status**: Not exploitable
**Component**: CD-ROM subsystem (`CONFIG_CDROM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — CD-ROM drive absent on server
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/cdrom/cdrom.c`, `cdrom_read_cd()` at line 2080 computes `cgc->buflen = blocksize * nblocks` and `cdrom_read_block()` at line 2104 computes `cgc->buflen = blksize * nblocks`. Both operands are `int` parameters, so the multiplication is evaluated as a signed 32-bit expression before being stored in the `unsigned int buflen` field of `struct packet_command`. When syzkaller passes a large `nblocks` value — for example, greater than 912,000 with the common `CD_FRAMESIZE_RAW = 2352` block size — the intermediate product exceeds `INT_MAX`, signed integer overflow occurs, and an incorrect (smaller) buffer length is stored in `cgc->buflen`.

`CONFIG_CDROM=y` is compiled in and HS 5.19.6 falls within the affected range. No optical drive is present on a standard Debian 11 server deployment. Without this hardware the CD-ROM device nodes are not created and the ioctl paths that call `cdrom_read_cd()` and `cdrom_read_block()` are never reached. The vulnerable code path cannot be triggered.

On a HeartSuite system with an optical drive installed, Lockdown's constraints would still apply after any escalation: `FS_IOC_SETFLAGS` returns EPERM (`kernel/ioctl.c:561–569`), every mount path returns EPERM (`kernel/namespace.c:4218, 4300, 4453`), and allowlist modification is blocked at `hs_sandbox_caching.c:1942`. Lockdown independently prevents any unauthorised program — including a backdoor dropped post-exploit — from executing regardless of file ownership or capability bits.

### CVE-2024-44985

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_finish_output2()` saves `idev = ip6_dst_idev(dst)` at line 63. At line 72, `skb_expand_head(skb, hh_len)` makes room for the link-layer header; when allocation fails, `skb_expand_head()` frees the original `skb` and returns NULL. The `idev` pointer saved before the call now references memory associated with the freed `skb`. At line 74, `IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS)` dereferences the stale `idev` — a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-44986

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_xmit()` saves `idev = ip6_dst_idev(dst)` at line 256. At line 271, `skb_expand_head(skb, head_room)` expands the buffer to accommodate the IPv6 header and IP options; when allocation fails, the original `skb` is freed and NULL is returned. The `idev` pointer is now stale. At line 273, `IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS)` dereferences freed memory — a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-44987

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_send_skb()` at line 1943 saves `rt = (struct rt6_info *)skb_dst(skb)` without holding `rcu_read_lock()`. At line 1946, `ip6_local_out()` transmits the packet and may consume the `skb`, releasing the associated route. If `ip6_local_out()` returns a non-zero error code, lines 1951–1952 dereference `rt->rt6i_idev` — but `rt` is an RCU-protected pointer and may be freed before the dereference. Holding `rcu_read_lock()` for the duration of the `rt` dereference is required.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-46673

**Status**: Not exploitable
**Component**: Adaptec aacraid SCSI driver (`CONFIG_SCSI_AACRAID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`aac_probe_one()` at `drivers/scsi/aacraid/linit.c:1577` calls the hardware-specific `init` function pointer from `aac_driver_ident`, which eventually calls `aac_init_adapter()` at `comminit.c:510`. On failure, `aac_init_adapter()` frees `dev->queues` internally at line 644 (on `aac_comm_init()` failure) or line 651 (on `aac_fib_setup()` failure) before returning NULL. The `aac_probe_one()` error path at `linit.c:1798` then calls `kfree(aac->queues)` a second time on the same pointer — a double-free.

`CONFIG_SCSI_AACRAID` is not set in the HS 5.19.6 configuration. The Adaptec aacraid RAID controller driver — including the vulnerable `aac_probe_one()` and `aac_init_adapter()` paths — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46746

**Status**: Not exploitable
**Component**: AMD Sensor Fusion Hub HID driver (`CONFIG_AMD_SFH_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/hid/amd-sfh-hid/amd_sfh_client.c`, the error cleanup path calls `devm_kfree(dev, cl_data->report_descr[i])` at lines 259 and 276 to free the HID report descriptor before `hid_destroy_device()` at line 178. The `amdtp_hid_parse()` callback at `amd_sfh_hid.c:32` accesses `cli_data->report_descr[hid_data->index]` during device initialisation or tear-down. If the descriptor is freed before `hid_destroy_device()` has completed its disconnect sequence — and the callback fires in that window — it dereferences freed memory.

`CONFIG_AMD_SFH_HID` is not set in the HS 5.19.6 configuration. The AMD Sensor Fusion Hub HID driver — including the vulnerable `amd_sfh_client.c` cleanup path and `amdtp_hid_parse()` callback — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46747

**Status**: Not exploitable
**Component**: Cougar HID driver (`CONFIG_HID_COUGAR`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`cougar_report_fixup()` at `drivers/hid/hid-cougar.c:109` reads `rdesc[2]`, `rdesc[3]`, `rdesc[115]`, and `rdesc[116]`, and conditionally writes to `rdesc[115]`–`rdesc[116]` at lines 113–114, without first checking that `*rsize >= 117`. If the Cougar 500k Gaming Keyboard presents a report descriptor shorter than 117 bytes, the fixed-offset accesses go beyond the descriptor buffer, producing an out-of-bounds memory read/write.

`CONFIG_HID_COUGAR` is not set in the HS 5.19.6 configuration. The Cougar HID driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46798

**Status**: Not exploitable
**Component**: ALSA rawmidi subsystem (`CONFIG_SND_RAWMIDI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_RAWMIDI` not compiled
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `sound/core/rawmidi.c`, `snd_rawmidi_drain_output()` at line 224 saves `runtime = substream->runtime` at line 228, then calls `wait_event_interruptible_timeout(runtime->sleep, ...)` at line 232, waiting up to 10 seconds for the output buffer to drain. If `close_substream()` runs concurrently and calls `snd_rawmidi_runtime_free(substream)` at line 528 — freeing `substream->runtime` — while the drain wait is still sleeping, the `runtime` pointer saved at line 228 becomes dangling. When the wait exits, accesses to `runtime->avail` and `runtime->buffer_size` at line 237 use freed memory.

`CONFIG_SND_RAWMIDI` is not compiled in the HS 5.19.6 configuration — no enabled driver selects it. The vulnerable `rawmidi.c` code path does not exist on this system.

### CVE-2024-46849

**Status**: Not exploitable
**Component**: Amlogic Meson ASoC driver (`CONFIG_SND_MESON_CARD_UTILS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `sound/soc/meson/axg-card.c`, `axg_card_add_loopback()` at line 107 saves `pad = &card->dai_link[*index]` — a pointer into the current `dai_link` array. At line 113, `meson_card_reallocate_links()` calls `krealloc()` on `card->dai_link`, potentially moving the array to a new address and freeing the original buffer. At lines 119 and 133, `pad->name` and `pad->cpus->of_node` are accessed through the now-dangling `pad` pointer. The fix moves the `pad` assignment to after the reallocation, where `card->dai_link` has been updated.

`CONFIG_SND_MESON_CARD_UTILS` is not compiled in the HS 5.19.6 configuration — the Amlogic Meson ASoC platform requires `ARCH_MESON` which is not set on x86. The vulnerable code path does not exist on this system.

### CVE-2024-47682

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — non-conformant VPD firmware absent; standard SAS/SATA drives conform to SCSI spec
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

If a device returns VPD page 0xb1 with a length of exactly 8 bytes (as QEMU v2.x does), `sd_read_block_characteristics()` proceeds past the guard at `drivers/scsi/sd.c:2921` (`vpd->len < 8`), then reads `vpd->data[8]` at line 2927. With `len == 8` the valid indices are 0–7; index 8 is one byte past the end of the buffer.

`CONFIG_SCSI=y` is compiled in and HS 5.19.6 falls within the affected range. The OOB read occurs during device enumeration when a SCSI disk returns VPD page 0xb1 with a length of exactly 8 bytes — behaviour documented in QEMU v2.x, not present on production SAS/SATA/NVMe drives. Standard enterprise storage conforms to the SCSI VPD specification and returns page 0xb1 with the correct length. On a HeartSuite Core Secure server deployment, no non-conformant storage device is present; the OOB read path in `sd_read_block_characteristics()` is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-47701

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

When ext4 searches an inlined directory, `ext4_find_inline_entry()` at `fs/ext4/inline.c:1709` calls `ext4_get_inline_xattr_pos()` to locate the extended-attribute portion of the inline data. At `inline.c:1077`, that function returns `IFIRST(header) + le16_to_cpu(entry->e_value_offs)` without validating that the offset stays within the inode body buffer. A crafted block device can supply an `e_value_offs` that pushes the resulting pointer out of bounds; that pointer is then passed directly to `ext4_search_dir()` at line 1712, causing an OOB memory access.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; inlined directory processing runs for any small directory during normal operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49852

**Status**: Not Affected — `CONFIG_SCSI_EFCT` not compiled
**Component**: Emulex EFC FC driver (`CONFIG_SCSI_EFCT`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_EFCT` not compiled in HS kernel

The kref_put() function will call nport->release if the refcount drops to zero. The nport->release release function is_efc_nport_free() which frees "nport"

`CONFIG_SCSI_EFCT` is not set in the HS 5.19.6 configuration. The Emulex EFC Fibre Channel target driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-49882

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_ext_try_to_merge_up()` at `fs/ext4/extents.c:1871`, `brelse(path[1].p_bh)` releases the depth-1 extent block buffer but leaves `path[1].p_bh` non-NULL. When the caller subsequently runs cleanup via `ext4_ext_drop_refs()`, it iterates the path and calls `brelse()` on every non-NULL `p_bh`, releasing the same buffer head a second time — a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent tree merge-up runs during any truncate or extent modification on a two-level extent tree. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49883

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_ext_insert_extent()` at `fs/ext4/extents.c:2094`, the call to `ext4_ext_create_new_leaf()` may internally call `ext4_ext_grow_indepth()`, which reallocates the `path` array via `kcalloc()`. After the call returns, the caller continues using the original `path` pointer — now stale — causing a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent insertion runs during any file write that extends or modifies the extent tree. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49884

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_split_extent_at()` at `fs/ext4/extents.c:3178`, the function saves the path pointer as `path = *ppath`. At line 3248 it calls `ext4_ext_insert_extent(handle, inode, ppath, ...)`, which may reallocate `*ppath`, freeing the memory that `path` still points to. Subsequent uses of `path` at lines 3281, 3282, 3301, and 3304 — in both the success and error-recovery branches — dereference the now-freed pointer, constituting a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent splitting is triggered during any write that bisects an existing extent. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49889

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

`ext4_find_extent()` at `fs/ext4/extents.c:874` takes an optional `**orig_path` argument allowing callers to reuse an existing path allocation. On two code paths it frees the old allocation: when the tree depth has grown beyond the cached maximum (lines 898–901, `kfree(path); *orig_path = NULL`) and on any I/O or corruption error (lines 953–957, same sequence). Callers that save a local `path = *ppath` copy before invoking a sub-function that internally calls `ext4_find_extent()` — such as `ext4_split_convert_extents()` — retain a pointer to the freed memory. Subsequent use of that stale pointer constitutes a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; any extent-modifying write that triggers a tree depth change or encounters a read error while holding a saved path pointer is a triggering condition. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49960

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ext4_fill_super()` (`fs/ext4/super.c`), `timer_setup(&sbi->s_err_report, ...)` runs at line 4995 and `INIT_WORK(&sbi->s_error_work, flush_stashed_error_work)` at line 4997. During the `failed_mount3:` error-unwind at line 5454, `flush_work(&sbi->s_error_work)` is called at line 5456 immediately before `del_timer_sync(&sbi->s_err_report)` at line 5457. The work callback `flush_stashed_error_work` can call `mod_timer` on `s_err_report`, arming the timer during the same unwind that is about to cancel it. When the code path passes through `failed_mount_wq:` (line 5439), `flush_work` runs a second time at line 5448 before falling through to `failed_mount3:`, doubling the exposure. Syzbot detected this as an ODEBUG (Object Debug) object-state inconsistency.

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable path runs during a failed mount — for example when `ext4_es_register_shrinker()` or journal loading fails partway through `ext4_fill_super()`. On a HeartSuite Core Secure system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the HS allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-49983

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ext4_ext_replay_update_ex()` at `fs/ext4/extents.c:5860`, line 5879 assigns `ppath = path`, making both local variables alias the same allocation. Line 5881 then calls `ext4_force_split_extent_at(NULL, inode, &ppath, start, 1)`, passing the address of `ppath`. Inside, `ext4_split_extent_at()` calls `ext4_ext_insert_extent()` which may invoke `ext4_ext_grow_indepth()` and reallocate `*ppath` via `kcalloc()`. When that happens, the outer `ppath` is updated to the new allocation and the original memory is freed — but `path` still holds the original (now stale) pointer. The `kfree(path)` call at line 5885 then frees already-freed memory, constituting a double-free/use-after-free. The bug is exercised during fast-commit journal replay.

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable path runs during fast-commit journal replay, triggered on mount after an unclean shutdown of a filesystem with the fast-commit feature enabled. On a HeartSuite Core Secure system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the HS allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-50007

**Status**: Not Affected
**Component**: ASIHPI soundcard driver (`CONFIG_SND_ASIHPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_ASIHPI` not compiled

The ASIHPI driver writes firmware-controlled index values into a static array without bounds-checking the index. `CONFIG_SND_ASIHPI` is not set in the HS 5.19.6 kernel configuration; the driver and this code path are absent from the compiled kernel image.

### CVE-2022-48951

**Status**: Not Affected
**Component**: ALSA SoC layer (`CONFIG_SND_SOC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_SOC` not compiled

`snd_soc_put_volsw_sx()` applies bounds checks only to the first channel, allowing out-of-bounds writes to the second. `CONFIG_SND_SOC` is not set in the HS 5.19.6 kernel configuration; the ALSA SoC layer and this function are absent from the compiled kernel image.

### CVE-2022-48956

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`ip6_fragment()` at `net/ipv6/ip6_output.c:831` handles IPv6 packet fragmentation. The function and its callees access RCU-protected routing and neighbor table entries; a prior commit added an assumption that all callers hold the RCU read lock at entry. For the IPv4-style fast path via `ip6_finish_output2()` this holds — `rcu_read_lock_bh()` is acquired at line 119. However the UDP egress path (`ip6_send_skb()` at line 1940 → `ip6_local_out()` → `ip6_output()` → `ip6_finish_output()` → `ip6_fragment()`) does not guarantee the lock is held before entry into the fragmentation code. Under concurrent route or neighbor table modification this produces a use-after-free. Syzbot confirmed the race.

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. IPv6 is active on any Debian 11 server that has IPv6 addresses configured; the UDP-over-IPv6 fragmentation path is reachable by any process with a UDP socket. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-49022

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ieee80211_get_rate_duration()` at `net/mac80211/airtime.c:455`, `airtime_mcs_groups[group].duration[idx]` is accessed where `group` is computed from bandwidth, stream count, and encoding mode via the `VHT_GROUP_IDX`/`HT_GROUP_IDX`/`HE_GROUP_IDX` macros. The stream-count bounds check at line 451 guards one dimension, but an invalid combination of bandwidth and stream count can produce a `group` index that exceeds the `airtime_mcs_groups` array bounds, triggering a UBSAN array-index-out-of-bounds read.

`CONFIG_MAC80211=y` is compiled in. No WiFi NIC is present on a Debian 11 server deployment; mac80211 creates no wireless interfaces without hardware and this code path is never reached. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or preserve access across a reboot.

### CVE-2022-49023

**Status**: Not exploitable
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `net/wireless/scan.c:338`, when merging per-STA profile elements in the multi-BSSID path, the code calls `memcmp(tmp_old + 2, tmp + 2, 5)` to compare the OUI (3 bytes) + type (1 byte) + subtype (1 byte) of a vendor element, without first checking that either IE has at least 5 bytes of data. A vendor element with fewer than 5 data bytes causes an out-of-bounds read beyond the element buffer.

`CONFIG_CFG80211=y` is compiled in. No WiFi NIC is present on a Debian 11 server deployment; cfg80211 creates no wireless interfaces without hardware and this code path is never reached. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or preserve access across a reboot.

### CVE-2024-50278

**Status**: Not Affected
**Component**: dm-cache (`CONFIG_DM_CACHE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_DM_CACHE` not compiled

If the cache device is expanded between initial load and first-time resume, the bitsets (`dirty_bitset`, `discard_bitset`) allocated in `dm-cache-target.c` are sized to the pre-expansion block count. On resume, cache-block indices derived from the new device size exceed the allocated bitset bounds, causing an out-of-bounds access. `CONFIG_DM_CACHE` is not set in the HS 5.19.6 kernel configuration; the dm-cache target and this code path are absent from the compiled kernel image.

### CVE-2024-50279

**Status**: Not Affected
**Component**: dm-cache (`CONFIG_DM_CACHE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_DM_CACHE` not compiled

When shrinking the fast (cache) device, dm-cache iterates the `dirty_bitset` to identify cache blocks that must be flushed before being dropped. An index error in the bitset iteration produces a bit index that exceeds the allocated bitset bounds, causing an out-of-bounds access. `CONFIG_DM_CACHE` is not set in the HS 5.19.6 kernel configuration; the dm-cache target and this code path are absent from the compiled kernel image.

### CVE-2024-53147

**Status**: Not exploitable
**Component**: FAT/exFAT filesystem (`CONFIG_FAT_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:H)
**Score on HeartSuite**: 0.0 — Lockdown blocks `mount()`; no adversary-controlled FAT filesystem reachable
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `fs/exfat/dir.c`, when iterating directory entries, the cluster-walk loop at line 105 calls `exfat_get_next_cluster(sb, &(clu.dir))` to follow the FAT chain. If a directory's size is at least one cluster (so `clu_offset > 0`) and `ei->start_clu` was set to `EXFAT_EOF_CLUSTER` (`0xFFFFFFFF`) due to filesystem corruption, `clu.dir` starts at `0xFFFFFFFF`. The call at line 106 then attempts a FAT table lookup at index `0xFFFFFFFF`, which is far outside the FAT table's `num_clusters` entries, causing an out-of-bounds read.

`CONFIG_FAT_FS=y` is compiled in and HS 5.19.6 falls within the affected range. exFAT is compiled in and is used for the EFI system partition; the vulnerable path is triggered by traversing a corrupted exFAT directory. The adversary must be able to present a crafted exFAT image — mounting an external device or network share requires `mount()`, which Lockdown blocks unconditionally. The EFI system partition is already mounted at boot time and its contents are controlled by the administrator; an external attacker cannot inject a malformed exFAT directory into the in-use ESP. On a HeartSuite Core Secure system in Lockdown, the kernel additionally blocks any process without an allowlist entry from executing, closing the exploitation path before it can reach the vulnerable directory traversal code.

### CVE-2024-53150

**Status**: Not Affected
**Component**: USB audio driver (`CONFIG_SND_USB_AUDIO`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_USB_AUDIO` not compiled

The USB-audio driver does not validate `bLength` of each descriptor when traversing clock descriptors, allowing a malformed USB device to cause an out-of-bounds read. `CONFIG_SND_USB_AUDIO` is not set in the HS 5.19.6 kernel configuration; the USB audio driver and this descriptor-traversal path are absent from the compiled kernel image.

### CVE-2024-53170

**Status**: Affected
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `blk_mq_exit_hctx()` at `block/blk-mq.c:3440`, the call to `blk_mq_clear_flush_rq_mapping()` (line 3441) is guarded by `if (blk_queue_init_done(q))`. During SCSI device probe, the queue is not yet fully initialized, so this condition is false and `blk_mq_clear_flush_rq_mapping()` is skipped. The function is responsible for atomically clearing the `flush_rq` pointer from every slot in `tags->rqs[]`. When skipped, `flush_rq` is subsequently freed but its pointer remains live in the `rqs[]` array. Any later iteration over `tags->rqs[]` — such as during a tag-set teardown or request lookup — dereferences the stale pointer, constituting a use-after-free.

`CONFIG_SCSI=y` is compiled in and HS 5.19.6 falls within the affected range. The SCSI subsystem underpins block storage on Debian 11 via libata; the vulnerable path is triggered during SCSI probe teardown when initialization does not complete successfully. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-53173

**Status**: Not exploitable
**Component**: NFS v4 client (`CONFIG_NFS_V4`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `mount()` blocked by Lockdown; no NFS v4 share reachable on HS deployments
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`nfs_release_seqid()` at `fs/nfs/nfs4state.c:1088` removes a seqid from the sequence wait-list and wakes the next waiter (`rpc_wake_up_queued_task()` at line 1102). When two threads open the same file concurrently and both abort before receiving a reply, two separate code paths each call `nfs_release_seqid()` on the same `nfs_seqid`: the prepare callback at `fs/nfs/nfs4proc.c:2462` (when `nfs4_setup_sequence()` returns non-zero) and the done/release callback at line 2061. The second call finds `seqid->list` already empty and returns without action, but by this point `nfs_free_seqid()` may have freed the seqid object. The task woken by the first release can dereference `seqid->sequence` through the `nfs_seqid` pointer it holds — now pointing to freed memory — constituting a use-after-free.

`CONFIG_NFS_V4=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable seqid use-after-free path is only reachable when an NFS v4 share is mounted. On a HeartSuite Core Secure system, Lockdown blocks `mount()` unconditionally — `do_mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`). No NFS v4 filesystem can be mounted by any process, so the vulnerable code path is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-53214

**Status**: Not Affected
**Component**: VFIO subsystem (`CONFIG_VFIO`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_VFIO` not compiled

In `drivers/vfio/pci/vfio_pci_config.c`, the VFIO PCI extended-capability enumeration loop at line 1638 hides capabilities with unknown length by rewriting the `next` pointer in the previous entry's header. When a capability should be hidden but occupies the first position in the extended-capability chain, the pointer fixup path has incorrect behaviour, allowing a misconfigured or malicious guest to reach memory it should not. `CONFIG_VFIO` is not set in the HS 5.19.6 kernel configuration; the VFIO subsystem and this PCI config-space virtualisation path are absent from the compiled kernel image.

### CVE-2024-53227

**Status**: Not Affected
**Component**: Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_BFA_FC` not compiled

In the Brocade bfa Fibre Channel adapter driver (`drivers/scsi/bfa/`), a use-after-free occurs during driver load: an internal object containing an embedded spinlock is freed while lockdep still holds a reference to that lock, producing a KASAN `slab-use-after-free` splat inside `__lock_acquire`. `CONFIG_SCSI_BFA_FC` is not set in the HS 5.19.6 kernel configuration; the Brocade bfa driver is absent from the compiled kernel image.

### CVE-2024-53239

**Status**: Not Affected
**Component**: 6fire USB audio driver (`CONFIG_SND_USB_6FIRE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_USB_6FIRE` not compiled

In the TerraTec AUREON 6fire USB audio driver (`sound/usb/6fire/chip.c`), `usb6fire_chip_disconnect()` calls `usb6fire_chip_abort()` at line 183 — which schedules a deferred `snd_card_free_when_closed()` and nulls `chip->card` — immediately followed by `usb6fire_chip_destroy()` at line 184, which frees the underlying sub-resources. When userspace still holds the card open, the deferred free races against the destroy path, producing a use-after-free. `CONFIG_SND_USB_6FIRE` is not set in the HS 5.19.6 kernel configuration; the driver is absent from the compiled kernel image.

### CVE-2024-56609

**Status**: Not Affected
**Component**: Realtek rtw88 WiFi driver (`CONFIG_RTW88`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_RTW88` not compiled

In the Realtek rtw88 802.11ac/ax wireless driver (`drivers/net/wireless/realtek/rtw88/tx.c`), `rtw_tx_report_purge_timer()` at line 160 calls `skb_queue_purge()` at line 172 to discard queued TX-report SKBs when the firmware fails to acknowledge them. Because `ieee80211_tx_status()` is never called for the discarded SKBs, mac80211 retains a reference to the associated station structure after it has been freed, producing a use-after-free during driver teardown. `CONFIG_RTW88` is not set in the HS 5.19.6 kernel configuration; the rtw88 driver family is absent from the compiled kernel image.

### CVE-2024-56631

**Status**: Not exploitable
**Component**: SCSI generic driver (`CONFIG_CHR_DEV_SG`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `/dev/sg*` access not in HS allowlist; Lockdown blocks the exploitation trigger
**Affected range**: Linux ≤ 6.12-rc7
**Upstream fix**: commit 4a9804207b58 ("scsi: sg: Fix UAF in sg_release()")

In the SCSI generic device driver (`drivers/scsi/sg.c`), `sg_release()` at line 382 acquires `sdp->open_rel_lock` at line 391, then calls `kref_put(&sfp->f_ref, sg_remove_sfp)` at line 393. If that `kref_put` drops the last reference, `sg_remove_sfp` is invoked, which can free the `Sg_device` structure that `sdp` points to — including its embedded mutex. The subsequent `mutex_unlock(&sdp->open_rel_lock)` at line 404 then operates on freed memory, producing a KASAN `slab-use-after-free` in `lock_release`.

`CONFIG_CHR_DEV_SG=y` is compiled in. Reaching `sg_release()` in the race window requires an active open of a `/dev/sg*` device node — SCSI generic pass-through that requires `CAP_SYS_RAWIO`. No HeartSuite Core Secure deployment includes raw SCSI access in the Lockdown allowlist. Without an allowlist entry, the kernel refuses any process attempting to open `/dev/sg*`. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-56663

**Status**: Not exploitable
**Component**: cfg80211 wireless stack (`CONFIG_CFG80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present

In `net/wireless/nl80211.c`, the netlink policy for `NL80211_ATTR_MLO_LINK_ID` at line 797 uses `NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS)` — where `IEEE80211_MLD_MAX_NUM_LINKS = 15` (`include/linux/ieee80211.h:4349`). Since the range check is inclusive, link ID 15 passes validation. Structures such as `cfg80211_bss` size their `links[]` array with 15 entries (valid indices 0–14); an attacker-supplied link ID of 15 indexes one element past the end of the array, producing an out-of-bounds access. `CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment; without WiFi hardware, no wireless interfaces are created and the MLO link ID path is never reachable.

### CVE-2024-57899

**Status**: Not Affected
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — 32-bit-specific vulnerability; HS kernel is x86_64

In the mac80211 wireless stack, a type-size mismatch between `unsigned long` (4 bytes on 32-bit) and `u64` (8 bytes) causes incorrect arithmetic or storage on 32-bit architectures. On x86_64, `sizeof(unsigned long) == sizeof(u64) == 8`; the size mismatch condition cannot arise. `CONFIG_X86_64=y` in the HS 5.19.6 configuration; additionally, no WiFi hardware is present on a server deployment.

### CVE-2025-21863

**Status**: Affected
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux ≤ 6.13-rc6
**Upstream fix**: commit 838154be1ea7 ("io_uring: sanitise sqe->opcode against speculations")

**What this means for an attacker:**

In `io_uring/io_uring.c`, `io_init_req()` reads `sqe->opcode` from userspace and checks it against `IORING_OP_LAST` at line 8385. Without a Spectre v1 barrier, the CPU's speculative execution engine can index into `io_op_defs[]` at line 8389 before the bounds-check branch resolves, enabling a microarchitectural side-channel read of kernel memory at speculative offsets. The upstream fix inserts `array_index_nospec(opcode, IORING_OP_LAST)` before the array access.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IO_URING=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable io_uring path requires a process to submit crafted SQEs via `io_uring_enter()`; this is a normal operation for any application using io_uring. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-52930

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no Intel display GPU present

In `drivers/gpu/drm/i915/gem/i915_gem_tiling.c`, `i915_gem_object_set_tiling()` releases the gem object lock at line 308, then performs an unguarded check-and-free of `obj->bit_17` at lines 314–322. Two threads concurrently calling `I915_GEM_SET_TILING` to set tiling to `I915_TILING_NONE` can both enter the `else` branch at line 319 and both call `bitmap_free(obj->bit_17)` at line 320, producing a double-free. Conversely, two threads setting a swizzled tiling mode can both pass the `!obj->bit_17` check at line 315 and both call `bitmap_zalloc`, leaking the first allocation. `CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment; DRM device nodes are not created and the GEM ioctl path is unreachable.

### CVE-2023-52988

**Status**: Not exploitable
**Component**: Intel HDA audio driver (`CONFIG_SND_HDA_INTEL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In `sound/pci/hda/patch_via.c`, `via_auto_init_analog_input()` calls `snd_hda_get_connections()` at line 820 and stores the return value in `nums`. The function can return a negative error code. The subsequent loop at line 822 (`for (i = 0; i < nums; i++)`) is a no-op for negative `nums`, but the `conn[nums++]` write at line 832 then indexes the `conn[]` array at a negative offset, producing an out-of-bounds write. `CONFIG_SND_HDA_INTEL=y` is compiled in. No audio hardware is present on a headless server deployment; HDA codec probing never runs and the vulnerable path is never reached.

### CVE-2025-21993

**Status**: Not Affected — `CONFIG_ISCSI_IBFT` not set
**Component**: iSCSI iBFT driver (`CONFIG_ISCSI_IBFT`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ISCSI_IBFT` not compiled in HS kernel

In the iSCSI Boot Firmware Table (iBFT) kernel driver, the subnet-mask field read from `/sys/firmware/ibft/ethernetX/subnet-mask` during an IPv6 iSCSI boot contains a memory safety issue. `CONFIG_ISCSI_IBFT` is not set in the HS 5.19.6 kernel configuration; the iBFT sysfs interface is absent from the compiled kernel image.

### CVE-2025-22083

**Status**: Not Affected
**Component**: vhost-SCSI driver (`CONFIG_VHOST_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_VHOST_SCSI` not compiled

In `drivers/vhost/scsi.c`, `vhost_scsi_set_endpoint()` at line 1531 does not guard against being called multiple times without an intervening `vhost_scsi_clear_endpoint()`. Duplicate invocations corrupt the `vs_tpg` pointer array and reference counts, triggering use-after-free and null-pointer conditions. `CONFIG_VHOST_SCSI` is not set in the HS 5.19.6 kernel configuration; the vhost-SCSI virtualisation driver is absent from the compiled kernel image.

### CVE-2025-22121

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux ≤ 6.13-rc3
**Upstream fix**: commit 34f96e89f84c ("ext4: fix UAF in ext4_xattr_inode_dec_ref_all()")

**What this means for an attacker:**

In `fs/ext4/xattr.c`, `ext4_xattr_inode_dec_ref_all()` at line 1127 iterates over xattr entries, calling `ext4_xattr_inode_iget()` at line 1148 to obtain each `ea_inode`. If `ext4_expand_inode_array()` at line 1154 fails, `iput(ea_inode)` at line 1158 frees the inode. When the journal restart function (`ext4_xattr_restart_fn`) subsequently runs, it can re-encounter the same entry and dereference the freed inode at line 1182 (`ext4_xattr_inode_dec_ref`), producing a use-after-free. The published vector is C:H/I:N/A:H — disclosure and crash, not direct privilege escalation.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Reaching the xattr teardown path requires a process to manipulate extended attributes on an ext4 filesystem — a standard operation available to any user with file access. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**The attacker cannot turn this UAF into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-37785

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; crafted ext4 image cannot be mounted
**Affected range**: Linux ≤ 6.14-rc4
**Upstream fix**: commit 4f45d4452e6b ("ext4: fix OOB read when mounting corrupted fs")

In `fs/ext4/dir.c`, when a corrupted ext4 directory block contains a `'.'` entry whose `rec_len` equals the filesystem block size, the iteration offset at line 246 jumps to exactly `block_size` after the first entry. During directory removal, a subsequent traversal computes a `de` pointer one block past the buffer boundary, producing an out-of-bounds read.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Triggering the out-of-bounds read requires mounting an ext4 filesystem image containing a corrupted directory block. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any ext4 directory parsing code is reached. In Lockdown, no approved program in the HS allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any HeartSuite Core Secure deployment.

### CVE-2025-40364

**Status**: Affected
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux ≤ 6.14-rc5
**Upstream fix**: commit 0f2122045b94 ("io_uring: don't import buffers for async preparation")

**What this means for an attacker:**

In `io_uring/io_uring.c`, `io_req_prep_async()` at line 7829 prepares an asynchronous copy of a request's state. For requests using provided buffers (`IOSQE_BUFFER_SELECT`), the function can select and consume a buffer slot during the async preparation phase. If the ring state is then discarded before the I/O completes — for example, when the async path is abandoned and the request is retried — the buffer slot is consumed but the reference is lost, allowing the slot to be selected again by a subsequent request and producing a use-after-free of the shared buffer metadata.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IO_URING=y` is compiled in and 5.19.6 falls within the affected range. Reaching the provided-buffer UAF path requires a process to submit io_uring SQEs with `IOSQE_BUFFER_SELECT` in a pattern where the async preparation phase selects a buffer slot before the request is discarded. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-37738

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; crafted xattr image cannot be mounted
**Affected range**: Linux ≤ 6.13-rc3
**Upstream fix**: commit b631e432b12d ("ext4: fix xattr inode dec ref boundary")

In `fs/ext4/xattr.c`, `ext4_xattr_inode_dec_ref_all()` at line 1143 iterates xattr entries with `for (entry = first; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry))`. The loop has no upper-boundary parameter: it relies solely on the `IS_LAST_ENTRY()` zero-terminator sentinel. A corrupted xattr block without a valid terminating entry causes the loop to walk past the end of the allocated buffer, reading and dereferencing arbitrary memory.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Triggering the unbounded xattr loop requires mounting a filesystem with a corrupted xattr block that lacks the valid zero-terminator sentinel. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any ext4 xattr parsing code is reached. In Lockdown, no approved program in the HS allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any HeartSuite Core Secure deployment.

### CVE-2022-49789

**Status**: Not Affected
**Component**: IBM Z Fibre Channel driver (`CONFIG_ZFCP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ZFCP` not compiled

In `drivers/s390/scsi/zfcp_fsf.c`, `zfcp_fsf_req_send()` stores the FSF request ID in a variable of the wrong integer type, causing the ID to be truncated on architectures where the required width exceeds that type. `CONFIG_ZFCP` is not present in the HS 5.19.6 kernel configuration; the IBM Z Fibre Channel driver is s390-architecture-specific and is absent from the x86_64 compiled kernel image.

### CVE-2022-49842

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In the ALSA sound subsystem, a use-after-free occurs in `device_del()` during driver module removal. When an ALSA driver is unloaded, a device object is freed while still referenced by a concurrent access path, producing a KASAN use-after-free report at `device_del+0xb5b` by the `rmmod` task.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-49865

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux 5.4–5.19.6
**Upstream fix**: kernel.org stable queue (net/ipv6/addrlabel.c)

**What this means for an attacker:**

In `net/ipv6/addrlabel.c`, `ip6addrlbl_putmsg()` (line 438) constructs a `struct ifaddrlblmsg` for a netlink reply. The function writes `ifal_family`, `ifal_prefixlen`, `ifal_flags`, and `ifal_seq` but never zeroes the `__ifal_reserved` padding byte. That uninitialised byte is subsequently copied to userspace via `nlmsg_unicast()`, leaking one byte of kernel stack memory per IPv6 address-label query.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Any process with access to a `NETLINK_ROUTE` socket can trigger the infoleak — no elevated privilege is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**The attacker cannot turn this leak into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53037

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in HS kernel

When the SAS Transport Layer support is enabled and a device exposed to the OS by the driver fails INQUIRY commands, the mpi3mr driver frees the memory allocated for an internal device handle but continues to reference that handle in subsequent SCSI transport operations, causing a use-after-free.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53039

**Status**: Not Affected
**Component**: Intel ISH HID driver (`CONFIG_INTEL_ISH_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_INTEL_ISH_HID` not compiled

When a reset notify IPC message is received by the Intel Integrated Sensor Hub Transfer Protocol (ISHTP) subsystem, the ISR schedules a work item and passes the device struct via the global `ishtp_dev` pointer. A race between the reset notify path and device teardown can leave `ishtp_dev` pointing to a freed object, triggering a use-after-free.

`CONFIG_INTEL_ISH_HID` is not set in the HS 5.19.6 configuration. The Intel ISH HID driver (`drivers/hid/intel-ish-hid/`) is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53065

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist

In `kernel/events/core.c`, a stack-out-of-bounds issue discovered by syzkaller occurs in the perf events sample output path. A crafted `perf_event_open()` call with specific sample type flags causes the kernel to write beyond the bounds of a stack-allocated buffer during event sampling, overwriting adjacent stack memory.

`CONFIG_PERF_EVENTS=y` is compiled in. The HS kernel sets `/proc/sys/kernel/perf_event_paranoid=3`, which restricts `perf_event_open()` to processes with `CAP_PERFMON`. No profiling tool (`perf`, `sysdig`, or equivalent) is included in the HS Lockdown allowlist — the kernel refuses to execute it. The crafted `perf_event_open()` call required to trigger the stack overflow is unreachable in a standard HS deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-37861

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in HS kernel

When the task management thread processes reply queues while the reset thread simultaneously resets them, the task management thread accesses an invalid queue ID (`0xFFFF`) — a sentinel value indicating a torn-down queue — resulting in an out-of-bounds access during the concurrent reset operation.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-37979

**Status**: Not Affected — `CONFIG_SND_SOC_SC7280` not compiled
**Component**: Qualcomm sc7280 ASoC driver (`CONFIG_SND_SOC_SC7280`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SND_SOC_SC7280` not compiled in HS kernel

Commit 5f78e1fb7a3e ("ASoC: qcom: Add driver support for audioreach solution") introduced switch-case values in the Qualcomm sc7280 machine driver that index into fixed-size arrays without bounds checking, causing out-of-bounds access when unexpected codec or CPU DAI link types are encountered during probe.

`CONFIG_SND_SOC_SC7280` is not set in the HS 5.19.6 configuration. This driver targets the Qualcomm sc7280 SoC, an ARM-based mobile/embedded platform. It is not selected on x86_64 server builds. The vulnerable code path does not exist on this system.

### CVE-2022-49934

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present

In `net/mac80211/scan.c`, `ieee80211_scan_rx()` accesses `scan_req->flags` after a null check. A use-after-free occurs when scan completion triggers `__ieee80211_scan_completed()`, which frees the scan request while a concurrent `ieee80211_scan_rx()` call still dereferences it.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38103

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no USB HID input devices on headless server

Update struct hid_descriptor to better reflect the mandatory and optional parts of the HID Descriptor as per USB HID 1.11 specification.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38206

**Status**: Not Affected — `CONFIG_EXFAT_FS` not compiled
**Component**: exFAT filesystem (`CONFIG_EXFAT_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_EXFAT_FS` not compiled in HS kernel

In `fs/exfat/nls.c`, `exfat_load_upcase_table()` frees `sbi->vol_utbl` via `exfat_free_upcase_table()` on a checksum-mismatch error (line 706) without NULLing the pointer. If the subsequent `exfat_load_default_upcase_table()` call fails to allocate a replacement buffer, `sbi->vol_utbl` retains the stale freed pointer. A later cleanup path calling `exfat_free_upcase_table()` again frees the same allocation, causing a double free. The trigger is mounting a specially crafted exFAT volume.

`CONFIG_EXFAT_FS` is not set in the HS 5.19.6 configuration. The exFAT filesystem driver — including `fs/exfat/nls.c` — is not compiled into the kernel image. Note that `CONFIG_FAT_FS=y` (VFAT/FAT32) is compiled for EFI system partition support, but that is a separate driver with no shared code. The vulnerable code path does not exist on this system.

### CVE-2025-38239

**Status**: Not Affected — `CONFIG_MEGARAID_SAS` not set
**Component**: LSI MegaRAID SAS driver (`CONFIG_MEGARAID_SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_MEGARAID_SAS` not compiled in HS kernel

On systems with DRAM interleave enabled, the MegaRAID SAS driver miscalculates the MSI-X poll queue allocation, requesting poll queues beyond the number of available vectors. This results in an out-of-bounds access during driver initialization when the hardware exposes a specific MSI-X configuration.

`CONFIG_MEGARAID_SAS` is not set in the HS 5.19.6 configuration. The LSI/Broadcom MegaRAID SAS controller driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-38249

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In snd_usb_get_audioformat_uac3(), the length value returned from snd_usb_ctl_msg() is used directly for memory allocation without validation.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38389

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no Intel display GPU present

On ring submission GPU platforms, unbinding the i915 driver during testing sporadically triggers a kernel warning. A GPU context or ring buffer entry is accessed after being freed during the driver teardown path, detected by the kernel's warning infrastructure during CI unbind tests.

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes may not be created and the GPU context entry points are unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38494

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no USB HID input devices on headless server

hid_hw_raw_request() is actually useful to ensure the provided buffer and length are valid.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38550

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/mcast.c

**What this means for an attacker:**

In `net/ipv6/mcast.c`, `mld_clear_delrec()` releases the `pmc->idev` reference before calling `ip6_mc_clear_src()`, but `ip6_mc_clear_src()` accesses `pmc->idev` internally. The reference drop must be deferred until after `ip6_mc_clear_src()` returns; releasing it early causes a use-after-free when `ip6_mc_clear_src()` subsequently dereferences the freed pointer.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and the IPv6 stack is active on configured interfaces. IPv6 multicast listener discovery (MLD) is reachable via network interfaces that join multicast groups — a common configuration on servers. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-38556

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no USB HID input devices on headless server

Testing by the syzbot fuzzer showed that the HID core gets a shift-out-of-bounds exception when it tries to convert a 32-bit quantity to a 0-bit quantity.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38563

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist

The perf mmap code is careful about mmap()'ing the user page with the ringbuffer and additionally the auxiliary buffer, when the event supports it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-38565

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist

When perf_mmap() fails to allocate a buffer, it still invokes the event_mapped() callback of the related event.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-38572

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/

**What this means for an attacker:**

syzbot demonstrated that a crafted IPv6 packet with excessively long chained extension headers causes `skb->transport_header` to overflow. The field is a `__u16`; when the cumulative extension header length wraps past 65535, the kernel misidentifies the transport layer offset when parsing subsequent headers, potentially accessing incorrect memory.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and the IPv6 stack processes all inbound IPv6 packets, including those with extension headers. This path is reachable from the network without requiring a local process. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to escalate further — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-38699

**Status**: Not Affected — `CONFIG_SCSI_BFA_FC` not compiled
**Component**: Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_BFA_FC` not compiled in HS kernel

When the bfad_im_probe() function fails during initialization, the memory pointed to by bfad->im is freed without setting bfad->im to NULL.

`CONFIG_SCSI_BFA_FC` is not set in the HS 5.19.6 configuration. The Brocade bfa Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-38729

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

UAC3 power domain descriptors need to be verified with its variable bLength for avoiding the unexpected OOB accesses by malicious firmware, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39702

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/

**What this means for an attacker:**

In `net/ipv6/`, a Message Authentication Code comparison used a variable-time function rather than a constant-time one (such as `crypto_memneq()`). An attacker who can observe response timing can iteratively determine whether partial MAC bytes are correct, eventually recovering a valid MAC and bypassing authentication in IPv6 protocol handling.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Exploiting a timing side-channel requires high network precision and repeated measurements (AC:H), which significantly reduces practical exploitability. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to follow up on a bypassed MAC check — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-39757

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

UAC3 class segment descriptors need to be verified whether their sizes match with the declared lengths and whether they fit with the allocated buffer sizes, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39760

**Status**: Not exploitable
**Component**: USB core (`CONFIG_USB`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no USB device on headless HS server; descriptor parsing path unreachable

usb_parse_ss_endpoint_companion() checks descriptor type before length, enabling a potentially odd read outside of the buffer size.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. The `usb_parse_ss_endpoint_companion()` descriptor parsing path is triggered during USB device enumeration when a device is connected. HeartSuite Core Secure runs on headless server hardware with no external USB devices; no USB device enumeration occurs, so the vulnerable descriptor parsing code path is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-39788

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — UFS flash storage absent on x86 server

On Google gs101, the number of UTP transfer request slots (nutrs) is 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE incorrectly as 0.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is used in mobile and embedded platforms. This bug is in the Samsung Exynos UFS variant (`ufs-exynos`). A Debian 11 x86 server has no UFS hardware; the driver is never active.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50306

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM

**Affected range**: Linux 5.10+; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/fast_commit.c

In `fs/ext4/fast_commit.c`, the fast commit replay scan loop reads the tag-length header (`struct ext4_fc_tl`, 4 bytes) before verifying that at least 4 bytes remain in the replay buffer. Mounting a filesystem whose fast commit area has been truncated or crafted to place fewer than 4 bytes at the tail causes an out-of-bounds read when parsing the next tag.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. The vulnerable path runs during the fast commit replay scan triggered on mount of a filesystem whose fast commit area has a malformed tag-length header. On a HeartSuite Core Secure system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the HS allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-53257

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present

Before checking the action code, check that it even exists in the frame.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53282

**Status**: Not Affected — `CONFIG_SCSI_LPFC` not compiled
**Component**: Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_LPFC` not compiled in HS kernel

In `drivers/scsi/lpfc/`, `lpfc_wr_object()` performs a use-after-free read during the sysfs firmware write process. KFENCE detects that a firmware object buffer is read after being freed during the firmware update write sequence.

`CONFIG_SCSI_LPFC` is not set in the HS 5.19.6 configuration. The Emulex lpfc Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53285

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — direct block device write requires CAP_SYS_RAWIO; no raw-device write tool in HS allowlist

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/inode.c

ext4 validates `i_extra_isize` when an inode is first loaded into memory (`fs/ext4/inode.c:4794`), confirming that the extra space falls within the inode's allocated size. If an attacker writes directly to the block device while the filesystem is mounted, the raw on-disk inode can be modified so that `i_extra_isize` exceeds the previously verified bound. Subsequent access to in-inode extended attributes computes the xattr magic pointer as `EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize` without re-validating the updated value, allowing a read or write beyond the end of the inode body.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Exploiting this bug requires writing directly to the block device while the filesystem is mounted — an operation that requires root or `CAP_SYS_RAWIO` and a tool that issues raw writes to the block device (e.g., `dd`, `badblocks`, or a custom exploit program). On a HeartSuite Core Secure system, no approved process in the HS allowlist writes raw block device data; the SPF allowlist blocks execution of any unapproved program at the kernel gate before the block device can be reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-53320

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in HS kernel

In the mpi3mr driver, `mpi3mr_get_all_tgt_info()` has multiple issues in its device map handling: the function miscalculates the valid entry length in `alltgt_info` by incorrectly sizing the `struct mpi3mr_device_map_info` header, leading to out-of-bounds reads when iterating target device entries.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53321

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present

In `net/mac80211/`, control frames such as ACK frames that legally omit Address 2 and Address 3 are forwarded through `wmediumd` or similar userspace interfaces. The mac80211 frame parser does not enforce the full 3-address format before forwarding, potentially causing out-of-bounds reads in userspace frame consumers that assume the standard frame layout.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53322

**Status**: Not Affected — `CONFIG_SCSI_QLA_FC` not compiled
**Component**: QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_QLA_FC` not compiled in HS kernel

System crash due to use after free. Current code allows terminate_rport_io to exit before making sure all IOs has returned.

`CONFIG_SCSI_QLA_FC` is not set in the HS 5.19.6 configuration. The QLogic qla2xxx Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50378

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Amlogic Meson ARM SoC GPU absent

In `drivers/gpu/drm/meson/`, unloading the Amlogic Meson display driver triggers a KASAN use-after-free. During driver teardown, a resource allocated during probe is accessed after the teardown path has freed it, producing a KASAN warning at module unload time.

`CONFIG_DRM=y` is compiled in. drm/meson is the display driver for Amlogic Meson SoC platforms (ARM-based embedded boards such as ODROID, Khadas, etc.). This driver and its hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53376

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in HS kernel

To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using byte as unit.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53392

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no USB HID input devices on headless server

In the Intel ISHTP HID driver, during a warm reset `device->fw_client` is set to NULL. If a bus driver is registered after this NULL assignment but before ISHTP completes re-enumeration of firmware clients, the driver dereferences the NULL `fw_client` pointer, triggering a kernel panic.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39841

**Status**: Not Affected — `CONFIG_SCSI_LPFC` not compiled
**Component**: Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_LPFC` not compiled in HS kernel

Fix a use-after-free window by correcting the buffer release sequence in the deferred receive path.

`CONFIG_SCSI_LPFC` is not set in the HS 5.19.6 configuration. The Emulex lpfc Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-39864

**Status**: Not exploitable
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no WiFi NIC present

In `net/wireless/scan.c`, `cfg80211_update_known_bss()` frees the last beacon frame of a BSS entry under conditions related to hidden SSID tracking (commit 776b3580178f). A race condition allows this beacon frame to be freed while still referenced by another code path, causing a use-after-free.

`CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment. cfg80211 manages wireless interfaces; without hardware, no interface is created and the affected code paths are unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39866

**Status**: Affected
**Component**: VFS writeback subsystem
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/fs-writeback.c

**What this means for an attacker:**

In `fs/fs-writeback.c`, `__mark_inode_dirty()` acquires a reference to a `bdi_writeback` structure. A concurrent `bdi_writeback_switch()` can free the structure before the reference is dropped, resulting in a use-after-free when the writeback pointer is subsequently accessed.

**Why HeartSuite does not reduce this to 0.0:**

`fs/fs-writeback.c` is always compiled in on a system with block device support. The writeback subsystem is active for all block I/O on any mounted filesystem. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-50422

**Status**: Not Affected — `CONFIG_SCSI_SAS_LIBSAS` not set
**Component**: SAS libsas library (`CONFIG_SCSI_SAS_LIBSAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_SAS_LIBSAS` not compiled in HS kernel

When executing SMP task failed, the smp_execute_task_sg() calls del_timer() to delete "slow_task->timer".

`CONFIG_SCSI_SAS_LIBSAS` is not set in the HS 5.19.6 configuration. The SAS libsas library — used by SAS host bus adapter drivers — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50432

**Status**: Affected
**Component**: kernfs subsystem (`CONFIG_KERNFS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/kernfs/dir.c

**What this means for an attacker:**

Syzkaller triggered concurrent calls to `kernfs_remove_by_name_ns()` for the same kernfs node, resulting in a KASAN-detected use-after-free in `fs/kernfs/dir.c`. The race occurs because `kernfs_remove_by_name_ns()` does not prevent concurrent removals of the same node from two threads.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_KERNFS=y` is compiled in and 5.19.6 falls within the affected range. kernfs underpins sysfs and is active on every running Linux system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53473

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/hash.c

**What this means for an attacker:**

In `fs/ext4/hash.c`, `__ext4fs_dirhash()` returns `-1` in two cases: when a directory uses the `DX_HASH_SIPHASH` algorithm but the inode lacks an encryption key (line 271: "Siphash requires key"), and on an unknown hash version (line 280). Callers of `ext4fs_dirhash()` did not consistently check for this error and proceeded with a stale or zero `hinfo->hash`, potentially corrupting hash-tree directory lookups or writes.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server and directory lookups occur during normal operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53510

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — UFS flash storage absent on x86 server

ufshcd_queuecommand() may be called two times in a row for a SCSI command before it is completed.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is mobile/embedded storage. The `ufshcd` core driver is compiled in but never instantiated on an x86 server; no UFS host controller hardware is present.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53521

**Status**: Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set
**Component**: SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ENCLOSURE_SERVICES` not compiled in HS kernel

In `drivers/scsi/ses.c`, `ses_intf_remove()` performs an out-of-bounds slab read when removing a SCSI Enclosure Services device. At `ses_intf_remove+0x23f`, a buffer access reads beyond its allocated boundary, as reported by KASAN during module removal by the `rmmod` task.

`CONFIG_ENCLOSURE_SERVICES` is not set in the HS 5.19.6 configuration. The SCSI Enclosure Services driver (ses) — and its dependence on SAS HBA infrastructure — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50488

**Status**: Not Affected
**Component**: BFQ I/O scheduler (`CONFIG_IOSCHED_BFQ`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_IOSCHED_BFQ` not compiled in HS kernel

In `block/bfq-iosched.c`, a use-after-free occurs in `bfq_select_queue()` involving `bfqq->bic`. A BFQ I/O queue object is freed while a reference to its `bic` (BFQ I/O context) is still live, leading to a use-after-free when `bfq_select_queue()` subsequently accesses the freed `bfqq` pointer.

`CONFIG_IOSCHED_BFQ` is not set in the HS 5.19.6 configuration. The BFQ (Budget Fair Queueing) block I/O scheduler is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50496

**Status**: Affected
**Component**: device mapper (`CONFIG_BLK_DEV_DM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/md/dm-cache-target.c

**What this means for an attacker:**

In `drivers/md/dm-cache-target.c`, `cache_resume()` (line 2971) calls `allow_background_work()`, which schedules work on `cache->wq`. If `cache_dtr()` runs concurrently, `destroy()` (line 1881) frees `cache->wq` at line 1891 while those work items are still active, resulting in a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_BLK_DEV_DM=y` is compiled in and device mapper is used for LVM on a standard Debian 11 installation. Triggering this race requires concurrent resume and destroy operations on a device mapper target. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to set up this race — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-50546

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/inode.c

**What this means for an attacker:**

In `ext4_evict_inode()` (`fs/ext4/inode.c:180`), the function checks `EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL` to determine whether the inode being evicted is an extended attribute inode. Under certain error paths during inode allocation, the ext4-specific `i_flags` field in `ext4_inode_info` is not fully initialized before the inode reaches eviction, causing the flag test to read from uninitialized memory. KMSAN reported the uninitialized-value access at this check.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server and inode eviction occurs during normal filesystem operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53640

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In the ALSA sound subsystem, `regcache_flat_read()` performs a slab-out-of-bounds read. syzkaller reproduced a KASAN report showing an out-of-bounds read in the flat register cache read path, triggered through the ALSA register map interface.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53675

**Status**: Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set
**Component**: SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ENCLOSURE_SERVICES` not compiled in HS kernel

Sanitize possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process().

`CONFIG_ENCLOSURE_SERVICES` is not set in the HS 5.19.6 configuration. The SCSI Enclosure Services driver (ses) is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53676

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in HS kernel

In `drivers/target/iscsi/`, `lio_target_nacl_info_show()` uses `sprintf()` in a loop to print details for every iSCSI connection in a session without checking that the output buffer has sufficient remaining space, leading to a buffer overflow when a session contains many connections.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-71075

**Status**: Not Affected — `CONFIG_SCSI_AIC94XX` not set
**Component**: Adaptec aic94xx SAS driver (`CONFIG_SCSI_AIC94XX`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_AIC94XX` not compiled in HS kernel

The asd_pci_remove() function fails to synchronize with pending tasklets before freeing the asd_ha structure, leading to a potential use-after-free vulnerability.

`CONFIG_SCSI_AIC94XX` is not set in the HS 5.19.6 configuration. The Adaptec aic94xx SAS HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23076

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In the ALSA ctxfi audio driver's mixer handling code, the `conf` field is used as a loop index and referenced in the index callbacks `amixer_index()` and `sum_index()`. Without a bounds check on `conf`, these callbacks can access mixer entries outside the allocated range, leading to an out-of-bounds read.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23078

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

The scarlett2_usb_get_config() function has a logic error in the endianness conversion code that can cause buffer overflows when count > 1.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23089

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

When snd_usb_create_mixer() fails, snd_usb_mixer_free() frees mixer->id_elems but the controls already added to the card still reference the freed memory.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23191

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

The PCM trigger callback of aloop driver tries to check the PCM state and stop the stream of the tied substream in the corresponding cable.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23193

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 8.8 HIGH (AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in HS kernel

In iscsit_dec_session_usage_count(), the function calls complete() while holding the sess->session_usage_lock.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23208

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In this case, the user constructed the parameters with maxpacksize 40 for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23216

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in HS kernel

In iscsit_dec_conn_usage_count(), the function calls complete() while holding the conn->conn_usage_lock.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-71238

**Status**: Not Affected — `CONFIG_SCSI_QLA_FC` not compiled
**Component**: QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_SCSI_QLA_FC` not compiled in HS kernel

In `drivers/scsi/qla2xxx/`, the QLogic Fibre Channel HBA driver writes to an invalid kernel address during a specific error recovery path, triggering a page fault with a supervisor write access error. The invalid address indicates a use-after-free or uninitialized pointer dereference within the driver's interrupt or completion handling.

`CONFIG_SCSI_QLA_FC` is not set in the HS 5.19.6 configuration. The QLogic qla2xxx Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23318

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

The entry of the validators table for UAC3 AC header descriptor is defined with the wrong protocol version UAC_VERSION_2, while it should have been UAC_VERSION_3.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-31581

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

In usb6fire_chip_abort(), the chip struct is allocated as the card's private data (via snd_card_new with sizeof(struct sfire_chip)).

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-3268

**Status**: Not exploitable
**Component**: relay filesystem (`CONFIG_RELAY`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — debugfs relay access not in HS allowlist; Lockdown blocks the exploitation trigger

An out of bounds (OOB) memory access flaw was found in the Linux kernel in relay_file_read_start_pos in kernel/relay.c in the relayfs.

`CONFIG_RELAY=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and read access to relay channel files under debugfs — paths used exclusively by kernel tracing tools (SystemTap, etc.) that have no place in a production server allowlist. Without an allowlist entry covering debugfs relay access, the kernel refuses it. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2023-3567

**Status**: Affected
**Component**: virtual terminal (VT) (`CONFIG_VT`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/tty/vt/vc_screen.c

**What this means for an attacker:**

In `drivers/tty/vt/vc_screen.c`, `vcs_read()` accesses virtual console screen data through a `vc_screen` reference without holding appropriate locks for the full duration of the read. A concurrent write or deallocation of the virtual console can free the underlying `vc_screen` structure while `vcs_read()` is still referencing it, causing a use-after-free. The published vector is C:H/I:N/A:H — disclosure and crash, not direct privilege escalation.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_VT=y` is compiled in and 5.19.6 falls within the affected range. Reading `/dev/vcs*` virtual console screen devices requires membership in the `tty` group on Debian. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. Executing a non-allowlisted program requires an allowlist entry; an attacker cannot reach this code path without one.

**What this means for you as an HS user:**

**The attacker cannot turn this UAF into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-6531

**Status**: Affected
**Component**: Unix domain sockets (`CONFIG_UNIX`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/unix/garbage.c

**What this means for an attacker:**

In `net/unix/garbage.c`, the Unix socket garbage collector frees orphaned socket buffers (SKBs) without coordinating with concurrent `unix_stream_read_generic()` operations on the socket those SKBs are queued on. The race allows `unix_stream_read_generic()` to access an SKB that the garbage collector has already freed, causing a use-after-free. AC:H reflects that exploitation requires precise timing between the GC sweep and a concurrent stream read.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_UNIX=y` is compiled in and 5.19.6 falls within the affected range. Unix domain sockets are used by virtually all inter-process communication on a Debian 11 server (systemd, D-Bus, logging daemons). The narrow race window (AC:H) makes reliable exploitation difficult. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a standalone race-exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-51043

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no DRM/GPU device on headless server; `drm_atomic` requires GPU mode-setting

In the Linux kernel before 6.4.5, drivers/gpu/drm/drm_atomic.c has a use-after-free during a race condition between a nonblocking atomic commit and a driver unload.

`CONFIG_DRM=y` is compiled in and 5.19.6 falls within the affected range. The `drm_atomic` race condition requires a process to initiate GPU mode-setting operations — specifically a nonblocking atomic commit — concurrent with driver unload. HeartSuite Core Secure runs on headless server hardware with no display GPU; the DRM device nodes are absent, so no mode-setting operation can be initiated. No GPU or display tool appears in the HS allowlist. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-0841

**Status**: Not exploitable
**Component**: hugetlbfs (`CONFIG_HUGETLBFS`)
**Base Score**: 6.6 MEDIUM (AV:L/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:H)
**Score on HeartSuite**: 0.0 — mount() blocked by Lockdown; hugetlbfs mount path unreachable
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/hugetlbfs/inode.c

In `fs/hugetlbfs/inode.c`, `hugetlbfs_fill_super()` initialises the hugetlbfs superblock for a `mount(2)` call. Under certain error conditions during setup — for instance, when huge page pool allocation fails — the function dereferences a pointer that was not initialised, causing a null pointer dereference. The crash is reachable by any local user with `CAP_SYS_ADMIN` permission to mount hugetlbfs.

`CONFIG_HUGETLBFS=y` is compiled in and 5.19.6 falls within the affected range. Triggering `hugetlbfs_fill_super()` requires calling `mount(2)` with `hugetlbfs` as the filesystem type, which additionally requires `CAP_SYS_ADMIN` on Debian 11. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any hugetlbfs setup begins. In Lockdown, no approved program in the HS allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any HeartSuite Core Secure deployment.

### CVE-2024-26593

**Status**: Not exploitable
**Component**: Intel SMBus I2C controller (`CONFIG_I2C_I801`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — no I2C/SMBus tool in HS allowlist; Lockdown blocks access

In `drivers/i2c/busses/i2c-i801.c`, the Intel I801 SMBus driver handles block process call transactions incorrectly. Intel datasheets specify that the block buffer index must be reset twice: once before writing the outgoing data to the buffer, and once before reading the incoming response. The driver resets the index only once, causing the response to be read from the wrong buffer position and potentially returning incorrect data to callers.

`CONFIG_I2C_I801=y` is compiled in and 5.19.6 falls within the affected range. The Intel I2C SMBus controller is present on Intel-based servers for BMC, temperature sensor, and management bus communication. Accessing it requires root or `i2c` group membership and an i2c-tools or lm-sensors program — no such tool appears in the HS allowlist. On a HeartSuite Core Secure system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the I2C device interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-38586

**Status**: Affected
**Component**: Realtek r8169 Ethernet driver (`CONFIG_R8169`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/net/ethernet/realtek/r8169_main.c

**What this means for an attacker:**

In `drivers/net/ethernet/realtek/r8169_main.c`, transmitting small fragmented scatter-gather packets on an RTL8125b NIC causes the driver to populate TX ring buffer descriptors with invalid state. The NIC subsequently processes the malformed descriptors, leading to incorrect DMA operations that can corrupt memory.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_R8169=y` is compiled in and 5.19.6 falls within the affected range. The r8169 driver is active on systems with a Realtek NIC and handles all network TX traffic; the faulty path is reachable through normal network operation on affected hardware. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-38630

**Status**: Not exploitable
**Component**: watchdog timer subsystem (`CONFIG_WATCHDOG`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no watchdog daemon in HS allowlist; Lockdown blocks `/dev/watchdog` access

When the cpu5wdt module is removing, the origin code uses del_timer() to de-activate the timer.

`CONFIG_WATCHDOG=y` is compiled in and 5.19.6 falls within the affected range. The cpu5wdt driver targets a PC-era ISA watchdog timer; this hardware is absent on any modern HS server deployment. Even on configurations where the hardware exists, the trigger requires a process to open and interact with `/dev/watchdog` — no watchdog daemon appears in the HS allowlist. On a HeartSuite Core Secure system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the cpu5wdt interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-34777

**Status**: Not Affected — `CONFIG_DMA_MAP_BENCHMARK` not compiled
**Component**: DMA map benchmark (`CONFIG_DMA_MAP_BENCHMARK`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `CONFIG_DMA_MAP_BENCHMARK` not compiled in HS kernel

In `kernel/dma/map_benchmark.c`, `map_benchmark_ioctl()` passes the user-supplied NUMA node ID directly to `node_possible()` (line 211) without first verifying that it falls within `[0, MAX_NUMNODES-1]`. `node_possible()` uses the node ID as a bitmap index; an out-of-range value causes an out-of-bounds read in the `node_possible_map` bitmap.

`CONFIG_DMA_MAP_BENCHMARK` is not set in the HS 5.19.6 configuration. The DMA mapping benchmark module is a debug/testing facility accessible via `/sys/kernel/debug/dma_map_benchmark`; it is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-39463

**Status**: Not exploitable
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `mount()` blocked by Lockdown; no 9P filesystem reachable on HS deployments

In `fs/9p/`, a use-after-free occurs on a dentry's `d_fsdata` fid list when one thread looks up a fid through the dentry while another thread concurrently unlinks it. The unlinking thread frees the fid while the lookup thread still holds a reference, causing the lookup to dereference freed memory.

`CONFIG_9P_FS=y` is compiled in. Triggering the bug requires mounting a 9P filesystem. Lockdown categorically blocks `mount()` — `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, after which all mount paths return `EPERM`. No HeartSuite Core Secure deployment has a 9P filesystem mounted before Lockdown engages at boot. The trigger cannot be reached.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2024-40956

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Intel IAX/DSA accelerator hardware absent

Use list_for_each_entry_safe() to allow iterating through the list and deleting the entry in the iteration process.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd is the driver for Intel Data Streaming Accelerator (DSA) and Intelligence Analytics Accelerator (IAX), available in Intel Sapphire Rapids and later server CPUs. These accelerators require specific Intel hardware not present on a standard Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-48867

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Intel IAX/DSA accelerator hardware absent

In `drivers/dma/idxd/`, when the Intel Data Streaming Accelerator driver is unloaded, `idxd_dmaengine_drv_remove()` frees the interrupt handler while descriptor completions are still pending. Completion callbacks that fire after interrupt teardown dereference the freed interrupt state, causing a use-after-free.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's Data Streaming Accelerator hardware, present only in Intel Sapphire Rapids (and later) server CPUs. This hardware is not present on a standard Debian 11 deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-46759

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — ADC128D818 I2C ADC chip absent

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large negative number such as -9223372036854775808 is provided by the user.

`CONFIG_HWMON=y` is compiled in. adc128d818 drives the Texas Instruments ADC128D818 — a specific 8-channel I2C ADC chip used on some custom boards. This chip is not part of standard server hardware; the hwmon driver is never bound.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-49860

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — malformed ACPI _STR firmware absent; standard OEM server firmware returns Buffer objects as specified
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/acpi/device_sysfs.c

In the ACPI subsystem, the `_STR` ACPI method must return a buffer object containing a Unicode description string. `description_show()`, exposed via sysfs at `/sys/bus/acpi/devices/*/description`, calls the `_STR` method and dereferences the result without validating that the returned object is in fact a buffer. A crafted or malformed ACPI table that returns an integer, package, or other non-buffer object from `_STR` causes `description_show()` to access invalid memory.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI tables are loaded from OEM firmware at boot and are read-only thereafter — no userspace process can modify them without firmware-level access outside the HS adversary model. Standard OEM server firmware conforms to the ACPI specification and returns a Buffer object from `_STR`. On a HeartSuite Core Secure server deployment, no malformed `_STR` firmware is present; the invalid-memory path in `description_show()` is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-49029

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — IBM Power Management Extension hardware absent

In `drivers/hwmon/ibmpex.c`, `ibmpex_register_bmc()` at line 509 adds a BMC device entry to the global list but does not remove it from the list on the error path. If registration fails partway through, `&data->list` remains linked while the containing `data` struct is freed, leading to a use-after-free when the list is subsequently traversed.

`CONFIG_HWMON=y` is compiled in. ibmpex drives the IBM Power Management Extension, specific to IBM Power Systems server hardware. This is not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-50127

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

In `net/sched/sch_taprio.c`, `taprio_change()` holds the `admin` schedule pointer while a concurrent `advance_sched()` call can switch or remove the schedule, making `admin` a dangling pointer. The critical section protected by `q->current_entry_lock` does not prevent this race, allowing access to freed schedule memory.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-50131

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — tracefs not in HS allowlist; Lockdown blocks the exploitation trigger

In the kernel tracing subsystem, `strlen()` returns the string length excluding the null terminator. If the string length equals the maximum buffer length, the buffer has no remaining space for the null byte, and the subsequent null terminator write goes one byte past the end of the buffer — a classic off-by-one overflow.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No HeartSuite Core Secure HeartSuite Core Secure deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-53057

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

In qdisc_tree_reduce_backlog, Qdiscs with major handle ffff: are assumed to be either root or ingress.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-56606

**Status**: Not exploitable
**Component**: AF_PACKET sockets (`CONFIG_PACKET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CAP_NET_RAW` not in HS allowlist; Lockdown blocks the exploitation trigger

After sock_init_data() the allocated sk object is attached to the provided sock object.

`CONFIG_PACKET=y` is compiled in. Creating an AF_PACKET raw socket requires `CAP_NET_RAW`. No HeartSuite Core Secure HeartSuite Core Secure deployment grants `CAP_NET_RAW` to any service — packet capture tools such as `tcpdump` have no allowlist entry. Without an allowlist entry, the kernel refuses to execute them. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-21692

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

Haowei Yan <g1042620637@gmail.com> found that ets_class_from_arg() can index an Out-Of-Bound class in ets_class_from_arg() when passed clid of 0.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49799

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — tracefs not in HS allowlist; Lockdown blocks the exploitation trigger

In `kernel/trace/`, `register_synth_event()` calls `trace_remove_event_call()` and `unregister_trace_event()` on the error path when `set_synth_event_print_fmt()` fails. Calling both functions causes the trace event to be unregistered twice, resulting in a double-free of the trace event structure.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No HeartSuite Core Secure HeartSuite Core Secure deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49892

**Status**: Not exploitable
**Component**: ftrace / function tracer (`CONFIG_FTRACE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — tracefs not in HS allowlist; Lockdown blocks the exploitation trigger

KASAN reported a use-after-free with ftrace ops [1]. It was found from vmcore that perf had registered two ops with the same content successively, both dynamic.

`CONFIG_FTRACE=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and write access to ftrace control files under `/sys/kernel/tracing/`. No HeartSuite Core Secure HeartSuite Core Secure deployment permits any service to access these paths. Without an allowlist entry covering the ftrace interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49921

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

We can't use "skb" again after passing it to qdisc_enqueue(). This is basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb len before calling child enqueue").

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2023-53111

**Status**: Not exploitable
**Component**: loop block device (`CONFIG_BLK_DEV_LOOP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `/dev/loop*` access not in HS allowlist; Lockdown blocks the exploitation trigger

do_req_filebacked() calls blk_mq_complete_request() synchronously or asynchronously when using asynchronous I/O unless memory allocation fails.

`CONFIG_BLK_DEV_LOOP=y` is compiled in. Triggering the bug requires `ioctl` operations on `/dev/loop*` with `CAP_SYS_ADMIN`. No HeartSuite Core Secure production workload uses loop devices — they are absent from the Lockdown allowlist. Without an allowlist entry, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37879

**Status**: Not exploitable
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — `mount()` blocked by Lockdown; no 9P filesystem reachable on HS deployments

In `net/9p/client.c`, `p9_client_write()` and `p9_client_read_once()` do not validate the count returned by the 9P server. If a misbehaving server replies with success but a negative byte count, the client treats the negative value as a large unsigned integer, potentially causing integer underflow or incorrect buffer offset calculations.

`CONFIG_9P_FS=y` is compiled in. Triggering the bug requires mounting a 9P filesystem. Lockdown categorically blocks `mount()` — `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, after which all mount paths return `EPERM`. No HeartSuite Core Secure deployment has a 9P filesystem mounted before Lockdown engages at boot. The trigger cannot be reached.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2025-37914

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37915

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37923

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — tracefs not in HS allowlist; Lockdown blocks the exploitation trigger

In `kernel/trace/trace.c`, `trace_seq_to_buffer()` at line 1830 performs a slab-out-of-bounds write. syzbot reproduced a KASAN report showing that a trace sequence buffer copy operation writes beyond the allocated slab boundary, reachable through the kernel tracing filesystem interface under `CAP_SYS_ADMIN`.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No HeartSuite Core Secure HeartSuite Core Secure deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-38369

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Intel IAX/DSA accelerator hardware absent

Running IDXD workloads in a container with the /dev directory mounted can trigger a call trace or even a kernel panic when the parent process exits while child processes are still using IDXD portal file descriptors. The portal file descriptor cleanup races with process exit, causing a use-after-free when the freed descriptor object is subsequently accessed.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's on-chip Data Streaming and Analytics Accelerator hardware. This requires specific Intel Sapphire Rapids or later CPU hardware not present on a standard server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38548

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Corsair Commander Pro hardware absent

Add buffer_recv_size to store the size of the received bytes. Validate buffer_recv_size in send_usb_cmd().

`CONFIG_HWMON=y` is compiled in. corsair-cpro drives the Corsair Commander Pro — a desktop PC fan/cooler controller connected via USB HID. This device is not present in a production server environment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50320

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — FPDT crash requires malformed firmware; not reachable on standard OEM hardware
**Affected range**: Linux 5.x–5.19 (fix adds address validation before acpi_os_map_memory call)
**Upstream fix**: drivers/acpi/acpi_fpdt.c (validate subtable->address before mapping)

In `drivers/acpi/acpi_fpdt.c`, `acpi_init_fpdt()` (line 253) passes FPDT subtable addresses from firmware-supplied ACPI tables directly to `acpi_os_map_memory()` without validating that the address falls within the physical memory range. On systems with buggy firmware (the Packard Bell Dot SC, Intel Atom N2600 being the reported case), FPDT entries contain addresses with high bits set outside the valid physical range. `acpi_os_map_memory()` then attempts to map non-existent memory, crashing the kernel. Any firmware that supplies a malformed FPDT triggers the same path.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. FPDT parsing runs at `fs_initcall` priority — early boot, before any user-space process is running. Triggering the invalid-address crash requires malformed FPDT entries in the system's ACPI firmware; HeartSuite deployments use standard OEM server firmware that conforms to the ACPI specification. Injecting a crafted ACPI table requires physical or firmware-level access, which is outside the HS software-based adversary model. An adversary with firmware access has already bypassed the OS security boundary; the ACPI parsing path is therefore not a reachable software attack surface on any standard HS deployment.

### CVE-2023-53395

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — AML exploit requires crafted firmware; ACPI tables read-only after boot on standard servers
**Affected range**: Linux 5.x through affected ACPICA version
**Upstream fix**: ACPICA commit 90310989a079 (drivers/acpi/acpica/acopcode.h)

In the ACPICA AML interpreter, the opcode table entries for the AML `Timer` instruction (`ARGP_TIMER_OP`, `ARGI_TIMER_OP` in `drivers/acpi/acpica/acopcode.h`) were inconsistent with ACPI Specification section 19.6.134, which specifies that `Timer` takes no arguments. The mismatch caused the AML parser to mishandle `Timer` opcodes in certain AML bytecode sequences, potentially treating subsequent bytecode as a spurious argument and corrupting the AML interpreter walk-state.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. AML execution runs at boot using ACPI tables supplied by the system firmware. Exploiting the walk-state corruption requires crafted AML bytecode — on a server with a reputable firmware vendor, ACPI tables are loaded from firmware storage at boot and are read-only thereafter; no userspace process can replace or modify the AML after boot without firmware-level access. This places the trigger outside the HS software-based adversary model. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-39869

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — Texas Instruments eDMA hardware absent

Fix a critical memory allocation bug in edma_setup_from_hw() where queue_priority_map was allocated with insufficient memory.

`CONFIG_DMA_ENGINE=y` is compiled in. ti-edma is the DMA controller driver for Texas Instruments Keystone/OMAP/AM embedded SoC platforms. This driver and hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50423

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–5.19
**Upstream fix**: drivers/acpi/acpica/utdelete.c (reference count ordering fix)

**What this means for an attacker:**

In `drivers/acpi/acpica/utdelete.c`, `acpi_ut_remove_reference()` is called on an ACPI operand object that has already been freed by a concurrent or error-handling code path. The function reads `object->common.descriptor_type` (via `ACPI_GET_DESCRIPTOR_TYPE`, line 720) and `object->common.reference_count` (via `acpi_ut_update_object_reference`, line 740) from the already-freed memory. KASAN detects the access as a use-after-free at offset +0x3b in `acpi_ut_remove_reference()`.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. The ACPI subsystem is active from boot; triggering this use-after-free requires manipulating the ACPI reference count lifecycle via method evaluation during device enumeration or hotplug events. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot drop and execute a new exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2026-23378

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `tc` not in HS allowlist; Lockdown blocks the exploitation trigger

Whenever an ife action replace changes the metalist, instead of replacing the old data on the metalist, the current ife code is appending the new metadata.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No HeartSuite Core Secure HeartSuite Core Secure deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-36883

**Status**: Not exploitable
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — pernet race requires module loading; `kmod`'s access to `/usr/lib/modprobe.d/` denied by Lockdown file-access enforcement post-boot
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/core/net_namespace.c

In `net/core/net_namespace.c`, `net_alloc_generic()` reads `max_gen_ptrs` — the size of the generic pointers array — to determine how much memory to allocate for a new network namespace. This read occurs without holding `pernet_ops_rwsem`. `register_pernet_operations()` can increment `max_gen_ptrs` concurrently while holding the write side of that lock. The race can cause `net_alloc_generic()` to allocate an undersized array, leading to out-of-bounds access when the new namespace is subsequently populated.

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The race requires `register_pernet_operations()` to execute concurrently with `net_alloc_generic()`. `register_pernet_operations()` is invoked exclusively from module initialization (`module_init` routines), so the race cannot be triggered post-Lockdown unless a new kernel module is loaded. New module loading is blocked by **Lockdown**, not by the Linux kernel's built-in lockdown LSM: on Debian 12, `modprobe` and `insmod` are symlinks to `/usr/bin/kmod`, which is added to the allowlist by standard Setup Mode via `systemd-modules-load.service`. HeartSuite does not refuse `execve` on `kmod`; the block operates at the file-access layer — Lockdown denies `kmod` access to `/usr/lib/modprobe.d/` by default, so module loading fails at the file-read stage before any module can be loaded. There is no `HS_locked_down()` check site in the `init_module` / `finit_module` syscall path — the block is at the file-access layer, enforced by Lockdown. (If you follow the [kmod hardening procedure](../maintenance/kmod-hardening/), kmod's module-path access records are explicitly scoped to permitted paths, hardening against configuration drift.) After Lockdown engages at boot, all statically-linked pernet operations have already registered and `max_gen_ptrs` is stable; no concurrent write is possible. Separately, creating a network namespace requires `CAP_NET_ADMIN` with user namespaces disabled on the HS kernel; no unprivileged process can initiate the namespace-creation side of the race. The race condition cannot be triggered on any HeartSuite Core Secure deployment where `kmod` does not have file-access permissions to `/usr/lib/modprobe.d/`.

### CVE-2024-36971

**Status**: Affected
**Component**: TCP/IP destination cache (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: 5.19.6 falls within the affected range
**Upstream fix**: net/core/dst.c — RCU locking in `__dst_negative_advice()`

**What this means for an attacker:**

This CVE was actively exploited in the wild (Google Threat Analysis Group, 2024). It describes a use-after-free in `net/core/dst.c`. `__dst_negative_advice()` clears `sk->dst_cache` when a cached destination entry is marked invalid — reading the entry, determining it should be dropped, then calling `sk_dst_reset()` — without proper RCU locking across this sequence. A concurrent operation can free the destination entry between the initial read and the reset, producing a use-after-free on the freed `dst` entry. The result is local privilege escalation to root; attack vector is local (AV:L), not remote.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. `__dst_negative_advice()` is invoked whenever a cached destination becomes invalid, reachable through normal network activity or by triggering ICMP unreachable messages from a local process. There is no hardware dependency and no special configuration required to reach the code path. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot drop and execute a new exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-38577

**Status**: Affected
**Component**: RCU tasks subsystem (`CONFIG_TASKS_RCU`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: kernel/rcu/tasks.h

**What this means for an attacker:**

In `kernel/rcu/tasks.h`, `show_rcu_tasks_trace_gp_kthread()` formats diagnostic counters for the RCU tasks trace grace-period kthread into a fixed-size buffer using `sprintf()`. The function does not bound the number of characters written; if individual counter values are sufficiently large, the formatted output overflows the buffer. The sysfs interface exposing this data is readable by any local user via `/sys/kernel/rcu_tasks_kthread_status` or equivalent debugfs entries.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_TASKS_RCU=y` is compiled in and 5.19.6 falls within the affected range. RCU tasks is a core kernel synchronisation mechanism active at all times; the overflow condition requires unusually large counter values, making reliable exploitation difficult on a production system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-40958

**Status**: Not exploitable
**Component**: network namespaces (`CONFIG_NET_NS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `CLONE_NEWNET` not in HS allowlist; Lockdown blocks the exploitation trigger

In the network namespace subsystem, a use-after-free occurs through a refcount underflow. syzkaller triggered a `refcount_t: addition on 0` warning at `lib/refcount.c:25`, indicating that a network namespace object's reference count reached zero while still being accessed, with a subsequent attempt to increment the freed object's refcount in `refcount_warn_saturate()`.

`CONFIG_NET_NS=y` is compiled in. Creating a network namespace requires `CLONE_NEWNET` with `CAP_NET_ADMIN`. User namespaces (which would bypass the capability requirement) are disabled on the HS kernel. No HeartSuite Core Secure production service creates network namespaces — they are absent from the Lockdown allowlist. Without an allowlist entry, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-41039

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no audio hardware present

Fix the checking that firmware file buffer is large enough for the wmfw header, to prevent overrunning the buffer.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-46713

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist

Ole reported that event->mmap_mutex is strictly insufficient to serialize the AUX buffer, add a per RB mutex to fully serialize it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-46852

**Status**: Not exploitable
**Component**: DMA-BUF shared buffer (`CONFIG_DMA_SHARED_BUFFER`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — no DRM device on headless HS server; DMA-BUF operations unreachable

Until VM_DONTEXPAND was added in commit 1c1914d6e8c6 ("dma-buf: heaps: Don't track CMA dma-buf pages under RssFile") it was possible to obtain a mapping larger than the buffer by calling `mremap()` on a DMA-BUF heap allocation. The DMA-BUF heap mmap handler did not set `VM_DONTEXPAND`, allowing the VMA to be extended beyond the original allocation size and enabling out-of-bounds access to adjacent memory.

`CONFIG_DMA_SHARED_BUFFER=y` is compiled in and 5.19.6 falls within the affected range. DMA-BUF buffer sharing requires access to a DRM or V4L2 device. HeartSuite Core Secure runs on headless server hardware with no GPU or video capture device; the DRM and V4L2 device nodes are absent, so the exploitation path — opening a DRM device and issuing `mmap()` on its DMA-BUF — is hardware-unreachable. No GPU or multimedia tool appears in the HS allowlist. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-48950

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in HS allowlist

In `kernel/events/core.c`, `perf_pending_task()` can execute after the associated `perf_event` object has been freed. When a task exits and its pending perf events are processed, a race allows the task-work callback to fire after the event is released, causing a use-after-free.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-49026

**Status**: Not exploitable
**Component**: Intel e100 Fast Ethernet driver (`CONFIG_E100`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — Intel Pro/100 NIC absent on any modern HS server deployment

In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will resend the skb.

`CONFIG_E100=y` is compiled in and 5.19.6 falls within the affected range. The Intel e100 driver supports legacy Intel Pro/100 Fast Ethernet cards, a line discontinued in the early 2000s. No modern server or datacenter hardware ships with or supports this NIC; the driver code is compiled in but the hardware is universally absent on any HS deployment. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-50055

**Status**: Affected
**Component**: core kernel (`CONFIG_BASE_FULL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/base/bus.c

**What this means for an attacker:**

In `drivers/base/bus.c`, `bus_register()` allocates a `subsys_private` struct (`@priv`) and calls `kset_register()` to publish the bus kobject. If a subsequent step in `bus_register()` fails — for example, during sysfs attribute file creation — the error path calls `kset_unregister()`, which frees `@priv` through its kobject release callback. `bus_register()` then also frees `@priv` directly in its own error path, causing a double-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_BASE_FULL=y` is compiled in and 5.19.6 falls within the affected range. `bus_register()` is called during driver probe and device enumeration, typically at boot or when kernel modules are loaded. Triggering the double-free requires causing a bus registration to fail partway through a specific sysfs error. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot load an exploit module or execute an exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-50112

**Status**: Not Affected — LAM not implemented in Linux 5.19.x
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — LAM infrastructure absent from Linux 5.19.x (introduced in 6.2)

Linear Address Masking (LAM) is an x86_64 feature that allows software to store metadata in the upper bits of a canonical virtual address; it requires explicit kernel support — `arch_prctl` LAM commands, CR3 tag bit management, and associated data structures — to activate. The SLAM transient execution attack exploits an interaction between LAM tag bits and the speculative address-translation pipeline when a LAM-enabled process is running. This LAM kernel infrastructure was introduced upstream in Linux 6.2. The 5.19.6 kernel contains no LAM code paths; no process can enable LAM regardless of privilege level, and the transient execution oracle the SLAM paper describes does not exist in this kernel.

### CVE-2024-50193

**Status**: Not exploitable
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on HeartSuite**: 0.0 — perf_event_open() blocked by perf_event_paranoid=3; no perf tool in HS allowlist
**Affected range**: Linux 5.x–6.11
**Upstream fix**: arch/x86/kernel/nmi.c (CPU buffer flush ordering fix)

On x86_64, the MDS/MD_CLEAR mitigation (VERW-based CPU buffer flush) is applied after `exc_nmi()` completes but before IRET restores register state. This ordering leaves a window in which speculative execution can observe uninitialised microarchitectural buffer contents from the interrupted context — a same-CPU information disclosure in the MDS (Microarchitectural Data Sampling) class.

`CONFIG_X86_64=y` is compiled in and 5.19.6 falls within the affected range. Triggering NMIs from ring-3 requires `perf_event_open()` or hardware performance counters. On a HeartSuite Core Secure system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the HS allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-56600

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/af_inet6.c

**What this means for an attacker:**

In `net/ipv6/af_inet6.c`, `sock_init_data()` attaches the newly allocated `sk` pointer to `sock->sk` before `inet6_create()` completes setup. If `inet6_create()` fails at a later step and frees the `sk`, `sock->sk` retains the dangling pointer. The socket cleanup path subsequently calls `sock->sk->sk_prot->close()` on the freed `sk`, causing a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 socket creation is triggered whenever a process opens an IPv6 socket — a common operation on any networked system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to reach this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-56601

**Status**: Affected
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv4/af_inet.c

**What this means for an attacker:**

In `net/ipv4/af_inet.c`, `sock_init_data()` attaches the newly allocated `sk` pointer to `sock->sk` before `inet_create()` completes setup. If `inet_create()` fails at a later step and frees the `sk`, `sock->sk` retains the dangling pointer. The socket cleanup path subsequently calls `sock->sk->sk_prot->close()` on the freed `sk`, causing a use-after-free.

**Why HeartSuite does not reduce this to 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP/IP stack is always active; INET socket creation occurs on every TCP or UDP connection. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-56616

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on HeartSuite**: 0.0 — DisplayPort MST display hardware absent

Fix the MST sideband message body length check, which must be at least 1 byte accounting for the message body CRC (aka message data CRC) at the end of the message.

`CONFIG_DRM=y` is compiled in. DisplayPort Multi-Stream Transport (DP MST) is used for daisy-chaining multiple monitors via DisplayPort. A headless server has no display output hardware; the DP MST sideband message path is never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

## Not Affected — Disabled Features {#not-affected-disabled-features}

HeartSuite Core Secure is built for production servers, regulated workstations, build infrastructure, and AI agent sandboxes. The kernel does not include subsystems these workloads do not require. Each absent subsystem eliminates the full class of vulnerabilities that subsystem carries, without requiring per-CVE evaluation.

Where a CVE in this section achieves root privilege, Lockdown provides the same backstop described in [CVE-2026-31431](#cve-2026-31431) — `chattr +i` filesystem immutability combined with the kernel refusing runtime allowlist changes means an attacker who reaches root in Lockdown has no path to persistence or to modifying the allowlist.

| Config gate | CVEs covered | Status |
|-------------|-------------|--------|
| [`CONFIG_BPF_SYSCALL` not set](#bpf-syscall-interface) | CVE-2021-20194, CVE-2023-2163, CVE-2023-39191, CVE-2023-52452, CVE-2024-26589, CVE-2023-52621, CVE-2023-52642, CVE-2024-26883, CVE-2024-26884, CVE-2024-26885, CVE-2024-38538, CVE-2024-40954, CVE-2024-41045, CVE-2024-49861, CVE-2022-49030, CVE-2024-50063, CVE-2024-50067, CVE-2024-50164, CVE-2024-50262, CVE-2024-53099, CVE-2024-56614, CVE-2024-56615, CVE-2024-56633, CVE-2024-56664, CVE-2023-53024, CVE-2022-49840, CVE-2025-37822, CVE-2022-49961, CVE-2022-49970, CVE-2022-49975, CVE-2025-38280, CVE-2025-38502, CVE-2025-38538, CVE-2025-39744, CVE-2023-53192, CVE-2023-53338, CVE-2025-39913, CVE-2022-50490, CVE-2022-50536, CVE-2026-23343, CVE-2026-23359  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NF_TABLES` not set](#netfilter-nftables) | CVE-2023-32233, CVE-2023-0179, CVE-2023-3390, CVE-2023-31248, CVE-2023-35001, CVE-2023-3610, CVE-2023-4004, CVE-2023-3777, CVE-2023-4015, CVE-2023-4244, CVE-2023-6817, CVE-2024-1085, CVE-2023-52628, CVE-2024-26673, CVE-2024-27020, CVE-2024-27065, CVE-2024-27397, CVE-2024-35896, CVE-2024-41042, CVE-2024-44983, CVE-2024-50257, CVE-2024-53141, CVE-2024-56650, CVE-2023-52927, CVE-2025-22056, CVE-2022-49919, CVE-2025-38201, CVE-2023-53179, CVE-2023-53492, CVE-2023-53619, CVE-2026-23231, CVE-2023-4147  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_SCH_QFQ`, `CONFIG_NET_CLS_TCINDEX` not set](#network-traffic-control-schedulers) | CVE-2023-31436, CVE-2023-1829, CVE-2023-1281 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BT` not set](#bluetooth-stack) | CVE-2022-42896, CVE-2022-45934, CVE-2022-3564, CVE-2022-3640, CVE-2023-1989, and 3 additional, CVE-2023-40283, CVE-2024-21803, CVE-2024-27000, CVE-2024-27398, CVE-2024-35963, CVE-2024-35965, CVE-2024-35966, CVE-2024-35967, CVE-2023-52766, CVE-2024-36012, CVE-2024-36032, CVE-2024-36880, CVE-2024-40927, CVE-2024-41087, CVE-2022-48871, CVE-2022-48878, CVE-2024-43883, CVE-2024-49950, CVE-2024-50125, CVE-2024-50234, CVE-2024-53208, CVE-2024-56604, CVE-2024-56605, CVE-2025-21969, CVE-2025-22022, CVE-2022-49826, CVE-2022-49910, CVE-2023-53057, CVE-2025-37882, CVE-2023-53145, CVE-2025-38117, CVE-2025-38118, CVE-2025-38250, CVE-2025-38593, CVE-2022-50315, CVE-2023-53252, CVE-2023-53305, CVE-2022-50386, CVE-2023-53386, CVE-2022-50419, CVE-2022-50470, CVE-2023-53673, CVE-2025-71082, CVE-2026-23395, CVE-2026-31500  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TLS`, `CONFIG_RDS`, `CONFIG_ROSE`, `CONFIG_MCTP`, `CONFIG_AF_RXRPC` not set](#protocol-families-tls-rds-rose-mctp-and-af_rxrpc) | CVE-2023-28466, CVE-2023-1078, CVE-2022-2961, CVE-2022-3977, CVE-2023-2006 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NFSD` not set](#nfs-server) | CVE-2022-43945, CVE-2022-4379, CVE-2023-1652, CVE-2024-26907, CVE-2023-52885, CVE-2024-50106, CVE-2024-50121, CVE-2024-53168, CVE-2025-38724, CVE-2022-50235, CVE-2022-50241, CVE-2022-50401, CVE-2022-50410, CVE-2023-53680, CVE-2026-22980  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NTFS3_FS`, `CONFIG_NTFS_FS`, `CONFIG_XFS_FS`, `CONFIG_JFS_FS`, `CONFIG_NILFS2_FS` not set](#filesystem-drivers) | CVE-2022-48423, CVE-2022-48424, CVE-2022-48425, CVE-2023-26544, CVE-2023-26506, CVE-2023-26507, CVE-2023-2124, CVE-2020-27815, CVE-2022-2978 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DVB_CORE`, `CONFIG_SGI_GRU`, `CONFIG_FPGA`, `CONFIG_KVM_INTEL` not set](#hardware-specific-and-virtualization-drivers) | CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919, CVE-2022-3424, CVE-2023-26242, CVE-2022-2196 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_NET_RNDIS_WLAN`, `CONFIG_SMB_SERVER` not set](#usb-network-adapter-and-smb-server) | CVE-2023-23559, CVE-2023-0210 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_ADV748X` not set](#config-video-adv748x) | CVE-2025-71136 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MD_RAID10` not set](#config-md-raid10) | CVE-2023-53357 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_NET_CDCETHER` not set](#config-usb-net-cdcether) | CVE-2025-38153 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_XLNX` not set](#config-drm-xlnx) | CVE-2024-56538 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_LAN78XX` not set](#config-usb-lan78xx) | CVE-2024-53213 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HYPERV_VSOCKETS` not set](#config-hyperv-vsockets) | CVE-2024-53103 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_XE` not set](#drm-xe-driver) | CVE-2024-53098 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ARM_SCMI_PROTOCOL` not set](#config-arm-scmi-protocol) | CVE-2024-53068 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_S5P_JPEG` not set](#config-video-s5p-jpeg) | CVE-2024-53061 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MSE102X` not set](#config-mse102x) | CVE-2024-50276 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TYPEC` not set](#config-typec) | CVE-2024-50150 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HSR` not set](#config-hsr) | CVE-2022-49015 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HI_GMAC` not set](#config-hi-gmac) | CVE-2022-48960, CVE-2022-48962 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_STM` not set](#config-drm-stm) | CVE-2024-49992 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PCI_KIRIN` not set](#config-pci-kirin) | CVE-2024-47751 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_ASPEED_GFX` not set](#config-drm-aspeed-gfx) | CVE-2023-52916 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BNA` not set](#config-bna) | CVE-2024-43839 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CRYPTO_DEV_HISI_SEC2` not set](#config-crypto-dev-hisi-sec2) | CVE-2024-42147, CVE-2024-47730 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IONIC` not set](#config-ionic) | CVE-2024-39502 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GREYBUS` not set](#config-greybus) | CVE-2024-39495 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_STM` not set](#config-stm) | CVE-2024-38627 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DEBUG_MUTEXES` not set](#config-debug-mutexes) | CVE-2023-52836 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RCU_NOCB_CPU` not set](#config-rcu-nocb-cpu) | CVE-2024-35929, CVE-2025-38704 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SECURITY_APPARMOR` not set](#config-security-apparmor) | CVE-2026-23408 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MACVLAN` not set](#config-macvlan) | CVE-2026-23001 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_TEAM` not set](#config-net-team) | CVE-2025-71091 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DLM` not set](#config-dlm) | CVE-2023-53629 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TRACE_BUF` not set](#config-trace-buf) | CVE-2023-53587 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PTP_1588_CLOCK_OCP` not set](#config-ptp-1588-clock-ocp) | CVE-2025-39859 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_XDP_SOCKETS` not set](#config-xdp-sockets) | CVE-2023-53426 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NUBUS` not set](#config-nubus) | CVE-2023-53217 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_COMEDI` not set](#config-comedi) | CVE-2025-38482, CVE-2025-38483, CVE-2025-38529, CVE-2025-38530, CVE-2025-39685, CVE-2025-39686 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IPV6_SEG6_LWTUNNEL` not set](#config-ipv6-seg6-lwtunnel) | CVE-2025-38476 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CORESIGHT` not set](#config-coresight) | CVE-2025-38131 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_STAGING` not set](#config-staging) | CVE-2022-49956, CVE-2023-53554 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MCB` not set](#config-mcb) | CVE-2025-37817 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UDMABUF` not set](#config-udmabuf) | CVE-2025-37803 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SLIMBUS` not set](#config-slimbus) | CVE-2025-21914 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GENEVE` not set](#config-geneve) | CVE-2025-21858 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ORANGEFS_FS` not set](#config-orangefs-fs) | CVE-2025-21782 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PKTGEN` not set](#config-pktgen) | CVE-2025-21680 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SPI_MPC52xx` not set](#config-spi-mpc52xx) | CVE-2024-50051 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SUPERH` not set](#config-superh) | CVE-2024-53165 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_MUSB_HDRC` not set](#config-usb-musb-hdrc) | CVE-2024-50269 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_SERIAL` not set](#config-usb-serial) | CVE-2024-50267 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VDPA` not set](#config-vdpa) | CVE-2024-47748, CVE-2024-53126, CVE-2023-53082, CVE-2023-53543 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SPI_NXP_FLEXSPI` not set](#config-spi-nxp-flexspi) | CVE-2024-46853 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UML` not set](#config-uml) | CVE-2024-46844 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_SCH_NETEM` not set](#config-net-sch-netem) | CVE-2024-46800 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PARISC` not set](#config-parisc) | CVE-2024-44949, CVE-2022-50518 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_FOU` not set](#config-net-fou) | CVE-2024-44940, CVE-2026-23083 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VHOST_VSOCK` not set](#config-vhost-vsock) | CVE-2024-43873 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IIO` not set](#config-iio) | CVE-2024-42086, CVE-2024-57906, CVE-2024-57907, CVE-2024-57908, CVE-2024-57910, CVE-2024-57911, CVE-2024-57912, CVE-2022-49792, CVE-2025-38485 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SND_SOC` not set](#config-snd-soc) | CVE-2024-41069, CVE-2022-50325 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CACHEFILES` not set](#config-cachefiles) | CVE-2024-41050, CVE-2024-41057, CVE-2024-41074 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_WWAN` not set](#config-wwan) | CVE-2024-40939 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VMWARE_VMCI` not set](#config-vmware-vmci) | CVE-2024-39499, CVE-2024-46738, CVE-2025-38403 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BONDING` not set](#config-bonding) | CVE-2024-39487, CVE-2026-23099 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TEE` not set](#tee-subsystem) | CVE-2023-52503 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_INPUT_POWERMATE` not set](#powermate-driver) | CVE-2023-52475 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PWM` not set](#pwm-subsystem) | CVE-2024-26599 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_PVRUSB2` not set](#pvrusb2-driver) | CVE-2023-52445 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ATALK` not set](#appletalk) | CVE-2023-51781 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IGB` not set](#igb-driver) | CVE-2023-45871 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_RKVDEC` not set](#rkvdec-driver) | CVE-2023-35829 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_RENESAS_USBHS3` not set](#renesas-usb3) | CVE-2023-35828 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_SUNXI_CEDRUS` not set](#cedrus-driver) | CVE-2023-35826 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_DM1105` not set](#dm1105-driver) | CVE-2023-35824 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_SAA7134` not set](#saa7134-driver) | CVE-2023-35823 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_CLS_U32` not set](#tc-cls-u32) | CVE-2026-23204 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_WILC1000` not set](#wilc1000-driver) | CVE-2025-39952 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MWIFIEX` not set](#mwifiex-driver) | CVE-2025-39891 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_AF_RXRPC` not set](#config-af-rxrpc) | CVE-2023-53218 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_SCH_QFQ` not set](#config-net-sch-qfq) | CVE-2025-37913 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NTFS_FS` not set](#config-ntfs-fs) | CVE-2022-49763 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IP_SCTP` not set](#sctp-protocol) | CVE-2025-23142, CVE-2025-38718, CVE-2022-50243, CVE-2023-53372  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MEMSTICK` not set](#memstick) | CVE-2025-22020, CVE-2023-3141  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BRCMFMAC` not set](#brcmfmac-driver) | CVE-2022-49740, CVE-2022-50258, CVE-2023-53213, CVE-2022-50408, CVE-2025-39863, CVE-2022-50551  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RTLWIFI` not set](#rtlwifi-driver) | CVE-2024-58072, CVE-2022-50279  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_LOONGARCH` not set](#loongarch-arch) | CVE-2024-56628 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UDF_FS` not set](#udf-filesystem) | CVE-2024-50143, CVE-2022-49846, CVE-2023-53107, CVE-2023-53506  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RMNET` not set](#rmnet-driver) | CVE-2024-50128, CVE-2024-26597  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PPP` not set](#ppp) | CVE-2024-50033, CVE-2024-50035, CVE-2025-37749, CVE-2025-38574  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_XEN` not set](#xen-hypervisor) | CVE-2024-49936, CVE-2024-56704  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_OCFS2_FS` not set](#ocfs2-filesystem) | CVE-2024-47670, CVE-2024-49966, CVE-2024-53155, CVE-2024-57892, CVE-2025-22079, CVE-2023-53081  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PLATFORM_X86` not set](#config-platform-x86) | CVE-2024-46859, CVE-2024-49986, CVE-2025-38077  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ISDN` not set](#isdn) | CVE-2024-42280 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HFSPLUS_FS` not set](#hfsplus-filesystem) | CVE-2024-41059, CVE-2024-56548, CVE-2025-38713, CVE-2025-38714  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_XFS_FS` not set](#config-xfs-fs) | CVE-2024-41013, CVE-2024-41014, CVE-2025-39835, CVE-2022-50406  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PPC` not set](#powerpc-arch) | CVE-2024-40974, CVE-2024-46774, CVE-2022-48998, CVE-2024-56765, CVE-2025-38088, CVE-2025-39776, CVE-2023-53487, CVE-2025-71078, CVE-2023-52451  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IMA` not set](#ima) | CVE-2024-38667, CVE-2024-53106, CVE-2024-57798, CVE-2025-39730  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_SCH_MULTIQ` not set](#tc-multiq) | CVE-2024-36978 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_VMWGFX` not set](#vmwgfx-driver) | CVE-2024-36960 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PINCTRL` not set](#pinctrl) | CVE-2024-36940, CVE-2025-38286  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GPIOLIB` not set](#gpiolib) | CVE-2024-36898, CVE-2024-36899, CVE-2024-42092, CVE-2025-38395  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TIPC` not set](#tipc-protocol) | CVE-2024-36886, CVE-2024-42284, CVE-2022-49017, CVE-2024-56642, CVE-2025-38052, CVE-2025-38464  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PPDEV` not set](#ppdev-driver) | CVE-2024-36015 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_RADEON` not set](#radeon-driver) | CVE-2023-52867 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_WMI` not set](#wmi-driver) | CVE-2023-52864 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HW_PERF_EVENTS_HISI` not set](#config-hw-perf-events-hisi) | CVE-2023-52859, CVE-2024-38569  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_BT848` not set](#bttv-driver) | CVE-2023-52847 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RMI4_CORE` not set](#rmi4-driver) | CVE-2023-52840 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BLK_DEV_NBD` not set](#nbd-driver) | CVE-2023-52837, CVE-2024-49855, CVE-2025-38443  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_KVM_AMD` not set](#kvm-amd) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HNS3` not set](#hns3-driver) | CVE-2023-52807, CVE-2024-46833, CVE-2025-71112  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IPVLAN` not set](#ipvlan) | CVE-2023-52796 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SMC` not set](#smc-driver) | CVE-2023-52775, CVE-2024-56640, CVE-2024-57791, CVE-2025-38734  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_GSPCA_CORE` not set](#gspca-driver) | CVE-2023-52764 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GFS2_FS` not set](#gfs2-filesystem) | CVE-2023-52760, CVE-2024-38570, CVE-2023-53622  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_FB` not set](#config-fb) | CVE-2023-52731, CVE-2024-49924, CVE-2024-50180, CVE-2025-38685, CVE-2025-38702  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DMA_DIRECT_REMAP` not set](#config-dma-direct-remap) | CVE-2024-35939 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_AX25` not set](#ax25-hamradio) | CVE-2024-35887, CVE-2026-23098  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MLX5_CORE` not set](#mlx5-driver) | CVE-2023-52667, CVE-2024-38555, CVE-2024-38556, CVE-2024-40940, CVE-2022-48883, CVE-2022-49025, CVE-2023-53340  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ATLANTIC` not set](#atlantic-driver) | CVE-2023-52664 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_KVM` not set](#config-kvm) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_FIREWIRE` not set](#firewire) | CVE-2024-27401, CVE-2023-53432  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_OPENVSWITCH` not set](#openvswitch) | CVE-2024-27395, CVE-2025-37789, CVE-2025-38146  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_EROFS_FS` not set](#erofs-filesystem) | CVE-2022-48674, CVE-2024-41058  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_OF` not set](#config-of) | CVE-2022-48672 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PECI` not set](#config-peci) | CVE-2022-48670 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DVB_CORE` not set](#config-dvb-core) | CVE-2024-27075, CVE-2024-43900, CVE-2024-47697, CVE-2024-47698, CVE-2025-38227, CVE-2022-50274, CVE-2023-53219, CVE-2022-50499  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_NOUVEAU` not set](#nouveau-driver) | CVE-2024-27008, CVE-2022-50454  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_GADGET` not set](#usb-gadget) | CVE-2024-26996, CVE-2024-46836, CVE-2022-48948, CVE-2024-58055, CVE-2022-49980, CVE-2025-38497, CVE-2025-38555  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_COMMON_CLK_QCOM` not set](#config-common-clk-qcom) | CVE-2024-26965 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NILFS2_FS` not set](#config-nilfs2-fs) | CVE-2024-26955, CVE-2024-26956, CVE-2024-26981, CVE-2024-38583, CVE-2024-37078, CVE-2024-39469, CVE-2024-42104, CVE-2024-42105, CVE-2024-47757, CVE-2024-50230, CVE-2022-49834, CVE-2023-53035, CVE-2023-53311, CVE-2022-50367, CVE-2022-50478, CVE-2023-53608  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ARM64` not set](#arm64-arch) | CVE-2022-48657, CVE-2024-26989, CVE-2024-40989, CVE-2025-21785, CVE-2022-49888, CVE-2025-37849, CVE-2024-26598  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MLXBF_I2C` not set](#config-mlxbf-i2c) | CVE-2022-48632 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TUN` not set](#tun-tap-driver) | CVE-2024-26882, CVE-2022-49014, CVE-2023-3812  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RDS` not set](#config-rds) | CVE-2024-26865, CVE-2022-48637, CVE-2024-27024, CVE-2024-42138, CVE-2024-42148, CVE-2024-46782, CVE-2024-46786, CVE-2024-57900, CVE-2025-23156, CVE-2025-23158, CVE-2023-53075, CVE-2025-37921, CVE-2025-39710, CVE-2022-50412, CVE-2023-53541, CVE-2025-39967, CVE-2026-31578  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SPARX5_SWITCH` not set](#config-sparx5-switch) | CVE-2024-26856 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_THINKPAD_LMI` not set](#config-thinkpad-lmi) | CVE-2024-26836 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BTRFS_FS` not set](#btrfs-filesystem) | CVE-2024-26791, CVE-2024-26944, CVE-2024-35849, CVE-2024-35949, CVE-2024-39496, CVE-2024-42314, CVE-2024-50217, CVE-2024-56581, CVE-2024-56582, CVE-2024-56759, CVE-2024-57896, CVE-2025-39738, CVE-2025-39759, CVE-2022-50300  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MPTCP` not set](#mptcp) | CVE-2024-26782, CVE-2024-44974, CVE-2024-46858, CVE-2024-50083, CVE-2023-53072, CVE-2023-53088, CVE-2025-38552  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DM_CRYPT` not set](#config-dm-crypt) | CVE-2024-26763 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GTP` not set](#config-gtp) | CVE-2024-26754, CVE-2024-26793, CVE-2024-27396, CVE-2024-44999  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CRYPTO_DEV_VIRTIO` not set](#config-crypto-dev-virtio) | CVE-2024-26753 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_CDNS3` not set](#config-usb-cdns3) | CVE-2024-26748, CVE-2024-26749 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_ACT_MIRRED` not set](#tc-act-mirred) | CVE-2024-26739 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_AFS_FS` not set](#config-afs-fs) | CVE-2024-26736 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IP_TUNNEL` not set](#config-ip-tunnel) | CVE-2024-26665, CVE-2023-53600  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MHI_BUS` not set](#config-mhi-bus) | CVE-2023-52494, CVE-2025-39790  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_LLC` not set](#config-llc) | CVE-2024-26625 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_JFS_FS` not set](#config-jfs-fs) | CVE-2023-52599, CVE-2023-52600, CVE-2023-52603, CVE-2023-52604, CVE-2023-52799, CVE-2023-52804, CVE-2023-52805, CVE-2024-40902, CVE-2024-43858, CVE-2024-47723, CVE-2024-49900, CVE-2024-49903, CVE-2024-56595, CVE-2024-56596, CVE-2024-56597, CVE-2024-56598, CVE-2025-38204, CVE-2025-38230, CVE-2025-38697, CVE-2025-39743, CVE-2022-50333, CVE-2023-53222, CVE-2023-53485, CVE-2023-53616  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_S390` not set](#config-s390) | CVE-2023-52598, CVE-2024-26957, CVE-2023-52669, CVE-2024-36931, CVE-2024-45026, CVE-2022-48954, CVE-2024-57838, CVE-2024-57849, CVE-2022-49804, CVE-2023-53123, CVE-2025-38257, CVE-2025-38320, CVE-2022-50307, CVE-2023-53205, CVE-2026-31568  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_MSM` not set](#config-drm-msm) | CVE-2023-52586, CVE-2023-53316, CVE-2022-50368, CVE-2022-50437, CVE-2022-50492, CVE-2022-50526  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SECURITY_TOMOYO` not set](#config-security-tomoyo) | CVE-2024-26622 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IWLWIFI` not set](#iwlwifi-driver) | CVE-2023-52531, CVE-2024-26610, CVE-2024-36921, CVE-2024-40929, CVE-2024-53059, CVE-2025-21905, CVE-2022-50248, CVE-2023-53524  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SPI_SUN6I` not set](#config-spi-sun6i) | CVE-2023-52517 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_INFINIBAND` not set](#infiniband-rdma) | CVE-2023-52515, CVE-2024-26872, CVE-2022-48694, CVE-2023-52851, CVE-2024-38545, CVE-2024-42285, CVE-2025-38024, CVE-2025-38211, CVE-2025-71133, CVE-2026-31493  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IEEE802154` not set](#ieee802154-wpan) | CVE-2023-52510, CVE-2024-56602  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RAVB` not set](#ravb-driver) | CVE-2023-52509, CVE-2022-48964, CVE-2023-35827  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NFC` not set](#nfc) | CVE-2023-52507, CVE-2024-36915, CVE-2022-48967, CVE-2025-21735, CVE-2023-53106, CVE-2025-38416, CVE-2023-53495  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_FUSE_FS` not set](#fuse-filesystem) | CVE-2023-52504, CVE-2024-35932, CVE-2024-41090, CVE-2024-41091, CVE-2024-58054, CVE-2022-49945, CVE-2025-38385, CVE-2023-53286, CVE-2023-53577  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MCTP` not set](#config-mctp) | CVE-2023-52483 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ATH` not set](#ath-wireless-driver) | CVE-2023-52464, CVE-2023-52594, CVE-2023-52491, CVE-2024-26958, CVE-2024-26983, CVE-2024-26988, CVE-2024-27043, CVE-2023-52679, CVE-2024-35847, CVE-2023-52777, CVE-2023-52827, CVE-2024-36906, CVE-2024-36979, CVE-2024-38578, CVE-2024-38621, CVE-2024-41096, CVE-2024-42271, CVE-2024-43830, CVE-2022-48873, CVE-2022-48881, CVE-2024-46674, CVE-2024-47695, CVE-2024-47742, CVE-2024-49930, CVE-2024-49931, CVE-2022-48980, CVE-2022-48981, CVE-2022-48999, CVE-2024-53142, CVE-2024-53156, CVE-2024-56672, CVE-2024-57887, CVE-2024-57980, CVE-2025-21934, CVE-2025-37780, CVE-2023-53084, CVE-2023-53090, CVE-2025-37840, CVE-2025-38022, CVE-2025-38069, CVE-2025-38157, CVE-2025-38259, CVE-2025-38313, CVE-2025-38456, CVE-2025-38708, CVE-2025-39701, CVE-2025-39749, CVE-2022-50234, CVE-2025-39810, CVE-2022-50384, CVE-2022-50411, CVE-2025-39905, CVE-2025-39911, CVE-2023-53454, CVE-2023-53500, CVE-2023-53556, CVE-2023-53559, CVE-2023-53604, CVE-2022-50543, CVE-2023-53659, CVE-2023-53668, CVE-2023-54207, CVE-2026-23068, CVE-2026-23209, CVE-2026-23397, CVE-2026-31489, CVE-2026-31576, CVE-2026-31583  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_F2FS_FS` not set](#f2fs-filesystem) | CVE-2023-52436, CVE-2023-52444, CVE-2023-52588, CVE-2023-52682, CVE-2023-52748, CVE-2023-52852, CVE-2024-39467, CVE-2024-42160, CVE-2024-44942, CVE-2024-47691, CVE-2024-41935, CVE-2022-49738, CVE-2025-37739, CVE-2025-38579, CVE-2025-38652, CVE-2025-38677, CVE-2022-50270, CVE-2023-53214, CVE-2023-53301, CVE-2023-53537, CVE-2026-23234, CVE-2026-23235  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_AMDGPU` not set](#amdgpu-driver) | CVE-2023-51042, CVE-2023-52624, CVE-2024-26699, CVE-2024-27045, CVE-2023-52691, CVE-2023-52812, CVE-2023-52818, CVE-2024-36914, CVE-2024-38552, CVE-2024-38581, CVE-2024-39471, CVE-2024-42118, CVE-2024-42119, CVE-2024-42120, CVE-2024-42121, CVE-2024-42228, CVE-2024-44977, CVE-2024-46722, CVE-2024-46723, CVE-2024-46724, CVE-2024-46729, CVE-2024-46804, CVE-2024-46811, CVE-2024-46813, CVE-2024-46814, CVE-2024-46815, CVE-2024-46818, CVE-2024-46871, CVE-2024-49894, CVE-2024-49895, CVE-2024-49969, CVE-2024-49989, CVE-2024-49991, CVE-2022-48990, CVE-2023-52921, CVE-2024-50282, CVE-2024-53108, CVE-2024-53133, CVE-2024-56551, CVE-2024-56608, CVE-2024-56775, CVE-2024-56784, CVE-2025-21780, CVE-2025-21968, CVE-2025-21985, CVE-2023-53077, CVE-2025-37903, CVE-2022-49969, CVE-2025-38361, CVE-2022-50303, CVE-2023-53471, CVE-2023-52469, CVE-2024-41011, CVE-2024-46731, CVE-2024-46821, CVE-2025-37854  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IP_DCCP` not set](#dccp-protocol) | CVE-2023-39197, CVE-2024-36904, CVE-2024-50154, CVE-2023-53333  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TLS` not set](#config-tls) | CVE-2024-0646, CVE-2024-58240, CVE-2025-40149  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ROSE` not set](#config-rose) | CVE-2023-51782, CVE-2025-21718, CVE-2025-38377, CVE-2025-39826  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ATM` not set](#atm-protocol) | CVE-2023-51780, CVE-2023-52578, CVE-2024-26895, CVE-2024-44998, CVE-2025-38180, CVE-2025-38236, CVE-2025-38245, CVE-2025-38323, CVE-2025-38459, CVE-2025-39828, CVE-2025-39839  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CIFS` not set](#cifs-smb-client) | CVE-2023-1194, CVE-2023-52434, CVE-2023-52440, CVE-2023-52572, CVE-2024-26928, CVE-2024-35861, CVE-2024-35862, CVE-2024-35864, CVE-2024-35866, CVE-2024-35867, CVE-2024-35868, CVE-2023-52741, CVE-2023-52751, CVE-2023-52752, CVE-2023-52757, CVE-2024-49996, CVE-2024-50047, CVE-2024-50151, CVE-2024-53179, CVE-2025-38051, CVE-2025-38527, CVE-2025-38728, CVE-2023-53427  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NVME_CORE` not set](#nvme-driver) | CVE-2023-5178, CVE-2023-6356, CVE-2023-6536, CVE-2022-48658, CVE-2022-48686, CVE-2024-41073, CVE-2024-58069, CVE-2025-21927, CVE-2023-53116, CVE-2025-39783  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CEPH_FS` not set](#ceph-filesystem) | CVE-2023-44466, CVE-2024-26689, CVE-2022-49770, CVE-2025-39880, CVE-2025-71116, CVE-2026-22984, CVE-2026-31580  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HFS_FS` not set](#hfs-filesystem) | CVE-2023-4623, CVE-2024-26982, CVE-2024-46744, CVE-2025-21702, CVE-2025-37797, CVE-2025-37823, CVE-2025-37890, CVE-2025-38000, CVE-2025-38415, CVE-2025-38715, CVE-2026-23388  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SMB_SERVER` not set](#config-smb-server) | CVE-2023-32250, CVE-2023-32254, CVE-2023-32247, CVE-2023-32248, CVE-2023-32252, CVE-2023-32257, CVE-2023-32258, CVE-2024-22705, CVE-2023-52441, CVE-2024-26592, CVE-2024-26594, CVE-2023-52480, CVE-2024-26936, CVE-2024-26952, CVE-2024-26954, CVE-2024-50086, CVE-2024-50283, CVE-2024-50286, CVE-2024-56626, CVE-2024-56627, CVE-2025-21945, CVE-2025-21946, CVE-2025-21967, CVE-2025-22038, CVE-2025-22039, CVE-2025-37776, CVE-2025-37777, CVE-2025-37778, CVE-2025-37899, CVE-2025-37924, CVE-2025-37926, CVE-2025-37947, CVE-2025-37952, CVE-2025-38437, CVE-2025-38501, CVE-2023-3865, CVE-2023-3867, CVE-2023-53358, CVE-2025-39943  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_CAN` not set](#can-bus) | CVE-2023-3090, CVE-2023-3389, CVE-2023-3609, CVE-2023-3611, CVE-2023-3776, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208, CVE-2023-4622, CVE-2023-4921, CVE-2023-5717, CVE-2023-46813, CVE-2023-6931, CVE-2023-6932, CVE-2023-6546, CVE-2023-6270, CVE-2024-25744, CVE-2023-52438, CVE-2023-52439, CVE-2023-52474, CVE-2023-52501, CVE-2022-47518, CVE-2022-47519, CVE-2022-47520, CVE-2022-47521, CVE-2023-2235, CVE-2023-2156, CVE-2023-52519, CVE-2023-52614, CVE-2024-26669, CVE-2023-52637, CVE-2024-26898, CVE-2022-48655, CVE-2024-26951, CVE-2024-26961, CVE-2024-26974, CVE-2024-35855, CVE-2024-35871, CVE-2024-35937, CVE-2023-52701, CVE-2023-52707, CVE-2023-52772, CVE-2023-52846, CVE-2023-52854, CVE-2024-36934, CVE-2024-36974, CVE-2024-38599, CVE-2024-38610, CVE-2024-39277, CVE-2023-52340, CVE-2024-39494, CVE-2024-40900, CVE-2024-40913, CVE-2024-40935, CVE-2024-40994, CVE-2024-41040, CVE-2024-42093, CVE-2024-42094, CVE-2024-42313, CVE-2024-43842, CVE-2024-43882, CVE-2022-48872, CVE-2022-48874, CVE-2022-48892, CVE-2023-52906, CVE-2024-44934, CVE-2024-46740, CVE-2024-46854, CVE-2024-47659, CVE-2024-47727, CVE-2024-47745, CVE-2024-47750, CVE-2024-49853, CVE-2024-49854, CVE-2022-48988, CVE-2022-48991, CVE-2022-49006, CVE-2022-49031, CVE-2022-49032, CVE-2024-50036, CVE-2024-50059, CVE-2024-50061, CVE-2024-50073, CVE-2024-50074, CVE-2024-50209, CVE-2024-50264, CVE-2024-50268, CVE-2024-50275, CVE-2024-50301, CVE-2024-53104, CVE-2024-53166, CVE-2024-53171, CVE-2024-53203, CVE-2024-56570, CVE-2024-56603, CVE-2024-56651, CVE-2024-52332, CVE-2024-57850, CVE-2024-57904, CVE-2024-57929, CVE-2025-21687, CVE-2025-21704, CVE-2024-57982, CVE-2025-21791, CVE-2025-21855, CVE-2023-53000, CVE-2025-21919, CVE-2025-21920, CVE-2025-21928, CVE-2025-22107, CVE-2025-23157, CVE-2025-37786, CVE-2022-49775, CVE-2022-49779, CVE-2022-49900, CVE-2023-53135, CVE-2025-37839, CVE-2025-37892, CVE-2025-37927, CVE-2025-37928, CVE-2025-37991, CVE-2025-38004, CVE-2025-38081, CVE-2022-49939, CVE-2022-49948, CVE-2025-38102, CVE-2025-38108, CVE-2025-38129, CVE-2025-38248, CVE-2025-38342, CVE-2025-38346, CVE-2025-38375, CVE-2025-38445, CVE-2025-38535, CVE-2025-38595, CVE-2025-38666, CVE-2025-38679, CVE-2025-38680, CVE-2025-38722, CVE-2025-39683, CVE-2025-39687, CVE-2025-39689, CVE-2025-39766, CVE-2025-39797, CVE-2022-50255, CVE-2023-53148, CVE-2023-53153, CVE-2023-53215, CVE-2023-53232, CVE-2023-53259, CVE-2023-53272, CVE-2025-39817, CVE-2025-39824, CVE-2022-50394, CVE-2023-53388, CVE-2023-53446, CVE-2025-39873, CVE-2025-39877, CVE-2025-39883, CVE-2025-39901, CVE-2022-50421, CVE-2023-53465, CVE-2025-39951, CVE-2023-53536, CVE-2023-53560, CVE-2023-53569, CVE-2023-53570, CVE-2022-50552, CVE-2025-71073, CVE-2025-71089, CVE-2025-71093, CVE-2025-71152, CVE-2025-71162, CVE-2026-23073, CVE-2026-23074, CVE-2026-23102, CVE-2026-23171, CVE-2025-71221, CVE-2026-23221, CVE-2026-23227, CVE-2026-23361, CVE-2026-31788, CVE-2026-23410, CVE-2026-23411, CVE-2026-31527, CVE-2026-31532, CVE-2026-31582  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_CLS_FLOWER` not set](#tc-cls-flower) | CVE-2023-35788 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NTFS3_FS` not set](#config-ntfs3-fs) | CVE-2022-48502, CVE-2023-26606, CVE-2023-52640, CVE-2024-50242, CVE-2024-50246, CVE-2024-50247, CVE-2025-38707, CVE-2025-39691, CVE-2023-53194, CVE-2023-53420, CVE-2022-50442, CVE-2023-53486, CVE-2022-50507  | <span class="badge badge-erased">Not Affected</span> |

### BPF Syscall Interface

**Status**: Not Affected  
**Config gate**: `CONFIG_BPF_SYSCALL` not set  
**CVEs covered**: CVE-2021-20194

The BPF syscall interface is the kernel entry point through which user-space programs load and run BPF programs in kernel context. CVE-2021-20194 describes a heap overflow in the BPF verifier reachable by a local user who submits a crafted BPF program, gaining elevated privilege.

`CONFIG_BPF_SYSCALL` is not compiled into the HeartSuite Core Secure kernel. The `bpf()` syscall is not available — any call to it returns `ENOSYS`. There is no verifier, no BPF program store, and no reachable code path for this CVE.

### Netfilter nftables

**Status**: Not Affected  
**Config gate**: `CONFIG_NF_TABLES` not set  
**CVEs covered**: CVE-2023-32233, CVE-2023-0179

nftables is the in-kernel packet classification and filtering framework. CVE-2023-32233 describes a use-after-free in anonymous set handling reachable via crafted netlink messages by a local user with `CAP_NET_ADMIN`. CVE-2023-0179 describes a stack-based buffer overflow in the nftables netlink implementation reachable from a user namespace.

`CONFIG_NF_TABLES` is not compiled into the HeartSuite Core Secure kernel. The nftables subsystem is not present — there are no netlink handlers to reach and no set or rule objects in memory.

### Network Traffic Control Schedulers

**Status**: Not Affected  
**Config gate**: `CONFIG_NET_SCH_QFQ`, `CONFIG_NET_CLS_TCINDEX` not set  
**CVEs covered**: CVE-2023-31436, CVE-2023-1829, CVE-2023-1281

These CVEs cover two traffic control components: the QFQ (Quick Fair Queueing) scheduler and the TCINDEX traffic control filter. CVE-2023-31436 describes an out-of-bounds write in the QFQ scheduler reachable via `tc qdisc add`. CVE-2023-1829 and CVE-2023-1281 both describe use-after-free conditions in the TCINDEX filter reachable by a local user with `CAP_NET_ADMIN`.

Neither `CONFIG_NET_SCH_QFQ` nor the TCINDEX traffic control filter is compiled into the HeartSuite Core Secure kernel. The relevant scheduler and filter code does not exist and cannot be reached via `tc`.

### Bluetooth Stack

**Status**: Not Affected  
**Config gate**: `CONFIG_BT` not set  
**CVEs covered**: CVE-2022-42896, CVE-2022-45934, CVE-2022-3564, CVE-2022-3640, CVE-2023-1989, and 3 additional CVEs in this group

These CVEs cover the kernel Bluetooth stack across the L2CAP, HCI, and RFCOMM layers. They include type confusion, use-after-free, and memory corruption conditions reachable by an attacker in proximity to the target device over Bluetooth, or by a local user with socket access to the Bluetooth subsystem.

`CONFIG_BT` is not compiled into the HeartSuite Core Secure kernel. The Bluetooth socket family, HCI layer, and all Bluetooth protocol drivers are not present — there is no reachable code path for any CVE in this group.

### Protocol Families: TLS, RDS, ROSE, MCTP, and AF_RXRPC

**Status**: Not Affected  
**Config gate**: `CONFIG_TLS`, `CONFIG_RDS`, `CONFIG_ROSE`, `CONFIG_MCTP`, `CONFIG_AF_RXRPC` not set  
**CVEs covered**: CVE-2023-28466, CVE-2023-1078, CVE-2022-2961, CVE-2022-3977, CVE-2023-2006

These CVEs cover five distinct socket protocol families, each gated by its own config option:

- **TLS** (CVE-2023-28466) — a race condition in the in-kernel TLS record layer reachable via a socket configured with `SO_TLS_TX`
- **RDS** (CVE-2023-1078) — a heap out-of-bounds write in the Reliable Datagram Sockets implementation
- **ROSE** (CVE-2022-2961) — a race condition in the X.25 ROSE packet radio protocol socket layer
- **MCTP** (CVE-2022-3977) — a use-after-free in the Management Component Transport Protocol socket layer
- **AF_RXRPC** (CVE-2023-2006) — a race condition in the RxRPC remote procedure call socket family

None of these protocol families is compiled into the HeartSuite Core Secure kernel. Attempting to open a socket in any of them returns `EAFNOSUPPORT` — there is no reachable code path for any CVE in this group.

### NFS Server

**Status**: Not Affected  
**Config gate**: `CONFIG_NFSD` not set  
**CVEs covered**: CVE-2022-43945, CVE-2022-4379, CVE-2023-1652

The kernel NFS server (`nfsd`) allows a Linux host to export filesystems to NFS clients over the network. CVE-2022-43945 describes a buffer overflow in the NFSv4 XDR decoder reachable from the network. CVE-2022-4379 describes a use-after-free in the NFSv4.1 `setclientid_confirm` handler. CVE-2023-1652 describes a use-after-free in the NFSv4 lease handling.

`CONFIG_NFSD` is not compiled into the HeartSuite Core Secure kernel. The kernel NFS server is not present — no NFS exports are possible and there is no reachable code path for any CVE in this group.

### Filesystem Drivers

**Status**: Not Affected  
**Config gate**: `CONFIG_NTFS3_FS`, `CONFIG_NTFS_FS`, `CONFIG_XFS_FS`, `CONFIG_JFS_FS`, `CONFIG_NILFS2_FS` not set  
**CVEs covered**: CVE-2022-48423, CVE-2022-48424, CVE-2022-48425, CVE-2023-26544, CVE-2023-26506, CVE-2023-26507, CVE-2023-2124, CVE-2020-27815, CVE-2022-2978

These CVEs cover five filesystem drivers absent from the HeartSuite Core Secure kernel. The CVEs include out-of-bounds reads and writes and use-after-free conditions across the NTFS3 driver (`CONFIG_NTFS3_FS`), the legacy NTFS driver (`CONFIG_NTFS_FS`), XFS (`CONFIG_XFS_FS`), JFS (`CONFIG_JFS_FS`), and NILFS2 (`CONFIG_NILFS2_FS`). Several are triggerable by mounting a crafted filesystem image.

None of these filesystems is compiled into the HeartSuite Core Secure kernel. Mounting an image in any of these formats returns an error — the filesystem code does not exist in the running kernel and there is no reachable code path for any CVE in this group.

### Hardware-Specific and Virtualization Drivers

**Status**: Not Affected  
**Config gate**: `CONFIG_DVB_CORE`, `CONFIG_SGI_GRU`, `CONFIG_FPGA`, `CONFIG_KVM_INTEL` not set  
**CVEs covered**: CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919, CVE-2022-3424, CVE-2023-26242, CVE-2022-2196

These CVEs cover four hardware-specific drivers absent from the HeartSuite Core Secure kernel:

- **DVB Core** (CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919) — use-after-free conditions in the Digital Video Broadcast core driver, reachable by a local user with access to a DVB device
- **SGI GRU** (CVE-2022-3424) — a use-after-free in the SGI UV coprocessor driver triggered via `ioctl` on the GRU device
- **Intel FPGA** (CVE-2023-26242) — a memory safety issue in the Intel FPGA BMC secure update driver
- **KVM Intel** (CVE-2022-2196) — a guest-to-host isolation bypass in nested VMX (nVMX) handling, reachable from inside a guest VM

`CONFIG_DVB_CORE`, `CONFIG_SGI_GRU`, the Intel FPGA driver, and `CONFIG_KVM_INTEL` are not compiled into the HeartSuite Core Secure kernel. HeartSuite Core Secure runs as a guest under other hypervisors — it does not host virtual machines. None of the hardware interfaces these drivers expose is available, and there is no reachable code path for any CVE in this group.

### USB Network Adapter and SMB Server

**Status**: Not Affected  
**Config gate**: `CONFIG_USB_NET_RNDIS_WLAN`, `CONFIG_SMB_SERVER` not set  
**CVEs covered**: CVE-2023-23559, CVE-2023-0210

- **USB RNDIS WLAN** (CVE-2023-23559) — an integer overflow in the RNDIS wireless USB adapter driver triggerable by a physically present attacker with a crafted USB device
- **SMB Server / ksmbd** (CVE-2023-0210) — a heap out-of-bounds read in `ksmbd`, the in-kernel SMB server, reachable from the network without authentication via a crafted SMB2 `NEGOTIATE` request

Neither `CONFIG_USB_NET_RNDIS_WLAN` nor `CONFIG_SMB_SERVER` is compiled into the HeartSuite Core Secure kernel. There is no RNDIS driver to probe and no `ksmbd` listener to reach — there is no reachable code path for either CVE in this group.

### Ntfs3 Fs {#config-ntfs3-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_NTFS3_FS` not set
**CVEs covered**: CVE-2022-48502

`CONFIG_NTFS3_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Traffic Control: cls_flower {#tc-cls-flower}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_CLS_FLOWER` not set
**CVEs covered**: CVE-2023-35788

`CONFIG_NET_CLS_FLOWER` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### CAN Bus

**Status**: Not Affected
**Config gate**: `CONFIG_CAN` not set
**CVEs covered**: CVE-2023-3090, CVE-2023-3389, CVE-2023-3609, CVE-2023-3611, CVE-2023-3776, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208, CVE-2023-4622, CVE-2023-4921, CVE-2023-5717, CVE-2023-46813, CVE-2023-6931, CVE-2023-6932, CVE-2023-6546, CVE-2023-6270, CVE-2024-25744, CVE-2023-52438, CVE-2023-52439, CVE-2023-52474, CVE-2023-52501

`CONFIG_CAN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Smb Server {#config-smb-server}

**Status**: Not Affected
**Config gate**: `CONFIG_SMB_SERVER` not set
**CVEs covered**: CVE-2023-32250, CVE-2023-32254, CVE-2023-32247, CVE-2023-32248, CVE-2023-32252, CVE-2023-32257, CVE-2023-32258, CVE-2024-22705, CVE-2023-52441, CVE-2024-26592, CVE-2024-26594, CVE-2023-52480

`CONFIG_SMB_SERVER` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### HFS Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_HFS_FS` not set
**CVEs covered**: CVE-2023-4623

`CONFIG_HFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ceph Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_CEPH_FS` not set
**CVEs covered**: CVE-2023-44466

`CONFIG_CEPH_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### NVMe Driver

**Status**: Not Affected
**Config gate**: `CONFIG_NVME_CORE` not set
**CVEs covered**: CVE-2023-5178, CVE-2023-6356, CVE-2023-6536

`CONFIG_NVME_CORE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### CIFS/SMB Client {#cifs-smb-client}

**Status**: Not Affected
**Config gate**: `CONFIG_CIFS` not set
**CVEs covered**: CVE-2023-1194, CVE-2023-52434, CVE-2023-52440

`CONFIG_CIFS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### ATM Protocol

**Status**: Not Affected
**Config gate**: `CONFIG_ATM` not set
**CVEs covered**: CVE-2023-51780

`CONFIG_ATM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Rose {#config-rose}

**Status**: Not Affected
**Config gate**: `CONFIG_ROSE` not set
**CVEs covered**: CVE-2023-51782

`CONFIG_ROSE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Tls {#config-tls}

**Status**: Not Affected
**Config gate**: `CONFIG_TLS` not set
**CVEs covered**: CVE-2024-0646

`CONFIG_TLS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### DCCP Protocol

**Status**: Not Affected
**Config gate**: `CONFIG_IP_DCCP` not set
**CVEs covered**: CVE-2023-39197

`CONFIG_IP_DCCP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### AMD GPU (amdgpu) {#amdgpu-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_AMDGPU` not set
**CVEs covered**: CVE-2023-51042

`CONFIG_DRM_AMDGPU` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### F2FS Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_F2FS_FS` not set
**CVEs covered**: CVE-2023-52436, CVE-2023-52444

`CONFIG_F2FS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Atheros Wireless Driver {#ath-wireless-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_ATH` not set
**CVEs covered**: CVE-2023-52464

`CONFIG_ATH` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mctp {#config-mctp}

**Status**: Not Affected
**Config gate**: `CONFIG_MCTP` not set
**CVEs covered**: CVE-2023-52483

`CONFIG_MCTP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### FUSE Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_FUSE_FS` not set
**CVEs covered**: CVE-2023-52504

`CONFIG_FUSE_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### NFC

**Status**: Not Affected
**Config gate**: `CONFIG_NFC` not set
**CVEs covered**: CVE-2023-52507

`CONFIG_NFC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Renesas Ethernet AVB Driver {#ravb-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RAVB` not set
**CVEs covered**: CVE-2023-52509

`CONFIG_RAVB` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### IEEE 802.15.4 (WPAN) {#ieee802154-wpan}

**Status**: Not Affected
**Config gate**: `CONFIG_IEEE802154` not set
**CVEs covered**: CVE-2023-52510

`CONFIG_IEEE802154` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### InfiniBand / RDMA {#infiniband-rdma}

**Status**: Not Affected
**Config gate**: `CONFIG_INFINIBAND` not set
**CVEs covered**: CVE-2023-52515, CVE-2024-26872

`CONFIG_INFINIBAND` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Spi Sun6I {#config-spi-sun6i}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_SUN6I` not set
**CVEs covered**: CVE-2023-52517

`CONFIG_SPI_SUN6I` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Intel WiFi (iwlwifi) {#iwlwifi-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_IWLWIFI` not set
**CVEs covered**: CVE-2023-52531, CVE-2024-26610

`CONFIG_IWLWIFI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Security Tomoyo {#config-security-tomoyo}

**Status**: Not Affected
**Config gate**: `CONFIG_SECURITY_TOMOYO` not set
**CVEs covered**: CVE-2024-26622

`CONFIG_SECURITY_TOMOYO` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Drm Msm {#config-drm-msm}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_MSM` not set
**CVEs covered**: CVE-2023-52586

`CONFIG_DRM_MSM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### S390 {#config-s390}

**Status**: Not Affected
**Config gate**: `CONFIG_S390` not set
**CVEs covered**: CVE-2023-52598, CVE-2024-26957

`CONFIG_S390` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Jfs Fs {#config-jfs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_JFS_FS` not set
**CVEs covered**: CVE-2023-52599, CVE-2023-52600, CVE-2023-52603, CVE-2023-52604

`CONFIG_JFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Llc {#config-llc}

**Status**: Not Affected
**Config gate**: `CONFIG_LLC` not set
**CVEs covered**: CVE-2024-26625

`CONFIG_LLC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mhi Bus {#config-mhi-bus}

**Status**: Not Affected
**Config gate**: `CONFIG_MHI_BUS` not set
**CVEs covered**: CVE-2023-52494

`CONFIG_MHI_BUS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ip Tunnel {#config-ip-tunnel}

**Status**: Not Affected
**Config gate**: `CONFIG_IP_TUNNEL` not set
**CVEs covered**: CVE-2024-26665

`CONFIG_IP_TUNNEL` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Afs Fs {#config-afs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_AFS_FS` not set
**CVEs covered**: CVE-2024-26736

`CONFIG_AFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Traffic Control: act_mirred {#tc-act-mirred}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_ACT_MIRRED` not set
**CVEs covered**: CVE-2024-26739

`CONFIG_NET_ACT_MIRRED` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Usb Cdns3 {#config-usb-cdns3}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_CDNS3` not set
**CVEs covered**: CVE-2024-26748, CVE-2024-26749

`CONFIG_USB_CDNS3` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Crypto Dev Virtio {#config-crypto-dev-virtio}

**Status**: Not Affected
**Config gate**: `CONFIG_CRYPTO_DEV_VIRTIO` not set
**CVEs covered**: CVE-2024-26753

`CONFIG_CRYPTO_DEV_VIRTIO` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Gtp {#config-gtp}

**Status**: Not Affected
**Config gate**: `CONFIG_GTP` not set
**CVEs covered**: CVE-2024-26754, CVE-2024-26793

`CONFIG_GTP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Dm Crypt {#config-dm-crypt}

**Status**: Not Affected
**Config gate**: `CONFIG_DM_CRYPT` not set
**CVEs covered**: CVE-2024-26763

`CONFIG_DM_CRYPT` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### MPTCP

**Status**: Not Affected
**Config gate**: `CONFIG_MPTCP` not set
**CVEs covered**: CVE-2024-26782

`CONFIG_MPTCP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Btrfs Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_BTRFS_FS` not set
**CVEs covered**: CVE-2024-26791, CVE-2024-26944, CVE-2024-35849, CVE-2024-35949, CVE-2024-39496, CVE-2024-42314, CVE-2024-50217, CVE-2024-56581, CVE-2024-56582, CVE-2024-56759, CVE-2024-57896, CVE-2025-39738, CVE-2025-39759, CVE-2022-50300

`CONFIG_BTRFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Thinkpad Lmi {#config-thinkpad-lmi}

**Status**: Not Affected
**Config gate**: `CONFIG_THINKPAD_LMI` not set
**CVEs covered**: CVE-2024-26836

`CONFIG_THINKPAD_LMI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Sparx5 Switch {#config-sparx5-switch}

**Status**: Not Affected
**Config gate**: `CONFIG_SPARX5_SWITCH` not set
**CVEs covered**: CVE-2024-26856

`CONFIG_SPARX5_SWITCH` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Rds {#config-rds}

**Status**: Not Affected
**Config gate**: `CONFIG_RDS` not set
**CVEs covered**: CVE-2024-26865, CVE-2022-48637, CVE-2024-27024

`CONFIG_RDS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### TUN/TAP Driver {#tun-tap-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_TUN` not set
**CVEs covered**: CVE-2024-26882

`CONFIG_TUN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mlxbf I2C {#config-mlxbf-i2c}

**Status**: Not Affected
**Config gate**: `CONFIG_MLXBF_I2C` not set
**CVEs covered**: CVE-2022-48632

`CONFIG_MLXBF_I2C` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### ARM64 Architecture {#arm64-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_ARM64` not set
**CVEs covered**: CVE-2022-48657, CVE-2024-26989

`CONFIG_ARM64` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Nilfs2 Fs {#config-nilfs2-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_NILFS2_FS` not set
**CVEs covered**: CVE-2024-26955, CVE-2024-26956, CVE-2024-26981

`CONFIG_NILFS2_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Common Clk Qcom {#config-common-clk-qcom}

**Status**: Not Affected
**Config gate**: `CONFIG_COMMON_CLK_QCOM` not set
**CVEs covered**: CVE-2024-26965

`CONFIG_COMMON_CLK_QCOM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### USB Gadget

**Status**: Not Affected
**Config gate**: `CONFIG_USB_GADGET` not set
**CVEs covered**: CVE-2024-26996

`CONFIG_USB_GADGET` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Nouveau (NVIDIA open-source) {#nouveau-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_NOUVEAU` not set
**CVEs covered**: CVE-2024-27008

`CONFIG_DRM_NOUVEAU` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Dvb Core {#config-dvb-core}

**Status**: Not Affected
**Config gate**: `CONFIG_DVB_CORE` not set
**CVEs covered**: CVE-2024-27075

`CONFIG_DVB_CORE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Peci {#config-peci}

**Status**: Not Affected
**Config gate**: `CONFIG_PECI` not set
**CVEs covered**: CVE-2022-48670

`CONFIG_PECI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Of {#config-of}

**Status**: Not Affected
**Config gate**: `CONFIG_OF` not set
**CVEs covered**: CVE-2022-48672

`CONFIG_OF` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### EROFS Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_EROFS_FS` not set
**CVEs covered**: CVE-2022-48674

`CONFIG_EROFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Open vSwitch {#openvswitch}

**Status**: Not Affected
**Config gate**: `CONFIG_OPENVSWITCH` not set
**CVEs covered**: CVE-2024-27395

`CONFIG_OPENVSWITCH` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### FireWire

**Status**: Not Affected
**Config gate**: `CONFIG_FIREWIRE` not set
**CVEs covered**: CVE-2024-27401

`CONFIG_FIREWIRE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Kvm {#config-kvm}

**Status**: Not Affected
**Config gate**: `CONFIG_KVM` not set
**CVEs covered**: CVE-2024-35791

`CONFIG_KVM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Aquantia Atlantic Driver {#atlantic-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_ATLANTIC` not set
**CVEs covered**: CVE-2023-52664

`CONFIG_ATLANTIC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mellanox mlx5 Driver {#mlx5-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_MLX5_CORE` not set
**CVEs covered**: CVE-2023-52667

`CONFIG_MLX5_CORE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### AX.25 / Ham Radio {#ax25-hamradio}

**Status**: Not Affected
**Config gate**: `CONFIG_AX25` not set
**CVEs covered**: CVE-2024-35887

`CONFIG_AX25` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Dma Direct Remap {#config-dma-direct-remap}

**Status**: Not Affected
**Config gate**: `CONFIG_DMA_DIRECT_REMAP` not set
**CVEs covered**: CVE-2024-35939

`CONFIG_DMA_DIRECT_REMAP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Fb {#config-fb}

**Status**: Not Affected
**Config gate**: `CONFIG_FB` not set
**CVEs covered**: CVE-2023-52731

`CONFIG_FB` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### GFS2 Shared Filesystem {#gfs2-filesystem}

**Status**: Not Affected
**Config gate**: `CONFIG_GFS2_FS` not set
**CVEs covered**: CVE-2023-52760

`CONFIG_GFS2_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### GSPCA USB Webcam Driver {#gspca-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_GSPCA_CORE` not set
**CVEs covered**: CVE-2023-52764

`CONFIG_USB_GSPCA_CORE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### SMC (RDMA over Converged Ethernet) {#smc-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_SMC` not set
**CVEs covered**: CVE-2023-52775

`CONFIG_SMC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### IPVLAN Driver {#ipvlan}

**Status**: Not Affected
**Config gate**: `CONFIG_IPVLAN` not set
**CVEs covered**: CVE-2023-52796

`CONFIG_IPVLAN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### HiSilicon HNS3 Driver {#hns3-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_HNS3` not set
**CVEs covered**: CVE-2023-52807

`CONFIG_HNS3` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### KVM AMD

**Status**: Not Affected
**Config gate**: `CONFIG_KVM_AMD` not set
**CVEs covered**: CVE-2023-52816

`CONFIG_KVM_AMD` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Network Block Device (NBD) {#nbd-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_BLK_DEV_NBD` not set
**CVEs covered**: CVE-2023-52837

`CONFIG_BLK_DEV_NBD` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Synaptics RMI4 Driver {#rmi4-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RMI4_CORE` not set
**CVEs covered**: CVE-2023-52840

`CONFIG_RMI4_CORE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Bt848 Video Capture Driver {#bttv-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_BT848` not set
**CVEs covered**: CVE-2023-52847

`CONFIG_VIDEO_BT848` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Hw Perf Events Hisi {#config-hw-perf-events-hisi}

**Status**: Not Affected
**Config gate**: `CONFIG_HW_PERF_EVENTS_HISI` not set
**CVEs covered**: CVE-2023-52859

`CONFIG_HW_PERF_EVENTS_HISI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### WMI Driver

**Status**: Not Affected
**Config gate**: `CONFIG_WMI` not set
**CVEs covered**: CVE-2023-52864

`CONFIG_WMI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### AMD Radeon GPU {#radeon-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_RADEON` not set
**CVEs covered**: CVE-2023-52867

`CONFIG_DRM_RADEON` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Parallel Port Device {#ppdev-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_PPDEV` not set
**CVEs covered**: CVE-2024-36015

`CONFIG_PPDEV` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### TIPC Protocol

**Status**: Not Affected
**Config gate**: `CONFIG_TIPC` not set
**CVEs covered**: CVE-2024-36886

`CONFIG_TIPC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### GPIO Library {#gpiolib}

**Status**: Not Affected
**Config gate**: `CONFIG_GPIOLIB` not set
**CVEs covered**: CVE-2024-36898, CVE-2024-36899

`CONFIG_GPIOLIB` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Pin Controller Subsystem {#pinctrl}

**Status**: Not Affected
**Config gate**: `CONFIG_PINCTRL` not set
**CVEs covered**: CVE-2024-36940

`CONFIG_PINCTRL` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### VMware SVGA (vmwgfx) {#vmwgfx-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_VMWGFX` not set
**CVEs covered**: CVE-2024-36960

`CONFIG_DRM_VMWGFX` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Traffic Control: sch_multiq {#tc-multiq}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_SCH_MULTIQ` not set
**CVEs covered**: CVE-2024-36978

`CONFIG_NET_SCH_MULTIQ` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### IMA (Integrity Measurement Architecture) {#ima}

**Status**: Not Affected
**Config gate**: `CONFIG_IMA` not set
**CVEs covered**: CVE-2024-38667

`CONFIG_IMA` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### PowerPC Architecture {#powerpc-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_PPC` not set
**CVEs covered**: CVE-2024-40974

`CONFIG_PPC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Xfs Fs {#config-xfs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_XFS_FS` not set
**CVEs covered**: CVE-2024-41013, CVE-2024-41014

`CONFIG_XFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### HFS+ Filesystem {#hfsplus-filesystem}

**Status**: Not Affected
**Config gate**: `CONFIG_HFSPLUS_FS` not set
**CVEs covered**: CVE-2024-41059

`CONFIG_HFSPLUS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### ISDN

**Status**: Not Affected
**Config gate**: `CONFIG_ISDN` not set
**CVEs covered**: CVE-2024-42280

`CONFIG_ISDN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Platform X86 {#config-platform-x86}

**Status**: Not Affected
**Config gate**: `CONFIG_PLATFORM_X86` not set
**CVEs covered**: CVE-2024-46859

`CONFIG_PLATFORM_X86` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### OCFS2 Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_OCFS2_FS` not set
**CVEs covered**: CVE-2024-47670

`CONFIG_OCFS2_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Xen Hypervisor

**Status**: Not Affected
**Config gate**: `CONFIG_XEN` not set
**CVEs covered**: CVE-2024-49936

`CONFIG_XEN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### PPP

**Status**: Not Affected
**Config gate**: `CONFIG_PPP` not set
**CVEs covered**: CVE-2024-50033, CVE-2024-50035

`CONFIG_PPP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### QCOM RmNet Driver {#rmnet-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RMNET` not set
**CVEs covered**: CVE-2024-50128

`CONFIG_RMNET` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### UDF Filesystem

**Status**: Not Affected
**Config gate**: `CONFIG_UDF_FS` not set
**CVEs covered**: CVE-2024-50143

`CONFIG_UDF_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### LoongArch Architecture {#loongarch-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_LOONGARCH` not set
**CVEs covered**: CVE-2024-56628

`CONFIG_LOONGARCH` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Realtek WiFi Driver {#rtlwifi-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RTLWIFI` not set
**CVEs covered**: CVE-2024-58072

`CONFIG_RTLWIFI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Broadcom WiFi Driver {#brcmfmac-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_BRCMFMAC` not set
**CVEs covered**: CVE-2022-49740

`CONFIG_BRCMFMAC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### MemStick Driver {#memstick}

**Status**: Not Affected
**Config gate**: `CONFIG_MEMSTICK` not set
**CVEs covered**: CVE-2025-22020

`CONFIG_MEMSTICK` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### SCTP Protocol

**Status**: Not Affected
**Config gate**: `CONFIG_IP_SCTP` not set
**CVEs covered**: CVE-2025-23142

`CONFIG_IP_SCTP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ntfs Fs {#config-ntfs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_NTFS_FS` not set
**CVEs covered**: CVE-2022-49763

`CONFIG_NTFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Net Sch Qfq {#config-net-sch-qfq}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_SCH_QFQ` not set
**CVEs covered**: CVE-2025-37913

`CONFIG_NET_SCH_QFQ` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Af Rxrpc {#config-af-rxrpc}

**Status**: Not Affected
**Config gate**: `CONFIG_AF_RXRPC` not set
**CVEs covered**: CVE-2023-53218

`CONFIG_AF_RXRPC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Marvell WiFi Driver {#mwifiex-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_MWIFIEX` not set
**CVEs covered**: CVE-2025-39891

`CONFIG_MWIFIEX` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Microchip WILC1000 WiFi Driver {#wilc1000-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_WILC1000` not set
**CVEs covered**: CVE-2025-39952

`CONFIG_WILC1000` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Traffic Control: cls_u32 {#tc-cls-u32}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_CLS_U32` not set
**CVEs covered**: CVE-2026-23204

`CONFIG_NET_CLS_U32` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### SAA7134 Media Driver {#saa7134-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_SAA7134` not set
**CVEs covered**: CVE-2023-35823

`CONFIG_VIDEO_SAA7134` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### DM1105 DVB Driver {#dm1105-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_DM1105` not set
**CVEs covered**: CVE-2023-35824

`CONFIG_VIDEO_DM1105` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Allwinner Cedrus Video Codec {#cedrus-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_SUNXI_CEDRUS` not set
**CVEs covered**: CVE-2023-35826

`CONFIG_VIDEO_SUNXI_CEDRUS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Renesas USB3 Driver {#renesas-usb3}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_RENESAS_USBHS3` not set
**CVEs covered**: CVE-2023-35828

`CONFIG_USB_RENESAS_USBHS3` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Rockchip Video Decoder {#rkvdec-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_RKVDEC` not set
**CVEs covered**: CVE-2023-35829

`CONFIG_VIDEO_RKVDEC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Intel IGB Ethernet Driver {#igb-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_IGB` not set
**CVEs covered**: CVE-2023-45871

`CONFIG_IGB` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### AppleTalk Protocol {#appletalk}

**Status**: Not Affected
**Config gate**: `CONFIG_ATALK` not set
**CVEs covered**: CVE-2023-51781

`CONFIG_ATALK` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Hauppauge pvrusb2 Driver {#pvrusb2-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_PVRUSB2` not set
**CVEs covered**: CVE-2023-52445

`CONFIG_VIDEO_PVRUSB2` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### PWM Subsystem

**Status**: Not Affected
**Config gate**: `CONFIG_PWM` not set
**CVEs covered**: CVE-2024-26599

`CONFIG_PWM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Griffin PowerMate Driver {#powermate-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_INPUT_POWERMATE` not set
**CVEs covered**: CVE-2023-52475

`CONFIG_INPUT_POWERMATE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### TEE Subsystem

**Status**: Not Affected
**Config gate**: `CONFIG_TEE` not set
**CVEs covered**: CVE-2023-52503

`CONFIG_TEE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Bonding {#config-bonding}

**Status**: Not Affected
**Config gate**: `CONFIG_BONDING` not set
**CVEs covered**: CVE-2024-39487, CVE-2026-23099

`CONFIG_BONDING` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Vmware Vmci {#config-vmware-vmci}

**Status**: Not Affected
**Config gate**: `CONFIG_VMWARE_VMCI` not set
**CVEs covered**: CVE-2024-39499, CVE-2024-46738, CVE-2025-38403

`CONFIG_VMWARE_VMCI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Wwan {#config-wwan}

**Status**: Not Affected
**Config gate**: `CONFIG_WWAN` not set
**CVEs covered**: CVE-2024-40939

`CONFIG_WWAN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Cachefiles {#config-cachefiles}

**Status**: Not Affected
**Config gate**: `CONFIG_CACHEFILES` not set
**CVEs covered**: CVE-2024-41050, CVE-2024-41057, CVE-2024-41074

`CONFIG_CACHEFILES` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Snd Soc {#config-snd-soc}

**Status**: Not Affected
**Config gate**: `CONFIG_SND_SOC` not set
**CVEs covered**: CVE-2024-41069, CVE-2022-50325

`CONFIG_SND_SOC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Iio {#config-iio}

**Status**: Not Affected
**Config gate**: `CONFIG_IIO` not set
**CVEs covered**: CVE-2024-42086, CVE-2024-57906, CVE-2024-57907, CVE-2024-57908, CVE-2024-57910, CVE-2024-57911, CVE-2024-57912, CVE-2022-49792, CVE-2025-38485

`CONFIG_IIO` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Vhost Vsock {#config-vhost-vsock}

**Status**: Not Affected
**Config gate**: `CONFIG_VHOST_VSOCK` not set
**CVEs covered**: CVE-2024-43873

`CONFIG_VHOST_VSOCK` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Net Fou {#config-net-fou}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_FOU` not set
**CVEs covered**: CVE-2024-44940, CVE-2026-23083

`CONFIG_NET_FOU` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Parisc {#config-parisc}

**Status**: Not Affected
**Config gate**: `CONFIG_PARISC` not set
**CVEs covered**: CVE-2024-44949, CVE-2022-50518

`CONFIG_PARISC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Net Sch Netem {#config-net-sch-netem}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_SCH_NETEM` not set
**CVEs covered**: CVE-2024-46800

`CONFIG_NET_SCH_NETEM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Uml {#config-uml}

**Status**: Not Affected
**Config gate**: `CONFIG_UML` not set
**CVEs covered**: CVE-2024-46844

`CONFIG_UML` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Spi Nxp Flexspi {#config-spi-nxp-flexspi}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_NXP_FLEXSPI` not set
**CVEs covered**: CVE-2024-46853

`CONFIG_SPI_NXP_FLEXSPI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Vdpa {#config-vdpa}

**Status**: Not Affected
**Config gate**: `CONFIG_VDPA` not set
**CVEs covered**: CVE-2024-47748, CVE-2024-53126, CVE-2023-53082, CVE-2023-53543

`CONFIG_VDPA` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Usb Serial {#config-usb-serial}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_SERIAL` not set
**CVEs covered**: CVE-2024-50267

`CONFIG_USB_SERIAL` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Usb Musb Hdrc {#config-usb-musb-hdrc}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_MUSB_HDRC` not set
**CVEs covered**: CVE-2024-50269

`CONFIG_USB_MUSB_HDRC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Superh {#config-superh}

**Status**: Not Affected
**Config gate**: `CONFIG_SUPERH` not set
**CVEs covered**: CVE-2024-53165

`CONFIG_SUPERH` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Spi Mpc52Xx {#config-spi-mpc52xx}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_MPC52xx` not set
**CVEs covered**: CVE-2024-50051

`CONFIG_SPI_MPC52xx` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Pktgen {#config-pktgen}

**Status**: Not Affected
**Config gate**: `CONFIG_PKTGEN` not set
**CVEs covered**: CVE-2025-21680

`CONFIG_PKTGEN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Orangefs Fs {#config-orangefs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_ORANGEFS_FS` not set
**CVEs covered**: CVE-2025-21782

`CONFIG_ORANGEFS_FS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Geneve {#config-geneve}

**Status**: Not Affected
**Config gate**: `CONFIG_GENEVE` not set
**CVEs covered**: CVE-2025-21858

`CONFIG_GENEVE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Slimbus {#config-slimbus}

**Status**: Not Affected
**Config gate**: `CONFIG_SLIMBUS` not set
**CVEs covered**: CVE-2025-21914

`CONFIG_SLIMBUS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Udmabuf {#config-udmabuf}

**Status**: Not Affected
**Config gate**: `CONFIG_UDMABUF` not set
**CVEs covered**: CVE-2025-37803

`CONFIG_UDMABUF` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mcb {#config-mcb}

**Status**: Not Affected
**Config gate**: `CONFIG_MCB` not set
**CVEs covered**: CVE-2025-37817

`CONFIG_MCB` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Staging {#config-staging}

**Status**: Not Affected
**Config gate**: `CONFIG_STAGING` not set
**CVEs covered**: CVE-2022-49956, CVE-2023-53554

`CONFIG_STAGING` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Coresight {#config-coresight}

**Status**: Not Affected
**Config gate**: `CONFIG_CORESIGHT` not set
**CVEs covered**: CVE-2025-38131

`CONFIG_CORESIGHT` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ipv6 Seg6 Lwtunnel {#config-ipv6-seg6-lwtunnel}

**Status**: Not Affected
**Config gate**: `CONFIG_IPV6_SEG6_LWTUNNEL` not set
**CVEs covered**: CVE-2025-38476

`CONFIG_IPV6_SEG6_LWTUNNEL` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Comedi {#config-comedi}

**Status**: Not Affected
**Config gate**: `CONFIG_COMEDI` not set
**CVEs covered**: CVE-2025-38482, CVE-2025-38483, CVE-2025-38529, CVE-2025-38530, CVE-2025-39685, CVE-2025-39686

`CONFIG_COMEDI` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Nubus {#config-nubus}

**Status**: Not Affected
**Config gate**: `CONFIG_NUBUS` not set
**CVEs covered**: CVE-2023-53217

`CONFIG_NUBUS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Xdp Sockets {#config-xdp-sockets}

**Status**: Not Affected
**Config gate**: `CONFIG_XDP_SOCKETS` not set
**CVEs covered**: CVE-2023-53426

`CONFIG_XDP_SOCKETS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ptp 1588 Clock Ocp {#config-ptp-1588-clock-ocp}

**Status**: Not Affected
**Config gate**: `CONFIG_PTP_1588_CLOCK_OCP` not set
**CVEs covered**: CVE-2025-39859

`CONFIG_PTP_1588_CLOCK_OCP` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Trace Buf {#config-trace-buf}

**Status**: Not Affected
**Config gate**: `CONFIG_TRACE_BUF` not set
**CVEs covered**: CVE-2023-53587

`CONFIG_TRACE_BUF` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Dlm {#config-dlm}

**Status**: Not Affected
**Config gate**: `CONFIG_DLM` not set
**CVEs covered**: CVE-2023-53629

`CONFIG_DLM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Net Team {#config-net-team}

**Status**: Not Affected
**Config gate**: `CONFIG_NET_TEAM` not set
**CVEs covered**: CVE-2025-71091

`CONFIG_NET_TEAM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Macvlan {#config-macvlan}

**Status**: Not Affected
**Config gate**: `CONFIG_MACVLAN` not set
**CVEs covered**: CVE-2026-23001

`CONFIG_MACVLAN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Security Apparmor {#config-security-apparmor}

**Status**: Not Affected
**Config gate**: `CONFIG_SECURITY_APPARMOR` not set
**CVEs covered**: CVE-2026-23408

`CONFIG_SECURITY_APPARMOR` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Rcu Nocb Cpu {#config-rcu-nocb-cpu}

**Status**: Not Affected
**Config gate**: `CONFIG_RCU_NOCB_CPU` not set
**CVEs covered**: CVE-2024-35929, CVE-2025-38704

`CONFIG_RCU_NOCB_CPU` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Debug Mutexes {#config-debug-mutexes}

**Status**: Not Affected
**Config gate**: `CONFIG_DEBUG_MUTEXES` not set
**CVEs covered**: CVE-2023-52836

`CONFIG_DEBUG_MUTEXES` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Stm {#config-stm}

**Status**: Not Affected
**Config gate**: `CONFIG_STM` not set
**CVEs covered**: CVE-2024-38627

`CONFIG_STM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Greybus {#config-greybus}

**Status**: Not Affected
**Config gate**: `CONFIG_GREYBUS` not set
**CVEs covered**: CVE-2024-39495

`CONFIG_GREYBUS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Ionic {#config-ionic}

**Status**: Not Affected
**Config gate**: `CONFIG_IONIC` not set
**CVEs covered**: CVE-2024-39502

`CONFIG_IONIC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Crypto Dev Hisi Sec2 {#config-crypto-dev-hisi-sec2}

**Status**: Not Affected
**Config gate**: `CONFIG_CRYPTO_DEV_HISI_SEC2` not set
**CVEs covered**: CVE-2024-42147, CVE-2024-47730

`CONFIG_CRYPTO_DEV_HISI_SEC2` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Bna {#config-bna}

**Status**: Not Affected
**Config gate**: `CONFIG_BNA` not set
**CVEs covered**: CVE-2024-43839

`CONFIG_BNA` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Drm Aspeed Gfx {#config-drm-aspeed-gfx}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_ASPEED_GFX` not set
**CVEs covered**: CVE-2023-52916

`CONFIG_DRM_ASPEED_GFX` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Pci Kirin {#config-pci-kirin}

**Status**: Not Affected
**Config gate**: `CONFIG_PCI_KIRIN` not set
**CVEs covered**: CVE-2024-47751

`CONFIG_PCI_KIRIN` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Drm Stm {#config-drm-stm}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_STM` not set
**CVEs covered**: CVE-2024-49992

`CONFIG_DRM_STM` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Hi Gmac {#config-hi-gmac}

**Status**: Not Affected
**Config gate**: `CONFIG_HI_GMAC` not set
**CVEs covered**: CVE-2022-48960, CVE-2022-48962

`CONFIG_HI_GMAC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Hsr {#config-hsr}

**Status**: Not Affected
**Config gate**: `CONFIG_HSR` not set
**CVEs covered**: CVE-2022-49015

`CONFIG_HSR` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Typec {#config-typec}

**Status**: Not Affected
**Config gate**: `CONFIG_TYPEC` not set
**CVEs covered**: CVE-2024-50150

`CONFIG_TYPEC` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Mse102X {#config-mse102x}

**Status**: Not Affected
**Config gate**: `CONFIG_MSE102X` not set
**CVEs covered**: CVE-2024-50276

`CONFIG_MSE102X` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Video S5P Jpeg {#config-video-s5p-jpeg}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_S5P_JPEG` not set
**CVEs covered**: CVE-2024-53061

`CONFIG_VIDEO_S5P_JPEG` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Arm Scmi Protocol {#config-arm-scmi-protocol}

**Status**: Not Affected
**Config gate**: `CONFIG_ARM_SCMI_PROTOCOL` not set
**CVEs covered**: CVE-2024-53068

`CONFIG_ARM_SCMI_PROTOCOL` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Intel Xe GPU Driver {#drm-xe-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_XE` not set
**CVEs covered**: CVE-2024-53098

`CONFIG_DRM_XE` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Hyperv Vsockets {#config-hyperv-vsockets}

**Status**: Not Affected
**Config gate**: `CONFIG_HYPERV_VSOCKETS` not set
**CVEs covered**: CVE-2024-53103

`CONFIG_HYPERV_VSOCKETS` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Usb Lan78Xx {#config-usb-lan78xx}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_LAN78XX` not set
**CVEs covered**: CVE-2024-53213

`CONFIG_USB_LAN78XX` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Drm Xlnx {#config-drm-xlnx}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_XLNX` not set
**CVEs covered**: CVE-2024-56538

`CONFIG_DRM_XLNX` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Usb Net Cdcether {#config-usb-net-cdcether}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_NET_CDCETHER` not set
**CVEs covered**: CVE-2025-38153

`CONFIG_USB_NET_CDCETHER` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Md Raid10 {#config-md-raid10}

**Status**: Not Affected
**Config gate**: `CONFIG_MD_RAID10` not set
**CVEs covered**: CVE-2023-53357

`CONFIG_MD_RAID10` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

### Video Adv748X {#config-video-adv748x}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_ADV748X` not set
**CVEs covered**: CVE-2025-71136

`CONFIG_VIDEO_ADV748X` is not compiled into the HeartSuite Core Secure kernel. There is no reachable code path for any CVE in this group.

## Scanner Guidance

When a scanner flags HeartSuite Core Secure for a CVE listed as Not Affected on this page, the result is a version-string match: the scanner has identified a kernel version older than the upstream fix but has not evaluated whether the vulnerable code path is compiled in.

Share this page with your auditor or scanner vendor as the reference for any disputed CVE entry. For compliance teams that require a configuration-level proof, the config gate for any entry on this page can be confirmed on the HeartSuite Core Secure host:

```bash
grep CONFIG_<GATE> /boot/config-$(uname -r)
```

For example, to confirm CVE-2026-31431:

```bash
$ grep CONFIG_CRYPTO_USER_API_AEAD /boot/config-$(uname -r)
CONFIG_CRYPTO_USER_API_AEAD=n
```

Replace `CONFIG_<GATE>` with the config gate listed in the relevant section. Any `=n` result confirms that config gate is not compiled into the running kernel.

## The Four Assessment Gates

Every entry on this page was verified source-first. No assumptions were made about what is compiled in, and no scanner output was taken at face value. The assessment follows four gates in order:

**Gate 1 — Is the vulnerable code compiled in?** The HeartSuite kernel configuration is checked directly against the relevant `CONFIG_` option. If the option is not set, the vulnerable code does not exist in the running kernel. The assessment stops here as Not Affected regardless of kernel version string.

**Gate 2 — Does HeartSuite's outbound connection control cover the attack path?** For socket-based CVEs, HeartSuite intercepts outbound `connect()` calls only. Attack paths that reach the kernel through socket creation, `sendmsg`, `recvmsg`, or kernel-internal crypto interfaces are not covered by this control and are noted accordingly.

**Gate 3 — Can an exploit program run?** Under Lockdown, the program allowlist is made filesystem-immutable. No new program entries can be added. An attacker-dropped exploit program has no allowlist entry and cannot execute. This gate does not apply to CVEs exploitable from within an already-running, allowlisted process.

**Gate 4 — What can root actually do under Lockdown?** When a CVE achieves root privilege, HeartSuite Lockdown applies a further constraint. The kernel refuses to clear filesystem immutable flags (`chattr -i` is blocked at the syscall level). All three mount syscall variants are blocked. Lockdown is one-way — it can only be cleared by a hardware reboot, and rebooting requires physical or serial console access to the GRUB menu. An attacker who reaches root in Lockdown has no path to persistence, cannot modify the allowlist, cannot add backdoors, and cannot survive a reboot.

The two residual risks that Lockdown does not close are in-memory data exfiltration (reading live process memory) and availability impact (crashing the system). These are noted in affected entries where relevant.

---

**The bug exists. The attack does not.**
