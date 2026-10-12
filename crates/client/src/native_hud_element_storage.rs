//! Native 9A5200 successful element allocation/default initialization.
//! Text Type mapping, registration, subsequent initialization and drawing are separate.
#[derive(Debug)]
pub struct ElementStorage { bytes:Vec<u8> }
impl ElementStorage {
    pub fn new(kind:u32)->Result<Self,&'static str> {
        let size=match kind {1=>0x228,2=>0x284,3=>0x30c,_=>return Err("unsupported native HUD element kind")};
        let mut bytes=vec![0;size];
        for (offset,value) in [(0x40,kind),(0x4c,u32::MAX),(0x1d0,1f32.to_bits()),(0x1d4,1f32.to_bits()),(0x1dc,u32::MAX)] {
            bytes[offset..offset+4].copy_from_slice(&value.to_le_bytes());
        }
        Ok(Self {bytes})
    }
    pub fn bytes(&self)->&[u8] {&self.bytes}
    pub fn kind(&self)->u32 {self.word(0x40)}
    pub fn flags(&self)->u32 {self.word(0x48)}
    pub(crate) fn word(&self,offset:usize)->u32 {u32::from_le_bytes(self.bytes[offset..offset+4].try_into().unwrap())}
    pub(crate) fn set_word(&mut self,offset:usize,value:u32) {self.bytes[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
    pub(crate) fn write_bytes(&mut self,offset:usize,value:&[u8]) {self.bytes[offset..offset+value.len()].copy_from_slice(value);}
    pub fn initial_fractions(&self)->[f32;2] {[f32::from_bits(self.word(0x1d0)),f32::from_bits(self.word(0x1d4))]}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_element_bytes_match_original_factory_and_crt_initialization() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_element_storage_contract.json")).unwrap();
        assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
        for c in p["cases"].as_array().unwrap() {
            let kind=c["kind"].as_u64().unwrap() as u32;let element=ElementStorage::new(kind).unwrap();
            let hex=c["output_hex"].as_str().unwrap();let expected=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
            assert_eq!(element.bytes(),expected);assert_eq!(element.kind(),kind);assert_eq!(element.flags(),0);assert_eq!(element.initial_fractions(),[1.,1.]);
        }
        for kind in [0,4,u32::MAX] {assert!(ElementStorage::new(kind).is_err());}
    }
}
