---
title: "SIEM and Fleet Integration"
weight: 75
description: "Connect Root Lock by HeartSuite to your existing SIEM, observability platforms, and incident management tools. The recommended scale path for teams managing many servers without per-host TUI toil."
categories: ["Guides"]
tags: ["heartsuite", "linux", "siem", "fleet", "syslog", "webhook", "monitoring", "alerts", "security"]
toc: true
type: docs
---

**Overview**: Root Lock by HeartSuite integrates with your existing SIEM, EDR, and observability stack via syslog (journald/rsyslog) and webhook. This is the scale path for larger teams: configure once (in the Dashboard under Alert Settings → Fleet tab) and let your central tooling handle monitoring, correlation, and alerting. There is no requirement to run the TUI on every host for day-to-day fleet visibility.

The raw enforcement decisions and higher-level alerts are emitted in real time. SIEM platforms receive the full picture; incident tools receive actionable events.

## Syslog (recommended for SIEM ingestion)

When the Fleet tab "Syslog" toggle is enabled, every alert and every kernel-level enforcement decision is written to the local journal (ident `heartsuite` / `heartsuite-alert`).

**Filebeat / Elastic (or any rsyslog-compatible shipper)**

```yaml
# filebeat-heartsuite.yml (adapt to your existing stack)
filebeat.inputs:
  - type: journald
    id: heartsuite-enforcement
    include_matches:
      - "SYSLOG_IDENTIFIER=heartsuite"
output.elasticsearch:
  hosts: ["https://your-elastic:9200"]
  # username, password, ssl.* etc. from your existing config
logging.level: warning
```

One ingest configuration works for Splunk, QRadar, Graylog, Loki (via promtail), etc. Both the per-decision enforcement stream and the aggregated alert events flow under the same tag.

Pre-flight check on the host:

```bash
filebeat test config && filebeat test output
```

**Direct rsyslog forwarding**

Create `/etc/rsyslog.d/heartsuite.conf`:

```
:programname, isequal, "heartsuite" @@your-siem-host:514
# Use @ for UDP or the TLS modules for production
```

Then:

```bash
sudo systemctl restart rsyslog
journalctl -t heartsuite --since "1 minute ago"
```

## Webhook (for PagerDuty, OpsGenie, Slack, etc.)

Enter a valid HTTPS URL in the Fleet tab. HeartSuite posts a compact JSON payload on every alert (immediate delivery, no batching on our side — let your receiver deduplicate).

Example payload:

```json
{
  "node_id":    "prod-web-03",
  "event_type": "new_program_blocked",
  "timestamp":  "2026-03-31T14:22:00Z",
  "mode":       "Lockdown",
  "lockdown":   true,
  "paths":      ["/tmp/dropper", "/tmp/payload"],
  "count":      2
}
```

Supported targets (paste the URL and any required key into the Fleet tab):

- PagerDuty Events API v2
- OpsGenie Incoming Webhook
- Slack Incoming Webhooks
- Generic HTTPS JSON receivers

Use the "Test Webhook" button in the UI to validate delivery.

## Status JSON (pull-based monitoring)

A passive, always-on snapshot is written every 60 seconds to `~/.cache/heartsuite/status.json` (world-readable when the alert daemon runs).

Fields of particular interest for health checks:

- `mode`, `is_hs_kernel`, `lockdown`, `daemon_ok`
- `pending_*` counts (non-zero in Lockdown usually indicates something needs investigation)
- Per-channel `last_*_error` objects

Tools that can consume it directly:

- Ansible facts / custom modules over SSH
- Nagios / Icinga / Zabbix (SSH or file checks)
- Any script that `cat`s or `jq`s the file on a schedule

No configuration is required on the HeartSuite side.

## Verification commands (run on the HeartSuite host)

```bash
# Recent alerts and enforcement decisions
journalctl -t heartsuite --since "10 minutes ago"
journalctl -t heartsuite-alert --since "10 minutes ago"

# Status snapshot (for pull monitors)
cat ~/.cache/heartsuite/status.json | jq .
```

## Relationship to the Dashboard

All channels are configured in the single Alert Settings screen (`[e]`). The "Fleet" tab is the central place for SIEM/webhook/syslog + status. Email remains available as a supplementary or low-volume channel.

At fleet scale the recommendation is clear: syslog for the SIEM, webhook for incident response platforms, and Status JSON for infrastructure-as-code health checks. The Dashboard remains the place for initial setup, exception review, and maintenance — not for ongoing fleet monitoring.

Once at least one push channel is configured, Phase 6 (Alert Configuration) is complete and you can proceed to Lockdown.

For the UI configuration steps in detail, see the parent [Alert Settings](.) page.
