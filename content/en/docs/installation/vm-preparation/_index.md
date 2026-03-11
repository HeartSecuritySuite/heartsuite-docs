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

## Overview

# Preliminary Step: Virtual Machines (VM’s) on Clouds

Installation of HeartSuite requires rebooting your computer several times. Notably, our installation procedure utilizes the GRUB boot loader, which can use labels or UUID’s when booting. We have found that use of labels for deployments in a cloud can result in boot failures. Accordingly, we strongly recommend that you edit the GRUB settings for VM’s provisioned in the cloud.

## Configuring GRUB Settings

Specifically, we recommend that you comment out the following line in the /etc/default/grub file:

```
GRUB_DISABLE_LINUX_UUID=true
```

by preceding it with a pound (#) symbol:

```
#GRUB_DISABLE_LINUX_UUID=true
```

Then, rebuild GRUB using `/sbin/update-grub`.

> [!NOTE]
> Cloud VMs may fail to boot due to GRUB settings; fix this to ensure reliable reboots.