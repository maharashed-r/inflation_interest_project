# Software environment

## Original environment

- `renv.lock` records **R 4.5.2** and the package `renv` 1.1.6 only.
- The versions of the analysis packages used by the original author are **UNKNOWN**. The
  lockfile was never snapshotted after they were installed.
- The lockfile is kept unchanged. A lockfile was not reconstructed, because it would claim
  versions that cannot be confirmed.

## Packages used

**Analysis** (attached by `scripts/00_packages.R`, in this order):
dplyr, lubridate, here, ARDL, dynlm, Formula, lmtest, sandwich, strucchange, tseries, urca,
ggplot2.

**Tables** (`scripts/08_tables.R`): modelsummary, which requires tinytable.

Install all of them once with `scripts/install_packages.R`.

## Environment that reproduced the committed outputs (archival closure, 2026-10-01)

| Component | Version |
|---|---|
| OS | Ubuntu 24.04 (Linux) |
| R | 4.3.3 |
| ARDL | 0.2.4 (the CRAN release available when the project was committed; 0.2.5 was released in May 2026) |
| dynlm | 0.3.6 |
| zoo | 1.8.12 |
| aod | 1.3.3 |
| lmtest | 0.9.40 |
| sandwich | 3.1.0 |
| strucchange | 1.5.3 |
| tseries | 0.10.55 |
| urca | 1.3.3 |
| dplyr | 1.1.4 |
| lubridate | 1.9.3 |
| here | 1.0.1 |
| Formula | 1.2.5 |
| ggplot2 | 3.4.4 |
| modelsummary | 2.6.0 |
| tinytable | 0.19.0 |
| knitr | 1.52 |

With these versions, the dataset and all six CSV tables were reproduced byte-identically.
The figure has the same values but different image bytes (graphics device). The HTML tables
have the same cells. ARDL, aod and modelsummary were installed from source copies of the CRAN
releases.

## Notes

- `tinytable` needs a recent `knitr`. An older knitr fails with
  `object 'record_print' not found`, and modelsummary then reports wrongly that tinytable is
  not installed.
- The HTML tables contain random element ids. Their bytes change on every run even when the
  content is the same.
