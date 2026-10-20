//! Bounded optional current E Bolt XYZ. Explicit local ground policy, not native flight.
use crate::Point;
use serde_json::Value;
use std::{collections::BTreeSet,io::{self,Write}};
pub const POLICY:&str="map10_e_ground_current_v1";
pub const MAX_ROWS:usize=64;
pub const MAX_BYTES:usize=16_384;
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Row {
    pub owner:u32,pub team:u8,pub ordinal:u64,pub position:Point,
    pub y_native:f32,pub direction:Point,
}
struct Budget(usize);
impl Write for Budget {
    fn write(&mut self,b:&[u8])->io::Result<usize> {
        if b.len()>MAX_BYTES.saturating_sub(self.0){return Err(io::Error::new(io::ErrorKind::InvalidData,"E current byte budget"));}
        self.0+=b.len();Ok(b.len())
    }
    fn flush(&mut self)->io::Result<()> {Ok(())}
}
fn number(v:Option<&Value>)->Result<f32,&'static str> {
    let n=v.and_then(Value::as_f64).ok_or("E current coordinate missing")?;
    let f=n as f32;
    if !n.is_finite() || !f.is_finite(){return Err("E current coordinate nonfinite");}Ok(f)
}
/// Only a complete accepted atomic OLSR frame authorizes these rows. Absence or
/// failure retires presentation; neither reconstruct a row from actor/target data.
pub fn decode(raw:&Value)->Result<Vec<Row>,&'static str> {
    serde_json::to_writer(Budget(0),raw).map_err(|_|"E current byte budget exceeded")?;
    let object=raw.as_object().ok_or("E current envelope invalid")?;
    if object.len()!=2 || object.get("policy").and_then(Value::as_str)!=Some(POLICY){return Err("E current policy invalid");}
    let rows=object.get("rows").and_then(Value::as_array).ok_or("E current rows invalid")?;
    if rows.len()>MAX_ROWS{return Err("E current row budget exceeded");}
    let mut out=Vec::with_capacity(rows.len());let mut ordinals=BTreeSet::new();
    for raw in rows {
        let r=raw.as_object().ok_or("E current row invalid")?;
        if r.len()!=8{return Err("E current fields invalid");}
        let owner=r.get("owner").and_then(Value::as_u64).and_then(|n|u32::try_from(n).ok())
            .filter(|n|*n!=0).ok_or("E current owner invalid")?;
        let team=r.get("team").and_then(Value::as_u64).and_then(|n|u8::try_from(n).ok())
            .filter(|n|*n<=1).ok_or("E current team invalid")?;
        let ordinal=r.get("ordinal").and_then(Value::as_u64).filter(|n|*n!=0).ok_or("E current ordinal invalid")?;
        // This spell allocates one global ordinal within the session.
        if !ordinals.insert(ordinal){return Err("E current ordinal duplicated");}
        let position=Point{x:number(r.get("x"))?,z:number(r.get("z"))?};
        let direction=Point{x:number(r.get("dx"))?,z:number(r.get("dz"))?};
        if (direction.x.hypot(direction.z)-1.).abs()>0.0001{return Err("E current direction invalid");}
        out.push(Row{owner,team,ordinal,position,direction,y_native:number(r.get("y_native"))?});
    }
    Ok(out)
}
pub(crate) fn encode(rows:Vec<Row>)->Option<Value> {
    if rows.is_empty() || rows.len()>MAX_ROWS{return None;}
    let raw=serde_json::json!({"policy":POLICY,"rows":rows.into_iter().map(|r|
        serde_json::json!({"owner":r.owner,"team":r.team,"ordinal":r.ordinal,
            "x":r.position.x,"z":r.position.z,"y_native":r.y_native,
            "dx":r.direction.x,"dz":r.direction.z})).collect::<Vec<_>>()});
    decode(&raw).ok()?;Some(raw)
}
#[cfg(test)]
mod tests {
    use super::*;
    fn row()->Row {Row{owner:1,team:0,ordinal:u64::MAX,position:Point{x:675.,z:7300.},
        y_native:143.,direction:Point{x:1.,z:0.}}}
    #[test]
    fn full_u64_current_identity_roundtrips_without_hidden_target_fields() {
        let raw=encode(vec![row()]).unwrap();let bytes=serde_json::to_vec(&raw).unwrap();
        assert_eq!(decode(&serde_json::from_slice(&bytes).unwrap()).unwrap(),vec![row()]);
        assert_eq!(raw["rows"][0].as_object().unwrap().len(),8);
        for field in ["target","origin","landing","tick","damage","cast_ordinal"]{assert!(raw["rows"][0].get(field).is_none());}
        assert!(encode(vec![]).is_none());
    }
    #[test]
    fn malformed_and_globally_duplicate_current_rows_fail_closed() {
        let raw=encode(vec![row()]).unwrap();
        for case in 0..10 {
            let mut v=raw.clone();
            match case {0=>v["rows"][0]["ordinal"]=serde_json::json!(1.5),
                1=>v["rows"][0]["owner"]=serde_json::json!(0),
                2=>v["rows"][0]["team"]=serde_json::json!(2),
                3=>v["rows"][0]["dx"]=serde_json::json!(0),
                4=>v["rows"][0]["y_native"]=serde_json::json!(1e100),
                5=>v["rows"][0]["target"]=serde_json::json!(2),
                6=>{let mut other=v["rows"][0].clone();other["owner"]=serde_json::json!(2);v["rows"].as_array_mut().unwrap().push(other);},
                7=>{v["rows"][0].as_object_mut().unwrap().remove("z");},
                8=>v["policy"]=serde_json::json!("native_flight"),
                _=>v["rows"][0]["x"]=Value::Null}
            assert!(decode(&v).is_err(),"case{case}");
        }
    }
    #[test]
    fn bounded_current_rows_and_bytes_accept_limit_and_reject_excess() {
        let rows:Vec<_>=(1..=MAX_ROWS).map(|i|Row{ordinal:i as u64,..row()}).collect();
        assert_eq!(decode(&encode(rows.clone()).unwrap()).unwrap().len(),MAX_ROWS);
        let mut too_many=rows;too_many.push(Row{ordinal:100,..row()});assert!(encode(too_many).is_none());
        let raw=serde_json::json!({"policy":POLICY,"rows":[],"padding":"x".repeat(MAX_BYTES)});
        assert!(decode(&raw).is_err());
    }
}
