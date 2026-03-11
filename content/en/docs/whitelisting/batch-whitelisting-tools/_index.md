---
title: "Batch Whitelisting Tools"
weight: 4
description: "Tools for bulk whitelisting programs and managing logs."
categories: ["Guides"]
tags: ["heartsuite", "linux", "batch", "whitelist", "tools", "logs"]
type: docs
toc: true
menu:
  main:
    parent: "whitelisting"
    identifier: "batch-whitelisting-tools"
---


# Other tools for adding records in batch

## Preparing Program Paths

A few other tools are included to aid in creating whitelist entries in batch. Because you need the absolute path to a program in order to whitelist it, a Python script named realpath_generator.py has been included for this task. This script accepts the name of a file containing names of programs, one per line; it then outputs their absolute paths if they are found using the PATH variable. You can capture the output by redirecting it to a file, as in this example:

```bash
# python3 realpath_generator.py program_names.txt > abs_program_names.txt
```

You can then use one of the batch scripts to create whitelist entries. If a program is not found by this Python script because it is not located with a path found in the PATH variable, you must find the program’s path manually.

## Creating Whitelist Entries in Batch

The batch_record_add_root.py script will create new whitelist entries that give programs access permissions to read any file. A more secure choice would be the batch_record_add.py script, which adds only limited access permissions that are generally needed for a program to execute. Specifically, this latter Python script adds only read access for the /usr/lib and /etc directories because, on Debian-based systems, programs routinely rely on files contained in those directories when they start. By using this more limited whitelist entry, you can watch for permission error messages and slowly add needed access permissions.

## Root Access Considerations

Please note that the /.hs/sys directory is owned by root; therefore, you can experience problems when creating files in that directory while using sudo. The easiest solution is to start a sudo shell, using the following command:

```bash
# sudo -s
```

You can then run any command as root. You can exit that shell by pressing Ctrl-d.

## Clearing and Monitoring Logs

Also, because error messages can quickly accumulate in the HeartSuite log, a simple utility permits you to easily clear the log. Run the following command as root to clear the log:

```bash
# /.hs/sys/empty_HS_log.sh
```

Further, by leaving your server running continuously, the HeartSuite and kernel logs will eventually capture information about the programs executed in conjunction with systemd timers and cron jobs, as mentioned above. Again, use the same procedure to add them to the HeartSuite whitelist database.