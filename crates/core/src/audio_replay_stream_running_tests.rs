use super::*;
use crate::audio_replay_stream_running as running;
const CONFIG: u32 = 0x3000c400;
const IMPL: u32 = 0x3000c480;
impl running::Boundary for Backend {
    fn launch_stream_worker(
        &mut self,
        l: &crate::audio_replay_transport_thread::Launch,
    ) -> Result<u32, &'static str> {
        let node = self.word(l.argument + 0x44).unwrap();
        let state = self.word(node + 12).unwrap();
        let flags: Vec<_> = (4..7)
            .map(|i| self.memory.read_byte(l.argument + i).unwrap())
            .collect();
        let tag: String = l.tag.iter().map(|b| format!("{b:02x}")).collect();
        self.events.push(json!({"op":"launch","callback":l.callback,"tag":tag,"name":std::str::from_utf8(l.name).unwrap(),"state":state,"flags":flags}));
        Ok(0)
    }
    fn start_implementation(&mut self, _: u32, f: u32, args: &[u32]) -> Result<u8, &'static str> {
        let p = self.word(CONFIG + 8).unwrap();
        let node = self.word(p + 0x44).unwrap();
        let state = self.word(node + 12).unwrap();
        let flags: Vec<_> = (4..7)
            .map(|i| self.memory.read_byte(p + i).unwrap())
            .collect();
        self.events.push(
            json!({"op":"implementation","method":f,"args":args,"state":state,"flags":flags}),
        );
        Ok(self
            .word(CONFIG + if f == 0x8f7060 { 0 } else { 4 })
            .unwrap() as u8)
    }
    fn sleep(&mut self, ms: u32) -> Result<(), &'static str> {
        self.events.push(json!(ms));
        let p = self.word(CONFIG + 8).unwrap();
        if self.word(CONFIG + 12).unwrap() == 0 {
            if self.events.len() == 3 {
                self.write_byte(p + 5, 0).unwrap();
            }
        } else if self.events.len() == 1 {
            self.write_byte(p + 5, 0).unwrap();
        } else if self.events.len() == 2 {
            self.write_byte(p + 6, 0).unwrap();
        }
        Ok(())
    }
}
fn running_host(fill: u8) -> (Backend, u32) {
    let mut b = make_stream(fill, false);
    b.memory.reserve_at(CONFIG, 256).unwrap();
    for (p, size) in [(stream::VTABLE, 32), (0x10d6254, 48), (0x10d5fec, 48)] {
        b.memory.reserve_at(p, size).unwrap();
    }
    for (p, v) in [
        (stream::VTABLE, 0x8f6c40),
        (stream::VTABLE + 12, 0x8f6bc0),
        (0x10d6254 + 8, 0x8f7060),
        (0x10d6254 + 12, 0x8f75d0),
        (0x10d5fec + 0x24, 0x8f6670),
    ] {
        b.set(p, v);
    }
    let p = new_stream(&mut b);
    b.set(CONFIG + 8, p);
    b.set(CONFIG + 12, 0);
    b.set(p + 0x64, IMPL);
    b.set(IMPL, 0x10d6254);
    b.events.clear();
    (b, p)
}
#[test]
fn audio_replay_stream_running_matches192_native_start_state_gates_callback_arguments_and_failure_states(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_running_contract.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 192);
    for c in cases {
        let (mut b, p) = running_host(n(&c["fill"]) as u8);
        let id = n(&c["state_before"]);
        let node = if id < 5 {
            b.word(p + 0x50 + id * 4).unwrap()
        } else {
            let node = CONFIG + 0xa0;
            let parent = b.word(p + 0x5c).unwrap();
            let event = b.word(parent + 8).unwrap();
            let enter = b.word(parent).unwrap();
            let exit = b.word(parent + 4).unwrap();
            for (o, v) in [(0, enter), (4, exit), (8, event), (12, 99), (16, parent)] {
                b.set(node + o, v);
            }
            node
        };
        b.set(p + 0x44, node);
        b.set(CONFIG, n(&c["first_return"]));
        b.set(CONFIG + 4, n(&c["second_return"]));
        let args = std::array::from_fn(|i| n(&c["arguments"][i]));
        assert_eq!(
            running::start(&mut b, p, args).unwrap(),
            n(&c["return_code"]),
            "{c}"
        );
        let node = b.word(p + 0x44).unwrap();
        assert_eq!(b.word(node + 12).unwrap(), n(&c["state_after"]));
        let flags: Vec<_> = (4..7).map(|i| b.memory.read_byte(p + i).unwrap()).collect();
        assert_eq!(json!(flags), c["flags"]);
        assert_eq!(json!(b.events), c["calls"]);
    }
}
#[test]
fn audio_replay_stream_worker_matches_native_pause_and_stop_flag_order_including_one_last_poll() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_running_contract.json",
    ))
    .unwrap();
    let cases = proof["workers"].as_array().unwrap();
    assert_eq!(cases.len(), 4);
    for c in cases {
        let (mut b, p) = running_host(n(&c["fill"]) as u8);
        b.set(IMPL, 0x10d5fec);
        b.write_byte(p + 5, 1).unwrap();
        if c["profile"] == "stop_while_paused" {
            b.set(CONFIG + 12, 1);
            b.write_byte(p + 6, 1).unwrap();
        }
        running::worker(&mut b, p).unwrap();
        assert_eq!(json!(b.events), c["sleep_calls"]);
        let flags: Vec<_> = (4..7).map(|i| b.memory.read_byte(p + i).unwrap()).collect();
        assert_eq!(json!(flags), c["flags"]);
    }
}
