# Decisions Log — Cleaning & Reconciliation

**Purpose:** Maintain a mathematical audit trail of data cleaning and reconciliation, checking that **Input = Kept + Rejected** at each row-filtering transformation.

## Master Reconciliation Table

| Step | Dataset / Table | Rows In | Rows Kept | Rows Rejected | Input = Kept + Rejected? | Running Total / Headline | Decision Rule & Impact |
|---|---|---:|---:|---:|---|---|---|
| **0** | Raw Invoices (`invoices_*.csv.gz`) | 470,776 | 470,776 | 0 | PASS (470,776 = 470,776 + 0) | ₹747,019,969.00 | Ingest all 7 quarterly files without row loss. |
| **1** | Raw Payments (`gateway_*.csv.gz`) | 473,507 | 473,507 | 0 | PASS (473,507 = 473,507 + 0) | 473,507 attempts | Ingest all 20 monthly payment files. |
| **2** | Payment Status Filter | 473,507 | 455,469 | 18,038 | PASS (473,507 = 455,469 + 18,038) | ₹721,803,124.00 captured | Keep `captured` payments; exclude `failed` attempts from captured-payment totals while retaining them in the raw audit data. |
| **3** | Q2 2026 Invoice Filter | 470,776 | 79,246 | 391,530 | PASS (470,776 = 79,246 + 391,530) | ₹132,847,274.00 | Filter `invoice_date` from `2026-04-01` through `2026-06-30`, inclusive. |
| **4** | Left Join Q2 Invoices to Payments | 79,246 | 79,246 | 0 | PASS (left-side row count preserved) | 79,246 rows | Pre-aggregate captured payments by normalized invoice reference to prevent join fan-out. |
| **5** | Bridge Reconciliation | 79,246 | 79,246 | 0 | PASS (row count preserved) | ₹119,286,373.00 collected | Reported bridge: billed ₹132.85M − unpaid ₹11.11M − timing ₹2.98M + differences ₹0.53M ≈ collected ₹119.29M. Figures are rounded in this description. |

## Validation Notes

- **Source status:** Counts and monetary values above are transcribed from the supplied draft; they have not been independently verified against source files.
- **Row conservation is not monetary reconciliation:** Passing `Rows In = Rows Kept + Rows Rejected` does not by itself prove that monetary totals reconcile or that joins are correct.
- **Step 5 bridge needs exact component values:** The rounded components shown do not establish a sub-₹0.50 reconciliation tolerance. Validate the bridge using unrounded figures and document its exact residual.
- **Timing classification:** Confirm that the timing component reflects observed post-quarter receipts or an explicitly defined, evidence-backed timing rule, rather than assuming recent invoices have been paid.
- **Payment exclusions:** Preserve rejected payment attempts for traceability; assess other statuses (such as refunds) separately if present.
