from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def edit(name,replacements):
 text=(r/name).read_text(encoding='utf-8')
 for before,after in replacements:
  assert text.count(before)==1,(name,before[:80],text.count(before));text=text.replace(before,after)
 (s/Path(name).name).write_text(text,encoding='utf-8')
edit('crates/core/src/audio_replay_transport_thread.rs',[
 ('fn replace_thread(b: &mut impl Boundary, thread: u32) -> Result<(), Error> {','pub fn replace_thread_at<B: Storage + ControlBoundary>(b: &mut B, destination: u32, thread: u32) -> Result<(), Error> {'),
 ('put(b, add(control, offset)?, value)?;', 'Storage::write_word(b, add(control, offset)?, value)?;'),
 ('let old = b.word(PAIR + 4)?;\n    put(b, PAIR + 4, control)?; put(b, PAIR, thread)?;', 'let old = b.word(add(destination, 4)?)?;\n    Storage::write_word(b, add(destination, 4)?, control)?; Storage::write_word(b, destination, thread)?;'),
 ('replace_thread(b, thread)?;', 'replace_thread_at(b, PAIR, thread)?;')])
edit('crates/core/src/audio_replay_windows_transport.rs',[
 ('        if (f, a) != (0x8fc100, 0) {', '''        if f == crate::audio_replay_stream_running::WORKER {
            return crate::audio_replay_stream_running::worker(self, a)
                .map_err(|e| self.failure(e, "stream worker failed"));
        }
        if (f, a) != (0x8fc100, 0) {'''),
 ('''        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("transport worker still owns runtime state after drain".into());
        }
        self.close_stream_owned(&mut b)?;''','''        self.close_stream_owned(&mut b)?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("transport worker still owns runtime state after drain".into());
        }''')])
edit('crates/core/src/audio_replay_windows_opening.rs',[
 ('audio_replay_manager_control as managers, audio_replay_object_commands as packets,','audio_replay_stream_running as running, audio_replay_object_commands as packets,'),
 ('    pub fn close_stream(&self) -> Result<(), String> {','''    /// Source no-op implementation start is available. Active ENet creation and
    /// connection must be supplied before starting the derived implementation.
    pub fn start_stream(&self, args: [u32; 6]) -> Result<u32, String> {
        let closed = self.shared.launch.lock().map_err(|_| "launch lock poisoned")?;
        if *closed { return Err("transport runtime is shut down".into()); }
        let owner = self.shared.stream.lock().map_err(|_| "stream owner poisoned")?;
        let p = owner.as_ref().ok_or("no open stream")?.pointer;
        let mut b = Backend::new(self.shared.clone());
        if !running::has_state(&mut b,p,3).map_err(|e|format!("stream state: {e:?}"))? { return Ok(8); }
        let object=b.word(p+0x64).map_err(|e|format!("stream implementation: {e:?}"))?;
        if b.word(object).map_err(|e|format!("implementation vtable: {e:?}"))? != opening::NULL_VTABLE {
            return Err("native active replay host creation/connection is not connected".into());
        }
        running::start(&mut b,p,args).map_err(|e|format!("stream start: {e:?}"))
    }
    pub fn stop_stream(&self) -> Result<(), String> {
        let closed = self.shared.launch.lock().map_err(|_| "launch lock poisoned")?;
        if *closed { return Ok(()); }
        let owner = self.shared.stream.lock().map_err(|_| "stream owner poisoned")?;
        if let Some(r)=owner.as_ref() {
            let mut b=Backend::new(self.shared.clone());
            stream::stop(&mut b,r.pointer).map_err(|e|format!("stream stop: {e:?}"))?;
        }
        if self.shared.active.load(Ordering::Acquire)!=0 { return Err("stream worker did not retire after stop".into()); }
        Ok(())
    }
    pub fn close_stream(&self) -> Result<(), String> {'''),
 ('''        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream cleanup requires retired workers".into());
        }
''',''),
 ('''        stream::scalar_delete(b, record.pointer, 1)''','''        stream::stop(b, record.pointer).map_err(|e| format!("stream stop before destruction: {e:?}"))?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream cleanup requires retired workers".into());
        }
        stream::scalar_delete(b, record.pointer, 1)'''),
 ('impl<N: startup::Network + Send + \'static> stream::Boundary for Backend<N> {}','''impl<N: startup::Network + Send + 'static> stream::Boundary for Backend<N> {
    fn join_worker(&mut self, worker:u32, timeout:u32)->Result<(),&'static str> {
        //8FB620 ignores8A8C50's numeric return. The owning API separately guards
        //against freeing storage still used by a worker after a failed/timed wait.
        thread::join(self,worker,timeout).map(|_|()).map_err(|e|self.failure(e,"stream worker join failed"))
    }
    fn stop_implementation(&mut self, object:u32, method:u32)->Result<(),&'static str> {
        match method {
            0x5642d0=>Ok(()),
            0x901c44=>derived::close(self,object.checked_sub(0xe0).ok_or("invalid stream interface")?)
                .map_err(|e|self.failure(e,"derived stream stop failed")),
            _=>Err("unknown stream stop method"),
        }
    }
}
impl<N: startup::Network + Send + 'static> running::Boundary for Backend<N> {
    fn launch_stream_worker(&mut self, launch:&thread::Launch)->Result<u32,&'static str>{thread::Boundary::create_worker(self,launch)}
    fn sleep(&mut self, milliseconds:u32)->Result<(),&'static str>{
        std::thread::sleep(std::time::Duration::from_millis(milliseconds.into()));Ok(())
    }
}''')])
edit('crates/core/src/lib.rs',[('pub mod audio_replay_stream;', 'pub mod audio_replay_stream;\npub mod audio_replay_stream_running;')])
edit('crates/core/src/audio_replay_runtime_image.rs',[('(1, 0x10d5f34, 4),','(1, 0x10d5f34, 32),')])
edit('tools/extract_replay_runtime_image.py',[("('stream_object_vtable',1,0x10d5f34,4)","('stream_object_vtable',1,0x10d5f34,32)")])
print('Prepared source stream start/worker and Windows ownership adapters')
