//! Whole921F60 position/bounds;918F74 reads System/group-vis into config138.
//! Full cache/overlays/resource construction and owner/frame producers separate.
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Config {pub group_vis_bits:u32}
impl Config {
    /// Already-decoded System section. Raw string/typed lookup and overlays
    /// remain in the resource decoder; reject unsupported source representations.
    pub fn from_decoded_system(system:&serde_json::Value)->Result<Self,&'static str> {
        if !system.is_object() {return Err("invalid decoded System section");}
        let value=match system.get("group-vis") {
            None=>250.,
            Some(v)=>v.as_f64().ok_or("unsupported decoded group-vis value")? as f32,
        };
        Ok(Self {group_vis_bits:value.to_bits()})
    }
    pub fn bounds(self,position:[u32;3])->Bounds {apply(position,self.group_vis_bits)}
}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Bounds {pub position:[u32;3],pub minimum:[u32;3],pub maximum:[u32;3]}
fn arithmetic(left:u32,right:u32,operation:impl FnOnce(f32,f32)->f32)->u32 {
    let a=f32::from_bits(left);let b=f32::from_bits(right);
    // Actual scalar SSE destination NaN takes precedence; invalid arithmetic
    // produces the negative indefinite quiet NaN on the qualified processor.
    if a.is_nan() {return left|0x00400000;}
    if b.is_nan() {return right|0x00400000;}
    let result=operation(a,b);if result.is_nan() {0xffc00000} else {result.to_bits()}
}
pub fn apply(position:[u32;3],config_138:u32)->Bounds {
    let extent=arithmetic(config_138,0x3f3504f3,|a,b|a*b);
    let minimum=position.map(|p|arithmetic(p,extent,|a,b|a-b));
    let span=arithmetic(extent,0x40000000,|a,b|a*b);
    let maximum=minimum.map(|p|arithmetic(p,span,|a,b|a+b));
    Bounds {position,minimum,maximum}
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn triple(v:&Value)->[u32;3] {std::array::from_fn(|i|bits(&v[i]))}
    #[test]
    fn actual26binary_system_reads_and244placement_bounds_match_native_composition() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_group_vis_contract.json")).unwrap();
        assert_eq!(p["definitions"].as_array().unwrap().len(),26);assert_eq!(p["placements"].as_array().unwrap().len(),244);
        let mut definitions=std::collections::BTreeMap::new();
        for row in p["definitions"].as_array().unwrap() {
            assert_eq!(row["byte_count"],row["consumed"]);
            let config=Config::from_decoded_system(&row["system"]).unwrap();
            assert_eq!(config.group_vis_bits,bits(&row["coefficient_bits"]));
            definitions.insert(row["reference"].as_str().unwrap(),config);
        }
        for row in p["placements"].as_array().unwrap() {
            let config=definitions[row["reference"].as_str().unwrap()];
            let bounds=config.bounds(triple(&row["input_bits"]));
            assert_eq!(bounds.position,triple(&row["position_bits"]));
            assert_eq!(bounds.minimum,triple(&row["minimum_bits"]),"placement{}",row["line"]);
            assert_eq!(bounds.maximum,triple(&row["maximum_bits"]),"placement{}",row["line"]);
        }
    }
    #[test]
    fn raw_position_and_bounds_match452native_cases_with_actual_cpu_sse_arithmetic() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_position_bounds_contract.json")).unwrap();
        assert_eq!(p["cases"].as_array().unwrap().len(),452);assert_eq!(bits(&p["constants"]["half"]),0x3f3504f3);
        assert_eq!(p["actual_cpu_sse_operations"],3616);assert_eq!(p["emulator_cpu_case_disagreements"],20);
        for row in p["cases"].as_array().unwrap() {
            let actual=apply(triple(&row["input"]),bits(&row["coefficient"]));
            assert_eq!(actual.position,triple(&row["cpu"]["position"]));
            assert_eq!(actual.minimum,triple(&row["cpu"]["minimum"]),"{row}");
            assert_eq!(actual.maximum,triple(&row["cpu"]["maximum"]),"{row}");
        }
    }
}
