---
title: "Where a host-shaped firewall belongs"
linkTitle: "Deployment scenarios"
weight: 15
description: "When Root Lock Firewall fits, when it sits beside Root Lock, and when a campus NGFW is still the right box for the edge."
categories: ["Essentials"]
tags: ["firewall", "deployment", "appliance", "scenarios", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: Root Lock Firewall fits when the workload can live on a closed HeartSuite image and you want a sealed inbound allowlist for this box. Delivery is that image. Campus NGFW blades stay the specialist tool.

## Where Root Lock Firewall fits

### A single-purpose workload on a closed image

A backup receiver, an internal service, a regulated workload that should run one job: the workload lives *on* the appliance. You observe what actually arrives, approve the sockets that job needs, and seal.

Root Lock by HeartSuite is already the operating system, so a new binary and a new outbound destination still go through the kernel allowlist.

### Virtual appliance on a hypervisor you administer

QCOW2 or OVA on KVM, or the equivalent import on a commercial hypervisor. Console or serial is how you reach the Dashboard. Restrict who can open that console.

The hypervisor is part of the trust boundary. See [The virtual appliance residual](../architecture/#the-virtual-appliance-residual).

### Next to cloud security groups and provider DDoS tools

Security groups and the provider's volumetric controls stay useful in front of any VM. Root Lock Firewall is the host allowlist *on* the image after that outer layer.

Cloud firewall services stay the provider's policy plane. Booting on AWS, Google Cloud, Azure, DigitalOcean, or Linode leaves that plane in place.

### Teams who already review Root Lock queues

If the team already reviews Programs, File Access, and Internet Access, Firewall Rules is the same human act applied to this box's sockets. That is the intended buyer. FortiManager-class estate management stays with the campus tool.

## Where another tool belongs

### In front of other machines

v1 has no FORWARD or NAT product surface. Keep the existing edge firewall in front of a backup server, a subnet, or a pair of application hosts, or wait for an edge SKU that changes placement.

### Campus, branch, or "NGFW refresh"

App-ID, TLS interception, URL clouds, SD-WAN, SSL-VPN as identity, and a central management empire stay with the specialist tool.

Using this image as a FortiGate or Cisco Secure Firewall replacement is a misfit.

### Install-on-my-Ubuntu

Delivery is the image.

Root Lock on a server you already own remains the kernel product. Inbound on that server stays the OS or cloud control you already run, unless you move the workload onto this appliance.

### Dedicated hardware

A hardware appliance (TPM / measured boot) is planned. v1 is the virtual image. Until hardware ships, the hypervisor is part of the trust boundary.

### Shared-kernel container hosts

This appliance is a closed image. Container hosts stay the separate Root Lock container-host kernel product. See Root Lock [Deployment Scenarios](../../docs/introduction/deployment-scenarios/).

### A WAF or API gateway requirement

Payload inspection, bot scores, and schema validation stay with a WAF in front of an allowed HTTPS port.

## Alongside Root Lock

On the HeartSuite appliance image the two layers are designed to run together.

| Job | Product |
|---|---|
| Inbound and this-host path | Root Lock Firewall |
| Programs, files, outbound IPs | Root Lock |

Root Lock without this image is still a complete kernel product. Root Lock Firewall on that server is an optional SKU.

Adding a second packet-filter manager next to Root Lock Firewall on the appliance *is* a hole in the composition.

For residuals inside an approved port, see [Protection limits](../introduction/limits/).
