# Data provenance

**UNKNOWN** means the information was not recorded and could not be recovered. Nothing below
is filled in by assumption.

## `data/data.csv` (input)

| Field | Value |
|---|---|
| Role | Only input file of the project |
| SHA-256 of the committed content (LF line endings) | `94f579c4c952bcdd6638b64ac16a3970d10811f17eedab4d2df6efe299ae06b0`. A Windows checkout with CRLF line endings has a different file hash, `2550459fbd0ee19a12067cddcaefa8d822bca225d59f0e1dda6a443e6301e48c`, but the same content. |
| Git blob (baseline `cb61ead`) | `77962609716cbd9c3b030fd7fcc86845bacc9133` |
| Format | CSV, header `"date","CPIAUCSL","FEDFUNDS","GDP"`, missing values written as `NA` |
| Rows | 949 monthly dates, 1947-01-01 to 2026-01-01, first day of each month; no duplicate or missing months |
| Source | The column names are FRED (Federal Reserve Bank of St. Louis) series identifiers. The file itself does not record its source. |
| Retrieval date | **UNKNOWN** |
| Vintage / realtime period | **UNKNOWN** |
| Download method or script | **UNKNOWN** (no script in the repository) |
| Raw or processed | **Processed.** Three series of different frequencies are merged on one monthly date column. The quoting and `NA` style match R's `write.csv`, so this is not an unmodified FRED download. The original downloads are not in the repository. |
| Values checked against FRED | **Not verified.** During the audit FRED could not be reached from the audit environment. |

### Columns

| Column | Concept (as published by FRED; not verified against the file) | Unit | Native frequency | Non-missing | First | Last |
|---|---|---|---|---|---|---|
| `CPIAUCSL` | Consumer Price Index for All Urban Consumers: All Items, seasonally adjusted (BLS) | Index 1982–84 = 100 | Monthly | 948 | 1947-01 | 2026-01 |
| `FEDFUNDS` | Effective federal funds rate (Board of Governors) | Percent, annual rate | Monthly | 859 | 1954-07 | 2026-01 |
| `GDP` | Gross domestic product, nominal, seasonally adjusted annual rate (BEA) | Billions of dollars | Quarterly, stored in the first month of each quarter | 316 | 1947-01 | 2025-10 |

### Missing values

- `CPIAUCSL`: one missing value inside the series, **2025-10-01**. The reason is not recorded
  in the file.
- `FEDFUNDS`: missing before 1954-07; no gaps inside the series.
- `GDP`: present only in January, April, July and October; no quarterly gaps.

No imputation, interpolation, rebasing, deflation or seasonal adjustment is done in the
repository.

## Transformations in the code (exactly as implemented)

| Output | Script | Transformation |
|---|---|---|
| `inflation_monthly` (in memory) | `scripts/02` | `100 * diff(log(CPIAUCSL))`; the first row is dropped |
| `results/final_dataset.csv` | `scripts/02` | Mean by calendar quarter, ignoring missing values: `Inflation` (mean of monthly inflation), `Interest_Rate` (mean of FEDFUNDS), `GDP` (the single quarterly value), then `na.omit`. Result: 286 quarters, 1954Q3–2025Q4. 2025Q4 inflation is December 2025 only, because of the October CPI gap. |
| Monthly model data (in memory) | `scripts/08` | `na.omit(data.frame(inflation_monthly, FEDFUNDS))`: 857 months, 1954-07 to 2026-01, with one gap (October–November 2025) |

## Generated files

| File | Produced by | Reproduced in closure |
|---|---|---|
| `results/final_dataset.csv` | `scripts/02` | Byte-identical |
| `tables/*.csv` | `scripts/08` | Byte-identical (text) |
| `tables/*.html` | `scripts/08` (modelsummary/tinytable) | Same cell content; markup and ids differ |
| `figures/cusum_stability_test.png` | `scripts/06`–`07` | Same values; image bytes differ by graphics device |
| `paper/inflation_interest_paper.docx` | Rendered from the `.Rmd` (Word metadata: created 2026-03-11) | Not re-rendered; contains no computed values |
