---
title: "Appendices"
weight: 110
description: "List of included HeartSuite tools."
categories: ["Reference"]
tags: ["heartsuite", "linux", "tools", "executables", "scripts", "reference"]
type: docs
toc: true
---

# Appendix: Included HeartSuite Tools

The dashboard is the primary interface for most users and provides access to the review tools (hs-review-programs, hs-review-files and hs-review-network) along with guided prompts and metadata. Low-level scripts and direct manager commands below are for advanced or specific cases only.

With exception of the Secure Script Launchers, all of the tools are located in the /.hs/sys directory. Please note that the HeartSuite installation routine does NOT add this directory to the PATH environment variable. The Secure Script Launchers are located in the /usr/bin directory because it is in the default PATH variable. As mentioned above, the programs and scripts that write data to the HeartSuite databases must be run as root.

**Note**: These tools are essential for managing HeartSuite—start with --help for command details.

## Executable Tools

A brief description of each program follows. The description also notes if a program includes help instructions, which may be accessed with the --help command line option or by starting the program without any command line arguments.

- **activate_HS** -- turns HeartSuite service on; the installation routine adds a systemd service that automatically runs this program at startup (use to enable after boot)
- **hs-cache-size** -- used to change the maximum number of allowlist entries that may be cached simultaneously; please view program help for details (adjust for performance)
- **hs-allowlist-manager** – manages access permissions that allow programs to run, as well as which directories and remote computers they may access; please view program help for details (core tool for permissions; most users should use dashboard review tools instead)
- **hs-backup** -- used by HeartSuite to back up files; you never need to execute this program directly! (auto-handled)
- **hs-backup-config-manager** -- use this program to specify a list of directories; only files in directories designated using this program are backed up automatically by HeartSuite when modified (e.g., add /home)
- **hs-curfew** -- stops HeartSuite from backing up files; this state must be achieved so that HeartSuite does not interfere with normal shutdown; the setup procedure adds a systemd service that automatically executes this program just before a shutdown or reboot (prevents backup conflicts)
- **hs-mode-switch** -- used to change whether HeartSuite starts in Setup or Secure mode; please view program help for details (key for mode changes)
- **hs-python-launcher, hs-python2-launcher, hs-perl-launcher, hs-php-launcher** -- Secure Script Launchers included with this version (use for secure script execution)
- **hs-unlock-progs** -- switches all HeartSuite files back to being mutable (after lockdown)
- **hs-secure-script-launcher-manager** -- configures the names of the interpreter programs that Secure Script Launchers launch (set up interpreters)
- **hs-verify-reg** – used by HeartSuite to verify registration; do not run this program directly (internal only)
- **hs-version-manager** -- permits restoring prior versions of backed up files; please view program help for details (restore from backups)
- **hs-lockdown** -- protects HeartSuite settings in Secure mode by making all HeartSuite files immutable (enables protection)
- **hs-activate-subscription** – activates the server using your HeartSuite subscription (required for Secure mode)

## Python Scripts

Each script contains help information, which is displayed when the script is started without any command line arguments.

- **hs-os-boot-setup.py** – scans the HeartSuite log and the kernel log for permission error messages and uses them to construct appropriate allowlist entries (advanced; most users should use dashboard review tools instead)
- **batch_record_add.py** -- adds programs listed in a file to allowlist entries, as well as basic directory access (use with caution or prefer dashboard review tools)
- **batch_record_add_root.py** -- adds programs listed in a file to allowlist entries, as well as read access to all files; USE THIS SCRIPT WITH CAUTION, IF AT ALL (prefer dashboard review tools)
- **extract_program_names.py** -- extracts program names from a log file
- **realpath_generator.py** -- generates the absolute path to programs

## Shell Scripts

These scripts do not include help information, but they are very simple to read and understand.

- **empty_HS_log.sh** -- resets the HeartSuite log file to zero bytes
- **init_base_records.sh** -- used by the installation script to add the Linux Standard Base (LSB) programs to allowlist entries, as well as certain essential programs; this script is used only once-- during Part 1 of installation
- **HS_lockdown.sh** -- makes files and directories immutable using chattr, then executes the hs-lockdown program; EDIT THIS SCRIPT TO MEET YOUR NEEDS (dashboard also provides mode and lockdown controls)
- **HS_startup.sh** – called by the systemd heartsuite.service unit immediately after booting; it activates HeartSuite automatically; by default, it also engages lockdown if Secure mode is chosen; EDIT THIS SCRIPT TO MEET YOUR NEEDS
- **HS_unlock.sh** -- runs the hs-unlock-progs program and then makes other files and directories mutable again; this script is the counterpart to HS_lockdown.sh; EDIT THIS SCRIPT TO MEET YOUR NEEDS
