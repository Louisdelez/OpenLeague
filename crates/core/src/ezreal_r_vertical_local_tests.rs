use super::*;
use crate::dense_height_grid::GridSpec;

fn identity() -> Identity { Identity { session: u64::MAX-1, owner: 7, team: 0, ordinal: u64::MAX-2 } }
fn facing(yaw: f32) -> Facing { Facing::from_yaw(yaw).unwrap() }
fn close(actual: f32, expected: f32) {
    assert!((actual-expected).abs()<0.0005, "{actual} != {expected}");
}
fn plane(x: f32, z: f32, base: f32) -> (GridSpec, Vec<u8>) {
    let spec = GridSpec { min_xz: [-1000.;2], max_xz: [1000.;2],
        dimensions: [3,3], spacing_xz: [1000.;2] };
    let bytes = (0..3).flat_map(|row| (0..3).flat_map(move |column| {
        (base+x*(column as f32*1000.-1000.)+z*(row as f32*1000.-1000.)).to_le_bytes()
    })).collect();
    (spec, bytes)
}
fn prepare(grid: &DenseHeightGrid<'_>, aim: Point, range: f32) -> FlightHeight {
    FlightHeight::prepare(identity(),30,[0.,10.,0.],100.,facing(0.),aim,range,grid).unwrap()
}

#[test]
fn release_pose_four_cardinals_match_restored_model_axes_and_actor_root() {
    // DATA audit: model(10.32636044,60.07355187,-9.01796455)*catalog1.1.
    // A yaw-90 transforms +Z into +X, as entity_orientation's matrix columns.
    let (x,y,z) = (11.358996485,66.080907060,-9.9197609998);
    for (yaw, offset) in [(0.,[x,y,z]),(-90.,[z,y,-x]),
        (-180.,[-x,y,-z]),(-270.,[-z,y,x])] {
        let result = restored_release_bone([100.,200.,300.],facing(yaw)).unwrap();
        for i in 0..3 { close(result[i],[100.,200.,300.][i]+offset[i]); }
    }
    assert_eq!(restored_release_bone([0.;3],facing(0.)).unwrap(),
        restored_release_bone([0.;3],facing(-360.)).unwrap());
}

#[test]
fn release_pose_follows_every_archived_yaw_basis_with_normalization_tolerance() {
    // Compare independent raw matrix placement against the normalized quaternion
    // contract. The archive contains111cases; three zero directions are skipped.
    let proof: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/entity_yaw_contract.json")).unwrap();
    let model = MODEL_R_FOOT_AT_ONE_SECOND.map(|v|v*CATALOG_SCALE);
    let mut count=0;
    for case in proof["cases"].as_array().unwrap() {
        let direction=std::array::from_fn(|i| f32::from_bits(case["direction_bits"][i].as_u64().unwrap() as u32));
        let Some(heading)=Facing::from_direction(direction).unwrap() else {continue};
        count+=1;
        let result=restored_release_bone([0.;3],heading).unwrap();
        let m=|i:usize|f32::from_bits(case["output_frame_bits"][i].as_u64().unwrap() as u32);
        let expected=[m(0)*model[0]+m(8)*model[2],model[1],m(2)*model[0]+m(10)*model[2]];
        for i in 0..3 { assert!((result[i]-expected[i]).abs()<0.002,"case {count}, axis {i}"); }
    }
    assert_eq!(count,108);
}

#[test]
fn bone_delta_uses_bone_xz_but_spawn_uses_cast_xz_and_dense_y() {
    let (spec,bytes)=plane(1.,2.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let state=prepare(&grid,Point{x:100.,z:0.},100.);
    // Terrain at bone =10+11.358996485+2*(-9.9197609998)=1.5194744854.
    // Actor root100 is independent of cast ground10. BoneY=166.080907060.
    // Delta=164.5614325746; final spawn=(0,174.5614325746,0).
    close(state.input.initial_height_delta,164.561432575);
    assert_eq!(state.input.position[0],0.);assert_eq!(state.input.position[2],0.);
    close(state.input.position[1],174.561432575);
    assert_eq!(state.endpoint_branch,EndpointBranch::DenseTerrain);
    assert_eq!([state.endpoint[0],state.endpoint[2]],[100.,0.]);
    close(state.endpoint[1],274.561432575);
    assert_ne!(state.input.position,restored_release_bone([0.,100.,0.],facing(0.)).unwrap());
}

#[test]
fn direction_is_pre_height_endpoint_minus_old_bone_and_gravity_zero_keeps_y() {
    let (spec,bytes)=plane(1.,2.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let state=prepare(&grid,Point{x:100.,z:0.},100.);
    // Native order: pre-height endpoint=(100,10,0), OLD bone=(11.359,166.081,-9.920).
    // Thus directionY is negative. Recomputing from final spawn/end would yield
    // positiveY, and clearing it for gravity0 would yield0; both are wrong here.
    assert!(state.input.direction[1] < -0.8);
    assert!(state.input.direction[2]>0.0);
    close(state.input.direction[1]/state.input.direction[0],
        (10.-166.080907060)/(100.-11.358996485));
    let [x,y,z]=state.input.direction;close((x*x+y*y+z*z).sqrt(),1.);
    assert!(state.endpoint[1]>state.input.position[1]);
}

#[test]
fn full_range_outside_endpoint_uses_explicit_branch_and_does_not_clamp_or_fake_terrain() {
    let (spec,bytes)=plane(1.,2.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let mut state=prepare(&grid,Point{x:50.,z:0.},20000.);
    assert_eq!(state.input.end_xz,[20000.,0.]);
    assert_eq!(state.endpoint_branch,EndpointBranch::OutsideDenseDomain);
    assert_eq!(state.endpoint[1],state.input.initial_height_delta);
    assert!(grid.sample_local_f32(state.input.end_xz).is_err());
    let old=state.input.position[1];
    state.advance(identity(),31,Point{x:50.,z:0.},&grid).unwrap();
    // End-domain gate fails; current terrain60 is below the oldY174.5614.
    assert_eq!(state.current_y(identity(),31,Point{x:50.,z:0.}),Some(old));
    state.advance(identity(),32,Point{x:500.,z:0.},&grid).unwrap();
    // Current terrain510 is above oldY, so the proven update gives510+4.
    assert_eq!(state.current_y(identity(),32,Point{x:500.,z:0.}),Some(514.));
}

#[test]
fn inside_endpoint_reuses_nonlinear_height_updater_and_both_terrain_axes() {
    let (spec,bytes)=plane(1.,2.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let mut state=prepare(&grid,Point{x:2.,z:2.},8_f32.sqrt());
    assert_eq!(state.input.end_xz,[2.,2.]);
    let start=state.input.position[1];
    state.advance(identity(),31,Point{x:0.75,z:0.},&grid).unwrap();
    // Endpoint distance²+1=9; sqrt(.75²/9)=.25; .25^1.5=1/8.
    // Endpoint terrain16 minus start terrain10 gives6: Y=start+6/8.
    close(state.current_y(identity(),31,Point{x:0.75,z:0.}).unwrap(),start+0.75);
}

#[test]
fn current_y_requires_full_identity_same_tick_and_exact_current_point() {
    let (spec,bytes)=plane(0.,0.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let state=prepare(&grid,Point{x:100.,z:0.},20000.);
    assert!(state.current_y(identity(),30,Point{x:0.,z:0.}).is_some());
    for changed in [Identity{session:9,..identity()},Identity{owner:8,..identity()},
        Identity{team:1,..identity()},Identity{ordinal:1,..identity()}] {
        assert_eq!(state.current_y(changed,30,Point{x:0.,z:0.}),None);
    }
    for tick in [29,31] {assert_eq!(state.current_y(identity(),tick,Point{x:0.,z:0.}),None);}
    for point in [Point{x:0.1,z:0.},Point{x:0.,z:0.1},Point{x:-0.,z:0.},
        Point{x:f32::NAN,z:0.}] {assert_eq!(state.current_y(identity(),30,point),None);}
}

#[test]
fn invalid_cast_or_bone_terrain_never_uses_the_outside_endpoint_branch() {
    let (spec,bytes)=plane(0.,0.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    assert!(matches!(FlightHeight::prepare(identity(),30,[1001.,10.,0.],100.,facing(0.),
        Point{x:1100.,z:0.},20000.,&grid),Err(Error::Terrain{role:TerrainRole::Cast,..})));
    assert!(matches!(FlightHeight::prepare(identity(),30,[1000.,10.,0.],100.,facing(0.),
        Point{x:1100.,z:0.},20000.,&grid),Err(Error::Terrain{role:TerrainRole::Bone,..})));
    assert_eq!(FlightHeight::prepare(identity(),30,[0.,0.,0.],100.,facing(0.),
        Point{x:100.,z:0.},20000.,&grid),Err(Error::CastGroundMismatch));
    assert!(DenseHeightGrid::parse(spec,&bytes[..bytes.len()-4]).is_err());
    let mut corrupt=bytes.clone();corrupt[..4].copy_from_slice(&f32::NAN.to_le_bytes());
    assert!(DenseHeightGrid::parse(spec,&corrupt).is_err());
}

#[test]
fn nonfinite_inputs_and_undefined_aim_are_explicit_errors() {
    let (spec,bytes)=plane(0.,0.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    for invalid in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY] {
        for component in 0..3 {
            let mut origin=[0.;3];origin[component]=invalid;
            assert!(matches!(restored_release_bone(origin,facing(0.)),Err(Error::NonFiniteInput{..})));
            let mut cast=[0.,10.,0.];cast[component]=invalid;
            assert!(FlightHeight::prepare(identity(),30,cast,100.,facing(0.),
                Point{x:100.,z:0.},20000.,&grid).is_err());
        }
        assert!(Facing::from_yaw(invalid).is_err());
        assert!(FlightHeight::prepare(identity(),30,[0.,10.,0.],invalid,facing(0.),
            Point{x:100.,z:0.},20000.,&grid).is_err());
        for aim in [Point{x:invalid,z:0.},Point{x:100.,z:invalid}] {
            assert!(FlightHeight::prepare(identity(),30,[0.,10.,0.],100.,facing(0.),aim,20000.,&grid).is_err());
        }
        assert!(FlightHeight::prepare(identity(),30,[0.,10.,0.],100.,facing(0.),
            Point{x:100.,z:0.},invalid,&grid).is_err());
    }
    assert_eq!(FlightHeight::prepare(identity(),30,[0.,10.,0.],100.,facing(0.),
        Point{x:0.,z:0.},20000.,&grid),Err(Error::UndefinedAim));
    assert!(matches!(FlightHeight::prepare(identity(),30,[0.,10.,0.],100.,facing(0.),
        Point{x:100.,z:0.},f32::MAX,&grid),Err(Error::NonFiniteCalculation(_))));
}

#[test]
fn failed_advance_is_atomic_and_repeated_or_skipped_tick_cannot_replay_height() {
    let (spec,bytes)=plane(0.,0.,10.);let grid=DenseHeightGrid::parse(spec,&bytes).unwrap();
    let mut state=prepare(&grid,Point{x:100.,z:0.},20000.);let before=state.clone();
    for tick in [29,30,32] {
        assert_eq!(state.advance(identity(),tick,Point{x:50.,z:0.},&grid),Err(Error::UnexpectedTick));
        assert_eq!(state,before);
    }
    assert_eq!(state.advance(Identity{owner:8,..identity()},31,Point{x:50.,z:0.},&grid),Err(Error::IdentityMismatch));
    assert_eq!(state,before);
    assert!(state.advance(identity(),31,Point{x:f32::NAN,z:0.},&grid).is_err());assert_eq!(state,before);
    state.advance(identity(),31,Point{x:50.,z:0.},&grid).unwrap();
    assert_eq!(state.current_y(identity(),30,Point{x:0.,z:0.}),None);
    assert!(state.current_y(identity(),31,Point{x:50.,z:0.}).is_some());
}
