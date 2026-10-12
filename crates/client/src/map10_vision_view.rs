//! Native Map10 geometry and registered view created at ordinary client startup.
//! Gameplay sources, authoritative masks and GPU visibility remain to be connected.
use bevy::prelude::Resource;
use std::sync::{Arc,Mutex};
use crate::{fow_level_bounds::{LevelBounds,ViewGeometry},fow_view_registry::{ViewRegistry,RegisteredView}};
#[derive(Resource)]
pub struct Map10VisionView {
    pub geometry:ViewGeometry,
    pub registry:ViewRegistry,
    pub view:Arc<Mutex<RegisteredView>>,
}
impl Map10VisionView {
    pub fn from_scb(bytes:&[u8])->Result<Self,&'static str> {
        let geometry=LevelBounds::from_scb(bytes)?.view_geometry();
        let mut registry=ViewRegistry::default();let view=registry.construct(geometry.extent)?;
        Ok(Self {geometry,registry,view})
    }
    pub fn native_map10()->Result<Self,&'static str> {
        Self::from_scb(include_bytes!("../../../assets/maps/tt_level_size.scb"))
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn startup_view_extent_and_registration_match_original_caller() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_view_caller_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),24);
        for c in proof["cases"].as_array().unwrap() {
            let b:Vec<f32>=c["bounds_bits"].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect();
            let mut bytes=vec![0;176];bytes[..8].copy_from_slice(b"r3d2Mesh");bytes[8..12].copy_from_slice(&[2,0,2,0]);
            for (i,v) in b.iter().enumerate() {bytes[152+i*4..156+i*4].copy_from_slice(&v.to_le_bytes());}
            let extent=f32::from_bits(c["extent_bits"].as_u64().unwrap() as u32);
            if extent<=0. {assert!(Map10VisionView::from_scb(&bytes).is_err());continue;}
            let state=Map10VisionView::from_scb(&bytes).unwrap();
            assert_eq!(state.registry.event_count(),c["event_count"].as_u64().unwrap() as usize);
            assert_eq!(state.registry.subscription_count(),c["subscriber_count"].as_u64().unwrap() as usize);
            let view=state.view.lock().unwrap();assert_eq!(view.extent.to_bits(),extent.to_bits());assert_eq!(view.circle.layer.dimension(),c["dimension"].as_u64().unwrap() as usize);
            assert_eq!(view.circle.layer.counts.iter().all(|v|*v==0),c["counts_zero"].as_bool().unwrap());assert_eq!(view.circle.layer.pixels.iter().all(|v|*v==0),c["pixels_zero"].as_bool().unwrap());
        }
        let state=Map10VisionView::native_map10().unwrap();assert_eq!(state.geometry.extent,15398.671875);assert_eq!(state.geometry.center,[7699.3359375,0.,7699.3359375]);
        assert!(Map10VisionView::from_scb(&[]).is_err());
    }
}
