---
title: "Deployment Scenarios"
linkTitle: "Deployment Scenarios"
weight: 4
description: "Environments and workloads where Root Lock by HeartSuite's kernel-level allowlisting fits best."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "deployment", "use-cases", "servers", "appliances", "ai"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "deployment-scenarios"
---

**Overview**: Every attack does three things: run a program, access files, make a network connection. Root Lock by HeartSuite enforces default-deny on all three at the kernel, per program, including malware running as root.

In Setup Mode, Root Lock logs activity so you can review and approve it through the Dashboard queues. Lockdown then enforces what you approved. Patches and new tools follow the same path: a maintenance window, review, then Lockdown again.

Root Lock operates standalone — no SaaS policy server, no agent-to-console channel. The Root Lock kernel sits beside your existing kernel in GRUB; you can boot back to it. The scenarios below are where that model fits, then where it is not a fit by design.

## Production servers

A web server serves pages. A database answers queries. A reverse proxy forwards traffic. Each has a shape you review and approve in the Dashboard queues after a few days of Setup Mode logging, then you activate Lockdown.

Patches, package upgrades, and new services follow the same path: open a maintenance window, install the changes in Setup Mode, approve the new entries, then re-engage Lockdown.

Under Lockdown, even root can no longer change the allowlist while the server runs. An attacker who already has remote root is left with nowhere to go.

CVE-2026-31431 — privilege escalation via AF_ALG — shows what that means. An attacker who exploits it already has root. On a Root Lock kernel AF_ALG is not compiled in. That path is gone.

Even if it had been, Lockdown closes every path from there. The kernel refuses to clear immutable flags. Mount operations are blocked. Writes to the audit log are blocked. Root cannot modify configuration, cannot add a backdoor, and cannot survive a reboot.

See [Kernel Security Transparency](../../security/) for the full CVE status table and scanner guidance.

## Closed appliances and embedded devices

A kiosk, a point-of-sale terminal, an industrial control gateway, a network appliance, a medical device, a defence endpoint — these systems don't have interactive users. They have a job. The programs that do the job are fixed.

An attacker's first move is usually to introduce a new program. In Lockdown, Root Lock blocks that move before it starts. Root cannot add to the allowlist while the system runs.

File Backup is the recovery layer. The kernel restricts the backup directory to Root Lock's own backup tooling — no other allowlisted program, however privileged, can read or overwrite it. If an approved program is compromised and corrupts a file, previous versions remain intact and restorable from the Dashboard's Backup.

## Regulated workstations and analyst systems

In financial, legal, healthcare, and defence workplaces, a workstation's toolchain is set by policy, not preference. The **Dashboard** includes review queues that let you approve each tool and add it to the allowlist. In Lockdown, only the tools you approve can execute — everything else is blocked.

> [!NOTE]
> **Lockdown** seals the allowlist against change. Under Lockdown, root cannot change the allowlist while it is running. The files are immutable (`chattr +i`). The kernel refuses the write. A compromised user session cannot quietly add an unauthorized tool, because the kernel itself will not accept the change.

In regulated industries — financial services, healthcare, defence — auditors ask a specific question: can an administrator, or an attacker who has compromised an administrator account, disable your security controls? With Lockdown active, the answer is no.

No program or user inside the running Root Lock kernel, including root, can modify the allowlist or disable enforcement. Disabling enforcement requires reaching the boot path: a keyboard and monitor on a physical machine, a serial console, or — on a virtual machine — the hypervisor that owns the guest's disk image and memory.

On VMs the hypervisor is the outer protective layer; Root Lock protects everything inside. Platform controls that protect the boot path (measured boot, disk encryption with keys held by the platform, controlled hypervisor access) extend that protection upward.

For environments subject to SOC 2, PCI DSS, HIPAA, or ISO 27001, that is a concrete answer to the privileged-access control question — and a clear specification of which controls remain the platform's responsibility.

For managed security providers, this answer is the same for every Root Lock-protected server they manage: under Lockdown, no administrator credential, no root session, and no remote path changes the security policy. Bypass requires physical or serial-console access. For the competitive comparison on this point, see [How Root Lock Compares](../how-it-compares/#circumvention-and-recovery).

## Build, CI, and release infrastructure

A build host sits at the top of a supply chain. Compromise it, and every downstream consumer is at risk.

CVE-2024-27198 — JetBrains TeamCity, unauthenticated RCE — shows what that means. An attacker who reaches a TeamCity server can execute any program without credentials. On a Root Lock build host, that program has no allowlist entry. The kernel refuses to run it.

A supply chain attacker who compromises the build pipeline itself — using its own credentials and tooling — does not introduce a new program. In the May 2026 TanStack incident, 84 malicious package versions across 42 packages were published in six minutes using valid pipeline credentials. The execution gate fires but does not block: the pipeline already has a valid allowlist entry.

The attack is contained, not prevented at execution. The network allowlist still blocks: a compromised build tool cannot reach destinations outside its approved list, regardless of credential validity.

**Root Lock** restricts the host to only approved programs, controlling which can execute, which files they can access, and which network connections they can make:

- Compilers, linkers, signing tools, and release scripts you approved in Setup Mode.
- Network destinations they need to fetch dependencies and publish build artifacts.

**File Backup** keeps versioned copies of signing keys and build output. The kernel restricts those copies to Root Lock's backup tooling — a compromised compiler, linker, or signing tool cannot read or overwrite them. So even if an approved tool is compromised, the previous versions remain intact and restorable from the Dashboard's Backup.

## Offline and air-gapped deployments

Some systems cannot assume the network is there. Industrial control networks, defence systems, classified environments, ships, aircraft, and recovery-of-last-resort servers either have no outbound connectivity or cannot be permitted to reach the internet at all.

Root Lock operates standalone — the allowlist lives on the machine, enforcement happens inside the kernel, and logs go to whichever local channel you configure. There is no telemetry upstream and no policy server to round-trip with.

An offline Root Lock system protects exactly the same way as an online one. Cloud-dependent EDRs degrade sharply in these environments; Root Lock does not.

## AI agent and automation sandboxes

Autonomous agents are powerful because they decide what to do next. That is also why they need a cage. Pwn2Own Berlin 2026 added an AI/ML tools category for the first time; every target fell.

Run Root Lock as the guest kernel inside a per-task virtual machine — a Kata Container, a Firecracker microVM, or plain KVM. You build the allowlist once: run a representative agent task in Setup Mode, review and approve the tools it uses through the Dashboard queues, then bake that allowlist into the VM image.

Each task VM boots from that image into Lockdown with the allowlist already in force. The allowlist holds for the life of the task. Then the VM is gone.

An attacker who already has root inside the VM cannot turn this off. There is no LSM to unload, no userspace shim to detach, and no agent to kill. gVisor filters syscalls in userspace to protect the host. Root Lock is the guest kernel. It protects the workload.

> [!NOTE]
> Setup Mode logs the most reliable allowlist when the same programs run in the same way across tasks — repeating activity is what you can review and approve in the Dashboard queues with confidence. Agents that call unpredictable tools at runtime are harder to allowlist than agents whose action space is well-scoped to a defined set of tools.

## Container hosts {#container-hosts}

Docker, containerd, Kubernetes, and CRI-O all run on a Root Lock host. The installer detects which container engine is present and asks you to choose a **Container host** or **Standard host** install.

Container host installs include overlay filesystem support and Setup Mode behavior adapted for container runtimes. Setup Mode logs container-runtime programs, overlay mounts, and each container image intended to run under Lockdown so you can review and approve them in the Dashboard queues before activating Lockdown.

Lockdown seals the running container set — the kernel stops accepting new mount operations, including the overlay mounts and bind-mounts every container start requires. The same protection blocks attackers from constructing paths to shadow protected files.

Containers running at the moment Lockdown engages continue running. New containers, image pulls, and restarts after exit each require a maintenance window — reboot to Setup Mode, start the containers, return to steady state, and re-engage Lockdown. The Dashboard shows mount-refusal messages from the kernel when a container engine tries to start a new container after Lockdown.

This is the right pattern for long-lived service containers, Kubernetes nodes with a stable pod set, and batch jobs that complete before Lockdown engages.

## Where Root Lock is not a fit

A few workloads are incompatible with the Root Lock kernel as shipped — **not a fit by design**. The kernel omits overlay filesystems, user namespaces, and the BPF syscall because they are the features attackers use to hide, shadow directories, and reach root.

- **Shared-kernel container guests (OpenVZ, LXC, Docker/Podman guests on a provider kernel, systemd-nspawn)** — Root Lock must boot its own kernel by design. Full VMs under KVM or cloud hypervisors are supported; Root Lock runs as a guest kernel inside them.
- **Hosts requiring continuous container scheduling** — dynamic deployments, autoscaling, and pod rescheduling after node loss each require new mount operations that Lockdown refuses. Container hosts with a steady-state workload are supported via the Container-host install above.
- **Hosts where eBPF-based tooling must run locally** — Falco, Cilium, Tetragon, bpftrace, and similar tools require the BPF syscall, which is deliberately absent. These tools can still observe the Root Lock host from adjacent infrastructure via network taps or log forwarding. For on-host forensics, use strace and /proc inspection.
- **Hypervisor hosts running virtual machines** — Root Lock protects workloads running *inside* a kernel. A hypervisor host grants trusted access to guest workloads it does not control — the inverse model. KVM host mode is not a supported configuration; those kernel features are compiled out. Root Lock runs as a VM guest on KVM, cloud hypervisors, and other platforms.
- **Systems that require rootless containers** — unprivileged user-namespace creation is disabled by policy on the Root Lock kernel; it is a common path to privilege escalation without credentials. Workloads requiring rootless containers should run on a separate host.
- **Applications that update daily or on an unpredictable schedule** — each update that adds a new binary, dependency, or network destination requires a maintenance window: open Setup Mode, run the update, approve the new allowlist entries, and re-engage Lockdown. That process fits controlled patch schedules. At daily cadence the overhead is daily. Applications with a predictable update cycle are a better fit.

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

Kubernetes-native runtime security, cross-platform endpoint protection across Windows and macOS, developer per-application sandboxing, and enterprise backup at fleet scale each have dedicated tools built for them. Root Lock is built for one thing: Linux systems where the security policy must survive a compromised root account.

If the host is a fit, continue to [Getting Started](../../getting-started/).
