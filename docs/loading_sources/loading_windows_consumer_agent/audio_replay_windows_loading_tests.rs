use super::*;
use crate::{audio_loading_record_tree as tree, audio_replay_metadata as metadata};
use crate::audio_replay_windows_application::Application;

struct Defaults;
impl crate::audio_game_service_lifecycle::Settings for Defaults {
    fn float_bits(&mut self, _: &str, _: &str, v:u32)->Result<u32,&'static str>{Ok(v)}
    fn bool_value(&mut self, _: &str, _: &str, v:u8)->Result<u8,&'static str>{Ok(v)}
    fn integer(&mut self, _: &str, _: &str, v:u32)->Result<u32,&'static str>{Ok(v)}
}
fn write<N:startup::Network+Send+'static>(b:&mut Backend<N>,p:u32,v:u32){Storage::write_word(b,p,v).unwrap();}
fn read_bytes<N:startup::Network+Send+'static>(b:&mut Backend<N>,p:u32,n:u32)->Vec<u8>{
    (0..n).map(|i|metadata::Boundary::read_byte(b,p+i).unwrap()).collect()
}

// These are explicit diagnostic storage bindings, NOT recipient constructors
// or loading-screen factory qualification. Only each tree uses its real ctor.
// Global control remains null, so this borrowed binding claims no shared owner.
struct Recipient {kind:Kind,p:u32,table:u32,wrapper:u32,key:u32,old:[u32;2]}
impl Recipient {
    fn tree(&self)->u32{self.p+match self.kind{Kind::Standard=>0x1c,Kind::Tutorial=>4}}
    fn create<N:startup::Network+Send+'static>(b:&mut Backend<N>,kind:Kind)->Self{
        let old=[b.word(packet95::GLOBAL_PAIR).unwrap(),b.word(packet95::GLOBAL_PAIR+4).unwrap()];
        assert_eq!(old,[0,0],"diagnostic binding requires an unowned global pair");
        let p=b.allocate(match kind{Kind::Standard=>0x608,Kind::Tutorial=>0x1f8}).unwrap();
        let table=b.allocate(4).unwrap();let wrapper=b.allocate(4).unwrap();let key=b.allocate(4).unwrap();
        write(b,table,match kind{Kind::Standard=>0x57d650,Kind::Tutorial=>0x5b3230});
        write(b,p,table);write(b,wrapper,p);
        let value=Self{kind,p,table,wrapper,key,old};tree::construct(b,kind,value.tree()).unwrap();
        write(b,packet95::GLOBAL_PAIR+4,0);write(b,packet95::GLOBAL_PAIR,wrapper);value
    }
    fn record<N:startup::Network+Send+'static>(&self,b:&mut Backend<N>,key:u32)->u32{
        write(b,self.key,key);tree::record_slot(b,self.kind,self.tree(),self.key).unwrap()
    }
    fn seed_name<N:startup::Network+Send+'static>(&self,b:&mut Backend<N>,record:u32){
        let s=record+match self.kind{Kind::Standard=>0x30,Kind::Tutorial=>0x28};
        b.write_byte(s,b'n').unwrap();b.write_byte(s+1,0).unwrap();write(b,s+16,1);write(b,s+20,15);
    }
    fn destroy<N:startup::Network+Send+'static>(self,b:&mut Backend<N>){
        write(b,packet95::GLOBAL_PAIR,self.old[0]);write(b,packet95::GLOBAL_PAIR+4,self.old[1]);
        tree::destroy(b,self.kind,self.tree()).unwrap();
        for p in [self.key,self.wrapper,self.table,self.p]{remove::Backend::free(b,p,remove::Deallocator::Standard).unwrap();}
    }
}
fn packet(owner:u32,key:u32,flags:u8,extended:bool)->Vec<u8>{
    let mut p=vec![0u8;30];p[0]=if extended{0xfe}else{0x95};p[1..5].copy_from_slice(&owner.to_le_bytes());
    for (i,v) in [key,0x55667788,0x99aabbcc,0x80000001,0x7f800123,0x13579bdf].into_iter().enumerate(){p[5+i*4..9+i*4].copy_from_slice(&v.to_le_bytes());}
    p[29]=flags;if extended{p[5]=0x95;p[6]=0;}p
}
#[test]
fn audio_replay_windows_loading_uses_real_trees_and_consumer_for48_hot_packets(){
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();
    let service_pointer=service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b=Backend::new(r.shared.clone());let local=b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();let mut context=0;
    for kind in [Kind::Standard,Kind::Tutorial]{
        let recipient=Recipient::create(&mut b,kind);
        for key in [0,0x80000000,0xffffffff]{for extended in [false,true]{for flag in [0,1,128,255]{
            let packet=packet(local,key,flag,extended);let actual_key=u32::from_le_bytes(packet[5..9].try_into().unwrap());
            let record=recipient.record(&mut b,actual_key);recipient.seed_name(&mut b,record);
            let size=match kind{Kind::Standard=>120,Kind::Tutorial=>76};let mut expected=read_bytes(&mut b,record,size);
            expected[..25].copy_from_slice(&packet[5..30]);if flag&1!=0{expected[16..20].fill(0);}
            let allocations=r.snapshot().unwrap().engine_allocations;context+=1;
            assert_eq!(r.receive_game_event(0,3,2,context,&packet).unwrap(),1);
            assert_eq!(read_bytes(&mut b,record,size),expected);assert_eq!(b.word(service_pointer+0x5c).unwrap(),context);
            assert_eq!(r.snapshot().unwrap().engine_allocations,allocations);
        }}}
        recipient.destroy(&mut b);
    }
    assert_eq!(context,48);assert!(r.errors().is_empty());r.close_game_manager().unwrap();service.close().unwrap();assert_eq!(r.snapshot().unwrap().engine_allocations,0);app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_rejects_truncation_before_any_runtime_mutation(){
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();
    let owner=service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
    let mut b=Backend::new(r.shared.clone());let local=b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();
    // A null global object has no payload reads, so the five-byte compact packet
    // remains a valid no-op under source577E90. Extended form needs seven bytes.
    for p in [packet(local,0,0,false)[..5].to_vec(),packet(local,0,0,true)[..7].to_vec()]{assert_eq!(r.receive_game_event(0,3,2,9,&p).unwrap(),1);}
    for kind in [Kind::Standard,Kind::Tutorial]{
        let recipient=Recipient::create(&mut b,kind);let before_context=b.word(owner+0x5c).unwrap();
        let before={let bank=r.shared.bank.lock().unwrap();(bank.memory.allocations.clone(),bank.memory.released_labels.clone(),bank.owned.clone(),bank.next_scratch,bank.event_scratch.clone())};
        let before_tree=read_bytes(&mut b,recipient.tree(),8);
        for extended in [false,true]{let complete=packet(local,123,0,extended);for length in (if extended{7}else{5})..30{
            assert!(r.receive_game_event(0,3,2,0xdeadbeef,&complete[..length]).unwrap_err().contains("truncated loading-screen"));
        }}
        let after={let bank=r.shared.bank.lock().unwrap();(bank.memory.allocations.clone(),bank.memory.released_labels.clone(),bank.owned.clone(),bank.next_scratch,bank.event_scratch.clone())};
        assert_eq!(before,after);assert_eq!(b.word(owner+0x5c).unwrap(),before_context);assert_eq!(read_bytes(&mut b,recipient.tree(),8),before_tree);
        assert_eq!([b.word(packet95::GLOBAL_PAIR).unwrap(),b.word(packet95::GLOBAL_PAIR+4).unwrap()],[recipient.wrapper,0]);recipient.destroy(&mut b);
    }
    assert!(r.errors().is_empty());r.close_game_manager().unwrap();service.close().unwrap();assert_eq!(r.snapshot().unwrap().engine_allocations,0);app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_keeps_missing_standard_ui_and_unknown_targets_explicit(){
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();let service=r.configure_service(Defaults).unwrap();r.initialize_game_manager().unwrap();
    let mut b=Backend::new(r.shared.clone());let local=b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();
    let recipient=Recipient::create(&mut b,Kind::Standard);let p=packet(local,42,1,false);let before=r.snapshot().unwrap().engine_allocations;
    assert!(r.receive_game_event(0,3,2,77,&p).is_err());assert_eq!(b.word(recipient.tree()+4).unwrap(),1);
    let record=recipient.record(&mut b,42);let mut expected=p[5..30].to_vec();expected[16..20].fill(0);assert_eq!(read_bytes(&mut b,record,25),expected);
    assert_eq!(r.snapshot().unwrap().engine_allocations,before+1);assert!(r.errors().iter().any(|e|e.contains("UI continuation57D6CB")));
    let live=r.snapshot().unwrap().engine_allocations;assert!(r.receive_game_event(0,3,2,78,&p).is_err());assert_eq!(r.snapshot().unwrap().engine_allocations,live);
    assert!(packet95::Boundary::receive_payload(&mut b,recipient.p,0xdeadbeef,0).is_err());
    assert!(loading::Boundary::service_name(&mut b,0,0xdeadbeef,0,42).is_err());
    assert_eq!(r.snapshot().unwrap().engine_allocations,live);recipient.destroy(&mut b);
    r.close_game_manager().unwrap();service.close().unwrap();assert_eq!(r.snapshot().unwrap().engine_allocations,0);app.close().unwrap();
}
