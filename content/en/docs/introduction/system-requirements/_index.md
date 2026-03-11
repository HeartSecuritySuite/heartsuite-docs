---
title: "System Requirements"
weight: 3
description: "Hardware and software prerequisites for HeartSuite compatibility."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "requirements", "specs", "debian", "x86"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "system-requirements"
---


## Overview

These specs ensure compatibility with HeartSuite's kernel modifications. This edition of HeartSuite was compiled on a Debian 11 server, running on an x86 chipset. Therefore, it is binary compatible with any Linux distro derived from Debian or Ubuntu running on an x86 chipset. Additionally, HeartSuite is distributed as a set of tools and a gingerly modified version of the mainline Linux kernel, specifically version 5.19.6. Accordingly, this modified kernel must be booted in order to utilize HeartSuite.