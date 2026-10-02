---
title: "Not Affected — disabled features"
linkTitle: "Disabled features"
weight: 20
description: "Config gates for kernel CVEs. Not Affected only where that option is unset on the kernel you boot."
categories: ["Reference"]
tags: ["heartsuite", "linux", "security", "cve", "kernel", "vulnerability"]
toc: true
type: docs
aliases:
  - /docs/security/disabled-features/
---

<!-- Flat catalog: every entry is an h3 under the page title, so the h1-to-h3 jump is intentional. -->
<!-- markdownlint-disable MD001 -->

**Overview**: A row is Not Affected on the kernel you boot only when that option is unset, because only then is the vulnerable code absent. On the 6.18.9-hs kernel that ships, `CONFIG_BPF_SYSCALL` is unset, so there is no eBPF program to load. The proof for any row is the pin config — the build configuration published for that kernel — because the guest file `/boot/config-6.18.9-hs` is a stub and a `grep` of it proves nothing. See [Evidence Status](../kernel-hardening/evidence-status/).

Compiled-in residuals and write-ups: [Compiled-in CVEs](../compiled-in-cves/). Method: [Kernel Security Transparency](../).

Where an option below is unset, that subsystem is absent and the group is Not Affected without a per-CVE review. Where the 6.18.9-hs kernel builds the option, the row says so and carries no Not Affected badge.

Where a CVE in this section achieves root privilege, Lockdown provides the same backstop described in [CVE-2026-31431](../compiled-in-cves/#cve-2026-31431). An attacker who already has root cannot persist or edit the allowlist, because the allowlist files are immutable and the kernel refuses the write.

| Config gate | CVEs covered | Status |
|-------------|-------------|--------|
| [`CONFIG_BPF_SYSCALL` not set](#bpf-syscall-interface) | CVE-2021-20194, CVE-2023-2163, CVE-2023-39191, CVE-2023-52452, CVE-2024-26589, CVE-2023-52621, CVE-2023-52642, CVE-2024-26883, CVE-2024-26884, CVE-2024-26885, CVE-2024-38538, CVE-2024-40954, CVE-2024-41045, CVE-2024-49861, CVE-2022-49030, CVE-2024-50063, CVE-2024-50067, CVE-2024-50164, CVE-2024-50262, CVE-2024-53099, CVE-2024-56614, CVE-2024-56615, CVE-2024-56633, CVE-2024-56664, CVE-2023-53024, CVE-2022-49840, CVE-2025-37822, CVE-2022-49961, CVE-2022-49970, CVE-2022-49975, CVE-2025-38280, CVE-2025-38502, CVE-2025-38538, CVE-2025-39744, CVE-2023-53192, CVE-2023-53338, CVE-2025-39913, CVE-2022-50490, CVE-2022-50536, CVE-2026-23343, CVE-2026-23359  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NF_TABLES=m` on 6.18.9-hs](#netfilter-nftables) | CVE-2023-32233, CVE-2023-0179, CVE-2023-3390, CVE-2023-31248, CVE-2023-35001, CVE-2023-3610, CVE-2023-4004, CVE-2023-3777, CVE-2023-4015, CVE-2023-4244, CVE-2023-6817, CVE-2024-1085, CVE-2023-52628, CVE-2024-26673, CVE-2024-27020, CVE-2024-27065, CVE-2024-27397, CVE-2024-35896, CVE-2024-41042, CVE-2024-44983, CVE-2024-50257, CVE-2024-53141, CVE-2024-56650, CVE-2023-52927, CVE-2025-22056, CVE-2022-49919, CVE-2025-38201, CVE-2023-53179, CVE-2023-53492, CVE-2023-53619, CVE-2026-23231, CVE-2023-4147  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_SCH_QFQ=m` on 6.18.9-hs](#network-traffic-control-schedulers) | CVE-2023-31436 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_CLS_TCINDEX` is not in this config](#network-traffic-control-schedulers) | CVE-2023-1829, CVE-2023-1281 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BT=m` on 6.18.9-hs](#bluetooth-stack) | CVE-2022-42896, CVE-2022-45934, CVE-2022-3564, CVE-2022-3640, CVE-2023-1989, and 3 additional, CVE-2023-40283, CVE-2024-21803, CVE-2024-27000, CVE-2024-27398, CVE-2024-35963, CVE-2024-35965, CVE-2024-35966, CVE-2024-35967, CVE-2023-52766, CVE-2024-36012, CVE-2024-36032, CVE-2024-36880, CVE-2024-40927, CVE-2024-41087, CVE-2022-48871, CVE-2022-48878, CVE-2024-43883, CVE-2024-49950, CVE-2024-50125, CVE-2024-50234, CVE-2024-53208, CVE-2024-56604, CVE-2024-56605, CVE-2025-21969, CVE-2025-22022, CVE-2022-49826, CVE-2022-49910, CVE-2023-53057, CVE-2025-37882, CVE-2023-53145, CVE-2025-38117, CVE-2025-38118, CVE-2025-38250, CVE-2025-38593, CVE-2022-50315, CVE-2023-53252, CVE-2023-53305, CVE-2022-50386, CVE-2023-53386, CVE-2022-50419, CVE-2022-50470, CVE-2023-53673, CVE-2025-71082, CVE-2026-23395, CVE-2026-31500  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_TLS=m`, `CONFIG_RDS=m`, `CONFIG_ROSE=m`, `CONFIG_AF_RXRPC=m` on 6.18.9-hs](#protocol-families-tls-rds-rose-mctp-and-af_rxrpc) | CVE-2023-28466, CVE-2023-1078, CVE-2022-2961, CVE-2023-2006 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MCTP` not set](#protocol-families-tls-rds-rose-mctp-and-af_rxrpc) | CVE-2022-3977 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NFSD=m` on 6.18.9-hs](#nfs-server) | CVE-2022-43945, CVE-2022-4379, CVE-2023-1652, CVE-2024-26907, CVE-2023-52885, CVE-2024-50106, CVE-2024-50121, CVE-2024-53168, CVE-2025-38724, CVE-2022-50235, CVE-2022-50241, CVE-2022-50401, CVE-2022-50410, CVE-2023-53680, CVE-2026-22980  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NTFS3_FS=m`, `CONFIG_JFS_FS=m`, `CONFIG_NILFS2_FS=m`; `CONFIG_NTFS_FS` not set](#filesystem-drivers) | CVE-2022-48423, CVE-2022-48424, CVE-2022-48425, CVE-2023-26544, CVE-2023-26506, CVE-2023-26507, CVE-2023-2124, CVE-2020-27815, CVE-2022-2978 | NTFS3, JFS, and NILFS2 are in the 6.18.9-hs kernel and stay on the patch date. Legacy NTFS (`CONFIG_NTFS_FS`) is not set. |
| [`CONFIG_FPGA` not set; GRU symbol absent on 6.18.9-hs](#hardware-specific-and-virtualization-drivers) | CVE-2022-3424, CVE-2023-26242 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DVB_CORE=m` on 6.18.9-hs](#hardware-specific-and-virtualization-drivers) | CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SMB_SERVER=m` on 6.18.9-hs](#usb-network-adapter-and-smb-server) | CVE-2023-0210 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_USB_NET_RNDIS_WLAN` is not in this config](#usb-network-adapter-and-smb-server) | CVE-2023-23559 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_ADV748X` not set](#config-video-adv748x) | CVE-2025-71136 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MD_RAID10=m` on 6.18.9-hs](#config-md-raid10) | CVE-2023-53357 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_USB_NET_CDCETHER=m` on 6.18.9-hs](#config-usb-net-cdcether) | CVE-2025-38153 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DRM_XLNX` not set](#config-drm-xlnx) | CVE-2024-56538 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_LAN78XX=m` on 6.18.9-hs](#config-usb-lan78xx) | CVE-2024-53213 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HYPERV_VSOCKETS` not set](#config-hyperv-vsockets) | CVE-2024-53103 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_XE=m` on 6.18.9-hs](#drm-xe-driver) | CVE-2024-53098 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ARM_SCMI_PROTOCOL` not set](#config-arm-scmi-protocol) | CVE-2024-53068 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_S5P_JPEG` not set](#config-video-s5p-jpeg) | CVE-2024-53061 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MSE102X` not set](#config-mse102x) | CVE-2024-50276 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TYPEC=m` on 6.18.9-hs](#config-typec) | CVE-2024-50150 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HSR=m` on 6.18.9-hs](#config-hsr) | CVE-2022-49015 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HI_GMAC` not set](#config-hi-gmac) | CVE-2022-48960, CVE-2022-48962 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_STM` not set](#config-drm-stm) | CVE-2024-49992 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PCI_KIRIN` not set](#config-pci-kirin) | CVE-2024-47751 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_ASPEED_GFX` not set](#config-drm-aspeed-gfx) | CVE-2023-52916 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_BNA=m` on 6.18.9-hs](#config-bna) | CVE-2024-43839 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CRYPTO_DEV_HISI_SEC2` not set](#config-crypto-dev-hisi-sec2) | CVE-2024-42147, CVE-2024-47730 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IONIC=m` on 6.18.9-hs](#config-ionic) | CVE-2024-39502 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_GREYBUS` not set](#config-greybus) | CVE-2024-39495 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_STM=m` on 6.18.9-hs](#config-stm) | CVE-2024-38627 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DEBUG_MUTEXES` not set](#config-debug-mutexes) | CVE-2023-52836 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_RCU_NOCB_CPU=y` on 6.18.9-hs](#config-rcu-nocb-cpu) | CVE-2024-35929, CVE-2025-38704 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SECURITY_APPARMOR=y` on 6.18.9-hs](#config-security-apparmor) | CVE-2026-23408 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MACVLAN=m` on 6.18.9-hs](#config-macvlan) | CVE-2026-23001, CVE-2026-23209 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NETFILTER_NETLINK_OSF=m` on 6.18.9-hs](#config-netfilter-netlink-osf) | CVE-2026-23397 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_USB_HACKRF=m` on 6.18.9-hs](#config-usb-hackrf) | CVE-2026-31576 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VIDEO_EM28XX_V4L2=m` on 6.18.9-hs](#config-video-em28xx-v4l2) | CVE-2026-31583 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_TEAM=m` on 6.18.9-hs](#config-net-team) | CVE-2025-71091 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DLM=m` on 6.18.9-hs](#config-dlm) | CVE-2023-53629 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_TRACE_BUF` not set](#config-trace-buf) | CVE-2023-53587 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PTP_1588_CLOCK_OCP=m` on 6.18.9-hs](#config-ptp-1588-clock-ocp) | CVE-2025-39859 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_XDP_SOCKETS` not set](#config-xdp-sockets) | CVE-2023-53426 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NUBUS` not set](#config-nubus) | CVE-2023-53217 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_COMEDI=m` on 6.18.9-hs](#config-comedi) | CVE-2025-38482, CVE-2025-38483, CVE-2025-38529, CVE-2025-38530, CVE-2025-39685, CVE-2025-39686 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IPV6_SEG6_LWTUNNEL=y` on 6.18.9-hs](#config-ipv6-seg6-lwtunnel) | CVE-2025-38476 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CORESIGHT` not set](#config-coresight) | CVE-2025-38131 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_STAGING=y` on 6.18.9-hs](#config-staging) | CVE-2022-49956, CVE-2023-53554 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MCB` not set](#config-mcb) | CVE-2025-37817 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UDMABUF=y` on 6.18.9-hs](#config-udmabuf) | CVE-2025-37803 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SLIMBUS=m` on 6.18.9-hs](#config-slimbus) | CVE-2025-21914 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_GENEVE=m` on 6.18.9-hs](#config-geneve) | CVE-2025-21858 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ORANGEFS_FS=m` on 6.18.9-hs](#config-orangefs-fs) | CVE-2025-21782 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PKTGEN` not set](#config-pktgen) | CVE-2025-21680 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SPI_MPC52xx` not set](#config-spi-mpc52xx) | CVE-2024-50051 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SUPERH` not set](#config-superh) | CVE-2024-53165 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_MUSB_HDRC` not set](#config-usb-musb-hdrc) | CVE-2024-50269 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_SERIAL=m` on 6.18.9-hs](#config-usb-serial) | CVE-2024-50267 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VDPA=m` on 6.18.9-hs](#config-vdpa) | CVE-2024-47748, CVE-2024-53126, CVE-2023-53082, CVE-2023-53543 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SPI_NXP_FLEXSPI` not set](#config-spi-nxp-flexspi) | CVE-2024-46853 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UML` not set](#config-uml) | CVE-2024-46844 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_SCH_NETEM=m` on 6.18.9-hs](#config-net-sch-netem) | CVE-2024-46800 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PARISC` not set](#config-parisc) | CVE-2024-44949, CVE-2022-50518 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_FOU=m` on 6.18.9-hs](#config-net-fou) | CVE-2024-44940, CVE-2026-23083 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VHOST_VSOCK=m` on 6.18.9-hs](#config-vhost-vsock) | CVE-2024-43873 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IIO=m` on 6.18.9-hs](#config-iio) | CVE-2024-42086, CVE-2024-57906, CVE-2024-57907, CVE-2024-57908, CVE-2024-57910, CVE-2024-57911, CVE-2024-57912, CVE-2022-49792, CVE-2025-38485 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SND_SOC=m` on 6.18.9-hs](#config-snd-soc) | CVE-2024-41069, CVE-2022-50325 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CACHEFILES=m` on 6.18.9-hs](#config-cachefiles) | CVE-2024-41050, CVE-2024-41057, CVE-2024-41074 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_WWAN=m` on 6.18.9-hs](#config-wwan) | CVE-2024-40939 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VMWARE_VMCI=m` on 6.18.9-hs](#config-vmware-vmci) | CVE-2024-39499, CVE-2024-46738, CVE-2025-38403 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_BONDING=m` on 6.18.9-hs](#config-bonding) | CVE-2024-39487, CVE-2026-23099 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_TEE=m` on 6.18.9-hs](#tee-subsystem) | CVE-2023-52503 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_INPUT_POWERMATE=m` on 6.18.9-hs](#powermate-driver) | CVE-2023-52475 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PWM=y` on 6.18.9-hs](#pwm-subsystem) | CVE-2024-26599 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VIDEO_PVRUSB2=m` on 6.18.9-hs](#pvrusb2-driver) | CVE-2023-52445 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ATALK=m` on 6.18.9-hs](#appletalk) | CVE-2023-51781 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IGB=m` on 6.18.9-hs](#igb-driver) | CVE-2023-45871 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_VIDEO_RKVDEC` not set](#rkvdec-driver) | CVE-2023-35829 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_RENESAS_USBHS3` not set](#renesas-usb3) | CVE-2023-35828 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_SUNXI_CEDRUS` not set](#cedrus-driver) | CVE-2023-35826 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_DM1105` not set](#dm1105-driver) | CVE-2023-35824 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_SAA7134=m` on 6.18.9-hs](#saa7134-driver) | CVE-2023-35823 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_CLS_U32=m` on 6.18.9-hs](#tc-cls-u32) | CVE-2026-23204 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_WILC1000` not set](#wilc1000-driver) | CVE-2025-39952 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MWIFIEX=m` on 6.18.9-hs](#mwifiex-driver) | CVE-2025-39891 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_AF_RXRPC=m` on 6.18.9-hs](#config-af-rxrpc) | CVE-2023-53218 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_SCH_QFQ=m` on 6.18.9-hs](#config-net-sch-qfq) | CVE-2025-37913 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NTFS_FS` not set](#config-ntfs-fs) | CVE-2022-49763 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IP_SCTP=m` on 6.18.9-hs](#sctp-protocol) | CVE-2025-23142, CVE-2025-38718, CVE-2022-50243, CVE-2023-53372  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MEMSTICK=m` on 6.18.9-hs](#memstick) | CVE-2025-22020, CVE-2023-3141  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_BRCMFMAC=m` on 6.18.9-hs](#brcmfmac-driver) | CVE-2022-49740, CVE-2022-50258, CVE-2023-53213, CVE-2022-50408, CVE-2025-39863, CVE-2022-50551  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_RTLWIFI=m` on 6.18.9-hs](#rtlwifi-driver) | CVE-2024-58072, CVE-2022-50279  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_LOONGARCH` not set](#loongarch-arch) | CVE-2024-56628 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_UDF_FS=m` on 6.18.9-hs](#udf-filesystem) | CVE-2024-50143, CVE-2022-49846, CVE-2023-53107, CVE-2023-53506  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_RMNET` not set](#rmnet-driver) | CVE-2024-50128, CVE-2024-26597  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PPP=m` on 6.18.9-hs](#ppp) | CVE-2024-50033, CVE-2024-50035, CVE-2025-37749, CVE-2025-38574  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_XEN=y` on 6.18.9-hs](#xen-hypervisor) | CVE-2024-49936, CVE-2024-56704  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_OCFS2_FS=m` on 6.18.9-hs](#ocfs2-filesystem) | CVE-2024-47670, CVE-2024-49966, CVE-2024-53155, CVE-2024-57892, CVE-2025-22079, CVE-2023-53081  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PLATFORM_X86` not set](#config-platform-x86) | CVE-2024-46859, CVE-2024-49986, CVE-2025-38077  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ISDN=y` on 6.18.9-hs](#isdn) | CVE-2024-42280 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HFSPLUS_FS=m` on 6.18.9-hs](#hfsplus-filesystem) | CVE-2024-41059, CVE-2024-56548, CVE-2025-38713, CVE-2025-38714  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_XFS_FS=m` on 6.18.9-hs](#config-xfs-fs) | CVE-2024-41013, CVE-2024-41014, CVE-2025-39835, CVE-2022-50406  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PPC` not set](#powerpc-arch) | CVE-2024-40974, CVE-2024-46774, CVE-2022-48998, CVE-2024-56765, CVE-2025-38088, CVE-2025-39776, CVE-2023-53487, CVE-2025-71078, CVE-2023-52451  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IMA=y` on 6.18.9-hs](#ima) | CVE-2024-38667, CVE-2024-53106, CVE-2024-57798, CVE-2025-39730  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_SCH_MULTIQ=m` on 6.18.9-hs](#tc-multiq) | CVE-2024-36978 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DRM_VMWGFX=m` on 6.18.9-hs](#vmwgfx-driver) | CVE-2024-36960 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PINCTRL=y` on 6.18.9-hs](#pinctrl) | CVE-2024-36940, CVE-2025-38286  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_GPIOLIB=y` on 6.18.9-hs](#gpiolib) | CVE-2024-36898, CVE-2024-36899, CVE-2024-42092, CVE-2025-38395  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_TIPC=m` on 6.18.9-hs](#tipc-protocol) | CVE-2024-36886, CVE-2024-42284, CVE-2022-49017, CVE-2024-56642, CVE-2025-38052, CVE-2025-38464  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_PPDEV=m` on 6.18.9-hs](#ppdev-driver) | CVE-2024-36015 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DRM_RADEON=m` on 6.18.9-hs](#radeon-driver) | CVE-2023-52867 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_WMI` not set](#wmi-driver) | CVE-2023-52864 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_HW_PERF_EVENTS_HISI` not set](#config-hw-perf-events-hisi) | CVE-2023-52859, CVE-2024-38569  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_VIDEO_BT848=m` on 6.18.9-hs](#bttv-driver) | CVE-2023-52847 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_RMI4_CORE=m` on 6.18.9-hs](#rmi4-driver) | CVE-2023-52840 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_BLK_DEV_NBD=m` on 6.18.9-hs](#nbd-driver) | CVE-2023-52837, CVE-2024-49855, CVE-2025-38443  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_KVM_AMD=m` on 6.18.9-hs](#kvm-amd) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HNS3` not set](#hns3-driver) | CVE-2023-52807, CVE-2024-46833, CVE-2025-71112  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_IPVLAN=m` on 6.18.9-hs](#ipvlan) | CVE-2023-52796 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SMC` not set](#smc-driver) | CVE-2023-52775, CVE-2024-56640, CVE-2024-57791, CVE-2025-38734  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_USB_GSPCA_CORE` not set](#gspca-driver) | CVE-2023-52764 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_GFS2_FS=m` on 6.18.9-hs](#gfs2-filesystem) | CVE-2023-52760, CVE-2024-38570, CVE-2023-53622  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_FB=y` on 6.18.9-hs](#config-fb) | CVE-2023-52731, CVE-2024-49924, CVE-2024-50180, CVE-2025-38685, CVE-2025-38702  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DMA_DIRECT_REMAP` not set](#config-dma-direct-remap) | CVE-2024-35939 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_AX25=m` on 6.18.9-hs](#ax25-hamradio) | CVE-2024-35887, CVE-2026-23098  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MLX5_CORE=m` on 6.18.9-hs](#mlx5-driver) | CVE-2023-52667, CVE-2024-38555, CVE-2024-38556, CVE-2024-40940, CVE-2022-48883, CVE-2022-49025, CVE-2023-53340  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ATLANTIC` not set](#atlantic-driver) | CVE-2023-52664 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_KVM=m` on 6.18.9-hs](#config-kvm) | CVE-2024-35791, CVE-2024-41070, CVE-2024-46830, CVE-2024-50115, CVE-2022-49882, CVE-2025-37885, CVE-2025-39823  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_FIREWIRE=m` on 6.18.9-hs](#firewire) | CVE-2024-27401, CVE-2023-53432  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_OPENVSWITCH=m` on 6.18.9-hs](#openvswitch) | CVE-2024-27395, CVE-2025-37789, CVE-2025-38146  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_EROFS_FS=m` on 6.18.9-hs](#erofs-filesystem) | CVE-2022-48674, CVE-2024-41058  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_OF` not set](#config-of) | CVE-2022-48672 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_PECI` not set](#config-peci) | CVE-2022-48670 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DVB_CORE=m` on 6.18.9-hs](#config-dvb-core) | CVE-2024-27075, CVE-2024-43900, CVE-2024-47697, CVE-2024-47698, CVE-2025-38227, CVE-2022-50274, CVE-2023-53219, CVE-2022-50499  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DRM_NOUVEAU=m` on 6.18.9-hs](#nouveau-driver) | CVE-2024-27008, CVE-2022-50454  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_USB_GADGET=m` on 6.18.9-hs](#usb-gadget) | CVE-2024-26996, CVE-2024-46836, CVE-2022-48948, CVE-2024-58055, CVE-2022-49980, CVE-2025-38497, CVE-2025-38555  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_COMMON_CLK_QCOM` not set](#config-common-clk-qcom) | CVE-2024-26965 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NILFS2_FS=m` on 6.18.9-hs](#config-nilfs2-fs) | CVE-2024-26955, CVE-2024-26956, CVE-2024-26981, CVE-2024-38583, CVE-2024-37078, CVE-2024-39469, CVE-2024-42104, CVE-2024-42105, CVE-2024-47757, CVE-2024-50230, CVE-2022-49834, CVE-2023-53035, CVE-2023-53311, CVE-2022-50367, CVE-2022-50478, CVE-2023-53608  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ARM64` not set](#arm64-arch) | CVE-2022-48657, CVE-2024-26989, CVE-2024-40989, CVE-2025-21785, CVE-2022-49888, CVE-2025-37849, CVE-2024-26598  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MLXBF_I2C` not set](#config-mlxbf-i2c) | CVE-2022-48632 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TUN=m` on 6.18.9-hs](#tun-tap-driver) | CVE-2024-26882, CVE-2022-49014, CVE-2023-3812  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_RDS=m` on 6.18.9-hs](#config-rds) | CVE-2024-26865, CVE-2022-48637, CVE-2024-27024, CVE-2024-42138, CVE-2024-42148, CVE-2024-46782, CVE-2024-46786, CVE-2024-57900, CVE-2025-23156, CVE-2025-23158, CVE-2023-53075, CVE-2025-37921, CVE-2025-39710, CVE-2022-50412, CVE-2023-53541, CVE-2025-39967, CVE-2026-31578  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SPARX5_SWITCH` not set](#config-sparx5-switch) | CVE-2024-26856 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_THINKPAD_LMI=m` on 6.18.9-hs](#config-thinkpad-lmi) | CVE-2024-26836 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_BTRFS_FS=m` on 6.18.9-hs](#btrfs-filesystem) | CVE-2024-26791, CVE-2024-26944, CVE-2024-35849, CVE-2024-35949, CVE-2024-39496, CVE-2024-42314, CVE-2024-50217, CVE-2024-56581, CVE-2024-56582, CVE-2024-56759, CVE-2024-57896, CVE-2025-39738, CVE-2025-39759, CVE-2022-50300  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MPTCP=y` on 6.18.9-hs](#mptcp) | CVE-2024-26782, CVE-2024-44974, CVE-2024-46858, CVE-2024-50083, CVE-2023-53072, CVE-2023-53088, CVE-2025-38552  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DM_CRYPT=m` on 6.18.9-hs](#config-dm-crypt) | CVE-2024-26763 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_GTP=m` on 6.18.9-hs](#config-gtp) | CVE-2024-26754, CVE-2024-26793, CVE-2024-27396, CVE-2024-44999  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CRYPTO_DEV_VIRTIO=m` on 6.18.9-hs](#config-crypto-dev-virtio) | CVE-2024-26753 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_USB_CDNS3` not set](#config-usb-cdns3) | CVE-2024-26748, CVE-2024-26749 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NET_ACT_MIRRED=m` on 6.18.9-hs](#tc-act-mirred) | CVE-2024-26739 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_AFS_FS=m` on 6.18.9-hs](#config-afs-fs) | CVE-2024-26736 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IP_TUNNEL` not set](#config-ip-tunnel) | CVE-2024-26665, CVE-2023-53600  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_MHI_BUS=m` on 6.18.9-hs](#config-mhi-bus) | CVE-2023-52494, CVE-2025-39790  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_LLC=m` on 6.18.9-hs](#config-llc) | CVE-2024-26625 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_JFS_FS=m` on 6.18.9-hs](#config-jfs-fs) | CVE-2023-52599, CVE-2023-52600, CVE-2023-52603, CVE-2023-52604, CVE-2023-52799, CVE-2023-52804, CVE-2023-52805, CVE-2024-40902, CVE-2024-43858, CVE-2024-47723, CVE-2024-49900, CVE-2024-49903, CVE-2024-56595, CVE-2024-56596, CVE-2024-56597, CVE-2024-56598, CVE-2025-38204, CVE-2025-38230, CVE-2025-38697, CVE-2025-39743, CVE-2022-50333, CVE-2023-53222, CVE-2023-53485, CVE-2023-53616  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_S390` not set](#config-s390) | CVE-2023-52598, CVE-2024-26957, CVE-2023-52669, CVE-2024-36931, CVE-2024-45026, CVE-2022-48954, CVE-2024-57838, CVE-2024-57849, CVE-2022-49804, CVE-2023-53123, CVE-2025-38257, CVE-2025-38320, CVE-2022-50307, CVE-2023-53205, CVE-2026-31568  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_DRM_MSM` not set](#config-drm-msm) | CVE-2023-52586, CVE-2023-53316, CVE-2022-50368, CVE-2022-50437, CVE-2022-50492, CVE-2022-50526  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_SECURITY_TOMOYO=y` on 6.18.9-hs](#config-security-tomoyo) | CVE-2024-26622 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IWLWIFI=m` on 6.18.9-hs](#iwlwifi-driver) | CVE-2023-52531, CVE-2024-26610, CVE-2024-36921, CVE-2024-40929, CVE-2024-53059, CVE-2025-21905, CVE-2022-50248, CVE-2023-53524  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SPI_SUN6I` not set](#config-spi-sun6i) | CVE-2023-52517 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_INFINIBAND=m` on 6.18.9-hs](#infiniband-rdma) | CVE-2023-52515, CVE-2024-26872, CVE-2022-48694, CVE-2023-52851, CVE-2024-38545, CVE-2024-42285, CVE-2025-38024, CVE-2025-38211, CVE-2025-71133, CVE-2026-31493  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IEEE802154=m` on 6.18.9-hs](#ieee802154-wpan) | CVE-2023-52510, CVE-2024-56602  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_RAVB` not set](#ravb-driver) | CVE-2023-52509, CVE-2022-48964, CVE-2023-35827  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_NFC=m` on 6.18.9-hs](#nfc) | CVE-2023-52507, CVE-2024-36915, CVE-2022-48967, CVE-2025-21735, CVE-2023-53106, CVE-2025-38416, CVE-2023-53495  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_FUSE_FS=y` on 6.18.9-hs](#fuse-filesystem) | CVE-2023-52504, CVE-2024-35932, CVE-2024-41090, CVE-2024-41091, CVE-2024-58054, CVE-2022-49945, CVE-2025-38385, CVE-2023-53286, CVE-2023-53577  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_MCTP` not set](#config-mctp) | CVE-2023-52483 | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_ATH` not set](#ath-wireless-driver) | CVE-2023-52464, CVE-2023-52594, CVE-2023-52491, CVE-2024-26958, CVE-2024-26983, CVE-2024-26988, CVE-2024-27043, CVE-2023-52679, CVE-2024-35847, CVE-2023-52777, CVE-2023-52827, CVE-2024-36906, CVE-2024-36979, CVE-2024-38578, CVE-2024-38621, CVE-2024-41096, CVE-2024-42271, CVE-2024-43830, CVE-2022-48873, CVE-2022-48881, CVE-2024-46674, CVE-2024-47695, CVE-2024-47742, CVE-2024-49930, CVE-2024-49931, CVE-2022-48980, CVE-2022-48981, CVE-2022-48999, CVE-2024-53142, CVE-2024-53156, CVE-2024-56672, CVE-2024-57887, CVE-2024-57980, CVE-2025-21934, CVE-2025-37780, CVE-2023-53084, CVE-2023-53090, CVE-2025-37840, CVE-2025-38022, CVE-2025-38069, CVE-2025-38157, CVE-2025-38259, CVE-2025-38313, CVE-2025-38456, CVE-2025-38708, CVE-2025-39701, CVE-2025-39749, CVE-2022-50234, CVE-2025-39810, CVE-2022-50384, CVE-2022-50411, CVE-2025-39905, CVE-2025-39911, CVE-2023-53454, CVE-2023-53500, CVE-2023-53556, CVE-2023-53559, CVE-2023-53604, CVE-2022-50543, CVE-2023-53659, CVE-2023-53668, CVE-2023-54207, CVE-2026-23068, CVE-2026-31489  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_F2FS_FS=m` on 6.18.9-hs](#f2fs-filesystem) | CVE-2023-52436, CVE-2023-52444, CVE-2023-52588, CVE-2023-52682, CVE-2023-52748, CVE-2023-52852, CVE-2024-39467, CVE-2024-42160, CVE-2024-44942, CVE-2024-47691, CVE-2024-41935, CVE-2022-49738, CVE-2025-37739, CVE-2025-38579, CVE-2025-38652, CVE-2025-38677, CVE-2022-50270, CVE-2023-53214, CVE-2023-53301, CVE-2023-53537, CVE-2026-23234, CVE-2026-23235  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_DRM_AMDGPU=m` on 6.18.9-hs](#amdgpu-driver) | CVE-2023-51042, CVE-2023-52624, CVE-2024-26699, CVE-2024-27045, CVE-2023-52691, CVE-2023-52812, CVE-2023-52818, CVE-2024-36914, CVE-2024-38552, CVE-2024-38581, CVE-2024-39471, CVE-2024-42118, CVE-2024-42119, CVE-2024-42120, CVE-2024-42121, CVE-2024-42228, CVE-2024-44977, CVE-2024-46722, CVE-2024-46723, CVE-2024-46724, CVE-2024-46729, CVE-2024-46804, CVE-2024-46811, CVE-2024-46813, CVE-2024-46814, CVE-2024-46815, CVE-2024-46818, CVE-2024-46871, CVE-2024-49894, CVE-2024-49895, CVE-2024-49969, CVE-2024-49989, CVE-2024-49991, CVE-2022-48990, CVE-2023-52921, CVE-2024-50282, CVE-2024-53108, CVE-2024-53133, CVE-2024-56551, CVE-2024-56608, CVE-2024-56775, CVE-2024-56784, CVE-2025-21780, CVE-2025-21968, CVE-2025-21985, CVE-2023-53077, CVE-2025-37903, CVE-2022-49969, CVE-2025-38361, CVE-2022-50303, CVE-2023-53471, CVE-2023-52469, CVE-2024-41011, CVE-2024-46731, CVE-2024-46821, CVE-2025-37854  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_IP_DCCP` not set](#dccp-protocol) | CVE-2023-39197, CVE-2024-36904, CVE-2024-50154, CVE-2023-53333  | <span class="badge badge-erased">Not Affected</span> |
| [`CONFIG_TLS=m` on 6.18.9-hs](#config-tls) | CVE-2024-0646, CVE-2024-58240, CVE-2025-40149  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ROSE=m` on 6.18.9-hs](#config-rose) | CVE-2023-51782, CVE-2025-21718, CVE-2025-38377, CVE-2025-39826  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_ATM=m` on 6.18.9-hs](#atm-protocol) | CVE-2023-51780, CVE-2023-52578, CVE-2024-26895, CVE-2024-44998, CVE-2025-38180, CVE-2025-38236, CVE-2025-38245, CVE-2025-38323, CVE-2025-38459, CVE-2025-39828, CVE-2025-39839  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CIFS=m` on 6.18.9-hs](#cifs-smb-client) | CVE-2023-1194, CVE-2023-52434, CVE-2023-52440, CVE-2023-52572, CVE-2024-26928, CVE-2024-35861, CVE-2024-35862, CVE-2024-35864, CVE-2024-35866, CVE-2024-35867, CVE-2024-35868, CVE-2023-52741, CVE-2023-52751, CVE-2023-52752, CVE-2023-52757, CVE-2024-49996, CVE-2024-50047, CVE-2024-50151, CVE-2024-53179, CVE-2025-38051, CVE-2025-38527, CVE-2025-38728, CVE-2023-53427  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NVME_CORE=y` on 6.18.9-hs](#nvme-driver) | CVE-2023-5178, CVE-2023-6356, CVE-2023-6536, CVE-2022-48658, CVE-2022-48686, CVE-2024-41073, CVE-2024-58069, CVE-2025-21927, CVE-2023-53116, CVE-2025-39783  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CEPH_FS=m` on 6.18.9-hs](#ceph-filesystem) | CVE-2023-44466, CVE-2024-26689, CVE-2022-49770, CVE-2025-39880, CVE-2025-71116, CVE-2026-22984, CVE-2026-31580  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_HFS_FS=m` on 6.18.9-hs](#hfs-filesystem) | CVE-2023-4623, CVE-2024-26982, CVE-2024-46744, CVE-2025-21702, CVE-2025-37797, CVE-2025-37823, CVE-2025-37890, CVE-2025-38000, CVE-2025-38415, CVE-2025-38715, CVE-2026-23388  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_SMB_SERVER=m` on 6.18.9-hs](#config-smb-server) | CVE-2023-32250, CVE-2023-32254, CVE-2023-32247, CVE-2023-32248, CVE-2023-32252, CVE-2023-32257, CVE-2023-32258, CVE-2024-22705, CVE-2023-52441, CVE-2024-26592, CVE-2024-26594, CVE-2023-52480, CVE-2024-26936, CVE-2024-26952, CVE-2024-26954, CVE-2024-50086, CVE-2024-50283, CVE-2024-50286, CVE-2024-56626, CVE-2024-56627, CVE-2025-21945, CVE-2025-21946, CVE-2025-21967, CVE-2025-22038, CVE-2025-22039, CVE-2025-37776, CVE-2025-37777, CVE-2025-37778, CVE-2025-37899, CVE-2025-37924, CVE-2025-37926, CVE-2025-37947, CVE-2025-37952, CVE-2025-38437, CVE-2025-38501, CVE-2023-3865, CVE-2023-3867, CVE-2023-53358, CVE-2025-39943  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_CAN=m` on 6.18.9-hs](#can-bus) | CVE-2023-3090, CVE-2023-3389, CVE-2023-3609, CVE-2023-3611, CVE-2023-3776, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208, CVE-2023-4622, CVE-2023-4921, CVE-2023-5717, CVE-2023-46813, CVE-2023-6931, CVE-2023-6932, CVE-2023-6546, CVE-2023-6270, CVE-2024-25744, CVE-2023-52438, CVE-2023-52439, CVE-2023-52474, CVE-2023-52501, CVE-2022-47518, CVE-2022-47519, CVE-2022-47520, CVE-2022-47521, CVE-2023-2235, CVE-2023-2156, CVE-2023-52519, CVE-2023-52614, CVE-2024-26669, CVE-2023-52637, CVE-2024-26898, CVE-2022-48655, CVE-2024-26951, CVE-2024-26961, CVE-2024-26974, CVE-2024-35855, CVE-2024-35871, CVE-2024-35937, CVE-2023-52701, CVE-2023-52707, CVE-2023-52772, CVE-2023-52846, CVE-2023-52854, CVE-2024-36934, CVE-2024-36974, CVE-2024-38599, CVE-2024-38610, CVE-2024-39277, CVE-2023-52340, CVE-2024-39494, CVE-2024-40900, CVE-2024-40913, CVE-2024-40935, CVE-2024-40994, CVE-2024-41040, CVE-2024-42093, CVE-2024-42094, CVE-2024-42313, CVE-2024-43842, CVE-2024-43882, CVE-2022-48872, CVE-2022-48874, CVE-2022-48892, CVE-2023-52906, CVE-2024-44934, CVE-2024-46740, CVE-2024-46854, CVE-2024-47659, CVE-2024-47727, CVE-2024-47745, CVE-2024-47750, CVE-2024-49853, CVE-2024-49854, CVE-2022-48988, CVE-2022-48991, CVE-2022-49006, CVE-2022-49031, CVE-2022-49032, CVE-2024-50036, CVE-2024-50059, CVE-2024-50061, CVE-2024-50073, CVE-2024-50074, CVE-2024-50209, CVE-2024-50264, CVE-2024-50268, CVE-2024-50275, CVE-2024-50301, CVE-2024-53104, CVE-2024-53166, CVE-2024-53171, CVE-2024-53203, CVE-2024-56570, CVE-2024-56603, CVE-2024-56651, CVE-2024-52332, CVE-2024-57850, CVE-2024-57904, CVE-2024-57929, CVE-2025-21687, CVE-2025-21704, CVE-2024-57982, CVE-2025-21791, CVE-2025-21855, CVE-2023-53000, CVE-2025-21919, CVE-2025-21920, CVE-2025-21928, CVE-2025-22107, CVE-2025-23157, CVE-2025-37786, CVE-2022-49775, CVE-2022-49779, CVE-2022-49900, CVE-2023-53135, CVE-2025-37839, CVE-2025-37892, CVE-2025-37927, CVE-2025-37928, CVE-2025-37991, CVE-2025-38004, CVE-2025-38081, CVE-2022-49939, CVE-2022-49948, CVE-2025-38102, CVE-2025-38108, CVE-2025-38129, CVE-2025-38248, CVE-2025-38342, CVE-2025-38346, CVE-2025-38375, CVE-2025-38445, CVE-2025-38535, CVE-2025-38595, CVE-2025-38666, CVE-2025-38679, CVE-2025-38680, CVE-2025-38722, CVE-2025-39683, CVE-2025-39687, CVE-2025-39689, CVE-2025-39766, CVE-2025-39797, CVE-2022-50255, CVE-2023-53148, CVE-2023-53153, CVE-2023-53215, CVE-2023-53232, CVE-2023-53259, CVE-2023-53272, CVE-2025-39817, CVE-2025-39824, CVE-2022-50394, CVE-2023-53388, CVE-2023-53446, CVE-2025-39873, CVE-2025-39877, CVE-2025-39883, CVE-2025-39901, CVE-2022-50421, CVE-2023-53465, CVE-2025-39951, CVE-2023-53536, CVE-2023-53560, CVE-2023-53569, CVE-2023-53570, CVE-2022-50552, CVE-2025-71073, CVE-2025-71089, CVE-2025-71093, CVE-2025-71152, CVE-2025-71162, CVE-2026-23073, CVE-2026-23074, CVE-2026-23102, CVE-2026-23171, CVE-2025-71221, CVE-2026-23221, CVE-2026-23227, CVE-2026-23361, CVE-2026-31788, CVE-2026-23410, CVE-2026-23411, CVE-2026-31527, CVE-2026-31532, CVE-2026-31582  | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NET_CLS_FLOWER=m` on 6.18.9-hs](#tc-cls-flower) | CVE-2023-35788 | In the 6.18.9-hs kernel. Stays on the patch date. |
| [`CONFIG_NTFS3_FS=m` on 6.18.9-hs](#config-ntfs3-fs) | CVE-2022-48502, CVE-2023-26606, CVE-2023-52640, CVE-2024-50242, CVE-2024-50246, CVE-2024-50247, CVE-2025-38707, CVE-2025-39691, CVE-2023-53194, CVE-2023-53420, CVE-2022-50442, CVE-2023-53486, CVE-2022-50507  | In the 6.18.9-hs kernel. Stays on the patch date. |

### BPF Syscall Interface

**Status**: Not Affected  
**Config gate**: `CONFIG_BPF_SYSCALL` not set  
**CVEs covered**: CVE-2021-20194

The BPF syscall interface is the kernel entry point through which user-space programs load and run BPF programs in kernel context. CVE-2021-20194 describes a heap overflow in the BPF verifier reachable by a local user who submits a crafted BPF program, gaining elevated privilege.

`CONFIG_BPF_SYSCALL` is not set on 5.19.6 and is not set on the 6.18.9-hs kernel that ships (`bpf()` returns `ENOSYS`). There is no verifier, no BPF program store, and no reachable code path for this CVE. `CONFIG_BPF=y` stays built in on that pin. This row covers the syscall entry point.

### Netfilter nftables

**Status**: In the 6.18.9-hs kernel (`CONFIG_NF_TABLES=m`). Stays on the patch date.  
**Component**: `CONFIG_NF_TABLES` built as kernel module (`m`)  
**CVEs covered**: CVE-2023-32233, CVE-2023-0179

nftables is the in-kernel packet classification and filtering framework. CVE-2023-32233 describes a use-after-free in anonymous set handling reachable via crafted netlink messages by a local user with `CAP_NET_ADMIN`. CVE-2023-0179 describes a stack-based buffer overflow in the nftables netlink implementation reachable from a user namespace.

The 6.18.9-hs kernel that ships builds nftables as a module (`CONFIG_NF_TABLES=m`), and loading the module makes this code reachable, so scanner findings for these CVEs are real on that kernel.

### Network Traffic Control Schedulers

**Status**: Split by option on 6.18.9-hs  
**Config gate**: `CONFIG_NET_SCH_QFQ=m` on 6.18.9-hs. `CONFIG_NET_CLS_TCINDEX` is not in this config.  
**CVEs covered**: CVE-2023-31436, CVE-2023-1829, CVE-2023-1281

These CVEs cover two traffic control components: the QFQ (Quick Fair Queueing) scheduler and the TCINDEX traffic control filter. CVE-2023-31436 describes an out-of-bounds write in the QFQ scheduler reachable via `tc qdisc add`. CVE-2023-1829 and CVE-2023-1281 both describe use-after-free conditions in the TCINDEX filter reachable by a local user with `CAP_NET_ADMIN`.

The 6.18.9-hs kernel that ships builds QFQ as a kernel module (`CONFIG_NET_SCH_QFQ=m`). CVE-2023-31436 stays on the patch date. `CONFIG_NET_CLS_TCINDEX` is not in this config, so CVE-2023-1829 and CVE-2023-1281 stay on the Not Affected row.

### Bluetooth Stack

**Status**: In the 6.18.9-hs kernel (`CONFIG_BT=m`). Stays on the patch date.  
**Config gate**: `CONFIG_BT=m` on 6.18.9-hs  
**CVEs covered**: CVE-2022-42896, CVE-2022-45934, CVE-2022-3564, CVE-2022-3640, CVE-2023-1989, and 3 additional CVEs in this group

These CVEs cover the kernel Bluetooth stack across the L2CAP, HCI, and RFCOMM layers. They include type confusion, use-after-free, and memory corruption conditions reachable by an attacker in proximity to the target device over Bluetooth, or by a local user with socket access to the Bluetooth subsystem.

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BT=m`). These CVEs stay on the patch date.

### Protocol Families: TLS, RDS, ROSE, MCTP, and AF_RXRPC

**Status**: Split by option on 6.18.9-hs  
**Config gate**: `CONFIG_TLS=m`, `CONFIG_RDS=m`, `CONFIG_ROSE=m`, and `CONFIG_AF_RXRPC=m` on 6.18.9-hs. `CONFIG_MCTP` is not set.  
**CVEs covered**: CVE-2023-28466, CVE-2023-1078, CVE-2022-2961, CVE-2022-3977, CVE-2023-2006

These CVEs cover five distinct socket protocol families, each gated by its own config option:

- **TLS** (CVE-2023-28466) — a race condition in the in-kernel TLS record layer reachable via a socket configured with `SO_TLS_TX`
- **RDS** (CVE-2023-1078) — a heap out-of-bounds write in the Reliable Datagram Sockets implementation
- **ROSE** (CVE-2022-2961) — a race condition in the X.25 ROSE packet radio protocol socket layer
- **MCTP** (CVE-2022-3977) — a use-after-free in the Management Component Transport Protocol socket layer
- **AF_RXRPC** (CVE-2023-2006) — a race condition in the RxRPC remote procedure call socket family

The 6.18.9-hs kernel that ships builds TLS, RDS, ROSE, and RxRPC as kernel modules (`CONFIG_TLS=m`, `CONFIG_RDS=m`, `CONFIG_ROSE=m`, `CONFIG_AF_RXRPC=m`). Those CVEs stay on the patch date. `CONFIG_MCTP` is not set, so CVE-2022-3977 is Not Affected.

### NFS Server

**Status**: In the 6.18.9-hs kernel (`CONFIG_NFSD=m`). Stays on the patch date.  
**Config gate**: `CONFIG_NFSD=m` on 6.18.9-hs  
**CVEs covered**: CVE-2022-43945, CVE-2022-4379, CVE-2023-1652

The kernel NFS server (`nfsd`) allows a Linux host to export filesystems to NFS clients over the network. CVE-2022-43945 describes a buffer overflow in the NFSv4 XDR decoder reachable from the network. CVE-2022-4379 describes a use-after-free in the NFSv4.1 `setclientid_confirm` handler. CVE-2023-1652 describes a use-after-free in the NFSv4 lease handling.

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NFSD=m`). These CVEs stay on the patch date.

### Filesystem Drivers

**Status**: Split by option on 6.18.9-hs  
**Config gate**: `CONFIG_NTFS3_FS=m`, `CONFIG_JFS_FS=m`, and `CONFIG_NILFS2_FS=m` on 6.18.9-hs. `CONFIG_NTFS_FS` is not set.  
**CVEs covered**: CVE-2022-48423, CVE-2022-48424, CVE-2022-48425, CVE-2023-26544, CVE-2023-26506, CVE-2023-26507, CVE-2023-2124, CVE-2020-27815, CVE-2022-2978

These CVEs cover four filesystem drivers. The CVEs include out-of-bounds reads and writes and use-after-free conditions across the NTFS3 driver (`CONFIG_NTFS3_FS`), the legacy NTFS driver (`CONFIG_NTFS_FS`), JFS (`CONFIG_JFS_FS`), and NILFS2 (`CONFIG_NILFS2_FS`). Several are triggerable by mounting a crafted filesystem image. `CONFIG_XFS_FS` is documented separately. It is a kernel module (`CONFIG_XFS_FS=m`) on the 6.18.9-hs kernel, and those CVEs stay on the patch date.

The 6.18.9-hs kernel that ships builds NTFS3, JFS, and NILFS2 as kernel modules (`CONFIG_NTFS3_FS=m`, `CONFIG_JFS_FS=m`, `CONFIG_NILFS2_FS=m`), so a CVE in one of those drivers stays on the patch date. Legacy NTFS (`CONFIG_NTFS_FS`) is not set.

### Hardware-Specific and Virtualization Drivers

**Status**: Split by option on 6.18.9-hs  
**Config gate**: `CONFIG_FPGA` is not set and the GRU symbol is absent from the 6.18.9-hs kernel; `CONFIG_DVB_CORE=m` and `CONFIG_KVM_INTEL=m` (see [Kvm](#config-kvm)) are built.  
**CVEs covered**: CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919, CVE-2022-3424, CVE-2023-26242, CVE-2022-2196

- **DVB Core** (CVE-2022-45884, CVE-2022-45885, CVE-2022-45886, CVE-2022-45919) — `CONFIG_DVB_CORE=m` on the 6.18.9-hs kernel that ships. These stay on the patch date.
- **SGI GRU** (CVE-2022-3424) — the GRU symbol is absent from the 6.18.9-hs kernel, so this CVE is Not Affected there.
- **Intel FPGA** (CVE-2023-26242) — `CONFIG_FPGA` is not set, so this CVE is Not Affected on 6.18.9-hs.
- **KVM Intel** (CVE-2022-2196) — `CONFIG_KVM_INTEL=m`. Covered under [Kvm](#config-kvm). Stays on the patch date.

KVM is built as a module on the 6.18.9-hs kernel even though Root Lock runs as a guest; see [Kvm](#config-kvm).

### USB Network Adapter and SMB Server

**Status**: Split by option on 6.18.9-hs  
**Config gate**: `CONFIG_SMB_SERVER=m` on 6.18.9-hs. `CONFIG_USB_NET_RNDIS_WLAN` is not in this config.  
**CVEs covered**: CVE-2023-23559, CVE-2023-0210

- **USB RNDIS WLAN** (CVE-2023-23559) — an integer overflow in the RNDIS wireless USB adapter driver triggerable by a physically present attacker with a crafted USB device
- **SMB Server / ksmbd** (CVE-2023-0210) — a heap out-of-bounds read in `ksmbd`, the in-kernel SMB server, reachable from the network without authentication via a crafted SMB2 `NEGOTIATE` request

The 6.18.9-hs kernel that ships builds the in-kernel SMB server as a kernel module (`CONFIG_SMB_SERVER=m`). CVE-2023-0210 stays on the patch date. `CONFIG_USB_NET_RNDIS_WLAN` is not in this config, so CVE-2023-23559 stays on the Not Affected row.

### Ntfs3 Fs {#config-ntfs3-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NTFS3_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_NTFS3_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2022-48502

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NTFS3_FS=m`). These CVEs stay on the patch date.

### Traffic Control: cls_flower {#tc-cls-flower}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_CLS_FLOWER=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_CLS_FLOWER=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-35788

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_CLS_FLOWER=m`). These CVEs stay on the patch date.

### CAN Bus

**Status**: In the 6.18.9-hs kernel (`CONFIG_CAN=m`). Stays on the patch date.
**Config gate**: `CONFIG_CAN=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-3090, CVE-2023-3389, CVE-2023-3609, CVE-2023-3611, CVE-2023-3776, CVE-2023-4206, CVE-2023-4207, CVE-2023-4208, CVE-2023-4622, CVE-2023-4921, CVE-2023-5717, CVE-2023-46813, CVE-2023-6931, CVE-2023-6932, CVE-2023-6546, CVE-2023-6270, CVE-2024-25744, CVE-2023-52438, CVE-2023-52439, CVE-2023-52474, CVE-2023-52501

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_CAN=m`). These CVEs stay on the patch date.

### Smb Server {#config-smb-server}

**Status**: In the 6.18.9-hs kernel (`CONFIG_SMB_SERVER=m`). Stays on the patch date.
**Config gate**: `CONFIG_SMB_SERVER=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-32250, CVE-2023-32254, CVE-2023-32247, CVE-2023-32248, CVE-2023-32252, CVE-2023-32257, CVE-2023-32258, CVE-2024-22705, CVE-2023-52441, CVE-2024-26592, CVE-2024-26594, CVE-2023-52480

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_SMB_SERVER=m`). These CVEs stay on the patch date.

### HFS Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_HFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_HFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-4623

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_HFS_FS=m`). These CVEs stay on the patch date.

### Ceph Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_CEPH_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_CEPH_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-44466

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_CEPH_FS=m`). These CVEs stay on the patch date.

### NVMe Driver

**Status**: In the 6.18.9-hs kernel (`CONFIG_NVME_CORE=y`). Stays on the patch date.
**Config gate**: `CONFIG_NVME_CORE=y` on 6.18.9-hs
**CVEs covered**: CVE-2023-5178, CVE-2023-6356, CVE-2023-6536

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_NVME_CORE=y`). These CVEs stay on the patch date.

### CIFS/SMB Client {#cifs-smb-client}

**Status**: In the 6.18.9-hs kernel (`CONFIG_CIFS=m`). Stays on the patch date.
**Config gate**: `CONFIG_CIFS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-1194, CVE-2023-52434, CVE-2023-52440

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_CIFS=m`). These CVEs stay on the patch date.

### ATM Protocol

**Status**: In the 6.18.9-hs kernel (`CONFIG_ATM=m`). Stays on the patch date.
**Config gate**: `CONFIG_ATM=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-51780

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_ATM=m`). These CVEs stay on the patch date.

### Rose {#config-rose}

**Status**: In the 6.18.9-hs kernel (`CONFIG_ROSE=m`). Stays on the patch date.
**Config gate**: `CONFIG_ROSE=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-51782

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_ROSE=m`). These CVEs stay on the patch date.

### Tls {#config-tls}

**Status**: In the 6.18.9-hs kernel (`CONFIG_TLS=m`). Stays on the patch date.
**Config gate**: `CONFIG_TLS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-0646

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_TLS=m`). These CVEs stay on the patch date.

### DCCP Protocol

**Status**: Not Affected
**Config gate**: `CONFIG_IP_DCCP` not set
**CVEs covered**: CVE-2023-39197

`CONFIG_IP_DCCP` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### AMD GPU (amdgpu) {#amdgpu-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DRM_AMDGPU=m`). Stays on the patch date.
**Config gate**: `CONFIG_DRM_AMDGPU=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-51042

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DRM_AMDGPU=m`). These CVEs stay on the patch date.

### F2FS Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_F2FS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_F2FS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52436, CVE-2023-52444

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_F2FS_FS=m`). These CVEs stay on the patch date.

### Atheros Wireless Driver {#ath-wireless-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_ATH` not set
**CVEs covered**: CVE-2023-52464

`CONFIG_ATH` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Mctp {#config-mctp}

**Status**: Not Affected
**Config gate**: `CONFIG_MCTP` not set
**CVEs covered**: CVE-2023-52483

`CONFIG_MCTP` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### FUSE Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_FUSE_FS=y`). Stays on the patch date.
**Config gate**: `CONFIG_FUSE_FS=y` on 6.18.9-hs
**CVEs covered**: CVE-2023-52504

The 6.18.9-hs kernel that ships builds FUSE in (`CONFIG_FUSE_FS=y`), so scanner findings for these CVEs are real on that kernel.

### NFC

**Status**: In the 6.18.9-hs kernel (`CONFIG_NFC=m`). Stays on the patch date.
**Config gate**: `CONFIG_NFC=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52507

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NFC=m`). These CVEs stay on the patch date.

### Renesas Ethernet AVB Driver {#ravb-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RAVB` not set
**CVEs covered**: CVE-2023-52509

`CONFIG_RAVB` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### IEEE 802.15.4 (WPAN) {#ieee802154-wpan}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IEEE802154=m`). Stays on the patch date.
**Config gate**: `CONFIG_IEEE802154=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52510

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IEEE802154=m`). These CVEs stay on the patch date.

### InfiniBand / RDMA {#infiniband-rdma}

**Status**: In the 6.18.9-hs kernel (`CONFIG_INFINIBAND=m`). Stays on the patch date.
**Config gate**: `CONFIG_INFINIBAND=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52515, CVE-2024-26872

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_INFINIBAND=m`). These CVEs stay on the patch date.

### Spi Sun6I {#config-spi-sun6i}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_SUN6I` not set
**CVEs covered**: CVE-2023-52517

`CONFIG_SPI_SUN6I` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Intel WiFi (iwlwifi) {#iwlwifi-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IWLWIFI=m`). Stays on the patch date.
**Config gate**: `CONFIG_IWLWIFI=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52531, CVE-2024-26610

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IWLWIFI=m`). These CVEs stay on the patch date.

### Security Tomoyo {#config-security-tomoyo}

**Status**: In the 6.18.9-hs kernel (`CONFIG_SECURITY_TOMOYO=y`). Stays on the patch date.
**Config gate**: `CONFIG_SECURITY_TOMOYO=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-26622

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_SECURITY_TOMOYO=y`). These CVEs stay on the patch date.

### Drm Msm {#config-drm-msm}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_MSM` not set
**CVEs covered**: CVE-2023-52586

`CONFIG_DRM_MSM` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### S390 {#config-s390}

**Status**: Not Affected
**Config gate**: `CONFIG_S390` not set
**CVEs covered**: CVE-2023-52598, CVE-2024-26957

`CONFIG_S390` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Jfs Fs {#config-jfs-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_JFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_JFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52599, CVE-2023-52600, CVE-2023-52603, CVE-2023-52604

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_JFS_FS=m`). These CVEs stay on the patch date.

### Llc {#config-llc}

**Status**: In the 6.18.9-hs kernel (`CONFIG_LLC=m`). Stays on the patch date.
**Config gate**: `CONFIG_LLC=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26625

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_LLC=m`). These CVEs stay on the patch date.

### Mhi Bus {#config-mhi-bus}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MHI_BUS=m`). Stays on the patch date.
**Config gate**: `CONFIG_MHI_BUS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52494

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MHI_BUS=m`). These CVEs stay on the patch date.

### Ip Tunnel {#config-ip-tunnel}

**Status**: Not Affected
**Config gate**: `CONFIG_IP_TUNNEL` not set
**CVEs covered**: CVE-2024-26665

`CONFIG_IP_TUNNEL` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Afs Fs {#config-afs-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_AFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_AFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26736

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_AFS_FS=m`). These CVEs stay on the patch date.

### Traffic Control: act_mirred {#tc-act-mirred}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_ACT_MIRRED=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_ACT_MIRRED=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26739

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_ACT_MIRRED=m`). These CVEs stay on the patch date.

### Usb Cdns3 {#config-usb-cdns3}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_CDNS3` not set
**CVEs covered**: CVE-2024-26748, CVE-2024-26749

`CONFIG_USB_CDNS3` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Crypto Dev Virtio {#config-crypto-dev-virtio}

**Status**: In the 6.18.9-hs kernel (`CONFIG_CRYPTO_DEV_VIRTIO=m`). Stays on the patch date.
**Config gate**: `CONFIG_CRYPTO_DEV_VIRTIO=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26753

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_CRYPTO_DEV_VIRTIO=m`). These CVEs stay on the patch date.

### Gtp {#config-gtp}

**Status**: In the 6.18.9-hs kernel (`CONFIG_GTP=m`). Stays on the patch date.
**Config gate**: `CONFIG_GTP=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26754, CVE-2024-26793

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_GTP=m`). These CVEs stay on the patch date.

### Dm Crypt {#config-dm-crypt}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DM_CRYPT=m`). Stays on the patch date.
**Config gate**: `CONFIG_DM_CRYPT=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26763

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DM_CRYPT=m`). These CVEs stay on the patch date.

### MPTCP

**Status**: In the 6.18.9-hs kernel (`CONFIG_MPTCP=y`). Stays on the patch date.
**Config gate**: `CONFIG_MPTCP=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-26782

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_MPTCP=y`). These CVEs stay on the patch date.

### Btrfs Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_BTRFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_BTRFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26791, CVE-2024-26944, CVE-2024-35849, CVE-2024-35949, CVE-2024-39496, CVE-2024-42314, CVE-2024-50217, CVE-2024-56581, CVE-2024-56582, CVE-2024-56759, CVE-2024-57896, CVE-2025-39738, CVE-2025-39759, CVE-2022-50300

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BTRFS_FS=m`). These CVEs stay on the patch date.

### Thinkpad Lmi {#config-thinkpad-lmi}

**Status**: In the 6.18.9-hs kernel (`CONFIG_THINKPAD_LMI=m`). Stays on the patch date.
**Config gate**: `CONFIG_THINKPAD_LMI=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26836

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_THINKPAD_LMI=m`). These CVEs stay on the patch date.

### Sparx5 Switch {#config-sparx5-switch}

**Status**: Not Affected
**Config gate**: `CONFIG_SPARX5_SWITCH` not set
**CVEs covered**: CVE-2024-26856

`CONFIG_SPARX5_SWITCH` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Rds {#config-rds}

**Status**: In the 6.18.9-hs kernel (`CONFIG_RDS=m`). Stays on the patch date.
**Config gate**: `CONFIG_RDS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26865, CVE-2022-48637, CVE-2024-27024

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_RDS=m`). These CVEs stay on the patch date.

### TUN/TAP Driver {#tun-tap-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_TUN=m`). Stays on the patch date.
**Config gate**: `CONFIG_TUN=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26882

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_TUN=m`). These CVEs stay on the patch date.

### Mlxbf I2C {#config-mlxbf-i2c}

**Status**: Not Affected
**Config gate**: `CONFIG_MLXBF_I2C` not set
**CVEs covered**: CVE-2022-48632

`CONFIG_MLXBF_I2C` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### ARM64 Architecture {#arm64-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_ARM64` not set
**CVEs covered**: CVE-2022-48657, CVE-2024-26989

`CONFIG_ARM64` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Nilfs2 Fs {#config-nilfs2-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NILFS2_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_NILFS2_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26955, CVE-2024-26956, CVE-2024-26981

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NILFS2_FS=m`). These CVEs stay on the patch date.

### Common Clk Qcom {#config-common-clk-qcom}

**Status**: Not Affected
**Config gate**: `CONFIG_COMMON_CLK_QCOM` not set
**CVEs covered**: CVE-2024-26965

`CONFIG_COMMON_CLK_QCOM` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### USB Gadget

**Status**: In the 6.18.9-hs kernel (`CONFIG_USB_GADGET=m`). Stays on the patch date.
**Config gate**: `CONFIG_USB_GADGET=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-26996

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_USB_GADGET=m`). These CVEs stay on the patch date.

### Nouveau (NVIDIA open-source) {#nouveau-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DRM_NOUVEAU=m`). Stays on the patch date.
**Config gate**: `CONFIG_DRM_NOUVEAU=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-27008

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DRM_NOUVEAU=m`). These CVEs stay on the patch date.

### Dvb Core {#config-dvb-core}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DVB_CORE=m`). Stays on the patch date.
**Config gate**: `CONFIG_DVB_CORE=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-27075

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DVB_CORE=m`). These CVEs stay on the patch date.

### Peci {#config-peci}

**Status**: Not Affected
**Config gate**: `CONFIG_PECI` not set
**CVEs covered**: CVE-2022-48670

`CONFIG_PECI` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Of {#config-of}

**Status**: Not Affected
**Config gate**: `CONFIG_OF` not set
**CVEs covered**: CVE-2022-48672

`CONFIG_OF` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### EROFS Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_EROFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_EROFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2022-48674

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_EROFS_FS=m`). These CVEs stay on the patch date.

### Open vSwitch {#openvswitch}

**Status**: In the 6.18.9-hs kernel (`CONFIG_OPENVSWITCH=m`). Stays on the patch date.
**Config gate**: `CONFIG_OPENVSWITCH=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-27395

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_OPENVSWITCH=m`). These CVEs stay on the patch date.

### FireWire

**Status**: In the 6.18.9-hs kernel (`CONFIG_FIREWIRE=m`). Stays on the patch date.
**Config gate**: `CONFIG_FIREWIRE=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-27401

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_FIREWIRE=m`). These CVEs stay on the patch date.

### Kvm {#config-kvm}

**Status**: In the 6.18.9-hs kernel (`CONFIG_KVM=m`, `CONFIG_KVM_INTEL=m`). Stays on the patch date.
**Config gate**: `CONFIG_KVM=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-35791, CVE-2022-2196

The 6.18.9-hs kernel that ships builds KVM as modules (`CONFIG_KVM=m`, `CONFIG_KVM_INTEL=m`), so scanner findings for these CVEs, including the Intel nested-VMX case CVE-2022-2196, are real on that kernel. Root Lock runs as a guest and hosting virtual machines on this kernel is not a supported product role, but the module is still in the kernel, so these CVEs stay on the patch date.

### Aquantia Atlantic Driver {#atlantic-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_ATLANTIC` not set
**CVEs covered**: CVE-2023-52664

`CONFIG_ATLANTIC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Mellanox mlx5 Driver {#mlx5-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MLX5_CORE=m`). Stays on the patch date.
**Config gate**: `CONFIG_MLX5_CORE=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52667

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MLX5_CORE=m`). These CVEs stay on the patch date.

### AX.25 / Ham Radio {#ax25-hamradio}

**Status**: In the 6.18.9-hs kernel (`CONFIG_AX25=m`). Stays on the patch date.
**Config gate**: `CONFIG_AX25=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-35887

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_AX25=m`). These CVEs stay on the patch date.

### Dma Direct Remap {#config-dma-direct-remap}

**Status**: Not Affected
**Config gate**: `CONFIG_DMA_DIRECT_REMAP` not set
**CVEs covered**: CVE-2024-35939

`CONFIG_DMA_DIRECT_REMAP` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Fb {#config-fb}

**Status**: In the 6.18.9-hs kernel (`CONFIG_FB=y`). Stays on the patch date.
**Config gate**: `CONFIG_FB=y` on 6.18.9-hs
**CVEs covered**: CVE-2023-52731

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_FB=y`). These CVEs stay on the patch date.

### GFS2 Shared Filesystem {#gfs2-filesystem}

**Status**: In the 6.18.9-hs kernel (`CONFIG_GFS2_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_GFS2_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52760

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_GFS2_FS=m`). These CVEs stay on the patch date.

### GSPCA USB Webcam Driver {#gspca-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_GSPCA_CORE` not set
**CVEs covered**: CVE-2023-52764

`CONFIG_USB_GSPCA_CORE` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### SMC (RDMA over Converged Ethernet) {#smc-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_SMC` not set
**CVEs covered**: CVE-2023-52775

`CONFIG_SMC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### IPVLAN Driver {#ipvlan}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IPVLAN=m`). Stays on the patch date.
**Config gate**: `CONFIG_IPVLAN=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52796

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IPVLAN=m`). These CVEs stay on the patch date.

### HiSilicon HNS3 Driver {#hns3-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_HNS3` not set
**CVEs covered**: CVE-2023-52807

`CONFIG_HNS3` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### KVM AMD

**Status**: In the 6.18.9-hs kernel (`CONFIG_KVM_AMD=m`). Stays on the patch date.
**Config gate**: `CONFIG_KVM_AMD=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52816

The 6.18.9-hs kernel that ships builds KVM AMD as a module (`CONFIG_KVM_AMD=m`), so scanner findings for these CVEs are real on that kernel.

### Network Block Device (NBD) {#nbd-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_BLK_DEV_NBD=m`). Stays on the patch date.
**Config gate**: `CONFIG_BLK_DEV_NBD=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52837

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BLK_DEV_NBD=m`). These CVEs stay on the patch date.

### Synaptics RMI4 Driver {#rmi4-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_RMI4_CORE=m`). Stays on the patch date.
**Config gate**: `CONFIG_RMI4_CORE=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52840

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_RMI4_CORE=m`). These CVEs stay on the patch date.

### Bt848 Video Capture Driver {#bttv-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VIDEO_BT848=m`). Stays on the patch date.
**Config gate**: `CONFIG_VIDEO_BT848=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52847

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VIDEO_BT848=m`). These CVEs stay on the patch date.

### Hw Perf Events Hisi {#config-hw-perf-events-hisi}

**Status**: Not Affected
**Config gate**: `CONFIG_HW_PERF_EVENTS_HISI` not set
**CVEs covered**: CVE-2023-52859

`CONFIG_HW_PERF_EVENTS_HISI` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### WMI Driver

**Status**: Not Affected
**Config gate**: `CONFIG_WMI` not set
**CVEs covered**: CVE-2023-52864

`CONFIG_WMI` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### AMD Radeon GPU {#radeon-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DRM_RADEON=m`). Stays on the patch date.
**Config gate**: `CONFIG_DRM_RADEON=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52867

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DRM_RADEON=m`). These CVEs stay on the patch date.

### Parallel Port Device {#ppdev-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_PPDEV=m`). Stays on the patch date.
**Config gate**: `CONFIG_PPDEV=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-36015

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_PPDEV=m`). These CVEs stay on the patch date.

### TIPC Protocol

**Status**: In the 6.18.9-hs kernel (`CONFIG_TIPC=m`). Stays on the patch date.
**Config gate**: `CONFIG_TIPC=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-36886

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_TIPC=m`). These CVEs stay on the patch date.

### GPIO Library {#gpiolib}

**Status**: In the 6.18.9-hs kernel (`CONFIG_GPIOLIB=y`). Stays on the patch date.
**Config gate**: `CONFIG_GPIOLIB=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-36898, CVE-2024-36899

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_GPIOLIB=y`). These CVEs stay on the patch date.

### Pin Controller Subsystem {#pinctrl}

**Status**: In the 6.18.9-hs kernel (`CONFIG_PINCTRL=y`). Stays on the patch date.
**Config gate**: `CONFIG_PINCTRL=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-36940

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_PINCTRL=y`). These CVEs stay on the patch date.

### VMware SVGA (vmwgfx) {#vmwgfx-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DRM_VMWGFX=m`). Stays on the patch date.
**Config gate**: `CONFIG_DRM_VMWGFX=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-36960

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DRM_VMWGFX=m`). These CVEs stay on the patch date.

### Traffic Control: sch_multiq {#tc-multiq}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_SCH_MULTIQ=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_SCH_MULTIQ=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-36978

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_SCH_MULTIQ=m`). These CVEs stay on the patch date.

### IMA (Integrity Measurement Architecture) {#ima}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IMA=y`). Stays on the patch date.
**Config gate**: `CONFIG_IMA=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-38667

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_IMA=y`, `CONFIG_IMA_APPRAISE=y`). These CVEs stay on the patch date.

Boot-path protection in Root Lock seals the kernel image directory and `/boot` under Lockdown with `chattr +i`, so those files cannot be modified while the Root Lock kernel is running. `CONFIG_KEXEC_FILE` is not set. Secure Boot is not enforced or verified by Root Lock; if Secure Boot is required, it must be configured at the firmware and bootloader level independently.

### PowerPC Architecture {#powerpc-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_PPC` not set
**CVEs covered**: CVE-2024-40974

`CONFIG_PPC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Xfs Fs {#config-xfs-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_XFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_XFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-41013, CVE-2024-41014

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_XFS_FS=m`). These CVEs stay on the patch date.

### HFS+ Filesystem {#hfsplus-filesystem}

**Status**: In the 6.18.9-hs kernel (`CONFIG_HFSPLUS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_HFSPLUS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-41059

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_HFSPLUS_FS=m`). These CVEs stay on the patch date.

### ISDN

**Status**: In the 6.18.9-hs kernel (`CONFIG_ISDN=y`). Stays on the patch date.
**Config gate**: `CONFIG_ISDN=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-42280

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_ISDN=y`). These CVEs stay on the patch date.

### Platform X86 {#config-platform-x86}

**Status**: Not Affected
**Config gate**: `CONFIG_PLATFORM_X86` not set
**CVEs covered**: CVE-2024-46859

`CONFIG_PLATFORM_X86` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### OCFS2 Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_OCFS2_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_OCFS2_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-47670

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_OCFS2_FS=m`). These CVEs stay on the patch date.

### Xen Hypervisor

**Status**: In the 6.18.9-hs kernel (`CONFIG_XEN=y`). Stays on the patch date.
**Config gate**: `CONFIG_XEN=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-49936

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_XEN=y`). These CVEs stay on the patch date.

### PPP

**Status**: In the 6.18.9-hs kernel (`CONFIG_PPP=m`). Stays on the patch date.
**Config gate**: `CONFIG_PPP=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-50033, CVE-2024-50035

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_PPP=m`). These CVEs stay on the patch date.

### QCOM RmNet Driver {#rmnet-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_RMNET` not set
**CVEs covered**: CVE-2024-50128

`CONFIG_RMNET` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### UDF Filesystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_UDF_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_UDF_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-50143

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_UDF_FS=m`). These CVEs stay on the patch date.

### LoongArch Architecture {#loongarch-arch}

**Status**: Not Affected
**Config gate**: `CONFIG_LOONGARCH` not set
**CVEs covered**: CVE-2024-56628

`CONFIG_LOONGARCH` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Realtek WiFi Driver {#rtlwifi-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_RTLWIFI=m`). Stays on the patch date.
**Config gate**: `CONFIG_RTLWIFI=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-58072

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_RTLWIFI=m`). These CVEs stay on the patch date.

### Broadcom WiFi Driver {#brcmfmac-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_BRCMFMAC=m`). Stays on the patch date.
**Config gate**: `CONFIG_BRCMFMAC=m` on 6.18.9-hs
**CVEs covered**: CVE-2022-49740

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BRCMFMAC=m`). These CVEs stay on the patch date.

### MemStick Driver {#memstick}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MEMSTICK=m`). Stays on the patch date.
**Config gate**: `CONFIG_MEMSTICK=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-22020

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MEMSTICK=m`). These CVEs stay on the patch date.

### SCTP Protocol

**Status**: In the 6.18.9-hs kernel (`CONFIG_IP_SCTP=m`). Stays on the patch date.
**Config gate**: `CONFIG_IP_SCTP=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-23142

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IP_SCTP=m`). These CVEs stay on the patch date.

### Ntfs Fs {#config-ntfs-fs}

**Status**: Not Affected
**Config gate**: `CONFIG_NTFS_FS` not set
**CVEs covered**: CVE-2022-49763

`CONFIG_NTFS_FS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Net Sch Qfq {#config-net-sch-qfq}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_SCH_QFQ=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_SCH_QFQ=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-37913

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_SCH_QFQ=m`). These CVEs stay on the patch date.

### Af Rxrpc {#config-af-rxrpc}

**Status**: In the 6.18.9-hs kernel (`CONFIG_AF_RXRPC=m`). Stays on the patch date.
**Config gate**: `CONFIG_AF_RXRPC=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-53218

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_AF_RXRPC=m`). These CVEs stay on the patch date.

### Marvell WiFi Driver {#mwifiex-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MWIFIEX=m`). Stays on the patch date.
**Config gate**: `CONFIG_MWIFIEX=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-39891

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MWIFIEX=m`). These CVEs stay on the patch date.

### Microchip WILC1000 WiFi Driver {#wilc1000-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_WILC1000` not set
**CVEs covered**: CVE-2025-39952

`CONFIG_WILC1000` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Traffic Control: cls_u32 {#tc-cls-u32}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_CLS_U32=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_CLS_U32=m` on 6.18.9-hs
**CVEs covered**: CVE-2026-23204

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_CLS_U32=m`). These CVEs stay on the patch date.

### SAA7134 Media Driver {#saa7134-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VIDEO_SAA7134=m`). Stays on the patch date.
**Config gate**: `CONFIG_VIDEO_SAA7134=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-35823

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VIDEO_SAA7134=m`). These CVEs stay on the patch date.

### DM1105 DVB Driver {#dm1105-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_DM1105` not set
**CVEs covered**: CVE-2023-35824

`CONFIG_VIDEO_DM1105` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Allwinner Cedrus Video Codec {#cedrus-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_SUNXI_CEDRUS` not set
**CVEs covered**: CVE-2023-35826

`CONFIG_VIDEO_SUNXI_CEDRUS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Renesas USB3 Driver {#renesas-usb3}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_RENESAS_USBHS3` not set
**CVEs covered**: CVE-2023-35828

`CONFIG_USB_RENESAS_USBHS3` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Rockchip Video Decoder {#rkvdec-driver}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_RKVDEC` not set
**CVEs covered**: CVE-2023-35829

`CONFIG_VIDEO_RKVDEC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Intel IGB Ethernet Driver {#igb-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IGB=m`). Stays on the patch date.
**Config gate**: `CONFIG_IGB=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-45871

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IGB=m`). These CVEs stay on the patch date.

### AppleTalk Protocol {#appletalk}

**Status**: In the 6.18.9-hs kernel (`CONFIG_ATALK=m`). Stays on the patch date.
**Config gate**: `CONFIG_ATALK=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-51781

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_ATALK=m`). These CVEs stay on the patch date.

### Hauppauge pvrusb2 Driver {#pvrusb2-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VIDEO_PVRUSB2=m`). Stays on the patch date.
**Config gate**: `CONFIG_VIDEO_PVRUSB2=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52445

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VIDEO_PVRUSB2=m`). These CVEs stay on the patch date.

### PWM Subsystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_PWM=y`). Stays on the patch date.
**Config gate**: `CONFIG_PWM=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-26599

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_PWM=y`). These CVEs stay on the patch date.

### Griffin PowerMate Driver {#powermate-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_INPUT_POWERMATE=m`). Stays on the patch date.
**Config gate**: `CONFIG_INPUT_POWERMATE=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52475

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_INPUT_POWERMATE=m`). These CVEs stay on the patch date.

### TEE Subsystem

**Status**: In the 6.18.9-hs kernel (`CONFIG_TEE=m`). Stays on the patch date.
**Config gate**: `CONFIG_TEE=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-52503

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_TEE=m`). These CVEs stay on the patch date.

### Bonding {#config-bonding}

**Status**: In the 6.18.9-hs kernel (`CONFIG_BONDING=m`). Stays on the patch date.
**Config gate**: `CONFIG_BONDING=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-39487, CVE-2026-23099

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BONDING=m`). These CVEs stay on the patch date.

### Vmware Vmci {#config-vmware-vmci}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VMWARE_VMCI=m`). Stays on the patch date.
**Config gate**: `CONFIG_VMWARE_VMCI=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-39499, CVE-2024-46738, CVE-2025-38403

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VMWARE_VMCI=m`). These CVEs stay on the patch date.

### Wwan {#config-wwan}

**Status**: In the 6.18.9-hs kernel (`CONFIG_WWAN=m`). Stays on the patch date.
**Config gate**: `CONFIG_WWAN=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-40939

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_WWAN=m`). These CVEs stay on the patch date.

### Cachefiles {#config-cachefiles}

**Status**: In the 6.18.9-hs kernel (`CONFIG_CACHEFILES=m`). Stays on the patch date.
**Config gate**: `CONFIG_CACHEFILES=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-41050, CVE-2024-41057, CVE-2024-41074

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_CACHEFILES=m`). These CVEs stay on the patch date.

### Snd Soc {#config-snd-soc}

**Status**: In the 6.18.9-hs kernel (`CONFIG_SND_SOC=m`). Stays on the patch date.
**Config gate**: `CONFIG_SND_SOC=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-41069, CVE-2022-50325

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_SND_SOC=m`). These CVEs stay on the patch date.

### Iio {#config-iio}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IIO=m`). Stays on the patch date.
**Config gate**: `CONFIG_IIO=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-42086, CVE-2024-57906, CVE-2024-57907, CVE-2024-57908, CVE-2024-57910, CVE-2024-57911, CVE-2024-57912, CVE-2022-49792, CVE-2025-38485

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IIO=m`). These CVEs stay on the patch date.

### Vhost Vsock {#config-vhost-vsock}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VHOST_VSOCK=m`). Stays on the patch date.
**Config gate**: `CONFIG_VHOST_VSOCK=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-43873

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VHOST_VSOCK=m`). These CVEs stay on the patch date.

### Net Fou {#config-net-fou}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_FOU=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_FOU=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-44940, CVE-2026-23083

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_FOU=m`). These CVEs stay on the patch date.

### Parisc {#config-parisc}

**Status**: Not Affected
**Config gate**: `CONFIG_PARISC` not set
**CVEs covered**: CVE-2024-44949, CVE-2022-50518

`CONFIG_PARISC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Net Sch Netem {#config-net-sch-netem}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_SCH_NETEM=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_SCH_NETEM=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-46800

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_SCH_NETEM=m`). These CVEs stay on the patch date.

### Uml {#config-uml}

**Status**: Not Affected
**Config gate**: `CONFIG_UML` not set
**CVEs covered**: CVE-2024-46844

`CONFIG_UML` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Spi Nxp Flexspi {#config-spi-nxp-flexspi}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_NXP_FLEXSPI` not set
**CVEs covered**: CVE-2024-46853

`CONFIG_SPI_NXP_FLEXSPI` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Vdpa {#config-vdpa}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VDPA=m`). Stays on the patch date.
**Config gate**: `CONFIG_VDPA=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-47748, CVE-2024-53126, CVE-2023-53082, CVE-2023-53543

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VDPA=m`). These CVEs stay on the patch date.

### Usb Serial {#config-usb-serial}

**Status**: In the 6.18.9-hs kernel (`CONFIG_USB_SERIAL=m`). Stays on the patch date.
**Config gate**: `CONFIG_USB_SERIAL=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-50267

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_USB_SERIAL=m`). These CVEs stay on the patch date.

### Usb Musb Hdrc {#config-usb-musb-hdrc}

**Status**: Not Affected
**Config gate**: `CONFIG_USB_MUSB_HDRC` not set
**CVEs covered**: CVE-2024-50269

`CONFIG_USB_MUSB_HDRC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Superh {#config-superh}

**Status**: Not Affected
**Config gate**: `CONFIG_SUPERH` not set
**CVEs covered**: CVE-2024-53165

`CONFIG_SUPERH` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Spi Mpc52Xx {#config-spi-mpc52xx}

**Status**: Not Affected
**Config gate**: `CONFIG_SPI_MPC52xx` not set
**CVEs covered**: CVE-2024-50051

`CONFIG_SPI_MPC52xx` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Pktgen {#config-pktgen}

**Status**: Not Affected
**Config gate**: `CONFIG_PKTGEN` not set
**CVEs covered**: CVE-2025-21680

`CONFIG_PKTGEN` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Orangefs Fs {#config-orangefs-fs}

**Status**: In the 6.18.9-hs kernel (`CONFIG_ORANGEFS_FS=m`). Stays on the patch date.
**Config gate**: `CONFIG_ORANGEFS_FS=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-21782

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_ORANGEFS_FS=m`). These CVEs stay on the patch date.

### Geneve {#config-geneve}

**Status**: In the 6.18.9-hs kernel (`CONFIG_GENEVE=m`). Stays on the patch date.
**Config gate**: `CONFIG_GENEVE=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-21858

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_GENEVE=m`). These CVEs stay on the patch date.

### Slimbus {#config-slimbus}

**Status**: In the 6.18.9-hs kernel (`CONFIG_SLIMBUS=m`). Stays on the patch date.
**Config gate**: `CONFIG_SLIMBUS=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-21914

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_SLIMBUS=m`). These CVEs stay on the patch date.

### Udmabuf {#config-udmabuf}

**Status**: In the 6.18.9-hs kernel (`CONFIG_UDMABUF=y`). Stays on the patch date.
**Config gate**: `CONFIG_UDMABUF=y` on 6.18.9-hs
**CVEs covered**: CVE-2025-37803

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_UDMABUF=y`). These CVEs stay on the patch date.

### Mcb {#config-mcb}

**Status**: Not Affected
**Config gate**: `CONFIG_MCB` not set
**CVEs covered**: CVE-2025-37817

`CONFIG_MCB` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Staging {#config-staging}

**Status**: In the 6.18.9-hs kernel (`CONFIG_STAGING=y`). Stays on the patch date.
**Config gate**: `CONFIG_STAGING=y` on 6.18.9-hs
**CVEs covered**: CVE-2022-49956, CVE-2023-53554

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_STAGING=y`). These CVEs stay on the patch date.

### Coresight {#config-coresight}

**Status**: Not Affected
**Config gate**: `CONFIG_CORESIGHT` not set
**CVEs covered**: CVE-2025-38131

`CONFIG_CORESIGHT` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Ipv6 Seg6 Lwtunnel {#config-ipv6-seg6-lwtunnel}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IPV6_SEG6_LWTUNNEL=y`). Stays on the patch date.
**Config gate**: `CONFIG_IPV6_SEG6_LWTUNNEL=y` on 6.18.9-hs
**CVEs covered**: CVE-2025-38476

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_IPV6_SEG6_LWTUNNEL=y`). These CVEs stay on the patch date.

### Comedi {#config-comedi}

**Status**: In the 6.18.9-hs kernel (`CONFIG_COMEDI=m`). Stays on the patch date.
**Config gate**: `CONFIG_COMEDI=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-38482, CVE-2025-38483, CVE-2025-38529, CVE-2025-38530, CVE-2025-39685, CVE-2025-39686

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_COMEDI=m`). These CVEs stay on the patch date.

### Nubus {#config-nubus}

**Status**: Not Affected
**Config gate**: `CONFIG_NUBUS` not set
**CVEs covered**: CVE-2023-53217

`CONFIG_NUBUS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Xdp Sockets {#config-xdp-sockets}

**Status**: Not Affected
**Config gate**: `CONFIG_XDP_SOCKETS` not set
**CVEs covered**: CVE-2023-53426

`CONFIG_XDP_SOCKETS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Ptp 1588 Clock Ocp {#config-ptp-1588-clock-ocp}

**Status**: In the 6.18.9-hs kernel (`CONFIG_PTP_1588_CLOCK_OCP=m`). Stays on the patch date.
**Config gate**: `CONFIG_PTP_1588_CLOCK_OCP=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-39859

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_PTP_1588_CLOCK_OCP=m`). These CVEs stay on the patch date.

### Trace Buf {#config-trace-buf}

**Status**: Not Affected
**Config gate**: `CONFIG_TRACE_BUF` not set
**CVEs covered**: CVE-2023-53587

`CONFIG_TRACE_BUF` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Dlm {#config-dlm}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DLM=m`). Stays on the patch date.
**Config gate**: `CONFIG_DLM=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-53629

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DLM=m`). These CVEs stay on the patch date.

### Net Team {#config-net-team}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NET_TEAM=m`). Stays on the patch date.
**Config gate**: `CONFIG_NET_TEAM=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-71091

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NET_TEAM=m`). These CVEs stay on the patch date.

### Macvlan {#config-macvlan}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MACVLAN=m`). Stays on the patch date.
**Config gate**: `CONFIG_MACVLAN=m` on 6.18.9-hs
**CVEs covered**: CVE-2026-23001, CVE-2026-23209

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MACVLAN=m`). These CVEs stay on the patch date.

### Netfilter OS fingerprint {#config-netfilter-netlink-osf}

**Status**: In the 6.18.9-hs kernel (`CONFIG_NETFILTER_NETLINK_OSF=m`). Stays on the patch date.
**Config gate**: `CONFIG_NETFILTER_NETLINK_OSF=m` on 6.18.9-hs
**CVEs covered**: CVE-2026-23397

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_NETFILTER_NETLINK_OSF=m`). These CVEs stay on the patch date.

### HackRF {#config-usb-hackrf}

**Status**: In the 6.18.9-hs kernel (`CONFIG_USB_HACKRF=m`). Stays on the patch date.
**Config gate**: `CONFIG_USB_HACKRF=m` on 6.18.9-hs
**CVEs covered**: CVE-2026-31576

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_USB_HACKRF=m`). These CVEs stay on the patch date.

### Empia EM28xx video {#config-video-em28xx-v4l2}

**Status**: In the 6.18.9-hs kernel (`CONFIG_VIDEO_EM28XX_V4L2=m`). Stays on the patch date.
**Config gate**: `CONFIG_VIDEO_EM28XX_V4L2=m` on 6.18.9-hs
**CVEs covered**: CVE-2026-31583

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_VIDEO_EM28XX_V4L2=m`). These CVEs stay on the patch date.

### Security Apparmor {#config-security-apparmor}

**Status**: In the 6.18.9-hs kernel (`CONFIG_SECURITY_APPARMOR=y`). Stays on the patch date.
**Config gate**: `CONFIG_SECURITY_APPARMOR=y` on 6.18.9-hs
**CVEs covered**: CVE-2026-23408

The 6.18.9-hs kernel that ships builds AppArmor in (`CONFIG_SECURITY_APPARMOR=y`), so a scanner finding for this CVE is real on that kernel.

### Rcu Nocb Cpu {#config-rcu-nocb-cpu}

**Status**: In the 6.18.9-hs kernel (`CONFIG_RCU_NOCB_CPU=y`). Stays on the patch date.
**Config gate**: `CONFIG_RCU_NOCB_CPU=y` on 6.18.9-hs
**CVEs covered**: CVE-2024-35929, CVE-2025-38704

The 6.18.9-hs kernel that ships builds this option in (`CONFIG_RCU_NOCB_CPU=y`). These CVEs stay on the patch date.

### Debug Mutexes {#config-debug-mutexes}

**Status**: Not Affected
**Config gate**: `CONFIG_DEBUG_MUTEXES` not set
**CVEs covered**: CVE-2023-52836

`CONFIG_DEBUG_MUTEXES` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Stm {#config-stm}

**Status**: In the 6.18.9-hs kernel (`CONFIG_STM=m`). Stays on the patch date.
**Config gate**: `CONFIG_STM=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-38627

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_STM=m`). These CVEs stay on the patch date.

### Greybus {#config-greybus}

**Status**: Not Affected
**Config gate**: `CONFIG_GREYBUS` not set
**CVEs covered**: CVE-2024-39495

`CONFIG_GREYBUS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Ionic {#config-ionic}

**Status**: In the 6.18.9-hs kernel (`CONFIG_IONIC=m`). Stays on the patch date.
**Config gate**: `CONFIG_IONIC=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-39502

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_IONIC=m`). These CVEs stay on the patch date.

### Crypto Dev Hisi Sec2 {#config-crypto-dev-hisi-sec2}

**Status**: Not Affected
**Config gate**: `CONFIG_CRYPTO_DEV_HISI_SEC2` not set
**CVEs covered**: CVE-2024-42147, CVE-2024-47730

`CONFIG_CRYPTO_DEV_HISI_SEC2` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Bna {#config-bna}

**Status**: In the 6.18.9-hs kernel (`CONFIG_BNA=m`). Stays on the patch date.
**Config gate**: `CONFIG_BNA=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-43839

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_BNA=m`). These CVEs stay on the patch date.

### Drm Aspeed Gfx {#config-drm-aspeed-gfx}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_ASPEED_GFX` not set
**CVEs covered**: CVE-2023-52916

`CONFIG_DRM_ASPEED_GFX` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Pci Kirin {#config-pci-kirin}

**Status**: Not Affected
**Config gate**: `CONFIG_PCI_KIRIN` not set
**CVEs covered**: CVE-2024-47751

`CONFIG_PCI_KIRIN` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Drm Stm {#config-drm-stm}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_STM` not set
**CVEs covered**: CVE-2024-49992

`CONFIG_DRM_STM` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Hi Gmac {#config-hi-gmac}

**Status**: Not Affected
**Config gate**: `CONFIG_HI_GMAC` not set
**CVEs covered**: CVE-2022-48960, CVE-2022-48962

`CONFIG_HI_GMAC` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Hsr {#config-hsr}

**Status**: In the 6.18.9-hs kernel (`CONFIG_HSR=m`). Stays on the patch date.
**Config gate**: `CONFIG_HSR=m` on 6.18.9-hs
**CVEs covered**: CVE-2022-49015

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_HSR=m`). These CVEs stay on the patch date.

### Typec {#config-typec}

**Status**: In the 6.18.9-hs kernel (`CONFIG_TYPEC=m`). Stays on the patch date.
**Config gate**: `CONFIG_TYPEC=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-50150

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_TYPEC=m`). These CVEs stay on the patch date.

### Mse102X {#config-mse102x}

**Status**: Not Affected
**Config gate**: `CONFIG_MSE102X` not set
**CVEs covered**: CVE-2024-50276

`CONFIG_MSE102X` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Video S5P Jpeg {#config-video-s5p-jpeg}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_S5P_JPEG` not set
**CVEs covered**: CVE-2024-53061

`CONFIG_VIDEO_S5P_JPEG` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Arm Scmi Protocol {#config-arm-scmi-protocol}

**Status**: Not Affected
**Config gate**: `CONFIG_ARM_SCMI_PROTOCOL` not set
**CVEs covered**: CVE-2024-53068

`CONFIG_ARM_SCMI_PROTOCOL` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Intel Xe GPU Driver {#drm-xe-driver}

**Status**: In the 6.18.9-hs kernel (`CONFIG_DRM_XE=m`). Stays on the patch date.
**Config gate**: `CONFIG_DRM_XE=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-53098

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_DRM_XE=m`). These CVEs stay on the patch date.

### Hyperv Vsockets {#config-hyperv-vsockets}

**Status**: Not Affected
**Config gate**: `CONFIG_HYPERV_VSOCKETS` not set
**CVEs covered**: CVE-2024-53103

`CONFIG_HYPERV_VSOCKETS` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Usb Lan78Xx {#config-usb-lan78xx}

**Status**: In the 6.18.9-hs kernel (`CONFIG_USB_LAN78XX=m`). Stays on the patch date.
**Config gate**: `CONFIG_USB_LAN78XX=m` on 6.18.9-hs
**CVEs covered**: CVE-2024-53213

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_USB_LAN78XX=m`). These CVEs stay on the patch date.

### Drm Xlnx {#config-drm-xlnx}

**Status**: Not Affected
**Config gate**: `CONFIG_DRM_XLNX` not set
**CVEs covered**: CVE-2024-56538

`CONFIG_DRM_XLNX` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.

### Usb Net Cdcether {#config-usb-net-cdcether}

**Status**: In the 6.18.9-hs kernel (`CONFIG_USB_NET_CDCETHER=m`). Stays on the patch date.
**Config gate**: `CONFIG_USB_NET_CDCETHER=m` on 6.18.9-hs
**CVEs covered**: CVE-2025-38153

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_USB_NET_CDCETHER=m`). These CVEs stay on the patch date.

### Md Raid10 {#config-md-raid10}

**Status**: In the 6.18.9-hs kernel (`CONFIG_MD_RAID10=m`). Stays on the patch date.
**Config gate**: `CONFIG_MD_RAID10=m` on 6.18.9-hs
**CVEs covered**: CVE-2023-53357

The 6.18.9-hs kernel that ships builds this option as a kernel module (`CONFIG_MD_RAID10=m`). These CVEs stay on the patch date.

### Video Adv748X {#config-video-adv748x}

**Status**: Not Affected
**Config gate**: `CONFIG_VIDEO_ADV748X` not set
**CVEs covered**: CVE-2025-71136

`CONFIG_VIDEO_ADV748X` is not compiled into the Root Lock kernel. There is no reachable code path for any CVE in this group.
