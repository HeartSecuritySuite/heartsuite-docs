---
title: "Network and Remote Access"
weight: 50
description: "Reviewing and approving internet destinations for each program."
type: docs
categories: ["Guides"]
tags: ["heartsuite", "linux", "network", "permissions", "security", "remote-access"]
toc: true
---

**Overview**: Programs make outbound connections you never approved — telemetry, update beacons, C2 callbacks. HeartSuite Core Secure blocks all outbound network connections by default. No program can connect to any destination unless you have explicitly approved it. The Dashboard's Internet Access queue (`[i]`) guides you through reviewing and approving destinations for each program as part of Phase 5.

## Per-Program, Per-Destination Enforcement

In Setup Mode, HeartSuite Core Secure logs every outbound connection attempt without blocking it. These connection attempts appear in the Dashboard's Internet Access queue. In Secure Mode, any connection to a destination not on the allowlist is blocked and an alert is generated.

Network permissions are per-program and per-destination. Approving `93.184.216.34` for `curl` does not allow `wget` to connect to the same address — each program must have its own approved destinations. HeartSuite Core Secure approves specific IPv4 and IPv6 addresses — not CIDR ranges, hostnames, or wildcards.

## Using the Internet Access Queue

Select the Internet Access queue from the Dashboard (`[i]`). Each connection shows:

- **Program** — the full path and package metadata (name, version, description, maintainer)
- **Destination** — the IP address with reverse DNS hostname (e.g., `93.184.216.34 — example.com (Edgecast, US)`)
- **Attempts** — how many times this connection was attempted

Example review prompt:

```text
/usr/bin/curl attempted an outbound connection:
Destination: 93.184.216.34 — example.com (Edgecast, US)
Program:     curl 7.88.1-10 — command line tool for transferring data with URL syntax
Attempts:    7

This destination has not been allowlisted for this program.

[a] Approve this connection for /usr/bin/curl
[s] Skip for now
```

Press `[a]` to approve the destination for that program, or `[s]` to skip it for later.

When the Internet Access queue is empty, the Dashboard marks Phase 5 as complete and updates the Suggested Next Step.

## Approving a Network Destination

Suppose `wget` is on the program allowlist but no network destinations have been approved. Running:

```bash
# wget https://example.com/agreement.html
```

HeartSuite Core Secure intercepts the connection and the attempt appears in the Internet Access queue with the destination `45.60.22.168 — example.com`. After you approve it, the same `wget` command completes without generating another entry for that IP address.

## Reviewing Existing Network Permissions

To browse or edit network destinations that have already been approved, select Allowed (`[a]`) from the Dashboard main screen. Existing entries are grouped by category — Programs, File Access, and Internet Access — so you can quickly find and modify network permissions.

## Direct Allowlist Management

For automation workflows or bulk changes, `hs-manage-allowlist` provides direct CLI access:

```bash
# hs-manage-allowlist add -x /usr/bin/wget -n 45.60.22.168
```

Or look up the entry number first:

```bash
# hs-manage-allowlist list | grep wget
277
/usr/bin/wget
# hs-manage-allowlist add -r 277 -n 192.142.166.196
```

For general allowlisting concepts (program execution, file access, write permissions), see [Allowlisting Basics](../allowlisting/allowlisting-basics/).
