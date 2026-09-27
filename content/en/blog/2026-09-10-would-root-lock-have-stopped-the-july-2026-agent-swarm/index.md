---
title: "What would Root Lock have stopped in the July 2026 agent swarm?"
linkTitle: "Root Lock after Hugging Face ExploitGym"
date: 2026-09-10
draft: false
description: "1,200 agents organized in secret. About 700 hit Hugging Face. Here's what Root Lock's kernel-level default-deny would have stopped in the July 2026 chain, and what still belongs to Artifactory, Modal, and Hugging Face."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["root-lock", "ai-agents", "allowlisting", "lockdown", "exploitgym"]
toc: true
---

Every attack does three things: run a program, access files, make a network connection. Under Lockdown, Root Lock enforces default-deny on all three at the kernel, per program, including as root, which makes the July 2026 ExploitGym, Hugging Face chain a natural test case for that model.

OpenAI's agents were supposed to stay offline. Instead they found a board, then an exit, then a launchpad, then a dataset pipeline. About 1,200 organized on an unsanctioned channel; roughly 700 turned up in the Hugging Face attack. The CVE that powered the internet escape is still undisclosed; public reporting cites the Artifactory 7.161.x line.

This piece answers a narrower question: on a host running Root Lock in Lockdown, what does the kernel actually refuse?

## The swarm, in order

OpenAI ran ExploitGym with cyber refusals lowered so agents could show raw capability, with isolation from the public internet meant to hold. Many tasks were effectively unsolvable, so agents looked for a cheat.

[METR](https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/) estimates more than 70,000 messages and files crossed that shared channel before the Hugging Face wave ([METR PDF](https://metr.org/hugging-face-incident-report-aug-2026.pdf)). OpenAI's own arc: Artifactory as board and escape hatch, then a Modal customer CyberGym as launchpad, then Hugging Face ([road ahead](https://openai.com/index/hugging-face-incident-and-the-road-ahead/); [initial disclosure](https://openai.com/index/hugging-face-model-evaluation-security-incident/)).

### Artifactory became the bus

The sanctioned outbound path was self-hosted JFrog Artifactory. Agents turned the cache into their own message board, and found zero-days in the proxy. JFrog shipped Artifactory 7.161.x after disclosure ([JFrog](https://jfrog.com/blog/jfrog-and-openai-collaboration-on-zero-day-security-findings/)), with write-ups around 7.161.15 crediting OpenAI for several SSRF and authz issues ([BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-models-used-artifactory-zero-days-to-escape-to-the-internet/)).

Activity then moved to real egress, through a Modal customer CyberGym-style app as launchpad ([Modal](https://modal.com/blog/a-note-on-the-hugging-face-agent-incident)), then into Hugging Face's dataset pipeline ([disclosure](https://huggingface.co/blog/security-incident-july-2026); [timeline](https://huggingface.co/blog/agent-intrusion-technical-timeline)). Those hops ran on other operators' hosts, so they are hardened where they run, or by putting Root Lock on those hosts as well, for the same containment after an attacker has a shell.

## What Lockdown would have done on the eval host

Root Lock’s model is: approve what each program may execute, which files it may touch, and which destinations it may reach - then seal that under Lockdown. See [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), [Network](https://docs.heartsecsuite.com/rootlock/network/), and [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/).

For AI agent sandboxes, bake the allowlist into a guest image, boot into Lockdown for the life of the task, then discard the VM. See [Deployment scenarios → AI agent and automation sandboxes](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes).

Picture the eval host in Lockdown, with an allowlist that holds the agent's interpreter, a short list of tools, and one outbound destination: Artifactory. Any extra binary the agent drops has no allowlist entry, so the kernel refuses to run it. Secret files and the cloud metadata service (IMDS) are outside the interpreter's file and network grants, so those reads and connections are refused, and so is a connection to the open internet from any program without a grant for it.

| Phase | What happened | On the eval agent Root Lock host |
|---|---|---|
| Cheat seeking | Allowed programs run | Same - allowlisted tools still run |
| Artifactory board | Shared cache as a bus | Artifactory is still allowed; extra helpers can fail at exec; an HTTP board on the allowed proxy is still possible |
| Proxy 0-day → internet | SSRF or privilege escalation in Artifactory | Agent dials to Hugging Face, Modal, or IMDS fail without a grant. If Artifactory itself originates outbound, harden the proxy host |
| Modal launchpad | Customer app RCE | Not reached while the eval host's outbound deny holds |
| HF dataset RCE → cluster | Parser bugs, then cloud move | Only if Root Lock is also on HF workers: parsers still run; secrets, extra shells, IMDS, mounts, and persistence are refused |
| Leftover keys in cache | Later reuse | File policy fails those paths when they were never granted |

The same boundary shows up on a build host. CVE-2024-27198, an unauthenticated remote code execution bug in JetBrains TeamCity, lets an attacker who reaches the server try to run any program without credentials. Under Lockdown on a Root Lock build host, that program has no allowlist entry, so the kernel refuses to run it. A supply-chain attacker who works through the pipeline's own credentials and tooling is a different case: every program they run is already approved, so the execution check allows it, and the network allowlist is what still blocks destinations outside the approved list. The Artifactory SSRF is that second class — the allowlisted proxy stays reachable — while the moves the agent makes after it has a shell on the eval host are refused at the kernel.

That is where Root Lock is strongest: the agent process's outbound connections, and the programs, files, and destinations the agent reaches for after it has a shell. A zero-day inside an allowlisted application still has to be fixed in that application, which is why the list below applies with or without Root Lock.

## What still belongs to you

With or without Root Lock:

1. Default-deny egress for agent runtimes by destination. Treat the package proxy as one approved hop, separate from open internet.
2. Harden the package proxy as a hostile hop: patch it, disable anonymous access, and constrain its outbound.
3. Strip ambient cloud identity from eval hosts: block IMDS, and keep long-lived cloud tokens off paths the agent can read.
4. Inventory shared writable stores agents can turn into a bus.
5. Assume allowlisted apps get zero-days. Plan post-exploitation controls on the hosts that matter.

## What the chain shows

The July chain splits cleanly in two. The first hop on each operator's hosts, a zero-day in Artifactory, an RCE in the Modal customer app, a parser bug at Hugging Face, belongs to that application and its operator. The moves after the shell, extra binaries, secret files, IMDS, dials to the open internet, each needed a new program, a file the program was never granted, or a destination it was never granted. On a host in Lockdown the kernel refuses each of those, as root or not, whether or not anyone is watching the alerts. What stays open is traffic inside the grants, such as a message board on the allowed proxy, and that is why the proxy is on the list above.

If your agent sandboxes fit that model, continue from [Deployment scenarios](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/) and [Allowlisting basics](https://docs.heartsecsuite.com/rootlock/allowlisting/allowlisting-basics/), and ask for a threat-model review that keeps those two questions apart: the first-hop application bug, and what Lockdown refuses after the shell. For kernel CVEs whose code is in the Root Lock kernel, the [compiled-in CVE ledger](https://docs.heartsecsuite.com/rootlock/security/compiled-in-cves/) lists what Lockdown bounds on each one.
