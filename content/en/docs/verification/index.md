---
title: "Verifying Installation and Basic Setup"
weight: 30
description: "Checking HeartSuite activation and initial configuration."
categories: ["Installation"]
tags: ["heartsuite", "linux", "verification", "testing", "setup"]
toc: true
type: docs
---

## Overview

**Overview**: After installation, check if HeartSuite is active to confirm setup.

## Verifying HeartSuite Activation

To confirm that HeartSuite is running, view the kernel log messages using the following command, which may require root permission:

```bash
# dmesg | grep HEARTSUITE
```

If HeartSuite is running, there will be at least two informational messages displayed in the log, one indicating that HeartSuite has been activated and another indicating its operation mode, Setup or Secure.

If HeartSuite was not running when activated, a message indicating the size of the whitelist entries cache will also be added to the kernel log. A simple activation message will also be added to the HeartSuite log file:

### Interpreting Log Messages

**Tip**: Look for activation and mode messages (Setup or Secure) in the output to verify success.

