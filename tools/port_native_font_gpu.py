from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
for src,dst in [('native_font_gpu.rs','crates/client/src/native_font_gpu.rs'),('native_font_ui.wgsl','assets/shaders/native_font_ui.wgsl')]:shutil.copy2(stage/src,r/dst)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_font_gpu;' not in s;s='mod native_font_gpu;\n'+s;anchor='.add_plugins(native_font_metrics::Plugin)';assert anchor in s;s=s.replace(anchor,anchor+'\n        .add_plugins(native_font_gpu::Plugin)');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8');anchor='pub struct Plugin;';s=s.replace(anchor,'#[derive(SystemSet,Debug,Hash,PartialEq,Eq,Clone,Copy)]\npub struct MetricsSet;\n'+anchor,1);s=s.replace('refresh.after(crate::native_hud_font_creation::SizingSet)','refresh.in_set(MetricsSet).after(crate::native_hud_font_creation::SizingSet)')
anchor='''            assert!(faces.atlases.iter().all(|bank|bank.bindings.len()==2 && !bank.bindings.contains_key(&32) && bank.pages.len()==1 && bank.pages[0].size==256 && bank.pages[0].dirty));'''
if anchor not in s:
 lines=[line for line in s.splitlines() if 'bank.bindings.len()==2' in line];assert len(lines)==1;anchor=lines[0]
addition='''
            let mut gpu=crate::native_font_gpu::Pages::default();let mut assets=Assets::<Image>::default();assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),19);assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),0);
            for text in 0..154 {
                let material=gpu.material_for_text(&faces,&sizes,text,65,Handle::default(),Vec4::ONE,Vec4::ZERO,Vec4::new(0.,0.,1.,1.)).unwrap();
                let image=assets.get(&material.font).unwrap();assert_eq!(image.texture_descriptor.format,bevy::render::render_resource::TextureFormat::Bgra8Unorm);assert_eq!(image.data.as_ref().unwrap(),&faces.update_atlas_for_text(&sizes,text,0).unwrap());
                assert_eq!(material.parameters.uv.to_array(),faces.atlases[sizes.descriptor_bindings[text]].bindings[&65].placement.uv);
            }
            faces.atlas_cell_for_text(&sizes,0,233).unwrap();assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),1);assert_eq!(gpu.sync(&faces,&sizes,&mut assets).unwrap(),0);
'''
s=s.replace(anchor,anchor+addition);p.write_text(s,encoding='utf-8')
shutil.copy2(stage/'port_native_font_gpu.py',r/'tools/port_native_font_gpu.py');print('native GPU page transport and UI material installed; widget layout/secondary atlas remain open')
