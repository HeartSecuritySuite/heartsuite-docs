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

**Overview**: Cloud VMs often use disk labels in GRUB rather than UUIDs — this causes boot failures during the multiple reboots HeartSuite Core Secure installation requires. This step applies to Local Path installations on cloud VMs only. Bare-metal installations and Cloud Path users skip this entirely.

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

