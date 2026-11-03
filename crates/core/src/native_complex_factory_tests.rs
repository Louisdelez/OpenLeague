use crate::{native_complex_factory_admission as admission,native_complex_flex_selection as flex,
    native_scalar_parameter::ScalarParameter,native_probability_curve::ProbabilityCurve};
fn bits(value:&serde_json::Value)->u32 {
    u32::from_str_radix(value.as_str().unwrap().trim_start_matches("0x"),16).unwrap()
}
#[test]
fn admission_matches_36_original_post_parser_factory_decisions() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/factory_admission_contract.json")).unwrap();
    let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),36);
    for r in rows {
        let actual=admission::decide(admission::Input {
            single_field_334:r["single_field_334"].as_u64().unwrap() as u32,
            rate_max_field_d4:r["rate_field_d4"].as_f64().unwrap() as f32,
            flex_flag_4b8:r["flag_4b8"]!=0,
            // Historical oracle label; the original parser identifies this vector
            // as material overrides. This is not a count of child emitters.
            auxiliary_vector_nonempty:r["child_count"]!=0,
        });
        assert_eq!(actual,if r["result"]=="destroy" {admission::Decision::Destroy}else{admission::Decision::Retain});
    }
}
#[test]
fn flex_matches_7_original_indexed_reads_and_conditional_activation_writes() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/indexed_flex_probability_contract.json")).unwrap();
    let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),7);
    for r in rows {
        let v=r["default"].as_f64().unwrap() as f32;
        let default=ScalarParameter {table:vec![v],maximum:v,probability:ProbabilityCurve::read_numeric("",|_|None).unwrap()};
        let actual=flex::read_fresh("e-rate",&default,r["initial_activation"]==1,0xdeadbeef,
            |k|r["fields"][k].as_array().map(|values|values.iter().map(|n|n.as_f64().unwrap() as f32).collect())).unwrap();
        assert_eq!(actual.activation,r["activation"]==1,"{}",r["name"]);
        assert_eq!(actual.discriminator,bits(&r["discriminator"]));
        assert_eq!(actual.parameter.maximum.to_bits(),bits(&r["maximum_bits"]));
        if let Some(expected)=r["probability_value_bits"].as_str() {
            assert_eq!(actual.parameter.probability.constant_value.to_bits(),u32::from_str_radix(expected.trim_start_matches("0x"),16).unwrap());
        }
        assert_eq!(actual.visited_keys,r["derived_keys"].as_array().unwrap().iter().map(|k|k.as_str().unwrap().to_owned()).collect::<Vec<_>>());
    }
}
