---
title: "Configuring Script Launchers"
weight: 2
description: "Setting up HeartSuite script launchers for secure script execution."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "security", "interpreters"]
type: docs
toc: true
---

**Overview**: When the Dashboard detects script interpreters (Python, Perl, PHP) in use without launcher configuration, it presents Phase 3 as the Suggested Next Step. The Launchers screen (`[l]`) shows detected interpreters and activates launchers in one step.

## Dashboard-Guided Setup

From the Dashboard, select the Launchers screen (`[l]`). The screen shows two panels:

- **Script Launcher Status** — how many interpreters were detected and how many launchers are pending activation
- **Detected Interpreters** — the list of interpreter paths found in the activity log, with their current launcher status

When launchers are pending, the status panel shows:

```text
2 interpreter(s) found across 47 log event(s).
2 launcher(s) available but not yet activated.

[a] Activate   [s] Skip
```

Press `[a]` to activate all pending launchers at once. HeartSuite registers each interpreter with its Secure Script Launcher — from this point forward, every call to that interpreter automatically routes through the launcher, applying per-script permissions.

After activation, the result panel confirms which launchers were activated:

```text
Activated 2 Secure Script Launcher(s): python3, perl.
Each interpreter now routes through its launcher. Scripts using
these interpreters will be reviewed on their own permission terms.
```

Press `[q]` to return to the Dashboard. Phase 3 is marked complete automatically.

## If No Script Events Are Detected

If none of the known interpreters have appeared in the activity log yet, the screen shows:

```text
No script interpreter log events detected.
You may proceed to the next phase without activating any launchers.
```

Phase 3 is not required if your system does not use script interpreters. The Dashboard updates the Suggested Next Step to proceed to Phase 4.

## Skipping Launcher Setup

Press `[s]` to skip without activating. HeartSuite notifies you:

```text
Script launcher activation skipped.
Interpreters will remain blocked in Secure Mode until approved.
```

You can return to the Launchers screen (`[l]`) at any time to activate launchers before switching to Secure Mode.

## Advanced: Testing a Launcher Directly

Before or after Dashboard activation, you can run a script through a specific launcher directly to verify it works under its own permissions:

```bash
# hs-python-launcher /path/to/your-script.py
```

This applies the script's allowlist entry rather than the interpreter's. Running the same script with `python3` directly uses the interpreter's broader permissions. This is useful for verifying per-script permissions in isolation before relying on them in Secure Mode.
