use super::*;
use crate::audio_replay_shared_pair as pair;
use crate::audio_replay_windows_application::Application;
#[test]
fn audio_replay_windows_loading_constructs_real_empty_wrapper_publishes_and_retires_control() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let _launch = r.shared.launch.lock().unwrap();
    let mut b = Backend::new(r.shared.clone());
    let global = [
        b.word(loading::GLOBAL_PAIR).unwrap(),
        b.word(loading::GLOBAL_PAIR + 4).unwrap(),
    ];
    assert_eq!(global, [0, 0]);
    let previous_language = b.word(loading::LANGUAGE_GLOBAL).unwrap();
    let before = r.snapshot().unwrap();
    // Explicit diagnostic supplies a language string. No normal startup producer,
    // screen factory or recipient is claimed or installed by this test.
    b.event_temporary(64, |b, s| {
        for (o, v) in [(16, 5), (20, 15)] {
            Storage::write_word(b, s + o, v).map_err(|_| "language descriptor")?;
        }
        for (i, v) in b"ZH_cn\0".iter().enumerate() {
            b.write_byte(s + i as u32, *v)
                .map_err(|_| "language bytes")?;
        }
        Storage::write_word(b, loading::LANGUAGE_GLOBAL, s).map_err(|_| "language global")?;
        let p = b
            .allocate(loading::WRAPPER_BYTES)
            .map_err(|_| "wrapper allocation")?;
        loading::construct(b, p, s + 24).map_err(|_| "wrapper construction")?;
        assert_eq!(loading::Boundary::read_byte(b, p + 0x5c).unwrap(), 1);
        assert_eq!(b.word(p).unwrap(), 0);
        assert_eq!(b.word(p + 4).unwrap(), 0);
        loading::publish(b, loading::GLOBAL_PAIR, p, false, s + 48)
            .map_err(|_| "wrapper publication")?;
        let control = b.word(loading::GLOBAL_PAIR + 4).unwrap();
        assert_ne!(control, 0);
        assert_eq!(b.word(control).unwrap(), loading::WRAPPER_CONTROL);
        // Test retires its explicitly published pair and restores the earlier global.
        // Application shutdown ownership is a separate unimplemented startup contract.
        Storage::write_word(b, s + 48, p).map_err(|_| "pair scratch")?;
        Storage::write_word(b, s + 52, control).map_err(|_| "pair scratch")?;
        for (i, v) in global.into_iter().enumerate() {
            Storage::write_word(b, loading::GLOBAL_PAIR + i as u32 * 4, v)
                .map_err(|_| "global restore")?;
        }
        pair::destroy(b, s + 48).map_err(|_| "wrapper retirement")?;
        Storage::write_word(b, loading::LANGUAGE_GLOBAL, previous_language)
            .map_err(|_| "language restore")?;
        Ok(())
    })
    .unwrap();
    let after = r.snapshot().unwrap();
    assert_eq!(after.engine_allocations, before.engine_allocations);
    assert_eq!(after.critical_sections, before.critical_sections);
    assert!(r.errors().is_empty());
    drop(_launch);
    app.close().unwrap();
}
