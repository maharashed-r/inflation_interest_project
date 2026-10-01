# Scientific limitations

This document records limitations found by the 2026 audit of the project at baseline commit
`cb61ead`. It describes the project as it is. It does not change any result, and the
original outputs remain in the repository unchanged.

Sources:
- the audit's Phase 1 report (forensic and econometric audit);
- the reproduction run of the archival closure (October 2026).

Figures marked *(audit computation)* were calculated by the auditor with separate code. They
are not outputs of the project's scripts.

## 1. Three different specifications

| | Manuscript (`paper/`) | Quarterly pipeline (`scripts/02`–`07`) | Committed tables (`scripts/08`) |
|---|---|---|---|
| Frequency | quarterly | quarterly | **monthly** |
| Inflation | log differences | quarterly mean of monthly 100·Δln CPI | monthly 100·Δln CPI |
| Interest rate | "interest rate" | quarterly mean of FEDFUNDS | monthly FEDFUNDS |
| Third variable | **GDP growth** (log differences) | **nominal GDP level** (billions of dollars) | **none** |
| "Adjusted for stationarity" | stated | not done | not done |

- The committed tables and the committed figure come from **different models**. The tables
  are from the monthly two-variable model; the CUSUM figure is from the quarterly model.
- The manuscript does not name the country, the period or the data source.
- The manuscript contains no numbers or tables. Its statements are qualitative.

## 2. GDP definition

The manuscript says GDP growth computed with log differences. The code uses the FRED series
`GDP`, which is **nominal GDP in levels** (billions of dollars, seasonally adjusted annual
rate). It is not real, not a growth rate, and not in logs.

## 3. Units

- Inflation is a **monthly** rate (100·Δln CPI). It is not annualised.
- The federal funds rate is an **annual** rate.

Coefficients are therefore in mixed units. For example, a long-run coefficient of 0.0386
means about 0.039 percentage points of *monthly* inflation per percentage point of the
federal funds rate.

## 4. Integration order and the bounds test

- Monthly inflation looks stationary in levels. The committed ADF statistic is −7.401
  (with trend, 4 lags); the 5% critical value is −3.41 *(audit computation)*.
- The federal funds rate does not reject a unit root (−2.801).
- In the quarterly data, `tseries::adf.test` gives p = 0.038 for inflation, and KPSS rejects
  level stationarity at 5% (p = 0.024) *(audit computation)*. The evidence is mixed.
- When the dependent variable is I(0), a significant bounds F-statistic (monthly F = 45.344;
  quarterly F = 12.69) and a negative ECT (monthly −0.3873) are consistent with inflation
  returning to its own mean. They do **not**, on their own, show a long-run (cointegrating)
  relationship. This is the "degenerate" case discussed by Pesaran, Shin & Smith (2001) and
  McNown, Sam & Goh (2018).
- `tables/bounds_test.csv` reports the F-statistic without critical values or a p-value.
- The deterministic specification (case 3, no trend) was fixed in advance and not tested
  for sensitivity.

## 5. Label discrepancy in `tables/long_run_coefficients.csv`

- The file contains the **short-run coefficients of the ARDL(4,4) model in levels** (lags of
  inflation and interest). It does **not** contain long-run multipliers.
- The long-run multiplier of interest is +0.0386 *(audit computation)*. Its Newey-West
  delta-method standard error is 0.0070.
- The file is kept unchanged. This note is the correction record.

## 6. Diagnostics

The manuscript says the model has no serial correlation and no heteroskedasticity. The audit
found otherwise:
- **Monthly ARDL(4,4):** Breusch-Godfrey(12) p = 3.6e-6, Breusch-Pagan p = 0.002, and
  Jarque-Bera p < 2e-16 *(audit computation)*.
- **Quarterly pipeline model:** Breusch-Pagan p = 0.0042, an output of `scripts/06`.
- The pipeline's serial-correlation check is Durbin-Watson (quarterly DW = 2.014, p = 0.49).
  This test is not valid with a lagged dependent variable.
- `scripts/06` computes CUSUM on `residuals(best_model) ~ 1`. That is a CUSUM of the
  residuals' mean, not the recursive-residual CUSUM of the regression.

## 7. Structural breaks

- The sample covers about 70 years of different monetary regimes: the Great Inflation and
  the Volcker disinflation, the Great Moderation, the zero lower bound (2009–2015,
  2020–2021) and the pandemic.
- A Bai-Perron search finds breaks near **1980-11 and 2008-05** *(audit computation)*.
- The models assume constant coefficients over the whole period.

## 8. Causal interpretation

- The federal funds rate enters contemporaneously. Monetary policy responds to inflation
  (reverse causality), so the coefficients are **associations, not causal effects**.
- The manuscript's conclusion that "monetary policy variables play an important role in
  explaining inflation dynamics" goes beyond what the design can show.
- The estimated long-run association is **positive**. This is consistent with a Fisher or
  policy-reaction relationship, not with the idea that higher rates lower inflation.

## 9. Lag selection

The committed monthly model is ARDL(4,4), chosen by `auto_ardl` with its default search. A
full AIC grid over the same orders gives ARDL(4,3) *(audit computation)*. The committed
output is what the project's code produces. The difference comes from the search method,
not from an error in the outputs.

## 10. Data issues

- The CPI value for **October 2025** is missing in `data/data.csv`. As a result:
  - monthly inflation is missing for October and November 2025;
  - the 2025Q4 quarterly value uses December only;
  - in the monthly model, lags run across this gap after `na.omit`.
- The provenance of `data/data.csv` is incomplete: no retrieval date, vintage or download
  script. See [provenance/DATA_PROVENANCE.md](provenance/DATA_PROVENANCE.md).

## 11. Reproducibility at baseline (some items fixed in the closure without changing results)

| Issue at baseline | Closure action |
|---|---|
| `scripts/08_tables.R` could not be parsed (three section titles were bare text) | Titles turned into comments |
| `scripts/08` was not in `run_project.R` and relied on objects from an interactive session | Added as step 8; attaches `modelsummary`; loads `raw_data` if absent |
| `View()` in `scripts/02` stopped non-interactive runs | Runs only in interactive sessions |
| `scripts/00` installed packages during the analysis | Now stops with a message; installation moved to `scripts/install_packages.R` |
| `renv.lock` records no analysis packages; original package versions UNKNOWN | Documented in `docs/ENVIRONMENT.md` (lockfile not invented) |
| `scripts/06`–`07` depend on `best_model` / `cusum_test` in memory | Documented; unchanged |
| `scripts/01` result unused; it renames the CPI level column to "inflation" | Documented; unchanged (legacy) |

None of these changes alters any number. See
[audit/REPRODUCTION_VALIDATION.md](audit/REPRODUCTION_VALIDATION.md).

## References

- McNown, R., Sam, C. Y., & Goh, S. K. (2018). Bootstrapping the autoregressive distributed
  lag test for cointegration. *Applied Economics*, 50(13), 1509–1521.
- Pesaran, M. H., Shin, Y., & Smith, R. J. (2001). Bounds testing approaches to the analysis
  of level relationships. *Journal of Applied Econometrics*, 16(3), 289–326.
