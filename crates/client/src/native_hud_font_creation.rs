//! Original 9A5EC0 font metadata and X87->double->ceil sizing.
//! Owned metadata replaces native allocations; device/string/pool lifecycle remains open.
use bevy::{prelude::*,window::PrimaryWindow};
#[derive(Clone,Copy,Debug)]
pub enum Precision {Bits53,Bits64}
fn rounded(value:u128,precision:u32)->(u128,i32) {
    let bits=128-value.leading_zeros();let shift=bits.saturating_sub(precision);
    if shift==0 {return (value,0)}
    let top=value>>shift;let tail=value-(top<<shift);let half=1u128<<(shift-1);
    (top+u128::from(tail>half || (tail==half && top&1!=0)),shift as i32)
}
pub fn scaled_size(height:u32,requested:u32,precision:Precision)->u32 {
    let precision=match precision {Precision::Bits53=>53,Precision::Bits64=>64};
    // 0x3AAAAAAB is exactly 11184811 * 2^-33, not the rational 1/768.
    // Simulate rounded X87 multiplies and the qword store without host FPU assumptions.
    let (n,mut exponent)=rounded(u128::from(height)*11184811,precision);exponent-=33;
    let (n,shift)=rounded(n*u128::from(requested),precision);exponent+=shift;
    let (n,shift)=rounded(n,53);exponent+=shift;
    let ceiling=if exponent>=0 {n<<exponent as u32} else {(n+(1u128<<(-exponent as u32))-1)>>(-exponent as u32)};
    // Original FISTP writes i64; the constructor stores only its low 32 bits.
    ceiling as u32
}
pub fn concordant_size(height:u32,requested:u32)->Result<u32,&'static str> {
    let a=scaled_size(height,requested,Precision::Bits53);let b=scaled_size(height,requested,Precision::Bits64);
    if a==b {Ok(a)} else {Err("native font precision context required")}
}
#[derive(Clone,Debug)]
pub struct Metadata {pub family:Vec<u8>,pub requested:u32,pub scaled:u32,pub flags:u32}
pub fn metadata(height:u32,request:&crate::native_hud_font_requests::Request)->Result<Metadata,&'static str> {
    Ok(Metadata {family:request.name.clone(),requested:request.size,scaled:concordant_size(height,request.size)?,flags:0x10|if request.shadow {4}else{0}})
}
#[derive(Resource,Default)]
pub struct Sizes {pub height:Option<u32>,pub texts:Vec<Metadata>,pub descriptors:crate::native_font_descriptor::Registry,pub descriptor_bindings:Vec<usize>}
#[derive(SystemSet,Debug,Hash,PartialEq,Eq,Clone,Copy)]
pub struct SizingSet;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Sizes>().add_systems(Update,refresh.in_set(SizingSet));}
}
fn refresh(windows:Query<&Window,With<PrimaryWindow>>,hud:Res<crate::native_zip_provider::StartupHud>,mut sizes:ResMut<Sizes>) {
    let Ok(window)=windows.single() else {return};let height=window.physical_height();
    if height==0 || sizes.height==Some(height) {return}
    let result=hud.source_font_requests().and_then(|requests|requests.iter().map(|r|metadata(height,r).map_err(std::io::Error::other)).collect::<std::io::Result<Vec<_>>>());
    match result {
        Ok(texts)=> {let (descriptors,bindings)=match crate::native_font_descriptor::Registry::source_bindings(&texts) {Ok(v)=>v,Err(error)=>{eprintln!("Native HUD font descriptors unavailable: {error}");return}};sizes.descriptors=descriptors;sizes.descriptor_bindings=bindings;sizes.height=Some(height);sizes.texts=texts;eprintln!("Native HUD font sizing height={} texts={} factor_bits=3aaaaaab rounding=ceil precision=concordant widgets=false",height,sizes.texts.len());eprintln!("Native HUD font descriptor bindings texts={} unique={} device_lifecycle=false widgets=false",sizes.descriptor_bindings.len(),sizes.descriptors.entries.len());}
        Err(error)=>eprintln!("Native HUD font sizing unavailable: {error}"),
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_creation_2736_cases_match_size_flags_and_device_routing() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_font_creation_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],2736);
        for case in proof["cases"].as_array().unwrap() {
            let height=case["height"].as_u64().unwrap() as u32;let requested=case["requested_size"].as_u64().unwrap() as u32;
            let precision=if case["control_word"]==0x27f {Precision::Bits53}else{Precision::Bits64};
            assert_eq!(scaled_size(height,requested,precision),case["scaled_size"].as_u64().unwrap() as u32,"height={height} requested={requested} precision={precision:?}");
            let shadow=case["shadow_byte"].as_u64().unwrap()!=0;assert_eq!(0x10|if shadow {4}else{0},case["flags"].as_u64().unwrap());
            let success=case["device_success"].as_bool().unwrap();assert_eq!(case["released"],!success);assert_eq!(case["inserted"],success);assert_eq!(case["returned_font"],success);
        }
        assert_eq!(concordant_size(768,16),Ok(17));assert_eq!(concordant_size(800,16),Ok(17));assert_eq!(concordant_size(1080,16),Ok(23));
        assert!(concordant_size(u32::MAX,u32::MAX).is_err());
    }
    #[test] fn real_window_changes_refresh_all_154_source_text_sizes_against_original_results() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_font_creation_contract.json")).unwrap();let mut app=App::new();app.insert_resource(hud).add_plugins(Plugin);
        let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        for height in [800,1080,768] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1280,height);app.update();
            let sizes=app.world().resource::<Sizes>();assert_eq!(sizes.height,Some(height));assert_eq!(sizes.texts.len(),154);assert_eq!(sizes.descriptor_bindings.len(),154);assert_eq!(sizes.descriptors.entries.iter().map(|e|e.references).sum::<u32>(),154);
            for (text,id) in sizes.texts.iter().zip(&sizes.descriptor_bindings) {let d=&sizes.descriptors.entries[*id].descriptor;assert_eq!(d.size,text.scaled);assert_eq!(d.flags,text.flags);assert_eq!(d.extra,0);assert_eq!(d.name,b"Gill Sans MT Pro Medium".iter().map(|v|u16::from(*v)).collect::<Vec<_>>());}
            for text in &sizes.texts {
                let case=proof["cases"].as_array().unwrap().iter().find(|c|c["height"]==height && c["requested_size"]==text.requested && c["control_word"]==0x27f && c["shadow_byte"]==if text.flags&4!=0 {1}else{0}).unwrap();
                assert_eq!(text.scaled,case["scaled_size"].as_u64().unwrap() as u32);assert_eq!(text.flags,case["flags"].as_u64().unwrap() as u32);assert_eq!(text.family,b"Gill Sans MT Pro Medium");
            }
        }
    }
}
