# Assistant log · Brief C · Group 4

Every use of a coding or chat assistant, one line each. Allowed uses: explaining an error you already tried to read, explaining a concept you then rewrite in your own words, checking English in the write-up without changing meaning. Not allowed: generating analysis, notebooks, cells, charts, slides, write-ups or the video script; asking what the answer or approach should be; pasting Kalpa Health data in.

An empty log next to notebooks that read like a tutorial is a claim the panel will test. Twenty honest lines are fine.

| # | Date | Tool | What we asked (one line) | What we did with the answer |
|---|---|---|---|---|
| 1 | Day 1 | Claude Sonnet | Explain the difference between `validate='1:1'` and `validate='1:m'` in a pandas merge | Established the join assertion in `03_clean_reconcile.ipynb`; rewrote the rule in our own words. |
| 2 | Day 1 | ChatGPT | A regex that matches both `INV2026123456` and `INV-2026-123456` | Rewrote the pattern to enforce a 4-digit year and 6-digit sequence in `loaders.py`. |
| 3 | Day 2 | Claude Opus | How to convert Unix epoch seconds to IST in vectorised pandas | Applied `pd.to_datetime(..., unit='s') + pd.Timedelta(hours=5, minutes=30)` in the loader. |


