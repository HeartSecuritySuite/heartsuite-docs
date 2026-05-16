---
title: "HJFS Overview"
linkTitle: "HJFS Overview"
weight: 2
description: "Design goals and core concepts of HeartSuite Joint File System."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "overview", "security", "concepts"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: The root cause of malware damage is straightforward — if a program can access any file it wants, it can do all the damage it desires. HJFS addresses this directly by joining data files to the program they belong to, so no other program can access them. See [The Security Problem HJFS Solves](../security-problem/) for the underlying OS design flaw this corrects.

## How HJFS works

HJFS joins, or connects, data files with the program that created them. Programs cannot touch files that don't belong to them. This creates a functional barrier that malware cannot cross: even if malware is present on the system, it cannot read, modify, or encrypt files owned by other programs.

### Technical implementation

HJFS moves file access restrictions out of the kernel's user-permission model and integrates them into the filesystem itself. Specifically, HJFS consists of:

- Additional source code integrated into the filesystem's `open()` call — the function the OS invokes whenever an application opens a file. Access policy is enforced at that point.
- Tools for installing and updating programs into the HJFS structure.
- A version selector that determines which program version is active when a program starts.

Executables are stored in a separate read-only area. Only the official HJFS installer can write to it. Programs cannot modify or replace their own binaries.

Unlike HeartSuite Core Secure, which enforces access at the kernel level, HJFS operates entirely within the filesystem layer. A standard kernel is sufficient — no kernel modification is required.

The diagram below illustrates how the modified `open()` call routes a file request through the OS to the program's isolated storage area:

![Diagram 2.1 — Basic file open flow: Program A calls open(file1), the OS determines the program name, locates the file in Program A's storage area, creates a handle, and returns it.](/images/hjfs/diagram-000.jpg)

The restructured filesystem separates system files, executables, and per-program data into distinct top-level areas:

![Diagram 2.3 — Restructured file system: root splits into System, Executables, and Data. Executables subdivides into Programs (Program A, Program B) and Shared libraries (lib1, lib2). Data subdivides into Program A and Program B.](/images/hjfs/diagram-002.jpg)

### Per-version storage

HJFS associates data files with the specific version of the program that created them. Each installed version of a program receives its own dedicated storage area — each program becomes, in that sense, king of its own castle. HJFS enforces the castle walls: programs are denied access to storage areas belonging to other programs, even when the only difference is the version number.

A program version is uniquely identified by the concatenation of SHA256 cryptographic hashes of the program executable and all its dynamically linked libraries, combined with the last modification date of those files. Two versions are treated as distinct even if only a single library changed. User-facing utilities display each version with a human-readable install-time identifier (for example, `260208_123022P`); the cryptographic hash is the underlying identity HJFS uses to enforce isolation.

![Diagram 2.2 — Versioned file open flow: Program A calls open(file2a), the OS determines program name and then program version, and locates the file in the matching version-hash subdirectory of Program A's storage area.](/images/hjfs/diagram-001.jpg)

This means:

- When a program is updated, the new version gets its own storage area. The previous version's program binary, libraries, and data files remain intact and unmodified.
- A malicious update cannot access or destroy files created by earlier versions.
- Users can roll back to any previous version and read the original files exactly as they were.

### Secure file transfer between programs

Because each program is confined to its own storage area, moving data between programs requires explicit user action through one of two mechanisms:

- **Copy utility**: Copies a file from one program's storage area directly to another's. Every transfer is an explicit, auditable operation.
- **Transfer area**: A neutral staging location where a file can be deposited once and made available for other programs to read and copy to their own areas. Programs can read from the transfer area but cannot write to other programs' areas directly.
- **Clipboard**: Standard copy and paste between programs operates as a user-mediated transfer. Because it requires manual user action, it cannot be performed by programs without the user's knowledge.

Programs cannot permanently delete files. The only deletion operation available to a program is moving a file to trash. A separate utility allows users to view the trash contents and permanently delete selected files, recovering storage. This ensures all deletions are visible and reversible until the user explicitly confirms permanent removal.

### Version management

HJFS includes two utilities:

| Utility | Purpose |
|---|---|
| `HJFS_update_program` | Install a new version of a program into HJFS |
| `HJFS_version_manager` | List installed versions, check the current version, set the active version |

`HJFS_version_manager` flags:

| Flag | Action |
|---|---|
| `-l` | List all installed versions |
| `-c` | Show the currently active version |
| `-s <version-id>` | Set the active version |

### Version rollback

Because each program version has its own storage area, rolling back is non-destructive. Setting the active version back to a prior release makes the original files immediately accessible — no restore process, no backup retrieval. HJFS preserves data across every version, including versions that turn out to be malicious updates.

The example below shows a program called SimpleEdit after an update on November 12. The May 6 version is preserved in its own subarea; the installer stores the prior executables before overwriting the current ones:

![Diagram 2.4 — SimpleEdit executable storage: current version (Nov 12) contains editor.exe and editor_functions.dll; a preserved "May 6" subarea contains the same files from the prior install. Shared libraries contains c_functions.dll.](/images/hjfs/diagram-003.jpg)

### Automatic data file backup

HJFS automatically backs up every version of every data file to a protected storage area that no ordinary program can access. A dedicated restore utility allows users to view all versions of a file and restore any of them.

This is distinct from program version rollback. Program version rollback restores a prior executable and its libraries. Data file backup maintains version history of the data files themselves, independent of which program version created them.

HJFS automatic backup differs from HeartSuite Core Secure's backup mechanism in two ways. Core Secure backs up admin-configured directories on every write — an administrator selects which directories are protected. HJFS backup requires no configuration: every data file written by any program is backed up automatically by the filesystem itself, covering every program's storage area from first use.

#### The malicious sleeper attack

Program version isolation alone does not close every window of exposure. Consider a more patient form of attack: a malicious update that behaves exactly as expected for months before activating. The attacker is not in a hurry. During those months the user continues working, creating new data files that fall within the malicious version's storage area. By the time the attack activates — encrypting those files for ransom — the user has legitimate data they cannot afford to lose. Rolling back the program version does not help, because the new data files were created under the malicious version and exist only in that version's storage area. They do not exist in the prior version's area.

This is the attack that automatic data file backup is specifically designed to defeat.

#### How the backup defeats it

HJFS backs up every write to every data file continuously. Every version of every file is stored in a protected area that no program — including the malicious update — can access or destroy. Attackers are well aware that backups are their primary obstacle, which is why destroying backup systems is typically the first step in a ransomware attack. HJFS removes this option entirely: the backup area is inaccessible to programs by design, not by permission.

When the attack activates, the user can:

1. Stop the malicious program.
2. Use the restore utility to recover every data file to the version that existed before the attack.
3. Copy those restored files to the prior legitimate program version's storage area.
4. Roll back the program version to the legitimate one.

Every file created before the attack is recoverable. The window of loss is limited to any files written during the active attack phase — a narrow interval compared to the months the sleeper was dormant. The attacker's return on investment in a prolonged, patient attack is eliminated.

## Security guarantees

HJFS protections cannot be disabled by a human or an AI agent running on the system. The only way to interfere with HJFS enforcement is by gaining physical-level access to the machine and deleting the HJFS drive.

## Patents

HJFS is based on innovations patented by HeartSuite:

| Patent | Title | Issued |
|---|---|---|
| US 11,822,699 B1 | Preventing Surreptitious Access to File Data by Malware | November 21, 2023 |
| US 11,983,288 B1 | Operating System Enhancements to Prevent Surreptitious Access to User Data Files | May 14, 2024 |

## How HJFS differs from HeartSuite Core Secure

| | HeartSuite Core Secure | HJFS |
|---|---|---|
| Enforcement layer | Kernel | Filesystem (`open()` call) |
| Kernel requirement | Modified HS kernel | Standard kernel |
| Program execution control | Yes | No |
| Filesystem path control | Yes | Yes |
| Network access control | Yes | No (v1.0) |
| Per-program-version file isolation | No | Yes |
| Audited cross-program file transfer | No | Yes |

Both products can be used together. HeartSuite Core Secure blocks unauthorized program execution and network access at the kernel; HJFS adds per-version file isolation at the filesystem layer.

## Status

HJFS is a prototype. Capabilities, configuration, and deployment details are subject to change.
