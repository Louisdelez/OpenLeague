//! Source-driven ambient event selection, separate from playback and spatial mixing.
//! Supplied unit draws allow reproducible checks without claiming the native RNG stream.
use serde::Deserialize;
use std::collections::{BTreeMap, BTreeSet, VecDeque};

#[derive(Debug, Clone, Deserialize)]
pub struct Contract {
    pub events: Vec<Event>,
    pub containers: Vec<Container>,
    pub sounds: Vec<Sound>,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Event {
    pub id: u32,
    pub actions: Vec<Action>,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Action {
    pub id: u32,
    pub target: u32,
    pub probability_percent: f64,
    #[serde(default)]
    pub properties: BTreeMap<String, f32>,
    pub transition_ms: f64,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Range {
    pub min: f64,
    pub max: f64,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Container {
    pub id: u32,
    pub mode: u8,
    pub random_mode: u8,
    pub avoid_repeat: usize,
    pub global: bool,
    pub continuous: bool,
    pub reset_each_play_raw: bool,
    pub uses_weight: bool,
    pub loop_count: u16,
    pub transition_mode: u8,
    pub properties: BTreeMap<String, f64>,
    pub ranges: BTreeMap<String, Range>,
    pub playlist: Vec<Entry>,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Entry {
    pub sound: u32,
    pub weight: i32,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Sound {
    pub id: u32,
    pub source: u32,
    pub parent: u32,
    pub properties: BTreeMap<String, f64>,
    pub ranges: BTreeMap<String, Range>,
}
#[derive(Debug, Clone, PartialEq)]
pub struct Selection {
    pub action: u32,
    pub container: u32,
    pub sound: u32,
    pub source: u32,
    pub transition_ms: f64,
}
#[derive(Debug, Clone, PartialEq)]
pub enum Error {
    InvalidContract,
    UnknownEvent(u32),
    InvalidDraw,
    UnsupportedContainer(u32),
}

pub fn ambient_contract() -> Result<Contract, Error> {
    let c: Contract = serde_json::from_str(include_str!(
        "../../../data/4.20/ambient_audio_selection.json"
    ))
    .map_err(|_| Error::InvalidContract)?;
    c.validate()?;
    Ok(c)
}
impl Contract {
    pub fn validate(&self) -> Result<(), Error> {
        fn unique(mut ids: impl Iterator<Item = u32>) -> bool {
            let mut seen = BTreeSet::new();
            ids.all(|id| seen.insert(id))
        }
        if !unique(self.events.iter().map(|x| x.id))
            || !unique(self.containers.iter().map(|x| x.id))
            || !unique(self.sounds.iter().map(|x| x.id))
        {
            return Err(Error::InvalidContract);
        }
        if self.sounds.iter().any(|s| {
            s.properties.values().any(|v| !v.is_finite())
                || s.ranges
                    .values()
                    .any(|v| !v.min.is_finite() || !v.max.is_finite() || v.min > v.max)
        }) {
            return Err(Error::InvalidContract);
        }
        for c in &self.containers {
            if c.mode != 0
                || c.continuous
                || c.loop_count != 1
                || c.transition_mode != 0
                || c.random_mode > 1
                || (c.random_mode == 1 && c.avoid_repeat != 0)
            {
                return Err(Error::UnsupportedContainer(c.id));
            }
            if c.playlist.is_empty()
                || !unique(c.playlist.iter().map(|x| x.sound))
                || c.playlist.iter().any(|p| p.weight < 0)
            {
                return Err(Error::InvalidContract);
            }
            let eligible = c
                .playlist
                .iter()
                .filter(|p| !c.uses_weight || p.weight > 0)
                .count();
            if eligible == 0 || c.avoid_repeat >= eligible {
                return Err(Error::InvalidContract);
            }
            for p in &c.playlist {
                if !self
                    .sounds
                    .iter()
                    .any(|s| s.id == p.sound && s.parent == c.id)
                {
                    return Err(Error::InvalidContract);
                }
            }
            if c.properties.values().any(|v| !v.is_finite())
                || c.ranges
                    .values()
                    .any(|v| !v.min.is_finite() || !v.max.is_finite() || v.min > v.max)
            {
                return Err(Error::InvalidContract);
            }
        }
        for e in &self.events {
            if !unique(e.actions.iter().map(|a| a.id)) {
                return Err(Error::InvalidContract);
            }
            for a in &e.actions {
                if !a.probability_percent.is_finite()
                    || !(0.0..=100.0).contains(&a.probability_percent)
                    || !a.transition_ms.is_finite()
                    || a.transition_ms < 0.0
                    || !self.containers.iter().any(|c| c.id == a.target)
                {
                    return Err(Error::InvalidContract);
                }
            }
        }
        Ok(())
    }
}
#[derive(Debug, Clone, Default)]
struct History {
    recent: VecDeque<usize>,
    remaining: Vec<usize>,
}
#[derive(Debug, Clone)]
pub struct Selector {
    contract: Contract,
    history: BTreeMap<(u32, Option<u64>), History>,
}
impl Selector {
    pub fn new(contract: Contract) -> Result<Self, Error> {
        contract.validate()?;
        Ok(Self {
            contract,
            history: BTreeMap::new(),
        })
    }
    pub fn contract(&self) -> &Contract {
        &self.contract
    }
    /// One step per successful Play action. All actions are evaluated independently.
    /// Global scope shares history between emitters; local scope keeps it per emitter.
    /// reset_each_play_raw is retained for later native qualification, not applied here.
    /// No ranges, attenuation, bus gain, voice limits or sound lifetimes are resolved.
    pub fn event(
        &mut self,
        id: u32,
        emitter: u64,
        mut draw: impl FnMut() -> f64,
    ) -> Result<Vec<Selection>, Error> {
        let event = self
            .contract
            .events
            .iter()
            .find(|e| e.id == id)
            .ok_or(Error::UnknownEvent(id))?;
        let mut next = self.history.clone();
        let mut result = Vec::new();
        for action in &event.actions {
            if action.probability_percent == 0.0 {
                continue;
            }
            if action.probability_percent < 100.0
                && unit(draw())? * 100.0 >= action.probability_percent
            {
                continue;
            }
            let c = self
                .contract
                .containers
                .iter()
                .find(|c| c.id == action.target)
                .ok_or(Error::InvalidContract)?;
            let key = (c.id, if c.global { None } else { Some(emitter) });
            let h = next.entry(key).or_default();
            let eligible: Vec<usize> = c
                .playlist
                .iter()
                .enumerate()
                .filter(|(_, p)| !c.uses_weight || p.weight > 0)
                .map(|(i, _)| i)
                .collect();
            let pool = if c.random_mode == 1 {
                if h.remaining.is_empty() {
                    h.remaining = eligible;
                }
                h.remaining.clone()
            } else {
                eligible
                    .into_iter()
                    .filter(|i| !h.recent.contains(i))
                    .collect()
            };
            let total: u64 = pool
                .iter()
                .map(|i| {
                    if c.uses_weight {
                        c.playlist[*i].weight as u64
                    } else {
                        1
                    }
                })
                .sum();
            if total == 0 {
                return Err(Error::InvalidContract);
            }
            let mut ticket = unit(draw())? * total as f64;
            let mut chosen = *pool.last().ok_or(Error::InvalidContract)?;
            for i in pool {
                let w = if c.uses_weight {
                    c.playlist[i].weight as f64
                } else {
                    1.0
                };
                if ticket < w {
                    chosen = i;
                    break;
                }
                ticket -= w;
            }
            if c.random_mode == 1 {
                h.remaining.retain(|i| *i != chosen);
            }
            if c.avoid_repeat > 0 {
                h.recent.push_back(chosen);
                while h.recent.len() > c.avoid_repeat {
                    h.recent.pop_front();
                }
            }
            let sound = c.playlist[chosen].sound;
            let source = self
                .contract
                .sounds
                .iter()
                .find(|s| s.id == sound)
                .ok_or(Error::InvalidContract)?
                .source;
            result.push(Selection {
                action: action.id,
                container: c.id,
                sound,
                source,
                transition_ms: action.transition_ms,
            });
        }
        self.history = next;
        Ok(result)
    }
}
fn unit(v: f64) -> Result<f64, Error> {
    if v.is_finite() && (0.0..1.0).contains(&v) {
        Ok(v)
    } else {
        Err(Error::InvalidDraw)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn selector() -> Selector {
        Selector::new(ambient_contract().unwrap()).unwrap()
    }
    fn rolls(values: &[f64]) -> impl FnMut() -> f64 + '_ {
        let mut it = values.iter();
        move || *it.next().expect("unexpected random draw")
    }
    #[test]
    fn native_contract_preserves_actions_sources_and_ranges() {
        let c = ambient_contract().unwrap();
        assert_eq!(c.events.len(), 5);
        assert_eq!(c.containers.len(), 8);
        assert_eq!(c.sounds.len(), 42);
        let b = &c.containers.iter().find(|c| c.id == 6927).unwrap();
        assert_eq!(b.playlist[0].sound, 854594428);
        assert_eq!(b.properties["0"], -36.0);
        assert_eq!(b.ranges["0"].min, -8.0);
        assert_eq!(b.ranges["2"].max, 200.0);
        assert!(b.reset_each_play_raw);
        assert!(!b.uses_weight);
        assert_eq!(
            c.sounds
                .iter()
                .find(|s| s.id == 320325277)
                .unwrap()
                .properties["5"],
            35.0
        );
    }
    #[test]
    fn native_brazier_actions_can_be_silent_single_or_simultaneous() {
        let mut s = selector();
        let id = 1392698701;
        assert_eq!(s.event(id, 1, rolls(&[0.5, 0.25])).unwrap().len(), 0);
        assert_eq!(s.event(id, 1, rolls(&[0.49, 0.0, 0.25])).unwrap().len(), 1);
        let both = s.event(id, 1, rolls(&[0.0, 0.0, 0.0, 0.0])).unwrap();
        assert_eq!(both.len(), 2);
        assert_eq!(both[0].transition_ms, 100.0);
        assert_ne!(both[0].container, both[1].container);
    }
    #[test]
    fn native_standard_history_is_global_and_skipped_actions_do_not_change_it() {
        let mut s = selector();
        let id = 1392698701;
        let first = s.event(id, 1, rolls(&[0.0, 0.0, 0.99])).unwrap()[0].sound;
        s.event(id, 2, rolls(&[0.99, 0.99])).unwrap();
        let second = s.event(id, 2, rolls(&[0.0, 0.0, 0.99])).unwrap()[0].sound;
        assert_ne!(first, second);
        assert_eq!(
            s.event(id, 3, rolls(&[0.0, 0.0, 0.99])).unwrap()[0].sound,
            first
        );
    }
    #[test]
    fn native_shuffle_exhausts_each_layer_independently_across_emitters() {
        let mut s = selector();
        let mut a = BTreeSet::new();
        let mut b = BTreeSet::new();
        for emitter in 0..6 {
            let p = s.event(3282059833, emitter, || 0.0).unwrap();
            assert_eq!(p.len(), 2);
            a.insert(p[0].sound);
            b.insert(p[1].sound);
        }
        assert_eq!(a.len(), 6);
        assert_eq!(b.len(), 6);
        assert_eq!(s.event(3282059833, 7, || 0.0).unwrap()[0].sound, 126431920);
    }
    #[test]
    fn local_scope_does_not_share_history() {
        let mut c = ambient_contract().unwrap();
        c.containers.iter_mut().for_each(|x| x.global = false);
        let mut s = Selector::new(c).unwrap();
        let a = s.event(3282059833, 1, || 0.0).unwrap();
        assert_eq!(a, s.event(3282059833, 2, || 0.0).unwrap());
        assert_ne!(a, s.event(3282059833, 1, || 0.0).unwrap());
    }
    #[test]
    fn native_shop_single_source_is_a_step_not_an_infinite_voice() {
        let mut s = selector();
        for _ in 0..3 {
            let p = s.event(910296306, 1, || 0.99).unwrap();
            assert_eq!(p.len(), 1);
            assert_eq!(p[0].source, 306723203);
            assert_eq!(p[0].transition_ms, 0.0);
        }
    }
    #[test]
    fn weighted_selection_uses_eligible_weight_sum() {
        let mut c = ambient_contract().unwrap();
        let x = c.containers.iter_mut().find(|x| x.id == 8083).unwrap();
        x.uses_weight = true;
        x.random_mode = 0;
        x.playlist.push(Entry {
            sound: 1,
            weight: 150000,
        });
        c.sounds.push(Sound {
            id: 1,
            source: 2,
            parent: 8083,
            properties: BTreeMap::new(),
            ranges: BTreeMap::new(),
        });
        let mut s = Selector::new(c).unwrap();
        assert_eq!(
            s.event(910296306, 1, || 0.249999).unwrap()[0].source,
            306723203
        );
        assert_eq!(s.event(910296306, 1, || 0.25).unwrap()[0].source, 2);
    }
    #[test]
    fn invalid_draw_is_atomic_even_after_a_successful_first_layer() {
        let mut s = selector();
        assert_eq!(
            s.event(3282059833, 1, rolls(&[0.0, f64::NAN])),
            Err(Error::InvalidDraw)
        );
        assert_eq!(s.event(3282059833, 1, || 0.0).unwrap()[0].sound, 126431920);
        for draw in [-0.1, 1.0, f64::INFINITY] {
            assert_eq!(s.event(3282059833, 1, || draw), Err(Error::InvalidDraw));
        }
    }
    #[test]
    fn unknown_and_unsupported_graphs_are_explicit_errors() {
        assert_eq!(selector().event(0, 1, || 0.0), Err(Error::UnknownEvent(0)));
        let mut c = ambient_contract().unwrap();
        c.containers[0].continuous = true;
        assert!(matches!(
            Selector::new(c),
            Err(Error::UnsupportedContainer(_))
        ));
    }
}

/// Native draw and playlist semantics for the qualified ambient contract.
/// Caller supplies RNG ownership and action execution order; no voices are admitted.
pub struct NativeSelector {
    contract:Contract,
    history:BTreeMap<(u32,Option<u64>),crate::audio_playlist::Playlist>,
}
impl NativeSelector {
    pub fn new(contract:Contract)->Result<Self,Error> {
        contract.validate()?;
        for action in contract.events.iter().flat_map(|e|&e.actions) {
            let mut rng=crate::audio_random::NativeRandom::seeded(0);
            rng.probability(action.properties.get("16").copied()).map_err(|_|Error::InvalidContract)?;
        }
        for c in &contract.containers {
            // Single-child dispatch bypasses selection in B1D960; supported after qualification.
            if c.playlist.len()<2 {continue;}
            crate::audio_playlist::Playlist::new(c.playlist.iter().map(|p|p.weight as u32).collect(),
                c.playlist.iter().any(|p|p.weight!=50000),c.random_mode==1,c.avoid_repeat).map_err(|_|Error::UnsupportedContainer(c.id))?;
        }
        Ok(Self {contract,history:BTreeMap::new()})
    }
    /// Execute one scheduled action; do not preselect all event actions at posting time.
    pub fn action(&mut self,event:u32,action:u32,owner:u64,rng:&mut crate::audio_random::NativeRandom)->Result<Option<Selection>,Error> {
        let e=self.contract.events.iter().find(|e|e.id==event).ok_or(Error::UnknownEvent(event))?;
        let a=e.actions.iter().find(|a|a.id==action).ok_or(Error::InvalidContract)?;
        if !rng.probability(a.properties.get("16").copied()).map_err(|_|Error::InvalidContract)? {return Ok(None);}
        let c=self.contract.containers.iter().find(|c|c.id==a.target).ok_or(Error::InvalidContract)?;
        let index=if c.playlist.len()==1 {0} else {
            let key=(c.id,if c.global {None} else {Some(owner)});
            let p=self.history.entry(key).or_insert_with(||crate::audio_playlist::Playlist::new(
                c.playlist.iter().map(|p|p.weight as u32).collect(),c.playlist.iter().any(|p|p.weight!=50000),c.random_mode==1,c.avoid_repeat).expect("validated playlist"));
            p.select(rng)
        };
        let sound=self.contract.sounds.iter().find(|s|s.id==c.playlist[index].sound).ok_or(Error::InvalidContract)?;
        Ok(Some(Selection {action:a.id,container:c.id,sound:sound.id,source:sound.source,transition_ms:a.transition_ms}))
    }
}
#[cfg(test)] mod native_tests {
 use super::*;
 #[test] fn explicit_probability_and_absence_keep_different_draw_counts() {
  let c=ambient_contract().unwrap();let event=c.events[1].id;let id=c.events[1].actions[0].id;
  assert!(!c.events[1].actions[0].properties.contains_key("16"));
  let mut rng=crate::audio_random::NativeRandom::seeded(17);let mut expected=rng.clone();expected.draw();
  NativeSelector::new(c.clone()).unwrap().action(event,id,1,&mut rng).unwrap().unwrap();assert_eq!(rng.state(),expected.state());
  let mut c=c;c.events[1].actions[0].properties.insert("16".into(),100.);
  let mut rng=crate::audio_random::NativeRandom::seeded(17);let mut expected=rng.clone();for _ in 0..3 {expected.draw();}
  NativeSelector::new(c).unwrap().action(event,id,1,&mut rng).unwrap().unwrap();assert_eq!(rng.state(),expected.state());
 }
 #[test] fn global_shuffle_keeps_last_sound_excluded_after_reset() {
  let c=ambient_contract().unwrap();let event=c.events[1].id;let action=c.events[1].actions[0].id;
  let mut s=NativeSelector::new(c).unwrap();let mut rng=crate::audio_random::NativeRandom::seeded(17);let mut last=None;
  for owner in 0..48 {let next=s.action(event,action,owner,&mut rng).unwrap().unwrap().sound;assert_ne!(last,Some(next));last=Some(next);}
 }
}
