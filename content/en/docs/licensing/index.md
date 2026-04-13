---
title: "Licensing and Subscription"
weight: 70
description: "Applying licenses and activating subscriptions."
categories: ["Installation"]
tags: ["heartsuite", "linux", "license", "subscription", "activation"]
toc: true
type: docs
---

# Licensing

## Configuring Automatic File Backup

**Overview**: HeartSuite auto-backs up files in specified dirs (e.g., /home) to recover from malware edits.

HeartSuite uses a separate database of directories to determine whether to backup a file that has been written. By default, the backup configuration database includes only a single directory, /home. You can remove it, as well as add additional directories, by using the hs-backup-config-manager tool. HeartSuite will automatically backup each file in these specified directories, including those within their subdirectories, when the contents of the file are changed by writing.

## Switching to Secure Mode and Subscription

## Subscription

**Overview**: Activate with your license key for Secure mode. The Dashboard shows subscription status alongside alerts.

In order to switch from Setup to Secure mode, you need a subscription for your server; you must also activate the server using the subscription. The subscription is a simple text file; however, one subscription can potentially be used to activate up to 9999 servers. At the time you purchase your subscription, you must specify how many servers you want to be covered by the subscription. You can purchase additional subscriptions, if needed.

After you have downloaded the subscription file, you must copy it to each server that it covers. Regardless of the name of your subscription file, you must copy it to each server as, “HS_license.txt” in the /.hs/sys directory. For example, if you named your subscription file, “MyCompany_HS_license_3-10-26.txt”, you would copy it using the following command:

```bash
# sudo cp MyCompany_HS_license_3-10-26.txt /.hs/sys/HS_license.txt
```

After you copy the subscription, you must activate the subscription by using the hs-activate-subscription program. The command line arguments needed are the IP address of the HeartSuite Activation Server and the port number, which is 6121. At the time of this writing, the IP of the HeartSuite Activation Server is 172.232.3.4. Please check our website to learn whether the IP and/or port number has changed. Using this data, you would run the activation program as follows:

```bash
# sudo /.hs/sys/hs-activate-subscription 172.232.3.4 6121
```

If activation is successful, the program will create an activation key that is used by another HeartSuite tool and display an appropriate message.

If an error occurs, the activation program will display an error message. You need to activate your server only once.