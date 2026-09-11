---
title: "What Lockdown refused after root already had a shell"
linkTitle: "Lockdown after a root shell"
date: 2026-09-11
slug: lockdown-after-a-root-shell
draft: false
description: "On stock AppArmor and targeted SELinux, unconfined root read another application's file until extra policy was added, then turned that policy off without a reboot. Under Lockdown the same ledger path could not be created, and the allowlist write was refused."
author: "Ron Hessing"
tags: ["root-lock", "selinux", "apparmor", "lockdown", "allowlisting"]
toc: true
---

SSH as root. The job is the same on three hosts: read a file that belongs to another program.

```text
/var/lib/vaultapp/customer-ledger.secret
```

Ubuntu 24.04 with AppArmor. Rocky Linux 9 with SELinux targeted Enforcing. Debian 12 running Root Lock by HeartSuite **6.18.9-hs** with Lockdown on.

Stock Ubuntu AppArmor does not confine `cat`. Stock Rocky targeted policy maps root to `unconfined_u`, and [Red Hat documents](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/managing-confined-and-unconfined-users_using-selinux) that unconfined users, including administrators, are only minimally restricted. On both of those hosts, unconfined root `cat` of the ledger succeeded while the LSM was loaded.

LSM policy is applied to a running kernel from userspace, and unconfined root is the common SSH case.

The AppArmor and SELinux hosts then got a deny for that path: a profile on `cat` that still lets `vaultapp` read its own ledger, and a `vaultapp_secret_t` type that still lets a confined `vaultapp_t` read it.

## AppArmor

After that profile, root `cat` failed. `vaultapp` still printed the ledger.

```text
cat: /var/lib/vaultapp/customer-ledger.secret: Permission denied
apparmor="DENIED" operation="open" profile="demo-agent-cat"
 name="/var/lib/vaultapp/customer-ledger.secret" requested_mask="r"
```

![AppArmor denies cat; vaultapp still reads](apparmor-denied.png)

Root then ran [`aa-disable`](https://apparmor.net/man/master/aa-disable/):

```bash
aa-disable /etc/apparmor.d/demo-agent-tools
```

`cat` printed the three ledger lines. AppArmor itself was still loaded. Only that profile was gone.

![AppArmor profile disabled, ledger in the clear](apparmor-bypass.png)

Root can unload an AppArmor profile without rebooting.

## SELinux

After the custom type, the same `cat` failed under Enforcing. `vaultapp` still printed the ledger.

```text
cat: /var/lib/vaultapp/customer-ledger.secret: Permission denied
avc: denied { read } for comm="cat" name="customer-ledger.secret"
 scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
 tcontext=unconfined_u:object_r:vaultapp_secret_t:s0
 tclass=file permissive=0
```

![SELinux AVC denies unconfined cat; vaultapp still reads](selinux-denied.png)

Root then ran [Red Hat: permissive mode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux):

```bash
setenforce 0
```

`getenforce` was Enforcing, then Permissive. `cat` printed the same three ledger lines. Policy stayed on disk. Mode from the config file stayed enforcing.

![SELinux set permissive from Enforcing, ledger in the clear](selinux-bypass.png)

Root can set SELinux to permissive without rebooting.

## Root Lock

Lockdown was already on. SSH as root still worked.

```text
# mkdir -p /var/lib/vaultapp
mkdir: cannot create directory '/var/lib/vaultapp': Unknown error 242
# /usr/local/bin/vaultapp
bash: /usr/local/bin/vaultapp: Permission denied
```

The kernel refused the create.

![Root Lock refuses the ledger path](rootlock-same-path.png)

| Move | Result under Lockdown |
|---|---|
| add a `cat` grant for the ledger | write refused |
| `chattr -i` on the allowlist | `Permission denied while reading flags` |
| `cat` of the ledger | No such file or directory |

![Root Lock refuses the allowlist write](rootlock-denied.png)

The allowlist is sealed. The files are immutable, and the kernel refuses the write.

Setup Mode harvested a wide `/etc` grant for `cat`, so host keys in `/etc/ssh` were readable. Unsealing takes physical or serial-console access.

## What the kernel refused

| Step | AppArmor | SELinux | Root Lock in Lockdown |
|---|---|---|---|
| Default distro policy vs unconfined root `cat` of the ledger | Allowed | Allowed | `mkdir /var/lib/vaultapp` refused |
| After a deny for `cat` on that path | Denied | Denied | `mkdir` already failed |
| Owning program | `vaultapp` still reads | `vaultapp` still reads | `vaultapp` could not be executed |
| Root disable | `aa-disable` the profile | `setenforce 0` | Allowlist add refused; `chattr` refused |
| Second `cat` | Ledger in the clear | Ledger in the clear | No such file or directory |

SELinux and AppArmor are LSM policy root can set permissive or unload. Root Lock is compiled into the kernel; Lockdown seals the allowlist.
