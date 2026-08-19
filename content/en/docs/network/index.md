---
title: "Each program gets its own internet destinations"
linkTitle: "Network and Remote Access"
weight: 60
description: "Outbound connections are allowlisted per program and per address. Approving a destination for curl does not approve it for wget."
type: docs
categories: ["Guides"]
tags: ["heartsuite", "linux", "network", "permissions", "security", "remote-access"]
toc: true
author: Ron Hessing
---

**Overview**: Programs make outbound connections you never approved (telemetry, update beacons, C2 callbacks). Root Lock by HeartSuite requires an allowlist entry for every outbound destination — per program, at the kernel.

In Lockdown, no program can connect to any destination unless you have approved it. The Dashboard's Internet Access queue (`[i]`) guides you through reviewing and approving destinations for each program.

## Per-program, per-destination enforcement

In Setup Mode, Root Lock logs every outbound connection without blocking it. Those connections appear in the Dashboard's Internet Access queue. In Lockdown, any connection to a destination not on the allowlist is blocked and an alert is generated.

Network permissions are per-program and per-destination. Approving `93.184.216.34` for `curl` does not allow `wget` to connect to the same address; each program must have its own approved destinations. Root Lock approves specific IPv4 and IPv6 addresses, not CIDR ranges, hostnames, or wildcards.

## Using the Internet Access queue

From the Dashboard, select the Internet Access queue (`[i]`). The review panel header says **Network**. Each program already on the allowlist is one item, with every destination it reached listed together:

- **Program**: path and package metadata when the distro database has an entry
- **Destinations**: each literal IP, with a hostname or CDN label when one resolved — for example `8.8.8.8 (dns.google)` or `151.101.0.223 (files.pythonhosted.org, Fastly CDN)`. Unresolved addresses show as the bare IP. There is no country field.
- **Counts**: `×N` next to each address, plus a total in the header

Example review prompt:

```text
Network: reviewing 1 of 2

curl connected to 3 addresses during Setup Mode  (3 total connections)

Approving grants curl network access to these destinations.

[a] Approve network access
[s] Skip for now
[?] What does approving this mean?

── Destinations (3) ──
  8.8.8.8 (dns.google)                         ×1
  1.1.1.1 (one.one.one.one)                    ×1
  142.250.74.46 (lga34s32-in-f14.1e100.net)    ×1
```

Press `[a]` to approve every listed address for that program, or `[s]` to skip it for later.

When the Internet Access queue is empty, the Lockdown Checklist marks **3. Internet Access Allowlisting** complete and updates the Suggested Next Step.

## Approving a network destination

Suppose `wget` is on the program allowlist but no network destinations have been approved. Running:

```bash
# wget https://example.com/agreement.html
```

Root Lock logs the connection. It appears in the Internet Access queue as a destination such as `93.184.216.34 (example.com)`. After you approve it, the same `wget` command does not generate another entry for that IP address. A later connection to a different IP for the same hostname is a new destination.

## Reviewing existing network permissions

To browse or edit destinations that have already been approved, select Allowed (`[a]`) from the Dashboard. Entries are grouped as Uninstalled, Programs, File access, Internet Access, and Root Lock. A program with approved destinations appears under Internet Access.

## CLI access for scripting and automation

For scripting without the Dashboard, the allowlist manager is `/.hs/sys/hs-app-perm-orders-manager` (`/.hs/sys` is not on `PATH`):

```bash
# /.hs/sys/hs-app-perm-orders-manager add -x /usr/bin/wget -n 93.184.216.34
```

Or look up the record number first:

```bash
# /.hs/sys/hs-app-perm-orders-manager list | grep wget
277
/usr/bin/wget
# /.hs/sys/hs-app-perm-orders-manager add -r 277 -n 192.0.2.10
```

The Dashboard is the supported path for normal use.

For general allowlisting concepts (program execution, file access, write permissions), see [Allowlisting Basics](../allowlisting/allowlisting-basics/).

When the Internet Access queue is empty, the Suggested Next Step goes to [Alert Settings](../alerts/) (`[e]`) if alerts are not configured yet — or to Lockdown (`[l]`) if they already are. Backup (`[b]`) can appear before Lockdown when backup is not configured.

## Inbound connections and remote login

Root Lock manages outbound connections only. Inbound filtering (which ports are reachable, port scans, who may connect) is outside its scope. Use an OS packet filter, cloud provider security groups, or [Root Lock Firewall](../../firewall/) when you move the workload onto that Firewall appliance image and want inbound and this-host path observed and sealed.

To log in over SSH, approve the SSH server to execute and to read the files it needs. Adding the addresses you connect from to Internet Access does not grant inbound access — that queue is outbound destinations only. Restrict source IPs in sshd or the packet filter. Lockdown offers Harden SSH (`[h]`) when an authorized key is already present. See [Mode Switching and Lockdown](../mode-switching/).
