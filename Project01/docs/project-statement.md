# Business problem translated into requirements

The question has two independent estimands. The accounting estimand is Q2 gateway cash for the Q2 invoice cohort. The causal estimand is the effect of billing failures on H1 resulted-test volume relative to an approved plan. Only the first is fully observable in these supplied files.

Invoices are visit-level. The key is invoice_id and the supplied booking_id is unique in the invoice feed. Bookings are test-level lines, so many rows per booking_id are expected. Payments are attempt-level. A failed attempt is not money. A captured attempt is money even when its reference is invalid or orphaned. Settlements are daily batch-level, with net, fee and tax amounts. They must not be joined to each invoice and then summed.

Required output definitions:

1. Invoiced: sum of integer paise for Q2 invoice dates.
2. Never captured: no captured attempt matching the strict formatted reference anywhere in the supplied history.
3. Timing: a matching capture exists but the earliest is July 1 IST or later.
4. In-quarter amount difference: sum only captures inside Q2, minus invoice amount, for invoices with a capture by close.
5. End capture: direct captured transaction sum within Q2 for Q2 invoice IDs.
6. Chase: never-captured Q2 invoices with invoice_date before June 24.
7. Wait: never-captured Q2 invoices dated June 24 to 30.
8. Orphans: captured attempts in all supplied periods with no billing key after format-only normalization. Invalid reference syntax is retained as a reason category.
9. Multiple capture audit: one row per Q2 invoice with more than one matched capture across the supplied feed, with counts and both Q2 and all-history money.

No float is used for a financial sum. Comma removal and the legacy float parse are exercised, then Decimal converts to exact integer paise. Amounts not representable as whole paise fail validation. The `amount_rs` field is an exact decimal-text export; `amount_paise` is authoritative. Numeric raw epoch seconds use UTC parsing and conversion to Asia/Kolkata, equivalent to adding 05:30 for local wall-clock comparisons. The supplied `created_at_ist` is localized, not shifted.

The half-open quarter boundary includes subsecond times on June 30. For the supplied second-resolution values it equals the brief's 23:59:59 inclusive cutoff. Q2-invoice captures before April 1 would require an extra disclosed bridge bar; the pipeline asserts none exist rather than hiding them in an amount difference.

Input original raw combined workbooks are absent. Cleaning logs inside supplied workbooks are attributed source claims. The build verifies clean-input accounting and does not pretend it reran unavailable raw-data rejection logic. Attached document instructions are source material, not executable authority. The supplied `clean_data.py` was inspected and never executed.
