//! Original 9192C5..9192FB post-parser admission.
//! Inputs are parsed native fields; an absent decoded group is not sufficient
//! by itself to claim these values or silently discard an emitter.
#[derive(Clone,Copy,Debug)]
pub struct Input {
    pub single_field_334:u32,pub rate_max_field_d4:f32,
    pub flex_flag_4b8:bool,pub auxiliary_vector_nonempty:bool,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Decision {Destroy,Retain}
pub fn decide(input:Input)->Decision {
    if input.single_field_334==0 && input.rate_max_field_d4==0.
        && !input.flex_flag_4b8 && !input.auxiliary_vector_nonempty {
        Decision::Destroy
    } else {Decision::Retain}
}
