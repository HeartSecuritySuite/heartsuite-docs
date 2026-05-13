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

exit $found
