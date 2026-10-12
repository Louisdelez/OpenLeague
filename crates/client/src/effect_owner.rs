//! Native eight-slot effect-owner stop dispatch, qualified at7558C0.
//! Owner creation/caller semantics and manager update remain separate.
use std::sync::{Mutex,Weak};

#[derive(Default)]
pub struct EffectRequest {
    pub bits:u32,
}
impl EffectRequest {
    pub fn request_stop(&mut self) { self.bits|=0x400; }
}
pub struct EffectOwner {
    pub active:bool,
    pub stopping:bool,
    pub effects:[Weak<Mutex<EffectRequest>>;8],
}
impl EffectOwner {
    pub fn request_stop(&mut self)->Result<(),&'static str> {
        if !self.active {return Err("native effect-owner stop requires an active owner");}
        self.stopping=true;
        for effect in &self.effects {
            //5BD6F0 locks weak handles; expired references are skipped.
            if let Some(effect)=effect.upgrade() {
                effect.lock().map_err(|_|"effect request lock poisoned")?.request_stop();
            }
        }
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Arc;
    #[test]
    fn all_original_eight_slot_masks_preserve_request_bits_and_expired_handles() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/effect_owner_stop_contract.json")).unwrap();
        for case in proof["cases"].as_array().unwrap() {
            let mask=case["live_mask"].as_u64().unwrap();
            let mut live:Vec<Arc<Mutex<EffectRequest>>>=Vec::new();
            let effects=std::array::from_fn(|i|{
                let effect=Arc::new(Mutex::new(EffectRequest{bits:0x2000|i as u32}));
                let weak=Arc::downgrade(&effect);
                if mask&(1<<i)!=0 {live.push(effect);}
                weak
            });
            let mut owner=EffectOwner {active:true,stopping:false,effects};
            owner.request_stop().unwrap();
            assert_eq!(owner.active,case["owner_active"]==1);
            assert_eq!(owner.stopping,case["owner_stop"]==1);
            let mut slots=Vec::new();
            for (i,weak) in owner.effects.iter().enumerate() {
                if let Some(effect)=weak.upgrade() {
                    slots.push(i);
                    assert_eq!(effect.lock().unwrap().bits,case["requests"][i].as_u64().unwrap() as u32);
                }
            }
            assert_eq!(serde_json::json!(slots),case["stop_slots"]);
            for effect in live {assert_eq!(Arc::strong_count(&effect),1);}
        }
    }
}
