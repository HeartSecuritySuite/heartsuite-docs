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

To confirm that HeartSuite is running and to orient yourself, access the Dashboard (`hs-dashboard` or on boot). The Dashboard surfaces current mode (Setup or Secure), phase status, and Suggested Next Step.

If the system is in Setup Mode with no prior allowlisting, the Dashboard indicates this state along with pending events and orients you without raw log output.

### Interpreting Log Messages

**Tip**: The Dashboard provides immediate verification of activation, mode (Setup or Secure), and Suggested Next Step. It orients you in the guided journey without raw logs; for Setup Mode with no prior allowlisting it surfaces pending events and next actions like beginning allowlisting. See the Dashboard for full details.

