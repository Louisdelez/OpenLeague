from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def read(n):return (r/'crates/core/src'/n).read_text(encoding='utf-8')
def save(n,t):(s/n).write_text(t,encoding='utf-8')
t=read('audio_replay_windows_opening.rs')
t=t.replace('    pointer: u32,\n    code:', '    pub(super) pointer: u32,\n    code:')
anchor='        if self.shared.diagnostics.is_some() {'
assert t.count(anchor)==1
t=t.replace(anchor,'''        self.open_stream_owned(request, 0, 0)
    }
    /// Caller holds launch for the entire operation. Recording callers must
    /// preserve native start/stop and retire the raw logger callbacks on cleanup.
    pub(super) fn open_stream_owned(&self, request: StreamOpenRequest<'_>, recording_path: u32, recording: u32) -> Result<u32, String> {
'''+anchor)
t=t.replace('                recording_path: 0,\n                recording: 0,','                recording_path,\n                recording,')
anchor='impl<N: startup::Network + Send + \'static> opening::Boundary for Backend<N> {}'
assert anchor in t
t=t.replace(anchor,'''impl<N: startup::Network + Send + 'static> opening::Boundary for Backend<N> {
    fn prepare_recording(&mut self, p:u32, path:u32) -> Result<bool,&'static str> {
        let scratch = self.recording_scratch(16)?;
        let result = crate::audio_replay_recording_resource::prepare(self,p,path,scratch);
        let cleanup = self.shared.bank.lock().unwrap().memory.release(scratch);
        match (result,cleanup) {
            (Ok(v),Ok(())) => Ok(v),
            (a,b) => Err(self.failure((a,b),"stream file preparation failed")),
        }
    }
}''')
anchor='impl<N: startup::Network + Send + \'static> stream::Boundary for Backend<N> {'
t=t.replace(anchor,anchor+'''
    fn close_resource(&mut self,p:u32)->Result<(),&'static str>{
        crate::audio_replay_recording_resource::close(self,p).map(|_|()).map_err(|e|self.failure(e,"stream file close failed"))
    }
''')
save('audio_replay_windows_opening.rs',t)
t=read('audio_replay_windows_transport.rs')
t=t.replace('self.shared.diagnostics.is_some() || callback != logger::SHUTDOWN','self.shared.diagnostics.is_some() || ![logger::SHUTDOWN,crate::audio_replay_path_registry::SHUTDOWN].contains(&callback)')
t=t.replace('pub use recording::RecordingFileProbe;','pub use recording::{RecordingFileProbe, RecordingStreamProbe};')
anchor='    fn dispose(&mut self, p: u32, f: u32) -> Result<(), &\'static str> {'
assert t.count(anchor)==1
t=t.replace(anchor,anchor+'''
        if f == crate::audio_replay_recording_resource::CONTROL_DISPOSE {
            return crate::audio_replay_recording_resource::dispose_control(self,p).map_err(|e|self.failure(e,"recording control disposal failed"));
        }
''')
anchor='        if !self.shared.bank.lock().unwrap().owned.is_empty() {\n            return Err("engine allocations remain live at shutdown".into());'
assert anchor in t
t=t.replace(anchor,'''        // Only an actually initialized source singleton owns its tree sentinel.
        // Older externally supplied transport banks need not contain this region.
        if self.shared.bank.lock().unwrap().memory.word(crate::audio_replay_path_registry::FLAG).ok().is_some_and(|v|v&1!=0) {
            crate::audio_replay_path_registry::shutdown(&mut b).map_err(|e|format!("path registry shutdown: {e:?}"))?;
        }
'''+anchor)
save('audio_replay_windows_transport.rs',t)
t=read('audio_replay_windows_recording.rs')
t+='''

impl<N: startup::Network + Send + 'static> Backend<N> {
    pub(super) fn recording_scratch(&mut self, bytes:u32)->Result<u32,&'static str>{
        let mut bank=self.shared.bank.lock().map_err(|_|"recording bank poisoned")?;
        let p=bank.next_scratch;
        let next=p.checked_add(bytes).and_then(|n|n.checked_add(63)).map(|n|n&!63).ok_or("recording scratch exhausted")?;
        bank.memory.reserve_at(p,bytes).map_err(|_|"recording scratch unavailable")?;
        bank.next_scratch=next;Ok(p)
    }
}
impl<N: startup::Network + Send + 'static> crate::audio_replay_path_registry::Boundary for Backend<N> {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{
        self.shared.bank.lock().unwrap().memory.read_byte(p).map_err(|_|read::Error::MissingWord(p))
    }
}
impl<N: startup::Network + Send + 'static> resource::Preparation for Backend<N> {
    fn register_path(&mut self,path:u32)->Result<(),&'static str>{
        let p=crate::audio_replay_path_registry::initialize(self).map_err(|e|self.failure(e,"path singleton initialization failed"))?;
        crate::audio_replay_path_registry::register_path(self,p,path).map(|_|()).map_err(|e|self.failure(e,"path registration failed"))
    }
}
#[derive(Debug,Clone,PartialEq,Eq,serde::Serialize)]
pub struct RecordingStreamProbe {
    pub open_code:u32,
    pub start_code:u32,
    pub state_after_start:u32,
    pub state_after_stop:u32,
    pub resource_enabled:u8,
    pub resource_references:u32,
    pub registry_initialized:bool,
    pub files_opened:u32,
    pub files_closed:u32,
    pub writes:u32,
    pub remaining_files:usize,
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Exercise native8FB650 through the source no-op stream implementation and
    /// a real Windows worker. Diagnostic text only; no replay frames or host.
    /// The launch lock covers the complete lifetime and raw callback retirement.
    pub fn probe_recording_stream(&self,path:Option<&[u8]>,messages:&[&[u8]])->Result<RecordingStreamProbe,String>{
        use crate::{audio_replay_stream as stream,audio_replay_stream_running as running};
        let closed=self.shared.launch.lock().map_err(|_|"launch lock poisoned")?;
        if *closed {return Err("transport runtime is shut down".into());}
        if self.shared.diagnostics.is_some() || self.shared.active.load(Ordering::Acquire)!=0 || self.shared.stream.lock().unwrap().is_some() || self.shared.configuration.lock().unwrap().is_some() || !self.shared.bank.lock().unwrap().owned.is_empty(){
            return Err("recorded stream probe requires an idle owned runtime".into());
        }
        let mut b=Backend::new(self.shared.clone());
        if b.word(logger::POINTER).map_err(|e|format!("logger pointer: {e:?}"))?!=0 {return Err("recorded stream requires an unused logger lifetime".into());}
        let path_storage=if let Some(bytes)=path {
            let size=u32::try_from(bytes.len()).ok().and_then(|n|n.checked_add(1)).ok_or("recording path too long")?;
            let p=b.recording_scratch(size).map_err(str::to_string)?;
            for (i,v) in bytes.iter().chain(std::iter::once(&0)).enumerate(){Storage::write_byte(&mut b,p+i as u32,*v).map_err(|e|format!("path storage: {e:?}"))?;}
            p
        }else{0};
        let work=(||->Result<RecordingStreamProbe,String>{
            let open_code=self.open_stream_owned(StreamOpenRequest {mode:1,configuration:StreamConfigurationRequest{
                transport:ConfigurationRequest{callback:None,arguments:[0,0],host:None,port:0,sockaddr_frame:[0;16]},key:[0;16],flag:0,extra:0,
            }},path_storage,1)?;
            if open_code!=0{return Err(format!("unexpected no-op opening code {open_code}"));}
            let p=self.shared.stream.lock().unwrap().as_ref().ok_or("missing recorded stream")?.pointer;
            let start_code=running::start(&mut b,p,[0;6]).map_err(|e|format!("recorded stream start: {e:?}"))?;
            if start_code!=0{return Err(format!("unexpected no-op start code {start_code}"));}
            let node=b.word(p+0x44).map_err(|e|format!("started state: {e:?}"))?;
            let state_after_start=b.word(node+12).map_err(|e|format!("started state ID: {e:?}"))?;
            let resource=b.word(p+0x30).map_err(|e|format!("file resource: {e:?}"))?;
            let control=b.word(p+0x34).map_err(|e|format!("file control: {e:?}"))?;
            let resource_references=b.word(control+4).map_err(|e|format!("file references: {e:?}"))?;
            let resource_enabled=logger::Boundary::byte(&mut b,resource+36).map_err(str::to_string)?;
            let owner=b.word(logger::POINTER).map_err(|e|format!("logger pointer: {e:?}"))?;
            for message in messages {
                b.lock(owner,true).map_err(str::to_string)?;
                let result=logger::write_message(&mut b,owner,message,None,0);
                let unlock=b.lock(owner,false);
                result.map_err(|e|format!("recorded stream log: {e:?}"))?;unlock.map_err(str::to_string)?;
            }
            stream::stop(&mut b,p).map_err(|e|format!("recorded stream stop: {e:?}"))?;
            let node=b.word(p+0x44).map_err(|e|format!("stopped state: {e:?}"))?;
            let state_after_stop=b.word(node+12).map_err(|e|format!("stopped state ID: {e:?}"))?;
            let registry_initialized=b.word(crate::audio_replay_path_registry::FLAG).map_err(|e|format!("path flag: {e:?}"))?&1!=0;
            Ok(RecordingStreamProbe{open_code,start_code,state_after_start,state_after_stop,resource_enabled,resource_references,registry_initialized,files_opened:0,files_closed:0,writes:0,remaining_files:0})
        })();
        let cleanup=(||->Result<(),String>{
            self.close_stream_owned(&mut b)?;
            // No transport reference exists in this source no-op implementation.
            // Freeing the stream leaves raw logger owners; retire the chain now.
            if b.word(logger::POINTER).map_err(|e|format!("recorded logger: {e:?}"))?!=0 {
                logger::shutdown(&mut b).map_err(|e|format!("recorded logger shutdown: {e:?}"))?;
            }
            if path_storage!=0{self.shared.bank.lock().unwrap().memory.release(path_storage).map_err(|e|format!("recorded path cleanup: {e:?}"))?;}
            Ok(())
        })();
        match (work,cleanup) {
            (Ok(mut report),Ok(()))=>{let f=self.shared.files.lock().unwrap();report.files_opened=f.opens;report.files_closed=f.closes;report.writes=f.writes;report.remaining_files=f.live.len();Ok(report)},
            (work,cleanup)=>Err(format!("recorded stream: {work:?}; cleanup: {cleanup:?}")),
        }
    }
}
'''
save('audio_replay_windows_recording.rs',t)
t=read('audio_replay_runtime_image.rs').replace('; 21]','; 24]')
t=t.replace('    (1, 0x10d5f64, 12),','    (1, 0x10d5f64, 12),\n    (1, 0x1085f8c, 12),\n    (1, 0x2d8bab4, 4),\n    (1, 0x2d8bac0, 0x10a8),')
save('audio_replay_runtime_image.rs',t)
t=(r/'tools/extract_replay_runtime_image.py').read_text(encoding='utf-8')
t=t.replace(" ('logger_composite_callback_vtable',1,0x10d5f64,12),"," ('logger_composite_callback_vtable',1,0x10d5f64,12),\n ('recording_control_vtable',1,0x1085f8c,12),\n ('diagnostic_path_singleton_flag',1,0x2d8bab4,4),\n ('diagnostic_path_singleton_storage',1,0x2d8bac0,0x10a8),")
(s/'extract_replay_runtime_image.py').write_text(t,encoding='utf-8')
t=read('lib.rs');t+='\npub mod audio_replay_path_registry;\n';save('lib.rs',t)
print('Staged Windows stream recording composition and three original image regions')
