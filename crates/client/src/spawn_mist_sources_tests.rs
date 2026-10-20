use crate::spawn_mist_sources::{Effect,Profile};
use crate::spawn_mist_material;
use serde_json::Value;
fn workspace()->std::path::PathBuf{std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")}
fn json(path:impl AsRef<std::path::Path>)->Value{serde_json::from_str(&std::fs::read_to_string(path).unwrap()).unwrap()}
fn profile(effect:Effect,capability:bool)->Profile{
    let base=workspace().join("data/4.20/spawn_mist");
    Profile::from_documents(effect,&json(workspace().join(format!("data/4.20/map10_particles/definitions/{}.json",effect.name()))),
        &json(base.join(format!("{}_numeric_factory_v5.json",effect.name()))),capability).unwrap()
}
fn expected_words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
fn compare_probabilities(actual:&[Option<openleague_core::native_probability_curve::ProbabilityCurve>],expected:&Value){
    for(p,v)in actual.iter().zip(expected.as_array().unwrap()){
        assert_eq!(p.is_none(),v.is_null());
        if let Some(p)=p {
            assert_eq!((p.constant,p.fast),(v["constant"].as_bool().unwrap(),v["fast"].as_bool().unwrap()));
            assert_eq!([p.constant_value.to_bits(),p.begin.to_bits(),p.difference.to_bits()],
                [v["constant_word"].as_u64().unwrap() as u32,v["begin_word"].as_u64().unwrap() as u32,v["difference_word"].as_u64().unwrap() as u32]);
            assert_eq!(p.times.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&v["times_words"]));
            assert_eq!(p.values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&v["values_words"]));
        }
    }
}
#[test]
fn native_mist_sources_match_four_whole_factories_and_all_owned_parameters(){
    use openleague_core::native_complex_vectors::FIELDS;
    let mut fields=0;let mut cases=0;
    for effect in [Effect::Order,Effect::Chaos]{
        let factory=json(workspace().join(format!("data/4.20/spawn_mist/{}_numeric_factory_v5.json",effect.name())));
        for row in factory["cases"].as_array().unwrap(){
            let p=profile(effect,row["provider_capability"].as_bool().unwrap());
            assert_eq!(p.factory.primary_position.to_vec(),expected_words(&row["primary_fields"]["position"]));
            assert_eq!(p.factory.primary_rotation_degrees.to_vec(),expected_words(&row["primary_fields"]["rotation_degrees"]));
            assert_eq!(p.factory.primary_scale.to_vec(),expected_words(&row["primary_fields"]["scale"]));
            assert_eq!(p.factory.source_modulation.map(f32::to_bits).to_vec(),expected_words(&row["source_modulation_rgba_a4"]));
            assert_eq!(p.factory.texdiv.map(f32::to_bits).to_vec(),expected_words(&row["texdiv_and_mult_words"])[..2]);
            let n=&row["nested_raw_words"];
            assert_eq!([p.factory.native_start_frame as u32,p.factory.native_num_frames as u32,p.factory.native_frame_rate.to_bits()],
                [n[1].as_u64().unwrap() as u32,n[2].as_u64().unwrap() as u32,n[3].as_u64().unwrap() as u32]);
            assert!(p.factory.primary_parameter_f0.table.is_empty());
            let scalar22=row["primary_parameters"].as_array().unwrap().iter().find(|v|v["offset"]=="0x22c").unwrap();
            assert_eq!(p.factory.primary_parameter_22c.table.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&scalar22["table_words"]));
            assert_eq!(p.factory.native_instance_c0.to_vec(),expected_words(&row["native_instance_c0_table_source_words"]));
            assert_eq!([p.timing.life.to_bits(),p.timing.period.to_bits(),p.timing.active.to_bits(),p.timing.time_offset.to_bits()],
                ["0x2f0","0x308","0x30c","0x2ec"].map(|k|row["primary_scalars"][k].as_u64().unwrap() as u32));
            assert_eq!(p.linger.particle.to_bits(),row["primary_scalars"]["0x338"].as_u64().unwrap() as u32);
            assert_eq!(p.linger.emitter.to_bits(),row["primary_scalars"]["0x33c"].as_u64().unwrap() as u32);
            for field in FIELDS{
                let cfg=p.vectors.field(field);
                let expected=row["primary_parameters"].as_array().unwrap().iter().find(|v|v["key"]==field.key()).unwrap();
                assert_eq!(cfg.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&expected["table_words"]),"{}",field.key());
                compare_probabilities(&cfg.probabilities,&expected["probabilities"]);fields+=1;
            }
            for(index,key)in openleague_core::native_complex_uv_parameters::KEYS.into_iter().enumerate(){
                let source=if index<2{&row["primary_parameters"]}else{&row["nested_parameters"]};
                let expected=source.as_array().unwrap().iter().find(|v|v["key"]==key).unwrap();
                assert_eq!(p.uv.parameters[index].table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&expected["table_words"]),"{key}");
                compare_probabilities(&p.uv.parameters[index].probabilities,&expected["probabilities"]);fields+=1;
            }
            for(color,key,rows)in[(&p.birth_color,"e-rgba",&row["primary_parameters"]),(&p.lifetime_color,"p-xrgba",&row["nested_parameters"])]{
                let expected=rows.as_array().unwrap().iter().find(|v|v["key"]==key).unwrap();
                assert_eq!(color.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&expected["table_words"]));
                compare_probabilities(&color.probabilities,&expected["probabilities"]);fields+=1;
            }
            for(scalar,key,rows)in[(&p.life,"p-life",&row["primary_parameters"]),(&p.rate,"e-rate",&row["primary_parameters"]),(&p.bind,"p-bindtoemitter",&row["nested_parameters"])]{
                let expected=rows.as_array().unwrap().iter().find(|v|v["key"]==key).unwrap();
                assert_eq!(scalar.table.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&expected["table_words"]));
                compare_probabilities(&[Some(scalar.probability.clone())],&expected["probabilities"]);fields+=1;
            }
            let expected=row["nested_parameters"].as_array().unwrap().iter().find(|v|v["key"]=="p-xscale").unwrap();
            assert_eq!(p.lifetime_scale.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected_words(&expected["table_words"]));
            compare_probabilities(&p.lifetime_scale.probabilities,&expected["probabilities"]);fields+=1;cases+=1;
        }
    }
    assert_eq!((cases,fields),(4,80));
}
#[test]
fn native_mist_draw_inputs_match_128_original_uv_rgba_palette_and_mode4_blend_calls(){
    use bevy::{prelude::*,render::render_resource::{BlendFactor,BlendOperation}};
    let proof=json(workspace().join("data/4.20/spawn_mist/mist_material_inputs_contract.json"));
    let f=|v:&Value|f32::from_bits(v.as_u64().unwrap() as u32);
    let mut checked=0;
    for row in proof["cases"].as_array().unwrap(){
        let effect=if row["effect"]=="Order_Spawn"{Effect::Order}else{Effect::Chaos};
        let p=profile(effect,row["provider_capability"].as_bool().unwrap());
        let actual=match row["kind"].as_str().unwrap(){
            "uv"=>p.mesh_uv_transform(f(&row["frame_bits"]),std::array::from_fn(|i|f(&row["scroll_bits"][i]))).unwrap().to_vec(),
            "rgba"=>p.prepare_rgba(std::array::from_fn(|i|f(&row["input_bits"][i]))).unwrap().to_vec(),
            "palette"=>p.lookup_uv(f(&row["age_bits"]),f(&row["shared_bits"])).unwrap().to_vec(),_=>panic!("unknown native input")};
        assert_eq!(actual.into_iter().map(f32::to_bits).collect::<Vec<_>>(),expected_words(&row["output_bits"]));checked+=1;
    }
    assert_eq!(checked,128);
    let native=json(workspace().join("data/4.20/projected_render_state_contract.json"));
    let mode4=native["cases"].as_array().unwrap().iter().find(|v|v["mode"]==4&&v["flags"]==0&&v["initial"]==0).unwrap();
    for call in [[19,5],[20,2],[207,5],[208,2],[171,1],[206,1]]{assert!(mode4["calls"].as_array().unwrap().contains(&serde_json::json!(call)));}
    let blend=spawn_mist_material::mode4_blend();
    for component in[blend.color,blend.alpha]{assert_eq!(component.src_factor,BlendFactor::SrcAlpha);assert_eq!(component.dst_factor,BlendFactor::One);assert_eq!(component.operation,BlendOperation::Add);}
    let input=spawn_mist_material::Inputs{uv_scale_offset:Vec4::new(2.,1.,0.125,0.875),lookup_uv:Vec2::new(0.5,0.75),color_factor:Vec4::ONE,
        fog_uv_scale_offset:Vec4::ZERO,output_encoding:spawn_mist_material::OutputEncoding::RawNumeric,cull:spawn_mist_material::Cull::None,
        shader_class:1,uv_mode:2,render_mode:4,vertex_colors:false,reflected:false,soft:false,mult_pass:false,screen_uv:false,alpha_slice:0.,fresnel_rgb:Vec3::ZERO};
    assert!(input.validate().is_ok());
    assert!(spawn_mist_material::Inputs{render_mode:0,..input}.validate().is_err());
    assert!(spawn_mist_material::Inputs{shader_class:0,..input}.validate().is_err());
    assert!(spawn_mist_material::Inputs{uv_mode:0,..input}.validate().is_err());
    let material=spawn_mist_material::MistMaterial::from_images(std::array::from_fn(|_|Handle::default()),input).unwrap();
    assert!(!material.is_ready()); // CPU construction makes no GPU/owner claim.
}
