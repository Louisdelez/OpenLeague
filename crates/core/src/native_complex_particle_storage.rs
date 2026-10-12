//! Original937890 stores one particle across13buffers; owner/global initialization separate.
//! Raw words preserve native ABI attributes whose semantics remain unqualified.
use crate::native_complex_uv_scroll::{Scroll,Flags};
#[derive(Debug,Clone)]
pub struct BirthPacket(pub [u32;69]);
impl BirthPacket {
    pub fn set_uv(&mut self,scroll:Scroll) {
        for (offset,pair) in [0xdc,0xe4,0xec,0xf4].into_iter().zip(scroll.origin.into_iter().chain(scroll.rate)) {
            for axis in 0..2 {self.0[offset/4+axis]=pair[axis].to_bits();}
        }
    }
}
#[derive(Debug,Copy,Clone)]
pub struct GlobalVectors {pub unit:[u32;3],pub scale:[u32;3],pub anchor:[u32;3]}
#[derive(Debug,Clone)]
pub struct Record {
    pub life:[u32;2],pub motion:[u32;53],pub surface:[u32;39],pub color:[u32;8],
    pub scale:[u32;6],pub uv:[u32;14],pub atlas:[u32;3],pub field_58:[u32;1],
    pub field_64:[u32;2],pub field_70:[u32;3],pub field_7c:[u32;1],pub field_88:[u32;1],
    pub trail_slots:Vec<[u32;2]>,
}
fn x87_copy(value:u32)->u32 {
    if value&0x7f800000==0x7f800000 && value&0x007fffff!=0 {value|0x00400000} else {value}
}
impl Record {
    /// Global vector values and three uninitialized native motion scratch words
    /// must be supplied explicitly. This does not infer their production semantics.
    /// Height callback receives native order X,Z,Y; actual terrain lookup separate.
    pub fn from_birth(packet:&BirthPacket,globals:GlobalVectors,motion_scratch:[u32;3],trail_count:usize,height_enabled:bool,mut terrain_height:impl FnMut([f32;3])->f32)->Self {
        let p=&packet.0;let at=|offset:usize|p[offset/4];
        let mut motion=[0;53];for index in [0,5,10,15] {motion[index]=1f32.to_bits();}
        motion[16..19].copy_from_slice(&motion_scratch);
        for (start,source,count) in [(19,0x50,3),(22,0x74,6),(28,0xa4,3),(31,0xbc,3),(40,0x5c,3),(43,0x8c,3),(46,0x98,3),(49,0xb0,3)] {
            motion[start..start+count].copy_from_slice(&p[source/4..source/4+count]);
        }
        motion[34..37].copy_from_slice(&globals.unit);motion[37..40].copy_from_slice(&globals.unit);
        let mut surface=[0;39];for index in 0..32 {surface[index]=x87_copy(p[index%16]);}
        surface[32..35].copy_from_slice(&globals.anchor);surface[35..38].copy_from_slice(&globals.unit);
        surface[38]=if height_enabled {x87_copy(terrain_height([0x30,0x38,0x34].map(|offset|f32::from_bits(x87_copy(at(offset))))).to_bits())} else {0};
        let color=std::array::from_fn(|axis|at(0x40+(axis%4)*4));
        let mut scale=[0;6];scale[..3].copy_from_slice(&p[0x68/4..0x74/4]);scale[3..].copy_from_slice(&globals.scale);
        let mut uv=[0;14];uv[..10].copy_from_slice(&p[0xd4/4..0xfc/4]);
        Self {life:[at(0x100),at(0x104)],motion,surface,color,scale,uv,atlas:[at(0xfc),0,0],field_58:[at(0x108)],field_64:[0;2],field_70:[at(0xc8),at(0xcc),at(0xd0)],field_7c:[at(0x10c)],field_88:[at(0x110)],trail_slots:vec![[0;2];trail_count]}
    }
    pub fn update_uv(&mut self,elapsed:f32,flags:Flags) {
        let scroll=Scroll {origin:std::array::from_fn(|layer|std::array::from_fn(|axis|f32::from_bits(self.uv[2+2*layer+axis]))),rate:std::array::from_fn(|layer|std::array::from_fn(|axis|f32::from_bits(self.uv[6+2*layer+axis])))};
        let output=scroll.update(elapsed,flags);for layer in 0..2 {for axis in 0..2 {self.uv[10+2*layer+axis]=output[layer][axis].to_bits();}}
    }
    /// Native buffer offsets; keeps unspecified raw channels available for later binding.
    pub fn native_words(&self,offset:usize)->Option<Vec<u32>> {
        Some(match offset {4=>self.life.to_vec(),0x10=>self.motion.to_vec(),0x1c=>self.surface.to_vec(),0x28=>self.color.to_vec(),0x34=>self.scale.to_vec(),0x40=>self.uv.to_vec(),0x4c=>self.atlas.to_vec(),0x58=>self.field_58.to_vec(),0x64=>self.field_64.to_vec(),0x70=>self.field_70.to_vec(),0x7c=>self.field_7c.to_vec(),0x88=>self.field_88.to_vec(),0x94=>self.trail_slots.iter().flatten().copied().collect(),_=>return None})
    }
}
/// Owned whole-particle records keep native companion channels together as Vec grows.
/// Null trail removal is qualified; live trail ownership and callbacks remain separate.
#[derive(Debug,Clone,Default)]
pub struct Storage {pub particles:Vec<Record>}
/// Native938740 final writes; frame metadata is owned by the emitter.
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct ClearState {pub last_update_bits:u32,pub live_count:u32}
/// Backend owns weak handles and native-equivalent lock/query/stop semantics.
/// Release locks the resource, marks available state dead and calls stop;
/// expired handles skip query/stop. Drop releases the slot weak reference.
/// Concrete effect implementations and concurrent ownership remain separate.
pub trait TrailBackend {
    fn release_particle_trail(&mut self,slot:[u32;2]);
    fn set_particle_index(&mut self,slot:[u32;2],index:usize);
    fn drop_slot(&mut self,slot:[u32;2]);
}
impl Storage {
    /// Whole938740: stop all particle trails first; clear attribute lengths;
    /// then drop slot weak references in forward order. Do not reindex particles.
    /// Death-emitter production is not qualified; reject that configuration.
    pub fn clear_native(&mut self,death_emitters_enabled:bool,backend:&mut impl TrailBackend)->Result<ClearState,&'static str> {
        if death_emitters_enabled {return Err("particle clear with death emitters is not qualified");}
        if let Some(first)=self.particles.first() {
            if self.particles.iter().any(|r|r.trail_slots.len()!=first.trail_slots.len()) {return Err("inconsistent particle trail slot count");}
        }
        for particle in &self.particles {
            for slot in &particle.trail_slots {backend.release_particle_trail(*slot);}
        }
        let slots:Vec<_>=self.particles.iter().flat_map(|r|r.trail_slots.iter().copied()).collect();
        self.particles.clear();
        for slot in slots {backend.drop_slot(slot);}
        Ok(ClearState {last_update_bits:0xff7fffff,live_count:0})
    }

    pub fn append(&mut self,record:Record)->usize {let index=self.particles.len();self.particles.push(record);index}
    /// Mirrors937F30 for null trail resources. Kinds4/5/9 preserve order.
    /// Non-null resources require the native release and owner-index callbacks;
    /// reject them before mutation until those callbacks are bound.
    pub fn remove_native(&mut self,index:usize,kind:u32)->Result<Record,&'static str> {
        if index>=self.particles.len() {return Err("particle index out of bounds");}
        if self.particles.iter().any(|r|r.trail_slots.iter().any(|slot|*slot!=[0;2])) {
            return Err("live trail resource removal is not bound");
        }
        Ok(self.remove_record(index,kind))
    }
    /// Original release callbacks precede attribute mutation. Ordered kinds
    /// drop removed slots in reverse order, then reindex all shifted particles;
    /// swap kinds reindex the moved particle and drop each slot in reverse order.
    pub fn remove_native_with_trails(&mut self,index:usize,kind:u32,backend:&mut impl TrailBackend)->Result<Record,&'static str> {
        if index>=self.particles.len() {return Err("particle index out of bounds");}
        let slots=self.particles[index].trail_slots.clone();
        if self.particles.iter().any(|r|r.trail_slots.len()!=slots.len()) {return Err("inconsistent particle trail slot count");}
        for slot in &slots {backend.release_particle_trail(*slot);}
        let mut removed=self.remove_record(index,kind);
        if [4,5,9].contains(&kind) {
            for slot in slots.into_iter().rev() {backend.drop_slot(slot);}
            for particle in index..self.particles.len() {
                for slot in &self.particles[particle].trail_slots {backend.set_particle_index(*slot,particle);}
            }
        } else {
            for slot_index in (0..slots.len()).rev() {
                if let Some(moved)=self.particles.get(index) {backend.set_particle_index(moved.trail_slots[slot_index],index);}
                backend.drop_slot(slots[slot_index]);
            }
        }
        removed.trail_slots.fill([0;2]);
        Ok(removed)
    }
    /// Whole93AE90 loop using the qualified13-buffer removal path. Retest the
    /// same index after removal for both ordered and swap kinds. This function
    /// does not advance frame time: the native frame dispatcher owns that write.
    pub fn expire_native(&mut self,time:f32,last_update:f32,kind:u32,backend:&mut impl TrailBackend,mut on_remove:impl FnMut(usize,&Record))->Result<usize,&'static str> {
        if time==last_update {return Ok(0);}
        if let Some(first)=self.particles.first() {
            if self.particles.iter().any(|r|r.trail_slots.len()!=first.trail_slots.len()) {return Err("inconsistent particle trail slot count");}
        }
        let mut index=0;let mut removed=0;
        while index<self.particles.len() {
            let life=self.particles[index].life;
            if time-f32::from_bits(life[0])>f32::from_bits(life[1]) {
                on_remove(index,&self.particles[index]);
                self.remove_native_with_trails(index,kind,backend)?;removed+=1;
            } else {index+=1;}
        }
        Ok(removed)
    }
    fn remove_record(&mut self,index:usize,kind:u32)->Record {
        if [4,5,9].contains(&kind) {
            let removed=self.particles.remove(index);
            for record in &mut self.particles[index..] {
                record.motion=record.motion.map(x87_copy);
                record.surface=record.surface.map(x87_copy);
                record.scale=record.scale.map(x87_copy);
                record.field_70=record.field_70.map(x87_copy);
            }
            removed
        } else {
            // Native motion/surface assignments run even when index was last.
            let last=self.particles.len()-1;
            self.particles[last].motion=self.particles[last].motion.map(x87_copy);
            self.particles[last].surface=self.particles[last].surface.map(x87_copy);
            self.particles.swap_remove(index)
        }
    }

}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_particle_storage_contract.json")).unwrap()}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words(v:&Value)->Vec<u32> {v.as_array().unwrap().iter().map(bits).collect()}
    fn globals(p:&Value)->GlobalVectors {GlobalVectors {unit:words(&p["defaults"]["unit"]).try_into().unwrap(),scale:words(&p["defaults"]["scale"]).try_into().unwrap(),anchor:words(&p["defaults"]["anchor"]).try_into().unwrap()}}
    fn assert_buffers(storage:&Storage,case:&Value) {
        for buffer in case["cpu_buffers"].as_array().unwrap() {
            let offset=bits(&buffer["offset"]) as usize;
            let actual=storage.particles.iter().flat_map(|v|v.native_words(offset).unwrap()).collect::<Vec<_>>();
            let expected=buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>();
            assert_eq!(actual,expected,"buffer{offset:x} capacity{} height{}",case["capacity"],case["height_enabled"]);
        }
    }
    fn record_from_native_buffers(buffers:&Value,index:usize,slots:usize)->Record {
        let at=|offset:usize|words(&buffers.as_array().unwrap().iter().find(|v|bits(&v["offset"]) as usize==offset).unwrap()["records"][index]);
        Record {life:at(4).try_into().unwrap(),motion:at(0x10).try_into().unwrap(),surface:at(0x1c).try_into().unwrap(),color:at(0x28).try_into().unwrap(),scale:at(0x34).try_into().unwrap(),uv:at(0x40).try_into().unwrap(),atlas:at(0x4c).try_into().unwrap(),field_58:at(0x58).try_into().unwrap(),field_64:at(0x64).try_into().unwrap(),field_70:at(0x70).try_into().unwrap(),field_7c:at(0x7c).try_into().unwrap(),field_88:at(0x88).try_into().unwrap(),trail_slots:vec![[0;2];slots]}
    }
    #[test]
    fn whole_native_removal_matches13buffers_all_kinds_indices_and_null_trails() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_particle_removal_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),360);
        for case in proof["cases"].as_array().unwrap() {
            let count=case["count"].as_u64().unwrap() as usize;let index=case["index"].as_u64().unwrap() as usize;
            let mut storage=Storage {particles:(0..count).map(|i|record_from_native_buffers(&case["before"],i,case["trail_slots"].as_u64().unwrap() as usize)).collect()};
            storage.remove_native(index,case["kind"].as_u64().unwrap() as u32).unwrap();
            assert_eq!(storage.particles.len(),case["live_count"].as_u64().unwrap() as usize);
            for buffer in case["after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                let actual=storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>();
                let expected=buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>();
                assert_eq!(actual,expected,"kind{} index{index} count{count} buffer{offset:x}",case["kind"]);
            }
        }
    }
    #[test]
    fn whole_clear_matches13buffers_trail_stop_order_and_weak_graph() {
        use crate::native_complex_trail_resources::{TroyTrailResources,Resource,State};
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_clear_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),432);
        for case in proof["cases"].as_array().unwrap() {
            let slots=case["trail_slots"].as_u64().unwrap() as usize;
            let mut backend=TroyTrailResources::default();
            for (i,row) in case["resources"].as_array().unwrap().iter().enumerate() {
                let at=|key:&str|row[key].as_u64().unwrap() as u32;
                let alive=row["alive"].as_bool().unwrap();let state_alive=case["state_alive"].as_bool().unwrap();
                backend.resources.insert(at("control"),Resource {object:at("object"),id:at("id"),strong:u32::from(alive),weak:if alive {2} else {1},state:[at("state"),at("state_control")],requests:at("initial_flags")});
                backend.states.insert(at("state_control"),State {object:at("state"),strong:u32::from(state_alive),weak:if state_alive {2} else {1},owner_index:(i/slots) as u32,dead:0});
            }
            let trails=case["before"].as_array().unwrap().iter().find(|b|bits(&b["offset"])==0x94).unwrap()["records"].as_array().unwrap();
            let mut storage=Storage {particles:(0..case["count"].as_u64().unwrap() as usize).map(|i|{let mut r=record_from_native_buffers(&case["before"],i,slots);r.trail_slots=(i*slots..(i+1)*slots).map(|j|words(&trails[j]).try_into().unwrap()).collect();r}).collect()};
            let cleared=storage.clear_native(false,&mut backend).unwrap();
            assert_eq!(cleared.last_update_bits,bits(&case["last_update"]));assert_eq!(cleared.live_count,case["live_count"].as_u64().unwrap() as u32);assert_eq!(storage.particles.len(),cleared.live_count as usize);
            assert_eq!(serde_json::to_value(&backend.events).unwrap(),case["events"]);
            for row in case["resources"].as_array().unwrap() {
                let resource=&backend.resources[&(row["control"].as_u64().unwrap() as u32)];let state=&backend.states[&(row["state_control"].as_u64().unwrap() as u32)];
                for (key,actual) in [("resource_strong",resource.strong),("resource_weak",resource.weak),("state_strong",state.strong),("state_weak",state.weak),("final_flags",resource.requests),("final_owner",state.owner_index),("final_dead",u32::from(state.dead))] {assert_eq!(actual,row[key].as_u64().unwrap() as u32,"{key}");}
            }
            for buffer in case["after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                assert_eq!(storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>(),buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>());
            }
        }
    }
    #[test]
    fn concrete_troy_state_query_stop_request_and_weak_graph_match_native_bodies() {
        use crate::native_complex_trail_resources::{TroyTrailResources,Resource,State};
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_concrete_trail_removal_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),192);
        for case in proof["cases"].as_array().unwrap() {
            let slots=case["trail_slots"].as_u64().unwrap() as usize;
            let mut backend=TroyTrailResources::default();
            for (i,row) in case["resources"].as_array().unwrap().iter().enumerate() {
                let at=|key:&str|row[key].as_u64().unwrap() as u32;
                let alive=row["alive"].as_bool().unwrap();let state_alive=case["state_alive"].as_bool().unwrap();
                backend.resources.insert(at("control"),Resource {object:at("object"),id:at("id"),strong:u32::from(alive),weak:if alive {2} else {1},state:[at("state"),at("state_control")],requests:at("initial_flags")});
                backend.states.insert(at("state_control"),State {object:at("state"),strong:u32::from(state_alive),weak:if state_alive {2} else {1},owner_index:(i/slots) as u32,dead:0});
            }
            let trails=case["before"].as_array().unwrap().iter().find(|b|bits(&b["offset"])==0x94).unwrap()["records"].as_array().unwrap();
            let mut storage=Storage {particles:(0..4).map(|i|{let mut r=record_from_native_buffers(&case["before"],i,slots);r.trail_slots=(i*slots..(i+1)*slots).map(|j|words(&trails[j]).try_into().unwrap()).collect();r}).collect()};
            storage.remove_native_with_trails(case["index"].as_u64().unwrap() as usize,case["kind"].as_u64().unwrap() as u32,&mut backend).unwrap();
            assert_eq!(serde_json::to_value(&backend.events).unwrap(),case["events"]);
            for row in case["resources"].as_array().unwrap() {
                let resource=&backend.resources[&(row["control"].as_u64().unwrap() as u32)];let state=&backend.states[&(row["state_control"].as_u64().unwrap() as u32)];
                for (key,actual) in [("resource_strong",resource.strong),("resource_weak",resource.weak),("state_strong",state.strong),("state_weak",state.weak),("final_flags",resource.requests),("final_owner",state.owner_index),("final_dead",u32::from(state.dead))] {assert_eq!(actual,row[key].as_u64().unwrap() as u32,"{key}");}
            }
            for buffer in case["after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                assert_eq!(storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>(),buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>());
            }
        }
    }
    #[test]
    fn full_expiry_matches_native_removal_order13buffers_and_live_count() {
        struct NullTrails;
        impl TrailBackend for NullTrails {
            fn release_particle_trail(&mut self,slot:[u32;2]) {assert_eq!(slot,[0;2]);}
            fn set_particle_index(&mut self,slot:[u32;2],_:usize) {assert_eq!(slot,[0;2]);}
            fn drop_slot(&mut self,slot:[u32;2]) {assert_eq!(slot,[0;2]);}
        }
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_full_expiry_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),672);
        for case in proof["cases"].as_array().unwrap() {
            let count=case["before"][0]["records"].as_array().unwrap().len();
            let mut storage=Storage {particles:(0..count).map(|i|record_from_native_buffers(&case["before"],i,case["trail_slots"].as_u64().unwrap() as usize)).collect()};
            let mut removed=vec![];
            let count=storage.expire_native(f32::from_bits(bits(&case["time"])),f32::from_bits(bits(&case["last_update"])),case["kind"].as_u64().unwrap() as u32,&mut NullTrails,|index,r|removed.push(serde_json::json!({"index":index,"id":r.field_88[0]}))).unwrap();
            assert_eq!(count,removed.len());assert_eq!(removed,case["removed"].as_array().unwrap().clone());
            assert_eq!(storage.particles.len(),case["live_count"].as_u64().unwrap() as usize);
            assert_eq!(case["stored_time_after"],case["last_update"]);
            for buffer in case["after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                assert_eq!(storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>(),buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>(),"kind{} time{} last{} buffer{offset:x}",case["kind"],case["time"],case["last_update"]);
            }
        }
    }
    #[test]
    fn live_trail_callback_order_owner_updates_and_net_weak_counts_match_native() {
        struct Backend {rows:Vec<Value>,events:Vec<Value>,state_alive:bool}
        impl Backend {
            fn row(&self,slot:[u32;2])->Option<usize> {self.rows.iter().position(|r|r["object"].as_u64().unwrap() as u32==slot[0] && slot[0]!=0)}
            fn query(&mut self,i:usize) {self.events.push(serde_json::json!({"event":"query_state","id":self.rows[i]["id"]}));}
        }
        impl TrailBackend for Backend {
            fn release_particle_trail(&mut self,slot:[u32;2]) {
                if let Some(i)=self.row(slot) {if self.rows[i]["alive"].as_bool().unwrap() {
                    self.query(i);if self.state_alive {self.rows[i]["observed_dead"]=serde_json::json!(1);}
                    self.events.push(serde_json::json!({"event":"stop","id":self.rows[i]["id"],"dead":self.rows[i]["observed_dead"]}));
                }}
            }
            fn set_particle_index(&mut self,slot:[u32;2],index:usize) {
                if let Some(i)=self.row(slot) {if self.rows[i]["alive"].as_bool().unwrap() {
                    self.query(i);if self.state_alive {self.rows[i]["observed_owner"]=serde_json::json!(index);}
                }}
            }
            fn drop_slot(&mut self,slot:[u32;2]) {
                if let Some(i)=self.row(slot) {
                    let weak=self.rows[i]["observed_weak"].as_u64().unwrap()-1;self.rows[i]["observed_weak"]=serde_json::json!(weak);
                    if weak==0 {self.events.push(serde_json::json!({"event":"free_control","control":format!("resource:{}",self.rows[i]["id"].as_u64().unwrap())}));}
                }
            }
        }
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_live_trail_removal_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),192);
        for case in proof["cases"].as_array().unwrap() {
            let slots=case["trail_slots"].as_u64().unwrap() as usize;
            let trails=case["before"].as_array().unwrap().iter().find(|b|bits(&b["offset"])==0x94).unwrap()["records"].as_array().unwrap();
            let mut storage=Storage {particles:(0..4).map(|i|{let mut r=record_from_native_buffers(&case["before"],i,slots);r.trail_slots=(i*slots..(i+1)*slots).map(|j|words(&trails[j]).try_into().unwrap()).collect();r}).collect()};
            let mut backend=Backend {rows:case["resources"].as_array().unwrap().clone(),events:vec![],state_alive:case["state_alive"].as_bool().unwrap()};
            for (i,row) in backend.rows.iter_mut().enumerate() {row["observed_owner"]=serde_json::json!(i/slots);row["observed_dead"]=serde_json::json!(0);row["observed_weak"]=serde_json::json!(if row["alive"].as_bool().unwrap() {2} else {1});}
            storage.remove_native_with_trails(case["index"].as_u64().unwrap() as usize,case["kind"].as_u64().unwrap() as u32,&mut backend).unwrap();
            assert_eq!(backend.events,case["events"].as_array().unwrap().clone(),"kind{} index{} mode{} state{}",case["kind"],case["index"],case["mode"],case["state_alive"]);
            for row in &backend.rows {assert_eq!(row["observed_owner"],row["final_owner"]);assert_eq!(row["observed_dead"],row["final_dead"]);assert_eq!(row["observed_weak"],row["resource_weak"]);}
            for buffer in case["after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                assert_eq!(storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>(),buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>());
            }
        }
    }
    #[test]
    fn removal_nonfinite_attributes_match_native_order_with_actual_cpu_x87_copies() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_particle_removal_x87_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),48);
        assert_eq!(proof["emulator_cpu_case_disagreements"],32);
        for case in proof["cases"].as_array().unwrap() {
            let mut storage=Storage {particles:(0..3).map(|i|record_from_native_buffers(&case["before"],i,case["trail_slots"].as_u64().unwrap() as usize)).collect()};
            storage.remove_native(case["index"].as_u64().unwrap() as usize,case["kind"].as_u64().unwrap() as u32).unwrap();
            for buffer in case["cpu_after"].as_array().unwrap() {
                let offset=bits(&buffer["offset"]) as usize;
                let actual=storage.particles.iter().flat_map(|r|r.native_words(offset).unwrap()).collect::<Vec<_>>();
                let expected=buffer["records"].as_array().unwrap().iter().flat_map(words).collect::<Vec<_>>();
                assert_eq!(actual,expected,"kind{} index{} phase{} buffer{offset:x}",case["kind"],case["index"],case["phase"]);
            }
        }
    }
    #[test]
    fn removal_rejects_invalid_index_and_unbound_live_trails_before_mutation() {
        let p=proof();let mut r=Record::from_birth(&BirthPacket([0;69]),globals(&p),[0;3],1,false,|_|unreachable!());r.trail_slots[0]=[123,456];
        let mut storage=Storage {particles:vec![r]};
        assert!(storage.remove_native(1,4).is_err());assert!(storage.remove_native(0,4).is_err());
        assert_eq!(storage.particles.len(),1);assert_eq!(storage.particles[0].trail_slots,vec![[123,456]]);
    }
    #[test]
    fn entire_native_append_matches_all13buffers_growth_defaults_and_height_arguments() {
        let p=proof();assert_eq!(p["cases"].as_array().unwrap().len(),72);let globals=globals(&p);
        for case in p["cases"].as_array().unwrap() {
            let mut storage=Storage {particles:Vec::with_capacity(case["capacity"].as_u64().unwrap() as usize)};let mut queries=vec![];
            for row in case["packets"].as_array().unwrap() {
                let packet=BirthPacket(words(&row["payload_bits"]).try_into().unwrap());
                let record=Record::from_birth(&packet,globals,words(&row["scratch_bits"]).try_into().unwrap(),case["trail_slots"].as_u64().unwrap() as usize,case["height_enabled"].as_bool().unwrap(),|args|{queries.push(args.map(f32::to_bits));f32::from_bits(bits(&case["height_bits"]))});
                assert_eq!(storage.append(record),storage.particles.len()-1);
            }
            assert_buffers(&storage,case);
            assert_eq!(queries,case["cpu_queries"].as_array().unwrap().iter().map(|v|words(v).try_into().unwrap()).collect::<Vec<[u32;3]>>());
        }
    }
    #[test]
    fn actual_map_uv_reader_shared_draw_and_storage_match_native_composition() {
        let p=proof();let case=&p["map_uv_case"];assert_eq!(case["packets"].as_array().unwrap().len(),27);
        let birth:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_uv_birth_contract.json")).unwrap();let mut storage=Storage::default();
        for row in case["packets"].as_array().unwrap() {
            let native=&row["uv_birth_case"];let profile=birth["profiles"].as_array().unwrap().iter().find(|v|v["name"]==native["name"]).unwrap();
            let cfg=crate::native_complex_uv_parameters::UvParameters::from_group(&profile["fields"]).unwrap();
            let mut rng=crate::native_random::Rng55::seeded(native["seed"].as_u64().unwrap() as u32);let shared=rng.fraction();
            let scroll=cfg.sample_birth(f32::from_bits(bits(&native["age_bits"])),shared).unwrap();
            let mut packet=BirthPacket(words(&row["payload_bits"]).try_into().unwrap());for word in &mut packet.0[0xdc/4..0xfc/4] {*word=0;}
            packet.set_uv(scroll);assert_eq!(packet.0.to_vec(),words(&row["payload_bits"]));
            storage.append(Record::from_birth(&packet,globals(&p),words(&row["scratch_bits"]).try_into().unwrap(),0,false,|_|panic!("disabled height")));
        }
        assert_buffers(&storage,case);
    }
    #[test]
    fn stored_uv_frame_update_matches_original_crt_contract_and_keeps_birth_attributes() {
        let p=proof();let native:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_uv_update_contract.json")).unwrap();
        for row in native["cases"].as_array().unwrap() {
            let pair=|key:&str|std::array::from_fn(|layer|std::array::from_fn(|axis|f32::from_bits(bits(&row[key][layer*2+axis]))));
            let scroll=Scroll {origin:pair("base_bits"),rate:pair("rate_bits")};let mut packet=BirthPacket([0;69]);packet.set_uv(scroll);
            let mut record=Record::from_birth(&packet,globals(&p),[0;3],0,false,|_|panic!("disabled height"));let before=record.clone();
            record.update_uv(f32::from_bits(bits(&row["elapsed_bits"])),Flags(row["flags"].as_u64().unwrap() as u8));
            assert_eq!(record.uv[10..].to_vec(),words(&row["cpu_arithmetic_native_crt_bits"]));assert_eq!(record.uv[..10],before.uv[..10]);
            for offset in [4,0x10,0x1c,0x28,0x34,0x4c,0x58,0x64,0x70,0x7c,0x88,0x94] {assert_eq!(record.native_words(offset),before.native_words(offset));}
        }
    }
}
