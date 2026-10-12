//! Local sustained W integration. No burst, attachment, particle or Spell2 caller.
use bevy::prelude::*;
use std::collections::{BTreeMap, BTreeSet};
use crate::{garen_w_state as w, garen_w_material_host as host, Match};

#[derive(Debug, Clone, PartialEq)]
pub struct Visuals(pub w::State);
impl Default for Visuals {
    fn default() -> Self {
        Self(w::State::new(0, openleague_core::attack_presentation::Limits::default().active_sources())
            .expect("positive shared presentation capacity"))
    }
}
impl Visuals { pub fn reset(&mut self, session:u64) { self.0.reset(session); } }

/// Validate all clonable visual consumers before the existing transactional
/// missile journal. After that final accept, commits have no fallible work.
pub fn begin_presentation_epoch(state:&mut Match,session:u64,epoch:u64)->Result<bool,String> {
    let mut attacks=state.attack_visuals.clone();
    let mut vilemaw=state.vilemaw_visuals.clone();
    let mut courage=state.w_visuals.clone();
    let mut missiles=state.missile_journal.clone();
    let a=attacks.begin_epoch(session,epoch)?;
    let v=vilemaw.begin_epoch(session,epoch)?;
    let w=courage.0.begin_epoch(session,epoch)?;
    let m=missiles.begin_epoch(session,epoch).map_err(str::to_owned)?;
    if a!=w || a!=m || a!=v {return Err("presentation journals disagree on connection epoch".into());}
    state.attack_visuals=attacks;state.vilemaw_visuals=vilemaw;state.w_visuals=courage;state.missile_journal=missiles;Ok(a)
}
pub fn accept_presentations(state:&mut Match,snapshot:&openleague_core::Snapshot,now:f64)->Result<bool,String> {
    accept_presentations_ordered(state,snapshot,None,now)
}
/// Call only after Context/epoch, frame freshness and clock bootstrap validation.
pub fn accept_presentations_frame(state:&mut Match,snapshot:&openleague_core::Snapshot,frame:u64,now:f64)->Result<bool,String> {
    accept_presentations_ordered(state,snapshot,Some(frame),now)
}
fn accept_presentations_ordered(state:&mut Match,snapshot:&openleague_core::Snapshot,frame:Option<u64>,now:f64)->Result<bool,String> {
    let mut attacks=state.attack_visuals.clone();
    let mut vilemaw=state.vilemaw_visuals.clone();
    let mut courage=state.w_visuals.clone();
    let attack_accepted=match frame {Some(frame)=>attacks.observe_frame(snapshot,frame,now),None=>attacks.observe(snapshot,now)}
        .map_err(|e|format!("Attack presentation: {e}"))?;
    let w_accepted=match frame {Some(frame)=>courage.0.observe_frame(snapshot,frame,now),None=>courage.0.observe(snapshot,now)}
        .map_err(|e|format!("Courage presentation: {e}"))?;
    let vilemaw_accepted=match frame {Some(frame)=>vilemaw.observe_frame(snapshot,frame,now),None=>vilemaw.observe(snapshot,now)}
        .map_err(|e|format!("Vilemaw presentation: {e}"))?;
    if attack_accepted!=w_accepted || attack_accepted!=vilemaw_accepted {return Err("presentation journals disagree on snapshot order".into());}
    if !attack_accepted {return Ok(false);}
    let missile_accepted=match frame {
        Some(frame)=>state.missile_journal.accept_frame(snapshot.session,frame,snapshot.tick,&snapshot.spell_projectiles),
        None=>state.missile_journal.accept(snapshot.session,snapshot.tick,&snapshot.spell_projectiles),
    }.map_err(|e|format!("Missile observation: {e}"))?;
    if !missile_accepted {
        return Err("missile journal disagrees on snapshot order".into());
    }
    if attacks.error()!=state.attack_visuals.error() {
        if let Some(error)=attacks.error() {warn!("Attack presentation unavailable: {error}");}
    }
    if vilemaw.error()!=state.vilemaw_visuals.error() {
        if let Some(error)=vilemaw.error() {warn!("Vilemaw presentation unavailable: {error}");}
    }
    state.attack_visuals=attacks;
    state.vilemaw_visuals=vilemaw;
    state.w_visuals=courage;
    Ok(true)
}

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Binding { pub root:Entity,pub identity:w::Identity,pub owner:u32 }
#[derive(Debug,Clone,Copy)]
pub struct Desired { pub root:Entity,pub identity:w::Identity }
#[derive(Resource,Default)]
pub struct Bindings {
    pub session:Option<u64>,
    pub active:BTreeMap<u32,Binding>,
    pub failure:Option<String>,
    next_owner:u64,
}
impl Bindings {
    fn clear(&mut self, requests:&mut host::Requests) {
        requests.clear();self.active.clear();
    }
    pub fn reconcile(&mut self,session:Option<u64>,desired:&[Desired],requests:&mut host::Requests)->Result<(),String> {
        if self.session!=session {
            self.clear(requests);self.session=session;self.next_owner=1;self.failure=None;
            if let Some(session)=session {requests.reset(session);}
        }
        let Some(session)=session else {self.clear(requests);return Ok(());};
        if let Some(error)=self.failure.as_ref() {return Err(error.clone());}
        let result=self.reconcile_inner(session,desired,requests);
        if let Err(error)=&result {self.clear(requests);self.failure=Some(error.clone());}
        result
    }
    fn reconcile_inner(&mut self,session:u64,desired:&[Desired],requests:&mut host::Requests)->Result<(),String> {
        if requests.session()!=Some(session) {requests.reset(session);}
        let mut sources=BTreeSet::new();let mut roots=BTreeSet::new();
        for request in desired {
            if request.identity.session!=session || !sources.insert(request.identity.source) || !roots.insert(request.root) {
                return Err("invalid or duplicate Courage material request".into());
            }
        }
        let retired:Vec<_>=self.active.iter().filter(|(source,binding)|!desired.iter().any(|d|
            d.identity.source==**source && d.identity==binding.identity && d.root==binding.root))
            .map(|(source,binding)|(*source,*binding)).collect();
        for (source,binding) in retired {requests.remove_root(binding.root);self.active.remove(&source);}
        for request in desired {
            let source=request.identity.source;
            let binding=if let Some(binding)=self.active.get(&source) {*binding} else {
                let owner=u32::try_from(self.next_owner).ok().filter(|owner|*owner!=0)
                    .ok_or("Courage material owner labels exhausted")?;
                self.next_owner+=1; // u32 range was checked; u64 cannot wrap here.
                let binding=Binding {root:request.root,identity:request.identity,owner};
                self.active.insert(source,binding);binding
            };
            // Idempotent refresh also restores a request dropped while the model loaded.
            requests.insert_base(binding.root,source,binding.owner)?;
        }
        requests.retain_roots(|root,source|self.active.get(&source).is_some_and(|b|b.root==root));
        Ok(())
    }
}

pub fn update_requests(state:Res<Match>,clock:Res<crate::native_effect_clock::EffectClock>,
    mut bindings:ResMut<Bindings>,mut requests:ResMut<host::Requests>) {
    let session=state.snapshot.as_ref().map(|snapshot|snapshot.session);
    let mut desired=Vec::new();
    let clock_failed=clock.diagnostic()["failed"].as_bool().unwrap_or(true);
    if !clock_failed {
        if let Some(snapshot)=state.snapshot.as_ref() {
            for player in &snapshot.players {
                if player.champion!="garen" {continue;}
                let Some(sustained)=state.w_visuals.0.sustained(player.id,clock.now) else {continue;};
                let Some(root)=state.visuals.get(&player.id).copied() else {continue;};
                desired.push(Desired {root,identity:sustained.identity});
            }
        }
    }
    let previous=bindings.failure.clone();
    if let Err(error)=bindings.reconcile(session,&desired,&mut requests) {
        if previous.as_deref()!=Some(error.as_str()) {warn!("Courage material requests unavailable: {error}");}
    }
}

pub fn scope_notice() {
    eprintln!("GAREN_W_SCOPE sustained_only=true identity=committed_cooldown texture_override=local_private_material native_activation_caller=false shader_equivalence=false bursts=false Spell2=false");
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Bindings>().init_resource::<host::Requests>().init_resource::<host::Diagnostics>()
            .init_resource::<crate::garen_w_probe::Probe>()
            .add_systems(Startup,(host::setup,scope_notice))
            .add_systems(Update,(bevy::ecs::schedule::ApplyDeferred,update_requests,host::synchronize).chain()
                .after(crate::receive).after(crate::actor_fow::bind)
                .before(crate::fow_visibility_texture::bind_materials)
                .before(crate::native_high_fog::advance).before(crate::render_probe::capture))
            .add_systems(Update,crate::garen_w_probe::observe.after(host::synchronize)
                .after(crate::fow_visibility_texture::bind_materials)
                .after(crate::native_high_fog::advance).before(crate::render_probe::capture));
    }
}

#[cfg(test)]
#[path="garen_w_live_tests.rs"]
mod tests;
