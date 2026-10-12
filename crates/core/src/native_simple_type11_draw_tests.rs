use super::*;
use serde_json::Value;

fn fixture()->Value {serde_json::from_str(include_str!("../../../data/4.20/type11_draw_contract.json")).unwrap()}
fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|u32::from_str_radix(v.as_str().unwrap(),16).unwrap()).collect()}
fn numbers<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|(v[i].as_f64().unwrap() as f32).to_bits())}
fn joints(words:&[u32])->Vec<Joint>{words.chunks_exact(10).map(|v|Transform(v.try_into().unwrap()).to_joint()).collect()}
fn identity()->Transform{Transform(crate::native_simple_type11_pose::IDENTITY)}
fn trs(t:[f32;3],s:[f32;3])->Joint{Transform([t[0],t[1],t[2],s[0],s[1],s[2],0.,0.,0.,1.].map(f32::to_bits)).to_joint()}
fn frame(row:&Value)->Frame{
    let p=&row["inputs"];
    Frame{position:numbers(&p["position"]),right:numbers(&p["right"]),up:numbers(&p["up"]),scale:(p["scale"].as_f64().unwrap() as f32).to_bits(),matrix:numbers(&p["matrix"])}
}

#[test]
fn type11_draw_palette_matches_120_original_native_observations_bit_exactly(){
    let data=fixture();let rows=data["cases"].as_array().unwrap();assert_eq!(rows.len(),120);
    assert_eq!(data["draw_observations"],240);assert_eq!(data["renderer_qualified"],false);
    for (i,row) in rows.iter().enumerate(){
        let input=joints(&words(&row["input_joint_words"]));let original=input.clone();
        let combined=Transform(words(&row["combined_transform_words"][0]).try_into().unwrap());
        let output=transform_palette(combined,&input).unwrap();
        assert_eq!(output,joints(&words(&row["draws"][0]["joint_words"])),"case{i}");
        assert_eq!(input,original,"caller palette remains unchanged case{i}");
    }
}

#[test]
fn type11_draw_frame_and_composition_match_five_native_profiles_with_declared_rsqrt_tolerance(){
    let data=fixture();let mut count=0;
    for row in data["cases"].as_array().unwrap(){
        let input=joints(&words(&row["input_joint_words"]));let source=Pose::new(1,input.clone()).unwrap();
        let actual=prepare(frame(row),Transform(numbers(&row["inputs"]["inverse"])),&source).unwrap();
        let expected=words(&row["combined_transform_words"][0]);
        for (i,(&a,&e)) in actual.combined.0.iter().zip(&expected).enumerate(){
            let a=f32::from_bits(a);let e=f32::from_bits(e);let tolerance=1e-5f32.max(e.abs()*3e-6);
            assert!((a-e).abs()<=tolerance,"{} component{i}: {a} versus {e}, tolerance{tolerance}",row["profile_name"]);
        }
        for (i,(a,e)) in actual.palette.iter().flat_map(|j|Transform::from_joint(j).0).zip(words(&row["draws"][0]["joint_words"])).enumerate(){
            let a=f32::from_bits(a);let e=f32::from_bits(e);let tolerance=2e-5f32.max(e.abs()*5e-6);
            assert!((a-e).abs()<=tolerance,"{} word{i}: {a} versus {e}",row["profile_name"]);
        }
        assert_eq!(source.joints(),input);assert_eq!(actual.skeleton,1);count+=1;
    }
    assert_eq!(count,120);
}

#[test]
fn type11_local_hierarchy_uses_actual_parents_owner_and_inverse_bind_without_affine_decomposition(){
    //Child precedes parent in the supplied array. This is explicit diagnostic data.
    let local=vec![trs([1.,2.,3.],[5.,6.,7.]),trs([10.,0.,0.],[2.,3.,4.])];
    let ib=vec![trs([-1.,0.,0.],[1.,1.,1.]),trs([0.,0.,0.],[1.,1.,1.])];
    let owner=Transform::from_joint(&trs([100.,0.,0.],[2.,2.,2.]));
    let before=local.clone();let out=build_palette(&local,&[1,-1],&ib,owner).unwrap();
    let child=Transform::from_joint(&out[0]).0.map(f32::from_bits);
    let parent=Transform::from_joint(&out[1]).0.map(f32::from_bits);
    assert_eq!(&parent[..6],&[120.,0.,0.,4.,6.,8.]);
    //Global child T=[124,12,24], S=[20,36,56]; inverse bind T.x=-1.
    assert_eq!(&child[..6],&[104.,12.,24.,20.,36.,56.]);
    assert_eq!(local,before);
}

#[test]
fn type11_native_trs_composition_keeps_nonuniform_scale_and_rejects_invalid_hierarchies(){
    let source=vec![trs([0.,0.,0.],[2.,3.,4.]);2];let ib=vec![identity().to_joint();2];
    assert_eq!(build_palette(&source,&[1,0],&ib,identity()),Err(Error::ParentCycle));
    assert_eq!(build_palette(&source,&[-2,-1],&ib,identity()),Err(Error::ParentIndex));
    assert_eq!(build_palette(&source,&[2,-1],&ib,identity()),Err(Error::ParentIndex));
    assert_eq!(build_palette(&source,&[-1],&ib,identity()),Err(Error::JointCount));
    let local=vec![identity().to_joint();257];assert_eq!(build_palette(&local,&vec![-1;257],&local,identity()),Err(Error::JointCount));
    assert_eq!(build_palette(&[],&[],&[],identity()).unwrap(),Vec::<Joint>::new());
}

#[test]
fn type11_errors_do_not_publish_partial_palettes_or_replace_invalid_data_with_identity(){
    let mut bad=identity();bad.0[6]=f32::NAN.to_bits();
    let source=vec![identity().to_joint(),bad.to_joint()];let before=source.clone();
    assert_eq!(transform_palette(identity(),&source),Err(Error::NonFinite));assert_eq!(source,before);
    assert_eq!(compose(bad,identity()),Err(Error::NonFinite));
    let mut f=frame(&fixture()["cases"][0]);f.position[0]=f32::INFINITY.to_bits();assert_eq!(prepare_frame(f),Err(Error::NonFinite));
}

#[cfg(any(target_arch="x86",target_arch="x86_64"))]
#[test]
fn type11_frame_restores_callers_x87_control_word(){
    fn control()->u16{let mut word=0u16;unsafe{std::arch::asm!("fnstcw word ptr [{p}]",p=in(reg)&mut word,options(nostack,preserves_flags));}word}
    let before=control();
    for row in fixture()["cases"].as_array().unwrap(){prepare_frame(frame(row)).unwrap();assert_eq!(control(),before);}
}
