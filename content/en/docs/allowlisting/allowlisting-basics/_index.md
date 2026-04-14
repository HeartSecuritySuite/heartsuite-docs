---
title: "Allowlisting Basics"
weight: 1
description: "Overview and basic procedures for allowlisting programs in HeartSuite."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "security", "programs"]
type: docs
toc: true
---

**Overview**: HeartSuite requires you to allowlist programs before they can execute, access files, or make network connections. The Dashboard and its review queues walk you through this process with full metadata and tiered grouping.

## How Allowlisting Works

In Setup Mode, HeartSuite logs every program execution, file access attempt, and outbound network connection without blocking anything. These logged events populate three review queues visible from the Dashboard:

- **Programs queue** (`[p]`) -- programs that attempted to execute
- **File Access queue** (`[f]`) -- programs that attempted to read or write files
- **Internet Access queue** (`[i]`) -- programs that attempted outbound connections

The Dashboard shows pending event counts for each queue and provides a Suggested Next Step directing you to the queue that needs attention first.

## The Review Process

### Starting a Review

The Dashboard displays pending counts for each queue. The Suggested Next Step directs you to the queue that needs attention first. Select a queue to begin reviewing.

### Single-Key Actions

The footer shows the primary actions available at any point:

| Key | Action |
|-----|--------|
| `[a]` | Approve the event |
| `[s]` | Skip for now (defer without approving) |
| `[n]` | Navigate to the next denied event — Secure Mode only |
| `[?]` | Explain — what approving this event means |
| `[q]` | Return to the Dashboard |

Two additional keys appear contextually, not in the footer:

| Key | When available |
|-----|---------------|
| `[v]` | View all — shown inline on Tier 2 grouped prompts; lists every event in the group before you approve |
| `[u]` | Undo — available for 5 seconds after an approval; cancels the last approval and returns the event to the queue |

### Metadata Shown in Review

Every review item displays metadata directly in the primary prompt -- you do not need to press a key to see it. The fields shown include:

| Field | Description |
|-------|-------------|
| Package | Package name and version from the distro database |
| Description | One-line package summary |
| Category | Package section (e.g., "editors", "web", "python") |
| Maintainer | Package maintainer string |
| Homepage | Package homepage URL |
| Installed | Date the package was installed or last updated |

When a program has no entry in any package database, HeartSuite displays the raw file path with "(no package)" in the metadata fields. Missing metadata is never hidden -- the absence of information is itself a signal.

### Sort Cohort Labels

Within each queue, programs are grouped under cohort headers in the sidebar. These groups determine the order you encounter events, placing items that need the most investigation first:

| Cohort | Meaning |
|--------|---------|
| Unknown origin | Program has no entry in any known package database. No metadata beyond the file path. |
| Installed after OS | Program belongs to a package installed after the OS provisioning date. |
| Installed with OS | Program belongs to a package whose install date matches the inferred OS provisioning date. |
| HeartSuite | File path falls under `/.hs/`. Origin is known; no investigation needed. Sorted last. |

The sort order is a workflow convenience that determines which programs appear first. It is not a trust ranking and does not affect the approval mechanism. Every program receives the same approve and skip options.

## Tiered Review Model

The review queues use a tiered model to handle large numbers of events without requiring blind bulk approval. Volume is managed through intelligent grouping, not through approving things you cannot see.

### Tier 1 -- Individual Review

Each event is presented one at a time with full metadata. Example for a program execution event:

```text
Program attempted to execute:
/usr/bin/nano
Package:     nano 7.2-1 -- small, friendly text editor
Attempts:    3

This program has not been allowlisted.

[a] Approve execution
[s] Skip for now
[?] What does approving this mean?
```

### Tier 2 -- Grouped Review

Related events are grouped together (e.g., "847 file reads from /usr/lib/python3/"). HeartSuite shows a sample of the grouped events so you can confirm the grouping makes sense before approving. The `[v]` View all option is shown inline on the grouped prompt for users who want complete visibility before approving.

### Tier 3 -- Informational Summary

When the volume of remaining events is large, HeartSuite presents a summary of what is ahead — total counts and a breakdown by program — before you begin reviewing. This is an orientation view, not an approval surface. Press `[a]` or `[Enter]` to proceed into individual review.

> [!NOTE]
> Tiers and cohort sort order are independent dimensions. A program in any cohort may appear in any tier. For example, a program with no package entry that generated 200 file read events would appear in the "Unknown origin" cohort (sorted first) but could be presented as a Tier 2 group (because the events are groupable by directory).

## Programs Queue (Phase 2)

When a program executes without an allowlist entry, HeartSuite logs it. The Programs queue presents these events for review. Example log entry:

```text
[Setup Notice - Add program to Allowlist?] Not Whitelisted: /usr/bin/nano
```

From the Dashboard, select the Programs queue (`[p]`). Each program is presented with its package metadata. Press `[a]` to approve execution or `[s]` to skip.

## File Access Queue (Phase 4)

After a program is allowlisted, HeartSuite begins logging every file it accesses. Programs typically access shared libraries, configuration files, and data files. The File Access queue presents these events with two distinct permission levels:

- **Read access** -- the default first approval level when approving a file read event.
- **Write access** -- always includes read access. Granted when approving a file write event.

Example review prompt for a file read event:

```text
/usr/bin/python3 attempted to read:
/usr/lib/python3/dist-packages/apt/__init__.py
Program:     python3 3.11.2-1 -- interactive high-level object-oriented language
File owner:  python3-apt 2.6.0
Attempts:    12

This file access has not been allowlisted.

[a] Approve read access
[s] Skip for now
[?] What does approving this mean?
```

Example review prompt for a file write event:

```text
/usr/bin/journald attempted to write:
/var/log/journal/machine-id/system.journal
Program:     systemd 252-19 -- system and service manager
File owner:  systemd 252-19
Attempts:    3

This file access has not been allowlisted.

[a] Approve read and write access
[s] Skip for now
[?] What does approving this mean?
```

From the Dashboard, select the File Access queue (`[f]`).

> [!TIP]
> Tier 2 grouped review handles the common case where a program reads many files from the same directory (e.g., `/usr/lib/python3/`). HeartSuite groups these events together and shows a sample, so you can approve directory-level access without reviewing each file individually.

## Internet Access Queue (Phase 5)

Programs that attempt outbound internet connections are logged with the destination IP address and reverse DNS hostname. The Internet Access queue presents these for review.

Example review prompt:

```text
/usr/bin/curl attempted an outbound connection:
Destination: 93.184.216.34 -- example.com (Edgecast, US)
Program:     curl 7.88.1-10 -- command line tool for transferring data with URL syntax
Attempts:    7

This destination has not been allowlisted for this program.

[a] Approve this connection for /usr/bin/curl
[s] Skip for now
```

From the Dashboard, select the Internet Access queue (`[i]`).

> [!NOTE]
> This edition supports specific IPv4 and IPv6 addresses only.

## Progress and Completion

While working through a queue, a progress indicator shows your position:

```text
Programs: reviewing 3 of 7  ───────────────────────────────
```

When a queue is empty:

```text
All program events resolved.
Returning to Dashboard…
```

The Dashboard automatically updates pending counts as you work. Allow several days to a week of observation in Setup Mode to capture events from systemd timers, cron jobs, and infrequent services before proceeding to Secure Mode.

## Review Queues in Secure Mode

In Secure Mode the review queues are read-only. `[a]` and `[s]` do nothing — you cannot approve events while enforcement is active. The queues show **denied** events (actions HeartSuite blocked), not pending events awaiting review.

Use `[n]` to navigate through denied events one by one. To approve a denied program, file access, or network destination, enter a maintenance period first via the Maintenance screen (`[t]`) — this switches to Setup Mode where the review queues become interactive again.

> [!NOTE]
> Denied events in Secure Mode are a normal part of operation, not failures. A denied event means HeartSuite blocked something that was not on the allowlist. Review it to decide whether to approve it or leave it blocked.

## Advanced: Manual Allowlist Management

For users who prefer direct CLI manipulation, `hs-manage-allowlist` provides a browser and editor for existing allowlist entries. See its built-in help:

```bash
# hs-manage-allowlist --help
```
