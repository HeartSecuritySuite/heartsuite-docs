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

**Overview**: HeartSuite Core Secure enforces a default-deny policy at the kernel level — each program must be explicitly approved to execute, to access files, and to make network connections, including malware running as root. In Setup Mode, the system logs everything it sees so you can review and approve it through the Dashboard queues; Lockdown then enforces what you approved. Patches, new tools, and evolving workloads are added the same way: open a maintenance window — reboot into Setup Mode, install or change what you need, review the new entries in the queues, then re-engage Lockdown. Nothing about this depends on cloud connectivity, a SaaS policy server, or an agent-to-console channel — HeartSuite Core Secure operates standalone. The scenarios below are where that model fits best, followed by the ones where it doesn't.

## Production Servers

A web server serves pages. A database answers queries. A reverse proxy forwards traffic. Each has a shape that Setup Mode captures over a few days of logging — the programs that run, the files they touch, the destinations they reach — which you then review and approve in the Dashboard queues before activating Lockdown. Patches, package upgrades, and new services follow the same path: open a maintenance window, install the changes in Setup Mode, approve the new entries, then re-engage Lockdown. The immutable seal goes one step further: while the server runs, even root can no longer change the allowlist. An attacker with root is left with nowhere to go.

CVE-2026-31431 — privilege escalation via AF_ALG — demonstrates what this means. An attacker exploiting it reaches root. On a HeartSuite Core Secure kernel, that path does not exist — AF_ALG is not compiled in. But even if it had been, Lockdown closes every path from there. The kernel refuses to clear immutable flags. Mount operations are blocked. Writes to the audit log are blocked. Root cannot modify configuration, cannot add a backdoor, and cannot survive a reboot.

See [Kernel Security Transparency](../../security/) for the full CVE status table and scanner guidance.

## Closed Appliances and Embedded Devices

A kiosk, a point-of-sale terminal, an industrial control gateway, a network appliance, a medical device, a defence endpoint — these systems don't have interactive users. They have a job. The programs that do the job are fixed. An attacker's first move is usually to introduce a new one, and HeartSuite Core Secure blocks that move before it starts. Lockdown extends that protection so even root cannot quietly extend the allowlist while the system runs. File Backup is the recovery layer behind both. The kernel restricts the backup directory to HeartSuite's own backup tooling — no other allowlisted program, however privileged, can read or overwrite it. So even if an approved program is compromised and corrupts a file, the previous versions remain intact and restorable from the Dashboard's Backup.

## Regulated Workstations and Analyst Systems

In financial, legal, healthcare, and defence workplaces, a workstation's toolchain is set by policy, not preference. The **Dashboard** includes review queues that let you approve each tool and add it to the allowlist. Only the tools you approve can execute — everything else is blocked.

> [!NOTE]
> **Lockdown** seals the allowlist against change. The configuration files are made immutable on disk (`chattr +i`), and the HeartSuite Core Secure kernel will not accept changes to the allowlist while it's running — even from root. A compromised user session cannot quietly add an unauthorized tool, because the kernel itself will not accept the change.

In regulated industries — financial services, healthcare, defence — auditors ask a specific question: can an administrator, or an attacker who has compromised an administrator account, disable your security controls? With Lockdown active, the answer is no. No program or user inside the running HeartSuite Core Secure kernel, including root, can modify the allowlist or disable enforcement. Disabling enforcement requires reaching the boot path itself: a keyboard and monitor on a physical machine, a serial console, or — on a virtual machine — the hypervisor that owns the guest's disk image and memory. On VMs the hypervisor becomes the outer protective layer; HeartSuite Core Secure protects everything inside. Platform controls that protect the boot path (measured boot, disk encryption with keys held by the platform, controlled hypervisor access) extend that protection upward. For environments subject to SOC 2, PCI DSS, HIPAA, or ISO 27001, that is a concrete answer to the privileged-access control question — and a clear specification of which controls remain the platform's responsibility.

## Build, CI, and Release Infrastructure

A build host sits at the top of a supply chain. Compromise it, and every downstream consumer is at risk. CVE-2024-27198 — JetBrains TeamCity, unauthenticated RCE — demonstrates what this means. An attacker who reaches a TeamCity server can execute any program without credentials. On a HeartSuite Core Secure build host, that program has no allowlist entry. The kernel refuses to run it.

**HeartSuite Core Secure** restricts the host to only approved programs, controlling which can execute, which files they can access, and which network connections they can make:

- Compilers, linkers, signing tools, and release scripts you approved in Setup Mode.
- Network destinations they need to fetch dependencies and publish build artifacts.

**File Backup** keeps versioned copies of signing keys and build output. The kernel restricts those copies to HeartSuite's backup tooling — a compromised compiler, linker, or signing tool cannot read or overwrite them. So even if an approved tool is compromised, the previous versions remain intact and restorable from the Dashboard's Backup.

## Offline and Air-Gapped Deployments

Some systems cannot assume the network is there. Industrial control networks, defence systems, classified environments, ships, aircraft, and recovery-of-last-resort servers either have no outbound connectivity or cannot be permitted to reach the internet at all. HeartSuite Core Secure operates standalone — the allowlist lives on the machine, enforcement happens inside the kernel, and logs go to whichever local channel you configure. There is no telemetry upstream and no policy server to round-trip with. An offline HeartSuite Core Secure system protects exactly the same way as an online one. Cloud-dependent EDRs degrade sharply in these environments; HeartSuite Core Secure does not.

## AI Agent and Automation Sandboxes

Autonomous agents are powerful because they decide what to do next. That is also why they need a cage. Run HeartSuite Core Secure as the guest kernel inside a per-task virtual machine — a Kata Container, a Firecracker microVM, or plain KVM. You build the allowlist once: run a representative agent task in Setup Mode, review and approve the tools it uses through the Dashboard queues, then bake that allowlist into the VM image. Each task VM boots from that image into Lockdown with the allowlist already in force. The allowlist holds for the life of the task. Then the VM is gone. Enforcement is in the guest kernel itself — no LSM module to unload, no userspace shim to detach, no separate agent process to kill from inside the guest. gVisor adds a userspace syscall filter to protect the host from an untrusted guest; HeartSuite Core Secure *is* the guest kernel, protecting the workload from an attacker who reaches root inside the VM.

> [!NOTE]
> Setup Mode captures the most reliable allowlist when the same programs run in the same way across tasks — repeating activity is what you can review and approve in the Dashboard queues with confidence. Agents that call unpredictable tools at runtime are harder to allowlist than agents whose action space is well-scoped to a defined set of tools.

## Container Hosts {#container-hosts}

Docker, containerd, Kubernetes, and CRI-O all run on a HeartSuite Core Secure host. The installer detects which container engine is present and asks you to choose a **Container host** or **Standard host** install. Container host installs include overlay filesystem support and Setup Mode behavior adapted for container runtimes — Setup Mode logs container-runtime programs, overlay mounts, and each container image intended to run under Lockdown so you can review and approve them in the Dashboard queues before activating Lockdown.

Lockdown seals the running container set — the kernel stops accepting new mount operations, including the overlay mounts and bind-mounts every container start requires. The same protection blocks attackers from constructing paths to shadow protected files. Containers running at the moment Lockdown engages continue running. New containers, image pulls, and restarts after exit each require a maintenance window — reboot to Setup Mode, start the containers, return to steady state, and re-engage Lockdown. The Dashboard shows mount-refusal messages from the kernel when a container engine tries to start a new container after Lockdown.

This is the right pattern for long-lived service containers, Kubernetes nodes with a stable pod set, and batch jobs that complete before Lockdown engages.

## Where HeartSuite Core Secure Is Not a Fit

A few workloads are not compatible with the HeartSuite Core Secure kernel as shipped:

- **Hosts requiring continuous container scheduling** — dynamic deployments, autoscaling, and pod rescheduling after node loss each require new mount operations that Lockdown refuses. Container hosts with a steady-state workload are supported via the Container-host install above.
- **Hosts where eBPF-based tooling must run locally** — Falco, Cilium, Tetragon, bpftrace, and similar tools require BPF syscalls that are not present on the HS kernel. These tools can still observe the HS host from adjacent infrastructure via network taps or log forwarding. For on-host forensics during incident response, eBPF-based tools are not available; strace and /proc inspection remain available.
- **Hypervisor hosts running virtual machines** — HeartSuite Core Secure protects workloads running *inside* a kernel; a hypervisor host runs the inverse model, granting trusted access to guest workloads it does not control. The HS kernel is built for the first case, not the second. KVM and the related virtualization features are not part of the supported configuration. HeartSuite Core Secure runs as a guest under other hypervisors and provides kernel-level enforcement there — which is the deployment shape this product was designed for.
- **Systems that require rootless containers** — unprivileged user-namespace creation is disabled by policy on the HS kernel; it is a common path to privilege escalation without credentials. Workloads requiring rootless containers should run on a separate host.

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

Kubernetes-native runtime security, cross-platform endpoint protection across Windows and macOS, developer per-application sandboxing, and enterprise backup at fleet scale each have dedicated products built for them. HeartSuite Core Secure is built for one thing: Linux systems where the security policy must survive a compromised root account.
