//! Native simple-projected emitter configuration; activation/lifecycle remains pending.
use bevy::prelude::*;
use serde_json::Value;
#[derive(Debug)]
pub struct SimpleProjectedConfig {
    pub texture:String,
    pub projection_range:f32,
    pub projection_fading:f32,
    pub color_modes:[u32;2],
    pub color_scale:Vec2,
    pub color_offset:Vec2,
    pub particle_life:f32,
    pub emitter_life:f32,
    pub particle_linger:f32,
    pub emitter_linger:f32,
    pub scale:f32,
    pub owner_scale_coefficients:[f32;3],
    pub emission_rate:f32,
    pub scale_bias:Vec2,
    pub bind_weight:Vec2,
    pub single_particle:u32,
    pub local_orientation:bool,
    pub emitter_local_orientation:bool,
    pub locked_to_emitter:bool,
    pub simple_orientation:i32,
}
fn required_scalar(group:&Value,key:&str)->Result<f32,String> {
    let value=group[key].as_f64().ok_or_else(||format!("simple projected {key}: native scalar required"))? as f32;
    value.is_finite().then_some(value).ok_or_else(||format!("simple projected {key}: nonfinite value"))
}
fn native_bool(group:&Value,key:&str,default:bool)->Result<bool,String> {
    match group.get(key) {
        None=>Ok(default),Some(v)=>match v.as_i64() {Some(0)=>Ok(false),Some(1)=>Ok(true),_=>Err(format!("simple projected {key}: native boolean required"))}
    }
}
fn pair(group:&Value,key:&str,default:Vec2)->Result<Vec2,String> {
    if group.get(key).is_none() {return Ok(default);}
    let values=group[key].as_array().filter(|v|v.len()==2).ok_or_else(||format!("simple projected {key}: native pair required"))?;
    let value=Vec2::new(values[0].as_f64().ok_or("invalid native pair component")? as f32,values[1].as_f64().ok_or("invalid native pair component")? as f32);
    value.is_finite().then_some(value).ok_or_else(||format!("simple projected {key}: nonfinite pair"))
}
// Native91EF33..91EFC9 uses defaults10/0 and replaces values outside[0,10] with10.
fn linger(group:&Value,key:&str,default:f32)->Result<f32,String> {
    let value=if group.get(key).is_none() {default} else {required_scalar(group,key)?};
    Ok(if (0. ..=10.).contains(&value) {value} else {10.})
}
impl SimpleProjectedConfig {
    /// Shared constant Simple cycle parameters for the five native invisible
    /// ambient children. Projection fields are unused by this non-rendered path.
    pub fn from_ambient_troy(document:&Value)->Result<Self,String> {
        let system=&document["sections"]["System"];
        let name=system["GroupPart1"].as_str().ok_or("ambient Simple group missing")?;
        if crate::native_particle_class::EmitterClass::from_system(system,1)? != crate::native_particle_class::EmitterClass::Simple
            || (2..=64).any(|i|system.get(format!("GroupPart{i}")).is_some()) {return Err("unsupported ambient child topology".into());}
        let group=document["sections"][name].as_object().ok_or("ambient group missing")?;
        let expected=serde_json::json!({"p-life":0,"e-rate":1,"p-texture":"black.tga","p-rgba":"black.tga","rendermode":0,"e-life":-1,"p-scale":0});
        if group!=expected.as_object().unwrap() {return Err("unqualified ambient Simple profile".into());}
        //91E593 seeds p-local-orient output0; both lookup branches pass default0.
        //91E06F..91E08D single default0. Other defaults are shared with the
        // qualified projected reader; negative life follows91DDFC..91DE17.
        Ok(Self {texture:group["p-texture"].as_str().unwrap().into(),projection_range:5.,projection_fading:200.,
            color_modes:[1,0],color_scale:Vec2::ONE,color_offset:Vec2::ZERO,
            particle_life:0.,emitter_life:f32::MAX,particle_linger:10.,emitter_linger:0.,scale:0.,
            owner_scale_coefficients:[0.;3],emission_rate:1.,scale_bias:Vec2::ONE,bind_weight:Vec2::ZERO,
            single_particle:0,local_orientation:false,emitter_local_orientation:true,locked_to_emitter:false,simple_orientation:0})
    }
    pub fn from_troy(document:&Value,name:&str)->Result<Self,String> {
        let sections=&document["sections"];let system=&sections["System"];
        let slot=(1..=64).find(|i|system[format!("GroupPart{i}")].as_str()==Some(name)).ok_or("native group not declared")?;
        if crate::native_particle_class::EmitterClass::from_system(system,slot)? != crate::native_particle_class::EmitterClass::Simple {
            return Err("native group does not select a Simple emitter".into());
        }
        let group=&sections[name];
        if group["p-type"].as_i64()!=Some(7) {return Err("native group is not a type7 projected emitter".into());}
        let particle_life=required_scalar(group,"p-life")?;
        let authored_emitter_life=required_scalar(group,"e-life")?;
        // Native91DDFC..91DE17 stores maximum finite f32 for negative e-life.
        let emitter_life=if authored_emitter_life<0. {f32::MAX}else{authored_emitter_life};
        let scale=required_scalar(group,"p-scale")?;
        // Native91EFE4..91F087 offsets210/220/218; absent keys default to zero.
        let keys=["p-flexscale","p-scalebyradius","p-scalebyheight"];
        let mut owner_scale_coefficients=[0.;3];
        for (i,key) in keys.iter().enumerate(){if group.get(*key).is_some(){owner_scale_coefficients[i]=required_scalar(group,key)?;}}
        let emission_rate=if group.get("e-rate").is_some(){required_scalar(group,"e-rate")?}else{100.}; //91C0C0 table74
        let particle_linger=linger(group,"p-linger",10.)?;
        let emitter_linger=linger(group,"e-linger",0.)?;
        let local_orientation=match group["p-local-orient"].as_i64() {
            Some(0)=>false,Some(1)=>true,_=>return Err("native local-orient must be explicitly authored as0or1".into())
        };
        let single_particle=match group.get("single-particle") {
            None=>0,Some(v)=>u32::try_from(v.as_u64().ok_or("invalid native single-particle")?).map_err(|_|"single-particle outside native u32")?
        };
        let simple_orientation=match group.get("p-simpleorient") {
            None=>0,Some(v)=>i32::try_from(v.as_i64().ok_or("invalid native simple orientation")?).map_err(|_|"simple orientation outside native i32")?
        };
        // Verified91C0C0 initializer defaults, corroborated by91EB75/91EBF0 reader offsets.
        let scale_bias=pair(group,"p-scalebias",Vec2::ONE)?;
        let bind_weight=pair(group,"p-bindtoemitter",Vec2::ZERO)?;
        //91C0C0 initializes150=1,160=0,161=0; native reader keys archived separately.
        let emitter_local_orientation=native_bool(group,"e-local-orient",true)?;
        let locked_to_emitter=native_bool(group,"p-lockedtoemitter",false)?;
        if native_bool(group,"p-followterrain",false)? {return Err("native terrain-follow consumer remains unqualified".into());}
        // Native91EC5B..91ED28: mode defaults1/0, scale1/1, offset0/0.
        let color_modes=match group.get("p-colortype") {
            None=>[1,0],Some(v)=>{
                let text=v.as_str().ok_or("native p-colortype requires integer pair string")?;
                let values=text.split_whitespace().map(str::parse::<u32>).collect::<Result<Vec<_>,_>>().map_err(|_|"invalid native color modes")?;
                values.try_into().map_err(|_|"native color modes require two values")?
            }
        };
        let color_scale=pair(group,"p-colorscale",Vec2::ONE)?;
        let color_offset=pair(group,"p-coloroffset",Vec2::ZERO)?;
        let texture=group["p-texture"].as_str().ok_or("native projected texture required")?.to_string();
        if particle_life<=0. || emitter_life<=0. || scale==0. || texture.is_empty() {return Err("unsupported projected lifetime, scale or texture".into());}
        let projection_range=if group.get("p-projection-y-range").is_some(){required_scalar(group,"p-projection-y-range")?}else{5.};
        let projection_fading=if group.get("p-projection-fading").is_some(){required_scalar(group,"p-projection-fading")?}else{200.};
        if projection_fading<=0. {return Err("nonpositive native projection fading remains unqualified".into());}
        Ok(Self {texture,projection_range,projection_fading,color_modes,color_scale,color_offset,particle_life,emitter_life,particle_linger,emitter_linger,scale,owner_scale_coefficients,emission_rate,scale_bias,bind_weight,single_particle,local_orientation,emitter_local_orientation,locked_to_emitter,simple_orientation})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn document()->Value {serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap()}
    #[test]
    fn native_base_q_preserves_simple_kind_scalar_scale_lifetimes_and_verified_defaults() {
        let cfg=SimpleProjectedConfig::from_troy(&document(),"Projected").unwrap();
        assert_eq!(cfg.texture,"disintegrate-light.dds");
        assert_eq!((cfg.particle_life,cfg.emitter_life,cfg.scale),(2.,1.,500.));
        assert_eq!(cfg.scale_bias,Vec2::ONE);assert_eq!(cfg.bind_weight,Vec2::ZERO);
        assert_eq!((cfg.particle_linger,cfg.emitter_linger),(0.,0.));
        assert_eq!(cfg.single_particle,1);assert!(cfg.local_orientation);assert_eq!(cfg.simple_orientation,0);
        assert!(cfg.emitter_local_orientation);assert!(!cfg.locked_to_emitter);
        let native:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_emitter_defaults_contract.json")).unwrap();
        assert_eq!(native["fields_raw"]["0x158"],0);assert_eq!(native["fields_raw"]["0x15c"],0);
        assert_eq!(native["fields_raw"]["0x1d4"],0x3f800000u32);assert_eq!(native["fields_raw"]["0x1d8"],0x3f800000u32);
        assert_eq!(native["flags_raw"]["0x150"],1);assert_eq!(native["flags_raw"]["0x160"],0);assert_eq!(native["flags_raw"]["0x161"],0);
    }
    #[test]
    fn complex_group_missing_authored_orientation_and_invalid_scalar_or_pair_are_explicitly_rejected() {
        assert!(SimpleProjectedConfig::from_troy(&document(),"Fire").is_err());
        let mut d=document();d["sections"]["Projected"]["p-scale"]=serde_json::json!([500.,500.,500.]);
        assert!(SimpleProjectedConfig::from_troy(&d,"Projected").is_err());
        let mut d=document();d["sections"]["Projected"]["p-followterrain"]=serde_json::json!(1);
        assert!(SimpleProjectedConfig::from_troy(&d,"Projected").is_err());
        let mut d=document();d["sections"]["Projected"].as_object_mut().unwrap().remove("p-local-orient");
        assert!(SimpleProjectedConfig::from_troy(&d,"Projected").is_err());
        let mut d=document();d["sections"]["Projected"]["p-scalebias"]=serde_json::json!([1.]);
        assert!(SimpleProjectedConfig::from_troy(&d,"Projected").is_err());
    }

    #[test]
    fn linger_defaults_and_clamps_match_original_reader_call_sites() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_linger_defaults_contract.json")).unwrap();
        for case in proof["cases"].as_array().unwrap() {
            let mut d=document();let group=d["sections"]["Projected"].as_object_mut().unwrap();
            for (i,key) in ["p-linger","e-linger"].iter().enumerate() {
                group.remove(*key);
                if !case["supplied"][i].is_null() {group.insert(key.to_string(),case["supplied"][i].clone());}
            }
            let c=SimpleProjectedConfig::from_troy(&d,"Projected").unwrap();
            assert_eq!(c.particle_linger,case["particle_linger"].as_f64().unwrap() as f32);
            assert_eq!(c.emitter_linger,case["emitter_linger"].as_f64().unwrap() as f32);
        }
    }
    #[test]
    fn negative_emitter_lifetime_matches_native_simple_reader_in_projected_config() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_emitter_lifetime_contract.json")).unwrap();
        let mut checked=0;
        for row in proof["cases"].as_array().unwrap() {
            let Some(raw)=row["emitter_authored_bits"].as_str() else {continue;};
            let authored=f32::from_bits(u32::from_str_radix(raw.trim_start_matches("0x"),16).unwrap());
            if !authored.is_finite() || authored==0. {continue;}
            let expected=u32::from_str_radix(row["lifetime_bits"].as_str().unwrap().trim_start_matches("0x"),16).unwrap();
            let mut doc=document();doc["sections"]["Projected"]["e-life"]=serde_json::json!(authored);
            let config=SimpleProjectedConfig::from_troy(&doc,"Projected").unwrap();
            assert_eq!(config.emitter_life.to_bits(),expected);checked+=1;
        }
        assert_eq!(checked,20);
    }

    #[test]
    fn real_ambient_definitions_feed_the_continuous_simple_cycle() {
        use crate::{native_projected_cycle::NativeProjectedCycle,simple_owner_pose::SimpleOwnerPose,simple_cycle::OwnerEnd};
        for raw in [include_str!("../../../data/4.20/particles/Audio-Emitter_TT_BrazierChains.json"),
            include_str!("../../../data/4.20/particles/Audio-Emitter_TT_ChainsSwing.json"),
            include_str!("../../../data/4.20/particles/Audio-Emitter_TT_ChainsSwingBase.json"),
            include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle.json"),
            include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle2.json")] {
            let mut document:Value=serde_json::from_str(raw).unwrap();
            let c=SimpleProjectedConfig::from_ambient_troy(&document).unwrap();
            let owner=SimpleOwnerPose::new(Vec3::new(100.,200.,300.),Mat4::IDENTITY,0.).unwrap();
            let mut cycle=NativeProjectedCycle::new(10.,&owner,&c,openleague_core::native_random::Rng55::seeded(17)).unwrap();
            for age in [0.,0.125,0.5,1.,2.,3.] {
                cycle.step(10.+age,&owner,None,&c).unwrap();assert!(!cycle.finished);assert_eq!(cycle.active_count,0);
            }
            cycle.step(13.125,&owner,Some(&OwnerEnd {system_start:10.,emitter_linger:c.emitter_linger,particle_linger:c.particle_linger}),&c).unwrap();
            assert!(cycle.finished);
            document["sections"]["empty"]["e-rate"]=serde_json::json!(2);
            assert!(SimpleProjectedConfig::from_ambient_troy(&document).is_err());
        }
    }

}
