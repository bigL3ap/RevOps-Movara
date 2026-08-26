# Movara — RevOps HubSpot Audit

Standing instructions for every Claude Code session in this repo:

- A HubSpot Service Key is saved locally in .env as HUBSPOT_TOKEN. Load it as an environment variable at the start of the session and confirm the connection with a simple test call.
- Never print, log, or include the token value itself in your responses or in anything you write to a file.
- Keep a running, prioritized list of blockers — data or access still needed, why it matters, and who has to provide it — in audits/blockers.md. Update it as things come up and get resolved so nothing gets lost between sessions.
- Save every meaningful finding to audits/ as you go. Commits and pushes happen automatically via the plugin's PostToolUse hook — don't add manual save, commit, or push steps to your own output. If the plugin isn't active (for example in a claude.ai session), commit and push by hand instead.
- Git workflow: commit directly to main. No feature branches, no pull requests, no autonomous scheduled follow-ups (PR watchers, check-in triggers, send-later jobs) unless explicitly requested for a specific task.
- At the start of every session, before doing anything else: run `git pull` to make sure you're working from the latest version of this repo. If it reports a conflict or says the branch has diverged, stop and flag it rather than forcing anything.
