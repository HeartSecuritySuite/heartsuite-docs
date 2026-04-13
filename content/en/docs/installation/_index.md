---
title: "Obtaining and Installing HeartSuite"
weight: 20
description: "Download, installation steps, and preliminary setup for virtual machines."
categories: ["Installation"]
tags: ["heartsuite", "linux", "setup", "kernel", "download", "beginner"]
toc: true
type: docs
menu:
  main:
    identifier: "installation"
---


## Overview

**What you'll do**: Download and extract HeartSuite, run the installer, reboot to load the modified kernel, and auto-allowlist essential startup programs by running a setup script multiple times.

**Why**: This process integrates HeartSuite's security features without disrupting your system—HeartSuite blocks unauthorized actions by default, so proper setup prevents boot failures or hangs.

Follow these sub-guides for detailed steps:

- [Obtaining HeartSuite](obtaining-heartsuite/) - Download the distribution from the website.
- [VM Preparation](vm-preparation/) - Configure GRUB settings for virtual machines on clouds.
- [Installation Part 1](installation-part1/) - Extract, install, and reboot to load the kernel.
- [Installation Part 2](installation-part2/) - Auto-allowlist startup programs with the setup script.