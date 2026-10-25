# Assistant Log — Group 4 — Brief C

**Purpose:** Document AI-assistant use, assess the quality of assistance, and record the team's independent modifications and application for academic integrity.

| # | Tool | Prompt / Query | Output Quality | Human Modification & Application | Date |
|---|---|---|---|---|---|
| 1 | Claude Sonnet | "Explain difference between `validate='1:1'` and `validate='1:m'` in pandas merge" | Excellent | Used to establish join assertion in `03_clean_reconcile.ipynb`. | Day 1 |
| 2 | ChatGPT | "Regex pattern to match both INV2026123456 and INV-2026-123456" | Good | Modified regex to enforce 4-digit year and 6-digit sequence in `loaders.py`. | Day 1 |
| 3 | Claude Opus | "How to convert Unix epoch seconds to IST in vectorised Pandas" | Excellent | Applied `pd.to_datetime(..., unit='s') + pd.Timedelta(hours=5, minutes=30)`. | Day 2 |

> **Integrity note:** The entries above are transcribed from the team's supplied draft. Verify the actual tools, prompts, dates, and human modifications against your usage history before submitting. Add any other material AI assistance used during the project. For timezone-aware processing, explicitly localizing UTC and converting to `Asia/Kolkata` is generally safer than adding a fixed offset to a timezone-naive timestamp.
