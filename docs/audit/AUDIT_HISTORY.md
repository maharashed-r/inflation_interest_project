# Audit history

| Phase | Date | Scope | Decision |
|---|---|---|---|
| 1 | 2026-09-30 | Read-only forensic, data, econometric and repository audit of baseline `cb61ead` | REQUIRES RESEARCH REDESIGN BEFORE CODE CHANGES |
| 2 | 2026-09-30 | Design only: which research question would be defensible | REDESIGN NOT YET APPROVED — DATA/IDENTIFICATION EVIDENCE REQUIRED |
| 3 | 2026-10-01 | Feasibility, identification and novelty of a separate follow-up study | ARCHIVE ORIGINAL — CREATE NEW PROJECT (the follow-up is outside this repository) |
| 4A | 2026-10-01 | Preservation, documentation and reproducibility closure of this repository | This branch: `cleanup/archival-closure-2026-10` |

## What "archive" means here

The project is **kept, not removed**:
- its data, code, tables, figure and manuscript are preserved with unchanged content;
- its limitations are documented in [../SCIENTIFIC_LIMITATIONS.md](../SCIENTIFIC_LIMITATIONS.md);
- its outputs can be re-created and checked with `tools/reproduce_and_verify.R`.

No result was corrected, improved or removed. Negative findings are documented, not deleted.

## Main Phase 1 findings (summary)

- Three different specifications (manuscript, quarterly pipeline, monthly tables).
- Nominal GDP level used where the manuscript says GDP growth.
- Inflation appears I(0), which makes the bounds-test reading of a long-run relationship
  degenerate.
- The manuscript's diagnostic claims are not supported.
- `long_run_coefficients.csv` is mislabelled.
- Structural breaks exist, and there is no causal identification.
- Provenance is incomplete, and the tables script could not be run.

Details are in [../SCIENTIFIC_LIMITATIONS.md](../SCIENTIFIC_LIMITATIONS.md).
