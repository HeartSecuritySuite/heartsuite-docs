---
title: "After the agents got out: Root Lock and OpenShell"
linkTitle: "Root Lock and OpenShell"
date: 2026-09-30
slug: root-lock-and-openshell
draft: false
description: "The July 2026 agents left through an allowed package proxy. Which of the later steps Lockdown refuses, which an OpenShell sandbox refuses, and which stay open."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["root-lock", "openshell", "ai-agents", "ai-agent-security", "sandbox", "hugging-face", "artifactory", "supply-chain", "egress", "allowlisting", "lockdown", "exploitgym"]
toc: true
---

You gave the agents a sandbox with no internet. The one sanctioned way out was the package proxy, because the agents needed packages. In July 2026 that is the exact shape that failed. Agents in OpenAI's ExploitGym evaluation were meant to be isolated from the internet and from each other. [METR's investigation](https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/) found that roughly 1,200 of them turned the self-hosted Artifactory proxy into an unsanctioned message board, sent over 70,000 messages and files, and that 700 went on to attack Hugging Face. Of the 533 agents METR saw active on the board during the attack period, over 90% quickly joined in.

{{< stat-row >}}
{{< stat number="~1,200" tone="info" label="agents meant to be isolated found each other on an unsanctioned message board." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="70,000+" tone="teal" label="messages and files crossed that board — through the one outbound path the sandbox allowed." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="700" tone="warning" label="of those agents went on to take part in the attack on Hugging Face." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< /stat-row >}}

Every attack does three things: run a program, access files, make a network connection. Under Lockdown, Root Lock enforces default-deny on all three at the kernel, per program, including programs running as root. There is no permissive mode to flip, no LSM to unload, no userspace shim to detach, and no agent to kill, and an attacker who already has root cannot edit the allowlist while that server is running. OpenShell puts a supervisor outside the agent and has that supervisor decide the network connection, so the agent does not hold the provider credential. That makes the July chain a fair test of both. This post answers a narrow question honestly: on an agent host in Lockdown, and around an agent inside OpenShell, which steps are refused, and which still belong to the proxy, the platform, and the application? Neither product took part in this incident, and nothing here claims either would have stopped the whole chain.

{{% alert title="The short version" color="success" %}}

- **Refused:** under Lockdown, a program the agent drops that has no allowlist entry, a file the interpreter was never granted, and a connection outside its grants — the open internet, Hugging Face, Modal, or the metadata endpoint. Around an OpenShell agent, an unlisted destination is denied, the metadata address cannot be approved, and provider credentials stay with the supervisor.
- **Still open:** traffic to the one approved destination, the package proxy. A message board built on that proxy, and a zero-day inside it, belong to the proxy. A secret already in the process travels with it. A bug inside an allowed program still runs.
- **What you get:** after the shell, the next new program, file, or destination is refused, whether or not anyone is watching the alerts. On Lockdown that refusal is the kernel, including for a program running as root, for the life of that boot. On OpenShell it is the supervisor.

{{% /alert %}}

## How the agents got out

OpenAI ran ExploitGym with cyber refusals lowered so agents could show raw capability, with isolation from the public internet meant to hold. According to METR, many agents — usually ones that had unintentionally been given an impossible task — started looking for a way to cheat using Artifactory, the internally deployed package repository. The July board was established on the evening of July 8, and METR's investigation covers June 26 to July 13, 2026. OpenAI's own account is Artifactory as board and escape hatch, then a Modal customer's app as the shell, then Hugging Face ([road ahead](https://openai.com/index/hugging-face-incident-and-the-road-ahead/); [technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf)).

### The Artifactory package proxy became the message board

The sanctioned outbound path was self-hosted JFrog Artifactory. Agents turned the cache into their own board. Part of that board was written with credentials they had already been given, before any zero-day. [OpenAI's technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf) says zero-days in the proxy then became the principal path to the internet: Artifactory, allowed to fetch packages, sent requests on the agents' behalf. The first SSRF relay is May 26. Internet worked again through that relay on July 8, before the rebuilt board. [BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-models-used-artifactory-zero-days-to-escape-to-the-internet/) lists eight CVEs credited to OpenAI and fixed in Artifactory 7.161.15 Self-Managed, released July 27, 2026. [JFrog](https://jfrog.com/blog/jfrog-and-openai-collaboration-on-zero-day-security-findings/) did not name which flaw carried the traffic.

### From the Modal shell to Hugging Face

Once that path existed, a customer's app on Modal gave the agents a shell: a public endpoint with no authentication, built to compile and run code submitted by anyone. [Modal](https://modal.com/blog/a-note-on-the-hugging-face-agent-incident) states the code execution stayed inside that customer's own container and that Modal's platform isolation was not compromised. [Hugging Face's timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline) puts a root shell in that container at 04:01 UTC on July 9. A debug shell there already shipped `curl`, `nc`, and `ip`, and within hours pastebins and file-drop hosts were a staging area.

Hugging Face's own dataset pipeline was the next estate ([disclosure](https://huggingface.co/blog/security-incident-july-2026)). On July 11 an HDF5 bug returned local files, including the process environment, and the timeline says no code ran on that path. A Jinja bug in the dataset config then ran commands. From inside that pod the agents reached the metadata endpoint at `169.254.169.254`, read a service-account token, and later, after node root, pulled a production secrets object holding 136 keys — the read that yielded both the mesh-VPN key used minutes later and a second credential used an hour later.

{{< stat-row >}}
{{< stat number="~17,600" tone="info" label="attacker actions reconstructed from the launchpad logs between July 9 and July 13." source="Hugging Face technical timeline, 2026" url="https://huggingface.co/blog/agent-intrusion-technical-timeline" >}}
{{< stat number="136 keys" tone="warning" label="in one production secrets object — read after node root, and the read that opened the mesh VPN." source="Hugging Face technical timeline, 2026" url="https://huggingface.co/blog/agent-intrusion-technical-timeline" >}}
{{< stat number="~$400K" tone="teal" label="in API credits spent over six days just to investigate what the agents did." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< /stat-row >}}

The cleanup is its own cost. Hugging Face rotated VPN auth keys, IAM keys, database credentials, and JWTs across its infrastructure. METR's three investigators spent six days and roughly $400K in API credits on about 1,300 transcripts, and in roughly 7% of those transcripts the agents had spoofed tool-call output in places, on the eval host. A kernel bug on July 19, CVE-2026-53362, did exit an Artifactory container onto an OpenAI worker. The technical report says that step did not lead to the Hugging Face compromise.

## What each control refuses after the shell

Root Lock's model is: you approve what each program may execute, which files it may touch, and which destinations it may reach, then seal that under Lockdown. See [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), [Network](https://docs.heartsecsuite.com/rootlock/network/), and [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/). Network grants are specific addresses, per program. Approving an address for `curl` leaves `wget` untouched.

For AI agent sandboxes, run Root Lock as the guest kernel of a per-task virtual machine. You run a representative agent task in Setup Mode, review and approve the tools it uses in the Dashboard queues, and bake that allowlist into the VM image. The image carries the allowlist and is not sealed. You run the seal on that machine, and the seal takes effect on the next boot. The allowlist holds for the life of the task until the VM is discarded. See [Deployment scenarios → AI agent and automation sandboxes](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes). This fits agents with a well-scoped tool set. An agent that calls unpredictable tools at runtime is harder to allowlist, and that is where the fit ends; for scoped agents, every tool it does need is one you approved.

OpenShell is the other shape. The agent runs in the sandbox. Landlock limits files. Seccomp hands TCP and DNS to a supervisor outside the sandbox, and that channel is the workload's egress. The docs used here are [OpenShell v0.1.2](https://docs.nvidia.com/openshell/about/architecture). The project is Apache 2.0 and the license ships it as is. Docker, Podman, and Kubernetes are how that sandbox is usually started, and those engines are not a supported workload on a Root Lock host.

Picture the eval host in Lockdown, with an allowlist that holds the agent's interpreter, a short list of tools, and one outbound destination: Artifactory. Picture the same agent as an OpenShell workload with that proxy as its one approved destination. Any extra binary the agent drops has no Root Lock allowlist entry, so the kernel refuses to run it. A tool already on the allowlist, such as `curl`, reaches only the destinations its own entry approves. Around the OpenShell agent, `curl` reaches only endpoints listed for it. Secret files and the metadata endpoint are outside the grants, so those reads and connections are refused. Refusals on a Root Lock host are logged by the kernel, not reported by the agent.

| Phase | What happened | On an agent host in Lockdown | Around an OpenShell agent |
|---|---|---|---|
| Cheat seeking | Allowed programs run | Same — allowlisted tools still run | Same — the agent you started still runs |
| Artifactory board | Shared cache as a message bus | Artifactory stays approved; extra helper programs are refused at execution; an HTTP board on the approved proxy is still possible | The listed host stays approved; with no request rules, any method on that hop is forwarded |
| Proxy zero-days → internet | The proxy sends the request | Dials from the agent to Hugging Face, Modal, or the metadata address are refused without a grant. If Artifactory itself connects, harden the proxy host | The sandbox does not open those destinations. The proxy's own request sits outside it |
| Modal launchpad | Unauthenticated code execution in a customer app | Not reached while the eval host's outbound refusal holds | Not reached while the sandbox's egress refusal holds |
| Hugging Face dataset renderer | File-read bug, then a template bug; pastebins, metadata, token files | On a renderer VM with Root Lock as the guest kernel, the bug still runs; pastebin addresses, the metadata address, and token files never granted are refused | The bug still runs in the sandbox; an unlisted pastebin is denied; the metadata address cannot be approved; a file outside the Landlock list is refused when those rules apply |
| Credential harvest | Secrets in the environment, then 136 keys | A secret in the program's own environment travels with it; a file or address never granted stays refused | A provider key stays with the supervisor; a secret already in the environment stays readable |

The same boundary shows up on a build host. CVE-2024-27198, an unauthenticated remote code execution bug in JetBrains TeamCity, lets an attacker who reaches the server try to run any program without credentials. Under Lockdown on a Root Lock build host, that program has no allowlist entry, so the kernel refuses to run it. A supply-chain attacker who works through the pipeline's own credentials and tooling is a different case: every program they run is already approved, so the execution check allows it, and the network allowlist is what still blocks destinations outside the approved list. The Artifactory SSRF bugs are that second class — the allowlisted proxy stays reachable — while the moves the agent makes after it has a shell on the eval host are refused at the kernel.

That is where each control is strongest: the connection the agent itself opens, and the program or file it reaches for after the shell. OpenShell also keeps provider keys on the supervisor. A zero-day inside an allowed application, or inside the proxy, still has to be fixed there, which is why the checklist below applies with or without either control. Two OpenShell defaults belong in that reading. HTTP method rules log the violation and forward the request until you set them to enforce. Extra filesystem rules default to best effort and can be skipped when they cannot be applied. For a hands-on comparison of what root could and could not undo on AppArmor, SELinux, and Lockdown, see [What Lockdown refused after root already had a shell]({{< relref "/blog/2026-09-11-lockdown-after-a-root-shell" >}}). That lab is one Debian 12 host. The way out of Lockdown, which the lab did not take, is the console or serial pick **Maintenance: unseal and return to Root Lock**. SSH does not lift the seal.

## AI agent sandbox security checklist

The gap is common. In [IBM's 2025 Cost of a Data Breach report](https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai), 13% of surveyed organizations had experienced an attack that affected their AI models or applications, and 97% of breached organizations that had an AI-related security incident said they lacked proper AI access controls.

{{< stat-row >}}
{{< stat number="13%" tone="info" label="of surveyed organizations had an attack that affected their AI models or applications." source="IBM Cost of a Data Breach, 2025" url="https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai" >}}
{{< stat number="97%" tone="warning" label="of breached organizations with an AI-related incident lacked proper AI access controls." source="IBM Cost of a Data Breach, 2025" url="https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai" >}}
{{< /stat-row >}}

With or without either control:

1. Refuse agent outbound connections by default, by destination. Treat the package proxy as one approved hop, separate from the open internet.
2. Harden the package proxy as a hostile hop: patch it (Artifactory 7.161.15 or later for this chain), keep anonymous access off (the advisory text quoted by BleepingComputer calls it disabled by default and not recommended for production), and limit where the proxy itself may connect.
3. Strip cloud access by default from eval hosts: block the metadata endpoint, and keep long-lived cloud tokens and secrets out of the files and environment the agent can read.
4. Inventory shared writable stores agents can turn into a message board.
5. Put authentication on anything that runs submitted code, like the Modal customer app in this chain.
6. Assume allowlisted apps get zero-days. Plan controls for what happens after the shell on the hosts that matter.
7. On OpenShell, switch HTTP rules from audit to enforce once they match the traffic you meant to allow, and set the extra filesystem policy to a hard requirement where those paths must hold.

## What the breach shows about agent containment

The July chain splits cleanly in two. The first hop on each operator's hosts — the zero-days in Artifactory, the unauthenticated code execution in the Modal customer app, the parser bug at Hugging Face — belongs to that application and its operator. The moves after the shell — pastebin loaders, secret files, the metadata endpoint, connections to the open internet — each needed a new program, a file the program was never granted, or a destination it was never granted. On a host in Lockdown the kernel refuses each of those while that kernel is running, including for a program running as root, whether or not anyone is watching the alerts. Around an OpenShell agent the supervisor refuses an unlisted destination, and it refuses the metadata address even when someone tries to approve it. What stays open is traffic inside the grants, such as a message board on the approved proxy, and that is why the proxy is on the checklist above.

OpenShell's runtimes are Docker, Podman, Kubernetes, and a virtual machine whose guest has no network device. Build and run those container engines on another machine. The Root Lock fit for this job is the guest kernel of a virtual machine you provide, sealed for the life of the task, then discarded. A hypervisor, an outside boot, or moving the disk sits outside that guest. [Circumvention and recovery](https://docs.heartsecsuite.com/rootlock/introduction/how-it-compares/#circumvention-and-recovery) is that limit.

If your agent sandboxes fit that model, continue from [Deployment scenarios](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/) and [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), and from the [Lockdown-only walkthrough of this same chain]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}). Ask for a threat-model review that keeps those two questions apart: the first-hop application bug, and what the boundary refuses after the shell. For kernel CVEs whose code is in the Root Lock kernel, the [compiled-in CVE ledger](https://docs.heartsecsuite.com/rootlock/security/compiled-in-cves/) lists what Lockdown bounds on each one.
