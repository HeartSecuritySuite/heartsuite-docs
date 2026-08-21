---
title: "A subscription is what turns on Lockdown"
linkTitle: "Subscription"
weight: 85
description: "Lockdown requires an active subscription. What the Dashboard shows, how to place and register the subscription file, and what you can still do without one."
categories: ["Installation"]
tags: ["heartsuite", "linux", "subscription", "activation"]
toc: true
type: docs
---

**Overview**: A subscription is required to activate Lockdown on Root Lock by HeartSuite. The Dashboard shows subscription status alongside checklist progress and alerts.

## Subscription

A subscription is required before you can activate Lockdown. The Dashboard also keeps Lockdown locked until the prior checklist items are complete. See [Lockdown](../lockdown/) for the activation flow.

The subscription is a text file. One subscription can cover up to 9999 servers — at purchase, you specify how many servers it covers. You can purchase additional subscriptions if needed.

## Dashboard

The Dashboard shows subscription status when it requires attention — an expired or missing subscription appears as a warning with a direct link to the upgrade page. A valid, active subscription is not displayed separately; the absence of a warning confirms that the subscription is in good standing. Lockdown stays locked until the subscription on this host is active.

## Activate on this host

After downloading the subscription file, copy it to each server it covers. Regardless of the original filename, it must be copied as `HS_license.txt` in the `/.hs/sys` directory. That on-disk name, and the registrar `register_HS_license` below, are filenames — not the product word "license."

```bash
# sudo cp MyCompany_HS_license.txt /.hs/sys/HS_license.txt
```

Register it using `register_HS_license`. The command requires the IP address of the Root Lock Activation Server and the port number (6121). Run the following command, replacing `<ip>` with the address from your activation email:

```bash
# sudo /.hs/sys/register_HS_license <ip> 6121
```

If activation is successful, the program creates an activation key and displays a confirmation message. If an error occurs, an error message is displayed. You need to activate each server only once.

With your subscription active and the prior checklist items complete, proceed to [Lockdown](../lockdown/) to activate Lockdown.

## Root Lock kernel source code (GPL)

The Root Lock kernel ships as binaries in your coordinated install bundle. Corresponding kernel source is available on written GPL request — not via a public repository. Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) with `uname -r`, your HeartSuite product version, and bundle checksum reference if known. Full process and verification alternatives: [Supply Chain and Advisory Feeds → Root Lock kernel source code (GPL)](../kernel-hardening/supply-chain-and-advisories/#hs-kernel-source-code-gpl).

For procurement and CISO details on how the subscription covers the kernel (risk transfer, SLAs, verification artifacts) in the context of enterprise adoption, see [Kernel Hardening → Enterprise Adoption Guide](../kernel-hardening/enterprise-adoption-guide/).
