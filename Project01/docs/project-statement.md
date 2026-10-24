**Purpose:** Translates Dr. Menon's business concern into exact analytical specifications.

```markdown
# Project Statement — Brief C (Money)

## 1. Dr. Menon's Words
> *"Billing says we invoiced one figure for the second quarter. The payment feed says we collected another. My finance team needs to know which invoices were never paid, which payments match no invoice, and how much of the gap is only timing."*

## 2. In Our Words
The Finance Controller cannot close Q2 2026 books without an asterisk because billing and cash collections show an apparent Rs 1.36 Crore variance. The decision hanging on our analysis is whether to deploy aggressive debt collection agencies (expensive, harms customer NPS), adjust billing system integrations (IT fix), or simply acknowledge standard bank settlement float (working capital timing).

## 3. Translation of Requirements
| Requirement | Translation & Technical Delivery | Acceptance Check |
|---|---|---|
| **F1: Invoiced vs Collected** | Calculate total billing vs gateway captured collections for Q2 2026 | Notebook 05 prints both values with period explicitly bound to Q2. |
| **F2: Balanced Bridge** | Decompose the gap into: Unpaid, Timing, and Amount differences | `checks.bridge_balances()` evaluates to True with variance $\le 0.50$ INR. |
| **F3: Three Action Lists** | Generate actionable CSVs: (1) True leak, (2) Orphan cash, (3) Double charges | 3 files written to `data/clean/` with SQL queries matching row counts. |
| **N1: Execution Speed** | Complete run under 5 minutes on standard laptop | Cold run timed via `time python notebooks/06_answer_cold_run.py`. |
| **N2: Row-Level Traceability**| Every rupee traces to discrete `invoice_id` and `payment_id` | Join keys audited with zero duplicate fan-outs. |
