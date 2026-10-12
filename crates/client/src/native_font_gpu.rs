//! Native CPU atlas bytes transported to BGRA GPU images and original glyph materials.
//! Native text layout/samplers/color-space and secondary glow generation remain separate.
use bevy::{prelude::*,asset::RenderAssetUsages,render::render_resource::{BlendFactor,BlendOperation,Extent3d,TextureDimension,TextureFormat,TextureUsages},ui_render::UiMaterialPlugin};
pub use crate::native_font_material::{FontMaterial,Parameters,blend};
#[derive(Resource,Default)]
pub struct Pages {pub height:Option<u32>,pub banks:Vec<Vec<Handle<Image>>>,queued_cells:Vec<Vec<usize>>}
impl Pages {
    /// Queue owned image payloads. This is not confirmation of asynchronous GPU upload.
    pub fn sync(&mut self,faces:&crate::native_font_metrics::Faces,sizes:&crate::native_hud_font_creation::Sizes,assets:&mut Assets<Image>)->Result<usize,String> {
        if faces.height!=sizes.height || sizes.height.is_none() {return Err("font GPU sizes unavailable or stale".into())}
        if self.height!=faces.height {self.height=faces.height;self.banks=(0..faces.atlases.len()).map(|_|Vec::new()).collect();self.queued_cells=(0..faces.atlases.len()).map(|_|Vec::new()).collect();}
        let mut updated=0;
        for (face,bank) in faces.atlases.iter().enumerate() {
            let text=sizes.descriptor_bindings.iter().position(|id|*id==face).ok_or("font GPU source Text reference missing")?;
            for (page_index,page) in bank.pages.iter().enumerate() {
                let count=bank.page_cells(page_index).map_err(|e|e.to_string())?.len();
                if self.queued_cells[face].get(page_index)==Some(&count) {continue}
                let pixels=faces.update_atlas_for_text(sizes,text,page_index)?;
                let mut image=Image::new(Extent3d {width:page.size as u32,height:page.size as u32,depth_or_array_layers:1},TextureDimension::D2,pixels,TextureFormat::Bgra8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
                image.texture_descriptor.usage=TextureUsages::TEXTURE_BINDING|TextureUsages::COPY_DST|TextureUsages::COPY_SRC;
                image.sampler=crate::native_font_material::sampler(0,false).map_err(str::to_owned)?;
                if let Some(handle)=self.banks[face].get(page_index) {
                    *assets.get_mut(handle).ok_or("font atlas image payload missing")?=image;self.queued_cells[face][page_index]=count;
                }else {self.banks[face].push(assets.add(image));self.queued_cells[face].push(count);}
                updated+=1;
            }
        }
        Ok(updated)
    }
    /// Source atlas page + native quad -> material without caller color/UV reconstruction.
    pub fn material_for_quad(&self,faces:&crate::native_font_metrics::Faces,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16,quad:&openleague_font_raster::native_font_quad::Quad,fill_texture:Handle<Image>,viewport_offset:Vec2)->Result<(Node,FontMaterial),String> {
        let (node,parameters)=crate::native_font_material::ui_quad(quad,viewport_offset)?;
        let material=self.material_for_text(faces,sizes,text,character,fill_texture,parameters.color0,parameters.color1,parameters.fill_uv)?;
        if material.parameters.uv!=parameters.uv {return Err("HUD glyph quad UV does not match source atlas cell".into())}
        Ok((node,FontMaterial {parameters,..material}))
    }
    pub fn material_for_text(&self,faces:&crate::native_font_metrics::Faces,sizes:&crate::native_hud_font_creation::Sizes,text:usize,character:u16,fill_texture:Handle<Image>,color0:Vec4,color1:Vec4,fill_uv:Vec4)->Result<FontMaterial,String> {
        if self.height!=sizes.height || faces.height!=sizes.height {return Err("font GPU material sizes stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("font GPU Text binding missing")?;
        let binding=faces.atlases.get(face).and_then(|b|b.bindings.get(&character)).ok_or("native glyph cell unavailable")?;
        let font=self.banks.get(face).and_then(|pages|pages.get(binding.page)).cloned().ok_or("native glyph page not queued")?;
        Ok(FontMaterial {parameters:Parameters {uv:Vec4::from_array(binding.placement.uv),fill_uv,color0,color1},font,fill:fill_texture,glow:false})
    }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Pages>().add_plugins(UiMaterialPlugin::<FontMaterial>::default()).add_systems(Update,sync.after(crate::native_font_metrics::MetricsSet));}
}
fn sync(faces:NonSend<crate::native_font_metrics::Faces>,sizes:Res<crate::native_hud_font_creation::Sizes>,mut pages:ResMut<Pages>,mut assets:ResMut<Assets<Image>>) {
    if sizes.height.is_none() || faces.height!=sizes.height {return}
    match pages.sync(&faces,&sizes,&mut assets) {Ok(0)=>{},Ok(count)=>eprintln!("Native font atlas image payloads queued={} format=BGRA8 GPU_ack=false widgets=false",count),Err(error)=>eprintln!("Native font atlas image unavailable: {error}")}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn material_blend_matches_original_d3d_setter_contract() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_blend_state_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],4);
        for case in proof["cases"].as_array().unwrap().iter().filter(|c|c["cached"]==false) {
            let value=blend(case["pass"]=="glow");let native=|factor:BlendFactor|match factor {BlendFactor::One=>2,BlendFactor::SrcAlpha=>5,BlendFactor::OneMinusSrcAlpha=>6,_=>panic!("unqualified blend")};
            for (channel,src_state,dst_state) in [(value.color,19,20),(value.alpha,207,208)] {
                let find=|state:i32|case["calls"].as_array().unwrap().iter().find(|x|x[0]==state).unwrap()[1].as_i64().unwrap();assert_eq!(i64::from(native(channel.src_factor)),find(src_state));assert_eq!(i64::from(native(channel.dst_factor)),find(dst_state));assert_eq!(channel.operation,BlendOperation::Add);
            }
        }
    }
}
