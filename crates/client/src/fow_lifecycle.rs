//! Native 6B0980 eligibility and 6B2110 lifetime decision. Callers must remove
//! expired visibility contributions before releasing a source; destruction is separate.
use crate::{fow_position::{SourcePosition,PositionOwner},fow_source_update::Parameters};
pub fn eligible(source:&SourcePosition,registry:&[Option<PositionOwner>])->Result<bool,&'static str> {
    let Some(key)=source.cached_owner else {return Ok(true);};
    if source.owner_handle==u32::MAX {return Err("invalid native fog owner sentinel");}
    if source.owner_handle==0 {return Ok(false);}
    let Some(owner)=registry.get((source.owner_handle&0xffff) as usize).and_then(Option::as_ref).filter(|owner|owner.handle==source.owner_handle) else {return Ok(false);};
    if owner.key!=key {return Err("native fog cached eligibility owner mismatch");}
    // Raw native flags: their producers/semantic labels remain to be qualified.
    Ok(owner.actor_ad && !owner.actor_118)
}
/// Returns true when original manager would dispatch removal; no destructor here.
pub fn advance(source:&mut SourcePosition,parameters:&mut Parameters,registry:&[Option<PositionOwner>],delta:f32)->Result<bool,&'static str> {
    source.refresh(parameters,registry)?;
    if source.remaining_lifetime==0. {return Ok(false);}
    if delta>=source.remaining_lifetime {return Ok(true);}
    source.remaining_lifetime-=delta;
    Ok(false)
}
#[cfg(test)] mod tests {
    use super::*;
    fn registry(mode:&str,ad:bool,flag118:bool)->Vec<Option<PositionOwner>> {
        let handle=0x12340002;let mut owners:Vec<Option<PositionOwner>>=(0..4).map(|_|None).collect();
        if mode!="empty_slot" {owners[2]=Some(PositionOwner {secondary_position:None,key:17,handle:if mode=="handle_mismatch" {handle+0x10000}else{handle},position:[10.,99.,20.],actor_ad:ad,actor_118:flag118});}
        owners
    }
    fn source(mode:&str,lifetime:f32)->SourcePosition {
        SourcePosition {center:[10.,20.],cached_owner:if mode=="uncached" {None}else{Some(17)},owner_handle:if mode=="no_owner" {0}else{0x12340002},remaining_lifetime:lifetime}
    }
    #[test] fn eligibility_matches_complete_original_method() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_lifecycle_contract.json")).unwrap();
        assert_eq!(proof["eligibility"].as_array().unwrap().len(),24);
        for c in proof["eligibility"].as_array().unwrap() {
            let mode=c["mode"].as_str().unwrap();let owners=registry(mode,c["flag_ad"].as_bool().unwrap(),c["flag_118"].as_bool().unwrap());
            assert_eq!(eligible(&source(mode,1.),&owners).unwrap(),c["result"].as_bool().unwrap(),"eligibility {c}");
        }
    }
    #[test] fn lifetime_and_position_order_match_original_manager() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_lifecycle_contract.json")).unwrap();
        assert_eq!(proof["lifetime"].as_array().unwrap().len(),105);
        for c in proof["lifetime"].as_array().unwrap() {
            let mode=c["mode"].as_str().unwrap();let mut source=source(mode,f32::from_bits(c["initial_bits"].as_u64().unwrap() as u32));
            let mut parameters=Parameters {radius:1350.,secondary_metric:128.,source_metric:64.,scale:1.,bias:0.,generation_dirty:false};
            let removed=advance(&mut source,&mut parameters,&registry(mode,true,false),f32::from_bits(c["delta_bits"].as_u64().unwrap() as u32)).unwrap();
            assert_eq!(removed,c["removed"].as_bool().unwrap(),"removal decision {c}");
            assert_eq!(source.remaining_lifetime.to_bits(),c["result_bits"].as_u64().unwrap() as u32,"duration {c}");
            assert_eq!(source.cached_owner.is_some(),c["result_cached_owner"].as_bool().unwrap(),"position order {c}");
        }
    }
}
