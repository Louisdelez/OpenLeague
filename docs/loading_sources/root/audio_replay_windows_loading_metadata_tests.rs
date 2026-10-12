use super::*;
use crate::{audio_replay_windows_application::Application,audio_replay_metadata as metadata,
    audio_replay_metadata_text as text,audio_replay_object_commands as commands};
struct Defaults;
impl crate::audio_game_service_lifecycle::Settings for Defaults{
 fn float_bits(&mut self,_:&str,_:&str,v:u32)->Result<u32,&'static str>{Ok(v)}
 fn bool_value(&mut self,_:&str,_:&str,v:u8)->Result<u8,&'static str>{Ok(v)}
 fn integer(&mut self,_:&str,_:&str,v:u32)->Result<u32,&'static str>{Ok(v)}
}
#[test]
fn audio_replay_windows_loading_metadata_resolves_from_actual_packet_index_and_preserves_lifetimes(){
 let mut app=Application::new().unwrap();let r=app.transport().unwrap();let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();
 let parent=r.game_manager_snapshot().unwrap().unwrap();let mut b=Backend::new(r.shared.clone());
 // Native mode1 opens the existing local no-op stream and creates its real
 // dual index; initialization alone intentionally leaves nested+6C empty.
 b.event_temporary(64,|b,s|manager::open(b,parent.pointer,manager::Request{
    arguments:[0;2],key:&[0;16],host:None,start:[0;6],mode:1,flag:0,extra:0,
    recording_path:0,recording:0},s).map(|_|()).map_err(|e|b.failure(e,"native local index startup failed"))).unwrap();
 for(key,index,id,name,extra)in [(0xdeadbeefu32,0x80000000u32,73u32,b"Original loading name longer than fifteen bytes".as_slice(),0x12345678u32),(1,0xffffffff,74,b"second".as_slice(),0x80000000)]{
  b.event_temporary(256,|b,s|{
   // Source command72C780 creates the actual native packet object and both indexes.
   for(o,v)in [(0,0),(4,id),(8,key),(12,index)]{b.event_reference(s+o,v)?;}
   commands::dispatch(b,[0,0,0,0,s],s+32).map_err(|e|b.failure(e,"index producer failed"))?;
   let raw=s+96;for(i,v)in name.iter().copied().chain(std::iter::once(0)).enumerate(){Storage::write_byte(b,raw+i as u32,v).unwrap();}
   b.event_reference(s+64,raw)?;b.event_reference(s+80,name.len() as u32)?;b.event_reference(s+84,63)?;
   text::put_string_extra(b,parent.metadata[0],key,index,s+64,extra,s+192).map_err(|e|b.failure(e,"name producer failed"))?;
   Ok(())
  }).unwrap();
  let before=r.snapshot().unwrap().engine_allocations;
  for query in [id,id,9000]{
   b.event_temporary(32,|b,s|{
    loading::service_name(b,s,query,s+24).map_err(|e|b.failure(e,"loading service name failed"))?;
    let len=b.word(s+16).unwrap();let cap=b.word(s+20).unwrap();let raw=if cap<16{s}else{b.word(s).unwrap()};
    let bytes:Vec<u8>=(0..len).map(|i|metadata::Boundary::read_byte(b,raw+i).unwrap()).collect();assert_eq!(bytes,if query==id{name}else{b""});
    assert_eq!(loading::service_extra(b,query,s+24).unwrap(),if query==id{extra}else{0});
    if cap>=16{let route=remove::Backend::deallocator(b).unwrap();remove::Backend::free(b,raw,route).unwrap();}
    Ok(())
   }).unwrap();
   assert_eq!(b.word(parent.metadata[1]+4).unwrap(),1);
  }
  // Only the cached metadata name may add an allocation; temporaries retire.
  assert!(r.snapshot().unwrap().engine_allocations<=before+1);
 }
 r.close_game_manager().unwrap();service.close().unwrap();assert_eq!(r.snapshot().unwrap().engine_allocations,0);app.close().unwrap();
}
