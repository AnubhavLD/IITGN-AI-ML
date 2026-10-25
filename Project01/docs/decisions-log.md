# Decisions log · cleaning and reconciliation · Brief C · Group 4

Every act of cleaning is a decision with a reason and an effect. Input equals clean plus rejected, every time. The headline number is recomputed after every decision so the bridge from raw to final is visible.

All figures were independently recomputed from the cleaned files (`data/clean/*`) on 2026-10-25; money is computed in whole paise with zero tolerance.

## Reconciliation

| Step | Table | Rows in | Rows kept | Rows rejected | In = kept + rejected? | Headline number after this step | Owner | Date |
|---|---|---:|---:|---:|---|---:|---|---|
| 0 | Raw invoices (`invoices_*.csv.gz`) | 470,776 | 470,776 | 0 | PASS | ₹737,020,069.00 billed (all history) | — | Day 1 |
| 1 | Raw gateway payments (`gateway_export_*.csv.gz`) | 473,507 | 473,507 | 0 | PASS | 473,507 attempts (20 files) | — | Day 1 |
| 2 | Payment status filter | 473,507 | 455,469 | 18,038 | PASS | ₹712,489,133.00 captured (all history) | — | Day 1 |
| 3 | Q2 2026 invoice filter | 470,776 | 79,246 | 391,530 | PASS | ₹132,847,274.00 Q2 billed | — | Day 2 |
| 4 | Join Q2 invoices → captured payments | 79,246 | 79,246 | 0 | PASS (left count preserved) | 79,246 reconciliation rows | — | Day 2 |
| 5 | Bridge reconciliation | 79,246 | 79,246 | 0 | PASS | ₹119,265,677.00 captured in-quarter · residual ₹0.00 | — | Day 2 |

### The bridge, exact and unrounded

| Component | Amount (₹) | Invoices |
|---|---:|---:|
| Starting invoiced | 132,847,274.00 | 79,246 |
| − Never paid (no captured payment) | −11,107,904.00 | 6,581 |
| − Paid after close (first capture > 2026-06-30 23:59:59 IST) | −2,982,123.00 | 1,763 |
| + Amount differences (over/under paid) | +508,430.00 | 70,902 (70,572 exact, 330 differ) |
| = Captured in-quarter | 119,265,677.00 | — |

`132,847,274 − 11,107,904 − 2,982,123 + 508,430 = 119,265,677`. Residual **₹0.00 (0 paise)**; SQL agrees independently.

## Decisions

| # | Table | What we found | Decision (drop / default / keep and flag / map / split) | Reason | Rows affected | Effect on the headline | Reversible? | Owner |
|---|---|---|---|---|---|---|---|---|
| 1 | Gateway payments | Amounts stored as integer **paise** | map (÷100 → `amount_rs`) | Paise are authoritative; a raw read overstates money 100× | 473,507 | sets the money scale | yes | — |
| 2 | Gateway payments | `failed` attempts mixed with `captured` | split (keep captured, isolate failed) | A failed attempt is not money | 18,038 isolated | captured total = ₹712,489,133 | yes (kept on disk) | — |
| 3 | Invoices | `amount` is a comma-formatted rupee string (`"1,070.00"`), already rupees | map (Decimal → whole paise) | Exact money, no float; do **not** divide by 100 | 470,776 | billing base = ₹737,020,069 | yes | — |
| 4 | Invoices | Cohort spans Dec 2024–Jun 2026 | filter (`invoice_date` 2026-04-01…06-30) | Scope the claim to Q2 | 391,530 excluded | Q2 billed = ₹132,847,274 | yes | — |
| 5 | Captures on Q2 invoices | 7 July retry-captures on in-quarter invoices | split (exclude post-cutoff from in-quarter cash) | July cash is not Q2 cash | 7 captures, ₹20,696 | difference bar +₹529,126 → **+₹508,430**; captured → **₹119,265,677** | yes | — |
| 6 | Gateway references | `notes_invoice_ref` casing/hyphen/space inconsistent | map (normalize → `INV-YYYY-NNNNNN`) | Match to `invoice_id` without inventing identity | 473,507 | 468,742 refs match an invoice | yes | — |

## Joins

| # | Left table (rows) | Right table (rows) | Key | Type | Rows after | Keys matched more than once | Explanation of the change in count | Owner |
|---|---|---|---|---|---|---|---|---|
| 1 | Q2 invoices (79,246) | captured payments, pre-aggregated by reference | `invoice_ref_clean` = `invoice_id` | 1:1 (after pre-aggregation) | 79,246 | 317 invoices had >1 capture (collapsed in the pre-aggregation) | Aggregating captures *before* the join prevents retry/duplicate fan-out; a direct join inflated 79,246 → 82,110 | — |

## Cold runs

| Date | Who ran it | Fresh Codespace? | Runtime | Headline number | Same as last run? | If not, why |
|---|---|---|---|---|---|---|
| 2026-10-25 | — | DuckDB/SQL parity run | — | ₹119,265,677.00 captured in-quarter | Yes | SQL independently compares eight fields across all 79,246 invoices; residual ₹0.00 |

## Corrections vs the earlier draft

| Step | Earlier draft | Corrected | Delta |
|---|---:|---:|---:|
| 0 — total billed | ₹747,019,969.00 | ₹737,020,069.00 | −9,999,900.00 |
| 2 — total captured | ₹721,803,124.00 | ₹712,489,133.00 | −9,313,991.00 |
| 5 — captured in-quarter | ₹119,286,373.00 | ₹119,265,677.00 | −20,696.00 |
| 5 — amount differences | ₹529,126.00 | ₹508,430.00 | −20,696.00 |
