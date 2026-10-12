from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_text_render.rs';assert not p.exists()
p.write_text('''//! Prepared native Text packets -> source glyph quads -> queued UI materials.
//! Encoding, engine font IDs, fill texture and viewport projection remain explicit inputs.
use bevy::prelude::*;
use std::collections::BTreeMap;
use crate::{native_font_metrics::{Faces,TextGeometry},native_font_gpu::{Pages,FontMaterial},native_hud_font_creation::Sizes,native_hud_text_batch::Batch};
pub struct Context {pub viewport:[u32;2],pub packet_scalar:f32,pub glyph_owner_scale:f32}
pub struct Text {pub source_binding:usize,pub packet_scale:f32,pub geometry:TextGeometry}
pub struct Prepared {pub texts:Vec<Text>,pub copy_errors:Vec<(usize,u32)>}
fn word(bytes:&[u8],offset:usize)->u32 {u32::from_le_bytes(bytes[offset..offset+4].try_into().unwrap())}
pub fn prepare(faces:&mut Faces,sizes:&Sizes,batch:&Batch,context:&Context,font_bindings:&BTreeMap<u32,usize>,decode:impl Fn(&[u8])->Result<Vec<u16>,String>)->Result<Prepared,String> {
    if !context.glyph_owner_scale.is_finite() || context.glyph_owner_scale<=0.0 {return Err("unqualified HUD glyph owner scale".into())}
    if sizes.height!=Some(context.viewport[1]) || faces.height!=sizes.height {return Err("HUD text viewport/font sizes stale".into())}
    let mut prepared=Prepared {texts:Vec::new(),copy_errors:Vec::new()};
    for (index,record) in batch.records.iter().enumerate() {
        let bytes=&record.bytes;let source_binding=*font_bindings.get(&word(bytes,0)).ok_or("HUD packet font handle not bound to source Text")?;
        if source_binding>=sizes.descriptor_bindings.len() {return Err("HUD source Text binding out of range".into())}
        let normalized=std::array::from_fn(|i|f32::from_bits(word(bytes,12+i*4)));
        let (rect,packet_scale)=openleague_font_raster::native_hud_text_draw::pixel_rect(normalized,context.viewport,context.packet_scalar,bytes[284]!=0).map_err(|e|e.to_string())?;
        let content=&bytes[28..284];let length=content.iter().position(|c|*c==0).ok_or("HUD packet text has no NUL terminator")?;
        let contents=decode(&content[..length])?;
        let geometry=faces.hud_text_geometry(sizes,source_binding,&contents,rect,word(bytes,4),word(bytes,8),context.glyph_owner_scale)?;
        if let Some(error)=record.copy_error {prepared.copy_errors.push((index,error));}
        prepared.texts.push(Text {source_binding,packet_scale,geometry});
    }
    Ok(prepared)
}
/// Payloads use the exact source atlas page and quad colors/UVs after Pages::sync.
/// Caller owns material assets, target camera, widget hierarchy and lifetimes.
pub fn ui_payloads(prepared:&Prepared,faces:&Faces,sizes:&Sizes,pages:&Pages,fill:Handle<Image>,viewport_offset:Vec2)->Result<Vec<(Node,FontMaterial)>,String> {
    let mut result=Vec::new();
    for text in &prepared.texts {for (character,quad) in &text.geometry.glyphs {
        result.push(pages.material_for_quad(faces,sizes,text.source_binding,*character,quad,fill.clone(),viewport_offset)?);
    }}
    Ok(result)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn packets_for154_source_fonts_bind_colors_positions_and_correct_gpu_page_after_upload() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).insert_resource(crate::native_font_metrics::Dpi {explicit:Some([96,96])}).add_plugins((crate::native_hud_font_creation::Plugin,crate::native_font_metrics::Plugin));let window=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},bevy::window::PrimaryWindow)).id();
        let bindings=(0..154usize).map(|i|(i as u32+1,i)).collect::<BTreeMap<_,_>>();let mut pages=Pages::default();let mut images=Assets::<Image>::default();
        for viewport in [[1280,800],[1920,1080]] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(viewport[0],viewport[1]);app.update();
            let sizes=app.world_mut().remove_resource::<Sizes>().unwrap();let mut faces=app.world_mut().non_send_resource_mut::<Faces>();
            let inputs=(0..154).map(|i|crate::native_hud_text_batch::Input {flags:if i%2==0 {1}else{0x81},font:i+1,alignment:i%3,color:0xffa1b2c3,rect:[0.2,0.3,0.4,0.5],text:b"A V"}).collect::<Vec<_>>();let batch=crate::native_hud_text_batch::prepare(&inputs,[1.0,1.0,0.0,0.0]).unwrap();
            let context=Context {viewport,packet_scalar:1.0,glyph_owner_scale:1.0};let decode=|b:&[u8]|if b.is_ascii() {Ok(b.iter().map(|b|*b as u16).collect())}else {Err("test ASCII supplier only".into())};
            assert!(prepare(&mut faces,&sizes,&batch,&context,&BTreeMap::new(),decode).is_err());
            let prepared=prepare(&mut faces,&sizes,&batch,&context,&bindings,decode).unwrap();assert_eq!(prepared.texts.len(),154);assert!(prepared.copy_errors.is_empty());
            assert!(ui_payloads(&prepared,&faces,&sizes,&pages,Handle::default(),Vec2::splat(0.5)).is_err());
            pages.sync(&faces,&sizes,&mut images).unwrap();let payloads=ui_payloads(&prepared,&faces,&sizes,&pages,Handle::default(),Vec2::splat(0.5)).unwrap();assert_eq!(payloads.len(),308);
            for (text,nodes) in prepared.texts.iter().zip(payloads.chunks_exact(2)) {
                assert_eq!(text.geometry.glyphs.iter().map(|g|g.0).collect::<Vec<_>>(),[65,86]);assert!(text.packet_scale.is_finite());
                for ((character,quad),(node,material)) in text.geometry.glyphs.iter().zip(nodes) {
                    let face=sizes.descriptor_bindings[text.source_binding];let binding=&faces.atlases[face].bindings[character];assert_eq!(material.font,pages.banks[face][binding.page]);
                    assert_eq!(material.parameters.uv.to_array(),binding.placement.uv);assert_eq!(material.parameters.color0,crate::native_font_material::packed_color(0xffa1b2c3));assert_eq!(material.parameters.color1,Vec4::ZERO);assert!(!material.glow);
                    assert_eq!(node.left,Val::Px(quad.vertices[0].position[0]+0.5));assert_eq!(node.top,Val::Px(quad.vertices[0].position[1]+0.5));assert!(images.get(&material.font).unwrap().data.as_ref().unwrap().iter().any(|b|*b>0));
                }
            }
            let text=&prepared.texts[0];let (character,quad)=&text.geometry.glyphs[0];let mut bad=quad.clone();bad.vertices[0].atlas_uv[0]+=0.125;
            assert!(pages.material_for_quad(&faces,&sizes,0,*character,&bad,Handle::default(),Vec2::ZERO).is_err());
            drop(faces);app.insert_resource(sizes);
        }
    }
}
''',encoding='utf-8')
p=r/'crates/client/src/native_font_gpu.rs';s=p.read_text(encoding='utf-8');marker='    pub fn material_for_text(';idx=s.index(marker)
bridge='''    /// Source atlas page + native quad -> material without caller color/UV reconstruction.
    pub fn material_for_quad(&self,faces:&crate::native_font_metrics::Faces,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16,quad:&openleague_font_raster::native_font_quad::Quad,fill_texture:Handle<Image>,viewport_offset:Vec2)->Result<(Node,FontMaterial),String> {
        let (node,parameters)=crate::native_font_material::ui_quad(quad,viewport_offset)?;
        let material=self.material_for_text(faces,sizes,text,character,fill_texture,parameters.color0,parameters.color1,parameters.fill_uv)?;
        if material.parameters.uv!=parameters.uv {return Err("HUD glyph quad UV does not match source atlas cell".into())}
        Ok((node,FontMaterial {parameters,..material}))
    }
''';s=s[:idx]+bridge+s[idx:];p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod native_hud_text_render;\n'+s;p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('HUD packets connected to source glyph geometry and queued UI material payloads')
