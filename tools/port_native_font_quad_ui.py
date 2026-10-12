from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_font_material.rs';s=p.read_text(encoding='utf-8');assert 'pub fn ui_quad(' not in s
s+=r"""
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
            let quad=openleague_font_raster::native_font_quad::Quad {vertices:[vertex(0),vertex(1),vertex(2),vertex(3)],indices:[0,1,2,0,2,3]};let (node,p)=ui_quad(&quad,Vec2::new(.5,.5)).unwrap();assert_eq!(node.left,Val::Px(quad.vertices[0].position[0]+.5));assert_eq!(node.top,Val::Px(quad.vertices[0].position[1]+.5));assert_eq!(p.color0,packed_color(quad.vertices[0].colors[0]));assert_eq!(p.uv.to_array(),[quad.vertices[0].atlas_uv[0],quad.vertices[0].atlas_uv[1],quad.vertices[2].atlas_uv[0],quad.vertices[2].atlas_uv[1]]);
        }
    }
}
"""
p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_native_font_vertex_colors.py'),r/'tools/qualify_native_font_vertex_colors.py')
p=r/'crates/client/examples/native_font_quad_ui_probe.rs';s=(r/'crates/client/examples/native_font_ui_probe.rs').read_text(encoding='utf-8')
s=s.replace('native-font-ui-source-','native-font-quad-ui-')
old='let material=materials.add(FontMaterial {parameters:Parameters {uv:Vec4::from_array(binding.placement.uv),fill_uv:Vec4::new(0.,0.,1.,1.),color0:Vec4::ONE,color1:Vec4::ZERO},font:font_image,fill:white,glow:false});'
new='let quad=openleague_font_raster::native_font_quad::build(&openleague_font_raster::native_font_quad::Input {position:[7.75,11.25],dimensions:[cell.width,cell.height],font_scale:[1.,1.],owner_scale:1.,opacity:1.,colors:[0xffffffff,0],atlas_uv:binding.placement.uv,base_index:0}).unwrap();let (node,parameters)=native_font_material::ui_quad(&quad,Vec2::new(0.5,0.5)).unwrap();let material=materials.add(FontMaterial {parameters,font:font_image,fill:white,glow:false});'
assert old in s;s=s.replace(old,new)
old='Node {position_type:PositionType::Absolute,left:Val::Px(0.),top:Val::Px(0.),width:Val::Px(cell.width as f32),height:Val::Px(cell.height as f32),..default()}'
assert old in s;s=s.replace(old,'node')
s=s.replace('if x<cell.width as usize && y<cell.height as usize {','if x>=7 && y>=11 && x<7+cell.width as usize && y<11+cell.height as usize {').replace('pixels[(y*256+x)*4+2]','pixels[((y-11)*256+(x-7))*4+2]')
p.write_text(s,encoding='utf-8')
