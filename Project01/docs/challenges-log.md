# Challenges Log — Brief C — Group 4

**Purpose:** Blameless postmortem log of real debugging obstacles.

| # | Phase | What Broke or Surprised Us | What We Tried First | What We Changed & Why | What We Would Do Differently Next Time | Author | Date |
|---|---|---|---|---|---|---|---|
| 1 | Ingestion | Payment amounts were 100× expected clinical test prices (e.g., Rs 122,000 for a lipid panel). | Suspected data corruption or currency conversion bug. | Discovered gateway amounts are exported in integer paise. Divided by `100.0` in loader. | Check schema documentation and unit tests before inspecting row values. | Karan | Day 1 |
| 2 | Join | Merging invoices and payments caused rows to jump from 79,246 to 82,110. | Looked for duplicate invoice IDs in billing table. | Found invoice IDs were unique, but payments contained failed retries and double charges. Added `pay[pay['status'] == 'captured'].groupby('invoice_id')`. | Always inspect relationship cardinality (`validate='1:m'`) before joining across systems. | Aditi | Day 1 |
| 3 | Timing | Several early-morning July 1 payments were categorised as June 30 timing. | Checked string slice on timestamp string. | Discovered `created_at_epoch` was raw UTC. Converted with `+ pd.Timedelta(hours=5, minutes=30)` to enforce IST. | Explicitly define timezone offsets in the foundational ingestion layer. | Neha | Day 2 |
| 4 | Reconciliation | Initial bridge was off by Rs 529,126.00. | Looked for missing invoices or lost payment rows. | Discovered 317 invoices had multiple captured payments (double charges). Net overpayment was positive. Explicitly added amount difference bar. | Never assume payment amount equals invoice amount; always model delta explicitly. | Varun | Day 2 |

## Validation note

This log preserves the team's supplied account. Before final submission, verify the reported counts, amounts, causes, and fixes against notebook outputs and commit history. In particular, confirm the timezone conversion is applied exactly once and that the grouped payment amounts are summed before the invoice-level join.
