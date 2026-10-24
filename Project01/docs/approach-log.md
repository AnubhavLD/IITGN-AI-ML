# Approach Log — Group 4 — Brief C

**Purpose:** Record engineering choices, alternatives considered, and the rationale and trade-offs behind each choice. The team should be prepared to defend the **Chosen** column during the panel review.

| # | Component | Approaches Considered | Chosen | Rationale & Trade-offs | What Would Change Choice |
|---|---|---|---|---|---|
| **1** | **Payment Reference Normalization** | (a) Strip all non-alphanumeric characters.<br>(b) Regex match on standard format `INV-YYYY-NNNNNN`.<br>(c) Levenshtein fuzzy string distance matching. | **(b)** | Strict regex fixes missing hyphens and case errors without risk of pairing adjacent numerical IDs. Fuzzy matching risked corrupting distinct invoices. | If gateway notes contained freeform conversational text. |
| **2** | **Join Grain & Fan-out Prevention** | (a) Direct LEFT JOIN invoices to raw payments.<br>(b) Pre-group captured payments by `invoice_id` before join.<br>(c) Filter join results in WHERE clause. | **(b)** | Invoices are visit-grain; payments are attempt-grain. Pre-grouping captures sum of amounts, min timestamp, and attempt counts while enforcing strict 1:1 join integrity. | If each payment attempt needed to appear as an individual line in financial reporting. |
| **3** | **Classifying the Unpaid Gap** | (a) Treat all 6,581 unpaid invoices as lost revenue.<br>(b) Exclude only July collections.<br>(c) Segment into timing float (last 7 days of June) vs aged leak (>7 days). | **(c)** | 56.4% of unpaid invoices were issued between June 24–30. Calling these a "leak" would lead to collections harassment of patients whose payments were currently clearing. | If Kalpa operated on a 100% upfront prepayment model before sample collection. |
| **4** | **Handling Orphan Payments** | (a) Reject at database load via FOREIGN KEY.<br>(b) Impute missing invoice IDs.<br>(c) Ingest into standalone audit table and anti-join. | **(c)** | Foreign keys would fail hard and drop Rs 72.69 lakh in real company cash. Anti-joining preserves cash auditability for accounting reconciliation. | If gateway had an enforced real-time webhook validation against the billing DB. |

> **Validation note:** The numerical claims and design decisions above are supplied project assertions. Confirm them against the final notebooks, SQL checks, and reconciliation outputs before treating them as audited findings.
