---
title: "Licensing and Subscription"
weight: 85
description: "Activating subscriptions for Lockdown."
categories: ["Installation"]
tags: ["heartsuite", "linux", "license", "subscription", "activation"]
toc: true
type: docs
author: Ron Hessing
---

**Overview**: A subscription is required to activate Lockdown (Phase 7). The Dashboard shows your current subscription status alongside phase progress and alerts.

## Subscription

A subscription is required before you can activate Lockdown. Phase 7 (Lockdown) is locked until phases 2-6 are complete and a valid subscription is activated.

The subscription is a simple text file. One subscription can cover up to 9999 servers — at the time of purchase, you specify how many servers the subscription covers. You can purchase additional subscriptions if needed.

After downloading the subscription file, copy it to each server it covers. Regardless of the original filename, it must be copied as `HS_license.txt` in the `/.hs/sys` directory. For example:

```bash
# sudo cp MyCompany_HS_license.txt /.hs/sys/HS_license.txt
```

After copying the subscription file, register it using `register_HS_license`. The command requires the IP address of the Root Lock by HeartSuite Activation Server and the port number (6121). Run the following command, replacing `<ip>` with the address from your activation email:

```bash
# sudo /.hs/sys/register_HS_license <ip> 6121
```

If activation is successful, the program creates an activation key and displays a confirmation message. If an error occurs, an error message is displayed. You need to activate each server only once.

## Dashboard subscription status

The Dashboard shows subscription status when it requires attention — an expired subscription appears as a warning on the Dashboard with a direct link to the upgrade page. A valid, active subscription is not displayed separately; the absence of a warning confirms that the subscription is in good standing. Phase 7 (Lockdown) unlocks when phases 2-6 are complete.

With your subscription active and phases 2-6 complete, proceed to [Mode Switching and Lockdown](../mode-switching/) to activate Lockdown.

## HS kernel source code (GPL)

The HS kernel ships as binaries in your coordinated install bundle. Corresponding kernel source is available on written GPL request — not via a public repository. Email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) with `uname -r`, your HeartSuite product version, and bundle checksum reference if known. Full process and verification alternatives: [Supply Chain and Advisory Feeds → HS kernel source code (GPL)](../kernel-hardening/supply-chain-and-advisories/#hs-kernel-source-code-gpl).

For procurement and CISO details on how the subscription covers the kernel (risk transfer, SLAs, verification artifacts) in the context of enterprise adoption, see [Kernel Hardening → Enterprise Adoption Guide](../kernel-hardening/enterprise-adoption-guide/).
