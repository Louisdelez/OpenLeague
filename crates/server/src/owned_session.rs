//! Local launcher ownership. EOF asks for draining; it never ejects another peer.
use std::io::{self, Read};
use std::sync::mpsc::{self, Receiver, TryRecvError};

pub struct Owner {
    ended: Option<Receiver<io::Result<()>>>,
    draining: bool,
}
impl Owner {
    pub fn from_environment() -> io::Result<Self> {
        match std::env::var("OPENLEAGUE_OWNED_STDIN") {
            Err(std::env::VarError::NotPresent) => Ok(Self { ended: None, draining: false }),
            Ok(value) if value == "1" => Self::read_owner(std::io::stdin()),
            _ => Err(io::Error::other("OPENLEAGUE_OWNED_STDIN must be absent or 1")),
        }
    }
    fn read_owner(mut reader: impl Read + Send + 'static) -> io::Result<Self> {
        let (send, ended) = mpsc::channel();
        std::thread::Builder::new().name("launcher-owner".into()).spawn(move || {
            let mut buffer = [0u8; 64];
            let result = loop {
                match reader.read(&mut buffer) {
                    Ok(0) => break Ok(()),
                    Ok(_) => {},
                    Err(error) if error.kind() == io::ErrorKind::Interrupted => {},
                    Err(error) => break Err(error),
                }
            };
            let _ = send.send(result);
        })?;
        Ok(Self { ended: Some(ended), draining: false })
    }
    pub fn poll(&mut self) -> io::Result<bool> {
        if !self.draining {
            if let Some(ended) = &self.ended {
                match ended.try_recv() {
                    Ok(result) => { self.draining = true; result?; },
                    Err(TryRecvError::Empty) => {},
                    Err(TryRecvError::Disconnected) => {
                        self.draining = true;
                        return Err(io::Error::other("launcher ownership reader stopped without a result"));
                    },
                }
            }
        }
        Ok(self.draining)
    }
}

pub fn can_stop(draining: bool, clients: usize, has_result: bool, saved: bool) -> bool {
    draining && clients == 0 && (!has_result || saved)
}

pub fn may_leave(session: u64, claimed_session: u64, player: u32, sequence: u64,
    peer: Option<(u32, u64)>) -> bool {
    session == claimed_session && peer.is_some_and(|(id, last)| id == player && sequence > last)
}

/// Local transport bound. Reserve space for every active peer's future departure,
/// so a reordered Join can never resurrect an explicitly departed participant.
#[derive(Default)]
pub struct Departures(std::collections::HashSet<std::net::SocketAddr>);
const MAX_SESSION_PEERS: usize = 1024;
impl Departures {
    pub fn can_join(&self, peer: &std::net::SocketAddr, active: usize) -> Result<(), &'static str> {
        if self.0.contains(peer) { return Err("peer already left this session"); }
        if self.0.len().saturating_add(active) >= MAX_SESSION_PEERS { return Err("local session participant limit reached"); }
        Ok(())
    }
    pub fn record(&mut self, peer: std::net::SocketAddr) -> Result<(), &'static str> {
        if self.0.len() >= MAX_SESSION_PEERS && !self.0.contains(&peer) {
            return Err("local session departure limit reached");
        }
        self.0.insert(peer);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn retired_peers_stay_retired_and_capacity_reserves_active_departures() {
        let mut departures = Departures::default();
        let address = |port| std::net::SocketAddr::from(([127, 0, 0, 1], port));
        for port in 1..MAX_SESSION_PEERS as u16 { departures.record(address(port)).unwrap(); }
        assert_eq!(departures.can_join(&address(1), 0), Err("peer already left this session"));
        assert!(departures.can_join(&address(2048), 0).is_ok());
        assert_eq!(departures.can_join(&address(2048), 1), Err("local session participant limit reached"));
        departures.record(address(2048)).unwrap();
        assert!(departures.record(address(2048)).is_ok());
        assert!(departures.record(address(2049)).is_err());
        assert_eq!(departures.0.len(), MAX_SESSION_PEERS);
        assert_eq!(departures.can_join(&address(1), 0), Err("peer already left this session"));
    }
    #[test]
    fn drain_keeps_other_players_and_unsaved_results_alive() {
        assert!(!can_stop(false, 0, false, false));
        assert!(!can_stop(true, 1, false, false));
        assert!(!can_stop(true, 5, true, true));
        assert!(!can_stop(true, 0, true, false));
        assert!(can_stop(true, 0, true, true));
        assert!(can_stop(true, 0, false, false));
    }
    #[test]
    fn departure_requires_this_session_peer_identity_and_new_sequence() {
        assert!(may_leave(8, 8, 3, 42, Some((3, 41))));
        assert!(!may_leave(8, 9, 3, 42, Some((3, 41))));
        assert!(!may_leave(8, 8, 4, 42, Some((3, 41))));
        assert!(!may_leave(8, 8, 3, 41, Some((3, 41))));
        assert!(!may_leave(8, 8, 3, 40, Some((3, 41))));
        assert!(!may_leave(8, 8, 3, 42, None));
    }
    #[test]
    fn eof_is_latched_and_read_errors_are_not_successful_drain() {
        let mut owner = Owner::read_owner(io::Cursor::new(vec![1, 2, 3])).unwrap();
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(2);
        while !owner.poll().unwrap() {
            assert!(std::time::Instant::now() < deadline);
            std::thread::yield_now();
        }
        assert!(owner.poll().unwrap());
        struct Broken;
        impl Read for Broken { fn read(&mut self, _: &mut [u8]) -> io::Result<usize> { Err(io::Error::other("injected read failure")) } }
        let mut owner = Owner::read_owner(Broken).unwrap();
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(2);
        loop {
            match owner.poll() {
                Err(error) => {
                    assert!(error.to_string().contains("injected read failure"));
                    assert!(owner.poll().unwrap());
                    assert!(!can_stop(true, 1, false, false));
                    assert!(!can_stop(true, 0, true, false));
                    break;
                },
                Ok(draining) => assert!(!draining),
            }
            assert!(std::time::Instant::now() < deadline);
            std::thread::yield_now();
        }
    }
}
