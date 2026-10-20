//! Bounded local diagnostics from ordinary child stdout/stderr, never raw logs.
//! Only fixed diagnostic codes survive; stdin, arguments, environment, arbitrary
//! messages, paths and capability bytes are never written. This proves neither
//! device audibility nor successful admission of an individual audio event.
use std::{fs::{self,File,OpenOptions}, io::{self,Read,Write}, path::{Path,PathBuf},
    process::{Child,ChildStderr,ChildStdout,Command,ExitStatus,Stdio},
    sync::{Arc,Mutex,atomic::{AtomicBool,AtomicU32,AtomicU64,Ordering},
        mpsc::{self,Receiver,SyncSender,TrySendError}}, thread::{self,JoinHandle}, time::{Duration,Instant}};

const MAX_SLOTS:usize=64;
const MAX_FILE_BYTES:usize=64*1024;
const FOOTER_RESERVE:usize=2048;
const MAX_LINE:usize=2048;
const QUEUE_RECORDS:usize=128;
const CHUNK:usize=4096;
static RETIRED:Mutex<Vec<JoinHandle<()>>>=Mutex::new(Vec::new());

#[derive(Clone,Copy)]
pub(super) enum Role { Client,Server }
impl Role { fn name(self)->&'static str {match self {Self::Client=>"client",Self::Server=>"server"}} }
#[derive(Clone,Copy)]
enum Stream { Out,Err }
impl Stream { fn index(self)->usize {match self {Self::Out=>0,Self::Err=>1}} }
#[derive(Default)]
struct Counts { bytes:AtomicU64,lines:AtomicU64,unknown:AtomicU64,oversized:AtomicU64,
    queue_dropped:AtomicU64,read_error:AtomicBool,ended:AtomicBool }
fn add(n:&AtomicU64,value:u64) {let _=n.fetch_update(Ordering::Relaxed,Ordering::Relaxed,|v|Some(v.saturating_add(value)));}
impl Counts {
    fn value(&self)->serde_json::Value {serde_json::json!({
        "bytes_drained":self.bytes.load(Ordering::Relaxed),"lines":self.lines.load(Ordering::Relaxed),
        "unclassified":self.unknown.load(Ordering::Relaxed),"oversized":self.oversized.load(Ordering::Relaxed),
        "queue_dropped":self.queue_dropped.load(Ordering::Relaxed),
        "read_error":self.read_error.load(Ordering::Relaxed),"reader_ended":self.ended.load(Ordering::Relaxed)})}
}
struct Shared { pid:AtomicU32,exited:AtomicBool,counts:[Counts;2],
    file_error:[AtomicBool;2],quota:[AtomicBool;2],writer_ended:AtomicBool,start:Instant }
impl Shared {
    fn new()->Self {Self {pid:AtomicU32::new(0),exited:AtomicBool::new(false),counts:Default::default(),
        file_error:Default::default(),quota:Default::default(),writer_ended:AtomicBool::new(false),start:Instant::now()}}
}
struct Record { stream:Stream,millis:u64,code:&'static str }
fn code(line:&[u8])->Option<&'static str> {
    // Input is untrusted. Even a forged matching line only yields this fixed code.
    // No substring from the input, hash of a secret, or arbitrary suffix is saved.
    const CODES:&[(&[u8],&str)]=&[
        (b"[OL_R_CAST_DIAG:v1:context_rejected]","r_cast_diag_context_rejected"),
        (b"[OL_R_CAST_DIAG:v1:delivery_revoked]","r_cast_diag_delivery_revoked"),
        (b"[OL_R_CAST_DIAG:v1:clock_rejected]","r_cast_diag_clock_rejected"),
        (b"[OL_R_CAST_DIAG:v1:projection_rejected]","r_cast_diag_projection_rejected"),
        (b"[OL_R_CAST_DIAG:v1:event_admitted]","r_cast_diag_event_admitted"),
        (b"[OL_R_CAST_DIAG:v1:event_baseline]","r_cast_diag_event_baseline"),
        (b"[OL_R_CAST_DIAG:v1:event_previously_hidden]","r_cast_diag_event_previously_hidden"),
        (b"[OL_R_CAST_DIAG:v1:event_not_ready]","r_cast_diag_event_not_ready"),
        (b"[OL_R_CAST_DIAG:v1:event_paused]","r_cast_diag_event_paused"),
        (b"[OL_R_CAST_DIAG:v1:event_finished]","r_cast_diag_event_finished"),
        (b"[OL_R_CAST_DIAG:v1:event_stale]","r_cast_diag_event_stale"),
        (b"[OL_R_CAST_DIAG:v1:event_backdated]","r_cast_diag_event_backdated"),
        (b"[OL_R_CAST_DIAG:v1:event_capacity]","r_cast_diag_event_capacity"),
        (b"[OL_R_CAST_DIAG:v1:pending_revoked]","r_cast_diag_pending_revoked"),
        (b"[OL_R_CAST_DIAG:v1:pending_expired]","r_cast_diag_pending_expired"),
        (b"[OL_R_CAST_DIAG:v1:request_not_ready]","r_cast_diag_request_not_ready"),
        (b"[OL_R_CAST_DIAG:v1:request_paused]","r_cast_diag_request_paused"),
        (b"[OL_R_CAST_DIAG:v1:request_channel]","r_cast_diag_request_channel"),
        (b"[OL_R_CAST_DIAG:v1:request_snapshot]","r_cast_diag_request_snapshot"),
        (b"[OL_R_CAST_DIAG:v1:request_capacity]","r_cast_diag_request_capacity"),
        (b"[OL_R_CAST_DIAG:v1:request_owner_hidden]","r_cast_diag_request_owner_hidden"),
        (b"[OL_R_CAST_DIAG:v1:request_owner_missing]","r_cast_diag_request_owner_missing"),
        (b"[OL_R_CAST_DIAG:v1:request_asset_missing]","r_cast_diag_request_asset_missing"),
        (b"[OL_R_CAST_DIAG:v1:gain_zero]","r_cast_diag_gain_zero"),
        (b"[OL_R_CAST_DIAG:v1:gain_invalid]","r_cast_diag_gain_invalid"),
        (b"[OL_R_CAST_DIAG:v1:spawn_queued]","r_cast_diag_spawn_queued"),
        (b"[OL_R_CAST_DIAG:v1:first_sink_within_100ms]","r_cast_diag_first_sink_within_100ms"),
        (b"[OL_R_CAST_DIAG:v1:first_sink_after_100ms]","r_cast_diag_first_sink_after_100ms"),
        (b"[OL_R_CAST_DIAG:v1:first_sink_clock_invalid]","r_cast_diag_first_sink_clock_invalid"),
        (b"[OL_R_CAST_DIAG:v1:retire_not_ready]","r_cast_diag_retire_not_ready"),
        (b"[OL_R_CAST_DIAG:v1:retire_paused]","r_cast_diag_retire_paused"),
        (b"[OL_R_CAST_DIAG:v1:retire_channel]","r_cast_diag_retire_channel"),
        (b"[OL_R_CAST_DIAG:v1:retire_snapshot]","r_cast_diag_retire_snapshot"),
        (b"[OL_R_CAST_DIAG:v1:retire_context]","r_cast_diag_retire_context"),
        (b"[OL_R_CAST_DIAG:v1:retire_authorization]","r_cast_diag_retire_authorization"),
        (b"[OL_R_CAST_DIAG:v1:retire_owner_hidden]","r_cast_diag_retire_owner_hidden"),
        (b"[OL_R_CAST_DIAG:v1:retire_owner_changed]","r_cast_diag_retire_owner_changed"),
        (b"[OL_R_CAST_DIAG:v1:retire_gain_zero]","r_cast_diag_retire_gain_zero"),
        (b"[OL_R_CAST_DIAG:v1:retire_gain_invalid]","r_cast_diag_retire_gain_invalid"),
        (b"[OL_R_CAST_DIAG:v1:retire_clock_or_duration]","r_cast_diag_retire_clock_or_duration"),
        (b"[OL_R_CAST_DIAG:v1:retire_hard_limit]","r_cast_diag_retire_hard_limit"),
        (b"[OL_R_CAST_DIAG:v1:retire_sink_lost]","r_cast_diag_retire_sink_lost"),
        (b"[OL_R_CAST_DIAG:v1:retire_sink_empty]","r_cast_diag_retire_sink_empty"),
        (b"[OL_R_CAST_DIAG:v1:retire_initial_sink_timeout]","r_cast_diag_retire_initial_sink_timeout"),
        (b"[OL_R_CAST_DIAG:v1:retire_first_sink_late]","r_cast_diag_retire_first_sink_late"),
        (b"[OL_R_CAST_DIAG:v1:retire_active_watchdog]","r_cast_diag_retire_active_watchdog"),
        (b"[OL_R_CAST_DIAG:v1:budget_exhausted]","r_cast_diag_budget_exhausted"),
        (b"No audio device found.","audio_output_unavailable"),
        (b"Error playing audio:","audio_playback_error"),
        (b"Optional Ezreal R OnCast audio unavailable:","r_cast_asset_unavailable"),
        (b"Optional Ezreal R OnCast audio ignored:","r_cast_projection_rejected"),
        (b"Optional Ezreal R hit audio unavailable:","r_hit_asset_unavailable"),
        (b"Optional Ezreal R hit audio ignored:","r_hit_projection_rejected"),
        (b"Optional Ezreal Q hit audio unavailable:","q_hit_asset_unavailable"),
        (b"Optional Ezreal Q hit audio ignored:","q_hit_projection_rejected"),
        (b"Native effect clock stopped:","effect_clock_failed"),
        (b"Canonical process clock failed:","process_clock_failed"),
        (b"Presentation snapshot rejected:","presentation_snapshot_rejected"),
        (b"Entity facing snapshot rejected:","facing_snapshot_rejected"),
        (b"Session bootstrap failed:","session_bootstrap_failed"),
        (b"Local session transport failed:","session_transport_failed"),
        (b"OpenLeague server on ","server_started"),
        (b"Native ZIP archives=", "client_resources_mounted"),
        (b"panicked at", "process_panic"),
        (b"Failed to load asset", "asset_load_failed"),
        (b"failed to load asset", "asset_load_failed"),
    ];
    CODES.iter().find_map(|(needle,name)|line.windows(needle.len()).any(|w|w==*needle).then_some(*name))
}
#[derive(Default)]
struct Framer { line:Vec<u8>,overflow:bool }
impl Framer {
    fn finish(&mut self,counts:&Counts,mut emit:impl FnMut(&'static str)) {
        add(&counts.lines,1);
        if self.overflow {add(&counts.oversized,1);}
        else if let Some(value)=code(&self.line) {emit(value);}
        else {add(&counts.unknown,1);}
        self.line.clear();self.overflow=false;
    }
    fn feed(&mut self,bytes:&[u8],counts:&Counts,mut emit:impl FnMut(&'static str)) {
        add(&counts.bytes,bytes.len() as u64);
        for &byte in bytes {
            if byte==b'\n' {self.finish(counts,&mut emit);}
            else if !self.overflow {
                if self.line.len()==MAX_LINE {self.line.clear();self.overflow=true;}
                else {self.line.push(byte);}
            }
        }
    }
    fn eof(&mut self,counts:&Counts,emit:impl FnMut(&'static str)) {
        if !self.line.is_empty() || self.overflow {self.finish(counts,emit);}
    }
}
struct Capped<W> { writer:W,written:usize,quota:bool,failed:bool }
impl<W:Write> Capped<W> {
    fn new(writer:W)->Self {Self {writer,written:0,quota:false,failed:false}}
    fn write(&mut self,value:&serde_json::Value,footer:bool) {
        if self.failed {return;}
        let Ok(mut bytes)=serde_json::to_vec(value) else {self.failed=true;return;};bytes.push(b'\n');
        let limit=if footer {MAX_FILE_BYTES}else{MAX_FILE_BYTES-FOOTER_RESERVE};
        if bytes.len()>limit.saturating_sub(self.written) {self.quota=true;return;}
        // A partial write is still bounded by this reservation. No retry loop on
        // disk failure; pipe readers never wait on this file or this thread.
        self.written+=bytes.len();
        if self.writer.write_all(&bytes).is_err() {self.failed=true;}
    }
}

fn reparse(metadata:&fs::Metadata)->bool {
    #[cfg(windows)] {use std::os::windows::fs::MetadataExt;metadata.file_attributes()&0x400!=0}
    #[cfg(not(windows))] {metadata.file_type().is_symlink()}
}
fn checked_dir(path:&Path)->io::Result<()> {
    let m=fs::symlink_metadata(path)?;
    if !m.is_dir() || reparse(&m) {return Err(io::Error::other("diagnostic directory rejected"));}Ok(())
}
#[cfg(windows)]
fn lock_dir(path:&Path)->io::Result<File> {
    use std::os::windows::fs::OpenOptionsExt;
    checked_dir(path)?;
    // Keep ancestors pinned against replacement/reparse edits while files exist.
    // These handles are not inherited by the child and authorize no deletion.
    let f=OpenOptions::new().read(true).access_mode(0x80).share_mode(1)
        .custom_flags(0x02000000|0x00200000).open(path)?;
    let m=f.metadata()?;if !m.is_dir() || reparse(&m) {return Err(io::Error::other("diagnostic directory handle rejected"));}Ok(f)
}
#[cfg(not(windows))]
fn lock_dir(path:&Path)->io::Result<File> {checked_dir(path)?;File::open(path)}
struct Files { slot:usize,files:[File;2],_locks:Vec<File> }
fn reserve(root:&Path)->io::Result<Files> {
    checked_dir(root)?;let mut path=root.canonicalize()?;let mut locks=vec![lock_dir(&path)?];
    for name in ["runtime","diagnostics","child-output"] {
        path.push(name);
        match fs::create_dir(&path) {Ok(())=>{},Err(e) if e.kind()==io::ErrorKind::AlreadyExists=>{},Err(e)=>return Err(e)}
        locks.push(lock_dir(&path)?);
    }
    for slot in 0..MAX_SLOTS {
        let dir=path.join(format!("slot-{slot:02}"));
        match fs::create_dir(&dir) {Ok(())=>{},Err(e) if e.kind()==io::ErrorKind::AlreadyExists=>continue,Err(e)=>return Err(e)}
        locks.push(lock_dir(&dir)?);
        let create=|name:&str|->io::Result<File> {
            let mut options=OpenOptions::new();options.write(true).create_new(true);
            #[cfg(windows)] {use std::os::windows::fs::OpenOptionsExt;options.share_mode(1).custom_flags(0x00200000);}
            let file=options.open(dir.join(name))?;
            let m=file.metadata()?;if !m.is_file() || reparse(&m) {return Err(io::Error::other("diagnostic file rejected"));}Ok(file)
        };
        return Ok(Files {slot,files:[create("stdout.jsonl")?,create("stderr.jsonl")?],_locks:locks});
    }
    Err(io::Error::other("diagnostic slot limit reached"))
}
enum Pipe { Out(ChildStdout),Err(ChildStderr) }
impl Read for Pipe {
    fn read(&mut self,b:&mut [u8])->io::Result<usize> {match self {Self::Out(p)=>p.read(b),Self::Err(p)=>p.read(b)}}
}
#[cfg(windows)]
fn available(pipe:&Pipe)->io::Result<Option<usize>> {
    use std::os::windows::io::AsRawHandle;
    #[link(name="kernel32")]
    extern "system" {fn PeekNamedPipe(h:*mut std::ffi::c_void,b:*mut std::ffi::c_void,n:u32,
        read:*mut u32,available:*mut u32,left:*mut u32)->i32;}
    let h=match pipe {Pipe::Out(p)=>p.as_raw_handle(),Pipe::Err(p)=>p.as_raw_handle()};
    let mut count=0;
    if unsafe {PeekNamedPipe(h,std::ptr::null_mut(),0,std::ptr::null_mut(),&mut count,std::ptr::null_mut())}==0 {
        let e=io::Error::last_os_error();if matches!(e.raw_os_error(),Some(109)|Some(232)) {return Ok(None);}return Err(e);
    }
    Ok(Some(count as usize))
}
fn send_record(sender:&SyncSender<Record>,shared:&Shared,stream:Stream,value:&'static str) {
    let record=Record {stream,millis:shared.start.elapsed().as_millis().min(u128::from(u64::MAX)) as u64,code:value};
    if let Err(TrySendError::Full(_)|TrySendError::Disconnected(_))=sender.try_send(record) {
        add(&shared.counts[stream.index()].queue_dropped,1);
    }
}
fn drain(input:Receiver<Pipe>,sender:SyncSender<Record>,shared:Arc<Shared>,stream:Stream) {
    let counts=&shared.counts[stream.index()];let mut framer=Framer::default();
    if let Ok(mut pipe)=input.recv() {
        let mut bytes=[0;CHUNK];let mut exit_at=None;
        loop {
            if shared.exited.load(Ordering::Acquire) {
                let end=exit_at.get_or_insert_with(Instant::now);
                if end.elapsed()>=Duration::from_millis(100) {break;}
            }
            #[cfg(windows)]
            let count=match available(&pipe) {
                Ok(None)=>break,Ok(Some(0))=>{
                    if exit_at.is_some() {break;}thread::sleep(Duration::from_millis(5));continue;
                },Ok(Some(n))=>n.min(CHUNK),Err(_)=>{counts.read_error.store(true,Ordering::Release);break;}
            };
            #[cfg(not(windows))]
            let count=CHUNK;
            match pipe.read(&mut bytes[..count]) {
                Ok(0)=>break,Ok(n)=>framer.feed(&bytes[..n],counts,|c|send_record(&sender,&shared,stream,c)),
                Err(e) if e.kind()==io::ErrorKind::Interrupted=>continue,
                Err(_)=>{counts.read_error.store(true,Ordering::Release);break;}
            }
        }
    }
    framer.eof(counts,|c|send_record(&sender,&shared,stream,c));
    counts.ended.store(true,Ordering::Release);
}
fn writer(files:Files,input:Receiver<Record>,shared:Arc<Shared>,role:Role,generation:u64) {
    let Files {slot,files,_locks}=files;let [out,err]=files;
    let mut files=[Capped::new(out),Capped::new(err)];
    let prepared_unix_ms=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).ok()
        .map(|d|d.as_millis().min(u128::from(u64::MAX)) as u64);
    for (i,file) in files.iter_mut().enumerate() {file.write(&serde_json::json!({"schema":"OpenLeague_child_diagnostics/v1",
        "role":role.name(),"generation":generation,"slot":slot,"stream":if i==0 {"stdout"}else{"stderr"},
        "prepared_unix_ms":prepared_unix_ms,"filtered_fixed_codes_only":true,"max_file_bytes":MAX_FILE_BYTES}),false);}
    for record in input {
        let i=record.stream.index();files[i].write(&serde_json::json!({"elapsed_ms":record.millis,
            "pid":shared.pid.load(Ordering::Acquire),"code":record.code}),false);
        shared.file_error[i].store(files[i].failed,Ordering::Release);shared.quota[i].store(files[i].quota,Ordering::Release);
    }
    for (i,file) in files.iter_mut().enumerate() {
        file.write(&serde_json::json!({"code":"stream_finished","pid":shared.pid.load(Ordering::Acquire),
            "counts":shared.counts[i].value(),"quota_reached":file.quota,"file_error":file.failed}),true);
        shared.file_error[i].store(file.failed,Ordering::Release);shared.quota[i].store(file.quota,Ordering::Release);
    }
    shared.writer_ended.store(true,Ordering::Release);
    // _locks stay alive until both create-only files have finished writing.
}
pub(super) fn reap_finished() {
    let mut handles=RETIRED.lock().unwrap_or_else(|p|p.into_inner());let mut i=0;
    while i<handles.len() {if handles[i].is_finished() {let h=handles.swap_remove(i);let _=h.join();}else{i+=1;}}
}
struct Workers { handles:Vec<JoinHandle<()>> }
impl Drop for Workers {
    fn drop(&mut self) {
        // No blocking join in process ownership/drop. The existing supervisor
        // polls this bounded registry; a stalled disk writer cannot stall a child.
        let mut retired=RETIRED.lock().unwrap_or_else(|p|p.into_inner());retired.append(&mut self.handles);
    }
}
struct Prepared { senders:[SyncSender<Pipe>;2],shared:Arc<Shared>,workers:Workers,slot:usize }
impl Prepared {
    fn new(root:&Path,role:Role,generation:u64)->io::Result<Self> {
        reap_finished();let files=reserve(root)?;let slot=files.slot;let shared=Arc::new(Shared::new());
        let (events,receive)=mpsc::sync_channel(QUEUE_RECORDS);let mut workers=Workers{handles:Vec::new()};
        let state=shared.clone();workers.handles.push(thread::Builder::new().name("child-log-writer".into()).spawn(move||writer(files,receive,state,role,generation))?);
        let (out_sender,out)=mpsc::sync_channel(1);let (err_sender,err)=mpsc::sync_channel(1);
        for (stream,input) in [(Stream::Out,out),(Stream::Err,err)] {
            let sender=events.clone();let state=shared.clone();
            workers.handles.push(thread::Builder::new().name("child-log-reader".into()).spawn(move||drain(input,sender,state,stream))?);
        }
        drop(events);Ok(Self {senders:[out_sender,err_sender],shared,workers,slot})
    }
}
struct Capture { shared:Arc<Shared>,_workers:Workers,slot:usize }
pub(super) struct LoggedChild { child:Child,capture:Option<Capture> }
impl std::ops::Deref for LoggedChild {type Target=Child;fn deref(&self)->&Child {&self.child}}
impl std::ops::DerefMut for LoggedChild {fn deref_mut(&mut self)->&mut Child {&mut self.child}}
impl LoggedChild {
    pub(super) fn spawn(command:&mut Command,root:&Path,role:Role,generation:u64)->io::Result<Self> {
        // Failure of optional diagnostics keeps the former inherited-output
        // policy and never blocks gameplay/bootstrap. Every thread exists BEFORE
        // requesting pipes from spawn; no live child can wait on thread creation.
        let prepared=Prepared::new(root,role,generation).ok();
        if prepared.is_some() {command.stdout(Stdio::piped()).stderr(Stdio::piped());}
        let child=command.spawn()?;let mut owned=Self {child,capture:None};
        if let Some(p)=prepared {
            p.shared.pid.store(owned.child.id(),Ordering::Release);
            if let Some(out)=owned.child.stdout.take() {let _=p.senders[0].try_send(Pipe::Out(out));}
            if let Some(err)=owned.child.stderr.take() {let _=p.senders[1].try_send(Pipe::Err(err));}
            owned.capture=Some(Capture {shared:p.shared,_workers:p.workers,slot:p.slot});
        }
        Ok(owned)
    }
    pub(super) fn observe(&mut self)->io::Result<Option<ExitStatus>> {
        let exit=self.child.try_wait()?;
        if exit.is_some() {if let Some(c)=&self.capture {c.shared.exited.store(true,Ordering::Release);}}
        reap_finished();Ok(exit)
    }
    pub(super) fn diagnostics(&self)->serde_json::Value {
        match &self.capture {
            None=>serde_json::json!({"enabled":false,"code":"diagnostic_setup_unavailable"}),
            Some(c)=>serde_json::json!({"enabled":true,"slot":c.slot,"directory":"runtime/diagnostics/child-output",
                "pid":self.child.id(),"filtered_fixed_codes_only":true,
                "stdout":c.shared.counts[0].value(),"stderr":c.shared.counts[1].value(),
                "file_error":[c.shared.file_error[0].load(Ordering::Acquire),c.shared.file_error[1].load(Ordering::Acquire)],
                "quota_reached":[c.shared.quota[0].load(Ordering::Acquire),c.shared.quota[1].load(Ordering::Acquire)],
                "writer_ended":c.shared.writer_ended.load(Ordering::Acquire)}),
        }
    }
}

#[cfg(test)]
#[path="sessions_output_tests.rs"]
mod tests;
