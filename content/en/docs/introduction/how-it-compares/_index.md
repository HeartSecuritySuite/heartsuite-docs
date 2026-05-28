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

**Overview**: HeartSuite Core Secure controls per program whether it can execute, which files it can read or write, and which network connections it can make — including for programs running as root. Standard operating systems grant these rights to users. Ken Thompson built Unix that way in 1969 on an unused PDP-7 at Bell Labs — designed for a small group of trusted researchers, not for networked infrastructure or a world with malware. Every operating system since inherited the decision unchanged. HeartSuite Core Secure does not. It replaces a set of runtime-confinement and kernel-observability tools whose enforcement can be disabled by an attacker with root. It does not replace your SIEM, network detection, vulnerability scanner, or HIDS — those answer different questions and should be run alongside.

## Kernel architecture

| Standard Linux | HeartSuite Core Secure |
|---|---|
| Wide kernel + security agent watching it | Minimal kernel — features removed at build time |
| BPF programs enforce blocking policy | BPF syscall is not compiled in — nothing to unload |
| Kernel module driver provides telemetry | No agent module — no module to kill |
| OverlayFS and FUSE enabled for containers | Compiled out — the CVE class disappears with them |
| Config file: 12,000+ lines, audited by tooling | Config file: 5,050 lines, readable by a person |
| Blocking depends on runtime configuration | Blocking is compiled into the binary itself |

Every published Linux kernel CVE comes with the same question: is that kernel feature compiled into your hosts? For the features HeartSuite Core Secure has compiled out, the answer is always no — without patching, without policy, without an agent checking.

Most runtime security products sit at Layer 3 (LSM hooks such as SELinux and AppArmor) or Layer 5 (userspace EDR agents such as CrowdStrike Falcon and SentinelOne). HeartSuite Core Secure sits at Layer 2: enforcement is compiled into the kernel binary itself, not applied to it from outside. That placement is why every bypass in the table below requires physical presence rather than a remote privilege escalation. For the full taxonomy with all products mapped by layer, see [Layer Analysis](../layer-analysis/).

## Security as economics

No security control is unconditionally unbreakable. The right question is not "can this be defeated?" but "what does defeating it cost the attacker — and what does operating it cost the defender?"

**No false positives in blocking.** In Secure Mode, HeartSuite Core Secure does not scan, score, or guess. A program either has an allowlist entry for the action it is attempting, or it does not. Permitted actions pass without interruption. Unpermitted actions are blocked. Every blocking decision is exact — not a detection estimate.

**The boundary holds regardless of privilege.** A process running as root can only reach the files its allowlist entry permits. Credentials, configuration, and data outside that slice are unreachable regardless of privilege level. Network destinations outside the allowlist are unreachable regardless of privilege level. Under Lockdown the allowlist itself is sealed — even root cannot edit it remotely. Each additional step the attacker takes requires a new custom exploit targeted at the specific program and allowlist slice they are confined to. The cost compounds. At some point the attack is no longer worth finishing.

**Cost to implement.** A finite window: run the programs you want to allow, the allowlist builds, engage Lockdown. Most customers complete it during a standard change window.

### Operational cost

**Patching urgency.** CVE classes that correspond to compiled-out kernel features do not generate emergency patch windows — the feature is absent, and no CVE in that class applies regardless of when the patch ships. For CVEs in features that are present, a vulnerable program whose allowlist scope is bounded has a structurally limited blast radius. The remediation is real; the urgency is not. Patch batching on schedule, rather than emergency change windows, is the practical result.

**Alert reduction.** An attack that cannot progress past the kernel gate does not generate a SIEM or EDR alert. A binary that cannot execute never triggers a process-execution event. An outbound connection refused at the kernel never appears in NDR telemetry as a beacon or data-loss event. This is not alert filtering — the event never occurs. The alert classes this eliminates carry the highest triage cost: unauthorized execution, unauthorized exfiltration, and novel outbound destinations.

**Maintenance.** No signature updates. No rule libraries. No agent fleet. The allowlist changes when software legitimately changes — new binaries, updated dependencies, changed network destinations — in a maintenance window on your schedule. The more frequently software changes, the more frequently those windows are needed. For software that updates daily — package managers pulling live repositories, or applications shipping a new binary on each release — a maintenance window is required each time. That is low overhead on monthly or quarterly patch schedules; at daily cadence it compounds. HeartSuite Core Secure fits well where the software stack is stable or follows a defined update process.

### ROI compared

**SELinux and AppArmor.** LSM policy is a sustained engineering cost: SELinux refpolicy domain authoring, AppArmor profile maintenance, permissive-mode exceptions that accumulate under operational pressure, and policy audits before each OS upgrade. Each policy file is hand-authored and must be updated when software changes. HeartSuite Core Secure's allowlist is built by observation during Setup Mode — the kernel records what programs actually do and presents it for approval. The difference compounds over years: one observation-driven setup session versus ongoing policy authorship and drift management.

**Zafran and risk-prioritization tools.** Zafran, Nucleus, Vulcan Cyber, and similar tools correlate CVEs against your deployed controls to identify which patches are actually urgent. They do not enforce anything at runtime. HeartSuite Core Secure reduces the urgency of items these tools surface: an unpatched CVE in a program whose allowlist scope is bounded has a structurally limited blast radius — a legitimate but lower-priority remediation. The two compose: a risk-prioritization tool can correctly de-prioritize CVEs in HeartSuite Core Secure-bounded programs because the enforcement is verifiable and the blast radius is documented.

**Linux EDR.** CrowdStrike Falcon, SentinelOne, and Microsoft Defender for Endpoint generate alerts that require analyst triage. The attack classes HeartSuite Core Secure prevents — unauthorized binary execution, file access outside approved scope, outbound connections to unapproved destinations — never reach the EDR because the attack cannot progress past the kernel gate. Fewer alerts is not filtering; it is that the attack class is structurally absent from the host. EDR's telemetry, behavioural analytics, and incident response capabilities remain valid for what HeartSuite Core Secure does not cover. The honest position: HeartSuite Core Secure changes what the EDR has to process, not whether you run one.

**Cost to buy.** HeartSuite Core Secure replaces the preventive-enforcement layer of several overlapping tools — the blocking dimension of EDR, LSM policy tuning, FIM enforcement — while leaving their detection and response capabilities intact. Whether that consolidation saves money depends on your stack. Fewer moving parts is consistent.

**CTEM programs** — Continuous Threat Exposure Management — cover exposure discovery, prioritisation, and validation across a whole estate: continuously mapping what an attacker could reach and ranking what to fix first. That scope fits large organisations managing complex, heterogeneous environments. For most deployments it is broader than the problem and carries corresponding cost. HeartSuite Core Secure addresses one specific problem: the OS design assumption that grants every running program the file and network rights of the user who launched it. Removing that assumption at the kernel level does not require a continuous discovery and ranking program.

**The CISO case.** An attacker who reaches root still cannot exceed the per-program, per-file, per-IP boundaries already in place. The blast radius is structurally bounded — not detected after the fact, not mitigated after the fact, bounded before anything runs. That changes the economics of every attack that reaches the host. It does not eliminate breach risk. It makes lateral movement, exfiltration, and privilege escalation substantially more expensive to execute — before detection has a chance to respond.

## What HeartSuite Core Secure replaces

The comparison below is scoped to preventive enforcement; telemetry, behavioural analytics, and incident response are addressed separately in [What HeartSuite Core Secure Complements](#what-heartsuite-core-secure-complements). These products provide runtime confinement or kernel-level enforcement of some kind. Each has a known bypass path. The HeartSuite Core Secure row is included in the same format for direct comparison — see [Circumvention and Recovery](#circumvention-and-recovery) below for detail.

| Product | What it does | How it can be disabled | How HeartSuite Core Secure compares |
|---|---|---|---|
| **Falco, Cilium Tetragon, Sysdig Secure, Tracee, bpftrace** (eBPF-based runtime detection) | Attach BPF programs to kernel hooks, watch syscall patterns, alert on suspicious behaviour | An attacker with root can unload the BPF program, kill the agent, or disable the BPF syscall | HeartSuite Core Secure removes the BPF syscall entirely from the kernel. There is no agent to kill and no hook to unload. Enforcement is compiled in. |
| **AppArmor, SELinux, SMACK, Landlock** (userspace LSM frameworks) | Per-process MAC profiles limiting filesystem and capability access | Root with the right capability can set SELinux to permissive, unload an AppArmor profile, or modify the policy file | HeartSuite Core Secure's allowlist is stored in configuration files made immutable under Lockdown, and the HeartSuite Core Secure kernel will not let any program change them while it's running. Even root cannot edit it. |
| **seccomp-bpf sandboxes** (systemd services, browser sandboxes, bubblewrap, firejail) | Per-process syscall filters set by the process itself or its parent | A parent with equivalent privilege can spawn the same binary without the filter. Filters are scoped to a process tree, not to the program identity | HeartSuite Core Secure gates by program identity, not process lineage. A program's allowlist applies every time it runs, regardless of who spawned it. |
| **gVisor** (userspace kernel for container sandboxing) | Intercepts container syscalls in a userspace kernel, reducing exposure to the host kernel | Runs as a userspace process; a compromise of the gVisor process itself, or a bug in its syscall emulation, can allow escape | HeartSuite Core Secure *is* the kernel — one layer instead of two, with nothing to unload. Used as a guest kernel inside a microVM, it provides kernel-level enforcement for the workload. |
| **Linux EDR agents** (CrowdStrike Falcon, SentinelOne, Microsoft Defender for Endpoint) | Kernel module or eBPF agent providing telemetry, detection, and response | Root can kill the agent process, unload the kernel module, or tamper with the driver. Many breaches include "disable EDR" as an early step | HeartSuite Core Secure has no agent and no module to unload — it is the kernel. When attackers use legitimate tools rather than new malware — the pattern in most modern breaches — EDR detects the suspicious behavior. HeartSuite Core Secure constrains it differently: even a legitimate tool can only reach the files and network destinations its allowlist entry approves. Note: EDR provides telemetry and response HeartSuite Core Secure does not. Treat HeartSuite Core Secure as a replacement for the preventive-enforcement dimension only; for detection and response, see the complementary table below. |

**The common pattern.** Every product in this table can be disabled by an attacker who has already reached root. HeartSuite Core Secure cannot — its enforcement is compiled into the kernel and its allowlist is sealed by filesystem immutability under Lockdown. This requires a different operational model, discussed in [Circumvention and Recovery](#circumvention-and-recovery).

**What each tool does best.** Bypass surface is one dimension of comparison, not the whole picture. Each product above retains strengths HeartSuite Core Secure does not replicate.

*eBPF observers* — Falco, Cilium Tetragon, Sysdig Secure, Tracee, and bpftrace — ship mature rule libraries, Kubernetes-aware context, and fleet-wide runtime telemetry. For behavioural alerting on Kubernetes nodes — particularly autoscaled clusters where HeartSuite Core Secure does not fit — those tools remain the right answer, and they can observe a HeartSuite Core Secure host from adjacent infrastructure via network taps or log forwarding.

*Userspace LSM frameworks* — AppArmor, SELinux, SMACK, Landlock — offer policy capabilities HeartSuite Core Secure does not replicate: SELinux refpolicy and domain transitions, AppArmor's distribution-shipped per-application profiles, Landlock's per-application self-confinement primitive. HeartSuite Core Secure's value is the sealed boundary — `chattr +i` immutability plus a running kernel that refuses runtime changes — not richer policy syntax.

*seccomp-bpf sandboxes* in systemd services, browser sandboxes, bubblewrap, and firejail sit closer to the syscall surface than HeartSuite Core Secure can. A Chromium renderer's own seccomp filter is genuine defence-in-depth from inside the program; HeartSuite Core Secure does not replace it, and both layers are worth keeping.

*gVisor* addresses a different threat model — host protected from untrusted guest, via a userspace syscall-emulating kernel. HeartSuite Core Secure addresses workloads protected from compromised root inside the kernel they run on. The two compose: HeartSuite Core Secure as the guest kernel inside a gVisor-isolated container is a coherent stack.

*Linux EDR* — CrowdStrike Falcon, SentinelOne, Microsoft Defender for Endpoint — provides telemetry, behavioural analytics, fleet-wide correlation through a SOC console, threat intelligence, and incident response. HeartSuite Core Secure provides none of those. The honest position is *prevention versus detection*; most regulated environments will run both.

## Trust boundaries and bypass surface

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

The May 2026 TanStack npm attack illustrated the trust-boundary distinction from the supply chain direction. The attacker operated inside a legitimate build pipeline using valid credentials — SLSA provenance, OIDC, and 2FA all functioned as designed. No credential check or trust-chain verification registered anything to block. HeartSuite Core Secure's per-program network allowlist bounds what pipeline processes can reach from the host regardless of credential validity; connections to unapproved destinations are refused at the kernel.

## What HeartSuite Core Secure complements

These products do not overlap with HeartSuite Core Secure. They answer different questions, and mature security programs run both.

| Category | Representative products | What they do | Where they take over |
|---|---|---|---|
| **SIEM / SOAR** | Splunk Enterprise Security, Microsoft Sentinel, Elastic Security, IBM QRadar, Sumo Logic, Graylog, Wazuh, Cortex XSOAR | Ingest logs from hosts and applications across a fleet, correlate events, alert analysts, drive playbook-based response | HeartSuite Core Secure blocks and logs on a single host. Fleet correlation, cross-host alerting, and playbook response are what SIEM is built for — and HeartSuite Core Secure's activity log is a direct input to it. |
| **NDR / NTA** | Darktrace, ExtraHop Reveal(x), Vectra AI, Corelight, Cisco Secure Network Analytics | Passive network sensing, behavioural flow analysis, lateral-movement detection, encrypted-traffic fingerprinting | HeartSuite Core Secure controls which programs reach which destinations. Traffic content, behavioural flow analysis, and cross-host correlation are what NDR is built for. |
| **Vulnerability management** | Tenable Nessus, Qualys VMDR, Rapid7 InsightVM, Greenbone, Wiz, Orca | Enumerate installed packages and services, match against CVE databases, produce a prioritised patch list | HeartSuite Core Secure reduces the blast radius of an unpatched CVE — a vulnerable but allowlist-bounded program cannot escalate beyond its allowlist. Mapping what needs patching is what vulnerability scanners are built for, and SOC 2, PCI DSS, and ISO 27001 require them as a distinct control. |
| **HIDS / FIM** | OSSEC, AIDE, Tripwire, Samhain, Wazuh | File-integrity monitoring, log-based intrusion detection, rootkit signatures | HeartSuite Core Secure enforces file integrity via Lockdown; HIDS adds independent alerting on unexpected change. Redundancy matters — different products have different failure modes. |

HeartSuite Core Secure makes a class of attacks impossible rather than merely visible. Your SIEM, NDR, and VA scanner work on what remains — a smaller, more focused set of events.

## Where a separate kernel is required

Some software depends on kernel features the HeartSuite Core Secure kernel does not include. Those workloads run on the Non-HS kernel or a separate system:

- **Kubernetes nodes where new containers start or pods reschedule after Lockdown engages** — running many instances of the same binary across pods is explicitly supported: one allowlist entry covers all instances, with no per-pod overhead. HeartSuite Core Secure installs on Kubernetes nodes (EKS, GKE, AKS) without modification. The limitation is container lifecycle events after Lockdown: HPA scale-out, pod rescheduling after node failure, and new container starts each require mount operations that Lockdown refuses. If the pod set is fixed before Lockdown engages and doesn't change between maintenance windows, the Container-host install supports that; see [Deployment Scenarios → Container Hosts](../deployment-scenarios/#container-hosts)
- **Falco, Cilium Tetragon, bpftrace, and similar eBPF tools** — the BPF syscall is not compiled in; removing it is what prevents an attacker from unloading these tools. They can still observe the HS host from adjacent infrastructure via network taps or log forwarding
- **Hypervisor hosts running virtual machines via KVM** — KVM host mode is not a supported configuration; the kernel features KVM requires have been compiled out to reduce the features attackers can reach. HeartSuite Core Secure runs as a VM guest on KVM and other hypervisors — it does not host them.
- **Systems that require rootless containers (unprivileged user namespaces)** — unprivileged user namespaces are not compiled in; they are a path to privilege escalation without credentials. Workloads requiring rootless containers should run on a separate host.

See [System Requirements → Software Compatibility Notes](../system-requirements/#software-compatibility-notes) for the full list.

## Circumvention and recovery

Every security system has a known way to be taken out of the picture. Being explicit about it is how customers evaluate fit.

HeartSuite Core Secure's allowlist can be changed through one path only:

1. **Maintenance window** — you switch to Setup Mode, make changes, and re-engage Lockdown. Logged and intentional.
2. **Lockdown recovery** — when Lockdown is active, the allowlist cannot be edited even by root on the HeartSuite Core Secure kernel. Recovery requires booting the Non-HS kernel, using the Dashboard's Maintenance (`[t]`) to remove the seal, and rebooting back. Booting the Non-HS kernel requires **physical presence** — a keyboard and monitor at the machine, a serial port, or your cloud provider's serial console. An attacker without physical presence cannot take this path.

What this means for security:

- Remote root alone is not sufficient to defeat enforcement. There is no agent to kill, no kernel module to unload, no LSM policy to set permissive, and no way to remotely force a reboot into the Non-HS kernel.
- Defeating HeartSuite Core Secure requires physical presence — a keyboard and monitor at the machine, a serial port, or your cloud provider's serial console. SSH access, regardless of privilege level, is not sufficient.
- Physical presence always returns control to you — no software applied to the system can prevent it.

Compare this to the products in the first table: in most of them, remote root is sufficient to disable enforcement. HeartSuite Core Secure is deliberately not in that category.

Nothing the attacker ran survives a reboot.

To see the three enforcement mechanisms tested against real attacks — including what happens when attackers stay within approved boundaries — see [When Root Isn't Enough](../in-practice/).

**The compliance answer.** SOC 2, PCI DSS, and ISO 27001 each include a privileged-access control question: can an administrator, or an attacker who has compromised one, remotely disable security controls? Under Lockdown, no remote path — including root — can modify the allowlist or disable enforcement. Bypass requires the physical presence described above. Every product in the bypass table earlier in this page can be disabled by an attacker with remote root; HeartSuite Core Secure cannot. For managed security providers, this is the answer they give to auditors — the same for every HeartSuite-protected server they manage in financial services, healthcare, and defence.
