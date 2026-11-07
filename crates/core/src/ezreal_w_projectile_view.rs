//! Bounded optional current W XYZ. Local ground policy, not a native bone/flight oracle.
use crate::Point;
use serde_json::Value;
use std::collections::BTreeSet;
pub const POLICY: &str = "map10_w_ground_current_v1";
pub const MAX_ROWS: usize = 64;
pub const MAX_BYTES: usize = 16_384;
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Row {
    pub owner:u32,pub team:u8,pub ordinal:u64,pub position:Point,
    pub y_native:f32,pub direction:Point,
}
fn number(v:Option<&Value>)->Result<f32,&'static str> {
    let n=v.and_then(Value::as_f64).ok_or("W current coordinate missing")?;
    let f=n as f32;
    if !n.is_finite() || !f.is_finite() {return Err("W current coordinate nonfinite");}
    Ok(f)
}
/// Decode only the optional channel; callers retire W on failure and keep gameplay.
pub fn decode(raw:&Value)->Result<Vec<Row>,&'static str> {
    if serde_json::to_vec(raw).map_err(|_|"W current serialization failed")?.len()>MAX_BYTES {
        return Err("W current byte budget exceeded");
    }
    let object=raw.as_object().ok_or("W current envelope invalid")?;
    if object.len()!=2 || object.get("policy").and_then(Value::as_str)!=Some(POLICY) {
        return Err("W current policy invalid");
    }
    let rows=object.get("rows").and_then(Value::as_array).ok_or("W current rows invalid")?;
    if rows.len()>MAX_ROWS {return Err("W current row budget exceeded");}
    let mut out=Vec::new();let mut ids=BTreeSet::new();
    for raw in rows {
        let r=raw.as_object().ok_or("W current row invalid")?;
        if r.len()!=8 {return Err("W current fields invalid");}
        let owner=r.get("owner").and_then(Value::as_u64).and_then(|n|u32::try_from(n).ok())
            .filter(|n|*n!=0).ok_or("W current owner invalid")?;
        let team=r.get("team").and_then(Value::as_u64).and_then(|n|u8::try_from(n).ok())
            .filter(|n|*n<=1).ok_or("W current team invalid")?;
        let ordinal=r.get("ordinal").and_then(Value::as_u64).filter(|n|*n!=0)
            .ok_or("W current ordinal invalid")?;
        if !ids.insert((owner,ordinal)) {return Err("W current identity duplicated");}
        let position=Point{x:number(r.get("x"))?,z:number(r.get("z"))?};
        let direction=Point{x:number(r.get("dx"))?,z:number(r.get("dz"))?};
        if (direction.x.hypot(direction.z)-1.).abs()>0.0001 {return Err("W current direction invalid");}
        out.push(Row{owner,team,ordinal,position,direction,y_native:number(r.get("y_native"))?});
    }
    Ok(out)
}
pub(crate) fn encode(rows:Vec<Row>)->Option<Value> {
    if rows.is_empty() {return None;}
    let raw=serde_json::json!({"policy":POLICY,"rows":rows.into_iter().map(|r|
        serde_json::json!({"owner":r.owner,"team":r.team,"ordinal":r.ordinal,
            "x":r.position.x,"z":r.position.z,"y_native":r.y_native,
            "dx":r.direction.x,"dz":r.direction.z})).collect::<Vec<_>>()});
    decode(&raw).ok()?;Some(raw)
}
#[cfg(test)]
mod tests {
    use super::*;
    fn row()->Row {Row{owner:1,team:0,ordinal:u64::MAX,position:Point{x:7000.,z:8000.},
        y_native:143.,direction:Point{x:1.,z:0.}}}
    #[test]
    fn full_integer_identity_survives_json_and_invalid_extensions_are_rejected() {
        let raw=encode(vec![row()]).unwrap();let bytes=serde_json::to_vec(&raw).unwrap();
        assert_eq!(decode(&serde_json::from_slice(&bytes).unwrap()).unwrap(),vec![row()]);
        for i in 0..6 {
            let mut changed=raw.clone();
            match i {0=>changed["rows"][0]["ordinal"]=serde_json::json!(1.5),
                1=>changed["rows"][0]["dx"]=serde_json::json!(0),
                2=>changed["rows"][0]["y_native"]=serde_json::json!(1e100),
                3=>changed["rows"][0]["hidden_origin"]=serde_json::json!([1,2]),
                4=>changed["rows"].as_array_mut().unwrap().push(raw["rows"][0].clone()),
                _=>changed["policy"]=serde_json::json!("native_bone")}
            assert!(decode(&changed).is_err(),"case{i}");
        }
        assert!(decode(&serde_json::json!({"policy":POLICY,"rows":[],"junk":"x".repeat(MAX_BYTES)})).is_err());
    }
}
