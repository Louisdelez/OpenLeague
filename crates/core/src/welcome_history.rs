//! Local protocol replay guard for previously established welcome identities.
//! This is not authentication: an unknown session still needs a trusted transport.
use std::collections::HashSet;
#[derive(Default)]
pub struct WelcomeHistory {
    current: Option<(u64,u32)>,
    retired_sessions: HashSet<u64>,
    retired_players: HashSet<(u64,u32)>,
}
impl WelcomeHistory {
    pub fn accept(&mut self, session:u64, player:u32)->bool {
        let identity=(session,player);
        if self.retired_sessions.contains(&session) || self.retired_players.contains(&identity) { return false; }
        if self.current==Some(identity) { return true; }
        if let Some(previous)=self.current {
            if previous.0!=session { self.retired_sessions.insert(previous.0); }
            else { self.retired_players.insert(previous); }
        }
        self.current=Some(identity);
        true
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn old_welcome_cannot_reopen_retired_session() {
        let mut h=WelcomeHistory::default();
        assert!(h.accept(100,21));assert!(h.accept(200,21));
        assert!(!h.accept(100,21));assert!(!h.accept(100,22));
        assert!(h.accept(200,21));assert_eq!(h.current,Some((200,21)));
    }
    #[test]
    fn repeated_current_welcome_and_new_identity_are_allowed() {
        let mut h=WelcomeHistory::default();assert!(h.accept(200,21));
        assert!(h.accept(200,21));assert!(h.accept(200,23));
        assert!(!h.accept(200,21));assert!(h.accept(200,23));
        // Session values are opaque, not presumed ordered wall-clock timestamps.
        assert!(h.accept(50,21));assert!(!h.accept(200,23));
    }
}
