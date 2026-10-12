//! AFB080 reads BKHD/version88 and publishes manager field490 on native failure too.
use crate::{audio_bus_bank::Error,audio_effect_bank_loader::Stream};
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
/// Caller supplies its20-byte output storage; short payloads preserve unread bytes.
/// `manager_flag` represents the bank manager byte490, not a stream mode flag.
pub fn read(stream:&mut Stream,header:&mut[u8;20],manager_flag:&mut u8)->Result<u32,Error>{
    let(status,envelope)=stream.header(8)?;
    let result=if status!=1||envelope[..4]!=*b"BKHD"{7}else{
        let(status,payload)=stream.header(20)?;header[..payload.len()].copy_from_slice(&payload);
        if status!=1{status}else{
            let extra=word(&envelope,4).wrapping_sub(20);
            if extra!=0&&stream.skip_count(extra)?!=extra{56}
            else if word(header,0)!=88{64}else{1}
        }
    };
    *manager_flag=u8::from(word(header,12)!=0);Ok(result)
}
#[cfg(test)]mod tests{
    use super::*;use serde_json::Value;
    fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    fn hex(raw:&[u8])->String{raw.iter().map(|b|format!("{b:02x}")).collect()}
    #[test]fn audio_bank_header_matches63_native_original_version_extension_and_short_read_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_header_contract.json")).unwrap();assert_eq!(proof["case_count"],63);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let pattern=row["pattern"].as_u64().unwrap()as u8;let mut stream=Stream{raw:[pattern;40],base:0,bytes:vec![]};for o in [8,24,28]{stream.raw[o..o+4].copy_from_slice(&0u32.to_le_bytes());}
            assert_eq!(stream.attach_memory(0x30008000,bytes(row["bank_payload"].as_str().unwrap())).unwrap(),1);assert_eq!(hex(&stream.raw),row["before"].as_str().unwrap(),"attach {i}");
            let mut header=[pattern;20];let mut flag=pattern;let result=read(&mut stream,&mut header,&mut flag).unwrap();
            assert_eq!(u64::from(result),row["result"].as_u64().unwrap(),"status {i}");assert_eq!(hex(&stream.raw),row["stream"].as_str().unwrap(),"stream {i}");assert_eq!(hex(&header),row["header"].as_str().unwrap(),"output/preserved padding {i}");assert_eq!(u64::from(flag),row["manager_flag"].as_u64().unwrap(),"failure flag publication {i}");assert!(row["calls"].as_array().unwrap().is_empty());
        }
    }
}
