---
title: "Appendices"
weight: 110
description: "List of included HeartSuite Core Secure tools."
categories: ["Reference"]
tags: ["heartsuite", "linux", "tools", "executables", "scripts", "reference"]
type: docs
toc: true
---

**Overview**: HeartSuite Core Secure includes a set of tools for system management, allowlisting, and security enforcement. The Dashboard is where you work day-to-day; the tools listed below are for advanced workflows and recovery scenarios.

With exception of the Secure Script Launchers, all tools are located in the `/.hs/sys` directory. The HeartSuite Core Secure installation routine does NOT add this directory to the PATH environment variable. The Secure Script Launchers are located in `/usr/bin` because it is in the default PATH. Programs and scripts that write data to HeartSuite Core Secure databases must be run as root.

## Management Tools

These are the tools most users interact with, organized by phase.

### Dashboard and Review (Phases 1-5)

- **Dashboard** — where you manage HeartSuite Core Secure. Displays phase progress, pending/denied counts, protection state indicator, status line at the bottom, and Suggested Next Step. Appears automatically on login. Launch manually with `sudo python3 main.py`.
- **Programs queue** (`[p]`) — Dashboard screen to review and approve pending program executions (Phase 2). Presents items with full metadata, grouped intelligently.
- **File Access queue** (`[f]`) — Dashboard screen to review and approve pending file accesses (Phase 4). Handles read access and write access approvals separately.
- **Internet Access queue** (`[i]`) — Dashboard screen to review and approve pending internet connections (Phase 5). Allows allowlisting specific IPs per program.
- **Allowed** (`[a]`) — Dashboard screen to browse and edit existing allowlist entries.
- **Browser View** (`[w]`) — Dashboard screen to enable or disable browser-based access to HeartSuite Core Secure via SSH tunnel.
- **Launchers** (`[l]`) — Dashboard screen to configure Secure Script Launchers (Phase 3).

### Alert Configuration (Phase 6)

- **Alert Settings** (`[e]`) — Dashboard screen to configure alert channels (email, syslog, or webhook). At least one channel must be configured before Secure Mode activation. See [Alert Configuration](../alerts/).

### Mode Switching and Security (Phase 7)

- **Mode Switch** (`[m]`) — Dashboard screen for Secure Mode activation. Shows precondition checklist, observation period, and review summary. After activation, offers `[r]` Reboot or `[l]` Reboot + Lockdown.
- **`hs-activate-lockdown`** — makes HeartSuite Core Secure configuration files and directories immutable using `chattr +i`, then engages the lockdown program. Requires Secure Mode to be active. Requires typing `YES` to confirm.
- **`hs-unlock`** — reverses Lockdown by making HeartSuite Core Secure files mutable again. This is the counterpart to `hs-activate-lockdown`.
- **`hs-mode-switch`** — change whether HeartSuite Core Secure starts in Setup or Secure Mode on next boot. Used from a Non-HS kernel during recovery. View `--help` for details.

### Maintenance and Backup

- **Maintenance** (`[t]`) — Dashboard screen for guided maintenance workflows. Detects Lockdown status automatically, presents a safety checklist (`[c]`/`[s]`), and guides through mode switching or the 3-step Lockdown maintenance process (`[u]`/`[d]`/`[k]`/`[f]`). Appears only in Secure Mode, Secure+Lockdown, and Non-HS kernel states — hidden in Setup Mode by design.
- **Backup** (`[b]`) — Dashboard screen to manage file backup and versioning. Offers File-first (`[f]`) and Timeline (`[t]`) browse modes, date filtering (`[d]`), batch restore (`[b]`), directory management (`[n]` add, `[r]` remove), and `[tab]` to switch panels.
- **`hs-manage-allowlist`** — CLI tool to browse and edit allowlist entries directly. For advanced workflows and automation. View `--help` for details.

## System and Subscription Tools

- **`activate_HS`** — turns HeartSuite Core Secure service on. The installation routine adds a systemd service that runs this automatically at startup.
- **`hs-cache-size`** — change the maximum number of allowlist entries cached simultaneously. View `--help` for details.
- **`hs-backup-config-manager`** — specify directories for automatic file backup (e.g., /home). Only files in designated directories are backed up when modified. Prefer the Dashboard's Backup screen (`[b]`) for directory management.
- **`hs-curfew`** — stops HeartSuite Core Secure from backing up files before shutdown. A systemd service executes this automatically before shutdown or reboot.
- **`hs-secure-script-launcher-manager`** — configures interpreter names for Secure Script Launchers. View `--help` for details.
- **`hs-activate-subscription`** — activates the server using your HeartSuite Core Secure subscription. Required before Secure Mode can be enabled.
- **`hs-version-manager`** — restore prior versions of backed-up files. Prefer the Dashboard's Backup screen (`[b]`) for version browsing and restoration. View `--help` for details.
- **`hs-unlock-progs`** — switches all HeartSuite Core Secure files back to mutable state (after Lockdown).

## Secure Script Launchers (Phase 3)

Located in `/usr/bin` (in the default PATH):

- **`hs-python-launcher`** — Secure Script Launcher for Python 3
- **`hs-python2-launcher`** — Secure Script Launcher for Python 2
- **`hs-perl-launcher`** — Secure Script Launcher for Perl
- **`hs-php-launcher`** — Secure Script Launcher for PHP

## Python Scripts

Each script displays help information when started without arguments.

- **`hs-os-boot-setup.py`** — used internally by the Installation screen during local installation to scan logs and build allowlist entries for startup programs. Not for direct user invocation.
- **`batch_record_add.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with basic directory access. Prefer the Dashboard review tools for standard workflows.
- **`batch_record_add_read_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with read access to all files. Use with caution. Prefer the Dashboard review tools.
- **`batch_record_add_write_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with write access to all files. Use with extreme caution. Prefer the Dashboard review tools.

## Shell Scripts

These scripts do not include help information.

- **`hs-clear-logs`** — manually clears the HeartSuite Core Secure activity log. In normal operation, the Dashboard auto-clears the log when all review queues are empty, so manual clearing is rarely needed.
- **`init_base_records.sh`** — used by the installation script to add Linux Standard Base (LSB) programs to allowlist entries. Used only once during Part 1 of installation.
- **`HS_startup.sh`** — called by the systemd `heartsuite.service` unit immediately after booting. Activates HeartSuite Core Secure automatically. The Dashboard's Maintenance screen (`[t]`) manages Lockdown re-engagement settings in this script.
