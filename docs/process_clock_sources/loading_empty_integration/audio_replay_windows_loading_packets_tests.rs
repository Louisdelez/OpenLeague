use super::*;
use crate::audio_replay_windows_application::Application;
use crate::{
    audio_loading_record_tree as tree, audio_replay_metadata as metadata,
    audio_replay_metadata_text as text, audio_replay_object_commands as commands,
    audio_replay_object_manager as objects, audio_replay_manager_control as index_control,
};

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
fn write<N: startup::Network + Send + 'static>(b: &mut Backend<N>, p: u32, v: u32) {
    Storage::write_word(b, p, v).unwrap();
}
fn read_bytes<N: startup::Network + Send + 'static>(b: &mut Backend<N>, p: u32, n: u32) -> Vec<u8> {
    (0..n)
        .map(|i| metadata::Boundary::read_byte(b, p + i).unwrap())
        .collect()
}

fn hex_bytes(s: &str) -> Vec<u8> {
    s.as_bytes().chunks_exact(2)
        .map(|p| u8::from_str_radix(std::str::from_utf8(p).unwrap(), 16).unwrap()).collect()
}

// Explicit diagnostic preparation, matching the native empty-name oracle:
// construct8F8810 and publish with9019A0. This qualifies the real index/provider
// lifetime, not a normal stream-opening producer or a loading-screen factory.
fn initialize_index<N: startup::Network + Send + 'static>(b: &mut Backend<N>, parent: u32) -> [u32; 2] {
    let nested = b.word(parent + 0x30).unwrap();
    assert_eq!([b.word(nested + 0x6c).unwrap(), b.word(nested + 0x70).unwrap()], [0, 0]);
    let index = b.allocate(48).unwrap();
    objects::construct(b, index).unwrap();
    index_control::replace_pair(b, nested + 0x6c, index).unwrap();
    [index, b.word(nested + 0x70).unwrap()]
}

fn prepare_name<N: startup::Network + Send + 'static>(
    b: &mut Backend<N>, metadata: u32, id: Option<u32>, key: u32, index: u32, name: Option<&[u8]>,
) {
    b.event_temporary(256, |b, s| {
        if let Some(id) = id {
            for (o, v) in [(0, 0), (4, id), (8, key), (12, index)] {
                b.event_reference(s + o, v)?;
            }
            commands::dispatch(b, [0, 0, 0, 0, s], s + 32)
                .map_err(|e| b.failure(e, "empty-name test index producer failed"))?;
        }
        if let Some(name) = name {
            assert!(name.len() < 64);
            let raw = s + 96;
            for (i, v) in name.iter().copied().chain(std::iter::once(0)).enumerate() {
                Storage::write_byte(b, raw + i as u32, v).unwrap();
            }
            b.event_reference(s + 64, raw)?;
            b.event_reference(s + 80, name.len() as u32)?;
            b.event_reference(s + 84, 63)?;
            text::put_string_extra(b, metadata, key, index, s + 64, 0, s + 192)
                .map_err(|e| b.failure(e, "empty-name test metadata producer failed"))?;
        }
        Ok(())
    }).unwrap();
}

fn query_name<N: startup::Network + Send + 'static>(b: &mut Backend<N>, id: u32, expected: &[u8]) {
    b.event_temporary(32, |b, s| {
        names::service_name(b, s, id, s + 24)
            .map_err(|e| b.failure(e, "empty-name test real name getter failed"))?;
        let len = b.word(s + 16).unwrap();
        let cap = b.word(s + 20).unwrap();
        let raw = if cap < 16 { s } else { b.word(s).unwrap() };
        assert_eq!(read_bytes(b, raw, len), expected);
        if cap >= 16 {
            let route = remove::Backend::deallocator(b).unwrap();
            remove::Backend::free(b, raw, route).unwrap();
        }
        Ok(())
    }).unwrap();
}

// These are explicit diagnostic storage bindings, NOT recipient constructors
// or loading-screen factory qualification. Only each tree uses its real ctor.
// Global control remains null, so this borrowed binding claims no shared owner.
struct Recipient {
    kind: Kind,
    p: u32,
    table: u32,
    wrapper: u32,
    key: u32,
    old: [u32; 2],
}
impl Recipient {
    fn tree(&self) -> u32 {
        self.p
            + match self.kind {
                Kind::Standard => 0x1c,
                Kind::Tutorial => 4,
            }
    }
    fn create<N: startup::Network + Send + 'static>(b: &mut Backend<N>, kind: Kind) -> Self {
        let old = [
            b.word(packet95::GLOBAL_PAIR).unwrap(),
            b.word(packet95::GLOBAL_PAIR + 4).unwrap(),
        ];
        assert_eq!(
            old,
            [0, 0],
            "diagnostic binding requires an unowned global pair"
        );
        let p = b
            .allocate(match kind {
                Kind::Standard => 0x608,
                Kind::Tutorial => 0x1f8,
            })
            .unwrap();
        let table = b.allocate(4).unwrap();
        let wrapper = b.allocate(4).unwrap();
        let key = b.allocate(4).unwrap();
        write(
            b,
            table,
            match kind {
                Kind::Standard => 0x57d650,
                Kind::Tutorial => 0x5b3230,
            },
        );
        write(b, p, table);
        write(b, wrapper, p);
        let value = Self {
            kind,
            p,
            table,
            wrapper,
            key,
            old,
        };
        tree::construct(b, kind, value.tree()).unwrap();
        write(b, packet95::GLOBAL_PAIR + 4, 0);
        write(b, packet95::GLOBAL_PAIR, wrapper);
        value
    }
    fn record<N: startup::Network + Send + 'static>(&self, b: &mut Backend<N>, key: u32) -> u32 {
        write(b, self.key, key);
        tree::record_slot(b, self.kind, self.tree(), self.key).unwrap()
    }
    fn seed_name<N: startup::Network + Send + 'static>(&self, b: &mut Backend<N>, record: u32) {
        let s = record
            + match self.kind {
                Kind::Standard => 0x30,
                Kind::Tutorial => 0x28,
            };
        b.write_byte(s, b'n').unwrap();
        b.write_byte(s + 1, 0).unwrap();
        write(b, s + 16, 1);
        write(b, s + 20, 15);
    }
    fn destroy<N: startup::Network + Send + 'static>(self, b: &mut Backend<N>) {
        write(b, packet95::GLOBAL_PAIR, self.old[0]);
        write(b, packet95::GLOBAL_PAIR + 4, self.old[1]);
        tree::destroy(b, self.kind, self.tree()).unwrap();
        for p in [self.key, self.wrapper, self.table, self.p] {
            remove::Backend::free(b, p, remove::Deallocator::Standard).unwrap();
        }
    }
}
fn packet(owner: u32, key: u32, flags: u8, extended: bool) -> Vec<u8> {
    let mut p = vec![0u8; 30];
    p[0] = if extended { 0xfe } else { 0x95 };
    p[1..5].copy_from_slice(&owner.to_le_bytes());
    for (i, v) in [
        key, 0x55667788, 0x99aabbcc, 0x80000001, 0x7f800123, 0x13579bdf,
    ]
    .into_iter()
    .enumerate()
    {
        p[5 + i * 4..9 + i * 4].copy_from_slice(&v.to_le_bytes());
    }
    p[29] = flags;
    if extended {
        p[5] = 0x95;
        p[6] = 0;
    }
    p
}
#[test]
fn audio_replay_windows_loading_uses_real_trees_and_consumer_for48_hot_packets() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let service_pointer = service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b = Backend::new(r.shared.clone());
    let local = b
        .word(crate::audio_replay_service_receive::LOCAL_OWNER)
        .unwrap();
    let mut context = 0;
    for kind in [Kind::Standard, Kind::Tutorial] {
        let recipient = Recipient::create(&mut b, kind);
        for key in [0, 0x80000000, 0xffffffff] {
            for extended in [false, true] {
                for flag in [0, 1, 128, 255] {
                    let packet = packet(local, key, flag, extended);
                    let actual_key = u32::from_le_bytes(packet[5..9].try_into().unwrap());
                    let record = recipient.record(&mut b, actual_key);
                    recipient.seed_name(&mut b, record);
                    let size = match kind {
                        Kind::Standard => 120,
                        Kind::Tutorial => 76,
                    };
                    let mut expected = read_bytes(&mut b, record, size);
                    expected[..25].copy_from_slice(&packet[5..30]);
                    if flag & 1 != 0 {
                        expected[16..20].fill(0);
                    }
                    let allocations = r.snapshot().unwrap().engine_allocations;
                    context += 1;
                    assert_eq!(r.receive_game_event(0, 3, 2, context, &packet).unwrap(), 1);
                    assert_eq!(read_bytes(&mut b, record, size), expected);
                    assert_eq!(b.word(service_pointer + 0x5c).unwrap(), context);
                    assert_eq!(r.snapshot().unwrap().engine_allocations, allocations);
                }
            }
        }
        recipient.destroy(&mut b);
    }
    assert_eq!(context, 48);
    assert!(r.errors().is_empty());
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_rejects_truncation_before_any_runtime_mutation() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let owner = service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b = Backend::new(r.shared.clone());
    let local = b
        .word(crate::audio_replay_service_receive::LOCAL_OWNER)
        .unwrap();
    // A null global object has no payload reads, so the five-byte compact packet
    // remains a valid no-op under source577E90. Extended form needs seven bytes.
    for p in [
        packet(local, 0, 0, false)[..5].to_vec(),
        packet(local, 0, 0, true)[..7].to_vec(),
    ] {
        assert_eq!(r.receive_game_event(0, 3, 2, 9, &p).unwrap(), 1);
    }
    for kind in [Kind::Standard, Kind::Tutorial] {
        let recipient = Recipient::create(&mut b, kind);
        let before_context = b.word(owner + 0x5c).unwrap();
        let before = {
            let bank = r.shared.bank.lock().unwrap();
            (
                bank.memory.allocations.clone(),
                bank.memory.released_labels.clone(),
                bank.owned.clone(),
                bank.next_scratch,
                bank.event_scratch.clone(),
            )
        };
        let before_tree = read_bytes(&mut b, recipient.tree(), 8);
        for extended in [false, true] {
            let complete = packet(local, 123, 0, extended);
            for length in (if extended { 7 } else { 5 })..30 {
                assert!(r
                    .receive_game_event(0, 3, 2, 0xdeadbeef, &complete[..length])
                    .unwrap_err()
                    .contains("truncated loading-screen"));
            }
        }
        let after = {
            let bank = r.shared.bank.lock().unwrap();
            (
                bank.memory.allocations.clone(),
                bank.memory.released_labels.clone(),
                bank.owned.clone(),
                bank.next_scratch,
                bank.event_scratch.clone(),
            )
        };
        assert_eq!(before, after);
        assert_eq!(b.word(owner + 0x5c).unwrap(), before_context);
        assert_eq!(read_bytes(&mut b, recipient.tree(), 8), before_tree);
        assert_eq!(
            [
                b.word(packet95::GLOBAL_PAIR).unwrap(),
                b.word(packet95::GLOBAL_PAIR + 4).unwrap()
            ],
            [recipient.wrapper, 0]
        );
        recipient.destroy(&mut b);
    }
    assert!(r.errors().is_empty());
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_keeps_missing_standard_ui_and_unknown_targets_explicit() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let parent = r.game_manager_snapshot().unwrap().unwrap();
    let mut b = Backend::new(r.shared.clone());
    initialize_index(&mut b, parent.pointer);
    let name = b"Nonempty real metadata name longer than fifteen";
    prepare_name(&mut b, parent.metadata[0], Some(42), 123, 456, Some(name));
    // Warm the metadata cache before measuring temporary output retirement.
    query_name(&mut b, 42, name);
    let local = b
        .word(crate::audio_replay_service_receive::LOCAL_OWNER)
        .unwrap();
    let recipient = Recipient::create(&mut b, Kind::Standard);
    let p = packet(local, 42, 1, false);
    let before = r.snapshot().unwrap().engine_allocations;
    let frees = r.shared.bank.lock().unwrap().memory.released_labels.len();
    assert!(r.receive_game_event(0, 3, 2, 77, &p).is_err());
    assert_eq!(b.word(recipient.tree() + 4).unwrap(), 1);
    let record = recipient.record(&mut b, 42);
    let mut expected = p[5..30].to_vec();
    expected[16..20].fill(0);
    assert_eq!(read_bytes(&mut b, record, 25), expected);
    assert_eq!(r.snapshot().unwrap().engine_allocations, before + 1);
    assert!(r
        .errors()
        .iter()
        .any(|e| e.contains("UI continuation57D6FE")));
    assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(), frees + 1);
    let live = r.snapshot().unwrap().engine_allocations;
    assert!(r.receive_game_event(0, 3, 2, 78, &p).is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations, live);
    assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(), frees + 2);
    assert!(packet95::Boundary::receive_payload(&mut b, recipient.p, 0xdeadbeef, 0).is_err());
    assert!(loading::Boundary::service_name(&mut b, 0, 0xdeadbeef, 0, 42).is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations, live);
    recipient.destroy(&mut b);
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_standard_matches64_empty_names_through_real_metadata() {
    let oracle: serde_json::Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/loading_standard_empty_name_probe.json")).unwrap();
    assert_eq!(oracle["passed"], true);
    let cases = oracle["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 16);
    let mut calls = 0;
    for case in cases {
        let mut app = Application::new().unwrap();
        let r = app.transport().unwrap();
        let service = r.configure_service(Defaults).unwrap();
        r.initialize_game_manager().unwrap();
        let parent = r.game_manager_snapshot().unwrap().unwrap();
        let mut b = Backend::new(r.shared.clone());
        let index = initialize_index(&mut b, parent.pointer);
        let cached_long = case["cached_long"].as_bool().unwrap();
        if cached_long {
            let old = b"Old cached metadata name kept on its real heap buffer";
            // The native oracle seeds the cache using564C20. Here the actual
            // object/metadata producers and service getter populate it instead.
            prepare_name(&mut b, parent.metadata[0], Some(74), 123, 456, Some(old));
            query_name(&mut b, 74, old);
        }
        let cached = parent.metadata[0] + 0x1b0;
        let cache_capacity = b.word(cached + 20).unwrap();
        let cache_buffer = b.word(cached).unwrap();
        assert_eq!(cache_capacity >= 16, cached_long);
        let id = case["identifier"].as_u64().unwrap() as u32;
        match case["profile"].as_str().unwrap() {
            "present_empty" => prepare_name(&mut b, parent.metadata[0], Some(id), 0xdeadbeef, 0x80000000, Some(b"")),
            "present_missing_metadata" => prepare_name(&mut b, parent.metadata[0], Some(id), 1, 2, None),
            "missing_all" => {},
            "missing_zero_empty" => prepare_name(&mut b, parent.metadata[0], None, 0, 0, Some(b"")),
            _ => panic!("unknown native empty-name profile"),
        }
        let recipient = Recipient::create(&mut b, Kind::Standard);
        let record = recipient.record(&mut b, id);
        let local = b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();
        for (step_index, step) in case["steps"].as_array().unwrap().iter().enumerate() {
            // Match the recorded initial120 bytes, including native00/A5
            // padding. The tree and all name/index objects remain real ports.
            let initial = hex_bytes(step["record_before_hex"].as_str().unwrap());
            assert_eq!(initial.len(), 120);
            for (i, v) in initial.into_iter().enumerate() {
                Storage::write_byte(&mut b, record + i as u32, v).unwrap();
            }
            let mut packet = vec![0x95];
            packet.extend_from_slice(&local.to_le_bytes());
            packet.extend_from_slice(&hex_bytes(step["payload_hex"].as_str().unwrap()));
            assert_eq!(packet.len(), 30);
            let before = r.snapshot().unwrap().engine_allocations;
            let frees = r.shared.bank.lock().unwrap().memory.released_labels.len();
            assert_eq!([b.word(parent.metadata[1] + 4).unwrap(), b.word(index[1] + 4).unwrap()], [1, 1]);
            assert_eq!(r.receive_game_event(0, 3, 2, step_index as u32 + 1, &packet).unwrap(), 1);
            assert_eq!(read_bytes(&mut b, record, 120), hex_bytes(step["record_after_hex"].as_str().unwrap()));
            assert_eq!([b.word(parent.metadata[1] + 4).unwrap(), b.word(index[1] + 4).unwrap()], [1, 1]);
            assert_eq!(r.snapshot().unwrap().engine_allocations, before);
            assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(), frees);
            assert_eq!(b.word(cached + 16).unwrap(), 0);
            assert_eq!(b.word(cached + 20).unwrap(), cache_capacity);
            if cached_long { assert_eq!(b.word(cached).unwrap(), cache_buffer); }
            assert!(r.errors().is_empty());
            calls += 1;
        }
        recipient.destroy(&mut b);
        r.close_game_manager().unwrap();
        service.close().unwrap();
        assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
        app.close().unwrap();
    }
    assert_eq!(calls, 64);
}
