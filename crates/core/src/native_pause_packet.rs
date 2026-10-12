//! LoL4.20 dispatcher5882C6: A1 pause, 0A resume.
//! The caller supplies the dispatcher opcode and validated packet buffer.
//! Transport framing, sender authentication and delivery order are separate.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Directive {
 Pause{actor:u32,remaining_seconds:i32,marker:bool},
 Resume{actor:u32,delayed:bool},
}
pub fn decode(opcode:u16,packet:&[u8])->Result<Directive,&'static str>{
 let minimum=match opcode{0xa1=>14,0x0a=>10,_=>return Err("unsupported pause opcode")};
 if packet.len()<minimum{return Err("truncated native pause packet");}
 let actor=u32::from_le_bytes(packet[5..9].try_into().unwrap());
 Ok(if opcode==0xa1 {Directive::Pause{actor,remaining_seconds:i32::from_le_bytes(packet[9..13].try_into().unwrap()),marker:packet[13]&1!=0}}
 else {Directive::Resume{actor,delayed:packet[9]&1!=0}})
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test] fn native_incoming_cases(){
  let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/game_clock_pause_incoming_contract.json")).unwrap();
  for case in data["cases"].as_array().unwrap(){
   let mut bytes=[0u8;14];let remaining=case["remaining_seconds"].as_i64().unwrap() as i32;let flags=case["raw_flags"].as_u64().unwrap() as u8;
   bytes[5..9].copy_from_slice(&0x12345678u32.to_le_bytes());bytes[9..13].copy_from_slice(&remaining.to_le_bytes());bytes[13]=flags;
   assert_eq!(decode(0xa1,&bytes),Ok(Directive::Pause{actor:0x12345678,remaining_seconds:remaining,marker:flags&1!=0}));
   bytes[9]=flags;assert_eq!(decode(0x0a,&bytes[..10]),Ok(Directive::Resume{actor:0x12345678,delayed:flags&1!=0}));
  }
 }
 #[test] fn rejects_every_truncation_and_unknown_opcode(){
  for (opcode,len) in [(0xa1,14),(0x0a,10)]{for n in 0..len{assert!(decode(opcode,&vec![0;n]).is_err());}}
  assert!(decode(0xffff,&[0;14]).is_err());
 }
}
