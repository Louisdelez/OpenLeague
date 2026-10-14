//! Native 946260 three-variant scalar flex selection after decoded field access.
//! Successful ASCII decimal key transport; initially null prior probability.
//! Missing later variants retain probability acquired by earlier variants.
use crate::{native_scalar_parameter::{ScalarParameter,baked_scalar_index},
                     native_probability_curve::ProbabilityCurve};
pub struct Selection {
    pub activation:bool,pub discriminator:u32,pub parameter:ScalarParameter,
    pub visited_keys:Vec<String>,
}
pub fn read_fresh(base:&str,default:&ScalarParameter,initial_activation:bool,initial_discriminator:u32,
            mut lookup:impl FnMut(&str)->Option<Vec<f32>>)->Result<Selection,String> {
    let index=baked_scalar_index(default.table.len(),0.).map_err(|e|format!("default table: {e:?}"))?;
    let fallback=default.table[index];
    let mut visited_keys=Vec::new();
    let mut prior_probability=ProbabilityCurve::read_numeric("",|_|None).map_err(|e|format!("initial probability: {e:?}"))?;
    for variant in 0..3 {
        let key=format!("{base}_flex{variant}");visited_keys.push(key.clone());
        let parameter=match ScalarParameter::read_numeric(&key,fallback,&mut lookup)
            .map_err(|e|format!("flex parameter: {e:?}"))? {
            Some(parameter)=>{prior_probability=parameter.probability.clone();parameter},
            None=>ScalarParameter {table:vec![fallback],maximum:fallback,probability:prior_probability.clone()},
        };
        // Original checks the table length and first scalar, not probability.
        let different=parameter.table.len()!=1 || parameter.table[0]!=fallback;
        if different || variant==2 {
            return Ok(Selection {activation:if different {true}else{initial_activation},
                discriminator:if different {variant}else{initial_discriminator},parameter,visited_keys});
        }
    }
    unreachable!()
}
