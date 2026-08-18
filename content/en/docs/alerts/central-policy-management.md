---
title: "Drive the allowlist from your own tooling"
linkTitle: "Central Policy"
weight: 2
description: "Keep policy in Ansible, Terraform, ServiceNow, or custom automation. Export and apply Root Lock allowlists at fleet scale — not one TUI per host."
categories: ["Guides"]
tags: ["heartsuite", "linux", "policy", "fleet", "ansible", "terraform", "servicenow", "automation", "central", "alerts", "siem", "security"]
toc: true
type: docs
---

**Overview**: Root Lock by HeartSuite is designed to be driven by your existing central tooling. The Dashboard is the operator experience for a single host; enterprises use their control planes to manage policy and observe at scale.

There is no built-in multi-host push from a HeartSuite server. Each host enforces its own allowlist, and Lockdown seals that allowlist on the device. Policy is applied per-host by your automation, with rich export surfaces for central consumption and attribution. This model lets you keep ownership of policy curation, change approval, and fleet-wide visibility inside the tools you already run (Ansible, Terraform, GitOps repositories, ServiceNow, Splunk, Elastic, custom orchestration).

The subscription activation step that enables Lockdown remains a per-host entitlement check. The content of the policy itself can be fully external.

## Policy curation in your central systems

A central system (CMDB, Git repository as source of truth, ITSM workflow, or custom script) owns the authoritative list of approved programs, file-access paths, and network destinations.

- Generate or maintain policy as simple text lists (one absolute program path per line) or structured data that your automation can parse.
- Curate changes through your normal processes: code review in Git, change tickets in ServiceNow, or policy-as-code pipelines.
- **Dense fleets (recommended):** harvest an install-time APO baseline from one dense reference host, package Root Lock **with that seed**, then install via Ansible using the seeded package so Phase 1 is short (not multi-hour learn-from-cold on every node).
- **Post-install text lists** (`hs_seeds`, `batch_record_add.py`) are for extras and program-path fleet reuse **after** install — they do not replace install-time APO pre-seed.

### Two seed mechanisms (do not conflate)

| | Install-time baseline pre-seed | Post-install text program list |
|---|--------------------------------|--------------------------------|
| **Purpose** | Seed **first**, then install: Phase 1 starts from a known dense baseline | Additive program approvals for extras after Root Lock is up |
| **When** | **Before/at** install (package or image includes baseline) | After Root Lock is installed; **not** while Phase 1 is still pending |
| **Shape** | Vendor packaging / installer options such as `--apo-seed` (baseline APO material) | Plain text: one absolute **program** path per line (`#` comments OK) |
| **Apply with** | Seeded installer / image; Ansible by **running that installer** | `hs_seeds` / `hs_programs` (Ansible role), `batch_record_add.py`, `hs-manage-allowlist` |

**Not required:** re-apply a full harvested baseline via **text** `hs_seeds` or `batch_record_add.py` after Phase 1 on the same host class. That does not skip multi-hour learning; use install-time APO pre-seed for that.

**Useful text seeds:** role-scoped bootstrap lists (for example SSH and app entrypoints), stack extras after residual queue review, and hosts that never observed those paths.

### Recommended order (dense / fleet — seed first)

1. **Reference host:** one machine of this class finishes Phase 1, runs the real dense workload, residual queues reviewed (pay multi-hour learning **once** if the host was seed-off).
2. **Harvest installer APO baseline** from that host with vendor harvest / packaging tooling (file and grant material for install-time pre-seed — not a program-path text list alone). Ansible may orchestrate collection over SSH; the artifact is still **installer baseline**, not `hs_seeds`.
3. **Review** and promote the baseline into your package pipeline.
4. **Build or obtain** a Root Lock install package **with baseline pre-seed enabled** (for example installer option `--apo-seed` / packaged baseline). Default customer packages may be seed-off until you enable this.
5. **Clean OS** on each fleet node.
6. **Ansible installs Root Lock using that seeded package** (point the playbook’s install bundle at the pre-seeded installer). Phase 1 uses the seed and finishes quickly.
7. Deploy application / hardening automation; residual Dashboard allow for deltas only.
8. Optional: post-install text program lists for extras (`hs-manage-allowlist list` → review → `hs_seeds` / `batch_record_add.py`).
9. Activate Lockdown only when subscription, alerts, and queue gates are ready.

### Cold path (first reference only)

Clean OS → install **without** baseline pre-seed → long Phase 1 on a dense host → residual review → harvest baseline (step 2 above) → all later hosts use the dense / fleet order.

Pending queue items are not grants until approved. Do not treat tester or one-shot pollution paths as production fleet seed.

## Applying policy from automation

Use the CLI tools shipped with every installation (documented in the [Appendices](../appendices/) and [Batch Allowlisting Tools](../../allowlisting/batch-allowlisting-tools/)) to apply **post-install** policy from your control plane. These tools do not replace install-time baseline pre-seed packaging:

- `hs-manage-allowlist` — inspect current state, add or remove specific entries for programs, file paths, and network destinations.
- `batch_record_add.py` — bulk-seed programs from a plain-text list of paths (adds each with standard library and configuration directories).

Run these tools over SSH, via config-management agents, or as part of provisioning scripts **after** Root Lock is installed and Phase 1 is complete. Your central system prepares the seed data or change set; the automation layer delivers and applies it to each target host.

Subscription activation (`hs-activate-subscription`) is still required on each host before Lockdown can be engaged — this is the entitlement step and remains local.

Examples for the primary integration patterns follow.

### 1. Ansible — playbooks for seeding and applying policy

HeartSuite provides an official declarative Ansible role (`heartsecurity.root_lock`) for fleet policy application and Lockdown transitions. It is modelled on `linux-system-roles.selinux` and ships with coordinated release materials; email [support@heartsecsuite.com](mailto:support@heartsecsuite.com) if you need the role package. On every installed host, the `limited_tools` Python API under `/opt/heartsuite` is the runtime integration surface the role uses. A shell-and-CLI alternative using `batch_record_add.py` and `hs-manage-allowlist` follows below for ad-hoc or legacy playbooks.

#### Official Ansible role: `heartsecurity.root_lock`

**Overview**: The role provides variable-driven, idempotent management of allowlist programs and mode transitions. It is modelled on `linux-system-roles.selinux` (and `rhel-system-roles.selinux`) so administrators familiar with RHEL declarative SELinux policy can apply the same playbook patterns to HeartSuite.

The role is intentionally narrow in scope: it assumes Root Lock is already installed on the target and focuses on allowlist management plus mode transitions (Setup Mode / Lockdown). Full server provisioning and deployment scenarios — base OS preparation, hardening using established standards such as the dev-sec collection, SFTP receiver setup, bundle-based installation, and post-install configuration — are supported by thin orchestrator playbooks. These compose the `heartsecurity.root_lock` role with upstream collections and custom tasks for the unique requirements of a host (for example source-restricted firewalls or dedicated backup directories).

A reference provisioning example for a realistic Debian 12 server (kernel 6, delegated hardening via dev-sec, SFTP receiver for backups, full Root Lock deployment, and integration with backup/alert surfaces) is available in the code repository under `ansible/examples/hs-debian12-provision/`. It demonstrates a practical pattern: install Root Lock (the example does not replace Phase 1 with a full text re-seed), start with a **minimal role-scoped** bootstrap allowlist via seed file, run the real workload (e.g. SFTP transfers), harvest observed **extras** from Setup Mode on the live machine after residual review, maintain them in a seed file, and re-apply via the role for hosts that need those paths.

**Requirements**:

- Root Lock already installed on managed hosts (the role does not install the product).
- Prefer Phase 1 finished before applying workload `hs_seeds` / stack playbooks that assume a learned baseline.
- `become: true` — all operations are privileged.
- Ansible >= 2.9.
- The role invokes the production Python API in `/opt/heartsuite` (`limited_tools` via `/opt/heartsuite/venv/bin/python3` and `/opt/heartsuite/src`).

`hs_seeds` / `hs_programs` are **post-install text program lists**. They are not install-time APO baseline packaging and not a binary policy file drop-in. Leave `hs_state` unset until subscription, alerts, and queue gates are ready for Lockdown.

**Key variables** (all prefixed `hs_` to avoid collision with SELinux role variables):

| Variable | Purpose |
|----------|---------|
| `hs_state` | Mode transition: `secure` or `lockdown` (synonyms). `setup` is informational only (no-op). Unset leaves mode unchanged. Calls `switch_to_secure()` with the same precondition gates as the Dashboard. Prefer unset until gates pass. |
| `hs_programs` | List of absolute program paths to approve (uses `apply_allowlist_seed()` internally). |
| `hs_seeds` | List of seed file paths, or literal inline paths when the entry is not an existing file. Seed files are plain text, one program path per line; `#` comments and blank lines are ignored. Combine freely with `hs_programs`. Post-install extras/fleet — not installer baseline pre-seed. |

Additional variables include `hs_gather_status` (default `true`, exposes `hs_status` fact), `hs_purge` / `hs_purge_allowlist` (currently emit a warning only — the scriptable surface is additive by design), and `hs_python` / `hs_src_path` overrides for non-standard install layouts.

**Idempotency**: All allowlist operations return `CommandResult` with `kind == "noop"` when an entry is already present. The role uses this for correct `changed_when` reporting, so repeated plays do not show spurious changes.

Minimal example playbook:

```yaml
# heartsuite-root-lock.yml
- name: Configure HeartSuite allowlist and engage Lockdown
  hosts: heartsuite_fleet
  become: true
  vars:
    hs_state: secure
    hs_programs:
      - /usr/sbin/sshd
      - /usr/bin/python3
    hs_seeds:
      - /var/lib/ansible/heartsuite/seed.txt
  roles:
    - heartsecurity.root_lock
```

After switching to `secure` or `lockdown`, a reboot is typically required for full seal; the role does not reboot automatically. Register facts (`hs_status`, `hs_apply_result`, `hs_switch_result`) are available for assertions or subsequent tasks.

**Python API alternative**: For custom Ansible modules or non-Ansible automation, the same primitives are exposed directly via `limited_tools`: `approve_program_path`, `apply_allowlist_seed`, `get_status`, `get_allowlist_programs`, and `switch_to_secure`. These reuse the same gates and `CommandResult` semantics. The `heartsecurity.root_lock` role is the preferred declarative path for the narrow post-install concerns; use the Python API (or thin custom tasks) when composing larger provisioning playbooks that also handle OS setup, hardening, or host-specific services before or after invoking the role.

See the reference provisioning starter in the code repository (`ansible/examples/hs-debian12-provision/`) for a concrete example of composition: it delegates SSH/SFTP hardening to the dev-sec collection, performs bundle-based installation, registers backup directories and alert configuration, starts with a minimal allowlist bootstrap (via seed file), and shows how to harvest from real workload observation into a maintainable seed file before using the root_lock role for allowlist and mode.

Register playbooks as the mechanism that executes change records approved in your central system.

#### Shell + register alternative

Use Ansible to distribute seed files and invoke the batch or management tools with `become: true`:

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

This pattern does not use `CommandResult.kind == "noop"` for `changed_when`; implement your own idempotency checks (for example `creates`, or `register` + conditional tasks).

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
