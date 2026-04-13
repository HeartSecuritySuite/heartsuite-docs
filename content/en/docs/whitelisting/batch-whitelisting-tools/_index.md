---
title: "Batch Allowlisting Tools"
weight: 4
description: "Tools for bulk allowlisting programs and managing logs."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "allowlist", "tools", "logs"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "batch-allowlisting-tools"
---


# Other tools for adding records in batch

## Preparing Program Paths

A few other tools are included to aid in creating allowlist entries. Because you need the absolute path to a program in order to allowlist it, the dashboard review tools handle this with metadata. You can review from the dashboard. 

You can then use the dashboard review tools to handle entries safely. If a program is not found, the metadata prompts provide context.

## Creating Allowlist Entries in Batch

The dashboard review tools handle batch-like events safely with samples and metadata. A more secure choice is to review individually, which adds only the limited access permissions generally needed. Specifically, this provides samples and metadata for the /usr/lib and /etc directories because, on Debian-based systems, programs routinely rely on files contained in those directories when they start. By using the review tools from the dashboard, you can watch for events and slowly add needed access permissions.

## Root Access Considerations

Please note that the /.hs/sys directory is owned by root; therefore, you can experience problems when creating files in that directory while using sudo. The easiest solution is to start a sudo shell, using the following command:

```bash
# sudo -s
```

You can then run any command as root. You can exit that shell by pressing Ctrl-d.

## Clearing and Monitoring Logs

Also, because events can quickly accumulate, the dashboard review tools manage them without showing raw logs. The tools handle this automatically.

Further, by leaving your server running continuously, the HeartSuite and kernel events will eventually be captured. Again, use the review tools from the dashboard to add them to the allowlist.