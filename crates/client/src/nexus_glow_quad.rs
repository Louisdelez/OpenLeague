//! Complex type0 packet transport. No simulation, hidden billboard, or auto-spawn.
//! Original192B vertices stay available beside the Bevy mesh for probe comparison.
use bevy::{asset::RenderAssetUsages, mesh::{Indices, PrimitiveTopology}, prelude::*};
use openleague_core::{native_complex_quad_binding as binding, native_complex_type0_quad as native};

pub struct Geometry { pub native: native::Quad, pub mesh: Mesh }

/// Uses the actual NativeCamera's original-LH view contract, never Bevy's RH
/// transform axes. Invoke after the current frame's camera() system has run.
pub fn current_native_axes(camera:&crate::camera_native::NativeCamera,angle:f32)
    ->Result<binding::Axes,&'static str>
{
    let parameters=camera.native_parameters().ok_or("CrystalGlow camera not ready")?;
    let view=openleague_core::camera_view::from_parameters(parameters)?;
    binding::axes(view,angle)
}

/// The caller must supply the center and RGBA AFTER the original preparation
/// path. In particular mode0 premultiplies RGB by alpha then publishes alpha1.
/// Axis scaling/center offsets remain caller-owned; this API does not infer them.
pub fn geometry(input:native::Input,division:[u16;2])->Result<Geometry,&'static str> {
    let packet=native::pack(input).map_err(|_|"CrystalGlow invalid native vertex input")?;
    from_packet(packet,division)
}
pub fn from_packet(packet:native::Quad,division:[u16;2])->Result<Geometry,&'static str> {
    let mut positions=Vec::with_capacity(4);let mut uv0=Vec::with_capacity(4);
    let mut uv1=Vec::with_capacity(4);let mut colors=Vec::with_capacity(4);
    for v in packet.words {
        let position=[v[0],v[1],v[2]].map(f32::from_bits);
        let lookup=[v[8],v[9]].map(f32::from_bits);
        if position.into_iter().chain(lookup).any(|x|!x.is_finite()) {
            return Err("CrystalGlow packet contains nonfinite mesh channels");
        }
        positions.push(position.map(|x|x/20.));
        uv0.push(binding::atlas_uv([v[4],v[5]].map(f32::from_bits),f32::from_bits(v[6]),division)?);
        uv1.push(lookup);
        // D3D packed ARGB -> shader RGBA; no sRGB conversion or extra alpha scale.
        colors.push([((v[3]>>16)&255) as f32/255.,((v[3]>>8)&255) as f32/255.,
            (v[3]&255) as f32/255.,((v[3]>>24)&255) as f32/255.]);
    }
    let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
    mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,positions);
    mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,uv0);
    mesh.insert_attribute(Mesh::ATTRIBUTE_UV_1,uv1);
    mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,colors);
    mesh.insert_indices(Indices::U32(vec![0,1,2,0,2,3]));
    Ok(Geometry {native:packet,mesh})
}

#[cfg(test)]
mod tests {
    use super::*;
    use bevy::mesh::VertexAttributeValues;
    #[test]
    fn actual_native_packet_keeps_winding_atlas_lookup_and_packed_color() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_type0_quad_vectors.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let words=std::array::from_fn(|i|std::array::from_fn(|j|c["output_words"][i*12+j].as_u64().unwrap() as u32));
            let out=from_packet(native::Quad {words},[2,2]).unwrap();
            assert_eq!(out.native.words,words);
            assert_eq!(out.mesh.indices(),Some(&Indices::U32(vec![0,1,2,0,2,3])));
            let Some(VertexAttributeValues::Float32x3(pos))=out.mesh.attribute(Mesh::ATTRIBUTE_POSITION) else {panic!("position");};
            let Some(VertexAttributeValues::Float32x2(uv))=out.mesh.attribute(Mesh::ATTRIBUTE_UV_0) else {panic!("uv0");};
            let Some(VertexAttributeValues::Float32x2(lookup))=out.mesh.attribute(Mesh::ATTRIBUTE_UV_1) else {panic!("uv1");};
            let Some(VertexAttributeValues::Float32x4(color))=out.mesh.attribute(Mesh::ATTRIBUTE_COLOR) else {panic!("color");};
            for i in 0..4 {
                assert_eq!(pos[i],std::array::from_fn(|j|f32::from_bits(words[i][j])/20.));
                assert_eq!(uv[i],binding::atlas_uv([words[i][4],words[i][5]].map(f32::from_bits),f32::from_bits(words[i][6]),[2,2]).unwrap());
                assert_eq!(lookup[i],[words[i][8],words[i][9]].map(f32::from_bits));
                let packed=words[i][3];assert_eq!(color[i],[((packed>>16)&255) as f32/255.,((packed>>8)&255) as f32/255.,(packed&255) as f32/255.,(packed>>24) as f32/255.]);
            }
        }
    }
}
