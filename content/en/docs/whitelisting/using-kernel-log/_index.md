---
title: "Using the Kernel Log"
weight: 3
description: "Accessing permission errors in the kernel log with dmesg."
categories: ["Guides"]
tags: ["heartsuite", "linux", "logs", "kernel", "dmesg", "permissions"]
type: docs
toc: true
menu:
  main:
    parent: "whitelisting"
    identifier: "using-kernel-log"
---

## Introduction to using the kernel log

Depending on you distro, some permission error messages may not appear in the HeartSuite log; instead, they are placed in the kernel log. You can easily obtain the kernel log with the following command, which may require root privilege:

```bash
# dmesg
```

In order to readily extract only the HeartSuite messages, use grep:

```bash
# dmesg | grep HEARTSUITE
```

Use **hs-os-boot-setup.py** or add manually with **hs-whitelist-manager** (see --help for examples).

Please note that any program added to the whitelist database using the **hs-os-boot-setup.py** script is granted access permissions allowing it to access every file, or directory, specified in log messages. Therefore, it is strongly recommended that you use the **hs-os-boot-setup.py** script cautiously. Specifically, we recommend that you use it before any adding programs that do not come with your distro. We have found that it can take several days, possibly a week, to capture all of the relevant log messages involving processes run by systemd timers and cron jobs. Once this essential information is captured, we strongly recommend that you switch to other means. Primarily, we strongly recommend that you add access permissions manually so that you can tailor access permissions to a “need-to-access” basis only. If you have several programs that require similar permissions, you can use one of our other scripts, which you can also modify easily for your needs. Finally, you can use the **hs-whitelist-manager** tool to review the access permissions of all programs and restrict them on the basis of need-to-access.
