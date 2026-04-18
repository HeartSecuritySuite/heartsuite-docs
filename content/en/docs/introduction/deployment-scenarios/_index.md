---
title: "Deployment Scenarios"
linkTitle: "Deployment Scenarios"
weight: 4
description: "Environments and workloads where HeartSuite Core Secure's kernel-level allowlisting fits best."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "deployment", "use-cases", "servers", "appliances", "ai"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "deployment-scenarios"
---

**Overview**: HeartSuite Core Secure enforces a default-deny policy at the kernel level — each program must be explicitly approved to execute, to access files, and to make network connections, including malware running as root. Setup Mode builds the allowlist from what your system actually uses, Secure Mode enforces it, and maintenance windows bring in patches, new tools, and evolving workloads under review before enforcement resumes. Nothing about this depends on cloud connectivity, a SaaS policy server, or an agent-to-console channel — HeartSuite Core Secure operates standalone. The scenarios below are where that model fits best, followed by the ones where it doesn't.

## Production Servers

A web server serves pages. A database answers queries. A reverse proxy forwards traffic. Each has a shape HeartSuite Core Secure can learn in a few days of Setup Mode, then enforce in Secure Mode. Patches, package upgrades, and new services arrive through maintenance windows — reviewed, added to the allowlist, then the server returns to enforcement. Lockdown goes one step further: while the server runs, even root can no longer change the allowlist. An attacker is left with nowhere to go.

## Closed Appliances and Embedded Devices

A kiosk, a point-of-sale terminal, an industrial control gateway, a network appliance, a medical device, a defence endpoint — these systems don't have users. They have a job. The programs that do the job are fixed. An attacker's first move is usually to introduce a new one, and HeartSuite Core Secure blocks that move before it starts. File Backup adds a second line of defence: if an approved program that malware takes over writes where it shouldn't, the original is still available to restore.

## Regulated Workstations and Analyst Systems

In financial, legal, healthcare, and defence workplaces, a workstation's toolchain is set by policy, not preference. The **Dashboard** includes review queues that let you approve each tool and add it to the allowlist. Only the tools you approve can execute — everything else is blocked.

> [!NOTE]
> **Lockdown** freezes the allowlist to prevent changes, including by root. This ensures a compromised user session cannot quietly add unauthorized tools, as enforcement happens at the kernel level.

In regulated industries — financial services, healthcare, defence — auditors ask a specific question: can an administrator, or an attacker who has compromised an administrator account, disable your security controls? With Lockdown active, the answer is no. No program or user, including root, can modify the allowlist or disable enforcement while the HeartSuite Core Secure kernel is running. Disabling enforcement requires physical presence at the machine. For environments subject to SOC 2, PCI DSS, HIPAA, or ISO 27001, that is a concrete answer to the privileged-access control question.

## Build, CI, and Release Infrastructure

A build host sits at the top of a supply chain. Compromise it, and every downstream consumer is at risk. CVE-2024-27198 — JetBrains TeamCity, unauthenticated RCE — demonstrates what this means. An attacker who reaches a TeamCity server can execute any program without credentials. On a HeartSuite Core Secure build host, that program has no allowlist entry. The kernel refuses to run it.

**HeartSuite Core Secure** restricts the host to only approved programs, controlling which can execute, which files they can access, and which network connections they can make:

- Compilers, linkers, signing tools, and release scripts you approved in Setup Mode.
- Network destinations they need to fetch dependencies and publish build artifacts.

**File Backup**—a feature that creates protected copies of critical files—safeguards signing keys and build output against tampering, allowing quick restoration if an approved tool gets compromised.

## Offline and Air-Gapped Deployments

Some systems cannot assume the network is there. Industrial control networks, defence systems, classified environments, ships, aircraft, and recovery-of-last-resort servers either have no outbound connectivity or cannot be permitted to reach the internet at all. HeartSuite Core Secure operates standalone — the allowlist lives on the machine, enforcement happens inside the kernel, and logs go to whichever local channel you configure. There is no telemetry upstream and no policy server to round-trip with. An offline HeartSuite Core Secure system protects exactly the same way as an online one. Cloud-dependent EDRs degrade sharply in these environments; HeartSuite Core Secure does not.

## AI Agent and Automation Sandboxes

Autonomous agents are powerful because they decide what to do next. That is also why they need a cage. Run HeartSuite Core Secure as the guest kernel inside a per-task virtual machine — a Kata Container, a Firecracker microVM, or plain KVM. The VM boots with an allowlist for the tools the agent is allowed to use. The allowlist holds for the life of the task. Then the VM is gone. Enforcement lives inside the guest, not on the host, so a compromised host cannot disable it. Where gVisor adds a userspace syscall filter between the agent and the kernel, HeartSuite Core Secure *is* the kernel — one layer instead of two, with nothing to unload.

> [!NOTE]
> Setup Mode builds the allowlist most accurately when the same programs run in the same way across tasks. Agents that call unpredictable tools at runtime are harder to allowlist than agents whose action space is well-scoped to a defined set of tools.

## Where HeartSuite Core Secure Is Not a Fit

A few workloads are not compatible with the HeartSuite Core Secure kernel as shipped:

- **Container hosts using the Docker default storage driver** — OverlayFS is not compiled into the HeartSuite Core Secure kernel; overlay filesystems are a surface for shadowing protected directories. Alternative storage drivers or a Non-HS container host may be required.
- **Hosts where eBPF-based tooling must run locally** — Falco, Cilium, Tetragon, bpftrace, and similar tools require BPF syscalls that are not present on the HS kernel. These tools can still observe the HS host from adjacent infrastructure via network taps or log forwarding. For on-host forensics during incident response, eBPF-based tools are not available; strace and /proc inspection remain available.
- **Hypervisor hosts running virtual machines** — KVM is not compiled in; hosting guest VMs requires kernel features that have been removed to reduce what attackers can reach. HeartSuite Core Secure runs as a guest under other hypervisors — it does not host guest VMs.
- **Systems that require rootless containers** — unprivileged user namespaces are not compiled in; they are a path to privilege escalation without credentials. Workloads requiring rootless containers should run on a separate host.

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

Kubernetes-native runtime security, cross-platform endpoint protection across Windows and macOS, developer per-application sandboxing, and enterprise backup at fleet scale each have dedicated products built for them. HeartSuite Core Secure is built for one thing: Linux systems where the security policy must survive a compromised root account.
