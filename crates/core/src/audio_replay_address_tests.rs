use super::*;
use serde_json::{json, Value};
use std::collections::VecDeque;
fn bytes(s: &str) -> Vec<u8> {
    s.as_bytes()
        .chunks_exact(2)
        .map(|c| u8::from_str_radix(std::str::from_utf8(c).unwrap(), 16).unwrap())
        .collect()
}
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap().try_into().unwrap()
}
struct Profile<'a> {
    row: &'a Value,
    events: VecDeque<Value>,
    scratch: [u8; 16],
}
impl Profile<'_> {
    fn next(&mut self, kind: &str) -> Value {
        let v = self.events.pop_front().expect("unexpected Windows call");
        assert_eq!(v["kind"], kind);
        v
    }
}
impl Boundary for Profile<'_> {
    fn validation_byte(&mut self, i: usize, v: u8) -> Result<(), &'static str> {
        self.scratch[i] = v;
        Ok(())
    }
    fn inet_addr(&mut self, text: &[u8]) -> Result<u32, &'static str> {
        let v = self.next("inet_addr");
        assert_eq!(bytes(v["text_hex"].as_str().unwrap()), text);
        Ok(n(&v["result"]))
    }
    fn localhost(&mut self) -> Result<u32, &'static str> {
        let host = self.next("gethostbyname");
        let ip = u32::from_le_bytes(
            bytes(host["address_hex"].as_str().unwrap())
                .try_into()
                .unwrap(),
        );
        let text = self.next("inet_ntoa");
        assert_eq!(n(&text["address"]), ip);
        self.inet_addr(&bytes(text["text_hex"].as_str().unwrap()))
    }
    fn passive_lookup(&mut self, service: &[u8]) -> Result<Lookup, &'static str> {
        let v = self.next("getaddrinfo");
        assert_eq!(bytes(v["service_hex"].as_str().unwrap()), service);
        assert_eq!(v["hints"], json!([1, 2, 2, 17, 0, 0, 0, 0]));
        let mode = v["mode"].as_str().unwrap();
        if mode == "fail" {
            return Ok(Lookup {
                code: 11001,
                records: vec![],
            });
        }
        let mut records = vec![];
        if mode != "empty" {
            records.push(Record {
                family: 23,
                socket: None,
            });
        }
        if mode == "ipv6_then_ipv4" {
            records.push(Record {
                family: 2,
                socket: Some([2, 0, 0x34, 0x12, 10, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0]),
            });
        }
        self.next("freeaddrinfo");
        Ok(Lookup { code: 0, records })
    }
    fn address_to_string(
        &mut self,
        socket: &[u8; 16],
        text: &mut [u8],
        capacity: &mut u32,
    ) -> Result<u32, &'static str> {
        let v = self.next("WSAAddressToStringA");
        assert_eq!(bytes(v["sockaddr_hex"].as_str().unwrap()), socket);
        assert_eq!(n(&v["capacity"]), *capacity);
        *capacity = n(&self.row["capacity"]);
        if v["supplied_failure"] == true {
            return Ok(10014);
        }
        // These are the observed external formatter bytes, not the Rust UID result.
        text.copy_from_slice(&bytes(self.row["text_hex"].as_str().unwrap()));
        Ok(0)
    }
}
#[test]
fn audio_replay_address_matches164_original_host_port_crc_and_platform_boundary_profiles() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_address_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 164);
    for row in cases {
        let fill = n(&row["fill"]) as u8;
        let mut b = Profile {
            row,
            events: row["events"].as_array().unwrap().iter().cloned().collect(),
            scratch: [fill; 16],
        };
        let mut socket = [fill; 16];
        let mut text = [fill; 128];
        let mut capacity = 128;
        let result = resolve(
            &mut b,
            &bytes(row["host_hex"].as_str().unwrap()),
            n(&row["port"]) as u16,
            &mut socket,
            &mut text,
            &mut capacity,
        )
        .unwrap();
        assert_eq!(
            result,
            n(&row["return_uid"]),
            "host={} port={}",
            row["host_hex"],
            row["port"]
        );
        assert_eq!(
            socket.as_slice(),
            bytes(row["sockaddr_hex"].as_str().unwrap())
        );
        assert_eq!(text.as_slice(), bytes(row["text_hex"].as_str().unwrap()));
        assert_eq!(capacity, n(&row["capacity"]));
        assert_eq!(
            b.scratch.as_slice(),
            bytes(row["validation_scratch_hex"].as_str().unwrap())
        );
        assert!(b.events.is_empty());
    }
}
#[cfg(windows)]
#[test]
fn audio_replay_address_real_windows_numeric_conversion_keeps_native_zero_port_and_zero_uid_collision(
) {
    use crate::audio_replay_transport_startup::{windows::WindowsNetwork, Network};
    let mut network = WindowsNetwork::default();
    assert_eq!(network.winsock_startup(0x202).unwrap().code, 0);
    for host in [
        b"127.0.0.1".as_slice(),
        b"127.1",
        b"0177.0.0.1",
        b"0x7f000001",
        b"98.24.0.44",
        b"0.0.0.0",
    ] {
        let mut b = windows::Windows {
            validation_scratch: [165; 16],
        };
        let mut socket = [165; 16];
        let mut text = [165; 128];
        let mut capacity = 128;
        let result = resolve(&mut b, host, 65535, &mut socket, &mut text, &mut capacity).unwrap();
        assert_eq!(&socket[2..4], &[0; 2]);
        let expected: &[u8] = if host == b"98.24.0.44" {
            b"98.24.0.44".as_slice()
        } else if host == b"0.0.0.0" {
            b"0.0.0.0"
        } else {
            b"127.0.0.1"
        };
        assert_eq!(&text[..capacity as usize - 1], expected);
        assert_eq!(text[capacity as usize - 1], 0);
        if host == b"98.24.0.44" {
            assert_eq!(result, 0);
        } else {
            assert_ne!(result, 0);
        }
    }
    assert_eq!(network.winsock_cleanup().unwrap(), 0);
    assert_eq!(network.outstanding(), (0, 0));
}
