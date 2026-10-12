//! Controlled Process/pipe results; no Tauri, socket, real child or server.
use super::*;
use std::{collections::VecDeque,sync::atomic::{AtomicUsize,Ordering}};

struct Fake {id:u32,answers:VecDeque<io::Result<Option<Exit>>>,polls:Arc<AtomicUsize>}
impl Process for Fake {
    fn id(&self)->u32{self.id}
    fn observe(&mut self)->io::Result<Option<Exit>> {
        self.polls.fetch_add(1,Ordering::SeqCst);self.answers.pop_front().unwrap_or(Ok(None))
    }
}
fn fake(id:u32,answers:Vec<io::Result<Option<Exit>>>)->Fake {
    Fake{id,answers:answers.into(),polls:Arc::new(AtomicUsize::new(0))}
}
fn done(code:i32)->io::Result<Option<Exit>>{Ok(Some(Exit{code:Some(code),success:code==0}))}
fn spec()->LaunchSpec{LaunchSpec{root:PathBuf::from("controlled-root"),champion:"garen".into(),summoners:"[\"Barrier\",\"Smite\"]".into(),key:[213;32],initial_nonce:[17;16]}}
fn run(answers:Vec<io::Result<Option<Exit>>>)->JoinedRun<Fake>{JoinedRun::new(12,spec(),fake(22,answers))}
fn payload(bytes:&[u8])->serde_json::Value {
    assert_eq!(u32::from_le_bytes(bytes[..4].try_into().unwrap()) as usize,bytes.len()-4);
    serde_json::from_slice(&bytes[4..]).unwrap()
}

#[test] fn joined_normal_exit_retires_only_client_without_server_authority() {
    let mut r=run(vec![Ok(None),done(0)]);
    r.observe();let live=r.status();assert_eq!(live["mode"],"joined_client");assert_eq!(live["can_play"],false);
    assert_eq!(live["can_join"],false);assert_eq!(live["server_owned"],false);assert!(live["server_pid"].is_null());
    assert!(live["server_exit"].is_null());assert_eq!(live["drain_requested"],false);assert_eq!(live["can_abandon"],false);
    assert!(r.block_launcher_exit());r.observe();assert!(r.retired());assert!(!r.block_launcher_exit());
    assert!(!r.can_resume());assert_eq!(r.status()["can_play"],true);assert_eq!(r.status()["drain_requested"],false);
    let polls=r.client.process.polls.clone();r.observe();assert_eq!(polls.load(Ordering::SeqCst),2);
}

#[test] fn joined_observation_error_keeps_handle_blocks_close_and_prevents_duplicate_spawn() {
    let mut r=run(vec![Err(io::Error::other("controlled observation")),done(71)]);
    r.observe();assert_eq!(r.client.process.id(),22);assert!(r.client.exit.is_none());
    assert!(!r.can_resume());assert!(r.block_launcher_exit());assert!(!r.retired());
    let attempted=Arc::new(AtomicUsize::new(0));let witness=attempted.clone();
    assert!(r.restart_with(move |_|{witness.fetch_add(1,Ordering::SeqCst);Ok(fake(33,vec![]))},|_,_|Ok(())).is_err());
    assert_eq!(attempted.load(Ordering::SeqCst),0);assert_eq!(r.status()["state"],"error");
    r.observe();assert!(r.can_resume());assert!(!r.block_launcher_exit());assert_eq!(r.errors.len(),2);
}

#[test] fn joined_crash_keeps_private_identity_and_warns_about_launcher_closure() {
    let mut r=run(vec![done(71)]);let initial=payload(&r.launch.payload(false).unwrap());r.observe();
    assert!(!r.retired());assert!(r.can_resume());assert_eq!(r.status()["can_abandon"],false);
    let recovery=payload(&r.resume_payload().unwrap());assert_eq!(initial["recover"],false);assert_eq!(recovery["recover"],true);
    assert_eq!(recovery["recovery_key"],initial["recovery_key"]);assert_eq!(recovery["initial_nonce"],initial["initial_nonce"]);
    let status=r.status().to_string();assert!(!status.contains("recovery_key"));assert!(!status.contains("initial_nonce"));assert!(!status.contains("213"));
    assert!(r.status()["message"].as_str().unwrap().contains("perd la reprise"));
    assert!(r.status()["message"].as_str().unwrap().contains("place réservée"));
}

#[test] fn joined_resume_spawn_failure_preserves_old_exit_and_capability() {
    let mut r=run(vec![done(71)]);r.observe();let before=r.resume_payload().unwrap();
    assert!(r.restart_with(|_|Err("controlled spawn failure".into()),|_,_|panic!("bootstrap must not run")).is_err());
    assert_eq!(r.client.process.id(),22);assert_eq!(r.client.exit.unwrap().code,Some(71));assert!(r.retired_clients.is_empty());
    assert!(r.can_resume());assert_eq!(r.resume_payload().unwrap(),before);
    assert!(r.status()["message"].as_str().unwrap().contains("controlled spawn failure"));
}

#[test] fn joined_resume_bootstrap_failure_adopts_replacement_before_failure() {
    let mut r=run(vec![done(71)]);r.observe();
    assert!(r.restart_with(|_|Ok(fake(33,vec![Ok(None),done(72)])),|child,bytes|{
        assert_eq!(child.id(),33);assert_eq!(payload(bytes)["recover"],true);Err("controlled pipe failure".into())
    }).is_err());
    assert_eq!(r.client.process.id(),33);assert!(r.client.exit.is_none());assert_eq!(r.retired_clients[0].0,22);
    assert!(!r.can_resume());assert!(r.block_launcher_exit());r.observe();assert!(!r.can_resume());
    assert!(r.status()["message"].as_str().unwrap().contains("controlled pipe failure"));
    r.observe();assert!(r.can_resume());assert!(!r.block_launcher_exit());
}

#[test] fn joined_successful_recovery_clears_current_error_only_then_normal_exit_retires() {
    let mut r=run(vec![done(71)]);r.observe();r.record_launch_error("controlled earlier spawn failure".into());
    r.restart_with(|_|Ok(fake(33,vec![Ok(None),done(0)])),|_,_|Ok(())).unwrap();r.observe();
    assert_eq!(r.status()["state"],"playing");assert_eq!(r.status()["current_errors"],serde_json::json!([]));
    assert_eq!(r.errors.len(),2);assert_eq!(r.retired_clients[0].0,22);assert_eq!(r.retired_clients[0].1.code,Some(71));
    assert!(!r.status()["message"].as_str().unwrap().contains("Some(71)"));assert!(!r.can_resume());
    r.observe();assert!(r.retired());assert_eq!(r.status()["state"],"idle");assert_eq!(r.status()["can_abandon"],false);
}

#[test] fn joined_initial_bootstrap_error_stays_visible_until_success_not_live_observation() {
    let mut r=run(vec![Ok(None)]);
    assert!(r.complete_bootstrap(Err("controlled initial pipe failure".into())).is_err());r.observe();
    assert_eq!(r.status()["state"],"error");assert!(r.block_launcher_exit());
    assert_eq!(r.client.process.id(),22);assert!(!r.can_resume());
    r.complete_bootstrap(Ok(())).unwrap();assert_eq!(r.status()["current_errors"],serde_json::json!([]));assert_eq!(r.errors.len(),1);
}

#[test] fn joined_launcher_release_retains_live_or_unobserved_child_until_exit() {
    let mut r=run(vec![Ok(None),Err(io::Error::other("controlled wait failure")),done(71)]);
    r.launcher_detached();r.observe();assert!(!r.retired());assert!(r.block_launcher_exit());assert!(!r.can_resume());
    r.observe();assert!(!r.retired());assert_eq!(r.client.process.id(),22);assert!(r.block_launcher_exit());
    r.observe();assert!(r.retired());assert!(!r.can_resume());assert!(!r.block_launcher_exit());
    assert_eq!(r.status()["server_owned"],false);assert_eq!(r.status()["drain_requested"],false);
}

#[test] fn joined_live_close_notice_is_public_and_does_not_discard_client() {
    let mut r=run(vec![Ok(None)]);r.observe();assert!(r.block_launcher_exit());
    assert!(r.status()["message"].as_str().unwrap().starts_with("Fermez d’abord le client rejoint."));
    assert_eq!(r.client.process.id(),22);assert_eq!(r.status()["can_play"],false);assert!(!r.retired());
    assert_eq!(r.status()["current_errors"],serde_json::json!([]));
}

#[test] fn joined_private_command_targets_only_client_without_secret_arguments() {
    let r=run(vec![]);let command=r.launch.command();
    assert!(Path::new(command.get_program()).ends_with("target/debug/openleague-client.exe"));
    assert_eq!(command.get_args().count(),0);
    let env=command.get_envs().map(|(k,v)|(k.to_string_lossy().into_owned(),v.map(|v|v.to_string_lossy().into_owned()))).collect::<Vec<_>>();
    assert!(env.iter().any(|(k,v)|k=="OPENLEAGUE_SESSION_STDIN" && v.as_deref()==Some("1")));
    assert!(env.iter().any(|(k,v)|k=="OPENLEAGUE_SERVER" && v.as_deref()==Some(ADDRESS)));
    assert!(env.iter().any(|(k,v)|k=="OPENLEAGUE_OWNED_STDIN" && v.is_none()));
    assert!(!format!("{command:?}").contains("213"));assert!(!format!("{command:?}").contains("recovery_key"));
}

#[test] fn joined_supervisor_interruption_remains_current_after_recovery() {
    let mut r=run(vec![done(71)]);r.observe();r.supervisor_interrupted();
    r.restart_with(|_|Ok(fake(33,vec![Ok(None)])),|_,_|Ok(())).unwrap();r.observe();
    assert_eq!(r.status()["state"],"error");assert!(r.status()["message"].as_str().unwrap().contains("superviseur"));
    assert_eq!(r.client.process.id(),33);assert!(r.block_launcher_exit());
}
