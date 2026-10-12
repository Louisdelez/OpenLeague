//!92EA60 construction and94322C/943BE0 initialization of acquired storage.
use crate::{native_simple_particle_update::State,native_simple_bounds_policy as bounds,native_simple_particle_bounds::Bounds};
#[derive(Clone)]
pub struct Storage {pub owner:u32,pub context:u32,pub particles:State,pub birth:Vec<u32>}
impl Storage {
    /// Fresh host allocation followed by the actual native caller's preparation.
    /// Native CRT/custom allocation and failure policy remain host obligations.
    pub fn fresh(owner:u32,context:u32,update_counter:u32)->Self {
        Self {owner,context,birth:vec![],particles:State {last_time:0xff7fffff,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:bounds::State {bounds:Bounds {minimum:[0x7f7fffff;3],maximum:[0xff7fffff;3]},center:[0;3],last:0},counter:update_counter}}
    }
    /// Recycled943B60 storage retains its original context. Reset943BE0 clears
    /// twelve arrays;98 heights andC0 bounds timestamp are deliberately retained.
    /// The update counter belongs to the new owner's definition, not this pool.
    pub fn prepare_reused(&mut self,owner:u32,update_counter:u32) {
        self.owner=owner;self.particles.last_time=0xff7fffff;self.particles.active=0;self.particles.counter=update_counter;
        self.birth.clear();self.particles.positions.clear();self.particles.velocities.clear();
        for array in [&mut self.particles.life,&mut self.particles.ages,&mut self.particles.scales,&mut self.particles.factors,&mut self.particles.scalar,&mut self.particles.rates,&mut self.particles.auxiliary,&mut self.particles.attribute_a,&mut self.particles.attribute_b]{array.clear();}
        self.particles.bounds.bounds=Bounds {minimum:[0x7f7fffff;3],maximum:[0xff7fffff;3]};self.particles.bounds.center=[0;3];
    }
}
/// Source retirement decides which storage may enter the native pending stack.
/// Memory/backend failures and resource handles are not synthesized here.
pub fn acquire(pending:&mut Vec<Storage>,owner:u32,context:u32,update_counter:u32)->Storage {
    if let Some(mut storage)=pending.pop(){storage.prepare_reused(owner,update_counter);storage}else{Storage::fresh(owner,context,update_counter)}
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn fresh_and_recycled_preparation_matches54_actual_native_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_storage_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),54);
        for (index,r) in rows.iter().enumerate(){let e=&r["cpu"];let fresh=r["fresh"].as_bool().unwrap();let count=r["count"].as_u64().unwrap() as usize;
            let mut old=Storage::fresh(99,e["context_before"].as_u64().unwrap() as u32,3);old.birth=vec![1;count];old.particles.life=vec![1;count];old.particles.ages=vec![1;count];old.particles.positions=vec![[1;3];count];old.particles.velocities=vec![[1;3];count];old.particles.scales=vec![1;count];old.particles.factors=vec![1;count];old.particles.scalar=vec![1;count];old.particles.rates=vec![1;count];old.particles.auxiliary=vec![1;count];old.particles.attribute_a=vec![1;count];old.particles.attribute_b=vec![1;count];old.particles.previous_heights=words(&e["height_before"]);old.particles.bounds.last=r["bounds_last"].as_u64().unwrap() as u32;
            let context=if fresh{e["context_before"].as_u64().unwrap() as u32}else{(e["context_before"].as_u64().unwrap() as u32)^0x1000};let mut pending=if fresh{vec![]}else{vec![old]};let storage=acquire(&mut pending,7,context,17);let s=&storage.particles;
            assert_eq!(storage.owner,7);assert!(pending.is_empty());assert_eq!(storage.context as u64,e["context_after"].as_u64().unwrap(),"context case{index}");assert_eq!(s.previous_heights,words(&e["height_after"]),"retained heights case{index}");
            for (actual,key) in [(s.last_time,"last_time"),(s.active,"active"),(s.bounds.last,"bounds_last")]{assert_eq!(actual as u64,e[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(s.bounds.bounds.minimum.as_slice(),words(&e["minimum"]));assert_eq!(s.bounds.bounds.maximum.as_slice(),words(&e["maximum"]));assert_eq!(s.bounds.center.as_slice(),words(&e["center"]));assert_eq!(s.counter,17);
            assert_eq!(vec![storage.birth.len(),s.life.len(),s.ages.len(),s.positions.len()*3,s.velocities.len()*3,s.scales.len(),s.factors.len(),s.scalar.len(),s.rates.len(),s.auxiliary.len(),s.attribute_a.len(),s.attribute_b.len()],words(&e["arrays"]).into_iter().map(|v|v as usize).collect::<Vec<_>>(),"array lengths case{index}");
        }
    }

    fn snapshot(storage:&Storage)->Value {
        let s=&storage.particles;
        serde_json::json!({"arrays":{"0x8":storage.birth,"0x14":s.life,"0x20":s.ages,"0x2c":s.positions.iter().flatten().copied().collect::<Vec<_>>(),"0x38":s.velocities.iter().flatten().copied().collect::<Vec<_>>(),"0x44":s.scales,"0x50":s.factors,"0x5c":s.scalar,"0x68":s.rates,"0x74":s.auxiliary,"0x80":s.attribute_a,"0x8c":s.attribute_b,"0x98":s.previous_heights},"last_time":s.last_time,"active":s.active,"bounds_last":s.bounds.last,"minimum":s.bounds.bounds.minimum,"maximum":s.bounds.bounds.maximum,"center":s.bounds.center})
    }
    #[test]
    fn recycle_birth_and_terrain_follow_match288_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_recycled_terrain_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),288);
        for (index,r) in rows.iter().enumerate(){let n=|key:&str|r[key].as_u64().unwrap() as u32;let old=n("old_count") as usize;
            let mut storage=Storage::fresh(7,9,0);storage.birth=vec![(-9f32).to_bits();old];let s=&mut storage.particles;
            s.positions=vec![[(-9f32).to_bits();3];old];s.velocities=s.positions.clone();
            for array in [&mut s.life,&mut s.ages,&mut s.scales,&mut s.factors,&mut s.scalar,&mut s.rates,&mut s.auxiliary,&mut s.attribute_a,&mut s.attribute_b]{*array=vec![(-9f32).to_bits();old];}
            s.previous_heights=words(&r["retained"]);s.bounds.last=0.125f32.to_bits();
            storage.prepare_reused(7,0);assert_eq!(snapshot(&storage),r["cpu"]["after_reset"],"reset case{index}");
            let mut rng=crate::native_random::Rng55::seeded(17);let before=rng.clone();let mut events=vec![];
            for j in 0..n("birth_count"){
                crate::native_simple_birth_insert::insert(&mut storage.particles,&mut storage.birth,&crate::native_simple_birth_insert::Input {time:10.125f32.to_bits(),life:2f32.to_bits(),position:[3f32+j as f32,4.,5.].map(f32::to_bits),velocity:[0.25f32,-0.5,1.].map(f32::to_bits),scalar:(-0.5f32).to_bits(),rate:500f32.to_bits(),factor:0.5f32.to_bits(),auxiliary:0.125f32.to_bits(),scale:crate::native_simple_particle_update::Table {values:&[1.],probability:None},terrain:n("terrain") as u8},&mut rng,&mut |arguments|{let height=(2f32+events.len() as f32*0.25).to_bits();events.push(serde_json::json!({"phase":"birth","arguments":arguments,"height":height}));Ok(height)}).unwrap();
            }
            assert_eq!(snapshot(&storage),r["cpu"]["after_birth"],"birth case{index}");
            let s=&mut storage.particles;
            crate::native_simple_terrain_follow::update(true,n("terrain") as u8,n("locked") as u8,n("begin"),n("last"),&s.ages,&mut s.positions,&mut s.previous_heights,&mut |arguments|{let height=(2f32+events.len() as f32*0.25).to_bits();events.push(serde_json::json!({"phase":"follow","arguments":arguments,"height":height}));Ok(height)}).unwrap();
            assert_eq!(snapshot(&storage),r["cpu"]["after_follow"],"follow case{index}");assert_eq!(events,r["cpu"]["events"].as_array().unwrap().clone(),"provider events case{index}");assert_eq!((rng.words,rng.first,rng.second),(before.words,before.first,before.second));
        }
    }
}
