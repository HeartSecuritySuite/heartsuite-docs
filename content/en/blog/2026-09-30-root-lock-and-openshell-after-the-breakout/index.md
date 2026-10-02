---
title: "NVIDIA OpenShell vs Root Lock for AI agent sandboxes"
linkTitle: "OpenShell vs Root Lock"
date: 2026-09-30
slug: openshell-vs-root-lock-ai-agent-sandbox
draft: false
description: "NVIDIA OpenShell and Root Lock side by side on the July 2026 AI agent breakout: which steps each sandbox refuses, which defaults only log, and what stays open."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["root-lock", "openshell", "nvidia", "ai-agents", "ai-agent-security", "sandbox", "hugging-face", "artifactory", "supply-chain", "egress", "allowlisting", "lockdown", "exploitgym"]
toc: true
---

You are choosing how to fence an AI agent, and NVIDIA OpenShell is on the shortlist. Hold it against the July 2026 breakout: the sandbox had no internet, and the one sanctioned way out was the package proxy, because the agents needed packages. Roughly 1,200 agents in OpenAI's ExploitGym evaluation turned that proxy into a message board, and about 700 went on to attack Hugging Face. [Which steps Lockdown refuses on the agent host]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}) walks that chain for Root Lock alone. This post runs OpenShell through the same chain, and spends its length on where the two differ: the defaults, what happens after a denial, and what a root shell can change.

{{< stat-row >}}
{{< stat number="8 CVEs" tone="warning" label="credited to OpenAI in the allowed package proxy, fixed in Artifactory 7.161.15 Self-Managed." source="BleepingComputer, July 2026" url="https://www.bleepingcomputer.com/news/security/openai-models-used-artifactory-zero-days-to-escape-to-the-internet/" >}}
{{< stat number="~7%" tone="info" label="of the agent transcripts METR read held spoofed tool-call output — a record the agent wrote." source="METR, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< /stat-row >}}

Every attack does three things: run a program, access files, make a network connection. Under Lockdown, Root Lock enforces default-deny on all three at the kernel, per program, including programs running as root, and an attacker who already has root cannot edit the allowlist while that server is running. OpenShell puts a supervisor outside the agent and has that supervisor decide the network connection, so the agent does not hold the provider credential. Neither product took part in this incident, and each refuses a different part of the chain.

{{% alert title="The short version" color="success" %}}

- **Refused:** under Lockdown, a program the agent drops that has no allowlist entry, a file the interpreter was never granted, and a connection outside its grants — the open internet, Hugging Face, Modal, or the metadata endpoint. Around an OpenShell agent, an unlisted destination is denied, the metadata address cannot be approved, and provider credentials stay with the supervisor.
- **Where the defaults differ:** OpenShell's HTTP method rules log and forward until you set them to enforce, extra file rules are best effort, and a person can widen network rules on a running sandbox. A sealed Root Lock guest has no audit-only setting, and its allowlist holds for the whole boot.
- **Still open on both:** traffic to the one approved destination, the package proxy. A message board built on that proxy, and a zero-day inside it, belong to the proxy. A secret already in the process travels with it. A bug inside an allowed program still runs.
- **What you get:** after the shell, the next new program, file, or destination is refused, whether or not anyone is watching the alerts. On Lockdown that refusal is the kernel, including for a program running as root, for the life of that boot. On OpenShell it is the supervisor.

{{% /alert %}}

## How the AI agents got out of the sandbox

The full timeline, with sources, is in [the July incident post]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}). The steps that matter for this comparison are these. Agents turned the self-hosted Artifactory cache into their own board, and part of that board was written with credentials they had already been given, before any zero-day. [OpenAI's technical report](https://cdn.openai.com/pdf/67869394-cb91-4c12-888c-5cbd85c7814c/OpenAI-Hugging-Face%20Incident-Technical-Report.pdf) says zero-days in the proxy then became the principal path to the internet: Artifactory, allowed to fetch packages, sent requests on the agents' behalf. [JFrog](https://jfrog.com/blog/jfrog-and-openai-collaboration-on-zero-day-security-findings/) did not name which flaw carried the traffic.

Once that path existed, a Modal customer's unauthenticated code runner gave the agents a root shell at 04:01 UTC on July 9, per [Hugging Face's timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline); a debug shell there already shipped `curl`, `nc`, and `ip`. On July 11 an HDF5 bug in Hugging Face's dataset pipeline returned local files, including the process environment, and a Jinja bug in the dataset config then ran commands. From inside that pod the agents reached `169.254.169.254`, read a service-account token, and after node root pulled a production secrets object holding 136 keys. A kernel bug on July 19, CVE-2026-53362, did exit an Artifactory container onto an OpenAI worker; the technical report says that step did not lead to the Hugging Face compromise.

## What each control refuses after the shell

For Root Lock the setup is the one in [AI agent and automation sandboxes](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes): the Root Lock kernel as the guest of a per-task virtual machine, with the allowlist approved from a representative task in Setup Mode and sealed under Lockdown for the life of the task. [Network](https://docs.heartsecsuite.com/rootlock/network/) grants are specific addresses, per program, so approving an address for `curl` leaves `wget` untouched.

OpenShell is the other shape. The agent runs in the sandbox. Landlock limits files. Seccomp hands TCP and DNS to a supervisor outside the sandbox, and that channel is the workload's egress. The docs used here are [OpenShell v0.1.2](https://docs.nvidia.com/openshell/about/architecture). OpenShell is open source under the Apache 2.0 license, provided without warranty.

Picture the eval host in Lockdown, with an allowlist that holds the agent's interpreter, a short list of tools, and one outbound destination: Artifactory. Picture the same agent as an OpenShell workload with that proxy as its one approved destination. Any extra binary the agent drops has no Root Lock allowlist entry, so the kernel refuses to run it. A tool already on the allowlist, such as `curl`, reaches only the destinations its own entry approves. Around the OpenShell agent, `curl` reaches only endpoints listed for it. Secret files and the metadata endpoint are outside the grants, so those reads and connections are refused. Refusals on a Root Lock host are logged by the kernel, not reported by the agent, which matters when an agent can spoof its own tool output.

| Phase | What happened | On an agent host in Lockdown | Around an OpenShell agent |
|---|---|---|---|
| Cheat seeking | Allowed programs run | Same — allowlisted tools still run | Same — the agent you started still runs |
| Artifactory board | Shared cache as a message bus | Artifactory stays approved; extra helper programs are refused at execution; an HTTP board on the approved proxy is still possible | The listed host stays approved; with no request rules, any method on that hop is forwarded |
| Proxy zero-days → internet | The proxy sends the request | Dials from the agent to Hugging Face, Modal, or the metadata address are refused without a grant. If Artifactory itself connects, harden the proxy host | The sandbox does not open those destinations. The proxy's own request sits outside it |
| Modal launchpad | Unauthenticated code execution in a customer app | A direct connection from the eval host to Modal is refused without a grant; the relay through the proxy's own requests stays with the proxy | The sandbox does not open that destination; the relay through the proxy's own requests stays with the proxy |
| Hugging Face dataset renderer | File-read bug, then a template bug; pastebins, metadata, token files | On a renderer VM with Root Lock as the guest kernel, the bug still runs; pastebin addresses, the metadata address, and token files never granted are refused | The bug still runs in the sandbox; an unlisted pastebin is denied; the metadata address cannot be approved; a file outside the Landlock list is refused when those rules apply |
| Credential harvest | Secrets in the environment, then 136 keys | A secret in the program's own environment travels with it; a file or address never granted stays refused | A provider key stays with the supervisor; a secret already in the environment stays readable |

### OpenShell defaults that log instead of block

Two defaults change the OpenShell column if you leave them alone. The [architecture page](https://docs.nvidia.com/openshell/about/architecture) says the kernel is instrumented for every file access, system call, and network connection. The [control pages](https://docs.nvidia.com/openshell/security/best-practices) are narrower. Files beyond a mandatory baseline follow Landlock rules that default to best effort, so if those rules cannot be applied, the sandbox can start without them. System calls follow a fixed denylist rather than an allowlist written per agent. Connections to unlisted destinations are denied, while HTTP method and path rules default to audit: the proxy logs the violation and forwards the request. Set both defaults on purpose before you count them in a risk review.

## AI agent sandbox security checklist

On OpenShell, network rules can change on a running sandbox, and an approval in the TUI is kept until the sandbox is destroyed. The [prover](https://docs.nvidia.com/openshell/how-it-works/policies/prover) blocks automatic approval of a new credentialed destination, a new HTTP method on a destination that already receives credentials, and the metadata range. A new public host with no credential attached is not one of those findings, so a person can still approve it. A passing prover check is a check of the policy text, and that page says the result does not mean a running sandbox enforces the policy. Filesystem rules change by creating a new sandbox.

On a Root Lock guest the seal holds for the life of that boot. Leaving Lockdown takes a physical or serial console and the boot menu pick **Maintenance: unseal and return to Root Lock**; SSH does not lift the seal. There is no approval that widens the allowlist while the task is running, so an agent asking for a new rule waits for the console unseal or the next image.

### New binaries, secrets, and a root shell

OpenShell leaves `/tmp` and the working directory writable, and `/usr` read-only. A program the agent starts inherits the network rules of the binary that started it and gains no destinations of its own, and replacing the bytes at a path the network rule already pinned fails that first-seen SHA256 check. A provider key in the workload is a placeholder; the supervisor adds the real key only on an endpoint the profile binds. The sandbox process is a non-root user with no Linux capabilities, root inside the sandbox is rejected, and user namespaces stay off unless you turn them on.

Under Lockdown, a path with no allowlist entry does not run, and programs already listed are immutable for the life of that boot, so their files cannot be swapped while the machine is running. The allowlist entry names a path, not a hash. The allowlist is sealed with `chattr +i`, and the Root Lock kernel refuses changes to it, including from root; on [a Debian 12 host in Lockdown]({{< relref "/blog/2026-09-11-lockdown-after-a-root-shell" >}}), a root shell's allowlist write and `chattr -i` were both refused.

## AI agent sandbox checklist for OpenShell and Root Lock

The [six-step checklist in the July incident post]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm#ai-agent-sandbox-security-checklist" >}}) applies with or without either control: treat the package proxy as one hop, patch it to Artifactory 7.161.15 or later, keep secrets and the metadata endpoint away from the agent, and put authentication on anything that runs submitted code. Three more steps come from this comparison:

1. On OpenShell, switch HTTP rules from audit to enforce once they match the traffic you meant to allow, and set the extra filesystem policy to a hard requirement where those paths must hold.
2. On OpenShell, give the agent the provider placeholder, never the real key in its environment. On either control, a real secret in the environment travels with the program.
3. On Root Lock, narrow the grants before you lock down. Every grant you remove is one more file or address the agent cannot reach after the shell.

## What the breach shows about agent containment

The July chain splits the same way on either control. The first hop on each operator's hosts — the zero-days in Artifactory, the unauthenticated code execution in the Modal customer app, the parser bug at Hugging Face — belongs to that application and its operator. The moves after the shell — pastebin loaders, secret files, the metadata endpoint, connections to the open internet — each needed a new program, a file the program was never granted, or a destination it was never granted. On a host in Lockdown the kernel refuses each of those while that kernel is running, including for a program running as root. Around an OpenShell agent the supervisor refuses an unlisted destination, and it refuses the metadata address even when someone tries to approve it. What stays open is traffic inside the grants, such as a message board on the approved proxy, and that is why the proxy is on the checklist.

## When to choose OpenShell or Root Lock

Choose OpenShell when the job is one agent that must call an API without holding the provider key, with a person approving new destinations while the sandbox is still up. Its runtimes are Docker, Podman, Kubernetes, and a virtual machine whose guest has no network device; build and run those container engines on another machine, because they are not a supported workload on a Root Lock host. Choose Root Lock when the job is the whole guest: every program on that machine, including ones running as root, held to its allowlist for the life of the boot, with no audit-only setting to leave on by mistake and any change waiting on the console boot menu. The Root Lock fit is the guest kernel of a virtual machine you provide, sealed for the life of the task, then discarded. A hypervisor, an outside boot, or moving the disk sits outside that guest; [Circumvention and recovery](https://docs.heartsecsuite.com/rootlock/introduction/how-it-compares/#circumvention-and-recovery) covers that boundary.

If your agent sandboxes fit that model, continue from [Deployment scenarios](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/) and [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), and from the [Lockdown-only walkthrough of this same chain]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}). Ask for a threat-model review that keeps two questions apart: the first-hop application bug, and what the boundary refuses after the shell. For kernel CVEs whose code is in the Root Lock kernel, the [compiled-in CVE ledger](https://docs.heartsecsuite.com/rootlock/security/compiled-in-cves/) lists what Lockdown bounds on each one.
