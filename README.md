# Kalpa Health Brief C

Build Week 1, IIT Gandhinagar Cohort 2\. Analysis prepared 24 October 2026 for the COO and Finance Controller roles specified in the brief. No review or acceptance by those people is asserted.

For 79,246 invoices dated April 1 to June 30, 2026, ₹132,847,274.00 invoiced reconciles to ₹119,265,677.00 gateway captures dated inside Q2 IST, with exact zero variance. The cash shortfall does not establish the cause of the reported H1 test-volume growth gap.

| Q2 2026 invoice-cohort bridge | Signed INR | Invoice count / 79,246 | Definition |
| :---- | ----: | ----: | :---- |
| Starting invoiced | ₹132,847,274.00 | 79,246 | All Q2 invoice dates |
| Subtract no capture in supplied feed | ₹-11,107,904.00 | 6,581 | Across the supplied capture history |
| Subtract first captured after June 30 IST | ₹-2,982,123.00 | 1,763 | Q2 invoices, no capture by quarter close |
| Add net amount differences | ₹508,430.00 | 330 | Only captures dated inside Q2 |
| End: gateway captured inside Q2 | ₹119,265,677.00 | 70,902 | Q2 invoice cohort, capture dates inside Q2 |

The bridge is exact to the paise. It uses integer paise and has no rounding plug. The four mutually exclusive invoice buckets are 6,581 never captured in the available feed, 1,763 first captured after close, 330 with a Q2 amount difference, and 70,572 captured at the exact invoiced amount. They sum to 79,246. Starting invoiced is the baseline, not a fifth bucket.

## Finance action

- Chase review: ₹4,841,145.00 across 2,854 invoices dated before June 24 out of 79,246 Q2 invoices. Confirm reference mapping and credit terms before contacting a payer.  
- Wait review: ₹6,266,759.00 across 3,727 invoices dated June 24 to 30 out of 79,246 Q2 invoices. This is 56.4171% of the ₹11,107,904.00 unpaid value across 6,581 Q2 invoices. Recent age is a working-float classification, not proof of collectability.  
- Fix: investigate 317 multi-capture invoices out of 79,246 Q2 invoices. Review 4,588 unmatched captured attempts out of 455,469 captured attempts in the full supplied feed, worth ₹7,269,408.00. These are cash already captured and remain outside the matched invoice bridge.

## Material findings

The requested reference code would report ₹119,286,373.00. That is ₹20,696.00 too high for Q2 across seven captures on seven Q2 invoices, because it includes July captures whenever an invoice's first capture was in June. A balanced equation alone would not reveal that population error.

The source cleaner already converted paise to rupees and labelled timestamps as IST. Raw combined workbooks and raw epochs were not supplied. This build does not divide clean rupees by 100 or shift clean IST a second time. Raw conversion functions are unit-tested. Source-timezone provenance remains conditional on the clean-file labels.

The supplied cleaner remapped 4,765 attempt references by subtracting 900,000. The primary case applies only the requested format normalization to the preserved `notes_invoice_ref`. It does not accept that semantic remap as verified identity. The separate supplied-remap sensitivity produces ₹120,537,859.00 Q2 captures, 5,845 unpaid Q2 invoices and 321 Q2 multi-capture invoices. Its exact invoice-level recomputation agrees with the provided reconciliation workbook on all 470,776 invoices. This is a policy difference, not an arithmetic disagreement.

The supplied processed settlement feed reconciles across 562 batches with zero absolute residual. Its Q2 net is ₹123,266,859.98 across 91 processed batches covering all cohorts. No independent bank statement is supplied. Read the separate capture-to-settlement bridge before using the word banked.

## Causal answer

Brief C identifies a realization and attribution problem. Payment status does not change the number of already recorded test lines. The supplied data do not identify a causal effect of unpaid invoices on future visits, credit holds or cancellations. A categorical claim that billing has no indirect effect, or that route saturation caused the gap, would exceed this evidence.

The legacy extract has 436,302 H1 2025 test lines and 399,212 H1 2026 test lines, but loses Chennai and Jaipur coverage in Q2 2026\. Adding 24,325 Nova collection visits at the source workbook's assumed 2.353 tests per visit produces an estimated 456,448.725 H1 2026 test lines, or 4.6176% growth over 436,302 H1 2025 test lines. Fractional tests are an estimate, not observed lab results. The brief's 5.0% actual, 18.0% plan and 13 percentage point gap are brief-stated, not fully verified all-city resulted-test metrics.

&nbsp;