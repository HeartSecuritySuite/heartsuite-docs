---
title: "Alert Configuration"
weight: 70
description: "Configuring push alert channels for blocks and state changes in Secure Mode."
categories: ["Guides"]
tags: ["heartsuite", "linux", "alerts", "email", "syslog", "webhook", "security", "notifications"]
toc: true
type: docs
---

**Overview**: In Secure Mode, blocks happen whether or not anyone is connected to the Dashboard — without alerts, a blocked program fails silently. Alerts notify you of blocks and state changes the moment they happen. On a stable system with a complete allowlist, alerts are rare — most weeks you may receive none at all. An alert means something genuinely unexpected happened.

> [!SCREENSHOT]
> **Screenshot needed**: Alert Settings screen (`[e]`) — show the Email tab in a configured state: Node ID filled, SMTP fields populated, password shown as `(set)`, Save and Test buttons visible. A second frame showing the Fleet tab with Syslog toggled on and the Webhook field populated would be valuable.

## Alerts vs. the Dashboard

Alerts are a push channel for blocks and state changes that warrant immediate attention. They are not a secondary log stream and not a replacement for the Dashboard.

Alerts are suppressed entirely in Setup Mode. Setup Mode is a high-volume observation phase — logging everything without blocking. Alerting during this phase would produce constant noise before the allowlist is complete. Alerts become active only when Secure Mode is enabled.

## Configuring Alerts

From the Dashboard, select the Alert Settings screen (`[e]`). The screen has two tabs: **Email** and **Fleet**.

### Email Tab

Configure SMTP credentials to receive email alerts directly. Required fields:

- **Node ID** — defaults to the system hostname; set a recognisable identifier (e.g., `prod-web-03`) so email subjects immediately identify the source machine when managing multiple servers
- **SMTP server** and **Port** (default 587)
- **Sender** and **Recipient** addresses
- **Password** (masked on entry; never displayed after saving)

Select Save to store the configuration. HeartSuite Core Secure validates all fields but does not attempt a live connection at save time. Select Test to send a test email — this is the only moment where SMTP connectivity is verified. If the test fails, the exact SMTP error code is shown:

```text
Test email failed: [535 Authentication credentials invalid]

Check your credentials and try again. No alerts have been sent.
```

Once configured, the tab shows current settings with the password displayed as `(set)`. Select Edit to modify — the password field is always blank when editing. You must re-enter the password to prevent credentials from appearing in the terminal scroll buffer.

### Fleet Tab

Configure syslog and webhook delivery for fleet and SIEM integrations. All channels are independent — enable any combination.

**Syslog** — A toggle (Enabled/Disabled). When enabled, HeartSuite Core Secure writes all alerts to the system log via `/dev/log`, using the `heartsuite-alert` ident, `LOG_AUTH` facility, and `LOG_WARNING` severity. No additional configuration is needed on the HeartSuite Core Secure node. After enabling, the Alert Settings screen provides an rsyslog forwarding rule example for your SIEM.

Verify syslog delivery with:

```bash
journalctl -t heartsuite-alert --since "1 minute ago"
```

To forward to a SIEM, configure an rsyslog output rule in `/etc/rsyslog.d/heartsuite.conf`. See the [rsyslog omfwd forwarding module documentation](https://www.rsyslog.com/doc/configuration/modules/omfwd.html) for forwarding syntax, and your SIEM's own documentation for the receiving end:

- [Splunk — Get data from TCP and UDP ports](https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitornetworkports)
- [Elastic — Filebeat syslog input](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-syslog.html)

**Webhook** — Enter an HTTPS URL. HeartSuite Core Secure POSTs a JSON payload to this URL on every alert. HTTP (non-TLS) URLs are rejected. Example payload:

```json
{
  "node_id":    "prod-web-03",
  "event_type": "new_program_blocked",
  "timestamp":  "2026-03-31T14:22:00Z",
  "mode":       "Secure Mode",
  "lockdown":   false,
  "paths":      ["/tmp/dropper", "/tmp/payload"],
  "count":      2
}
```

To receive this payload, create an integration in your incident management tool and paste the endpoint URL into the Webhook field:

- [PagerDuty — Events API v2](https://developer.pagerduty.com/api-reference/f80f5db9acbe3-pager-duty-v2-events-api)
- [OpsGenie — Incoming webhook integration](https://support.atlassian.com/opsgenie/docs/integrate-opsgenie-with-webhook/)
- [Slack — Incoming webhooks](https://api.slack.com/incoming-webhooks)

**Status JSON** — A passive monitoring surface at `/.hs/sys/hs-status.json`, updated every 60 seconds. Ansible, Nagios, and [Zabbix](https://www.zabbix.com/documentation/current/en/manual/config/items/itemtypes/ssh_checks) can read this file via SSH pull. No configuration required — always active when the alert daemon is running. This is read-only; it does not push notifications.

> [!TIP]
> At fleet scale, syslog is the primary integration path: enable syslog on all nodes, forward via rsyslog to your SIEM, and alert centrally from the SIEM's own rule engine. Webhook covers incident management tools (PagerDuty, OpsGenie). Status JSON covers Ansible health checks. Email is for single-machine deployments or as a supplementary channel.

When Phase 6 is complete — at least one push channel configured — the Dashboard marks Phase 6 as complete and unlocks Phase 7 (Secure Mode).

## What Triggers an Alert

### Administrative State Changes

These alerts fire immediately on every configured channel, regardless of accumulation windows or digest mode:

| Alert | When it fires |
|-------|---------------|
| Mode switch (Setup → Secure or Secure → Setup) | Immediately on mode change |
| Lockdown activated or deactivated | Immediately on state change |
| New allowlist file pushed while Lockdown is active | On detection |

### Blocks in Secure Mode

These blocks apply a threshold filter and are active in Secure Mode only:

| Block | Trigger condition |
|-------|------------------|
| Previously unseen program blocked | A program path appears in the denial log that has never appeared in any prior log session |
| Network burst to new destinations | A single program generates blocked connections to previously unseen destinations within a 2-hour window |
| Critical file version created outside maintenance | A new backup version is created for a file under `/etc/`, `/bin/`, `/usr/bin/`, `/sbin/`, `/lib/`, or `/usr/lib/` while in Secure Mode with no maintenance window open |

**Never alerted under any circumstances:**

- Anything in Setup Mode
- Repeated blocks of the same program–destination pair already seen in the current session
- File version activity under `/tmp/`, `/var/tmp/`, or `/dev/shm/`
- Dashboard sessions opened or closed
- Successful allowlist approvals

## How Alerts Are Delivered

### Email — 5-Minute Accumulation Window

Blocks are grouped before delivery. A dropper that installs 40 payloads in 90 seconds produces one email — *"40 previously unseen programs blocked in 90 seconds"* — not 40 individual messages. Volume and velocity are the attack signal; 40 separate emails fragment that signal into noise.

- The 5-minute window starts on the first block of a given type
- Additional blocks of the same type within that window are added to the pending bundle
- At window close, one email is dispatched covering all accumulated blocks
- Blocks of different types accumulate independently — a network burst does not delay a file modification alert

**Digest mode:** If more than 3 block alerts are dispatched within a single hour, HeartSuite Core Secure switches to digest mode for the remainder of that hour. All further blocks are queued and delivered as one digest email at the hour's end. Administrative state changes are never held — mode switches and lockdown changes are always delivered immediately.

The 5-minute window and hourly cap are fixed, not user-configurable.

### Syslog and Webhook — Immediate

Syslog and webhook emit every alert immediately, without grouping or windowing. SIEM platforms (Splunk, Elastic) and incident management tools (PagerDuty, OpsGenie) apply their own correlation and deduplication — grouping alerts before they reach these systems removes information they need.

> [!NOTE]
> Alerts begin flowing only after Secure Mode is activated. If a configured channel appears silent during Setup Mode, that is expected — not a misconfiguration.
