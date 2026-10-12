from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8')
assert 'mod hud_wrapper_tests' not in s
s+='''
#[cfg(test)] mod hud_wrapper_tests {
    use super::*;
    #[test] fn hud_wrapper_connects154_source_fonts_to_native_fixture_positions_and_colors() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,Plugin));app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
        let sizes=app.world_mut().remove_resource::<crate::native_hud_font_creation::Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
        let contract:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_draw_contract.json")).unwrap();
        for text in 0..154 {for alignment in 0..3 {
            let face=sizes.descriptor_bindings[text];let flags=sizes.descriptors.entries[face].descriptor.flags;
            let fixture=contract["cases"].as_array().unwrap().iter().find(|c|c["font_flags"].as_u64()==Some(flags as u64) && c["alignment"].as_u64()==Some(alignment) && c["rect"][0].as_f64()==Some(10.75) && c["color"].as_u64()==Some(0xffa1b2c3)).unwrap();
            let args=&fixture["draw_argument_bits"];let anchor=[f32::from_bits(args[1].as_u64().unwrap() as u32),f32::from_bits(args[2].as_u64().unwrap() as u32)];
            let geometry=faces.hud_text_geometry(&sizes,text,&[65,0,86],[10.75,7.25,91.5,46.5],alignment as u32,0xffa1b2c3).unwrap();
            assert_eq!(geometry.glyphs.len(),1);assert_eq!(geometry.glyphs[0].0,65);
            let width=geometry.dimensions[0];let adjustment=match alignment {0=>0,1=>width/2,_=>width};
            let bearing=faces.glyph_for_text(&sizes,text,65).unwrap().metrics.bearing_x;
            let ascender=faces.prepared[face].metrics.ascender_26_6>>6;
            let first=&geometry.glyphs[0].1.vertices[0];
            assert_eq!(first.position[0],(anchor[0]-adjustment as f32+bearing as f32).floor()-0.5);
            assert_eq!(first.position[1],(anchor[1]-ascender as f32).floor()-0.5);
            assert!(geometry.glyphs[0].1.vertices.iter().all(|v|v.colors==[0xffa1b2c3,0]));
        }}
        assert!(faces.hud_text_geometry(&sizes,154,&[65],[0.0;4],0,0).is_err());
    }
}
'''
p.write_text(s,encoding='utf-8');print('HUD bridge integration test added')
