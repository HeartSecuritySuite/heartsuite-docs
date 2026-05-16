---
title: "Advanced Protection"
weight: 25
description: "The advanced protection tier of HJFS — internal and user file separation, OS-mediated file dialogs, and export/import functions."
categories: ["Essentials"]
tags: ["hjfs", "advanced", "user-files", "internal-files", "volition", "export", "import"]
type: docs
toc: true
---

> **Prototype**: Content on this page reflects current design intent and will be updated as the product matures.

HJFS defines two tiers of protection:

| Tier | OS changes | App changes | Description |
|---|---|---|---|
| Basic protection | Yes | No | Program and version isolation. All current HJFS v1.0 capabilities. |
| Advanced protection | Yes | Yes | Adds internal/user file separation and OS-mediated file access. Requires application updates. |

Basic protection is the foundation — it runs existing software unchanged. Advanced protection builds on top of it and delivers stronger guarantees for user-facing data files, at the cost of requiring applications to be updated to use the new OS functions.

## Internal files and user files

Advanced protection subdivides each program's per-version storage area into two types:

**Internal files** are managed directly by the program using file names. They are hidden from user utilities — they cannot be browsed, copied, or accessed outside the program that owns them. A spell-checker dictionary, a configuration file, or game state data are examples of internal files.

**User files** are the data the user interacts with directly: documents, spreadsheets, images. Under advanced protection, a program cannot open a user file by specifying its name. Instead, the program must invoke a system function that presents a standard OS file-selection dialog. The user makes the selection. The OS opens the file and passes a file handle to the program — not a name. The program never learns the file's location in the broader filesystem.

This means malware cannot open user files surreptitiously. It must wait for the user to open a file through the dialog. Even then, the user can restrict the opened file to read-only access for the program — the equivalent of handing the scribe a document without the pen.

The diagram below shows a program opening an internal file — the OS determines the program name and version, and locates the file within the `internal` subarea of the program's version directory:

![Diagram 2.6 — Advanced versioned file open (internal): Program A calls open(file2a), the OS determines program name and version, and locates the file in the "internal" subarea of the matched version-hash directory. A separate "user" subarea exists alongside it.](/images/hjfs/diagram-005.jpg)

When a program needs to open a user file, the OS instead invokes a file-selection dialog. The user picks the file; the OS resolves and opens it, passing only a handle to the program:

![Diagram 2.7 — User file open via dialog: Program A calls user_open(), the OS presents a File Open Dialog Box, the user selects "Chapter1.docx," the OS determines program name and version, locates the file in the "user" subarea, and returns a handle.](/images/hjfs/diagram-006.jpg)

## Exporting and importing data

Because internal files are hidden and user files require OS mediation, HJFS advanced protection provides two explicit system functions for moving data across the boundary:

**Export**: A program can write internal file data to a user file, making it available to the user or to other programs. To prevent data mixing, no other user file may be open by the program during the export operation.

**Import**: A program can read from a user file and write the data into its internal files. This is the standard path for a program to accept externally supplied data — a document being opened for editing, for example.

Both functions are explicit, auditable, and user-initiated through the OS dialog.

## Why this matters

Basic protection prevents malware from accessing files belonging to other programs. Advanced protection additionally prevents malware within a program from secretly accessing the user's own documents. Even a compromised version of a trusted program cannot silently open and read user files — it must wait for the user to choose a file through the OS dialog.

The combination of both tiers means:

- Cross-program file access is impossible by design (basic).
- Within-program silent file access to user data is impossible by design (advanced).

## Multiple Users

On a multi-user system, per-user isolation is layered on top of per-program and per-version isolation. Each program's storage area is first divided by user, then by program version, then into internal and user subareas. A program running as user X cannot access files created by user Y, even within the same program version.

![Diagram 2.8 — Multi-user versioned file open: the same internal file open flow as Diagram 2.6, extended with a per-user subdivision layer above the version-hash directories in Program A's storage area.](/images/hjfs/diagram-007.jpg)

Internal files that contain no user-specific data (for example, shared configuration or reference data) can be stored in a user-independent area accessible to all users of the program. Programs are restricted to read-only access of such common files to prevent one user's program session from surreptitiously modifying data visible to another.

## Relationship to basic protection

Advanced protection does not replace basic protection — it adds to it. Version isolation, per-program storage, secure file transfer, automatic data file backup, and all other basic protection features remain active. Advanced protection adds the internal/user file distinction on top.
