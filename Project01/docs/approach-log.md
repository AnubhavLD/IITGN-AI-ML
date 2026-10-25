# Approach log

| Considered | Chosen | Why | Expected | Actual evidence |
|---|---|---|---|---|
| Float rupees with rounding tolerance | Decimal parse then integer paise | A one-paise error must fail | Exact zero | Aggregate and 79,246 row residuals equal zero |
| Supplied reference remap | Strict formatting primary, remap sensitivity | A matching amount cannot establish transaction identity | Preserve possible orphans | 4,588 captured orphans out of 455,469 full-feed captures |
| Re-run supplied cleaner | Inspect only | Original combined inputs absent; script contains semantic repairs | Preserve provenance | Fingerprinted seven inputs and rebuilt from clean source rows |
| Full XLSX through openpyxl for repeated loads | Calamine readers in three processes | Faster independent workbooks; process workers are ordinary data loaders, not AI agents | Parallel loading | Per-file timings recorded in loader_timings.json |
| Validate a sample | Batched Pydantic validation of every invoice and payment | Bound memory while checking all rows | Reject malformed schema | 470,776 invoice rows and 473,507 attempt rows validated |
| Direct invoice-to-attempt join | Capture CTE/groupby first | Retry fan-out would inflate invoice totals | One joined row per invoice | Exactly 79,246 rows after both joins |
| All captures on first-paid-in-Q2 invoices | Time-filtered capture amount inside aggregation | Mixed June/July captures exist | No Q3 cash in Q2 | Seven excluded July captures, ₹20,696.00 |
| Single total tie-out | Invoice-level residual, sign splits, SQL parity and cold run | Totals can conceal offsetting errors and consistent population mistakes | Independent agreement | SQL compares eight fields across 79,246 invoices |
| Label captured money banked | Separate batch bridge | Gateway capture and net settlement have different dates and cohorts | Clear cash stages | 562 batches balance; bank statement absent |
| Hard-code a NO causal conclusion | Bounded accounting conclusion and explicit identification limits | No route or acquisition plan data exist | Avoid invented causes | Nova coverage break measured; indirect effects remain unidentified |
| Native deck | Six-slide HTML and full speaker script | The brief requests a script; HTML is directly viewable and printable | Accessible local handoff | outputs/presentation.html and docs/presentation-script.md |
