from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
p=r/'crates/client/src/main.rs';shutil.copy2(p,b/'main.rs');s=p.read_text(encoding='utf-8');assert 'mod native_fow;' not in s;s='#[allow(dead_code)]\nmod native_fow;\n'+s;p.write_text(s,encoding='utf-8')
(r/'crates/client/src/native_fow.rs').write_text('''//! Original c230 arithmetic and FogOfWar shader factors.
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
''',encoding='utf-8')
for name in ['discover_fow_constants.py','probe_fow_params.py','install_fow_math.py']:shutil.copy2(w/name,r/'tools'/name)
print('Native fog coordinate/density module ready; native extent provider and GPU bindings explicitly pending.')
