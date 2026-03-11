---
title: "Protecting During Maintenance"
weight: 2
description: "Securing your server during maintenance windows to prevent attacks."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "security", "lockdown", "protection"]
type: docs
toc: true
---

## Protecting Your Server During Maintenance

Maintenance (e.g., installing packages, editing files) often requires Setup mode or disabling lockdown, as `HS_startup.sh` auto-engages it.

### Booting Without Lockdown
- HeartSuite adds a modified kernel; your original kernel remains available.
- In GRUB, select the original kernel to boot without HeartSuite activation.
- Switch to Setup mode with `hs-mode-switch setup`.
- Or, comment out lockdown in `HS_startup.sh` if working in Secure mode (but avoid tools like `dpkg`).

> [!WARNING]
> Without lockdown, your server is vulnerable—implement additional protections during maintenance.

### Recommended Protection Measures

#### Block All Incoming Connections
Disable network interfaces for maintenance to prevent remote access.
- Use `ifdown`/`ifup` or `ip` command.
- Requires physical/serial access.

Example (using `ifdown`):
```bash
ifdown eth0
/.hs/sys/activate_HS
if [ $? -eq 0 ]; then
ifup eth0
fi
```

Example (using `ip`):
```bash
ip link set eth0 down
/.hs/sys/activate_HS
if [ $? -eq 0 ]; then
ip link set eth0 up
fi
```

For SSH-based maintenance:
- Set firewall rules to block all except your IP/connection.
- Add rules to `HS_lockdown.sh` to enable after lockdown.
- Alternatively, use a separate firewall server for better protection (disable manually post-maintenance).

#### Shut Down Server Programs
Stop server programs (e.g., web servers) to close Internet access vectors.
- Restart them after maintenance/reboot with lockdown.
- Exception: Keep SSH if needed for access (see restrictions below).

#### Restrict SSH Access
For cloud setups, prefer serial port access (disable auto-start of `sshd`).
If SSH required:
- Disable root login.
- Allow only one admin user.
- Use key-based auth (no passwords).
- Limit to specific IPs via firewall.
- Use VPN for added security.
