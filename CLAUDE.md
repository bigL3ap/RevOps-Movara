# Movara — RevOps HighLevel Audit

Read-only audit of a single HighLevel (GoHighLevel) sub-account, run through
the LeadConnector MCP server.

## Session conventions

- At the start of every session, before doing anything else: run `git pull`
  to make sure you're working from the latest version of this repo. If it
  reports a conflict or says the branch has diverged, stop and flag it
  rather than forcing anything.
- A read-only HighLevel Private Integration Token is saved locally in `.env`
  as `GHL_PIT`. It is consumed by `.mcp.json` at connection time — you do not
  need to load or handle it yourself. Confirm the connection with
  `search_operations` before pulling any data.
- Never print, log, or include the token value itself in your responses or in
  anything you write to a file.
- Keep a running, prioritized list of blockers — data or access still needed,
  why it matters, and who has to provide it — in `audits/blockers.md`. Update
  it as things come up and get resolved so nothing gets lost between sessions.
- Save every meaningful finding to `audits/` as you go, then commit and push
  by hand. There is no plugin hook in this repo — the HubSpot audit plugin was
  removed and has no HighLevel equivalent, because LeadConnector is a hosted
  remote MCP server with nothing to install.
- Git workflow: commit directly to main. No feature branches, no pull
  requests, no autonomous scheduled follow-ups (PR watchers, check-in
  triggers, send-later jobs) unless explicitly requested for a specific task.

## Hard rules

1. **Read only.** Never call `execute_operation` for any create, update,
   delete, upsert, send, or void operation. If an operation's name or
   description implies a write, stop and ask before running it.
2. The PIT is scoped read-only, so writes should fail at the API. Do not
   treat that as the only safeguard — do not attempt them.
3. **Single sub-account.** This connection is scoped to one sub-account.
   Record its name and Location ID in `audits/context.md` and verify you are
   pointed at it before the first pull of each session. If anything returned
   looks like it belongs to a different client, stop immediately.
4. **No client PII in committed files.** `audits/` is tracked by git.
   Contact names, emails, phone numbers, and conversation content must not
   land there. Findings are aggregate or anonymized; if you need record-level
   detail to make a point, describe the pattern and give a count, not the
   records.
5. **Do not fabricate counts.** Every number in a finding must come from a
   tool result. If a query was truncated or rate-limited, say so rather than
   estimating.

## Start of every audit session

Run `search_operations` first and report what the current grant actually
exposes. This confirms the read-only scoping held before any audit logic is
built on top of it. If write operations appear in the grant, stop and flag it
— the PIT was scoped wrong and needs to be recreated.

## Scope of the audit

Full-account, read-only, one sub-account. Work the domains below in order.

### 1. Account foundation
- Business profile completeness: name, address, phone, timezone, branding
- Users: who has access, role and permission level, stale or over-permissioned accounts
- Custom fields: full inventory, populated vs. dead weight, near-duplicate names
- Custom values: set vs. empty, any still holding placeholder text
- Tag taxonomy: total count, tags on fewer than 5 contacts, near-duplicate tags

### 2. Contacts and data quality
- Total contacts; growth over the trailing 12 months
- Duplicate rate — same email, same phone, near-identical names
- Contacts missing an owner, or missing source/attribution
- Required custom fields left empty
- DND status distribution and channel-level DND conflicts
- Contacts with no activity in 180+ days, as a share of the database

### 3. Opportunities and pipelines
- Pipeline inventory; stage count and names per pipeline
- Stale opportunities: no stage change in 30/60/90 days
- Opportunities with null or $0 value, or no assigned owner
- Lost reasons: configured, and actually being used
- Stage conversion and win rate per pipeline
- Pipelines with no activity at all (abandoned but not archived)

### 4. Conversations and messaging
- Channels in use and volume by channel
- Unanswered inbound messages; oldest unanswered
- Median first-response time where derivable
- Failed or undelivered message volume

### 5. Calendars and appointments
- Calendars configured; which have availability actually set
- Booking volume per calendar; calendars with zero bookings
- No-show and cancellation rates
- Appointment outcomes recorded vs. left blank

### 6. Workflows and automation
- Active vs. draft vs. published counts
- Workflows with no trigger, or a trigger that can never fire
- Workflows with zero enrollments over the trailing 90 days
- Near-duplicate workflows (a common snapshot-import artifact)
- Any workflow in an error state

### 7. Forms, surveys, and capture
- Form and survey inventory; submission volume each
- Forms with zero submissions
- Form fields not mapped to a custom field (data captured then dropped)
- Forms with no notification or downstream automation on submit

### 8. Marketing assets
- Email templates and folders; unused or duplicated templates
- Campaign stats: delivery, open, click, bounce, unsubscribe, spam rate
- Social Planner: connected accounts, post cadence, disconnected or failing accounts
- Blogs: sites, post volume, authors, categories

### 9. Commerce
- Products and prices; products with no price set
- Invoices and estimates: outstanding, overdue, voided
- Payment integrations connected and healthy
- Subscriptions: active count, failed transaction volume

### 10. Attribution
- Contact volume by source; share with no source at all
- UTM capture on inbound contacts
- Whether form submissions carry attribution through to the contact record

## Output

- **Findings** → `audits/findings.md`. Each finding carries: what was checked,
  observed value, why it matters, recommended fix, and severity
  (Critical / Important / Housekeeping).
- **Dashboard-access gaps** → `audits/blockers.md`, using the existing blocker
  format. Anything the read-only grant cannot see becomes a blocker with a
  specific question for whoever has UI access. Expect this to include some
  settings, snapshot lineage, integration credentials, and billing. Record the
  gap; never guess at the answer.

## Execution

A whole-account audit means large enumerations, and HighLevel enforces rate
limits. Sequence it:

- **Pass 1 — inventory.** Counts and configuration only. Cheap, and it shows
  where the volume is before pulling detail.
- **Pass 2 — samples.** Bounded samples for quality checks rather than full
  exports. State the sample size in the finding.
- **Pass 3 — detail.** Only on domains Pass 1 or 2 flagged.

If a query truncates or rate-limits, record it as a coverage gap in the
findings. Never extrapolate a total from a partial result.
