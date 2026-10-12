from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['terrain_material.rs','projected_live.rs','projected_render.rs']:shutil.copy2(r/'crates/client/src'/name,b/name)
p=r/'crates/client/src/terrain_material.rs';s=p.read_text(encoding='utf-8');marker='pub fn setup('
helper='''// Original particle manager sets stage0 MIPFILTER NONE; WGPU uses an explicit LOD clamp.
fn configure_projected_image(settings:&mut ImageLoaderSettings) {
    configure_image(settings,false);
    if let ImageSampler::Descriptor(sampler)=&mut settings.sampler {
        sampler.lod_min_clamp=0.;
        sampler.lod_max_clamp=0.;
    }
}
pub(crate) fn projected_image(assets:&AssetServer,path:String)->Handle<Image> {
    assets.load_builder().with_settings(configure_projected_image).load(path)
}
'''
assert 'fn configure_projected_image' not in s;s=s.replace(marker,helper+marker,1)
s+='''
#[cfg(test)]
mod projected_filter_tests {
    use super::*;
    #[test]
    fn projected_loader_matches_original_linear_filters_and_disables_mip_selection() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particle_filter_contract.json")).unwrap();
        let cold=&p["cases"][0]["calls"].as_array().unwrap();
        for pair in [[0,5,2],[0,6,2],[0,7,0]] {assert!(cold.contains(&serde_json::json!(pair)));}
        let mut settings=ImageLoaderSettings::default();configure_projected_image(&mut settings);
        let ImageSampler::Descriptor(s)=settings.sampler else {panic!("explicit projected sampler required")};
        assert_eq!(s.mag_filter,ImageFilterMode::Linear);assert_eq!(s.min_filter,ImageFilterMode::Linear);
        assert_eq!(s.lod_min_clamp,0.);assert_eq!(s.lod_max_clamp,0.);
        assert_eq!(s.address_mode_u,ImageAddressMode::ClampToEdge);assert_eq!(s.address_mode_v,ImageAddressMode::ClampToEdge);
    }
}
''';p.write_text(s,encoding='utf-8')
for name in ['projected_live.rs','projected_render.rs']:
 p=r/'crates/client/src'/name;s=p.read_text(encoding='utf-8');s=s.replace('terrain_material::image(&assets,"particles/annie/disintegrate-light.png".into(),false)','terrain_material::projected_image(&assets,"particles/annie/disintegrate-light.png".into())');p.write_text(s,encoding='utf-8')
s=(r/'tools/capture_projected_live_v3.py').read_text(encoding='utf-8').replace('5985','5986').replace('projected-live-v3','projected-live-v4').replace('projected_normal_capture_v3.json','projected_normal_capture_v4.json');(r/'tools/capture_projected_live_v4.py').write_text(s,encoding='utf-8')
print('Projected-only LOD0 enforced; other image loaders preserved.')
