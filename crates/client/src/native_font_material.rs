use bevy::{prelude::*,render::render_resource::{AsBindGroup,ShaderType,RenderPipelineDescriptor,BlendState,BlendComponent,BlendFactor,BlendOperation},shader::ShaderRef,ui_render::ui_material::{UiMaterial,UiMaterialKey}};
#[derive(Clone,Copy,Debug,ShaderType)]
pub struct Parameters {pub uv:Vec4,pub fill_uv:Vec4,pub color0:Vec4,pub color1:Vec4}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)] pub struct Key {pub glow:bool}
#[derive(Asset,TypePath,AsBindGroup,Clone,Debug)]
#[bind_group_data(Key)]
pub struct FontMaterial {
    #[uniform(0)] pub parameters:Parameters,
    #[texture(1)] #[sampler(2)] pub font:Handle<Image>,
    #[texture(3)] #[sampler(4)] pub fill:Handle<Image>,
    pub glow:bool,
}
impl From<&FontMaterial> for Key {fn from(material:&FontMaterial)->Self {Self {glow:material.glow}}}
pub fn blend(glow:bool)->BlendState {
    let component=if glow {BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add}}else {BlendComponent {src_factor:BlendFactor::One,dst_factor:BlendFactor::SrcAlpha,operation:BlendOperation::Add}};
    BlendState {color:component,alpha:component}
}
impl UiMaterial for FontMaterial {
    fn fragment_shader()->ShaderRef {"shaders/native_font_ui.wgsl".into()}
    fn specialize(descriptor:&mut RenderPipelineDescriptor,key:UiMaterialKey<Self>) {
        if let Some(fragment)=&mut descriptor.fragment {if key.bind_group_data.glow {fragment.shader_defs.push("NATIVE_FONT_GLOW".into());} for target in fragment.targets.iter_mut().flatten() {target.blend=Some(blend(key.bind_group_data.glow));}}
    }
}

/// Qualified native stage0 glyph and stage1 fill sampling. Address/gamma are separate.
pub fn sampler(stage:u32,glow:bool)->Result<bevy::image::ImageSampler,&'static str> {
    match (stage,glow) {(0,false)=>Ok(bevy::image::ImageSampler::nearest()),(0,true)|(1,false)=>Ok(bevy::image::ImageSampler::linear()),_=>Err("native font sampler stage unqualified")}
}
#[cfg(test)] mod sampler_tests {
    use super::*;
    #[test] fn all9_native_font_sampler_cases_match_actual_image_filter_descriptors() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_sampler_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],9);
        for case in proof["cases"].as_array().unwrap() {
            let bevy::image::ImageSampler::Descriptor(descriptor)=sampler(case["stage"].as_u64().unwrap() as u32,case["pass"]=="glow").unwrap() else {panic!("explicit native sampler expected")};
            let value=match case["native_state"].as_u64().unwrap() {4=>descriptor.mag_filter,5=>descriptor.min_filter,6=>descriptor.mipmap_filter,_=>panic!("unqualified state")};
            let expected=if case["d3d_calls"][0][2]==1 {"Nearest"}else {"Linear"};assert_eq!(format!("{value:?}"),expected);
        }
        assert!(sampler(1,true).is_err());assert!(sampler(2,false).is_err());
    }
}

/// Native packed ARGB -> linear numeric RGBA parameters. Original shader variants pass xyzw.
pub fn packed_color(color:u32)->Vec4 {Vec4::new(((color>>16)&255) as f32/255.,((color>>8)&255) as f32/255.,(color&255) as f32/255.,(color>>24) as f32/255.)}
/// Transport an axis-aligned original glyph quad into UI. Caller must supply viewport offset.
/// Explicit offset is not a claim that the original projection/half-texel conversion is complete.
pub fn ui_quad(quad:&openleague_font_raster::native_font_quad::Quad,viewport_offset:Vec2)->Result<(Node,Parameters),String> {
    let v=&quad.vertices;let [x,y,z]=v[0].position;let [right,bottom,z2]=v[2].position;
    if !viewport_offset.is_finite() || !v.iter().all(|v|v.position.iter().chain(v.atlas_uv.iter()).chain(v.fill_uv.iter()).all(|n|n.is_finite())) || z!=0. || z2!=0. || v[1].position!=[right,y,0.] || v[3].position!=[x,bottom,0.] || right<x || bottom<y {return Err("native glyph quad cannot use axis-aligned UI transport".into())}
    if quad.indices!=[0,1,2,0,2,3] || v.iter().any(|vertex|vertex.colors!=v[0].colors) || v[1].atlas_uv!=[v[2].atlas_uv[0],v[0].atlas_uv[1]] || v[3].atlas_uv!=[v[0].atlas_uv[0],v[2].atlas_uv[1]] || v[1].fill_uv!=[v[2].fill_uv[0],v[0].fill_uv[1]] || v[3].fill_uv!=[v[0].fill_uv[0],v[2].fill_uv[1]] {return Err("native glyph UV/color/index interpolation unsupported by UI transport".into())}
    let node=Node {position_type:PositionType::Absolute,left:Val::Px(x+viewport_offset.x),top:Val::Px(y+viewport_offset.y),width:Val::Px(right-x),height:Val::Px(bottom-y),..default()};
    let parameters=Parameters {uv:Vec4::new(v[0].atlas_uv[0],v[0].atlas_uv[1],v[2].atlas_uv[0],v[2].atlas_uv[1]),fill_uv:Vec4::new(v[0].fill_uv[0],v[0].fill_uv[1],v[2].fill_uv[0],v[2].fill_uv[1]),color0:packed_color(v[0].colors[0]),color1:packed_color(v[0].colors[1])};Ok((node,parameters))
}
#[cfg(test)] mod quad_transport_tests {
    use super::*;
    #[test] fn packed_colors_and_actual_native_quad_bytes_transport_without_channel_or_origin_loss() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_vertex_color_contract.json")).unwrap();assert_eq!(proof["case_count"],256);assert_eq!(proof["passed"],true);
        for c in proof["cases"].as_array().unwrap() {let color=packed_color(c["packed"].as_u64().unwrap() as u32).to_array();let v=c["argb"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as f32/255.).collect::<Vec<_>>();assert_eq!(color,[v[1],v[2],v[3],v[0]]);}
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_quad_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let hex=c["vertex_bytes_hex"].as_str().unwrap();let bytes=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
            let vertex=|index:usize|{let chunk=&bytes[index*36..(index+1)*36];let w=chunk.chunks_exact(4).map(|c|u32::from_le_bytes(c.try_into().unwrap())).collect::<Vec<_>>();openleague_font_raster::native_font_quad::Vertex {position:[f32::from_bits(w[0]),f32::from_bits(w[1]),f32::from_bits(w[2])],colors:[w[3],w[4]],atlas_uv:[f32::from_bits(w[5]),f32::from_bits(w[6])],fill_uv:[f32::from_bits(w[7]),f32::from_bits(w[8])]}};
            let quad=openleague_font_raster::native_font_quad::Quad {vertices:[vertex(0),vertex(1),vertex(2),vertex(3)],indices:[0,1,2,0,2,3]};let (node,p)=ui_quad(&quad,Vec2::new(0.5,0.5)).unwrap();assert_eq!(node.left,Val::Px(quad.vertices[0].position[0]+0.5));assert_eq!(node.top,Val::Px(quad.vertices[0].position[1]+0.5));assert_eq!(p.color0,packed_color(quad.vertices[0].colors[0]));assert_eq!(p.uv.to_array(),[quad.vertices[0].atlas_uv[0],quad.vertices[0].atlas_uv[1],quad.vertices[2].atlas_uv[0],quad.vertices[2].atlas_uv[1]]);
        }
    }
}
