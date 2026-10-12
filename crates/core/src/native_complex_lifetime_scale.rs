//! Original939D56..939DBE live p-xscale consumption; ordinary renderer binding pending.
use crate::native_complex_vectors::FieldConfig;
use crate::native_complex_age::sse_result;
use crate::native_random::Rng55;
fn multiply(left:f32,right:f32)->f32 {
    // MULSS in this native stage preserves destination QNaN when both are NaN.
    if left.is_nan() && right.is_nan() {return f32::from_bits(left.to_bits()|0x00400000);}
    sse_result(left,right,|a,b|a*b)
}
///949120 samples probabilities on each invocation, then scales stored birth axes.
/// Owner scale and normalized age are caller supplied; this does not mutate birth scale.
pub fn update(config:&FieldConfig,age:f32,birth:[f32;3],owner:f32,rng:&mut Rng55)->Result<([f32;3],[f32;3]),crate::native_scalar_parameter::Error> {
    let index=crate::native_scalar_parameter::baked_scalar_index(config.table.len(),age)?;
    let mut sampled=config.table[index];
    for axis in 0..3 {
        if let Some(curve)=&config.probabilities[axis] {
            let factor=if curve.constant {curve.constant_value} else {
                let parameter=rng.fraction();
                if curve.fast {
                    let scaled=multiply(curve.difference,parameter);
                    sse_result(scaled,curve.begin,|a,b|a+b)
                } else {curve.sample_parameter(parameter)}
            };
            sampled[axis]=multiply(sampled[axis],factor);
        }
    }
    let output=std::array::from_fn(|axis| {
        let scaled=multiply(birth[axis],sampled[axis]);
        multiply(scaled,owner)
    });
    Ok((sampled,output))
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn expected(v:&Value)->Vec<u32> {v.as_array().unwrap().iter().map(bits).collect()}
    fn assert_config(row:&Value,config:&FieldConfig) {
        assert_eq!(config.authored,row["reader_returned"].as_bool().unwrap(),"{}",row["name"]);
        assert_eq!(config.table.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected(&row["table_bits"]),"{}",row["name"]);
        for axis in 0..3 {
            let p=&row["probabilities"][axis];assert_eq!(config.probabilities[axis].is_none(),p.is_null());
            if let Some(actual)=&config.probabilities[axis] {
                assert_eq!((actual.constant,actual.fast),(p["constant"].as_bool().unwrap(),p["fast"].as_bool().unwrap()));
                assert_eq!([actual.constant_value,actual.begin,actual.difference].map(f32::to_bits),[bits(&p["constant_bits"]),bits(&p["begin_bits"]),bits(&p["difference_bits"])]);
                for (values,key) in [(&actual.times,"times"),(&actual.values,"values")] {assert_eq!(values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(),p[key].as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect::<Vec<_>>());}
            }
        }
    }
    #[test]
    fn lifetime_scale_reader_matches_native_configuration_and_fallback() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_lifetime_scale_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),62);
        for row in proof["cases"].as_array().unwrap() {assert_config(row,&FieldConfig::from_lifetime_scale_group(&row["fields"]).unwrap());}
    }
    #[test]
    fn actual_map10_lifetime_scale_fields_match_native_reader() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_lifetime_scale_contract.json")).unwrap();let mut checked=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let document:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap() {
                if group["declared_type"].as_str()==Some("Simple") {continue;}
                let name=format!("map:{}:{}",definition["reference"].as_str().unwrap(),group["name"].as_str().unwrap());
                let row=proof["cases"].as_array().unwrap().iter().find(|row|row["name"].as_str()==Some(&name)&&row["prior_count"]==0).unwrap();
                assert_config(row,&FieldConfig::from_lifetime_scale_group(&document["sections"][group["name"].as_str().unwrap()]).unwrap());checked+=1;
            }
        }
        assert_eq!(checked,27);
    }
    #[test]
    fn live_scale_matches_native_output_birth_preservation_and_full_rng_state() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/complex_lifetime_scale_update_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),2008);
        for row in proof["cases"].as_array().unwrap() {
            let profile=proof["profiles"].as_array().unwrap().iter().find(|p|p["name"]==row["name"]).unwrap();
            let config=FieldConfig::from_lifetime_scale_group(&profile["fields"]).unwrap();
            let mut rng=Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let check=|rng:&Rng55,state:&Value| {assert_eq!((rng.first,rng.second),(state["first"].as_u64().unwrap() as u32,state["second"].as_u64().unwrap() as u32));assert_eq!(rng.words.to_vec(),state["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());};
            check(&rng,&row["initial_rng"]);
            let birth=std::array::from_fn(|axis|f32::from_bits(bits(&row["birth_bits"][axis])));
            let (sampled,output)=update(&config,f32::from_bits(bits(&row["age_bits"])),birth,f32::from_bits(bits(&row["owner_bits"])),&mut rng).unwrap();
            assert_eq!(sampled.map(f32::to_bits).to_vec(),expected(&row["sample_bits"]),"{row}");
            // Actual CPU takes precedence where Unicorn differs on NaN payloads.
            assert_eq!(output.map(f32::to_bits).to_vec(),expected(&row["cpu_output_bits"]),"{row}");
            assert_eq!(birth.map(f32::to_bits).to_vec(),expected(&row["birth_after_bits"]));check(&rng,&row["rng"]);
        }
    }
}
