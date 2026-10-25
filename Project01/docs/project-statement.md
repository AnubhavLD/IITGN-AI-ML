# Project statement · Brief C · Group 4

Written in Scope, before the data is opened. Updated when the data proves a line wrong, with the old line struck through rather than deleted, so the panel can see what you learned.

## 1. Dr Menon's words

> Brief C · Money — "Why do my invoices and my collections disagree?" Billing and collections have drifted apart, and have for a while.

## 2. The question in our words

The question has two independent estimands. The **accounting estimand** is Q2 gateway cash for the Q2 invoice cohort: of what was billed in April–June 2026, how much was actually captured inside the quarter, and where does every remaining rupee sit? The **causal estimand** is the effect of billing failures on H1 resulted-test volume relative to the approved plan. Only the first is fully observable in the supplied files. The answer drives a concrete decision — which unpaid invoices Finance should chase versus which to leave as settlement float — and it keeps the cash question separate from the growth question.

## 3. The question she did not ask

Whether the "collection gap" is a **timing lag or a genuine loss**. The two lead to opposite actions (wait vs chase), and treating recent working float as leakage would trigger brand-damaging collection calls on patients who have simply not yet settled. It matters because the headline "collections below billing" is mostly timing, not loss.

## 4. Translation into the method

| Her words | The Week 1 or 2 method it maps to | Where the vocabulary changes |
|---|---|---|
| "Invoices and collections disagree" | the bridge (invoiced → captured, balanced to the rupee) | "collection" = captured gateway payment (gross), not the net bank settlement |
| "By how much, and why" | the bridge's four mutually-exclusive bars (never paid, timing, amount differences, captured) | "amount difference" includes double-charge over-captures, not only underpayment |
| "What do I do about it" | the fair-comparison split: chase vs wait vs fix | "float" = recent unpaid that is not yet contractually due |

## 5. What does not transfer from Retail

| In Retail | In a diagnostics business | What changes for our analysis |
|---|---|---|
| A missed sale costs one order. | An unpaid invoice happens *after* the test is run and counted. | It is a revenue-realization leak, not a lost unit of volume — cash and volume are separate populations. |
| The shopper chooses the basket. | The clinician and test panel set the tests per visit. | "Tests per visit" is a clinical mix, not a shopper decision; demand is measured in patients and visits. |
| One payment equals one sale. | One visit can generate several payment attempts — retries, failures, double charges. | Payment rows must be aggregated per invoice before any join, or totals fan out. |

## 6. Our prediction, before the data

We expected most of the billing–collection gap to be **timing and working float** rather than genuine loss, and the truly recoverable leak to be a small fraction of the headline difference. Dated at the start of Scope; compared against findings in the write-up. (It held: of the ₹1.36 Cr gap, only ~₹0.48 Cr is actionable.)

## 7. Requirements

### Functional: what the analysis must do

| # | Requirement | How we will show it is met |
|---|---|---|
| F1 | Reproduce Dr Menon's 5 percent, or explain exactly why our figure differs. | H1 test-volume growth recomputed from bookings (+5.8%), against an +18% plan; definition gap stated. |
| F2 | Answer the brief's question with a number and its denominator. | ₹119,265,677 captured of ₹132,847,274 billed across 79,246 Q2 invoices (89.8%), bridge residual ₹0.00. |
| F3 | Produce the list or split someone can act on the next morning. | Chase (2,854 invoices, ₹4,841,145), wait (3,727, ₹6,266,759), and fix (317 double-captures; 4,588 orphans) CSVs. |
| F4 | Classify every reconciliation exception into one mutually-exclusive bucket. | Four invoice buckets (6,581 / 1,763 / 330 / 70,572 = 79,246) plus orphans on the payment side. |

### Non-functional: how well it must do it

| # | Requirement | How we will show it is met |
|---|---|---|
| N1 | Re-runs from a fresh Codespace in under ten minutes with no manual edits. | A teammate's cold run, logged in the decisions log. |
| N2 | A finance analyst who never met us can audit every number back to rows. | Invoice-level residuals; SQL/DuckDB parity across eight fields for all 79,246 invoices. |
| N3 | Every cleaning decision is written with its reason before the next step runs. | The decisions log; Input = Kept + Rejected at each step. |
| N4 | No financial sum uses float. | Comma-cleaned text parsed via Decimal to whole paise; non-whole-paise amounts fail validation. |

### Constraints: what we cannot change

| # | Constraint |
|---|---|
| C1 | Free tools covered so far: notebooks in VS Code on Codespaces, SQL, Excel, GitHub. |
| C2 | No coding or chat assistants on the analysis, the notebooks or the write-ups. |
| C3 | The data as released; three to four working days; a group of three or four. |
| C4 | Original raw combined workbooks are absent; the supplied `clean_data.py` is inspected, never executed. |

## 8. Scope

| In | Out, and why |
|---|---|
| Q2 2026 invoiced-to-captured reconciliation, exact to the rupee. | A causal claim that billing caused the volume miss — the causal estimand is not observable in these files. |
| Exception action lists: chase, wait, fix. | Route-capacity and acquisition-plan analysis — no such data was supplied. |
| A separate gateway-capture vs bank-settlement bridge. | Confirming cash hit the bank — no independent bank statement was supplied. |

## 9. Done looks like

For 79,246 invoices dated 1 April to 30 June 2026, ₹132,847,274.00 invoiced reconciles to ₹119,265,677.00 of gateway captures dated inside Q2 IST, at exact zero variance; the ₹1.36 Cr gap is decomposed into never-paid, timing, and amount differences, with an actionable chase list of ₹48.41 L, and the cash shortfall is stated *not* to establish the cause of the H1 volume gap.

## 10. Who signs off

| Reader | What they will check | What would make them reject it |
|---|---|---|
| Dr Menon | One sentence she can say to the board | A number without a comparison |
| The finance controller | Every number traces to rows | A bar in the bridge nobody can trace |
| The city heads / collections lead | The chase list is real and identity-verified | Chasing patients who were simply billed recently |
