---
title: "Network and Remote Access"
weight: 50
description: "Configuring network permissions and remote access rules."
type: docs
categories: ["Guides"]
tags: ["heartsuite", "linux", "network", "permissions", "security", "remote-access"]
toc: true
---

# Network Access Configuration

## Overview

**Overview**: For internet access, whitelist specific IPs—HeartSuite blocks everything by default to prevent exploits.

## Adding Network Permissions

The same procedures apply to learning which remote servers a program attempts to access, as well as permitting the program to access particular remote servers. This edition of HeartSuite is strictly limited to specific IPv4 and IPv6 addresses, it cannot regulate network access using address ranges or domain names. Address ranges and domain name-based access, however, are planned for later editions.

### Example: Whitelisting wget

For example, suppose that a whitelist entry is created for the wget program without adding any network permissions. Then, the program is used to obtain an HTML document from a website, as follows:

```bash
# wget https://example.com/agreement.html
```

The following permission error message concerning network access appears in the log file:

```text
[Setup Notice - Add to Network Whitelist?] Network Connection Attempt Logged by /usr/bin/wget; IP: 45.60.22.168
```

You can add this IP address to the whitelist entry for wget as follows:

```bash
# sudo /.hs/sys/hs-whitelist-manager add -x /usr/bin/wget -n 45.60.22.168
```

– or –

```bash
# /.hs/sys/hs-whitelist-manager list | grep wget
# /.hs/sys/hs-whitelist-manager add -r 277 -n 192.142.166.196
# /.hs/sys/hs-whitelist-manager list | grep wget
277
/usr/bin/wget
# /.hs/sys/hs-whitelist-manager add -r 277 -n 192.142.166.196
```

The next time you run the same wget command, there will be no permission error message in the log for this IP address access.
