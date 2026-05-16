---
title: "Walkthrough: per-version isolation"
linkTitle: "Walkthrough"
weight: 3
description: "A short CLI walkthrough showing how HJFS preserves data across program versions, including rollback."
categories: ["Essentials"]
tags: ["hjfs", "walkthrough", "example", "version-management"]
type: docs
toc: true
menu:
  main:
    parent: "hjfs-introduction"
    identifier: "hjfs-walkthrough"
---

> **Prototype**: Commands and output shown reflect the current prototype and may change.

This walkthrough uses a small demonstration program, `TinyDemo`, to show how HJFS keeps data files tied to the specific program version that created them. The same flow is shown in the [demo video](../../#see-it-in-action).

## 1. Check the installed program version

```sh
$ ./start_TinyDemo -V
TinyDemo v1.0
```

## 2. Write and read a data file

The `w` flag writes text to a file; `r` reads it back.

```sh
$ ./start_TinyDemo w FileA
$ ./start_TinyDemo r FileA
The apple was a shiny red color.
```

## 3. Build and install a new version

```sh
./make_TinyDemo-2.sh
./HJFS_update_program TinyDemo TinyDemo TinyDemo.hash
```

List installed versions:

```sh
./HJFS_version_manager TinyDemo -l
```

## 4. Read the existing file from the new version

`FileA` is still readable — its contents are unchanged:

```sh
$ ./start_TinyDemo r FileA
The apple was a shiny red color.
```

## 5. Overwrite under the new version

```sh
$ ./start_TinyDemo w FileA
$ ./start_TinyDemo r FileA
The pear was a dull green color.
$ ./start_TinyDemo -V
TinyDemo v2.0
```

Both versions of `FileA` now exist — version 2 did not destroy or alter the original. Each version owns its own copy in its own storage area.

## 6. Roll back to the prior version

Confirm the current active version, then set it back to the first:

```sh
$ ./HJFS_version_manager TinyDemo -c
$ ./HJFS_version_manager TinyDemo -s 260208_123022P
$ ./start_TinyDemo r FileA
The apple was a shiny red color.
```

The original data is restored — no backup retrieval, no restore process. The user can switch between versions at will, and HJFS preserves data across every version, including versions that turn out to be malicious updates.

## What this demonstrates

- Per-version storage areas (see [HJFS Overview](../hjfs-overview/#per-version-storage)).
- Non-destructive rollback (see [Version rollback](../hjfs-overview/#version-rollback)).
- The `HJFS_update_program` and `HJFS_version_manager` utilities (see [Version management](../hjfs-overview/#version-management)).
