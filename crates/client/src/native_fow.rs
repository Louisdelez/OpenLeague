//! Original c230 arithmetic and FogOfWar shader factors.
//! Texture rasterization, native world extent and GPU bindings are separate contracts.
use bevy::prelude::*;
pub struct FogParams(Vec4);
impl FogParams {
    pub fn from_native_extent(extent:f32)->Result<Self,&'static str> {
        if !extent.is_finite() || extent<=0. {return Err("invalid native fog extent");}
        let scale=1./extent;
        if !scale.is_finite() {return Err("fog reciprocal overflow");}
        Ok(Self(Vec4::new(scale,-scale,0.,1.)))
    }
    pub fn params(&self)->Vec4 {self.0}
    /// Input native world coordinates, before Bevy unit/axis transforms.
    pub fn texture_coordinates(&self,native_xz:Vec2)->Vec2 {
        native_xz*self.0.xy()+self.0.zw()
    }
}
/// GetFogOfWarFactors: projected RGB uses this alpha only, preserving texture alpha.
/// Native #if0 edge sharpener is disabled; no extra threshold or height fade here.
pub fn projected_density(overlay_alpha:f32,visibility_red:f32)->f32 {
    overlay_alpha+(1.-overlay_alpha)*visibility_red
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn c230_upload_params_match_original_arithmetic_and_native_axes() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_params_contract.json")).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let extent=c["extent"].as_f64().unwrap() as f32;
            let params=FogParams::from_native_extent(extent).unwrap();
            assert_eq!(c["register"],230);assert_eq!(c["count"],1);
            for (actual,expected) in params.params().to_array().iter().zip(c["params"].as_array().unwrap()) {assert_eq!(*actual,expected.as_f64().unwrap() as f32);}
            assert_eq!(params.texture_coordinates(Vec2::ZERO),Vec2::new(0.,1.));
            let end=params.texture_coordinates(Vec2::splat(extent));
            assert!((end.x-1.).abs()<0.000001 && end.y.abs()<0.000001);
        }
        for extent in [0.,-1.,f32::NAN,f32::INFINITY,f32::from_bits(1)] {assert!(FogParams::from_native_extent(extent).is_err());}
    }
    #[test]
    fn projected_fog_keeps_authored_density_when_hidden_and_clears_when_visible() {
        // Original archived shader inputs: hidden uses overlay alpha, visible uses1.
        let ps=include_str!("../../../data/4.20/shaders/FogOfWar/FogOfWar_PS.hls");
        assert!(ps.contains("float visibility = lerp(fowOverlay.a, 1.0f, fowVis);"));
        let projected=include_str!("../../../data/4.20/shaders/ParticleSystem/SIMPLE_PROJECTED_PS.ps_2_0");
        assert!(projected.contains("out_color0.rgb *= fowFactors.a;"));
        for overlay in [0.,0.25,0.5,1.] {
            assert_eq!(projected_density(overlay,0.),overlay);
            assert_eq!(projected_density(overlay,1.),1.);
        }
        assert_eq!(projected_density(0.25,0.5),0.625);
    }
}

/// Native6B3F20 raw-byte query. This does not convert the mask into a shader channel.
/// Original code assumes valid coordinates; the port rejects invalid metadata/positions.
pub fn raw_mask_is_zero(native_xz:Vec2,extent:f32,dimension:usize,mask:&[u8])->Result<bool,&'static str> {
    FogParams::from_native_extent(extent)?;
    if dimension==0 || dimension.checked_mul(dimension)!=Some(mask.len()) {return Err("invalid raw fog mask dimensions");}
    if !native_xz.is_finite() || native_xz.x<0. || native_xz.y<0. || native_xz.x>=extent || native_xz.y>=extent {return Err("fog query outside native extent");}
    // Original x87 keeps a wider reciprocal than f64. Use a wider quotient rather
    // than a rounded f64 reciprocal: the latter can move exact cell edges backward.
    // This quotient matches the recorded native cases; full x87 precision modes remain open.
    let x=(native_xz.x as f64/extent as f64*dimension as f64).trunc() as usize;
    let z=(native_xz.y as f64/extent as f64*dimension as f64).trunc() as usize;
    if x>=dimension || z>=dimension {return Err("fog query rounded outside mask");}
    Ok(mask[z*dimension+x]==0)
}
#[cfg(test)]
mod raw_lookup_tests {
    use super::*;
    #[test]
    fn original_x87_point_queries_and_zero_byte_results_match() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_lookup_contract.json")).unwrap();
        assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let d=c["dimension"].as_u64().unwrap() as usize;
            let at=c["sample_index"].as_u64().unwrap() as usize;
            let byte=c["mask_byte"].as_u64().unwrap() as u8;
            let mut mask=vec![if byte==0 {255} else {0};d*d];mask[at]=byte;
            let point=Vec2::new(c["native_x"].as_f64().unwrap() as f32,c["native_z"].as_f64().unwrap() as f32);
            assert_eq!(raw_mask_is_zero(point,c["extent"].as_f64().unwrap() as f32,d,&mask).unwrap(),c["returns_zero"].as_bool().unwrap(),"native case {c}");
        }
        for point in [Vec2::new(-1.,0.),Vec2::new(0.,-1.),Vec2::new(128.,0.),Vec2::new(0.,128.),Vec2::new(f32::NAN,0.)] {assert!(raw_mask_is_zero(point,128.,128,&vec![0;128*128]).is_err());}
        assert!(raw_mask_is_zero(Vec2::ZERO,128.,128,&[0;128]).is_err());
        assert!(raw_mask_is_zero(Vec2::ZERO,128.,usize::MAX,&[]).is_err());
    }
}

/// Native normal-UV visibility branches: 0 base, 1 toward fogged, 2 toward clear.
/// Caller supplies sampled normalized texture values; no invented edge sharpening.
pub fn shader_factors(overlay:Vec4,vis:f32,height:f32,mode:u32,edge:Vec4)->Vec4 {
    let t=match mode {0=>vis,1=>vis*height,2=>vis+(1.-vis)*height,_=>panic!("unsupported native FoW factor branch")};
    let tint=(vis*edge.z).clamp(0.,1.);
    let color=overlay.truncate()+(Vec3::new(0.2,0.07,0.06)-overlay.truncate())*tint;
    color.extend(overlay.w+(1.-overlay.w)*t)
}
#[cfg(test)] mod factor_tests {
 use super::*;
 #[test] fn native_factor_modes_match_independent_rational_reference() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_factor_shader_contract.json")).unwrap();
  assert_eq!(proof["cases"].as_array().unwrap().len(),144);
  for c in proof["cases"].as_array().unwrap() {
   let f=|k:&str|c[k].as_f64().unwrap() as f32;
   let a=c["overlay"].as_array().unwrap();let overlay=Vec4::from_array(std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
   let factors=shader_factors(overlay,f("visibility"),f("height"),c["mode"].as_u64().unwrap() as u32,Vec4::new(50.,-49.,f("tint_reciprocal"),0.));
   for(i,x) in factors.to_array().iter().enumerate() {assert!((*x-c["expected"][i].as_f64().unwrap() as f32).abs()<0.000001,"case {c}");}
  }
 }
}


/// Literal native6B399F c250 upload, verified independently of configured c251.
pub fn always_below_params()->Vec4 {Vec4::new(0.,-1000.,f32::from_bits(0x3c23d70a),10.)}
pub fn fade_toward_fogged(native_y:f32)->f32 {let p=always_below_params();(native_y*p.z+p.w).clamp(0.,1.)}
#[cfg(test)] mod below_tests {
 use super::*;
 #[test] fn original_c250_uploads_and_height_boundaries_match() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_below_height_contract.json")).unwrap();assert_eq!(p["passed"],true);
  for c in p["cases"].as_array().unwrap() {assert_eq!(c["uploads"][0]["register"],250);for(i,x) in always_below_params().to_array().iter().enumerate() {assert_eq!(x.to_bits(),c["uploads"][0]["bits"][i].as_u64().unwrap() as u32);}}
  for(y,expected) in [(-1100.,0.),(-1000.,0.),(-950.,0.5),(-900.,1.),(-114.,1.),(179.,1.)] {assert!((fade_toward_fogged(y)-expected).abs()<0.000001);}
 }
}
