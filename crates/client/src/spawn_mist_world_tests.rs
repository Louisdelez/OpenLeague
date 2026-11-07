use super::*;
include!("spawn_mist_world_goldens.rs");
fn words(h:ReconstructedHeader)->[[u32;3];3] {
    [h.centre.map(f32::to_bits),h.post.map(f32::to_bits),h.position.map(f32::to_bits)]
}
fn geometry()->ReconstructedGeometry {
    ReconstructedGeometry {
        native_positions:GEOMETRY_POSITIONS.iter().map(|p|p.map(f32::from_bits)).collect(),
        uv:GEOMETRY_UV.iter().map(|p|p.map(f32::from_bits)).collect(),
        triangles:GEOMETRY_TRIANGLES.to_vec(),
    }
}
fn cross(a:[f32;3],b:[f32;3])->[f32;3] {
    [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
}
fn difference(a:[f32;3],b:[f32;3])->[f32;3] {std::array::from_fn(|i|a[i]-b[i])}

#[test]
fn native_mist_mesh_caller_and_worldmatrix_match_all_576_original_cases() {
    let mut h=ReconstructedHeader::neutral_fogcircle_v2();let mut owner=None;
    for row in NATIVE_CASES {
        if row.policy==0 || owner!=Some((row.policy,row.sequence)) {
            h=ReconstructedHeader::neutral_fogcircle_v2();
        }
        owner=Some((row.policy,row.sequence));
        let label=format!("policy{} sequence{} frame{} slot{}",row.policy,row.sequence,row.ordinal,row.slot);
        assert_eq!(words(h),row.before,"{label} input header");
        let result=prepare(row.surface,&mut h,1.,1.).unwrap();
        assert_eq!(words(h),row.after,"{label} output header");
        assert_eq!(result.scale.map(f32::to_bits),row.scale,"{label} scale");
        assert_eq!(result.pose.map(f32::to_bits),row.pose,"{label} packed pose");
        assert_eq!(result.world.map(f32::to_bits),row.world,"{label} native world matrix");
    }
    assert_eq!(NATIVE_CASES.len(),576);
}

#[test]
fn reconstructed_mist_bake_preserves_769_vertices_uvs_1440_winding_without_second_translation() {
    let g=geometry();let mut triangles=0;
    for row in NATIVE_CASES {
        let w=row.world.map(f32::from_bits);let baked=g.bake(w).unwrap();
        assert_eq!(baked.positions.len(),769);
        assert_eq!(baked.uv,g.uv);assert_eq!(baked.triangles,g.triangles);
        // Reconstructed centre vertex is local0. Actual native matrix carries
        // placement once; no raw surface postY10/owner matrix may be added here.
        for axis in 0..3 {
            assert_eq!(baked.positions[0][axis],w[12+axis]/20.);
        }
        let expected_up=cross([w[8],w[9],w[10]],[w[0],w[1],w[2]]);
        for face in &baked.triangles {
            let [a,b,c]=face.map(|i|baked.positions[i as usize]);
            let normal=cross(difference(b,a),difference(c,a));
            let same_side=(normal[0]*expected_up[0]+normal[1]*expected_up[1])+normal[2]*expected_up[2];
            assert!(same_side>0.,"native row-matrix geometry winding changed");triangles+=1;
        }
    }
    assert_eq!(triangles,829_440);
}

#[test]
fn invalid_mist_scale_or_geometry_cannot_publish_spatial_data() {
    let before=ReconstructedHeader::neutral_fogcircle_v2();let mut h=before;
    let mut surface=NATIVE_CASES[0].surface;surface[37]=2f32.to_bits();
    assert!(prepare(surface,&mut h,1.,1.).is_err());assert_eq!(h,before);
    surface=NATIVE_CASES[0].surface;surface[12]=f32::NAN.to_bits();
    assert!(prepare(surface,&mut h,1.,1.).is_err());assert_eq!(h,before);
    let mut g=geometry();g.triangles[0][0]=769;
    assert!(g.bake(NATIVE_CASES[0].world.map(f32::from_bits)).is_err());
}
