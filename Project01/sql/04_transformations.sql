-- Query 1: The Reconciled Revenue Bridge for Q2 2026
WITH q2_invoices AS (
    SELECT invoice_id, amount_rs 
    FROM invoices 
    WHERE invoice_date >= '2026-04-01' AND invoice_date <= '2026-06-30'
),
captured_payments AS (
    SELECT invoice_id, 
           sum(amount_rs) AS paid_rs, 
           min(created_at) AS first_paid
    FROM payments 
    WHERE status = 'captured' 
    GROUP BY invoice_id
),
classified_bridge AS (
    SELECT 
        q.invoice_id, 
        q.amount_rs AS invoiced_rs, 
        p.paid_rs,
        CASE 
            WHEN p.invoice_id IS NULL THEN '1. Invoices Never Paid'
            WHEN p.first_paid > '2026-06-30 23:59:59' THEN '2. Paid After Cutoff (Timing)'
            ELSE '3. Collected In Quarter'
        END AS bridge_bucket
    FROM q2_invoices q
    LEFT JOIN captured_payments p ON p.invoice_id = q.invoice_id
)
SELECT 
    bridge_bucket,
    count(*) AS invoice_count,
    sum(invoiced_rs) AS total_invoiced_rs,
    sum(coalesce(paid_rs, 0)) AS total_paid_rs,
    sum(coalesce(paid_rs, 0)) - sum(invoiced_rs) AS amount_variance_rs
FROM classified_bridge
GROUP BY bridge_bucket
ORDER BY bridge_bucket;

-- Query 2: Unpaid Invoice Aging Analysis (Working Float vs True Leak)
SELECT 
    CASE 
        WHEN invoice_date >= '2026-06-24' THEN '1. Last Week of June (Working Float)'
        WHEN invoice_date >= '2026-06-01' THEN '2. June 1-23 (Soft Overdue)'
        WHEN invoice_date >= '2026-05-01' THEN '3. May 2026 (Moderate Overdue)'
        ELSE '4. April 2026 (Hard Overdue)'
    END AS aging_bucket,
    count(*) AS unpaid_invoices,
    sum(amount_rs) AS unpaid_amount_rs,
    round(100.0 * sum(amount_rs) / 11107904.00, 2) AS pct_of_unpaid_gap
FROM invoices i
LEFT JOIN payments p ON p.invoice_id = i.invoice_id AND p.status = 'captured'
WHERE i.invoice_date BETWEEN '2026-04-01' AND '2026-06-30'
  AND p.invoice_id IS NULL
GROUP BY aging_bucket
ORDER BY aging_bucket;

-- Query 3: Weekly Recurring Finance Control Query
SELECT 
    date_trunc('week', invoice_date) AS invoice_week,
    count(DISTINCT i.invoice_id) AS total_invoices,
    sum(i.amount_rs) AS total_invoiced,
    sum(CASE WHEN p.status = 'captured' THEN p.amount_rs ELSE 0 END) AS total_collected,
    round(100.0 * sum(CASE WHEN p.status = 'captured' THEN p.amount_rs ELSE 0 END) / sum(i.amount_rs), 2) AS realization_rate_pct
FROM invoices i
LEFT JOIN payments p ON p.invoice_id = i.invoice_id
WHERE i.invoice_date >= '2026-01-01'
GROUP BY invoice_week
ORDER BY invoice_week DESC;
