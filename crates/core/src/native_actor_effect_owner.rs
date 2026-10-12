//! Concrete owner vtable10B0E1C: slots04/08/24/34/38.
//! Binding this provider to a particular effect is a separate requirement.
#[derive(Clone,Copy,Debug)]
pub struct Actor {
    pub position:[f32;3],
    pub direction:[f32;3],
    pub flags:u32,
    pub type_tag:u32,
    pub primary_status:u8,
    pub current_id:u32,
    pub field_50c:u32,
}
pub const NATIVE_TYPE_TAG:u32=0x02d6da00;
#[derive(Clone,Copy,Debug)]
pub struct Owner {
    /// None represents failed native weak-owner acquisition.
    pub actor:Option<Actor>,
    pub previous_id:u32,
}
impl Owner {
    pub fn eligible(&self)->bool {self.actor.is_some()}
    pub fn position(&self)->Option<[f32;3]> {self.actor.map(|a|a.position)}
    pub fn direction(&self)->Option<[f32;3]> {self.actor.map(|a|a.direction)}
    pub fn primary_status(&self)->u8 {
        let Some(a)=self.actor else {return 0};
        if a.flags&0x400!=0 {a.primary_status}
        else {u8::from(a.type_tag==NATIVE_TYPE_TAG && a.field_50c==0)}
    }
    pub fn secondary_status(&self)->bool {
        self.actor.is_some_and(|a|a.flags&0x400!=0 && a.current_id!=self.previous_id)
    }
}
/// Native719890 copies actor+18C0, then718F70 normalizes rows independently.
/// Ordinary finite matrices only; native exceptional arithmetic needs qualification.
pub fn orientation(mut matrix:[f32;16])->Result<[f32;16],&'static str> {
    if !matrix.iter().all(|x|x.is_finite()) {return Err("unqualified nonfinite owner matrix");}
    for row in 0..3 {
        let x=matrix[row];let y=matrix[row+4];let z=matrix[row+8];
        let squared=(y*y+x*x)+z*z;
        if !squared.is_finite() {return Err("unqualified owner matrix overflow");}
        let estimate=crate::native_particle_force_body::inverse_estimate(squared)?;
        let length=if squared==0. {0.}else{((3.-((estimate*squared)*estimate))*(estimate*0.5))*squared};
        if length!=0. {
            let reciprocal=1./length;
            matrix[row]=x*reciprocal;matrix[row+4]=y*reciprocal;matrix[row+8]=z*reciprocal;
        }
    }
    matrix[12..16].copy_from_slice(&[0.,0.,0.,1.]);
    Ok(matrix)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn orientation_matches_original_copy_and_normalization_with_cpu_rsqrt() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/actor_effect_owner_orientation_contract.json")).unwrap();
        assert_eq!(proof["actual_cpu_rsqrt_operations"],15);
        for row in proof["cases"].as_array().unwrap() {
            let input=std::array::from_fn(|i|row["input"][i].as_f64().unwrap() as f32);
            let actual=orientation(input).unwrap();
            for (i,v) in actual.iter().enumerate(){assert_eq!(v.to_bits(),row["result_words"][i].as_u64().unwrap() as u32,"component {i}");}
        }
    }
    #[test]
    fn concrete_owner_vectors_and_status_match96_native_executions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/actor_effect_owner_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
        for row in cases {
            let vector=|name:&str|std::array::from_fn(|i|row[name][i].as_f64().unwrap() as f32);
            let actor=Actor {position:vector("position"),direction:vector("direction"),flags:if row["flag"].as_bool().unwrap(){0x400}else{0},type_tag:if row["kind"]=="missile"{NATIVE_TYPE_TAG}else{0x12345},primary_status:row["primary"].as_u64().unwrap() as u8,current_id:row["current_id"].as_u64().unwrap() as u32,field_50c:row["death"].as_u64().unwrap() as u32};
            let owner=Owner {actor:row["live"].as_bool().unwrap().then_some(actor),previous_id:row["previous_id"].as_u64().unwrap() as u32};
            let expected=&row["result"];
            assert_eq!(owner.eligible(),expected["eligible"]==1);
            assert_eq!(owner.primary_status(),expected["primary"].as_u64().unwrap() as u8);
            assert_eq!(owner.secondary_status(),expected["secondary"]==1);
            for (key,value) in [("position",owner.position()),("direction",owner.direction())] {
                assert_eq!(value.is_some(),expected[key]["ok"].as_bool().unwrap());
                if let Some(values)=value {for (i,v) in values.iter().enumerate(){assert_eq!(v.to_bits(),expected[key]["words"][i].as_u64().unwrap() as u32);}}
            }
        }
    }
}
