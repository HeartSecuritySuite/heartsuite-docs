---
title: "From install to Lockdown"
linkTitle: "The Setup Journey"
weight: 2
description: "Initial setup runs unattended. Then the Dashboard walks you from program allowlisting to Lockdown."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "setup", "modes", "secure", "allowlist", "overview"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "setup-overview"
---

**Overview**: Immediately after install the allowlist is empty. Root Lock by HeartSuite logs in Setup Mode so you can review and approve programs, file access, and network connections — including as root — before Lockdown blocks everything else.

## Why Setup Mode is necessary

If Lockdown engaged with an empty allowlist, boot and shutdown programs would be blocked.

In Setup Mode, Root Lock logs activity without blocking it. You review that activity through the Dashboard queues, approve programs and their access, and build an allowlist that matches the workload. Then you activate Lockdown.

Setup Mode is the default after installation. Automated backup also runs in Setup Mode, so you can restore protected directories before Lockdown is active.

## Initial setup, then the Dashboard checklist

Initial setup runs unattended after you boot the Root Lock kernel. It reads startup and shutdown activity, adds those programs to the allowlist, and reboots as needed.

Cloud images already finished this at image-prep time. The Dashboard appears when that chain is complete.

| Checklist | Description |
|-----------|-------------|
| Program Allowlisting | Review and approve programs from the Dashboard's Programs queue (`[p]`). |
| Script Launchers | Configure Secure Script Launchers from Launchers (`[s]`), if applicable. |
| File Access Allowlisting | Review and approve file reads and writes from the File Access queue (`[f]`). |
| Internet Access Allowlisting | Review and approve internet connections from the Internet Access queue (`[i]`). |
| Alert Settings | Configure at least one push channel (email, syslog, or webhook) from Alert Settings (`[e]`). |
| Lockdown | Locked until the earlier checklist items are complete. Activate from Lockdown (`[l]`). Review the checklist, then type `YES` (case-sensitive). |

## Cloud Path and Local Path

{{< choice-pane >}}
{{< choice-card header="Cloud Path" >}}
Pre-installed on AWS, Google Cloud, Azure, DigitalOcean, Linode, and other providers. The Dashboard appears on first login.
{{< /choice-card >}}
{{< choice-card header="Local Path" >}}
Download from heartsecsuite.com, install, and boot the Root Lock kernel. Initial setup runs unattended. Once the Dashboard appears, both paths merge.
{{< /choice-card >}}
{{< /choice-pane >}}

[Getting Started](../../getting-started/) covers both paths.

![Dashboard after setup: Program Allowlisting active, 3 programs pending review](test_docs_dashboard_phase1_complete.svg)

## From installation to Lockdown

The following diagram shows the path from installation to Lockdown, including the maintenance cycle.

```mermaid
graph TD
    A[Install Root Lock] --> B{Cloud or Local?}
    B -- Cloud --> C[Boot instance — Dashboard confirms setup complete]
    B -- Local --> D["Boot setup runs automatically — reboots between passes"]
    D --> C
    C --> E[Dashboard appears — Suggested Next Step]
    E --> F["Programs queue — approve programs"]
    F --> G["Script Launchers — if applicable"]
    G --> H["File Access queue — approve file access"]
    H --> I["Internet Access queue — approve connections"]
    I --> J["Configure alerts"]
    J --> K["Activate Lockdown"]
    K --> L["[r] Reboot — Lockdown active on next boot"]
    L --> M{Maintenance needed?}
    M -- Yes --> N["Maintenance guides through steps"]
    N --> K
    M -- No --> O[System secured]
```

## Activating Lockdown

> [!WARNING]
>
> Complete all allowlisting in Setup Mode before activating Lockdown. If boot and shutdown programs have not been approved, the host will fail to start or shut down correctly.

Activating Lockdown shows an allowlist summary and a precondition checklist. Type `YES` (case-sensitive) to confirm. See [Mode Switching and Lockdown](../../mode-switching/) for the activation flow.

After activating Lockdown, the Dashboard offers `[r]` Reboot — Lockdown active on next boot. Lockdown is engaged automatically on every Root Lock kernel boot.

## Maintenance in Lockdown

To change a sealed allowlist, open Maintenance (`[m]`) from the Dashboard. `[m]` is the unseal path: remove immutable flags on the maintenance kernel, make changes, then return to the Root Lock kernel and review new activity.

For the full 3-step process, see [Protecting During Maintenance](../../maintenance/protecting-during-maintenance/).
