# Blockers

| Item | Why it matters | Who provides it | Status |
|---|---|---|---|
| `GHL_PIT` is rejected by the LeadConnector API — every `execute_operation` call (tried `search-users`, `get-pipelines`) returns `401 Invalid Private Integration token` | Blocks the entire audit — no data can be pulled at all, not just the location lookup, until this is fixed | Ashley — regenerate or verify the Private Integration Token in HighLevel (Settings > Private Integrations) and update `.env` | Open |
| Location ID for the sub-account being audited | Needed in `audits/context.md` to confirm every pull is scoped to the right client before the audit starts | Ashley — HighLevel Settings > Business Profile (blocked until the PIT above is fixed, since `list_locations` also fails and `get-location` needs a locationId we can't yet confirm) | Open |
