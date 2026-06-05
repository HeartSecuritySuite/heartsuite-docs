---
title: "Obtaining HeartSuite Root Lock"
linkTitle: "Obtaining HeartSuite Root Lock"
weight: 1
description: "Install HeartSuite Root Lock with a single command."
categories: ["Installation"]
tags: ["heartsuite", "linux", "install", "website"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "obtaining-heartsuite"
---

**Overview**: Install HeartSuite Root Lock with a single command.

> [!NOTE]
> Cloud users who launched a pre-configured instance (AWS AMI, GCP image) already have HeartSuite Root Lock installed. Skip this step and proceed directly to the Dashboard.

Run the following command on the target system:

```bash
curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh | sudo sh
```

The script downloads and installs the HeartSuite Root Lock kernel, tools, and Dashboard, then reboots automatically. Proceed to [Installation Part 1](../installation-part1/) after the reboot.
