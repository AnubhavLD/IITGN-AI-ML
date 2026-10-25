# Approach log · Brief C · Group 4

One row per part of the work. At least two approaches in every row. Written when the choice is made, not afterwards; the commit timestamp is the proof. An approach you tried for twenty minutes and abandoned is the best kind of row. Keep the dead notebook cell and link to it.

The panel reads this file before it reads your notebooks. A panellist will cover the "chosen" column and ask you to choose again, aloud.

| # | Part of the work | Approaches considered (two at least) | Chosen | Why this, and not the others | What would have changed the choice | What happened when we tried it | Owner | Date |
|---|---|---|---|---|---|---|---|---|
| 1 | Money-type parsing | (a) Float rupees with a rounding tolerance; (b) Decimal parse to integer paise | (b) Decimal → integer paise | A one-paise error must fail, not round away | A finance-agreed sub-rupee tolerance | Expected exact zero; aggregate and all 79,246 row residuals equal zero | — | — |
| 2 | Reference matching | (a) Use the supplied reference remap; (b) Strict formatting as primary, remap only as a sensitivity check | (b) Strict formatting primary | A matching amount cannot establish transaction identity | A shared transaction key present in both feeds | Possible orphans preserved: 4,588 captured orphans out of 455,469 full-feed captures | — | — |
| 3 | Rebuild vs rerun the cleaner | (a) Re-run the supplied cleaner; (b) Inspect it only and rebuild from clean source rows | (b) Inspect only | Original combined inputs are absent; the script contains semantic repairs we cannot reproduce | The raw combined workbooks being available | Fingerprinted seven inputs and rebuilt from clean source rows | — | — |
| 4 | Loader performance | (a) Full XLSX via openpyxl for repeated loads; (b) Calamine readers in three processes | (b) Calamine, 3 processes | Faster on independent workbooks; process workers are ordinary data loaders, not AI agents | Single-file input, or an I/O-bound bottleneck | Per-file timings recorded in `loader_timings.json` | — | — |
| 5 | Validation scope | (a) Validate a sample; (b) Batched Pydantic validation of every invoice and payment | (b) Validate all, in chunks | Bound memory while still checking every row | A dataset too large to validate in full | 470,776 invoice rows and 473,507 attempt rows validated | — | — |
| 6 | Invoice ↔ payment join | (a) Direct invoice-to-attempt join; (b) Aggregate captures (CTE/groupby) first | (b) Pre-aggregate | Retry fan-out would inflate invoice totals | A guaranteed one-capture-per-invoice feed | Exactly 79,246 rows after both joins | — | — |
| 7 | Q2 capture timing | (a) Count all captures on first-paid-in-Q2 invoices; (b) Time-filter capture amounts inside the aggregation | (b) Time-filter | Mixed June/July captures exist on the same invoices | No post-cutoff captures on in-quarter invoices | Seven July captures excluded, ₹20,696.00 | — | — |
| 8 | Tie-out method | (a) Single total tie-out; (b) Invoice-level residual + sign splits + SQL parity + cold run | (b) Invoice-level | Totals can conceal offsetting errors and consistent-population mistakes | A trusted, pre-reconciled source of truth | SQL compares eight fields across all 79,246 invoices | — | — |
| 9 | Settlement vs capture | (a) Label captured money as banked; (b) A separate batch settlement bridge | (b) Separate bridge | Gateway capture and net settlement have different dates and cohorts | A bank statement tying settlements to the account | 562 batches balance internally; independent bank statement absent | — | — |
| 10 | Causal conclusion | (a) Hard-code a "NO, billing did not cause it"; (b) A bounded accounting conclusion with explicit identification limits | (b) Bounded | No route-capacity or acquisition-plan data exist to establish a cause | Operational exposure and plan data being supplied | Nova coverage break measured; indirect effects remain unidentified | — | — |
| 11 | Deliverable format | (a) A native slide deck; (b) Six-slide HTML plus a full speaker script | (b) HTML + script | The brief requests a script; HTML is directly viewable and printable | A hard requirement for an editable native deck | `outputs/presentation.html` and `docs/presentation-script.md` produced | — | — |

## Parts we never had to choose about

- **The quarter boundary.** The half-open interval on 2026-06-30 equals the brief's inclusive 23:59:59 IST cutoff at second resolution, so there was only one correct boundary to apply.
- **Failed attempts as money.** A `failed` attempt is never cash; there was no second approach to weigh — it is excluded from captured totals and kept on disk for audit.
