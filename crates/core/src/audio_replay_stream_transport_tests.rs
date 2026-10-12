use crate::{
    audio_announcer_owner_component_destructor::ControlBoundary,
    audio_announcer_owner_control as control, audio_replay_key as key,
    audio_replay_shared_pair as pair, audio_replay_stream_transport as derived,
};
impl Host {
    fn prepare_stream(&mut self) {
        let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
            "data/4.20/replay_key_probe.json",
        ))
        .unwrap();
        let seed = bytes(proof["initial_tables_hex"].as_str().unwrap());
        self.memory
            .reserve_at(key::TABLES, key::TABLE_BYTES as u32)
            .unwrap();
        for (i, v) in seed.iter().enumerate() {
            self.write_byte(key::TABLES + i as u32, *v).unwrap();
        }
        for (p, n) in [
            (derived::VTABLE, 8),
            (derived::INTERFACE_VTABLE, 48),
            (derived::CONTROL_VTABLE, 12),
        ] {
            self.memory.reserve_at(p, n).unwrap();
        }
        let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
            "data/4.20/replay_stream_derived_lifetime_probe.json",
        ))
        .unwrap();
        for (p, count) in [
            (derived::VTABLE, 2),
            (derived::INTERFACE_VTABLE, 12),
            (derived::CONTROL_VTABLE, 3),
        ] {
            for i in 0..count {
                Storage::write_word(
                    self,
                    p + i * 4,
                    n(&proof["tables"][format!("{p:#x}")][i as usize]),
                )
                .unwrap();
            }
        }
    }
}
impl ControlBoundary for Host {
    fn decrement_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        let value = self.word(p).map_err(|_| "missing reference")?;
        Storage::write_word(self, p, value.wrapping_sub(1)).map_err(|_| "reference write")?;
        Ok(value)
    }
    fn dispose(&mut self, p: u32, f: u32) -> Result<(), &'static str> {
        match f {
            derived::CONTROL_DISPOSE => {
                derived::dispose_control(self, p).map_err(|_| "derived disposal")
            }
            crate::audio_replay_manager_control::DISPOSE => {
                crate::audio_replay_manager_control::dispose(self, p)
                    .map_err(|_| "manager disposal")
            }
            control::DISPOSE => {
                let object = self.word(p + 12).map_err(|_| "control object")?;
                if object != 0 {
                    let vt = self.word(object).map_err(|_| "object vtable")?;
                    let method = self.word(vt).map_err(|_| "object delete")?;
                    if method == crate::audio_replay_metadata::SCALAR_DELETE {
                        return crate::audio_replay_metadata::scalar_delete(self, object, 1)
                            .map(|_| ())
                            .map_err(|_| "metadata deletion");
                    }
                    if method != crate::audio_replay_opening::NULL_DELETE {
                        return Err("unexpected scalar object");
                    }
                    crate::audio_replay_opening::scalar_delete_null(self, object, 1)
                        .map_err(|_| "null implementation deletion")?;
                }
                Ok(())
            }
            crate::audio_replay_transport_thread::DISPOSE => {
                if self.word(p + 12).map_err(|_| "thread control")? != 0 {
                    return Err("only supplied null stream worker supported");
                }
                Ok(())
            }
            crate::audio_replay_recording_resource::CONTROL_DISPOSE => {
                crate::audio_replay_recording_resource::dispose_control(self, p)
                    .map_err(|_| "resource disposal")
            }
            _ => Err("unknown opening control disposal"),
        }
    }
    fn release_control(&mut self, p: u32, f: u32) -> Result<(), &'static str> {
        assert_eq!(f, control::RELEASE);
        control::release(self, p).map_err(|_| "control release")
    }
}
impl pair::Boundary for Host {
    fn increment_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        let value = self.word(p).map_err(|_| "missing reference")?;
        Storage::write_word(self, p, value.wrapping_add(1)).map_err(|_| "reference write")?;
        Ok(value)
    }
}
impl derived::Boundary for Host {}
#[test]
fn audio_replay_stream_transport_matches6_native_full_object_scalar_and_aliased_shared_lifetimes() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_derived_lifetime_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 6);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.prepare_stream();
        b.all_allocations = true;
        b.queue = c["constructed"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .chain(
                c["steps"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .flat_map(|s| s["snapshot"]["allocations"].as_array().unwrap()),
            )
            .cloned()
            .collect();
        let p = b.allocate(derived::BYTES).unwrap();
        assert_eq!(p, n(&c["object"]));
        derived::construct(&mut b, p).unwrap();
        b.compare(&c["constructed"]);
        for pair in [0x3000f800, 0x3000f810] {
            b.memory.reserve_at(pair, 8).unwrap();
            Storage::write_word(&mut b, pair, 0).unwrap();
            Storage::write_word(&mut b, pair + 4, 0).unwrap();
        }
        for step in c["steps"].as_array().unwrap() {
            match step["action"].as_str().unwrap() {
                "scalar0" => {
                    derived::scalar_delete(&mut b, p, 0).unwrap();
                }
                "scalar1" => {
                    derived::scalar_delete(&mut b, p, 1).unwrap();
                }
                "wrap" => {
                    derived::wrap(&mut b, 0x3000f800, p).unwrap();
                    assert_eq!(
                        json!([b.word(0x3000f800).unwrap(), b.word(0x3000f804).unwrap()]),
                        step["pair"]
                    );
                }
                "copy" => {
                    pair::copy(&mut b, 0x3000f810, 0x3000f800).unwrap();
                    assert_eq!(
                        json!([b.word(0x3000f810).unwrap(), b.word(0x3000f814).unwrap()]),
                        step["pair"]
                    );
                }
                "release_first" => pair::destroy(&mut b, 0x3000f800).unwrap(),
                "release_second" => pair::destroy(&mut b, 0x3000f810).unwrap(),
                _ => panic!("unknown lifetime action"),
            }
            b.compare(&step["snapshot"]);
        }
        assert!(b.queue.is_empty() && b.locks.is_empty());
        if c["mode"] == "scalar0" {
            remove::Backend::free(&mut b, p, remove::Deallocator::Standard).unwrap();
        }
        assert!(b.word(p).is_err());
    }
}
#[test]
fn audio_replay_stream_transport_matches24_native_complete_key_callback_configuration_and_close_profiles(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_derived_configuration_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 24);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.prepare_stream();
        b.startup_error = n(&c["startup_error"]);
        b.queue = ["prepared", "configured", "closed", "destroyed", "shutdown"]
            .into_iter()
            .flat_map(|s| {
                c[s]["allocations"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .filter(|v| selected(v))
                    .cloned()
            })
            .collect();
        let p = b.allocate(derived::BYTES).unwrap();
        assert_eq!(p, n(&c["object"]));
        derived::construct(&mut b, p).unwrap();
        let incoming = if c["has_callback"] == true {
            b.callback(0x44000000, 0x728e20)
        } else {
            0
        };
        assert_eq!(incoming, n(&c["incoming"]));
        b.compare(&c["prepared"]);
        let key: [u8; 16] = bytes(c["key_hex"].as_str().unwrap()).try_into().unwrap();
        let host = c["host_hex"].as_str().map(bytes);
        let args = &c["args"];
        assert_eq!(
            derived::configure(
                &mut b,
                p + derived::INTERFACE,
                incoming,
                [n(&args[1]), n(&args[2])],
                &key,
                host.as_deref(),
                n(&args[5]),
                n(&args[6]),
                n(&args[7])
            )
            .unwrap(),
            n(&c["return_code"])
        );
        b.compare(&c["configured"]);
        b.globals(&c["configuration_globals"]);
        assert_eq!(json!(b.logs), c["configuration_logs"]);
        b.logs.clear();
        if b.word(startup::REFERENCES).unwrap() != 0 {
            derived::close(&mut b, p).unwrap();
        }
        b.compare(&c["closed"]);
        assert_eq!(json!(b.logs), c["close_logs"]);
        b.logs.clear();
        derived::scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&c["destroyed"]);
        logger::shutdown(&mut b).unwrap();
        b.compare(&c["shutdown"]);
        assert_eq!(json!(b.network), c["network_events"]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
    }
}
