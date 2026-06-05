---
title: "HJFS Overview"
linkTitle: "HJFS Overview"
weight: 2
description: "How HJFS confines programs to their own storage areas — eliminating the OS's default of shared file access across all programs."
categories: ["Essentials"]
tags: ["hjfs", "filesystem", "overview", "security", "concepts"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

**Overview**: On a standard Linux system, any program can open any file the current user can reach — including programs running as root. That is the root cause of most malware damage. HJFS addresses it directly by binding data files to the program that created them. The modified `open()` call enforces that binding at every file access: no other program can read or write those files, regardless of privilege. Access control is enforced per program and per program version. Execution control and network connection control are outside HJFS scope. See [The security problem HJFS solves](../security-problem/) for the underlying OS design flaw this corrects.

## File isolation in practice

HJFS binds data files to the program that created them. A program can only reach files in its own storage area. That boundary holds even for programs running as root. Malware present on the system cannot read, modify, or encrypt files that belong to another program — the `open()` call blocks the attempt before it reaches the data.

### Technical implementation

HJFS moves file access enforcement out of the kernel's user-permission model and into the filesystem itself. It consists of three parts:

- Additional code integrated into the filesystem's `open()` call — the function the OS invokes whenever a program opens a file. Access policy is enforced at that point.
- Tools for installing and updating programs into the HJFS structure.
- A version selector that determines which program version is active when a program starts.

Executables are stored in a separate area. The `open()` modification marks that area read-only for all programs. Only the official HJFS installer has write access. Programs cannot modify or replace their own binaries.

HJFS operates entirely within the filesystem layer. A standard kernel is sufficient — no kernel modification is required.

When a program opens a file, the modified `open()` call routes the request to that program's isolated storage area:

![Diagram 2.1 — Basic file open flow: Program A calls open(file1), the OS determines the program name, locates the file in Program A's storage area, creates a handle, and returns it.](/images/hjfs/diagram-000.jpg)

The restructured filesystem separates system files, executables, and per-program data into distinct top-level areas:

![Diagram 2.3 — Restructured file system: root splits into System, Executables, and Data. Executables subdivides into Programs (Program A, Program B) and Shared libraries (lib1, lib2). Data subdivides into Program A and Program B.](/images/hjfs/diagram-002.jpg)

### Per-version storage

HJFS enforces isolation at the version level, not just the program level. Each installed version of a program receives its own dedicated storage area. HJFS trusts a program only with the storage area that version created. Storage areas belonging to other programs — or to other versions of the same program — are outside that trust boundary, even when the program runs as root.

A program version is uniquely identified by the concatenation of SHA256 cryptographic hashes of the program executable and all its dynamically linked libraries, combined with the last modification date of those files. Two versions are treated as distinct even if only a single library changed. User-facing utilities display each version with a human-readable install-time identifier (for example, `260208_123022P`). The cryptographic hash is the identity HJFS uses internally to enforce isolation.

When a program opens a versioned file, the `open()` call resolves both the program name and the version hash before locating the file:

![Diagram 2.2 — Versioned file open flow: Program A calls open(file2a), the OS determines program name and then program version, and locates the file in the matching version-hash subdirectory of Program A's storage area.](/images/hjfs/diagram-001.jpg)

This means:

- When a program is updated, the new version gets its own storage area. The previous version's binary, libraries, and data files remain intact.
- A malicious update cannot reach or destroy files created by earlier versions.
- Users can roll back to any previous version and read the original files exactly as they were.

### Secure file transfer between programs

Because each program is confined to its own storage area, moving data between programs requires explicit user action through one of two mechanisms:

- **Copy utility**: Copies a file from one program's storage area directly to another's. Every transfer is an explicit, auditable operation.
- **Transfer area**: A neutral staging location where a file can be deposited once and made available for other programs to read and copy to their own areas. Programs can read from the transfer area but cannot write to other programs' areas directly.
- **Clipboard**: Standard copy and paste between programs is a user-mediated transfer. It requires manual user action and cannot be performed by a program without the user's knowledge.

Programs cannot permanently delete files. The only deletion operation available to a program is moving a file to trash. A separate utility allows users to view trash contents and permanently delete selected files. All deletions are visible and reversible until the user explicitly confirms permanent removal.

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

Because each version has its own storage area, rolling back is non-destructive. Setting the active version to a prior release makes the original files immediately accessible — no restore process, no backup retrieval. Prior executables, libraries, and data files remain untouched in their own subareas.

If the user created data files under the version being rolled back from — for example, a malicious update installed since the last legitimate version — those files exist only in that version's storage area. The file transfer utility can copy them to the target version's storage area before or after the rollback, preserving any legitimate work done under the compromised version.

The example below shows a program called SimpleEdit after an update on November 12. The May 6 version is preserved in its own subarea; the installer stores the prior executables before overwriting the current ones:

![Diagram 2.4 — SimpleEdit executable storage: current version (Nov 12) contains editor.exe and editor_functions.dll; a preserved "May 6" subarea contains the same files from the prior install. Shared libraries contains c_functions.dll.](/images/hjfs/diagram-003.jpg)

### Automatic data file backup

HJFS automatically backs up every version of every data file to a protected storage area. No program can reach that area — including programs running as root. A dedicated restore utility allows users to view all versions of a file and restore any of them.

This is distinct from program version rollback. Program version rollback restores a prior executable and its libraries. Data file backup maintains version history of the data files themselves, independent of which program version created them.

HJFS automatic backup differs from Root Lock by HeartSuite's backup mechanism in two ways. Core Secure backs up admin-configured directories on every write — an administrator selects which directories are protected. HJFS backup requires no configuration: every data file written by any program is backed up automatically by the filesystem, covering every program's storage area from first use.

#### The malicious sleeper attack

Program version isolation alone does not close every window of exposure. Consider a patient form of attack: a malicious update that behaves exactly as expected for months before activating. During those months the user continues working. New data files accumulate inside the malicious version's storage area. By the time the attack activates — encrypting files for ransom — the user has legitimate data that exists only in that version's area. Rolling back the program version does not help, because the affected files were created under the malicious version and were never written to the prior version's area.

This is the attack that automatic data file backup is specifically designed to defeat.

#### How the backup defeats it

HJFS backs up every write to every data file continuously. Ransomware targets backup systems first because intact backups eliminate the leverage of encryption. HJFS removes that option. The backup area is unreachable to any running program — not through a permission rule that can be changed, but through the same `open()` enforcement that governs all other isolation boundaries.

When the attack activates, the user can:

1. Stop the malicious program.
2. Use the restore utility to recover every data file to the version that existed before the attack.
3. Copy those restored files to the prior legitimate program version's storage area.
4. Roll back the program version to the legitimate one.

Every file created before the attack is recoverable. The window of loss is limited to files written during the active attack phase — a narrow interval compared to the months the sleeper was dormant.

## Security guarantees

HJFS trusts each program only with the storage area that program version created. It does not trust privilege level: root access does not expand what a program can open. The trust boundary is enforced at the filesystem layer, below all running software. The only path around it is physical: removing the HJFS drive bypasses the enforcement entirely.

## Patents

HJFS is based on innovations patented by HeartSuite:

| Patent | Title | Issued |
|---|---|---|
| US 11,822,699 B1 | Preventing Surreptitious Access to File Data by Malware | November 21, 2023 |
| US 11,983,288 B1 | Operating System Enhancements to Prevent Surreptitious Access to User Data Files | May 14, 2024 |

## HJFS and Root Lock by HeartSuite: what each covers

Root Lock by HeartSuite and HJFS are not currently compatible and cannot be deployed together. The table below describes what each product covers for reference.

| | Root Lock by HeartSuite | HJFS |
|---|---|---|
| Enforcement layer | Kernel | Filesystem (`open()` call) |
| Kernel requirement | Modified HS kernel | Standard kernel |
| Program execution control | Yes | No |
| Filesystem path control | Yes | Yes |
| Network access control | Yes | Not in v1.0 scope |
| Per-program-version file isolation | No | Yes |
| Audited cross-program file transfer | No | Yes |

Each product covers dimensions the other does not, but they cannot currently be deployed together. Program execution control and network access control remain outside HJFS scope; organizations requiring those controls should use a dedicated allowlisting tool alongside HJFS.

## Status

HJFS is a prototype. Capabilities, configuration, and deployment details are subject to change.
