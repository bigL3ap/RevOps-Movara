#!/bin/bash
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

claude plugin marketplace add bigL3ap/claude-plugins > /tmp/hubspot-audit-install.log 2>&1
claude plugin install hubspot-audit@bigleap >> /tmp/hubspot-audit-install.log 2>&1

if grep -q "hubspot-audit@bigleap" ~/.claude/plugins/installed_plugins.json 2>/dev/null; then
  exit 0
fi

echo "=================================================================="
echo "hubspot-audit plugin is NOT active in this session."
echo "The automatic install needs bigL3ap/claude-plugins attached to"
echo "this session before it can authenticate. To fix it:"
echo "  1. Click the + next to the repo pills above the message box"
echo "  2. Attach bigL3ap/claude-plugins as a second repo"
echo "  3. Run: claude plugin marketplace add bigL3ap/claude-plugins"
echo "          claude plugin install hubspot-audit@bigleap"
echo "  4. Start a NEW session -- plugins only load at session start"
echo "=================================================================="
exit 0
