---
title: "How HeartSuite Core Secure Compares"
linkTitle: "How It Compares"
weight: 5
description: "How HeartSuite Core Secure relates to other security tools — what it replaces, what it complements, and how it can be circumvented."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "comparison", "siem", "edr", "ebpf", "falco", "selinux", "apparmor", "gvisor"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "how-it-compares"
---

**Overview**: HeartSuite Core Secure controls per program whether it can execute, which files it can read or write, and which network connections it can make — including for programs running as root. The question is not "can this user access this file?" but "can this specific program?" Two programs running as the same user get different permissions. It replaces a set of runtime-confinement and kernel-observability tools whose enforcement can be disabled by an attacker with root. It does not replace your SIEM, network detection, vulnerability scanner, or HIDS — those answer different questions and should be run alongside.

## What HeartSuite Core Secure Replaces

These products provide runtime confinement or kernel-level enforcement of some kind. Each has a known bypass path. The HeartSuite Core Secure row is included in the same format for direct comparison — see [Circumvention and Recovery](#circumvention-and-recovery) below for detail.

| Product | What it does | How it can be disabled | How HeartSuite Core Secure compares |
|---|---|---|---|
| **Falco, Cilium Tetragon, Sysdig Secure, Tracee, bpftrace** (eBPF-based runtime detection) | Attach BPF programs to kernel hooks, watch syscall patterns, alert on suspicious behaviour | An attacker with root can unload the BPF program, kill the agent, or disable the BPF syscall | HeartSuite Core Secure removes the BPF syscall entirely. There is no agent to kill and no hook to unload. Enforcement is compiled in. |
| **AppArmor, SELinux, SMACK, Landlock** (userspace LSM frameworks) | Per-process MAC profiles limiting filesystem and capability access | Root with the right capability can set SELinux to permissive, unload an AppArmor profile, or modify the policy file | HeartSuite Core Secure's allowlist is stored in filesystem objects the kernel refuses to modify under Lockdown. Even root cannot edit it at runtime. |
| **seccomp-bpf sandboxes** (systemd services, browser sandboxes, bubblewrap, firejail) | Per-process syscall filters set by the process itself or its parent | A parent with equivalent privilege can spawn the same binary without the filter. Filters are scoped to a process tree, not to the program identity | HeartSuite Core Secure gates by program identity, not process lineage. A program's allowlist applies every time it runs, regardless of who spawned it. |
| **gVisor** (userspace kernel for container sandboxing) | Intercepts container syscalls in a userspace kernel, reducing exposure to the host kernel | Runs as a userspace process; a compromise of the gVisor process itself, or a bug in its syscall emulation, can allow escape | HeartSuite Core Secure *is* the kernel — one layer instead of two, with nothing to unload. Used as a guest kernel inside a microVM, it provides kernel-level enforcement for the workload. |
| **Linux EDR agents** (CrowdStrike Falcon, SentinelOne, Microsoft Defender for Endpoint) | Kernel module or eBPF agent providing telemetry, detection, and response | Root can kill the agent process, unload the kernel module, or tamper with the driver. Many breaches include "disable EDR" as an early step | HeartSuite Core Secure has no agent and no module to unload — it is the kernel. When attackers use legitimate tools rather than new malware — the pattern in most modern breaches — EDR detects the suspicious behavior. HeartSuite Core Secure constrains it differently: even a legitimate tool can only reach the files and network destinations its allowlist entry approves. Note: EDR provides telemetry and response HeartSuite Core Secure does not. Treat HeartSuite Core Secure as a replacement for the preventive-enforcement dimension only; for detection and response, see the complementary table below. |

**The common pattern.** Every product in this table can be disabled by an attacker who has already reached root. HeartSuite Core Secure cannot — its enforcement is compiled into the kernel and its allowlist is sealed by filesystem immutability under Lockdown. This requires a different operational model, discussed in [Circumvention and Recovery](#circumvention-and-recovery).

## Trust Boundaries and Bypass Surface

Three questions cut to the core of any enforcement mechanism: *who is trusted to set the policy, who is gated at runtime, and what does a bypass look like?*

```mermaid
graph LR
    A[Attacker gains root] --> B["eBPF agent\n(Falco, Tetragon)"]
    A --> C["LSM framework\n(AppArmor, SELinux)"]
    A --> D["seccomp sandbox\n(bubblewrap, firejail)"]
    A --> E["Linux EDR agent\n(CrowdStrike, SentinelOne)"]
    A --> F["HeartSuite Core Secure"]
    B --> G["Kill agent or\nunload BPF program"]
    C --> H["Set permissive or\nreload policy"]
    D --> I["Launch same binary\nwithout the filter"]
    E --> J["Kill driver or\nBYOVD bypass"]
    F --> K["Physical presence\nrequired"]
    G --> L["Protection disabled ✗"]
    H --> L
    I --> L
    J --> L
    K --> M["Protection intact ✓"]
```

The table below answers each question in full for the main enforcement mechanisms alongside HeartSuite Core Secure.

| Mechanism | Trusted during setup | Untrusted at runtime | How enforcement is bypassed |
|---|---|---|---|
| eBPF observation and enforcement (Falco, Cilium Tetragon, Sysdig Secure, Tracee, bpftrace) | Admin who writes the rules | Processes the agent observes (Tetragon and Sysdig can kill in-kernel) | Root unloads the BPF program, kills the agent, or disables the BPF syscall |
| Userspace LSM frameworks (AppArmor, SELinux, SMACK, Landlock) | Admin who authors the policy files | Processes labelled or confined by policy | Root sets the framework permissive, reloads a relaxed policy, or edits the policy file |
| seccomp-bpf sandboxes (bubblewrap, firejail, systemd, browser sandboxes) | The parent process that sets the filter | The child process the filter applies to | A sibling process launched without the filter is unaffected — filters are scoped to a process tree, not a program identity |
| gVisor | Container runtime administrator | Syscalls from inside the sandboxed container | Compromise the gVisor sentry process, or exploit a syscall-emulation bug |
| Linux EDR agents (CrowdStrike Falcon, SentinelOne, Microsoft Defender for Endpoint) | SOC team via a cloud console | Monitored processes | Root kills the agent, unloads the driver, or exploits a BYOVD bypass |
| **HeartSuite Core Secure** | **You in Setup Mode; allowlist sealed by Lockdown** | **Every program, including those running as root** | **Physical presence required to boot the Non-HS kernel — no remote path** |

**Two differences carry the position.** Every mechanism above narrows the runtime trust boundary to a subset of processes — one container, one labelled domain, one process tree, one observed program. HeartSuite Core Secure narrows it to *every* program via a system-wide allowlist, root included. And where every competitor's bypass is something an attacker can do remotely once they have root, HeartSuite Core Secure's bypass requires physical presence at the console. Those two shifts are the substance of the HeartSuite Core Secure position.

## What HeartSuite Core Secure Complements

These products do not overlap with HeartSuite Core Secure. They answer different questions, and mature security programs run both.

| Category | Representative products | What they do | Where they take over |
|---|---|---|---|
| **SIEM / SOAR** | Splunk Enterprise Security, Microsoft Sentinel, Elastic Security, IBM QRadar, Sumo Logic, Graylog, Wazuh, Cortex XSOAR | Ingest logs from hosts and applications across a fleet, correlate events, alert analysts, drive playbook-based response | HeartSuite Core Secure blocks and logs on a single host. Fleet correlation, cross-host alerting, and playbook response are what SIEM is built for — and HeartSuite Core Secure's activity log is a direct input to it. |
| **NDR / NTA** | Darktrace, ExtraHop Reveal(x), Vectra AI, Corelight, Cisco Secure Network Analytics | Passive network sensing, behavioural flow analysis, lateral-movement detection, encrypted-traffic fingerprinting | HeartSuite Core Secure controls which programs reach which destinations. Traffic content, behavioural flow analysis, and cross-host correlation are what NDR is built for. |
| **Vulnerability management** | Tenable Nessus, Qualys VMDR, Rapid7 InsightVM, Greenbone, Wiz, Orca | Enumerate installed packages and services, match against CVE databases, produce a prioritised patch list | HeartSuite Core Secure reduces the blast radius of an unpatched CVE — a vulnerable but allowlist-bounded program cannot escalate beyond its allowlist. Mapping what needs patching is what vulnerability scanners are built for, and SOC 2, PCI DSS, and ISO 27001 require them as a distinct control. |
| **HIDS / FIM** | OSSEC, AIDE, Tripwire, Samhain, Wazuh | File-integrity monitoring, log-based intrusion detection, rootkit signatures | HeartSuite Core Secure enforces file integrity via Lockdown; HIDS adds independent alerting on unexpected change. Redundancy matters — different products have different failure modes. |

HeartSuite Core Secure makes a class of attacks impossible rather than merely visible. Your SIEM, NDR, and VA scanner work on what remains — a smaller, more focused set of events.

## Where a Separate Kernel Is Required

Some software depends on kernel features the HeartSuite Core Secure kernel does not include. Those workloads run on the Non-HS kernel or a separate system:

- Container hosts using Docker's default OverlayFS storage driver — OverlayFS is not compiled in; overlay filesystems are a surface for shadowing protected directories
- Hosts where eBPF-based tooling must run locally — BPF syscalls are not present on the HS kernel; these tools can still observe the HS host from adjacent infrastructure via network taps or log forwarding
- Hypervisor hosts running virtual machines via KVM — KVM is not compiled in; the kernel features KVM requires have been removed to reduce the features attackers can reach. HeartSuite Core Secure runs as a guest inside VMs — it does not host them.
- Systems that require rootless containers (unprivileged user namespaces) — unprivileged user namespaces are not compiled in; they are a path to privilege escalation without credentials

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

## Circumvention and Recovery

Every security system has a known way to be taken out of the picture. Being explicit about it is how customers evaluate fit.

HeartSuite Core Secure's allowlist can be changed through one path only:

1. **Maintenance window** — you switch to Setup Mode, make changes, and return to Secure Mode. Logged and intentional.
2. **Lockdown recovery** — when Lockdown is active, the allowlist cannot be edited even by root on the HeartSuite Core Secure kernel. Recovery requires booting the Non-HS kernel, running `hs-unlock`, and rebooting back. Booting the Non-HS kernel requires **physical presence**. An attacker without physical presence cannot take this path.

What this means for security:

- Remote root alone is not sufficient to defeat enforcement. There is no agent to kill, no kernel module to unload, no LSM policy to set permissive, and no way to remotely force a reboot into the Non-HS kernel.
- Defeating HeartSuite Core Secure requires physical presence — a keyboard and monitor at the machine, a serial port, or a hypervisor console. SSH access, regardless of privilege level, is not sufficient.
- Physical presence always returns control to you — no software applied to the system can prevent it.

Compare this to the products in the first table: in most of them, remote root is sufficient to disable enforcement. HeartSuite Core Secure is deliberately not in that category.

To see the three enforcement mechanisms tested against real attacks — including what happens when attackers stay within approved boundaries — see [In Practice](../in-practice/).
