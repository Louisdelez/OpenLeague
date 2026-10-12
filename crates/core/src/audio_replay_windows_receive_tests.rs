use super::*;
use crate::audio_replay_windows_application::Application;
struct Defaults;
impl crate::audio_game_service_lifecycle::Settings for Defaults {
    fn float_bits(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
    fn bool_value(&mut self, _: &str, _: &str, v: u8) -> Result<u8, &'static str> {
        Ok(v)
    }
    fn integer(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
}
#[test]
fn audio_replay_windows_receive_parent_route_filters_compact_and_extended_headers_without_context_mutation(
) {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let owner = service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b = Backend::new(r.shared.clone());
    let before = b.word(owner + 0x5c).unwrap();
    for subtype in [2, 3, 4, 0x102, 0x103, 0x104] {
        for packet in [
            vec![0xdd],
            vec![0x51],
            vec![0xfe, 0, 0, 0, 0, 0xdd, 0],
            vec![0xfe, 0, 0, 0, 0, 0x51, 0],
        ] {
            assert_eq!(
                r.receive_game_event(0, 3, subtype, 0x12345678, &packet)
                    .unwrap(),
                1
            );
        }
    }
    for packet in [
        vec![],
        vec![0xfe],
        vec![0xfe, 0, 0, 0, 0, 0xdd],
        vec![0x95],
        vec![0x88, 0, 0, 0],
    ] {
        assert!(r.receive_game_event(0, 3, 2, 77, &packet).is_err());
    }
    assert_eq!(b.word(owner + 0x5c).unwrap(), before);
    assert!(r.errors().is_empty());
    let probe = r.probe_service_packet_ingress().unwrap();
    assert_eq!(probe["packet95_empty_receiver_packets"], 4);
    assert_eq!(probe["gameplay_actions"], 0);
    assert!(r.errors().is_empty());
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
#[test]
fn audio_replay_windows_receive_activates_real_owner_listeners_sets_clears_bits_and_unregisters() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let owner = service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b = Backend::new(r.shared.clone());
    // This diagnostic explicitly supplies mode/global bindings; normal game-mode
    // producers are separate source ports and are not claimed by this test.
    let old_global = b.word(callbacks::SERVICE_GLOBAL).unwrap();
    let old_local = b.word(receive::LOCAL_OWNER).unwrap();
    let old_enabled = consumers::ConsumerBoundary::byte(&mut b, owner + 0x184).unwrap();
    let id = b.allocate(4).unwrap();
    Storage::write_word(&mut b, id, 0x11223344).unwrap();
    Storage::write_word(&mut b, receive::LOCAL_OWNER, 0).unwrap();
    Storage::write_word(&mut b, callbacks::SERVICE_GLOBAL, owner).unwrap();
    b.write_byte(owner + 0x184, 1).unwrap();
    let metadata = b.allocate(56).unwrap();
    callbacks::construct(&mut b, metadata, 0, id).unwrap();
    assert_eq!(
        b.word(owner + 0x10).unwrap() - b.word(owner + 0xc).unwrap(),
        16
    );
    for (event, index, expected) in [(0xe0, 0, 1), (0xe0, 3, 9), (0xe1, 0, 8), (0xe1, 3, 0)] {
        let packet = [event, 0x44, 0x33, 0x22, 0x11, index];
        assert_eq!(
            r.receive_game_event(0, 3, 2, 0x55667788, &packet).unwrap(),
            1
        );
        assert_eq!(b.word(metadata + 40).unwrap(), expected);
        assert_eq!(b.word(owner + 0x5c).unwrap(), 0x55667788);
    }
    assert_eq!(b.word(owner + 0x10).unwrap(), b.word(owner + 0xc).unwrap());
    assert_eq!(b.word(owner + 0x1c).unwrap(), 4);
    let live = r.snapshot().unwrap().engine_allocations;
    assert!(r
        .receive_game_event(0, 3, 2, 7, &[0xe0, 0x44, 0x33, 0x22, 0x11])
        .unwrap_err()
        .contains("truncated"));
    assert_eq!(r.snapshot().unwrap().engine_allocations, live);
    assert_eq!(b.word(owner + 0x5c).unwrap(), 0x55667788);
    assert!(r.errors().is_empty());
    // Missing native diagnostic fails visibly and still frees the dispatch copy.
    assert!(r
        .receive_game_event(0, 3, 2, 29, &[0xe0, 0x44, 0x33, 0x22, 0x11, 4])
        .is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations, live);
    assert_eq!(b.word(metadata + 40).unwrap(), 0);
    assert!(r
        .errors()
        .iter()
        .any(|e| e.contains("native metadata diagnostic is not connected")));
    assert!(r
        .receive_game_event(0, 3, 2, 30, &[0xfe, 0x44, 0x33, 0x22, 0x11, 0xe0, 0])
        .is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations, live);
    assert_eq!(b.word(metadata + 40).unwrap(), 0);
    callbacks::scalar_delete(&mut b, metadata, 1).unwrap();
    assert_eq!(b.word(owner + 0x1c).unwrap(), 0);
    assert_eq!(b.word(owner + 0x40).unwrap(), 0);
    remove::Backend::free(&mut b, id, remove::Deallocator::Standard).unwrap();
    Storage::write_word(&mut b, callbacks::SERVICE_GLOBAL, old_global).unwrap();
    Storage::write_word(&mut b, receive::LOCAL_OWNER, old_local).unwrap();
    b.write_byte(owner + 0x184, old_enabled).unwrap();
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
#[test]
fn audio_replay_windows_receive_keeps_unimplemented_packet_handlers_explicit() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let owner = service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b = Backend::new(r.shared.clone());
    let local = b.word(receive::LOCAL_OWNER).unwrap();
    let mut packet = vec![0x88];
    packet.extend(local.to_le_bytes());
    let before = r.snapshot().unwrap().engine_allocations;
    assert!(r.receive_game_event(0, 3, 2, 19, &packet).is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations, before);
    assert_eq!(b.word(owner + 0x5c).unwrap(), 19);
    assert!(r.errors().iter().any(|e| e.contains("UnknownCallback")));
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
