---
title: "Licensing and Subscription"
weight: 70
description: "Activating subscriptions for Secure Mode."
categories: ["Installation"]
tags: ["heartsuite", "linux", "license", "subscription", "activation"]
toc: true
type: docs
---

**Overview**: A subscription is required to activate Secure Mode (Phase 7). The Dashboard shows your current subscription status alongside phase progress and alerts.

## Subscription

A subscription is required before you can switch from Setup Mode to Secure Mode. Phase 7 (Secure Mode) is locked until phases 2-6 are complete and a valid subscription is activated.

The subscription is a simple text file. One subscription can cover up to 9999 servers -- at the time of purchase, you specify how many servers the subscription covers. You can purchase additional subscriptions if needed.

After downloading the subscription file, copy it to each server it covers. Regardless of the original filename, it must be copied as `HS_license.txt` in the `/.hs/sys` directory. For example:

```bash
# sudo cp MyCompany_HS_subscription_3-10-26.txt /.hs/sys/HS_license.txt
```

After copying the subscription file, activate it using `hs-activate-subscription`. The command requires the IP address of the HeartSuite Core Secure Activation Server and the port number (6121). At the time of this writing, the IP is 172.232.3.4. Check the HeartSuite Core Secure website for current connection details.

```bash
# sudo /.hs/sys/hs-activate-subscription 172.232.3.4 6121
```

If activation is successful, the program creates an activation key and displays a confirmation message. If an error occurs, an error message is displayed. You need to activate each server only once.

## Dashboard Subscription Status

The Dashboard shows subscription status when it requires attention — an expired subscription appears as a warning on the Dashboard with a direct link to the upgrade page. A valid, active subscription is not displayed separately; the absence of a warning confirms that the subscription is in good standing. Phase 7 (Secure Mode) unlocks when phases 2-6 are complete.
