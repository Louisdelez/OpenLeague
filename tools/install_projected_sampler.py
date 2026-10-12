from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');p=r/'crates/client/src/terrain_material.rs';backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True);shutil.copy2(p,backup/p.name)
s=p.read_text(encoding='utf-8');start=s.index('            // Legacy HLSL');end=s.index('\n        })',start);body=s[start:end];s=s[:start]+'            configure_image(s, tiled);'+s[end:];marker='pub(crate) fn image('
helper='fn configure_image(s: &mut ImageLoaderSettings, tiled: bool) {\n'+body+'\n}\n'
s=s.replace(marker,helper+marker,1)
s+='''
#[cfg(test)]
mod projected_sampler_tests {
    use super::*;
    #[test]
    fn production_projected_image_addressing_matches_original_dispatch_and_cache_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_sampler_contract.json")).unwrap();
        let mut settings=ImageLoaderSettings::default();
        configure_image(&mut settings,false);
        let ImageSampler::Descriptor(sampler)=settings.sampler else {panic!("explicit projected sampler required")};
        assert_eq!(sampler.address_mode_u,ImageAddressMode::ClampToEdge);
        assert_eq!(sampler.address_mode_v,ImageAddressMode::ClampToEdge);
        for case in proof["cases"].as_array().unwrap() {
            let calls=case["calls"].as_array().unwrap();
            if case["initial_cached"]==2 {assert!(calls.is_empty());}
            else {
                assert_eq!(calls.len(),6);
                for stage in 0..3 {
                    // Native D3D address U/V states1/2 both receive CLAMP3.
                    assert!(calls.contains(&serde_json::json!([stage,1,3])));
                    assert!(calls.contains(&serde_json::json!([stage,2,3])));
                }
            }
            assert_eq!(case["final_cached"],serde_json::json!([[2,2],[2,2],[2,2]]));
        }
    }
}
'''
p.write_text(s,encoding='utf-8');shutil.copy2(w/'probe_native_projected_sampler.py',r/'tools/probe_native_projected_sampler.py')
print('Production image settings preserved; native sampler regression linked to actual loader.')
