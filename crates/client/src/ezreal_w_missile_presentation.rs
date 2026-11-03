//! One accepted OLSR frame owns each current W XYZ. No actor/bone/history lookup.
use std::collections::{BTreeMap,BTreeSet};
use openleague_core::{Snapshot,Point,session_transport::Context,ezreal_w_projectile_view::{self as wire,Row}};
const FRESH_SECONDS:f64=0.2;
#[derive(Debug,Clone,Copy,PartialEq,Eq,PartialOrd,Ord)]
pub struct Key {pub session:u64,pub owner:u32,pub team:u8,pub ordinal:u64}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct CurrentW {pub key:Key,pub incarnation:u64,pub position:Point,pub y_native:f32,
    pub direction:Point,pub sample_tick:u64,pub frame_ordinal:u64}
#[derive(Debug,Default)]
pub struct State {
    session:Option<u64>,viewer:Option<u32>,epoch:Option<u64>,team:Option<u8>,last_tick:Option<u64>,
    last_frame:Option<u64>,last_now:Option<f64>,at:Option<f64>,ended:bool,next:u64,
    facts:BTreeMap<Key,Row>,rows:BTreeMap<Key,CurrentW>,
}
impl State {
    pub fn suspend(&mut self){self.rows.clear();self.at=None;}
    pub fn reset_session(&mut self,session:u64,viewer:u32){let next=self.next;
        *self=Self{session:Some(session),viewer:Some(viewer),next,..Self::default()};}
    pub fn begin_epoch(&mut self,epoch:Option<u64>){self.suspend();self.facts.clear();self.epoch=epoch;
        self.last_frame=None;self.last_tick=None;self.last_now=None;self.team=None;self.ended=false;}
    fn audience(snapshot:&Snapshot,viewer:u32)->Result<u8,&'static str>{
        if snapshot.roster.len()>64{return Err("W roster budget");}let mut seen=BTreeSet::new();
        for row in &snapshot.roster{if row.id==0||row.team>1||!seen.insert(row.id){return Err("W roster invalid");}}
        snapshot.roster.iter().find(|p|p.id==viewer).map(|p|p.team).ok_or("W viewer absent")
    }
    fn fresh(&self,now:f64)->bool{self.at.is_some_and(|old|now>=old&&now-old<=FRESH_SECONDS)}
    pub fn observe_accepted_frame(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,paused:bool,healthy:bool,
        delivery:Option<(Context,u64)>)->Result<(),&'static str>{
        let result=self.observe(snapshot,viewer,now,paused,healthy,delivery);
        if result.is_err(){self.suspend();}result
    }
    fn observe(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,paused:bool,healthy:bool,
        delivery:Option<(Context,u64)>)->Result<(),&'static str>{
        if !healthy||!now.is_finite()||now<0.||self.last_now.is_some_and(|old|now<old)
            ||self.session!=Some(snapshot.session)||self.viewer!=Some(viewer)
            ||self.last_tick.is_some_and(|old|snapshot.tick<old){return Err("W current boundary unavailable");}
        let Some((context,frame))=delivery else{self.suspend();self.facts.clear();return Ok(());};
        if !context.valid()||context.session!=snapshot.session||context.player!=viewer||self.epoch!=Some(context.epoch)
            ||frame==0||self.last_frame.is_some_and(|old|frame<=old){return Err("W requires fresh atomic frame");}
        self.last_frame=Some(frame); // consume before optional parsing; malformed replay cannot revive
        let team=Self::audience(snapshot,viewer)?;
        if self.team!=Some(team){self.suspend();self.facts.clear();self.team=Some(team);}
        if snapshot.winner.is_some()||self.ended{self.suspend();self.ended=true;return Ok(());}
        let new_tick=self.last_tick!=Some(snapshot.tick);
        self.last_tick=Some(snapshot.tick);self.last_now=Some(now);
        let incoming=match &snapshot.ezreal_w_current_missiles{Some(v)=>wire::decode(v)?,None=>vec![]};
        let mut facts=BTreeMap::new();
        for row in incoming{
            if !snapshot.roster.iter().any(|p|p.id==row.owner&&p.team==row.team&&p.champion=="ezreal"){
                return Err("W owner roster mismatch");}
            let key=Key{session:snapshot.session,owner:row.owner,team:row.team,ordinal:row.ordinal};
            if self.facts.get(&key).is_some_and(|old|old.direction!=row.direction){return Err("W frozen direction changed");}
            facts.insert(key,row);
        }
        let changed=self.facts!=facts;
        if self.at.is_some()&&!self.fresh(now){self.suspend();}
        self.rows.retain(|key,_|facts.contains_key(key));
        if !new_tick&&!changed&&self.rows.is_empty(){return Ok(());}
        self.facts=facts.clone();
        for (key,row) in facts{
            if let Some(current)=self.rows.get_mut(&key){
                if !paused{*current=CurrentW{key,incarnation:current.incarnation,position:row.position,
                    y_native:row.y_native,direction:row.direction,sample_tick:snapshot.tick,frame_ordinal:frame};}
            }else if !paused{
                self.next=self.next.checked_add(1).ok_or("W incarnation exhausted")?;
                self.rows.insert(key,CurrentW{key,incarnation:self.next,position:row.position,y_native:row.y_native,
                    direction:row.direction,sample_tick:snapshot.tick,frame_ordinal:frame});
            }
        }
        // Paused new facts do not create emitters. Existing XYZ/stamp stay frozen,
        // but current authorization still removes rows on every accepted frame.
        if new_tick||changed{self.at=Some(now);}Ok(())
    }
    pub fn samples(&self,snapshot:&Snapshot,viewer:u32,session:u64,epoch:Option<u64>,now:f64,healthy:bool)->Vec<CurrentW>{
        if !healthy||!now.is_finite()||!self.fresh(now)||self.ended||snapshot.winner.is_some()
            ||self.session!=Some(session)||snapshot.session!=session||self.viewer!=Some(viewer)
            ||epoch.is_none()||self.epoch!=epoch||self.last_tick!=Some(snapshot.tick)
            ||Self::audience(snapshot,viewer).ok()!=self.team||self.last_now.is_none_or(|old|now<old){return vec![];}
        self.rows.values().copied().collect()
    }
}
#[cfg(test)]
mod tests{
    use super::*;
    fn fixture()->(State,Snapshot,u32,Context){
        let mut bytes=Vec::new();for _ in 0..6400{bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
        let mut sim=openleague_core::Simulation::new(nav).unwrap();sim.session=u64::MAX-1;
        let a=sim.join("ezreal").unwrap();let b=sim.join("garen").unwrap();let mut snap=sim.snapshot();
        snap.players.retain(|p|p.id!=a);
        snap.ezreal_w_current_missiles=Some(serde_json::json!({"policy":wire::POLICY,"rows":[{
            "owner":a,"team":0,"ordinal":u64::MAX,"x":7000,"z":8000,"y_native":150,"dx":1,"dz":0}]}));
        let context=Context{session:snap.session,player:b,epoch:(1u64<<53)+5};
        let mut s=State::default();s.reset_session(snap.session,b);s.begin_epoch(Some(context.epoch));(s,snap,b,context)
    }
    fn samples(s:&State,snap:&Snapshot,b:u32,c:Context,now:f64)->Vec<CurrentW>{s.samples(snap,b,c.session,Some(c.epoch),now,true)}
    #[test]
    fn atomic_xyz_hidden_owner_full_identity_and_no_extrapolation(){
        let(mut s,mut snap,b,c)=fixture();s.observe_accepted_frame(&snap,b,1.,false,true,Some((c,u64::MAX-2))).unwrap();
        let first=samples(&s,&snap,b,c,1.1)[0];assert_eq!(first.key.ordinal,u64::MAX);assert_eq!(first.key.session,c.session);
        assert_eq!(first.position,Point{x:7000.,z:8000.});assert_eq!(first.y_native,150.);
        snap.tick+=1;snap.ezreal_w_current_missiles.as_mut().unwrap()["rows"][0]["x"]=serde_json::json!(7100);
        snap.ezreal_w_current_missiles.as_mut().unwrap()["rows"][0]["y_native"]=serde_json::json!(155);
        s.observe_accepted_frame(&snap,b,1.1,false,true,Some((c,u64::MAX-1))).unwrap();
        let next=samples(&s,&snap,b,c,1.2)[0];assert_eq!((next.position.x,next.y_native),(7100.,155.));
        assert_eq!(next.incarnation,first.incarnation);assert_eq!(next.sample_tick,snap.tick);assert_eq!(next.frame_ordinal,u64::MAX-1);
    }
    #[test]
    fn same_batch_loss_and_reveal_replace_episode_and_same_tick_replays_do_not_refresh(){
        let(mut s,mut snap,b,c)=fixture();s.observe_accepted_frame(&snap,b,1.,false,true,Some((c,1))).unwrap();let old=samples(&s,&snap,b,c,1.)[0];
        let value=snap.ezreal_w_current_missiles.take();snap.tick+=1;
        s.observe_accepted_frame(&snap,b,1.,false,true,Some((c,2))).unwrap();assert!(samples(&s,&snap,b,c,1.).is_empty());
        snap.tick+=1;snap.ezreal_w_current_missiles=value;
        s.observe_accepted_frame(&snap,b,1.,false,true,Some((c,3))).unwrap();assert!(samples(&s,&snap,b,c,1.)[0].incarnation>old.incarnation);
        s.observe_accepted_frame(&snap,b,1.21,false,true,Some((c,4))).unwrap();assert!(samples(&s,&snap,b,c,1.21).is_empty());
        assert!(s.observe_accepted_frame(&snap,b,1.21,false,true,Some((c,4))).is_err());
    }
    #[test]
    fn pause_keeps_atomic_pose_but_never_permission_and_legacy_or_bad_data_retires(){
        let(mut s,mut snap,b,c)=fixture();s.observe_accepted_frame(&snap,b,2.,false,true,Some((c,1))).unwrap();let old=samples(&s,&snap,b,c,2.)[0];
        snap.tick+=1;snap.ezreal_w_current_missiles.as_mut().unwrap()["rows"][0]["x"]=serde_json::json!(9000);
        s.observe_accepted_frame(&snap,b,2.,true,true,Some((c,2))).unwrap();assert_eq!(samples(&s,&snap,b,c,2.)[0],old);
        let value=snap.ezreal_w_current_missiles.take();snap.tick+=1;s.observe_accepted_frame(&snap,b,2.,true,true,Some((c,3))).unwrap();
        assert!(samples(&s,&snap,b,c,2.).is_empty());snap.ezreal_w_current_missiles=value;snap.tick+=1;
        s.observe_accepted_frame(&snap,b,2.,true,true,Some((c,4))).unwrap();assert!(samples(&s,&snap,b,c,2.).is_empty());
        snap.tick+=1;s.observe_accepted_frame(&snap,b,2.,false,true,Some((c,5))).unwrap();assert_eq!(samples(&s,&snap,b,c,2.).len(),1);
        assert!(samples(&s,&snap,b,c,2.).len()==1);assert!(s.samples(&snap,b,c.session,Some(c.epoch),2.,false).is_empty());
        s.observe_accepted_frame(&snap,b,2.,false,true,None).unwrap();assert!(samples(&s,&snap,b,c,2.).is_empty());
        snap.ezreal_w_current_missiles=Some(serde_json::json!("corrupt"));assert!(s.observe_accepted_frame(&snap,b,2.,false,true,Some((c,6))).is_err());
    }
    #[test]
    fn session_epoch_direction_roster_time_and_counter_fail_closed(){
        for case in 0..7 {let(mut s,mut snap,b,c)=fixture();s.observe_accepted_frame(&snap,b,1.,false,true,Some((c,1))).unwrap();
            let mut context=c;let mut now=1.1;match case{0=>context.epoch+=1,1=>context.player+=10,
                2=>snap.roster.push(snap.roster[0].clone()),3=>now=f64::NAN,4=>snap.session-=1,
                5=>{snap.ezreal_w_current_missiles.as_mut().unwrap()["rows"][0]["dx"]=serde_json::json!(-1);},
                _=>{s.suspend();s.next=u64::MAX;snap.tick+=1;}}
            assert!(s.observe_accepted_frame(&snap,b,now,false,true,Some((context,2))).is_err());assert!(s.rows.is_empty());}
    }
}
