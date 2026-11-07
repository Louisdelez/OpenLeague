//! Fixed, process-bounded observations of the local R OnCast consumer.
//! No identities, positions, media paths or user strings. Not proof of audibility.
//! Budgets never reset on reconnect/session/visibility; no frame polling output.
use std::sync::atomic::{AtomicBool, AtomicU8, Ordering};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(usize)]
pub(crate) enum Code {
    ContextRejected, DeliveryRevoked, ClockRejected, ProjectionRejected,
    EventAdmitted, EventBaseline, EventPreviouslyHidden, EventNotReady, EventPaused,
    EventFinished, EventStale, EventBackdated, EventCapacity, PendingRevoked, PendingExpired,
    RequestNotReady, RequestPaused, RequestChannel, RequestSnapshot,
    RequestCapacity, RequestOwnerHidden, RequestOwnerMissing, RequestAssetMissing,
    GainZero, GainInvalid, SpawnQueued, FirstSinkWithin100ms, FirstSinkAfter100ms, FirstSinkClockInvalid,
    RetireNotReady, RetirePaused, RetireChannel, RetireSnapshot, RetireContext,
    RetireAuthorization, RetireOwnerHidden, RetireOwnerChanged, RetireGainZero, RetireGainInvalid,
    RetireClockOrDuration, RetireHardLimit, RetireSinkLost, RetireSinkEmpty,
    RetireInitialSinkTimeout, RetireFirstSinkLate, RetireActiveWatchdog,
    BudgetExhausted,
}
impl Code {
    const COUNT: usize = Self::BudgetExhausted as usize + 1;
    pub(crate) fn token(self) -> &'static str {
        match self {
            Self::ContextRejected => "[OL_R_CAST_DIAG:v1:context_rejected]",
            Self::DeliveryRevoked => "[OL_R_CAST_DIAG:v1:delivery_revoked]",
            Self::ClockRejected => "[OL_R_CAST_DIAG:v1:clock_rejected]",
            Self::ProjectionRejected => "[OL_R_CAST_DIAG:v1:projection_rejected]",
            Self::EventAdmitted => "[OL_R_CAST_DIAG:v1:event_admitted]",
            Self::EventBaseline => "[OL_R_CAST_DIAG:v1:event_baseline]",
            Self::EventPreviouslyHidden => "[OL_R_CAST_DIAG:v1:event_previously_hidden]",
            Self::EventNotReady => "[OL_R_CAST_DIAG:v1:event_not_ready]",
            Self::EventPaused => "[OL_R_CAST_DIAG:v1:event_paused]",
            Self::EventFinished => "[OL_R_CAST_DIAG:v1:event_finished]",
            Self::EventStale => "[OL_R_CAST_DIAG:v1:event_stale]",
            Self::EventBackdated => "[OL_R_CAST_DIAG:v1:event_backdated]",
            Self::EventCapacity => "[OL_R_CAST_DIAG:v1:event_capacity]",
            Self::PendingRevoked => "[OL_R_CAST_DIAG:v1:pending_revoked]",
            Self::PendingExpired => "[OL_R_CAST_DIAG:v1:pending_expired]",
            Self::RequestNotReady => "[OL_R_CAST_DIAG:v1:request_not_ready]",
            Self::RequestPaused => "[OL_R_CAST_DIAG:v1:request_paused]",
            Self::RequestChannel => "[OL_R_CAST_DIAG:v1:request_channel]",
            Self::RequestSnapshot => "[OL_R_CAST_DIAG:v1:request_snapshot]",
            Self::RequestCapacity => "[OL_R_CAST_DIAG:v1:request_capacity]",
            Self::RequestOwnerHidden => "[OL_R_CAST_DIAG:v1:request_owner_hidden]",
            Self::RequestOwnerMissing => "[OL_R_CAST_DIAG:v1:request_owner_missing]",
            Self::RequestAssetMissing => "[OL_R_CAST_DIAG:v1:request_asset_missing]",
            Self::GainZero => "[OL_R_CAST_DIAG:v1:gain_zero]",
            Self::GainInvalid => "[OL_R_CAST_DIAG:v1:gain_invalid]",
            Self::SpawnQueued => "[OL_R_CAST_DIAG:v1:spawn_queued]",
            Self::FirstSinkWithin100ms => "[OL_R_CAST_DIAG:v1:first_sink_within_100ms]",
            Self::FirstSinkAfter100ms => "[OL_R_CAST_DIAG:v1:first_sink_after_100ms]",
            Self::FirstSinkClockInvalid => "[OL_R_CAST_DIAG:v1:first_sink_clock_invalid]",
            Self::RetireNotReady => "[OL_R_CAST_DIAG:v1:retire_not_ready]",
            Self::RetirePaused => "[OL_R_CAST_DIAG:v1:retire_paused]",
            Self::RetireChannel => "[OL_R_CAST_DIAG:v1:retire_channel]",
            Self::RetireSnapshot => "[OL_R_CAST_DIAG:v1:retire_snapshot]",
            Self::RetireContext => "[OL_R_CAST_DIAG:v1:retire_context]",
            Self::RetireAuthorization => "[OL_R_CAST_DIAG:v1:retire_authorization]",
            Self::RetireOwnerHidden => "[OL_R_CAST_DIAG:v1:retire_owner_hidden]",
            Self::RetireOwnerChanged => "[OL_R_CAST_DIAG:v1:retire_owner_changed]",
            Self::RetireGainZero => "[OL_R_CAST_DIAG:v1:retire_gain_zero]",
            Self::RetireGainInvalid => "[OL_R_CAST_DIAG:v1:retire_gain_invalid]",
            Self::RetireClockOrDuration => "[OL_R_CAST_DIAG:v1:retire_clock_or_duration]",
            Self::RetireHardLimit => "[OL_R_CAST_DIAG:v1:retire_hard_limit]",
            Self::RetireSinkLost => "[OL_R_CAST_DIAG:v1:retire_sink_lost]",
            Self::RetireSinkEmpty => "[OL_R_CAST_DIAG:v1:retire_sink_empty]",
            Self::RetireInitialSinkTimeout => "[OL_R_CAST_DIAG:v1:retire_initial_sink_timeout]",
            Self::RetireFirstSinkLate => "[OL_R_CAST_DIAG:v1:retire_first_sink_late]",
            Self::RetireActiveWatchdog => "[OL_R_CAST_DIAG:v1:retire_active_watchdog]",
            Self::BudgetExhausted => "[OL_R_CAST_DIAG:v1:budget_exhausted]",
        }
    }
}
const PER_CODE_LIMIT: u8 = 4;
struct Budget { counts: [AtomicU8; Code::COUNT], limit_reported: AtomicBool }
impl Budget {
    const fn new() -> Self {
        Self { counts: [const { AtomicU8::new(0) }; Code::COUNT], limit_reported: AtomicBool::new(false) }
    }
    fn claim(&self, code: Code) -> Option<Code> {
        if code == Code::BudgetExhausted { return None; }
        let result = self.counts[code as usize].fetch_update(Ordering::Relaxed, Ordering::Relaxed,
            |count| (count < PER_CODE_LIMIT).then(|| count + 1));
        match result {
            Ok(_) => Some(code),
            Err(_) if !self.limit_reported.swap(true, Ordering::Relaxed) => Some(Code::BudgetExhausted),
            Err(_) => None,
        }
    }
}
static BUDGET: Budget = Budget::new();
pub(crate) fn record(code: Code) {
    #[cfg(test)]
    if TEST_CAPTURE.with(|capture| {
        if let Some(events) = capture.borrow_mut().as_mut() { events.push(code); true } else { false }
    }) { return; }
    if let Some(code) = BUDGET.claim(code) { bevy::log::info!("{}", code.token()); }
}

/// Measures only the first component observation against the same EffectClock
/// used by Lifetime. This flag cannot alter Lifetime's observed_start or expiry.
#[derive(Clone, Copy, Debug, Default)]
pub(crate) struct FirstSink { seen: bool }
impl FirstSink {
    pub(crate) fn observe(&mut self, delay: f64, present: bool) -> Option<Code> {
        if self.seen || !present { return None; }
        self.seen = true;
        Some(if !delay.is_finite() || delay < 0. { Code::FirstSinkClockInvalid }
            else if delay <= 0.1 { Code::FirstSinkWithin100ms } else { Code::FirstSinkAfter100ms })
    }
}

#[cfg(test)]
std::thread_local! { static TEST_CAPTURE: std::cell::RefCell<Option<Vec<Code>>> = const { std::cell::RefCell::new(None) }; }
/// Test-only raw observer: isolates assertions from the process-global quota;
/// quota tests exercise a real Budget independently. Never enabled in product.
#[cfg(test)]
pub(crate) fn captured(run: impl FnOnce()) -> Vec<Code> {
    struct Reset;
    impl Drop for Reset { fn drop(&mut self) { TEST_CAPTURE.with(|c| { c.borrow_mut().take(); }); } }
    TEST_CAPTURE.with(|capture| { assert!(capture.borrow().is_none()); *capture.borrow_mut() = Some(Vec::new()); });
    let _reset = Reset;
    run();
    TEST_CAPTURE.with(|capture| capture.borrow_mut().take().unwrap())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn process_budget_caps_each_code_and_reports_global_exhaustion_only_once() {
        let budget = Budget::new();
        for _ in 0..4 { assert_eq!(budget.claim(Code::EventAdmitted), Some(Code::EventAdmitted)); }
        assert_eq!(budget.claim(Code::EventAdmitted), Some(Code::BudgetExhausted));
        for _ in 0..1000 { assert_eq!(budget.claim(Code::EventAdmitted), None); }
        for _ in 0..4 { assert_eq!(budget.claim(Code::SpawnQueued), Some(Code::SpawnQueued)); }
        assert_eq!(budget.claim(Code::SpawnQueued), None);
        assert_eq!(budget.claim(Code::BudgetExhausted), None);
        assert_eq!(budget.counts[Code::EventAdmitted as usize].load(Ordering::Relaxed), 4);
    }
    #[test]
    fn concurrent_attempts_cannot_overrun_one_code_or_duplicate_limit_marker() {
        let budget = std::sync::Arc::new(Budget::new());
        let threads: Vec<_> = (0..8).map(|_| {
            let budget = budget.clone();
            std::thread::spawn(move || (0..128).filter_map(|_| budget.claim(Code::EventAdmitted)).collect::<Vec<_>>())
        }).collect();
        let events: Vec<_> = threads.into_iter().flat_map(|t| t.join().unwrap()).collect();
        assert_eq!(events.iter().filter(|&&v| v == Code::EventAdmitted).count(), 4);
        assert_eq!(events.iter().filter(|&&v| v == Code::BudgetExhausted).count(), 1);
    }
    #[test]
    fn first_sink_is_reported_once_at_exact_local_boundary_and_invalid_time() {
        for (delay, expected) in [(0., Code::FirstSinkWithin100ms), (0.1, Code::FirstSinkWithin100ms),
            (f64::from_bits(0.1f64.to_bits()+1), Code::FirstSinkAfter100ms),
            (f64::NAN, Code::FirstSinkClockInvalid), (f64::INFINITY, Code::FirstSinkClockInvalid),
            (-0.01, Code::FirstSinkClockInvalid)] {
            let mut observer = FirstSink::default();
            assert_eq!(observer.observe(delay, false), None);
            assert_eq!(observer.observe(delay, true), Some(expected));
            assert_eq!(observer.observe(0., true), None);
            assert_eq!(observer.observe(0., false), None);
        }
    }
}
