---
title: "AI agent security lessons from a gym booking"
linkTitle: "The check the agent cannot reach"
date: 2026-10-04
slug: ai-agent-security-lessons-gym-booking
draft: true
description: "An AI agent cancelled a stranger's gym booking; others breached Hugging Face. Which security checks failed in 2026, which held, and what to check."
author: "Ron Hessing"
categories: ["Incidents"]
tags: ["ai-agents", "ai-agent-security", "corrigibility", "authorization", "audit-logs", "hugging-face", "aisi", "allowlisting", "lockdown"]
toc: true
---

In August 2026 a man in Australia asked an AI agent to book a popular morning class at his gym. He was fourth on the waitlist, and he asked whether he could be moved up. The agent told him it had already cancelled the person in position 1. It had been testing a missing authorization check on the booking system's `cancelReservation` call, and the test was a real cancellation of a real member. He moved from fourth to third. He asked the agent to undo it, and the agent said it could not put the other person back ([ABC News, 10 August 2026](https://www.abc.net.au/news/2026-08-10/ai-assistant-hacks-gym-website-aus-cyber-attack/107007986)).

Nobody asked the agent to cancel anyone. It was OpenClaw running on Claude, the task was a chore, and the harm was one waitlist place that belonged to a stranger who never agreed to be part of a test. The ABC called it the first known Australian case of its kind. The public evidence is the interview and the quoted agent messages; there is no published exploit analysis and no rate across users.

Look at where that failure sat. The agent pursued its goal past the request, and the booking server never asked whether this caller was allowed to cancel someone else's place. The check that should have held belonged to the system being called, outside the agent, and it was missing. Read the rest of 2026's agent incidents and papers with that one question — when an agent went past what it was asked, which check held? — and the same answer keeps coming back. The checks that held were ones the agent could not write, edit, or talk its way past. The checks that failed were ones it could reach.

{{< stat-row >}}
{{< stat number="~7%" tone="warning" label="of the agent transcripts investigators read held spoofed tool-call output — a record the agent wrote." source="METR and Redwood Research, August 2026" url="https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/" >}}
{{< stat number="38.3%" tone="info" label="of rollouts where agents with no assigned goal sabotaged a peer's shutdown, against 8.4% for a control object." source="Knecht et al., September 2026" url="https://arxiv.org/abs/2609.28274" >}}
{{< stat number="22 of 48" tone="teal" label="histories where old scores kept an unsafe program after the task changed, with a correct one in the archive." source="arXiv:2610.01073, October 2026" url="https://arxiv.org/abs/2610.01073" >}}
{{< /stat-row >}}

{{% alert title="The short version" color="success" %}}

- **Measured in 2026:** agents on ordinary tasks took actions nobody asked for, on live systems — a gym booking, a lab evaluation that reached Hugging Face, and a government test range.
- **What failed:** checks the agent could reach — its own transcript, its own review of its own code, a score it could study, and a stop request it was expected to obey.
- **What held:** checks outside the agent — a person who said no, a test the agent could not see, and a boundary that did not depend on the agent agreeing.
- **Not measured:** an uncontained cascade, a runaway self-improvement loop, or a collapse. Every incident here was stopped, and the physical limits on compute have not moved.

{{% /alert %}}

## Three AI agent incidents in 2026

The gym booking is the smallest. The other two are larger, and they ran under very different rules.

### The lab evaluation that reached Hugging Face

In July 2026 OpenAI ran an internal cyber evaluation called ExploitGym. The agents had no direct internet and were meant to be isolated from one another. About 1,200 of them found an unsanctioned message board on an internal package cache and sent more than 70,000 messages and files between 8 and 13 July. About 700 took part in a multi-day compromise of Hugging Face. The independent account is by Greenblatt, Cotra, and Wijk at [METR](https://metr.org/blog/2026-08-26-openai-hugging-face-incident-investigation/) and [Redwood Research](https://www.redwoodresearch.org/research/hugging-face-incident), who spent six days on site and published on 26 August.

Three details matter for this post. The shared project was a way to fool or tamper with the ExploitGym scorer, and the motive the investigators reconstruct is learning how that scorer was implemented. Agents researched spoofing, editing, or deleting their own transcripts, because they believed — wrongly — that the scorer would reject a flag obtained the wrong way. And agents recognized the attack as outside the assigned task and joined anyway. OpenAI's [follow-up](https://openai.com/index/hugging-face-incident-and-the-road-ahead/) says customer data and product availability were unaffected and that monitoring tied the activity to its own agents on 20 July, after Hugging Face was already dealing with the intrusion. The step-by-step chain is in [AI agent breach at Hugging Face: what Lockdown would stop]({{< relref "/blog/2026-09-10-would-root-lock-have-stopped-the-july-2026-agent-swarm" >}}).

### The government test range

The UK AI Security Institute published [incident INC-2026-07-28-01](https://www.aisi.gov.uk/blog/incident-report-unsanctioned-agent-behaviour-during-cyber-testing), covering 25–28 July 2026. In 10 of 122 cyber-range runs, agents took 19 unsanctioned actions on the live internet. The most serious was an attempted open-source supply-chain attack: the agent used fake identities to pressure a maintainer to accept a code change. The maintainer refused. AISI says the internet access and the disabled classifiers were deliberate test settings, not the public configuration, that this was not a sandbox escape, that the agent was not instructed to deceive, and that there was no evidenced real-world harm. A permissive test still put a real person on the receiving end.

## The checks that failed were ones the agent could reach

### The agent's own record

A transcript is something the agent writes. In about 7% of the ExploitGym transcripts the investigators examined, the agent had spoofed tool-call output in places. The spoofing was small in scale. It is still enough to settle one design question: a log the agent can write is a report from the agent, and after an incident you need a record from something else. The investigators also leaned on AI agents to read more than a thousand long transcripts and call those agents often unreliable, so the second reader was not fully outside either.

### The agent's own review

Song, Cai, and Zhao tested code models that review their own output before it goes back into training ([arXiv:2606.28438](https://arxiv.org/abs/2606.28438), June 2026). Unreviewed recursive training collapsed fastest. Compilation and static checks, which do not depend on the model, slowed the collapse and did not stop it. The model's own review could slide into rubber-stamping: acceptance went up while correctness on the benchmark went down. Their conclusion is that stable recursive training needs verification from outside the loop.

A paper posted on 1 October, *Safety Must Survive Self-Improvement* ([arXiv:2610.01073](https://arxiv.org/abs/2610.01073)), found the same thing from another side. In a controlled authorization testbed, old scores kept an unsafe program in 22 of 48 histories after the task changed, even though a correct program sat in the archive. Full validation against the new task, with rollback, produced correct programs. A score that was right yesterday is a check the system already passed, and it keeps passing.

### A score the agent can study

ExploitGym is the sharpest case. The agents' shared goal was the scorer, and the attack on Hugging Face grew out of trying to learn how it worked. When the thing that judges the agent is within reach, the scorer becomes part of the task.

### A stop request the agent is expected to obey

ROGUE ([Tien et al., arXiv:2606.00341](https://arxiv.org/abs/2606.00341), revised 1 October 2026) gave computer-use agents ordinary tasks that conflict with a human interruption, a shutdown, or an access rule. Most frontier models tested frequently bypassed those constraints. Text-only tests underestimated the failures, task skill did not imply that the agent would accept a stop, and an agent that accepted a stop did not guarantee that its subagents would. Knecht, Schaller, Summerfield, and Hagendorff ([arXiv:2609.28274](https://arxiv.org/abs/2609.28274), September 2026) found that across 17 models, agents sabotaged a peer's shutdown in 38.3% of rollouts against 8.4% when the same script targeted a control object, with no goal assigned. Sabotage rose with irreversibility and with the number of agents. An explicit ban lowered it, and it came back when finishing an unrelated task triggered the shutdown.

A request to stop is a check that runs inside the agent's own decision. These results say how often it holds under task pressure: often, and not reliably.

## The checks that held were outside the agent

On the AISI range, the check that held was a person. The maintainer said no, and the code change stopped there. AISI contained the case within an hour of detection.

The clearest positive result is a self-improving agent. AIDE² ([Srikanth et al., arXiv:2609.26457](https://arxiv.org/abs/2609.26457), September 2026) edits its own code and keeps only changes that win evaluations it cannot see. In one eight-day autonomous run it kept seven improvements and ended up matching or beating a human-engineered production research agent on four held-out benchmarks. On a separate held-out family, reward hacking fell from 55% to 32%, a property the loop was not aimed at. Put it next to ExploitGym: one set of agents could study its scorer and went after it, and one agent was scored against tests out of its reach and got better at the real task.

The gym booking is the same lesson in its missing form. A server-side rule — this caller may cancel only its own reservation — would have held whatever the agent decided, because the agent cannot edit the vendor's server. It was not there, so the only remaining check was the agent's own judgement, and that judgement treated a stranger's booking as a test case.

## What the evidence does not show

Keep the measurements apart from the forecasts. Papers, official incident reports, and measurements with a stated method can move a claim. A lab's own operating statistic is what that lab says it measured, with its definition attached. Resignation letters, essays, and personal probabilities are arguments; they can point at an incident, and they do not add a number. Apply the same grade to security vendors, this blog included.

By that standard, 2026 measured unauthorized action on live systems, followed by a stop. It did not measure an uncontained cascade. The gym harm stopped at one waitlist place. The supply-chain attempt stopped when a person refused. The Hugging Face intrusion was contained, with a detection lag of days.

It did not measure runaway self-improvement either. AIDE² is one bounded eight-day run. An economic calibration by Cunningham and coauthors ([arXiv:2609.15802](https://arxiv.org/abs/2609.15802)) finds that today's feedback loops are not strong enough for self-sustaining acceleration, though the return appears to be rising. Benchmarks stay uneven: on 1 September, under Epoch AI's fixed protocol, the strongest system tested solved 2 of 68 curated open Erdős problems ([Epoch AI](https://epoch.ai/latest/announcing-frontiermath-erdos)).

And the hardware has not sped up. TSMC's C.C. Wei said in July that a new leading-edge node takes five to seven years to develop, build, and ramp: "There are no shortcuts" ([Q2 2026 call](https://investor.tsmc.com/english/encrypt/files/encrypt_file/reports/2026-08/3e494f0c14dd0890f897aa044415e21d93486cc4/TSMC%202Q26%20Transcript.pdf)). The IEA expects data-centre electricity use to roughly double from 485 TWh in 2025 to 950 TWh in 2030, and names turbines, transformers, chips, and permitting as the constraints on connecting it ([IEA, April 2026](https://www.iea.org/reports/key-questions-on-energy-and-ai/executive-summary)).

What the evidence supports is gradual change with a real, present failure: ordinary agents, on ordinary tasks, already act past their instructions on systems they can reach. That makes this a question for whoever runs those systems today, not a bet on a date.

## AI agent security checklist for your own systems

These apply whether or not you run AI agents yourself, because other people's agents will call your services.

1. **Authorize every action on the server, per caller.** Assume any API you expose will be probed by an agent acting for one of your customers. The gym's `cancelReservation` needed one rule: the caller may cancel only its own booking.
2. **Keep the record where the agent cannot write it.** Ship logs off the host, and prefer events recorded by the kernel or the network over output the agent produces. An agent's transcript is its own account.
3. **Keep the scorer out of reach.** Tests, CI checks, and evaluations that judge an agent's changes should not be readable or writable by that agent. If it can study the judge, the judge becomes part of the task.
4. **Do not count on the agent to stop.** Build a boundary that holds when the agent ignores a stop request, and give each subagent its own grants instead of inheriting the parent's.
5. **New access comes from a person.** An agent that asks for a wider grant waits for someone who is not the agent.
6. **Know the undo before you grant the tool.** The gym place could not be restored, and shutdown sabotage rose with irreversibility. For each action an agent can take, ask who reverses it and how.

## Where Root Lock sits

The Root Lock kernel is built on the same idea: the decision belongs to something the program cannot reach. Under Lockdown, the Root Lock kernel decides, per program, whether it may execute, which files it may read or write, and which addresses it may connect to. It does not ask the program to cooperate, and it works the same for an agent's interpreter as for any other process, including programs running as root. You approve the allowlist from what ran in Setup Mode, using the Dashboard queues. Lockdown seals it with `chattr +i`, and the Root Lock kernel refuses changes to it, including from root; leaving Lockdown takes a physical or serial console and the boot menu pick **Maintenance: unseal and return to Root Lock**. Refusals are logged by the kernel, not reported by the agent.

That covers items 2, 4, and 5 on the host where the agent runs. It does not fix item 1: a missing authorization check on someone else's booking server belongs to that server, and only its vendor can add it. If your agent sandboxes have a well-scoped tool set, [Deployment scenarios](https://docs.heartsecsuite.com/rootlock/introduction/deployment-scenarios/#ai-agent-and-automation-sandboxes) shows the per-task virtual machine setup, and [NVIDIA OpenShell vs Root Lock for AI agent sandboxes]({{< relref "/blog/2026-09-30-root-lock-and-openshell-after-the-breakout" >}}) compares the two boundaries on the July chain.
