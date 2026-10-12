//! Capability bootstrap from the owned launcher's private stdin pipe only.
//! No packet/serde diagnostic may be printed. Not a durable credential store.
use std::io::Read;
use openleague_core::{session_transport as t,summoners};
use crate::session_client::Client;

const MAX_BYTES:usize=1024;
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bootstrap {
    version:u16,recovery_key:t::Secret32,initial_nonce:t::RequestNonce,recover:bool,
}
impl Bootstrap {
    pub fn into_client(self,champion:String,summoners:[Option<summoners::Spell>;2])->Result<Client,&'static str>{
        if self.version!=t::VERSION || !self.initial_nonce.valid(){return Err("invalid private session bootstrap");}
        let query_nonce=t::RequestNonce(openleague_core::session_random::bytes()?);
        Client::new(t::JoinRequest{version:self.version,champion,summoners,
            recovery_key:self.recovery_key,request_nonce:self.initial_nonce},self.recover,query_nonce)
    }
}
/// A missing marker preserves explicit legacy launches. A present but invalid
/// marker, pipe, EOF or payload never falls back to legacy/Join.
pub fn read_from_environment()->Result<Option<Bootstrap>,&'static str>{
    match std::env::var("OPENLEAGUE_SESSION_STDIN") {
        Err(std::env::VarError::NotPresent)=>Ok(None),
        Ok(value) if value=="1"=>read(std::io::stdin().lock()).map(Some),
        _=>Err("invalid private session bootstrap mode"),
    }
}
fn read(mut input:impl Read)->Result<Bootstrap,&'static str>{
    // Launcher sends a u32 LE size then exactly that bounded JSON payload and
    // closes its ChildStdin. Read through EOF to reject appended payloads.
    let mut header=[0;4];input.read_exact(&mut header).map_err(|_|"private session bootstrap header unavailable")?;
    let size=u32::from_le_bytes(header) as usize;
    if size==0 || size>MAX_BYTES{return Err("private session bootstrap size rejected");}
    let mut bytes=Vec::with_capacity(size+1);
    input.take((size+1) as u64).read_to_end(&mut bytes).map_err(|_|"private session bootstrap read failed")?;
    if bytes.len()!=size{return Err("private session bootstrap incomplete or oversized");}
    let value:Bootstrap=serde_json::from_slice(&bytes).map_err(|_|"private session bootstrap invalid")?;
    if value.version!=t::VERSION || !value.initial_nonce.valid(){return Err("private session bootstrap invalid");}
    Ok(value)
}

#[cfg(test)] mod tests{
 use super::*;
 fn payload()->Vec<u8>{serde_json::to_vec(&serde_json::json!({"version":1,"recovery_key":vec![213u8;32],"initial_nonce":vec![17u8;16],"recover":true})).unwrap()}
 fn framed(p:&[u8])->Vec<u8>{let mut all=(p.len() as u32).to_le_bytes().to_vec();all.extend_from_slice(p);all}
 #[test] fn private_bootstrap_rejects_eof_truncation_extra_bytes_and_malformed_payload_without_echo(){
  let p=payload();assert!(read(&framed(&p)[..]).is_ok());
  for n in 0..4{assert!(read(&[0;4][..n]).is_err());}
  let original=framed(&p);for n in [4,original.len()-1]{assert!(read(&original[..n]).is_err());}
  let mut extra=original.clone();extra.push(0);assert!(read(&extra[..]).is_err());
  for invalid in [b"{".to_vec(),vec![213;10],b"null".to_vec()]{let e=read(&framed(&invalid)[..]).err().unwrap();assert!(!e.contains("213"));}
  assert!(read(&0u32.to_le_bytes()[..]).is_err());assert!(read(&1025u32.to_le_bytes()[..]).is_err());
 }
 #[test] fn private_bootstrap_rejects_zero_secrets_unknown_fields_and_unsupported_modes(){
  for (field,value) in [("recovery_key",serde_json::json!(vec![0u8;32])),("initial_nonce",serde_json::json!(vec![0u8;16])),("version",serde_json::json!(2)),("unexpected",serde_json::json!(true))]{
   let mut p:serde_json::Value=serde_json::from_slice(&payload()).unwrap();p[field]=value;
   assert!(read(&framed(&serde_json::to_vec(&p).unwrap())[..]).is_err());
  }
 }
}
