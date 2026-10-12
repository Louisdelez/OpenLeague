# Recorder review — read-only production inspection

Reviewed `record_validation.py` and its read-only command verifier. The recorder was not executed. No client, Rust compiler, production edit or frozen-lot edit was performed.

## Findings

1. **Frozen archive content was not pinned by the recorder.** The `archive_*` functions compare each manifest against its expected hash, but then copy the directory and hash its current files. A modified artifact with an unchanged manifest could therefore be archived alongside the original qualification claim. No such drift was found in the current directories. The supplied `validate_prepared_archives.py` closes this check: call `validate()` before archive writes; use its returned hashes to verify destination copies as well. It validates seven pinned manifests, their local artifacts, the 17 indirectly pinned raw regions under `loading_service_global_preparation/source_manifest.json`, and an exact file inventory excluding `__pycache__`.

2. **Chronology is explicit in the full receipt but absent from its short summary/HTML.** `qualification_history.probe_only_repair.selected_tests_precede_probe_only_repair=true` correctly separates the 854 core/14 client tests from the later probe-only main change. The short fields `core_tests_passed`, `client_tests_passed` and the HTML sentence do not repeat that distinction. Add a short chronology field/sentence if those summaries will stand alone. This does not require rerunning unchanged implementation tests merely to change their description.

3. **Numeric CLI exit 101 is retained as history.** `first_clock_command.exit_code=101`, the previous executable hash and the four archived files remain in the receipt. Their archive hashes are checked before output. The archived report has a successful exercise and failed cleanup assertion; stderr preserves its panic. The numeric exit code itself is a carried-forward execution observation, not a field independently recoverable from those JSON/stderr files: the original runner threw before producing command-run.json. Do not present those four files alone as a structured process-exit capture.

## Checks which already prevent false final qualification

- `module.verify()` runs before archive functions or receipt/plan writes. It requires exactly 11 ordered commands, each exit 0, empty stderr, current executable SHA, per-command SHA agreement, expected reports, and stable hashes through verification. The recorder cannot mark final success merely because the earlier tests passed or one probe passed. This review did not execute that verifier against an unfinished run.
- Core and client logs each contain one passing test summary (854/14, zero failures) and retain their separate test-executable hashes. The receipt explicitly states that the only subsequent implementation change is the probe portion of main, and records its separate installed hash.
- Every prepared next lot is labelled unintegrated and incomplete. The prefix/ownership/shutdown proposals remain uncompiled or not integration-ready as appropriate; the 52 native lifecycle cases are not described as a Rust port.
- Initial core 849/3 and CLI failure 101 are not replaced by the final successful counts: they retain their own history entries and archives.

## Executed verification

`record_validation_review.json` contains the exact current per-file results and inspected script hashes. The new integrity validator passed **7 groups / 95 files**, including the 7 manifests. Five deliberate invalid-input checks were rejected: wrong content SHA, wrong size, path outside the group, duplicate artifact entry, and changed manifest pin. These checks only read existing artifacts and modify in-memory expected values; they did not alter a frozen source.

The validator proves archive integrity only. It does not compile candidates, run native bodies, execute client commands, or establish integration/runtime completion.
