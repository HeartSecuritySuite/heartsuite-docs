---
title: "Configuring Script Launchers"
weight: 2
description: "How to activate per-script allowlisting for Python, Perl, and PHP interpreters."
categories: ["Guides"]
tags: ["heartsuite", "linux", "scripts", "python", "perl", "security", "interpreters"]
type: docs
toc: true
---

**Overview**: An interpreter like Python, Perl, or PHP executes many different scripts — without additional control, a single allowlist entry for the interpreter applies to all of them equally. Secure Script Launchers identify the specific script being executed and apply a separate allowlist entry for it, giving each script its own file and network permissions. The Launchers screen (`[l]`) shows detected interpreters and activates launchers in one step.

## Activating Launchers

From the Dashboard, select the Launchers screen (`[l]`). The screen shows two sections:

- **Script Launcher Status** — how many interpreters were detected and how many launchers are pending activation
- **Detected Interpreters** — the list of interpreter paths found in the activity log, with their current launcher status

When launchers are pending, the screen shows:

```text
2 interpreter(s) found across 47 log event(s).
2 launcher(s) available but not yet activated.

[a] Activate   [s] Skip
```

> [!SCREENSHOT]
> **Screenshot needed**: Launchers screen (`[l]`) — show the screen with 1–2 pending interpreters listed in the Detected Interpreters section, the status count ("2 interpreter(s) found across 47 log event(s). 2 launcher(s) available but not yet activated."), and `[a]` Activate / `[s]` Skip visible.

Press `[a]` to activate all pending launchers at once. HeartSuite Core Secure registers each interpreter with its Secure Script Launcher — from this point forward, every call to that interpreter automatically routes through the launcher, applying per-script permissions.

After activation, the screen confirms which launchers were activated:

```text
Activated 2 Secure Script Launcher(s): python3, perl.
Each interpreter now routes through its launcher. Scripts using
these interpreters will be reviewed on their own permission terms.
```

Press `[q]` to return to the Dashboard. Phase 3 is marked complete automatically.

## If No Script Interpreters Are Detected

If none of the known interpreters have appeared in the activity log yet, the screen shows:

```text
No script interpreter log events detected.
You may proceed to the next phase without activating any launchers.
```

Phase 3 is not required if your system does not use script interpreters. The Dashboard updates the Suggested Next Step to proceed to Phase 4.

## Skipping Launcher Setup

Press `[s]` to skip without activating. HeartSuite Core Secure notifies you:

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
