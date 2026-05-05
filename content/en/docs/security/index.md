---
title: "Kernel Security Transparency"
weight: 107
description: "CVE status for the HeartSuite Core Secure kernel — precise status and technical rationale for each relevant vulnerability, including Not Affected entries where the vulnerable code path is absent by design."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
type: docs
toc: true
---

**Overview**: Vulnerability scanners match on kernel version strings — when a scanner sees a kernel older than the version that introduced an upstream fix, it may flag the system as affected regardless of whether the vulnerable code path is compiled in. This page lists kernel CVEs relevant to HeartSuite Core Secure, with the exact status and technical reason for each. Auditors and compliance teams can reference it directly when reviewing scanner output.

The **Effective Score** column shows the CVSS v3.1 Environmental Score for a HeartSuite Core Secure deployment — the actual risk on your system, not the theoretical worst case. Where the attack surface is absent — hardware not present or trigger not installed — the Effective Score is 0.0 regardless of Base Score. Where the code path is reachable, the Effective Score reflects Modified Impact metrics accounting for Lockdown: Integrity Impact is reduced (MI: High→Low) because Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot. Scores are computed using CR=M, IR=M, AR=M with no Temporal adjustments.

## CVE Status

<div class="row my-4 text-center">
<div class="col-md-4">
<div class="card border-success mb-3">
<div class="card-body">
<p class="display-4 fw-bold text-success mb-0">70</p>
<p class="card-text text-muted">HIGH/CRITICAL CVEs<br><strong>reduced to Effective Score 0.0</strong><br><small>attack surface absent by design</small></p>
</div>
</div>
</div>
<div class="col-md-4">
<div class="card border-warning mb-3">
<div class="card-body">
<p class="display-4 fw-bold text-warning mb-0">115</p>
<p class="card-text text-muted">CVEs with code path reachable<br><strong>Lockdown limits post-exploitation</strong><br><small>no persistence · no allowlist changes · no reboot survival</small></p>
</div>
</div>
</div>
<div class="col-md-4">
<div class="card border-secondary mb-3">
<div class="card-body">
<p class="display-4 fw-bold text-secondary mb-0">1,000+</p>
<p class="card-text text-muted">additional CVEs<br><strong>Not Applicable — subsystem not compiled</strong><br><small>zero attack surface by kernel configuration</small></p>
</div>
</div>
</div>
</div>

| CVE | Component | Base Score | Effective Score | Status |
|-----|-----------|-----------|-----------------|--------|
| [CVE-2026-31431](#cve-2026-31431) | algif_aead (AF_ALG) | <span class="badge bg-secondary">—</span> | <span class="badge bg-success">0.0</span> | Not Affected — code not compiled in |
| [CVE-2024-47685](#cve-2024-47685) | nf_reject_ipv6 | <span class="badge bg-danger">9.1 CRITICAL</span> | <span class="badge bg-success">0.0</span> | Affected — trigger not present in default configuration |
| [CVE-2022-41674, CVE-2022-42719, CVE-2022-42720](#cve-2022-41674-cve-2022-42719-cve-2022-42720) | mac80211 | <span class="badge badge-cve-high">8.8 / 8.1 / 7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent on server deployments |
| [CVE-2023-0266](#cve-2023-0266) | ALSA PCM | <span class="badge badge-cve-high">7.9 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent on server deployments |
| [CVE-2022-4139](#cve-2022-4139) | i915 GPU | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent on server deployments |
| [CVE-2023-2236, CVE-2022-3910](#cve-2023-2236-cve-2022-3910) | io_uring | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.1–7.9 HIGH</span> | Affected — Lockdown reduces persistence and integrity impact; confidentiality and availability remain HIGH |
| [CVE-2024-0775](#cve-2024-0775) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">6.7 HIGH</span> | <span class="badge bg-warning text-dark">6.8 MEDIUM</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-52530](#cve-2023-52530) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2023-52612](#cve-2023-52612) | kernel crypto framework (`CONFIG_CRYPTO`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_CRYPTO=y`; Lockdown limits post-exploitation |
| [CVE-2024-26654](#cve-2024-26654) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-26704](#cve-2024-26704) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-26842](#cve-2024-26842) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; UFS flash storage absent on x86 server |
| [CVE-2022-48662](#cve-2022-48662) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no Intel display GPU present |
| [CVE-2024-26934](#cve-2024-26934) | USB core (`CONFIG_USB`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_USB=y`; Lockdown limits post-exploitation |
| [CVE-2024-26939](#cve-2024-26939) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no Intel display GPU present |
| [CVE-2022-48689](#cve-2022-48689) | TCP receive zerocopy (`CONFIG_INET`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2022-48701](#cve-2022-48701) | USB audio driver (`CONFIG_SND_USB_AUDIO`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Not Affected — `CONFIG_SND_USB_AUDIO` not set |
| [CVE-2022-48702](#cve-2022-48702) | EMU10K1 audio driver (`CONFIG_SND_EMU10K1`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Not Affected — `CONFIG_SND_EMU10K1` not set |
| [CVE-2022-48695](#cve-2022-48695) | mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Not Affected — `CONFIG_SCSI_MPT3SAS` not set |
| [CVE-2024-35789](#cve-2024-35789) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2024-35886](#cve-2024-35886) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2023-52835](#cve-2023-52835) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2023-52868](#cve-2023-52868) | thermal management (`CONFIG_THERMAL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_THERMAL=y`; Lockdown limits post-exploitation |
| [CVE-2024-36916](#cve-2024-36916) | block I/O cost controller (`CONFIG_BLK_CGROUP_IOCOST`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BLK_CGROUP_IOCOST=y`; Lockdown limits post-exploitation |
| [CVE-2024-38560](#cve-2024-38560) | Brocade bfa SCSI driver (`CONFIG_SCSI_BFA`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_BFA` not set |
| [CVE-2024-38588](#cve-2024-38588) | kprobes (`CONFIG_KPROBES`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_KPROBES=y`; Lockdown limits post-exploitation |
| [CVE-2024-40901](#cve-2024-40901) | LSI/Avago mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_MPT3SAS` not set |
| [CVE-2024-40978](#cve-2024-40978) | QLogic qedi iSCSI driver (`CONFIG_SCSI_QEDI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_SCSI_QEDI` not set |
| [CVE-2024-41092](#cve-2024-41092) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no Intel display GPU present |
| [CVE-2024-42136](#cve-2024-42136) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; CD-ROM drive absent on server |
| [CVE-2024-44985](#cve-2024-44985) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44986](#cve-2024-44986) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-44987](#cve-2024-44987) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-46673](#cve-2024-46673) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Adaptec aacraid RAID controller |
| [CVE-2024-46746](#cve-2024-46746) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2024-46747](#cve-2024-46747) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2024-46798](#cve-2024-46798) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-46849](#cve-2024-46849) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-47682](#cve-2024-47682) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_SCSI=y`; Lockdown limits post-exploitation |
| [CVE-2024-47701](#cve-2024-47701) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49852](#cve-2024-49852) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Emulex libefc Fibre Channel HBA |
| [CVE-2024-49882](#cve-2024-49882) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49883](#cve-2024-49883) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49884](#cve-2024-49884) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49889](#cve-2024-49889) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49960](#cve-2024-49960) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-49983](#cve-2024-49983) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-50007](#cve-2024-50007) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2022-48951](#cve-2022-48951) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2022-48956](#cve-2022-48956) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2022-49022](#cve-2022-49022) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2022-49023](#cve-2022-49023) | cfg80211 wireless framework (`CONFIG_CFG80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2024-50278](#cve-2024-50278) | device mapper (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BLK_DEV_DM=y`; Lockdown limits post-exploitation |
| [CVE-2024-50279](#cve-2024-50279) | device mapper (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BLK_DEV_DM=y`; Lockdown limits post-exploitation |
| [CVE-2024-53147](#cve-2024-53147) | FAT/exFAT filesystem (`CONFIG_FAT_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-warning text-dark">6.6 MEDIUM</span> | Affected — `CONFIG_FAT_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-53150](#cve-2024-53150) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-53170](#cve-2024-53170) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_SCSI=y`; Lockdown limits post-exploitation |
| [CVE-2024-53173](#cve-2024-53173) | NFS v4 client (`CONFIG_NFS_V4`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NFS_V4=y`; Lockdown limits post-exploitation |
| [CVE-2024-53214](#cve-2024-53214) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2024-53227](#cve-2024-53227) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Brocade bfa Fibre Channel HBA |
| [CVE-2024-53239](#cve-2024-53239) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-56609](#cve-2024-56609) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2024-56631](#cve-2024-56631) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_SCSI=y`; Lockdown limits post-exploitation |
| [CVE-2024-56663](#cve-2024-56663) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2024-57899](#cve-2024-57899) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2025-21863](#cve-2025-21863) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IO_URING=y`; Lockdown limits post-exploitation |
| [CVE-2023-52930](#cve-2023-52930) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no Intel display GPU present |
| [CVE-2023-52988](#cve-2023-52988) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2025-21993](#cve-2025-21993) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires iSCSI Boot Firmware Table (iBFT, iSCSI boot configuration) |
| [CVE-2025-22083](#cve-2025-22083) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; vhost-scsi not applicable — no KVM host mode in HS |
| [CVE-2025-22121](#cve-2025-22121) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2025-37785](#cve-2025-37785) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2025-40364](#cve-2025-40364) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IO_URING=y`; Lockdown limits post-exploitation |
| [CVE-2025-37738](#cve-2025-37738) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-49789](#cve-2022-49789) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; IBM Z Fibre Channel hardware absent |
| [CVE-2022-49842](#cve-2022-49842) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2022-49865](#cve-2022-49865) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2023-53037](#cve-2023-53037) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Broadcom mpi3mr SAS 3.0 HBA |
| [CVE-2023-53039](#cve-2023-53039) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2023-53065](#cve-2023-53065) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2025-37861](#cve-2025-37861) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Broadcom mpi3mr SAS 3.0 HBA |
| [CVE-2025-37979](#cve-2025-37979) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2022-49934](#cve-2022-49934) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2025-38103](#cve-2025-38103) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2025-38206](#cve-2025-38206) | FAT/exFAT filesystem (`CONFIG_FAT_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_FAT_FS=y`; Lockdown limits post-exploitation |
| [CVE-2025-38239](#cve-2025-38239) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires LSI MegaRAID SAS controller |
| [CVE-2025-38249](#cve-2025-38249) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2025-38389](#cve-2025-38389) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no Intel display GPU present |
| [CVE-2025-38494](#cve-2025-38494) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2025-38550](#cve-2025-38550) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-38556](#cve-2025-38556) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2025-38563](#cve-2025-38563) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2025-38565](#cve-2025-38565) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2025-38572](#cve-2025-38572) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-38699](#cve-2025-38699) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Brocade bfa Fibre Channel HBA |
| [CVE-2025-38729](#cve-2025-38729) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2025-39702](#cve-2025-39702) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2025-39757](#cve-2025-39757) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2025-39760](#cve-2025-39760) | USB core (`CONFIG_USB`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_USB=y`; Lockdown limits post-exploitation |
| [CVE-2025-39788](#cve-2025-39788) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; UFS flash storage absent on x86 server |
| [CVE-2022-50306](#cve-2022-50306) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53257](#cve-2023-53257) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2023-53282](#cve-2023-53282) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Emulex lpfc Fibre Channel HBA |
| [CVE-2023-53285](#cve-2023-53285) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53320](#cve-2023-53320) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Broadcom mpi3mr SAS 3.0 HBA |
| [CVE-2023-53321](#cve-2023-53321) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2023-53322](#cve-2023-53322) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires QLogic qla2xxx Fibre Channel HBA |
| [CVE-2022-50378](#cve-2022-50378) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Amlogic Meson ARM SoC GPU absent |
| [CVE-2023-53376](#cve-2023-53376) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Broadcom mpi3mr SAS 3.0 HBA |
| [CVE-2023-53392](#cve-2023-53392) | HID subsystem (`CONFIG_HID`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no USB HID input devices on headless server |
| [CVE-2025-39841](#cve-2025-39841) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Emulex lpfc Fibre Channel HBA |
| [CVE-2025-39864](#cve-2025-39864) | cfg80211 wireless framework (`CONFIG_CFG80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no WiFi NIC present |
| [CVE-2025-39866](#cve-2025-39866) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-50422](#cve-2022-50422) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires SAS libsas library (requires SAS HBA) |
| [CVE-2022-50432](#cve-2022-50432) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53473](#cve-2023-53473) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53510](#cve-2023-53510) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; UFS flash storage absent on x86 server |
| [CVE-2023-53521](#cve-2023-53521) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires SCSI Enclosure Services (SAS enclosure hardware) |
| [CVE-2022-50488](#cve-2022-50488) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2022-50496](#cve-2022-50496) | device mapper (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BLK_DEV_DM=y`; Lockdown limits post-exploitation |
| [CVE-2022-50546](#cve-2022-50546) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_EXT4_FS=y`; Lockdown limits post-exploitation |
| [CVE-2023-53640](#cve-2023-53640) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2023-53675](#cve-2023-53675) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires SCSI Enclosure Services (SAS enclosure hardware) |
| [CVE-2023-53676](#cve-2023-53676) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Linux iSCSI target (requires iscsi-target configuration) |
| [CVE-2025-71075](#cve-2025-71075) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Adaptec aic94xx SAS HBA |
| [CVE-2026-23076](#cve-2026-23076) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-23078](#cve-2026-23078) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-23089](#cve-2026-23089) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-23191](#cve-2026-23191) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-23193](#cve-2026-23193) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge bg-danger">9.0 CRITICAL</span> | Affected — requires Linux iSCSI target (requires iscsi-target configuration) |
| [CVE-2026-23208](#cve-2026-23208) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-23216](#cve-2026-23216) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires Linux iSCSI target (requires iscsi-target configuration) |
| [CVE-2025-71238](#cve-2025-71238) | SCSI subsystem (`CONFIG_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — requires QLogic qla2xxx Fibre Channel HBA |
| [CVE-2026-23318](#cve-2026-23318) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2026-31581](#cve-2026-31581) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2023-3268](#cve-2023-3268) | relay filesystem (`CONFIG_RELAY`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_RELAY=y`; Lockdown limits post-exploitation |
| [CVE-2023-3567](#cve-2023-3567) | virtual terminal (VT) (`CONFIG_VT`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_VT=y`; Lockdown limits post-exploitation |
| [CVE-2023-6531](#cve-2023-6531) | Unix domain sockets (`CONFIG_UNIX`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_UNIX=y`; Lockdown limits post-exploitation |
| [CVE-2023-51043](#cve-2023-51043) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_DRM=y`; Lockdown limits post-exploitation |
| [CVE-2024-0841](#cve-2024-0841) | hugetlbfs (`CONFIG_HUGETLBFS`) | <span class="badge badge-cve-high">6.6 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_HUGETLBFS=y`; Lockdown limits post-exploitation |
| [CVE-2024-26593](#cve-2024-26593) | Intel SMBus I2C controller (`CONFIG_I2C_I801`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_I2C_I801=y`; Lockdown limits post-exploitation |
| [CVE-2024-38586](#cve-2024-38586) | Realtek r8169 Ethernet driver (`CONFIG_R8169`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_R8169=y`; Lockdown limits post-exploitation |
| [CVE-2024-38630](#cve-2024-38630) | watchdog timer subsystem (`CONFIG_WATCHDOG`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_WATCHDOG=y`; Lockdown limits post-exploitation |
| [CVE-2024-34777](#cve-2024-34777) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_DMA_ENGINE=y`; Lockdown limits post-exploitation |
| [CVE-2024-39463](#cve-2024-39463) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_9P_FS=y`; Lockdown limits post-exploitation |
| [CVE-2024-40956](#cve-2024-40956) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Intel IAX/DSA accelerator hardware absent |
| [CVE-2022-48867](#cve-2022-48867) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Intel IAX/DSA accelerator hardware absent |
| [CVE-2024-46759](#cve-2024-46759) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; ADC128D818 I2C ADC chip absent |
| [CVE-2024-49860](#cve-2024-49860) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2022-49029](#cve-2022-49029) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; IBM Power Management Extension hardware absent |
| [CVE-2024-50127](#cve-2024-50127) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2024-50131](#cve-2024-50131) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_TRACING=y`; Lockdown limits post-exploitation |
| [CVE-2024-53057](#cve-2024-53057) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2024-56606](#cve-2024-56606) | AF_PACKET sockets (`CONFIG_PACKET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PACKET=y`; Lockdown limits post-exploitation |
| [CVE-2025-21692](#cve-2025-21692) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2022-49799](#cve-2022-49799) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_TRACING=y`; Lockdown limits post-exploitation |
| [CVE-2022-49892](#cve-2022-49892) | ftrace / function tracer (`CONFIG_FTRACE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_FTRACE=y`; Lockdown limits post-exploitation |
| [CVE-2022-49921](#cve-2022-49921) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2023-53111](#cve-2023-53111) | loop block device (`CONFIG_BLK_DEV_LOOP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BLK_DEV_LOOP=y`; Lockdown limits post-exploitation |
| [CVE-2025-37879](#cve-2025-37879) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_9P_FS=y`; Lockdown limits post-exploitation |
| [CVE-2025-37914](#cve-2025-37914) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2025-37915](#cve-2025-37915) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-high">7.1 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2025-37923](#cve-2025-37923) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_TRACING=y`; Lockdown limits post-exploitation |
| [CVE-2025-38369](#cve-2025-38369) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Intel IAX/DSA accelerator hardware absent |
| [CVE-2025-38548](#cve-2025-38548) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Corsair Commander Pro hardware absent |
| [CVE-2022-50320](#cve-2022-50320) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2023-53395](#cve-2023-53395) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2025-39869](#cve-2025-39869) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; Texas Instruments eDMA hardware absent |
| [CVE-2022-50423](#cve-2022-50423) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_ACPI=y`; Lockdown limits post-exploitation |
| [CVE-2026-23378](#cve-2026-23378) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_SCHED=y`; Lockdown limits post-exploitation |
| [CVE-2024-36883](#cve-2024-36883) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-36971](#cve-2024-36971) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-38577](#cve-2024-38577) | RCU tasks subsystem (`CONFIG_TASKS_RCU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_TASKS_RCU=y`; Lockdown limits post-exploitation |
| [CVE-2024-40958](#cve-2024-40958) | network namespaces (`CONFIG_NET_NS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_NET_NS=y`; Lockdown limits post-exploitation |
| [CVE-2024-41039](#cve-2024-41039) | ALSA sound subsystem (`CONFIG_SND`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; no audio hardware present |
| [CVE-2024-46713](#cve-2024-46713) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2024-46852](#cve-2024-46852) | DMA-BUF shared buffer (`CONFIG_DMA_SHARED_BUFFER`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_DMA_SHARED_BUFFER=y`; Lockdown limits post-exploitation |
| [CVE-2022-48950](#cve-2022-48950) | perf events subsystem (`CONFIG_PERF_EVENTS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_PERF_EVENTS=y`; Lockdown limits post-exploitation |
| [CVE-2022-49026](#cve-2022-49026) | Intel e100 Fast Ethernet driver (`CONFIG_E100`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_E100=y`; Lockdown limits post-exploitation |
| [CVE-2024-50055](#cve-2024-50055) | core kernel (`CONFIG_BASE_FULL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_BASE_FULL=y`; Lockdown limits post-exploitation |
| [CVE-2024-50112](#cve-2024-50112) | x86_64 architecture (`CONFIG_X86_64`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_X86_64=y`; Lockdown limits post-exploitation |
| [CVE-2024-50193](#cve-2024-50193) | x86_64 architecture (`CONFIG_X86_64`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_X86_64=y`; Lockdown limits post-exploitation |
| [CVE-2024-56600](#cve-2024-56600) | IPv6 networking stack (`CONFIG_IPV6`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_IPV6=y`; Lockdown limits post-exploitation |
| [CVE-2024-56601](#cve-2024-56601) | TCP/IP networking (`CONFIG_INET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.9 HIGH</span> | Affected — `CONFIG_INET=y`; Lockdown limits post-exploitation |
| [CVE-2024-56616](#cve-2024-56616) | DRM subsystem (`CONFIG_DRM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge bg-success">0.0</span> | Affected — hardware absent; DisplayPort MST display hardware absent |

Over 1,000 CVEs across 178 disabled-feature groups are listed in [Not Affected — Disabled Features](#not-affected-disabled-features) below.

## CVE-2026-31431

**Status**: Not Affected  
**Component**: algif_aead — the in-kernel AEAD interface exposed by the AF_ALG socket family (`CONFIG_CRYPTO_USER_API_AEAD`)  
**Upstream fix**: Linux 6.12.85 (LTS), 6.18.22 (LTS), 6.19.12 (LTS)

This CVE describes a privilege escalation through the AF_ALG socket interface. An attacker who can open an AF_ALG socket reaches `algif_aead_copy_sgl()`, exploits a copy-on-write failure in the scatter-gather list handling, and gains root.

`CONFIG_CRYPTO_USER_API_AEAD` is not compiled into the HeartSuite Core Secure kernel. The AF_ALG socket family is not available. An attempt to open an AF_ALG socket returns `EAFNOSUPPORT` — there is no `algif_aead` code present in the running kernel and therefore no reachable code path. The HeartSuite Core Secure kernel predates the upstream fix versions listed above, but the fix is not required: the fix removes a vulnerability in code that was never compiled in.

Lockdown closes the remaining question. Even if the code path were present, Lockdown — `chattr +i` filesystem immutability combined with the HeartSuite Core Secure kernel refusing runtime changes to the allowlist — removes every useful action root can take after gaining privilege. The kernel refuses to clear immutable flags. Mount operations are blocked in Secure Mode + Lockdown. Writes to the audit log are blocked. Root cannot modify the allowlist, add a backdoor, or persist across a reboot.

See [Deployment Scenarios → Production Servers](../introduction/deployment-scenarios/) for the architectural context of how Lockdown interacts with a privilege escalation reaching root.

## CVE-2024-47685

**Status**: Affected — not reachable in default configuration  
**Component**: nf_reject_ipv6 — IPv6 netfilter TCP RST generation (`CONFIG_NF_REJECT_IPV6`, `CONFIG_IP6_NF_TARGET_REJECT`)  
**Base Score**: 9.1 CRITICAL (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:H)  
**Environmental Score**: 0.0 — trigger not present; HeartSuite installs no ip6tables REJECT rules  
**Upstream fix**: Linux 4.19.323, 5.4.285, 5.10.227, 5.15.168, 6.1.113, 6.6.54, 6.10.13, 6.11.2 (5.19 branch is EOL; no backport)

This CVE describes an information disclosure in the IPv6 netfilter TCP reset path. When the kernel sends a TCP RST packet in response to a connection rejected by an ip6tables rule, `nf_reject_ip6_tcphdr_put()` allocates a TCP header via `skb_put()` without zeroing the buffer. The function then writes every field in the header explicitly except the four reserved bits (`th->res1`) in byte 12. Those bits retain whatever value was in the allocated kernel memory region. The RST packet is sent with that uninitialized content on the wire.

`CONFIG_NF_REJECT_IPV6=y` and `CONFIG_IP6_NF_TARGET_REJECT=y` are compiled in. The code path exists in this kernel. The vulnerable function has five callers across the kernel source. In this configuration only `ip6t_REJECT.c` is compiled — the remaining four callers (`nft_reject_ipv6`, `nft_reject_inet`, `nft_reject_bridge`, `nft_reject_netdev`) are all gated by `CONFIG_NF_TABLES`, which is not set. Reaching the vulnerable code therefore requires an active ip6tables rule using `REJECT --reject-with tcp-reset` on IPv6 traffic. The HeartSuite Core Secure install scripts and service unit contain no ip6tables rules of any kind. An operator who manually adds such a rule would expose this path.

Lockdown does not patch the vulnerability mechanism — the kernel still places uninitialized bits into the packet header if the path is reached. However, Secure Mode and Lockdown together make the triggering condition unreachable in practice.

To trigger this CVE, an operator must first add an ip6tables rule with `REJECT --reject-with tcp-reset`. That requires running `ip6tables` with root privilege. In Secure Mode, HeartSuite's program allowlist is enforced at the kernel level for every user including root: a program without a valid allowlist entry cannot execute regardless of the caller's privilege level. Network management utilities such as `ip6tables` have no allowlist entry on a production HeartSuite deployment, so root cannot run them and the rule cannot be added.

Lockdown closes the remaining path. Even if an attacker gained root and attempted to add `ip6tables` to the allowlist first, Lockdown blocks every mechanism for doing so: `FS_IOC_SETFLAGS` (the ioctl used by `chattr`) returns `EPERM` for all callers during lockdown, so immutable flags cannot be cleared from the allowlist database files; `mount()`, `fsmount()`, and `move_mount()` all return `EPERM`, blocking any bind-mount or remount workaround; and the HeartSuite reactivation path is disabled, preventing the service from being reconfigured to accept new entries.

The result is a two-layer guarantee: Secure Mode prevents the trigger from being established, and Lockdown ensures the allowlist cannot be modified to enable the tools that would establish it. A 9.1 CRITICAL CVE that requires setting up an ip6tables REJECT rule becomes unreachable by any user, including root, once Lockdown is in force.

## CVE-2022-41674, CVE-2022-42719, CVE-2022-42720

**Status**: Affected — attack surface absent on server deployments  
**Component**: mac80211 — 802.11 wireless stack (`CONFIG_MAC80211`)  
**Base Scores**: CVE-2022-42719: 8.8 HIGH (AV:A); CVE-2022-41674: 8.1 HIGH (AV:A); CVE-2022-42720: 7.8 HIGH (AV:A)  
**Environmental Score**: 0.0 — no WiFi hardware present; attack vector (frame injection via wireless NIC) has no path to execution  
**Affected range**: Linux 5.19.x before 5.19.16  
**Upstream fix**: Linux 5.4.218–219, 5.10.148–149, 5.15.74, 5.19.16, 6.0.2

These three CVEs cover memory corruption in the mac80211 multi-BSSID scanning path, exploitable by an attacker who can inject 802.11 management frames:

- **CVE-2022-41674** (CVSS 8.1) — buffer overflow in `ieee80211_bss_info_update()` in `net/mac80211/scan.c` triggered by a crafted beacon or probe response with a malformed multi-BSSID element
- **CVE-2022-42719** (CVSS 8.8) — use-after-free when parsing a multi-BSSID element, exploitable to crash the kernel or gain privilege
- **CVE-2022-42720** (CVSS 7.8) — refcounting bugs in multi-BSS handling reachable through the same scanning path

`CONFIG_MAC80211=y` is compiled in and 5.19.6 is within the affected version range for all three. The entry point is `ieee80211_scan_rx()` in `net/mac80211/rx.c`, which has a single caller: the hardware NIC interrupt RX path. A physical WiFi NIC must be present, registered, and receiving frames for any of these paths to execute. `CONFIG_MAC80211_HWSIM` (software WiFi simulator) is not set. On server deployments without a WiFi interface the code paths are unreachable.

If exploited on a deployment with WiFi hardware, all three CVEs lead to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable by `HS_lockdown.sh` before Lockdown is engaged. Once Lockdown is active, `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through one of these WiFi CVEs finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot. The blast radius of a successful exploit on a locked-down HeartSuite system is bounded to the current session of already-permitted processes.

## CVE-2023-0266

**Status**: Affected — hardware-dependent  
**Component**: ALSA PCM — in-kernel sound subsystem (`CONFIG_SND`)  
**Base Score**: 7.9 HIGH (AV:L/AC:H/PR:L/UI:N/S:C/C:H/I:H/A:H)  
**Environmental Score**: 0.0 — no audio hardware present; no `/dev/snd` devices; ioctl path unreachable  
**Affected range**: Linux 5.16 through 6.1.5  
**Upstream fix**: Linux 4.14.303, 4.19.270, 5.4.229, 5.10.163, 5.15.88, 6.1.6 (5.19 branch is EOL; no backport)

This CVE describes a use-after-free in the ALSA PCM control interface. `SNDRV_CTL_IOCTL_ELEM_READ` and `SNDRV_CTL_IOCTL_ELEM_WRITE` (32-bit compat variants) are missing locks that allow a local user to trigger a use-after-free and gain elevated privilege.

`CONFIG_SND=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable code requires an ALSA-accessible sound device. Server deployments without audio hardware have no `/dev/snd` devices and no reachable path to this ioctl.

If exploited on a deployment with audio hardware, the CVE achieves local privilege escalation to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. Once Lockdown is active, `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot. The blast radius of a successful exploit on a locked-down HeartSuite system is bounded to the current session of already-permitted processes.

## CVE-2022-4139

**Status**: Affected — hardware-dependent  
**Component**: i915 GPU driver (`CONFIG_DRM_I915`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**Environmental Score**: 0.0 — no i915 GPU present; GPU context entry point unreachable  
**Affected range**: Linux 5.16 through 6.0.10  
**Upstream fix**: Linux 5.4.226, 5.10.157, 5.15.81, 6.0.11 (5.19 branch is EOL; no backport)

This CVE describes an incorrect TLB flush in the Intel i915 GPU driver. When GPU memory mappings are changed, a missing or incorrect TLB invalidation can leave stale translation entries active, allowing writes to land in the wrong physical pages. This can corrupt kernel memory and is exploitable by a local user with access to a GPU context to gain elevated privilege.

`CONFIG_DRM_I915=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable path requires an Intel i915 GPU to be present and accessible. Deployments without i915 hardware have no reachable path to this driver.

If exploited, kernel memory corruption from a stale TLB entry operates at the GPU hardware level and can precede any userspace privilege escalation. Lockdown's restrictions are API-level constraints on userspace callers; they have no bearing on writes the GPU issues through stale TLB entries before the exploit surfaces in userspace.

Once the exploit does reach root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The result is a split boundary: Lockdown cannot contain damage that occurs at the GPU TLB layer before userspace is involved, but once the attacker holds root in userspace, they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.

## CVE-2023-2236, CVE-2022-3910

**Status**: Affected  
**Component**: io_uring — asynchronous I/O subsystem (`CONFIG_IO_URING`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**Environmental Score**: 7.1–7.9 HIGH — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High; score stays within the HIGH band  
**Affected ranges**: CVE-2023-2236: 5.19 through 6.0.10; CVE-2022-3910: 5.18 through 5.19.10  
**Upstream fix**: CVE-2023-2236: 6.0.11; CVE-2022-3910: 5.19.11 (5.19 branch is EOL for CVE-2023-2236; CVE-2022-3910 fix was in-branch but 5.19.6 predates it)

Both CVEs describe use-after-free conditions in io_uring's fixed file management, exploitable by a local user to gain root:

- **CVE-2023-2236** — double `fput()` in the `io_install_fixed_file()` path. When an async open operation installs a fixed file and encounters an error, `io_install_fixed_file()` calls `fput(file)` at its error label; the caller then calls `fput(file)` a second time. The file's reference count reaches zero while the object is still referenced, producing a use-after-free.
- **CVE-2022-3910** — improper reference count update in io_uring's fixed file handling that leads to a use-after-free and local privilege escalation.

`CONFIG_IO_URING=y` is compiled in. The `io_uring_setup` syscall has no capability gate — any local user can create an io_uring ring and reach both vulnerable paths. There is no hardware dependency.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

These constraints are why the Environmental Score reflects a reduced MI (High→Low): root cannot modify the allowlist, cannot install persistent backdoors, and cannot survive a reboot. Confidentiality and Availability impacts remain High, reflecting that an attacker with a live root session can still read data and disrupt services within the bounds of already-permitted processes.

A more sophisticated exploit could use the kernel use-after-free to directly corrupt kernel data structures before surfacing in userspace. In that scenario Lockdown's API-level restrictions are not the binding constraint — the corruption happens below the layer where those checks operate. This is why the Environmental Score does not reach 0.0: the io_uring path is reachable by any local user, and pre-userspace kernel corruption is outside the scope of what Lockdown addresses.


## CVE-2024-0775

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 6.7 MEDIUM (AV:L/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 6.8 MEDIUM — Lockdown reduces MI: High→Low
**Affected range**: kernels through 6.7.2, 6.6.15, 6.1.79, 5.15.148, 5.10.211, 5.4.270, 4.19.308 (5.19 branch is EOL; no backport)
**Upstream fix**: Linux 6.7.3, 6.6.16, 6.1.80, 5.15.149, 5.10.212, 5.4.271, 4.19.309

This CVE describes a use-after-free in the `__ext4_remount()` error path in `fs/ext4/super.c`. When a remount operation fails and rolls back to saved options, the function restores quota file name pointers via `rcu_assign_pointer(sbi->s_qf_names[i], old_opts.s_qf_names[i])` and then frees the displaced current pointer via `kfree(to_free[i])`. If the success path has already freed those names at the earlier `kfree(old_opts.s_qf_names[i])` call, the error path operates on already-freed memory. The CVE requires `CAP_SYS_ADMIN` (implicit in `PR:H`) because `mount(MS_REMOUNT)` is a privileged operation.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server.

Lockdown directly prevents the trigger. `__ext4_remount()` is reached exclusively via `mount(MS_REMOUNT)`. HeartSuite's `kernel/namespace.c` returns `EPERM` from `do_mount()` whenever `HS_locked_down()` is true. During Lockdown, root cannot call `mount()` at all — the CVE's entry point is blocked at the syscall level before any ext4 code is reached.

In Secure Mode without Lockdown, an additional gate applies: an attacker cannot execute a new exploit binary because it has no allowlist entry and the kernel refuses to run it regardless of privilege level. Reaching `__ext4_remount()` requires an already-permitted process to make the remount call.

If exploitation were to succeed, Lockdown closes the post-exploitation path: the allowlist database files are immutable, `FS_IOC_SETFLAGS` is blocked so immutable flags cannot be cleared, and `mount()` is blocked so no filesystem remapping is possible. Root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup additionally creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable.


## CVE-2023-52530

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present; WoWLAN path unreachable
**Affected range**: kernels through 6.7.3, 6.6.18, 6.1.81, 5.15.150, 5.10.214, 5.4.273, 4.19.311 (5.19 branch is EOL; no backport)
**Upstream fix**: Linux 6.7.4, 6.6.19, 6.1.82, 5.15.151, 5.10.215, 5.4.274, 4.19.312

This CVE describes a use-after-free in the mac80211 WoWLAN (Wake on Wireless LAN) GTK rekey path. When `ieee80211_gtk_rekey_add()` installs a new group temporal key, it calls `ieee80211_key_link()`. If the new key is identical to the one already installed — the KRACK protection path — `ieee80211_key_link()` frees the new key via `ieee80211_key_free_unused(key)` and returns `0` to signal that the reinstall was silently accepted. `ieee80211_gtk_rekey_add()` treats the `0` return as success, skips the error branch, and returns `&key->conf` — a pointer into the object that was just freed. The caller receives a dangling pointer to freed `ieee80211_key` memory.

`CONFIG_MAC80211=y` is compiled in. The entry point `ieee80211_gtk_rekey_add()` guards itself with `WARN_ON(!local->wowlan)`: it requires WoWLAN to be active, which in turn requires a WiFi NIC with WoWLAN firmware support, a wireless interface, and an active station association. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and neither the rekey path nor any other mac80211 code path is reachable.

If exploited on a deployment with WiFi hardware and WoWLAN active, the CVE leads to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2023-52612

**Status**: Affected
**Component**: kernel crypto framework — scomp interface (`CONFIG_CRYPTO`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: kernels prior to stable fixes in the 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8-rc; backported across active stable series

This CVE describes a buffer overflow in the kernel software compression (`scomp`) interface in `crypto/scompress.c`. The `scomp_acomp_comp_decomp()` function uses a per-CPU scratch buffer of `SCOMP_SCRATCH_SIZE` bytes as working space. If the caller provides a `req->dst` scatter list smaller than `SCOMP_SCRATCH_SIZE`, the function still caps `req->dlen` to `SCOMP_SCRATCH_SIZE` and then copies the full output — up to that size — into `req->dst` via `scatterwalk_map_and_copy()`. No check verifies that `req->dst` can hold `req->dlen` bytes before the copy. A caller who controls `req->dst` and triggers a compression or decompression that fills the scratch buffer can write beyond the end of the destination scatter list.

`CONFIG_CRYPTO=y` is compiled in and 5.19.6 falls within the affected range. The kernel crypto framework is used by IPsec, dm-crypt, TLS, and other subsystems — all active on a Debian 11 server. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot. The blast radius of a successful exploit on a locked-down HeartSuite system is bounded to the current session of already-permitted processes.


## CVE-2024-26654

**Status**: Not Affected — driver not compiled in
**Component**: ALSA AICA Dreamcast sound driver (`CONFIG_SND_AICA`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport)

This CVE describes a use-after-free caused by a circular scheduling race between `dreamcastcard->timer` and `spu_dma_work` in the AICA Yamaha sound chip driver (`sound/sh/aica.c`). The timer callback `aica_period_elapsed()` schedules `spu_dma_work` via `schedule_work()`; the work handler then re-arms the timer via `mod_timer()`. `spu_begin_dma()` independently schedules the work and arms the timer in the same call. These two execution paths can race against each other and against card teardown, producing a use-after-free on the `snd_card_aica` object while the timer or work item is still pending.

`CONFIG_SND_AICA` is not set in the HeartSuite Core Secure kernel. `sound/sh/aica.c` is gated by `obj-$(CONFIG_SND_AICA)` in `sound/sh/Makefile` and is not compiled. There is no AICA driver code present in the running kernel — not merely absent hardware, but absent code. An attempt to reach this path has no code to execute. The HeartSuite Core Secure kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.


## CVE-2024-26704

**Status**: Affected
**Component**: ext4 filesystem — online defragmentation (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: kernels prior to stable fixes in the 6.8.x, 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8; backported across active stable series

This CVE describes a use-after-free in `ext4_move_extents()` in `fs/ext4/move_extent.c`, reachable via the `EXT4_IOC_MOVE_EXT` ioctl. The function moves file extents between an original inode and a donor inode. If the first move operation fails, `o_start` has not advanced past `orig_blk`, so `*moved_len` is set to zero. Preallocation blocks set up for `orig_inode` and `donor_inode` are discarded only when `*moved_len` is non-zero — the guard at `move_extent.c:692`. With `*moved_len == 0`, those preallocations are never discarded, leaving stale preallocation state that produces a use-after-free when the preallocations are later released. The `EXT4_IOC_MOVE_EXT` ioctl requires only write access to the file — no `CAP_SYS_ADMIN`, consistent with the `PR:L` CVSS score.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server, so this ioctl path is active for any process with write access to an ext4 file. On a HeartSuite Core Secure system in Secure Mode, reaching this path requires an approved process to invoke the ioctl. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it regardless of privilege level.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot. File Backup additionally creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file during exploitation, the previous version remains recoverable.


## CVE-2024-26842

**Status**: Not Affected — driver not compiled in
**Component**: UFS host controller driver (`CONFIG_SCSI_UFSHCD`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport)

This CVE describes an out-of-bounds memory access in the UFS host controller driver's MCQ (Multi-Circular Queue) mode. When `task_tag >= 32` and `sizeof(unsigned int) == 4`, the expression `1U << task_tag` is undefined behaviour in C — shifting a 32-bit value by 32 or more positions. In practice this produces incorrect bitmask values in the per-queue task tracking, allowing the computed mask to index outside the valid task range and corrupt adjacent memory.

`CONFIG_SCSI_UFSHCD` is not set in the HeartSuite Core Secure kernel. The UFS host controller driver is not compiled, and no UFS source files are present under `drivers/scsi/ufs/` in the kernel tree. The prior claim that "ufshcd is compiled in but never bound to hardware" was incorrect — the driver does not exist in the running kernel image at all. The HeartSuite Core Secure kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.


## CVE-2022-48662

**Status**: Affected — hardware absent on server deployments
**Component**: Intel i915 DRM driver — i915_perf (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no Intel display GPU present
**Affected range**: Linux 5.19.x before 5.19.16; 5.15.x before 5.15.74; earlier stable series also affected
**Upstream fix**: Linux 5.19.16, 5.15.74, 5.10.148, 5.4.218, 4.19.263 (fix landed within the 5.19 branch before it reached EOL; 5.19.6 predates it)

This CVE describes a use-after-free in the i915 performance monitoring subsystem (`i915_perf.c`). During OA register reconfiguration, `i915_perf` iterates `i915->gem.contexts.list` under `i915->gem.contexts.lock`. For each entry it acquires a reference via `kref_get_unless_zero()` and then **drops the spin lock** to call `gen8_configure_context()`. After the call it re-acquires the lock and calls `list_safe_reset_next(ctx, cn, link)` to advance the iteration cursor — dereferencing `ctx->link`. The assumption is that holding a reference prevents the context from being unlinked. It does not: a concurrent thread can remove `ctx` from the list while its refcount is non-zero. When `list_safe_reset_next` dereferences `ctx->link` after the lock is re-acquired, it reads from freed or repurposed list-head memory.

`CONFIG_DRM_I915=y` is compiled in and 5.19.6 falls within the affected range. No Intel integrated or discrete display GPU is present on a server deployment. Without GPU hardware, DRM device nodes are not created and the i915_perf entry point is unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

If exploited on a deployment with i915 hardware, the CVE leads to kernel memory corruption that can escalate to root. At that point Lockdown constrains everything the attacker can do with that root access.

The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown, so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2024-26934

**Status**: Affected
**Component**: USB core (`CONFIG_USB`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: 4.11–6.8
**Upstream fix**: 6.8.2 series

Among the attribute file callback routines in `drivers/usb/core/sysfs.c`, `interface_authorized_store()` is the only one that acquires a device lock on an ancestor device. It delegates immediately to `usb_deauthorize_interface()` (`drivers/usb/core/message.c`), which takes `device_lock(dev->parent)` first (line 1792) and then `device_lock(dev)` (line 1795). This lock ordering diverges from other USB subsystem paths, creating an ABBA deadlock when a concurrent bind or configuration operation holds the interface device lock and waits to acquire the parent lock while `usb_deauthorize_interface()` holds the parent lock and waits for the child. The deadlock stalls the USB subsystem and can produce a kernel hang. The HS 5.19.6 kernel carries the unpatched `interface_authorized_store()` at `drivers/usb/core/sysfs.c:1172` and the unchanged `usb_deauthorize_interface()` at `drivers/usb/core/message.c:1792`.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. Triggering the race requires a local process with write access to the `/sys/.../authorized` sysfs attribute of a USB interface device at the same moment another USB operation is in progress.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c:561–569`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown (`hs_sandbox_caching.c:1942`), so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2024-26939

**Status**: Affected — hardware absent on server deployments
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no Intel display GPU present
**Affected range**: pre-6.8
**Upstream fix**: 6.8 series

Object debugging tools were sporadically reporting illegal attempts to free a still-active i915 VMA object when parking a GT believed to be idle: `[161.359441] ODEBUG: free active object type: i915_active`. When the GPU's Graphics Tile (GT) transitions to the parked (powered-down) state, `i915_vma_parked()` (`drivers/gpu/drm/i915/i915_vma.c:1729`) iterates the `gt->closed_vma` list of VMAs marked for deferred destruction. For each candidate it calls `i915_gem_object_trylock()` (line 1758) and, on success, calls `i915_vma_destroy()` (line 1760) immediately — without checking whether the VMA's embedded `i915_active` tracker has reached zero. If outstanding GPU command-buffer work still holds a live reference through that tracker, the object is freed while completion callbacks continue to dereference it, producing a use-after-free with attacker-controlled timing on the GPU side.

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes are not created and the GT power-management paths that call `i915_vma_parked()` are never reached. The environmental score reflects this: the vulnerable code path is structurally unreachable on the deployed hardware configuration.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-48689

**Status**: Affected
**Component**: TCP receive zerocopy (`CONFIG_INET`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low
**Affected range**: 4.14–pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

A syzbot report identified a misuse of pfmemalloc page status in TCP zerocopy receive paths. In `tcp_zerocopy_receive()` (`net/ipv4/tcp.c:2086`), socket buffer fragment pages are collected into a batch (line 2178: `page = skb_frag_page(frags)`) and mapped directly into userspace via `vm_insert_pages()`. No `page_is_pfmemalloc()` check is performed before adding a fragment page to the batch. Pages allocated from pfmemalloc reserves (used to break memory-pressure deadlocks in the network receive path) carry special lifecycle accounting; mapping them into userspace circumvents that accounting. A local attacker who can induce a pfmemalloc allocation into the TCP receive path can map a reserve page into their own address space, potentially corrupting page refcount state in ways that lead to privilege escalation.

`CONFIG_INET=y` is built in and 5.19.6 falls within the affected range. The TCP zerocopy receive path (`TCP_ZEROCOPY_RECEIVE` ioctl on a connected socket) is fully reachable by any local user with network access.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c:561–569`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown (`hs_sandbox_caching.c:1942`), so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2022-48701

**Status**: Not Affected — driver not compiled in
**Component**: USB audio driver (`CONFIG_SND_USB_AUDIO`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

There may be a bad USB audio device with a USB ID of (0x04fa, 0x4201) and fewer than 4 interfaces; an out-of-bounds read bug occurs when the USB audio stream parser iterates altsettings. The Dallas DS4201 workaround at `sound/usb/stream.c:1108` unconditionally caps `num = 4` regardless of how many altsettings the device actually reports. If a malicious or malformed device presents that USB ID with fewer than 4 altsettings, the loop at line 1111 accesses `iface->altsetting[i]` beyond the bounds of the array, leaking kernel memory.

`CONFIG_SND_USB_AUDIO` is not set in the HS 5.19.6 configuration. The USB audio driver — including the vulnerable `sound/usb/stream.c` altsetting parser — is not compiled into the kernel image. A USB device with this ID cannot be claimed by any USB audio driver, and the vulnerable code path does not exist in the binary.


## CVE-2022-48702

**Status**: Not Affected — driver not compiled in
**Component**: EMU10K1 audio driver (`CONFIG_SND_EMU10K1`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

The voice allocator sometimes begins allocating from near the end of the array and then wraps around; however `snd_emu10k1_pcm_channel_alloc()` accesses the voices array without the wrapping modulo that the allocator itself uses. The round-robin allocator in `sound/pci/emu10k1/voice.c:42` uses `i %= NUM_G` to keep indices in bounds, but `sound/pci/emu10k1/emupcm.c:127` assigns multichannel voices as `&emu->voices[epcm->voices[0]->number + i]` with no `% NUM_G` guard. When the allocator places the first voice near the end of the 64-entry array and more than one voice is requested, the addition exceeds array bounds, producing an out-of-bounds read and write that can corrupt adjacent kernel memory.

`CONFIG_SND_EMU10K1` is not set in the HS 5.19.6 configuration. The EMU10K1 driver — including the vulnerable `sound/pci/emu10k1/emupcm.c` channel allocator — is not compiled into the kernel image. The vulnerable code path does not exist in the binary.


## CVE-2022-48695

**Status**: Not Affected — driver not compiled in
**Component**: mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

A use-after-free occurs during controller reset in the mpt3sas firmware event cleanup path. In `drivers/scsi/mpt3sas/mpt3sas_scsih.c`, the reset handler iterates queued firmware events and calls `cancel_work_sync()` on each. When `cancel_work_sync()` returns non-zero (the work was never executed), the handler calls `fw_event_work_put()` at line 3752 to release the work's reference — then unconditionally calls `fw_event_work_put()` again at line 3754. This double decrement underflows the `kref` reference count, freeing the `fw_event_work` object while other paths may still hold pointers to it.

`CONFIG_SCSI_MPT3SAS` is not set in the HS 5.19.6 configuration. The mpt3sas driver — including the vulnerable firmware event cleanup path — is not compiled into the kernel image. The vulnerable code path does not exist in the binary.


## CVE-2024-35789

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

When moving a station out of a VLAN and deleting the VLAN afterwards, the fast_rx entry still holds a pointer to the VLAN's netdev, which can cause use-after-free. In `net/mac80211/cfg.c`, the station change path at line 1949 calls `__ieee80211_check_fast_rx_iface(vlansdata)`, which builds a new `fast_rx` structure with `dev = vlansdata->dev` (the target VLAN's netdev). The original VLAN's fast_rx is cleared at line 1955 via `ieee80211_clear_fast_rx(sta)`, but that function uses RCU: the old `fast_rx` object — containing `dev = original_vlan->dev` — is not freed until after a grace period. If the original VLAN interface is deleted before that grace period expires, any CPU still reading the old fast_rx entry will dereference a freed netdev. The HS 5.19.6 kernel carries the unpatched station change path at `net/mac80211/cfg.c:1939–1970`.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-35886

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

syzkaller reported infinite recursive calls of `fib6_dump_done()` during netlink socket destruction. From the log, syzkaller sent an AF_UNSPEC RTM_GETROUTE message, and then closed the netlink socket. The IPv6 FIB dump handler at `net/ipv6/ip6_fib.c:652` hooks the callback destructor by setting `cb->done = fib6_dump_done` (saving the original callback in `cb->args[3]`). When the netlink socket closes, netlink core invokes the destructor, calling `fib6_dump_done()` at line 570. This function calls `cb->done(cb)` — but `cb->done` is now `fib6_dump_done` itself, creating infinite recursion that exhausts the kernel stack. The HS 5.19.6 kernel carries the unpatched FIB dump callback at `net/ipv6/ip6_fib.c:645–684`.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. Triggering the recursion requires sending an AF_UNSPEC RTM_GETROUTE netlink message and then closing the socket — reachable by any local user with a netlink socket.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c:561–569`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown (`hs_sandbox_caching.c:1942`), so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2023-52835

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.8 series

When perf-record with a large AUX area, e.g. 4GB, it fails with: `#perf record -C 0 -m ,4G -e arm_spe_0// -- sleep 1 failed to mmap with 12 (Cannot allocate memory)`. The perf AUX area mmap handler in `kernel/events/core.c:6269–6345` calculates memory accounting limits and calls `rb_alloc_aux()` to allocate the backing pages. For very large AUX areas (gigabytes), the accounting arithmetic at line 6285 (`user_locked += user_extra`) can underflow or produce incorrect values when `user_extra` is extremely large (e.g., 1M pages for 4GB). The mmap() still succeeds despite the accounting failure, allowing unprivileged users to bypass RLIMIT_MEMLOCK restrictions and exhaust kernel memory. The HS 5.19.6 kernel carries the unpatched AUX area accounting at `kernel/events/core.c:6269–6345`.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. Triggering the accounting error requires calling `mmap()` with a very large AUX area on a perf event file descriptor — reachable by any local user within the paranoia level limits.

On a HeartSuite Core Secure system, Secure Mode provides the primary barrier: the kernel enforces the SPF allowlist equally against root and non-root processes (`hs_sandbox_caching.c`). No process without an allowlist entry can execute, so a standalone exploit tool has no path to the vulnerable perf AUX mmap path. Once Lockdown is activated, four independent mechanisms block every follow-on path an attacker would need:

1. **Allowlist integrity**: SPF control files are marked immutable by `chattr +i`. Under Lockdown, `FS_IOC_SETFLAGS` returns `EPERM` (`kernel/ioctl.c:561–569`), preventing any process — including root — from clearing the immutable flag and modifying the allowlist.
2. **Mount paths sealed**: `do_mount()` (`kernel/namespace.c:4218`), `fsmount()` (line 4300), and `move_mount()` (line 4453) all return `EPERM` under Lockdown, blocking filesystem remounting and injection.
3. **Reactivation disabled**: `hs_sandbox_caching.c:1942` prevents Secure Mode from being re-enabled once it has been turned off under Lockdown. An attacker who disables Secure Mode loses it permanently.
4. **No new execution**: Secure Mode remains active in parallel with Lockdown, so any new binary — including a post-exploitation payload — is blocked at the kernel execution gate regardless of filesystem access.


## CVE-2023-52868

**Status**: Affected
**Component**: thermal management (`CONFIG_THERMAL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

The `dev->id` value comes from `ida_alloc()`, so it is a number between zero and INT_MAX. In `drivers/thermal/thermal_core.c`, this ID is formatted into fixed-size `THERMAL_NAME_LENGTH` (20-byte) buffers using `sprintf()`. At line 681, `sprintf(dev->attr_name, "cdev%d_trip_point", dev->id)` produces a string of the form `"cdev<N>_trip_point"`. For large IDs, the full string exceeds 20 bytes: `"cdev2147483647_trip_point"` is 25 characters plus a null terminator (26 bytes total), overflowing `attr_name` by 6 bytes. The same overflow applies at line 690 for `sprintf(dev->weight_attr_name, "cdev%d_weight", dev->id)`, which produces up to 22 bytes into a 20-byte buffer. Both overflows corrupt adjacent kernel heap memory and can be leveraged for privilege escalation.

`CONFIG_THERMAL=y` is compiled in and 5.19.6 falls within the affected range. Thermal management is present on all x86 servers for CPU temperature control. Triggering the overflow requires registering a thermal cooling device with a sufficiently large ID — possible for a local user with access to the thermal sysfs interface.

On a HeartSuite Core Secure system, Secure Mode provides the primary barrier: the kernel enforces the SPF allowlist equally against root and non-root processes (`hs_sandbox_caching.c`). No process without an allowlist entry can execute, so a standalone exploit tool has no path to the thermal registration interface. Once Lockdown is activated, four independent mechanisms block every follow-on path an attacker would need:

1. **Allowlist integrity**: SPF control files are marked immutable by `chattr +i`. Under Lockdown, `FS_IOC_SETFLAGS` returns `EPERM` (`kernel/ioctl.c:561–569`), preventing any process — including root — from clearing the immutable flag and modifying the allowlist.
2. **Mount paths sealed**: `do_mount()` (`kernel/namespace.c:4218`), `fsmount()` (line 4300), and `move_mount()` (line 4453) all return `EPERM` under Lockdown, blocking filesystem remounting and injection.
3. **Reactivation disabled**: `hs_sandbox_caching.c:1942` prevents Secure Mode from being re-enabled once it has been turned off under Lockdown. An attacker who disables Secure Mode loses it permanently.
4. **No new execution**: Secure Mode remains active in parallel with Lockdown, so any new binary — including a post-exploitation payload — is blocked at the kernel execution gate regardless of filesystem access.


## CVE-2024-36916

**Status**: Affected
**Component**: block I/O cost controller (`CONFIG_BLK_CGROUP_IOCOST`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

UBSAN catches undefined behavior in blk-iocost, where sometimes `iocg->delay` is shifted right by a number that is too large, resulting in undefined behavior on some architectures. Two sites in `block/blk-iocost.c` are affected: line 1338 computes `iocg->delay >> div64_u64(tdelta, USEC_PER_SEC)`, where the divisor is elapsed time in seconds — if the delay has been active for 64 or more seconds, the shift amount reaches or exceeds 64, which is undefined behavior for a 64-bit type under the C standard. Line 2112 performs `iocg->delay >> nr_cycles`, where `nr_cycles` can similarly exceed 63. On x86 the shift wraps, but on other architectures the result is indeterminate. Incorrect delay values can bypass I/O throttling controls or cause the cgroup I/O cost model to make scheduling decisions based on garbage data.

`CONFIG_BLK_CGROUP_IOCOST=y` is compiled in and 5.19.6 falls within the affected range. The blk-iocost controller is active whenever cgroups are in use with I/O cost weighting enabled.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. The allowlist database files are made immutable before Lockdown is engaged. `FS_IOC_SETFLAGS` returns `EPERM` for all callers (`kernel/ioctl.c:561–569`), so root cannot use `chattr` to clear those immutable flags and rewrite the allowlist. `mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`), blocking any bind-mount or remount attempt to shadow or replace the allowlist files. HeartSuite reactivation is disabled during Lockdown (`hs_sandbox_caching.c:1942`), so the service cannot be reconfigured to accept new entries through any path.

Secure Mode adds a further constraint that runs independently of Lockdown: every program execution is checked against the allowlist at the kernel level, applying equally to root. An attacker who has gained root cannot execute a backdoor binary they drop onto the filesystem — it has no allowlist entry, and the kernel refuses to run it regardless of file ownership or permission bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2024-38560

**Status**: Not Affected — driver not compiled in
**Component**: Brocade bfa SCSI driver (`CONFIG_SCSI_BFA`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

Currently, we allocate a `nbytes`-sized kernel buffer and copy `nbytes` from userspace to that buffer. In `drivers/scsi/bfa/bfad_bsg.c`, the BSG passthrough handler at line 3373 allocates `kzalloc(bsg_data->payload_len, GFP_KERNEL)` where `payload_len` comes directly from the user-supplied BSG request structure, with no upper-bound validation. Line 3379 then calls `copy_from_user(..., bsg_data->payload_len)` using the same unchecked value. An attacker with access to the BSG device node can supply an oversized `payload_len` to exhaust kernel memory or, with a carefully chosen value, produce a heap overflow.

`CONFIG_SCSI_BFA` is not set in the HS 5.19.6 configuration. The Brocade bfa Fibre Channel HBA driver — including the vulnerable `bfad_bsg.c` BSG handler — is not compiled into the kernel image. The vulnerable code path does not exist in the binary.


## CVE-2024-38588

**Status**: Affected
**Component**: kprobes (`CONFIG_KPROBES`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `kernel/trace/ftrace.c`, `ftrace_location()` at line 1577 calls `lookup_rec(ip, ip)` at line 1583 to obtain a `dyn_ftrace *rec` pointer without holding `ftrace_lock`. On a concurrent path, module unloading frees the pages that back ftrace records for module functions. If a module is removed between the `lookup_rec()` return and the `return rec->ip` dereference at line 1594, the pointer references freed memory. The race is reached through the kprobe registration path: `check_kprobe_address_safe()` → `check_ftrace_location()` → `ftrace_location()` — all called without the lock that serialises ftrace record lifetime.

`CONFIG_KPROBES=y` is compiled in and HS 5.19.6 falls within the affected range.

Once an exploit reaches root in userspace, Lockdown's constraints apply in full. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`; at that point `FS_IOC_SETFLAGS` returns EPERM (`kernel/ioctl.c:561–569`), every mount path returns EPERM (`kernel/namespace.c:4218, 4300, 4453`), and allowlist modification is blocked at `hs_sandbox_caching.c:1942`. An attacker who has escalated through this UAF cannot alter what the system will run, cannot install a persistent backdoor, and loses their access on the next reboot.

Secure Mode adds a further constraint that operates entirely independently. Every execution is checked against the SPF allowlist inside the kernel before the process is permitted to run — applying equally to root. A backdoor or tool written to exploit this path and dropped onto the filesystem will not execute: it carries no allowlist entry, and the kernel refuses it regardless of file ownership or capability bits.

The combined effect is that an attacker who reaches root through this CVE finds themselves in a contained environment: they cannot add new programs, cannot modify what existing programs are permitted to do, cannot install persistence, and lose their access entirely on the next reboot.


## CVE-2024-40901

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

There is a potential out-of-bounds access when using test_bit() on a single word.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the LSI/Avago mpt3sas SAS/NVMe HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2024-40978

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

The qedi_dbg_do_not_recover_cmd_read() function invokes sprintf() directly on a __user pointer, which results into the crash.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the QLogic qedi iSCSI HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2024-41092

**Status**: Affected — hardware absent on server deployments
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no Intel display GPU present

CI has been sporadically reporting the following issue triggered by igt@i915_selftest@live@hangcheck on ADL-P and similar machines: <6> [414.049203] i915: Running intel_

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes may not be created and the GPU context entry points are unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-42136

**Status**: Affected — hardware absent on server deployments
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — CD-ROM drive absent on server

When running syzkaller with the newly reintroduced signed integer wrap sanitizer we encounter this splat: [  366.015950] UBSAN: signed-integer-overflow in .

`CONFIG_SCSI=y` is compiled in. This bug is in the CD-ROM block driver (`drivers/cdrom/cdrom.c`). No optical drive is present on a production server deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-44985

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

If skb_expand_head() returns NULL, skb has been freed and the associated dst/idev could also have been freed.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-44986

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

If skb_expand_head() returns NULL, skb has been freed and associated dst/idev could also have been freed.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-44987

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

syzbot reported an UAF in ip6_send_skb() [1] After ip6_local_out() has returned, we no longer can safely dereference rt, unless we hold rcu_read_lock().

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46673

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

aac_probe_one() calls hardware-specific init functions through the aac_driver_ident::init pointer, all of which eventually call down to aac_init_adapter().

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Adaptec aacraid RAID controller driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2024-46746

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

HID driver callbacks aren't called anymore once hid_destroy_device() has been called.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46747

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

report_fixup for the Cougar 500k Gaming Keyboard was not verifying that the report descriptor size was correct before accessing it

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46798

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

When using kernel with the following extra config, - CONFIG_KASAN=y - CONFIG_KASAN_GENERIC=y

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46849

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

Buffer 'card->dai_link' is reallocated in 'meson_card_reallocate_links()', so move 'pad' pointer initialization after this function when memory is already reallocated.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-47682

**Status**: Affected
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Ff the device returns page 0xb1 with length 8 (happens with qemu v2.x, for example), sd_read_block_characteristics() may attempt an out-of-bounds memory access when

`CONFIG_SCSI=y` is compiled in and 5.19.6 falls within the affected range. The SCSI subsystem underpins block storage on Debian 11 (SATA via libata, NVMe via the SCSI translation layer). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-47701

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

When looking up for an entry in an inlined directory, if e_value_offs is changed underneath the filesystem by some change in the block device, it will lead t

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49852

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

The kref_put() function will call nport->release if the refcount drops to zero. The nport->release release function is _efc_nport_free() which frees "nport"

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Emulex libefc Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2024-49882

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In ext4_ext_try_to_merge_up(), set path[1].p_bh to NULL after it has been released, otherwise it may be released twice.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49883

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

As Ojaswin mentioned in Link, in ext4_ext_insert_extent(), if the path is reallocated in ext4_ext_create_new_leaf(), we'll use the stale path and cause UAF.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49884

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

We hit the following use-after-free: ================================================================== BUG: KASAN: slab-use-after-free in ext4_split_extent_at+0xba8/0xcc0

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49889

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In ext4_find_extent(), path may be freed by error or be reallocated, so using a previously saved *ppath may have been freed and thus may trigger use-after-free, as follows:

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49960

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Syzbot has found an ODEBUG bug in ext4_fill_super The del_timer_sync function cancels the s_err_report timer, which reminds about filesystem errors daily.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-49983

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

When calling ext4_force_split_extent_at() in ext4_ext_replay_update_ex(), the 'ppath' is updated but it is the 'path' that is freed, thus potentially triggerin

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2024-50007

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

ASIHPI driver stores some values in the static array upon a response from the driver, and its index depends on the firmware.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-48951

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The bounds checks in snd_soc_put_volsw_sx() are only being applied to the first channel, meaning it is possible to write out of bounds values to the second chann

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-48956

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Blamed commit claimed rcu_read_lock() was held by ip6_fragment() callers. It seems to not be always true, at least for UDP stack. syzbot reported:

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49022

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

Fix possible out-of-bound access in ieee80211_get_rate_duration routine as reported by the following UBSAN report: UBSAN: array-index-out-of-bounds in net/mac8

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49023

**Status**: Affected — hardware absent on server deployments
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

For vendor elements, the code here assumes that 5 octets are present without checking.

`CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment. cfg80211 manages wireless interfaces; without hardware, no interface is created and the affected code paths are unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50278

**Status**: Affected
**Component**: device mapper (`CONFIG_BLK_DEV_DM`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Out-of-bounds access occurs if the fast device is expanded unexpectedly before the first-time resume of the cache table.

`CONFIG_BLK_DEV_DM=y` is compiled in and 5.19.6 falls within the affected range. Device mapper is used for LVM and is active on a standard Debian 11 installation. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup covers writes to protected directories regardless of the block layer.


## CVE-2024-50279

**Status**: Affected
**Component**: device mapper (`CONFIG_BLK_DEV_DM`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

dm-cache checks the dirty bits of the cache blocks to be dropped when shrinking the fast device, but an index bug in bitset iteration causes out-of-bounds access

`CONFIG_BLK_DEV_DM=y` is compiled in and 5.19.6 falls within the affected range. Device mapper is used for LVM and is active on a standard Debian 11 installation. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup covers writes to protected directories regardless of the block layer.


## CVE-2024-53147

**Status**: Affected
**Component**: FAT/exFAT filesystem (`CONFIG_FAT_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:H)
**Environmental Score**: 6.6 MEDIUM — Lockdown reduces MI: High→Low

In the case of the directory size is greater than or equal to the cluster size, if start_clu becomes an EOF cluster(an invalid cluster) due to file system corruption, then the d

`CONFIG_FAT_FS=y` is compiled in and 5.19.6 falls within the affected range. FAT/exFAT is compiled in (used for the EFI system partition on Debian 11). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53150

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The current USB-audio driver code doesn't check bLength of each descriptor at traversing for clock descriptors.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53170

**Status**: Affected
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

blk_mq_clear_flush_rq_mapping() is not called during scsi probe, by checking blk_queue_init_done().

`CONFIG_SCSI=y` is compiled in and 5.19.6 falls within the affected range. The SCSI subsystem underpins block storage on Debian 11 (SATA via libata, NVMe via the SCSI translation layer). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53173

**Status**: Affected
**Component**: NFS v4 client (`CONFIG_NFS_V4`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Yang Erkun reports that when two threads are opening files at the same time, and are forced to abort before a reply is seen, then the call to nfs_release_seqid() in

`CONFIG_NFS_V4=y` is compiled in and 5.19.6 falls within the affected range. NFS v4 client is compiled in. This path is active only when an NFS v4 share is mounted. On a server not using NFS, this code path is not reached. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53214

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

There are cases where a PCIe extended capability should be hidden from the user.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53227

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

BUG: KASAN: slab-use-after-free in __lock_acquire+0x2aca/0x3a20 Read of size 8 at addr ffff8881082d80c8 by task modprobe/25303 Call Trace:

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Brocade bfa Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2024-53239

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The current 6fire code tries to release the resources right after the call of usb6fire_chip_abort().

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56609

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

When removing kernel modules by: rmmod rtw88_8723cs rtw88_8703b rtw88_8723x rtw88_sdio rtw88_core Driver uses skb_queue_purge() to purge TX skb, but not report tx sta

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56631

**Status**: Affected
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Fix a use-after-free bug in sg_release(), detected by syzbot with KASAN: BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30 kernel/locking/lockdep.c:5838

`CONFIG_SCSI=y` is compiled in and 5.19.6 falls within the affected range. The SCSI subsystem underpins block storage on Debian 11 (SATA via libata, NVMe via the SCSI translation layer). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56663

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

Since the netlink attribute range validation provides inclusive checking, the *max* of attribute NL80211_ATTR_MLO_LINK_ID should be IEEE80211_MLD_MAX_NUM_LINKS - 1 otherwise c

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-57899

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

On 32-bit systems, the size of an unsigned long is 4 bytes, while a u64 is 8 bytes.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-21863

**Status**: Affected
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

sqe->opcode is used for different tables, make sure we santitise it against speculations.

`CONFIG_IO_URING=y` is compiled in and 5.19.6 falls within the affected range. io_uring is compiled in. Applications using io_uring for async I/O can reach these paths. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-52930

**Status**: Affected — hardware absent on server deployments
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no Intel display GPU present

A userspace with multiple threads racing I915_GEM_SET_TILING to set the tiling to I915_TILING_NONE could trigger a double free of the bit_17 bitmask.  (Or conversely leak memory on the tr

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes may not be created and the GPU context entry points are unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-52988

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

snd_hda_get_connections() can return a negative error code. It may lead to accessing 'conn' array at a negative index.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-21993

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

When performing an iSCSI boot using IPv6, iscsistart still reads the /sys/firmware/ibft/ethernetX/subnet-mask entry.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the iSCSI Boot Firmware Table (iBFT, iSCSI boot configuration) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-22083

**Status**: Affected — hardware absent on server deployments
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — vhost-scsi not applicable — no KVM host mode in HS

If vhost_scsi_set_endpoint is called multiple times without a vhost_scsi_clear_endpoint between them, we can hit multiple bugs found by Haoran Zhang:

`CONFIG_SCSI=y` is compiled in. vhost-scsi is used when Linux acts as a KVM hypervisor, presenting a SCSI device to guest VMs. HeartSuite Core Secure does not support the KVM host deployment model — KVM and related virtualisation features are not part of the supported configuration (see Deployment Scenarios). This attack path does not apply.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-22121

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

There's issue as follows: BUG: KASAN: use-after-free in ext4_xattr_inode_dec_ref_all+0x6ff/0x790 Read of size 4 at addr ffff88807b003000 by task syz-executor.0/15172

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2025-37785

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Mounting a corrupted filesystem with directory which contains '.' dir entry with rec_len == block size results in out-of-bounds read (later on, when the corrupted directory is removed).

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2025-40364

**Status**: Affected
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

io_req_prep_async() can import provided buffers, commit the ring state by giving up on that before, it'll be reimported later if needed.

`CONFIG_IO_URING=y` is compiled in and 5.19.6 falls within the affected range. io_uring is compiled in. Applications using io_uring for async I/O can reach these paths. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37738

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Once inside 'ext4_xattr_inode_dec_ref_all' we should ignore xattrs entries past the 'end' entry.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2022-49789

**Status**: Affected — hardware absent on server deployments
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — IBM Z Fibre Channel hardware absent

We used to use the wrong type of integer in 'zfcp_fsf_req_send()' to cache the FSF request ID when sending a new FSF request.

`CONFIG_SCSI=y` is compiled in. zfcp is the Fibre Channel driver for IBM Z (mainframe) architecture. This code path does not exist on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49842

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

KASAN reports a use-after-free: BUG: KASAN: use-after-free in device_del+0xb5b/0xc60 Read of size 8 at addr ffff888008655050 by task rmmod/387

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49865

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved remained uninitialized, resulting in a 1-byte infoleak: BUG: KMSAN: kernel-network-i

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53037

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

When the SAS Transport Layer support is enabled and a device exposed to the OS by the driver fails INQUIRY commands, the driver frees up the memory allocated for an internal

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Broadcom mpi3mr SAS 3.0 HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2023-53039

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

When a reset notify IPC message is received, the ISR schedules a work function and passes the ISHTP device to it via a global pointer ishtp_dev.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53065

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

syzkaller reportes a KASAN issue with stack-out-of-bounds. The call trace is as follows: dump_stack+0x9c/0xd3

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37861

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

When the task management thread processes reply queues while the reset thread resets them, the task management thread accesses an invalid queue ID (0xFFFF),

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Broadcom mpi3mr SAS 3.0 HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-37979

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

Case values introduced in commit 5f78e1fb7a3e ("ASoC: qcom: Add driver support for audioreach solution") cause out of bounds access in arrays of sc7280 driver data (e.g. in ca

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49934

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

ieee80211_scan_rx() tries to access scan_req->flags after a null check, but a UAF is observed when the scan is completed and __ieee80211_scan_completed() executes, which then calls

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38103

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

Update struct hid_descriptor to better reflect the mandatory and optional parts of the HID Descriptor as per USB HID 1.11 specification.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38206

**Status**: Affected
**Component**: FAT/exFAT filesystem (`CONFIG_FAT_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

The double free could happen in the following path. exfat_create_upcase_table() exfat_create_upcase_table() : return error

`CONFIG_FAT_FS=y` is compiled in and 5.19.6 falls within the affected range. FAT/exFAT is compiled in (used for the EFI system partition on Debian 11). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38239

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

On a system with DRAM interleave enabled, out-of-bound access is detected: megaraid_sas 0000:3f:00.0: requested/available msix 128/128 poll_queue 0

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the LSI MegaRAID SAS controller driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-38249

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no audio hardware present

In snd_usb_get_audioformat_uac3(), the length value returned from snd_usb_ctl_msg() is used directly for memory allocation without validation.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38389

**Status**: Affected — hardware absent on server deployments
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no Intel display GPU present

The following error has been reported sporadically by CI when a test unbinds the i915 driver on a ring submission platform: <4> [239.330153] ------------[ cut here ]---------

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes may not be created and the GPU context entry points are unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38494

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

hid_hw_raw_request() is actually useful to ensure the provided buffer and length are valid.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38550

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

pmc->idev is still used in ip6_mc_clear_src(), so as mld_clear_delrec() does, the reference should be put after ip6_mc_clear_src() return.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38556

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

Testing by the syzbot fuzzer showed that the HID core gets a shift-out-of-bounds exception when it tries to convert a 32-bit quantity to a 0-bit quantity.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38563

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

The perf mmap code is careful about mmap()'ing the user page with the ringbuffer and additionally the auxiliary buffer, when the event supports it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38565

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

When perf_mmap() fails to allocate a buffer, it still invokes the event_mapped() callback of the related event.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38572

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

syzbot was able to craft a packet with very long IPv6 extension headers leading to an overflow of skb->transport_header.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38699

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

When the bfad_im_probe() function fails during initialization, the memory pointed to by bfad->im is freed without setting bfad->im to NULL.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Brocade bfa Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-38729

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

UAC3 power domain descriptors need to be verified with its variable bLength for avoiding the unexpected OOB accesses by malicious firmware, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39702

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low

To prevent timing attacks, MACs need to be compared in constant time. Use the appropriate helper function for this.

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39757

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no audio hardware present

UAC3 class segment descriptors need to be verified whether their sizes match with the declared lengths and whether they fit with the allocated buffer sizes, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39760

**Status**: Affected
**Component**: USB core (`CONFIG_USB`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

usb_parse_ss_endpoint_companion() checks descriptor type before length, enabling a potentially odd read outside of the buffer size.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. USB core is present. Exploiting USB core bugs typically requires connecting a USB device or having an existing USB device present. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39788

**Status**: Affected — hardware absent on server deployments
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — UFS flash storage absent on x86 server

On Google gs101, the number of UTP transfer request slots (nutrs) is 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE incorrectly as 0.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is used in mobile and embedded platforms. This bug is in the Samsung Exynos UFS variant (`ufs-exynos`). A Debian 11 x86 server has no UFS hardware; the driver is never active.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-50306

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

For scan loop must ensure that at least EXT4_FC_TAG_BASE_LEN space. If remain space less than EXT4_FC_TAG_BASE_LEN which will lead to out of bound read when mounting c

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2023-53257

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

Before checking the action code, check that it even exists in the frame.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53282

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

During the sysfs firmware write process, a use-after-free read warning is logged from the lpfc_wr_object() routine: BUG: KFENCE: use-after-free read in

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Emulex lpfc Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2023-53285

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Normally the extended attributes in the inode body would have been checked when the inode is first opened, but if someone is writing to the block device while the file

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2023-53320

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

The function mpi3mr_get_all_tgt_info() has four issues: 1) It calculates valid entry length in alltgt_info assuming the header part of the struct mpi3mr_device_map_info wou

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Broadcom mpi3mr SAS 3.0 HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2023-53321

**Status**: Affected — hardware absent on server deployments
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

While technically some control frames like ACK are shorter and end after Address 1, such frames shouldn't be forwarded through wmediumd or similar userspace, so require the full 3-address

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53322

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

System crash due to use after free. Current code allows terminate_rport_io to exit before making sure all IOs has returned.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the QLogic qla2xxx Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2022-50378

**Status**: Affected — hardware absent on server deployments
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — Amlogic Meson ARM SoC GPU absent

Unloading the driver triggers the following KASAN warning: [  +0.006275] ============================================================= [  +0.000029] BUG: KASAN:

`CONFIG_DRM=y` is compiled in. drm/meson is the display driver for Amlogic Meson SoC platforms (ARM-based embedded boards such as ODROID, Khadas, etc.). This driver and its hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53376

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using byte as unit.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Broadcom mpi3mr SAS 3.0 HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2023-53392

**Status**: Affected — hardware absent on server deployments
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no USB HID input devices on headless server

During warm reset device->fw_client is set to NULL. If a bus driver is registered after this NULL setting and before new firmware clients are enumerated by ISHTP, kernel panic

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39841

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

Fix a use-after-free window by correcting the buffer release sequence in the deferred receive path.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Emulex lpfc Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-39864

**Status**: Affected — hardware absent on server deployments
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no WiFi NIC present

Following bss_free() quirk introduced in commit 776b3580178f ("cfg80211: track hidden SSID networks properly"), adjust cfg80211_update_known_bss() to free the last beacon frame

`CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment. cfg80211 manages wireless interfaces; without hardware, no interface is created and the affected code paths are unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39866

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

An use-after-free issue occurred when __mark_inode_dirty() get the bdi_writeback that was in the progress of switching.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2022-50422

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

When executing SMP task failed, the smp_execute_task_sg() calls del_timer() to delete "slow_task->timer".

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the SAS libsas library (requires SAS HBA) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2022-50432

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Syzkaller managed to trigger concurrent calls to kernfs_remove_by_name_ns() for the same file resulting in a KASAN detected use-after-free.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2023-53473

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

The ext4_dirhash() will *almost* never fail, especially when the hash tree feature was first introduced.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2023-53510

**Status**: Affected — hardware absent on server deployments
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — UFS flash storage absent on x86 server

ufshcd_queuecommand() may be called two times in a row for a SCSI command before it is completed.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is mobile/embedded storage. The `ufshcd` core driver is compiled in but never instantiated on an x86 server; no UFS host controller hardware is present.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53521

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

A fix for: BUG: KASAN: slab-out-of-bounds in ses_intf_remove+0x23f/0x270 [ses] Read of size 8 at addr ffff88a10d32e5d8 by task rmmod/12013

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the SCSI Enclosure Services (SAS enclosure hardware) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2022-50488

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Our test report a uaf for 'bfqq->bic' in 5.10: ================================================================== BUG: KASAN: use-after-free in bfq_select_queue+0x378/0xa30

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2022-50496

**Status**: Affected
**Component**: device mapper (`CONFIG_BLK_DEV_DM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Dm_cache also has the same UAF problem when dm_resume() and dm_destroy() are concurrent.

`CONFIG_BLK_DEV_DM=y` is compiled in and 5.19.6 falls within the affected range. Device mapper is used for LVM and is active on a standard Debian 11 installation. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup covers writes to protected directories regardless of the block layer.


## CVE-2022-50546

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Syzbot found the following issue: ===================================================== BUG: KMSAN: uninit-value in ext4_evict_inode+0xdd/0x26b0 fs/ext4/inode.c:180

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. The SCSI and VFS layers that expose this path are active for normal disk I/O. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot. File Backup creates a versioned copy before each write to protected directories, so even if an approved program corrupts a file, the previous version remains recoverable from the Dashboard's Backup.


## CVE-2023-53640

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

When we run syzkaller we get below Out of Bounds error. "KASAN: slab-out-of-bounds Read in regcache_flat_read" Below is the backtrace of the issue:

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53675

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

Sanitize possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process().

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the SCSI Enclosure Services (SAS enclosure hardware) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2023-53676

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

The function lio_target_nacl_info_show() uses sprintf() in a loop to print details for every iSCSI connection in a session without checking for the buffer len

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Linux iSCSI target (requires iscsi-target configuration) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-71075

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

The asd_pci_remove() function fails to synchronize with pending tasklets before freeing the asd_ha structure, leading to a potential use-after-free vulnerability.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Adaptec aic94xx SAS HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2026-23076

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no audio hardware present

In the audio mixer handling code of ctxfi driver, the conf field is used as a kind of loop index, and it's referred in the index callbacks (amixer_index() and sum_index

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23078

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The scarlett2_usb_get_config() function has a logic error in the endianness conversion code that can cause buffer overflows when count > 1.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23089

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

When snd_usb_create_mixer() fails, snd_usb_mixer_free() frees mixer->id_elems but the controls already added to the card still reference the freed memory.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23191

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The PCM trigger callback of aloop driver tries to check the PCM state and stop the stream of the tied substream in the corresponding cable.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23193

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 8.8 HIGH (AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 9.0 CRITICAL — hardware-conditional; Lockdown reduces MI: High→Low

In iscsit_dec_session_usage_count(), the function calls complete() while holding the sess->session_usage_lock.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Linux iSCSI target (requires iscsi-target configuration) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2026-23208

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

In this case, the user constructed the parameters with maxpacksize 40 for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23216

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

In iscsit_dec_conn_usage_count(), the function calls complete() while holding the conn->conn_usage_lock.

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the Linux iSCSI target (requires iscsi-target configuration) driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2025-71238

**Status**: Affected — requires specific hardware
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — hardware-conditional; Lockdown reduces MI: High→Low

Kernel panic observed on system, [5353358.825191] BUG: unable to handle page fault for address: ff5f5e897b024000 [5353358.825194] #PF: supervisor write access in kernel mode

`CONFIG_SCSI=y` is compiled in. This vulnerability is in the QLogic qla2xxx Fibre Channel HBA driver. The attack surface is present only on servers equipped with this hardware. On a standard Debian 11 server without this adapter, the driver is compiled in but never bound to hardware, and the affected code path is unreachable.

Where the hardware is present: on a HeartSuite Core Secure system, an attacker cannot run a new exploit binary (no allowlist entry). After gaining root, Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.


## CVE-2026-23318

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — no audio hardware present

The entry of the validators table for UAC3 AC header descriptor is defined with the wrong protocol version UAC_VERSION_2, while it should have been UAC_VERSION_3.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-31581

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

In usb6fire_chip_abort(), the chip struct is allocated as the card's private data (via snd_card_new with sizeof(struct sfire_chip)).

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-3268

**Status**: Affected
**Component**: relay filesystem (`CONFIG_RELAY`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

An out of bounds (OOB) memory access flaw was found in the Linux kernel in relay_file_read_start_pos in kernel/relay.c in the relayfs.

`CONFIG_RELAY=y` is compiled in and 5.19.6 falls within the affected range. The relay filesystem is used by kernel tracing tools (SystemTap, etc.). Access requires `CAP_SYS_ADMIN`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-3567

**Status**: Affected
**Component**: virtual terminal (VT) (`CONFIG_VT`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

A use-after-free flaw was found in vcs_read in drivers/tty/vt/vc_screen.c in vc_screen in the Linux Kernel.

`CONFIG_VT=y` is compiled in and 5.19.6 falls within the affected range. Virtual terminals are present. Exploiting vc_screen bugs requires access to `/dev/vcs*` devices, readable by members of the `tty` group on Debian. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-6531

**Status**: Affected
**Component**: Unix domain sockets (`CONFIG_UNIX`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low

A use-after-free flaw was found in the Linux Kernel due to a race problem in the unix garbage collector's deletion of SKB races with unix_stream_read_generic() on the socket that the SKB is queued on.

`CONFIG_UNIX=y` is compiled in and 5.19.6 falls within the affected range. Unix domain sockets are used by virtually all inter-process communication on a Debian 11 server (systemd, D-Bus, etc.). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-51043

**Status**: Affected
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low

In the Linux kernel before 6.4.5, drivers/gpu/drm/drm_atomic.c has a use-after-free during a race condition between a nonblocking atomic commit and a driver unload.

`CONFIG_DRM=y` is compiled in and 5.19.6 falls within the affected range. The DRM subsystem manages GPU and display hardware. On a server without a display GPU, most DRM paths are inactive. The drm_atomic path specifically requires GPU mode-setting operations. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-0841

**Status**: Affected
**Component**: hugetlbfs (`CONFIG_HUGETLBFS`)
**Base Score**: 6.6 MEDIUM (AV:L/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low

A null pointer dereference flaw was found in the hugetlbfs_fill_super function in the Linux kernel hugetlbfs (HugeTLB pages) functionality.

`CONFIG_HUGETLBFS=y` is compiled in and 5.19.6 falls within the affected range. HugeTLB pages require explicit mmap with `MAP_HUGETLB` or use of hugetlbfs. Not all processes use huge pages; requires specific process behavior. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-26593

**Status**: Affected
**Component**: Intel SMBus I2C controller (`CONFIG_I2C_I801`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

According to the Intel datasheets, software must reset the block buffer index twice for block process call transactions: once before writing the outgoing data to the buffer, and once

`CONFIG_I2C_I801=y` is compiled in and 5.19.6 falls within the affected range. The Intel I2C SMBus controller is present on Intel-based servers (for BMC, temperature sensor, and other management interfaces). Access requires root or membership in the `i2c` group. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-38586

**Status**: Affected
**Component**: Realtek r8169 Ethernet driver (`CONFIG_R8169`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

An issue was found on the RTL8125b when transmitting small fragmented packets, whereby invalid entries were inserted into the transmit ring buffer, subsequently

`CONFIG_R8169=y` is compiled in and 5.19.6 falls within the affected range. The r8169 Realtek Gigabit Ethernet driver is active if the server has a Realtek NIC. Network operation uses this driver continuously. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-38630

**Status**: Affected
**Component**: watchdog timer subsystem (`CONFIG_WATCHDOG`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

When the cpu5wdt module is removing, the origin code uses del_timer() to de-activate the timer.

`CONFIG_WATCHDOG=y` is compiled in and 5.19.6 falls within the affected range. Watchdog timer hardware is present on many servers for reboot-on-hang. This specific bug is in the cpu5wdt driver (a PC-era ISA watchdog timer); this hardware may not be present on modern servers. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-34777

**Status**: Affected
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

While validating node ids in map_benchmark_ioctl(), node_possible() may be provided with invalid argument outside of [0,MAX_NUMNODES-1] range leading to:

`CONFIG_DMA_ENGINE=y` is compiled in and 5.19.6 falls within the affected range. The DMA engine framework is used by storage, network, and crypto subsystems. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-39463

**Status**: Affected
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Fix a use-after-free on dentry's d_fsdata fid list when a thread looks up a fid through dentry while another thread unlinks it: UAF thread:

`CONFIG_9P_FS=y` is compiled in and 5.19.6 falls within the affected range. 9P (Plan 9) filesystem is compiled in and used in virtualised environments for host-guest file sharing. On a bare-metal server without 9P mounts, this code path requires a process that mounts a 9P filesystem. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-40956

**Status**: Affected — hardware absent on server deployments
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — Intel IAX/DSA accelerator hardware absent

Use list_for_each_entry_safe() to allow iterating through the list and deleting the entry in the iteration process.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd is the driver for Intel Data Streaming Accelerator (DSA) and Intelligence Analytics Accelerator (IAX), available in Intel Sapphire Rapids and later server CPUs. These accelerators require specific Intel hardware not present on a standard Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-48867

**Status**: Affected — hardware absent on server deployments
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — Intel IAX/DSA accelerator hardware absent

On driver unload any pending descriptors are flushed at the time the interrupt is freed: idxd_dmaengine_drv_remove() ->

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's Data Streaming Accelerator hardware, present only in Intel Sapphire Rapids (and later) server CPUs. This hardware is not present on a standard Debian 11 deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46759

**Status**: Affected — hardware absent on server deployments
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — ADC128D818 I2C ADC chip absent

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large negative number such as -9223372036854775808 is provided by the user.

`CONFIG_HWMON=y` is compiled in. adc128d818 drives the Texas Instruments ADC128D818 — a specific 8-channel I2C ADC chip used on some custom boards. This chip is not part of standard server hardware; the hwmon driver is never bound.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-49860

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Only buffer objects are valid return values of _STR. If something else is returned description_show() will access invalid memory.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI is present on all x86 servers and is active from boot. Most ACPI bugs are triggered via ACPI table parsing or sysfs interfaces accessible to root. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49029

**Status**: Affected — hardware absent on server deployments
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — IBM Power Management Extension hardware absent

Smatch report warning as follows: drivers/hwmon/ibmpex.c:509 ibmpex_register_bmc() warn: '&data->list' not removed from list

`CONFIG_HWMON=y` is compiled in. ibmpex drives the IBM Power Management Extension, specific to IBM Power Systems server hardware. This is not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50127

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In 'taprio_change()', 'admin' pointer may become dangling due to sched switch / removal caused by 'advance_sched()', and critical section protected by 'q->current_entry_lock' is to

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50131

**Status**: Affected
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

strlen() returns a string length excluding the null byte. If the string length equals to the maximum buffer length, the buffer will have no space for the NULL t

`CONFIG_TRACING=y` is compiled in and 5.19.6 falls within the affected range. Kernel tracing requires root or `CAP_SYS_ADMIN` to configure. On a production server, tracing is not normally active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-53057

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In qdisc_tree_reduce_backlog, Qdiscs with major handle ffff: are assumed to be either root or ingress.

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56606

**Status**: Affected
**Component**: AF_PACKET sockets (`CONFIG_PACKET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

After sock_init_data() the allocated sk object is attached to the provided sock object.

`CONFIG_PACKET=y` is compiled in and 5.19.6 falls within the affected range. AF_PACKET raw sockets are used by packet capture tools (`tcpdump`, etc.). Creating AF_PACKET sockets requires `CAP_NET_RAW`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-21692

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Haowei Yan <g1042620637@gmail.com> found that ets_class_from_arg() can index an Out-Of-Bound class in ets_class_from_arg() when passed clid of 0.

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49799

**Status**: Affected
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In register_synth_event(), if set_synth_event_print_fmt() failed, then both trace_remove_event_call() and unregister_trace_event() will be called, which means the trace_eve

`CONFIG_TRACING=y` is compiled in and 5.19.6 falls within the affected range. Kernel tracing requires root or `CAP_SYS_ADMIN` to configure. On a production server, tracing is not normally active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49892

**Status**: Affected
**Component**: ftrace / function tracer (`CONFIG_FTRACE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

KASAN reported a use-after-free with ftrace ops [1]. It was found from vmcore that perf had registered two ops with the same content successively, both dynamic.

`CONFIG_FTRACE=y` is compiled in and 5.19.6 falls within the affected range. ftrace is the kernel function tracer. Configuring ftrace requires `CAP_SYS_ADMIN` and is not active in normal production operation. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49921

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

We can't use "skb" again after passing it to qdisc_enqueue(). This is basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb len before calling child enqueue").

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53111

**Status**: Affected
**Component**: loop block device (`CONFIG_BLK_DEV_LOOP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

do_req_filebacked() calls blk_mq_complete_request() synchronously or asynchronously when using asynchronous I/O unless memory allocation fails.

`CONFIG_BLK_DEV_LOOP=y` is compiled in and 5.19.6 falls within the affected range. Loop devices are present on Debian 11 (used for snaps, container images, etc.). Exploiting this requires loop device operations with `CAP_SYS_ADMIN`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37879

**Status**: Affected
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In p9_client_write() and p9_client_read_once(), if the server incorrectly replies with success but a negative write/read count then we would consider written (nega

`CONFIG_9P_FS=y` is compiled in and 5.19.6 falls within the affected range. 9P (Plan 9) filesystem is compiled in and used in virtualised environments for host-guest file sharing. On a bare-metal server without 9P mounts, this code path requires a process that mounts a 9P filesystem. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37914

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37915

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.1 HIGH — Lockdown reduces MI: High→Low

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-37923

**Status**: Affected
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

syzbot reported this bug: ================================================================== BUG: KASAN: slab-out-of-bounds in trace_seq_to_buffer kernel/trace/trace.c:1830 [inline]

`CONFIG_TRACING=y` is compiled in and 5.19.6 falls within the affected range. Kernel tracing requires root or `CAP_SYS_ADMIN` to configure. On a production server, tracing is not normally active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38369

**Status**: Affected — hardware absent on server deployments
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — Intel IAX/DSA accelerator hardware absent

Running IDXD workloads in a container with the /dev directory mounted can trigger a call trace or even a kernel panic when the parent proces

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's on-chip Data Streaming and Analytics Accelerator hardware. This requires specific Intel Sapphire Rapids or later CPU hardware not present on a standard server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-38548

**Status**: Affected — hardware absent on server deployments
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — Corsair Commander Pro hardware absent

Add buffer_recv_size to store the size of the received bytes. Validate buffer_recv_size in send_usb_cmd().

`CONFIG_HWMON=y` is compiled in. corsair-cpro drives the Corsair Commander Pro — a desktop PC fan/cooler controller connected via USB HID. This device is not present in a production server environment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-50320

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

On a Packard Bell Dot SC (Intel Atom N2600 model) there is a FPDT table which contains invalid physical addresses, with high bits set which fall outside t

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI is present on all x86 servers and is active from boot. Most ACPI bugs are triggered via ACPI table parsing or sysfs interfaces accessible to root. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2023-53395

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

ACPICA commit 90310989a0790032f5a0140741ff09b545af4bc5 According to the ACPI specification 19.6.134, no argument is required to be passed for ASL Timer instruction.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI is present on all x86 servers and is active from boot. Most ACPI bugs are triggered via ACPI table parsing or sysfs interfaces accessible to root. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2025-39869

**Status**: Affected — hardware absent on server deployments
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 0.0 — Texas Instruments eDMA hardware absent

Fix a critical memory allocation bug in edma_setup_from_hw() where queue_priority_map was allocated with insufficient memory.

`CONFIG_DMA_ENGINE=y` is compiled in. ti-edma is the DMA controller driver for Texas Instruments Keystone/OMAP/AM embedded SoC platforms. This driver and hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-50423

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

There is an use-after-free reported by KASAN: BUG: KASAN: use-after-free in acpi_ut_remove_reference+0x3b/0x82 Read of size 1 at addr ffff888112afc460 by task

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI is present on all x86 servers and is active from boot. Most ACPI bugs are triggered via ACPI table parsing or sysfs interfaces accessible to root. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2026-23378

**Status**: Affected
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Whenever an ife action replace changes the metalist, instead of replacing the old data on the metalist, the current ife code is appending the new metadata.

`CONFIG_NET_SCHED=y` is compiled in and 5.19.6 falls within the affected range. The traffic control scheduler is present and used by the kernel network stack. Exploiting most tc bugs requires `CAP_NET_ADMIN` to configure qdiscs. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-36883

**Status**: Affected
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

net_alloc_generic is called by net_alloc, which is called without any locking. It reads max_gen_ptrs, which is changed under pernet_ops_rwsem.

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP/IP stack is always active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-36971

**Status**: Affected
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

__dst_negative_advice() does not enforce proper RCU rules when sk->dst_cache must be cleared, leading to possible UAF.

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP/IP stack is always active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-38577

**Status**: Affected
**Component**: RCU tasks subsystem (`CONFIG_TASKS_RCU`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

There is a possibility of buffer overflow in show_rcu_tasks_trace_gp_kthread() if counters, passed to sprintf() are huge.

`CONFIG_TASKS_RCU=y` is compiled in and 5.19.6 falls within the affected range. RCU tasks is a core kernel synchronisation mechanism, active at all times. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-40958

**Status**: Affected
**Component**: network namespaces (`CONFIG_NET_NS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Syzkaller hit a warning: refcount_t: addition on 0; use-after-free. WARNING: CPU: 3 PID: 7890 at lib/refcount.c:25 refcount_warn_saturate+0xdf/0x1d0

`CONFIG_NET_NS=y` is compiled in and 5.19.6 falls within the affected range. Network namespaces are used by containers and process isolation. Creating network namespaces requires `CAP_SYS_ADMIN` (or user namespaces, which are disabled on the HS kernel). On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-41039

**Status**: Affected — hardware absent on server deployments
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — no audio hardware present

Fix the checking that firmware file buffer is large enough for the wmfw header, to prevent overrunning the buffer.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46713

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Ole reported that event->mmap_mutex is strictly insufficient to serialize the AUX buffer, add a per RB mutex to fully serialize it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-46852

**Status**: Affected
**Component**: DMA-BUF shared buffer (`CONFIG_DMA_SHARED_BUFFER`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Until VM_DONTEXPAND was added in commit 1c1914d6e8c6 ("dma-buf: heaps: Don't track CMA dma-buf pages under RssFile") it was possible to obtain a mapping larger than the buff

`CONFIG_DMA_SHARED_BUFFER=y` is compiled in and 5.19.6 falls within the affected range. DMA-BUF is used by GPU and multimedia subsystems for zero-copy buffer sharing. Requires access to a DRM or V4L2 device. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-48950

**Status**: Affected
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Per syzbot it is possible for perf_pending_task() to run after the event is free()'d.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. The perf events subsystem is accessible to processes depending on `/proc/sys/kernel/perf_event_paranoid`. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2022-49026

**Status**: Affected
**Component**: Intel e100 Fast Ethernet driver (`CONFIG_E100`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will resend the skb.

`CONFIG_E100=y` is compiled in and 5.19.6 falls within the affected range. The Intel e100 driver supports legacy Intel Fast Ethernet cards. If this NIC is present, the driver is active during normal network operation. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50055

**Status**: Affected
**Component**: core kernel (`CONFIG_BASE_FULL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

For bus_register(), any error which happens after kset_register() will cause that @priv are freed twice, fixed by setting @priv with NULL after the first free.

`CONFIG_BASE_FULL=y` is compiled in and 5.19.6 falls within the affected range. This is a core kernel driver infrastructure bug (bus/device management). Driver probe and removal paths are active during device enumeration. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50112

**Status**: Affected
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

Linear Address Masking (LAM) has a weakness related to transient execution as described in the SLAM paper[1].

`CONFIG_X86_64=y` is compiled in and 5.19.6 falls within the affected range. This is an architecture-level bug in x86_64 address masking. The affected code path requires a process to use Linear Address Masking (LAM), which requires `ARCH_SET_GS`/`ARCH_SET_FS` with a tagged pointer. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-50193

**Status**: Affected
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

CPU buffers are currently cleared after call to exc_nmi, but before register state is restored.

`CONFIG_X86_64=y` is compiled in and 5.19.6 falls within the affected range. This is an architecture-level bug in x86_64 address masking. The affected code path requires a process to use Linear Address Masking (LAM), which requires `ARCH_SET_GS`/`ARCH_SET_FS` with a tagged pointer. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56600

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

sock_init_data() attaches the allocated sk pointer to the provided sock object. If inet6_create() fails later, the sk object is released, but the sock object retains

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 is compiled in and the stack is active when IPv6 is configured. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56601

**Status**: Affected
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 7.9 HIGH — Lockdown reduces MI: High→Low

sock_init_data() attaches the allocated sk object to the provided sock object. If inet_create() fails later, the sk object is freed, but the sock object retains the da

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP/IP stack is always active. On a HeartSuite Core Secure system in Secure Mode, reaching this code path requires an approved process to invoke the relevant kernel interface. An attacker cannot execute a new exploit binary — it has no allowlist entry and the kernel refuses to run it. After gaining root, Lockdown closes the post-exploitation path: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.


## CVE-2024-56616

**Status**: Affected — hardware absent on server deployments
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Environmental Score**: 0.0 — DisplayPort MST display hardware absent

Fix the MST sideband message body length check, which must be at least 1 byte accounting for the message body CRC (aka message data CRC) at the end of the message.

`CONFIG_DRM=y` is compiled in. DisplayPort Multi-Stream Transport (DP MST) is used for daisy-chaining multiple monitors via DisplayPort. A headless server has no display output hardware; the DP MST sideband message path is never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

## Not Affected — Disabled Features {#not-affected-disabled-features}

HeartSuite Core Secure is built for production servers, regulated workstations, build infrastructure, and AI agent sandboxes. The kernel does not include subsystems these workloads do not require. Each absent subsystem eliminates the full class of vulnerabilities that subsystem carries, without requiring per-CVE evaluation.

Where a CVE in this section achieves root privilege, Lockdown provides the same backstop described in [CVE-2026-31431](#cve-2026-31431) — `chattr +i` filesystem immutability combined with the kernel refusing runtime allowlist changes means an attacker who reaches root in Secure Mode + Lockdown has no path to persistence or to modifying the allowlist.

| Config gate | CVEs covered | Status |
|-------------|-------------|--------|
| [`CONFIG_BPF_SYSCALL` not set](#bpf-syscall-interface) | CVE-2021-20194, CVE-2023-2163, CVE-2023-39191, CVE-2023-52452, CVE-2024-26589, CVE-2023-52621, CVE-2023-52642, CVE-2024-26883, CVE-2024-26884, CVE-2024-26885, CVE-2024-38538, CVE-2024-40954, CVE-2024-41045, CVE-2024-49861, CVE-2022-49030, CVE-2024-50063, CVE-2024-50067, CVE-2024-50164, CVE-2024-50262, CVE-2024-53099, CVE-2024-56614, CVE-2024-56615, CVE-2024-56633, CVE-2024-56664, CVE-2023-53024, CVE-2022-49840, CVE-2025-37822, CVE-2022-49961, CVE-2022-49970, CVE-2022-49975, CVE-2025-38280, CVE-2025-38502, CVE-2025-38538, CVE-2025-39744, CVE-2023-53192, CVE-2023-53338, CVE-2025-39913, CVE-2022-50490, CVE-2022-50536, CVE-2026-23343, CVE-2026-23359  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NF_TABLES` not set](#netfilter-nftables) | CVE-2023-32233, CVE-2023-0179, CVE-2023-3390, CVE-2023-31248, CVE-2023-35001, CVE-2023-3610, CVE-2023-4004, CVE-2023-3777, CVE-2023-4015, CVE-2023-4244, CVE-2023-6817, CVE-2024-1085, CVE-2023-52628, CVE-2024-26673, CVE-2024-27020, CVE-2024-27065, CVE-2024-27397, CVE-2024-35896, CVE-2024-41042, CVE-2024-44983, CVE-2024-50257, CVE-2024-53141, CVE-2024-56650, CVE-2023-52927, CVE-2025-22056, CVE-2022-49919, CVE-2025-38201, CVE-2023-53179, CVE-2023-53492, CVE-2023-53619, CVE-2026-23231, CVE-2023-4147  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_SCH_QFQ`, `CONFIG_NET_CLS_TCINDEX` not set](#network-traffic-control-schedulers) | CVE-2023-31436, CVE-2023-1829, CVE-2023-1281 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BT` not set](#bluetooth-stack) | CVE-2022-42896, CVE-2022-45934, CVE-2022-3564, CVE-2022-3640, CVE-2023-1989, and 3 additional, CVE-2023-40283, CVE-2024-21803, CVE-2024-27000, CVE-2024-27398, CVE-2024-35963, CVE-2024-35965, CVE-2024-35966, CVE-2024-35967, CVE-2023-52766, CVE-2024-36012, CVE-2024-36032, CVE-2024-36880, CVE-2024-40927, CVE-2024-41087, CVE-2022-48871, CVE-2022-48878, CVE-2024-43883, CVE-2024-49950, CVE-2024-50125, CVE-2024-50234, CVE-2024-53208, CVE-2024-56604, CVE-2024-56605, CVE-2025-21969, CVE-2025-22022, CVE-2022-49826, CVE-2022-49910, CVE-2023-53057, CVE-2025-37882, CVE-2023-53145, CVE-2025-38117, CVE-2025-38118, CVE-2025-38250, CVE-2025-38593, CVE-2022-50315, CVE-2023-53252, CVE-2023-53305, CVE-2022-50386, CVE-2023-53386, CVE-2022-50419, CVE-2022-50470, CVE-2023-53673, CVE-2025-71082, CVE-2026-23395, CVE-2026-31500  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TLS`, `CONFIG_RDS`, `CONFIG_ROSE`, `CONFIG_MCTP`, `CONFIG_AF_RXRPC` not set](#protocol-families-tls-rds-rose-mctp-and-af_rxrpc) | CVE-2023-28466, CVE-2023-1078, CVE-2022-2961, CVE-2022-3977, CVE-2023-2006 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NFSD` not set](#nfs-server) | CVE-2022-43945, CVE-2022-4379, CVE-2023-1652, CVE-2024-26907, CVE-2023-52885, CVE-2024-50106, CVE-2024-50121, CVE-2024-53168, CVE-2025-38724, CVE-2022-50235, CVE-2022-50241, CVE-2022-50401, CVE-2022-50410, CVE-2023-53680, CVE-2026-22980  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NTFS3_FS`, `CONFIG_NTFS_FS`, `CONFIG_XFS_FS`, `CONFIG_JFS_FS`, `CONFIG_NILFS2_FS` not set](#filesystem-drivers) | CVE-2022-48423, CVE-2022-48424, CVE-2022-48425, CVE-2023-26544, CVE-2023-26506, CVE-2023-26507, CVE-2023-2124, CVE-2020-27815, CVE-2022-2978 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DVB_CORE`, `CONFIG_SGI_GRU`, `CONFIG_FPGA`, `CONFIG_KVM_INTEL` not set](#hardware-specific-and-virtualization-drivers) | CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919, CVE-2022-3424, CVE-2023-26242, CVE-2022-2196 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_NET_RNDIS_WLAN`, `CONFIG_SMB_SERVER` not set](#usb-network-adapter-and-smb-server) | CVE-2023-23559, CVE-2023-0210 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_ADV748X` not set](#config-video-adv748x) | CVE-2025-71136 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MD_RAID10` not set](#config-md-raid10) | CVE-2023-53357 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_NET_CDCETHER` not set](#config-usb-net-cdcether) | CVE-2025-38153 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_XLNX` not set](#config-drm-xlnx) | CVE-2024-56538 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_LAN78XX` not set](#config-usb-lan78xx) | CVE-2024-53213 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HYPERV_VSOCKETS` not set](#config-hyperv-vsockets) | CVE-2024-53103 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_XE` not set](#drm-xe-driver) | CVE-2024-53098 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ARM_SCMI_PROTOCOL` not set](#config-arm-scmi-protocol) | CVE-2024-53068 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_S5P_JPEG` not set](#config-video-s5p-jpeg) | CVE-2024-53061 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MSE102X` not set](#config-mse102x) | CVE-2024-50276 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TYPEC` not set](#config-typec) | CVE-2024-50150 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HSR` not set](#config-hsr) | CVE-2022-49015 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HI_GMAC` not set](#config-hi-gmac) | CVE-2022-48960, CVE-2022-48962 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_STM` not set](#config-drm-stm) | CVE-2024-49992 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PCI_KIRIN` not set](#config-pci-kirin) | CVE-2024-47751 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_ASPEED_GFX` not set](#config-drm-aspeed-gfx) | CVE-2023-52916 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BNA` not set](#config-bna) | CVE-2024-43839 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CRYPTO_DEV_HISI_SEC2` not set](#config-crypto-dev-hisi-sec2) | CVE-2024-42147, CVE-2024-47730 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IONIC` not set](#config-ionic) | CVE-2024-39502 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_GREYBUS` not set](#config-greybus) | CVE-2024-39495 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_STM` not set](#config-stm) | CVE-2024-38627 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DEBUG_MUTEXES` not set](#config-debug-mutexes) | CVE-2023-52836 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RCU_NOCB_CPU` not set](#config-rcu-nocb-cpu) | CVE-2024-35929, CVE-2025-38704 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SECURITY_APPARMOR` not set](#config-security-apparmor) | CVE-2026-23408 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MACVLAN` not set](#config-macvlan) | CVE-2026-23001 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_TEAM` not set](#config-net-team) | CVE-2025-71091 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DLM` not set](#config-dlm) | CVE-2023-53629 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TRACE_BUF` not set](#config-trace-buf) | CVE-2023-53587 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PTP_1588_CLOCK_OCP` not set](#config-ptp-1588-clock-ocp) | CVE-2025-39859 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_XDP_SOCKETS` not set](#config-xdp-sockets) | CVE-2023-53426 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NUBUS` not set](#config-nubus) | CVE-2023-53217 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_COMEDI` not set](#config-comedi) | CVE-2025-38482, CVE-2025-38483, CVE-2025-38529, CVE-2025-38530, CVE-2025-39685, CVE-2025-39686 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IPV6_SEG6_LWTUNNEL` not set](#config-ipv6-seg6-lwtunnel) | CVE-2025-38476 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CORESIGHT` not set](#config-coresight) | CVE-2025-38131 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_STAGING` not set](#config-staging) | CVE-2022-49956, CVE-2023-53554 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MCB` not set](#config-mcb) | CVE-2025-37817 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_UDMABUF` not set](#config-udmabuf) | CVE-2025-37803 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SLIMBUS` not set](#config-slimbus) | CVE-2025-21914 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_GENEVE` not set](#config-geneve) | CVE-2025-21858 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ORANGEFS_FS` not set](#config-orangefs-fs) | CVE-2025-21782 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PKTGEN` not set](#config-pktgen) | CVE-2025-21680 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SPI_MPC52xx` not set](#config-spi-mpc52xx) | CVE-2024-50051 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SUPERH` not set](#config-superh) | CVE-2024-53165 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_MUSB_HDRC` not set](#config-usb-musb-hdrc) | CVE-2024-50269 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_SERIAL` not set](#config-usb-serial) | CVE-2024-50267 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VDPA` not set](#config-vdpa) | CVE-2024-47748, CVE-2024-53126, CVE-2023-53082, CVE-2023-53543 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SPI_NXP_FLEXSPI` not set](#config-spi-nxp-flexspi) | CVE-2024-46853 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_UML` not set](#config-uml) | CVE-2024-46844 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_SCH_NETEM` not set](#config-net-sch-netem) | CVE-2024-46800 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PARISC` not set](#config-parisc) | CVE-2024-44949, CVE-2022-50518 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_FOU` not set](#config-net-fou) | CVE-2024-44940, CVE-2026-23083 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VHOST_VSOCK` not set](#config-vhost-vsock) | CVE-2024-43873 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IIO` not set](#config-iio) | CVE-2024-42086, CVE-2024-57906, CVE-2024-57907, CVE-2024-57908, CVE-2024-57910, CVE-2024-57911, CVE-2024-57912, CVE-2022-49792, CVE-2025-38485 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SND_SOC` not set](#config-snd-soc) | CVE-2024-41069, CVE-2022-50325 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CACHEFILES` not set](#config-cachefiles) | CVE-2024-41050, CVE-2024-41057, CVE-2024-41074 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_WWAN` not set](#config-wwan) | CVE-2024-40939 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VMWARE_VMCI` not set](#config-vmware-vmci) | CVE-2024-39499, CVE-2024-46738, CVE-2025-38403 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BONDING` not set](#config-bonding) | CVE-2024-39487, CVE-2026-23099 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TEE` not set](#tee-subsystem) | CVE-2023-52503 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_INPUT_POWERMATE` not set](#powermate-driver) | CVE-2023-52475 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PWM` not set](#pwm-subsystem) | CVE-2024-26599 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_PVRUSB2` not set](#pvrusb2-driver) | CVE-2023-52445 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ATALK` not set](#appletalk) | CVE-2023-51781 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IGB` not set](#igb-driver) | CVE-2023-45871 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_RKVDEC` not set](#rkvdec-driver) | CVE-2023-35829 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_RENESAS_USBHS3` not set](#renesas-usb3) | CVE-2023-35828 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_SUNXI_CEDRUS` not set](#cedrus-driver) | CVE-2023-35826 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_DM1105` not set](#dm1105-driver) | CVE-2023-35824 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_SAA7134` not set](#saa7134-driver) | CVE-2023-35823 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_CLS_U32` not set](#tc-cls-u32) | CVE-2026-23204 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_WILC1000` not set](#wilc1000-driver) | CVE-2025-39952 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MWIFIEX` not set](#mwifiex-driver) | CVE-2025-39891 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_AF_RXRPC` not set](#config-af-rxrpc) | CVE-2023-53218 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_SCH_QFQ` not set](#config-net-sch-qfq) | CVE-2025-37913 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NTFS_FS` not set](#config-ntfs-fs) | CVE-2022-49763 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IP_SCTP` not set](#sctp-protocol) | CVE-2025-23142, CVE-2025-38718, CVE-2022-50243, CVE-2023-53372  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MEMSTICK` not set](#memstick) | CVE-2025-22020, CVE-2023-3141  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BRCMFMAC` not set](#brcmfmac-driver) | CVE-2022-49740, CVE-2022-50258, CVE-2023-53213, CVE-2022-50408, CVE-2025-39863, CVE-2022-50551  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RTLWIFI` not set](#rtlwifi-driver) | CVE-2024-58072, CVE-2022-50279  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_LOONGARCH` not set](#loongarch-arch) | CVE-2024-56628 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_UDF_FS` not set](#udf-filesystem) | CVE-2024-50143, CVE-2022-49846, CVE-2023-53107, CVE-2023-53506  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RMNET` not set](#rmnet-driver) | CVE-2024-50128, CVE-2024-26597  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PPP` not set](#ppp) | CVE-2024-50033, CVE-2024-50035, CVE-2025-37749, CVE-2025-38574  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_XEN` not set](#xen-hypervisor) | CVE-2024-49936, CVE-2024-56704  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_OCFS2_FS` not set](#ocfs2-filesystem) | CVE-2024-47670, CVE-2024-49966, CVE-2024-53155, CVE-2024-57892, CVE-2025-22079, CVE-2023-53081  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PLATFORM_X86` not set](#config-platform-x86) | CVE-2024-46859, CVE-2024-49986, CVE-2025-38077  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ISDN` not set](#isdn) | CVE-2024-42280 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HFSPLUS_FS` not set](#hfsplus-filesystem) | CVE-2024-41059, CVE-2024-56548, CVE-2025-38713, CVE-2025-38714  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_XFS_FS` not set](#config-xfs-fs) | CVE-2024-41013, CVE-2024-41014, CVE-2025-39835, CVE-2022-50406  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PPC` not set](#powerpc-arch) | CVE-2024-40974, CVE-2024-46774, CVE-2022-48998, CVE-2024-56765, CVE-2025-38088, CVE-2025-39776, CVE-2023-53487, CVE-2025-71078, CVE-2023-52451  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IMA` not set](#ima) | CVE-2024-38667, CVE-2024-53106, CVE-2024-57798, CVE-2025-39730  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_SCH_MULTIQ` not set](#tc-multiq) | CVE-2024-36978 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_VMWGFX` not set](#vmwgfx-driver) | CVE-2024-36960 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PINCTRL` not set](#pinctrl) | CVE-2024-36940, CVE-2025-38286  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_GPIOLIB` not set](#gpiolib) | CVE-2024-36898, CVE-2024-36899, CVE-2024-42092, CVE-2025-38395  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TIPC` not set](#tipc-protocol) | CVE-2024-36886, CVE-2024-42284, CVE-2022-49017, CVE-2024-56642, CVE-2025-38052, CVE-2025-38464  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PPDEV` not set](#ppdev-driver) | CVE-2024-36015 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_RADEON` not set](#radeon-driver) | CVE-2023-52867 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_WMI` not set](#wmi-driver) | CVE-2023-52864 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HW_PERF_EVENTS_HISI` not set](#config-hw-perf-events-hisi) | CVE-2023-52859, CVE-2024-38569  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_VIDEO_BT848` not set](#bttv-driver) | CVE-2023-52847 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RMI4_CORE` not set](#rmi4-driver) | CVE-2023-52840 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BLK_DEV_NBD` not set](#nbd-driver) | CVE-2023-52837, CVE-2024-49855, CVE-2025-38443  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_KVM_AMD` not set](#kvm-amd) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HNS3` not set](#hns3-driver) | CVE-2023-52807, CVE-2024-46833, CVE-2025-71112  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IPVLAN` not set](#ipvlan) | CVE-2023-52796 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SMC` not set](#smc-driver) | CVE-2023-52775, CVE-2024-56640, CVE-2024-57791, CVE-2025-38734  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_GSPCA_CORE` not set](#gspca-driver) | CVE-2023-52764 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_GFS2_FS` not set](#gfs2-filesystem) | CVE-2023-52760, CVE-2024-38570, CVE-2023-53622  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_FB` not set](#config-fb) | CVE-2023-52731, CVE-2024-49924, CVE-2024-50180, CVE-2025-38685, CVE-2025-38702  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DMA_DIRECT_REMAP` not set](#config-dma-direct-remap) | CVE-2024-35939 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_AX25` not set](#ax25-hamradio) | CVE-2024-35887, CVE-2026-23098  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MLX5_CORE` not set](#mlx5-driver) | CVE-2023-52667, CVE-2024-38555, CVE-2024-38556, CVE-2024-40940, CVE-2022-48883, CVE-2022-49025, CVE-2023-53340  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ATLANTIC` not set](#atlantic-driver) | CVE-2023-52664 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_KVM` not set](#config-kvm) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_FIREWIRE` not set](#firewire) | CVE-2024-27401, CVE-2023-53432  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_OPENVSWITCH` not set](#openvswitch) | CVE-2024-27395, CVE-2025-37789, CVE-2025-38146  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_EROFS_FS` not set](#erofs-filesystem) | CVE-2022-48674, CVE-2024-41058  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_OF` not set](#config-of) | CVE-2022-48672 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_PECI` not set](#config-peci) | CVE-2022-48670 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DVB_CORE` not set](#config-dvb-core) | CVE-2024-27075, CVE-2024-43900, CVE-2024-47697, CVE-2024-47698, CVE-2025-38227, CVE-2022-50274, CVE-2023-53219, CVE-2022-50499  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_NOUVEAU` not set](#nouveau-driver) | CVE-2024-27008, CVE-2022-50454  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_GADGET` not set](#usb-gadget) | CVE-2024-26996, CVE-2024-46836, CVE-2022-48948, CVE-2024-58055, CVE-2022-49980, CVE-2025-38497, CVE-2025-38555  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_COMMON_CLK_QCOM` not set](#config-common-clk-qcom) | CVE-2024-26965 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NILFS2_FS` not set](#config-nilfs2-fs) | CVE-2024-26955, CVE-2024-26956, CVE-2024-26981, CVE-2024-38583, CVE-2024-37078, CVE-2024-39469, CVE-2024-42104, CVE-2024-42105, CVE-2024-47757, CVE-2024-50230, CVE-2022-49834, CVE-2023-53035, CVE-2023-53311, CVE-2022-50367, CVE-2022-50478, CVE-2023-53608  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ARM64` not set](#arm64-arch) | CVE-2022-48657, CVE-2024-26989, CVE-2024-40989, CVE-2025-21785, CVE-2022-49888, CVE-2025-37849, CVE-2024-26598  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MLXBF_I2C` not set](#config-mlxbf-i2c) | CVE-2022-48632 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TUN` not set](#tun-tap-driver) | CVE-2024-26882, CVE-2022-49014, CVE-2023-3812  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RDS` not set](#config-rds) | CVE-2024-26865, CVE-2022-48637, CVE-2024-27024, CVE-2024-42138, CVE-2024-42148, CVE-2024-46782, CVE-2024-46786, CVE-2024-57900, CVE-2025-23156, CVE-2025-23158, CVE-2023-53075, CVE-2025-37921, CVE-2025-39710, CVE-2022-50412, CVE-2023-53541, CVE-2025-39967, CVE-2026-31578  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SPARX5_SWITCH` not set](#config-sparx5-switch) | CVE-2024-26856 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_THINKPAD_LMI` not set](#config-thinkpad-lmi) | CVE-2024-26836 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_BTRFS_FS` not set](#btrfs-filesystem) | CVE-2024-26791, CVE-2024-26944, CVE-2024-35849, CVE-2024-35949, CVE-2024-39496, CVE-2024-42314, CVE-2024-50217, CVE-2024-56581, CVE-2024-56582, CVE-2024-56759, CVE-2024-57896, CVE-2025-39738, CVE-2025-39759, CVE-2022-50300  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MPTCP` not set](#mptcp) | CVE-2024-26782, CVE-2024-44974, CVE-2024-46858, CVE-2024-50083, CVE-2023-53072, CVE-2023-53088, CVE-2025-38552  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DM_CRYPT` not set](#config-dm-crypt) | CVE-2024-26763 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_GTP` not set](#config-gtp) | CVE-2024-26754, CVE-2024-26793, CVE-2024-27396, CVE-2024-44999  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CRYPTO_DEV_VIRTIO` not set](#config-crypto-dev-virtio) | CVE-2024-26753 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_USB_CDNS3` not set](#config-usb-cdns3) | CVE-2024-26748, CVE-2024-26749 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_ACT_MIRRED` not set](#tc-act-mirred) | CVE-2024-26739 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_AFS_FS` not set](#config-afs-fs) | CVE-2024-26736 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IP_TUNNEL` not set](#config-ip-tunnel) | CVE-2024-26665, CVE-2023-53600  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MHI_BUS` not set](#config-mhi-bus) | CVE-2023-52494, CVE-2025-39790  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_LLC` not set](#config-llc) | CVE-2024-26625 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_JFS_FS` not set](#config-jfs-fs) | CVE-2023-52599, CVE-2023-52600, CVE-2023-52603, CVE-2023-52604, CVE-2023-52799, CVE-2023-52804, CVE-2023-52805, CVE-2024-40902, CVE-2024-43858, CVE-2024-47723, CVE-2024-49900, CVE-2024-49903, CVE-2024-56595, CVE-2024-56596, CVE-2024-56597, CVE-2024-56598, CVE-2025-38204, CVE-2025-38230, CVE-2025-38697, CVE-2025-39743, CVE-2022-50333, CVE-2023-53222, CVE-2023-53485, CVE-2023-53616  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_S390` not set](#config-s390) | CVE-2023-52598, CVE-2024-26957, CVE-2023-52669, CVE-2024-36931, CVE-2024-45026, CVE-2022-48954, CVE-2024-57838, CVE-2024-57849, CVE-2022-49804, CVE-2023-53123, CVE-2025-38257, CVE-2025-38320, CVE-2022-50307, CVE-2023-53205, CVE-2026-31568  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_MSM` not set](#config-drm-msm) | CVE-2023-52586, CVE-2023-53316, CVE-2022-50368, CVE-2022-50437, CVE-2022-50492, CVE-2022-50526  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SECURITY_TOMOYO` not set](#config-security-tomoyo) | CVE-2024-26622 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IWLWIFI` not set](#iwlwifi-driver) | CVE-2023-52531, CVE-2024-26610, CVE-2024-36921, CVE-2024-40929, CVE-2024-53059, CVE-2025-21905, CVE-2022-50248, CVE-2023-53524  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SPI_SUN6I` not set](#config-spi-sun6i) | CVE-2023-52517 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_INFINIBAND` not set](#infiniband-rdma) | CVE-2023-52515, CVE-2024-26872, CVE-2022-48694, CVE-2023-52851, CVE-2024-38545, CVE-2024-42285, CVE-2025-38024, CVE-2025-38211, CVE-2025-71133, CVE-2026-31493  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IEEE802154` not set](#ieee802154-wpan) | CVE-2023-52510, CVE-2024-56602  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_RAVB` not set](#ravb-driver) | CVE-2023-52509, CVE-2022-48964, CVE-2023-35827  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NFC` not set](#nfc) | CVE-2023-52507, CVE-2024-36915, CVE-2022-48967, CVE-2025-21735, CVE-2023-53106, CVE-2025-38416, CVE-2023-53495  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_FUSE_FS` not set](#fuse-filesystem) | CVE-2023-52504, CVE-2024-35932, CVE-2024-41090, CVE-2024-41091, CVE-2024-58054, CVE-2022-49945, CVE-2025-38385, CVE-2023-53286, CVE-2023-53577  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_MCTP` not set](#config-mctp) | CVE-2023-52483 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ATH` not set](#ath-wireless-driver) | CVE-2023-52464, CVE-2023-52594, CVE-2023-52491, CVE-2024-26958, CVE-2024-26983, CVE-2024-26988, CVE-2024-27043, CVE-2023-52679, CVE-2024-35847, CVE-2023-52777, CVE-2023-52827, CVE-2024-36906, CVE-2024-36979, CVE-2024-38578, CVE-2024-38621, CVE-2024-41096, CVE-2024-42271, CVE-2024-43830, CVE-2022-48873, CVE-2022-48881, CVE-2024-46674, CVE-2024-47695, CVE-2024-47742, CVE-2024-49930, CVE-2024-49931, CVE-2022-48980, CVE-2022-48981, CVE-2022-48999, CVE-2024-53142, CVE-2024-53156, CVE-2024-56672, CVE-2024-57887, CVE-2024-57980, CVE-2025-21934, CVE-2025-37780, CVE-2023-53084, CVE-2023-53090, CVE-2025-37840, CVE-2025-38022, CVE-2025-38069, CVE-2025-38157, CVE-2025-38259, CVE-2025-38313, CVE-2025-38456, CVE-2025-38708, CVE-2025-39701, CVE-2025-39749, CVE-2022-50234, CVE-2025-39810, CVE-2022-50384, CVE-2022-50411, CVE-2025-39905, CVE-2025-39911, CVE-2023-53454, CVE-2023-53500, CVE-2023-53556, CVE-2023-53559, CVE-2023-53604, CVE-2022-50543, CVE-2023-53659, CVE-2023-53668, CVE-2023-54207, CVE-2026-23068, CVE-2026-23209, CVE-2026-23397, CVE-2026-31489, CVE-2026-31576, CVE-2026-31583  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_F2FS_FS` not set](#f2fs-filesystem) | CVE-2023-52436, CVE-2023-52444, CVE-2023-52588, CVE-2023-52682, CVE-2023-52748, CVE-2023-52852, CVE-2024-39467, CVE-2024-42160, CVE-2024-44942, CVE-2024-47691, CVE-2024-41935, CVE-2022-49738, CVE-2025-37739, CVE-2025-38579, CVE-2025-38652, CVE-2025-38677, CVE-2022-50270, CVE-2023-53214, CVE-2023-53301, CVE-2023-53537, CVE-2026-23234, CVE-2026-23235  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_DRM_AMDGPU` not set](#amdgpu-driver) | CVE-2023-51042, CVE-2023-52624, CVE-2024-26699, CVE-2024-27045, CVE-2023-52691, CVE-2023-52812, CVE-2023-52818, CVE-2024-36914, CVE-2024-38552, CVE-2024-38581, CVE-2024-39471, CVE-2024-42118, CVE-2024-42119, CVE-2024-42120, CVE-2024-42121, CVE-2024-42228, CVE-2024-44977, CVE-2024-46722, CVE-2024-46723, CVE-2024-46724, CVE-2024-46729, CVE-2024-46804, CVE-2024-46811, CVE-2024-46813, CVE-2024-46814, CVE-2024-46815, CVE-2024-46818, CVE-2024-46871, CVE-2024-49894, CVE-2024-49895, CVE-2024-49969, CVE-2024-49989, CVE-2024-49991, CVE-2022-48990, CVE-2023-52921, CVE-2024-50282, CVE-2024-53108, CVE-2024-53133, CVE-2024-56551, CVE-2024-56608, CVE-2024-56775, CVE-2024-56784, CVE-2025-21780, CVE-2025-21968, CVE-2025-21985, CVE-2023-53077, CVE-2025-37903, CVE-2022-49969, CVE-2025-38361, CVE-2022-50303, CVE-2023-53471, CVE-2023-52469, CVE-2024-41011, CVE-2024-46731, CVE-2024-46821, CVE-2025-37854  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_IP_DCCP` not set](#dccp-protocol) | CVE-2023-39197, CVE-2024-36904, CVE-2024-50154, CVE-2023-53333  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_TLS` not set](#config-tls) | CVE-2024-0646, CVE-2024-58240, CVE-2025-40149  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ROSE` not set](#config-rose) | CVE-2023-51782, CVE-2025-21718, CVE-2025-38377, CVE-2025-39826  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_ATM` not set](#atm-protocol) | CVE-2023-51780, CVE-2023-52578, CVE-2024-26895, CVE-2024-44998, CVE-2025-38180, CVE-2025-38236, CVE-2025-38245, CVE-2025-38323, CVE-2025-38459, CVE-2025-39828, CVE-2025-39839  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CIFS` not set](#cifs-smb-client) | CVE-2023-1194, CVE-2023-52434, CVE-2023-52440, CVE-2023-52572, CVE-2024-26928, CVE-2024-35861, CVE-2024-35862, CVE-2024-35864, CVE-2024-35866, CVE-2024-35867, CVE-2024-35868, CVE-2023-52741, CVE-2023-52751, CVE-2023-52752, CVE-2023-52757, CVE-2024-49996, CVE-2024-50047, CVE-2024-50151, CVE-2024-53179, CVE-2025-38051, CVE-2025-38527, CVE-2025-38728, CVE-2023-53427  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NVME_CORE` not set](#nvme-driver) | CVE-2023-5178, CVE-2023-6356, CVE-2023-6536, CVE-2022-48658, CVE-2022-48686, CVE-2024-41073, CVE-2024-58069, CVE-2025-21927, CVE-2023-53116, CVE-2025-39783  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CEPH_FS` not set](#ceph-filesystem) | CVE-2023-44466, CVE-2024-26689, CVE-2022-49770, CVE-2025-39880, CVE-2025-71116, CVE-2026-22984, CVE-2026-31580  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_HFS_FS` not set](#hfs-filesystem) | CVE-2023-4623, CVE-2024-26982, CVE-2024-46744, CVE-2025-21702, CVE-2025-37797, CVE-2025-37823, CVE-2025-37890, CVE-2025-38000, CVE-2025-38415, CVE-2025-38715, CVE-2026-23388  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_SMB_SERVER` not set](#config-smb-server) | CVE-2023-32250, CVE-2023-32254, CVE-2023-32247, CVE-2023-32248, CVE-2023-32252, CVE-2023-32257, CVE-2023-32258, CVE-2024-22705, CVE-2023-52441, CVE-2024-26592, CVE-2024-26594, CVE-2023-52480, CVE-2024-26936, CVE-2024-26952, CVE-2024-26954, CVE-2024-50086, CVE-2024-50283, CVE-2024-50286, CVE-2024-56626, CVE-2024-56627, CVE-2025-21945, CVE-2025-21946, CVE-2025-21967, CVE-2025-22038, CVE-2025-22039, CVE-2025-37776, CVE-2025-37777, CVE-2025-37778, CVE-2025-37899, CVE-2025-37924, CVE-2025-37926, CVE-2025-37947, CVE-2025-37952, CVE-2025-38437, CVE-2025-38501, CVE-2023-3865, CVE-2023-3867, CVE-2023-53358, CVE-2025-39943  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_CAN` not set](#can-bus) | CVE-2023-3090, CVE-2023-3389, CVE-2023-3609, CVE-2023-3611, CVE-2023-3776, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208, CVE-2023-4622, CVE-2023-4921, CVE-2023-5717, CVE-2023-46813, CVE-2023-6931, CVE-2023-6932, CVE-2023-6546, CVE-2023-6270, CVE-2024-25744, CVE-2023-52438, CVE-2023-52439, CVE-2023-52474, CVE-2023-52501, CVE-2022-47518, CVE-2022-47519, CVE-2022-47520, CVE-2022-47521, CVE-2023-2235, CVE-2023-2156, CVE-2023-52519, CVE-2023-52614, CVE-2024-26669, CVE-2023-52637, CVE-2024-26898, CVE-2022-48655, CVE-2024-26951, CVE-2024-26961, CVE-2024-26974, CVE-2024-35855, CVE-2024-35871, CVE-2024-35937, CVE-2023-52701, CVE-2023-52707, CVE-2023-52772, CVE-2023-52846, CVE-2023-52854, CVE-2024-36934, CVE-2024-36974, CVE-2024-38599, CVE-2024-38610, CVE-2024-39277, CVE-2023-52340, CVE-2024-39494, CVE-2024-40900, CVE-2024-40913, CVE-2024-40935, CVE-2024-40994, CVE-2024-41040, CVE-2024-42093, CVE-2024-42094, CVE-2024-42313, CVE-2024-43842, CVE-2024-43882, CVE-2022-48872, CVE-2022-48874, CVE-2022-48892, CVE-2023-52906, CVE-2024-44934, CVE-2024-46740, CVE-2024-46854, CVE-2024-47659, CVE-2024-47727, CVE-2024-47745, CVE-2024-47750, CVE-2024-49853, CVE-2024-49854, CVE-2022-48988, CVE-2022-48991, CVE-2022-49006, CVE-2022-49031, CVE-2022-49032, CVE-2024-50036, CVE-2024-50059, CVE-2024-50061, CVE-2024-50073, CVE-2024-50074, CVE-2024-50209, CVE-2024-50264, CVE-2024-50268, CVE-2024-50275, CVE-2024-50301, CVE-2024-53104, CVE-2024-53166, CVE-2024-53171, CVE-2024-53203, CVE-2024-56570, CVE-2024-56603, CVE-2024-56651, CVE-2024-52332, CVE-2024-57850, CVE-2024-57904, CVE-2024-57929, CVE-2025-21687, CVE-2025-21704, CVE-2024-57982, CVE-2025-21791, CVE-2025-21855, CVE-2023-53000, CVE-2025-21919, CVE-2025-21920, CVE-2025-21928, CVE-2025-22107, CVE-2025-23157, CVE-2025-37786, CVE-2022-49775, CVE-2022-49779, CVE-2022-49900, CVE-2023-53135, CVE-2025-37839, CVE-2025-37892, CVE-2025-37927, CVE-2025-37928, CVE-2025-37991, CVE-2025-38004, CVE-2025-38081, CVE-2022-49939, CVE-2022-49948, CVE-2025-38102, CVE-2025-38108, CVE-2025-38129, CVE-2025-38248, CVE-2025-38342, CVE-2025-38346, CVE-2025-38375, CVE-2025-38445, CVE-2025-38535, CVE-2025-38595, CVE-2025-38666, CVE-2025-38679, CVE-2025-38680, CVE-2025-38722, CVE-2025-39683, CVE-2025-39687, CVE-2025-39689, CVE-2025-39766, CVE-2025-39797, CVE-2022-50255, CVE-2023-53148, CVE-2023-53153, CVE-2023-53215, CVE-2023-53232, CVE-2023-53259, CVE-2023-53272, CVE-2025-39817, CVE-2025-39824, CVE-2022-50394, CVE-2023-53388, CVE-2023-53446, CVE-2025-39873, CVE-2025-39877, CVE-2025-39883, CVE-2025-39901, CVE-2022-50421, CVE-2023-53465, CVE-2025-39951, CVE-2023-53536, CVE-2023-53560, CVE-2023-53569, CVE-2023-53570, CVE-2022-50552, CVE-2025-71073, CVE-2025-71089, CVE-2025-71093, CVE-2025-71152, CVE-2025-71162, CVE-2026-23073, CVE-2026-23074, CVE-2026-23102, CVE-2026-23171, CVE-2025-71221, CVE-2026-23221, CVE-2026-23227, CVE-2026-23361, CVE-2026-31788, CVE-2026-23410, CVE-2026-23411, CVE-2026-31527, CVE-2026-31532, CVE-2026-31582  | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NET_CLS_FLOWER` not set](#tc-cls-flower) | CVE-2023-35788 | <span class="badge bg-success">Not Affected</span> |
| [`CONFIG_NTFS3_FS` not set](#config-ntfs3-fs) | CVE-2022-48502, CVE-2023-26606, CVE-2023-52640, CVE-2024-50242, CVE-2024-50246, CVE-2024-50247, CVE-2025-38707, CVE-2025-39691, CVE-2023-53194, CVE-2023-53420, CVE-2022-50442, CVE-2023-53486, CVE-2022-50507  | <span class="badge bg-success">Not Affected</span> |

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

Share this page with your auditor or scanner vendor as the primary reference. For compliance teams that require a configuration-level proof, the config gate for any entry on this page can be confirmed on the HeartSuite Core Secure host:

```bash
$ grep CONFIG_<GATE> /boot/config-$(uname -r)
```

For example, to confirm CVE-2026-31431:

```bash
$ grep CONFIG_CRYPTO_USER_API_AEAD /boot/config-$(uname -r)
CONFIG_CRYPTO_USER_API_AEAD=n
```

Replace `CONFIG_<GATE>` with the config gate listed in the relevant section. Any `=n` result confirms that config gate is not compiled into the running kernel.

## How These Assessments Are Made

Every entry on this page was verified source-first. No assumptions were made about what is compiled in, and no scanner output was taken at face value. The assessment follows four gates in order:

**Gate 1 — Is the vulnerable code compiled in?** The HeartSuite kernel configuration is checked directly against the relevant `CONFIG_` option. If the option is not set, the vulnerable code does not exist in the running kernel. The assessment stops here as Not Affected regardless of kernel version string.

**Gate 2 — Does HeartSuite's network hook cover the attack path?** For socket-based CVEs, the network allowlist hook in the kernel intercepts outbound `connect()` calls only. Attack paths that reach the kernel through socket creation, `sendmsg`, `recvmsg`, or kernel-internal crypto interfaces bypass this hook and are noted accordingly.

**Gate 3 — Can an exploit binary run?** Under Lockdown, the Application Permission Orders (APO) database is made filesystem-immutable. No new program entries can be added. An attacker-dropped exploit binary has no APO record and cannot execute. This gate does not apply to CVEs exploitable from within an already-running, APO-approved process.

**Gate 4 — What can root actually do under Lockdown?** When a CVE achieves root privilege, HeartSuite Lockdown applies a further constraint. The kernel refuses to clear filesystem immutable flags (`chattr -i` is blocked at the syscall level). All three mount syscall variants are blocked. The Lockdown state variable is one-way — it can only be cleared by a hardware reboot, and rebooting requires physical or serial console access to the GRUB menu. An attacker who reaches root in Secure Mode + Lockdown has no path to persistence, cannot modify the allowlist, cannot add backdoors, and cannot survive a reboot.

The two residual risks that Lockdown does not close are in-memory data exfiltration (reading live process memory) and availability impact (crashing the system). These are noted in affected entries where relevant.
