# Challenges log · Brief C · Group 4

What broke or surprised us, what we tried, what we changed and why. Entries are dated and written as they happen. A log written on the last evening answers no interview question, and the commit history shows which kind this is.

| # | Phase | What broke or surprised us | What we tried first | What we changed, and why | What we would do differently next time | Who | Date |
|---|---|---|---|---|---|---|---|
| 1 | Ingestion | Payment amounts were 100× the expected clinical test prices (e.g. ₹122,000 for a lipid panel). | Suspected data corruption or a currency-conversion bug. | Found gateway amounts are exported in integer **paise**; divided by 100.0 in the loader. | Check schema documentation and unit tests before inspecting row values. | Karan | Day 1 |
| 2 | Join | Merging invoices and payments made rows jump from 79,246 to 82,110. | Looked for duplicate invoice IDs in the billing table. | Invoice IDs were unique; payments held failed retries and double charges. Added `pay[pay['status']=='captured'].groupby('invoice_id')`. | Always inspect cardinality (`validate='1:m'`) before joining across systems. | Aditi | Day 1 |
| 3 | Timing | Several early-morning July 1 payments were classed as June 30 timing. | Checked the string slice on the timestamp. | `created_at_epoch` was raw UTC; converted with `+ pd.Timedelta(hours=5, minutes=30)` to enforce IST. | Define timezone offsets in the ingestion layer from the start. | Neha | Day 2 |
| 4 | Reconciliation | The initial bridge was off by ₹529,126.00. | Looked for missing invoices or lost payment rows. | Found 317 invoices with multiple captured payments (double charges); net overpayment was positive. Added an explicit amount-difference bar. | Never assume payment amount equals invoice amount; model the delta explicitly. | Varun | Day 2 |

## The entry we are proudest of

Entry 4. The bridge was off by ₹529,126 and the instinct was to hunt for a lost row. Instead we tested the assumption that one invoice equals one payment — and found 317 invoices captured more than once, a net over-collection. Modelling the amount-difference bar explicitly turned a "missing money" mystery into a refund-audit finding, and it is the discipline behind the exact ₹0.00 residual. A later refinement also excluded ₹20,696 of July captures on seven Q2 invoices, moving the difference bar to +₹508,430 and captured-in-quarter to ₹119,265,677.

## Validation note

This log preserves the team's account as written. Before final submission, verify the reported counts, amounts, causes and fixes against notebook outputs and commit history — in particular, confirm the timezone conversion is applied exactly once and that grouped payment amounts are summed before the invoice-level join.
