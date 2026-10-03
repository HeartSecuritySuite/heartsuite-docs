---
title: "Does this replace EDR? And other FAQs"
linkTitle: "FAQs"
weight: 105
description: "How Root Lock differs from anti-malware, who it is for, AI agents, containers, VM versus metal install, and what happens when something is blocked."
categories: ["Support"]
tags: ["heartsuite", "linux", "questions", "help", "debian", "ubuntu", "alpine", "rhel", "fedora", "centos", "rocky", "openclaw", "nemoclaw", "claude-code", "codex"]
toc: true
type: docs
aliases:
  - /docs/faqs/
---

## General

{{< details summary="How is Root Lock by HeartSuite different from other anti-malware solutions?" >}}

A: Every attack does three things: run a program, access files, make a network connection. Root Lock controls all three per program, not per user.

Where anti-malware tools look for signatures or suspicious behavior, Root Lock requires every execution, file access, and network connection to be approved through the Dashboard review queues. In Lockdown, anything not approved is blocked.

Enforcement is compiled into the kernel, so there is no agent to kill and no module to unload. An attacker who already has remote root cannot turn Lockdown off or edit the sealed allowlist, because unsealing takes the console: a keyboard and monitor, a serial port, a BMC (Dell iDRAC, HPE iLO, and similar), or your cloud provider's serial console — the same class as sitting at the rack. sshd is stopped when Lockdown seals, unless you chose to leave it running before the seal, and SSH cannot lift the seal. After unseal, SSH is how you work in Setup Mode.

See [How Root Lock Compares](introduction/how-it-compares/#circumvention-and-recovery).

{{< /details >}}

{{< details summary="Which scanner findings can wait for the standard change window?" >}}

A: Under Lockdown, a finding can wait when exploiting the bug only gets an attacker as far as a step Root Lock refuses: running a new program, opening a file the vulnerable program was never granted, or connecting to a destination outside its network allowlist. If your policy allows an exception, record it as one rule in the scanner you already run, with an expiry. The scanner takes the finding off its remediation queue until that expiry, and the finding comes back for the patch when it expires. See [Scanner deadlines](maintenance/scanner-deadlines/).

The exception does not move the patch date in your policy or contract, because the vulnerable code stays on the host until the patch goes in. A finding the attacker can complete inside the program's existing grants — including an attack on the vulnerable app's own files — stays on the patch date.

A scanner that flags a kernel CVE from the version string alone follows a separate workflow: [CVE Hygiene for Scanners](kernel-hardening/cve-hygiene-for-scanners/).

Root Lock does not scan for, report on, or remediate vulnerabilities, so ISO 27001 A.8.8 is not covered; see [Compliance Quick Reference](compliance-quick-reference/).

{{< /details >}}

{{< details summary="Do I still have to patch after Lockdown?" >}}

A: Yes. Install distro errata and application updates on the remediation SLA in your policy or contract: Lockdown bounds what an unpatched bug can reach, but the vulnerable code stays on the host until the patch goes in.

**One host already in Lockdown:** open Maintenance (`[m]`) in the Dashboard, select **Maintenance: unseal and return to Root Lock** from the console boot menu, patch over SSH in Setup Mode, approve the new activity in the review queues, then activate Lockdown (`[l]`) again. See [Protecting During Maintenance](maintenance/protecting-during-maintenance/).

**Many locked hosts:** bake the patched OS and the current Root Lock bundle into a new image and reprovision, which avoids a console session on each node. Ansible distributes allowlists but does not lift the seal. See "How do I patch many hosts that are already in Lockdown?" below and the [Enterprise Adoption Guide](kernel-hardening/enterprise-adoption-guide/#operational-model-for-fleets).

The expiry you file in the scanner is a separate date from that SLA. Where your policy sets the standard change window at 60 days or 90 days for work it does not rank critical, a finding whose exploit only reaches a step Lockdown refuses — a new program, file, or destination — can take that window as its expiry. See [Scanner deadlines](maintenance/scanner-deadlines/).

A kernel CVE whose code is compiled out of the Root Lock kernel needs no kernel update. `apt` and `dnf` still install the OS packages and leave the Root Lock kernel as shipped.

{{< /details >}}

{{< details summary="Is Root Lock a kernel module? How is that different from eBPF or SELinux?" >}}

A: No. Root Lock is compiled into the kernel binary. You do not load it with `insmod`, and you cannot unload it with `rmmod`. When the Root Lock kernel is running, the checks are part of exec, file access, and outbound connect.

eBPF tools (Falco, Tetragon, BPF LSM, eBPF Jailer) attach programs to a running kernel. That needs the BPF syscall. Root can unload those programs or kill the agent that loaded them. SELinux and AppArmor are LSM policy: on a typical distro, root can set them permissive or edit the policy file.

Root Lock is neither an LSM nor eBPF, so there is no policy to set permissive and no program to unload. The supported way off the Root Lock kernel is a reboot into the maintenance kernel from a keyboard and monitor, a serial port, a BMC, or your cloud serial console. sshd is stopped when Lockdown seals, unless you chose to leave it running before the seal, and SSH cannot select that kernel. After unseal, SSH is how you work in Setup Mode.

See [How Root Lock Compares](introduction/how-it-compares/) and [Layer Analysis](introduction/layer-analysis/).

{{< /details >}}

{{< details summary="How do I stop using Root Lock on a host?" >}}

A: The console pick does not remove Root Lock from the host. Reboot from a keyboard and monitor, a serial port, a BMC, or your cloud serial console, and select **Maintenance: unseal and return to Root Lock**. That boot runs `HS_unlock.sh` and returns you to the Root Lock kernel in Setup Mode. The GRUB default stays Root Lock, so the next reboot boots Root Lock again.

If a boot menu password was set before Lockdown, that entry asks for the GRUB name `root` and the boot menu password, while the everyday Root Lock entry does not ask. See [Protecting During Maintenance](maintenance/protecting-during-maintenance/).

{{< /details >}}

{{< details summary="Who is Root Lock for?" >}}

A: Root Lock fits systems where the same programs do the same jobs, day after day — production servers with defined stacks, closed appliances and embedded devices, regulated workstations, build and CI infrastructure, and AI agent sandboxes inside per-task virtual machines. It is for operators who need a kernel allowlist they can build without custom MAC policy, then seal so root cannot unload it.

Autoscaling groups fit too: profile one reference host of that class, then bake its allowlist into the image.

Containers fit as OCI images built and run on a separate host, with Root Lock protecting the fixed-workload hosts around them — see [Shared-kernel containers](introduction/deployment-scenarios/#container-hosts).

Running Docker, containerd, Kubernetes, CRI-O, or Podman on a Root Lock host is not a fit by design. Under Lockdown, Root Lock refuses the new mounts a runtime makes each time it starts or reschedules a container.

Hosts that run eBPF-based tools like Falco, Cilium, or Tetragon as their enforcement layer are not a fit by design: Root Lock does not enforce through eBPF, and the BPF syscall is off, so there is no eBPF program for those tools to load. See [Deployment Scenarios](introduction/deployment-scenarios/) for the full breakdown.

{{< /details >}}

{{< details summary="How does Root Lock treat AI agents?" >}}

A: An agent is another program on the allowlist, with its own execution, file, and network grants, so under Lockdown anything outside those grants is blocked. When Syslog is enabled on Alert Settings → Fleet, those blocked events go to the journal under ident `heartsuite`. Root Lock has no MCP integration.

{{< /details >}}

{{< details summary="Is Root Lock just easier SELinux?" >}}

A: No. In Setup Mode the Dashboard records which programs actually ran, what each one read or wrote, and where it connected, and you build the per-program allowlist by approving that record.

Then Lockdown seals it. Under Lockdown there is no permissive mode, nothing to unload, and the allowlist cannot be edited. An attacker who already has remote root cannot turn it off. Unsealing takes a keyboard and monitor, a serial port, a BMC, or the cloud serial console. sshd is stopped when Lockdown seals, unless you chose to leave it running before the seal, and SSH cannot lift the seal. After unseal, SSH is how you work in Setup Mode.

SELinux still has policy depth Root Lock does not replicate (domain transitions, distribution-shipped profiles). See [How Root Lock Compares](introduction/how-it-compares/), [The Setup Journey](introduction/setup-overview/), and [Central Policy](alerts/central-policy-management/).

{{< /details >}}

{{< details summary="Can I use the same allowlist across a fleet or Kubernetes cluster?" >}}

A: Yes, across a fleet of similar hosts. Each host runs the Root Lock kernel with the allowlist installed locally, and because Root Lock has no central policy server, your automation (Ansible, Terraform + GitOps, Puppet, scripts) distributes the files.

Each host still installs through Cloud Path or Local Path; Ansible runs that install and then applies policy.

**Kubernetes:** a cluster that schedules pods onto the Root Lock host is not a fit by design, including a long-lived fixed pod set. Under Lockdown, Root Lock refuses the new mounts a runtime makes each time it starts or reschedules a container. Run that workload in a Firecracker or Kata microVM instead, with Root Lock as the guest kernel. See [Deployment Scenarios](introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes) and [Containers and microVMs](introduction/containers-and-microvms/). Root Lock does not ship Firecracker or Kata. The same allowlist can still be copied across Root Lock hosts that run a fixed set of programs.

Because Root Lock works on each host individually, event correlation stays in your SIEM, policy reconciliation in Git or your configuration management, and compliance reporting in your GRC tool. See [Central Policy Management](alerts/central-policy-management/).

{{< /details >}}

{{< details summary="How do I patch many hosts that are already in Lockdown?" >}}

A: Bake the patched OS and the current Root Lock bundle into a new image and reprovision the instances. Unsealing a locked host takes the console, so reprovisioning is how a fleet patches without a console session on each node.

In-place package installs still work on a **single** host after unseal — [Protecting During Maintenance](maintenance/protecting-during-maintenance/). An in-place Root Lock update is the same unseal, then `bash heartsuite-install.sh` from a terminal and type `YES` — [Updating Root Lock](maintenance/updating-heartsuite/). Ansible distributes allowlists; it does not lift the seal. See [Central Policy](alerts/central-policy-management/) and the [Enterprise Adoption Guide](kernel-hardening/enterprise-adoption-guide/#operational-model-for-fleets).

{{< /details >}}

{{< details summary="How does Root Lock compare to Falco, AppArmor, SELinux, gVisor, or Linux EDR?" >}}

A: Falco is a **detection** engine. AppArmor, SELinux, gVisor, and Linux EDR each do a different job. Root Lock is host-local **prevention** (allowlist + Lockdown).

The tools differ most in how an attacker turns them off. An attacker who already has remote root can still kill a Falco agent, unload an eBPF program, or set SELinux permissive. Under Lockdown, that attacker cannot lift the seal, because lifting it takes physical or serial-console access: keyboard and monitor, serial port, or cloud serial console.

See [How Root Lock Compares](introduction/how-it-compares/) for a side-by-side table. For SELinux specifically, see the next question.

{{< /details >}}

{{< details summary="How does Root Lock compare to SELinux specifically?" >}}

A: Root can set SELinux to permissive mode, reload a relaxed policy, or edit the policy files. Root Lock is not an LSM, so it has no policy mode for root to switch. Setup Mode logs what each program did, you approve it in the queues, and Lockdown seals that allowlist: the files are made immutable (`chattr +i`) and the kernel refuses the write that would clear the flag, even from root. Unsealing takes booting the maintenance kernel from a keyboard and monitor, a serial port, a BMC, or your cloud provider's serial console, not an SSH session. After unseal, you work over SSH in Setup Mode.

The two are not mutually exclusive. SELinux's domain transitions and distribution-shipped per-application profiles add policy depth Root Lock does not provide; Root Lock adds the sealed boundary SELinux does not. See [How Root Lock Compares](introduction/how-it-compares/) for the full side-by-side. A lab of the same root-shell path is in [What Lockdown refused after a root shell](../../blog/2026/09/11/lockdown-after-a-root-shell/).

{{< /details >}}

{{< details summary="What software can I remove or stop paying for if I run Root Lock?" >}}

A: Root Lock replaces the preventive-enforcement layer of the following tool categories. Whether you can remove a tool entirely depends on whether you were running it purely for prevention, or also for telemetry and response.

**What Root Lock can replace (narrowly):**

- **Commercial eBPF enforcement tools** (Sysdig Secure, commercial Falco, Cilium Tetragon): the allowlist covers blocking, and Root Lock removes the BPF syscall by design. On 6.18.9-hs there is no eBPF program to load. These tools cannot run on the Root Lock kernel. OSS Falco carries no licensing cost but does carry ongoing rule-tuning overhead that goes away.
- **gVisor**: if used solely to protect workloads from root-level compromise inside a VM or microVM, Root Lock is a direct replacement as the guest kernel.
- **AppArmor / SELinux**: no licensing cost, but the policy-authoring and drift-management overhead is replaced by observation-driven allowlist setup. See [Security as Economics](introduction/security-as-economics/) for the full comparison.
- **The blocking dimension of Linux EDR** (CrowdStrike Falcon, SentinelOne, MDE): prevention is replaced. Telemetry, behavioural analytics, and SOC console are not. Some vendors offer lighter-tier pricing once the workload prevention layer moves to Root Lock.

**Cannot remove:**

- **SIEM, NDR, vulnerability scanners, and HIDS/FIM** — these answer questions Root Lock does not: fleet correlation, traffic analysis, compliance reporting, and patch prioritisation. See "Does Root Lock replace my SIEM, NDR, or vulnerability scanner?" below.

{{< /details >}}

{{< details summary="Does Root Lock replace my SIEM, NDR, or vulnerability scanner?" >}}

A: No. Root Lock works on each host individually. It does not correlate events across a fleet, ingest external data, or produce fleet-wide compliance reports on its own.

The same allowlist can still be distributed by your automation; see "Can I use the same allowlist across a fleet or Kubernetes cluster?" above.

SIEM (Splunk, Sentinel, Elastic), NDR (Darktrace, ExtraHop), vulnerability management (Nessus, Qualys, Wiz), and HIDS/FIM (OSSEC, Wazuh, AIDE) answer fleet-wide, telemetry, and compliance questions that Root Lock does not. Run them alongside. Root Lock's syslog streams, JSONL approval log, status.json, and webhook are designed inputs for those tools.

See [How Root Lock Compares](introduction/how-it-compares/) and [Central Policy Management and External Control](alerts/central-policy-management/).

{{< /details >}}

{{< details summary="Why is kernel-level enforcement better than eBPF or agent-based security?" >}}

A: Many security tools — including Falco, Cilium Tetragon, and CrowdStrike Falcon on Linux — rely on eBPF filters or user-space agents running as processes in the same OS as the programs they are meant to protect. Malware with sufficient privileges can disable, bypass, or unload them.

Root Lock compiles blocking into the kernel itself. There is no agent to kill, no filter to detach, and no module to unload. If the Root Lock kernel is running, its checks are running: Setup Mode logs what they see, and Lockdown blocks what is not approved.

This is the difference between a lock on the door and a guard standing next to it.

{{< /details >}}

{{< details summary="How is Root Lock itself protected from attacks? How do I know that Root Lock won't be targeted or compromised?" >}}

A: Lockdown makes allowlist entries and configuration files immutable at the filesystem, then disables changing immutability flags in the kernel. Under Lockdown, root cannot add, delete, or change allowlist entries. The kernel refuses the write.

To make changes, open Maintenance (`[m]`). If the seal is applied, reboot from a physical or serial console and select **Maintenance: unseal and return to Root Lock**. The seal lifts automatically and you return to Setup Mode on the Root Lock kernel. The Dashboard confirms Lockdown status after every reboot.

{{< /details >}}

{{< details summary="What are the system requirements for Root Lock?" >}}

A: x86 (64-bit) Linux. The current installer needs glibc 2.34 or newer and Python 3.11 or newer. The 6.18 lab set is Debian 12, Debian 13, Ubuntu 24.04, and Ubuntu 26.04. Fedora 42 is in lab. Rocky Linux 10, CentOS Stream 10, Alpine, and openSUSE Tumbleweed are experimental. Debian 11 and Ubuntu 20.04 are lab re-proof of the legacy 5.19 kernel. Ubuntu 22.04, Rocky Linux 9, AlmaLinux 9, RHEL 9, and CentOS Stream 9 meet the glibc floor and fail the Python floor, so the installer refuses them. RHEL 8, AlmaLinux 8, and older extended-support releases (CentOS 7, Ubuntu 18.04, Debian 10 and earlier) are below the glibc floor. There is no compat package that puts this installer on those releases. Full matrix: [Distro Compatibility](kernel-hardening/distro-compatibility-matrix/).

{{< /details >}}

{{< details summary="Which Linux kernels does Root Lock ship? Is Linux 7 supported?" >}}

A: New installs boot **6.18** (`uname -r` is `6.18.9-hs`). Linux 7 is not a shipped kernel. 5.19 is the legacy line. Debian 11 and Ubuntu 20.04 are lab re-proof of the k5 installer. See [Kernel Support Policy](kernel-hardening/kernel-support-policy/).

{{< /details >}}

{{< details summary="How can I download Root Lock?" >}}

A: On the target host, run `curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh | sudo bash`. Inspect the script first if you prefer. See [Obtaining Root Lock by HeartSuite](installation/obtaining-heartsuite/).

{{< /details >}}

{{< details summary="Is technical support available for Root Lock customers?" >}}

A: Yes. Email support@heartsecsuite.com or visit the tech support page on [heartsecsuite.com](https://heartsecsuite.com).

{{< /details >}}

{{< details summary="How do I report a bug or security issue?" >}}

A: For product bugs, email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) with your Root Lock version, kernel version (`uname -r`), the protection state shown at the top of your Dashboard, and steps to reproduce. For documentation corrections, open an issue on [heartsuite-docs](https://github.com/HeartSecuritySuite/heartsuite-docs/issues). For security vulnerabilities, email support@heartsecsuite.com for responsible disclosure — do not use public issue trackers.

{{< /details >}}

{{< details summary="Can Root Lock automatically backup files?" >}}

A: Yes. Every time a file in a configured directory is modified, Root Lock creates a versioned backup with a timestamp and file size. Versions are never automatically deleted.

Under Lockdown, the kernel blocks any program (including root) from reaching the backup files. A compromised approved program cannot destroy previous versions.

Use Backup (`[b]`) to add or remove directories, browse version history, and restore any previous version.

{{< /details >}}

{{< details summary="Will Root Lock flood me with alerts?" >}}

A: No. Most security tools flag suspicious patterns, and real threats get lost in the volume of alerts that produces.

Root Lock only alerts on unauthorized activity: a program attempting to execute without approval, or an outbound connection to an unapproved destination. Email groups those blocks in a 5-minute window and caps at three block emails per hour, then sends a digest. Syslog and webhook emit each alert immediately.

In Lockdown with a complete allowlist, alerts are rare — the allowlist already covers legitimate activity. Configure alerts through Alert Settings (`[e]`) (email, syslog, or webhook).

{{< /details >}}

{{< details summary="What does the free trial include?" >}}

A: Lockdown requires an active subscription, all review queues to be cleared, and alert settings to be configured. Setup Mode logs activity without blocking, so you can observe your workload before anything is blocked. The Dashboard presents a precondition checklist before activation.

{{< /details >}}

{{< details summary="I work remotely a lot; can I still access a Root Lock server remotely?" >}}

A: In Setup Mode, yes. Approve the SSH server to execute and to read the files it needs, the same as any other program; the allowlist entries the installer adds usually already cover `sshd`. sshd is stopped when Lockdown seals, unless you chose to leave it running before the seal. Unsealing Lockdown is the one step that needs the console, because it is a boot-menu pick. After unseal, SSH is how you work in Setup Mode.

Internet Access (`[i]`) is outbound destinations only. Adding the address you connect *from* there does not grant inbound SSH.

Root Lock still has SSH posture controls:

- **Lockdown** — Harden SSH (`[h]`) when an authorized key is already present (key-only login, direct root login off). Inbound permits (`[o]` / `[a]`) record which source addresses may reach sshd while sealed. `[r]` / `[j]` choose whether sshd stays up under Lockdown. The default is sshd stopped; leaving it running is not recommended.
- **Maintenance** — unseal is a console GRUB pick. Once the seal is lifted, keep a restricted SSH route, leave SSH open, or take the network down (console only). You can limit SSH to specific source addresses, or press `[n]` to leave it open to anyone (not recommended). See [Protecting During Maintenance](maintenance/protecting-during-maintenance/).

sshd's own config, an OS packet filter, and cloud security groups still apply. If you SSH *from* the Root Lock host *to* other hosts, those destination IPs appear in Internet Access for the SSH client. See [Network and Remote Access](network/).

{{< /details >}}

{{< details summary="What is the Dashboard?" >}}

A: The Dashboard is how you manage Root Lock. It shows your current mode (Setup or Lockdown), checklist progress, pending or denied counts, and a Suggested Next Step.

The indicator at the top confirms the current protection state. The Dashboard appears automatically on first login.

{{< /details >}}

{{< details summary="How does Root Lock guide me through setup?" >}}

A: A checklist walks you through the work: approving programs (`[p]`), approving file access (`[f]`), approving internet access (`[i]`), configuring script launchers (`[s]`), and setting up alerts (`[e]`).

The Dashboard tracks progress and always shows the next step. Lockdown unlocks only after the prior checklist items are complete.

{{< /details >}}

## Installation

{{< details summary="Is installation the same on a virtual machine as on a physical machine?" >}}

A: The Local Path command is the same on a physical host and on a full virtual machine. Cloud Path versus Local Path is how you obtain Root Lock: a pre-built image, or running the installer.

A full virtual machine with hardware virtualization (KVM, VMware, or a cloud hypervisor) is a supported install target, the same as bare metal. What differs is the machine: keyboard and monitor on metal, hypervisor serial console and virtio devices on a VM.

If the outer machine does not expose `/dev/kvm`, install on that outer machine: in a guest nested inside it, the installer stops at the start. See [Bare metal, virtual machines, and nested VMs](introduction/system-requirements/#bare-metal-virtual-machines-and-nested-vms).

{{< /details >}}

{{< details summary="If Root Lock runs in a VM, can a hypervisor jailbreak bypass it?" >}}

A: A full VM (KVM, VMware, AWS, Firecracker, Kata) is a supported install. Root Lock is the guest kernel. Under Lockdown it blocks unapproved programs, files, and outbound network inside that guest, including as root, and remote root in the guest cannot unseal Lockdown.

The hypervisor's own controls — serial console, pause/snapshot, and attaching the disk to another machine — sit outside the guest, so Root Lock does not police them. They are the same class as a keyboard on metal, so restrict them in hypervisor or cloud IAM.

A guest-to-host escape attacks the hypervisor itself. If it succeeds, the attacker is running outside the guest kernel, where no guest kernel's controls reach.

Shared-kernel containers (Docker/LXC as the *install target*) are not a fit by design: Root Lock must boot its own kernel. Root Lock as a hypervisor host is not a supported product role.

See [Containers and microVMs](introduction/containers-and-microvms/) and [Circumvention and recovery](introduction/how-it-compares/#circumvention-and-recovery).

{{< /details >}}

{{< details summary="Does Dell iDRAC (or iLO, or a cloud serial console) bypass Lockdown?" >}}

A: It is the supported way out of Lockdown.

Lockdown is built so remote root over SSH cannot unseal the allowlist or boot another kernel. The path out is the maintenance kernel, selected at the boot menu from a console. A console here means a keyboard to firmware, not an SSH session: a rack keyboard, a serial port, a BMC virtual console or serial-over-LAN (Dell iDRAC, HPE iLO, Lenovo XCC, IPMI SOL), a hypervisor serial console, or a cloud serial console.

If you can reach that console, you can select **Maintenance: unseal and return to Root Lock**. The boot menu password is off by default. If one was set, GRUB asks for the name root and that password before that entry or a kernel-line edit, while the normal Root Lock entry boots without asking.

See [Circumvention and recovery](introduction/how-it-compares/#circumvention-and-recovery).

{{< /details >}}

{{< details summary="Will installing the Root Lock kernel break my existing software?" >}}

A: The Root Lock kernel is installed alongside your existing kernel via GRUB — it does not replace it. You can boot the maintenance kernel from the GRUB menu. The Dashboard runs on the Root Lock kernel (serial console, and SSH when sshd is up), not on the maintenance kernel. A new install boots mainline LTS 6.18 (`uname -r` is `6.18.9-hs`).

Setup Mode reveals compatibility issues before anything is blocked: the kernel logs all activity without blocking, and programs that would fail in Lockdown appear in the Dashboard review queues.

On 6.18.9-hs the BPF syscall is off by design, so there is no eBPF program to load. See [System Requirements → Software Compatibility Notes](introduction/system-requirements/#software-compatibility-notes). Software not listed in that table runs on the Root Lock kernel like any other program: under Lockdown it needs an allowlist entry.

{{< /details >}}

{{< details summary="Once I've installed Root Lock, can a program access files without adding the directories to the allowlist entry?" >}}

A: No. In Lockdown, a program can only access files and directories that have been explicitly approved through the File Access review queue.

After you approve a program's execution, you approve its file access separately. The Dashboard shows every file the program read or wrote during Setup Mode.

{{< /details >}}

{{< details summary="Why do I need to reboot multiple times during installation?" >}}

A: The Root Lock kernel must be loaded during installation. Unattended initial setup records startup and shutdown programs that appeared in the previous boot and reboots as needed.

Multiple passes are needed because shutdown programs appear on the second boot, and timer-driven processes on later ones. The Dashboard appears when that chain is complete.

{{< /details >}}

{{< details summary="If the reboot after Part 1 fails, what should I do?" >}}

A: Reboot and select the Root Lock kernel from the GRUB menu. On a VM, use the hypervisor serial console, then `cat /var/log/heartsuite/install.log`.

If the installer stopped before reboot on a nested guest, install on the outer machine — see [Bare metal, virtual machines, and nested VMs](introduction/system-requirements/#bare-metal-virtual-machines-and-nested-vms).

{{< /details >}}

{{< details summary="The Dashboard has not appeared after install — what next?" >}}

A: Initial setup is still running. It is unattended: the host reboots on its own between passes. Watch the serial console for the finishing-install banner, or `cat /var/log/heartsuite/install.log`. The Dashboard appears when initial setup is complete. There is no System Setup screen and no `[a]` to press.

{{< /details >}}

{{< details summary="Should other software be installed before or after Root Lock?" >}}

A: Install the OS and the runtime packages this host will keep, then install Root Lock. Initial setup records boot and shutdown. After the Dashboard appears, Setup Mode logs the rest of the workload you will keep.

After Lockdown, add software through Maintenance — see [Protecting During Maintenance](maintenance/protecting-during-maintenance/). If you install compilers, probes, or other one-shot tools they become queue items, and approving them grants them under Lockdown.

{{< /details >}}

{{< details summary="Why do cloud-init or first-boot helpers appear?" >}}

A: Cloud images and first-boot provisioning often leave helpers that executed once to configure the instance. They appear in the Programs queue because they executed during Setup Mode.

Do not approve them if they are not part of the runtime workload. Approving them grants them under Lockdown.

{{< /details >}}

## Allowlisting

{{< details summary="How does Root Lock know which program is running? What if someone replaces the file?" >}}

A: Root Lock identifies a program by its **resolved absolute path** (what `execve` actually opened). Approving `/usr/bin/sshd` allows whatever file that path names at the next exec.

Under Lockdown, replacing that file is blocked, because the allowlist is immutable, many system trees are immutable, and a program can write a path only if its allowlist entry grants that write.

Root Lock checks the path when a program starts, so in-memory patching of an allowed process that is already running is outside that check. A compromised program that is already allowed still only gets the files and destinations on its entry.

See [How Root Lock Compares](introduction/how-it-compares/) (Fuchsia hashes every executable; Root Lock does not).

{{< /details >}}

{{< details summary="I approved /tmp or /usr in File Access — does Lockdown keep that?" >}}

A: Not by default. Before Lockdown finalizes, the Dashboard shows caution panels and strips several risky grants unless you opt out: kmod directory reads, unexpected writes into OS trees (including `/tmp` and `/usr`), GTFOBins-style file-write tools, install-tree writes, and bare `/` grants. `rm`/`cp`/`mv` can be restricted to the directories they used in Setup Mode.

If you do nothing, typing `YES` still narrows those grants; keeping one takes its undo key on the Lockdown activation view. Approving everything that appeared in Setup Mode and then undoing every narrowing is how the protection thins.

See [Lockdown](lockdown/).

{{< /details >}}

{{< details summary="Are kernel drivers on the allowlist? What about /dev/sda?" >}}

A: No. Video, network, and block drivers are kernel code. They are not programs and they do not appear in the Programs queue.

`/dev/sda` (or `/dev/vda`, `/dev/nvme0n1`) is a device node. Write access to it is a **file grant** on some userspace program — often a directory write to `/dev`. That write goes to the raw disk and skips the filesystem, which is why Root Lock requires a file grant for that open.

`kmod` is the loader. Early in every Root Lock kernel boot, `heartsuite-kernel-latch.service` sets `kernel.modules_disabled=1`. After that, a later modprobe stays refused. See [Restricting Kernel Module Loading](maintenance/kmod-hardening/).

{{< /details >}}

{{< details summary="A program only ran once during install — should I approve it?" >}}

A: Do not approve it if it will not execute in production. Approving it grants that program under Lockdown. Press `[s]` Skip for now to defer the item without granting it.

Install-time compilers, probes, and extra shells belong off the allowlist unless this host must keep them. See [Allowlisting Basics](allowlisting/allowlisting-basics/).

{{< /details >}}

{{< details summary="A new program is being blocked in Lockdown — what should I do?" >}}

A: In Lockdown, any program not on the allowlist is blocked. This typically happens after installing new software or a system update.

Select Maintenance (`[m]`) from the Dashboard. It guides you through switching to Setup Mode, where the new program appears in the review queue. Approve the programs you will keep. Do not approve install-only helpers. Then lock down again. See [Protecting During Maintenance](maintenance/protecting-during-maintenance/).

{{< /details >}}

{{< details summary="How do I add software after Lockdown?" >}}

A: Open Maintenance (`[m]`). If the seal is applied, reboot from a physical or serial console and select **Maintenance: unseal and return to Root Lock**. SSH is not enough for that GRUB pick. That boot runs `HS_unlock.sh`. After the seal lifts you are in Setup Mode: install what you will keep, review the queues, then lock down again. Do not approve compilers and package-install helpers that executed only for that window unless they must stay.

The procedure is in [Protecting During Maintenance](maintenance/protecting-during-maintenance/). Do not leave the host in Setup Mode to install tools you will not keep.

{{< /details >}}

{{< details summary="Can I allowlist directories instead of files?" >}}

A: Yes. When the File Access review queue presents grouped accesses from the same directory, you can approve directory-level access rather than each file individually.

For example, if Python reads 200 files from `/usr/lib/python3/`, the review queue groups them and lets you approve access to the entire directory at once.

{{< /details >}}

{{< details summary="How do I activate Lockdown?" >}}

A: The Dashboard unlocks Lockdown when the prior checklist items are complete and shows it as the Suggested Next Step. Activation requires typing `YES` (case-sensitive) to confirm.

{{< /details >}}

{{< details summary="How do I add network access for a program?" >}}

A: Every outbound destination must be approved per program. When a program connects during Setup Mode, it appears in the Internet Access queue (`[i]`) with its destination IPs and any reverse-DNS or CDN label the Dashboard resolved.

Approve network access from there. Approving an IP for one program does not approve it for another. In Lockdown, any destination not on that program's list is refused at the kernel. Inbound ports and client source IPs are out of scope — see [Network and Remote Access](network/).

{{< /details >}}

## Modes and security

{{< details summary="When should I activate Lockdown?" >}}

A: After the Dashboard shows the review checklist complete. Take your time in Setup Mode — allow several days to a week for systemd timers, cron jobs, and infrequent services to appear in the review queues.

The status line at the bottom of the Dashboard shows how long Setup Mode has been active (e.g., "Setup Mode — active for 3d 7h"). Switching too early will block programs that have not been approved.

{{< /details >}}

{{< details summary="What is Lockdown, and when to use it?" >}}

A: Lockdown makes all allowlist entries and configuration files immutable (`chattr +i`), then disables the ability to change immutability flags at the kernel level. Under Lockdown, root cannot add, delete, or change allowlist entries.

Use it in production after confirming programs work correctly under Lockdown.

{{< /details >}}

{{< details summary="What is the boot menu password?" >}}

A: An optional GRUB password, off by default, that guards the maintenance entry and kernel-line edits. Set it on Lockdown with `[l]` before the seal, while Setup Mode can still write the boot menu; after Lockdown that key is absent because `/boot` cannot be rewritten. At the GRUB prompt, the name is root and the password is the one you set with `[l]`, which is separate from the Linux root login password. The normal Root Lock boot does not ask, but selecting **Maintenance: unseal and return to Root Lock**, or editing the kernel line, does when one was set. If the password does not land, `YES` does not start Lockdown. Extlinux (Alpine) does not offer the control, and Lockdown still works there.

{{< /details >}}

{{< details summary="How do I apply the immutable seal after Lockdown?" >}}

A: The seal is applied as part of Lockdown activation (see the "How do I activate Lockdown?" entry above). Once confirmed and rebooted, Lockdown with the seal is active automatically on every Root Lock kernel boot.

{{< /details >}}

{{< details summary="How do I make configuration changes after entering Lockdown?" >}}

A: Select Maintenance (`[m]`) from the Dashboard. If the seal is not applied, type `YES` and reboot once into Setup Mode on the Root Lock kernel. If the seal is applied, reboot from a physical or serial console and select **Maintenance: unseal and return to Root Lock**. If a boot menu password was set, that pick asks for it. SSH is not enough for that GRUB pick. The seal lifts automatically (`HS_unlock.sh`) and you land in Setup Mode, then log in over SSH to make the changes. Review new activity in the queues, then re-engage Lockdown (`[l]`).

{{< /details >}}

{{< details summary="Does sshd, or a Dashboard key, lift the seal?" >}}

A: No. You leave Lockdown from a physical or serial console by selecting GRUB **Maintenance: unseal and return to Root Lock**. That boot runs `HS_unlock.sh` and returns you to the Root Lock kernel in Setup Mode, where Lockdown (`[l]`) seals again. Whether sshd is running on the Root Lock kernel has no effect on the seal, and neither a Dashboard key nor an allowlist grant lifts it remotely. If you are on the maintenance kernel, reboot: the GRUB default stays Root Lock.

{{< /details >}}

{{< details summary="How do I maintain or update in Lockdown?" >}}

A: Maintenance (`[m]`) detects whether the immutable seal is active and opens the matching path — a `YES` switch to Setup Mode on the Root Lock kernel, or the console GRUB entry **Maintenance: unseal and return to Root Lock** when the seal is applied. SSH is not enough for that GRUB pick. After unseal, SSH is how you install packages, edit files, and run the installer.

A product update will not overwrite Root Lock while that kernel is booted. Setup Mode is still the Root Lock kernel. If Lockdown is applied, unseal first. From a terminal in Setup Mode (SSH is fine), run `bash heartsuite-install.sh` and type `YES` for one stock boot. The default stays Root Lock. See [Updating Root Lock](maintenance/updating-heartsuite/).

Many locked hosts reprovision from an updated image instead (see the "How do I patch many hosts that are already in Lockdown?" entry above).

{{< /details >}}

## Troubleshooting

{{< details summary="How do I check if Root Lock is active?" >}}

A: The indicator at the top of the Dashboard immediately shows whether Root Lock is active and what mode it is in. The Dashboard appears automatically on login.

{{< /details >}}

{{< details summary="The system hangs—what's first?" >}}

A: From a physical or serial console, reboot and select **Maintenance: unseal and return to Root Lock**. If a boot menu password was set, that pick asks for it. The Dashboard is not launched on the maintenance kernel. That entry brings you back to the Root Lock kernel in Setup Mode, where the Dashboard shows any pending items that caused the hang.

{{< /details >}}

{{< details summary="How to clear Root Lock logs?" >}}

A: The Dashboard automatically clears the activity log (`/.hs/sys/HS_log.txt`) when all review queues are empty and Secure Script Launchers is not still pending. A maintenance reboot also clears it. There is no `hs-clear-logs` command. `ui.log`, the JSONL approval log, and the journal are not cleared by that path.

{{< /details >}}

For support email support@heartsecsuite.com.
