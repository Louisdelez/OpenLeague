//! Partial reconstructed4.20 E: native scalar values, local point-agent terrain.
//! Circle150/slow360/push180->200 at600 are explicitly documented policies.
//! No native callback, actor footprint, HostE, pillar/VFX/audio/pixel claim.
use crate::*;
use std::sync::OnceLock;

pub const WALL_RADIUS:f32=150.;
pub const SLOW_RADIUS:f32=360.;
pub const PUSH_QUERY:f32=180.;
pub const PUSH_LANDING:f32=200.;
pub const PUSH_SPEED:f32=600.;
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct Pillar {pub owner:u32,pub team:u8,pub center:Point,pub rank:u8,pub started:u64,pub until:u64}
#[derive(Debug,Clone,Serialize,Deserialize)]
pub struct VisiblePillar {pub owner:u32,pub starts:u64,pub until:u64,pub center:Point}
#[derive(Debug,Clone,Copy,PartialEq,Eq,Serialize,Deserialize)]
pub struct ForcedMovement {pub started:u64,pub until:u64}
#[derive(Debug,Clone)]
pub struct Push {pub owner:u32,pub source_started:u64,pub origin:Point,pub from:Point,pub started:u64,pub until:u64,pub destination:Point,last_position:Point}
#[derive(Debug,Default)]
pub(crate) struct State {pub pillars:BTreeMap<u32,Pillar>,pub pushes:BTreeMap<u32,Push>,pub blocked_intrusion:Option<(u32,u64)>}
#[derive(Debug,Clone,Copy)]
pub struct Rank {pub cost:f32,pub cooldown:f32,pub range:f32,pub duration:u64,pub slow:f32}
fn number(v:&serde_json::Value,key:&str)->Result<f32,String> {
    let v=v.get(key).ok_or_else(||format!("Trundle E native field absent:{key}"))?;
    let n=if let Some(n)=v.as_f64(){n as f32}else if let Some(s)=v.as_str(){s.parse::<f32>().map_err(|_|"invalid Trundle E native number")?}else{return Err("Trundle E field is not numeric".into())};
    if !n.is_finite(){return Err("nonfinite Trundle E native number".into())} Ok(n)
}
fn parse(text:&str)->Result<[Rank;5],String> {
    let rows:serde_json::Value=serde_json::from_str(text).map_err(|e|e.to_string())?;
    let rows=rows.as_array().ok_or("Trundle E table is not array")?;
    let found:Vec<_>=rows.iter().filter(|r|r["champion"].as_str().is_some_and(|s|s.eq_ignore_ascii_case("trundle"))&&r["slot"].as_u64()==Some(2)).collect();
    if found.len()!=1||found[0]["spell"]!="TrundleCircle"{return Err("unique native Trundle E resource required".into())}
    let v=&found[0]["values"];let mut out=Vec::new();
    for n in 1..=5 {
        let cost=number(v,&format!("ManaCost{n}"))?;let cd=number(v,&format!("Cooldown{n}"))?;
        let range=number(v,&format!("CastRange{n}"))?;let seconds=number(v,&format!("Effect1Level{n}Amount"))?;
        let slow=number(v,&format!("Effect2Level{n}Amount"))?;
        if cost!=60.||cd!=[23.,20.,17.,14.,11.][n-1]||range!=1000.||seconds!=6.||slow!=[25.,30.,35.,40.,45.][n-1] {return Err("verified Trundle E native scalar changed".into())}
        out.push(Rank{cost,cooldown:cd,range,duration:6*TICK_RATE,slow:slow/100.});
    }
    out.try_into().map_err(|_|"Trundle E rank count".into())
}
pub fn rules(rank:u8)->Result<Rank,String> {
    if !(1..=5).contains(&rank){return Err("invalid Trundle E rank".into())}
    static R:OnceLock<Result<[Rank;5],String>>=OnceLock::new();
    let rows=R.get_or_init(||parse(include_str!("../../../data/4.20/native_spells_420.json")));
    match rows {Ok(r)=>Ok(r[rank as usize-1]),Err(e)=>Err(e.clone())}
}
fn healthy(h:f32)->bool {h.is_finite()&&h>0.}
fn active(push:&Option<ForcedMovement>,tick:u64)->bool {push.as_ref().is_some_and(|p|p.started<=tick&&tick<p.until&&p.until-p.started<=11)}
fn receipt(push:&Push)->ForcedMovement {ForcedMovement{started:push.started,until:push.until}}
pub fn champion_forced(p:&Champion,tick:u64)->bool {healthy(p.health)&&active(&p.effects.trundle_e_push,tick)}
pub fn unit_forced(u:&world::Unit,tick:u64)->bool {healthy(u.health)&&active(&u.trundle_e_push,tick)}
fn eligible(kind:world::Kind)->bool {!kind.structure()&&kind!=world::Kind::Boss}

impl Simulation {
    pub(crate) fn trundle_e_projection(&self,team:Option<u8>)->Vec<VisiblePillar> {
        // Debug snapshot is omniscient; every normal network export passes its
        // viewer team. A pillar is NOT a vision provider or sight blocker.
        self.trundle_e.pillars.values().filter(|p|self.trundle_e_live(p))
            .filter(|p|team.is_none_or(|team|p.team==team||self.visible_point_to(team,p.center)))
            .map(|p|VisiblePillar{owner:p.owner,starts:p.started,until:p.until,center:p.center}).collect()
    }
    fn trundle_e_live(&self,p:&Pillar)->bool {self.winner.is_none()&&p.started<=self.tick&&self.tick<p.until&&p.center.finite()&&self.players.contains_key(&p.owner)}
    pub(crate) fn trundle_e_circles(&self)->Vec<pillar_navigation::Circle> {
        self.trundle_e.pillars.values().filter(|p|self.trundle_e_live(p)).map(|p|pillar_navigation::Circle{center:p.center,radius:WALL_RADIUS}).collect()
    }
    pub(crate) fn dynamic_path(&self,start:Point,end:Point)->Option<VecDeque<Point>> {pillar_navigation::path(&self.navigation,start,end,&self.trundle_e_circles())}
    pub(crate) fn dynamic_nearest(&self,p:Point)->Option<Point> {pillar_navigation::nearest_walkable(&self.navigation,p,&self.trundle_e_circles())}
    pub(crate) fn dynamic_ground(&self,p:Point)->Option<f32> {
        let circles=self.trundle_e_circles();
        if circles.is_empty()||pillar_navigation::point_allowed(&self.navigation,p,&circles){self.navigation.ground(p)}else{None}
    }
    pub(crate) fn trundle_e_slow(&self,id:u32)->f32 {
        let actor=if let Some(p)=self.players.get(&id){(p.position,p.health,p.team)}
            else if let Some(u)=self.units.get(&id).filter(|u|eligible(u.kind)){(u.position,u.health,u.team)}else{return 0.};
        if !healthy(actor.1)||!actor.0.finite(){return 0.}
        self.trundle_e.pillars.values().filter(|p|self.trundle_e_live(p)&&p.team!=actor.2&&actor.0.distance(p.center)<=SLOW_RADIUS)
            .filter_map(|p|rules(p.rank).ok().map(|r|r.slow)).fold(0.,f32::max)
    }
    fn trundle_e_targets(&self)->Vec<(u32,Point)> {
        let mut out:Vec<_>=self.players.values().filter(|p|healthy(p.health)&&p.position.finite()).map(|p|(p.id,p.position)).collect();
        out.extend(self.units.values().filter(|u|eligible(u.kind)&&healthy(u.health)&&u.position.finite()).map(|u|(u.id,u.position)));
        out.sort_by_key(|r|r.0);out
    }
    fn plan_trundle_e_push(&self,owner:u32,source_started:u64,center:Point,caster:Point,id:u32,from:Point)->Result<Push,String> {
        let mut x=f64::from(from.x)-f64::from(center.x);let mut z=f64::from(from.z)-f64::from(center.z);
        let mut d=x.hypot(z);
        if d==0. {x=f64::from(from.x)-f64::from(caster.x);z=f64::from(from.z)-f64::from(caster.z);d=x.hypot(z);}
        if d==0. {x=1.;z=0.;d=1.;}
        let destination=Point{x:(f64::from(center.x)+x/d*f64::from(PUSH_LANDING))as f32,z:(f64::from(center.z)+z/d*f64::from(PUSH_LANDING))as f32};
        let circles:Vec<_>=self.trundle_e.pillars.values().filter(|p|self.trundle_e_live(p)&&!(p.owner==owner&&p.started==source_started))
            .map(|p|pillar_navigation::Circle{center:p.center,radius:WALL_RADIUS}).collect();
        // The origin pillar is the sole excluded obstacle while escaping it.
        if !destination.finite()||!pillar_navigation::segment_allowed(&self.navigation,from,destination,&circles) {return Err(format!("Trundle E push has no legal terrain/other-pillar segment:{id}"))}
        let distance=(f64::from(destination.x)-f64::from(from.x)).hypot(f64::from(destination.z)-f64::from(from.z));
        let steps=(distance/(f64::from(PUSH_SPEED)/TICK_RATE as f64)).ceil().max(1.);
        if !steps.is_finite()||steps>11. {return Err("Trundle E push bound exceeded".into())}
        let until=self.tick.checked_add(steps as u64).ok_or("Trundle E push clock overflow")?;
        Ok(Push{owner,source_started,origin:center,from,started:self.tick,until,destination,last_position:from})
    }
    fn commit_trundle_e_push(&mut self,id:u32,push:Push) {
        let source_team=self.players.get(&push.owner).map(|p|p.team);
        let marker=receipt(&push);self.trundle_e.pushes.insert(id,push);
        if self.players.contains_key(&id) {
            self.cancel_attack_presentation(id,attack_presentation::CancelReason::Control);
            let p=self.players.get_mut(&id).unwrap();p.windup=None;p.path.clear();p.destination=None;p.target=None;p.effects.trundle_e_push=Some(marker);
            // Accepted non-damaging enemy ability effect: native Garen Perseverance interruption.
            // The living target was preflighted; keep this commit free of fallible operations.
            if p.champion=="garen"&&source_team.is_some_and(|team|team!=p.team) {p.perseverance_interrupted_at=Some(self.tick);}
        } else if self.units.contains_key(&id) {
            self.interrupt_unit_windup(id);
            let u=self.units.get_mut(&id).unwrap();u.path.clear();u.destination=None;u.target=None;u.trundle_e_push=Some(marker);if let Some(pet)=u.pet.as_mut(){pet.order=annie_r::Order::Follow;}u.next_ai=self.tick;
        }
    }
    pub(crate) fn cast_trundle_e_at(&mut self,id:u32,point:Point)->Result<(),String> {
        if self.winner.is_some(){return Err("match ended".into())}
        if !point.finite(){return Err("invalid Trundle E point".into())}
        let p=self.players.get(&id).ok_or("unknown player")?;
        if p.champion!="trundle"{return Err("Trundle E requires Trundle".into())}
        if champion_forced(p,self.tick){return Err("champion in forced movement".into())}
        if !healthy(p.health)||!p.position.finite(){return Err("invalid living Trundle E caster".into())}
        if stuns::active(p,self.tick){return Err("champion stunned".into())}
        if self.tick<p.effects.silence_until{return Err("champion silenced".into())}
        let r=rules(p.ranks[2])?;
        if self.tick<p.cooldowns[2]{return Err("skill on cooldown".into())}
        if !p.mana.is_finite()||p.mana<r.cost{return Err("insufficient mana".into())}
        if p.windup.as_ref().is_some_and(|w|!w.cancelable){return Err("attack windup cannot be cancelled".into())}
        let distance=p.position.distance(point);
        if !distance.is_finite()||distance>r.range||self.navigation.ground(point).is_none(){return Err("invalid Trundle E map center/range".into())}
        if self.trundle_e.pillars.values().filter(|v|self.trundle_e_live(v)).count()>=6||self.trundle_e.pillars.get(&id).is_some_and(|v|self.trundle_e_live(v)){return Err("Trundle E pillar capacity occupied".into())}
        let reduction=self.stats(id).cooldown_reduction;if !reduction.is_finite(){return Err("invalid cooldown reduction".into())}
        let cd=cooldown::ticks(r.cooldown,reduction);let ready=self.tick.checked_add(cd).ok_or("Trundle E cooldown clock overflow")?;
        let until=self.tick.checked_add(r.duration).ok_or("Trundle E pillar clock overflow")?;
        let caster=p.position;let team=p.team;
        let mut planned=Vec::new();
        for (target,from)in self.trundle_e_targets().into_iter().filter(|(_,from)|from.distance(point)<=PUSH_QUERY){planned.push((target,self.plan_trundle_e_push(id,self.tick,point,caster,target,from)?));}
        // No fallible operation after this point. Source snapshots/cancel refer
        // only to unresolved attack state, not a released projectile or Rdrain.
        let captured=self.capture_attack_presentation(id);
        self.cancel_captured_attack_presentation(captured,attack_presentation::CancelReason::OtherCast);
        let p=self.players.get_mut(&id).unwrap();p.windup=None;p.mana-=r.cost;p.cooldowns[2]=ready;p.cooldown_totals[2]=Some(cd);
        self.trundle_e.pillars.insert(id,Pillar{owner:id,team,center:point,rank:p.ranks[2],started:self.tick,until});
        for (target,push)in planned{self.commit_trundle_e_push(target,push)}
        Ok(())
    }
    pub(crate) fn clear_trundle_e(&mut self) {
        self.trundle_e.pillars.clear();self.trundle_e.pushes.clear();self.trundle_e.blocked_intrusion=None;
        for p in self.players.values_mut(){p.effects.trundle_e_push=None;}
        for u in self.units.values_mut(){u.trundle_e_push=None;}
    }
    pub(crate) fn remove_trundle_e_owner(&mut self,id:u32) {
        self.trundle_e.pillars.remove(&id);
        let removed:Vec<_>=self.trundle_e.pushes.iter().filter(|(target,q)|**target==id||q.owner==id).map(|(target,_)|*target).collect();
        self.trundle_e.pushes.retain(|target,q|*target!=id&&q.owner!=id);
        for p in self.players.values_mut(){if removed.contains(&p.id){p.effects.trundle_e_push=None;}}
        for u in self.units.values_mut(){if removed.contains(&u.id){u.trundle_e_push=None;}}
    }
    pub(crate) fn advance_trundle_e(&mut self) {
        if self.winner.is_some(){self.clear_trundle_e();return;}
        let living_owners:Vec<_>=self.players.keys().copied().collect();
        self.trundle_e.pillars.retain(|_,p|p.started<=self.tick&&self.tick<p.until&&living_owners.contains(&p.owner));
        let pushes:Vec<_>=self.trundle_e.pushes.iter().map(|(id,q)|(*id,q.clone())).collect();
        for (id,push)in pushes {
            let actor=self.players.get(&id).map(|p|(p.position,p.health,p.effects.trundle_e_push)).or_else(||self.units.get(&id).map(|u|(u.position,u.health,u.trundle_e_push)));
            let live=self.trundle_e.pillars.get(&push.owner).is_some_and(|p|p.started==push.source_started&&self.trundle_e_live(p));
            let mut moved=None;let mut keep=false;
            if let Some((position,health,_))=actor.filter(|(position,h,marker)|healthy(*h)&&*marker==Some(receipt(&push))&&*position==push.last_position).filter(|_|live&&push.started<=self.tick&&push.until>push.started&&push.until-push.started<=11&&push.origin.finite()&&push.from.finite()&&push.destination.finite()) {
                let dx=f64::from(push.destination.x)-f64::from(push.from.x);let dz=f64::from(push.destination.z)-f64::from(push.from.z);let distance=dx.hypot(dz);
                if distance.is_finite()&&distance>0. {
                    let fraction=((self.tick-push.started)as f64*(f64::from(PUSH_SPEED)/TICK_RATE as f64)/distance).min(1.);
                    let next=Point{x:(f64::from(push.from.x)+dx*fraction)as f32,z:(f64::from(push.from.z)+dz*fraction)as f32};
                    let circles:Vec<_>=self.trundle_e.pillars.values().filter(|p|self.trundle_e_live(p)&&!(p.owner==push.owner&&p.started==push.source_started)).map(|p|pillar_navigation::Circle{center:p.center,radius:WALL_RADIUS}).collect();
                    if pillar_navigation::segment_allowed(&self.navigation,position,next,&circles) {moved=Some(next);keep=fraction<1.&&self.tick<push.until;}
                    else{self.trundle_e.blocked_intrusion=Some((id,self.tick));}
                }
                let _=health;
            }
            if keep {if let Some(next)=moved {if let Some(stored)=self.trundle_e.pushes.get_mut(&id){stored.last_position=next;}}} else {self.trundle_e.pushes.remove(&id);}
            if let Some(p)=self.players.get_mut(&id){if let Some(next)=moved{p.position=next;p.height=self.navigation.ground(next).unwrap();}if !keep{p.effects.trundle_e_push=None;}}
            else if let Some(u)=self.units.get_mut(&id){if let Some(next)=moved{u.position=next;u.height=self.navigation.ground(next).unwrap();}if !keep{u.trundle_e_push=None;}}
        }
        // Late spawn/respawn intrusion is separate from an instant cast. No
        // illegal teleport: blocked actors remain stopped and diagnostically
        // retry until an escape is legal or the terrain expires.
        let pillars:Vec<_>=self.trundle_e.pillars.values().cloned().collect();
        for (id,position)in self.trundle_e_targets() {
            if self.players.get(&id).is_some_and(|p|champion_forced(p,self.tick))||self.units.get(&id).is_some_and(|u|unit_forced(u,self.tick)){continue;}
            if let Some(pillar)=pillars.iter().find(|p|position.distance(p.center)<WALL_RADIUS){
                let caster=self.players.get(&pillar.owner).map_or(pillar.center,|p|p.position);
                match self.plan_trundle_e_push(pillar.owner,pillar.started,pillar.center,caster,id,position){Ok(push)=>self.commit_trundle_e_push(id,push),Err(_)=>self.trundle_e.blocked_intrusion=Some((id,self.tick))}
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn arena()->Simulation {
        let mut b=Vec::new();for _ in 0..6400{b.extend(0f32.to_le_bytes());b.extend(0u16.to_le_bytes());b.extend(0u32.to_le_bytes());b.push(1);}
        Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&b).unwrap()).unwrap()
    }
    fn game()->(Simulation,u32,u32) {
        let mut s=arena();let a=s.join("trundle").unwrap();let b=s.join("garen").unwrap();
        for(id,x)in[(a,1000.),(b,1500.)]{let p=s.players.get_mut(&id).unwrap();p.position=Point{x,z:1500.};p.health=5000.;p.max_health=5000.;p.mana=500.;p.level=18;}
        s.players.get_mut(&a).unwrap().ranks=[1,1,1,1];(s,a,b)
    }
    fn point(x:f32)->Point{Point{x,z:1500.}}
    fn cast(s:&mut Simulation,a:u32,x:f32){s.command(a,Action::CastAt{slot:2,point:point(x)}).unwrap();}
    fn unit(id:u32,team:u8,kind:world::Kind,x:f32)->world::Unit {
        serde_json::from_value(serde_json::json!({"id":id,"name":"pillarfixture","definition":"pillarfixture","kind":kind,"team":team,"position":point(x),"height":0.,"facing":1.,"health":5000.,"max_health":5000.,"damage":10.,"armor":10.,"magic_resist":10.,"gold":0.,"experience":0.,"target":null,"destination":null,"next_attack":0,"silence_until":0,"respawn_at":null})).unwrap()
    }
    #[test] fn strict_native_ranks_and_learning_reject_missing_duplicate_and_changed_data() {
        for rank in 1..=5{let r=rules(rank).unwrap();assert_eq!((r.cost,r.cooldown,r.range,r.duration),(60.,[23.,20.,17.,14.,11.][rank as usize-1],1000.,180));assert_eq!(r.slow,[0.25,0.30,0.35,0.40,0.45][rank as usize-1]);}
        for rank in[0,6,255]{assert!(rules(rank).is_err());}
        let source=include_str!("../../../data/4.20/native_spells_420.json");
        for case in 0..4{let mut v:serde_json::Value=serde_json::from_str(source).unwrap();let rows=v.as_array_mut().unwrap();let i=rows.iter().position(|r|r["spell"]=="TrundleCircle").unwrap();
            match case{0=>{rows[i]["values"].as_object_mut().unwrap().remove("Cooldown1");},1=>{let extra=rows[i].clone();rows.push(extra);},2=>rows[i]["values"]["Effect2Level1Amount"]=serde_json::json!("NaN"),_=>rows[i]["values"]["CastRange1"]=serde_json::json!(999)}
            assert!(parse(&v.to_string()).is_err());}
        let(mut s,a,_)=game();s.players.get_mut(&a).unwrap().ranks=[0;4];
        for rank in 1..=5{s.players.get_mut(&a).unwrap().level=2*rank-1;s.command(a,Action::Learn{slot:2}).unwrap();assert_eq!(s.players[&a].ranks[2],rank);assert!(s.command(a,Action::Learn{slot:2}).is_err());}
    }
    #[test] fn invalid_e_casts_are_atomic_before_mana_cooldown_cancel_and_terrain() {
        for case in 0..13{let(mut s,a,b)=game();let mut center=point(1500.);match case{
            0=>s.players.get_mut(&a).unwrap().ranks[2]=0,1=>s.players.get_mut(&a).unwrap().mana=59.,2=>s.players.get_mut(&a).unwrap().mana=f32::NAN,
            3=>s.players.get_mut(&a).unwrap().health=0.,4=>s.players.get_mut(&a).unwrap().health=f32::NAN,5=>s.players.get_mut(&a).unwrap().cooldowns[2]=1,
            6=>s.players.get_mut(&a).unwrap().effects.silence_until=1,7=>s.grant_stun(Some(b),a,"fixture",10).unwrap(),8=>center.x=f32::NAN,
            9=>center.x=2000.25,10=>center.x=-1.,11=>s.tick=u64::MAX-100,_=>s.players.get_mut(&a).unwrap().champion="garen".into()}
            let before=serde_json::to_value(&s.players).unwrap();let facts=s.snapshot().attack_events;
            assert!(s.cast_trundle_e_at(a,center).is_err());assert_eq!(serde_json::to_value(&s.players).unwrap(),before);assert!(s.trundle_e.pillars.is_empty());assert_eq!(s.snapshot().attack_events,facts);}
        let(mut s,a,_)=game();assert!(s.cast_trundle_e_at(999,point(1500.)).is_err());assert!(s.cast(a,2,None).is_err());assert!(s.cast(a,2,Some(a)).is_err());
    }
    #[test] fn full_push_preflight_rejects_unwalkable_landing_without_partial_cast() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=point(400.);s.players.get_mut(&b).unwrap().position=point(50.);
        let before=serde_json::to_value(&s.players).unwrap();assert!(s.cast_trundle_e_at(a,point(100.)).is_err());assert_eq!(serde_json::to_value(&s.players).unwrap(),before);assert!(s.trundle_e.pillars.is_empty());
    }
    #[test] fn accepted_e_commits_native_cost_cd_and_closed_range_once() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=point(2500.);cast(&mut s,a,2000.);
        assert_eq!(s.players[&a].mana,440.);assert_eq!(s.players[&a].cooldowns[2],690);assert_eq!(s.players[&a].cooldown_totals[2],Some(690));
        assert_eq!(s.trundle_e.pillars[&a].center,point(2000.));assert_eq!(s.trundle_e.pillars[&a].until,180);
        let before=serde_json::to_value(&s.players).unwrap();assert!(s.cast_trundle_e_at(a,point(1800.)).is_err());assert_eq!(serde_json::to_value(&s.players).unwrap(),before);
    }
    #[test] fn forced_motion_is_not_stun_or_fake_order_and_preserves_roll_cadence_qwr() {
        let(mut s,a,b)=game();let target=s.join("ashe").unwrap();s.players.get_mut(&target).unwrap().position=point(1550.);
        s.command(b,Action::Attack{target}).unwrap();s.advance_attacks();assert!(s.players[&b].windup.is_some());s.players.get_mut(&b).unwrap().attack_roll=Some(true);let cadence=s.players[&b].next_attack;
        let before_projectiles=serde_json::to_value(&s.projectiles).unwrap();cast(&mut s,a,1500.);
        assert!(champion_forced(&s.players[&b],s.tick));assert!(s.players[&b].stuns.is_empty());assert!(s.players[&b].destination.is_none());assert!(s.players[&b].windup.is_none());assert_eq!(s.players[&b].attack_roll,Some(true));assert_eq!(s.players[&b].next_attack,cadence);
        assert!(s.command(b,Action::Move{point:point(1900.)}).is_err());assert!(s.command(b,Action::Attack{target}).is_err());assert!(s.command(b,Action::Stop).is_err());
        for tick in 1..=10{s.tick=tick;s.advance_trundle_e();assert_eq!(s.players[&b].position,point(1500.+20.*tick as f32));}
        assert!(!champion_forced(&s.players[&b],10));assert_eq!(serde_json::to_value(&s.projectiles).unwrap(),before_projectiles);assert_eq!(s.players[&b].attack_roll,Some(true));assert_eq!(s.players[&b].next_attack,cadence);
        let cancels=s.snapshot().attack_events.into_iter().filter(|e|e.attack.source==b&&matches!(e.phase,attack_presentation::Phase::Cancelled{reason:attack_presentation::CancelReason::Control})).count();assert_eq!(cancels,1);
    }
    #[test] fn ally_push_and_enemy_unit_slow_exclude_structures_and_bosses() {
        let(mut s,a,b)=game();let ally=s.join("ashe").unwrap();assert_eq!(s.players[&ally].team,s.players[&a].team);s.players.get_mut(&ally).unwrap().position=point(1580.);
        for(id,kind)in[(50,world::Kind::Melee),(51,world::Kind::Monster),(52,world::Kind::Pet),(53,world::Kind::Turret),(54,world::Kind::Boss)]{s.units.insert(id,unit(id,2,kind,1550.));}
        cast(&mut s,a,1500.);assert!(champion_forced(&s.players[&ally],0));assert_eq!(s.trundle_e_slow(ally),0.);assert_eq!(s.trundle_e_slow(b),0.25);
        for id in 50..=52{assert!(unit_forced(&s.units[&id],0));assert_eq!(s.trundle_e_slow(id),0.25);}
        for id in 53..=54{assert!(!unit_forced(&s.units[&id],0));assert_eq!(s.trundle_e_slow(id),0.);}
    }
    #[test] fn source_scoped_slow_exits_exactly_and_uses_common_strongest_policy() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=point(1860.);let base=s.movement_speed(b);cast(&mut s,a,1500.);assert_eq!(s.trundle_e_slow(b),0.25);assert!(s.movement_speed(b)<base);
        s.grant_slow(b,"other",0.5,300).unwrap();let other=s.movement_speed(b);s.players.get_mut(&b).unwrap().position=point(1860.25);assert_eq!(s.trundle_e_slow(b),0.);assert_eq!(s.movement_speed(b),other);
        s.players.get_mut(&b).unwrap().position=point(1860.);s.tick=180;s.advance_trundle_e();assert_eq!(s.trundle_e_slow(b),0.);assert_eq!(s.players[&b].slows.len(),1);
    }
    #[test] fn terrain_survives_caster_death_without_respawn_extension_but_not_departure_or_end() {
        let(mut s,a,_)=game();cast(&mut s,a,1500.);s.players.get_mut(&a).unwrap().health=0.;s.tick=30;s.advance_trundle_e();assert_eq!(s.trundle_e.pillars[&a].until,180);
        s.players.get_mut(&a).unwrap().health=5000.;s.players.get_mut(&a).unwrap().effects=Default::default();s.tick=179;s.advance_trundle_e();assert_eq!(s.trundle_e.pillars.len(),1);s.tick=180;s.advance_trundle_e();assert!(s.trundle_e.pillars.is_empty());
        let(mut s,a,_)=game();cast(&mut s,a,1500.);s.remove_player(a);assert!(s.trundle_e.pillars.is_empty());assert!(s.players.values().all(|p|p.effects.trundle_e_push.is_none()));
        let(mut s,a,_)=game();cast(&mut s,a,1500.);s.winner=Some(0);s.advance_trundle_e();assert!(s.trundle_e.pillars.is_empty());
    }
    #[test] fn existing_champion_path_stops_at_new_terrain_and_detours_on_replan() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=Point{x:1500.,z:2200.};s.players.get_mut(&b).unwrap().position=point(1000.);
        s.command(b,Action::Move{point:point(2000.)}).unwrap();cast(&mut s,a,1500.);
        for _ in 0..80{s.advance();assert!(s.players[&b].position.distance(point(1500.))>=WALL_RADIUS);}
        assert!(s.players[&b].position.x<1500.);s.command(b,Action::Move{point:point(2000.)}).unwrap();assert!(s.players[&b].path.iter().any(|p|p.z!=1500.));
    }
    #[test] fn npc_existing_path_uses_dynamic_segment_guard_and_enemy_speed_factor() {
        let(mut s,a,_)=game();s.enable_map10().unwrap();s.players.get_mut(&a).unwrap().position=Point{x:1500.,z:2200.};
        let definition=s.world.as_ref().unwrap().config.definitions.iter().find(|(_,d)|d.kind==world::Kind::Monster&&d.move_speed>0.).map(|(k,_)|k.clone()).unwrap();
        let mut u=unit(500,2,world::Kind::Monster,1000.);u.definition=definition;u.path=VecDeque::from([point(2000.)]);u.destination=Some(point(2000.));u.next_ai=u64::MAX;s.units.insert(500,u);cast(&mut s,a,1500.);
        for tick in 1..=80{s.tick=tick;s.advance_trundle_e();s.advance_world();assert!(s.units[&500].position.distance(point(1500.))>=WALL_RADIUS);}
        assert!(s.units[&500].position.x<1500.);assert!(s.units[&500].path.is_empty());assert_eq!(s.trundle_e_slow(500),0.25);
    }
    #[test] fn e_and_incoming_push_do_not_clear_live_r_drain_or_other_spell_records() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=point(1300.);s.players.get_mut(&b).unwrap().position=point(1400.);
        s.cast(a,3,Some(b)).unwrap();let drain=serde_json::to_value(&s.players[&a].effects.trundle_r).unwrap();s.players.get_mut(&a).unwrap().attack_roll=Some(true);s.players.get_mut(&a).unwrap().effects.trundle_q.armed_rank=1;s.players.get_mut(&a).unwrap().effects.trundle_q.armed_until=100;
        cast(&mut s,a,1400.);assert_eq!(serde_json::to_value(&s.players[&a].effects.trundle_r).unwrap(),drain);assert_eq!(s.players[&a].effects.trundle_q.armed_rank,1);assert_eq!(s.players[&a].attack_roll,Some(true));
        for tick in 1..=30{s.tick=tick;s.advance_trundle_e();s.advance_trundle_r();}assert_eq!(s.players[&a].effects.trundle_r.as_ref().unwrap().pulses,1);
    }
    #[test] fn absent_pillar_preserves_old_path_speed_and_omits_optional_network_fields() {
        let(s,a,_)=game();assert_eq!(s.dynamic_path(point(1000.),point(2000.)),s.navigation.path(point(1000.),point(2000.)));assert_eq!(s.dynamic_nearest(point(4020.)),s.navigation.nearest_walkable(point(4020.)));
        let p=&s.players[&a];let flat=s.definitions[&p.champion].move_speed+shop::bonuses(p).move_speed;assert_eq!(s.movement_speed(a),movement::effective_speed(p,flat,s.tick));
        let value=serde_json::to_value(p).unwrap();assert!(value["effects"].get("trundle_e_push").is_none());let u=unit(500,2,world::Kind::Monster,1200.);assert!(serde_json::to_value(u).unwrap().get("trundle_e_push").is_none());
    }
    #[test] fn forced_marker_exposes_no_owner_or_geometry_and_enemy_pillar_needs_current_vision() {
        let(mut s,a,b)=game();s.enable_map10().unwrap();s.units.clear();
        s.players.get_mut(&b).unwrap().vision_radius_modifiers.flat_bubble_radius_mod=-10000.;cast(&mut s,a,1500.);
        let own=s.snapshot_for(a).unwrap();assert_eq!(own.trundle_e_pillars.len(),1);
        let hidden=s.snapshot_for(b).unwrap();assert!(hidden.trundle_e_pillars.is_empty());assert!(!hidden.players.iter().any(|p|p.id==a));
        let marker=serde_json::to_value(hidden.players.iter().find(|p|p.id==b).unwrap().effects.trundle_e_push).unwrap();let keys=marker.as_object().unwrap();
        assert_eq!(keys.len(),2);assert!(keys.contains_key("started")&&keys.contains_key("until"));
        s.players.get_mut(&b).unwrap().vision_radius_modifiers=Default::default();assert_eq!(s.snapshot_for(b).unwrap().trundle_e_pillars.len(),1);
        s.players.get_mut(&b).unwrap().position=point(3900.);assert!(s.snapshot_for(b).unwrap().trundle_e_pillars.is_empty());
        s.tick=180;assert!(s.snapshot_for(a).unwrap().trundle_e_pillars.is_empty());
    }
    #[test] fn quantized_diagonal_destination_uses_checked_bounded_motion_without_epsilon() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().position=Point{x:1200.,z:1200.};s.players.get_mut(&b).unwrap().position=point(1500.);
        cast(&mut s,a,1500.);let push=s.trundle_e.pushes[&b].clone();assert!(push.until>push.started&&push.until-push.started<=11);
        for tick in 1..=push.until{s.tick=tick;s.advance_trundle_e();}
        assert_eq!(s.players[&b].position,push.destination);assert!(s.players[&b].position.distance(push.origin)>=WALL_RADIUS);assert!(s.players[&b].effects.trundle_e_push.is_none());
    }

    #[test] fn new_cast_summoner_and_item_commands_cannot_retarget_a_live_push() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().health=4000.;s.players.get_mut(&a).unwrap().summoners.spells[0]=Some(summoners::Spell::Heal);
        s.players.get_mut(&a).unwrap().inventory[0]=Some(2003);s.players.get_mut(&a).unwrap().inventory_counts[0]=1;cast(&mut s,a,1100.);
        assert!(champion_forced(&s.players[&a],0));s.players.get_mut(&a).unwrap().attack_roll=Some(true);
        let before=serde_json::to_value(&s.players).unwrap();
        for action in [Action::Move{point:point(1900.)},Action::Attack{target:b},Action::Stop,Action::Cast{slot:0,target:None},Action::Cast{slot:3,target:Some(b)},Action::CastAt{slot:1,point:point(1500.)},Action::CastAt{slot:2,point:point(1500.)},Action::Summoner{slot:0},Action::SummonerTarget{slot:0,target:None},Action::UseItem{slot:0}] {
            assert_eq!(s.command(a,action).unwrap_err(),"champion in forced movement");assert_eq!(serde_json::to_value(&s.players).unwrap(),before);
        }
        assert_eq!(s.cast(a,0,None).unwrap_err(),"champion in forced movement");assert_eq!(s.cast_at(a,1,point(1500.)).unwrap_err(),"champion in forced movement");
        assert_eq!(s.cast_summoner(a,0).unwrap_err(),"champion in forced movement");assert_eq!(s.use_item(a,0).unwrap_err(),"champion in forced movement");assert_eq!(serde_json::to_value(&s.players).unwrap(),before);
        // Flash has no current enum/implementation: this is an explicit parser
        // rejection, not a fabricated successful Flash gameplay test.
        assert!(serde_json::from_value::<summoners::Spell>(serde_json::json!("Flash")).is_err());
    }
    #[test] fn unexpected_external_position_change_clears_old_push_instead_of_snapping_back() {
        let(mut s,a,b)=game();cast(&mut s,a,1500.);assert!(s.trundle_e.pushes.contains_key(&b));s.players.get_mut(&b).unwrap().position=point(3000.);
        s.tick=1;s.advance_trundle_e();assert_eq!(s.players[&b].position,point(3000.));assert!(!s.trundle_e.pushes.contains_key(&b));assert!(s.players[&b].effects.trundle_e_push.is_none());
    }


    #[test] fn enemy_push_interrupts_perseverance_once_without_damage() {
        let(mut s,a,b)=game();s.tick=100;s.players.get_mut(&b).unwrap().level=1;
        assert_ne!(s.players[&a].team,s.players[&b].team);assert!(s.garen_passive_per_second(b)>0.);
        let hp=s.players[&b].health;cast(&mut s,a,1500.);
        assert!(champion_forced(&s.players[&b],100));assert_eq!(s.players[&b].health,hp);
        assert_eq!(s.players[&b].perseverance_interrupted_at,Some(100));assert_eq!(s.garen_passive_per_second(b),0.);
        for tick in 101..=110{s.tick=tick;s.advance_trundle_e();assert_eq!(s.players[&b].perseverance_interrupted_at,Some(100));assert_eq!(s.players[&b].health,hp);}
        s.tick=369;assert_eq!(s.garen_passive_per_second(b),0.);s.tick=370;assert!(s.garen_passive_per_second(b)>0.);
    }
    #[test] fn ally_push_and_unaffected_garen_preserve_perseverance() {
        let(mut s,a,b)=game();let ally=s.join("garen").unwrap();
        assert_eq!(s.players[&ally].team,s.players[&a].team);s.players.get_mut(&ally).unwrap().position=point(1550.);
        s.players.get_mut(&b).unwrap().position=point(3000.);s.tick=100;
        let ally_hp=s.players[&ally].health;let enemy_hp=s.players[&b].health;cast(&mut s,a,1500.);
        assert!(champion_forced(&s.players[&ally],100));assert!(s.players[&ally].perseverance_interrupted_at.is_none());
        assert!(s.players[&b].perseverance_interrupted_at.is_none());assert!(!champion_forced(&s.players[&b],100));
        assert_eq!(s.players[&ally].health,ally_hp);assert_eq!(s.players[&b].health,enemy_hp);
        assert!(s.garen_passive_per_second(ally)>0.&&s.garen_passive_per_second(b)>0.);
    }
    #[test] fn rejected_pillar_preserves_perseverance_and_player_state() {
        let(mut s,a,b)=game();s.tick=100;s.players.get_mut(&b).unwrap().perseverance_interrupted_at=Some(7);
        let before=serde_json::to_value(&s.players).unwrap();
        assert!(s.cast_trundle_e_at(a,point(2000.25)).is_err());assert_eq!(serde_json::to_value(&s.players).unwrap(),before);
        assert!(s.trundle_e.pillars.is_empty()&&s.trundle_e.pushes.is_empty());
    }
    #[test] fn late_enemy_push_interrupts_perseverance_at_commit_not_each_motion_tick() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position=point(3000.);cast(&mut s,a,1500.);
        assert!(s.players[&b].perseverance_interrupted_at.is_none());let hp=s.players[&b].health;
        s.tick=50;s.players.get_mut(&b).unwrap().position=point(1500.);s.advance_trundle_e();
        assert!(champion_forced(&s.players[&b],50));assert_eq!(s.players[&b].perseverance_interrupted_at,Some(50));
        s.tick=51;s.advance_trundle_e();assert_eq!(s.players[&b].perseverance_interrupted_at,Some(50));assert_eq!(s.players[&b].health,hp);
    }
}
