use super::*;
use crate::audio_replay_windows_application::Application;

#[test]
fn audio_replay_windows_resource_manager_constructs_real_initializers_fourteen_allocations_and_retires_empty_lifetime() {
    for _ in 0..2 {
        let mut app=Application::new().unwrap();
        let r=app.transport().unwrap();
        let mut b=Backend::new(r.shared.clone());
        assert_eq!(r.loading_resource_snapshot().unwrap()["attempted"],false);
        let before=r.snapshot().unwrap().engine_allocations;
        let pointer=r.initialize_loading_resources().unwrap();
        assert_ne!(pointer,0);
        assert_eq!(b.word(0x2d78f1c).unwrap(),pointer);
        assert_eq!(b.word(pointer).unwrap(),0x10d6450);
        for (p,v) in [(0x2d6edf0,0x3cbb5e22),(0x2d6edf4,0x1737aba5),
                      (0x2d6edf8,0xd553ffbd),(0x2d6edfc,0x0f16597f)] {
            assert_eq!(b.word(p).unwrap(),v);
        }
        for offset in [0x28,0x3c,0x50,0x6c,0x84,0x98] {
            assert_eq!(b.word(pointer+offset).unwrap(),pointer);
        }
        assert_eq!(crate::audio_replay_metadata::Boundary::read_byte(&mut b,pointer+0xa8).unwrap(),1);
        assert_eq!([b.word(pointer+8).unwrap(),b.word(pointer+16).unwrap(),
                    b.word(pointer+24).unwrap(),b.word(pointer+32).unwrap()],[0,0,0,4]);
        assert_eq!(r.snapshot().unwrap().engine_allocations,before+14);
        assert_eq!(r.initialize_loading_resources().unwrap(),pointer);
        assert_eq!(r.snapshot().unwrap().engine_allocations,before+14);
        assert_eq!(r.loading_resource_snapshot().unwrap()["record"]["ready"],true);
        assert_eq!(r.loading_resource_snapshot().unwrap()["real_providers_connected"],false);
        r.shutdown().unwrap();
        assert_eq!(b.word(0x2d78f1c).unwrap(),0);
        assert_eq!(r.snapshot().unwrap().engine_allocations,0);
        assert!(r.loading_resource_snapshot().unwrap()["record"].is_null());
        assert!(r.errors().is_empty());
        assert!(r.initialize_loading_resources().unwrap_err().contains("shut down"));
        drop(b);app.close().unwrap();
        assert_eq!(app.diagnostic().unwrap()["closed"],true);
    }
}

#[test]
fn audio_replay_windows_resource_manager_rejects_external_global_before_initialization_or_allocation() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let mut b=Backend::new(r.shared.clone());
    Storage::write_word(&mut b,0x2d78f1c,0x30004000).unwrap();
    let before=r.snapshot().unwrap().engine_allocations;
    assert!(r.initialize_loading_resources().unwrap_err().contains("another owner"));
    assert_eq!(b.word(0x2d78f1c).unwrap(),0x30004000);
    assert_eq!(b.word(0x2d6edf0).unwrap(),0);
    assert_eq!(r.snapshot().unwrap().engine_allocations,before);
    assert_eq!(r.loading_resource_snapshot().unwrap()["attempted"],false);
    Storage::write_word(&mut b,0x2d78f1c,0).unwrap();
    drop(b);app.close().unwrap();
}

#[test]
fn audio_replay_windows_resource_manager_retirement_checks_active_status_before_mutation() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let mut b=Backend::new(r.shared.clone());let pointer=r.initialize_loading_resources().unwrap();
    let before=r.loading_resource_snapshot().unwrap();
    // This is a host gate injection, not a claim that a worker ran here.
    r.shared.active.store(1,Ordering::Release);
    assert!(r.close_loading_resources_owned(&mut b).unwrap_err().contains("worker owns runtime state"));
    assert_eq!(r.loading_resource_snapshot().unwrap(),before);
    assert_eq!(b.word(0x2d78f1c).unwrap(),pointer);
    assert_eq!(r.snapshot().unwrap().engine_allocations,14);
    r.shared.active.store(0,Ordering::Release);
    drop(b);app.close().unwrap();
}

#[test]
fn audio_replay_windows_resource_manager_failed_final_free_retains_bank_and_global_until_retry_without_double_release() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let shared=r.shared.clone();let mut b=Backend::new(shared.clone());
    let baseline=Arc::strong_count(&shared);
    let pointer=r.initialize_loading_resources().unwrap();
    assert_eq!(Arc::strong_count(&shared),baseline+1);
    let initial_frees=shared.bank.lock().unwrap().memory.released_labels.len();
    // Withhold only the ownership token: the physical allocation remains live.
    assert!(shared.bank.lock().unwrap().owned.remove(&pointer));
    assert!(r.shutdown().unwrap_err().contains("resource manager retirement remains unresolved"));
    assert_eq!(Arc::strong_count(&shared),baseline+1);
    assert_eq!(b.word(0x2d78f1c).unwrap(),pointer);
    assert!(b.word(pointer).is_ok());
    let failed_frees=shared.bank.lock().unwrap().memory.released_labels.len();
    assert_eq!(failed_frees,initial_frees+13);
    assert!(r.loading_resource_snapshot().unwrap()["record"]["last_error"].as_str().unwrap().contains("unresolved"));
    assert!(r.shutdown().is_err());
    assert_eq!(shared.bank.lock().unwrap().memory.released_labels.len(),failed_frees);
    assert!(shared.bank.lock().unwrap().owned.insert(pointer));
    r.shutdown().unwrap();
    assert_eq!(Arc::strong_count(&shared),baseline);
    assert_eq!(b.word(0x2d78f1c).unwrap(),0);
    assert!(b.word(pointer).is_err());
    assert_eq!(shared.bank.lock().unwrap().memory.released_labels.iter().filter(|&&p|p==pointer).count(),1);
    assert_eq!(r.snapshot().unwrap().engine_allocations,0);
    drop(b);drop(shared);app.close().unwrap();
}
