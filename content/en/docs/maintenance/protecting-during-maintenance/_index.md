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

Maintenance — such as installing packages, editing files, or applying updates — is simply the period during which you temporarily reduce HeartSuite's protection to make changes. There are two ways to do this, and the choice matters: for almost all routine maintenance, switching to Setup mode on the HeartSuite kernel is the right approach. Booting the original kernel is a specific solution for a specific problem, described under Option 2 below.

### Option 1: Switch to Setup Mode

The most common approach is to remain on the HeartSuite kernel but switch to Setup mode. In Setup mode, HeartSuite logs all activity but does not block anything. Backups continue to run, and all `hs-*` tools remain available.

Use this option for tasks such as installing packages with `dpkg`, editing configuration files, or updating allowlist entries. For example, `dpkg` creates temporary directories during installation; in Secure mode this causes a permission error and the installation halts. Switching to Setup mode allows the installation to proceed, after which you can add any needed allowlist entries and return to Secure mode.

```bash
# sudo /.hs/sys/hs-mode-switch setup
```

After maintenance is complete, switch back to Secure mode:

```bash
# sudo /.hs/sys/hs-mode-switch off
```

### Option 2: Boot the Original Kernel

Use this option only when lockdown is configured to re-engage automatically on every boot — that is, when the lockdown line in `HS_startup.sh` is uncommented. In that situation, rebooting into the HeartSuite kernel will re-engage lockdown before you can prevent it, and you cannot switch to Setup mode from within the locked-down system. Booting the original non-HeartSuite kernel from the GRUB menu is the way out.

On the original kernel, HeartSuite is completely absent. The kernel module is not loaded, no enforcement or logging takes place, and backups do not run. Only `hs-*` tools that perform file operations — such as `hs-monitor-state`, `hs-backup-config-manager`, and `hs-allowlist-manager` — will work. Tools that invoke HeartSuite system calls, such as `activate_HS`, will fail with an error on the original kernel.

> [!WARNING]
> The original kernel provides no HeartSuite protection whatsoever. Take additional precautions to secure your server during this time (see Recommended Protection Measures below).

To prepare for re-entry into the HeartSuite kernel after booting the original kernel, use the following workflow:

1. Run `hs-monitor-state on` to pre-configure HeartSuite to start in Setup mode on the next boot:
   ```bash
   # sudo /.hs/sys/hs-monitor-state on
   ```
2. If lockdown was previously active, run `HS_unlock.sh` to clear filesystem immutability flags:
   ```bash
   # sudo /.hs/sys/HS_unlock.sh
   ```
3. Perform your maintenance tasks.
4. Reboot into the HeartSuite kernel. HeartSuite will activate in Setup mode automatically.
5. Update your allowlist as needed, then switch back to Secure mode.

> [!NOTE]
> You must have physical or serial port access to select the original kernel at the GRUB menu. This is intentional — it prevents an attacker from remotely booting to the original kernel to bypass HeartSuite.

### Lockdown and Filesystem Immutability

When `HS_lockdown.sh` makes files immutable using `chattr +i`, those flags are stored at the filesystem level and persist across reboots — including reboots to the original kernel. If you attempt to modify a file that was made immutable during a previous lockdown session, you will encounter an error such as "could not open <filename> file; errno:1." Run `HS_unlock.sh` to restore mutability before proceeding.

### Recommended Protection Measures

The protection measures below are recommended whenever HeartSuite is not fully active. The degree of risk differs between the two options above: in Setup mode, HeartSuite is still logging and backups are still running; on the original kernel, no HeartSuite protection is present at all. In either case, the following measures are strongly advised.

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
