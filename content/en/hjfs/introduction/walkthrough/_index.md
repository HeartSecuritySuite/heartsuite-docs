---
title: "Walkthrough: per-version isolation"
linkTitle: "Walkthrough"
weight: 3
description: "Upgrade a program, keep v1's data out of v2's reach, roll back. A short CLI walkthrough of HJFS per-version isolation."
categories: ["Essentials"]
tags: ["hjfs", "walkthrough", "example", "version-management"]
type: docs
toc: true
---

> **Prototype**: Commands and output shown reflect the current prototype and may change.

**Overview**: Each installed version of a program has its own storage area. After an update, the new version cannot open files the old version created. Rolling back makes the old files available again — they were never copied into the new area.

See [HJFS overview](../hjfs-overview/#per-version-storage) for why. This walkthrough is the CLI shape of that rule.

## 1. Check the installed program version

```sh
$ ./start_TinyDemo -V
TinyDemo v1.0
```

## 2. Write and read a data file under v1

The `w` flag writes text to a file; `r` reads it back. Both calls run as TinyDemo v1, so they share v1's storage area.

```sh
$ ./start_TinyDemo w FileA
$ ./start_TinyDemo r FileA
The apple was a shiny red color.
```

## 3. Build and install a new version

```sh
$ ./make_TinyDemo-2.sh
$ ./HJFS_update_program TinyDemo TinyDemo TinyDemo.hash
```

List installed versions. The identifiers are install-time labels; HJFS enforces the hash.

```sh
$ ./HJFS_version_manager TinyDemo -l
260208_123022P  TinyDemo v1.0  (hash …)
260208_124510P  TinyDemo v2.0  (hash …)  [active]
```

## 4. v2 cannot read v1's FileA

v2 is now active. `FileA` still exists in v1's storage area. It is not in v2's.

```sh
$ ./start_TinyDemo -V
TinyDemo v2.0
$ ./start_TinyDemo r FileA
FileA: not in this version's storage area
```

That miss is the isolation. A malicious update is a new hash, so it starts with an empty area and cannot open the prior version's files. To give v2 a copy, use the file transfer utility — not `open()` from v2. See [Secure file transfer](../hjfs-overview/#secure-file-transfer-between-programs).

## 5. Write FileA under v2

v2 can create its own `FileA`. That is a different file in a different area. v1's copy is unchanged.

```sh
$ ./start_TinyDemo w FileA
$ ./start_TinyDemo r FileA
The pear was a dull green color.
```

## 6. Roll back to v1

Confirm the active version, then set it back to the first. Rollback does not copy or merge files. It makes v1's area the one `open()` resolves.

```sh
$ ./HJFS_version_manager TinyDemo -c
260208_124510P  TinyDemo v2.0  [active]
$ ./HJFS_version_manager TinyDemo -s 260208_123022P
$ ./start_TinyDemo -V
TinyDemo v1.0
$ ./start_TinyDemo r FileA
The apple was a shiny red color.
```

v2's pear is still in v2's area. It is not gone; it is not visible while v1 is active. The file transfer utility can copy it across if you need it. See [Version rollback](../hjfs-overview/#version-rollback).
