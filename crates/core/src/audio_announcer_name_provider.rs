//! Control flow of original716CE0. Encoding and allocation backends remain explicit.
//! The returned cache is borrowed from the actor; no fallback name is invented here.
use crate::audio_announcer_actor_name::NameStorage;
pub const FAILURE_FORMAT: &[u8] = b"Name conversion to multibyte failed for name: %s\n";
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Allocator { Standard, Custom { context: u32 } }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Diagnostic { First, Second, Final { flags: [u32; 3] } }
/// A backend-owned native string temporary. Tokens are labels, never host pointers.
pub struct Temporary { pub capacity: u32, pub allocation: Option<u32> }
pub trait Backend<A: Copy> {
    fn raw_name(&mut self, actor: A) -> Result<NameStorage<'_>, &'static str>;
    fn copy_temporary(&mut self, bytes: &[u8]) -> Result<Temporary, &'static str>;
    fn convert_into_cache(&mut self, actor: A, temporary: &Temporary) -> Result<bool, &'static str>;
    fn allocator(&mut self) -> Result<Allocator, &'static str>;
    fn free_standard(&mut self, allocation: u32) -> Result<(), &'static str>;
    fn free_custom(&mut self, allocation: u32, context: u32) -> Result<(), &'static str>;
    fn diagnostic(&mut self, kind: Diagnostic, format: &[u8], raw_name: &[u8]) -> Result<(), &'static str>;
    fn cache(&mut self, actor: A) -> Result<NameStorage<'_>, &'static str>;
}
/// Port of the admitted normal-return path. Backend Err rejects an unsupported boundary;
/// native SEH/exception unwinding is not claimed by this control-flow function.
pub fn converted_name<A: Copy>(actor: A, backend: &mut impl Backend<A>) -> Result<NameStorage<'_>, &'static str> {
    converted_name_by(actor,backend,|b,a,t|b.convert_into_cache(a,t))
}
/// Actual conversion consumes explicit temporary storage, including any qualified lookahead.
pub trait NativeEncodingStorage<A:Copy>:Backend<A> {
    fn temporary_memory(&self, temporary:&Temporary)->Result<&[u8], &'static str>;
    fn replace_cache(&mut self, actor:A, converted:&crate::audio_announcer_name_encoding::ConvertedName)->Result<(), &'static str>;
}
pub fn converted_name_with_native_encoding<A:Copy,B:NativeEncodingStorage<A>>(actor:A,backend:&mut B)->Result<NameStorage<'_>, &'static str> {
    converted_name_by(actor,backend,|b,a,t| {
        let converted=crate::audio_announcer_name_encoding::convert_name_bytes(b.temporary_memory(t)?)?;
        b.replace_cache(a,&converted)?;Ok(converted.success)
    })
}
fn converted_name_by<A:Copy,B:Backend<A>>(actor:A,backend:&mut B,convert:impl FnOnce(&mut B,A,&Temporary)->Result<bool,&'static str>)->Result<NameStorage<'_>, &'static str> {
    let raw = backend.raw_name(actor)?.nul_bytes()?.to_vec();
    let temporary = backend.copy_temporary(&raw)?;
    let success = convert(backend, actor, &temporary)?;
    if temporary.capacity >= 16 {
        let allocation = temporary.allocation.ok_or("native name temporary allocation unavailable")?;
        match backend.allocator()? {
            Allocator::Standard => backend.free_standard(allocation)?,
            Allocator::Custom { context } => backend.free_custom(allocation, context)?,
        }
    }
    if !success {
        for kind in [Diagnostic::First, Diagnostic::Second, Diagnostic::Final { flags: [2, 1, 0] }] {
            // Original executes the virtual getter again for each diagnostic, after cleanup.
            let raw = backend.raw_name(actor)?.nul_bytes()?.to_vec();
            backend.diagnostic(kind, FAILURE_FORMAT, &raw)?;
        }
    }
    // Conversion false is not a replacement name and does not suppress the cache result.
    backend.cache(actor)
}
#[cfg(test)] mod tests {
    use super::*;
    struct Provider { sequence: Vec<Vec<u8>>, calls: usize, inline: [u8;16], buffer: Vec<u8>, capacity: u32, converted: Vec<u8>, success: bool, allocator: Allocator, trace: Vec<&'static str>, inputs: Vec<String>, diagnostics: Vec<serde_json::Value>, frees: usize }
    impl Provider {
        fn storage(&mut self, bytes: Vec<u8>) {
            self.inline = [0;16];self.capacity = if bytes.len()<16 {15} else {bytes.len() as u32};
            if bytes.len()<16 {self.inline[..bytes.len()].copy_from_slice(&bytes);}
            self.buffer=bytes;self.buffer.push(0);
        }
        fn view(&self)->NameStorage<'_> {NameStorage {inline:&self.inline,capacity:self.capacity,heap:Some(&self.buffer)}}
    }
    impl Backend<u32> for Provider {
        fn raw_name(&mut self, actor:u32)->Result<NameStorage<'_>, &'static str> {
            assert_eq!(actor,7);self.trace.push("virtual_name");let bytes=self.sequence[self.calls].clone();self.calls+=1;self.storage(bytes);Ok(self.view())
        }
        fn copy_temporary(&mut self, bytes:&[u8])->Result<Temporary, &'static str> {
            self.trace.push("temporary_copy");self.inputs.push(String::from_utf8(bytes.to_vec()).unwrap());
            Ok(Temporary {capacity:if bytes.len()<16 {15} else {bytes.len() as u32},allocation:(bytes.len()>=16).then_some(123)})
        }
        fn convert_into_cache(&mut self, actor:u32,_:&Temporary)->Result<bool, &'static str> {assert_eq!(actor,7);self.trace.push("conversion");Ok(self.success)}
        fn allocator(&mut self)->Result<Allocator, &'static str> {Ok(self.allocator)}
        fn free_standard(&mut self, allocation:u32)->Result<(), &'static str> {assert_eq!(allocation,123);assert_eq!(self.allocator,Allocator::Standard);self.trace.push("temporary_free");self.frees+=1;Ok(())}
        fn free_custom(&mut self, allocation:u32,context:u32)->Result<(), &'static str> {assert_eq!(allocation,123);assert_eq!(self.allocator,Allocator::Custom {context});self.trace.push("custom_temporary_free");self.frees+=1;Ok(())}
        fn diagnostic(&mut self, kind:Diagnostic, format:&[u8], raw:&[u8])->Result<(), &'static str> {
            self.trace.push("diagnostic");let mut d=serde_json::json!({"function":if matches!(kind,Diagnostic::Final {..}) {"0x5fa170"} else {"0x5642d0"},"format":std::str::from_utf8(format).unwrap(),"name":std::str::from_utf8(raw).unwrap()});
            if let Diagnostic::Final {flags}=kind {d["flags"]=serde_json::json!(flags);}
            self.diagnostics.push(d);Ok(())
        }
        fn cache(&mut self,actor:u32)->Result<NameStorage<'_>, &'static str> {assert_eq!(actor,7);self.storage(self.converted.clone());Ok(self.view())}
    }
    #[test] fn audio_name_provider_control_matches36_native_standard_custom_cleanup_and_fresh_failure_diagnostics() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_provider_allocator_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
        for c in cases {
            let mut backend=Provider {sequence:c["raw_sequence"].as_array().unwrap().iter().map(|v|v.as_str().unwrap().as_bytes().to_vec()).collect(),calls:0,inline:[0;16],buffer:vec![],capacity:15,converted:c["provided_conversion_result"].as_str().unwrap().as_bytes().to_vec(),success:c["conversion_success"].as_bool().unwrap(),allocator:if c["allocator"]=="custom" {Allocator::Custom {context:c["custom_free_context"].as_u64().unwrap() as u32}} else {Allocator::Standard},trace:vec![],inputs:vec![],diagnostics:vec![],frees:0};
            let output=converted_name(7,&mut backend).unwrap().ascii_text().unwrap();
            assert_eq!(output,c["output"].as_str().unwrap());assert_eq!(backend.calls as u64,c["virtual_calls"].as_u64().unwrap());assert_eq!(backend.frees as u64,c["temporary_frees"].as_u64().unwrap());
            assert_eq!(serde_json::json!(backend.inputs),c["conversion_inputs"]);assert_eq!(serde_json::json!(backend.trace),c["trace"]);assert_eq!(serde_json::json!(backend.diagnostics),c["diagnostics"]);
        }
    }
}

#[cfg(test)] mod native_encoding_tests {
    use super::*;
    use crate::audio_announcer_name_encoding::ConvertedName;
    #[derive(Clone)]
    struct Storage {inline:[u8;16], heap:Vec<u8>, capacity:u32}
    impl Storage {
        fn new(bytes:&[u8],capacity:u32)->Self {
            let capacity=capacity.max(bytes.len() as u32);let mut inline=[0;16];
            if capacity<16 {inline[..bytes.len()].copy_from_slice(bytes);}
            let mut heap=vec![0;capacity as usize+1];heap[..bytes.len()].copy_from_slice(bytes);
            Self {inline,heap,capacity}
        }
        fn view(&self)->NameStorage<'_> {NameStorage {inline:&self.inline,capacity:self.capacity,heap:Some(&self.heap)}}
    }
    #[derive(Clone)]
    struct NativeProvider {raw:Storage,cache:Storage,memory:Vec<u8>,allocator:Allocator,getters:usize,copied:Vec<Vec<u8>>,raw_frees:usize}
    impl Backend<u32> for NativeProvider {
        fn raw_name(&mut self,actor:u32)->Result<NameStorage<'_>, &'static str> {assert_eq!(actor,7);self.getters+=1;Ok(self.raw.view())}
        fn copy_temporary(&mut self,bytes:&[u8])->Result<Temporary, &'static str> {
            self.copied.push(bytes.to_vec());
            let capacity=if bytes.len()<16 {15} else {bytes.len() as u32};
            // Same explicit native-layout constructor boundary as the original composed fixture.
            self.memory=if capacity<16 {
                let mut memory=vec![0xcc;24];memory[..bytes.len()].copy_from_slice(bytes);memory[bytes.len()]=0;
                memory[16..20].copy_from_slice(&(bytes.len() as u32).to_le_bytes());memory[20..24].copy_from_slice(&capacity.to_le_bytes());memory
            } else {let mut memory=bytes.to_vec();memory.push(0);memory.extend_from_slice(&[0xcc;32]);memory};
            Ok(Temporary {capacity,allocation:(capacity>=16).then_some(123)})
        }
        fn convert_into_cache(&mut self,_:u32,_:&Temporary)->Result<bool, &'static str> {Err("supplied conversion must not run")}
        fn allocator(&mut self)->Result<Allocator, &'static str> {Ok(self.allocator)}
        fn free_standard(&mut self,id:u32)->Result<(), &'static str> {assert_eq!(id,123);assert_eq!(self.allocator,Allocator::Standard);self.raw_frees+=1;Ok(())}
        fn free_custom(&mut self,id:u32,context:u32)->Result<(), &'static str> {assert_eq!(id,123);assert_eq!(self.allocator,Allocator::Custom {context});self.raw_frees+=1;Ok(())}
        fn diagnostic(&mut self,_:Diagnostic,_:&[u8],_:&[u8])->Result<(), &'static str> {Err("unexpected native conversion diagnostic")}
        fn cache(&mut self,actor:u32)->Result<NameStorage<'_>, &'static str> {assert_eq!(actor,7);Ok(self.cache.view())}
    }
    impl NativeEncodingStorage<u32> for NativeProvider {
        fn temporary_memory(&self,_:&Temporary)->Result<&[u8], &'static str> {Ok(&self.memory)}
        fn replace_cache(&mut self,actor:u32,converted:&ConvertedName)->Result<(), &'static str> {
            assert_eq!(actor,7);self.cache=Storage::new(&converted.bytes,self.cache.capacity.max(converted.sized_cache_len as u32));Ok(())
        }
    }
    fn unhex(text:&str)->Vec<u8> {(0..text.len()).step_by(2).map(|i|u8::from_str_radix(&text[i..i+2],16).unwrap()).collect()}
    fn hex(bytes:&[u8])->String {bytes.iter().map(|b|format!("{b:02x}")).collect()}
    #[test] fn audio_provider_real_conversion_and_owned_cache_match1324_composed_original_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_provider_composed_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1324);
        for case in cases {
            let raw=unhex(case["input_hex"].as_str().unwrap());let previous=case["previous_cache"].as_str().unwrap().as_bytes();
            let mut backend=NativeProvider {raw:Storage::new(&raw,15),cache:Storage::new(previous,15),memory:vec![],allocator:if case["allocator"]=="custom" {Allocator::Custom {context:0x34567890}} else {Allocator::Standard},getters:0,copied:vec![],raw_frees:0};
            let observed=converted_name_with_native_encoding(7,&mut backend).unwrap().nul_bytes().unwrap().to_vec();
            let expected=unhex(case["output_hex"].as_str().unwrap());let end=expected.iter().position(|b|*b==0).unwrap_or(expected.len());assert_eq!(observed,&expected[..end]);
            assert_eq!(backend.cache.capacity as u64,case["capacity"].as_u64().unwrap());
            assert_eq!(serde_json::json!(backend.copied.iter().map(|b|hex(b)).collect::<Vec<_>>()),case["copied_inputs"]);assert_eq!(backend.getters as u64,case["getter_calls"].as_u64().unwrap());
            let units=crate::audio_announcer_name_encoding::decode_cstring(&backend.memory,&mut[]).unwrap();
            // Native physical allocation remains a boundary; compare its modeled threshold separately.
            assert_eq!(backend.raw_frees+usize::from(units>=8),case["temporary_frees"].as_u64().unwrap() as usize);
        }
    }

    impl crate::audio_announcer_actor_name::Backend<u32> for NativeProvider {
        fn flags(&mut self,_:u32)->Result<u32,&'static str> {Ok(0x1000)}
        fn converted_name(&mut self,actor:u32)->Result<NameStorage<'_>,&'static str> {converted_name_with_native_encoding(actor,self)}
        fn localize(&mut self,_:&'static str)->Result<String,&'static str> {Err("hero name must not localize")}
    }
    #[test] fn audio_full_name_formatting_matches7944_native_provider_conversion_and_dispatch_frames() {
        use crate::audio_announcer_actor_name::{bind_name_bytes,exhausted_fallback_bytes,bind_name,exhausted_fallback};
        use crate::audio_announcer_actor_wrapper::Form;
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_full_formatter_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),7944);
        for case in cases {
            let raw=unhex(case["input_hex"].as_str().unwrap());let previous=case["previous_cache"].as_str().unwrap().as_bytes();
            let mut backend=NativeProvider {raw:Storage::new(&raw,15),cache:Storage::new(previous,15),memory:vec![],allocator:if case["allocator"]=="custom" {Allocator::Custom {context:0x34567890}} else {Allocator::Standard},getters:0,copied:vec![],raw_frees:0};
            let mut text_backend=backend.clone();let form=if case["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let input=case["input"].as_str().unwrap();
            let output=if input==" unknown field@" {exhausted_fallback_bytes(Some(7),&mut backend).unwrap()} else {bind_name_bytes(input.as_bytes(),Some(7),form,&mut backend).unwrap().unwrap()};
            assert_eq!(hex(&output),case["formatter_output_hex"].as_str().unwrap());assert_eq!(backend.cache.capacity as u64,case["capacity"].as_u64().unwrap());assert_eq!(backend.getters as u64,case["getter_calls"].as_u64().unwrap());assert_eq!(serde_json::json!(backend.copied.iter().map(|b|hex(b)).collect::<Vec<_>>()),case["copied_inputs"]);
            let text=if input==" unknown field@" {exhausted_fallback(Some(7),&mut text_backend)} else {bind_name(input,Some(7),form,&mut text_backend).map(Option::unwrap)};
            match String::from_utf8(output) {Ok(expected)=>assert_eq!(text.unwrap(),expected),Err(_)=>assert_eq!(text.unwrap_err(),"native name cannot be represented as UTF-8")}
        }
    }
}
