---
title: "A sealed host filter beside a campus NGFW"
linkTitle: "How it compares"
weight: 35
description: "What Root Lock Firewall is, what it complements, and why it sits beside a campus NGFW rather than replacing one."
categories: ["Essentials"]
tags: ["firewall", "comparison", "ngfw", "cisco", "fortinet", "prototype"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: A listening service on a Linux host accepts inbound packets unless a filter refuses them. Root Lock Firewall is that host-path filter on a closed HeartSuite appliance: observe real traffic, approve a finite allowlist for this box, seal it.

The question it answers is: did a human approve this socket on this box, and is that set sealed?

Application identification, TLS interception, and fleet NGFW management stay with the campus tool. [Root Lock by HeartSuite](../../docs/) handles execution, files, and per-program outbound destinations on the same image.

---

## Root Lock Firewall and Root Lock

Three OS-level controls are unrestricted by default on Linux: file access, network communication, and program execution. Inbound reachability is a fourth default: a bound port is open to the routeable world.

Root Lock and Root Lock Firewall share a review grammar and a seal. They close different defaults.

**Root Lock** is production-ready today on a server or a cloud image. You review programs, file paths, and outbound destinations, then enable Lockdown. Anything not on that allowlist is blocked at the kernel, including from root.

**Root Lock Firewall** is the host packet filter for a closed appliance. You review inbound and this-host path events, then enable Firewall Lockdown. On the HeartSuite appliance image they are designed to run together.

| Aspect | Root Lock | Root Lock Firewall | What this means in practice |
|---|---|---|---|
| Default it closes | A program inherits the user's right to execute, read, write, and connect out | A listener accepts inbound packets from anywhere that can route to it | Approving `curl` to one IP does not close port 22. Closing port 22 does not constrain `curl`. |
| Placement | Kernel on the host you install | Filter on the appliance image; workload on that image | v1 is host-shaped: the workload runs on the image. |
| Inspection | Kernel grants (program, path, literal outbound IP) | Stateful packet filter (connection state + sealed allowlist) | Inspection stays kernel grants and a stateful packet filter. |
| How you reach it | Dashboard on the host | Dashboard on the console or serial console of the image | Console or serial is the administrative path. |
| Seal | Lockdown on the kernel allowlist | Firewall Lockdown on the packet allowlist, paired with Lockdown | Two seals, one maintenance path. |
| Production status | Shipped | Prototype | Do not treat this section as a GA install guide. |

### For production deployments today

**Root Lock** is the shipped product for execution, files, and outbound destinations. Inbound on that deployment remains an OS packet filter or a cloud security group, as the [Network](../../docs/network/) page states.

**Root Lock Firewall** is the prototype that takes inbound on a HeartSuite appliance as its job. Use it when the workload can live on the image and the team wants the same observe → approve → seal act on sockets.

Firewall Lockdown seals the packet allowlist. Root Lock Lockdown seals the kernel allowlist.

---

## A finite observed sealed allowlist

This appliance is a finite, observed, reviewed, sealed allowlist for this host. Campus NGFW blades — application catalogs, TLS interception, URL clouds, sandbox, SD-WAN, SASE — stay the specialist tool. Enterprise NGFWs sell infinite policy surface and paid inspection.

Payload interpretation stays with a WAF in front of an allowed HTTPS port.

A virtual appliance that boots on AWS, Google Cloud, or Azure stays a host filter on that image. Provider controls (AWS Network Firewall, Azure Firewall, Cloudflare) stay the outer layer.

v1 filters this host. FORWARD and NAT stay later. Keep the existing edge box in front of other machines.

One owner of the host filter. UFW, firewalld, or a second manager on the same image is a composition hazard.

The Dashboard writes allowlist entries. Engine internals stay off the glass. There is no configuration mall and no cluster GUI as a drop-in vendor-panel replacement.

Execution, files, and per-program outbound destinations stay [Root Lock by HeartSuite](../../docs/). Root Lock inbound permits at Lockdown remain a thin accept path for SSH and named services.

---

## A smaller remote plane is a different tool

Campus firewalls earned a second job: they became the remote-access concentrator and the administrative website. The packet filter then has to survive bugs in its own VPN web server, cloud SSO, and static accounts. That is a different tool shape from a sealed host filter with a console TUI.

Named incidents (vendor advisories, not HeartSuite testing):

| Year | What was exposed | Advisory |
|---|---|---|
| 2024 | Cisco FTD on Firepower 1000/2100/3100/4200 shipped **static accounts with hard-coded passwords**. A local attacker who could reach the CLI (serial or SSH, which is on by default on the management interface) could log in as those accounts. | [CVE-2024-20412](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-ftd-statcred-dFC8tXT5) |
| 2025 | Cisco Secure Firewall ASA/FTD **VPN web server**: crafted HTTP to the SSL VPN / AnyConnect path, arbitrary code as root, exploited as a zero-day. CISA issued Emergency Directive 25-03. | [CVE-2025-20333](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-webvpn-z5xP8EUB), [ED 25-03](https://www.cisa.gov/news-events/directives/ed-25-03-identify-and-mitigate-potential-compromise-cisco-devices) |
| 2026 | Persistence in the FXOS base OS **survived upgrade** to the September 2025 fixed releases. Cisco's recommended removal is a reimage. A reboot CLI command is not enough. | [cisco-sa-asaftd-persist-CISAED25-03](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-persist-CISAED25-03) |
| 2026 | FortiOS and related tools: **FortiCloud SSO** let an attacker with a FortiCloud account and a registered device log into *other* customers' devices when that SSO toggle was on. Fortinet documents that registering the device in the GUI enables the toggle unless you turn it off. Operators then downloaded configuration and created local admin accounts. Exploited in the wild. | [CVE-2026-24858](https://www.fortiguard.com/psirt/FG-IR-26-060) |

Root Lock Firewall is designed without those surfaces:

- no VPN web server as identity
- no cloud SSO into the filter
- no vendor-static administrative accounts
- console or serial as the administrative path
- HeartSuite as the update authority
- seal plus a custom kernel under the filter

That is a smaller remote attack surface. A bug in this prototype remains in scope. Campus and inline FortiGate / Cisco Secure Firewall roles stay with those boxes.

See [Recent firewall campaigns](../examples/) for the honest residual on each incident.

---

## What Root Lock Firewall complements

| Gap Root Lock Firewall leaves open | Complementary control |
|---|---|
| Program execution, file access, per-program outbound IPs | [Root Lock](../../docs/) |
| Application content on an allowed port | WAF / application hardening |
| Ports the image left open to any source | Not produced by observation. Seal keeps them. Narrow through Maintenance. |
| Detection, correlation, incident response | SIEM, NDR, EDR hunting — forward events; the SOC console stays there |
| Volumetric DDoS and provider edge | Cloud security groups, provider DDoS, CDN |
| Inline NAT, HA pairs, SD-WAN, site-to-site VPN | The existing campus or DC firewall |
| Who may open the serial or hypervisor console | Cloud IAM, hypervisor ACL, locked rack |

Root Lock Firewall and Root Lock address complementary OS-level defaults. Root Lock Firewall covers inbound and this-host path at the packet filter. Root Lock covers execution, files, and outbound destinations at the kernel.

---

## The HeartSuite appliance image, and a Root Lock server you already run

The HeartSuite appliance image is the intended Root Lock Firewall deployment: kernel grants under a sealed host filter. The image includes the Root Lock kernel. A packet filter on a general-purpose kernel you already run stays a different product.

Root Lock on a server you already run is the shipped shape for hosts that need execution and outbound control and already have an inbound filter (OS or cloud). That remains valid.

---

## Positioning relative to common categories

| Category | Does Root Lock Firewall apply? | Notes |
|---|---|---|
| Host inbound allowlist on a closed appliance | Yes — the job | Observe, approve, seal |
| Stateful inspection | Yes | Connection state, not a stateless ACL box |
| Virtual appliance delivery | Yes (v1) | QCOW2 / OVA; hardware later |
| NGFW / App-ID / TLS MITM | No | Refused as identity |
| WAF / proxy | No | No payload interpretation |
| Cloud FWaaS | No | May run on IaaS; the provider's policy plane stays there |
| Inline DC / branch edge (v1) | No | Host-shaped; no FORWARD/NAT surface |
| UFW-on-Ubuntu replacement | No | Image, not a package |
| SIEM / NDR / EDR | Complements | Forward events; the SOC stays the SOC |

**How Root Lock Firewall can be circumvented.** Under Firewall Lockdown paired with Root Lock Lockdown, an attacker who already has remote root cannot rewrite the sealed allowlist. Changing it takes Maintenance on the console or serial console. SSH is not enough.

What remains is whether you approved too wide a rule, whether an allowed port is still a hole in the application, whether the filter program can be killed, and whether someone who holds the hypervisor owns the disk.

Physical presence, cloud serial, or hypervisor control returns the box to whoever holds it.

Every security system has a known way to be taken out of the picture. Being explicit about it is how customers evaluate fit.
