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

Under basic protection, malware is confined to its own program's storage area but can still silently access the user's own documents. Advanced protection closes this gap: it subdivides each program's storage area into internal files and user files, and requires OS mediation before any user file can be opened. HJFS provides two levels of protection:

| Protection level | OS changes | App changes | Description |
|---|---|---|---|
| Basic protection | Yes | No | Program and version isolation. All current HJFS v1.0 capabilities. |
| Advanced protection | Yes | Yes | Adds internal/user file separation and OS-mediated file access. Requires application updates. |

Basic protection is the foundation — it runs existing software unchanged. Advanced protection builds on top of it and delivers stronger guarantees for user-facing data files, at the cost of requiring applications to be updated to use the new OS functions.

## Internal files and user files

Advanced protection subdivides each program's per-version storage area into two types.

**Internal files** are managed directly by the program using file names. They are hidden from user utilities — they cannot be browsed, copied, or accessed outside the program that owns them. A spell-checker dictionary, a configuration file, or game state data are examples of internal files.

**User files** are the data the user interacts with directly: documents, spreadsheets, images. A program cannot open a user file by specifying its name. Instead, the program invokes a system function that presents a standard OS file-selection dialog. The user makes the selection. The OS opens the file and passes a file handle to the program — not a path. The program never learns the file's location in the broader filesystem.

This means malware cannot open user files without the user's knowledge. It must wait for the user to open a file through the dialog. Even then, the user can restrict the opened file to read-only access for the program — the equivalent of handing the scribe a document without the pen.

![Diagram 2.6 — Advanced versioned file open (internal): Program A calls open(file2a), the OS determines program name and version, and locates the file in the "internal" subarea of the matched version-hash directory. A separate "user" subarea exists alongside it.](/images/hjfs/diagram-005.jpg)

When the user opens a user file, a file-selection dialog appears. The user picks the file; the OS resolves and opens it, passing only a handle to the program:

![Diagram 2.7 — User file open via dialog: Program A calls user_open(), the OS presents a File Open Dialog Box, the user selects "Chapter1.docx," the OS determines program name and version, locates the file in the "user" subarea, and returns a handle.](/images/hjfs/diagram-006.jpg)

## Exporting and importing data

Because internal files are hidden and user files require OS mediation, HJFS advanced protection provides two explicit system functions for moving data across the boundary:

**Export**: A program can write internal file data to a user file, making it available to the user or to other programs. To prevent data mixing, no other user file may be open by the program during the export operation.

**Import**: A program can read from a user file and write the data into its internal files. This is the standard path for a program to accept externally supplied data — a document being opened for editing, for example.

Both functions are explicit, auditable, and user-initiated through the OS dialog.

## Why this matters

The combination of both protection levels means:

- No program can access files belonging to another program.
- No program can access the user's own files without an OS-mediated dialog in which the user makes the selection.

## Multiple users

On a multi-user system, each user's storage is kept separate first. Within that per-user space, storage is divided by program. Within each program, storage is divided by version. Within each version, storage is split into internal and user subareas. A program running as user X cannot access files created by user Y, even within the same program version.

![Diagram 2.8 — Multi-user versioned file open: the same internal file open flow as Diagram 2.6, extended with a per-user subdivision layer above the version-hash directories in Program A's storage area.](/images/hjfs/diagram-007.jpg)

Internal files that contain no user-specific data — shared configuration or reference data, for example — can be stored in a user-independent area accessible to all users of the program. Programs are restricted to read-only access of such common files to prevent one user's program session from modifying data visible to another without the other user's knowledge.

## Relationship to basic protection

Advanced protection does not replace basic protection — it adds to it. Version isolation, per-program storage, secure file transfer, automatic data file backup, and all other basic protection features remain active. Advanced protection adds the internal/user file distinction on top.
