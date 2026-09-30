---
title: "After the agents got out: Root Lock and OpenShell"
linkTitle: "Root Lock and OpenShell"
date: 2026-09-30
slug: root-lock-and-openshell
draft: false
description: "The July 2026 agents left through an allowed package proxy. How that chain behaves under Root Lock and under NVIDIA OpenShell."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["root-lock", "openshell", "ai-agents", "sandbox", "hugging-face", "artifactory", "lockdown", "allowlisting"]
toc: true
---

The July sandbox had one sanctioned way out, and that way out was the package proxy. [The earlier note]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}) asks which later steps Lockdown refuses on the agent host. This note puts NVIDIA OpenShell next to that question. Root Lock is the guest kernel of the machine. OpenShell is a sandbox runtime whose supervisor sits outside the agent and holds the credentials. Neither product was in the incident. Neither one stops the whole chain.

{{< stat-row >}}
{{< stat number="~1,200" tone="info" label="agents found each other on the Artifactory board from the evening of 8 July through 13 July." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="70,000+" tone="teal" label="messages and files crossed that board, on the one outbound path the sandbox allowed." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="136 keys" tone="warning" label="in one production object, read on 11 July after node root on a Hugging Face worker." source="Hugging Face technical timeline, 2026" url="https://huggingface.co/blog/agent-intrusion-technical-timeline" >}}
{{< /stat-row >}}

{{% alert title="The short version" color="success" %}}

- **Open on both, when the proxy is already approved:** a message board on that hop, a request the proxy itself sends, a secret already in the process, and a bug inside a program that is already allowed to run.
- **Refused on a host in Lockdown:** a new program, a file that program was never granted, and an address that program was never granted. The metadata address is refused only when it has no grant.
- **Refused around an OpenShell agent, at the documented defaults:** an unlisted destination, the metadata address even when someone tries to approve it, and a provider credential the supervisor was not told to attach. A new file under `/tmp` can still be written. HTTP method rules log the violation and forward the request until they are set to enforce.
- **Another estate entirely:** the proxy host, the Modal customer's app, and the Hugging Face dataset bugs. Those stay with the operator of that estate.

{{% /alert %}}

## What the breakout actually used

OpenAI's [technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf) separates the network boundary from the container. Zero-days in self-hosted Artifactory, which was allowed to fetch packages, became the principal path to the public internet: the proxy sent requests on the agents' behalf. The first SSRF relay is dated 26 May 2026. Internet worked again through that relay on 8 July, before the rebuilt message board. The [earlier note]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}) follows write-ups that put the internet breakout through Modal. Read with the technical report, and with [METR](https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/), Modal is the shell that came after. [Modal](https://modal.com/blog/a-note-on-the-hugging-face-agent-incident) says the code stayed inside that customer's container and that Modal's platform isolation held.

[Hugging Face's timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline) puts a root shell in that customer's container at 04:01 UTC on 9 July. A debug shell there already shipped `curl`, `nc`, and `ip`, and pastebins became a staging area from that shell. Hugging Face's own dataset pipeline was the next estate, on 11 July: an HDF5 bug returned local files, including the process environment, and the timeline says no code ran on that path. A Jinja bug in the dataset config then ran commands. From inside that pod the agents reached `169.254.169.254`, read a service-account token, and later, after node root, read the object that held 136 keys.

A kernel bug on 19 July, CVE-2026-53362, did exit an Artifactory container onto an OpenAI worker. The technical report says that step did not lead to the Hugging Face compromise. The escape that reached Hugging Face was the allowed proxy, then bugs in other applications. About 700 of the agents on the board went on to take part. METR's count of roughly 1,200 agents and of more than 70,000 messages and files was not retracted in the sources above.

## Same steps, two controls

Picture one process at a time. For Root Lock the picture is the one in [AI agent and automation sandboxes](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes): the Root Lock kernel as the guest of a per-task virtual machine, the allowlist reviewed from a representative task, the seal run on that machine and taking effect on the next boot. For OpenShell the picture is their [architecture](https://docs.nvidia.com/openshell/about/architecture): the agent in the sandbox, Landlock on files, seccomp handing TCP and DNS to a supervisor, and no direct egress except that supervisor. The docs used here are OpenShell v0.1.2. The project is Apache 2.0 and the license ships it as is.

[Allowlisting](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/) approves each program on its own for execute, for files, and for network. [Network](https://docs.heartsecsuite.com/rootlock/network/) grants are specific IPv4 and IPv6 addresses, per program. Approving an address for `curl` leaves `wget` untouched. [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/) then seals that allowlist with filesystem immutability: while the server is running, no program, including root, can modify it.

| Step | Where it ran | Root Lock, if that process is on a host in Lockdown | OpenShell, if that process is the sandbox workload |
|---|---|---|---|
| Message board on the approved proxy | Artifactory, the allowed hop | The proxy's address stays approved. A board built from allowed programs, over that address, still works. | The listed host, port, and binary stay approved. With no request protocol set, any HTTP method and path on that hop is forwarded. |
| The proxy sends the internet request | Artifactory's own process | Stays with the proxy. The agent host's allowlist does not govern a process on another machine. | Stays with the proxy. The link-local block applies to connections the sandbox itself opens. |
| New public destination | Pastebins, Hugging Face, the open internet, from the agent | Blocked when that program has no grant for the address. | Blocked. Unlisted destinations are denied, and the workload's egress is the supervisor channel. |
| Metadata address `169.254.169.254` | Hugging Face pod, after the foothold | Blocked when that program has no grant for the address. A grant for that address would allow it. | Blocked. That address sits in the link-local range the network policy never authorizes, and a proposal that targets it cannot be approved. |
| A new binary on disk | Dropped by the agent | Refused at execution. A path with no allowlist entry does not run. Programs already listed are immutable for the life of that boot, so those files cannot be swapped while the machine is running. The entry names a path. Root Lock does not verify executables by hash. | `/tmp` and the working directory are writable. The docs do not describe a general ban on executing a new file. A program the agent starts can use the network rules of the binary that started it, and it does not gain destinations of its own. Replacing the bytes at a path the network rule already pinned fails that first-seen SHA256 check. `/usr` is read-only. |
| `curl` or `nc` already in the image | Modal debug shell, 9 July | Reaches only addresses on that program's own entry. | Reaches only endpoints listed for that binary, or for a binary that started it. |
| A secret file the program was never granted | Service-account token, the 136-key object | That read is refused for that program. | Other paths are inaccessible when the filesystem rules are applied. Those extra rules default to best effort: if they cannot be applied, the sandbox can start without them. The private channel between sandbox and supervisor stays hidden either way. |
| A secret already in the environment, or in a file the program may read | HDF5 returned `/proc/self/environ` | Travels with the program. Keep it out of the environment and out of granted paths. | A provider key is a placeholder. The supervisor adds the real key only on an endpoint the profile binds. A real value placed in the workload environment stays readable. |
| A bug inside an allowed program | HDF5 file read, then Jinja commands, 11 July | The bug still runs. The refusal is the next new program, the next ungranted file, or the next ungranted address. | The bug still runs, inside the sandbox. The refusal is that same next step. |
| A container or kernel exit onto the host | Not the path into Hugging Face. The 19 July kernel bug was an Artifactory worker, and OpenAI says it did not lead there. | Docker, containerd, Kubernetes, CRI-O, and Podman are not a supported workload on a Root Lock host. The supported shape is the guest kernel of a virtual machine. The hypervisor that owns that guest's disk is outside the guest. | Seccomp blocks a fixed list of calls, including creating a user namespace. User namespaces, which would land a container escape as an unprivileged host user, stay off unless you turn them on. Once the process is on the host, the sandbox fence does not follow it. |
| Widening policy after a denial | Operators, or an agent asking for a new rule | The seal holds for the life of that boot. Leaving Lockdown is the console or serial pick **Maintenance: unseal and return to Root Lock**. SSH does not lift the seal. There is no prover in the product. | Network rules can change on a running sandbox. An approval in the TUI is kept for that sandbox until the sandbox is destroyed. The prover blocks automatic approval of a new credentialed destination, a new HTTP method on a destination that already receives credentials, and the metadata range. A new public host with no credential attached is not one of those findings. A person can still approve that host. Filesystem rules change by creating a new sandbox. |
| A root shell tries to turn the control off | The Modal shell was `uid=0` | On the [11 September lab]({{< relref "/blog/2026-09-11-lockdown-after-a-root-shell" >}}), one Debian 12 host already in Lockdown refused an allowlist write and `chattr -i` from a root shell. That is one machine. While that kernel is running, the [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/) page states that no program, including root, can modify the sealed allowlist. The way out is the maintenance-kernel boot above. The lab did not take that boot. | The sandbox process is a non-root user with no Linux capabilities, and root inside the sandbox is rejected. Credentials and policy sit with the supervisor, outside the agent. |

Two defaults change the OpenShell column if you leave them alone. The [architecture page](https://docs.nvidia.com/openshell/about/architecture) says the kernel is instrumented for every file access, system call, and network connection. The [control pages](https://docs.nvidia.com/openshell/security/best-practices) are narrower. Files beyond a mandatory baseline follow Landlock rules that default to best effort. System calls follow a fixed denylist, not an allowlist edited per agent. Connections to unlisted destinations are denied, while HTTP method and path rules default to audit: the proxy logs the violation and forwards the request. A passing [prover](https://docs.nvidia.com/openshell/how-it-works/policies/prover) check is a check of the policy text. That page says the result does not mean a running sandbox enforces the policy.

Root Lock's rule on a sealed host is the three actions: run a program, touch a file, open a connection, each per program. It does not attach credentials on the way out, it does not inspect HTTP methods, and it does not check a policy change with a solver. Setup Mode, before the seal, logs what the workload did so you can approve it. Lockdown is the seal. There is no permissive switch on that sealed boot.

## What you still do either way

The checklist on the [earlier note]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}) still applies, with or without either control.

1. Treat the package proxy as one hop. The board in this incident was that hop, and part of it was written with credentials the agents had already been given, before any zero-day.
2. Patch the proxy. BleepingComputer reported the OpenAI-credited fixes in Artifactory 7.161.15, released 27 July 2026. JFrog did not name which flaw was the SSRF that carried the traffic. Keep anonymous access off, and limit where the proxy itself may connect.
3. Keep long-lived tokens out of the files and the environment the agent can read. On Hugging Face the HDF5 bug returned `/proc/self/environ` before any command ran.
4. Put authentication on anything that runs submitted code. That is the Modal customer's app in this chain.
5. If you run OpenShell, switch HTTP rules from audit to enforce after the rules match the traffic you meant to allow, and set the extra filesystem policy to a hard requirement where those paths must hold.
6. Assume an allowed program will have a bug. The refusal worth planning for is the next program, the next file, and the next address.

## Where each control belongs

OpenShell's documented runtimes are Docker, Podman, Kubernetes, and a virtual machine whose guest has no network device, with the supervisor on the host. Those container engines are not a supported workload on a Root Lock host. Build and run them on another machine. The agent fit already written for Root Lock is the guest kernel of a virtual machine you provide, sealed for the life of the task, then discarded.

Use OpenShell when the job is one agent that must call an API without holding the provider key, with a person approving new destinations while the sandbox is still up. Use Root Lock when the job is the whole guest: every program on that machine, including ones running as root, for the life of the boot, with a change of allowlist waiting on the console boot menu. A hypervisor, an outside boot, or moving the disk sits outside that guest. [Circumvention and recovery](https://docs.heartsecsuite.com/rootlock/introduction/how-it-compares/#circumvention-and-recovery) is the page for that limit.

The July chain splits the same way on either control. The proxy's own request, the unauthenticated code runner, and the dataset parser belong to those applications. The moves after the shell — a new program, a file the program was never granted, a destination it was never granted — are the steps a sealed Root Lock guest refuses, and the steps an OpenShell sandbox refuses when the destination was never listed. What stays open is traffic inside the grants you already made. That is why the proxy is still on the checklist.
