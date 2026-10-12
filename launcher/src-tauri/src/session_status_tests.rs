//! Controlled Process results only. No child, socket, private pipe or Tauri runtime.
use super::*;
use std::collections::VecDeque;

struct Fake { id:u32, answers:VecDeque<io::Result<Option<Exit>>> }
impl Process for Fake {
    fn id(&self)->u32 {self.id}
    fn observe(&mut self)->io::Result<Option<Exit>> {self.answers.pop_front().unwrap_or(Ok(None))}
}
fn done(code:i32)->io::Result<Option<Exit>> {Ok(Some(Exit{code:Some(code),success:code==0}))}
fn fake(id:u32,answers:Vec<io::Result<Option<Exit>>>)->Fake {Fake{id,answers:answers.into()}}
fn owned(id:u32,answers:Vec<io::Result<Option<Exit>>>)->Owned<Fake> {
    Owned{process:fake(id,answers),exit:None,observed_live:false,observation_error:None}
}
fn run(client:Vec<io::Result<Option<Exit>>>,server:Vec<io::Result<Option<Exit>>>)->Run<Fake,()> {
    Run{generation:9,server:owned(11,server),client:Some(owned(22,client)),server_stdin:Some(()),
        drain_requested:false,early_server_reported:false,
        launch:Some(LaunchSpec{root:PathBuf::from("controlled-root"),champion:"garen".into(),summoners:"[null,null]".into(),
            key:[213;32],initial_nonce:[17;16]}),retired_clients:vec![],errors:vec![],launch_error:None,supervisor_interrupted:false}
}

#[test]
fn resumed_client_and_normal_retirement_do_not_repeat_historical_crash() {
    let mut r=run(vec![done(71)],vec![Ok(None),Ok(None),Ok(None),done(0)]);
    r.observe();assert!(r.can_resume());assert_eq!(r.status()["state"],"error");
    assert!(r.status()["message"].as_str().unwrap().contains("Some(71)"));
    r.replace_client(fake(33,vec![Ok(None),done(0)]));r.bootstrap_completed();r.observe();
    let playing=r.status();
    assert_eq!(playing["state"],"playing");assert_eq!(playing["message"],"Partie locale ouverte.");
    assert_eq!(playing["current_errors"],serde_json::json!([]));assert_eq!(playing["errors"].as_array().unwrap().len(),1);
    assert_eq!(playing["client_pid"],33);assert_eq!(playing["server_pid"],11);
    assert_eq!(playing["retired_clients"][0]["pid"],22);assert_eq!(playing["retired_clients"][0]["code"],71);
    assert!(!r.can_resume());assert!(!r.can_abandon());assert!(!r.drain_requested);
    r.observe();assert_eq!(r.status()["state"],"draining");r.observe();assert!(r.retired());
    let retired=r.status();assert_eq!(retired["state"],"idle");assert_eq!(retired["can_play"],true);
    assert_eq!(retired["message"],"Session terminée. Une nouvelle partie peut être ouverte.");
    assert_eq!(retired["errors"],playing["errors"]);assert_eq!(retired["retired_clients"],playing["retired_clients"]);
}

#[test]
fn repeated_exit_code_on_replacement_is_current_even_with_deduplicated_history() {
    let mut r=run(vec![done(71)],vec![Ok(None),Ok(None)]);r.observe();
    r.replace_client(fake(33,vec![done(71)]));r.bootstrap_completed();r.observe();
    assert_eq!(r.errors.len(),1);assert_eq!(r.status()["state"],"error");
    assert_eq!(r.status()["current_errors"].as_array().unwrap().len(),1);
    assert!(r.status()["message"].as_str().unwrap().contains("Some(71)"));assert!(r.can_resume());
}

#[test]
fn successful_observation_clears_current_faults_only_and_keeps_both_owners() {
    let mut r=run(vec![Err(io::Error::other("client observation")),Ok(None)],
        vec![Err(io::Error::other("server observation")),Ok(None)]);
    r.observe();assert_eq!(r.status()["current_errors"].as_array().unwrap().len(),2);
    assert_eq!(r.status()["state"],"error");assert!(!r.can_resume());assert!(!r.can_abandon());
    r.observe();assert_eq!(r.status()["state"],"playing");assert_eq!(r.errors.len(),2);
    assert_eq!(r.status()["current_errors"],serde_json::json!([]));
    assert_eq!(r.server.process.id(),11);assert_eq!(r.client.as_ref().unwrap().process.id(),22);
    assert!(!r.drain_requested);assert!(!r.can_resume());assert!(!r.can_abandon());
}

#[test]
fn identical_observation_fault_becomes_current_again_after_successful_retry() {
    let mut r=run(vec![Err(io::Error::other("same failure")),Ok(None),Err(io::Error::other("same failure"))],vec![]);
    r.observe();assert_eq!(r.status()["state"],"error");r.observe();assert_eq!(r.status()["state"],"playing");
    r.observe();assert_eq!(r.status()["state"],"error");assert_eq!(r.errors.len(),1);
    assert_eq!(r.status()["current_errors"].as_array().unwrap().len(),1);
}

#[test]
fn launch_error_requires_successful_bootstrap_not_just_a_live_process() {
    let mut r=run(vec![done(71)],vec![]);r.observe();
    r.record_launch_error("Redémarrage du client impossible : controlled failure".into());
    assert!(r.can_resume());assert_eq!(r.client.as_ref().unwrap().process.id(),22);
    r.replace_client(fake(33,vec![Ok(None)]));
    r.record_launch_error("Écriture du canal privé du client impossible".into());r.observe();
    assert_eq!(r.status()["state"],"error");assert!(r.status()["message"].as_str().unwrap().contains("canal privé"));
    r.bootstrap_completed();assert_eq!(r.status()["state"],"playing");assert_eq!(r.errors.len(),3);
    assert_eq!(r.status()["current_errors"],serde_json::json!([]));
}

#[test]
fn supervisor_interruption_remains_current_after_bootstrap_and_observation() {
    let mut r=run(vec![],vec![]);r.supervisor_interrupted();r.bootstrap_completed();r.observe();
    assert_eq!(r.status()["state"],"error");assert!(r.status()["message"].as_str().unwrap().contains("superviseur"));
    assert_eq!(r.errors.len(),1);assert_eq!(r.status()["current_errors"].as_array().unwrap().len(),1);
}

#[test]
fn early_normal_server_exit_remains_current_until_live_client_retires() {
    let mut r=run(vec![Ok(None),done(0)],vec![done(0)]);r.observe();
    assert_eq!(r.status()["state"],"error");assert!(r.status()["message"].as_str().unwrap().contains("avant le client"));
    assert!(r.drain_requested);assert!(!r.can_resume());r.observe();
    assert_eq!(r.status()["state"],"idle");assert_eq!(r.status()["current_errors"],serde_json::json!([]));assert_eq!(r.errors.len(),1);
}

#[test]
fn failed_server_exit_is_not_hidden_by_a_successful_client_bootstrap() {
    let mut r=run(vec![Ok(None),done(0)],vec![done(5)]);r.observe();r.bootstrap_completed();
    assert_eq!(r.status()["state"],"error");assert!(r.status()["message"].as_str().unwrap().contains("Serveur terminé en erreur"));
    r.observe();assert!(r.retired());assert_eq!(r.status()["state"],"error");
    assert_eq!(r.status()["current_errors"].as_array().unwrap().len(),1);assert_eq!(r.status()["can_play"],true);
}
