#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct RtpcRequest {
    pub id:u32, pub value_bits:u32, pub owner:u32, pub duration:u32, pub curve:u32,
}
