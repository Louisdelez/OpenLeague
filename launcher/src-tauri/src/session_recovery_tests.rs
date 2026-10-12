//! Controlled process/pipe results. These do not launch a real game or attest
//! OS secrecy; the real crash/socket/restart qualification remains required.
use super::*;
use std::{collections::VecDeque,sync::atomic::{AtomicUsize,Ordering}};
struct Fake {id:u32,answers:VecDeque<io::Result<Option<Exit>>>}
impl Process for Fake{fn id(&self)->u32{self.id}fn observe(&mut self)->io::Result<Option<Exit>>{self.answers.pop_front().unwrap_or(Ok(None))}}
struct Pipe(Arc<AtomicUsize>);
impl Drop for Pipe{fn drop(&mut self){self.0.fetch_add(1,Ordering::SeqCst);}}
fn done(code:i32)->io::Result<Option<Exit>>{Ok(Some(Exit{code:Some(code),success:code==0}))}
fn launch()->LaunchSpec{LaunchSpec{root:PathBuf::from("controlled-root"),champion:"garen".into(),summoners:"[null,null]".into(),key:[213;32],initial_nonce:[17;16]}}
fn run(client:Vec<io::Result<Option<Exit>>>,server:Vec<io::Result<Option<Exit>>>)->(Run<Fake,Pipe>,Arc<AtomicUsize>){
 let drops=Arc::new(AtomicUsize::new(0));
 (Run{generation:7,server:Owned{process:Fake{id:11,answers:server.into()},exit:None,observed_live:false,observation_error:None},
  client:Some(Owned{process:Fake{id:22,answers:client.into()},exit:None,observed_live:false,observation_error:None}),server_stdin:Some(Pipe(drops.clone())),
  drain_requested:false,early_server_reported:false,launch:Some(launch()),retired_clients:vec![],errors:vec![],launch_error:None,supervisor_interrupted:false},drops)
}
#[test] fn failed_client_keeps_only_its_owned_server_and_credential_until_explicit_abandon(){
 let(mut r,drops)=run(vec![done(7)],vec![Ok(None),Ok(None),done(0)]);
 r.observe();assert!(r.can_resume());assert!(r.can_abandon());assert!(!r.retired());assert_eq!(drops.load(Ordering::SeqCst),0);
 let status=r.status();assert_eq!(status["can_play"],false);assert_eq!(status["can_resume"],true);assert_eq!(status["client_exit"]["code"],7);
 assert!(!status.to_string().contains("213"));assert!(!status.to_string().contains("recovery_key"));assert!(!status.to_string().contains("initial_nonce"));
 r.drain();assert!(!r.can_resume());assert_eq!(drops.load(Ordering::SeqCst),1);r.observe();assert!(!r.retired());
 r.observe();assert!(r.retired());assert_eq!(drops.load(Ordering::SeqCst),1);assert_eq!(r.errors.len(),1);
}
#[test] fn normal_close_keeps_existing_drain_contract_and_does_not_offer_resume(){
 let(mut r,drops)=run(vec![done(0)],vec![Ok(None),done(0)]);r.observe();
 assert!(!r.can_resume());assert!(!r.can_abandon());assert_eq!(drops.load(Ordering::SeqCst),1);assert_eq!(r.status()["state"],"draining");
 r.observe();assert!(r.retired());assert_eq!(r.status()["can_play"],true);
}
#[test] fn failed_observation_retains_live_client_and_never_authorizes_a_second_process(){
 let(mut r,drops)=run(vec![Err(io::Error::other("controlled try_wait failure")),done(7)],vec![Ok(None),Ok(None)]);
 r.observe();assert!(r.client.as_ref().unwrap().exit.is_none());assert!(!r.can_resume());assert!(!r.can_abandon());assert_eq!(drops.load(Ordering::SeqCst),0);
 r.observe();assert!(r.can_resume());assert_eq!(r.errors.len(),2);assert_eq!(r.client.as_ref().unwrap().process.id(),22);
}
#[test] fn dead_server_never_allows_resume_into_an_external_or_replacement_server(){
 let(mut r,drops)=run(vec![Ok(None),done(7)],vec![done(1)]);r.observe();
 assert!(!r.can_resume());assert!(!r.retired());assert_eq!(drops.load(Ordering::SeqCst),1);
 r.observe();assert!(r.retired());assert!(!r.can_resume());assert!(!r.can_abandon());
}
#[test] fn server_observation_error_blocks_restart_until_owned_live_child_is_observed(){
 let(mut r,drops)=run(vec![done(7)],vec![Err(io::Error::other("controlled server observation failure")),Ok(None)]);
 r.observe();assert!(!r.can_resume());assert!(r.server.exit.is_none());assert!(!r.server.observed_live);assert_eq!(drops.load(Ordering::SeqCst),0);
 r.observe();assert!(r.can_resume());assert!(r.server.observed_live);assert_eq!(r.errors.len(),2);
}
#[test] fn private_pipe_changes_only_recovery_mode_and_never_appears_in_argv_or_environment(){
 let spec=launch();let first=spec.payload(false).unwrap();let next=spec.payload(true).unwrap();
 let parse=|bytes:&[u8]|->serde_json::Value{let n=u32::from_le_bytes(bytes[..4].try_into().unwrap()) as usize;assert!(n<=1024);assert_eq!(n,bytes.len()-4);serde_json::from_slice(&bytes[4..]).unwrap()};
 let mut a=parse(&first);let b=parse(&next);assert_eq!(a["recover"],false);a["recover"]=true.into();assert_eq!(a,b);
 assert_eq!(a["recovery_key"],serde_json::json!(vec![213u8;32]));
 let command=spec.command();assert_eq!(command.get_args().count(),0);
 let configured=command.get_envs().map(|(name,value)|(name.to_string_lossy().into_owned(),value.map(|value|value.to_string_lossy().into_owned()))).collect::<Vec<_>>();
 assert!(configured.iter().any(|(name,value)|name=="OPENLEAGUE_SESSION_STDIN" && value.as_deref()==Some("1")));
 assert!(configured.iter().all(|(name,_)|!name.to_ascii_lowercase().contains("secret") && !name.to_ascii_lowercase().contains("recovery_key")));
 assert!(!format!("{command:?}").contains("213"));
}
#[test] fn bootstrap_writer_is_dropped_even_on_partial_failure_and_error_has_no_payload(){
 struct Writer{drops:Arc<AtomicUsize>,first:bool}
 impl Write for Writer{fn write(&mut self,b:&[u8])->io::Result<usize>{if self.first{self.first=false;Ok(b.len().min(4))}else{Err(io::Error::other("controlled private failure"))}}fn flush(&mut self)->io::Result<()>{Ok(())}}
 impl Drop for Writer{fn drop(&mut self){self.drops.fetch_add(1,Ordering::SeqCst);}}
 let drops=Arc::new(AtomicUsize::new(0));let error=write_bootstrap(Writer{drops:drops.clone(),first:true},&launch().payload(false).unwrap()).unwrap_err();
 assert_eq!(drops.load(Ordering::SeqCst),1);assert!(!error.contains("213"));assert!(!error.contains("controlled private failure"));
}
