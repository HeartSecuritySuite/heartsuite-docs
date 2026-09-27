---
title: "What Cisco and Fortinet incidents needed to exist"
linkTitle: "Attack examples"
weight: 30
description: "2024–2026 Cisco and Fortinet campaigns depended on management planes and extra services. HeartSuite Firewall is designed without those surfaces."
categories: ["Essentials"]
tags: ["firewall", "cisco", "fortinet", "cve", "examples", "prototype"]
type: docs
toc: true
---

> **Prototype**: The protections described on this page reflect HeartSuite Firewall design intent. HeartSuite Firewall is under active development. Incident facts below are taken from vendor and CISA publications, not from HeartSuite exploitation tests.

**Overview**: HeartSuite Firewall is a host-shaped stateful filter on a closed image.

Each incident below names what the campaign depended on, what HeartSuite Firewall does about that surface, and what it leaves to other tools. The linked vendor advisories stay the source for campaign facts.

Where an attack is application content on a port you approved, or a new binary, or an outbound callback, those dimensions belong to [Root Lock by HeartSuite](../../rootlock/) and a WAF.

---

## Cisco FTD static accounts (CVE-2024-20412)

**What happened.** In October 2024 Cisco published a critical advisory for Firepower Threat Defense on Firepower 1000, 2100, 3100, and 4200 series. The devices contained static accounts with hard-coded passwords.

An unauthenticated local attacker who reached the CLI could log in as those accounts, read sensitive data, change some configuration, or leave the device unable to boot. SSH is enabled by default on the management interface.

Cisco listed example account names in the advisory (`csm_processes`, `report`, `sftop10user`, `Sourcefire`, `SRU`).

Source: [cisco-sa-ftd-statcred-dFC8tXT5](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-ftd-statcred-dFC8tXT5).

**What the campaign needed.** A management CLI that accepted vendor-static credentials, reachable from serial or from SSH that ships enabled.

**What HeartSuite Firewall does.** The image ships no vendor-static administrative accounts. You reach the box on the console TUI of an image you control, and there is no public administrative SSH by default.

**What it does not cover.** Console or serial remains the administrative path, so an attacker who holds a hypervisor console, or who exploits a bug in the appliance's own console stack, reaches that path.

---

## Cisco ASA/FTD VPN web server (CVE-2025-20333) and CISA ED 25-03

**What happened.** On 25 September 2025 Cisco disclosed a critical bug in the VPN web server of Secure Firewall ASA and FTD. Improper validation of HTTP(S) requests let an authenticated VPN user run code as root.

Cisco later described an unauthenticated companion (CVE-2025-20362) and stated that exploitation was attempted. CISA issued [Emergency Directive 25-03](https://www.cisa.gov/news-events/directives/ed-25-03-identify-and-mitigate-potential-compromise-cisco-devices). Affected features include SSL VPN and AnyConnect client-services on an interface.

Source: [cisco-sa-asaftd-webvpn-z5xP8EUB](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-webvpn-z5xP8EUB).

**What the campaign needed.** A TLS web listener on the firewall whose job is remote access, not packet filtering.

**What HeartSuite Firewall does.** The appliance is designed without a VPN web server: it is a sealed host filter that you administer from the Dashboard on the console or serial console.

**What it does not cover.** AnyConnect-class remote access stays with a dedicated SSL-VPN concentrator.

---

## Persistence that survived the Cisco patch (April 2026)

**What happened.** On 23 April 2026 Cisco published that the ArcaneDoor actor had a persistence mechanism in the FXOS base operating system of affected ASA/FTD hardware. It remained after customers upgraded to the September 2025 fixed releases.

Cisco's recommended removal is a reimage. A `reload` / `reboot` CLI command does not clear it. Cisco documented that only a cold power cycle is an emergency alternative, and warned that pulling power can corrupt the device.

Source: [cisco-sa-asaftd-persist-CISAED25-03](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-asaftd-persist-CISAED25-03). CISA's September 2025 background also described ROM persistence across reboot and upgrade on ASA.

**What the campaign needed.** A large, long-lived appliance OS under the filter, plus a first foothold (the VPN web server class above), plus persistence below the patch you thought you installed.

**What HeartSuite Firewall does.** A smaller closed image, HeartSuite as the only update authority, and a custom kernel that already removes a class of in-kernel bypass primitives.

Supported recovery of a sealed box is Maintenance on the console, then a return and re-seal; that cycle unseals policy so you can change it.

**What it does not cover.** A hostile hypervisor, firmware, or ROM sits below the image, outside both the seal and that recovery cycle, and stays with whoever holds that path. A later hardware appliance is the planned answer for the hypervisor.

The filter engine is userspace software under Root Lock, and formal seL4-style assurance of that engine is outside this prototype.

---

## FortiCloud SSO into other customers' devices (CVE-2026-24858)

**What happened.** On 27 January 2026 Fortinet disclosed an authentication-bypass in FortiOS, FortiManager, FortiAnalyzer, FortiProxy, FortiSwitchManager, and FortiWeb. An attacker with a FortiCloud account and a registered device could log into devices registered to *other* accounts when FortiCloud SSO was enabled.

Fortinet states the feature is off in factory defaults, but registering the device to FortiCare from the GUI enables the toggle unless the administrator turns it off. The bug was exploited in the wild.

After SSO, Fortinet observed configuration-file download and creation of local admin accounts (`audit`, `backup`, `itadmin`, and others).

Source: [FG-IR-26-060](https://www.fortiguard.com/psirt/FG-IR-26-060) (CVE-2026-24858).

**What the campaign needed.** A cloud identity plane that can administer the filter, turned on as a side effect of "register this device."

**What HeartSuite Firewall does.** The appliance has no cloud SSO into the filter and no FortiCare-style registration step that opens an administrative identity provider on the box. HeartSuite is the update authority.

**What it does not cover.** Email, webhook, or syslog sent to addresses you approved is ordinary outbound traffic, governed by Root Lock's outbound policy and whatever you configured for alerts. A bug in an update channel HeartSuite ships is a HeartSuite bug, disclosed as such.

---

## Unsolicited inbound on a closed port

**What happens on a general-purpose server.** A forgotten listener or a default service is reachable from the internet. Scanners find it. Credential stuffing follows.

**What HeartSuite Firewall does.** During observation those attempts become review events. After Firewall Lockdown, packets to sockets that are not on the sealed allowlist are refused, including when the service runs as root.

**What it does not cover.** A port you approved stays open to the traffic its rule allows, and a seal that is too wide stays too wide until you narrow it through Maintenance. Volumetric floods have to be absorbed in front of the host, by the provider or cloud perimeter. See [Protection limits](../introduction/limits/).
