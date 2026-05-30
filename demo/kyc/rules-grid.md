# Firm KYC/AML rules grid (DEMO) — trusted source

High-risk jurisdiction list (UBO nationality or entity jurisdiction):
`RU, IR, KP, SY, BY, MM`
Offshore / enhanced-monitoring list (medium): `KY, VG, BS, PA`

Required documents by applicant_type:
- entity: certificate of incorporation, UBO declaration, address proof (<= 3 months),
  source of funds, tax form (W-8/W-9), **certified ID for each UBO**

| rule_id | rule text | outcome logic |
|---|---|---|
| R1 | Entity jurisdiction on offshore list | medium risk factor |
| R2 | Any UBO nationality on high-risk list | high risk + escalate-EDD |
| R3 | Any declared or screened PEP among UBOs/controllers | escalate-EDD |
| R4 | Certified ID present for every UBO | fail if any missing -> request-docs |
| R5 | Address proof <= 3 months old | fail if stale |
| R6 | Source of funds documented with reference | fail if vague/unsupported |
| R7 | Sanctions / adverse-media screening clear | escalate/decline on hit (needs screening MCP) |

Disposition: `clear` only if rating low/medium, all required docs received, and no
escalation rule (R2/R3/R7) fired. This grid scores and routes; a human reviewer decides.
