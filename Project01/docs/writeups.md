# Individual write-ups · Brief C · Group 4

## Group summary

For 79,246 invoices dated 1 April to 30 June 2026, Kalpa billed ₹132,847,274.00 and captured ₹119,265,677.00 of it inside the quarter — 89.8 percent — with the invoiced-to-captured bridge balancing to exact zero variance. The ₹1.36 Cr gap is not a single leak: ₹1.11 Cr was never captured, ₹0.30 Cr was captured after the quarter closed (timing), and amount differences added ₹0.05 Cr net. Of the never-captured amount, 56 percent is recent working float (June 24–30); the genuinely actionable chase list is ₹48.41 L across 2,854 invoices.

The cash shortfall does not establish the cause of the reported H1 test-volume growth gap. Growth was reproduced at +5.8% against an +18% plan; the shortfall is a demand story (patients grew only +3.8%, concentrated in Jaipur and Chennai), not a billing one. Dr Menon should chase the aged 2,854 invoices (after identity checks), wait on the recent float, fix the 317 double-captures and 4,588 orphan payments, and treat growth recovery as a separate workstream needing route and acquisition data that was not supplied.

---

Four role lenses are used for this handoff because the brief supplies no student roster; no participation or authorship is attributed to a named student. Each lens answers ten questions in its own words.

## Data ingestion and validation

**1. What was your input contract?** Seven original supplied files, read-only, with SHA-256 fingerprints. The raw combined workbooks named by the old cleaner were absent.

**2. Why use process workers?** Independent Excel workbooks can be parsed concurrently. A bounded three-worker pool is implemented and timed.

**3. What did Pydantic check?** Every invoice and attempt amount, required identifier and date/timestamp field, in chunks of 25,000 records.

**4. What needs a table-wide check?** Primary-key uniqueness, unique invoice booking grain, reference coverage and joined row counts.

**5. How were money types handled?** Comma-cleaned source text was parsed through Decimal to whole paise with no tolerance.

**6. What was the paise trap here?** The supplied invoice amount (`amount_rupees` / `amount_clean`) was already in rupees. Dividing it again would understate money by 100 times. Only the gateway and settlement `*_paise` fields are divided by 100.

**7. What was the timezone trap here?** The clean timestamp was labelled IST. A second +05:30 shift would move valid records across dates.

**8. What rows were rejected in this run?** No supplied clean rows were silently rejected. Invalid primary schemas stop execution; captured orphans and failed attempts remain on disk.

**9. What source fact could not be verified?** The source claim that the original datetime was already IST cannot be independently established without raw epochs.

**10. What would you improve next?** Add source-system contracts with explicit units, timezone, immutable receipt IDs and approved identity crosswalks.

## Analytics and SQL engineering

**1. What is the invoice grain?** One row per invoice/visit. The invoice and booking keys are unique in the supplied invoice feed.

**2. What is the payment grain?** One row per attempt. Failed attempts and multiple captures may share one invoice reference.

**3. How was fan-out prevented?** Aggregate captured amounts and counts by invoice before a one-to-one invoice join.

**4. Why two capture sums?** The all-history sum and first capture determine observed payment presence/timing; the Q2-only sum determines quarter cash.

**5. What was wrong with the reference code?** It included seven July captures worth ₹20,696.00 on seven Q2 invoices after testing only `first_paid`.

**6. Where is the anti-join?** `captured_orphans` uses NOT EXISTS against invoices and preserves null/invalid canonical keys.

**7. What does the window function do?** ROW_NUMBER orders capture attempts per reference and COUNT identifies multiple captures without duplicating invoice totals.

**8. Why omit the FK?** Orphan references are evidence that must enter the source layer to be investigated.

**9. Did indexes speed it up?** No speedup is claimed. Candidate indexes and actual EXPLAIN ANALYZE evidence are recorded for review.

**10. What was independently compared?** Eight fields for all 79,246 Q2 invoices, direct transaction cash, and exact orphan/chase ID sets in DuckDB.

## Audit and finance controls

**1. What is the exact bridge?** ₹132,847,274.00 − ₹11,107,904.00 − ₹2,982,123.00 + ₹508,430.00 = ₹119,265,677.00 for 79,246 Q2 invoices and Q2 captures.

**2. How many invoice buckets exist?** Four exclusive classes: 6,581 no capture, 1,763 first after close, 330 amount differences and 70,572 exact Q2 matches, totalling 79,246.

**3. How do you rule out offsetting row errors?** Every invoice residual and their absolute sum equal zero. A deliberate opposite-sign synthetic corruption fails the row check.

**4. What are the signed differences?** 318 Q2 overpaid invoices contribute +₹523,266.00; 12 underpaid contribute −₹14,836.00, each out of 79,246 Q2 invoices.

**5. Who goes on chase review?** 2,854 unpaid invoices before June 24 worth ₹4,841,145.00, out of 79,246 Q2 invoices, subject to mapping/terms review.

**6. Who is in working-float review?** 3,727 unpaid June-24-to-30 invoices worth ₹6,266,759.00, out of 79,246 Q2 invoices. Recent age alone is not a contractual grace period.

**7. What is the orphan population?** 4,588 captured attempts worth ₹7,269,408.00 in the full supplied feed, out of 455,469 captures.

**8. Why not refund automatically?** 317 multi-capture Q2 invoice flags do not prove payer authorization, erroneous liability or absence of earlier refunds.

**9. What reconciles to the bank?** Only the supplied processed settlement feed is internally reconciled. An independent bank statement remains missing.

**10. What is the main policy risk?** The unverified 900,000 reference remap changes Q2 cash attribution and 718 invoices in the older chase set.

## Business interpretation and presentation

**1. What is the claim sentence?** For 79,246 invoices dated April 1 to June 30, 2026, ₹132,847,274.00 invoiced reconciles to ₹119,265,677.00 gateway captures dated inside Q2 IST, with exact zero variance. The cash shortfall does not establish the cause of the reported H1 test-volume growth gap.

**2. What growth benchmark is supplied?** The brief states 5.0% H1 2026 growth and 18.0% plan over H1 2025 test volume. (Recomputed from bookings at +5.8% actual and +18% plan; see the growth analysis.)

**3. What coverage issue matters?** Chennai and Jaipur have no Q2 legacy booking test lines but have 24,325 Nova collection visits.

**4. What does the estimate say?** At 2.353 assumed tests/visit, estimated H1 2026 lines are 456,448.725 versus 436,302 H1 2025 lines, or 4.6176% estimated growth.

**5. Why not call this exact test volume?** Nova tests are imputed and include all Nova collection visits, including no-shows. There is no lab-result table.

**6. What can chronology establish?** Under the stated workflow, unpaid status on an existing invoice cannot mechanically erase a preceding test count.

**7. What can chronology not establish?** It cannot rule out credit blocks, cancellations or repeat-visit effects on future volume.

**8. Can the team claim route saturation?** No. Route capacity, utilization and rejected-slot data are missing.

**9. What are the action owners?** Finance reviews older balances/terms, Engineering verifies references and retry handling, Operations supplies Nova and driver evidence. These are suggested roles, not assigned individuals.

**10. What would you say under panel pressure?** State the computed denominator and period, show the exact audit, and say when a causal claim remains unverified.
