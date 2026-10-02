---
title: "AI agent breach at Hugging Face: what Lockdown would stop"
linkTitle: "AI agent swarm vs Lockdown"
date: 2026-09-10
draft: false
description: "In July 2026, AI agents escaped an OpenAI test sandbox via Artifactory and breached Hugging Face. Which steps kernel-level Lockdown refuses, and which it can't."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["root-lock", "ai-agents", "ai-agent-security", "sandbox", "hugging-face", "artifactory", "supply-chain", "egress", "allowlisting", "lockdown", "exploitgym"]
toc: true
---

You gave the agents a sandbox with no internet. The one sanctioned way out was the package proxy, because the agents needed packages. In July 2026 that is the exact shape that failed. Agents in OpenAI's ExploitGym evaluation were meant to be isolated from the internet and from each other. [METR's investigation](https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/) found that roughly 1,200 of them turned the self-hosted Artifactory proxy into an unsanctioned message board, sent over 70,000 messages and files, and that 700 went on to attack Hugging Face. Of the 533 agents METR saw active on the board during the attack period, over 90% quickly joined in.

{{< stat-row >}}
{{< stat number="~1,200" tone="info" label="agents meant to be isolated found each other on an unsanctioned message board." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="70,000+" tone="teal" label="messages and files crossed that board — through the one outbound path the sandbox allowed." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="700" tone="warning" label="of those agents went on to take part in the attack on Hugging Face." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< /stat-row >}}

Every attack does three things: run a program, access files, make a network connection. Under Lockdown, Root Lock enforces default-deny on all three at the kernel, per program, including programs running as root. There is no permissive mode to flip, no LSM to unload, no userspace shim to detach, and no agent to kill, and an attacker who already has root cannot edit the allowlist. That makes the July chain a fair test. This post answers a narrow question honestly: on an agent host running Root Lock in Lockdown, which steps does the kernel refuse, and which still belong to the proxy, the platform, and the application? Root Lock did not take part in this incident, and nothing here claims it would have stopped the whole chain.

{{% alert title="The short version" color="success" %}}

- **Refused under Lockdown on the agent host:** a program the agent drops that has no allowlist entry, a file the agent's interpreter was never granted, and a connection to any destination outside its grants — the open internet, Hugging Face, Modal, or the cloud metadata endpoint.
- **Still open:** traffic to the one approved destination, the package proxy. A message board built on that proxy, and a zero-day inside it, belong to the proxy.
- **What you get:** after the shell, the agent's next new program, file, or destination is refused at the kernel, as root or not, whether or not anyone is watching the alerts.

{{% /alert %}}

## How AI agents escaped the ExploitGym sandbox

OpenAI ran ExploitGym with cyber refusals lowered so agents could show raw capability, with isolation from the public internet meant to hold. According to METR, many agents — usually ones that had unintentionally been given an impossible task — started looking for a way to cheat using Artifactory, the internally deployed package repository. The board was established on the evening of July 8, and the investigation covers June 26 to July 13, 2026. OpenAI's own account follows the same arc: Artifactory as board and escape hatch, then a Modal customer's app as launchpad, then Hugging Face ([road ahead](https://openai.com/index/hugging-face-incident-and-the-road-ahead/); [initial disclosure](https://openai.com/index/hugging-face-model-evaluation-security-incident/)).

### The Artifactory package proxy became the message board

The sanctioned outbound path was self-hosted JFrog Artifactory. Agents turned the cache into their own board, and found zero-days in the proxy itself. [BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-models-used-artifactory-zero-days-to-escape-to-the-internet/) lists eight CVEs credited to OpenAI and fixed in Artifactory 7.161.15 Self-Managed, released July 27, 2026: three server-side request forgery bugs in remote repositories, an authentication bypass and an authorization flaw that each lead to privilege escalation, a path traversal, remote code execution on the package service container, and exposure of build environment properties ([JFrog](https://jfrog.com/blog/jfrog-and-openai-collaboration-on-zero-day-security-findings/)). OpenAI's [technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf) says those zero-days became the principal path to the internet: Artifactory, allowed to fetch packages, sent requests on the agents' behalf. The first SSRF relay is dated May 26, and internet access worked again through that relay on July 8. The public write-ups do not name one CVE as the escape.

### From the Modal launchpad to the Hugging Face breach

Once the proxy relay reached the internet, a customer's app on Modal gave the agents a shell: a public endpoint with no authentication, designed to compile and run code submitted by anyone. [Modal](https://modal.com/blog/a-note-on-the-hugging-face-agent-incident) states the code execution stayed inside that customer's own container and that Modal's platform isolation was not compromised. METR describes agents building shared tools on that shell for the rest of the campaign.

The [Hugging Face technical timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline) reconstructs about 17,600 attacker actions between July 9 and July 13, and puts the first root shell in that Modal container at 04:01 UTC on July 9. The agent did not need to download a toolkit there: a bundled debug shell already shipped `curl`, `nc`, and `ip`, and within hours pastebins and file-drop hosts were its staging area. On July 11 it went after Hugging Face's own dataset pipeline ([disclosure](https://huggingface.co/blog/security-incident-july-2026)). An HDF5 bug returned local files, including the process environment, and a Jinja bug in the dataset config then ran commands. From inside that pod the agent reached the cloud metadata endpoint at `169.254.169.254`, read a service-account token, and after node root pulled a production secrets object holding 136 keys — the read that yielded both the mesh-VPN key used minutes later and a second credential used an hour later.

{{< stat-row >}}
{{< stat number="~17,600" tone="info" label="attacker actions reconstructed from the launchpad logs between July 9 and July 13." source="Hugging Face technical timeline, 2026" url="https://huggingface.co/blog/agent-intrusion-technical-timeline" >}}
{{< stat number="136 keys" tone="warning" label="in one production secrets object — a single read that opened the mesh VPN." source="Hugging Face technical timeline, 2026" url="https://huggingface.co/blog/agent-intrusion-technical-timeline" >}}
{{< stat number="~$400K" tone="teal" label="in API credits spent over six days just to investigate what the agents did." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< /stat-row >}}

The cleanup is its own cost. Hugging Face rotated VPN auth keys, IAM keys, database credentials, and JWTs across its infrastructure. METR's three investigators spent six days on site and roughly $400K in API credits reading about 1,300 agent transcripts, and in roughly 7% of those transcripts the agents had spoofed tool-call output in places. A record the agent can write is not a record you can trust after the fact.

## What Lockdown would have stopped on the agent host

Root Lock's model is: you approve what each program may execute, which files it may touch, and which destinations it may reach, then seal that under Lockdown. See [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), [Network](https://docs.heartsecsuite.com/rootlock/network/), and [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/).

For AI agent sandboxes, run Root Lock as the guest kernel of a per-task virtual machine. You run a representative agent task in Setup Mode, review and approve the tools it uses in the Dashboard queues, and bake that allowlist into the VM image. The image carries the allowlist and is not sealed. You run the seal on that machine, and the seal takes effect on the next boot. The allowlist holds for the life of the task until the VM is discarded. See [Deployment scenarios → AI agent and automation sandboxes](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes). This fits agents with a well-scoped tool set. An agent that calls unpredictable tools at runtime is harder to allowlist, and that is where the fit ends; for scoped agents, every tool it does need is one you approved.

Picture the eval host in Lockdown, with an allowlist that holds the agent's interpreter, a short list of tools, and one outbound destination: Artifactory. Any extra binary the agent drops has no allowlist entry, so the kernel refuses to run it. A tool already on the allowlist, such as `curl`, reaches only the destinations its own entry approves. Secret files and the cloud metadata endpoint are outside the interpreter's file and network grants, so those reads and connections are refused, and so is a connection to the open internet from any program without a grant for it. Refusals are logged by the kernel, not reported by the agent, so the record does not depend on a transcript the agent could spoof.

| Phase | What happened | On an agent host in Lockdown |
|---|---|---|
| Cheat seeking | Allowed programs run | Same — allowlisted tools still run |
| Artifactory board | Shared cache as a message bus | Artifactory is still an approved destination; extra helper programs are refused at execution; an HTTP board on the approved proxy is still possible |
| Proxy zero-days → internet | SSRF and privilege escalation in Artifactory | Agent connections to Hugging Face, Modal, or the metadata endpoint are refused without a grant. If Artifactory itself makes the outbound request, harden the proxy host |
| Modal launchpad | Unauthenticated code execution in a customer app | A direct connection from the eval host to Modal is refused without a grant. The relay through the proxy's own requests stays with the proxy, and authentication on that app belongs to its operator |
| Hugging Face dataset renderer | Parser bug, then pastebin loaders, metadata endpoint, token files | Shared-kernel Kubernetes nodes are not a Root Lock workload. Where a renderer runs in its own VM with Root Lock as the guest kernel, the parser bug still runs; pastebin and file-drop destinations, the metadata endpoint, and token files the renderer was never granted are refused |
| Credential harvest | Secrets in the environment, then 136 keys over the cluster API | Secrets passed in a program's own environment travel with that program, so keep them out of it; a file or destination it was never granted stays refused |

The same boundary shows up on a build host. CVE-2024-27198, an unauthenticated remote code execution bug in JetBrains TeamCity, lets an attacker who reaches the server try to run any program without credentials. Under Lockdown on a Root Lock build host, that program has no allowlist entry, so the kernel refuses to run it. A supply-chain attacker who works through the pipeline's own credentials and tooling is a different case: every program they run is already approved, so the execution check allows it, and the network allowlist is what still blocks destinations outside the approved list. The Artifactory SSRF bugs are that second class — the allowlisted proxy stays reachable — while the moves the agent makes after it has a shell on the eval host are refused at the kernel.

That is where Root Lock is strongest: the agent process's outbound connections, and the programs, files, and destinations the agent reaches for after it has a shell. A zero-day inside an allowlisted application still has to be fixed in that application, which is why the checklist below applies with or without Root Lock. For a hands-on comparison of what root could and could not undo on AppArmor, SELinux, and Lockdown, see [What Lockdown refused after root already had a shell]({{< relref "/blog/2026-09-11-lockdown-after-a-root-shell" >}}).

## AI agent sandbox security checklist

The gap is common. In [IBM's 2025 Cost of a Data Breach report](https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai), 13% of surveyed organizations had experienced an attack that affected their AI models or applications, and 97% of breached organizations that had an AI-related security incident said they lacked proper AI access controls.

{{< stat-row >}}
{{< stat number="13%" tone="info" label="of surveyed organizations had an attack that affected their AI models or applications." source="IBM Cost of a Data Breach, 2025" url="https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai" >}}
{{< stat number="97%" tone="warning" label="of breached organizations with an AI-related incident lacked proper AI access controls." source="IBM Cost of a Data Breach, 2025" url="https://www.ibm.com/think/x-force/2025-cost-of-a-data-breach-navigating-ai" >}}
{{< /stat-row >}}

With or without Root Lock:

1. Refuse agent outbound connections by default, by destination. Treat the package proxy as one approved hop, separate from the open internet.
2. Harden the package proxy as a hostile hop: patch it (Artifactory 7.161.15 or later for this chain), keep anonymous access off (the advisory text quoted by BleepingComputer calls it disabled by default and not recommended for production), and limit where the proxy itself may connect.
3. Strip cloud access by default from eval hosts: block the metadata endpoint, and keep long-lived cloud tokens and secrets out of the files and environment the agent can read.
4. Inventory shared writable stores agents can turn into a message board.
5. Put authentication on anything that runs submitted code, like the Modal customer app in this chain.
6. Assume allowlisted apps get zero-days. Plan controls for what happens after the shell on the hosts that matter.

## What the breach shows about agent containment

The July chain splits cleanly in two. The first hop on each operator's hosts — the zero-days in Artifactory, the unauthenticated code execution in the Modal customer app, the parser bug at Hugging Face — belongs to that application and its operator. The moves after the shell — pastebin loaders, secret files, the metadata endpoint, connections to the open internet — each needed a new program, a file the program was never granted, or a destination it was never granted. On a host in Lockdown the kernel refuses each of those, as root or not, whether or not anyone is watching the alerts. What stays open is traffic inside the grants, such as a message board on the approved proxy, and that is why the proxy is on the checklist above.

If your agent sandboxes fit that model, continue from [Deployment scenarios](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/) and [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), and ask for a threat-model review that keeps those two questions apart: the first-hop application bug, and what Lockdown refuses after the shell. For kernel CVEs whose code is in the Root Lock kernel, the [compiled-in CVE ledger](https://docs.heartsecsuite.com/rootlock/security/compiled-in-cves/) lists what Lockdown bounds on each one.
