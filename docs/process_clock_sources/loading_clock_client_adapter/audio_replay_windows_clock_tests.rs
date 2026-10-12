//! Planned integration tests. Require the actual once/Windows implementation;
//! do not run with successful synthetic lock boundaries.
use super::*;

#[test]
fn native_clock_handles_and_loading_backend_share_one_canonical_origin_and_reject_after_close() {
    let mut owner = crate::audio_replay_windows_application::Application::new().unwrap();
    let runtime = owner.transport().unwrap();
    let first = runtime.clock_handle().unwrap();
    let second = runtime.clock_handle().unwrap();
    assert!(Arc::ptr_eq(&first.shared, &second.shared));
    let a = first.raw_clock_sample().unwrap();
    let b = second.raw_clock_sample().unwrap();
    assert_eq!((a.origin, a.frequency), (b.origin, b.frequency));
    assert!(b.counter >= a.counter);
    {
        // Same path as loading's Boundary, already under launch. Calling the
        // public handle from here would deadlock; this test uses the backend.
        let closed = first.shared.launch.lock().unwrap(); assert!(!*closed);
        let mut backend = Backend::new(first.shared.clone());
        let loading_bits = backend.native_clock_f32_bits().unwrap();
        let c = backend.raw_clock_sample().unwrap();
        assert_eq!((a.origin, a.frequency), (c.origin, c.frequency));
        assert_eq!(Memory::word(&mut backend, clock::ONCE_READY).unwrap(), 1);
        let origin = u64::from(Memory::word(&mut backend, clock::ORIGIN).unwrap()) |
            (u64::from(Memory::word(&mut backend, clock::ORIGIN + 4).unwrap()) << 32);
        let frequency = u64::from(Memory::word(&mut backend, clock::FREQUENCY).unwrap()) |
            (u64::from(Memory::word(&mut backend, clock::FREQUENCY + 4).unwrap()) << 32);
        assert_eq!((origin, frequency), (a.origin, a.frequency));
        assert!(f32::from_bits(loading_bits).is_finite());
    }
    owner.close().unwrap();
    // Clones retain the allocation lifetime but no longer authorize reads or OS calls.
    assert_eq!(first.raw_clock_sample().unwrap_err(), "process clock runtime is shut down");
    assert_eq!(second.wall_clock_f32_bits().unwrap_err(), "process clock runtime is shut down");
}
