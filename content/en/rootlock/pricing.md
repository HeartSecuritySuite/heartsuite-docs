---
title: "Subscription pricing"
linkTitle: "Pricing"
weight: 86
draft: False
description: "Personal and non-production use is free. Production use requires a paid subscription. Indicative rates for small deployments; fleets are quoted."
author: "Heart Security Suite (draft — pending review)"
categories: ["Installation"]
tags: ["heartsuite", "subscription", "pricing", "lockdown"]
toc: true
type: docs
---

**Overview**: Root Lock by HeartSuite is free for personal and non-production use. Company production hosts need a paid subscription. Lockdown on a host requires an active subscription on that host.

## Personal and non-production

Under the public terms, personal and non-production use is free. Typical cases: a home lab, a learning environment, or a personal VPS used for study and evaluation.

## Production use

Company production hosts need a paid commercial subscription. That includes work servers, customer-facing systems, and fleets. Support terms follow the subscription agreement.

## rates

Billing unit: one **sealed host** (physical server or VM) with Lockdown in use.

| Subscription | Intended use | Monthly (indicative) | Annual (indicative, 10% prepaid discount) |
|--------------|--------------|----------------------|-------------------------------------------|
| Lab / Setup | Personal or non-production | $0 | $0 |
| Lockdown | Company production, typically 1–5 hosts | $25 per sealed host | $270 per sealed host |
| Lockdown with onboarding | Same scope, with onboarding assistance | $45 per sealed host | $486 per sealed host |
| Fleet or regulated | Six or more hosts, or custom packaging | Quoted | Quoted |

Quoted deployments use the Lockdown host rate as the floor. The agreement can set a different floor.

These figures are a starting point for commercial discussion. Final amounts, host counts, and support packaging and discounts are confirmed in the subscription agreement.

## Subscription and Lockdown

After purchase, place and register the subscription file on each covered host. See [Subscription](../licensing/) for Dashboard status, file placement (`HS_license.txt`), and `register_HS_license`.

Lockdown requires the standard checklist: empty review queues, configured alerts, the settling period, and an active subscription on that host. See [Lockdown](../lockdown/).

## Data-integrity warranty

Indicative host rates above are subscription only. Data-integrity warranty is available on quote: a host-integrity stamp that applies only while Lockdown is on for that host, under the commercial agreement, separate from the subscription line.

Request warranty on the quote via [support@heartsecsuite.com](mailto:support@heartsecsuite.com).

## Contact

For production subscriptions, fleet quotes, or onboarding: [support@heartsecsuite.com](mailto:support@heartsecsuite.com).
