---
title: "Tools shipped with Root Lock"
linkTitle: "Appendices"
weight: 110
description: "CLI tools included with Root Lock by HeartSuite. Which ones the Dashboard runs for you, and which ones you run yourself."
categories: ["Reference"]
tags: ["heartsuite", "linux", "tools", "executables", "scripts", "reference"]
type: docs
toc: true
---

**Overview**: Root Lock by HeartSuite includes a set of tools for system management, allowlisting, and security. The Dashboard is where you work day-to-day. Most CLI entries below are run automatically by the Dashboard, or kept for scripting, recovery, and advanced setup.

Except for the Secure Script Launchers, all tools are located in `/.hs/sys`. The installer does not add this directory to `PATH`. The Secure Script Launchers are in `/usr/bin` because it is in the default `PATH`. Programs and scripts that write data to Root Lock databases must be run as root.

## Day-to-day

The Dashboard guides you through the Lockdown Checklist. These are the main views you use in normal operation.

- **Dashboard** — manages Root Lock. Displays the Lockdown Checklist, pending and denied counts, the protection state indicator, the status line at the bottom, and the Suggested Next Step. Appears automatically on login. Launch it manually with `heartsuite`.
- **Programs queue** (`[p]`) — review and approve pending program executions from the Dashboard. Presents items with full metadata, grouped intelligently.
- **File Access queue** (`[f]`) — review and approve pending file accesses from the Dashboard. Handles read access and write access approvals separately.
- **Internet Access queue** (`[i]`) — review and approve pending internet connections from the Dashboard. Allows allowlisting specific IPs per program.
- **Allowed** (`[a]`) — browse and edit existing allowlist entries from the Dashboard.
- **Launchers** (`[s]`) — configure Secure Script Launchers from the Dashboard. Hidden once Lockdown is applied.
- **Alert Settings** (`[e]`) — configure alert channels (email, syslog, or webhook) from the Dashboard. At least one channel must be configured before Lockdown activation. Hidden once Lockdown is applied. See [Alert Settings](../alerts/).
- **Lockdown** (`[l]`) — in Setup Mode, open Lockdown from the Dashboard. Shows the precondition checklist, observation period summary, and allowlist review. Type `YES` (case-sensitive) to start a probe reboot; a second reboot applies the seal. In Lockdown, the same key opens the read-only Lockdown Inventory. See [Lockdown](../mode-switching/) for the activation flow.
- **Maintenance** (`[m]`) — guided maintenance from the Dashboard. After Lockdown, sends you to the console to select **Maintenance: unseal and return to Root Lock**; the seal lifts automatically and the machine returns in Setup Mode. If the strip already says Lockdown not applied, Maintenance offers a `YES` switch that stays on the Root Lock kernel. Safety checklist is `[c]` / `[s]`. Grid button in Lockdown; keyboard `[m]` also works in Setup Mode after you unseal. See [Protecting During Maintenance](../maintenance/protecting-during-maintenance/).
- **Backup** (`[b]`) — manage file backup and versioning from the Dashboard. Configure vs Restore tabs. Add a directory (`[a]`), Remove from backup (`[r]`). Restore: File-first (`[f]`), Timeline (`[t]`), date filter (`[d]`), batch restore (`[b]`). `[n]` is Cancel.
- **About** (`[o]`) — product and build identity from the Dashboard.

## Lockdown scripts

These run automatically when you engage or unlock Lockdown via the Dashboard. You do not need to invoke or edit them yourself.

- **`HS_lockdown.sh`** — runs when Lockdown is applied, and again automatically on every Root Lock kernel boot after that. It seals Root Lock's configuration so it can't be changed while the Root Lock kernel is running, disables common file editors (`nano`, `vim`, `sed`, `ed`), seals the restricted `rm`/`cp`/`mv` copies, then engages Lockdown. Deployments where kmod is allowlisted should also complete the steps in [Restricting Kernel Module Loading](../maintenance/kmod-hardening/) before engaging Lockdown for the first time.
- **`HS_unlock.sh`** — reverses `HS_lockdown.sh` — it re-enables changes to Root Lock's configuration, restores the file editors, and restores `rm`, `cp`, and `mv` to their full versions. Maintenance runs this for you on the console unseal path. Invoke it yourself only if you need recovery outside the Dashboard.

## Recovery & scripting CLI

For scripting, automation, and recovery scenarios. UI users rarely need these — most have a Dashboard equivalent that handles them automatically.

- **`hs-app-perm-orders-manager`** — CLI tool to browse and edit allowlist entries (`/.hs/sys/hs-app-perm-orders-manager`; that directory is not on `PATH`). House name in some docs: `hs-manage-allowlist`. For advanced workflows and automation. View `--help` for details.
- **`hs-monitor-state`** — on-disk binary that sets Setup Mode or Lockdown on next boot (`/.hs/sys/hs-monitor-state`). The Dashboard Lockdown button (`[l]`) is the normal path. There is no `hs-mode-switch` file on a current install.
- **`hs-cache-size`** — glossary name for the kernel allowlist cache size (10–255). On disk the binary is `/.hs/sys/hs-APO-cache-size`. The cache is an LRU window, not a program cap. The Dashboard auto-expands it on every refresh; see [Adjusting the Cache Size](../maintenance/cache-adjustment/). Use the CLI only for scripting and automation.
- **`register_HS_license`** — activates the server using your Root Lock subscription (`/.hs/sys/register_HS_license`). Some Dashboard copy still prints the house name `hs-activate-subscription`. Required before Lockdown can be activated.
- **`hs-backup-config-manager`** — specify directories for automatic file backup (`list`, `add -d <path>`, `del -d <path>`). Only files in designated directories are backed up when modified. Prefer the Dashboard's Backup (`[b]`) for directory management.
- **`hs-version-manager`** — restore prior versions of backed-up files (`list`, `versions`, `replace <path> <token>`). Prefer the Dashboard's Backup (`[b]`) for version browsing and restoration. View `--help` for details.
- **`hs-shim-manager`** — configures interpreter names for Secure Script Launchers (`/.hs/sys/hs-shim-manager`). House name: `hs-secure-script-launcher-manager`. Prefer the Dashboard's Launchers (`[s]`) for normal use. View `--help` for scripting details.
- **`empty_HS_log.sh`** — clears `/.hs/sys/HS_log.txt`. The Dashboard does this when queues drain in Setup Mode. There is no `hs-clear-logs` binary.

## Internal / automatic

These run on their own — you do not need to invoke them yourself.

- **`activate_HS`** — turns Root Lock service on. The installation routine adds a systemd service that runs this automatically at startup.
- **`hs-curfew`** — stops Root Lock from backing up files before shutdown. A systemd service executes this automatically before shutdown or reboot.
- **`hs-unlock-progs`** — runs automatically as part of `HS_unlock.sh`. Not invoked directly in normal use.
- **`add_logged_permissions.py` / `add_start_and_shutdown_programs.py`** — used internally during local installation to scan logs and build allowlist entries for startup programs. Not for direct user invocation. There is no `hs-os-boot-setup.py` on a current install.
- **`init_base_records.sh`** — used by the installation script to add Linux Standard Base (LSB) programs to allowlist entries. Used only once during Part 1 of installation.
- **`HS_startup.sh`** — runs automatically when the system boots, turning Root Lock on. On the maintenance kernel it also lifts the immutable seal before express return.

## Legacy / scripted deployment only

Off the user path. Prefer the Dashboard review tools for any standard workflow.

- **`batch_record_add.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with basic directory access. Prefer the Dashboard review tools for standard workflows.
- **`batch_record_add_read_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with read access to all files. Use with caution. Prefer the Dashboard review tools.
- **`batch_record_add_write_all.py`** — (legacy/advanced) adds programs listed in a file to allowlist entries with write access to all files. Use with extreme caution. Prefer the Dashboard review tools.

## Secure Script Launchers

Installed in `/usr/bin` (in the default PATH). Configured via the Dashboard's Launchers (`[s]`). Four launchers ship; there is no Java launcher.

| On disk | House name | Interpreter |
|---|---|---|
| `hs_python3` | `hs-python-launcher` | Python 3 |
| `hs_python2` | `hs-python2-launcher` | Python 2 |
| `hs_perl` | `hs-perl-launcher` | Perl |
| `hs_php` | `hs-php-launcher` | PHP |

## Log files

These files are written automatically by Root Lock. They are not tools and require no user invocation. Day-to-day you use the Dashboard review queues, not these paths.

Three cloud surfaces are not the same thing:

- **Serial console** (EC2 Serial Console, Linode LISH, Hetzner, Azure Serial Console, GCP serial, and others) — interactive `cat` of local files. The serial console (ttyS0) has root autologin.
- **Get system log** (AWS) — a buffered serial snapshot in the provider console. It is not CloudWatch.
- **CloudWatch / Cloud Logging / Log Analytics** — the **platform** logging agent plus IAM. Root Lock does not install that agent. On AWS, if the CloudWatch agent is already present at install, Root Lock may drop a collect config for `/var/log/heartsuite/`. You still attach the instance role. `/.hs/sys/HS_log.txt` is not in that collect list.

- **`/.hs/sys/HS_log.txt`** — temporary denial buffer (plus a few activation lines), not a success audit. Cleared in Setup Mode when the review queues are empty and Secure Script Launchers is not still pending; also cleared on a maintenance reboot; rotated in place at about 32 MiB. Forwarded to journald as ident `heartsuite` **only** when Syslog is enabled on Alert Settings → Fleet.
- **`/var/log/heartsuite/install.log`** — installer bundle output, persisted on every install persist for serial recovery. On AWS, recent serial output is also on **Actions > Monitor and troubleshoot > Get system log**.
- **`/var/log/heartsuite/allowlist-audit.log`** — JSONL of allowlist **approvals** (timestamp, uid, tty). Rotates at 1 MB and keeps one `.1` copy. Not under `~/.local/share/heartsuite/`.
- **`/var/log/heartsuite/ui.log`** — rotating Python application log (INFO and above). Size-capped at about 8 MB. Not a keystroke transcript.
- **`/var/log/heartsuite/dropped_violations.log`** — denials that were already allowlisted and therefore dropped from the review queues. Advanced artifact, not a daily surface.
- **Initial setup logs** (`/var/log/heartsuite/initial-setup-*.log`) — per-iteration output from the boot setup chain (some leftover `phase1-step-N.log` names may remain on disk).
- **Syslog streams (RFC 5424)** — denial lines and aggregated alerts under ident `heartsuite`, after you enable the Fleet Syslog toggle. Alert lines use the message prefix `heartsuite-alert:`; that is not a second `journalctl -t` tag. See [SIEM and Fleet Integration](../alerts/siem-integration/).
- **`~/.cache/heartsuite/status.json`** — system status snapshot (not a log).

  | Field | Type | Notes |
  |---|---|---|
  | `node_id` | string | Configured host identifier |
  | `mode` | string | `"Secure Mode"`, `"Setup Mode"`, or `"Unknown"`. `"Secure Mode"` is the on-disk token; the Dashboard and email copy say **Lockdown**. |
  | `is_hs_kernel` | bool \| null | Whether the running kernel is the Root Lock kernel. `null` if the daemon did not observe the host this cycle. |
  | `lockdown` | bool \| null | Whether the immutable seal is currently applied. Separate from `mode`. |
  | `lockdown_on_boot` | bool \| null | Whether Lockdown re-engages on the next Root Lock boot |
  | `pending_programs` | int \| null | Programs awaiting review |
  | `pending_files` | int \| null | Sum of pending read + pending write entries |
  | `pending_network` | int \| null | Network destinations awaiting review |
  | `fully_protected` | bool \| null | True when `mode` is `"Secure Mode"` and the seal is applied |
  | `subscription` | string \| null | `"Active"` or `"Expired"` |
  | `version` | string | Build identity |
  | `last_alert_at` | string | ISO 8601 UTC timestamp of last alert, or empty string |
  | `updated_at` | string | ISO 8601 UTC timestamp of last daemon write |
  | `daemon_ok` | bool | Whether the HeartSuite daemon is running normally |
  | `channel_errors` | object | Present when the daemon writes an `AlertState` (includes empty strings when healthy) |
  | └ `email.message` / `email.at` | string | Last email delivery error and its timestamp |
  | └ `syslog.message` / `syslog.at` | string | Last syslog delivery error and its timestamp |
  | └ `webhook.message` / `webhook.at` | string | Last webhook delivery error and its timestamp |

  For monitoring integrations, `lockdown`, `is_hs_kernel`, and `daemon_ok` are the three fields that together confirm a healthy Lockdown state. Treat `"Secure Mode"` plus `lockdown: true` as the sealed Lockdown posture.

## Integration tooling (evaluation and fleet automation)

Production hosts use the installed bundle: CLI tools under `/.hs/sys`, the `limited_tools` Python API under `/opt/heartsuite`, syslog, and `status.json`. The items below are **not** installed by `heartsuite-install.sh`; they are available with coordinated release materials or on request.

- **`heartsecurity.root_lock` Ansible role** — declarative post-install management of allowlist programs and mode/Lockdown transitions (modelled on `linux-system-roles.selinux`). The role assumes Root Lock is already installed. Full server provisioning is handled by thin orchestrator playbooks that compose this role. See [Central Policy Management and External Control](../alerts/central-policy-management/#official-ansible-role-heartsecurityroot_lock) and `ansible/examples/hs-debian12-provision/`. Request the role package from [support@heartsecsuite.com](mailto:support@heartsecsuite.com) if it is not already in your delivery.
- **`tools/kibana-bridge/`** — optional disposable Docker stack for policy-centric Kibana views during lab evaluation (living allowlist table, KPIs, risk signals, `record_hash` drift). Complements syslog enforcement streams; not required for production. Security-disabled and intended for localhost or a tightly perimeter-controlled lab only — see [SIEM and Fleet Integration](../alerts/siem-integration/#toolskibana-bridge-optional-evaluation-stack).

## Kernel CVE coverage

For CVE status entries with full technical rationale and scanner guidance, see [Kernel Security Transparency](../security/).
