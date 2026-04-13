---
title: "File Backup and Versioning"
weight: 91
description: "Automatic backups for designated directories and version restoration to protect against malware."
categories: ["Advanced"]
tags: ["heartsuite", "linux", "maintenance", "backup", "versioning", "security", "files"]
toc: true
---

**Overview**: HeartSuite automatically backs up and versions files in protected directories, preventing malware from destroying or modifying them—only HeartSuite can access backups.

## File Backup and Versioning

Files that attackers routinely attack today are your backups. So HeartSuite makes sure to wall them off with extra protection. For starters, HeartSuite automatically backs up files in designated directories, including their subdirectories. But more importantly, HeartSuite prevents access to the backups by all programs—only HeartSuite can access the backups. HeartSuite supplies a backup configuration manager tool that admins can use to add and remove directories from the list of directories that will be backed up automatically. By means of this simple but powerful approach, HeartSuite prevents all programs from destroying or modifying backup files.

The HeartSuite version manager program can then be used to retrieve any version of the file at will. All of that means that if your staff downloads malware masquerading as legitimate software by mistake, the layers of Program Allowlist, Lockdown, and versioning will work together to minimize damage and easily let you restore your files.

## Configuring Automatic File Backup

HeartSuite uses a separate database of directories to determine whether to backup a file that has been written. By default, the backup configuration database includes only a single directory, /home. You can remove it, as well as add additional directories, by using the `hs-backup-config-manager` tool. HeartSuite will automatically backup each file in these specified directories, including those within their subdirectories, when the contents of the file are changed by writing.

### Example Usage

To add a directory to the backup list:

```bash
sudo /.hs/sys/hs-backup-config-manager add /var/www
```

To remove a directory:

```bash
sudo /.hs/sys/hs-backup-config-manager remove /home
```

To list configured directories:

```bash
sudo /.hs/sys/hs-backup-config-manager list
```

Always backup after file writes in monitored directories. This ensures multiple versions are available for restoration.

## Restoring File Versions

If a file is compromised (e.g., encrypted by ransomware), use the `hs-version-manager` to restore a previous version.

### Example: Restore a File

```bash
sudo /.hs/sys/hs-version-manager restore /home/user/document.txt --version 2023-11-01
```

View available versions:

```bash
sudo /.hs/sys/hs-version-manager list /home/user/document.txt
```

This tool helps recover from malware attacks, as backups are isolated and only accessible by HeartSuite.

## Integration with Other Features

Backup and versioning work seamlessly with HeartSuite's core features:
- **Program Allowlist**: Prevents unauthorized access to backup files.
- **Lockdown**: Ensures backup configurations can't be altered during production.
- **Secure Mode**: Enforces restrictions that protect backups from tampering.

For advanced maintenance, see [Protecting During Maintenance](../protecting-during-maintenance/) for secure update practices.