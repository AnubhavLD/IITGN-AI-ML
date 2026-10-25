# Diagrams · Brief C · Group 4

Mermaid sources, rendered by GitHub when this file is opened in the repository, and exportable as PNG in `docs/diagrams/` for slides. Every diagram answers one question, named in its heading. These represent the analytical design for the billing-to-payment reconciliation; the cutoff, settlement handling and exception categories are validated against source data and finance policy (see the checklist at the end).

## 1 · System context: who and what surrounds the reconciliation

```mermaid
flowchart LR
    ERP[Billing ERP] -->|Invoice exports| PIPE[Reconciliation Pipeline]
    PG[Payment Gateway] -->|Payment attempts and captures| PIPE
    PG -->|Settlement references| SET[Settlement Feed]
    SET --> PIPE
    PIPE -->|Bridge, exceptions, evidence| DASH[Finance Controller Dashboard]
    DASH --> FC[Finance Controller]
```

## 2 · Data context: what each export records

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

## 3 · High-level design: the analysis as a pipeline

```mermaid
flowchart LR
    A[Step 1: Profile] --> B[Step 2: Clean and Validate]
    B --> C[Step 3: Build Invoice-Payment Bridge]
    C --> D[Step 4: Anti-Join and Investigate Exceptions]
    D --> E[Export Action Lists and Audit Checks]
```

## 4 · Entity model of the clean tables

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

**Cardinality caveat:** a payment may have no valid invoice match; a settlement ID may be absent or pending. The diagram models the *intended reference relationship*, not a guaranteed foreign key. Settlement fields are illustrative and are checked against the real settlement schema.

## 5 · The life of an invoice, as a state machine

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

## 6 · Decision flow: matching a payment to an invoice

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

## 7 · The financial reconciliation bridge

```mermaid
flowchart TD
    A[Q2 2026 Invoice Value] --> B[Less: Invoices without eligible captured payments]
    B --> C[Plus / Minus: Amount differences on matched invoices]
    C --> D[Equals: Captured payments attributed to Q2 invoices]
    D --> E[Separately reconcile: gateway captures vs bank settlements]
    F[Post-cutoff captures] -.->|Timing analysis; avoid double-counting| B
    G[Orphan payments] -.->|Separate cash exception population| E
```

**Bridge rule:** mutually exclusive categories, exact amounts. A post-cutoff capture cannot also count as a permanent unpaid loss. Orphan payments are not automatically attributable to Q2 invoices.

## 8 · Exception triage and action ownership

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

**Policy caveat:** the seven-day timing rule is a working heuristic, not proof that every younger unpaid invoice is settlement float. Confirm against contractual payment terms and observed post-cutoff receipts.

## 9 · Audit trail and cold-run validation

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

- [ ] Confirm exact input filenames, schemas and row counts.
- [ ] Verify invoice-ID normalization against real gateway references.
- [ ] Confirm whether the payment cutoff uses UTC or IST and document the rule.
- [ ] Keep payment captures separate from settlement deposits and fees.
- [ ] Validate exception classification against payment terms and refunds.
- [ ] Confirm each bridge component is mutually exclusive and balances exactly.
- [ ] Ensure every action-list row traces to original invoice and/or payment IDs.
