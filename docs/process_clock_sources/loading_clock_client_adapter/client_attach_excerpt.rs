// Inside the existing attach_native_replay_runtime, after replay.0.attach(...)
// and before app.insert_non_send_resource(runtime):
let process_clock = runtime.transport()?.clock_handle()?;
app.insert_resource(native_effect_clock::EffectClock::with_process_clock(process_clock));
// Existing Application remains the only owner. Plugin::init_resource preserves
// this inserted EffectClock and never creates an Application.
