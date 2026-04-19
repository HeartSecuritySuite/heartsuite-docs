---
title: "Setup Overview"
linkTitle: "Setup Overview"
weight: 2
description: "Overview of HeartSuite Core Secure setup process and modes."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "setup", "modes", "secure", "allowlist", "overview"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "setup-overview"
---

**Overview**: HeartSuite Core Secure must complete a guided setup journey in Setup Mode before it can enforce security in Secure Mode.

## Why Setup Mode Is Necessary

HeartSuite Core Secure enforces a default-deny policy: every program must be explicitly approved to execute, to access files, and to make network connections — including programs running as root. Immediately after installation, the allowlist is empty. If the system entered Secure Mode at this point, it would block the programs required for boot and shutdown, rendering the system inoperable.

Setup Mode solves this problem. In Setup Mode, HeartSuite Core Secure logs all activity without blocking anything. You review activity through the Dashboard queues, approve programs and their access, and build an allowlist that reflects the system's actual workload. Once the allowlist is complete, you transition to Secure Mode.

Setup Mode is the default after installation. HeartSuite Core Secure's automated backup system also operates during Setup Mode, providing an additional layer of protection even before enforcement begins.

## The 7 Phases

HeartSuite Core Secure organizes the setup journey into seven phases. The Dashboard tracks progress through each phase and always displays a Suggested Next Step.

| Phase | Name | Description |
|-------|------|-------------|
| 1 | System Verification | Confirms the HeartSuite Core Secure kernel is active and the system is in Setup Mode. Auto-completes on Cloud instances. |
| 2 | Program Allowlisting | Review and approve programs detected during observation from the Dashboard's Programs queue (`[p]`). |
| 3 | Script Launchers | Configure Secure Script Launchers for interpreted scripts from the Dashboard's Launchers screen (`[l]`), if applicable. |
| 4 | File Access Allowlisting | Review and approve file reads and writes from the Dashboard's File Access queue (`[f]`). |
| 5 | Internet Access Allowlisting | Review and approve internet connections from the Dashboard's Internet Access queue (`[i]`). |
| 6 | Alert Configuration | Configure at least one push channel (email, syslog, or webhook) from the Dashboard's Alert Settings screen (`[e]`). |
| 7 | Secure Mode | Locked until phases 2 through 6 are complete. Activate via the Dashboard's Mode Switch screen (`[m]`). |

## Cloud vs. Local Path

### Cloud Path

Users who launch a pre-installed HeartSuite Core Secure cloud instance (AWS AMI, GCP image) boot directly into Setup Mode. The Dashboard confirms Phase 1 is complete. The Dashboard appears on first login with the current system state and a Suggested Next Step. No manual verification is required.

### Local Path

Users who install HeartSuite Core Secure on bare-metal or custom VMs follow a longer path:

1. Download and extract the installation package.
2. Prepare GRUB and install the HeartSuite Core Secure kernel.
3. Follow the System Setup screen — press `[a]` for each step; the system reboots after each one.
4. After Phase 1 is complete, the Dashboard appears and the journey merges with the Cloud path.

Both paths converge at the Dashboard after Phase 1. From that point forward, the workflow is identical.

## From Installation to Secure Mode

The following diagram shows the path from installation to Secure Mode, including the maintenance cycle.

```mermaid
graph TD
    A[Install HeartSuite Core Secure] --> B{Cloud or Local?}
    B -- Cloud --> C[Boot instance — Dashboard confirms Phase 1 complete]
    B -- Local --> D["System Setup screen — press [a] each step"]
    D --> C
    C --> E[Dashboard appears — Suggested Next Step]
    E --> F["Phase 2: Programs queue — approve programs"]
    F --> G["Phase 3: Script Launchers — if applicable"]
    G --> H["Phase 4: File Access queue — approve file access"]
    H --> I["Phase 5: Internet Access queue — approve connections"]
    I --> J["Phase 6: Configure alerts"]
    J --> K["Phase 7: Activate Secure Mode"]
    K --> L["Lockdown: [r] Reboot or [l] Reboot + Lockdown"]
    L --> M{Maintenance needed?}
    M -- Yes --> N["Maintenance screen guides through steps"]
    N --> K
    M -- No --> O[System secured]
```

## Switching to Secure Mode

> [!WARNING]
>
> Complete all allowlisting phases in Setup Mode before switching to Secure Mode. If boot and shutdown programs have not been approved, the system will fail to start or shut down correctly.

When phases 2 through 6 are complete, the Dashboard unlocks Phase 7. The Suggested Next Step will prompt you to activate Secure Mode. Activating Secure Mode requires typing `YES` (case-sensitive) to confirm and displays an allowlist summary and pre-condition checklist before proceeding.

After activating Secure Mode, the Dashboard offers two reboot options: `[r]` Reboot (enforcement active, configuration remains editable) or `[l]` Reboot + Lockdown (enforcement active, configuration sealed with filesystem immutability). Both are valid configurations depending on your security requirements. Lockdown can also be applied later from the Dashboard's Mode Switch screen (`[m]`).

## Maintenance in Secure Mode

To perform system maintenance after entering Secure Mode, select the Maintenance screen (`[t]`) from the Dashboard. The Dashboard detects whether Lockdown is active and guides you through the correct path:

- **Without Lockdown**: The Maintenance screen walks you through a safety checklist, switches to Setup Mode, and reboots. The HeartSuite Core Secure kernel stays active with logging and backups running. Make your changes, then return to Secure Mode from the Dashboard.
- **With Lockdown**: The Maintenance screen guides you through a 3-step process across two reboots — removing immutable flags on the Non-HS kernel, making changes, then returning to the HeartSuite Core Secure kernel to review new activity. The Dashboard resumes at the correct step after each reboot.

For full details, see [Protecting During Maintenance](../../maintenance/protecting-during-maintenance/).
