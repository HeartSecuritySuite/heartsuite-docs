---
title: "HeartSuite Overview"
linkTitle: "HeartSuite Overview"
weight: 1
description: "Core concepts and purpose of HeartSuite security suite."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "overview", "security", "concepts"]
type: docs
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "heartsuite-overview"
---

# Introduction

**At-a-glance**: HeartSuite proactively blocks malware by whitelisting safe programs and actions.

## What Makes HeartSuite Tick? A Technical Overview

HeartSuite takes a radical new approach to security. Instead of trying to detect and isolate malware after the fact like our competition does, we've redesigned the Linux server from the ground up to make it completely secure—by preventing attacks before they have a chance to get off the ground. Here's what sets HeartSuite apart: Even if malware is downloaded to a HeartSuite server, the architecture of HeartSuite won't allow it to execute its harmful commands, thanks to HeartSuite's unique core features. That means HeartSuite stops malware before it can be detected—up to and including zero day attacks.

## HeartSuite's Radical Approach

HeartSuite, Server Edition, was developed as an aggressive weapon to combat malware. Specifically, it was designed to achieve Security, a military term referring to actions that destroy an enemy's ability to wage war. HeartSuite engages in proactive blocks to achieve this goal. In particular, it prevents programs from starting unless they have been added to a Program Whitelist entry by an administrator using a HeartSuite tool. Moreover, HeartSuite prevents programs from accessing files unless and until access permissions for accessing those files have been added to the programs’ whitelist entry.

Likewise, HeartSuite prevents programs from accessing remote computers unless and until access permissions for accessing their Internet addresses have been added to the programs’ whitelist entry.

Attackers are notorious for convincing unsuspecting souls to download and install malicious updates to existing, useful programs. To deprive such Trojan malware from destroying files, HeartSuite automatically backs up all files designated for backup using another HeartSuite tool. Finally, the HeartSuite version manager tool can be used later to restore any version of a backed-up file, regardless of whether it was encrypted, deleted, or otherwise modified by malware. In short, HeartSuite eliminates malware by disabling its functionality, even before it can be detected.

## The Heart of HeartSuite: Core Features

Here’s a brief description of the core features that make up HeartSuite's revolutionary approach—and how they work together to bring you unparalleled protection.

### 1. Program Whitelist
The most essential feature of HeartSuite—and the one that really distinguishes it—is its use of Program Whitelist. A Program Whitelist is a collection of orders that provide access to various files, directories, and network connections. HeartSuite includes programs and scripts for easily creating and modifying whitelist entries as needed.

HeartSuite is comprised of a modified Linux kernel and tools in the form of programs and scripts. The HeartSuite kernel requires a program to have a whitelist entry before it's permitted to run. Once HeartSuite is installed, it will generate messages in both its log and the kernel log whenever a program runs that lacks a whitelist entry. A simple HeartSuite script can be used to automatically scour the logs for this error and then create the needed whitelist entry. Of course, the system administrator can also create such a record manually.

Once the whitelist entry is in place, HeartSuite will generate log messages about the files and directories that the program accesses—and it will also generate log messages about network connections the program makes. HeartSuite's simple script can find these error messages too, and then add appropriate access permissions to the program's whitelist entry. Likewise, the system administrator can add these orders manually, if preferred.

Access to files and directories is also divided into two categories: read-only and write. That means a file permission order can restrict a program so that it's only allowed to read the file, or it can permit a program to write to a file. (Write permission implies read permission as well.) Permission to access a directory for reading allows a program to not only read the directory, but also to read any file in the directory or its subdirectories. Similarly, write permission permits a program to write to any files in the directory or its subdirectories—including the creation of new files.

The HeartSuite script will also add appropriate access permissions for accessing remote computers. In particular, the IP addresses of computers that a program is trying to access are listed in the log messages. These IP addresses can then be added to the program's whitelist entry either using the script or manually. Once all access permissions have been added that are needed by the program, the HeartSuite kernel will no longer generate any error messages about that program's activities, unless it attempts to access files or network connections that have not yet been permitted.

This monitoring doesn't significantly impact performance, either. The HeartSuite caching mechanism loads only a single whitelist entry into memory for a running program—even if there are thousands of concurrent instances of that program—thereby minimizing impact on kernel memory use.

The key is to permit a program to access files and network connections that are necessary for the work that the program needs to do. A Trojan malware program, masquerading as a legitimate program, will need basic file access—but a legitimate program won't need access to all of the data files on the server. So when Trojan malware attempts to access other files—to encrypt them for ransom, for example—the HeartSuite kernel can prevent this access because it doesn't exist in the whitelist entry. Which means that in order for malware to run and cause damage, a system administrator would need to first add a whitelist entry to allow it to run, and then add file and directory permissions that would allow it to cause damage.

The Lockdown feature, discussed below, prevents attackers from adding and modifying whitelist entries. The bottom line is that each program can be controlled with fine granularity in terms of access permissions—in order to allow as much or as little access to files and network locations as desired. And because HeartSuite access permissions don't affect physical storage, they can readily overlap—which permits programs to readily share resources, such as shared libraries, without having to make copies and worry about synchronizing updates. And here's another great benefit: because application of access permissions is implemented in the modified kernel, HeartSuite can't be circumvented by any program or user—including the root user!

### 2. Setup and Secure Modes
HeartSuite starts out in Setup Mode, which helps you learn how programs behave in terms of access. While it's in Setup Mode, HeartSuite doesn't prevent any programs from running, nor does it prevent access to any files or network connections. Use of the logs during Setup Mode expedites the building of the whitelist database.

Once you've completed the database for the programs that your server runs, you'll switch HeartSuite to Secure Mode, which prevents a program from running if no whitelist entry exists—and if one does exist, from exceeding its whitelist entry configuration. You can also use these modes to test untrusted programs. By loading such programs onto a HeartSuite test server and adding them to a whitelist entry without any access permissions, you can review the HeartSuite log to determine whether the program performs only legitimate functionality or contains embedded malware. In fact, this process can even be run in Secure Mode to protect the test server.

### 3. Lockdown
Lockdown protects the integrity of the whitelist entries by preventing any changes to them. Lockdown is initiated with a simple command and can't be turned off while the server is running, thereby preventing all attacks against HeartSuite itself. If you wish to make any changes, you can simply reboot the server, which always turns Lockdown off. After you're done, you can turn Lockdown on again with the same simple command. However, a best practice is to enable the HeartSuite startup script to initiate Lockdown automatically, immediately after the server is booted. In that situation, you only need to boot to the original Linux kernel to turn Lockdown off. The HeartSuite installation routine leaves prior Linux kernels in place, recognizing that there may be times when you wish to boot to them. Once you've made your changes, simply reboot your system and HeartSuite will be restored to Lockdown status, as the default kernel in the GRUB menu.

Notably, you must have either physical or serial port access to your server in order to reboot to the original kernel—which means that attackers can't remotely reboot to the original kernel, thus providing another layer of defense.

### 4. File Backup and Versioning
Files that attackers routinely attack today are your backups. So HeartSuite makes sure to wall them off with extra protection. For starters, HeartSuite automatically backs up files in designated directories, including their subdirectories. But more importantly, HeartSuite prevents access to the backups by all programs—only HeartSuite can access the backups. HeartSuite supplies a backup configuration manager tool that admins can use to add and remove directories from the list of directories that will be backed up automatically. By means of this simple but powerful approach, HeartSuite prevents all programs from destroying or modifying backup files.

The HeartSuite version manager program can then be used to retrieve any version of the file at will. All of that means that if your staff downloads malware masquerading as legitimate software by mistake, the layers of Program Whitelist, Lockdown, and versioning will work together to minimize damage and easily let you restore your files.

### 5. Ability to Protect Interpreted Programs
Whitelist entries can also be created for interpreted code, such as Python, PHP, and Java. In particular, the code containing the main procedure is treated the same way as any ordinary executable program by HeartSuite. HeartSuite relies on programs supplied with it, known as Secure Script Launchers, to identify the code file containing the main procedure when the corresponding interpreter program (such as Python, PHP, Java, etc.) is launched. No other technology provides the granularity of control with respect to file and network access that HeartSuite does. No other product provides such an all-encompassing security architecture that combines elements of administrative control with kernel-level implementation.

## HeartSuite: Always On the Beat
These five core features are the essence of HeartSuite's groundbreaking approach to security. Of course, there's plenty more going on underneath the hood of HeartSuite—and we'd be glad to answer any technical questions you might have, or discuss HeartSuite in greater detail. Feel free to get in touch with us to ask questions or set up a further conversation.