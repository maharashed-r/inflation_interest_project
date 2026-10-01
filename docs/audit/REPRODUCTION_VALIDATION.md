# Reproduction validation (archival closure, 2026-10-01)

Environment: see [../ENVIRONMENT.md](../ENVIRONMENT.md). All runs used copies outside the
repository.

## BEFORE: original code at `cb61ead`, unchanged

`run_project.R` (steps 0–7) was run without any edit to the scripts. The only intervention
was a no-op `View()` placed on the search path, because a headless session cannot open a
viewer.

`scripts/08_tables.R` could **not** be run at baseline (parse error at line 17). The
reference for the tables is therefore the committed files.

The quarterly pipeline printed the following. These values were never written to a file at
baseline and are recorded here for completeness.

| Item | Value |
|---|---|
| ADF level, `tseries::adf.test` | Inflation −3.5562 (p = 0.0377); Interest_Rate −2.9938 (p = 0.1574); GDP 2.6856 (p = 0.99) |
| ADF first difference | −7.1196, −7.5388, −4.8294 (all p = 0.01, the minimum the test prints) |
| Selected model | ARDL(3,2,1), `Inflation ~ Interest_Rate + GDP`, observations 4–286 |
| Coefficients | (Intercept) 0.0572700; L(Inflation,1) 0.2350975; L(Inflation,2) 0.1679688; L(Inflation,3) 0.2272124; Interest_Rate 0.0547994; L(Interest_Rate,1) −0.0143080; L(Interest_Rate,2) −0.0289895; GDP 0.0002519; L(GDP,1) −0.0002552 |
| Bounds F-test (case 3, k = 2) | F = 12.69, p = 1e-06 (asymptotic) |
| Durbin-Watson | 2.014 (p = 0.4887) |
| Breusch-Pagan | 22.394, df = 8, p = 0.004236 |

## AFTER: closure branch, `tools/reproduce_and_verify.R`

The full pipeline (steps 0–8) was run in a temporary copy, with no stub and no manual step.
The outputs were compared with the committed files.

| Output | Result |
|---|---|
| `results/final_dataset.csv` | **Identical** (text) |
| `tables/adf_results.csv` | **Identical** |
| `tables/bounds_test.csv` | **Identical** (F = 45.344) |
| `tables/descriptive_statistics.csv` | **Identical** |
| `tables/ecm_results.csv` | **Identical** (ect = −0.3873) |
| `tables/long_run_coefficients.csv` | **Identical** |
| `tables/descriptive_statistics.html` | **Same 24 cells**; markup and ids differ |
| `tables/correlation_matrix.html` | **Same 8 cells**; markup and ids differ |
| `figures/cusum_stability_test.png` | AFTER bytes = BEFORE bytes in the same environment. Compared with the committed file (made on another machine), the size is the same (900×600) and the plot looks the same; 2.8% of pixels differ because of anti-aliasing and fonts. |
| Quarterly console output (steps 3–6) | Same as BEFORE; only the position of four `adf.test` warning messages differs |

**Scientific numeric difference: zero.**

This is also the first time `scripts/08_tables.R` was run non-interactively. Its outputs
match the committed tables exactly, which confirms that they came from this code.
