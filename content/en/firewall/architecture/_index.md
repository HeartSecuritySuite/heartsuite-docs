---
title: "What sits under a closed firewall image"
linkTitle: "Architecture"
weight: 20
description: "Root Lock Firewall is a closed image: a stateful host filter on Linux netfilter (nft). What is in the box, and what you do not get to reconfigure."
categories: ["Essentials"]
tags: ["firewall", "architecture", "netfilter", "nftables", "kernel", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

## Closed image, not a package

Root Lock Firewall is the stateful packet-filter layer of a HeartSuite appliance image. The customer model is: boot the image, use the Dashboard on the console or serial console, observe, approve, seal. The image already carries a custom kernel, a userspace stateful-inspection engine HeartSuite updates, a console TUI, and host-integrity grants. Operators do not allowlist those programs.

That shape is required by the kernel underneath. Root Lock by HeartSuite is a custom Linux kernel. You cannot treat this product as software you drop onto a distribution kernel you already run. Laboratory install scripts exist for layer-installing the prototype on a throwaway guest. They are not the product.

## Two layers, one box

```text
Workload on this image
        │
        ▼
Root Lock Firewall     stateful allowlist for this host's path
        │
        ▼
Root Lock programs, files, per-program outbound IPs
                        plus the kernel the filter is allowed to run on
```

Root Lock Firewall owns the host packet filter. Root Lock owns what may execute and which literal outbound addresses each program may use. On this image there is one filter owner. A second manager (UFW, firewalld, or a hand-maintained ruleset beside the product) is a composition hazard, not a hardening step.

Root Lock's own packet path — SSH scope and accept-only service permits at Lockdown — remains thin. It is not this product. See [Mode Switching and Lockdown](../../docs/mode-switching/) for that Root Lock path, and do not read it as Root Lock Firewall.

## Linux netfilter on the nft path

The Root Lock kernel carries nftables and does not carry the older iptables table. Public documentation therefore describes the data path as **Linux netfilter, nft path**. Older iptables tools on this image load no table, so a rule you thought you applied does nothing.

A userspace stateful-inspection engine drives the filter. The Dashboard writes allowlist entries. It does not expose an engine configuration mall, a vendor web panel, or a cluster GUI. HeartSuite is the update authority for that engine. External reputation and geo downloads are off under seal.

The engine is still userspace software. Root Lock is what constrains which binaries may run and which addresses they may call. That residual is why the two layers ship together on the image. It is also why "we have no bugs" is not a claim this documentation makes.

## What the seal actually is

Firewall Lockdown makes the chosen allowlist immutable on the running appliance and is applied together with Root Lock Lockdown. After reboot, the Dashboard treats the ruleset as read-only.

The seal is immutability of a set you already chose. It is not a cryptographic proof that the live filter table equals the review queue you clicked through. Completeness of that correspondence is an engineering property under test, not a slogan. If a later engine can make the seal hashable, the product class does not change: it is still a stateful host filter.

## No administrative web plane

You administer the box from the console TUI. The appliance is designed without:

- a public administrative SSH listener by default
- a VPN web server as product identity
- cloud single sign-on into the filter
- vendor-static administrative accounts

The host filter's image baseline can still include the SSH port and the usual workload ports, open to any source. That is a port shape, not a running listener. Starting a listener on those ports is reachable from any source until you narrow the baseline through Maintenance. See [What Root Lock Firewall does and does not cover](../introduction/limits/).

Those omissions are the architectural answer to the campaign class in [Recent firewall campaigns](../examples/). They shrink the remote attack surface of the filter. They do not make the box unreachable to someone who holds the hypervisor console or the rack key.

## The virtual appliance residual

A virtual appliance runs on someone else's hypervisor. Control of that hypervisor is control of the disk and of the serial console. Root Lock Firewall does not claim to survive a hostile hypervisor.

Later marketing names two SKUs without changing inspection class:

- a virtual appliance on a hypervisor you trust
- a hardware appliance for environments where the hypervisor is not trusted

Until hardware ships, treat hypervisor and cloud serial-console IAM as part of the product's trust boundary.

## Compatibility notes

| Environment | Notes |
|---|---|
| HeartSuite appliance image (QCOW2, OVA) | The supported delivery. Console or serial first. |
| Root Lock kernel on a general-purpose server you built | That is Root Lock. It does not become Root Lock Firewall because the kernel is present. |
| Stock Debian or Ubuntu kernel | Not a supported host for this product. The nft-only constraint and the closed image assume the Root Lock kernel. |
| Cloud IaaS (AWS, Google Cloud, Azure, and others) | The virtual appliance may *run* there. It is not the provider's managed firewall (security groups, Network Firewall, Azure Firewall). Keep those as an outer layer if you use them. |
| Inline / NAT / HA pair | Not v1. See [Deployment scenarios](../deployment-scenarios/). |
| Shared-kernel containers on this image | This image is a closed appliance, not a Docker host. It does not ship a container engine. See [Deployment Scenarios](../../docs/introduction/deployment-scenarios/) on Root Lock for the separate container-host kernel product. |
| Windows or macOS | Not a target. The filter and the kernel are Linux. |
