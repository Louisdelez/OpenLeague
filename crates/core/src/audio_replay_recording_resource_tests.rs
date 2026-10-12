use super::*;
use crate::audio_replay_recording_resource as file;
const SCRATCH: u32 = 0x3000f800;
fn host(fill: u8) -> Host {
    let mut b = Host::new(fill);
    b.memory.reserve_at(COMPOSITE_VTABLE, 12).unwrap();
    b.memory.reserve_at(SCRATCH, 16).unwrap();
    b.memory.reserve_at(file::CONTROL_VTABLE, 12).unwrap();
    for (o, v) in [
        (0, file::CONTROL_DISPOSE),
        (4, crate::audio_announcer_owner_control::RELEASE),
        (8, crate::audio_announcer_owner_control::SCALAR_DELETE),
    ] {
        Storage::write_word(&mut b, file::CONTROL_VTABLE + o, v).unwrap();
    }
    for (o, v) in [
        (0, COMPOSITE_DELETE),
        (4, COMPOSITE_CLONE),
        (8, COMPOSITE_INVOKE),
    ] {
        Storage::write_word(&mut b, COMPOSITE_VTABLE + o, v).unwrap();
    }
    b
}
impl crate::audio_announcer_owner_component_destructor::ControlBoundary for Host {
    fn decrement_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        let old = self.word(p).map_err(|_| "reference missing")?;
        Storage::write_word(self, p, old.wrapping_sub(1)).map_err(|_| "reference write failed")?;
        Ok(old)
    }
    fn dispose(&mut self, p: u32, method: u32) -> Result<(), &'static str> {
        if method != file::CONTROL_DISPOSE {
            return Err("unexpected control dispose");
        }
        file::dispose_control(self, p).map_err(|_| "resource disposal failed")
    }
    fn release_control(&mut self, p: u32, method: u32) -> Result<(), &'static str> {
        if method != crate::audio_announcer_owner_control::RELEASE {
            return Err("unexpected control release");
        }
        crate::audio_announcer_owner_control::release(self, p).map_err(|_| "control release failed")
    }
}
impl crate::audio_replay_shared_pair::Boundary for Host {
    fn increment_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        let old = self.word(p).map_err(|_| "reference missing")?;
        Storage::write_word(self, p, old.wrapping_add(1)).map_err(|_| "reference write failed")?;
        Ok(old)
    }
}
impl file::Preparation for Host {
    fn register_path(&mut self, p: u32) -> Result<(), &'static str> {
        self.file_events
            .push(json!({"op":"register_path","path":p}));
        Ok(())
    }
}
#[test]
fn audio_replay_recording_preparation_matches48_native_flags_path_file_failure_and_shared_resource_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_recording_preparation_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 48);
    for c in cases {
        let mut b = host(n(&c["fill"]) as u8);
        b.file_profile = n(&c["profile"]);
        let labels = queue(
            &mut b,
            &[
                &c["prepared"]["snapshot"],
                &c["destroyed"]["snapshot"],
                &c["shutdown"]["snapshot"],
            ],
        );
        let stream = n(&c["stream"]);
        let path = n(&c["path"]);
        b.memory.reserve_at(stream, 64).unwrap();
        for o in [0x30, 0x34, 0x38, 0x3c] {
            set(&mut b, stream + o, 0);
        }
        let name = b"E:/OpenLeague/logs/supplied-preparation.txt\0";
        b.memory.reserve_at(path, name.len() as u32).unwrap();
        for (i, v) in name.iter().enumerate() {
            b.write_byte(path + i as u32, *v).unwrap();
        }
        // The helper represents only the enabled native branch. Its caller's
        // low-byte gate is already implemented in opening::prepare.
        let ready = if n(&c["flag"]) as u8 != 0 {
            file::prepare(
                &mut b,
                stream,
                if c["has_path"] == true { path } else { 0 },
                SCRATCH,
            )
            .unwrap()
        } else {
            true
        };
        assert_eq!(u32::from(ready), n(&c["return_byte"]));
        compare(&mut b, &c["prepared"]["snapshot"], &labels);
        assert_eq!(json!(b.file_events), c["prepared"]["events"]);
        b.file_events.clear();
        let pairs: Vec<_> = [0x30, 0x34, 0x38, 0x3c]
            .iter()
            .map(|o| b.word(stream + o).unwrap())
            .collect();
        assert_eq!(json!(pairs), c["prepared"]["stream_pairs"]);
        let resource = n(&c["resource"]);
        if resource != 0 {
            assert_eq!(b.word(resource + 32).unwrap(), n(&c["prepared"]["file"]));
            assert_eq!(
                b.byte(resource + 36).unwrap() as u32,
                n(&c["prepared"]["enabled"])
            );
            file::close(&mut b, resource).unwrap();
        }
        crate::audio_replay_shared_pair::destroy(&mut b, stream + 0x30).unwrap();
        compare_file(&mut b, resource, &c["destroyed"], &labels);
        if b.word(POINTER).unwrap() != 0 {
            shutdown(&mut b).unwrap();
        }
        compare_file(&mut b, resource, &c["shutdown"], &labels);
        assert!(b.queue.unwrap().is_empty() && b.locks.is_empty());
    }
}
fn queue(b: &mut Host, stages: &[&Value]) -> BTreeSet<u32> {
    let q: VecDeque<Value> = stages
        .iter()
        .flat_map(|s| s["allocations"].as_array().unwrap().iter().cloned())
        .collect();
    let labels = q
        .iter()
        .flat_map(|a| (0..n(&a["bytes"])).step_by(4).map(|i| n(&a["pointer"]) + i))
        .collect();
    b.queue = Some(q);
    labels
}
fn compare(b: &mut Host, s: &Value, labels: &BTreeSet<u32>) {
    assert_eq!(json!(b.allocations), s["allocations"]);
    b.allocations.clear();
    assert_eq!(json!(b.memory.released_labels), s["freed"]);
    b.memory.released_labels.clear();
    for row in s["words"].as_array().unwrap() {
        let p = n(&row[0]);
        if labels.contains(&p) {
            assert_eq!(b.word(p).unwrap(), n(&row[1]), "word {p:08x}");
        }
    }
}
fn set(b: &mut Host, p: u32, v: u32) {
    Storage::write_word(b, p, v).unwrap();
}
#[test]
fn audio_replay_logger_composite_matches28_native_recursive_append_clone_both_callbacks_and_destruction_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_logger_composite_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 28);
    for c in cases {
        let mut b = host(n(&c["fill"]) as u8);
        let steps = c["steps"].as_array().unwrap();
        let mut stages = vec![&c["initial"]];
        stages.extend(steps.iter().map(|s| &s["snapshot"]));
        stages.extend([&c["cloned"], &c["clone_deleted"], &c["shutdown"]]);
        let labels = queue(&mut b, &stages);
        assert_eq!(initialize(&mut b).unwrap(), n(&c["logger"]));
        compare(&mut b, &c["initial"], &labels);
        for step in steps {
            let owner = n(&step["owner"]);
            b.memory.reserve_at(owner, 4).unwrap();
            set(&mut b, owner, n(&step["supplied_return"]));
            let incoming = b.allocate(12).unwrap();
            assert_eq!(incoming, n(&step["incoming"]));
            for (o, v) in [(0, callback::HANDLER_VTABLE), (4, owner), (8, 0x32008a00)] {
                set(&mut b, incoming + o, v);
            }
            set(&mut b, SCRATCH + 4, incoming);
            append_callback(&mut b, LOGGER, SCRATCH + 4, SCRATCH).unwrap();
            compare(&mut b, &step["snapshot"], &labels);
        }
        let root = b.word(LOGGER + 32).unwrap();
        let cloned = clone_callback(&mut b, root).unwrap();
        assert_eq!(cloned, n(&c["cloned_pointer"]));
        compare(&mut b, &c["cloned"], &labels);
        assert_eq!(
            invoke_callback(&mut b, cloned, n(&c["message"])).unwrap() as u32,
            n(&c["return_byte"])
        );
        let calls:Vec<_>=b.calls.iter().map(|&(owner,member,message)|json!({"owner":owner,"member":member,"message":message})).collect();
        assert_eq!(json!(calls), c["invocations"]);
        delete(&mut b, cloned).unwrap();
        compare(&mut b, &c["clone_deleted"], &labels);
        shutdown(&mut b).unwrap();
        compare(&mut b, &c["shutdown"], &labels);
        assert!(b.queue.unwrap().is_empty() && b.locks.is_empty());
    }
}
fn text(b: &Host, p: u32) -> Vec<u8> {
    (0..)
        .map(|i| b.memory.read_byte(p + i).unwrap())
        .take_while(|v| *v != 0)
        .collect()
}
fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|v| format!("{v:02x}")).collect()
}
impl file::Boundary for Host {
    fn lock(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        assert!(self.locks.contains(&(p + 8)));
        if enter {
            assert!(self.held.insert(p));
        } else {
            assert!(self.held.remove(&p));
        }
        self.file_events
            .push(json!({"op":if enter{"enter"}else{"leave"},"object":p}));
        Ok(())
    }
    fn file_open(&mut self, p: u32, mode: &[u8]) -> Result<u32, &'static str> {
        let v = if mode == b"wc" {
            if self.file_profile >= 1 {
                0x76000001
            } else {
                0
            }
        } else {
            assert_eq!(mode, b"ac");
            if self.file_profile == 2 {
                0x76000002
            } else {
                0
            }
        };
        self.file_events.push(json!({"op":"open","path_hex":hex(&text(self,p)),"mode":std::str::from_utf8(mode).unwrap(),"result":v}));
        Ok(v)
    }
    fn file_close(&mut self, p: u32) -> Result<i32, &'static str> {
        self.file_events
            .push(json!({"op":"close","file":p,"result":self.close_result}));
        Ok(self.close_result)
    }
    fn file_message(&mut self, p: u32, message: u32) -> Result<i32, &'static str> {
        self.file_events.push(json!({"op":"write","file":p,"message_hex":hex(&text(self,message)),"result":self.write_result}));
        Ok(self.write_result)
    }
}
fn compare_file(b: &mut Host, p: u32, s: &Value, labels: &BTreeSet<u32>) {
    compare(b, &s["snapshot"], labels);
    assert_eq!(json!(b.file_events), s["events"]);
    b.file_events.clear();
    assert!(b.held.is_empty());
    if let Some(expected) = s.get("file") {
        assert_eq!(b.word(p + 32).unwrap(), n(expected));
        assert_eq!(b.byte(p + 36).unwrap() as u32, n(&s["enabled"]));
    }
}
#[test]
fn audio_replay_recording_resource_matches24_native_file_open_failure_write_result_repeated_open_close_and_callback_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_recording_file_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 24);
    for c in cases {
        let mut b = host(n(&c["fill"]) as u8);
        b.file_profile = n(&c["profile"]);
        b.write_result = c["write_result"].as_i64().unwrap() as i32;
        b.close_result = c["close_result"].as_i64().unwrap() as i32;
        let steps = c["steps"].as_array().unwrap();
        let mut stages = vec![&c["initial"]["snapshot"]];
        stages.extend(steps.iter().map(|s| &s["state"]["snapshot"]));
        stages.extend([&c["destroyed"]["snapshot"], &c["shutdown"]["snapshot"]]);
        let labels = queue(&mut b, &stages);
        let p = b.allocate(40).unwrap();
        assert_eq!(p, n(&c["resource"]));
        file::construct(&mut b, p, SCRATCH).unwrap();
        compare_file(&mut b, p, &c["initial"], &labels);
        let path = n(&c["path_pointer"]);
        let message = n(&c["message_pointer"]);
        for (p, data) in [
            (path, b"E:/OpenLeague/logs/supplied-file.txt\0".as_slice()),
            (message, b"raw\n%token\xe9\0ignored\0"),
        ] {
            b.memory.reserve_at(p, data.len() as u32).unwrap();
            for (i, v) in data.iter().enumerate() {
                b.write_byte(p + i as u32, *v).unwrap();
            }
        }
        for s in steps {
            let v = match s["action"].as_str().unwrap() {
                "write_disabled" | "write" => file::message(&mut b, p, message),
                "write_null" => file::message(&mut b, p, 0),
                "open" | "open_again" => file::open(&mut b, p, path),
                "close" | "close_again" => file::close(&mut b, p),
                _ => panic!("unknown action"),
            }
            .unwrap();
            assert_eq!(v as u32, n(&s["return_byte"]));
            compare_file(&mut b, p, &s["state"], &labels);
        }
        file::destroy(&mut b, p).unwrap();
        compare_file(&mut b, p, &c["destroyed"], &labels);
        shutdown(&mut b).unwrap();
        compare_file(&mut b, p, &c["shutdown"], &labels);
        assert!(b.queue.unwrap().is_empty() && b.locks.is_empty());
    }
}
