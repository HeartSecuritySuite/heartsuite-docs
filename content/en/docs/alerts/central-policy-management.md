---
title: "Central Policy Management and External Control"
linkTitle: "Central Policy"
weight: 2
description: "Drive allowlist policy from your existing enterprise control planes (Ansible, Terraform, ServiceNow, and custom automation) and consume rich export data for central visibility and auditing at fleet scale. The recommended path for teams that own policy in their own tooling."
categories: ["Guides"]
tags: ["heartsuite", "linux", "policy", "fleet", "ansible", "terraform", "servicenow", "automation", "central", "alerts", "siem", "security"]
toc: true
type: docs
---

**Overview**: HeartSuite is designed to be driven by your existing central tooling. The Dashboard is the operator experience for a single host; enterprises use their control planes to manage policy and observe at scale.

There is no built-in multi-host push from a HeartSuite server. Each host enforces its own allowlist, and Lockdown seals that allowlist on the device. Policy is applied per-host by your automation, with rich export surfaces for central consumption and attribution. This model lets you keep ownership of policy curation, change approval, and fleet-wide visibility inside the tools you already run (Ansible, Terraform, GitOps repositories, ServiceNow, Splunk, Elastic, custom orchestration).

The subscription activation step that enables Lockdown remains a per-host entitlement check. The content of the policy itself can be fully external.

## Policy curation in your central systems

A central system (CMDB, Git repository as source of truth, ITSM workflow, or custom script) owns the authoritative list of approved programs, file-access paths, and network destinations.

- Generate or maintain policy as simple text lists (one absolute program path per line) or structured data that your automation can parse.
- Curate changes through your normal processes: code review in Git, change tickets in ServiceNow, or policy-as-code pipelines.
- For homogeneous fleets or golden images, pre-seed a known-good baseline allowlist at install or first boot. This accelerates onboarding compared to pure observation on every host.
- For varied or custom workloads, allow an initial observation window in Setup Mode on a representative host, harvest the resulting allowlist entries, review them centrally, and then push the approved set to the rest of the fleet.

Pre-seeding reduces per-host Dashboard toil for standard stacks while still requiring explicit approval of any deviation before Lockdown.

## Applying policy from automation

Use the CLI tools shipped with every installation (documented in the [Appendices](../appendices/) and [Batch Allowlisting Tools](../../allowlisting/batch-allowlisting-tools/)) to apply policy from your control plane:

- `hs-manage-allowlist` — inspect current state, add or remove specific entries for programs, file paths, and network destinations.
- `batch_record_add.py` — bulk-seed programs from a plain-text list of paths (adds each with standard library and configuration directories).

Run these tools over SSH, via config-management agents, or as part of provisioning scripts. Your central system prepares the seed data or change set; the automation layer delivers and applies it to each target host.

Subscription activation (`hs-activate-subscription`) is still required on each host before Lockdown can be engaged — this is the entitlement step and remains local.

Examples for the primary integration patterns follow.

### 1. Ansible — playbooks for seeding and applying policy

Use Ansible to distribute seed files and invoke the batch or management tools with become: true. A typical pattern:

```yaml
# heartsuite-policy-apply.yml
- hosts: heartsuite_fleet
  become: true
  tasks:
    - name: Copy central program seed list
      copy:
        src: "policy/seeds/programs-{{ inventory_hostname }}.txt"
        dest: "/tmp/heartsuite-programs.txt"
        owner: root
        mode: '0600'

    - name: Apply baseline programs via batch tool
      shell: "/.hs/sys/batch_record_add.py /tmp/heartsuite-programs.txt"
      args:
        creates: "/.hs/sys/allowlist_applied_{{ inventory_hostname }}.stamp"

    - name: Apply targeted network and file deltas from central policy
      shell: |
        hs-manage-allowlist add -x /usr/bin/curl -n 93.184.216.34
        hs-manage-allowlist add -r /etc/ssl/certs -w /var/log/app
      # Idempotency and error handling left to your playbook

    - name: Record application in central audit
      shell: "hs-manage-allowlist list > /tmp/current-allowlist-{{ inventory_hostname }}.txt"
      delegate_to: localhost
      # Then copy or commit the harvest back to your policy repo
```

Register the playbooks as the mechanism that executes change records approved in your central system.

### 2. Splunk / Elastic (and similar SIEMs) — ingesting for central dashboards and policy triggers

The primary use of Splunk and Elastic is consumption of the structured data streams (see [SIEM and Fleet Integration](siem-integration/)). Once events are in the SIEM:

- Build dashboards showing per-node mode, pending counts (from status.json), block rates, and approval activity (from the JSONL approval log forwarded via syslog or other shipper).
- Build views of the current allowlist and associated risks from the structured policy snapshots and posture data, including tables of programs with grant counts, `risk_level`, broad-write and network flags, and `record_hash` for drift detection.
- Use SOAR playbooks or alert actions in the SIEM to trigger Ansible Tower / AWX jobs or Terraform runs that apply approved policy updates back to affected hosts.
- Correlate HeartSuite enforcement events with change tickets to close the audit loop.

Syslog is the recommended high-volume path for both the per-decision enforcement stream and higher-level alerts. For richer views of the allowlist and posture (tables, metrics, and correlation) see [SIEM and Fleet Integration](siem-integration/).

### 3. Terraform + GitOps — policy in repository, applied at provision and drift remediation

Store allowlist seeds and change manifests in the same Git repository as your infrastructure code.

- Use Terraform `local_file` or `templatefile` to render per-host or per-role seed files from a central policy definition.
- During `terraform apply`, a `remote-exec` provisioner, `local-exec` that calls Ansible, or a custom provider runs the seed application and `hs-manage-allowlist` invocations on the new or updated instance.
- Drift detection: scheduled jobs (or Terraform Cloud/Enterprise runs) harvest current state via `hs-manage-allowlist list` or `cat ~/.cache/heartsuite/status.json`, compare against the repo, and open PRs or apply corrections.
- Git history becomes the authoritative change record for policy; the on-host JSONL approval log provides the per-host attribution of when and by which uid/tty the change was executed.

This pattern works especially well for immutable or frequently reprovisioned fleets.

### 4. ServiceNow or ITSM platforms — change-driven policy

- Model allowlist additions, removals, or baseline updates as standard or emergency change requests.
- Approved changes update a central policy repository (Git, CMDB, or dedicated store) or directly enqueue an automation job.
- The automation (Ansible, scripts, or ServiceNow Flow Designer + MID server) applies the delta to the target hosts using the CLI tools above.
- On completion, the automation closes the change ticket and posts the resulting JSONL approval log excerpts (or a pointer to the SIEM record) as evidence.

This keeps policy changes inside the same approval workflow used for all other infrastructure changes.

### 5. Custom scripts and other configuration management (Puppet, Chef, Salt, etc.)

Any tool that can copy files and run commands as root on the target can drive policy:

- Puppet: a custom resource or exec that writes a seed list managed by Hiera or PuppetDB and then invokes `batch_record_add.py` or `hs-manage-allowlist`.
- Chef: a recipe that templates policy from a data bag and executes the CLI tools.
- Pure scripts (Python, Bash, or your language of choice) run from a central runner or cron on a bastion: query the authoritative policy store, compute the diff for each host (or use a node-specific tag), SSH in, and apply.

The dedicated JSONL approval log (with uid/tty attribution for each change) and the enforcement/alert syslog streams give you the same audit trail regardless of which tool performed the apply.

## Consuming data for central visibility, auditing, and harvesting

All of the following surfaces are available without additional configuration once the daemon is running. They are the mechanism by which your central tooling observes state and reconstructs history.

- **Status JSON** (`~/.cache/heartsuite/status.json`, updated every 60 seconds) — lightweight pull surface for health and pending counts. Use from Ansible facts, Nagios/Zabbix checks over SSH, or any scheduled collector. Key fields for fleet dashboards: `mode`, `lockdown`, `is_hs_kernel`, `daemon_ok`, `pending_*` counts, `node_id`. See the schema in the [Appendices](../appendices/).

- **Dedicated JSONL approval log** — persistent, append-only record of every allowlist change (program, file path, or network destination) with timestamp, uid, and tty. This is the primary artifact for change attribution and audit reconstruction. Forward it (or its directory) via your existing log shipper alongside the syslog streams.

- **Structured syslog streams** — two real-time RFC 5424 streams under the `heartsuite` APP-NAME. One carries every kernel decision (enforcement: `HS-PROG-DENY`, `HS-FILE-DENY`, etc.). The other carries aggregated alerts (`new_program_blocked`, mode changes, etc.). A single rsyslog rule forwards both. Full configuration examples and Filebeat patterns are in the [SIEM and Fleet Integration](siem-integration/) page.

- **Webhook** — HTTPS POST of compact JSON alert payloads on every significant event. Configure the endpoint in Alert Settings; use for immediate routing into ServiceNow, PagerDuty, or your own policy-evaluation service.

- **Harvest current allowlist state** — run `hs-manage-allowlist list` (or the equivalent Dashboard export) on a schedule or on demand and commit the output to your central policy repository. This closes the loop: central sees what is actually enforced on each host and can detect drift or feed the next baseline.

See [Alert Settings](.) for configuration of syslog and webhook (Fleet tab) and [SIEM and Fleet Integration](siem-integration/) for production-scale ingestion patterns.

## Relationship to the Dashboard and Lockdown

The Dashboard remains the right surface for one-off investigation, initial setup on a new host, and guided maintenance windows. At fleet scale, routine policy application and observation move to your central tooling.

Lockdown itself is still activated per host (after subscription activation and alert-channel prerequisites). Once active, the kernel and the immutable seal protect the applied policy exactly as they do for Dashboard-driven changes. Alerts for "new allowlist file pushed while Lockdown is active" fire on all configured channels, giving your central systems immediate visibility into any out-of-band modification.

## Next steps and related documentation

- Configure the base alert channels on a pilot host: [Alert Settings](.)
- Review the CLI tools available for automation: [Batch Allowlisting Tools](../../allowlisting/batch-allowlisting-tools/) and [Appendices](../appendices/).
- Set up log ingestion: [SIEM and Fleet Integration](siem-integration/).
- Understand maintenance windows and when policy changes are permitted: [Maintenance](../maintenance/).
- Compliance context for auditors: [SOC 2 Control Mapping](../soc2/) and [Compliance Reference: NIST CSF & ISO 27001](../heartsuite-compliance-nist-iso27001/).

For support with large-scale or custom automation patterns, contact support@heartsecsuite.com.
