---
title: "Using HeartSuite Log"
weight: 2
description: "Monitoring permission errors and adding program access via the HeartSuite activity log."
categories: ["Guides"]
tags: ["heartsuite", "linux", "permissions", "allowlist", "log", "security"]
type: docs
toc: true
menu:
  main:
    parent: "allowlisting"
    identifier: "using-heart-suite-log"
---

# Introduction to using the HeartSuite log

While running, HeartSuite always attempts to capture permission errors to the HeartSuite log, `/.hs/sys/hs-activity-log.txt`. Initially, it will report programs that are executed and that are not allowlisted. For example, if you run the nano program before allowlisting it, the HeartSuite log will contain the following entry:

```text
[Setup Notice - Add program to Allowlist?] Not Whitelisted: /usr/bin/nano
```

After observing this message, you can allowlist the nano program manually, as root, as follows:

```bash
hs-review-programs
```

--OR, IF RUNNING AS ROOT--

```bash
hs-review-programs
```

## Adding Program Permissions

## Granting File Access Permissions

If you then run nano again, HeartSuite will start reporting access permission errors for all files that nano accesses and the IP address of any remote servers that it connects to. Please note that nano, like most programs, relies on shared libraries to execute; accordingly, those libraries will be listed in the HeartSuite log as files accessed without permission. For example, after allowlisting nano on a Debian server and running it again, the following file access permission errors were generated:

```text
[Setup Notice - Add to Allowlist?] File Access Attempt Logged: Program: /usr/bin/nano; File: /etc/ld.so.cache
```

In fact, additional file access permission error messages were generated, but they are not shown in the example for the sake of brevity. In order to grant nano access permissions to those files, you must add file permissions to the allowlist entry for nano. Specifically, you must add either the directories in which the files are located or the complete file paths themselves. In fact, you can include one directory or file path at the time the allowlist entry for nano is created. For example, to add the directory /usr/lib to the allowlist entry when it is created, you would use a modified version of the prior command:

```bash
hs-review-files
```

Thereafter, you can add more directories and file paths to the nano allowlist entry in two ways. One way uses the program name, the other uses the program's allowlist entry number. For example, to add the /etc directory to the nano allowlist entry, use the following command after the nano allowlist entry has been created:

```bash
# sudo /.hs/sys/hs-allowlist-manager add -x /usr/bin/nano -d /etc
```

Otherwise, you can extract the allowlist entry number using the list command, coupled with a simple grep (or use dashboard for metadata):

```bash
hs-review-files
```

In this example, because HeartSuite has assigned the temporary record number 276 to the nano allowlist entry, you can use the record number as follows to add the /etc directory:

```bash
hs-review-files
```

> [!TIP]
> Allowlist entry numbers change if you remove items – always check the latest list.

**Tip**: Use directories for broad access (e.g., /usr/lib for libraries) or files for precise control (e.g., a specific script).

## Granting Write Permissions

Noticeably, all of these examples grant read-only file access to files. In order to grant write permission (which includes read permission, as well) you must prefix either the directory name or file path with a capital ‘W’. For example, to permit the nano program to write to a file named setup.sh in the home directory of user ‘admin’, use the following command:

```bash
hs-review-files
```

To grant nano permission to write to all files in admin’s home directory, use this command instead:

```bash
hs-review-files
```

## Granting Network Access Permissions

### Example: Allowlisting wget

The same procedures apply to learning which remote servers a program attempts to access, as well as permitting the program to access particular remote servers. This edition of HeartSuite is strictly limited to specific IPv4 and IPv6 addresses, it cannot regulate network access using address ranges or domain names. Address ranges and domain name-based access, however, are planned for later editions.

For example, suppose that a allowlist entry is created for the wget program without adding any network permissions. Then, the program is used to obtain an HTML document from a website, as follows:

```bash
# wget https://example.com/agreement.html
```

The following permission error message concerning network access appears in the log file:

```text
[Setup Notice - Add to Network Allowlist?] Network Connection Attempt Logged by /usr/bin/wget; IP: 45.60.22.168
```

You can add this IP address to the allowlist entry for wget as follows (via tiered review queue with metadata prompts):

```bash
hs-review-network
```

– or –

```bash
hs-review-network
```

The next time you run the same wget command, there will be no permission error message in the log for this IP address access. Use hs-review-* queues from the dashboard (per UX §§8.1-8.2,11); tiered review with metadata avoids raw logs and blind bulk (per §14).