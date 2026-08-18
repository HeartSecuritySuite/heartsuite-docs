#!/usr/bin/env bash
# Fails CI if deprecated terminology appears in docs source.
BANNED=(
  # Mode names — §5.1 (DD-060)
  "Secure Mode"             # → Lockdown
  "Monitor Mode"            # → Setup Mode
  "Denial Mode"             # → Lockdown
  "Denial mode"             # → Lockdown
  "Maintenance Mode"        # → maintenance window / Non-HS kernel
  "Activate Secure Mode"    # → Lockdown

  # Renamed UI sections
  "Alert Configuration"     # → Alert Settings (renamed in 7a6d0ee)

  # In-body author attribution — R29 (fixed in 8969b1b; belongs in YAML frontmatter only)
  "**Author:"               # → move to YAML frontmatter field

  # Legacy terminology — §5.1
  "APO record"              # → allowlist entry
  "Application Permission Orders"  # → program allowlist
  "Safety Banner"           # → protection state
  "Suggested Next Action"   # → Suggested Next Step
  "shim program"            # → Secure Script Launcher

  # UX rule violations — §5.4 / §9
  "press any key"           # → name the exact key (§5.4)
  "any key to continue"     # → name the exact key (§5.4)
  "Tier 1"                  # → individual review (§9)
  "Tier 2"                  # → grouped review (§9)
  "Tier 3"                  # → queue summary review (§9)

  # "enforcement" as user-visible state description — §5.1 (fixed in 79589e3)
  "enforcement is active"       # → blocking is active
  "enforcement is not active"   # → blocking is not active
  "enforcement is inactive"     # → blocking is inactive

  # Stale version claims
  "coming in v2"            # container host support has shipped
  "Coming in v2"            # container host support has shipped

  # Product naming — §5.1 (house brand HeartSuite; product Root Lock)
  "Root Lock by HeartSuite security suite"  # stacked endorsed name + category
  "HeartSuite security suite"               # HeartSuite is the house, not a suite product
  "Core Secure"             # retired product name → Root Lock
  "non-HeartSuite kernel"   # → maintenance kernel
)
found=0
for term in "${BANNED[@]}"; do
  matches=$(grep -rn --include="*.md" "$term" content/ || true)
  if [[ -n "$matches" ]]; then
    echo "BANNED TERM: \"$term\""
    echo "$matches"
    found=1
  fi
done

# R45: headings must name what the user sees/does/gets — not "How X Works"
how_works=$(grep -rEn --include="*.md" "^##+ How .+ Works" content/ || true)
if [[ -n "$how_works" ]]; then
  echo "BANNED PATTERN: \"## How ... Works\" heading (R45 — name what the user sees, not the mechanism)"
  echo "$how_works"
  found=1
fi

# §6: sentence-case headings — function words must not be capitalised mid-heading.
# Catches the most common Title Case mistakes: conjunctions, articles, short prepositions.
# Words at the very start of a heading are always correct (first word is capitalised).
# Proper nouns (HeartSuite, Dashboard, Lockdown, CLI, …) are never in this list.
title_case=$(grep -rEn --include="*.md" \
  "^#{1,6} .+[[:space:]](And|Or|But|Nor|The|For|With|In|On|Of|To|From|At|By|An)[[:space:]]" \
  content/ || true)
if [[ -n "$title_case" ]]; then
  echo "STYLE: Title Case function word mid-heading (§6 — use sentence case; only capitalise the first word and proper nouns)"
  echo "$title_case"
  found=1
fi

# §5.1: "HeartSuite kernel" is retired, but the substring appears inside the
# allowed first-mention form "Root Lock by HeartSuite kernel".
hs_kernel=$(python3 - <<'PY'
from pathlib import Path
needle = "HeartSuite kernel"
ok_prefix = "Root Lock by "
for path in sorted(Path("content").rglob("*.md")):
    for i, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        start = 0
        while True:
            idx = line.find(needle, start)
            if idx == -1:
                break
            if not line[:idx].endswith(ok_prefix):
                print(f"{path}:{i}:{line}")
            start = idx + len(needle)
PY
)
if [[ -n "$hs_kernel" ]]; then
  echo "BANNED TERM: \"HeartSuite kernel\" (use Root Lock kernel; first-mention \"Root Lock by HeartSuite kernel\" is allowed)"
  echo "$hs_kernel"
  found=1
fi

# §5.1: at most one "Root Lock by HeartSuite" in the body (front matter and
# the site tagline are chrome / SEO and may repeat the full name).
excess=$(python3 - <<'PY'
from pathlib import Path
full = "Root Lock by HeartSuite"
tagline = "Root Lock by HeartSuite | Humans in Command"
root = Path("content")
for path in sorted(root.rglob("*.md")):
    text = path.read_text(encoding="utf-8")
    if text.startswith("---\n"):
        end = text.find("\n---\n", 4)
        if end != -1:
            text = text[end + 5:]
    body = text.replace(tagline, "")
    count = body.count(full)
    if count > 1:
        print(f"{path}: {count} full-name mentions in body")
PY
)
if [[ -n "$excess" ]]; then
  echo "STYLE: more than one \"Root Lock by HeartSuite\" in page body (§5.1 — full name once, then Root Lock)"
  echo "$excess"
  found=1
fi

exit $found
