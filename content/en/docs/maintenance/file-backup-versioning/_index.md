---
title: "File Backup and Versioning"
weight: 91
description: "Automatic backups for designated directories and version restoration to protect against malware."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "backup", "versioning", "security", "files"]
toc: true
---

**Overview**: Every time a file in a protected directory is modified, HeartSuite automatically creates a versioned backup with a timestamp and file size. Only HeartSuite can access the backups — no other program, including malware running as root, can read or destroy them. Versions are never automatically deleted.

## How Backup Works

HeartSuite monitors a list of protected directories. When any file in those directories (including subdirectories) is written, HeartSuite silently creates a new versioned backup before the write completes. This runs automatically in both Setup Mode and Secure Mode — protection begins from first boot, before you have reviewed a single event.

By default, `/home` is configured for backup. You can add or remove directories from the Dashboard's Backup screen.

## Configuring Protected Directories

From the Dashboard, select the Backup screen (`[b]`). The screen shows your current backup configuration — which directories are protected and when they were last backed up.

From this screen you can:

- **Add directories** (`[n]`) — protect additional directories (e.g., `/var/www`, `/etc`, `/usr/lib`)
- **Remove directories** (`[r]`) — stop backing up a directory (removing a directory does not delete existing backups; existing versions are retained)

Recommended directories include those containing user documents, executable files, configuration, and shared libraries. Avoid high-churn directories like log directories — backup creates a new version on every write.

> [!NOTE]
> Backup is optional. You can remove all directories, disabling backup entirely. Mode Switch does not require backup to be configured.

## Restoring File Versions

If a file is compromised — for example, encrypted by ransomware — the Dashboard's Backup screen lets you browse version history and restore any previous version of any file in a protected directory. The Backup screen offers two browse modes:

- **File-first** (`[f]`) — navigate by directory and file, then view versions of the selected file
- **Timeline** (`[t]`) — navigate by date, showing all files modified on a given day

To restore a single file, select it and choose the version to restore. Each version shows its timestamp and file size.

For ransomware recovery where many files were modified on the same date, use the Timeline view (`[t]`), press `[d]` to filter by date, review the affected files, and press `[b]` to batch restore all of them in one operation.

## Lockdown and Backup

When Lockdown is active, the backup configuration file is sealed — no user or program, including root, can add or remove directories. This prevents an attacker who compromises a running process from silently disabling backup. To change the backup configuration, enter a maintenance period first (see [Protecting During Maintenance](../protecting-during-maintenance/)).

## Advanced: CLI Backup Management

For automation workflows, the underlying CLI tools are available:

```bash
# hs-backup-config-manager add /var/www
# hs-backup-config-manager remove /home
# hs-backup-config-manager list
# hs-version-manager list /home/user/document.txt
# hs-version-manager restore /home/user/document.txt --version 2023-11-01
```
