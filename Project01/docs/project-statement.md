# Project Statement — Brief C (Money)

**Purpose:** Translate Dr. Menon's business concern into precise analytical specifications and verifiable outputs.

## 1. Dr. Menon's Words

> “Billing says we invoiced one figure for the second quarter. The payment feed says we collected another. My finance team needs to know which invoices were never paid, which payments match no invoice, and how much of the gap is only timing.”

## 2. In Our Words

The Finance Controller cannot close the Q2 2026 books without a qualification because billing and cash collections show an **apparent ₹1.36 crore variance**.

The analysis must inform which response is appropriate:

- **Chase:** Deploy debt-collection efforts where invoices are genuinely unpaid, considering cost and customer NPS implications.
- **Fix:** Correct billing or payment-system integration issues where mismatches are caused by data or process errors.
- **Wait:** Recognize ordinary bank settlement float where the difference is timing-related rather than a permanent shortfall.

The ₹1.36 crore figure is a project-stated starting variance, subject to reconciliation and validation against the underlying data.

## 3. Translation of Requirements

| ID | Requirement | Translation and technical delivery | Acceptance check |
|---|---|---|---|
| F1 | **Invoiced vs Collected** | Calculate total billing versus gateway-captured collections for Q2 2026. | Notebook 05 prints both amounts with the reporting period explicitly restricted to Q2 2026. |
| F2 | **Balanced Bridge** | Decompose the apparent gap into unpaid invoices, timing differences, and amount differences. | `checks.bridge_balances()` returns `True`, with an absolute residual variance of no more than ₹0.50. |
| F3 | **Three Action Lists** | Generate actionable CSVs for (1) true leak, (2) orphan cash, and (3) double charges. | Three files are written to `data/clean/`; corresponding SQL queries reproduce their row counts. |
| N1 | **Execution Speed** | Complete the reproducible analytical run in under five minutes on a standard laptop. | Time the cold run using `time python notebooks/06_answer_cold_run.py`. |
| N2 | **Row-Level Traceability** | Trace every reconciled rupee to its underlying `invoice_id` and, where applicable, `payment_id`. | Audit join-key cardinality and demonstrate zero unintended duplicate fan-outs. |

## 4. Validation Notes

- Treat an invoice without a matching captured payment as a **reconciliation exception**, not automatically as a confirmed loss.
- Distinguish payment capture from bank settlement: settlement timing can create a temporary difference.
- Preserve unmatched records and source identifiers for auditability.
- Validate the period boundaries and transaction-date basis before reporting Q2 totals.
- The acceptance checks describe intended deliverables; they are not claims that the notebooks, functions, SQL checks, or CSVs already exist or have passed.
