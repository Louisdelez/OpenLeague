# Additional tutorial clock integration test

Append `addition_tests.rs.txt` to the Windows loading-packet test module after
integrating the previous empty-name stage and the actual process-clock adapter.
This adds exactly one test:
`audio_replay_windows_loading_tutorial_first_names_use_real_clock_once_and_retire_with_owner`.

The test reuses the previously prepared Windows helpers for real parent/index,
metadata producers, record-tree construction and diagnostic recipient binding.
No name or clock result is mocked. Four complete packet95 dispatches, with
flags0/1/128/255, enter the tutorial's first nonempty-name branch. Checks cover
the complete76-byte record, both stored floating-point copies, a finite
nonnegative clock stamp, retained metadata cache, references and output frees.
No wall-clock duration or exact stamp is assumed.

It uses the actual API names from root's current clock stage:
`Runtime::clock_handle`, `Runtime::process_clock_snapshot` and
`ClockHandle::process_clock_snapshot`. The first sample initializes the clock;
four consumers require one QPF and five QPC calls. Read-only snapshots add none.
One cloned handle observes the state after the real `Application::close`:
zero clock CRT allocations/inner mutexes, retired callbacks/events, unchanged
call counters and rejection of further sampling. The application CRT diagnostic
must also show no heap blocks, retained mirrors, or critical sections.

No compiler or Rust test has been run for this candidate. The previous stage
remains unchanged. Its injected generic clock-failure cleanup test intentionally
remains valid; no Windows test there assumes that the real clock is unavailable.
The frozen Windows adapter still calls `loading_clock_f32_bits`; root's merge
must bind that path to the actual clock (currently `native_clock_f32_bits`).

As with the previous stage, these diagnostic recipient/index bindings do not
qualify normal loading-screen factories or stream startup. Actual UI resources
and nonempty standard-screen initialization remain separate work.
