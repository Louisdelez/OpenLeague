# Process clock probe: Shared-scope section retirement

This is a source-only correction of the single `native_process_clock_probe` function. No production source, core API, verifier, frozen lot, or executable was changed. No compiler, client, or test was run for this correction.

## Observed failure

The existing `logs/client-process-clock-clock.json` reports seven successful frame updates, four paused frames, QPF=1, QPC=33, stable origin/frequency, successful Application close, balanced CRT allocations/frees, and closed-handle rejection. Its only cleanup error is the old probe's demand for zero transport critical sections before dropping retained handles. The failed log does not contain the actual intermediate section count because the old code returned before serializing it. The expected count below is proven by source, not extracted from that null report.

## Exact ownership contract

- `audio_replay_transport_startup.rs:6`: `MUTEX = 0x2D6ED50`.
- `audio_replay_windows_transport.rs:220`: native-logger attachment initializes exactly one permanent section, at `MUTEX+8 = 0x2D6ED58`. The additional logger section is only initialized by the external-logger branch. Dynamic service sections have separate lifetimes.
- `Runtime::shutdown` retires service, metadata, and other dynamic owners but does not delete this permanent section. `Shared` owns the section bank, and ServiceHandle, ClockHandle, and EffectClock retain Shared even after logical shutdown.
- `audio_crt_windows_critical_sections.rs`: each Bank holds one `Arc<Report>` and each Section holds one clone of that same report. The probe's retained report holds no Shared, Bank, or Section reference. At the intermediate snapshot, one Bank, one Section, and the probe therefore imply exactly three strong report owners.
- After Application close and closed-handle checks, the probe drops App and then the explicit ClockHandle. The remaining report must have strong count one and no failures. A surviving Bank or Section would keep this count greater than one. `Section::drop` records `OwnedAtDrop` if deletion is unsafe; otherwise it calls `DeleteCriticalSection`.

The final count is evidence that the Rust Bank and Section owners retired, tied to the audited Drop implementation. It is not an independent OS deletion count, nor a return-code check: `DeleteCriticalSection` returns void. The JSON explicitly reports `direct_os_deletion_count_observed: false`.

## JSON schema changes

`retired_runtime` now requires:

```json
{
  "engine_allocations": 0,
  "active_workers": 0,
  "handles": 0,
  "critical_sections": 1,
  "scope_critical_section_reference": 47639896,
  "critical_section_report_owners": 3,
  "errors": []
}
```

The reference above is `0x2D6ED58`. A new report after all Shared handles have been dropped requires:

```json
{
  "app_dropped": true,
  "clock_handle_dropped": true,
  "critical_section_report_owners": 1,
  "critical_section_failures": [],
  "bank_and_sections_retired": true,
  "direct_os_deletion_count_observed": false
}
```

This is `shared_drop` at the top level. The root must update the strict verifier to require both dictionaries. No prior clock exercise, paused-frame assertion, cleanup condition, or scope limitation was relaxed. No clock operation follows the final drops.

The frozen uncompiled shutdown-plugin candidate has the same obsolete early-zero expectation. It is not part of this change and must be corrected separately before compilation/integration.
