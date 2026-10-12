// Integration with the existing real CRT packet/FLS/CreateThread pipeline.
use super::*;
use crate::{audio_crt_windows_worker_thread as thread, audio_crt_worker_packet as packet,
    audio_crt_worker_entry::Entry, audio_replay_transport_startup as transport};
use transport::tests::Harness;
type Runtime = Harness<transport::windows::WindowsNetwork>;
thread_local! { static TRANSPORT: std::cell::RefCell<Option<Runtime>> = const { std::cell::RefCell::new(None) }; }
unsafe extern "system" fn callback(argument: u32) -> u32 {
    std::panic::catch_unwind(|| {
        if argument != 0 { return 1; }
        TRANSPORT.with(|slot| match slot.borrow_mut().as_mut() {
            Some(b) => if transport::worker(b).is_ok() { 0 } else { 2 }, None => 3,
        })
    }).unwrap_or(4)
}
struct Capsule { root: Arc<Startup<Owned>>, packet: u32, result: std::sync::mpsc::Sender<(u32, u32, Runtime)> }
#[link(name = "kernel32")]
unsafe extern "system" { fn ExitThread(code: u32) -> !; fn SetLastError(code: u32); }
#[link(name = "kernel32")]
unsafe extern "system" { fn GetCurrentThreadId() -> u32; }
// The new wait/close port uses the real handle, with exclusive borrowed storage.
struct JoinAdapter<'a> { thread: &'a mut thread::Thread, memory: crate::audio_announcer_registry_init::OwnedMemory, last: u32, held: Vec<u32> }
use crate::{audio_announcer_object_lookup as lookup, audio_announcer_registry_init as init, audio_announcer_registry_remove as removal, audio_replay_transport_thread as join_port};
impl lookup::Memory for JoinAdapter<'_> { fn word(&mut self,a:u32)->Result<u32,lookup::Error>{lookup::Memory::word(&mut self.memory,a)} }
impl init::Storage for JoinAdapter<'_> {
 fn allocate(&mut self,n:u32)->Result<u32,init::Error>{init::Storage::allocate(&mut self.memory,n)}
 fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{init::Storage::write_word(&mut self.memory,a,v)}
 fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error>{init::Storage::write_byte(&mut self.memory,a,v)}
 fn register_shutdown(&mut self,c:u32)->Result<(),init::Error>{init::Storage::register_shutdown(&mut self.memory,c)}
}
impl removal::Backend for JoinAdapter<'_> {
 fn write_word(&mut self,a:u32,v:u32)->Result<(),removal::Error>{init::Storage::write_word(&mut self.memory,a,v).map_err(removal::Error::Owned)}
 fn deallocator(&mut self)->Result<removal::Deallocator,removal::Error>{Ok(removal::Deallocator::Standard)}
 fn free(&mut self,p:u32,_:removal::Deallocator)->Result<(),removal::Error>{self.memory.release(p).map_err(removal::Error::Owned)}
}
impl crate::audio_announcer_owner_component_destructor::ControlBoundary for JoinAdapter<'_>{
 fn decrement_reference(&mut self,_:u32)->Result<u32,&'static str>{Err("join test has no control")}
 fn dispose(&mut self,_:u32,_:u32)->Result<(),&'static str>{Err("join test has no control")}
 fn release_control(&mut self,_:u32,_:u32)->Result<(),&'static str>{Err("join test has no control")}
}
impl join_port::Boundary for JoinAdapter<'_>{
 fn current_thread_id(&mut self)->Result<u32,&'static str>{Ok(unsafe{GetCurrentThreadId()})}
 fn wait_handle(&mut self,h:u32,t:u32)->Result<u32,&'static str>{assert!(h==self.thread.label()||(h==0&&self.thread.is_closed()));match self.thread.wait_only(t){Ok(true)=>Ok(0),Ok(false)=>Ok(258),Err(thread::Failure::Windows{operation:"WaitForSingleObject",code})=>{self.last=code;Ok(u32::MAX)},Err(thread::Failure::UnexpectedWait(v))=>Ok(v),Err(_)=>Err("unexpected wait adapter failure")}}
 fn close_handle(&mut self,h:u32)->Result<u32,&'static str>{assert_eq!(h,self.thread.label());match self.thread.close(){Ok(())=>Ok(1),Err(thread::Failure::Windows{operation:"CloseHandle",code})=>{self.last=code;Ok(0)},Err(_)=>Err("unexpected close adapter failure")}}
 fn last_error(&mut self)->Result<u32,&'static str>{Ok(self.last)}
 fn mutex(&mut self,a:u32,enter:bool)->Result<(),&'static str>{if enter{self.held.push(a);}else{assert_eq!(self.held.pop(),Some(a));}Ok(())}
 fn delete_critical_section(&mut self,_:u32)->Result<(),&'static str>{Err("join test does not destroy the thread object")}
 fn create_worker(&mut self,_:&join_port::Launch)->Result<u32,&'static str>{Err("worker already created through the CRT adapter")}
 fn exchange_status(&mut self,_:u32)->Result<u32,&'static str>{Err("join test has no status")}
}
unsafe extern "system" fn entry(parameter: *mut std::ffi::c_void) -> u32 {
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let data = unsafe { Box::from_raw(parameter.cast::<Capsule>()) };
        let Entry::Ready { record } = data.root.initialize_worker_packet(data.packet).unwrap() else { panic!("worker packet not published") };
        assert_eq!(record, data.packet);
        let tid = data.root.context.with(|c| get(&c.memory, &c.dead, record, 4).unwrap()).unwrap();
        TRANSPORT.with(|slot| *slot.borrow_mut() = Some(Runtime::new(transport::windows::WindowsNetwork::default())));
        let exit = data.root.prepare_worker_body_exit().unwrap();
        assert_eq!(exit.code, 0); assert_eq!(data.root.slot.as_ref().unwrap().value().unwrap(), 0);
        data.root.context.with(|c| { assert!(!c.memory.contains_key(&record)); assert_eq!(c.services.inner.inner.pending_ro_initializations(), 0); }).unwrap();
        let runtime = TRANSPORT.with(|slot| slot.borrow_mut().take().unwrap());
        data.result.send((record, tid, runtime)).unwrap();
        exit.code
    }));
    // All owning Rust locals are dropped before the non-returning Windows call.
    unsafe { ExitThread(result.unwrap_or(0xffff_fffe)) }
}
#[test]
fn audio_replay_transport_actual_worker_6_crt_roots_create_packet_execute_global_init_retire_tls_wait_close_and_release_winsock() {
    let p = fixture(); let mut cases = 0;
    for row in p["cases"].as_array().unwrap().iter().filter(|v| v["layout"] == "all" && v["failure"] == "none") {
        let mut context = prepare(&p, row);
        context.memory.insert(0x14ae5f8, Memory { reference: 0x14ae5f8, raw: vec![0;16] });
        context.memory.insert(0x122343c, Memory { reference: 0x122343c, raw: u32::MAX.to_le_bytes().to_vec() });
        let heap = context.services.inner.heap.report(); let locks = context.services.locks.report();
        let root = Arc::new(initialize(context, Some(retire)).unwrap());
        let callback = root.context.with(|c| {
            c.memory.insert(0x40029600, Memory { reference: 0x40029600, raw: vec![0xa5;8] });
            unsafe { c.services.inner.inner.register_worker_callback(callback) }.unwrap()
        }).unwrap();
        let request = packet::Request { security: 0, stack_size: 0, callback, argument: 0, flags: 0, thread_id_output: 0x40029600, callback_slot: 0x40029604 };
        let report = Arc::new(thread::Report::default()); let (send, receive) = std::sync::mpsc::channel(); let mut owned = None; let mut incoming = 0;
        assert_eq!(root.create_worker_packet(request, |q, services, memory, dead| {
            incoming = q.packet; services.inner.heap.synchronize(q.packet, memory).unwrap();
            let capsule = Box::into_raw(Box::new(Capsule { root: root.clone(), packet: q.packet, result: send.clone() }));
            match unsafe { thread::Thread::spawn(0x73000000, q, entry, capsule.cast(), report.clone()) } {
                Ok(thread) => { put(memory, dead, q.thread_id_output, 4, thread.id())?; let label = thread.label(); owned = Some(thread); Ok(label) },
                Err(error) => { unsafe { drop(Box::from_raw(capsule)); } if let thread::Failure::Windows { code, .. } = error { unsafe { SetLastError(code); } Ok(0) } else { Err(Error::Backend("transport thread launch failed")) } },
            }
        }).unwrap(), 0x73000000);
        let mut thread = owned.take().unwrap();
        let label=thread.label();let id=thread.id();let mut memory=init::OwnedMemory::new(0x39000000,0);let p=init::Storage::allocate(&mut memory,80).unwrap();init::Storage::write_word(&mut memory,p,label).unwrap();init::Storage::write_word(&mut memory,p+0x24,id).unwrap();
        let mut adapter=JoinAdapter{thread:&mut thread,memory,last:0,held:vec![]};assert_eq!(join_port::join(&mut adapter,p,10000).unwrap(),0);assert_eq!(lookup::Memory::word(&mut adapter,p).unwrap(),0);assert_eq!(lookup::Memory::word(&mut adapter,p+0x24).unwrap(),0);assert!(adapter.held.is_empty());assert_eq!(join_port::wait(&mut adapter,p,0).unwrap(),2);assert_eq!(adapter.last,6);drop(adapter);assert!(thread.is_closed());
        let (record, tid, mut runtime) = receive.recv_timeout(std::time::Duration::from_secs(1)).unwrap();
        assert_eq!(record, incoming); assert_eq!(tid, thread.id()); drop(thread);
        assert_eq!((report.created(), report.closed()), (1,1)); assert!(report.failures().is_empty());
        assert_eq!(runtime.words[&transport::STATUS], 2); assert_eq!(runtime.words[&transport::REFERENCES], 1); assert_eq!(runtime.network.outstanding(), (1,1));
        transport::release(&mut runtime).unwrap(); assert_eq!(runtime.network.outstanding(), (0,0)); assert!(runtime.held.is_empty());
        root.shutdown().unwrap();
        root.context.with(|c| { assert_eq!(c.services.inner.heap.outstanding(), 0); assert_eq!(c.services.inner.heap.retained_mirrors(), 0); assert!(c.services.locks.is_empty()); }).unwrap();
        assert_eq!((heap.allocations(), heap.frees()), (2,2)); assert!(heap.failures().is_empty() && locks.failures().is_empty());
        cases += 1;
    }
    assert_eq!(cases, 6);
}
