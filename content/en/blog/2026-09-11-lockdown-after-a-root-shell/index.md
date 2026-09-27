---
title: "What Lockdown refused after root already had a shell"
linkTitle: "What Lockdown refused"
date: 2026-09-11
slug: lockdown-after-a-root-shell
draft: false
description: "On Ubuntu AppArmor and Rocky SELinux, root read another application's file until extra policy was added, then turned that policy off without a reboot. Under Lockdown the same ledger path could not be created, and the allowlist write was refused."
author: "Ron Hessing"
tags: ["root-lock", "selinux", "apparmor", "lockdown", "allowlisting"]
toc: true
---

You are logged in over SSH as root, and the job is to read a file that belongs to another program:

```text
/var/lib/vaultapp/customer-ledger.secret
```

`vaultapp` is a demo program, and its ledger is the file no other tool should read. The same job ran on three hosts, Ubuntu 24.04 with AppArmor, Rocky Linux 9 with SELinux Enforcing, and Debian 12 running Root Lock by HeartSuite with Lockdown on, and none of them was rebooted along the way.

On Ubuntu and Rocky the file was already on disk, and default policy let root `cat` it. Those two hosts then got extra policy that denied `cat` while still letting `vaultapp` read the ledger, and the same root shell then tried to turn that policy off.

## The same job, in order

### AppArmor

Ubuntu's AppArmor does not confine `cat` by default, so the demo added a profile for it. With that profile loaded, root `cat` failed and `vaultapp` still printed the ledger.

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

`cat` printed:

```text
VAULTAPP-LEDGER
customer=acme-healthcare
token=HS-DEMO-LEDGER-2026-09-11
```

AppArmor itself was still loaded; only that one profile was gone, which is enough, because root can unload an AppArmor profile without rebooting.

![AppArmor profile disabled, ledger in the clear](apparmor-bypass.png)

### SELinux

Rocky followed the same steps. There root maps to `unconfined_u`, and [Red Hat documents](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/managing-confined-and-unconfined-users_using-selinux) that unconfined users, including administrators, are only minimally restricted.

So the demo labeled the ledger with a custom type. Under Enforcing, the same `cat` then failed, and `vaultapp` still printed the ledger.

```text
cat: /var/lib/vaultapp/customer-ledger.secret: Permission denied
avc: denied { read } for comm="cat" name="customer-ledger.secret"
 scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
 tcontext=unconfined_u:object_r:vaultapp_secret_t:s0
 tclass=file permissive=0
```

![SELinux denies cat; vaultapp still reads](selinux-denied.png)

Root then set SELinux to permissive ([`setenforce 0`](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux)):

```bash
setenforce 0
```

`getenforce` went from Enforcing to Permissive, while the config file still said enforcing and the policy stayed on disk. `cat` printed the same three ledger lines, because root can set SELinux to permissive without rebooting.

![SELinux set permissive from Enforcing, ledger in the clear](selinux-bypass.png)

### Root Lock

On the third host Lockdown was already on, and SSH as root still worked. The ledger was never staged here, so root's first move is to create the path:

```text
# mkdir -p /var/lib/vaultapp
mkdir: cannot create directory '/var/lib/vaultapp': Unknown error 242
# /usr/local/bin/vaultapp
bash: /usr/local/bin/vaultapp: Permission denied
```

Unknown error 242 is the kernel refusing `mkdir` under Lockdown, and running `vaultapp` is refused too. Because the create is refused, the ledger never exists on this host, and there is no second `cat` to compare.

![Root Lock refuses the ledger path](rootlock-same-path.png)

`setenforce` and `aa-disable` are not on Debian 12, and a missing binary would prove nothing about the kernel anyway. The equivalent move here is a write to the allowlist:

| Move | Result under Lockdown |
|---|---|
| add a `cat` grant for the ledger | write refused |
| `chattr -i` on the allowlist | `Permission denied while reading flags` |
| `cat` of the ledger | No such file or directory |

![Root Lock refuses the allowlist write](rootlock-denied.png)

The allowlist is sealed: its files are immutable, and the kernel refuses the write.

To compare the same file across two programs, take one that is already on disk, `/opt/heartsuite/src/main.py`. `cat` has no grant for it, while `/usr/bin/python3` is the Dashboard interpreter and is granted that tree:

```text
# cat /opt/heartsuite/src/main.py
cat: /opt/heartsuite/src/main.py: Permission denied
# python3 -c "print(open('/opt/heartsuite/src/main.py').readline())"
# SPDX-License-Identifier: BUSL-1.1
```

Both commands ran as root, and the kernel answered differently because grants follow the program, not the user.

![cat denied; python3 reads the same file](rootlock-held.png)

## What the kernel refused

| Step | AppArmor | SELinux | Root Lock in Lockdown |
|---|---|---|---|
| Default policy vs root `cat` of the ledger | Allowed | Allowed | `mkdir /var/lib/vaultapp` refused |
| After a deny for `cat` on that path | Denied | Denied | Create already refused |
| `vaultapp` | still reads | still reads | could not be executed |
| Root disable | `aa-disable` the profile | `setenforce 0` | Allowlist add refused; `chattr` refused |
| Second `cat` | Ledger in the clear | Ledger in the clear | No file |
| Same file, different program | `vaultapp` still reads | `vaultapp` still reads | `cat` denied; `python3` reads |

AppArmor and SELinux both stopped `cat` once someone wrote policy for it, and root turned that policy off from the same shell. Root Lock is in the kernel, and under Lockdown the allowlist is sealed, so the same root shell that disabled the other two could not add a grant for itself here.

What Lockdown holds is exactly what you approved in Setup Mode. A grant is as wide as you make it — approve `cat` on all of `/etc`, and the SSH host keys in `/etc/ssh` come with it — so narrow the grants before you lock down. Changing them afterwards means unsealing, which takes physical or serial-console access — the one way out of Lockdown, and not one a remote root shell has. Within those two limits, a root shell on a Lockdown host is held to what each program was approved for. See [Lockdown](https://docs.heartsecsuite.com/rootlock/lockdown/).
