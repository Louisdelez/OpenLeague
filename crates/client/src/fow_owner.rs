//! Native6B17E0/717D10 resolution and617F80 radius modifiers.
// actor+18/source+30 identity tags; do not treat this check as a generation counter.
pub struct Owner {pub key:u64,pub handle:u32,pub owner_tag:u32,pub percent:f32,pub flat:f32}
pub struct Reference {pub handle:u32,pub cached_key:u64,pub owner_tag:u32}
pub fn modifiers(default:[f32;2],reference:&Reference,registry:&[Option<Owner>])->Result<[f32;2],&'static str> {
    if reference.handle==0 {return Ok(default);}
    if reference.handle==u32::MAX {return Err("invalid native fog owner sentinel");}
    let Some(Some(owner))=registry.get((reference.handle&0xffff) as usize) else {return Ok(default);};
    if owner.handle!=reference.handle {return Ok(default);}
    if owner.key!=reference.cached_key {return Err("native fog cached owner mismatch");}
    if owner.owner_tag!=reference.owner_tag {return Ok(default);}
    let values=openleague_core::vision::RadiusModifiers {flat_bubble_radius_mod:owner.flat,percent_bubble_radius_mod:owner.percent}.parameters();
    if values.iter().any(|v|!v.is_finite()) {return Err("nonfinite native fog owner modifiers");}
    Ok(values)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn owner_modifiers_match_original_resolver_and_virtual_dispatch() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_owner_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let mode=c["mode"].as_str().unwrap();let handle=0x12340002;
            let owner=Owner {key:17,handle:if mode=="handle_mismatch" {handle+0x10000}else{handle},owner_tag:if mode=="generation_mismatch" {8}else{7},percent:c["percent"].as_f64().unwrap() as f32,flat:c["flat"].as_f64().unwrap() as f32};
            let mut registry:Vec<Option<Owner>>=(0..4).map(|_|None).collect();if mode!="empty_slot" {registry[2]=Some(owner);}
            let reference=Reference {handle:if mode=="no_owner" {0}else if mode=="out_of_range" {handle+3}else{handle},cached_key:17,owner_tag:7};
            let actual=modifiers([c["default_scale"].as_f64().unwrap() as f32,c["default_bias"].as_f64().unwrap() as f32],&reference,&registry).unwrap();
            for i in 0..2 {assert_eq!(actual[i].to_bits(),c["result_bits"][i].as_u64().unwrap() as u32,"owner case {c}");}
        }
    }
}
