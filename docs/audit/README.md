# Baseline manifest

`BASELINE_MANIFEST.csv` lists all 29 files of the baseline commit
`cb61ead4021662515dce317976bff9a68caf7bac`. For each file it gives:
- the Git blob id;
- the SHA-256 of the committed content;
- the size;
- a classification.

| Class | Meaning |
|---|---|
| A | authoritative source / configuration |
| B | raw / input data |
| C | analysis code |
| D | manuscript |
| E | scientific output |
| F | generated reproducible artifact |
| G | legacy / historical |
| H | temporary / cache (none present) |
| I | uncertain (none present; `data/data.csv` is class B with provenance partly UNKNOWN) |

## Verifying that scientific files are unchanged

The most robust check compares Git blob ids. It works on any operating system and with any
line-ending setting:

```
git ls-tree -r cb61ead
git ls-tree -r HEAD
```

The blob ids of data, tables, figure, results and manuscript files must be equal.

`baseline_sha256.txt` can be checked with `sha256sum -c docs/audit/baseline_sha256.txt` on a
checkout **without** line-ending conversion (for example on Linux or macOS). On Windows with
`core.autocrlf=true`, text files are stored with CRLF line endings, so their file hashes
differ even though their content is the same.

Files changed by the closure (`README.md`, `.gitignore`, `run_project.R` and `scripts/00`, `02`, `07`, `08`) will
differ from the baseline. Those changes are listed in the closure commit and in
`REPRODUCTION_VALIDATION.md`.
