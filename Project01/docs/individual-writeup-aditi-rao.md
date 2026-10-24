# Individual Write-Up — Aditi Rao (Lead / Payments & Bridge)

**Student:** Aditi Rao  
**Role:** Lead / Payments & Bridge  
**Project:** Kalpa Health — Brief C (Money), Group 4  
**Requirement:** 600–900 words across 10 structured questions

> **Draft status:** Questions 1–3 below preserve the supplied exemplar. Questions 4–10 require student verification or completion. Figures, code ownership, and performance claims should be checked against the actual project artifacts before submission.

### 1. In your own words, what was Dr. Menon asking for, and what did she actually need?

Dr. Menon asked why billing reported one number and the payment feed reported another, fearing revenue leakage. What she actually needed was risk categorization. If Finance treats the entire Rs 1.11 Crore unpaid balance as lost revenue, they deploy external recovery agencies, destroying patient trust and wasting operational capital. What she needed was a segmented control mechanism separating working capital float (Rs 62.67 Lakh) from actionable leakage (Rs 48.41 Lakh) and unlinked gateway cash (Rs 72.69 Lakh).

### 2. Which part of the work was yours, and what did you produce that the group depends on?

I owned the classification logic of the Revenue Bridge in `notebooks/05_methods.ipynb` and the assertion suite in `kalpa/checks.py`. I designed the vectorised classification rules that grouped 79,246 invoices into four mutually exclusive buckets and proved that `Invoiced - Unpaid - Timing + Diffs == Collected` with zero rupee variance. The team’s slide 3 and 4 claims directly depend on this code.

### 3. Which approaches did you consider for your part, which did you choose, and why not the others?

I considered calculating the bridge row-by-row via an iterative loop, using raw SQL CTEs, or building a vectorised pandas array. I chose vectorised pandas for exploratory reconciliation and replicated it in SQL CTEs for the final audit. I rejected row-by-row iteration because it took over 4 minutes to process 80,000 rows, whereas boolean masking executed in 45 milliseconds.

### 4. Which number do you trust most, what is its denominator, and what would make you stop trusting it?

I trust the Q2 collected figure of Rs 119,286,373.00 most. Its denominator is the 70,902 invoices dated between 2026-04-01 and 2026-06-30 that have at least one captured payment on or before 2026-06-30 23:59:59 IST. I would stop trusting it if an audit showed that the payment gateway recorded timestamps in clinic-local daylight savings or if bank chargebacks (refunds) were retroactively deducted without appearing in the export feed.

### 5. [Insert the exact fifth question from the assignment]

*Student response to be completed.*

### 6. [Insert the exact sixth question from the assignment]

*Student response to be completed.*

### 7. [Insert the exact seventh question from the assignment]

*Student response to be completed.*

### 8. [Insert the exact eighth question from the assignment]

*Student response to be completed.*

### 9. [Insert the exact ninth question from the assignment]

*Student response to be completed.*

### 10. [Insert the exact tenth question from the assignment]

*Student response to be completed.*

---

## Pre-submission checklist

- [ ] Replace question placeholders with the exact questions from the assignment.
- [ ] Write first-person answers based on Aditi's actual work.
- [ ] Verify all numbers, timings, code paths, and claims against notebooks and logs.
- [ ] Check the financial bridge with unrounded values and correct payment cutoffs.
- [ ] Confirm the complete write-up is between 600 and 900 words.
