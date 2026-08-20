---
title: "Pipe Lockdown blocks into the SIEM you already run"
linkTitle: "SIEM Integration"
weight: 1
description: "Syslog and webhook into SIEM, EDR, and incident tools. The fleet path when you do not want a Dashboard session on every host."
categories: ["Guides"]
tags: ["heartsuite", "linux", "siem", "fleet", "syslog", "webhook", "monitoring", "alerts", "security"]
toc: true
type: docs
---

**Overview**: Root Lock by HeartSuite integrates with your existing SIEM, EDR, and observability stack via syslog (journald/rsyslog) and webhook. Configure once in Alert Settings → Fleet, and let your central tooling handle monitoring, correlation, and alerting. There is no requirement to run the Dashboard on every host for day-to-day fleet visibility.

Raw **denial** decisions and higher-level alerts are emitted in real time. Successful allowlisted work is not streamed. Incident tools receive the events you configure them to receive.

## Syslog (recommended for SIEM ingestion)

When the Fleet tab **Syslog** switch is on (*Send alerts to /dev/log (LOG_AUTH facility)*), every alert and every kernel **denial** is written to the local journal under identifier `heartsuite`. Successful allowlisted work is not streamed. Alert message text begins with `heartsuite-alert:`.

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

The journal identifier is `heartsuite` on every host. How you ship that identifier is stack-specific: Filebeat journald for Elastic, a universal forwarder or HEC for Splunk, a DSM for QRadar, promtail for Loki. The YAML below is an Elastic example, not a universal ingest path.

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

Enter an HTTPS URL in **Webhook URL (must be HTTPS)** on the Fleet tab. Root Lock posts a JSON payload on every alert (immediate delivery, no batching — let your receiver deduplicate). HTTP (non-TLS) URLs are rejected. When the URL contains `pagerduty.com` or `opsgenie.com`, the matching key field appears and Root Lock posts that vendor's native format instead of the generic payload.

Example generic payload (a Lockdown block):

```json
{
  "node_id":            "prod-web-03",
  "event_type":         "new_program_blocked",
  "timestamp":          "2026-03-31T14:22:00Z",
  "mode":               "Secure Mode",
  "lockdown":           true,
  "tier":               2,
  "paths":              ["/tmp/dropper", "/tmp/payload"],
  "count":              2,
  "message":            "2 previously unseen programs blocked.",
  "subscription":       "Active",
  "total_pending":      2,
  "pending_programs":   2,
  "pending_file_r":     0,
  "pending_file_w":     0,
  "pending_network":    0,
  "enrich_failed":      false
}
```

`mode` is the on-disk token (`"Setup Mode"` or `"Secure Mode"`). The Dashboard label for `"Secure Mode"` is Lockdown. `lockdown` is the seal boolean. `tier` is `1` when you switch Setup Mode or Lockdown, and for allowlist, backup-coverage, and kernel-module config changes. It is `2` for denied programs, files, and network.

Supported targets:

- PagerDuty Events API v2 (routing key field appears for `pagerduty.com` URLs)
- OpsGenie Incoming Webhook (API key field appears for `opsgenie.com` URLs)
- Slack Incoming Webhooks
- Generic HTTPS JSON receivers

Test Webhook (`[w]`) sends a test POST.

## Status JSON (pull-based monitoring)

A passive, always-on snapshot is written every 60 seconds to `~/.cache/heartsuite/status.json`. No Fleet setting turns this on or off.

Fields of particular interest for health checks:

- `mode`, `is_hs_kernel`, `lockdown`, `daemon_ok`, `node_id`
- `pending_*` counts (non-zero in Lockdown usually indicates something needs investigation)
- `channel_errors` (`email`, `syslog`, `webhook`), each with `message` and `at`

Tools that can consume it directly:

- Ansible facts / custom modules over SSH
- Nagios / Icinga / Zabbix (SSH or file checks)
- Any script that `cat`s or `jq`s the file on a schedule

No configuration is required on the Root Lock side.

## Policy and posture data in Elastic and Kibana

In addition to the enforcement and alert streams, Root Lock can emit structured policy and posture data — snapshots of the current allowlist and periodic reports of the host's protection posture. When ingested into Elasticsearch, that data supports views of the allowlist across your fleet.

Use it for:

- Tables of approved programs with their exact file and network grants
- Counts of programs, broad-write risks while locked down, and reporting hosts
- Drift detection by comparing the stable `record_hash` across snapshots
- Filtering for higher-risk entries using `risk_level`, `has_broad_write`, `has_network_grant`, and `lockdown_active_at_capture`

Use the Dashboard for deliberate changes, review queues, and sealing on individual hosts. Use the central view for scanning, filtering, and correlating posture at fleet scale.

### Production path on real hosts

On production hosts, ship enforcement and alert streams via syslog or Filebeat as described above. Ingest into your existing Elasticsearch cluster and build Kibana dashboards with your standard security, retention, and access controls. Alert Settings has no policy-or-posture export switch — Fleet configures syslog and webhook only. No separate HeartSuite download is required for this path.

### `tools/kibana-bridge` (optional evaluation stack)

For lab, evaluation, and customer demos, HeartSuite offers `tools/kibana-bridge/`: an optional disposable Docker stack (Elasticsearch, Kibana, and a small ingest receiver) that turns Root Lock telemetry (`apo_change`, heartbeats, enforcement) into policy-centric Kibana views.

It is **not** installed by `heartsuite-install.sh`. Request an evaluation kit from [support@heartsecsuite.com](mailto:support@heartsecsuite.com) or use the materials included with your coordinated release delivery.

The bridge is a read-only insight plane that complements syslog enforcement streams. It does not replace them and is not required for production. Typical views include:

- A living allowlist table (one row per `program_path` with grant counts, `risk_level`, `has_broad_write`, `has_network_grant`, and related fields).
- KPI-style posture metrics (policy counts, broad-write risk while locked down, high-grant surface, recent blocks).
- Drift detection by comparing stable `record_hash` values across snapshots.
- Enforcement correlation for drill-down alongside policy rows.

The stack is localhost-only, security-disabled, and throwaway (`docker compose down -v` wipes volumes). Do not publish Kibana, Elasticsearch, or the ingest receiver on a public IP without a network perimeter — for example a cloud firewall allowlist of known lab addresses, or an SSH tunnel so the browser reaches only `localhost`.

Use the production path above for real access control, TLS, and retention.

**Versus `tools/siem-test/`:** These are sibling evaluation fixtures with different purposes (both available on request, not on production hosts):

| Fixture | Purpose |
|---|---|
| `tools/siem-test/` | Alert channel validation (syslog, email, webhook). Optional Kibana is for eyeballing raw text events. |
| `tools/kibana-bridge/` | Policy-surface visibility in Kibana (tables, KPIs, risk filters, `record_hash` drift). Uses richer telemetry payloads. |

They can run side by side on the same machine (different ports). Neither fixture is installed to `/.hs/sys` on hosts.

**Quickstart (evaluation):**

```sh
cd tools/kibana-bridge
docker compose up -d
docker compose run --rm setup
# Open http://localhost:5601 (or http://127.0.0.1:5601)
```

After setup, Kibana includes preconfigured data views:

- **HeartSuite Policies** — primary view for the living allowlist table (Lens tables, drift filters).
- **HeartSuite Events** — raw telemetry and event drill-down in Discover.

An optional imported dashboard, **HeartSuite - Policy Overview**, may also be present when saved objects are bundled with your checkout.

To feed live data during lab work, forward syslog or the evaluation-kit telemetry to the bridge ingest receiver, or ingest exported policy data into your production Elasticsearch using the same field model. Setup detail is included in the evaluation kit README shipped with `tools/kibana-bridge/`.

### Pairing with Ansible central policy

The exported policy data model pairs with Ansible (or Terraform/GitOps) central policy: curate one allowlist in your repo, push via the `heartsecurity.root_lock` Ansible role, `batch_record_add.py`, or `hs-manage-allowlist`, and use Kibana tables, KPIs, and `record_hash` for fleet visibility and drift detection.

The bridge (or your production Elasticsearch deployment) is the read side. Your control plane remains the write path.

See [Central Policy Management and External Control](central-policy-management/) for Ansible role variables, seed application, harvest patterns, and composition with full server deployment playbooks.

## Verification commands (run on the HeartSuite host)

```bash
# Recent alerts and enforcement decisions (journal identifier is heartsuite)
journalctl -t heartsuite --since "10 minutes ago"

# Status snapshot (for pull monitors)
cat ~/.cache/heartsuite/status.json | jq .
```

## Relationship to the Dashboard

All channels are configured from the Dashboard: Alerts (`[e]`) opens Alert Settings. The Fleet tab is the place for syslog, webhook, and Setup Mode Alerts. Status JSON is written whenever the alert daemon is running. Email remains available as a supplementary or low-volume channel.

At fleet scale: syslog for the SIEM, webhook for incident response platforms, and Status JSON for infrastructure-as-code health checks. The Dashboard remains the place for initial setup, exception review, and maintenance — not for ongoing fleet monitoring.

Policy management is the inbound complement: your central systems curate and apply allowlists via the shipped CLI tools, pre-seeding, and automation patterns. See [Central Policy Management and External Control](central-policy-management/).

Once at least one push channel is configured, you can proceed to Lockdown.

For the UI configuration steps in detail, see the parent [Alert Settings](.) page.
