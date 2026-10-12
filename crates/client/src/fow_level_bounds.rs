//! Original86FA49 SSE bounds arithmetic. Resource registry/loader remains unqualified.
#[derive(Debug,Clone,Copy)]
pub struct LevelBounds {pub min:[f32;3],pub max:[f32;3]}
#[derive(Debug,Clone,Copy)]
pub struct ViewGeometry {pub span:[f32;3],pub center:[f32;3],pub extent:f32}
impl LevelBounds {
    pub fn from_scb(bytes:&[u8])->Result<Self,&'static str> {
        if bytes.len()<176 || &bytes[..8]!=b"r3d2Mesh" || bytes[8..12]!=[2,0,2,0] {return Err("unsupported level-size SCB header");}
        let values=std::array::from_fn::<_,6,_>(|i|f32::from_le_bytes(bytes[152+i*4..156+i*4].try_into().unwrap()));
        Ok(Self {min:values[..3].try_into().unwrap(),max:values[3..].try_into().unwrap()})
    }
    pub fn view_geometry(self)->ViewGeometry {
        let span=std::array::from_fn(|i|self.max[i]-self.min[i]);
        ViewGeometry {span,center:[self.min[0]+span[0]*0.5,0.,self.min[2]+span[2]*0.5],extent:span[0]}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_sse_bounds_and_authored_map10_header_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_level_bounds_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),6);
        for c in proof["cases"].as_array().unwrap() {
            let b:Vec<f32>=c["bounds_bits"].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect();
            let g=LevelBounds {min:b[..3].try_into().unwrap(),max:b[3..].try_into().unwrap()}.view_geometry();
            for i in 0..3 {assert_eq!(g.span[i].to_bits(),c["span_bits"][i].as_u64().unwrap() as u32);assert_eq!(g.center[i].to_bits(),c["center_bits"][i].as_u64().unwrap() as u32);}
            assert_eq!(g.extent.to_bits(),c["view_extent_bits"].as_u64().unwrap() as u32);
        }
        let bounds=LevelBounds::from_scb(include_bytes!("../../../assets/maps/tt_level_size.scb")).unwrap();
        let g=bounds.view_geometry();assert_eq!(g.extent,15398.671875);assert_eq!(bounds.max[1],0.);assert_eq!(g.center[1],0.);
        let mut registry=crate::fow_view_registry::ViewRegistry::default();let view=registry.construct(g.extent).unwrap();assert_eq!(view.lock().unwrap().extent.to_bits(),proof["cases"][0]["view_extent_bits"].as_u64().unwrap() as u32);
        assert!(LevelBounds::from_scb(&[0;176]).is_err());assert!(LevelBounds::from_scb(b"r3d2Mesh").is_err());
    }
}
