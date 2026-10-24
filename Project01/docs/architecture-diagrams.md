# Architecture & Reconciliation Diagrams — Brief C (Money)

**Project:** Kalpa Health — Group 4  
**Purpose:** Nine Mermaid diagrams describing the billing-to-payment reconciliation design, decision rules, and audit controls.

> **Interpretation note:** These diagrams represent the proposed analytical design, not proof that every component or classification rule is implemented. The cutoff, settlement handling, and exception categories must be validated against source data and finance policy.

## 1. System Context

```mermaid
flowchart LR
    ERP[Billing ERP] -->|Invoice exports| PIPE[Reconciliation Pipeline]
    PG[Payment Gateway] -->|Payment attempts and captures| PIPE
    PG -->|Settlement references| SET[Settlement Feed]
    SET --> PIPE
    PIPE -->|Bridge, exceptions, evidence| DASH[Finance Controller Dashboard]
    DASH --> FC[Finance Controller]
```

## 2. Data Context

```mermaid
flowchart LR
    I[(invoices_*.csv.gz)] --> LOAD[Load and Profile]
    P[(gateway_export_*.csv.gz)] --> LOAD
    S[(Settlement exports, if available)] --> LOAD
    LOAD --> NORM[Normalize IDs, units, dates, status]
    NORM --> MATCH[Aggregate and Reconcile]
    MATCH --> BRIDGE[Financial Bridge]
    MATCH --> EXC[Exception Classification]
    EXC --> A[Unpaid / Chase Review CSV]
    EXC --> B[Orphan Cash Review CSV]
    EXC --> C[Potential Double Charges CSV]
    BRIDGE --> REPORT[Finance Report]
```

## 3. High-Level Design

```mermaid
flowchart LR
    A[Step 1: Profile] --> B[Step 2: Clean and Validate]
    B --> C[Step 3: Build Invoice-Payment Bridge]
    C --> D[Step 4: Anti-Join and Investigate Exceptions]
    D --> E[Export Action Lists and Audit Checks]
```

## 4. Entity Model

```mermaid
erDiagram
    INVOICES ||--o{ PAYMENTS : "referenced by (when matched)"
    SETTLEMENTS o|--o{ PAYMENTS : "groups captured payments"
    INVOICES {
        string invoice_id PK
        date invoice_date
        string booking_id
        decimal amount_inr
    }
    PAYMENTS {
        string payment_id PK
        string notes_invoice_ref
        decimal amount_paise
        string status
        datetime created_at_epoch
        string settlement_id FK
    }
    SETTLEMENTS {
        string settlement_id PK
        datetime settlement_date
        decimal net_settlement_inr
    }
```

**Cardinality caveat:** A payment may have no valid invoice match; a settlement ID may be absent or pending. The entity diagram models the *intended reference relationship*, not a guaranteed foreign-key constraint. Settlement fields shown are illustrative and must be checked against the actual settlement export schema.

## 5. The Life of an Invoice

```mermaid
stateDiagram-v2
    [*] --> Issued
    Issued --> PaymentAttempted
    PaymentAttempted --> Failed: Attempt failed
    Failed --> PaymentAttempted: Retry
    PaymentAttempted --> Captured: Attempt captured
    Captured --> SettlementPending
    SettlementPending --> SettledToBank: Settlement confirmed
    SettlementPending --> Investigation: Settlement missing or delayed
    Issued --> UnpaidReview: No captured payment by cutoff
    UnpaidReview --> PaymentAttempted: Later payment
    SettledToBank --> [*]
```

## 6. Decision Flow for Matching

```mermaid
flowchart TD
    A[Gateway payment row] --> B{Invoice reference matches strict normalization rule?}
    B -- No --> O[Orphan / invalid reference review]
    B -- Yes --> C{Status = captured?}
    C -- No --> X[Retain as non-captured attempt; exclude from captured cash]
    C -- Yes --> D{Matching invoice exists?}
    D -- No --> O
    D -- Yes --> E{Captured by Q2 cutoff?}
    E -- Yes --> F[Include in Q2 captured-payment comparison]
    E -- No --> G[Post-cutoff payment / timing review]
    F --> H{Aggregate paid amount equals invoice amount?}
    H -- Yes --> M[Matched]
    H -- No --> J[Amount difference / potential double-charge review]
    G --> K[Classify timing only after checking payment and settlement policy]
```

## 7. Financial Reconciliation Bridge

```mermaid
flowchart TD
    A[Q2 2026 Invoice Value] --> B[Less: Invoices without eligible captured payments]
    B --> C[Plus / Minus: Amount differences on matched invoices]
    C --> D[Equals: Captured payments attributed to Q2 invoices]
    D --> E[Separately reconcile: gateway captures vs bank settlements]
    F[Post-cutoff captures] -.->|Timing analysis; avoid double-counting| B
    G[Orphan payments] -.->|Separate cash exception population| E
```

**Bridge rule:** Use mutually exclusive categories and exact amounts. A post-cutoff capture cannot be simultaneously counted as a permanent unpaid loss. Orphan payments are not automatically attributable to Q2 invoices.

## 8. Exception Triage and Action Ownership

```mermaid
flowchart TD
    A[Reconciliation exceptions] --> B{Exception type}
    B -->|No captured payment| C{Aged beyond agreed grace period?}
    C -->|Yes| D[Chase: Collections team review]
    C -->|No| E[Wait: Timing / pending review]
    B -->|Invalid or unmatched invoice ref| F[Fix: Billing / gateway mapping]
    B -->|Multiple captures or amount delta| G[Fix: Finance and refunds review]
    B -->|Capture not yet settled| H[Wait / Escalate: Settlement operations]
    D --> I[Evidence-backed action CSVs]
    E --> I
    F --> I
    G --> I
    H --> I
```

**Policy caveat:** The seven-day timing rule described in the project approach log is a working heuristic, not proof that all younger unpaid invoices are settlement float. Confirm it against contractual payment terms and observed post-cutoff receipts.

## 9. Audit Trail and Cold-Run Validation

```mermaid
flowchart TD
    A[Immutable raw extracts] --> B[Ingestion counts and checksums]
    B --> C[Cleaned invoice and payment tables]
    C --> D[Row conservation: input = kept + rejected]
    C --> E[Unique keys and join-cardinality checks]
    D --> F[Invoice-level reconciliation output]
    E --> F
    F --> G[Bridge balance assertion]
    F --> H[Unmatched payment anti-join]
    G --> I[Reproducible report and action lists]
    H --> I
    I --> J[Cold run with documented runtime and outputs]
```

## Review checklist

- [ ] Confirm exact input filenames, schemas, and row counts.
- [ ] Verify invoice ID normalization against real gateway references.
- [ ] Confirm whether payment cutoff uses UTC or IST and document the rule.
- [ ] Keep payment captures separate from settlement deposits and fees.
- [ ] Validate exception classification against payment terms and refunds.
- [ ] Confirm that each bridge component is mutually exclusive and balances exactly.
- [ ] Ensure every action-list row traces to original invoice and/or payment IDs.
