//! Native8E2E80 temporary frame packet:300initialized bytes, no-op element drop.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Scratch {pub words:[u32;75]}
impl Default for Scratch {
    fn default()->Self {
        let mut words=[0;75];words[0x114/4..0x120/4].fill(0x7f7fffff);words[0x120/4..0x12c/4].fill(0xff7fffff);Self {words}
    }
}
impl Scratch {
    /// Original8E36B0 consumes explicit native planes and support selectors.
    /// These inputs must come from a qualified producer; no camera inference here.
    pub fn set_visibility_inputs(&mut self,planes:[[u32;4];6],selectors:[[u32;3];6]) {
        for i in 0..6 {self.words[0x6c/4+i*4..0x6c/4+(i+1)*4].copy_from_slice(&planes[i]);self.words[0xcc/4+i*3..0xcc/4+(i+1)*3].copy_from_slice(&selectors[i]);}
    }
    pub fn contains_bounds(&self,bounds:[u32;6])->Result<bool,&'static str> {
        if self.words[0xcc/4..0x114/4].iter().any(|i|*i>=6) {return Err("native visibility support selector outside bounds");}
        for plane in 0..6 {
            let p=&self.words[0x6c/4+plane*4..0x6c/4+(plane+1)*4];let s=&self.words[0xcc/4+plane*3..0xcc/4+(plane+1)*3];
            let y=arithmetic(p[1],bounds[s[1] as usize],false);let x=arithmetic(p[0],bounds[s[0] as usize],false);let z=arithmetic(bounds[s[2] as usize],p[2],false);
            let dot=arithmetic(arithmetic(arithmetic(y,x,true),z,true),p[3],true);
            if 0.0>f32::from_bits(dot) {return Ok(false);}
        }
        Ok(true)
    }
    /// Original8E35C0 tri-state classification: outside=-1, intersecting=0, inside=1.
    /// The second support point uses the selectors of the opposite plane (reverse order).
    pub fn classify_bounds(&self,bounds:[u32;6])->Result<i32,&'static str> {
        if self.words[0xcc/4..0x114/4].iter().any(|i|*i>=6) {return Err("native visibility support selector outside bounds");}
        let mut result=1;
        for plane in 0..6 {
            let p=&self.words[0x6c/4+plane*4..0x6c/4+(plane+1)*4];
            let dot=|selector:usize| {
                let s=&self.words[0xcc/4+selector*3..0xcc/4+(selector+1)*3];
                let x=arithmetic(p[0],bounds[s[0] as usize],false);let y=arithmetic(p[1],bounds[s[1] as usize],false);let z=arithmetic(p[2],bounds[s[2] as usize],false);
                f32::from_bits(arithmetic(arithmetic(arithmetic(x,y,true),z,true),p[3],true))
            };
            if dot(plane)<0. {return Ok(-1);}
            let opposite=dot(5-plane);
            // COMISS/JB regards unordered as below: NaN retains the current class.
            if !opposite.is_nan() && opposite<=0. {result=0;}
        }
        Ok(result)
    }
    /// Unspecified channels remain raw until their producers are qualified.
    pub fn bytes(&self)->[u8;0x12c] {
        let mut bytes=[0;0x12c];for (i,w) in self.words.iter().enumerate(){bytes[i*4..i*4+4].copy_from_slice(&w.to_le_bytes());}bytes
    }
    /// The original six5642D0 element destructors do nothing.
    pub fn destroy(self) {}
}
fn arithmetic(a:u32,b:u32,add:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);
    if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let v=if add {x+y}else{x*y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
/// Initialize only the native300-byte footprint, preserving surrounding memory.
pub fn initialize_into(destination:&mut [u8])->Result<(),&'static str> {
    if destination.len()<0x12c {return Err("scratch destination is shorter than native footprint");}
    destination[..0x12c].copy_from_slice(&Scratch::default().bytes());Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bytes(v:&Value)->Vec<u8>{v.as_str().unwrap().as_bytes().chunks_exact(2).map(|c|u8::from_str_radix(std::str::from_utf8(c).unwrap(),16).unwrap()).collect()}
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn visibility_matches322_native_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_visibility_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),322);assert_eq!(p["actual_cpu_sse_operations"],5316);
        for (i,row) in p["cases"].as_array().unwrap().iter().enumerate() {
            let planes=std::array::from_fn(|i|std::array::from_fn(|j|bits(&row["planes"][i][j])));let selectors=std::array::from_fn(|i|std::array::from_fn(|j|row["selectors"][i][j].as_u64().unwrap() as u32));let bounds=std::array::from_fn(|i|bits(&row["bounds"][i]));
            let mut scratch=Scratch::default();scratch.set_visibility_inputs(planes,selectors);let original=scratch.clone();assert_eq!(scratch.contains_bounds(bounds).unwrap(),row["cpu"].as_bool().unwrap(),"case{i}");assert_eq!(scratch,original);
        }
    }
    #[test]
    fn invalid_support_selector_returns_error_without_mutating_packet() {
        let mut scratch=Scratch::default();scratch.words[0xcc/4+17]=6;let original=scratch.clone();assert!(scratch.contains_bounds([0;6]).is_err());assert_eq!(scratch,original);
    }
    #[test]
    fn constructor_matches16_native_memory_patterns_and_alignments() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_scratch_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),16);
        for row in p["cases"].as_array().unwrap() {
            let before=bytes(&row["before"]);let padding=16+row["alignment"].as_u64().unwrap() as usize;let mut memory=vec![0xa5;padding];memory.extend(&before);memory.extend([0x5a;16]);
            initialize_into(&mut memory[padding..padding+before.len()]).unwrap();assert_eq!(&memory[padding..padding+before.len()],bytes(&row["after"]));assert!(memory[..padding].iter().all(|b|*b==0xa5));assert!(memory[padding+before.len()..].iter().all(|b|*b==0x5a));
            assert_eq!(row["after"],row["after_destroy"]);assert_eq!(&memory[padding..padding+0x12c],Scratch::default().bytes());Scratch::default().destroy();
        }
    }
}
