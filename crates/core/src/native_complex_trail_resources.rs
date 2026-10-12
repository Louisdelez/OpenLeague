//! Troy virtual64/928660 and virtualA0/9289B0, with single-threaded weak graph.
//! Resource acquisition, stop-request consumption and concrete GPU destruction separate.
use std::collections::BTreeMap;
use crate::native_complex_particle_storage::TrailBackend;
#[derive(Debug,Clone)]
pub struct Resource {pub object:u32,pub id:u32,pub strong:u32,pub weak:u32,pub state:[u32;2],pub requests:u32}
#[derive(Debug,Clone)]
pub struct State {pub object:u32,pub strong:u32,pub weak:u32,pub owner_index:u32,pub dead:u8}
#[derive(Debug,Clone,serde::Serialize)]
#[serde(tag="event",rename_all="snake_case")]
pub enum Event {QueryState{id:u32},Stop{id:u32,dead:u8},FreeControl{control:String}}
/// Explicit graph registration avoids inventing absent resources. Handles are
/// identifiers, never host pointers. All slots must refer to registered controls.
#[derive(Debug,Default)]
pub struct TroyTrailResources {pub resources:BTreeMap<u32,Resource>,pub states:BTreeMap<u32,State>,pub events:Vec<Event>}
impl TroyTrailResources {
    fn lock(&mut self,slot:[u32;2])->Option<(u32,[u32;2])> {
        if slot==[0;2] {return None;}
        let resource=self.resources.get_mut(&slot[1]).expect("unregistered trail control");
        assert_eq!(resource.object,slot[0]);assert!(resource.weak>0,"deleted trail control");
        if resource.strong==0 {return None;}
        resource.strong=resource.strong.wrapping_add(1);
        Some((resource.id,resource.state))
    }
    fn state_action(&mut self,id:u32,handle:[u32;2],owner:Option<usize>)->u8 {
        self.events.push(Event::QueryState{id});
        if handle==[0;2] {return 0;}
        let state=self.states.get_mut(&handle[1]).expect("unregistered trail state");
        assert_eq!(state.object,handle[0]);assert!(state.weak>0);
        // Original virtual64 retains the weak pair;5BD6F0 attempts a strong lock.
        state.weak=state.weak.wrapping_add(1);
        if state.strong!=0 {
            state.strong=state.strong.wrapping_add(1);
            if let Some(index)=owner {state.owner_index=index as u32;} else {state.dead=1;}
            state.strong=state.strong.wrapping_sub(1);
        }
        state.weak=state.weak.wrapping_sub(1);
        state.dead
    }
}
impl TrailBackend for TroyTrailResources {
    fn release_particle_trail(&mut self,slot:[u32;2]) {
        if let Some((id,state))=self.lock(slot) {
            let dead=self.state_action(id,state,None);
            let resource=self.resources.get_mut(&slot[1]).unwrap();
            resource.requests|=0x400; // Native9289B0: deferred stop request.
            self.events.push(Event::Stop{id,dead});
            resource.strong=resource.strong.wrapping_sub(1);
        }
    }
    fn set_particle_index(&mut self,slot:[u32;2],index:usize) {
        if let Some((id,state))=self.lock(slot) {
            self.state_action(id,state,Some(index));
            let resource=self.resources.get_mut(&slot[1]).unwrap();resource.strong=resource.strong.wrapping_sub(1);
        }
    }
    fn drop_slot(&mut self,slot:[u32;2]) {
        if slot==[0;2] {return;}
        let resource=self.resources.get_mut(&slot[1]).expect("unregistered trail control");
        assert_eq!(resource.object,slot[0]);assert!(resource.weak>0);
        resource.weak-=1;
        if resource.weak==0 {self.events.push(Event::FreeControl{control:format!("resource:{}",resource.id)});}
    }
}
