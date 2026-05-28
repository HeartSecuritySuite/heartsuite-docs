---
title: "Linux Security Layer Analysis"
linkTitle: "Layer Analysis"
weight: 7
description: "A taxonomy of Linux host security products by enforcement layer — where each mechanism sits in the stack and what that means for bypass surface."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "comparison", "edr", "ebpf", "selinux", "apparmor", "gvisor", "layers", "taxonomy"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "layer-analysis"
---

**Purpose**: Security audits and competitive evaluations often group products by vendor category — EDR, SIEM, NDR — without capturing where in the kernel stack enforcement actually happens. This page maps Linux host security products to the enforcement layer they occupy. Layer placement determines bypass surface: a product enforcing at Layer 2 cannot be disabled by a mechanism that only reaches Layer 3 or above.

## Layer definitions

| Layer | Name | What lives here |
|---|---|---|
| **1** | Hardware / firmware | CPU microcode, UEFI/BIOS, Secure Boot chain, TPM |
| **2** | Kernel | The running kernel binary and its compiled-in configuration |
| **3** | LSM / kernel hooks | In-tree LSM frameworks, eBPF programs attached to kernel hooks |
| **4** | Userspace sandbox | Agents and runtimes that compose Layer 3 primitives — run as userspace processes |
| **5** | Userspace telemetry / response | Kernel-module or eBPF agents primarily providing detection, alerting, and response |
| **Adj.** | Complementary controls | Products that answer different questions — no enforcement overlap with Layers 2–5 |

The higher the layer, the more layers beneath it an attacker can leverage to disable it. A Layer 5 agent can be killed by a process with root. A Layer 3 LSM policy can be set permissive by root. A Layer 2 kernel configuration cannot be changed without rebooting into a different kernel.

## Product map

### Layer 2 — Kernel-embedded enforcement

| Mechanism | Products |
|---|---|
| Kernel-embedded allowlist / stripped kernel | **HeartSuite Core Secure**, custom hardened kernels, unikernels |
| Hardware-virtualized micro-isolation | Firecracker, Kata Containers, Cloud Hypervisor |

Enforcement is part of the kernel binary. Changing it requires a reboot into a different kernel. Remote root is not sufficient to disable it.

### Layer 2–3 — Userspace-process-run-as-kernel

| Mechanism | Products |
|---|---|
| Userspace syscall-emulating kernel (intercepts container syscalls) | gVisor (sentry process) |

gVisor intercepts container syscalls in a userspace process that acts as the container's kernel, reducing exposure to the host kernel. The sentry process runs in userspace and can be compromised; a bug in its syscall emulation can allow escape. HeartSuite Core Secure running as a guest kernel inside a gVisor-isolated container is a coherent composition — see [How It Compares → gVisor](../how-it-compares/#what-heartsuite-core-secure-replaces).

### Layer 3 — LSM hooks (in-tree)

| Mechanism | Products |
|---|---|
| Mandatory Access Control LSM | SELinux, AppArmor, SMACK, Tomoyo |
| Capability / path-based LSM | Landlock, Yama, LoadPin |

Policy is applied to a running kernel from outside. Root with the right capability can set SELinux permissive, unload an AppArmor profile, or modify a policy file without rebooting.

### Layer 3 — LSM hook + eBPF programs

| Mechanism | Products |
|---|---|
| eBPF programs attached via KRSI / LSM BPF | Tetragon (Cilium), Cilium network path, KRSI primitives |

eBPF programs are loaded into a running kernel at runtime. Root can unload the BPF program or kill the agent that loaded it.

### Layer 3–5 — eBPF observability with optional in-kernel kill

| Mechanism | Products |
|---|---|
| eBPF detection; optional kill signal | Falco (detection only, no kill), Tetragon (detect + kill), Sysdig Secure |

These products span layers depending on configuration: eBPF programs run at Layer 3, the userspace agent sits at Layer 5. The kill capability (where present) runs in-kernel but is loaded and managed by a userspace process.

### Layer 4 — Userspace agent sandbox

| Mechanism | Products |
|---|---|
| Userspace runtime composing seccomp-bpf, namespaces, cgroups | bubblewrap, Firejail, Flatpak sandbox, Snap confinement, OpenShell (NVIDIA) |

These tools set up confinement using kernel primitives (seccomp-bpf, Linux namespaces) from userspace. Filters are scoped to a process tree launched by the agent — a sibling process launched without the agent is unaffected.

### Layer 5 — Agent-based EDR / XDR

| Mechanism | Products |
|---|---|
| Kernel module or eBPF agent: telemetry, detection, response | CrowdStrike Falcon, SentinelOne Singularity, Microsoft Defender for Endpoint, Elastic Defend, Wazuh |

The agent provides detection and response capabilities that HeartSuite Core Secure does not replicate. Most modern breaches include "disable EDR" as an early step — root can kill the agent process, unload the kernel module, or exploit a BYOVD path. Treat these as complementary to Layer 2 enforcement, not substitutes.

## Complementary controls (no enforcement overlap)

These products do not overlap with Layers 2–5 enforcement. They answer different questions and should run alongside host enforcement.

| Category | Products | What they answer |
|---|---|---|
| **SIEM / SOAR** | Splunk, Elastic Security, Microsoft Sentinel, IBM QRadar, Sumo Logic, Graylog, Wazuh, Cortex XSOAR, Tines, Torq | Fleet-wide event correlation, alerting, playbook response |
| **NDR / NTA** | Darktrace, ExtraHop Reveal(x), Vectra AI, Corelight, Cisco Secure Network Analytics, Arista NDR | Passive network behavioral analysis, lateral-movement detection |
| **Vulnerability / posture** | Tenable Nessus, Qualys VMDR, Rapid7 InsightVM, Greenbone/OpenVAS, Wiz, Orca, Snyk, Trivy, Grype, Clair | CVE enumeration, patch prioritization, posture scoring |
| **HIDS / FIM** | OSSEC, AIDE, Tripwire, Samhain | Alert-only file-integrity monitoring, no blocking |
| **Backup / recovery** | Veeam, Rubrik, Cohesity, BackupPC, restic | Recovery from destructive events — separate category |

## Takeaway

HeartSuite Core Secure is the only product in this map sitting squarely at Layer 2 as a kernel-embedded allowlist enforced across all programs including root. Every other host enforcement product sits at Layer 3 (LSM hooks, eBPF programs) or higher — meaning a sufficiently privileged attacker can disable it remotely without rebooting. The Layer 2 position is what makes physical presence the only bypass path.

For the product-by-product comparison with bypass analysis, see [How It Compares](../how-it-compares/).
