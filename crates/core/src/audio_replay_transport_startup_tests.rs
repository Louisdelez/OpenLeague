use super::*;
use serde_json::{json, Value};
use std::collections::BTreeMap;
pub(crate) struct Harness<N> {
    pub(crate) words: BTreeMap<u32, u32>, pub(crate) network: N,
    pub(crate) events: Vec<Value>, pub(crate) held: Vec<u32>,
    logger: u32, fail_log: bool,
}
impl<N> Harness<N> {
    pub(crate) fn new(network: N) -> Self {
        Self { words: [STATUS, REFERENCES, ALLOCATOR, DEALLOCATOR].into_iter().chain(COUNTERS).map(|p| (p, 0)).collect(), network, events: vec![], held: vec![], logger: 0x2d78ed0, fail_log: false }
    }
}
impl<N: Network> Network for Harness<N> {
    fn winsock_startup(&mut self, version: u16) -> Result<Negotiation, Error> { self.events.push(json!({"op":"WSAStartup","version":version})); self.network.winsock_startup(version) }
    fn winsock_cleanup(&mut self) -> Result<u32, Error> { self.events.push(json!({"op":"WSACleanup"})); self.network.winsock_cleanup() }
    fn timer_begin(&mut self, period: u32) -> Result<u32, Error> { self.events.push(json!({"op":"timeBeginPeriod","period":period})); self.network.timer_begin(period) }
    fn timer_end(&mut self, period: u32) -> Result<u32, Error> { self.events.push(json!({"op":"timeEndPeriod","period":period})); self.network.timer_end(period) }
}
impl<N: Network> Backend for Harness<N> {
    fn read(&self, address: u32) -> Result<u32, Error> { self.words.get(&address).copied().ok_or(Error::Boundary("unknown global")) }
    fn write(&mut self, address: u32, value: u32) -> Result<(), Error> { *self.words.get_mut(&address).ok_or(Error::Boundary("unknown global"))? = value; self.events.push(json!({"op":"write","address":address,"value":value})); Ok(()) }
    fn exchange(&mut self, address: u32, value: u32) -> Result<u32, Error> { let old = self.read(address)?; self.write(address, value)?; Ok(old) }
    fn mutex(&mut self, address: u32, enter: bool) -> Result<(), Error> { if enter { self.held.push(address); } else { assert_eq!(self.held.pop(), Some(address)); } self.events.push(json!({"op":if enter{"lock"}else{"unlock"},"address":address})); Ok(()) }
    fn logger(&mut self) -> Result<u32, Error> { Ok(self.logger) }
    fn log(&mut self, logger: u32, message: &str) -> Result<(), Error> { if self.fail_log { return Err(Error::Boundary("logger unavailable")); } self.events.push(json!({"op":"log","logger":logger,"message":message})); Ok(()) }
}
struct Profile(Value);
impl Network for Profile {
    fn winsock_startup(&mut self, version: u16) -> Result<Negotiation, Error> { assert_eq!(version, 0x202); Ok(Negotiation { code: n(&self.0["startup_code"]), version: n(&self.0["version"]) as u16 }) }
    fn winsock_cleanup(&mut self) -> Result<u32, Error> { Ok(n(&self.0["cleanup_code"])) }
    fn timer_begin(&mut self, period: u32) -> Result<u32, Error> { assert_eq!(period, 1); Ok(n(&self.0["begin_code"])) }
    fn timer_end(&mut self, period: u32) -> Result<u32, Error> { assert_eq!(period, 1); Ok(n(&self.0["end_code"])) }
}
fn n(v: &Value) -> u32 { v.as_u64().unwrap().try_into().unwrap() }
fn proof() -> Value { serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_transport_startup_contract.json")).unwrap() }
fn prepare(p: &Value, c: &Value) -> Harness<Profile> {
    let mut b = Harness::new(Profile(c["profile"].clone()));
    b.logger = n(&p["logger"]);
    for (address, word) in p["addresses"].as_array().unwrap().iter().zip(c["before"].as_array().unwrap()) { b.words.insert(n(address), n(word)); }
    b
}
fn compare(p: &Value, c: &Value, b: &Harness<Profile>) {
    assert!(b.held.is_empty());
    assert_eq!(json!(b.events), c["after"]["events"]);
    assert_eq!(json!(p["addresses"].as_array().unwrap().iter().map(|a| b.words[&n(a)]).collect::<Vec<_>>()), c["after"]["words"]);
}
#[test]
fn audio_replay_transport_worker_matches40_native_global_banks_network_failures_lock_order_and_wrapping_references() {
    let p = proof(); let cases = p["workers"].as_array().unwrap(); assert_eq!(cases.len(), 40);
    assert_eq!(p["failure_message"], FAILURE_MESSAGE);
    for c in cases { let mut b = prepare(&p, c); worker(&mut b).unwrap(); compare(&p, c, &b); }
}
#[test]
fn audio_replay_transport_release_matches32_native_signed_diagnostics_timer_winsock_order_wrapping_and_unchanged_status() {
    let p = proof(); let cases = p["shutdowns"].as_array().unwrap(); assert_eq!(cases.len(), 32);
    for c in cases { let mut b = prepare(&p, c); release(&mut b).unwrap(); compare(&p, c, &b); }
}
#[test]
fn audio_replay_transport_network_matches5_native_negotiation_profiles_and_ignored_timer_cleanup_return_codes() {
    let p = proof(); let cases = p["network"].as_array().unwrap(); assert_eq!(cases.len(), 5);
    for c in cases { let mut b = prepare(&p, c); assert_eq!(network_startup(&mut b).unwrap(), n(&c["result"])); compare(&p, c, &b); }
}
#[test]
fn audio_replay_transport_boundary_failure_unlocks_both_scopes_and_does_not_publish_success() {
    let p = proof(); let c = &p["workers"][1]; assert_ne!(c["profile"]["startup_code"], 0);
    let mut b = prepare(&p, c); b.fail_log = true;
    assert_eq!(worker(&mut b), Err(Error::Boundary("logger unavailable")));
    assert!(b.held.is_empty()); assert_eq!(b.words[&STATUS], 0); assert_eq!(b.words[&REFERENCES], 0);
    assert_eq!(&b.events[b.events.len()-2..], [json!({"op":"unlock","address":b.logger}), json!({"op":"unlock","address":MUTEX})]);
}
#[cfg(windows)]
#[test]
fn audio_replay_transport_actual_windows_network_initialization_and_release_balance_owned_resources() {
    let mut b = Harness::new(windows::WindowsNetwork::default());
    worker(&mut b).unwrap(); assert_eq!(b.words[&STATUS], 2); assert_eq!(b.words[&REFERENCES], 1); assert_eq!(b.network.outstanding(), (1, 1));
    worker(&mut b).unwrap(); assert_eq!(b.words[&REFERENCES], 2); assert_eq!(b.network.outstanding(), (1, 1));
    release(&mut b).unwrap(); assert_eq!(b.network.outstanding(), (1, 1));
    release(&mut b).unwrap(); assert_eq!(b.network.outstanding(), (0, 0)); assert_eq!(b.words[&REFERENCES], 0); assert_eq!(b.words[&STATUS], 2); assert!(b.held.is_empty());
}
