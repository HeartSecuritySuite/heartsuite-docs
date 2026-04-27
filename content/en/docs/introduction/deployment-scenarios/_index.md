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

**Overview**: HeartSuite Core Secure enforces a default-deny policy at the kernel level — each program must be explicitly approved to execute, to access files, and to make network connections, including malware running as root. In Setup Mode, the system logs everything it sees so you can review and approve it through the Dashboard queues; Secure Mode then enforces what you approved. Patches, new tools, and evolving workloads are added the same way: open a maintenance window — reboot into Setup Mode, install or change what you need, review the new entries in the queues, then re-engage Secure Mode (and Lockdown, if you use it). Nothing about this depends on cloud connectivity, a SaaS policy server, or an agent-to-console channel — HeartSuite Core Secure operates standalone. The scenarios below are where that model fits best, followed by the ones where it doesn't.

## Production Servers

A web server serves pages. A database answers queries. A reverse proxy forwards traffic. Each has a shape that Setup Mode captures over a few days of logging — the programs that run, the files they touch, the destinations they reach — which you then review and approve in the Dashboard queues before switching to Secure Mode. Patches, package upgrades, and new services follow the same path: open a maintenance window, install the changes in Setup Mode, approve the new entries, then re-engage Secure Mode. Lockdown goes one step further: while the server runs, even root can no longer change the allowlist. An attacker with root is left with nowhere to go.

## Closed Appliances and Embedded Devices

A kiosk, a point-of-sale terminal, an industrial control gateway, a network appliance, a medical device, a defence endpoint — these systems don't have interactive users. They have a job. The programs that do the job are fixed. An attacker's first move is usually to introduce a new one, and HeartSuite Core Secure blocks that move before it starts. Lockdown extends that protection so even root cannot quietly extend the allowlist while the system runs. File Backup is the recovery layer behind both. Under Lockdown, the kernel blocks any program (including root) from reaching the backup files — so even if an approved program is compromised and corrupts a file, the previous versions remain intact and restorable from the Dashboard's Backup screen.

## Regulated Workstations and Analyst Systems

In financial, legal, healthcare, and defence workplaces, a workstation's toolchain is set by policy, not preference. The **Dashboard** includes review queues that let you approve each tool and add it to the allowlist. Only the tools you approve can execute — everything else is blocked.

> [!NOTE]
> **Lockdown** seals the allowlist against change. The configuration files are made immutable on disk (`chattr +i`), and the HeartSuite Core Secure kernel will not accept changes to the allowlist while it's running — even from root. A compromised user session cannot quietly add an unauthorized tool, because the kernel itself will not accept the change.

In regulated industries — financial services, healthcare, defence — auditors ask a specific question: can an administrator, or an attacker who has compromised an administrator account, disable your security controls? With Lockdown active, the answer is no. No program or user, including root, can modify the allowlist or disable enforcement while the HeartSuite Core Secure kernel is running. Disabling enforcement requires physical presence at the machine — a keyboard and monitor, a serial port, or your cloud provider's serial console. For environments subject to SOC 2, PCI DSS, HIPAA, or ISO 27001, that is a concrete answer to the privileged-access control question.

## Build, CI, and Release Infrastructure

A build host sits at the top of a supply chain. Compromise it, and every downstream consumer is at risk. CVE-2024-27198 — JetBrains TeamCity, unauthenticated RCE — demonstrates what this means. An attacker who reaches a TeamCity server can execute any program without credentials. On a HeartSuite Core Secure build host, that program has no allowlist entry. The kernel refuses to run it.

**HeartSuite Core Secure** restricts the host to only approved programs, controlling which can execute, which files they can access, and which network connections they can make:

- Compilers, linkers, signing tools, and release scripts you approved in Setup Mode.
- Network destinations they need to fetch dependencies and publish build artifacts.

**File Backup** keeps versioned copies of signing keys and build output. Under Lockdown, the kernel blocks any program (including root) from reaching those copies — so even if an approved tool is compromised, the previous versions remain intact and restorable from the Dashboard's Backup screen.

## Offline and Air-Gapped Deployments

Some systems cannot assume the network is there. Industrial control networks, defence systems, classified environments, ships, aircraft, and recovery-of-last-resort servers either have no outbound connectivity or cannot be permitted to reach the internet at all. HeartSuite Core Secure operates standalone — the allowlist lives on the machine, enforcement happens inside the kernel, and logs go to whichever local channel you configure. There is no telemetry upstream and no policy server to round-trip with. An offline HeartSuite Core Secure system protects exactly the same way as an online one. Cloud-dependent EDRs degrade sharply in these environments; HeartSuite Core Secure does not.

## AI Agent and Automation Sandboxes

Autonomous agents are powerful because they decide what to do next. That is also why they need a cage. Run HeartSuite Core Secure as the guest kernel inside a per-task virtual machine — a Kata Container, a Firecracker microVM, or plain KVM. You build the allowlist once: run a representative agent task in Setup Mode, review and approve the tools it uses through the Dashboard queues, then bake that allowlist into the VM image. Each task VM boots from that image into Secure Mode with the allowlist already in force. The allowlist holds for the life of the task. Then the VM is gone. Enforcement lives inside the guest, not on the host, so a compromised host cannot disable it. Where gVisor adds a userspace syscall filter between the agent and the kernel, HeartSuite Core Secure *is* the kernel — one layer instead of two, with nothing to unload.

> [!NOTE]
> Setup Mode captures the most reliable allowlist when the same programs run in the same way across tasks — repeating activity is what you can review and approve in the Dashboard queues with confidence. Agents that call unpredictable tools at runtime are harder to allowlist than agents whose action space is well-scoped to a defined set of tools.

## Container Hosts

Docker, containerd, Kubernetes, Podman, and CRI-O all run on a HeartSuite Core Secure host. The installer detects which container engine is present and asks the operator to choose a **Container host** or **Standard host** install. Container host installs include overlay filesystem support and Setup Mode behavior adapted for container runtimes — Setup Mode logs container-runtime programs, overlay mounts, and each container image intended to run under Lockdown so you can review and approve them in the Dashboard queues before switching to Secure Mode.

Lockdown seals the running container set — the kernel stops accepting new mount operations, including the overlay mounts and bind-mounts every container start requires. The same protection blocks attackers from constructing paths to shadow protected files. Containers running at the moment Lockdown engages continue running. New containers, image pulls, and restarts after exit each require a maintenance window — reboot to Setup Mode, start the containers, return to steady state, and re-engage Lockdown. The Dashboard's Lockdown screen shows mount-refusal messages from the kernel when a container engine tries to start a new container after Lockdown.

This is the right pattern for long-lived service containers, Kubernetes nodes with a stable pod set, and batch jobs that complete before Lockdown engages.

## Where HeartSuite Core Secure Is Not a Fit

A few workloads are not compatible with the HeartSuite Core Secure kernel as shipped:

- **Hosts requiring continuous container scheduling** — dynamic deployments, autoscaling, and pod rescheduling after node loss each require new mount operations that Lockdown refuses. Container hosts with a steady-state workload are supported via the Container-host install above.
- **Hosts where eBPF-based tooling must run locally** — Falco, Cilium, Tetragon, bpftrace, and similar tools require BPF syscalls that are not present on the HS kernel. These tools can still observe the HS host from adjacent infrastructure via network taps or log forwarding. For on-host forensics during incident response, eBPF-based tools are not available; strace and /proc inspection remain available.
- **Hypervisor hosts running virtual machines** — KVM is not compiled in; hosting guest VMs requires kernel features that have been removed to reduce what attackers can reach. HeartSuite Core Secure runs as a guest under other hypervisors — it does not host guest VMs.
- **Systems that require rootless containers** — unprivileged user namespaces are not compiled in; they are a path to privilege escalation without credentials. Workloads requiring rootless containers should run on a separate host.

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

Kubernetes-native runtime security, cross-platform endpoint protection across Windows and macOS, developer per-application sandboxing, and enterprise backup at fleet scale each have dedicated products built for them. HeartSuite Core Secure is built for one thing: Linux systems where the security policy must survive a compromised root account.
