#!/usr/bin/env bash
# Dual: public Lockdown-patch docs keep the KVM-proven claims.
# Reads shipped markdown only (no re-implemented copy of the procedures).
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
need() {
  local file="$1" needle="$2"
  if ! grep -Fq "$needle" "$file"; then
    echo "MISSING in $file:"
    echo "  $needle"
    fail=1
  fi
}

need content/en/docs/maintenance/_index.md \
  "they take different paths out of Lockdown."
need content/en/docs/maintenance/_index.md \
  "Reprovision from an updated image rather than opening a console on every node"
need content/en/docs/maintenance/_index.md \
  "it cannot lift the seal."

need content/en/docs/maintenance/protecting-during-maintenance/_index.md \
  "Once you are in Setup Mode, SSH and Ansible can install packages and edit files on that host."
need content/en/docs/maintenance/protecting-during-maintenance/_index.md \
  "Ansible cannot lift the seal."
need content/en/docs/maintenance/protecting-during-maintenance/_index.md \
  "leaves mode unchanged when \`hs_state\` is unset or \`setup\`."
need content/en/docs/maintenance/protecting-during-maintenance/_index.md \
  "hypervisor access, not a supported patch procedure."

need content/en/docs/maintenance/updating-heartsuite/_index.md \
  "The installer cannot set the next boot while \`/boot\` is sealed."
need content/en/docs/maintenance/updating-heartsuite/_index.md \
  "The in-place bundle is per host."
need content/en/docs/maintenance/updating-heartsuite/_index.md \
  "\`/boot\` is sealed."

need content/en/docs/alerts/central-policy-management.md \
  "It does not lift Lockdown."
need content/en/docs/alerts/central-policy-management.md \
  "the official role does not unseal."

need content/en/docs/kernel-hardening/enterprise-adoption-guide.md \
  "Ansible does not unseal."
need content/en/docs/kernel-hardening/enterprise-adoption-guide.md \
  "bake the patched OS and the current Root Lock bundle into a new image and reprovision the instances."

need content/en/docs/lockdown/index.md \
  "The Debian package manager \`dpkg\` creates temporary directories during installation."
need content/en/docs/lockdown/index.md \
  "In Lockdown, that write fails and the installation halts."

if [[ "$fail" -ne 0 ]]; then
  echo "check-lockdown-patch-claims: FAIL"
  exit 1
fi
echo "check-lockdown-patch-claims: OK"
exit 0
