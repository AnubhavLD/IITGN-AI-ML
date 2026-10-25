# Kalpa Health — Cleaned Data (`data/clean`)

**Brief C · Money** — analysis-ready tables cleaned from the raw Kalpa Health data pack.
Cleaning is **non-destructive**: original raw columns are kept, and cleaned columns are added
alongside. Every decision and count is logged in [`_decisions_log.md`](./docs/decisions_log.md).

> ⚠️ **These CSVs are large** (up to ~258 MB) — above GitHub's 100 MB file limit — so the
> data lives on Google Drive and is linked below.
>
> 📂 **[Download all cleaned files — Google Drive folder](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S)**

---

## Files in this folder

| File | What it is | Rows | Size | Download |
|---|---|---:|---:|:--:|
| `bookings_clean.csv` | Bookings, two vendors (legacy + nova) unified; dates → `created_at_ist` / `slot_at_ist`, `channel`/`source` lowercased | 1,315,204 | 258 MB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `payments_gateway_clean.csv` | Captured gateway payments; `amount_paise`→`amount_rs`, epoch→`created_at_ist`, `invoice_ref_clean` standardized | 455,469 | 70 MB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `invoices_clean.csv` | Invoices; thousands-separated `amount` → numeric `amount_clean` (₹120–9,896) | 470,776 | 52 MB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `collections_clean.csv` | Sample-collection records; 2,894 exact duplicates removed | 549,598 | 51 MB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `payments_gateway_rejected.csv` | **Audit** — failed gateway payments (never settled) | 18,038 | 2.8 MB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `collections_duplicates_removed.csv` | **Audit** — the exact-duplicate collection rows removed | 2,894 | 284 KB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `payments_settlements_clean.csv` | Bank settlement batches; `amount`/`fees`/`tax` paise→rupees, epoch→IST | 562 | 88 KB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |
| `bookings_rejected.csv` | **Audit** — leaked header rows dropped from the source files | 21 | 4 KB | [⬇︎](https://drive.google.com/drive/folders/1phhkk5NmygkzlJgvM7i-9drZKhFVwp_S) |

---

## Cleaning applied

- **Paise → rupees** (`/100`) on all gateway and settlement amounts.
- **Epoch → IST** — `created_at_epoch` (UTC seconds) converted to a readable `created_at_ist` (`YYYY-MM-DD HH:MM:SS+05:30`).
- **Invoice references standardized** — messy `notes_invoice_ref` (missing hyphens, casing, whitespace) normalized to `INV-YYYY-NNNNNN` (99% match to `invoice_id`).
- **Amounts de-formatted** — invoice `amount` thousands separators (`"1,070.00"`) stripped into numeric `amount_clean`.
- **Dates unified** — bookings' two vendor formats (legacy `DD/MM/YYYY`, nova ISO + 05:30) merged to one `YYYY-MM-DD HH:MM:SS`.
- **Statuses split** — captured vs failed gateway payments separated; rejected rows kept in audit files.
- **Duplicates & bad rows removed** — exact duplicates and leaked header rows dropped, each into a `*_rejected` / `*_duplicates_removed` audit file.


*Generated for IITGN Build Week 1 · Brief C · Group 4.*
