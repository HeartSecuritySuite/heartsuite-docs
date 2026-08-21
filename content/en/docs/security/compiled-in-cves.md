---
title: "Compiled-in CVEs — what each score means"
linkTitle: "Compiled-in CVEs"
weight: 10
description: "Per-CVE status for compiled-in Root Lock kernel paths: Score on Root Lock, dual-kernel pins, and Lockdown bounds."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
toc: true
type: docs
---

<!-- Flat catalog: every entry is an h3 under the page title, so the h1-to-h3 jump is intentional. -->
<!-- markdownlint-disable MD001 -->

**Overview**: Per-CVE write-ups for paths that exist in a Root Lock kernel. A 0.0 score means the trigger is absent on this deployment (hardware, tool, or config). A non-zero score is a live residual.

Read [How to read the backstop sections](/docs/security/#how-to-read-the-backstop-sections) on the Kernel Security Transparency landing before the entries. Compiled-out groups are on [Not Affected — Disabled Features](../disabled-features/).

| CVE | Component | Base Score | Score on Root Lock | Status |
|-----|-----------|-----------|-----------------|--------|
| [CVE-2024-47685](#cve-2024-47685) | nf_reject_ipv6 | <span class="badge bg-danger">9.1 CRITICAL</span> | <span class="badge badge-erased">0.0</span> | Score on Root Lock 0.0 — trigger not present in default configuration |
| [CVE-2022-41674, CVE-2022-42719, CVE-2022-42720](#cve-2022-41674-cve-2022-42719-cve-2022-42720) | mac80211 | <span class="badge badge-cve-high">8.8 / 8.1 / 7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2026-23193](#cve-2026-23193) | Linux iSCSI target (`CONFIG_ISCSI_TARGET`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_ISCSI_TARGET` not compiled |
| [CVE-2026-43284](#cve-2026-43284) | XFRM/IPv6 ESP (`CONFIG_XFRM`, `CONFIG_INET6_ESP`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `esp_output` unreachable; no XFRM SA can be established; IPsec management tools absent from Root Lock allowlist; Dirty Frag chain broken (rxrpc absent) |
| [CVE-2023-0266](#cve-2023-0266) | ALSA PCM | <span class="badge badge-cve-high">7.9 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2026-31431](#cve-2026-31431) | algif_aead (AF_ALG) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Code not compiled in |
| [CVE-2026-43500](#cve-2026-43500) | rxrpc (`CONFIG_AF_RXRPC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_AF_RXRPC` not compiled; Dirty Frag chain cannot execute on Root Lock |
| [CVE-2026-46242](#cve-2026-46242) | epoll (`CONFIG_EPOLL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6 (introduced in 6.4); Not exploitable on 6.18.9-hs — linked-epoll close race not constructible from the allowlist |
| [CVE-2026-46300](#cve-2026-46300) | skbuff coalescing and ESP-in-TCP (`CONFIG_NET`, `CONFIG_INET_ESPINTCP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-45920](#cve-2026-45920) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-46094](#cve-2026-46094) | ext4 xattr bounds (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable on 6.18.9-hs — Lockdown blocks mount of a crafted image |
| [CVE-2026-46020](#cve-2026-46020) | DAMON core — `damos_quota_goal->nid` for `node_mem_{used,free}_bp` (`CONFIG_DAMON`, `CO… | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-46121](#cve-2026-46121) | DAMON sysfs schemes (`CONFIG_DAMON`, `CONFIG_DAMON_SYSFS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-46279](#cve-2026-46279) | mm/alloc_tag (`CONFIG_MEM_ALLOC_PROFILING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-46281](#cve-2026-46281) | vmalloc — virtually contiguous allocator (`CONFIG_MMU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 6.18.9-hs — Lockdown limits post-exploitation; Not Affected on 5.19.6 |
| [CVE-2026-52968](#cve-2026-52968) | KVM s390 PCI (`CONFIG_KVM_S390`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-52969](#cve-2026-52969) | KVM dirty ring (`CONFIG_KVM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-53004](#cve-2026-53004) | SCTP (`CONFIG_IP_SCTP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-53264](#cve-2026-53264) | net/sched action API (`CONFIG_NET_SCHED`, `CONFIG_NET_CLS_ACT`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-53359](#cve-2026-53359) | KVM x86 shadow MMU (`CONFIG_KVM`) | <span class="badge badge-cve-high">8.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-63794](#cve-2026-63794) | KVM AMD SVM — SEV debug crypt (`CONFIG_KVM`, `CONFIG_KVM_AMD`, `CONFIG_KVM_AMD_SEV`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-63804](#cve-2026-63804) | GFS2 clustered filesystem (`CONFIG_GFS2_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-64121](#cve-2026-64121) | IFB intermediate functional block (`CONFIG_IFB`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-64600](#cve-2026-64600) | XFS reflink / copy-on-write (`CONFIG_XFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 6.18.9-hs — Lockdown limits post-exploitation; Not Affected on 5.19.6 |
| [CVE-2026-64239](#cve-2026-64239) | DAMON sysfs schemes (`CONFIG_DAMON_SYSFS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-64283](#cve-2026-64283) | KVM guest_memfd (`CONFIG_KVM_GUEST_MEMFD`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-64531](#cve-2026-64531) | Open vSwitch datapath (`CONFIG_OPENVSWITCH`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-64564](#cve-2026-64564) | SCTP ASCONF DEL-IP (`CONFIG_IP_SCTP`) | <span class="badge bg-danger">9.8 CRITICAL</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-45837](#cve-2026-45837) | BPF arena (`CONFIG_BPF_SYSCALL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs |
| [CVE-2026-45839](#cve-2026-45839) | BPF CO-RE relocation parser (`CONFIG_BPF_SYSCALL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-45851](#cve-2026-45851) | EFI unaccepted memory table (`CONFIG_UNACCEPTED_MEMORY`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-45853](#cve-2026-45853) | AMDGPU DRM driver (`CONFIG_DRM_AMDGPU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-45893](#cve-2026-45893) | AppArmor DFA table unpack (`CONFIG_SECURITY_APPARMOR`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-45903](#cve-2026-45903) | BPF helper prototypes (`CONFIG_BPF_SYSCALL`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected |
| [CVE-2026-45943](#cve-2026-45943) | EROFS ztailpacking (`CONFIG_EROFS_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-45957](#cve-2026-45957) | RCU preempt (`CONFIG_PREEMPT_RCU`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-46033](#cve-2026-46033) | IPsec authencesn (`CONFIG_CRYPTO_AUTHENC`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-46045](#cve-2026-46045) | MD last-level bitmap (`CONFIG_MD_LLBITMAP`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs |
| [CVE-2026-46130](#cve-2026-46130) | dm-verity FEC (`CONFIG_DM_VERITY_FEC`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-46136](#cve-2026-46136) | MediaTek mt7921 Wi-Fi (`CONFIG_MT7921E`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-46162](#cve-2026-46162) | Intel ice Ethernet (`CONFIG_ICE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-46180](#cve-2026-46180) | Broadcom FullMAC Wi-Fi (`CONFIG_BRCMFMAC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-46234](#cve-2026-46234) | vsock (`CONFIG_VSOCKETS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-46294](#cve-2026-46294) | Device-mapper ioctl (`CONFIG_BLK_DEV_DM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-46309](#cve-2026-46309) | Intel Xe DRM (`CONFIG_DRM_XE`) | <span class="badge badge-cve-high">7.0 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-52962](#cve-2026-52962) | CephFS setxattr (`CONFIG_CEPH_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-53059](#cve-2026-53059) | Device-mapper dirty log (`CONFIG_DM_MIRROR`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — tool not in the program allowlist |
| [CVE-2026-53089](#cve-2026-53089) | BPF offload info fill (`CONFIG_BPF_SYSCALL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled |
| [CVE-2026-53119](#cve-2026-53119) | ACPI WMI bus (`CONFIG_ACPI_WMI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not Affected on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2026-53120](#cve-2026-53120) | PCI `driver_override` (`CONFIG_PCI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.5 HIGH</span> | Affected — Lockdown limits post-exploitation |
| [CVE-2026-53129](#cve-2026-53129) | ext4 mbcache (`CONFIG_FS_MBCACHE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">6.1 HIGH</span> | Affected — Lockdown limits post-exploitation |
| [CVE-2026-53136](#cve-2026-53136) | AMD display BIOS parser (`CONFIG_DRM_AMDGPU`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53137](#cve-2026-53137) | AMD HDMI HDCP 2.x (`CONFIG_DRM_AMD_DC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53138](#cve-2026-53138) | AMD display VBIOS walk (`CONFIG_DRM_AMD_DC`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53143](#cve-2026-53143) | AMD KFD SDMA checkpoint (`CONFIG_HSA_AMD`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-53149](#cve-2026-53149) | Thunderbolt property parser (`CONFIG_USB4`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53233](#cve-2026-53233) | netdev RX bind (`CONFIG_NET_DEVMEM`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not Affected on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2026-53255](#cve-2026-53255) | Bluetooth MGMT advertising (`CONFIG_BT`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-53272](#cve-2026-53272) | EROFS compressed read (`CONFIG_EROFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-53286](#cve-2026-53286) | Intel IDPF ethernet (`CONFIG_IDPF`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53303](#cve-2026-53303) | F2FS sysfs extension_list (`CONFIG_F2FS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-53330](#cve-2026-53330) | AMD DisplayPort LTTPR (`CONFIG_DRM_AMD_DC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-53346](#cve-2026-53346) | Rust arm64 unwind tables (`CONFIG_RUST`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs |
| [CVE-2026-64186](#cve-2026-64186) | AMD IOMMU debugfs (`CONFIG_IOMMU_DEBUGFS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs |
| [CVE-2026-64237](#cve-2026-64237) | Elan I2C touchpad (`CONFIG_MOUSE_ELAN_I2C`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs |
| [CVE-2026-64245](#cve-2026-64245) | fbdev mode database (`CONFIG_FB`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2025-71306](#cve-2025-71306) | IMA exec appraisal (`CONFIG_IMA`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-45998](#cve-2026-45998) | RxRPC (`CONFIG_AF_RXRPC`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-46191](#cve-2026-46191) | framebuffer console rotation (`CONFIG_FRAMEBUFFER_CONSOLE`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs |
| [CVE-2026-52992](#cve-2026-52992) | ADFS filesystem (`CONFIG_ADFS_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Not exploitable — feature not compiled on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation |
| [CVE-2022-4139](#cve-2022-4139) | i915 GPU | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Hardware absent on server deployments |
| [CVE-2023-2236, CVE-2022-3910](#cve-2023-2236-cve-2022-3910) | io_uring | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.1–7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
| [CVE-2023-52530](#cve-2023-52530) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No WiFi NIC present |
| [CVE-2023-52612](#cve-2023-52612) | kernel crypto framework — scomp interface (`CONFIG_CRYPTO`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `CONFIG_INET_IPCOMP` not compiled; no compression algorithm registered; `scomp_acomp_comp_decomp()` unreachable |
| [CVE-2024-26704](#cve-2024-26704) | ext4 filesystem — online defragmentation (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not exploitable — `EXT4_IOC_MOVE_EXT` ioctl only reached by defrag tools; none in Root Lock allowlist |
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
| [CVE-2024-57899](#cve-2024-57899) | mac80211 wireless stack (`CONFIG_MAC80211`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — 32-bit-specific vulnerability; Root Lock kernel is x86_64 |
| [CVE-2025-21863](#cve-2025-21863) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
| [CVE-2023-52930](#cve-2023-52930) | Intel i915 DRM driver (`CONFIG_DRM_I915`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | No Intel display GPU present |
| [CVE-2023-52988](#cve-2023-52988) | Intel HDA audio driver (`CONFIG_SND_HDA_INTEL`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — no audio hardware present |
| [CVE-2025-22083](#cve-2025-22083) | vhost-SCSI driver (`CONFIG_VHOST_SCSI`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_VHOST_SCSI` not compiled |
| [CVE-2025-40364](#cve-2025-40364) | io_uring (`CONFIG_IO_URING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-cve-high">7.3 HIGH</span> | Affected on 5.19.6 (`CONFIG_IO_URING=y`); Not Affected on derived 6.18 (`CONFIG_IO_URING` not compiled) |
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
| [CVE-2023-53285](#cve-2023-53285) | ext4 filesystem (`CONFIG_EXT4_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — raw block device write tool absent from Root Lock allowlist |
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
| [CVE-2024-39463](#cve-2024-39463) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `mount()` blocked by Lockdown; no 9P filesystem on Root Lock deployments |
| [CVE-2024-40956](#cve-2024-40956) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Intel IAX/DSA accelerator hardware absent |
| [CVE-2022-48867](#cve-2022-48867) | DMA engine framework (`CONFIG_DMA_ENGINE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Intel IAX/DSA accelerator hardware absent |
| [CVE-2024-46759](#cve-2024-46759) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | ADC128D818 I2C ADC chip absent |
| [CVE-2022-49029](#cve-2022-49029) | hardware monitoring subsystem (`CONFIG_HWMON`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | IBM Power Management Extension hardware absent |
| [CVE-2024-50127](#cve-2024-50127) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-50131](#cve-2024-50131) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2024-53057](#cve-2024-53057) | network traffic scheduler (`CONFIG_NET_SCHED`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `tc` not in allowlist; Lockdown prevents modification |
| [CVE-2024-56606](#cve-2024-56606) | AF_PACKET sockets (`CONFIG_PACKET`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `CAP_NET_RAW` not in allowlist; Lockdown prevents modification |
| [CVE-2026-53341](#cve-2026-53341) | file handles / fhandle (`CONFIG_FHANDLE`) | <span class="badge badge-cve-high">7.8 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `CAP_DAC_READ_SEARCH` required; unprivileged path denied; Lockdown prevents allowlist modification |
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
| [CVE-2026-53223](#cve-2026-53223) | AF_PACKET timestamp cmsgs (`CONFIG_PACKET`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `CAP_NET_RAW` not granted to services; packet tools absent from allowlist; Lockdown prevents modification |
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
| [CVE-2024-34777](#cve-2024-34777) | DMA map benchmark (`CONFIG_DMA_MAP_BENCHMARK`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-cve-none">0.0</span> | Not Affected — `CONFIG_DMA_MAP_BENCHMARK` not compiled in Root Lock kernel |
| [CVE-2024-49860](#cve-2024-49860) | ACPI subsystem (`CONFIG_ACPI`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — malformed ACPI _STR firmware absent; standard OEM firmware conforms to spec |
| [CVE-2022-49799](#cve-2022-49799) | kernel tracing (`CONFIG_TRACING`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — tracefs not in allowlist; Lockdown prevents modification |
| [CVE-2025-37879](#cve-2025-37879) | Plan 9 filesystem (9P) (`CONFIG_9P_FS`) | <span class="badge badge-cve-high">7.1 HIGH</span> | <span class="badge badge-erased">0.0</span> | Not exploitable — `mount()` blocked by Lockdown; no 9P filesystem on Root Lock deployments |
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

### CVE-2026-31431

**Status**: Not Affected  
**Component**: algif_aead — the in-kernel AEAD interface exposed by the AF_ALG socket family (`CONFIG_CRYPTO_USER_API_AEAD`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org); NVD assessment pending  
**Upstream fix**: Linux 6.12.85 (LTS), 6.18.22 (LTS), 6.19.12 (LTS)

This CVE describes a privilege escalation through the AF_ALG socket interface. An attacker who can open an AF_ALG socket reaches `algif_aead_copy_sgl()`, exploits a copy-on-write failure in the scatter-gather list handling, and gains root.

`CONFIG_CRYPTO_USER_API_AEAD` is not compiled into the Root Lock kernel. The AF_ALG socket family is not available. An attempt to open an AF_ALG socket returns `EAFNOSUPPORT` — there is no `algif_aead` code present in the running kernel and therefore no reachable code path. The Root Lock kernel predates the upstream fix versions listed above, but the fix is not required: the fix removes a vulnerability in code that was never compiled in.

Lockdown closes the remaining question. Even if the code path were present, Lockdown — `chattr +i` filesystem immutability combined with the Root Lock kernel refusing runtime changes to the allowlist — removes every useful action root can take after gaining privilege. The kernel refuses to clear immutable flags. Mount operations are blocked in Lockdown. Writes to the audit log are blocked. Root cannot modify the allowlist, add a backdoor, or persist across a reboot.

See [Deployment Scenarios → Production Servers](../introduction/deployment-scenarios/) for the architectural context of how Lockdown interacts with a privilege escalation reaching root.

### CVE-2026-43284

**Status**: Not exploitable  
**Component**: XFRM framework and IPv6 ESP (`CONFIG_XFRM`, `CONFIG_INET6_ESP`)  
**Base Score**: 8.8 HIGH — NVD full vector assessment pending  
**Score on Root Lock**: 0.0 — `esp_output` is unreachable; no XFRM security association can be established on a default Root Lock deployment  
**Upstream fix**: merged; backported to active stable series by 2026-05-09 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a write-what-where condition in the `esp_output` page-write path. The vulnerable code is at `net/ipv6/esp6.c:524`: `tail = page_address(page) + pfrag->offset` followed by `esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto)`. If `pfrag->offset` is corrupted or attacker-influenced, the trailer write reaches an arbitrary kernel page address. The identical pattern exists in `net/ipv4/esp4.c:489` (`CONFIG_INET_ESP`, not compiled), but the absence of IPv4 ESP is irrelevant — `esp6.c` carries the same code. The bug is one half of the "Dirty Frag" exploit chain; chaining it with CVE-2026-43500 produces a deterministic privilege escalation.

`CONFIG_INET6_ESP=y` is compiled in and `esp6.c:524` is present in the running kernel. The `esp_output` function is called only when the kernel encrypts an outgoing packet that matches a configured XFRM security association. With no security association configured, `esp_output` is never reached — by any user, at any privilege level. Configuring a XFRM security association requires XFRM management tooling: `ip xfrm` (iproute2), `setkey`, strongSwan, libreswan, or an equivalent IKE daemon. None of these are in the Root Lock default allowlist. Under Lockdown, the allowlist is `chattr +i` immutable and `FS_IOC_SETFLAGS` returns `EPERM` for all callers — root cannot add management tools and therefore cannot establish a security association. The `esp_output` page-write path is unreachable for the lifetime of the boot.

The Dirty Frag chain has no second link on this system regardless: `CONFIG_AF_RXRPC` is not compiled (see CVE-2026-43500).

The trigger cannot be reached on any default Root Lock deployment.

If your deployment adds XFRM management tooling (`ip xfrm`, `setkey`, strongSwan, libreswan, or an equivalent IKE daemon) to the Root Lock allowlist, a security association can be established and `esp_output` becomes reachable. In that configuration this CVE applies at its base score of 8.8 HIGH. Treat it as Affected and apply the standard backstop logic.

### CVE-2026-43500

**Status**: Not Affected  
**Component**: rxrpc — RxRPC transport protocol (`CONFIG_AF_RXRPC`)  
**Base Score**: 7.8 HIGH — NVD full vector assessment pending  
**Upstream fix**: merged; backported to active stable series by 2026-05-09 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a local privilege escalation through an out-of-bounds write in the rxrpc transport protocol implementation. It is the second half of the "Dirty Frag" exploit chain (paired with CVE-2026-43284); chaining both produces a deterministic privilege escalation to root.

`CONFIG_AF_RXRPC` is not compiled into the Root Lock kernel. The rxrpc address family is not available; an attempt to open an `AF_RXRPC` socket returns `EAFNOSUPPORT`. The vulnerable code in `net/rxrpc/` is entirely absent from the running kernel. The Root Lock kernel predates the upstream fix, but the fix is not required: there is no reachable code path for this bug on any Root Lock deployment. The Dirty Frag chain has no second link on this system.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46242

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs  
**Component**: epoll — event polling subsystem (`CONFIG_EPOLL`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org)  
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range; on 6.18.9-hs the linked-epoll close race is not constructible from the allowlist  
**Affected range**: 6.4 through 6.18.32; also narrow LTS windows 5.15.209–5.15.x and 6.1.175–6.1.177. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.33  
**Upstream fix**: `a6dc643c6931` (mainline); stable 6.18.33+

This CVE describes a use-after-free in `ep_remove()`. When one epoll instance monitors another, a concurrent `close()` can clear `file->f_ep` and then keep using that `struct file` while `__fput()` frees the watched `struct eventpoll`. The construction turns the race into an attacker-controlled free against the wrong slab cache and privilege escalation to root.

`CONFIG_EPOLL=y` is compiled in on both fielded kernels. That is not enough for 5.19.6: the mainline introduction is 6.4 (`58c9b016e128`). 5.19.6 predates that change, so the 5.19.6 `ep_remove` path is not the vulnerable one.

On 6.18.9-hs the vulnerable interleaving is present until a 6.18.33+ base. Reaching it requires allocating two specifically linked epoll instances and driving the close ordering from a dedicated program. No such program appears in the Root Lock allowlist. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot. The kernel therefore refuses to run a dropped exploit binary.

The trigger cannot be reached on any default Root Lock deployment.

If your 6.18.9-hs deployment adds a program that performs the linked-epoll close pattern to the allowlist, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2024-47685

**Status**: Score on Root Lock 0.0 — trigger not present in default configuration
**Component**: nf_reject_ipv6 — IPv6 netfilter TCP RST generation (`CONFIG_NF_REJECT_IPV6`, `CONFIG_IP6_NF_TARGET_REJECT`)  
**Base Score**: 9.1 CRITICAL (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:H)  
**Score on Root Lock**: 0.0 — trigger not present; HeartSuite installs no ip6tables REJECT rules  
**Upstream fix**: Linux 4.19.323, 5.4.285, 5.10.227, 5.15.168, 6.1.113, 6.6.54, 6.10.13, 6.11.2 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an information disclosure in the IPv6 netfilter TCP reset path. When the kernel sends a TCP RST packet in response to a connection rejected by an ip6tables rule, `nf_reject_ip6_tcphdr_put()` allocates a TCP header via `skb_put()` without zeroing the buffer. The function then writes every field in the header explicitly except the four reserved bits (`th->res1`) in byte 12. Those bits retain whatever value was in the allocated kernel memory region. The RST packet is sent with that uninitialized content on the wire.

`CONFIG_NF_REJECT_IPV6=y` and `CONFIG_IP6_NF_TARGET_REJECT=y` are compiled in. The code path exists in this kernel. The vulnerable function has five callers across the kernel source. In this configuration only `ip6t_REJECT.c` is compiled — the remaining four callers (`nft_reject_ipv6`, `nft_reject_inet`, `nft_reject_bridge`, `nft_reject_netdev`) are all gated by `CONFIG_NF_TABLES`, which is built as module (`m`) and not loaded at boot. Reaching the vulnerable code therefore requires an active ip6tables rule using `REJECT --reject-with tcp-reset` on IPv6 traffic. The Root Lock install scripts and service unit contain no ip6tables rules of any kind. If you manually add such a rule, this path becomes exposed.

Lockdown does not patch the vulnerability mechanism — the kernel still places uninitialized bits into the packet header if the path is reached. However, the program allowlist and Lockdown together make the triggering condition unreachable in practice.

To trigger this CVE, you must first add an ip6tables rule with `REJECT --reject-with tcp-reset`. That requires running `ip6tables` with root privilege. In Lockdown, HeartSuite's program allowlist is enforced at the kernel level for every user including root: a program without a valid allowlist entry cannot execute regardless of the caller's privilege level. Network management utilities such as `ip6tables` have no allowlist entry on a production HeartSuite deployment, so root cannot run them and the rule cannot be added.

Lockdown closes the remaining path. Even if an attacker gained root and attempted to add `ip6tables` to the allowlist first, Lockdown blocks every mechanism for doing so: `FS_IOC_SETFLAGS` (the ioctl used by `chattr`) returns `EPERM` for all callers during lockdown, so immutable flags cannot be cleared from the allowlist database files; `mount()`, `fsmount()`, and `move_mount()` all return `EPERM`, blocking any bind-mount or remount workaround; and the HeartSuite reactivation path is disabled, preventing the service from being reconfigured to accept new entries.

The result is a two-layer guarantee: the program allowlist prevents the trigger from being established, and Lockdown ensures the allowlist cannot be modified to enable the tools that would establish it. A 9.1 CRITICAL CVE that requires setting up an ip6tables REJECT rule becomes unreachable by any user, including root, once Lockdown is in force.

### CVE-2022-41674, CVE-2022-42719, CVE-2022-42720

**Status**: Not exploitable
**Component**: mac80211 — 802.11 wireless stack (`CONFIG_MAC80211`)  
**Base Scores**: CVE-2022-42719: 8.8 HIGH (AV:A); CVE-2022-41674: 8.1 HIGH (AV:A); CVE-2022-42720: 7.8 HIGH (AV:A)  
**Score on Root Lock**: 0.0 — no WiFi hardware present; attack vector (frame injection via wireless NIC) has no path to execution  
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
**Score on Root Lock**: 0.0 — no audio hardware present; no `/dev/snd` devices; ioctl path unreachable  
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
**Score on Root Lock**: 0.0 — no i915 GPU present; GPU context entry point unreachable  
**Affected range**: Linux 5.16 through 6.0.10  
**Upstream fix**: Linux 5.4.226, 5.10.157, 5.15.81, 6.0.11 (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an incorrect TLB flush in the Intel i915 GPU driver. When GPU memory mappings are changed, a missing or incorrect TLB invalidation can leave stale translation entries active, allowing writes to land in the wrong physical pages. This can corrupt kernel memory and is exploitable by a local user with access to a GPU context to gain elevated privilege.

`CONFIG_DRM_I915=y` is compiled in and 5.19.6 falls within the affected range. Reaching the vulnerable path requires an Intel i915 GPU to be present and accessible. Deployments without i915 hardware have no reachable path to this driver.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2023-2236, CVE-2022-3910

**Status**: Affected on 5.19.6; Not Affected on derived 6.18  
**Component**: io_uring — asynchronous I/O subsystem (`CONFIG_IO_URING`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)  
**Score on Root Lock**: 7.1–7.3 HIGH — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High; score stays within the HIGH band  
**Affected ranges**: CVE-2023-2236: 5.19 through 6.0.10; CVE-2022-3910: 5.18 through 5.19.10  
**Upstream fix**: CVE-2023-2236: 6.0.11; CVE-2022-3910: 5.19.11 (5.19 branch is EOL for CVE-2023-2236; CVE-2022-3910 fix was in-branch but 5.19.6 predates it)

**What this means for an attacker:**

Both CVEs describe use-after-free conditions in io_uring's fixed file management, exploitable by a local user to gain root:

- **CVE-2023-2236** — double `fput()` in the `io_install_fixed_file()` path. When an async open operation installs a fixed file and encounters an error, `io_install_fixed_file()` calls `fput(file)` at its error label; the caller then calls `fput(file)` a second time. The file's reference count reaches zero while the object is still referenced, producing a use-after-free.
- **CVE-2022-3910** — improper reference count update in io_uring's fixed file handling that leads to a use-after-free and local privilege escalation.

**Why the score is not 0.0:**

`CONFIG_IO_URING=y` is compiled in on 5.19.6. The public 6.18 pin does not compile `CONFIG_IO_URING` (`io_uring_setup` returns `ENOSYS`); those two CVEs are Not Affected on derived 6.18. On 5.19.6 the `io_uring_setup` syscall has no capability gate — any local user can create an io_uring ring and reach both vulnerable paths. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

These constraints are why the Score on Root Lock reflects a reduced MI (High→Low): root cannot modify the allowlist, cannot install persistent backdoors, and cannot survive a reboot. Confidentiality and Availability impacts remain High, reflecting that an attacker with a live root session can still read data and disrupt services within the bounds of already-permitted processes.

A more sophisticated exploit could use the kernel use-after-free to directly corrupt kernel data structures before surfacing in userspace. In that scenario Lockdown's API-level restrictions are not the binding constraint — the corruption happens below the layer where those checks operate. This is why the Score on Root Lock does not reach 0.0: the io_uring path is reachable by any local user, and pre-userspace kernel corruption is outside the scope of what Lockdown addresses.

### CVE-2024-0775

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 6.7 MEDIUM (AV:L/AC:L/PR:H/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `mount(MS_REMOUNT)` blocked by Lockdown; ext4 remount entry point unreachable
**Affected range**: kernels through 6.7.2, 6.6.15, 6.1.79, 5.15.148, 5.10.211, 5.4.270, 4.19.308 (5.19 branch is EOL; no backport)
**Upstream fix**: Linux 6.7.3, 6.6.16, 6.1.80, 5.15.149, 5.10.212, 5.4.271, 4.19.309

This CVE describes a use-after-free in the `__ext4_remount()` error path in `fs/ext4/super.c`. When a remount operation fails and rolls back to saved options, the function restores quota file name pointers via `rcu_assign_pointer(sbi->s_qf_names[i], old_opts.s_qf_names[i])` and then frees the displaced current pointer via `kfree(to_free[i])`. If the success path has already freed those names at the earlier `kfree(old_opts.s_qf_names[i])` call, the error path operates on already-freed memory. The CVE requires `CAP_SYS_ADMIN` (implicit in `PR:H`) because `mount(MS_REMOUNT)` is a privileged operation.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server. `__ext4_remount()` is reached exclusively via `mount(MS_REMOUNT)` — a privileged operation that Lockdown blocks unconditionally. `do_mount()` returns `EPERM` whenever `HS_locked_down()` is true (`kernel/namespace.c:4218`), so root cannot call `mount()` at all; the CVE's entry point is blocked at the syscall level before any ext4 code is reached. In Lockdown, the allowlist additionally prevents execution of any exploit program that would invoke the remount path.

### CVE-2023-52530

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present; WoWLAN path unreachable
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
**Score on Root Lock**: 0.0 — `CONFIG_INET_IPCOMP` not compiled; no compression algorithm registered; `scomp_acomp_comp_decomp()` unreachable
**Affected range**: kernels prior to stable fixes in the 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8-rc; backported across active stable series

This CVE describes a buffer overflow in the kernel software compression (`scomp`) interface in `crypto/scompress.c`. The `scomp_acomp_comp_decomp()` function uses a per-CPU scratch buffer of `SCOMP_SCRATCH_SIZE` bytes as working space. If the caller provides a `req->dst` scatter list smaller than `SCOMP_SCRATCH_SIZE`, the function still caps `req->dlen` to `SCOMP_SCRATCH_SIZE` and then copies the full output — up to that size — into `req->dst` via `scatterwalk_map_and_copy()`. No check verifies that `req->dst` can hold `req->dlen` bytes before the copy. A caller who controls `req->dst` and triggers a compression or decompression that fills the scratch buffer can write beyond the end of the destination scatter list.

The `scomp` interface is the software-side of the kernel's `acomp` (asynchronous compression) API. It is not a general-purpose path used by dm-crypt, TLS, or cipher operations — it exists exclusively to service IPsec compression transforms (IPCOMP, RFC 3173). `scomp_acomp_comp_decomp()` is only reached when a compression algorithm is registered with the scomp backend and a caller submits a request to it. On Root Lock there are no such callers and no such registrations:

- `# CONFIG_INET_IPCOMP is not set` — the IPv4/IPv6 IPsec compression module is not compiled; no IPCOMP transform can be configured
- `# CONFIG_CRYPTO_DEFLATE is not set` — DEFLATE not compiled; not registered with scomp
- `# CONFIG_CRYPTO_LZ4 is not set` — LZ4 not compiled; not registered with scomp
- `# CONFIG_CRYPTO_ZSTD is not set` — ZSTD not compiled; not registered with scomp

With no compression algorithm registered, the scomp backend has no handler to dispatch to. `CONFIG_CRYPTO=y` means the crypto framework is present, but framework presence is not trigger reachability. The trigger cannot be reached on any Root Lock deployment.

### CVE-2024-26654

**Status**: Not exploitable
**Component**: ALSA AICA Dreamcast sound driver (`CONFIG_SND_AICA`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport — not required for HS)

This CVE describes a use-after-free caused by a circular scheduling race between `dreamcastcard->timer` and `spu_dma_work` in the AICA Yamaha sound chip driver (`sound/sh/aica.c`). The timer callback `aica_period_elapsed()` schedules `spu_dma_work` via `schedule_work()`; the work handler then re-arms the timer via `mod_timer()`. `spu_begin_dma()` independently schedules the work and arms the timer in the same call. These two execution paths can race against each other and against card teardown, producing a use-after-free on the `snd_card_aica` object while the timer or work item is still pending.

`CONFIG_SND_AICA` is not set in the Root Lock kernel. `sound/sh/aica.c` is gated by `obj-$(CONFIG_SND_AICA)` in `sound/sh/Makefile` and is not compiled. There is no AICA driver code present in the running kernel — not merely absent hardware, but absent code. An attempt to reach this path has no code to execute. The Root Lock kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.

### CVE-2024-26704

**Status**: Not exploitable
**Component**: ext4 filesystem — online defragmentation (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `EXT4_IOC_MOVE_EXT` ioctl only reached by defragmentation tools; none in Root Lock allowlist
**Affected range**: kernels prior to stable fixes in the 6.8.x, 6.7.x, 6.6.x, 6.1.x, 5.15.x, 5.10.x, and 5.4.x series (5.19 branch is EOL; no backport)
**Upstream fix**: merged in Linux 6.8; backported across active stable series

This CVE describes a use-after-free in `ext4_move_extents()` in `fs/ext4/move_extent.c`, reachable via the `EXT4_IOC_MOVE_EXT` ioctl. The function moves file extents between an original inode and a donor inode. If the first move operation fails, `o_start` has not advanced past `orig_blk`, so `*moved_len` is set to zero. Preallocation blocks set up for `orig_inode` and `donor_inode` are discarded only when `*moved_len` is non-zero — the guard at `move_extent.c:692`. With `*moved_len == 0`, those preallocations are never discarded, leaving stale preallocation state that produces a use-after-free when the preallocations are later released. The `EXT4_IOC_MOVE_EXT` ioctl requires only write access to the file — no `CAP_SYS_ADMIN`, consistent with the `PR:L` CVSS score.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. The `EXT4_IOC_MOVE_EXT` ioctl is the sole entry point to the vulnerable `ext4_move_extents()` path; it is invoked by extent-defragmentation tools (`e4defrag`) and not by normal filesystem read or write operations. No defragmentation tool appears in the Root Lock allowlist, and the kernel blocks any process without an allowlist entry from executing. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

If your deployment adds `e4defrag` or any other extent-defragmentation tool to the Root Lock allowlist, the `EXT4_IOC_MOVE_EXT` ioctl becomes reachable and this CVE applies at its base score of 7.8 HIGH. Treat it as Affected and apply the standard backstop logic.

### CVE-2024-26842

**Status**: Not exploitable
**Component**: UFS host controller driver (`CONFIG_SCSI_UFSHCD`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in; no code path exists
**Upstream fix**: merged in Linux 6.8; backported across active stable series (5.19 branch is EOL; no backport — not required for HS)

This CVE describes an out-of-bounds memory access in the UFS host controller driver's MCQ (Multi-Circular Queue) mode. When `task_tag >= 32` and `sizeof(unsigned int) == 4`, the expression `1U << task_tag` is undefined behaviour in C — shifting a 32-bit value by 32 or more positions. In practice this produces incorrect bitmask values in the per-queue task tracking, allowing the computed mask to index outside the valid task range and corrupt adjacent memory.

`CONFIG_SCSI_UFSHCD` is not set in the Root Lock kernel. The UFS host controller driver is not compiled, and no UFS source files are present under `drivers/scsi/ufs/` in the kernel tree. The prior claim that "ufshcd is compiled in but never bound to hardware" was incorrect — the driver does not exist in the running kernel image at all. The Root Lock kernel predates the upstream fix, but the fix is not required: it patches code that was never compiled in.

### CVE-2022-48662

**Status**: Not exploitable
**Component**: Intel i915 DRM driver — i915_perf (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no Intel display GPU present
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
**Score on Root Lock**: 0.0 — no USB interface device on headless HS server; deadlock race unreachable
**Affected range**: 4.11–6.8
**Upstream fix**: 6.8.2 series

Among the attribute file callback routines in `drivers/usb/core/sysfs.c`, `interface_authorized_store()` is the only one that acquires a device lock on an ancestor device. It delegates immediately to `usb_deauthorize_interface()` (`drivers/usb/core/message.c`), which takes `device_lock(dev->parent)` first (line 1792) and then `device_lock(dev)` (line 1795). This lock ordering diverges from other USB subsystem paths, creating an ABBA deadlock when a concurrent bind or configuration operation holds the interface device lock and waits to acquire the parent lock while `usb_deauthorize_interface()` holds the parent lock and waits for the child. The deadlock stalls the USB subsystem and can produce a kernel hang. The HS 5.19.6 kernel carries the unpatched `interface_authorized_store()` at `drivers/usb/core/sysfs.c:1172` and the unchanged `usb_deauthorize_interface()` at `drivers/usb/core/message.c:1792`.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. Triggering the ABBA deadlock race requires writing to the `/sys/.../authorized` sysfs attribute of an enumerated USB interface device while a concurrent USB operation is in progress. Root Lock runs on headless server hardware with no external USB devices connected; no USB interface device is enumerated, so the sysfs path does not exist and the race condition is unreachable. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-26939

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no Intel display GPU present
**Affected range**: pre-6.8
**Upstream fix**: 6.8 series

Object debugging tools were sporadically reporting illegal attempts to free a still-active i915 VMA object when parking a GT believed to be idle: `[161.359441] ODEBUG: free active object type: i915_active`. When the GPU's Graphics Tile (GT) transitions to the parked (powered-down) state, `i915_vma_parked()` (`drivers/gpu/drm/i915/i915_vma.c:1729`) iterates the `gt->closed_vma` list of VMAs marked for deferred destruction. For each candidate it calls `i915_gem_object_trylock()` (line 1758) and, on success, calls `i915_vma_destroy()` (line 1760) immediately — without checking whether the VMA's embedded `i915_active` tracker has reached zero. If outstanding GPU command-buffer work still holds a live reference through that tracker, the object is freed while completion callbacks continue to dereference it, producing a use-after-free with attacker-controlled timing on the GPU side.

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes are not created and the GT power-management paths that call `i915_vma_parked()` are never reached. The environmental score reflects this: the vulnerable code path is structurally unreachable on the deployed hardware configuration.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-48689

**Status**: Affected
**Component**: TCP receive zerocopy (`CONFIG_INET`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)
**Affected range**: 4.14–pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

A syzbot report identified a misuse of pfmemalloc page status in TCP zerocopy receive paths. In `tcp_zerocopy_receive()` (`net/ipv4/tcp.c:2086`), socket buffer fragment pages are collected into a batch (line 2178: `page = skb_frag_page(frags)`) and mapped directly into userspace via `vm_insert_pages()`. No `page_is_pfmemalloc()` check is performed before adding a fragment page to the batch. Pages allocated from pfmemalloc reserves (used to break memory-pressure deadlocks in the network receive path) carry special lifecycle accounting; mapping them into userspace circumvents that accounting. A local attacker who can induce a pfmemalloc allocation into the TCP receive path can map a reserve page into their own address space, potentially corrupting page refcount state in ways that lead to privilege escalation.

**Why the score is not 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP zerocopy receive path (`TCP_ZEROCOPY_RECEIVE` ioctl on a connected socket) is reachable by any local user with network access. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-48701

**Status**: Not exploitable
**Component**: USB audio driver (`CONFIG_SND_USB_AUDIO`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

There may be a bad USB audio device with a USB ID of (0x04fa, 0x4201) and fewer than 4 interfaces; an out-of-bounds read bug occurs when the USB audio stream parser iterates altsettings. The Dallas DS4201 workaround at `sound/usb/stream.c:1108` unconditionally caps `num = 4` regardless of how many altsettings the device actually reports. If a malicious or malformed device presents that USB ID with fewer than 4 altsettings, the loop at line 1111 accesses `iface->altsetting[i]` beyond the bounds of the array, leaking kernel memory.

`CONFIG_SND_USB_AUDIO` is not set in the HS 5.19.6 configuration. The USB audio driver — including the vulnerable `sound/usb/stream.c` altsetting parser — is not compiled into the kernel image. A USB device with this ID cannot be claimed by any USB audio driver, and the vulnerable code path does not exist on this system.

### CVE-2022-48702

**Status**: Not exploitable
**Component**: EMU10K1 audio driver (`CONFIG_SND_EMU10K1`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

The voice allocator sometimes begins allocating from near the end of the array and then wraps around; however `snd_emu10k1_pcm_channel_alloc()` accesses the voices array without the wrapping modulo that the allocator itself uses. The round-robin allocator in `sound/pci/emu10k1/voice.c:42` uses `i %= NUM_G` to keep indices in bounds, but `sound/pci/emu10k1/emupcm.c:127` assigns multichannel voices as `&emu->voices[epcm->voices[0]->number + i]` with no `% NUM_G` guard. When the allocator places the first voice near the end of the 64-entry array and more than one voice is requested, the addition exceeds array bounds, producing an out-of-bounds read and write that can corrupt adjacent kernel memory.

`CONFIG_SND_EMU10K1` is not set in the HS 5.19.6 configuration. The EMU10K1 driver — including the vulnerable `sound/pci/emu10k1/emupcm.c` channel allocator — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-48695

**Status**: Not exploitable
**Component**: mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

A use-after-free occurs during controller reset in the mpt3sas firmware event cleanup path. In `drivers/scsi/mpt3sas/mpt3sas_scsih.c`, the reset handler iterates queued firmware events and calls `cancel_work_sync()` on each. When `cancel_work_sync()` returns non-zero (the work was never executed), the handler calls `fw_event_work_put()` at line 3752 to release the work's reference — then unconditionally calls `fw_event_work_put()` again at line 3754. This double decrement underflows the `kref` reference count, freeing the `fw_event_work` object while other paths may still hold pointers to it.

`CONFIG_SCSI_MPT3SAS` is not set in the HS 5.19.6 configuration. The mpt3sas driver — including the vulnerable firmware event cleanup path — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-35789

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

When moving a station out of a VLAN and deleting the VLAN afterwards, the fast_rx entry still holds a pointer to the VLAN's netdev, which can cause use-after-free. In `net/mac80211/cfg.c`, the station change path at line 1949 calls `__ieee80211_check_fast_rx_iface(vlansdata)`, which builds a new `fast_rx` structure with `dev = vlansdata->dev` (the target VLAN's netdev). The original VLAN's fast_rx is cleared at line 1955 via `ieee80211_clear_fast_rx(sta)`, but that function uses RCU: the old `fast_rx` object — containing `dev = original_vlan->dev` — is not freed until after a grace period. If the original VLAN interface is deleted before that grace period expires, any CPU still reading the old fast_rx entry will dereference a freed netdev. The HS 5.19.6 kernel carries the unpatched station change path at `net/mac80211/cfg.c:1939–1970`.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-35886

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

**What this means for an attacker:**

syzkaller reported infinite recursive calls of `fib6_dump_done()` during netlink socket destruction. From the log, syzkaller sent an AF_UNSPEC RTM_GETROUTE message, and then closed the netlink socket. The IPv6 FIB dump handler at `net/ipv6/ip6_fib.c:652` hooks the callback destructor by setting `cb->done = fib6_dump_done` (saving the original callback in `cb->args[3]`). When the netlink socket closes, netlink core invokes the destructor, calling `fib6_dump_done()` at line 570. This function calls `cb->done(cb)` — but `cb->done` is now `fib6_dump_done` itself, creating infinite recursion that exhausts the kernel stack. The HS 5.19.6 kernel carries the unpatched FIB dump callback at `net/ipv6/ip6_fib.c:645–684`.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Triggering the infinite recursion requires sending an `AF_UNSPEC RTM_GETROUTE` netlink message and then closing the socket — reachable by any local user with a netlink socket. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-52835

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist
**Affected range**: pre-fix
**Upstream fix**: 6.8 series

When perf-record with a large AUX area, e.g. 4GB, it fails with: `#perf record -C 0 -m ,4G -e arm_spe_0// -- sleep 1 failed to mmap with 12 (Cannot allocate memory)`. The perf AUX area mmap handler in `kernel/events/core.c:6269–6345` calculates memory accounting limits and calls `rb_alloc_aux()` to allocate the backing pages. For very large AUX areas (gigabytes), the accounting arithmetic at line 6285 (`user_locked += user_extra`) can underflow or produce incorrect values when `user_extra` is extremely large (e.g., 1M pages for 4GB). The mmap() still succeeds despite the accounting failure, allowing unprivileged users to bypass RLIMIT_MEMLOCK restrictions and exhaust kernel memory. The HS 5.19.6 kernel carries the unpatched AUX area accounting at `kernel/events/core.c:6269–6345`.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-52868

**Status**: Not exploitable
**Component**: thermal management (`CONFIG_THERMAL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — thermal sysfs not accessible in Root Lock allowlist; Lockdown blocks the trigger
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

The `dev->id` value comes from `ida_alloc()`, so it is a number between zero and INT_MAX. In `drivers/thermal/thermal_core.c`, this ID is formatted into fixed-size `THERMAL_NAME_LENGTH` (20-byte) buffers using `sprintf()`. At line 681, `sprintf(dev->attr_name, "cdev%d_trip_point", dev->id)` produces a string of the form `"cdev<N>_trip_point"`. For large IDs, the full string exceeds 20 bytes: `"cdev2147483647_trip_point"` is 25 characters plus a null terminator (26 bytes total), overflowing `attr_name` by 6 bytes. The same overflow applies at line 690 for `sprintf(dev->weight_attr_name, "cdev%d_weight", dev->id)`, which produces up to 22 bytes into a 20-byte buffer. Both overflows corrupt adjacent kernel heap memory and can be leveraged for privilege escalation.

`CONFIG_THERMAL=y` is compiled in and 5.19.6 falls within the affected range. Thermal management is present on all x86 servers for CPU temperature control. Triggering the overflow requires registering a thermal cooling device with a sufficiently large ID — this path requires access to the thermal sysfs interface, which is not included in the Root Lock allowlist. On a Root Lock system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the thermal registration interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-36916

**Status**: Not exploitable
**Component**: block I/O cost controller (`CONFIG_BLK_CGROUP_IOCOST`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — iocost cgroup paths not in Root Lock allowlist; Lockdown blocks the trigger
**Affected range**: pre-fix
**Upstream fix**: 6.9 series

UBSAN catches undefined behavior in blk-iocost, where sometimes `iocg->delay` is shifted right by a number that is too large, resulting in undefined behavior on some architectures. Two sites in `block/blk-iocost.c` are affected: line 1338 computes `iocg->delay >> div64_u64(tdelta, USEC_PER_SEC)`, where the divisor is elapsed time in seconds — if the delay has been active for 64 or more seconds, the shift amount reaches or exceeds 64, which is undefined behavior for a 64-bit type under the C standard. Line 2112 performs `iocg->delay >> nr_cycles`, where `nr_cycles` can similarly exceed 63. On x86 the shift wraps, but on other architectures the result is indeterminate. Incorrect delay values can bypass I/O throttling controls or cause the cgroup I/O cost model to make scheduling decisions based on garbage data.

`CONFIG_BLK_CGROUP_IOCOST=y` is compiled in and 5.19.6 falls within the affected range. The blk-iocost controller is active whenever cgroups are in use with I/O cost weighting enabled. Configuring iocost requires writing to cgroup control files under `/sys/fs/cgroup/` — no cgroup management tool that exposes iocost configuration appears in the Root Lock allowlist. On a Root Lock system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the iocost configuration path. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-38560

**Status**: Not exploitable
**Component**: Brocade bfa SCSI driver (`CONFIG_SCSI_BFA`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

Currently, we allocate a `nbytes`-sized kernel buffer and copy `nbytes` from userspace to that buffer. In `drivers/scsi/bfa/bfad_bsg.c`, the BSG passthrough handler at line 3373 allocates `kzalloc(bsg_data->payload_len, GFP_KERNEL)` where `payload_len` comes directly from the user-supplied BSG request structure, with no upper-bound validation. Line 3379 then calls `copy_from_user(..., bsg_data->payload_len)` using the same unchecked value. An attacker with access to the BSG device node can supply an oversized `payload_len` to exhaust kernel memory or, with a carefully chosen value, produce a heap overflow.

`CONFIG_SCSI_BFA` is not set in the HS 5.19.6 configuration. The Brocade bfa Fibre Channel HBA driver — including the vulnerable `bfad_bsg.c` BSG handler — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-38588

**Status**: Not exploitable
**Component**: kprobes (`CONFIG_KPROBES`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — kprobe registration not in Root Lock allowlist; Lockdown blocks the exploitation trigger
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `kernel/trace/ftrace.c`, `ftrace_location()` at line 1577 calls `lookup_rec(ip, ip)` at line 1583 to obtain a `dyn_ftrace *rec` pointer without holding `ftrace_lock`. On a concurrent path, module unloading frees the pages that back ftrace records for module functions. If a module is removed between the `lookup_rec()` return and the `return rec->ip` dereference at line 1594, the pointer references freed memory. The race is reached through the kprobe registration path: `check_kprobe_address_safe()` → `check_ftrace_location()` → `ftrace_location()` — all called without the lock that serialises ftrace record lifetime.

`CONFIG_KPROBES=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` to register a kprobe — the attack path runs through `check_kprobe_address_safe()` → `check_ftrace_location()` → `ftrace_location()`. No Root Lock deployment permits any service to register kprobes. Without an allowlist entry covering the kprobes interface, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-40901

**Status**: Not exploitable
**Component**: LSI/Avago mpt3sas SCSI driver (`CONFIG_SCSI_MPT3SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/scsi/mpt3sas/mpt3sas_scsih.c`, the `pd_handles` bitmap is allocated as `(ioc->facts.MaxDevHandle / 8)` bytes (rounded up) via `kzalloc()` at `mpt3sas_base.c:8312`. The `test_bit()` function accesses bitmaps in `unsigned long`-sized units (8 bytes on 64-bit kernels). When the allocation is smaller than `sizeof(unsigned long)` — for example a single byte when `MaxDevHandle` is 8 — calls such as `test_bit(sas_device->handle, ioc->pd_handles)` at line 1942 and `test_bit(handle, ioc->pd_handles)` at line 4106 read 7 bytes beyond the heap allocation, producing a slab out-of-bounds read.

`CONFIG_SCSI_MPT3SAS` is not set in the HS 5.19.6 configuration. The LSI/Avago mpt3sas SAS/SATA/NVMe HBA driver — including the vulnerable `mpt3sas_scsih.c` bitmap access paths — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-40978

**Status**: Not exploitable
**Component**: QLogic qedi iSCSI driver (`CONFIG_SCSI_QEDI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/scsi/qedi/qedi_debugfs.c`, `qedi_dbg_do_not_recover_cmd_read()` at line 128 calls `sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover)` where `buffer` is the `char __user *` argument passed directly from the debugfs file read handler. `sprintf()` writes to a kernel virtual address rather than staging data in a kernel buffer first; on a system with SMAP (Supervisor Mode Access Prevention) enabled, the kernel write to a userspace pointer faults immediately and panics the kernel. The correct fix is to stage into a kernel buffer and use `simple_read_from_buffer()` to copy to userspace.

`CONFIG_SCSI_QEDI` is not set in the HS 5.19.6 configuration. The QLogic qedi iSCSI HBA driver — including the vulnerable `qedi_dbg_do_not_recover_cmd_read()` debugfs handler — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-41092

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no Intel display GPU present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In the i915 GT reset path, `intel_gt_handle_error()` at `intel_reset.c:1309` calls `synchronize_srcu_expedited()` at line 1285 on `gt->reset.backoff_srcu` to drain concurrent SRCU readers before the GPU reset proceeds. The GuC engine failure worker (`reset_fail_worker_func` at `intel_guc_submission.c:4485`) queues via `queue_work()` at line 4545 and calls `intel_gt_handle_error()` asynchronously. A race between this deferred reset path and the hangcheck heartbeat — as reproduced by `igt@i915_selftest@live@hangcheck` on ADL-P (GuC submission) — can reach `reset_prepare_engine()` at `intel_reset.c:743` and the WW-mutex backoff context via `i915_gem_ww_ctx_backoff()` (`i915_gem_ww.c:42`) after the owning structure has already been freed, producing a use-after-free.

`CONFIG_DRM_I915=y` is compiled in and HS 5.19.6 falls within the affected range. No Intel integrated or discrete display GPU is present on a standard Debian 11 server deployment. Without display hardware the DRM device nodes are not created, the GPU submission paths are not initialised, and the GuC engine failure worker that triggers this race is never scheduled. The vulnerable code path cannot be reached.

On a HeartSuite system with this hardware installed, Lockdown's constraints would still apply after any escalation: `FS_IOC_SETFLAGS` returns EPERM (`kernel/ioctl.c:561–569`), every mount path returns EPERM (`kernel/namespace.c:4218, 4300, 4453`), and allowlist modification is blocked at `hs_sandbox_caching.c:1942`. Lockdown independently prevents any unauthorised program — including a backdoor dropped post-exploit — from executing regardless of file ownership or capability bits.

### CVE-2024-42136

**Status**: Not exploitable
**Component**: CD-ROM subsystem (`CONFIG_CDROM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — CD-ROM drive absent on server
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/cdrom/cdrom.c`, `cdrom_read_cd()` at line 2080 computes `cgc->buflen = blocksize * nblocks` and `cdrom_read_block()` at line 2104 computes `cgc->buflen = blksize * nblocks`. Both operands are `int` parameters, so the multiplication is evaluated as a signed 32-bit expression before being stored in the `unsigned int buflen` field of `struct packet_command`. When syzkaller passes a large `nblocks` value — for example, greater than 912,000 with the common `CD_FRAMESIZE_RAW = 2352` block size — the intermediate product exceeds `INT_MAX`, signed integer overflow occurs, and an incorrect (smaller) buffer length is stored in `cgc->buflen`.

`CONFIG_CDROM=y` is compiled in and HS 5.19.6 falls within the affected range. No optical drive is present on a standard Debian 11 server deployment. Without this hardware the CD-ROM device nodes are not created and the ioctl paths that call `cdrom_read_cd()` and `cdrom_read_block()` are never reached. The vulnerable code path cannot be triggered.

On a HeartSuite system with an optical drive installed, Lockdown's constraints would still apply after any escalation: `FS_IOC_SETFLAGS` returns EPERM (`kernel/ioctl.c:561–569`), every mount path returns EPERM (`kernel/namespace.c:4218, 4300, 4453`), and allowlist modification is blocked at `hs_sandbox_caching.c:1942`. Lockdown independently prevents any unauthorised program — including a backdoor dropped post-exploit — from executing regardless of file ownership or capability bits.

### CVE-2024-44985

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_finish_output2()` saves `idev = ip6_dst_idev(dst)` at line 63. At line 72, `skb_expand_head(skb, hh_len)` makes room for the link-layer header; when allocation fails, `skb_expand_head()` frees the original `skb` and returns NULL. The `idev` pointer saved before the call now references memory associated with the freed `skb`. At line 74, `IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS)` dereferences the stale `idev` — a use-after-free.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-44986

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_xmit()` saves `idev = ip6_dst_idev(dst)` at line 256. At line 271, `skb_expand_head(skb, head_room)` expands the buffer to accommodate the IPv6 header and IP options; when allocation fails, the original `skb` is freed and NULL is returned. The `idev` pointer is now stale. At line 273, `IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS)` dereferences freed memory — a use-after-free.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-44987

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `net/ipv6/ip6_output.c`, `ip6_send_skb()` at line 1943 saves `rt = (struct rt6_info *)skb_dst(skb)` without holding `rcu_read_lock()`. At line 1946, `ip6_local_out()` transmits the packet and may consume the `skb`, releasing the associated route. If `ip6_local_out()` returns a non-zero error code, lines 1951–1952 dereference `rt->rt6i_idev` — but `rt` is an RCU-protected pointer and may be freed before the dereference. Holding `rcu_read_lock()` for the duration of the `rt` dereference is required.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. Any local process that sends IPv6 network traffic can trigger the vulnerable allocation failure paths; no capability gate is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-46673

**Status**: Not exploitable
**Component**: Adaptec aacraid SCSI driver (`CONFIG_SCSI_AACRAID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`aac_probe_one()` at `drivers/scsi/aacraid/linit.c:1577` calls the hardware-specific `init` function pointer from `aac_driver_ident`, which eventually calls `aac_init_adapter()` at `comminit.c:510`. On failure, `aac_init_adapter()` frees `dev->queues` internally at line 644 (on `aac_comm_init()` failure) or line 651 (on `aac_fib_setup()` failure) before returning NULL. The `aac_probe_one()` error path at `linit.c:1798` then calls `kfree(aac->queues)` a second time on the same pointer — a double-free.

`CONFIG_SCSI_AACRAID` is not set in the HS 5.19.6 configuration. The Adaptec aacraid RAID controller driver — including the vulnerable `aac_probe_one()` and `aac_init_adapter()` paths — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46746

**Status**: Not exploitable
**Component**: AMD Sensor Fusion Hub HID driver (`CONFIG_AMD_SFH_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `drivers/hid/amd-sfh-hid/amd_sfh_client.c`, the error cleanup path calls `devm_kfree(dev, cl_data->report_descr[i])` at lines 259 and 276 to free the HID report descriptor before `hid_destroy_device()` at line 178. The `amdtp_hid_parse()` callback at `amd_sfh_hid.c:32` accesses `cli_data->report_descr[hid_data->index]` during device initialisation or tear-down. If the descriptor is freed before `hid_destroy_device()` has completed its disconnect sequence — and the callback fires in that window — it dereferences freed memory.

`CONFIG_AMD_SFH_HID` is not set in the HS 5.19.6 configuration. The AMD Sensor Fusion Hub HID driver — including the vulnerable `amd_sfh_client.c` cleanup path and `amdtp_hid_parse()` callback — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46747

**Status**: Not exploitable
**Component**: Cougar HID driver (`CONFIG_HID_COUGAR`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`cougar_report_fixup()` at `drivers/hid/hid-cougar.c:109` reads `rdesc[2]`, `rdesc[3]`, `rdesc[115]`, and `rdesc[116]`, and conditionally writes to `rdesc[115]`–`rdesc[116]` at lines 113–114, without first checking that `*rsize >= 117`. If the Cougar 500k Gaming Keyboard presents a report descriptor shorter than 117 bytes, the fixed-offset accesses go beyond the descriptor buffer, producing an out-of-bounds memory read/write.

`CONFIG_HID_COUGAR` is not set in the HS 5.19.6 configuration. The Cougar HID driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-46798

**Status**: Not exploitable
**Component**: ALSA rawmidi subsystem (`CONFIG_SND_RAWMIDI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_RAWMIDI` not compiled
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `sound/core/rawmidi.c`, `snd_rawmidi_drain_output()` at line 224 saves `runtime = substream->runtime` at line 228, then calls `wait_event_interruptible_timeout(runtime->sleep, ...)` at line 232, waiting up to 10 seconds for the output buffer to drain. If `close_substream()` runs concurrently and calls `snd_rawmidi_runtime_free(substream)` at line 528 — freeing `substream->runtime` — while the drain wait is still sleeping, the `runtime` pointer saved at line 228 becomes dangling. When the wait exits, accesses to `runtime->avail` and `runtime->buffer_size` at line 237 use freed memory.

`CONFIG_SND_RAWMIDI` is not compiled in the HS 5.19.6 configuration — no enabled driver selects it. The vulnerable `rawmidi.c` code path does not exist on this system.

### CVE-2024-46849

**Status**: Not exploitable
**Component**: Amlogic Meson ASoC driver (`CONFIG_SND_MESON_CARD_UTILS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — driver not compiled in
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `sound/soc/meson/axg-card.c`, `axg_card_add_loopback()` at line 107 saves `pad = &card->dai_link[*index]` — a pointer into the current `dai_link` array. At line 113, `meson_card_reallocate_links()` calls `krealloc()` on `card->dai_link`, potentially moving the array to a new address and freeing the original buffer. At lines 119 and 133, `pad->name` and `pad->cpus->of_node` are accessed through the now-dangling `pad` pointer. The fix moves the `pad` assignment to after the reallocation, where `card->dai_link` has been updated.

`CONFIG_SND_MESON_CARD_UTILS` is not compiled in the HS 5.19.6 configuration — the Amlogic Meson ASoC platform requires `ARCH_MESON` which is not set on x86. The vulnerable code path does not exist on this system.

### CVE-2024-47682

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — non-conformant VPD firmware absent; standard SAS/SATA drives conform to SCSI spec
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

If a device returns VPD page 0xb1 with a length of exactly 8 bytes (as QEMU v2.x does), `sd_read_block_characteristics()` proceeds past the guard at `drivers/scsi/sd.c:2921` (`vpd->len < 8`), then reads `vpd->data[8]` at line 2927. With `len == 8` the valid indices are 0–7; index 8 is one byte past the end of the buffer.

`CONFIG_SCSI=y` is compiled in and HS 5.19.6 falls within the affected range. The OOB read occurs during device enumeration when a SCSI disk returns VPD page 0xb1 with a length of exactly 8 bytes — behaviour documented in QEMU v2.x, not present on production SAS/SATA/NVMe drives. Standard enterprise storage conforms to the SCSI VPD specification and returns page 0xb1 with the correct length. On a Root Lock server deployment, no non-conformant storage device is present; the OOB read path in `sd_read_block_characteristics()` is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-47701

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

When ext4 searches an inlined directory, `ext4_find_inline_entry()` at `fs/ext4/inline.c:1709` calls `ext4_get_inline_xattr_pos()` to locate the extended-attribute portion of the inline data. At `inline.c:1077`, that function returns `IFIRST(header) + le16_to_cpu(entry->e_value_offs)` without validating that the offset stays within the inode body buffer. A crafted block device can supply an `e_value_offs` that pushes the resulting pointer out of bounds; that pointer is then passed directly to `ext4_search_dir()` at line 1712, causing an OOB memory access.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; inlined directory processing runs for any small directory during normal operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49852

**Status**: Not Affected — `CONFIG_SCSI_EFCT` not compiled
**Component**: Emulex EFC FC driver (`CONFIG_SCSI_EFCT`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_EFCT` not compiled in Root Lock kernel

The kref_put() function will call nport->release if the refcount drops to zero. The nport->release release function is_efc_nport_free() which frees "nport"

`CONFIG_SCSI_EFCT` is not set in the HS 5.19.6 configuration. The Emulex EFC Fibre Channel target driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-49882

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_ext_try_to_merge_up()` at `fs/ext4/extents.c:1871`, `brelse(path[1].p_bh)` releases the depth-1 extent block buffer but leaves `path[1].p_bh` non-NULL. When the caller subsequently runs cleanup via `ext4_ext_drop_refs()`, it iterates the path and calls `brelse()` on every non-NULL `p_bh`, releasing the same buffer head a second time — a use-after-free.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent tree merge-up runs during any truncate or extent modification on a two-level extent tree. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49883

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_ext_insert_extent()` at `fs/ext4/extents.c:2094`, the call to `ext4_ext_create_new_leaf()` may internally call `ext4_ext_grow_indepth()`, which reallocates the `path` array via `kcalloc()`. After the call returns, the caller continues using the original `path` pointer — now stale — causing a use-after-free.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent insertion runs during any file write that extends or modifies the extent tree. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49884

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

In `ext4_split_extent_at()` at `fs/ext4/extents.c:3178`, the function saves the path pointer as `path = *ppath`. At line 3248 it calls `ext4_ext_insert_extent(handle, inode, ppath, ...)`, which may reallocate `*ppath`, freeing the memory that `path` still points to. Subsequent uses of `path` at lines 3281, 3282, 3301, and 3304 — in both the success and error-recovery branches — dereference the now-freed pointer, constituting a use-after-free.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; extent splitting is triggered during any write that bisects an existing extent. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49889

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

**What this means for an attacker:**

`ext4_find_extent()` at `fs/ext4/extents.c:874` takes an optional `**orig_path` argument allowing callers to reuse an existing path allocation. On two code paths it frees the old allocation: when the tree depth has grown beyond the cached maximum (lines 898–901, `kfree(path); *orig_path = NULL`) and on any I/O or corruption error (lines 953–957, same sequence). Callers that save a local `path = *ppath` copy before invoking a sub-function that internally calls `ext4_find_extent()` — such as `ext4_split_convert_extents()` — retain a pointer to the freed memory. Subsequent use of that stale pointer constitutes a use-after-free.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server; any extent-modifying write that triggers a tree depth change or encounters a read error while holding a saved path pointer is a triggering condition. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-49960

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ext4_fill_super()` (`fs/ext4/super.c`), `timer_setup(&sbi->s_err_report, ...)` runs at line 4995 and `INIT_WORK(&sbi->s_error_work, flush_stashed_error_work)` at line 4997. During the `failed_mount3:` error-unwind at line 5454, `flush_work(&sbi->s_error_work)` is called at line 5456 immediately before `del_timer_sync(&sbi->s_err_report)` at line 5457. The work callback `flush_stashed_error_work` can call `mod_timer` on `s_err_report`, arming the timer during the same unwind that is about to cancel it. When the code path passes through `failed_mount_wq:` (line 5439), `flush_work` runs a second time at line 5448 before falling through to `failed_mount3:`, doubling the exposure. Syzbot detected this as an ODEBUG (Object Debug) object-state inconsistency.

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable path runs during a failed mount — for example when `ext4_es_register_shrinker()` or journal loading fails partway through `ext4_fill_super()`. On a Root Lock system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the Root Lock allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-49983

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ext4_ext_replay_update_ex()` at `fs/ext4/extents.c:5860`, line 5879 assigns `ppath = path`, making both local variables alias the same allocation. Line 5881 then calls `ext4_force_split_extent_at(NULL, inode, &ppath, start, 1)`, passing the address of `ppath`. Inside, `ext4_split_extent_at()` calls `ext4_ext_insert_extent()` which may invoke `ext4_ext_grow_indepth()` and reallocate `*ppath` via `kcalloc()`. When that happens, the outer `ppath` is updated to the new allocation and the original memory is freed — but `path` still holds the original (now stale) pointer. The `kfree(path)` call at line 5885 then frees already-freed memory, constituting a double-free/use-after-free. The bug is exercised during fast-commit journal replay.

`CONFIG_EXT4_FS=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable path runs during fast-commit journal replay, triggered on mount after an unclean shutdown of a filesystem with the fast-commit feature enabled. On a Root Lock system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the Root Lock allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-50007

**Status**: Not Affected
**Component**: ASIHPI soundcard driver (`CONFIG_SND_ASIHPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_ASIHPI` not compiled

The ASIHPI driver writes firmware-controlled index values into a static array without bounds-checking the index. `CONFIG_SND_ASIHPI` is not set in the HS 5.19.6 kernel configuration; the driver and this code path are absent from the compiled kernel image.

### CVE-2022-48951

**Status**: Not Affected
**Component**: ALSA SoC layer (`CONFIG_SND_SOC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_SOC` not compiled

`snd_soc_put_volsw_sx()` applies bounds checks only to the first channel, allowing out-of-bounds writes to the second. `CONFIG_SND_SOC` is not set in the HS 5.19.6 kernel configuration; the ALSA SoC layer and this function are absent from the compiled kernel image.

### CVE-2022-48956

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`ip6_fragment()` at `net/ipv6/ip6_output.c:831` handles IPv6 packet fragmentation. The function and its callees access RCU-protected routing and neighbor table entries; a prior commit added an assumption that all callers hold the RCU read lock at entry. For the IPv4-style fast path via `ip6_finish_output2()` this holds — `rcu_read_lock_bh()` is acquired at line 119. However the UDP egress path (`ip6_send_skb()` at line 1940 → `ip6_local_out()` → `ip6_output()` → `ip6_finish_output()` → `ip6_fragment()`) does not guarantee the lock is held before entry into the fragmentation code. Under concurrent route or neighbor table modification this produces a use-after-free. Syzbot confirmed the race.

`CONFIG_IPV6=y` is compiled in and HS 5.19.6 falls within the affected range. IPv6 is active on any Debian 11 server that has IPv6 addresses configured; the UDP-over-IPv6 fragmentation path is reachable by any process with a UDP socket. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-49022

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `ieee80211_get_rate_duration()` at `net/mac80211/airtime.c:455`, `airtime_mcs_groups[group].duration[idx]` is accessed where `group` is computed from bandwidth, stream count, and encoding mode via the `VHT_GROUP_IDX`/`HT_GROUP_IDX`/`HE_GROUP_IDX` macros. The stream-count bounds check at line 451 guards one dimension, but an invalid combination of bandwidth and stream count can produce a `group` index that exceeds the `airtime_mcs_groups` array bounds, triggering a UBSAN array-index-out-of-bounds read.

`CONFIG_MAC80211=y` is compiled in. No WiFi NIC is present on a Debian 11 server deployment; mac80211 creates no wireless interfaces without hardware and this code path is never reached. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or preserve access across a reboot.

### CVE-2022-49023

**Status**: Not exploitable
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `net/wireless/scan.c:338`, when merging per-STA profile elements in the multi-BSSID path, the code calls `memcmp(tmp_old + 2, tmp + 2, 5)` to compare the OUI (3 bytes) + type (1 byte) + subtype (1 byte) of a vendor element, without first checking that either IE has at least 5 bytes of data. A vendor element with fewer than 5 data bytes causes an out-of-bounds read beyond the element buffer.

`CONFIG_CFG80211=y` is compiled in. No WiFi NIC is present on a Debian 11 server deployment; cfg80211 creates no wireless interfaces without hardware and this code path is never reached. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or preserve access across a reboot.

### CVE-2024-50278

**Status**: Not Affected
**Component**: dm-cache (`CONFIG_DM_CACHE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_DM_CACHE` not compiled

If the cache device is expanded between initial load and first-time resume, the bitsets (`dirty_bitset`, `discard_bitset`) allocated in `dm-cache-target.c` are sized to the pre-expansion block count. On resume, cache-block indices derived from the new device size exceed the allocated bitset bounds, causing an out-of-bounds access. `CONFIG_DM_CACHE` is not set in the HS 5.19.6 kernel configuration; the dm-cache target and this code path are absent from the compiled kernel image.

### CVE-2024-50279

**Status**: Not Affected
**Component**: dm-cache (`CONFIG_DM_CACHE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_DM_CACHE` not compiled

When shrinking the fast (cache) device, dm-cache iterates the `dirty_bitset` to identify cache blocks that must be flushed before being dropped. An index error in the bitset iteration produces a bit index that exceeds the allocated bitset bounds, causing an out-of-bounds access. `CONFIG_DM_CACHE` is not set in the HS 5.19.6 kernel configuration; the dm-cache target and this code path are absent from the compiled kernel image.

### CVE-2024-53147

**Status**: Not exploitable
**Component**: FAT/exFAT filesystem (`CONFIG_FAT_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:H)
**Score on Root Lock**: 0.0 — Lockdown blocks `mount()`; no adversary-controlled FAT filesystem reachable
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `fs/exfat/dir.c`, when iterating directory entries, the cluster-walk loop at line 105 calls `exfat_get_next_cluster(sb, &(clu.dir))` to follow the FAT chain. If a directory's size is at least one cluster (so `clu_offset > 0`) and `ei->start_clu` was set to `EXFAT_EOF_CLUSTER` (`0xFFFFFFFF`) due to filesystem corruption, `clu.dir` starts at `0xFFFFFFFF`. The call at line 106 then attempts a FAT table lookup at index `0xFFFFFFFF`, which is far outside the FAT table's `num_clusters` entries, causing an out-of-bounds read.

`CONFIG_FAT_FS=y` is compiled in and HS 5.19.6 falls within the affected range. exFAT is compiled in and is used for the EFI system partition; the vulnerable path is triggered by traversing a corrupted exFAT directory. The adversary must be able to present a crafted exFAT image — mounting an external device or network share requires `mount()`, which Lockdown blocks unconditionally. The EFI system partition is already mounted at boot time and its contents are controlled by the administrator; an external attacker cannot inject a malformed exFAT directory into the in-use ESP. On a Root Lock system in Lockdown, the kernel additionally blocks any process without an allowlist entry from executing, closing the exploitation path before it can reach the vulnerable directory traversal code.

### CVE-2024-53150

**Status**: Not Affected
**Component**: USB audio driver (`CONFIG_SND_USB_AUDIO`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_USB_AUDIO` not compiled

The USB-audio driver does not validate `bLength` of each descriptor when traversing clock descriptors, allowing a malformed USB device to cause an out-of-bounds read. `CONFIG_SND_USB_AUDIO` is not set in the HS 5.19.6 kernel configuration; the USB audio driver and this descriptor-traversal path are absent from the compiled kernel image.

### CVE-2024-53170

**Status**: Affected
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

In `blk_mq_exit_hctx()` at `block/blk-mq.c:3440`, the call to `blk_mq_clear_flush_rq_mapping()` (line 3441) is guarded by `if (blk_queue_init_done(q))`. During SCSI device probe, the queue is not yet fully initialized, so this condition is false and `blk_mq_clear_flush_rq_mapping()` is skipped. The function is responsible for atomically clearing the `flush_rq` pointer from every slot in `tags->rqs[]`. When skipped, `flush_rq` is subsequently freed but its pointer remains live in the `rqs[]` array. Any later iteration over `tags->rqs[]` — such as during a tag-set teardown or request lookup — dereferences the stale pointer, constituting a use-after-free.

`CONFIG_SCSI=y` is compiled in and HS 5.19.6 falls within the affected range. The SCSI subsystem underpins block storage on Debian 11 via libata; the vulnerable path is triggered during SCSI probe teardown when initialization does not complete successfully. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-53173

**Status**: Not exploitable
**Component**: NFS v4 client (`CONFIG_NFS_V4`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `mount()` blocked by Lockdown; no NFS v4 share reachable on Root Lock deployments
**Affected range**: pre-fix
**Upstream fix**: mainline; not backported to 5.19.x (5.19 EOL)

`nfs_release_seqid()` at `fs/nfs/nfs4state.c:1088` removes a seqid from the sequence wait-list and wakes the next waiter (`rpc_wake_up_queued_task()` at line 1102). When two threads open the same file concurrently and both abort before receiving a reply, two separate code paths each call `nfs_release_seqid()` on the same `nfs_seqid`: the prepare callback at `fs/nfs/nfs4proc.c:2462` (when `nfs4_setup_sequence()` returns non-zero) and the done/release callback at line 2061. The second call finds `seqid->list` already empty and returns without action, but by this point `nfs_free_seqid()` may have freed the seqid object. The task woken by the first release can dereference `seqid->sequence` through the `nfs_seqid` pointer it holds — now pointing to freed memory — constituting a use-after-free.

`CONFIG_NFS_V4=y` is compiled in and HS 5.19.6 falls within the affected range. The vulnerable seqid use-after-free path is only reachable when an NFS v4 share is mounted. On a Root Lock system, Lockdown blocks `mount()` unconditionally — `do_mount()`, `fsmount()`, and `move_mount()` all return `EPERM` (`kernel/namespace.c:4218, 4300, 4453`). No NFS v4 filesystem can be mounted by any process, so the vulnerable code path is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-53214

**Status**: Not Affected
**Component**: VFIO subsystem (`CONFIG_VFIO`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_VFIO` not compiled

In `drivers/vfio/pci/vfio_pci_config.c`, the VFIO PCI extended-capability enumeration loop at line 1638 hides capabilities with unknown length by rewriting the `next` pointer in the previous entry's header. When a capability should be hidden but occupies the first position in the extended-capability chain, the pointer fixup path has incorrect behaviour, allowing a misconfigured or malicious guest to reach memory it should not. `CONFIG_VFIO` is not set in the HS 5.19.6 kernel configuration; the VFIO subsystem and this PCI config-space virtualisation path are absent from the compiled kernel image.

### CVE-2024-53227

**Status**: Not Affected
**Component**: Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_BFA_FC` not compiled

In the Brocade bfa Fibre Channel adapter driver (`drivers/scsi/bfa/`), a use-after-free occurs during driver load: an internal object containing an embedded spinlock is freed while lockdep still holds a reference to that lock, producing a KASAN `slab-use-after-free` splat inside `__lock_acquire`. `CONFIG_SCSI_BFA_FC` is not set in the HS 5.19.6 kernel configuration; the Brocade bfa driver is absent from the compiled kernel image.

### CVE-2024-53239

**Status**: Not Affected
**Component**: 6fire USB audio driver (`CONFIG_SND_USB_6FIRE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_USB_6FIRE` not compiled

In the TerraTec AUREON 6fire USB audio driver (`sound/usb/6fire/chip.c`), `usb6fire_chip_disconnect()` calls `usb6fire_chip_abort()` at line 183 — which schedules a deferred `snd_card_free_when_closed()` and nulls `chip->card` — immediately followed by `usb6fire_chip_destroy()` at line 184, which frees the underlying sub-resources. When userspace still holds the card open, the deferred free races against the destroy path, producing a use-after-free. `CONFIG_SND_USB_6FIRE` is not set in the HS 5.19.6 kernel configuration; the driver is absent from the compiled kernel image.

### CVE-2024-56609

**Status**: Not Affected
**Component**: Realtek rtw88 WiFi driver (`CONFIG_RTW88`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_RTW88` not compiled

In the Realtek rtw88 802.11ac/ax wireless driver (`drivers/net/wireless/realtek/rtw88/tx.c`), `rtw_tx_report_purge_timer()` at line 160 calls `skb_queue_purge()` at line 172 to discard queued TX-report SKBs when the firmware fails to acknowledge them. Because `ieee80211_tx_status()` is never called for the discarded SKBs, mac80211 retains a reference to the associated station structure after it has been freed, producing a use-after-free during driver teardown. `CONFIG_RTW88` is not set in the HS 5.19.6 kernel configuration; the rtw88 driver family is absent from the compiled kernel image.

### CVE-2024-56631

**Status**: Not exploitable
**Component**: SCSI generic driver (`CONFIG_CHR_DEV_SG`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `/dev/sg*` access not in Root Lock allowlist; Lockdown blocks the exploitation trigger
**Affected range**: Linux ≤ 6.12-rc7
**Upstream fix**: commit 4a9804207b58 ("scsi: sg: Fix UAF in sg_release()")

In the SCSI generic device driver (`drivers/scsi/sg.c`), `sg_release()` at line 382 acquires `sdp->open_rel_lock` at line 391, then calls `kref_put(&sfp->f_ref, sg_remove_sfp)` at line 393. If that `kref_put` drops the last reference, `sg_remove_sfp` is invoked, which can free the `Sg_device` structure that `sdp` points to — including its embedded mutex. The subsequent `mutex_unlock(&sdp->open_rel_lock)` at line 404 then operates on freed memory, producing a KASAN `slab-use-after-free` in `lock_release`.

`CONFIG_CHR_DEV_SG=y` is compiled in. Reaching `sg_release()` in the race window requires an active open of a `/dev/sg*` device node — SCSI generic pass-through that requires `CAP_SYS_RAWIO`. No Root Lock deployment includes raw SCSI access in the Lockdown allowlist. Without an allowlist entry, the kernel refuses any process attempting to open `/dev/sg*`. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-56663

**Status**: Not exploitable
**Component**: cfg80211 wireless stack (`CONFIG_CFG80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present

In `net/wireless/nl80211.c`, the netlink policy for `NL80211_ATTR_MLO_LINK_ID` at line 797 uses `NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS)` — where `IEEE80211_MLD_MAX_NUM_LINKS = 15` (`include/linux/ieee80211.h:4349`). Since the range check is inclusive, link ID 15 passes validation. Structures such as `cfg80211_bss` size their `links[]` array with 15 entries (valid indices 0–14); an attacker-supplied link ID of 15 indexes one element past the end of the array, producing an out-of-bounds access. `CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment; without WiFi hardware, no wireless interfaces are created and the MLO link ID path is never reachable.

### CVE-2024-57899

**Status**: Not Affected
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 32-bit-specific vulnerability; Root Lock kernel is x86_64

In the mac80211 wireless stack, a type-size mismatch between `unsigned long` (4 bytes on 32-bit) and `u64` (8 bytes) causes incorrect arithmetic or storage on 32-bit architectures. On x86_64, `sizeof(unsigned long) == sizeof(u64) == 8`; the size mismatch condition cannot arise. `CONFIG_X86_64=y` in the HS 5.19.6 configuration; additionally, no WiFi hardware is present on a server deployment.

### CVE-2025-21863

**Status**: Affected on 5.19.6; Not Affected on derived 6.18
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux ≤ 6.13-rc6
**Upstream fix**: commit 838154be1ea7 ("io_uring: sanitise sqe->opcode against speculations")

**What this means for an attacker:**

In `io_uring/io_uring.c`, `io_init_req()` reads `sqe->opcode` from userspace and checks it against `IORING_OP_LAST` at line 8385. Without a Spectre v1 barrier, the CPU's speculative execution engine can index into `io_op_defs[]` at line 8389 before the bounds-check branch resolves, enabling a microarchitectural side-channel read of kernel memory at speculative offsets. The upstream fix inserts `array_index_nospec(opcode, IORING_OP_LAST)` before the array access.

**Why the score is not 0.0:**

`CONFIG_IO_URING=y` is compiled in on 5.19.6, which falls within the affected range. Derived 6.18 does not compile `CONFIG_IO_URING`; this CVE is Not Affected on that pin. On 5.19.6, reaching the vulnerable io_uring path requires a process to submit crafted SQEs via `io_uring_enter()`; this is a normal operation for any application using io_uring. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-52930

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no Intel display GPU present

In `drivers/gpu/drm/i915/gem/i915_gem_tiling.c`, `i915_gem_object_set_tiling()` releases the gem object lock at line 308, then performs an unguarded check-and-free of `obj->bit_17` at lines 314–322. Two threads concurrently calling `I915_GEM_SET_TILING` to set tiling to `I915_TILING_NONE` can both enter the `else` branch at line 319 and both call `bitmap_free(obj->bit_17)` at line 320, producing a double-free. Conversely, two threads setting a swizzled tiling mode can both pass the `!obj->bit_17` check at line 315 and both call `bitmap_zalloc`, leaking the first allocation. `CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment; DRM device nodes are not created and the GEM ioctl path is unreachable.

### CVE-2023-52988

**Status**: Not exploitable
**Component**: Intel HDA audio driver (`CONFIG_SND_HDA_INTEL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In `sound/pci/hda/patch_via.c`, `via_auto_init_analog_input()` calls `snd_hda_get_connections()` at line 820 and stores the return value in `nums`. The function can return a negative error code. The subsequent loop at line 822 (`for (i = 0; i < nums; i++)`) is a no-op for negative `nums`, but the `conn[nums++]` write at line 832 then indexes the `conn[]` array at a negative offset, producing an out-of-bounds write. `CONFIG_SND_HDA_INTEL=y` is compiled in. No audio hardware is present on a headless server deployment; HDA codec probing never runs and the vulnerable path is never reached.

### CVE-2025-21993

**Status**: Not Affected — `CONFIG_ISCSI_IBFT` not set
**Component**: iSCSI iBFT driver (`CONFIG_ISCSI_IBFT`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ISCSI_IBFT` not compiled in Root Lock kernel

In the iSCSI Boot Firmware Table (iBFT) kernel driver, the subnet-mask field read from `/sys/firmware/ibft/ethernetX/subnet-mask` during an IPv6 iSCSI boot contains a memory safety issue. `CONFIG_ISCSI_IBFT` is not set in the HS 5.19.6 kernel configuration; the iBFT sysfs interface is absent from the compiled kernel image.

### CVE-2025-22083

**Status**: Not Affected
**Component**: vhost-SCSI driver (`CONFIG_VHOST_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_VHOST_SCSI` not compiled

In `drivers/vhost/scsi.c`, `vhost_scsi_set_endpoint()` at line 1531 does not guard against being called multiple times without an intervening `vhost_scsi_clear_endpoint()`. Duplicate invocations corrupt the `vs_tpg` pointer array and reference counts, triggering use-after-free and null-pointer conditions. `CONFIG_VHOST_SCSI` is not set in the HS 5.19.6 kernel configuration; the vhost-SCSI virtualisation driver is absent from the compiled kernel image.

### CVE-2025-22121

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux ≤ 6.13-rc3
**Upstream fix**: commit 34f96e89f84c ("ext4: fix UAF in ext4_xattr_inode_dec_ref_all()")

**What this means for an attacker:**

In `fs/ext4/xattr.c`, `ext4_xattr_inode_dec_ref_all()` at line 1127 iterates over xattr entries, calling `ext4_xattr_inode_iget()` at line 1148 to obtain each `ea_inode`. If `ext4_expand_inode_array()` at line 1154 fails, `iput(ea_inode)` at line 1158 frees the inode. When the journal restart function (`ext4_xattr_restart_fn`) subsequently runs, it can re-encounter the same entry and dereference the freed inode at line 1182 (`ext4_xattr_inode_dec_ref`), producing a use-after-free. The published vector is C:H/I:N/A:H — disclosure and crash, not direct privilege escalation.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Reaching the xattr teardown path requires a process to manipulate extended attributes on an ext4 filesystem — a standard operation available to any user with file access. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**The attacker cannot turn this UAF into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-37785

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; crafted ext4 image cannot be mounted
**Affected range**: Linux ≤ 6.14-rc4
**Upstream fix**: commit 4f45d4452e6b ("ext4: fix OOB read when mounting corrupted fs")

In `fs/ext4/dir.c`, when a corrupted ext4 directory block contains a `'.'` entry whose `rec_len` equals the filesystem block size, the iteration offset at line 246 jumps to exactly `block_size` after the first entry. During directory removal, a subsequent traversal computes a `de` pointer one block past the buffer boundary, producing an out-of-bounds read.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Triggering the out-of-bounds read requires mounting an ext4 filesystem image containing a corrupted directory block. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any ext4 directory parsing code is reached. In Lockdown, no approved program in the Root Lock allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any Root Lock deployment.

### CVE-2025-40364

**Status**: Affected on 5.19.6; Not Affected on derived 6.18
**Component**: io_uring (`CONFIG_IO_URING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux ≤ 6.14-rc5
**Upstream fix**: commit 0f2122045b94 ("io_uring: don't import buffers for async preparation")

**What this means for an attacker:**

In `io_uring/io_uring.c`, `io_req_prep_async()` at line 7829 prepares an asynchronous copy of a request's state. For requests using provided buffers (`IOSQE_BUFFER_SELECT`), the function can select and consume a buffer slot during the async preparation phase. If the ring state is then discarded before the I/O completes — for example, when the async path is abandoned and the request is retried — the buffer slot is consumed but the reference is lost, allowing the slot to be selected again by a subsequent request and producing a use-after-free of the shared buffer metadata.

**Why the score is not 0.0:**

`CONFIG_IO_URING=y` is compiled in on 5.19.6, which falls within the affected range. Derived 6.18 does not compile `CONFIG_IO_URING`; this CVE is Not Affected on that pin. On 5.19.6, reaching the provided-buffer UAF path requires a process to submit io_uring SQEs with `IOSQE_BUFFER_SELECT` in a pattern where the async preparation phase selects a buffer slot before the request is discarded. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-37738

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; crafted xattr image cannot be mounted
**Affected range**: Linux ≤ 6.13-rc3
**Upstream fix**: commit b631e432b12d ("ext4: fix xattr inode dec ref boundary")

In `fs/ext4/xattr.c`, `ext4_xattr_inode_dec_ref_all()` at line 1143 iterates xattr entries with `for (entry = first; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry))`. The loop has no upper-boundary parameter: it relies solely on the `IS_LAST_ENTRY()` zero-terminator sentinel. A corrupted xattr block without a valid terminating entry causes the loop to walk past the end of the allocated buffer, reading and dereferencing arbitrary memory.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Triggering the unbounded xattr loop requires mounting a filesystem with a corrupted xattr block that lacks the valid zero-terminator sentinel. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any ext4 xattr parsing code is reached. In Lockdown, no approved program in the Root Lock allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any Root Lock deployment.

### CVE-2022-49789

**Status**: Not Affected
**Component**: IBM Z Fibre Channel driver (`CONFIG_ZFCP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ZFCP` not compiled

In `drivers/s390/scsi/zfcp_fsf.c`, `zfcp_fsf_req_send()` stores the FSF request ID in a variable of the wrong integer type, causing the ID to be truncated on architectures where the required width exceeds that type. `CONFIG_ZFCP` is not present in the HS 5.19.6 kernel configuration; the IBM Z Fibre Channel driver is s390-architecture-specific and is absent from the x86_64 compiled kernel image.

### CVE-2022-49842

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In the ALSA sound subsystem, a use-after-free occurs in `device_del()` during driver module removal. When an ALSA driver is unloaded, a device object is freed while still referenced by a concurrent access path, producing a KASAN use-after-free report at `device_del+0xb5b` by the `rmmod` task.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-49865

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux 5.4–5.19.6
**Upstream fix**: kernel.org stable queue (net/ipv6/addrlabel.c)

**What this means for an attacker:**

In `net/ipv6/addrlabel.c`, `ip6addrlbl_putmsg()` (line 438) constructs a `struct ifaddrlblmsg` for a netlink reply. The function writes `ifal_family`, `ifal_prefixlen`, `ifal_flags`, and `ifal_seq` but never zeroes the `__ifal_reserved` padding byte. That uninitialised byte is subsequently copied to userspace via `nlmsg_unicast()`, leaking one byte of kernel stack memory per IPv6 address-label query.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Any process with access to a `NETLINK_ROUTE` socket can trigger the infoleak — no elevated privilege is required. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**The attacker cannot turn this leak into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53037

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in Root Lock kernel

When the SAS Transport Layer support is enabled and a device exposed to the OS by the driver fails INQUIRY commands, the mpi3mr driver frees the memory allocated for an internal device handle but continues to reference that handle in subsequent SCSI transport operations, causing a use-after-free.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53039

**Status**: Not Affected
**Component**: Intel ISH HID driver (`CONFIG_INTEL_ISH_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_INTEL_ISH_HID` not compiled

When a reset notify IPC message is received by the Intel Integrated Sensor Hub Transfer Protocol (ISHTP) subsystem, the ISR schedules a work item and passes the device struct via the global `ishtp_dev` pointer. A race between the reset notify path and device teardown can leave `ishtp_dev` pointing to a freed object, triggering a use-after-free.

`CONFIG_INTEL_ISH_HID` is not set in the HS 5.19.6 configuration. The Intel ISH HID driver (`drivers/hid/intel-ish-hid/`) is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53065

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist

In `kernel/events/core.c`, a stack-out-of-bounds issue discovered by syzkaller occurs in the perf events sample output path. A crafted `perf_event_open()` call with specific sample type flags causes the kernel to write beyond the bounds of a stack-allocated buffer during event sampling, overwriting adjacent stack memory.

`CONFIG_PERF_EVENTS=y` is compiled in. The Root Lock kernel sets `/proc/sys/kernel/perf_event_paranoid=3`, which restricts `perf_event_open()` to processes with `CAP_PERFMON`. No profiling tool (`perf`, `sysdig`, or equivalent) is included in the HS Lockdown allowlist — the kernel refuses to execute it. The crafted `perf_event_open()` call required to trigger the stack overflow is unreachable in a standard HS deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-37861

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in Root Lock kernel

When the task management thread processes reply queues while the reset thread simultaneously resets them, the task management thread accesses an invalid queue ID (`0xFFFF`) — a sentinel value indicating a torn-down queue — resulting in an out-of-bounds access during the concurrent reset operation.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-37979

**Status**: Not Affected — `CONFIG_SND_SOC_SC7280` not compiled
**Component**: Qualcomm sc7280 ASoC driver (`CONFIG_SND_SOC_SC7280`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SND_SOC_SC7280` not compiled in Root Lock kernel

Commit 5f78e1fb7a3e ("ASoC: qcom: Add driver support for audioreach solution") introduced switch-case values in the Qualcomm sc7280 machine driver that index into fixed-size arrays without bounds checking, causing out-of-bounds access when unexpected codec or CPU DAI link types are encountered during probe.

`CONFIG_SND_SOC_SC7280` is not set in the HS 5.19.6 configuration. This driver targets the Qualcomm sc7280 SoC, an ARM-based mobile/embedded platform. It is not selected on x86_64 server builds. The vulnerable code path does not exist on this system.

### CVE-2022-49934

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present

In `net/mac80211/scan.c`, `ieee80211_scan_rx()` accesses `scan_req->flags` after a null check. A use-after-free occurs when scan completion triggers `__ieee80211_scan_completed()`, which frees the scan request while a concurrent `ieee80211_scan_rx()` call still dereferences it.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38103

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no USB HID input devices on headless server

Update struct hid_descriptor to better reflect the mandatory and optional parts of the HID Descriptor as per USB HID 1.11 specification.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38206

**Status**: Not Affected — `CONFIG_EXFAT_FS` not compiled
**Component**: exFAT filesystem (`CONFIG_EXFAT_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_EXFAT_FS` not compiled in Root Lock kernel

In `fs/exfat/nls.c`, `exfat_load_upcase_table()` frees `sbi->vol_utbl` via `exfat_free_upcase_table()` on a checksum-mismatch error (line 706) without NULLing the pointer. If the subsequent `exfat_load_default_upcase_table()` call fails to allocate a replacement buffer, `sbi->vol_utbl` retains the stale freed pointer. A later cleanup path calling `exfat_free_upcase_table()` again frees the same allocation, causing a double free. The trigger is mounting a specially crafted exFAT volume.

`CONFIG_EXFAT_FS` is not set in the HS 5.19.6 configuration. The exFAT filesystem driver — including `fs/exfat/nls.c` — is not compiled into the kernel image. Note that `CONFIG_FAT_FS=y` (VFAT/FAT32) is compiled for EFI system partition support, but that is a separate driver with no shared code. The vulnerable code path does not exist on this system.

### CVE-2025-38239

**Status**: Not Affected — `CONFIG_MEGARAID_SAS` not set
**Component**: LSI MegaRAID SAS driver (`CONFIG_MEGARAID_SAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_MEGARAID_SAS` not compiled in Root Lock kernel

On systems with DRAM interleave enabled, the MegaRAID SAS driver miscalculates the MSI-X poll queue allocation, requesting poll queues beyond the number of available vectors. This results in an out-of-bounds access during driver initialization when the hardware exposes a specific MSI-X configuration.

`CONFIG_MEGARAID_SAS` is not set in the HS 5.19.6 configuration. The LSI/Broadcom MegaRAID SAS controller driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-38249

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In snd_usb_get_audioformat_uac3(), the length value returned from snd_usb_ctl_msg() is used directly for memory allocation without validation.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38389

**Status**: Not exploitable
**Component**: Intel i915 DRM driver (`CONFIG_DRM_I915`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no Intel display GPU present

On ring submission GPU platforms, unbinding the i915 driver during testing sporadically triggers a kernel warning. A GPU context or ring buffer entry is accessed after being freed during the driver teardown path, detected by the kernel's warning infrastructure during CI unbind tests.

`CONFIG_DRM_I915=y` is compiled in. No Intel integrated or discrete display GPU is present on this server deployment. Without display hardware, DRM device nodes may not be created and the GPU context entry points are unreachable. This follows the established pattern for i915 CVEs — see CVE-2022-4139.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38494

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no USB HID input devices on headless server

hid_hw_raw_request() is actually useful to ensure the provided buffer and length are valid.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38550

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/mcast.c

**What this means for an attacker:**

In `net/ipv6/mcast.c`, `mld_clear_delrec()` releases the `pmc->idev` reference before calling `ip6_mc_clear_src()`, but `ip6_mc_clear_src()` accesses `pmc->idev` internally. The reference drop must be deferred until after `ip6_mc_clear_src()` returns; releasing it early causes a use-after-free when `ip6_mc_clear_src()` subsequently dereferences the freed pointer.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and the IPv6 stack is active on configured interfaces. IPv6 multicast listener discovery (MLD) is reachable via network interfaces that join multicast groups — a common configuration on servers. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-38556

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no USB HID input devices on headless server

Testing by the syzbot fuzzer showed that the HID core gets a shift-out-of-bounds exception when it tries to convert a 32-bit quantity to a 0-bit quantity.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38563

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist

The perf mmap code is careful about mmap()'ing the user page with the ringbuffer and additionally the auxiliary buffer, when the event supports it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-38565

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist

When perf_mmap() fails to allocate a buffer, it still invokes the event_mapped() callback of the related event.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-38572

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/

**What this means for an attacker:**

syzbot demonstrated that a crafted IPv6 packet with excessively long chained extension headers causes `skb->transport_header` to overflow. The field is a `__u16`; when the cumulative extension header length wraps past 65535, the kernel misidentifies the transport layer offset when parsing subsequent headers, potentially accessing incorrect memory.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and the IPv6 stack processes all inbound IPv6 packets, including those with extension headers. This path is reachable from the network without requiring a local process. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to escalate further — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-38699

**Status**: Not Affected — `CONFIG_SCSI_BFA_FC` not compiled
**Component**: Brocade bfa FC driver (`CONFIG_SCSI_BFA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_BFA_FC` not compiled in Root Lock kernel

When the bfad_im_probe() function fails during initialization, the memory pointed to by bfad->im is freed without setting bfad->im to NULL.

`CONFIG_SCSI_BFA_FC` is not set in the HS 5.19.6 configuration. The Brocade bfa Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-38729

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

UAC3 power domain descriptors need to be verified with its variable bLength for avoiding the unexpected OOB accesses by malicious firmware, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39702

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/

**What this means for an attacker:**

In `net/ipv6/`, a Message Authentication Code comparison used a variable-time function rather than a constant-time one (such as `crypto_memneq()`). An attacker who can observe response timing can iteratively determine whether partial MAC bytes are correct, eventually recovering a valid MAC and bypassing authentication in IPv6 protocol handling.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. Exploiting a timing side-channel requires high network precision and repeated measurements (AC:H), which significantly reduces practical exploitability. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to follow up on a bypassed MAC check — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2025-39757

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

UAC3 class segment descriptors need to be verified whether their sizes match with the declared lengths and whether they fit with the allocated buffer sizes, too.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39760

**Status**: Not exploitable
**Component**: USB core (`CONFIG_USB`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no USB device on headless HS server; descriptor parsing path unreachable

usb_parse_ss_endpoint_companion() checks descriptor type before length, enabling a potentially odd read outside of the buffer size.

`CONFIG_USB=y` is compiled in and 5.19.6 falls within the affected range. The `usb_parse_ss_endpoint_companion()` descriptor parsing path is triggered during USB device enumeration when a device is connected. Root Lock runs on headless server hardware with no external USB devices; no USB device enumeration occurs, so the vulnerable descriptor parsing code path is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-39788

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — UFS flash storage absent on x86 server

On Google gs101, the number of UTP transfer request slots (nutrs) is 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE incorrectly as 0.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is used in mobile and embedded platforms. This bug is in the Samsung Exynos UFS variant (`ufs-exynos`). A Debian 11 x86 server has no UFS hardware; the driver is never active.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50306

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; `do_mount()` returns EPERM

**Affected range**: Linux 5.10+; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/fast_commit.c

In `fs/ext4/fast_commit.c`, the fast commit replay scan loop reads the tag-length header (`struct ext4_fc_tl`, 4 bytes) before verifying that at least 4 bytes remain in the replay buffer. Mounting a filesystem whose fast commit area has been truncated or crafted to place fewer than 4 bytes at the tail causes an out-of-bounds read when parsing the next tag.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. The vulnerable path runs during the fast commit replay scan triggered on mount of a filesystem whose fast commit area has a malformed tag-length header. On a Root Lock system, `sys_hs_lockdown_hs()` blocks all mount paths at `kernel/namespace.c:4218, 4300, 4453`; `do_mount()` returns EPERM before any filesystem setup begins. No approved process in the Root Lock allowlist carries a `mount` allowlist entry, and unapproved programs are refused execution by the kernel's SPF gate regardless of file ownership or privilege. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-53257

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present

Before checking the action code, check that it even exists in the frame.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53282

**Status**: Not Affected — `CONFIG_SCSI_LPFC` not compiled
**Component**: Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_LPFC` not compiled in Root Lock kernel

In `drivers/scsi/lpfc/`, `lpfc_wr_object()` performs a use-after-free read during the sysfs firmware write process. KFENCE detects that a firmware object buffer is read after being freed during the firmware update write sequence.

`CONFIG_SCSI_LPFC` is not set in the HS 5.19.6 configuration. The Emulex lpfc Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53285

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — direct block device write requires CAP_SYS_RAWIO; no raw-device write tool in Root Lock allowlist

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/inode.c

ext4 validates `i_extra_isize` when an inode is first loaded into memory (`fs/ext4/inode.c:4794`), confirming that the extra space falls within the inode's allocated size. If an attacker writes directly to the block device while the filesystem is mounted, the raw on-disk inode can be modified so that `i_extra_isize` exceeds the previously verified bound. Subsequent access to in-inode extended attributes computes the xattr magic pointer as `EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize` without re-validating the updated value, allowing a read or write beyond the end of the inode body.

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. Exploiting this bug requires writing directly to the block device while the filesystem is mounted — an operation that requires root or `CAP_SYS_RAWIO` and a tool that issues raw writes to the block device (e.g., `dd`, `badblocks`, or a custom exploit program). On a Root Lock system, no approved process in the Root Lock allowlist writes raw block device data; the SPF allowlist blocks execution of any unapproved program at the kernel gate before the block device can be reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2023-53320

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in Root Lock kernel

In the mpi3mr driver, `mpi3mr_get_all_tgt_info()` has multiple issues in its device map handling: the function miscalculates the valid entry length in `alltgt_info` by incorrectly sizing the `struct mpi3mr_device_map_info` header, leading to out-of-bounds reads when iterating target device entries.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53321

**Status**: Not exploitable
**Component**: mac80211 wireless stack (`CONFIG_MAC80211`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present

In `net/mac80211/`, control frames such as ACK frames that legally omit Address 2 and Address 3 are forwarded through `wmediumd` or similar userspace interfaces. The mac80211 frame parser does not enforce the full 3-address format before forwarding, potentially causing out-of-bounds reads in userspace frame consumers that assume the standard frame layout.

`CONFIG_MAC80211=y` is compiled in. No WiFi network interface card is present on a server deployment. Without WiFi hardware, mac80211 creates no wireless interfaces and the relevant code paths are never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53322

**Status**: Not Affected — `CONFIG_SCSI_QLA_FC` not compiled
**Component**: QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_QLA_FC` not compiled in Root Lock kernel

System crash due to use after free. Current code allows terminate_rport_io to exit before making sure all IOs has returned.

`CONFIG_SCSI_QLA_FC` is not set in the HS 5.19.6 configuration. The QLogic qla2xxx Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50378

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Amlogic Meson ARM SoC GPU absent

In `drivers/gpu/drm/meson/`, unloading the Amlogic Meson display driver triggers a KASAN use-after-free. During driver teardown, a resource allocated during probe is accessed after the teardown path has freed it, producing a KASAN warning at module unload time.

`CONFIG_DRM=y` is compiled in. drm/meson is the display driver for Amlogic Meson SoC platforms (ARM-based embedded boards such as ODROID, Khadas, etc.). This driver and its hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53376

**Status**: Not Affected — `CONFIG_SCSI_MPI3MR` not set
**Component**: Broadcom mpi3mr SAS driver (`CONFIG_SCSI_MPI3MR`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_MPI3MR` not compiled in Root Lock kernel

To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using byte as unit.

`CONFIG_SCSI_MPI3MR` is not set in the HS 5.19.6 configuration. The Broadcom mpi3mr SAS 3.0 HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53392

**Status**: Not exploitable
**Component**: HID subsystem (`CONFIG_HID`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no USB HID input devices on headless server

In the Intel ISHTP HID driver, during a warm reset `device->fw_client` is set to NULL. If a bus driver is registered after this NULL assignment but before ISHTP completes re-enumeration of firmware clients, the driver dereferences the NULL `fw_client` pointer, triggering a kernel panic.

`CONFIG_HID=y` is compiled in. No USB human interface devices (keyboard, mouse, or other HID peripherals) are connected to a headless production server. HID device paths are never instantiated, making this code path unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39841

**Status**: Not Affected — `CONFIG_SCSI_LPFC` not compiled
**Component**: Emulex lpfc FC driver (`CONFIG_SCSI_LPFC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_LPFC` not compiled in Root Lock kernel

Fix a use-after-free window by correcting the buffer release sequence in the deferred receive path.

`CONFIG_SCSI_LPFC` is not set in the HS 5.19.6 configuration. The Emulex lpfc Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-39864

**Status**: Not exploitable
**Component**: cfg80211 wireless framework (`CONFIG_CFG80211`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no WiFi NIC present

In `net/wireless/scan.c`, `cfg80211_update_known_bss()` frees the last beacon frame of a BSS entry under conditions related to hidden SSID tracking (commit 776b3580178f). A race condition allows this beacon frame to be freed while still referenced by another code path, causing a use-after-free.

`CONFIG_CFG80211=y` is compiled in. No WiFi network interface card is present on a server deployment. cfg80211 manages wireless interfaces; without hardware, no interface is created and the affected code paths are unreachable.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-39866

**Status**: Affected
**Component**: VFS writeback subsystem
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/fs-writeback.c

**What this means for an attacker:**

In `fs/fs-writeback.c`, `__mark_inode_dirty()` acquires a reference to a `bdi_writeback` structure. A concurrent `bdi_writeback_switch()` can free the structure before the reference is dropped, resulting in a use-after-free when the writeback pointer is subsequently accessed.

**Why the score is not 0.0:**

`fs/fs-writeback.c` is always compiled in on a system with block device support. The writeback subsystem is active for all block I/O on any mounted filesystem. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-50422

**Status**: Not Affected — `CONFIG_SCSI_SAS_LIBSAS` not set
**Component**: SAS libsas library (`CONFIG_SCSI_SAS_LIBSAS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_SAS_LIBSAS` not compiled in Root Lock kernel

When executing SMP task failed, the smp_execute_task_sg() calls del_timer() to delete "slow_task->timer".

`CONFIG_SCSI_SAS_LIBSAS` is not set in the HS 5.19.6 configuration. The SAS libsas library — used by SAS host bus adapter drivers — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50432

**Status**: Affected
**Component**: kernfs subsystem (`CONFIG_KERNFS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/kernfs/dir.c

**What this means for an attacker:**

Syzkaller triggered concurrent calls to `kernfs_remove_by_name_ns()` for the same kernfs node, resulting in a KASAN-detected use-after-free in `fs/kernfs/dir.c`. The race occurs because `kernfs_remove_by_name_ns()` does not prevent concurrent removals of the same node from two threads.

**Why the score is not 0.0:**

`CONFIG_KERNFS=y` is compiled in and 5.19.6 falls within the affected range. kernfs underpins sysfs and is active on every running Linux system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53473

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/hash.c

**What this means for an attacker:**

In `fs/ext4/hash.c`, `__ext4fs_dirhash()` returns `-1` in two cases: when a directory uses the `DX_HASH_SIPHASH` algorithm but the inode lacks an encryption key (line 271: "Siphash requires key"), and on an unknown hash version (line 280). Callers of `ext4fs_dirhash()` did not consistently check for this error and proceeded with a stale or zero `hinfo->hash`, potentially corrupting hash-tree directory lookups or writes.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server and directory lookups occur during normal operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53510

**Status**: Not exploitable
**Component**: SCSI subsystem (`CONFIG_SCSI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — UFS flash storage absent on x86 server

ufshcd_queuecommand() may be called two times in a row for a SCSI command before it is completed.

`CONFIG_SCSI=y` is compiled in. UFS (Universal Flash Storage) is mobile/embedded storage. The `ufshcd` core driver is compiled in but never instantiated on an x86 server; no UFS host controller hardware is present.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53521

**Status**: Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set
**Component**: SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ENCLOSURE_SERVICES` not compiled in Root Lock kernel

In `drivers/scsi/ses.c`, `ses_intf_remove()` performs an out-of-bounds slab read when removing a SCSI Enclosure Services device. At `ses_intf_remove+0x23f`, a buffer access reads beyond its allocated boundary, as reported by KASAN during module removal by the `rmmod` task.

`CONFIG_ENCLOSURE_SERVICES` is not set in the HS 5.19.6 configuration. The SCSI Enclosure Services driver (ses) — and its dependence on SAS HBA infrastructure — is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50488

**Status**: Not Affected
**Component**: BFQ I/O scheduler (`CONFIG_IOSCHED_BFQ`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_IOSCHED_BFQ` not compiled in Root Lock kernel

In `block/bfq-iosched.c`, a use-after-free occurs in `bfq_select_queue()` involving `bfqq->bic`. A BFQ I/O queue object is freed while a reference to its `bic` (BFQ I/O context) is still live, leading to a use-after-free when `bfq_select_queue()` subsequently accesses the freed `bfqq` pointer.

`CONFIG_IOSCHED_BFQ` is not set in the HS 5.19.6 configuration. The BFQ (Budget Fair Queueing) block I/O scheduler is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2022-50496

**Status**: Affected
**Component**: device mapper (`CONFIG_BLK_DEV_DM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/md/dm-cache-target.c

**What this means for an attacker:**

In `drivers/md/dm-cache-target.c`, `cache_resume()` (line 2971) calls `allow_background_work()`, which schedules work on `cache->wq`. If `cache_dtr()` runs concurrently, `destroy()` (line 1881) frees `cache->wq` at line 1891 while those work items are still active, resulting in a use-after-free.

**Why the score is not 0.0:**

`CONFIG_BLK_DEV_DM=y` is compiled in and device mapper is used for LVM on a standard Debian 11 installation. Triggering this race requires concurrent resume and destroy operations on a device mapper target. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to set up this race — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2022-50546

**Status**: Affected
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/ext4/inode.c

**What this means for an attacker:**

In `ext4_evict_inode()` (`fs/ext4/inode.c:180`), the function checks `EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL` to determine whether the inode being evicted is an extended attribute inode. Under certain error paths during inode allocation, the ext4-specific `i_flags` field in `ext4_inode_info` is not fully initialized before the inode reaches eviction, causing the flag test to read from uninitialized memory. KMSAN reported the uninitialized-value access at this check.

**Why the score is not 0.0:**

`CONFIG_EXT4_FS=y` is compiled in and 5.19.6 falls within the affected range. ext4 is the primary filesystem on a Debian 11 server and inode eviction occurs during normal filesystem operation. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-53640

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In the ALSA sound subsystem, `regcache_flat_read()` performs a slab-out-of-bounds read. syzkaller reproduced a KASAN report showing an out-of-bounds read in the flat register cache read path, triggered through the ALSA register map interface.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-53675

**Status**: Not Affected — `CONFIG_ENCLOSURE_SERVICES` not set
**Component**: SCSI Enclosure Services (`CONFIG_ENCLOSURE_SERVICES`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ENCLOSURE_SERVICES` not compiled in Root Lock kernel

Sanitize possible desc_ptr out-of-bounds accesses in ses_enclosure_data_process().

`CONFIG_ENCLOSURE_SERVICES` is not set in the HS 5.19.6 configuration. The SCSI Enclosure Services driver (ses) is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2023-53676

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in Root Lock kernel

In `drivers/target/iscsi/`, `lio_target_nacl_info_show()` uses `sprintf()` in a loop to print details for every iSCSI connection in a session without checking that the output buffer has sufficient remaining space, leading to a buffer overflow when a session contains many connections.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-71075

**Status**: Not Affected — `CONFIG_SCSI_AIC94XX` not set
**Component**: Adaptec aic94xx SAS driver (`CONFIG_SCSI_AIC94XX`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_AIC94XX` not compiled in Root Lock kernel

The asd_pci_remove() function fails to synchronize with pending tasklets before freeing the asd_ha structure, leading to a potential use-after-free vulnerability.

`CONFIG_SCSI_AIC94XX` is not set in the HS 5.19.6 configuration. The Adaptec aic94xx SAS HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23076

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In the ALSA ctxfi audio driver's mixer handling code, the `conf` field is used as a loop index and referenced in the index callbacks `amixer_index()` and `sum_index()`. Without a bounds check on `conf`, these callbacks can access mixer entries outside the allocated range, leading to an out-of-bounds read.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23078

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

The scarlett2_usb_get_config() function has a logic error in the endianness conversion code that can cause buffer overflows when count > 1.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23089

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

When snd_usb_create_mixer() fails, snd_usb_mixer_free() frees mixer->id_elems but the controls already added to the card still reference the freed memory.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23191

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

The PCM trigger callback of aloop driver tries to check the PCM state and stop the stream of the tied substream in the corresponding cable.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23193

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 8.8 HIGH (AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in Root Lock kernel

In iscsit_dec_session_usage_count(), the function calls complete() while holding the sess->session_usage_lock.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23208

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In this case, the user constructed the parameters with maxpacksize 40 for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-23216

**Status**: Not Affected — `CONFIG_ISCSI_TARGET` not compiled
**Component**: Linux iSCSI target (`CONFIG_ISCSI_TARGET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_ISCSI_TARGET` not compiled in Root Lock kernel

In iscsit_dec_conn_usage_count(), the function calls complete() while holding the conn->conn_usage_lock.

`CONFIG_ISCSI_TARGET` is not set in the HS 5.19.6 configuration. The Linux iSCSI target (`drivers/target/iscsi/`) subsystem is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2025-71238

**Status**: Not Affected — `CONFIG_SCSI_QLA_FC` not compiled
**Component**: QLogic qla2xxx FC driver (`CONFIG_SCSI_QLA_FC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_SCSI_QLA_FC` not compiled in Root Lock kernel

In `drivers/scsi/qla2xxx/`, the QLogic Fibre Channel HBA driver writes to an invalid kernel address during a specific error recovery path, triggering a page fault with a supervisor write access error. The invalid address indicates a use-after-free or uninitialized pointer dereference within the driver's interrupt or completion handling.

`CONFIG_SCSI_QLA_FC` is not set in the HS 5.19.6 configuration. The QLogic qla2xxx Fibre Channel HBA driver is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2026-23318

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

The entry of the validators table for UAC3 AC header descriptor is defined with the wrong protocol version UAC_VERSION_2, while it should have been UAC_VERSION_3.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-31581

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

In usb6fire_chip_abort(), the chip struct is allocated as the card's private data (via snd_card_new with sizeof(struct sfire_chip)).

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2023-3268

**Status**: Not exploitable
**Component**: relay filesystem (`CONFIG_RELAY`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — debugfs relay access not in Root Lock allowlist; Lockdown blocks the exploitation trigger

An out of bounds (OOB) memory access flaw was found in the Linux kernel in relay_file_read_start_pos in kernel/relay.c in the relayfs.

`CONFIG_RELAY=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and read access to relay channel files under debugfs — paths used exclusively by kernel tracing tools (SystemTap, etc.) that have no place in a production server allowlist. Without an allowlist entry covering debugfs relay access, the kernel refuses it. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2023-3567

**Status**: Affected
**Component**: virtual terminal (VT) (`CONFIG_VT`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 7.1 HIGH — base I:N; Lockdown limits post-exploitation persistence
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/tty/vt/vc_screen.c

**What this means for an attacker:**

In `drivers/tty/vt/vc_screen.c`, `vcs_read()` accesses virtual console screen data through a `vc_screen` reference without holding appropriate locks for the full duration of the read. A concurrent write or deallocation of the virtual console can free the underlying `vc_screen` structure while `vcs_read()` is still referencing it, causing a use-after-free. The published vector is C:H/I:N/A:H — disclosure and crash, not direct privilege escalation.

**Why the score is not 0.0:**

`CONFIG_VT=y` is compiled in and 5.19.6 falls within the affected range. Reading `/dev/vcs*` virtual console screen devices requires membership in the `tty` group on Debian. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. Executing a non-allowlisted program requires an allowlist entry; an attacker cannot reach this code path without one.

**What this means for you as an HS user:**

**The attacker cannot turn this UAF into anything that runs new code.** Even if a follow-on memory-corruption bug is chained in to escalate to root, Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-6531

**Status**: Affected
**Component**: Unix domain sockets (`CONFIG_UNIX`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 6.5 MEDIUM — Lockdown reduces MI: High→Low; AC:H reduces exploitability (Exp=1.05 vs 1.83 for AC:L)
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/unix/garbage.c

**What this means for an attacker:**

In `net/unix/garbage.c`, the Unix socket garbage collector frees orphaned socket buffers (SKBs) without coordinating with concurrent `unix_stream_read_generic()` operations on the socket those SKBs are queued on. The race allows `unix_stream_read_generic()` to access an SKB that the garbage collector has already freed, causing a use-after-free. AC:H reflects that exploitation requires precise timing between the GC sweep and a concurrent stream read.

**Why the score is not 0.0:**

`CONFIG_UNIX=y` is compiled in and 5.19.6 falls within the affected range. Unix domain sockets are used by virtually all inter-process communication on a Debian 11 server (systemd, D-Bus, logging daemons). The narrow race window (AC:H) makes reliable exploitation difficult. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a standalone race-exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2023-51043

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no DRM/GPU device on headless server; `drm_atomic` requires GPU mode-setting

In the Linux kernel before 6.4.5, drivers/gpu/drm/drm_atomic.c has a use-after-free during a race condition between a nonblocking atomic commit and a driver unload.

`CONFIG_DRM=y` is compiled in and 5.19.6 falls within the affected range. The `drm_atomic` race condition requires a process to initiate GPU mode-setting operations — specifically a nonblocking atomic commit — concurrent with driver unload. Root Lock runs on headless server hardware with no display GPU; the DRM device nodes are absent, so no mode-setting operation can be initiated. No GPU or display tool appears in the Root Lock allowlist. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-0841

**Status**: Not exploitable
**Component**: hugetlbfs (`CONFIG_HUGETLBFS`)
**Base Score**: 6.6 MEDIUM (AV:L/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:H)
**Score on Root Lock**: 0.0 — mount() blocked by Lockdown; hugetlbfs mount path unreachable
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: fs/hugetlbfs/inode.c

In `fs/hugetlbfs/inode.c`, `hugetlbfs_fill_super()` initialises the hugetlbfs superblock for a `mount(2)` call. Under certain error conditions during setup — for instance, when huge page pool allocation fails — the function dereferences a pointer that was not initialised, causing a null pointer dereference. The crash is reachable by any local user with `CAP_SYS_ADMIN` permission to mount hugetlbfs.

`CONFIG_HUGETLBFS=y` is compiled in and 5.19.6 falls within the affected range. Triggering `hugetlbfs_fill_super()` requires calling `mount(2)` with `hugetlbfs` as the filesystem type, which additionally requires `CAP_SYS_ADMIN` on Debian 11. `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, blocking all mount paths at `kernel/namespace.c:4218, 4300, 4453` with EPERM; `do_mount()` returns `EPERM` before any hugetlbfs setup begins. In Lockdown, no approved program in the Root Lock allowlist carries a `mount` entry — the kernel SPF gate enforces this independently of Lockdown. The trigger cannot be reached on any Root Lock deployment.

### CVE-2024-26593

**Status**: Not exploitable
**Component**: Intel SMBus I2C controller (`CONFIG_I2C_I801`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — no I2C/SMBus tool in Root Lock allowlist; Lockdown blocks access

In `drivers/i2c/busses/i2c-i801.c`, the Intel I801 SMBus driver handles block process call transactions incorrectly. Intel datasheets specify that the block buffer index must be reset twice: once before writing the outgoing data to the buffer, and once before reading the incoming response. The driver resets the index only once, causing the response to be read from the wrong buffer position and potentially returning incorrect data to callers.

`CONFIG_I2C_I801=y` is compiled in and 5.19.6 falls within the affected range. The Intel I2C SMBus controller is present on Intel-based servers for BMC, temperature sensor, and management bus communication. Accessing it requires root or `i2c` group membership and an i2c-tools or lm-sensors program — no such tool appears in the Root Lock allowlist. On a Root Lock system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the I2C device interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-38586

**Status**: Affected
**Component**: Realtek r8169 Ethernet driver (`CONFIG_R8169`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/net/ethernet/realtek/r8169_main.c

**What this means for an attacker:**

In `drivers/net/ethernet/realtek/r8169_main.c`, transmitting small fragmented scatter-gather packets on an RTL8125b NIC causes the driver to populate TX ring buffer descriptors with invalid state. The NIC subsequently processes the malformed descriptors, leading to incorrect DMA operations that can corrupt memory.

**Why the score is not 0.0:**

`CONFIG_R8169=y` is compiled in and 5.19.6 falls within the affected range. The r8169 driver is active on systems with a Realtek NIC and handles all network TX traffic; the faulty path is reachable through normal network operation on affected hardware. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to trigger this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-38630

**Status**: Not exploitable
**Component**: watchdog timer subsystem (`CONFIG_WATCHDOG`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no watchdog daemon in Root Lock allowlist; Lockdown blocks `/dev/watchdog` access

When the cpu5wdt module is removing, the origin code uses del_timer() to de-activate the timer.

`CONFIG_WATCHDOG=y` is compiled in and 5.19.6 falls within the affected range. The cpu5wdt driver targets a PC-era ISA watchdog timer; this hardware is absent on any modern HS server deployment. Even on configurations where the hardware exists, the trigger requires a process to open and interact with `/dev/watchdog` — no watchdog daemon appears in the Root Lock allowlist. On a Root Lock system in Lockdown, the kernel blocks any process without an allowlist entry from executing, so a standalone exploit tool cannot reach the cpu5wdt interface. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-34777

**Status**: Not Affected — `CONFIG_DMA_MAP_BENCHMARK` not compiled
**Component**: DMA map benchmark (`CONFIG_DMA_MAP_BENCHMARK`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_DMA_MAP_BENCHMARK` not compiled in Root Lock kernel

In `kernel/dma/map_benchmark.c`, `map_benchmark_ioctl()` passes the user-supplied NUMA node ID directly to `node_possible()` (line 211) without first verifying that it falls within `[0, MAX_NUMNODES-1]`. `node_possible()` uses the node ID as a bitmap index; an out-of-range value causes an out-of-bounds read in the `node_possible_map` bitmap.

`CONFIG_DMA_MAP_BENCHMARK` is not set in the HS 5.19.6 configuration. The DMA mapping benchmark module is a debug/testing facility accessible via `/sys/kernel/debug/dma_map_benchmark`; it is not compiled into the kernel image. The vulnerable code path does not exist on this system.

### CVE-2024-39463

**Status**: Not exploitable
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `mount()` blocked by Lockdown; no 9P filesystem reachable on Root Lock deployments

In `fs/9p/`, a use-after-free occurs on a dentry's `d_fsdata` fid list when one thread looks up a fid through the dentry while another thread concurrently unlinks it. The unlinking thread frees the fid while the lookup thread still holds a reference, causing the lookup to dereference freed memory.

`CONFIG_9P_FS=y` is compiled in. Triggering the bug requires mounting a 9P filesystem. Lockdown categorically blocks `mount()` — `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, after which all mount paths return `EPERM`. No Root Lock deployment has a 9P filesystem mounted before Lockdown engages at boot. The trigger cannot be reached.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2024-40956

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Intel IAX/DSA accelerator hardware absent

Use list_for_each_entry_safe() to allow iterating through the list and deleting the entry in the iteration process.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd is the driver for Intel Data Streaming Accelerator (DSA) and Intelligence Analytics Accelerator (IAX), available in Intel Sapphire Rapids and later server CPUs. These accelerators require specific Intel hardware not present on a standard Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-48867

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Intel IAX/DSA accelerator hardware absent

In `drivers/dma/idxd/`, when the Intel Data Streaming Accelerator driver is unloaded, `idxd_dmaengine_drv_remove()` frees the interrupt handler while descriptor completions are still pending. Completion callbacks that fire after interrupt teardown dereference the freed interrupt state, causing a use-after-free.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's Data Streaming Accelerator hardware, present only in Intel Sapphire Rapids (and later) server CPUs. This hardware is not present on a standard Debian 11 deployment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-46759

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — ADC128D818 I2C ADC chip absent

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large negative number such as -9223372036854775808 is provided by the user.

`CONFIG_HWMON=y` is compiled in. adc128d818 drives the Texas Instruments ADC128D818 — a specific 8-channel I2C ADC chip used on some custom boards. This chip is not part of standard server hardware; the hwmon driver is never bound.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-49860

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — malformed ACPI _STR firmware absent; standard OEM server firmware returns Buffer objects as specified
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/acpi/device_sysfs.c

In the ACPI subsystem, the `_STR` ACPI method must return a buffer object containing a Unicode description string. `description_show()`, exposed via sysfs at `/sys/bus/acpi/devices/*/description`, calls the `_STR` method and dereferences the result without validating that the returned object is in fact a buffer. A crafted or malformed ACPI table that returns an integer, package, or other non-buffer object from `_STR` causes `description_show()` to access invalid memory.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. ACPI tables are loaded from OEM firmware at boot and are read-only thereafter — no userspace process can modify them without firmware-level access outside the HS adversary model. Standard OEM server firmware conforms to the ACPI specification and returns a Buffer object from `_STR`. On a Root Lock server deployment, no malformed `_STR` firmware is present; the invalid-memory path in `description_show()` is never reached. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-49029

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — IBM Power Management Extension hardware absent

In `drivers/hwmon/ibmpex.c`, `ibmpex_register_bmc()` at line 509 adds a BMC device entry to the global list but does not remove it from the list on the error path. If registration fails partway through, `&data->list` remains linked while the containing `data` struct is freed, leading to a use-after-free when the list is subsequently traversed.

`CONFIG_HWMON=y` is compiled in. ibmpex drives the IBM Power Management Extension, specific to IBM Power Systems server hardware. This is not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-50127

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In `net/sched/sch_taprio.c`, `taprio_change()` holds the `admin` schedule pointer while a concurrent `advance_sched()` call can switch or remove the schedule, making `admin` a dangling pointer. The critical section protected by `q->current_entry_lock` does not prevent this race, allowing access to freed schedule memory.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-50131

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — tracefs not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In the kernel tracing subsystem, `strlen()` returns the string length excluding the null terminator. If the string length equals the maximum buffer length, the buffer has no remaining space for the null byte, and the subsequent null terminator write goes one byte past the end of the buffer — a classic off-by-one overflow.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No Root Lock deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-53057

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In qdisc_tree_reduce_backlog, Qdiscs with major handle ffff: are assumed to be either root or ingress.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-56606

**Status**: Not exploitable
**Component**: AF_PACKET sockets (`CONFIG_PACKET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CAP_NET_RAW` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

After sock_init_data() the allocated sk object is attached to the provided sock object.

`CONFIG_PACKET=y` is compiled in. Creating an AF_PACKET raw socket requires `CAP_NET_RAW`. No Root Lock deployment grants `CAP_NET_RAW` to any service — packet capture tools such as `tcpdump` have no allowlist entry. Without an allowlist entry, the kernel refuses to execute them. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-21692

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

Haowei Yan <g1042620637@gmail.com> found that ets_class_from_arg() can index an Out-Of-Bound class in ets_class_from_arg() when passed clid of 0.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49799

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — tracefs not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In `kernel/trace/`, `register_synth_event()` calls `trace_remove_event_call()` and `unregister_trace_event()` on the error path when `set_synth_event_print_fmt()` fails. Calling both functions causes the trace event to be unregistered twice, resulting in a double-free of the trace event structure.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No Root Lock deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49892

**Status**: Not exploitable
**Component**: ftrace / function tracer (`CONFIG_FTRACE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — tracefs not in Root Lock allowlist; Lockdown blocks the exploitation trigger

KASAN reported a use-after-free with ftrace ops [1]. It was found from vmcore that perf had registered two ops with the same content successively, both dynamic.

`CONFIG_FTRACE=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and write access to ftrace control files under `/sys/kernel/tracing/`. No Root Lock deployment permits any service to access these paths. Without an allowlist entry covering the ftrace interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2022-49921

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

We can't use "skb" again after passing it to qdisc_enqueue(). This is basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb len before calling child enqueue").

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2023-53111

**Status**: Not exploitable
**Component**: loop block device (`CONFIG_BLK_DEV_LOOP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `/dev/loop*` access not in Root Lock allowlist; Lockdown blocks the exploitation trigger

do_req_filebacked() calls blk_mq_complete_request() synchronously or asynchronously when using asynchronous I/O unless memory allocation fails.

`CONFIG_BLK_DEV_LOOP=y` is compiled in. Triggering the bug requires `ioctl` operations on `/dev/loop*` with `CAP_SYS_ADMIN`. No Root Lock production workload uses loop devices — they are absent from the Lockdown allowlist. Without an allowlist entry, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37879

**Status**: Not exploitable
**Component**: Plan 9 filesystem (9P) (`CONFIG_9P_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `mount()` blocked by Lockdown; no 9P filesystem reachable on Root Lock deployments

In `net/9p/client.c`, `p9_client_write()` and `p9_client_read_once()` do not validate the count returned by the 9P server. If a misbehaving server replies with success but a negative byte count, the client treats the negative value as a large unsigned integer, potentially causing integer underflow or incorrect buffer offset calculations.

`CONFIG_9P_FS=y` is compiled in. Triggering the bug requires mounting a 9P filesystem. Lockdown categorically blocks `mount()` — `sys_hs_lockdown_hs()` sets `HS_lockdown_state = 7`, after which all mount paths return `EPERM`. No Root Lock deployment has a 9P filesystem mounted before Lockdown engages at boot. The trigger cannot be reached.

The vulnerable path never opens. The bug exists in the source — not on this system.

### CVE-2025-37914

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37915

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

As described in Gerrard's report [1], there are use cases where a netem child qdisc will make the parent qdisc's enqueue callback reentrant.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-37923

**Status**: Not exploitable
**Component**: kernel tracing (`CONFIG_TRACING`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — tracefs not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In `kernel/trace/trace.c`, `trace_seq_to_buffer()` at line 1830 performs a slab-out-of-bounds write. syzbot reproduced a KASAN report showing that a trace sequence buffer copy operation writes beyond the allocated slab boundary, reachable through the kernel tracing filesystem interface under `CAP_SYS_ADMIN`.

`CONFIG_TRACING=y` is compiled in. Triggering the bug requires `CAP_SYS_ADMIN` and active access to the kernel tracing filesystem at `/sys/kernel/tracing/`. No Root Lock deployment permits any service to write to these paths. Without an allowlist entry covering the tracing interface, the kernel refuses access. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2025-38369

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Intel IAX/DSA accelerator hardware absent

Running IDXD workloads in a container with the /dev directory mounted can trigger a call trace or even a kernel panic when the parent process exits while child processes are still using IDXD portal file descriptors. The portal file descriptor cleanup races with process exit, causing a use-after-free when the freed descriptor object is subsequently accessed.

`CONFIG_DMA_ENGINE=y` is compiled in. idxd drives Intel's on-chip Data Streaming and Analytics Accelerator hardware. This requires specific Intel Sapphire Rapids or later CPU hardware not present on a standard server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2025-38548

**Status**: Not exploitable
**Component**: hardware monitoring subsystem (`CONFIG_HWMON`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Corsair Commander Pro hardware absent

Add buffer_recv_size to store the size of the received bytes. Validate buffer_recv_size in send_usb_cmd().

`CONFIG_HWMON=y` is compiled in. corsair-cpro drives the Corsair Commander Pro — a desktop PC fan/cooler controller connected via USB HID. This device is not present in a production server environment.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50320

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — FPDT crash requires malformed firmware; not reachable on standard OEM hardware
**Affected range**: Linux 5.x–5.19 (fix adds address validation before acpi_os_map_memory call)
**Upstream fix**: drivers/acpi/acpi_fpdt.c (validate subtable->address before mapping)

In `drivers/acpi/acpi_fpdt.c`, `acpi_init_fpdt()` (line 253) passes FPDT subtable addresses from firmware-supplied ACPI tables directly to `acpi_os_map_memory()` without validating that the address falls within the physical memory range. On systems with buggy firmware (the Packard Bell Dot SC, Intel Atom N2600 being the reported case), FPDT entries contain addresses with high bits set outside the valid physical range. `acpi_os_map_memory()` then attempts to map non-existent memory, crashing the kernel. Any firmware that supplies a malformed FPDT triggers the same path.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. FPDT parsing runs at `fs_initcall` priority — early boot, before any user-space process is running. Triggering the invalid-address crash requires malformed FPDT entries in the system's ACPI firmware; HeartSuite deployments use standard OEM server firmware that conforms to the ACPI specification. Injecting a crafted ACPI table requires physical or firmware-level access, which is outside the HS software-based adversary model. An adversary with firmware access has already bypassed the OS security boundary; the ACPI parsing path is therefore not a reachable software attack surface on any standard HS deployment.

### CVE-2023-53395

**Status**: Not exploitable
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — AML exploit requires crafted firmware; ACPI tables read-only after boot on standard servers
**Affected range**: Linux 5.x through affected ACPICA version
**Upstream fix**: ACPICA commit 90310989a079 (drivers/acpi/acpica/acopcode.h)

In the ACPICA AML interpreter, the opcode table entries for the AML `Timer` instruction (`ARGP_TIMER_OP`, `ARGI_TIMER_OP` in `drivers/acpi/acpica/acopcode.h`) were inconsistent with ACPI Specification section 19.6.134, which specifies that `Timer` takes no arguments. The mismatch caused the AML parser to mishandle `Timer` opcodes in certain AML bytecode sequences, potentially treating subsequent bytecode as a spurious argument and corrupting the AML interpreter walk-state.

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. AML execution runs at boot using ACPI tables supplied by the system firmware. Exploiting the walk-state corruption requires crafted AML bytecode — on a server with a reputable firmware vendor, ACPI tables are loaded from firmware storage at boot and are read-only thereafter; no userspace process can replace or modify the AML after boot without firmware-level access. This places the trigger outside the HS software-based adversary model. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2025-39869

**Status**: Not exploitable
**Component**: DMA engine framework (`CONFIG_DMA_ENGINE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — Texas Instruments eDMA hardware absent

Fix a critical memory allocation bug in edma_setup_from_hw() where queue_priority_map was allocated with insufficient memory.

`CONFIG_DMA_ENGINE=y` is compiled in. ti-edma is the DMA controller driver for Texas Instruments Keystone/OMAP/AM embedded SoC platforms. This driver and hardware are not present on an x86 Debian 11 server.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2022-50423

**Status**: Affected
**Component**: ACPI subsystem (`CONFIG_ACPI`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–5.19
**Upstream fix**: drivers/acpi/acpica/utdelete.c (reference count ordering fix)

**What this means for an attacker:**

In `drivers/acpi/acpica/utdelete.c`, `acpi_ut_remove_reference()` is called on an ACPI operand object that has already been freed by a concurrent or error-handling code path. The function reads `object->common.descriptor_type` (via `ACPI_GET_DESCRIPTOR_TYPE`, line 720) and `object->common.reference_count` (via `acpi_ut_update_object_reference`, line 740) from the already-freed memory. KASAN detects the access as a use-after-free at offset +0x3b in `acpi_ut_remove_reference()`.

**Why the score is not 0.0:**

`CONFIG_ACPI=y` is compiled in and 5.19.6 falls within the affected range. The ACPI subsystem is active from boot; triggering this use-after-free requires manipulating the ACPI reference count lifecycle via method evaluation during device enumeration or hotplug events. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot drop and execute a new exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2026-23378

**Status**: Not exploitable
**Component**: network traffic scheduler (`CONFIG_NET_SCHED`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `tc` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

Whenever an ife action replace changes the metalist, instead of replacing the old data on the metalist, the current ife code is appending the new metadata.

`CONFIG_NET_SCHED=y` is compiled in. Triggering the bug requires the `tc` utility (`iproute2`) with `CAP_NET_ADMIN` to install or modify a qdisc or filter. No Root Lock deployment includes `tc` in the Lockdown allowlist — the kernel refuses to execute it. An attacker who has already gained root cannot add it: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-36883

**Status**: Not exploitable
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — pernet race requires module loading; `kmod`'s access to `/usr/lib/modprobe.d/` denied by Lockdown file-access enforcement post-boot
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/core/net_namespace.c

In `net/core/net_namespace.c`, `net_alloc_generic()` reads `max_gen_ptrs` — the size of the generic pointers array — to determine how much memory to allocate for a new network namespace. This read occurs without holding `pernet_ops_rwsem`. `register_pernet_operations()` can increment `max_gen_ptrs` concurrently while holding the write side of that lock. The race can cause `net_alloc_generic()` to allocate an undersized array, leading to out-of-bounds access when the new namespace is subsequently populated.

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The race requires `register_pernet_operations()` to execute concurrently with `net_alloc_generic()`. `register_pernet_operations()` is invoked exclusively from module initialization (`module_init` routines), so the race cannot be triggered post-Lockdown unless a new kernel module is loaded. New module loading is blocked by **Lockdown**, not by the Linux kernel's built-in lockdown LSM: on Debian 12, `modprobe` and `insmod` are symlinks to `/usr/bin/kmod`, which is added to the allowlist by standard Setup Mode via `systemd-modules-load.service`. HeartSuite does not refuse `execve` on `kmod`; the block operates at the file-access layer — Lockdown denies `kmod` access to `/usr/lib/modprobe.d/` by default, so module loading fails at the file-read stage before any module can be loaded. There is no `HS_locked_down()` check site in the `init_module` / `finit_module` syscall path — the block is at the file-access layer, enforced by Lockdown. (If you follow the [kmod hardening procedure](../maintenance/kmod-hardening/), kmod's module-path access records are explicitly scoped to permitted paths, hardening against configuration drift.) After Lockdown engages at boot, all statically-linked pernet operations have already registered and `max_gen_ptrs` is stable; no concurrent write is possible. Separately, creating a network namespace requires `CAP_NET_ADMIN` with user namespaces disabled on the Root Lock kernel; no unprivileged process can initiate the namespace-creation side of the race. The race condition cannot be triggered on any Root Lock deployment where `kmod` does not have file-access permissions to `/usr/lib/modprobe.d/`.

### CVE-2024-36971

**Status**: Affected
**Component**: TCP/IP destination cache (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: 5.19.6 falls within the affected range
**Upstream fix**: net/core/dst.c — RCU locking in `__dst_negative_advice()`

**What this means for an attacker:**

This CVE was actively exploited in the wild (Google Threat Analysis Group, 2024). It describes a use-after-free in `net/core/dst.c`. `__dst_negative_advice()` clears `sk->dst_cache` when a cached destination entry is marked invalid — reading the entry, determining it should be dropped, then calling `sk_dst_reset()` — without proper RCU locking across this sequence. A concurrent operation can free the destination entry between the initial read and the reset, producing a use-after-free on the freed `dst` entry. The result is local privilege escalation to root; attack vector is local (AV:L), not remote.

**Why the score is not 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. `__dst_negative_advice()` is invoked whenever a cached destination becomes invalid, reachable through normal network activity or by triggering ICMP unreachable messages from a local process. There is no hardware dependency and no special configuration required to reach the code path. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot drop and execute a new exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-38577

**Status**: Affected
**Component**: RCU tasks subsystem (`CONFIG_TASKS_RCU`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: kernel/rcu/tasks.h

**What this means for an attacker:**

In `kernel/rcu/tasks.h`, `show_rcu_tasks_trace_gp_kthread()` formats diagnostic counters for the RCU tasks trace grace-period kthread into a fixed-size buffer using `sprintf()`. The function does not bound the number of characters written; if individual counter values are sufficiently large, the formatted output overflows the buffer. The sysfs interface exposing this data is readable by any local user via `/sys/kernel/rcu_tasks_kthread_status` or equivalent debugfs entries.

**Why the score is not 0.0:**

`CONFIG_TASKS_RCU=y` is compiled in and 5.19.6 falls within the affected range. RCU tasks is a core kernel synchronisation mechanism active at all times; the overflow condition requires unusually large counter values, making reliable exploitation difficult on a production system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot execute a non-allowlisted program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-40958

**Status**: Not exploitable
**Component**: network namespaces (`CONFIG_NET_NS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CLONE_NEWNET` not in Root Lock allowlist; Lockdown blocks the exploitation trigger

In the network namespace subsystem, a use-after-free occurs through a refcount underflow. syzkaller triggered a `refcount_t: addition on 0` warning at `lib/refcount.c:25`, indicating that a network namespace object's reference count reached zero while still being accessed, with a subsequent attempt to increment the freed object's refcount in `refcount_warn_saturate()`.

`CONFIG_NET_NS=y` is compiled in. Creating a network namespace requires `CLONE_NEWNET` with `CAP_NET_ADMIN`. User namespaces (which would bypass the capability requirement) are disabled on the Root Lock kernel. No Root Lock production service creates network namespaces — they are absent from the Lockdown allowlist. Without an allowlist entry, the kernel refuses access. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

### CVE-2024-41039

**Status**: Not exploitable
**Component**: ALSA sound subsystem (`CONFIG_SND`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no audio hardware present

Fix the checking that firmware file buffer is large enough for the wmfw header, to prevent overrunning the buffer.

`CONFIG_SND=y` is compiled in. No audio hardware is present on a headless Debian 11 server. The ALSA subsystem does not create `/dev/snd` device nodes without an audio card. The ioctl path that exposes this bug is never instantiated.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2024-46713

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist

Ole reported that event->mmap_mutex is strictly insufficient to serialize the AUX buffer, add a per RB mutex to fully serialize it.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-46852

**Status**: Not exploitable
**Component**: DMA-BUF shared buffer (`CONFIG_DMA_SHARED_BUFFER`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — no DRM device on headless HS server; DMA-BUF operations unreachable

Until VM_DONTEXPAND was added in commit 1c1914d6e8c6 ("dma-buf: heaps: Don't track CMA dma-buf pages under RssFile") it was possible to obtain a mapping larger than the buffer by calling `mremap()` on a DMA-BUF heap allocation. The DMA-BUF heap mmap handler did not set `VM_DONTEXPAND`, allowing the VMA to be extended beyond the original allocation size and enabling out-of-bounds access to adjacent memory.

`CONFIG_DMA_SHARED_BUFFER=y` is compiled in and 5.19.6 falls within the affected range. DMA-BUF buffer sharing requires access to a DRM or V4L2 device. Root Lock runs on headless server hardware with no GPU or video capture device; the DRM and V4L2 device nodes are absent, so the exploitation path — opening a DRM device and issuing `mmap()` on its DMA-BUF — is hardware-unreachable. No GPU or multimedia tool appears in the Root Lock allowlist. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-48950

**Status**: Not exploitable
**Component**: perf events subsystem (`CONFIG_PERF_EVENTS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `perf_event_paranoid=3` restricts `perf_event_open()`; no profiling tool in Root Lock allowlist

In `kernel/events/core.c`, `perf_pending_task()` can execute after the associated `perf_event` object has been freed. When a task exits and its pending perf events are processed, a race allows the task-work callback to fire after the event is released, causing a use-after-free.

`CONFIG_PERF_EVENTS=y` is compiled in and 5.19.6 falls within the affected range. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2022-49026

**Status**: Not exploitable
**Component**: Intel e100 Fast Ethernet driver (`CONFIG_E100`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Intel Pro/100 NIC absent on any modern HS server deployment

In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will resend the skb.

`CONFIG_E100=y` is compiled in and 5.19.6 falls within the affected range. The Intel e100 driver supports legacy Intel Pro/100 Fast Ethernet cards, a line discontinued in the early 2000s. No modern server or datacenter hardware ships with or supports this NIC; the driver code is compiled in but the hardware is universally absent on any HS deployment. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-50055

**Status**: Affected
**Component**: core kernel (`CONFIG_BASE_FULL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low
**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: drivers/base/bus.c

**What this means for an attacker:**

In `drivers/base/bus.c`, `bus_register()` allocates a `subsys_private` struct (`@priv`) and calls `kset_register()` to publish the bus kobject. If a subsequent step in `bus_register()` fails — for example, during sysfs attribute file creation — the error path calls `kset_unregister()`, which frees `@priv` through its kobject release callback. `bus_register()` then also frees `@priv` directly in its own error path, causing a double-free.

**Why the score is not 0.0:**

`CONFIG_BASE_FULL=y` is compiled in and 5.19.6 falls within the affected range. `bus_register()` is called during driver probe and device enumeration, typically at boot or when kernel modules are loaded. Triggering the double-free requires causing a bus registration to fail partway through a specific sysfs error. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root; an attacker cannot load an exploit module or execute an exploit program without an allowlist entry.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-50112

**Status**: Not Affected — LAM not implemented in Linux 5.19.x
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — LAM infrastructure absent from Linux 5.19.x (introduced in 6.2)

Linear Address Masking (LAM) is an x86_64 feature that allows software to store metadata in the upper bits of a canonical virtual address; it requires explicit kernel support — `arch_prctl` LAM commands, CR3 tag bit management, and associated data structures — to activate. The SLAM transient execution attack exploits an interaction between LAM tag bits and the speculative address-translation pipeline when a LAM-enabled process is running. This LAM kernel infrastructure was introduced upstream in Linux 6.2. The 5.19.6 kernel contains no LAM code paths; no process can enable LAM regardless of privilege level, and the transient execution oracle the SLAM paper describes does not exist in this kernel.

### CVE-2024-50193

**Status**: Not exploitable
**Component**: x86_64 architecture (`CONFIG_X86_64`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — perf_event_open() blocked by perf_event_paranoid=3; no perf tool in Root Lock allowlist
**Affected range**: Linux 5.x–6.11
**Upstream fix**: arch/x86/kernel/nmi.c (CPU buffer flush ordering fix)

On x86_64, the MDS/MD_CLEAR mitigation (VERW-based CPU buffer flush) is applied after `exc_nmi()` completes but before IRET restores register state. This ordering leaves a window in which speculative execution can observe uninitialised microarchitectural buffer contents from the interrupted context — a same-CPU information disclosure in the MDS (Microarchitectural Data Sampling) class.

`CONFIG_X86_64=y` is compiled in and 5.19.6 falls within the affected range. Triggering NMIs from ring-3 requires `perf_event_open()` or hardware performance counters. On a Root Lock system, `perf_event_paranoid=3` restricts `perf_event_open()` to processes with `CAP_SYS_ADMIN`; no profiling or performance analysis tool appears in the Root Lock allowlist. The exploitation path — loading and executing a non-allowlisted program — is blocked at the kernel execution gate before any perf subsystem interaction is possible. After gaining root through any avenue, Lockdown's allowlist refuses new code and blocks allowlist modification — no persistence, no backdoors, no cross-reboot survival.

### CVE-2024-56600

**Status**: Affected
**Component**: IPv6 networking stack (`CONFIG_IPV6`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv6/af_inet6.c

**What this means for an attacker:**

In `net/ipv6/af_inet6.c`, `sock_init_data()` attaches the newly allocated `sk` pointer to `sock->sk` before `inet6_create()` completes setup. If `inet6_create()` fails at a later step and frees the `sk`, `sock->sk` retains the dangling pointer. The socket cleanup path subsequently calls `sock->sk->sk_prot->close()` on the freed `sk`, causing a use-after-free.

**Why the score is not 0.0:**

`CONFIG_IPV6=y` is compiled in and 5.19.6 falls within the affected range. IPv6 socket creation is triggered whenever a process opens an IPv6 socket — a common operation on any networked system. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program to reach this path — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-56601

**Status**: Affected
**Component**: TCP/IP networking (`CONFIG_INET`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH — Lockdown reduces MI: High→Low

**Affected range**: Linux 5.x–6.x; 5.19.6 falls within range  
**Upstream fix**: net/ipv4/af_inet.c

**What this means for an attacker:**

In `net/ipv4/af_inet.c`, `sock_init_data()` attaches the newly allocated `sk` pointer to `sock->sk` before `inet_create()` completes setup. If `inet_create()` fails at a later step and frees the `sk`, `sock->sk` retains the dangling pointer. The socket cleanup path subsequently calls `sock->sk->sk_prot->close()` on the freed `sk`, causing a use-after-free.

**Why the score is not 0.0:**

`CONFIG_INET=y` is compiled in and 5.19.6 falls within the affected range. The TCP/IP stack is always active; INET socket creation occurs on every TCP or UDP connection. In Lockdown, `hs_sandbox_caching.c` enforces the SPF allowlist against all processes including root. An attacker cannot execute a new exploit program — it has no allowlist entry and the kernel refuses to run it.

**What this means for you as an HS user:**

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2024-56616

**Status**: Not exploitable
**Component**: DRM subsystem (`CONFIG_DRM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — DisplayPort MST display hardware absent

Fix the MST sideband message body length check, which must be at least 1 byte accounting for the message body CRC (aka message data CRC) at the end of the message.

`CONFIG_DRM=y` is compiled in. DisplayPort Multi-Stream Transport (DP MST) is used for daisy-chaining multiple monitors via DisplayPort. A headless server has no display output hardware; the DP MST sideband message path is never reached.

The attack vector has no path to execution on a standard Debian 11 server deployment. Lockdown provides a backstop regardless: root cannot modify the allowlist, install persistent backdoors, or survive a reboot.

### CVE-2026-53341

**Status**: Not exploitable  
**Component**: file handles / fhandle (`CONFIG_FHANDLE`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — NVD base pending; UAF class aligned with peer kernel entries  
**Score on Root Lock**: 0.0 — `CAP_DAC_READ_SEARCH` required to pass `may_decode_fh`; unprivileged callers receive `-EPERM`; Lockdown blocks allowlist modification  
**Affected range**: Linux 6.11 through 6.18.y prior to 6.18.36; production **6.18.9-hs** still lacks the upstream fix until a newer 6.18.y base  
**Upstream fix**: 6.18.36+ (`32138633e51e` — fhandle / `may_decode_fh`)

`may_decode_fh()` in the file-handle open path reads `mount::mnt_ns` without holding a lock. A concurrent unmount can free the mount namespace after an RCU grace period, so a racing `open_by_handle_at` can use the pointer after free. Upstream notes the race requires `CONFIG_PREEMPTION` or `CONFIG_RCU_STRICT_GRACE_PERIOD` and rates practical impact as limited (integer-comparison leak, hang, or crash) rather than a polished privilege-escalation chain.

`CONFIG_FHANDLE=y` is compiled in on 6.18.9-hs. Entering the vulnerable helper requires `open_by_handle_at` and `CAP_DAC_READ_SEARCH` (or the admin + DAC branch in that helper). Without those capabilities, `may_decode_fh` returns `-EPERM` before the unlocked `mnt_ns` read matters for an unprivileged attacker. No Root Lock deployment places a dedicated file-handle exploit tool in the allowlist. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot. Same product model as other capability-gated local paths (for example AF_PACKET / `CAP_NET_RAW`).

The trigger cannot be reached on any default Root Lock deployment.

### CVE-2026-53223

**Status**: Not exploitable  
**Component**: AF_PACKET timestamp cmsgs (`CONFIG_PACKET`)  
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)  
**Score on Root Lock**: 0.0 — `CAP_NET_RAW` not granted to services; packet-capture tools absent from Root Lock allowlist; Lockdown blocks the exploitation trigger  
**Affected range**: kernels prior to the AF_PACKET timestamp cmsg guard; production **6.18.9-hs** lacks the upstream fix until base ≥ 6.18.36-class  
**Upstream fix**: `3dde4fb941fa` (guard timestamp cmsgs to real error-queue skbs)

`skb_is_err_queue()` treated `PACKET_OUTGOING` as proof that an skb came from the socket error queue. AF_PACKET also delivers legitimate outgoing taps with that `pkt_type` while `skb->cb` holds packet control state, not `sock_exterr_skb`. With socket timestamping enabled, the generic timestamp cmsg path can emit `SCM_TIMESTAMPING_OPT_STATS` from the wrong buffer and disclose heap contents or trip hardened usercopy.

`CONFIG_PACKET=y` is compiled in. Creating an AF_PACKET socket requires `CAP_NET_RAW`. No Root Lock deployment grants `CAP_NET_RAW` to any service — packet capture tools such as `tcpdump` have no allowlist entry. Without an allowlist entry, the kernel refuses to execute them. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot. HeartSuite network hooks cover `connect` and destination `sendto` only; they do not cover `socket` / `setsockopt` / `recvmsg` on this path — reachability is closed by capability and allowlist composition, not by the net hook.

The trigger cannot be reached on any default Root Lock deployment.

### CVE-2026-46300

**Status**: Not exploitable
**Component**: skbuff coalescing and ESP-in-TCP (`CONFIG_NET`, `CONFIG_INET_ESPINTCP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org)
**Score on Root Lock**: 0.0 — ESP-in-TCP is not compiled; the TCP-coalesce-then-ESP write path does not exist
**Affected range**: Linux 3.9 through 6.18.32 (and listed LTS windows). 5.19.6 and production 6.18.9-hs are in range.
**Upstream fix**: 6.18.33 (6.18 stable); 5.19 branch is EOL

This CVE describes a local privilege escalation (Fragnesia) in which `skb_try_coalesce()` attaches paged fragments from one socket buffer to another and drops the shared-fragment marker. ESP input then treats the coalesced buffer as privately owned, skips copy-on-write, and decrypts in place over page-cache-backed fragments. The published local-root path splices a privileged file into a TCP stream and switches that socket into ESP-in-TCP.

`CONFIG_NET=y` is compiled on both fielded kernels, so `skb_try_coalesce()` is present. The write that turns the lost marker into a page-cache overwrite is ESP input after TCP receive coalescing. That composition is ESP-in-TCP (`CONFIG_INET_ESPINTCP` / `CONFIG_INET6_ESPINTCP`). Both options are not set on 5.19.6-HeartSuite-2.0 and on 6.18.9-hs. IPv4 ESP is also not compiled on 5.19.6. 6.18.9-hs builds IPv4/IPv6 ESP as modules and still leaves both ESP-in-TCP options unset. The running System.map on both kernels exports `skb_try_coalesce` and contains no `espintcp` symbol.

A second independent stop matches CVE-2026-43284. Establishing any XFRM security association requires XFRM management tooling (`ip xfrm`, `setkey`, strongSwan, libreswan, or an equivalent IKE daemon). None of those programs are in the Root Lock default allowlist. Under Lockdown the allowlist is `chattr +i` immutable and `FS_IOC_SETFLAGS` returns `EPERM` for all callers.

The trigger cannot be reached on any Root Lock deployment.

If a custom kernel is built with `CONFIG_INET_ESPINTCP=y` or `CONFIG_INET6_ESPINTCP=y` and XFRM management tooling is added to the allowlist, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-45920

**Status**: Not exploitable
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — filesystem-shutdown injection (`EXT4_IOC_SHUTDOWN`) is not reachable from the allowlist
**Affected range**: 2.6.29–5.10.252; 5.11–5.15.202; 5.16–6.1.166 (includes 5.19.6); 6.2–6.6.129; 6.7–6.12.74; 6.13–6.18.13 (includes 6.18.9); 6.19–6.19.3
**Upstream fix**: 5.10.253, 5.15.203, 6.1.167, 6.6.130, 6.12.75, 6.18.14, 6.19.4 (5.19 branch is EOL; no backport)

This CVE describes a double decrement of the ext4 dirty-clusters counter on the multi-block allocator error path. After the filesystem is placed in forced-shutdown state, `ext4_mb_mark_diskspace_used()` decrements `s_dirtyclusters_counter` and then `ext4_handle_dirty_metadata()` returns an error; the caller `ext4_mb_new_blocks()` decrements the same counter again in the failed-allocation cleanup path. The counter reaches −1 and `ext4_put_super()` emits a kernel WARNING. The documented reproduction is fstests generic/388 (allocator stress plus filesystem-shutdown injection).

`CONFIG_EXT4_FS=y` on 5.19.6 and `CONFIG_EXT4_FS=m` on 6.18.9-hs; both kernels fall inside the NVD range. Ordinary reads and writes on the mounted ext4 volume do not take this error path. The path requires `EXT4_FLAGS_SHUTDOWN` first. On 5.19.6 that bit is set only by `ext4_shutdown()`, reached solely through `EXT4_IOC_SHUTDOWN`, which returns `-EPERM` unless the caller has `CAP_SYS_ADMIN`. The userspace programs that inject that ioctl (`xfs_io`) and that drive the concurrent allocator stress (`fsstress`) are not in the HeartSuite allowlist. The kernel refuses to execute any program without an allowlist record. Lockdown also returns `-EPERM` on `mount()`, `fsmount()`, and `move_mount()`, so a test image cannot be mounted to host the same sequence.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46094

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: ext4 filesystem (`CONFIG_EXT4_FS`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range; on 6.18.9-hs Lockdown returns `-EPERM` from `mount()` / `fsmount()` / `move_mount()`, so a crafted xattr image cannot be attached
**Affected range**: 6.3 through 6.6.139; 6.7 through 6.12.85; 6.13 through 6.18.26; 6.19 through 7.0.3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.27
**Upstream fix**: 6.6.140, 6.12.86, 6.18.27, 7.0.4; mainline `eceafc31ea7b`

This CVE describes an out-of-bounds read in `fs/ext4/xattr.c`. `check_xattrs()` walks on-disk xattr entries and tests `(void *)next >= end`. That test lets `next` land inside the last four bytes of the xattr region. The next loop iteration calls `IS_LAST_ENTRY()`, which reads a `u32` and overruns the valid region (CWE-125). Integrity impact is None.

`CONFIG_EXT4_FS=y` on 5.19.6 and `CONFIG_EXT4_FS=m` on 6.18.9-hs. The `check_xattrs()` helper was introduced in 6.3; 5.19.6 predates it and is outside the NVD window. 6.18.9 sits inside 6.13–6.18.26. The v6.18.9 `check_xattrs()` still uses the unfixed `(void *)next >= end` test. The function is `static` (absent from System.map) and is compiled into `ext4.ko`.

The overrun requires a corrupted xattr block on a mounted ext4 image. Kernel-formed `setxattr` on the already-mounted root does not produce that layout. Attaching a crafted image requires `mount()`, `fsmount()`, or `move_mount()`. `mount` is in the shipped command list. Under Lockdown those three syscalls return `-EPERM` in `kernel/namespace.c`. `losetup`, `setfattr`, `getfattr`, and `mkfs.ext4` are not in the allowlist; that is not the binding stop.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46020

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs  
**Component**: DAMON core — `damos_quota_goal->nid` for `node_mem_{used,free}_bp` (`CONFIG_DAMON`, `CONFIG_DAMON_SYSFS`)  
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)  
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and DAMON is not compiled; on 6.18.9-hs the DAMON sysfs trigger is not reachable from the allowlist  
**Affected range**: Linux 6.16 through 6.18.26; 6.19 through 7.0.3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.27  
**Upstream fix**: `40250b2dded0604a112be605f3828700d80ad7c2` (mainline 7.1-rc1); stable 6.18.27, 7.0.4

This CVE describes an out-of-bounds read in DAMON core. Users can set `damos_quota_goal->nid` to an arbitrary node id for the `node_mem_{used,free}_bp` quota-goal metrics. DAMON then calls `si_meminfo_node()` without validating that id. An invalid nid produces a kernel NULL-pointer dereference and an out-of-bounds read of node data. The kernel interface is DAMON_SYSFS. The documented trigger is the `damo` userspace tool.

`# CONFIG_DAMON is not set` on 5.19.6-HeartSuite-2.0. The introducing commit is 6.16. 5.19.6 predates the feature. The 5.19.6 System.map has no `damos_get_node_mem_bp` symbol.

On 6.18.9-hs, `CONFIG_DAMON=y` and `CONFIG_DAMON_SYSFS=y`. `damos_get_node_mem_bp` is present in the 6.18.9-hs System.map. That is not enough. Reaching the path requires writing DAMON sysfs quota-goal attributes under `/sys/kernel/mm/damon/`. `damo` is not in the shipped allowlist. Lockdown refuses to execute it. The allowlisted writers that exist (`echo`, `tee`, `printf`, `bash`) receive write grants only for `/usr/lib` and `/etc` from the default record seed. Opening `/sys/kernel/mm/damon/` for write returns `EACCES`. Under Lockdown the allowlist is immutable: `FS_IOC_SETFLAGS` returns `EPERM`, so root cannot add `damo` or a DAMON sysfs write grant.

The trigger cannot be reached on any default Root Lock deployment.

If your 6.18.9-hs deployment adds `damo` or grants write access to `/sys/kernel/mm/damon/` to an allowlisted program, treat this CVE as Affected at 7.1 HIGH and apply the I:N infoleak backstop.

### CVE-2026-46121

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: DAMON sysfs schemes (`CONFIG_DAMON`, `CONFIG_DAMON_SYSFS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and does not compile DAMON; on 6.18.9-hs the memcg_path race is not reachable from the allowlist
**Affected range**: 6.6.96–6.6.139; 6.12.36–6.12.87; 6.15.5–6.15.x; 6.16; 6.16.1 through 6.18.29; 6.19 through 7.0.6. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.30
**Upstream fix**: 6.18.30; 6.12.88; 6.6.140; 7.0.7

This CVE describes a use-after-free in `mm/damon/sysfs-schemes.c`. Direct reads of the DAMON sysfs `memcg_path` and `path` files race with writes that free the backing buffer. The commit path that copies those strings into DAMON is already under `damon_sysfs_lock`; the user-facing show/store path was not. Two open files on the same attribute can therefore read a buffer after it has been freed.

On 5.19.6, `# CONFIG_DAMON is not set`. The 5.19.6 DAMON tree has `sysfs.c` and `dbgfs.c` only — no `sysfs-schemes.c` and no `memcg_path` attribute. The vulnerable code is not present.

On 6.18.9-hs, `CONFIG_DAMON=y` and `CONFIG_DAMON_SYSFS=y`. `memcg_path_show`, `memcg_path_store`, and `damon_sysfs_scheme_filter_memcg_path_attr` are in the running `System.map`. That is not enough to reach the race. The `memcg_path` and `path` files exist only after userspace creates the scheme-filter hierarchy under `/sys/kernel/mm/damon/admin`. The kernel documents that directory as a privileged admin interface and names `damo` as the userspace tool. `damo` is not in the HeartSuite allowlist. Default allowlist records grant `/usr/lib` and `/etc` only; writes to `/sys/kernel/mm/damon/` are denied. `CONFIG_DAMON_RECLAIM` and `CONFIG_DAMON_LRU_SORT` run in-kernel and do not create those scheme-filter files. Under Lockdown, `FS_IOC_SETFLAGS` returns `-EPERM`, so root cannot add `damo` or that sysfs path.

The trigger cannot be reached on any default Root Lock deployment.

If a 6.18.9-hs deployment adds `damo` or write access to `/sys/kernel/mm/damon/admin` to the allowlist, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-46279

**Status:** Not exploitable — feature not compiled
**Component:** mm/alloc_tag (CONFIG_MEM_ALLOC_PROFILING)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 0.0 — CONFIG_MEM_ALLOC_PROFILING is not compiled; alloc_tag/codetag is not in the kernel.

The bug is an uninitialized alloc_tag/codetag on pages allocated before page_ext is ready during boot. That path is compiled only when CONFIG_MEM_ALLOC_PROFILING is enabled. The published warning requires CONFIG_MEM_ALLOC_PROFILING_DEBUG. HeartSuite 6.18.9-hs is in the NVD range (6.10 through 6.18.26) and has `# CONFIG_MEM_ALLOC_PROFILING is not set`. HeartSuite 5.19.6 is outside the NVD range (starts at 6.10) and the option is not present in that kernel.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46281

**Status**: Not Affected on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation
**Component**: vmalloc — virtually contiguous allocator (`CONFIG_MMU`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 on 5.19.6 (outside the affected range). 7.1–7.3 HIGH on 6.18.9-hs — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High; score stays within the HIGH band
**Affected range**: 6.18 through 6.18.26; also 6.19 through 7.0.3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.27
**Upstream fix**: `e9b057a44def` (mainline); stable 6.18.27+

This CVE describes an out-of-bounds write in `vrealloc_node_align()`. When the helper forces a new allocation while shrinking the object, it allocates `size` bytes and copies `old_size` bytes into that buffer.

`CONFIG_MMU=y` compiles `mm/vmalloc.c` on both fielded kernels. That is not enough for 5.19.6: the helper was added in 6.18. The 5.19.6 kernel has `kvrealloc` only. The 5.19.6 `vrealloc_node_align` path does not exist.

On 6.18.9-hs the helper is in the running kernel. `vrealloc_node_align_noprof` is present and `kvrealloc_node_align_noprof` is exported. The overflow is a kernel memory-corruption bug in a core allocator. Lockdown does not remove that code path from an already-running process.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

These constraints are why the Score on Root Lock on 6.18.9-hs reflects a reduced MI (High→Low): root cannot modify the allowlist, cannot install persistent backdoors, and cannot survive a reboot. Confidentiality and Availability remain High. Residual risks are in-memory data exfiltration and availability impact. The Score on Root Lock does not reach 0.0 on 6.18.9-hs because the helper is compiled in.

### CVE-2026-52968

**Status**: Not exploitable
**Component**: KVM s390 PCI (`CONFIG_KVM_S390`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_KVM_S390` not compiled; s390 PCI GAIT path absent from the x86_64 image
**Affected range**: Linux 6.0–6.1.174, 6.2–6.6.140, 6.7–6.12.90, 6.13–6.18.32, 6.19–7.0.9, and 7.1-rc1–rc3
**Upstream fix**: 6.1.175, 6.6.141, 6.12.91, 6.18.33, 7.0.10, 7.1-rc4

In `arch/s390/kvm/pci.c` and `arch/s390/kvm/interrupt.c`, `kvm_s390_pci_aif_enable()`, `kvm_s390_pci_aif_disable()`, and `aen_host_forward()` index the GAIT by multiplying the AISB index by `sizeof(struct zpci_gaite)` on a pointer that is already typed as `struct zpci_gaite *`. The offset is double-scaled and the access lands at element `aisb*16` instead of `aisb`, which is out of bounds when `aisb >= 32` (`ZPCI_NR_DEVICES=512`).

5.19.6 is outside the affected range (the code landed in 6.0) and `# CONFIG_KVM is not set`. 6.18.9-hs is inside 6.13–6.18.32 and builds x86 KVM (`CONFIG_KVM=m`, `CONFIG_KVM_X86=m`). Both kernels are `CONFIG_X86_64=y`. `CONFIG_S390` and `CONFIG_KVM_S390` do not appear in either production config. The 6.18.9-hs System.map contains none of `kvm_s390_pci_aif_enable`, `kvm_s390_pci_aif_disable`, `aen_host_forward`, or `zpci_gaite`. The compiled KVM module is Intel/AMD x86; it does not contain the s390 PCI GAIT indexer.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-52969

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: KVM dirty ring (`CONFIG_KVM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile host KVM; on 6.18.9-hs the dirty-ring reset path is reached only by a KVM userspace program, and none is in the allowlist
**Affected range**: 5.11–5.15.208; 5.16–6.1.174; 6.2–6.6.140; 6.7–6.12.90; 6.13–6.18.32; 6.19–7.0.9; 7.1-rc1–rc3. Both 5.19.6 and 6.18.9-hs are in range. Fixed in 6.18.33+ and 7.0.10+
**Upstream fix**: `577a8d3bae05` (mainline); stable 6.18.33+

This CVE describes a wrapped `u64` offset in `kvm_reset_dirty_gfn()`. The bounds check adds `offset` to `__fls(mask)` without first rejecting a wrap. A process that holds `/dev/kvm` and uses the dirty ring can rewrite slot and offset fields so the check passes. The wrapped offset then indexes a near-`U64_MAX` gfn and performs an out-of-bounds load.

On 5.19.6, `CONFIG_KVM` is not set. Host KVM is not in the running kernel.

On 6.18.9-hs, `CONFIG_KVM=m`. The trigger requires a loaded `kvm` module and a userspace program that opens `/dev/kvm`, enables the dirty ring, and issues `KVM_RESET_DIRTY_RINGS`. No KVM userspace program is in the Root Lock allowlist. `modprobe` is not in the allowlist, so the `kvm` module cannot be loaded at runtime. Under Lockdown, the allowlist cannot be modified. The dirty-ring reset path is never reached.

The trigger cannot be reached on any Root Lock deployment.

If your deployment adds a KVM userspace program (qemu, libvirt, firecracker, or equivalent) to the Root Lock allowlist and loads the `kvm` module, this CVE applies at its base score of 7.8 HIGH. Treat it as Affected and apply the standard backstop logic.

### CVE-2026-53004

**Status**: Not exploitable
**Component**: SCTP (`CONFIG_IP_SCTP`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile SCTP; 6.18.9 builds SCTP as a module that cannot be loaded because `modprobe`/`insmod`/`kmod` are not on the allowlist
**Affected range**: Linux through 7.0.9 (Ubuntu 5.15–7.0 and Debian bullseye 5.10 needed the fix)
**Upstream fix**: 7.1-rc1 / 7.0.10

`sctp_getsockopt_peer_auth_chunks()` checks `if (len < num_chunks)` and then writes `num_chunks` bytes to `p->gauth_chunks`, which sits eight bytes inside the caller's `optval`. The check omits the `sctp_authchunks` header. When the caller passes `len == num_chunks`, `copy_to_user()` writes eight bytes past the declared buffer. Those bytes land in the caller's own userspace; this is not kernel memory corruption.

On 5.19.6, `# CONFIG_IP_SCTP is not set`. The function is absent from the vmlinux System.map. On 6.18.9-hs, `CONFIG_IP_SCTP=m`. Reaching the function requires the SCTP module to be loaded, an SCTP association with AUTH enabled, and `getsockopt(SCTP_PEER_AUTH_CHUNKS)`. The shipped allowlist has no `modprobe`, `insmod`, `kmod`, or SCTP tools. Under Lockdown, `FS_IOC_SETFLAGS` returns `EPERM`, so those programs cannot be added. The SCTP stack is not loaded.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53264

**Status**: Not exploitable  
**Component**: net/sched action API (`CONFIG_NET_SCHED`, `CONFIG_NET_CLS_ACT`)  
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org)  
**Score on Root Lock**: 0.0 — no tc action can be instantiated; `tc` and module-loading tools are absent from the allowlist  
**Affected range**: 4.14 through unfixed stables including 6.18 before 6.18.36; **5.19.6 and 6.18.9-hs are in range**  
**Upstream fix**: stable 6.18.36+ (5.19 branch is EOL; no backport)

This CVE describes a use-after-free in the traffic-control action lifecycle. Concurrent NEWTFILTER and DELFILTER netlink operations race on a `tc_action`: the delete path frees the object immediately while a lookup still holds the pointer, so the increment of the action refcount touches freed memory.

`CONFIG_NET_SCHED=y` and `CONFIG_NET_CLS_ACT=y` are compiled in on both fielded kernels. The race requires an instantiated tc action attached to a filter.

On 5.19.6 every `CONFIG_NET_ACT_*` option is not set. No action kind is registered in the running image, so a NEWTFILTER that names an action cannot create one.

On 6.18.9-hs every `CONFIG_NET_ACT_*` option is a module and those kinds are not in vmlinux. Loading them requires `kmod`/`modprobe`/`insmod`, which are not on the allowlist. The `tc` program that issues NEWTFILTER and DELFILTER is also not on the allowlist. Under Lockdown the allowlist cannot be extended.

The trigger cannot be reached on any Root Lock deployment.

If your deployment adds `tc` to the allowlist (and on 6.18.9-hs also allowlists loading of `act_*` modules), treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-53359

**Status**: Not exploitable
**Component**: KVM x86 shadow MMU (`CONFIG_KVM`)
**Base Score**: 8.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:H) — CNA (kernel.org); NVD assessment pending
**Score on Root Lock**: 0.0 — 5.19.6 does not compile `CONFIG_KVM`; 6.18.9 compiles `CONFIG_KVM=m` but no QEMU or libvirt program is in the allowlist
**Affected range**: Linux 2.6.36 through 6.1.176; 6.2 through 6.6.143; 6.7 through 6.12.94; 6.13 through 6.18.37; 6.19 through 7.1.2
**Upstream fix**: 6.1.177, 6.6.144, 6.12.95, 6.18.38, 7.1.3, 7.2

This CVE is a use-after-free in the KVM x86 shadow MMU. The host reuses a cached shadow page when the guest frame number matches even though the page role does not. A later reverse-map walk then dereferences a freed shadow page.

On 5.19.6, `# CONFIG_KVM is not set`. Host KVM is not compiled. `CONFIG_KVM_GUEST=y` only enables paravirtual guest support; it does not compile the host shadow MMU.

On 6.18.9, `CONFIG_KVM=m` with `CONFIG_KVM_INTEL=m` and `CONFIG_KVM_AMD=m`. Reaching the bug requires a running KVM guest: a userspace hypervisor (QEMU, libvirt, or equivalent) must create a VM and drive the shadow MMU. No such program is in the HeartSuite allowlist. The kernel refuses to execute it. An attacker who has already gained root cannot add one: Lockdown prevents allowlist modification, backdoor installation, and persistence across reboot.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-63794

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: KVM AMD SVM — SEV debug crypt (`CONFIG_KVM`, `CONFIG_KVM_AMD`, `CONFIG_KVM_AMD_SEV`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile host KVM; on 6.18.9-hs the SEV debug-encrypt ioctl is not reachable from the allowlist
**Affected range**: Linux 4.16 through 6.18.37 (plus the other listed stable windows). 5.19.6 is in the 5.16–<6.1.177 window but host KVM is not compiled. Production 6.18.9-hs remains in range until base ≥ 6.18.38
**Upstream fix**: 6.18.38, 6.12.95, 6.6.144, 6.1.177, 5.15.211, 5.10.260

This CVE describes a page overflow in `sev_dbg_crypt()` on the ENCRYPT path in `arch/x86/kvm/svm/sev.c`. The per-iteration copy length is clipped to the source page remainder (`PAGE_SIZE - s_off`) but not the destination page remainder (`PAGE_SIZE - d_off`). When `d_off > s_off`, `__sev_dbg_encrypt_user` issues a PSP command and a memcpy into a single-page bounce buffer that overflows. The entry is `kvm_vm_ioctl` → `sev_mem_enc_ioctl` → `sev_dbg_crypt` (KVM SEV debug encrypt).

On 5.19.6, `# CONFIG_KVM is not set`. `CONFIG_KVM_GUEST=y` is guest-side paravirt only. There is no `CONFIG_KVM_AMD` / `CONFIG_KVM_AMD_SEV`, and `sev_dbg_crypt` is not in the 5.19.6 image.

On 6.18.9-hs, `CONFIG_KVM=m`, `CONFIG_KVM_AMD=m`, and `CONFIG_KVM_AMD_SEV=y`. Reaching the overflow requires a loaded `kvm_amd` module, an SEV guest, and the SEV debug-encrypt ioctl. No qemu, libvirt, virsh, or KVM/SEV userspace appears in the Root Lock allowlist, and `modprobe` / `insmod` / `kmod` are likewise absent, so the module is not loadable from userspace. The kernel refuses to run a dropped program with no allowlist entry. After gaining root through any other avenue, Lockdown still blocks allowlist modification, so those tools cannot be added for the life of the boot.

The trigger cannot be reached on any Root Lock deployment.

If a 6.18.9-hs deployment adds qemu-system, libvirt, or any other program that issues KVM SEV debug-encrypt ioctls to the allowlist, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-63804

**Status**: Not exploitable
**Component**: GFS2 clustered filesystem (`CONFIG_GFS2_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — GFS2 cluster tools are not on the allowlist; the unmount path never runs
**Affected range**: Linux 6.6 through 6.6.143, 6.7 through 6.12.94, 6.13 through 6.18.37, and 6.19 through 7.1.2. HeartSuite 5.19.6 is outside this range. HeartSuite 6.18.9 is inside it.
**Upstream fix**: `rcu_barrier()` before `free_sbd()` in `gfs2_put_super()`; stable backports through 6.18.38

During GFS2 unmount, `gfs2_qd_dealloc()` runs as an RCU callback and touches the superblock after that superblock is already freed. The bug is a use-after-free in the quota-object teardown path.

HeartSuite 5.19.6 does not compile GFS2 (`CONFIG_GFS2_FS` is not set) and sits below the NVD floor of 6.6.

HeartSuite 6.18.9 compiles GFS2 as a module (`CONFIG_GFS2_FS=m`, `CONFIG_GFS2_FS_LOCKING_DLM=y`, `CONFIG_DLM=m`). The trigger is unmount of an already-mounted GFS2 volume. That state requires the GFS2 and DLM modules plus the cluster userspace (`mount.gfs2` and the DLM/corosync stack). Those programs are not on the HeartSuite allowlist, so they cannot execute. No Root Lock deployment mounts GFS2 as a live filesystem.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64121

**Status**: Not exploitable
**Component**: IFB intermediate functional block (`CONFIG_IFB`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H) — NVD
**Score on Root Lock**: 0.0 — `CONFIG_IFB` is not compiled on 5.19.6; on 6.18.9-hs the trigger requires `ip`, `ethtool`, and `modprobe`, none of which are in the Root Lock allowlist
**Affected range**: 5.17 through 6.1.174; 6.2 through 6.6.141; 6.7 through 6.12.91; 6.13 through 6.18.33; 6.19 through 7.0.10; plus 7.1-rc1–rc4. Both production kernels (5.19.6 and 6.18.9-hs) sit in range.
**Upstream fix**: ethtool stats walk `dev->num_tx_queues`; stable 6.18.34+

This CVE describes a slab out-of-bounds read in the IFB ethtool stats path. `ifb_dev_init()` allocates `dp->tx_private` with `dev->num_tx_queues` entries. `ifb_get_ethtool_stats()` instead walks `dev->real_num_rx_queues`. On an IFB device created with more RX queues than TX queues, the walk indexes past the allocation and copies adjacent slab data out through `ETHTOOL_GSTATS`. Integrity impact is none. The bug does not grant root.

On 5.19.6, `CONFIG_IFB` is not compiled. The Kconfig depends on `NET_ACT_MIRRED || NFT_FWD_NETDEV`. Both parents are unset (`# CONFIG_NET_ACT_MIRRED is not set`, `# CONFIG_NF_TABLES is not set`), so the `CONFIG_IFB` symbol is not offered. The 5.19.6 System.map has no `ifb_get_ethtool_stats` symbol. The callbacks in `drivers/net/ifb.c` are not in the running image.

On 6.18.9-hs, `CONFIG_IFB=m`. The module is built, not builtin. Reaching the bug requires loading `ifb`, creating an asymmetric IFB device, and querying ethtool stats. `ip`, `ethtool`, and `modprobe` are absent from the Root Lock allowlist. Under Lockdown the allowlist cannot be changed: `FS_IOC_SETFLAGS` returns `-EPERM`, and `mount()`, `fsmount()`, and `move_mount()` return `-EPERM`. Root cannot add those programs.

The trigger cannot be reached on any Root Lock deployment.

If a 6.18.9-hs deployment adds `ip`, `ethtool`, and a way to load `ifb` to the allowlist, treat this CVE as Affected at 7.1 HIGH for confidentiality and availability only.

### CVE-2026-64600

**Status**: Affected — Lockdown limits post-exploitation
**Component**: XFS reflink / copy-on-write (`CONFIG_XFS_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.1–7.3 HIGH — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High
**Affected ranges**: NVD: 4.11 through 5.15.211; 5.16 through 6.1.177; 6.2 through 6.6.144; 6.7 through 6.12.95; 6.13 through 6.18.38; 6.19 through 7.1.3. HeartSuite 5.19.6 is in range with XFS not compiled. HeartSuite 6.18.9-hs is in range with `CONFIG_XFS_FS=m`.
**Upstream fix**: 5.15.212, 6.1.178, 6.6.145, 6.12.96, 6.18.39, 7.1.4

The bug is a race in the XFS reflink copy-on-write path. After `xfs_reflink_fill_cow_hole` and `xfs_reflink_fill_delalloc` drop and re-take ILOCK to start a transaction, they refresh the CoW fork mapping and leave the data-fork mapping stale. A concurrent aligned `O_DIRECT` writer can finish a CoW cycle in that window. The first writer then operates on the wrong physical block, including a block that now solely backs the reflink source. That is a local privilege-escalation primitive.

On 5.19.6 HeartSuite, `# CONFIG_XFS_FS is not set`. The helpers are not compiled. That kernel is Not Affected.

On 6.18.9-hs, `CONFIG_XFS_FS=m` and `CONFIG_MODULES=y`. The unfixed fill helpers are in the 6.18.9 XFS tree. The installer unpacks the full module tarball into `/lib/modules` and, on Amazon Linux, forces `xfs` into the initrd. Amazon Linux 2023, Rocky 9, and RHEL 9 use XFS as the root filesystem. `cp`, `dd`, and `python3` are allowlisted. Creating a new XFS image requires `mkfs.xfs`, which is not in the allowlist, and Lockdown returns `-EPERM` from `mount()`, `fsmount()`, and `move_mount()`. That closes a late mount of an attacker-supplied XFS volume. It does not close the path when XFS is already mounted: aligned `O_DIRECT` writes and reflink clones are ordinary file I/O.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** Lockdown's allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2026-45837

### CVE-2026-45839

**Status**: Not exploitable — feature not compiled
**Component**: BPF CO-RE relocation parser (`CONFIG_BPF_SYSCALL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_BPF_SYSCALL` is not compiled; `bpf()` returns `ENOSYS`; `bpf_core_parse_spec()` is unreachable

CVE-2026-45839 is a signed-index out-of-bounds read in `bpf_core_parse_spec()`. CO-RE accessor strings are colon-separated field indices parsed with `sscanf("%d")`. A negative index passes the upper-bound check (`access_idx >= btf_vlen(t)`) and is cast to `u32` 0xffffffff inside `btf_member_bit_offset()`, reading far past the BTF members array. A local caller with `CAP_BPF` triggers it on `BPF_PROG_LOAD`.

`# CONFIG_BPF_SYSCALL is not set` on the Root Lock kernel (`bpf()` returns `ENOSYS`). There is no verifier, no CO-RE relocation path, and no `bpf_core_parse_spec()` in the running kernel. Both lines also ship `CONFIG_DEBUG_INFO_NONE=y` with no vmlinux BTF.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45851

**Status:** Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9
**Component:** EFI unaccepted memory table (CONFIG_UNACCEPTED_MEMORY absent on 5.19.6; CONFIG_UNACCEPTED_MEMORY=y on 6.18.9)
**Base Score:** 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock:** 0.0 — 5.19.6 is outside the NVD range and does not compile unaccepted memory; 6.18.9 compiles the path but the trigger requires Intel TDX guest firmware that presents an unaccepted memory table.

reserve_unaccepted() under-reserves the EFI unaccepted memory table when the table start address is not page-aligned. The tail of the table is left unreserved, the table is overwritten or becomes inaccessible, and the kernel panics in accept_memory(). Upstream recorded that failure when starting Intel TDX guests with specific memory sizes (for example greater than 64 GB).

NVD marks Linux before 6.6 unaffected. HeartSuite 5.19.6 has no CONFIG_UNACCEPTED_MEMORY option and no accept_memory symbol. HeartSuite 6.18.9 sits in 6.13–6.18.13 and builds CONFIG_UNACCEPTED_MEMORY=y, but a standard Root Lock deployment is not an Intel TDX guest and does not receive that firmware table.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45853

**Status**: Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9
**Component**: AMDGPU DRM driver (`CONFIG_DRM_AMDGPU`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `# CONFIG_DRM_AMDGPU is not set` on 5.19.6 and the NVD range starts at 6.11; on 6.18.9 the driver is compiled as a module but no AMD GPU is present
**Affected range**: 6.11 through 6.12.74; 6.13 through 6.18.13; 6.19 through 6.19.3
**Upstream fix**: 6.12.75, 6.18.14, 6.19.4

`amdgpu_gmc_get_nps_memranges()` in `drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c` frees a range table with `kfree()` after `amdgpu_discovery_get_nps_info()` allocated it with `kvcalloc()`. When that allocation comes from vmalloc, `kfree()` corrupts kernel memory.

On 5.19.6 the AMDGPU driver is not compiled and the function does not exist. On 6.18.9 `CONFIG_DRM_AMDGPU=m` sits inside the NVD window, but the path runs only when an AMD GPU is present and the driver binds. No AMD GPU is present on a Root Lock server deployment.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45893

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: AppArmor DFA table unpack (`CONFIG_SECURITY_APPARMOR`)
**Base Score**: 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile AppArmor; on 6.18.9-hs the policy-unpack path is not reachable from the allowlist
**Affected range**: Linux 4.11 through 6.12.74; 6.13 through 6.18.13; 6.19 through 6.19.3. Both HeartSuite production kernels sit in that window until the config and allowlist gates apply.
**Upstream fix**: 6.12.75; 6.18.14; 6.19.4

This CVE describes an unaligned memory access in `unpack_table()` (`security/apparmor/match.c`). AppArmor copies DFA match tables out of a userspace policy blob with aligned `be16_to_cpu` / `be32_to_cpu`. A blob that is not naturally aligned produces an out-of-bounds read. The function runs only when a profile is loaded or replaced through the AppArmor securityfs interface.

On 5.19.6, `# CONFIG_SECURITY_APPARMOR is not set`. The AppArmor code is not compiled. The `CONFIG_LSM` string still names apparmor; that string does not compile the module when the Kconfig option is off.

On 6.18.9-hs, `CONFIG_SECURITY_APPARMOR=y` and `CONFIG_DEFAULT_SECURITY_APPARMOR=y`. AppArmor is a live LSM. That is not enough to reach `unpack_table`. Reaching the bug requires writing a packed profile to `/sys/kernel/security/apparmor/.load` or `.replace`. `apparmor_parser` and the `aa-*` policy tools are not on the allowlist. Default allowlist records grant `/usr/lib` and `/etc` only, read-only; writes to `/sys/kernel/security/apparmor/` are denied. Under Lockdown, `FS_IOC_SETFLAGS` returns `-EPERM`, so the allowlist cannot be extended to add those programs or that path.

The trigger cannot be reached on any default Root Lock deployment.

If a 6.18.9-hs deployment adds `apparmor_parser` or write access to `/sys/kernel/security/apparmor/` to the allowlist, treat this CVE as Affected at 7.1 HIGH with Confidentiality and Availability High and Integrity None.

### CVE-2026-45903

**Status**: Not Affected
**Component**: BPF syscall / verifier helper prototypes (`CONFIG_BPF_SYSCALL`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_BPF_SYSCALL` is not compiled; `bpf()` returns `ENOSYS`

After a verifier refactor, several BPF helper prototypes omitted `MEM_RDONLY` or `MEM_WRITE` on `ARG_PTR_TO_MEM` arguments. The verifier then treated helper buffers as unchanged and dropped later reads, producing incorrect memory access.

NVD lists Linux 6.14 through 6.18.13 and 6.19 through 6.19.3. 5.19.6 is outside that range. On both released pins the `bpf()` syscall is not compiled. There is no verifier and no helper-prototype path.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45943

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: EROFS filesystem (`CONFIG_EROFS_FS`, `CONFIG_EROFS_FS_ZIP`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile EROFS; on 6.18.9-hs the erofs module cannot be loaded and a ztailpacking image cannot be attached
**Affected range**: 5.17 through 6.12.77; 6.13 through 6.18.13; 6.19 through 6.19.3. Both 5.19.6 and 6.18.9-hs are in range. Fixed in 6.12.78, 6.18.14, 6.19.4, and 7.0.
**Upstream fix**: 6.12.78, 6.18.14, 6.19.4, 7.0; stable commits 5de1aa0bf3a5, 92088bd9aa2a, ad07ea069f92, c134a40f86ef

This CVE describes a NULL pointer dereference in `z_erofs_decompress_pcluster()`. Compressed folios for ztailpacking pclusters must be valid before those pclusters are added to the I/O chain. If a fatal signal interrupts `read_mapping_folio()` while the inline tail is being fetched, `z_erofs_decompress_queue()` treats the folio as valid and dereferences a NULL page. Integrity impact is None. The entry is a `read()` of a file on a mounted EROFS volume that uses ztailpacking.

On 5.19.6, `# CONFIG_EROFS_FS is not set`. The EROFS decompression path is not in the running kernel.

On 6.18.9-hs, `CONFIG_EROFS_FS=m` and `CONFIG_EROFS_FS_ZIP=y`. Reaching the path requires the erofs module to be loaded and a ztailpacking EROFS volume to be mounted, then a `read()` of a compressed file. `modprobe`, `insmod`, and `kmod` are not on the allowlist, so `erofs.ko` cannot be loaded. `mkfs.erofs`, `dump.erofs`, and `fsck.erofs` are not on the allowlist. `mount` is on the allowlist; under Lockdown, `mount()`, `fsmount()`, and `move_mount()` return `-EPERM`, so a brought-in image cannot be attached. HeartSuite startup and setup do not mount EROFS.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45957

**Status**: Not exploitable
**Component**: RCU preemptible tree (`CONFIG_PREEMPT_RCU`, `CONFIG_TREE_RCU`); documented trigger is ftrace softirq stack tracing (`CONFIG_FTRACE`, `CONFIG_TRACING`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H) — NVD
**Score on Root Lock**: 0.0 — the deadloop requires ftrace softirq events with stack traces; no tracing program and no tracefs write grant are in the allowlist
**Affected range**: Linux 5.8 through 6.6.127, 6.7–6.12.74, 6.13–6.18.13, and 6.19–6.19.3. **5.19.6 and 6.18.9-hs are both in range.** Fixed in 6.6.128, 6.12.75, 6.18.14, 6.19.4, and 7.0
**Upstream fix**: `d41e37f26b31` (mainline); stable 6.18.14+

This CVE describes an infinite recursion in `rcu_read_unlock_special()`. After commit `5f5fa7ea89dc` removed recursion protection from `__rcu_read_unlock()`, that function can call `raise_softirq_irqoff(RCU_SOFTIRQ)` without a pending-work flag. When ftrace is recording the softirq raise and walking the stack, the unwind re-enters `rcu_read_unlock_special()` and the CPU deadloops. The impact is a local denial of service. The path does not escalate to root.

`CONFIG_PREEMPT_RCU=y`, `CONFIG_TREE_RCU=y`, `CONFIG_FTRACE=y`, and `CONFIG_TRACING=y` are compiled in on both fielded kernels. That is not enough. The deadloop is not the ordinary RCU unlock path. It requires the irq/softirq tracepoints to be armed with stack traces. Those controls live under `/sys/kernel/tracing/`. Enabling them takes a tracing program (`trace-cmd`, `perf`) or a write to that filesystem. None of those programs appear in the allowlist. Default allowlist directory grants are `/usr/lib` and `/etc` only. File-open write checks refuse any other path. An attacker who has already gained root cannot add a tracer: Lockdown returns `EPERM` for `FS_IOC_SETFLAGS`, `mount()`, `fsmount()`, and `move_mount()`, so the allowlist cannot be expanded and a bind-mount cannot cover `/sys/kernel/tracing/`.

The trigger cannot be reached on any default Root Lock deployment.

If your deployment adds `trace-cmd`, `perf`, or a program that writes `/sys/kernel/tracing/` to the allowlist, treat this CVE as Affected at 7.1 HIGH for availability.

### CVE-2026-46033

**Status**: 5.19.6 Not exploitable — feature not compiled; 6.18.9-hs Not exploitable — tool not in the program allowlist
**Component**: IPsec authencesn (`CONFIG_CRYPTO_AUTHENC`)
**Base Score**: 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile the AF_ALG AEAD interface the bug uses; 6.18.9-hs compiles that interface as a module and HeartSuite APO does not include the programs that load it

authencesn requires a zero authsize or an authsize of at least 4 bytes because the ESN encrypt and decrypt paths always move 4 bytes of high-order sequence number at the end of the authenticated data. Instance creation copied the inner ahash digest size into the default authsize without rejecting the invalid 1..3 range. Binding that instance through AF_ALG then ran the ESN tail handling with a too-short tag and hit an out-of-bounds read.

Both Root Lock kernels are in the NVD range (Linux 4.11 through 6.18.26) and compile `crypto/authencesn.c` via `CONFIG_CRYPTO_AUTHENC`. The unprivileged trigger is AF_ALG (`CONFIG_CRYPTO_USER_API_AEAD`) after instantiating authencesn with a 1..3-byte ahash such as `cbcmac(cipher_null)` from the CCM template. 5.19.6 has `CONFIG_CRYPTO_USER_API_AEAD` and `CONFIG_CRYPTO_USER` not set, so that userspace crypto path is not present. 6.18.9-hs builds AF_ALG AEAD, authenc, CCM, and IPsec ESP as modules. Reaching the path requires those modules to be loaded. HeartSuite APO does not include `modprobe`, `insmod`, `ip`, `setkey`, or IPsec daemons. Module autoload also runs `modprobe` and is refused.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46045

**Status:** Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs
**Component:** MD last-level bitmap (`CONFIG_MD_LLBITMAP`)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 0.0 — CONFIG_MD_LLBITMAP is not compiled; 5.19.6 is outside the affected range

The bug is in md-llbitmap page reads: the code picks the first assigned non-faulty rdev without checking In_sync, so bitmap pages can be read from a spare still being rebuilt. That path exists only in drivers/md/md-llbitmap.c under CONFIG_MD_LLBITMAP.

NVD lists Linux 6.18 through 6.18.26 and 6.19 through 7.0.3. HeartSuite 5.19.6 is outside that range and the option is not present. HeartSuite 6.18.9-hs is in range and has `# CONFIG_MD_LLBITMAP is not set`. Classic MD bitmap (`CONFIG_MD_BITMAP`) is a different file and is not this bug.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46130

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: dm-verity forward error correction (`CONFIG_DM_VERITY`, `CONFIG_DM_VERITY_FEC`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and does not compile dm-verity; on 6.18.9-hs the FEC decode path requires veritysetup or dmsetup, which are not on the allowlist
**Affected range**: NVD: 6.1.125 through 6.2; 6.6.72 through 6.7; 6.12.10 through 6.13; 6.13 through 7.0.6 (first 6.18 fix is 6.18.42). **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.42
**Upstream fix**: `430a05cb926f6bdf53e81460a2c3a553257f3f61` (mainline 7.1-rc1); stable 6.18.42, 7.0.7

This CVE describes an out-of-bounds read in `fec_decode_bufs()`. The decoder assumes the first Reed-Solomon codeword's parity bytes never split across parity blocks. For non-default `fec_roots` values and a reduced buffer count, that assumption is false and the walk reads past the parity block buffer. Integrity impact is none. The bug does not grant root.

On 5.19.6-HeartSuite-2.0, `# CONFIG_DM_VERITY is not set`. `CONFIG_DM_VERITY_FEC` has no line. `drivers/md/dm-verity-fec.c` is not compiled.

On 6.18.9-hs, `CONFIG_DM_VERITY=m` and `CONFIG_DM_VERITY_FEC=y`. That is not enough. The decode path runs only after a verity target with FEC is mapped and a hash verification failure enters FEC recovery. Creating that mapping requires `veritysetup` or `dmsetup`. Loading the module requires `modprobe`. None of those programs are on the HeartSuite allowlist. No default Root Lock deployment mounts a verity+FEC volume. the program allowlist refuses to execute the missing tools. Under Lockdown the allowlist cannot be changed.

The trigger cannot be reached on any Root Lock deployment.

If a 6.18.9-hs deployment adds `veritysetup` or `dmsetup` and a way to load `dm-verity` to the allowlist, treat this CVE as Affected at 7.1 HIGH for confidentiality and availability only.

### CVE-2026-46136

**Status:** Not exploitable — hardware absent (6.18.9-hs); Not Affected (5.19.6)
**Component:** MediaTek mt76 mt7921 Wi-Fi (`CONFIG_MT7921E`, `CONFIG_MT7921U`)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 0.0 — the trigger requires a MediaTek MT7921 Wi-Fi adapter. Root Lock servers do not present that hardware. On 5.19.6 the driver is not compiled and the kernel version is outside the NVD range.

The bug is a CLC (country power table) buffer-length underflow in the mt7921 MCU path. An undersized CLC blob wraps `buf_len` and either loops until the driver fails to initialize or applies an invalid power setting.

HeartSuite 6.18.9-hs builds `mt7921e` and `mt7921u` as modules. Those modules attach only when MT7921 PCIe or USB hardware is present. HeartSuite servers have no such adapter, so the CLC path is never entered.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46162

**CVE-2026-46162**

**Status:** 5.19.6-HeartSuite-2.0: Not Affected. 6.18.9-hs: Not exploitable — tool not in the program allowlist.

**Component:** Intel ice Ethernet driver, `ice_sf_eth_activate()` (`drivers/net/ethernet/intel/ice/ice_sf_eth.c`). Config gate: `# CONFIG_ICE is not set` on 5.19.6-HeartSuite-2.0; `CONFIG_ICE=m` with `CONFIG_ICE_SWITCHDEV=y` on 6.18.9-hs.

**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)

**Score on Root Lock:** 0.0. 5.19.6 is outside the NVD range (the Scalable Function path was added in 6.12) and the ice driver is not compiled. On 6.18.9 the ice module is compiled, but the double-free runs only when userspace activates an Intel Ethernet 800 Series Scalable Function. That path is `devlink port add … flavour pcisf` followed by `devlink port function set … state active` after switchdev mode is enabled. `devlink` and `ip` are not on the HeartSuite default allowlist, so the program allowlist refuses to execute them. Lockdown keeps that allowlist immutable for the boot.

The bug is a double free on the ice Scalable Function activate error path. When `auxiliary_device_add()` fails, `ice_sf_eth_activate()` calls `auxiliary_device_uninit()`, the device release callback frees `sf_dev`, and the error path then frees the same object again. NVD lists Linux 6.12 through 6.12.87, 6.13 through 6.18.29, and 6.19 through 7.0.6.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46180

**Status**: Not exploitable
**Component**: Broadcom FullMAC WiFi driver (`CONFIG_BRCMFMAC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — Broadcom FullMAC WiFi hardware absent

In `drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c`, `brcmf_sdio_bus_stop()` and `brcmf_sdio_remove()` send `SIGTERM` to the SDIO watchdog kthread and then call `kthread_stop()` on the same `task_struct`. If the kthread exits between those two calls, `kthread_stop()` uses a freed task. The fix takes a reference with `get_task_struct()` and switches the stop to `kthread_stop_put()`.

HeartSuite 5.19.6 does not compile `CONFIG_BRCMFMAC`. HeartSuite 6.18.9 compiles `CONFIG_BRCMFMAC=m` with `CONFIG_BRCMFMAC_SDIO=y`. The watchdog kthread exists only after a Broadcom FullMAC SDIO device probes. No such NIC is present on a Root Lock server.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46234

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: vsock (`CONFIG_VSOCKETS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile AF_VSOCK; 6.18.9-hs ships vsock as modules that cannot be loaded because modprobe, insmod, and kmod are not on the allowlist
**Affected range**: Linux 5.5–5.10.257, 5.11–5.15.208, 5.16–6.1.174, 6.2–6.6.139, 6.7–6.12.89, 6.13–6.18.31, 6.19–7.0.8. Both 5.19.6 and 6.18.9-hs are in range. Fixed in 6.18.32+ and 6.1.175+
**Upstream fix**: stable 6.18.32+ / 6.1.175+

This CVE describes inverted buffer-size clamping in `vsock_update_buffer_size()`. The function clamped to the maximum first and then to the minimum. Setting a minimum larger than the maximum let `vsk->buffer_size` grow past `vsk->buffer_max_size` and broke the intended socket memory bound. NVD classifies that as CWE-787.

On 5.19.6, `# CONFIG_VSOCKETS is not set`. The AF_VSOCK family is not in the kernel.

On 6.18.9-hs, `CONFIG_VSOCKETS=m` with loopback, virtio, VMware VMCI, vsockmon, and vhost_vsock also `=m`. Reaching the path requires the vsock family to be registered and a process to open an AF_VSOCK socket and call setsockopt. The installer and startup scripts do not load vsock. The allowlist has no vsock, qemu, or socat program, and no modprobe, insmod, or kmod. Kernel autoload of the `net-pf-40` family also execs modprobe and is refused. Under Lockdown, `FS_IOC_SETFLAGS` returns `EPERM`, so those programs cannot be added.

The network hook at connect() and sendto() does not fire on socket() or setsockopt. That does not change the result: the vsock family is not registered.

The trigger cannot be reached on any Root Lock deployment.

If a 6.18.9-hs deployment loads `vsock.ko` and an allowlisted program creates AF_VSOCK sockets, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-46294

**Status**: Not exploitable — tool not in the program allowlist
**Component**: Device mapper ioctl (`CONFIG_BLK_DEV_DM=y` on 5.19.6; `CONFIG_BLK_DEV_DM=m` on 6.18.9-hs)
**Base Score**: 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — both kernels compile device mapper; HeartSuite APO does not include the programs that issue device-mapper ioctls
**Affected range**: Linux 2.6.12.1 through 5.10.257; 5.11 through 5.15.208; 5.16 through 6.1.174; 6.2 through 6.6.139; 6.7 through 6.12.87; 6.13 through 6.18.29; 6.19 through 7.0.6. Both HeartSuite production kernels sit in that window.
**Upstream fix**: bounds check after `align_ptr()` in `retrieve_status()` (`drivers/md/dm-ioctl.c`); stable 6.18.30+

The bug is a buffer overflow in `retrieve_status()`. The function writes a status string, then aligns the output pointer to the next 8-byte boundary without checking that the aligned pointer stays inside the buffer. The next loop iteration computes `remaining = len - (outptr - outbuf)`. When `outptr` is past the buffer, that subtraction wraps and the write goes out of bounds.

NVD scores the overflow as a local path to high impact. The kernel description states that only root can issue device-mapper ioctls, and that libdevmapper uses an 8-byte-aligned buffer so the alignment step does not overshoot on the ordinary library path. Reaching the overflow therefore requires a program that opens `/dev/mapper/control` and issues a device-mapper ioctl with an output buffer that is not 8-byte aligned.

On 5.19.6, `CONFIG_BLK_DEV_DM=y`. `retrieve_status`, `ctl_ioctl`, and `dm_ctl_ioctl` are in the running image.

On 6.18.9-hs, `CONFIG_BLK_DEV_DM=m`. The ioctl path is not in vmlinux. Loading the module requires `modprobe`/`insmod`/`kmod`, which are not on the allowlist.

`dmsetup`, LVM (`lvcreate`, `lvchange`, `vgchange`, `pvcreate`), `cryptsetup`, `kpartx`, `multipath`, and `dmeventd` are not on the allowlist. Lockdown refuses `FS_IOC_SETFLAGS`, so the allowlist cannot be extended to add them. The ioctl path is never reached.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46309

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: Intel Xe DRM driver — xe_vm_madvise_ioctl PAT coherency (`CONFIG_DRM_XE`)
**Base Score**: 7.0 HIGH (AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and has no Xe driver; on 6.18.9-hs the trigger requires Intel Xe GPU hardware that is not present
**Affected range**: Linux 6.18 through 6.18.31; 6.19 through 7.0.8; 7.1-rc1. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.32
**Upstream fix**: 6.18.32; 7.0.9; 7.1

This CVE describes a missing validation in `xe_vm_madvise_ioctl()`. A local caller can apply a PAT index with `XE_COH_NONE` coherency to CPU-cached memory. The kernel page-clear then stays dirty in the CPU cache. An Intel Xe iGPU using that PAT index bypasses the CPU caches and reads stale DRAM, disclosing contents of previously freed pages from other processes.

`CONFIG_DRM_XE` does not exist on 5.19.6-HeartSuite-2.0. The Xe driver and `xe_vm_madvise.c` are not in that kernel. NVD marks every release before 6.18 unaffected.

On 6.18.9-hs, `CONFIG_DRM_XE=m`. Reaching `xe_vm_madvise_ioctl()` requires a bound Intel Xe GPU and a DRM device node. No Intel Xe iGPU or discrete Xe GPU is present on a standard HeartSuite server deployment. Without that hardware the module does not bind, Xe DRM nodes are not created, and the ioctl is not reachable.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-52962

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: CephFS setxattr (`CONFIG_CEPH_FS`, `CONFIG_CEPH_LIB`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — NVD; Red Hat 5.5 (AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile CephFS; 6.18.9-hs ships Ceph as an unloaded module and no allowlisted program mounts CephFS or loads that module
**Affected range**: NVD: 5.3.1 through 5.10.258; 5.11 through 5.15.209; 5.16 through 6.1.175; 6.2 through 6.6.141; 6.7 through 6.12.91; 6.13 through 6.18.33; 6.19 through 7.0.10. Both HeartSuite production kernels sit in that window until the config and load gates apply.
**Upstream fix**: 5d3cc36b4e77 (mainline); stable 6.18.33+

This CVE describes a buffer leak in `__ceph_setxattr()`. On the retry path, `old_blob` can hold `ci->i_xattrs.prealloc_blob`. Taking the `do_sync` path then skips `ceph_buffer_put(old_blob)`, so the prior allocation is never released. That is a kernel memory leak. It is not a write primitive.

On 5.19.6, `# CONFIG_CEPH_FS is not set` and `# CONFIG_CEPH_LIB is not set`. The 5.19.6 System.map has no Ceph symbols. `__ceph_setxattr` is not in the running image.

On 6.18.9-hs, `CONFIG_CEPH_FS=m` and `CONFIG_CEPH_LIB=m`. The filesystem is not built in. The 6.18.9-hs System.map has no Ceph symbols. Reaching `__ceph_setxattr` requires a mounted CephFS volume. That state requires loading `ceph.ko` and the Ceph userspace (`mount.ceph`, `ceph`). Those programs are not on the HeartSuite allowlist. `modprobe`, `kmod`, and `insmod` are not on the allowlist, so the module is not loaded. `mount` is on the allowlist; it cannot load the Ceph module or run `mount.ceph`.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53059

Status: Not exploitable — tool not in the program allowlist
Component: Device-mapper dirty log (CONFIG_BLK_DEV_DM, CONFIG_DM_MIRROR)
Base Score: 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
Score on Root Lock: 0.0

The bug is an integer overflow in the device-mapper dirty log. A 64-bit region count is truncated to 32 bits, the log bitsets are allocated too small, and later bit operations write out of bounds in kernel heap. The trigger is creating a device-mapper mirror whose region count overflows UINT_MAX. That requires dmsetup (or LVM). HeartSuite APO does not ship dmsetup or LVM; the attack surface is not reachable.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53089

**Status**: Not exploitable — feature not compiled
**Component**: BPF offload map/prog info fill (`CONFIG_BPF_SYSCALL`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — `CONFIG_BPF_SYSCALL` is not compiled; `bpf()` returns `ENOSYS`

This CVE is a use-after-free in the BPF offload info-fill path. Querying information for an offloaded BPF map or program calls `get_net()` on the netdev network namespace while that namespace can already be tearing down, which increments a zero refcount.

`CONFIG_BPF_SYSCALL` is not compiled (`bpf()` returns `ENOSYS`). There is no verifier, no BPF program or map store, and no offload info-fill path.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53119

### CVE-2026-53120

**CVE-2026-53120**
**Status:** Affected — Lockdown limits post-exploitation
**Component:** PCI core driver_override (CONFIG_PCI=y, CONFIG_SYSFS=y on 5.19.6 and 6.18.9)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 7.5 (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/MC:H/MI:N/MA:H) — Modified Integrity None because the program allowlist refuses new programs and Lockdown blocks chattr and all three mount syscalls. Confidentiality High and Availability High remain (in-memory reads and crash).

The bug is a use-after-free in the PCI bus match path. When a driver is probed through __driver_attach(), match() runs without the device lock and reads the driver_override string while a concurrent write to /sys/bus/pci/devices/<addr>/driver_override can free it.

PCI is compiled in on both fielded kernels and is present on a standard server. The trigger is a write to that sysfs attribute plus a concurrent driver attach. Allowlisted shells, python3, and systemd can perform that write when they hold a write grant on the PCI sysfs node. The path is not a socket path.

**Lockdown.** Even if the use-after-free is turned into kernel execution and a root userspace, the program allowlist refuses every non-allowlisted program at exec. Lockdown returns -EPERM on FS_IOC_SETFLAGS, so immutable flags cannot be cleared, and returns -EPERM on mount, fsmount, and move_mount, so bind-mounts over sealed paths fail. The residual risks are in-memory data exfiltration and availability impact.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** The program allowlist refuses every non-allowlisted program at execve, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2026-53129

**Status:** Affected — Lockdown limits post-exploitation
**Component:** fs/mbcache (`CONFIG_FS_MBCACHE=y` and `CONFIG_EXT4_FS=y` on 5.19.6-HeartSuite-2.0; `CONFIG_FS_MBCACHE=m` and `CONFIG_EXT4_FS=m` on 6.18.9-hs)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 6.1 — Modified Confidentiality Low, Integrity None (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/MC:L/MI:N/MA:H). Lockdown refuses `FS_IOC_SETFLAGS` and all three mount syscalls, so a kernel use-after-free that reaches root cannot persist or remount. Availability stays High: a crash is residual. In-memory reads remain.

`mb_cache_destroy()` tears down the ext4 extended-attribute cache without canceling pending shrink work. If entry creation already scheduled that work, the worker touches the cache after free. The trigger is the last put of a mounted ext4 volume — `umount` of that volume, or teardown at reboot. Both fielded kernels ship the code. `mount` and `umount` are on the HeartSuite allowlist. Lockdown refuses new mounts; it does not refuse `umount`. An already-mounted extra ext4 volume, or the last put of root ext4 at reboot, still reaches destroy.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** The program allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

### CVE-2026-53136

**Status**: 5.19.6: Not exploitable — feature not compiled. 6.18.9: Not exploitable — hardware absent.
**Component**: AMD display BIOS parser (`CONFIG_DRM_AMDGPU`, `CONFIG_DRM_AMD_DC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — AMD GPU driver not compiled on 5.19.6; AMD GPU hardware absent on 6.18.9

The bug is an out-of-bounds heap write in the AMD display BIOS parser. Unvalidated VBIOS HDMI retimer register counts are used as loop bounds when copying retimer I2C settings into fixed-size arrays during driver probe.

On 5.19.6 `CONFIG_DRM_AMDGPU` is not set, so the parser is not in the image. On 6.18.9 `CONFIG_DRM_AMDGPU=m` and `CONFIG_DRM_AMD_DC=y`, so the parser is in the amdgpu module. Probe runs only when an AMD GPU presents a VBIOS integrated-info table. That hardware is not present on a Root Lock server deployment.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53137

**Status:** Not exploitable — hardware absent (6.18.9-hs); Not exploitable — feature not compiled (5.19.6)
**Component:** drm/amd/display HDMI HDCP 2.x (`CONFIG_DRM_AMDGPU=m`, `CONFIG_DRM_AMD_DC=y` on 6.18.9-hs; `# CONFIG_DRM_AMDGPU is not set` on 5.19.6)
**Base Score:** 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 0.0

The bug is an unclamped I2C read in `mod_hdcp_read_rx_id_list()` during HDMI HDCP 2.x repeater authentication. The driver takes a 10-bit message size from the sink RxStatus register and uses it as the read length into `rx_id_list[177]`. A malicious HDMI repeater that advertises a size larger than the buffer overruns the destination.

HeartSuite 5.19.6 does not compile the AMD GPU driver. HeartSuite 6.18.9 compiles the AMD display engine as a module, but the trigger requires an AMD GPU HDMI port attached to a malicious HDCP 2.x repeater. That hardware is not present on a Root Lock deployment.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53138

**Status**: Not exploitable — hardware absent (6.18.9-hs); Not exploitable — feature not compiled (5.19.6)
**Component**: AMD display / amdgpu (`CONFIG_DRM_AMDGPU`, `CONFIG_DRM_AMD_DC`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile amdgpu; 6.18.9-hs compiles it as a module and the VBIOS parser runs only when an AMD GPU is probed
**Affected range**: Linux 4.15 through 6.18.35 (6.18 stable fixed in 6.18.36). Both HeartSuite production kernels sit in that window until the config and hardware gates apply.
**Upstream fix**: 6.18.36+ (bound every VBIOS record-chain walk to BIOS_MAX_NUM_RECORD)

This bug is an unbounded walk of the AMD VBIOS record chain in `bios_parser.c` and `bios_parser2.c`. The loops stop only on a 0xFF record-type sentinel or a zero record size. A malformed VBIOS image that omits the terminator is walked without a cap at amdgpu probe, and the last steps can read past the image.

On 5.19.6, `# CONFIG_DRM_AMDGPU is not set`. The display parser is not in the kernel.

On 6.18.9-hs, `CONFIG_DRM_AMDGPU=m` and `CONFIG_DRM_AMD_DC=y`. The drop ships `amdgpu.ko`. The installer extracts modules and runs depmod; startup does not load amdgpu. The parser runs only when amdgpu binds to an AMD GPU. A headless Root Lock server has no AMD display GPU, so the probe path is not reached.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53143

### CVE-2026-53149

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs
**Component**: Thunderbolt / USB4 property parser (`CONFIG_USB4`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H) — NVD
**Score on Root Lock**: 0.0 — 5.19.6 does not compile `CONFIG_USB4`; on 6.18.9-hs the parser runs only after a USB4/Thunderbolt host controller enumerates a device, and that hardware is absent
**Affected range**: Linux 4.15 through 6.18.35 (and later unfixed stables). Both fielded kernels sit in NVD windows: 5.19.6 in 5.16–6.1.175; 6.18.9-hs in 6.13–6.18.35. Fixed in 6.18.36+
**Upstream fix**: thunderbolt: Bound root directory content to block size

`__tb_property_parse_dir()` does not check that `content_offset + content_len` fits in `block_len` for the root directory. When `rootdir->length` is `block_len - 2` or larger, the entry loop reads past the allocated property block. The path runs when the kernel parses a Thunderbolt/USB4 device's root property directory after a controller enumerates a device.

On 5.19.6, `# CONFIG_USB4 is not set`. The Thunderbolt driver is not in that kernel.

On 6.18.9-hs, `CONFIG_USB4=m` is compiled. Parsing still requires a USB4/Thunderbolt host controller and a connected device that presents a property directory. Headless HeartSuite servers have no such controller. `CONFIG_USB4_DEBUGFS_WRITE` is not set, so there is no debugfs write path that can feed a crafted directory without hardware.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53233

**Status**: Not Affected on 5.19.6; Affected — Lockdown limits post-exploitation on 6.18.9
**Component**: netdev generic netlink RX bind (`CONFIG_NET_DEVMEM`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 on 5.19.6 — BIND_RX / `CONFIG_NET_DEVMEM` do not exist before Linux 6.12; 7.3 HIGH on 6.18.9 — Lockdown reduces MI: High→Low; C and A remain High
**Affected range**: Linux 6.12 through 6.12.93, 6.13 through 6.18.35, 6.19 through 7.0.12
**Upstream fix**: 6.12.94, 6.18.36, 7.0.13

The bug is a double-free in `netdev_nl_bind_rx_doit()`. After a successful dma-buf bind to NIC RX queues, `genlmsg_reply()` always consumes the reply skb. On a reply failure (full receive buffer) the error path called `nlmsg_free()` on that same skb and unbound the dma-buf. The kernel then frees already-freed memory.

`CONFIG_NET_DEVMEM` is not present on 5.19.6-HeartSuite-2.0. NVD marks every release below 6.12 unaffected. `netdev_nl_bind_rx_doit` is absent from that kernel’s System.map. The trigger cannot be reached on 5.19.6.

On 6.18.9-hs `CONFIG_NET_DEVMEM=y` and `netdev_nl_bind_rx_doit` is in the image. The command is `NETDEV_CMD_BIND_RX` on the netdev generic-netlink family (`GENL_ADMIN_PERM`). HeartSuite’s network hook fires at `connect()` and at `sendto()` with a destination address; it does not fire at netlink `sendmsg()`. A process that already holds `CAP_NET_ADMIN` issues the command directly. The bind succeeds only on a NIC that implements queue-management ops (mlx5, bnxt with the queue API, gve) with tcp-data-split enabled and a dma-buf fd (`CONFIG_UDMABUF=y`). Those drivers are compiled as modules and load when the NIC is present. virtio-net in 6.18.9 has no queue-management ops, so a virtio-only guest does not complete the bind; a host with mlx5, gve, or bnxt does.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** The program allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

These constraints are why the Score on Root Lock on 6.18.9 reflects a reduced MI (High→Low): root cannot clear immutable flags (`FS_IOC_SETFLAGS` returns `-EPERM`), cannot `mount` / `fsmount` / `move_mount`, and cannot add allowlist records. Confidentiality and Availability remain High. The double-free itself is kernel memory corruption and is outside the layer those API checks close. Residual risks are in-memory data exfiltration and availability impact.

### CVE-2026-53255

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: Bluetooth MGMT advertising TLV (`CONFIG_BT`)
**Base Score**: 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile Bluetooth; 6.18.9-hs ships the stack as an unloaded module and no allowlisted program sends MGMT_OP_ADD_ADVERTISING
**Affected range**: Linux 4.9 through 6.18.35 (6.18 stable fixed in 6.18.36). Both HeartSuite production kernels sit in that window until the config and load gates apply.
**Upstream fix**: stable 6.18.36+

This CVE describes a one-byte out-of-bounds read in `tlv_data_is_valid()`. The parser reads each advertising field length from `data[i]` and then inspects `data[i + 1]` for managed EIR types before proving the field still fits in the buffer. A malformed `MGMT_OP_ADD_ADVERTISING` request whose length byte is the last byte of the buffer reads one byte past the advertising data.

On 5.19.6, `# CONFIG_BT is not set`. The Bluetooth socket family, HCI layer, and MGMT parser are absent from the running kernel.

On 6.18.9-hs, `CONFIG_BT=m`. Reaching the parser requires the Bluetooth module to be loaded, a registered HCI controller, and a trusted MGMT command. `MGMT_OP_ADD_ADVERTISING` is not in the untrusted command set; the kernel refuses it without `CAP_NET_ADMIN`. HeartSuite APO does not include `bluetoothd`, `bluetoothctl`, `btmgmt`, or `modprobe`/`insmod`/`kmod`. Module autoload also runs `modprobe` and is refused. The MGMT advertising path is not reached.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-53272

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: EROFS compressed read (`CONFIG_EROFS_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) — NVD
**Score on Root Lock**: 0.0 — 5.19.6 does not compile EROFS; 6.18.9-hs builds EROFS as a module that is not in vmlinux and cannot be loaded because modprobe/insmod/kmod are not on the allowlist
**Affected range**: Linux 5.17 through 6.12.93, 6.13 through 6.18.35, 6.19 through 7.0.12, and 7.1-rc1–rc6. Both HeartSuite production kernels sit in that window until the config and load gates apply.
**Upstream fix**: 1aee05e814d2 (mainline); stable 6.12.94, 6.18.36, 7.0.13

This CVE describes a use-after-free on the EROFS superblock decompress flag. `z_erofs_endio()` calls `z_erofs_decompress_kickoff()`, which queues `z_erofs_decompressqueue_work()` and then writes the superblock after that queue. Once the work unlocks the folios, unmount can free the superblock before that write.

On 5.19.6, `# CONFIG_EROFS_FS is not set`. The decompress path is absent from the running kernel. System.map contains no erofs symbols.

On 6.18.9-hs, `CONFIG_EROFS_FS=m` with `CONFIG_EROFS_FS_ZIP=y`. The 6.18.9 `z_erofs_decompress_kickoff()` still writes the decompress flag after `queue_work`. The vmlinux System.map contains no erofs symbols. Startup does not load EROFS. Reaching the race requires a loaded erofs module and a mounted compressed EROFS volume that is then unmounted while I/O completes. The allowlist has no `modprobe`, `insmod`, `kmod`, `mkfs.erofs`, `fsck.erofs`, or `dump.erofs`. Module autoload execs `modprobe` and is refused. Under Lockdown, `FS_IOC_SETFLAGS` returns `EPERM`, so those programs cannot be added, and `mount()`, `fsmount()`, and `move_mount()` return `EPERM`, so a new EROFS volume cannot be mounted.

The trigger cannot be reached on any default Root Lock deployment.

If a 6.18.9-hs deployment loads erofs and mounts a compressed EROFS volume, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-53286

**Status**: Not Affected on 5.19.6; Not exploitable — hardware absent on 6.18.9-hs
**Component**: Intel IDPF ethernet driver — IDC auxiliary device plug (`CONFIG_IDPF`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and has no IDPF driver; 6.18.9-hs has no Intel IDPF/IPU/E830 device, so the aux-device error path is never reached
**Affected range**: 6.17 through 6.18.32; 6.19 through 7.0.9; 7.1-rc1 through 7.1-rc3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.33
**Upstream fix**: 6.18.33, 7.0.10, 7.1

This CVE describes a double-free and use-after-free in the Intel IDPF driver's IDC auxiliary-device error paths in `drivers/net/ethernet/intel/idpf/idpf_idc.c`. When `auxiliary_device_add()` fails in `idpf_plug_vport_aux_dev()` or `idpf_plug_core_aux_dev()`, the `err_aux_dev_add` label calls `auxiliary_device_uninit()` and falls through to `err_aux_dev_init`. Uninit runs the release callback that frees `iadev`. The fall-through then reads `adev->id` from the freed object for `ida_free()` and double-frees `iadev` with `kfree()`.

On 5.19.6 the IDPF Kconfig symbol does not exist. The Intel ethernet block ends at IGC. NVD lists versions before 6.17 as unaffected.

On 6.18.9-hs `CONFIG_IDPF=m`. The 6.18.9 `idpf_idc.c` still has the fall-through. Those functions run only after the idpf driver probes an Intel Infrastructure Data Path Function PCI device (Intel IPU / Ethernet Controller E830 PF or VF) and IDC RDMA initialization plugs the core or vport auxiliary device. A standard Root Lock server has no such device. Without the PCI device the driver does not probe, the plug functions are not called, and the error path is not reached.

The trigger cannot be reached on any Root Lock deployment.

If a 6.18.9-hs deployment attaches an Intel IDPF/IPU/E830 device, treat this CVE as Affected at 7.8 HIGH and apply the standard backstop.

### CVE-2026-53303

### CVE-2026-53330

### CVE-2026-53346

**Status:** Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs
**Component:** rust arm64 unwind tables (`CONFIG_RUST`, `CONFIG_UNWIND_TABLES`, `CONFIG_UNWIND_PATCH_PAC_INTO_SCS`)
**Base Score:** 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock:** 0.0 — 5.19.6 is outside the NVD range; 6.18.9-hs is an x86_64 image and does not compile Rust kernel code or ARM64 unwind-table patching
**Affected range:** Linux 6.12 through 6.12.93; 6.13 through 6.18.35; 6.19 through 7.0.12; 7.1-rc1 through 7.1-rc6. **5.19.6 is not in range.** Production **6.18.9-hs** is in range until base ≥ 6.18.36
**Upstream fix:** 6.12.94, 6.18.36, 7.0.13, 7.1

The bug is a rustc missing `uwtable` LLVM module flag on arm64. `-Cforce-unwind-tables=y` annotates functions but not the module, so compiler-generated functions such as `asan.module_ctor` have no uwtable. With `CONFIG_UNWIND_PATCH_PAC_INTO_SCS` the SCS boot patcher patches `paciasp` and skips `autiasp`. The kernel then crashes in `do_ctors()` / `do_basic_setup` during boot.

Both production configs are `Linux/x86` with `CONFIG_X86_64=y`. Neither file contains `CONFIG_RUST`, `CONFIG_ARM64`, `CONFIG_UNWIND_TABLES`, or `CONFIG_UNWIND_PATCH_PAC_INTO_SCS`. 6.18.9-hs has `CONFIG_HAVE_RUST=y` and `CONFIG_RUSTC_VERSION=0`; rustc is not present and `CONFIG_RUST` is not enabled. Both have `# CONFIG_KASAN is not set`. The path lives in `arch/arm64/Makefile` and is not in the x86 image.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64186

**Status:** Not Affected on 5.19.6; Not exploitable — feature not compiled on 6.18.9-hs
**Component:** AMD IOMMU debugfs (`CONFIG_AMD_IOMMU_DEBUGFS`, `CONFIG_IOMMU_DEBUGFS`)
**Base Score:** 7.1 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock:** 0.0 — AMD IOMMU debugfs is not compiled; `iommu_mmio_write` and `iommu_capability_write` are absent
**Affected range:** Linux 6.17 through 6.18.33; 6.19 through 7.0.10; 7.1-rc1 through 7.1-rc3. 5.19.6 is not in range. Fixed in 6.18.34+ and 7.0.11+

The bug is a signed/unsigned mismatch in AMD IOMMU debugfs. `iommu_mmio_write()` and `iommu_capability_write()` store a user-supplied offset in an `int` after parsing it with `kstrtou32_from_user()`. A large value becomes negative and can be used as an out-of-bounds index.

`drivers/iommu/amd/debugfs.c` is compiled only when `CONFIG_AMD_IOMMU_DEBUGFS` is enabled. That option depends on `CONFIG_IOMMU_DEBUGFS`. Both production configs have `# CONFIG_IOMMU_DEBUGFS is not set` and no `CONFIG_AMD_IOMMU_DEBUGFS` line. `CONFIG_AMD_IOMMU=y` builds the IOMMU driver; it does not build the debugfs write handlers.

5.19.6 is outside the NVD range (the write handlers landed in 6.17). The 5.19 `debugfs.c` has no `iommu_mmio_write` or `iommu_capability_write`. 6.18.9-hs is inside 6.17–6.18.33. The 6.18.9-hs System.map contains none of `iommu_mmio_write`, `iommu_capability_write`, or `amd_iommu_debugfs`.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64237

**Status**: Not exploitable
**Component**: Elan I2C touchpad (`CONFIG_MOUSE_ELAN_I2C`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — Elan I2C touchpad hardware absent; 5.19.6 does not compile the driver

The elan_i2c firmware updater indexes the firmware blob at a signature address derived from a page count, then walks those pages, without checking that the blob is large enough. A truncated firmware file produces an out-of-bounds read. The trigger is a write to the driver's `update_fw` sysfs attribute after the I2C client has probed.

`CONFIG_MOUSE_ELAN_I2C` is not set on HeartSuite 5.19.6. On HeartSuite 6.18.9 it is built as a module. The driver is the Elan I2C/SMBus laptop touchpad. Root Lock runs on headless server hardware with no Elan I2C touchpad, so the probe never binds and the firmware parser is never reached.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64245

**Status**: Not Affected on 5.19.6; Not exploitable on 6.18.9-hs
**Component**: fbdev mode database (`CONFIG_FB`, `CONFIG_FB_MODE_HELPERS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and framebuffer support is not compiled; on 6.18.9-hs `fb_find_mode()` is compiled in but no allowlisted program can load a driver that calls it
**Affected range**: 6.4 through 6.6.143; 6.7 through 6.12.94; 6.13 through 6.18.37 (includes 6.18.9); 6.19 through 7.1.2. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until base ≥ 6.18.38
**Upstream fix**: `85b6256469ce` (mainline 7.2); stable 6.6.144, 6.12.95, 6.18.38, 7.1.3

This CVE describes a use-after-free in `fb_find_mode()`. When the caller passes a NULL mode string the function copies the kernel `video=` option into a heap buffer, frees that buffer at the parse-done label, and then still compares the freed string against the mode database.

`# CONFIG_FB is not set` on 5.19.6-HeartSuite-2.0. The introducing change is 6.4. 5.19.6 predates it and does not compile fbdev.

On 6.18.9-hs, `CONFIG_FB=y` and `CONFIG_FB_MODE_HELPERS=y`. That is not enough. The built-in framebuffer drivers (`CONFIG_FB_EFI`, `CONFIG_FB_VESA`, `CONFIG_FB_SIMPLE`) register firmware-supplied timings and do not call `fb_find_mode()`. The generic `/dev/fb*` mode ioctl uses `fb_set_var()`, which also does not call `fb_find_mode()`. The remaining callers are modular legacy or virtual framebuffer drivers. Loading those drivers requires `modprobe` or `insmod`. Those programs, and `fbset`, are not in the HeartSuite allowlist. the program allowlist refuses to execute them. Under Lockdown the allowlist is immutable, so root cannot add them.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2025-71306

**Status**: Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: IMA exec appraisal (`CONFIG_IMA`, `CONFIG_IMA_APPRAISE`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the NVD range and builds without IMA; 6.18.9 compiles IMA but the exec appraisal path is not armed and cannot be armed from the allowlist
**Affected range**: Linux 6.14 through 6.19.3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until the IMA policy gate applies.
**Upstream fix**: 6.19.4+

The bug is a stack out-of-bounds read when IMA appraises an exec. `is_bprm_creds_for_exec()` is reached only from `ima_appraise_measurement()` on a BPRM_CHECK policy rule.

HeartSuite 5.19.6 is outside that range and has `# CONFIG_IMA is not set`.

HeartSuite 6.18.9 is inside the range and compiles `CONFIG_IMA=y` and `CONFIG_IMA_APPRAISE=y`. `process_measurement()` returns immediately when no IMA policy is loaded. The 6.18 default policy is empty unless a boot parameter (`ima_policy=`, `ima_appraise_tcb`, `ima_tcb`) or a write to the IMA policy file installs an APPRAISE rule that covers exec. HeartSuite install and startup do not set those boot parameters. Architecture Secure Boot rules appraise modules, kexec, and policy — not exec. IMA policy utilities are not on the allowlist, and no allowlisted program is granted write access to the IMA policy file. Under Lockdown the allowlist is immutable.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-45998

**Status**: Not Affected on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: RxRPC (`CONFIG_AF_RXRPC`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the NVD range and does not compile AF_RXRPC; 6.18.9-hs compiles AF_RXRPC as a module, and the programs that load or use that module are not on the allowlist
**Affected range**: Linux 6.2 through 6.6.139; 6.7 through 6.12.85; 6.13 through 6.18.26; 6.19 through 7.0.3. **5.19.6 is not in range.** Production **6.18.9-hs** remains in range until the module is loaded.
**Upstream fix**: 6.6.140, 6.12.86, 6.18.27, 7.0.4

This CVE describes a use-after-free after `skb_unshare()` fails in `rxrpc_input_packet()`. Allocation failure NULLs the skb in `rxrpc_io_thread()`, and a later trace helper then oopses on the stale pointer.

5.19.6 predates the introduction and is built with `# CONFIG_AF_RXRPC is not set`. 6.18.9-hs is in range and is built with `CONFIG_AF_RXRPC=m`.

Reaching the bug requires the RxRPC family to be registered so inbound packets hit `rxrpc_input_packet()`. On 6.18.9-hs the family is a module. Opening `socket(AF_RXRPC)` asks the kernel to autoload the protocol family; that autoload executes `modprobe`, which has no allowlist record and is refused. AFS clients and RxRPC userspace programs are also absent from the allowlist. The fielded kernel image has no rxrpc symbols, so the stack is not built in and is not loaded at boot.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-46191

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: framebuffer console rotation (`CONFIG_FRAMEBUFFER_CONSOLE`, `CONFIG_FRAMEBUFFER_CONSOLE_ROTATION`)
**Base Score**: 7.1 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 does not compile framebuffer support; 6.18.9-hs compiles fbcon rotation, but no allowlisted program can request rotation
**Affected range**: Linux 2.6.15 through 6.6.139; 6.7 through 6.12.89; 6.13 through 6.18.31; 6.19 through 7.0.6. Both HeartSuite production kernels sit in that window.
**Upstream fix**: 6.6.140, 6.12.90, 6.18.32, 7.0.7, 7.1

This CVE describes an out-of-bounds font-buffer access in `fbcon_rotate_font()`. When reallocation of the rotated font buffer fails, the old buffer is kept. Printing a high character code to the rotated console overflows that buffer. Integrity impact is none.

On 5.19.6, `# CONFIG_FB is not set`. Framebuffer console rotation is not compiled. `fbcon_rotate_font` is absent from the production System.map.

On 6.18.9-hs, `CONFIG_FRAMEBUFFER_CONSOLE=y` and `CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y`. Rotation is requested by writing `/sys/class/graphics/fbcon/rotate` or `rotate_all`, or by the `fbcon=rotate:` boot option. The default rotation is unrotated. `con2fbmap`, `fbset`, `setfont`, and `fbterm` are not on the allowlist. Default allowlist directory grants do not cover that sysfs path. the program allowlist refuses to execute the missing tools. Under Lockdown the allowlist is immutable.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-52992

**Status**: Not exploitable — feature not compiled on 5.19.6; Affected on 6.18.9-hs — Lockdown limits post-exploitation
**Component**: ADFS filesystem (`CONFIG_ADFS_FS`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 7.3 HIGH on 6.18.9-hs — Lockdown reduces MI: High→Low (no allowlist modification, no persistence, no backdoors); C and A remain High. 0.0 on 5.19.6
**Affected range**: Linux 5.6 through 5.10.257; 5.11 through 5.15.208; 5.16 through 6.1.174; 6.2 through 6.6.140; 6.7 through 6.12.90; 6.13 through 6.18.32; 6.19 through 7.0.9. Both HeartSuite production kernels sit in that window. Fixed in 6.18.33+.
**Upstream fix**: `dd9d3e16c2d5` (mainline); stable 6.18.33+

This CVE describes an out-of-bounds write when mounting a crafted ADFS image. `adfs_validate_bblk()` accepted a disc record with `nzones == 0`. `adfs_read_map()` then called `kmalloc_array(0, …)` and `adfs_map_layout()` wrote through `dm[-1]`. Old-format images already rejected a zero zone count. New-format images did not.

On 5.19.6, `# CONFIG_ADFS_FS is not set`. The helpers are not compiled.

On 6.18.9-hs, `CONFIG_ADFS_FS=m`. The installer unpacks the full module tarball into `/lib/modules`. That tarball contains `kernel/fs/adfs/adfs.ko.xz` (16 372 bytes, ELF x86-64 relocatable) and the `fs-adfs` alias. `MODULE_SIG=y` and `MODULE_SIG_ALL=y` sign that shipped module; `# CONFIG_MODULE_SIG_FORCE is not set` is irrelevant for this signed object. `python3` is on the allowlist and can load a shipped module. `mount` is on the allowlist. Autoload on `mount -t adfs` also resolves `fs-adfs` to that same file.

Lockdown returns `-EPERM` on `mount`, `fsmount`, and `move_mount`. It does not intercept `fsopen` or `fsconfig`. Creating the superblock (`vfs_get_tree` → `adfs_fill_super` → `adfs_validate_bblk`) still runs. The out-of-bounds write is reached before any attach check.

**Even with this CVE exploited to root, the attacker cannot run new code on this system.** The program allowlist refuses every non-allowlisted program at `execve`, including in the worst case where the attacker has cleared Lockdown. No persistence, no backdoors, no cross-reboot survival. ([How](/docs/security/#how-to-read-the-backstop-sections).)

A reboot is a clean slate. The attack does not survive it.

These constraints are why the Score on Root Lock on 6.18.9 reflects a reduced MI (High→Low): root cannot clear immutable flags, cannot `mount` / `fsmount` / `move_mount` of a new tree after the fact, and cannot add allowlist records. Confidentiality and Availability remain High. The out-of-bounds write itself is kernel memory corruption and is outside the layer those API checks close.

### CVE-2026-64239

Status: Not exploitable — feature not compiled
Component: mm/damon/sysfs-schemes (CONFIG_DAMON_SYSFS=y on 6.18.9-hs; # CONFIG_DAMON is not set on 5.19.6; # CONFIG_DEBUG_KOBJECT is not set and # CONFIG_DEBUG_OBJECTS is not set on both)
Base Score: 7.8 HIGH (CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
Score on Root Lock: 0.0 — the use-after-free is produced only when kobject release is delayed; that delay is CONFIG_DEBUG_KOBJECT_RELEASE, which HeartSuite does not compile.

Writing update_schemes_tried_regions to /sys/kernel/mm/damon/admin/kdamonds/<N>/state (mode 0600) clears DAMOS tried-region directories with damon_sysfs_scheme_regions_rm_dirs(), which puts each region kobject and leaves list_del to the release callback. If that callback is delayed, damos_sysfs_populate_region_dir() walks a list that still holds objects about to be freed.

On 5.19.6 DAMON is not compiled and the kernel predates the NVD window (affected from 6.2). On 6.18.9-hs the sysfs scheme code is present, but CONFIG_DEBUG_OBJECTS and CONFIG_DEBUG_KOBJECT are not set, so CONFIG_DEBUG_KOBJECT_RELEASE is not built.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64283

**Status:** Not exploitable — tool not in the program allowlist
**Component:** KVM guest_memfd (`CONFIG_KVM=m`, `CONFIG_KVM_GUEST_MEMFD=y` on 6.18.9-hs; `CONFIG_KVM` is not set on 5.19.6)
**Base Score:** 7.0 HIGH (CVSS:3.1/AV:L/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock:** 0.0

The bug is a signed overflow in guest_memfd memslot binding. KVM stored the binding offset and size as signed values. A large offset plus a legal size wraps to a negative sum, so the check against the guest_memfd file size accepts an offset that is outside the file.

guest_memfd exists from Linux 6.8. HeartSuite 5.19.6 predates the feature and does not compile host KVM. HeartSuite 6.18.9-hs compiles the feature into kvm.ko. Reaching the path requires a program that opens /dev/kvm, creates a VM, creates a guest_memfd, and binds a memslot with a wrapping offset. QEMU and other KVM front-ends are not on the allowlist. Lockdown refuses FS_IOC_SETFLAGS, so the allowlist cannot be extended to add them.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64531

**Status**: 5.19.6 Not Affected; 6.18.9-hs Not exploitable — tool not in the program allowlist
**Component**: Open vSwitch datapath (`CONFIG_OPENVSWITCH`)
**Base Score**: 7.8 HIGH (AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H)
**Score on Root Lock**: 0.0 — 5.19.6 is outside the affected range and does not compile Open vSwitch; 6.18.9-hs compiles the datapath as a module, and HeartSuite APO does not include the programs that load that module

Open vSwitch stores generated flow actions as Netlink attributes with a 16-bit length field. After the old 32 KiB action-stream cap was removed, a nested CLONE or conntrack action can be generated larger than 65,535 bytes. The stored length wraps, and a later dump or teardown walks attacker-controlled bytes as independent actions. On a kernel that has the datapath loaded and lets an unprivileged user hold `CAP_NET_ADMIN` in a network namespace, that is a local path to root.

5.19.6 predates the unbounded nested-action path and is built with `CONFIG_OPENVSWITCH` not set.

6.18.9-hs is in the NVD range (6.14 through 6.18.39) and builds `CONFIG_OPENVSWITCH=m` with conntrack and unprivileged user namespaces enabled. Reaching the bug still requires the `openvswitch` module to be loaded. HeartSuite APO does not include `modprobe`, `insmod`, `ovs-vswitchd`, or `ovs-vsctl`. Module autoload also runs `modprobe` and is refused. The datapath is not loaded on a standard Root Lock deployment, and it cannot be loaded after the allowlist is in force.

The trigger cannot be reached on any Root Lock deployment.

### CVE-2026-64564

**Status**: Not exploitable — feature not compiled on 5.19.6; Not exploitable — tool not in the program allowlist on 6.18.9-hs
**Component**: SCTP ASCONF DEL-IP (`CONFIG_IP_SCTP`)
**Base Score**: 9.8 CRITICAL (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H) — CNA (kernel.org); NVD assessment pending
**Score on Root Lock**: 0.0 — 5.19.6 does not compile SCTP; 6.18.9-hs ships sctp.ko as an unloaded module and no allowlisted program creates an SCTP endpoint
**Affected range**: Linux 2.6.25 through 6.18.41 (6.18 stable fixed in 6.18.42). Both HeartSuite production kernels sit in that window until the config and load gates apply.
**Upstream fix**: 9b2854f86f0b (mainline); stable 6.18.42+

This CVE describes a use-after-free in `sctp_process_asconf()`. A single ASCONF chunk can delete the transport the chunk is being processed against and then reuse that freed pointer as the association's primary and active path.

On 5.19.6, `# CONFIG_IP_SCTP is not set`. The SCTP protocol is absent from the running kernel. `sctp_process_asconf` is not in System.map and is not among the shipped modules.

On 6.18.9-hs, `CONFIG_IP_SCTP=m`. The drop ships `sctp.ko` (and `sctp_diag.ko`). The protocol is not built in. The installer extracts modules and runs depmod; it does not load SCTP. Startup does not load SCTP. No SCTP client or server is in the allowlist, and `modprobe`/`kmod`/`insmod` are not in the allowlist, so the module is not loaded. An inbound ASCONF never reaches `sctp_process_asconf` because the protocol is not registered.

The network hook at connect() and sendto() does not apply to inbound ASCONF processing. That does not change the result: the SCTP stack is not up.

The trigger cannot be reached on any default Root Lock deployment.

If a 6.18.9-hs deployment loads `sctp.ko` and runs an allowlisted SCTP listener, treat this CVE as Affected at 9.8 CRITICAL and apply the standard backstop.
