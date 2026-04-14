---
title: "VM Preparation"
weight: 2
description: "Preliminary setup for virtual machines in the cloud."
categories: ["Installation"]
tags: ["heartsuite", "linux", "vm", "cloud", "grub", "setup"]
type: docs
toc: true
menu:
  main:
    parent: "installation"
    identifier: "vm-preparation"
---

**Overview**: This step applies to the Local Path only. Cloud VMs provisioned from a pre-configured image do not require GRUB changes.

Installation of HeartSuite Core Secure requires rebooting several times. The installation procedure uses the GRUB boot loader, which can reference disks by labels or UUIDs. Using labels on cloud deployments can result in boot failures. Edit the GRUB settings for VMs provisioned in the cloud before proceeding.

## Configuring GRUB Settings

Comment out the following line in `/etc/default/grub`:

```text
GRUB_DISABLE_LINUX_UUID=true
```

by preceding it with a `#` symbol:

```text
#GRUB_DISABLE_LINUX_UUID=true
```

Then rebuild GRUB:

```bash
# /sbin/update-grub
```

> [!NOTE]
> Cloud VMs may fail to boot due to GRUB settings. Correcting this ensures reliable reboots during the installation process.
