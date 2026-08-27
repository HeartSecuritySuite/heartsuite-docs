---
title: "Obtaining Root Lock by HeartSuite"
linkTitle: "Obtaining Root Lock by HeartSuite"
weight: 1
description: "Install Root Lock by HeartSuite with a single command."
categories: ["Installation"]
tags: ["heartsuite", "linux", "install", "website"]
type: docs
aliases:
  - /docs/installation/obtaining-heartsuite/
toc: true
menu:
  main:
    parent: "installation"
    identifier: "obtaining-heartsuite"
---

**Overview**: Install Root Lock by HeartSuite with a single command.

> [!NOTE]
> This public install is a **beta**. Product version stays 1.7.0. Debian 12 is the reference platform. Inspect the bootstrap before piping to a shell if you prefer.

> [!NOTE]
> Cloud users who launched a pre-configured instance (AWS AMI, GCP image) already have Root Lock installed. Skip this step and proceed directly to the Dashboard.

Run the following command on the target system:

```bash
curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh | sudo sh
```

Prefer to inspect first:

```bash
curl -fsSL https://get.heartsecsuite.com/get-heartsuite.sh -o get-heartsuite.sh
less get-heartsuite.sh
sudo bash get-heartsuite.sh
```

The script downloads and installs the Root Lock kernel, tools, and Dashboard, then reboots automatically. Proceed to [Installation Part 1](../installation-part1/) after the reboot.

The installer itself is also published at the [v1.7.0-beta GitHub Release](https://github.com/HeartSecuritySuite/heartsuite-get/releases/tag/v1.7.0-beta) (`heartsuite-install.sh` plus `.sha256`). That drop is the beta channel; it is not the numbered 1.7.0 release ritual.
