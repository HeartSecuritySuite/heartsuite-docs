---
title: "Appendices"
weight: 110
description: "List of included Root Lock by HeartSuite tools."
categories: ["Reference"]
tags: ["heartsuite", "linux", "tools", "executables", "scripts", "reference"]
type: docs
toc: true
---

**Overview**: Root Lock by HeartSuite includes a set of tools for system management, allowlisting, and security enforcement. The Dashboard is where you work day-to-day. Most CLI entries below are run automatically by the system or by the Dashboard, or kept for scripting, recovery, and advanced setup. A normal user does not invoke them directly.

With exception of the Secure Script Launchers, all tools are located in the `/.hs/sys` directory. The Root Lock by HeartSuite installation routine does NOT add this directory to the PATH environment variable. The Secure Script Launchers are located in `/usr/bin` because it is in the default PATH. Programs and scripts that write data to Root Lock by HeartSuite databases must be run as root.

## Day-to-day: Dashboard screens

This is what you use in normal operation. The Dashboard guides you through every phase, and these screens cover the full setup and maintenance workflow.

- **Dashboard** — where you manage Root Lock by HeartSuite. Displays phase progress, pending/denied counts, protection state indicator, status line at the bottom, and Suggested Next Step. Appears automatically on login. Launch manually with `heartsuite`.
- **Programs queue** (`[p]`) — Dashboard screen to review and approve pending program executions (Phase 2). Presents items with full metadata, grouped intelligently.
- **File Access queue** (`[f]`) — Dashboard screen to review and approve pending file accesses (Phase 4). Handles read access and write access approvals separately.
- **Internet Access queue** (`[i]`) — Dashboard screen to review and approve pending internet connections (Phase 5). Allows allowlisting specific IPs per program.
- **Allowed** (`[a]`) — Dashboard screen to browse and edit existing allowlist entries.
- **Browser View** (`[w]`) — Dashboard screen to enable or disable browser-based access to Root Lock by HeartSuite via SSH tunnel.
- **Launchers** (`[s]`) — Dashboard screen to configure Secure Script Launchers (Phase 3).
- **Alert Settings** (`[e]`) — Dashboard screen to configure alert channels (email, syslog, or webhook). At least one channel must be configured before Lockdown activation. See [Alert Settings](../alerts/).
- **Lockdown** (`[l]`) — Dashboard screen for Lockdown activation. Shows precondition checklist, observation period, and review summary. After activation, offers `[r]` Reboot.
- **Maintenance** (`[m]`) — Dashboard screen for guided maintenance workflows. Detects Lockdown status automatically, presents a safety checklist (`[c]`/`[s]`), and guides through mode switching or the 3-step Lockdown maintenance process (`[u]`/`[d]`/`[k]`/`[f]`). Appears only in Lockdown, Lockdown+sealed, and Non-HS kernel states — hidden in Setup Mode by design.
- **Backup** (`[b]`) — Dashboard screen to manage file backup and versioning. Offers File-first (`[f]`) and Timeline (`[t]`) browse modes, date filtering (`[d]`), batch restore (`[b]`), directory management (`[n]` add, `[r]` remove), and `[tab]` to switch panels.

## Lockdown scripts

These run automatically when you engage or unlock Lockdown via the Dashboard. You do not need to invoke or edit them yourself.

- **`HS_lockdown.sh`** — runs when you press `[l]` Lockdown → `[r]` Reboot, and again automatically on every boot. It seals Root Lock by HeartSuite's configuration so it can't be changed while the HS kernel is running, disables common file editors (`nano`, `vim`, `sed`, `ed`), replaces `rm`, `cp`, and `mv` with restricted copies whose write scope matches what the kernel saw those tools used for during Setup Mode, then engages Lockdown. Deployments where kmod is allowlisted should also complete the steps in [Restricting Kernel Module Loading](../maintenance/kmod-hardening/) before engaging Lockdown for the first time.
- **`HS_unlock.sh`** — reverses `HS_lockdown.sh` — it re-enables changes to Root Lock by HeartSuite's configuration, restores the file editors, and restores `rm`, `cp`, and `mv` to their full versions. The Maintenance runs this for you when you press `[u]` as part of removing the Lockdown seal. Invoke it yourself only if you need recovery outside the Dashboard.

## Recovery & scripting CLI

For scripting, automation, and recovery scenarios. UI users rarely need these — most have a Dashboard equivalent that handles them automatically.

- **`hs-manage-allowlist`** — CLI tool to browse and edit allowlist entries directly. For advanced workflows and automation. View `--help` for details.
- **`hs-mode-switch`** — change whether Root Lock by HeartSuite starts in Setup or Lockdown on next boot. The Dashboard's Lockdown button (`[l]`) handles this for normal use; this CLI is for scripting and automation. View `--help` for details.
- **`hs-cache-size`** — set the kernel allowlist cache size (10–255). The Dashboard auto-adjusts this on every refresh; see [Adjusting the Cache Size](../maintenance/cache-adjustment/). Use the CLI only for scripting and automation.
- **`hs-activate-subscription`** — activates the server using your Root Lock by HeartSuite subscription. Required before Lockdown can be activated.
- **`hs-backup-config-manager`** — specify directories for automatic file backup (e.g., /home). Only files in designated directories are backed up when modified. Prefer the Dashboard's Backup (`[b]`) for directory management.
- **`hs-version-manager`** — restore prior versions of backed-up files. Prefer the Dashboard's Backup (`[b]`) for version browsing and restoration. View `--help` for details.
- **`hs-secure-script-launcher-manager`** — configures interpreter names for Secure Script Launchers. Prefer the Dashboard's Launchers (`[s]`) for normal use. View `--help` for scripting details.
- **`hs-clear-logs`** — manually clears the Root Lock by HeartSuite activity log. In normal operation, the Dashboard auto-clears the log when all review queues are empty, so manual clearing is rarely needed.

## Internal / automatic

These run on their own — you do not need to invoke them yourself.

- **`activate_HS`** — turns Root Lock by HeartSuite service on. The installation routine adds a systemd service that runs this automatically at startup.
- **`hs-curfew`** — stops Root Lock by HeartSuite from backing up files before shutdown. A systemd service executes this automatically before shutdown or reboot.
- **`hs-unlock-progs`** — runs automatically as part of `HS_unlock.sh`. Not invoked directly in normal use.
- **`hs-os-boot-setup.py`** — used internally by Installation during local installation to scan logs and build allowlist entries for startup programs. Not for direct user invocation.
- **`init_base_records.sh`** — used by the installation script to add Linux Standard Base (LSB) programs to allowlist entries. Used only once during Part 1 of installation.
- **`HS_startup.sh`** — runs automatically when the system boots, turning Root Lock by HeartSuite on. The Dashboard's Maintenance (`[m]`) edits this file when you change Lockdown re-engagement settings.

## Legacy / scripted deployment only

Off the user path. Prefer the Dashboard review tools for any standard workflow.

- **`batch_record_add.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with basic directory access. Prefer the Dashboard review tools for standard workflows.
- **`batch_record_add_read_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with read access to all files. Use with caution. Prefer the Dashboard review tools.
- **`batch_record_add_write_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with write access to all files. Use with extreme caution. Prefer the Dashboard review tools.

## Secure Script Launchers (Phase 3)

Located in `/usr/bin` (in the default PATH). Configured via the Dashboard's Launchers (`[s]`).

- **`hs-python-launcher`** — Secure Script Launcher for Python 3
- **`hs-python2-launcher`** — Secure Script Launcher for Python 2
- **`hs-perl-launcher`** — Secure Script Launcher for Perl
- **`hs-php-launcher`** — Secure Script Launcher for PHP

## Log files

These files are written automatically by Root Lock by HeartSuite. They are not tools and require no user invocation.

- **`/.hs/sys/HS_log.txt`** — the on-device activity log. Records program executions, file accesses, and network connection attempts observed during Setup Mode. The Dashboard auto-clears this log when all review queues are empty; `hs-clear-logs` clears it manually. Not retained across maintenance cycles.
- **`/var/log/heartsuite/install.log`** — written by the installer during updates. Records the steps and outcome of each update bundle application.
- **Dedicated JSONL approval log** — persistent record of every allowlist approval action (programs, file paths, network destinations). Each entry includes timestamp, uid, and tty for attribution. This is the primary machine-readable change log for compliance and audit reconstruction.
- **`/var/log/heartsuite/ui.log`** — the rotating application audit log. Captures UI interactions, core events, and errors. Size-capped at approximately 8 MB with automatic rotation; no time-based retention policy.
- **Syslog streams (RFC 5424)** — two real-time streams under the `heartsuite` APP-NAME: a per-decision enforcement stream (one record per kernel allow/deny decision for execution, file access, and network) and a higher-level alert stream (aggregated events such as `new_program_blocked`). Both are delivered to `/dev/log` and are the recommended path for SIEM ingestion (Splunk, Elastic, Datadog, QRadar, etc.). A single rsyslog rule can forward the `heartsuite` ident. See [SIEM and Fleet Integration](../alerts/siem-integration/) for production configuration examples and guidance.
- **`~/.cache/heartsuite/status.json`** — system status snapshot updated every 60 seconds. Read-only; used by Ansible, Nagios, Zabbix, and similar tools for automated health checks. Not a log — does not accumulate history.

  | Field | Type | Notes |
  |---|---|---|
  | `node_id` | string | Configured host identifier |
  | `mode` | string | `"Lockdown"`, `"Setup Mode"`, or `"Unknown"` |
  | `is_hs_kernel` | bool | Whether the running kernel is the HeartSuite kernel |
  | `lockdown` | bool | Whether Lockdown is currently active |
  | `lockdown_on_boot` | bool \| null | Lockdown re-engagement setting; null if unset |
  | `pending_programs` | int | Programmes awaiting review |
  | `pending_files` | int | Sum of pending read + pending write entries |
  | `pending_network` | int | Network destinations awaiting review |
  | `last_alert_at` | string | ISO 8601 UTC timestamp of last alert, or empty string |
  | `updated_at` | string | ISO 8601 UTC timestamp of last daemon write |
  | `daemon_ok` | bool | Whether the HeartSuite daemon is running normally |
  | `channel_errors` | object | Optional — present only when a delivery error has occurred |
  | └ `email.message` / `email.at` | string | Last email delivery error and its timestamp |
  | └ `syslog.message` / `syslog.at` | string | Last syslog delivery error and its timestamp |
  | └ `webhook.message` / `webhook.at` | string | Last webhook delivery error and its timestamp |

  For monitoring integrations, `lockdown`, `is_hs_kernel`, and `daemon_ok` are the three fields that together confirm a healthy Lockdown state.

## Integration tooling (evaluation and fleet automation)

Production hosts use the installed bundle: CLI tools under `/.hs/sys`, the `limited_tools` Python API under `/opt/heartsuite`, syslog, and `status.json`. The items below are **not** installed by `heartsuite-install.sh`; they are available with coordinated release materials or on request for evaluation and fleet automation work.

- **`heartsecurity.root_lock` Ansible role** — declarative fleet policy application and Lockdown transitions (modelled on `linux-system-roles.selinux`). See [Central Policy Management and External Control](../alerts/central-policy-management/#official-ansible-role-heartsecurityroot_lock). Request the role package from [support@heartsecsuite.com](mailto:support@heartsecsuite.com) if it is not already in your delivery.
- **`tools/kibana-bridge/`** — optional disposable Docker stack for policy-centric Kibana views during lab evaluation (living allowlist table, KPIs, risk signals, `record_hash` drift). Complements syslog enforcement streams; not required for production. See [SIEM and Fleet Integration](../alerts/siem-integration/#toolskibana-bridge-optional-evaluation-stack). Available on request for evaluation kits.

## Kernel CVE coverage

For CVE status entries with full technical rationale and scanner guidance, see [Kernel Security Transparency](../security/).
