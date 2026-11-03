//! Original QUAD packet producers and atlas arithmetic. The local host supplies
//! the current camera and authorized particles; this module grants no authority.
use bevy::{asset::RenderAssetUsages,mesh::{Indices,PrimitiveTopology},prelude::*};
use openleague_core::{native_complex_particle_storage::Record,native_complex_quad_binding as binding};
use crate::{ezreal_e_simple_parameters::Group,ezreal_e_simple_simulation::State};
pub(crate) const MAX_QUADS_PER_MESH:usize=512;
#[derive(Default)]
struct Packets {positions:Vec<[f32;3]>,uv0:Vec<[f32;2]>,uv1:Vec<[f32;2]>,colors:Vec<[f32;4]>,indices:Vec<u32>}
impl Packets {
    fn push(&mut self,words:[[u32;12];4],division:[u16;2])->Result<(),&'static str>{
        if self.positions.len()/4>=MAX_QUADS_PER_MESH{return Err("E QUAD mesh budget exceeded");}
        let base=u32::try_from(self.positions.len()).map_err(|_|"E QUAD index overflow")?;
        for w in words {
            let position=[w[0],w[1],w[2]].map(|v|f32::from_bits(v)/20.);
            let uv0=binding::atlas_uv([w[4],w[5]].map(f32::from_bits),f32::from_bits(w[6]),division)?;
            let uv1=[w[8],w[9]].map(f32::from_bits);
            if position.iter().chain(&uv0).chain(&uv1).any(|v|!v.is_finite()){return Err("E QUAD nonfinite output");}
            self.positions.push(position);self.uv0.push(uv0);self.uv1.push(uv1);
            self.colors.push([((w[3]>>16)&255) as f32/255.,((w[3]>>8)&255) as f32/255.,
                (w[3]&255) as f32/255.,((w[3]>>24)&255) as f32/255.]);
        }
        self.indices.extend([base,base+1,base+2,base,base+2,base+3]);Ok(())
    }
    fn finish(self)->Option<Mesh>{
        if self.positions.is_empty(){return None;}
        let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
        mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,self.positions);mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,self.uv0);
        mesh.insert_attribute(Mesh::ATTRIBUTE_UV_1,self.uv1);mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,self.colors);
        mesh.insert_indices(Indices::U32(self.indices));Some(mesh)
    }
}
pub(crate) fn simple(state:&State,group:Group,view:[f32;16])->Result<Option<Mesh>,&'static str>{
    use openleague_core::native_simple_type0_quad as native;
    let storage=state.particles();let mut out=Packets::default();
    for i in state.live_indices(){
        let angle=f32::from_bits(storage.scalar[i]);let scale=f32::from_bits(storage.scales[i]);
        let (a,b,division,frame)=match group {
            Group::Magicdust|Group::ReleaseFlash|Group::ArrivalHead=>{let axes=native::axes(view,angle).map_err(|_|"E Simple camera axes invalid")?;
                (axes.a,axes.b,[1,1],0.)},
            Group::Dust=>{let axes=crate::simple_selected_axes::selected_fixed(2,angle)?.map(f32::from_bits);
                ([axes[0],axes[1],axes[2]],[axes[3],axes[4],axes[5]],[2,3],3.)},
        };
        // Original dust selects fixed orientation2. Its authored startframe3,
        // numframes1 and frameRate0 are independent of lifetime or RNG.
        let quad=native::pack(native::Input{center:storage.positions[i].map(f32::from_bits),
            axis_a:a.map(|v|v*scale),axis_b:b.map(|v|v*scale),rgba:[1.;4],
            channel0_origin:[0.;2],channel0_z:frame,
            channel1_origin:[storage.attribute_a[i],storage.attribute_b[i]].map(f32::from_bits)})
            .map_err(|_|"E Simple QUAD packet rejected")?;
        out.push(quad.words,division)?;
    }
    Ok(out.finish())
}
pub(crate) fn complex(records:&[Record],view:[f32;16])->Result<Option<Mesh>,&'static str>{
    if records.len()>MAX_QUADS_PER_MESH{return Err("E Complex QUAD budget exceeded");}
    let mut out=Packets::default();
    for record in records {
        let f=binding::DrawFields::from_record(record,false)?;
        let rgba=crate::relic_pickup_complex_rgba::mode0(f.rgba,[1.;4])?.value();
        // Authored p-vecalign=true uses the separate type0 DL=true path, whose
        // local scalar sqrt normalization remains explicitly distinct from native bits.
        let raw=[record.surface[32],record.surface[33],record.surface[34]].map(f32::from_bits);
        let (a,b)=crate::ezreal_r_impact_complex_axes::aligned(view,raw)?;
        let quad=openleague_core::native_complex_type0_quad::pack(openleague_core::native_complex_type0_quad::Input{
            center:f.matrix_center,axis_a:a.map(|v|v*f.scale[1]),axis_b:b.map(|v|v*f.scale[0]),rgba,
            channel0_origin:f.uv_scroll,channel0_z:f.atlas_frame,channel1_origin:f.lookup,channel1_corners:false})
            .map_err(|_|"E Complex QUAD packet rejected")?;
        out.push(quad.words,[3,3])?;
    }
    Ok(out.finish())
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn packet_conversion_preserves_authored_atlas_lut_and_native_scale(){
        let q=openleague_core::native_simple_type0_quad::pack(openleague_core::native_simple_type0_quad::Input{
            center:[100.,200.,300.],axis_a:[0.,20.,0.],axis_b:[20.,0.,0.],rgba:[1.,0.,0.,1.],
            channel0_origin:[0.;2],channel0_z:3.,channel1_origin:[0.25,0.75]}).unwrap();
        let mut out=Packets::default();out.push(q.words,[2,3]).unwrap();
        assert_eq!(out.positions[0],[4.,11.,15.]);assert_eq!(out.uv0[0],[0.5,1./3.]);
        assert_eq!(out.uv1,vec![[0.25,0.75];4]);assert_eq!(out.colors,vec![[1.,0.,0.,1.];4]);
        assert_eq!(out.indices,[0,1,2,0,2,3]);
    }
    #[test]
    fn bounded_mesh_refuses_overflow_instead_of_truncating_particles(){
        let words=[[0u32;12];4];let mut out=Packets::default();
        for _ in 0..MAX_QUADS_PER_MESH{out.push(words,[1,1]).unwrap();}
        let count=out.positions.len();assert!(out.push(words,[1,1]).is_err());assert_eq!(out.positions.len(),count);
    }
}
