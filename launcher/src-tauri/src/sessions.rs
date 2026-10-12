//! Own only the two processes spawned for this local session. No PID lookup/kill.
use std::{io::{self,Write}, path::{Path,PathBuf}, process::{Child, ChildStdin, Command, ExitStatus, Stdio},
    sync::{Arc, Mutex}, thread, time::Duration};

pub const ADDRESS: &str = "127.0.0.1:5896";
const POLL: Duration = Duration::from_millis(250);
#[path="sessions_joined.rs"]
mod joined;
use joined::JoinedRun;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Exit { code: Option<i32>, success: bool }
impl From<ExitStatus> for Exit {
    fn from(value: ExitStatus) -> Self { Self { code: value.code(), success: value.success() } }
}
trait Process {
    fn id(&self) -> u32;
    fn observe(&mut self) -> io::Result<Option<Exit>>;
}
impl Process for Child {
    fn id(&self) -> u32 { Child::id(self) }
    fn observe(&mut self) -> io::Result<Option<Exit>> { self.try_wait().map(|value| value.map(Into::into)) }
}
struct Owned<P> { process: P, exit: Option<Exit>, observed_live:bool, observation_error:Option<String> }
impl<P: Process> Owned<P> {
    fn observe(&mut self, role: &str, errors: &mut Vec<String>) {
        if self.exit.is_some() { return; }
        match self.process.observe() {
            Ok(Some(exit)) => {
                self.exit = Some(exit);self.observed_live=false;self.observation_error=None;
                if !exit.success { push_error(errors, format!("{role} terminé en erreur : code {:?}", exit.code)); }
            }
            Ok(None) => {self.observed_live=true;self.observation_error=None;}
            Err(error) => {
                self.observed_live=false;
                let message=format!("Observation {role} impossible : {error}");
                self.observation_error=Some(message.clone());push_error(errors,message);
            },
        }
    }
}
fn push_error(errors: &mut Vec<String>, message: String) {
    if !errors.contains(&message) { errors.push(message); }
}
// Capability storage belongs only to this owned Run. No Debug/Serialize derives.
struct LaunchSpec { root:PathBuf,champion:String,summoners:String,key:[u8;32],initial_nonce:[u8;16] }
impl LaunchSpec {
    fn new(root:&Path,champion:&str,summoners:&str)->Result<Self,String>{
        Ok(Self{root:root.to_path_buf(),champion:champion.into(),summoners:summoners.into(),
            key:crate::session_random::bytes().map_err(str::to_string)?,
            initial_nonce:crate::session_random::bytes().map_err(str::to_string)?})
    }
    fn payload(&self,recover:bool)->Result<Vec<u8>,String>{
        let bytes=serde_json::to_vec(&serde_json::json!({"version":1,"recovery_key":self.key,
            "initial_nonce":self.initial_nonce,"recover":recover})).map_err(|_|"Préparation du canal privé impossible")?;
        if bytes.is_empty() || bytes.len()>1024{return Err("Taille du message privé invalide".into());}
        let mut framed=(bytes.len() as u32).to_le_bytes().to_vec();framed.extend_from_slice(&bytes);Ok(framed)
    }
    fn command(&self)->Command{
        let mut command=Command::new(self.root.join("target/debug/openleague-client.exe"));
        command.current_dir(&self.root).env("OPENLEAGUE_SERVER",ADDRESS)
            .env_remove("OPENLEAGUE_OWNED_STDIN").env("OPENLEAGUE_SESSION_STDIN","1")
            .env("WGPU_BACKEND",std::env::var("WGPU_BACKEND").unwrap_or_else(|_|"vulkan".into()))
            .env("OPENLEAGUE_CHAMPION",&self.champion).env("OPENLEAGUE_SUMMONERS",&self.summoners)
            .stdin(Stdio::piped());
        #[cfg(windows)] {use std::os::windows::process::CommandExt;command.creation_flags(0x08000000);}
        command
    }
}
fn write_bootstrap(mut pipe:impl Write,bytes:&[u8])->Result<(),String>{
    // Errors are fixed labels, never serde diagnostics or secret payloads. The
    // caller owns the only writer and drops it on every result to deliver EOF.
    pipe.write_all(bytes).and_then(|_|pipe.flush()).map_err(|_|"Écriture du canal privé du client impossible".into())
}
struct Run<P, D> {
    generation: u64,
    server: Owned<P>,
    client: Option<Owned<P>>,
    server_stdin: Option<D>,
    drain_requested: bool,
    early_server_reported: bool,
    launch:Option<LaunchSpec>,
    retired_clients:Vec<(u32,Exit)>,
    // History remains available to diagnostics after a successful restart.
    errors: Vec<String>,
    launch_error:Option<String>,
    supervisor_interrupted:bool,
}
impl<P: Process, D> Run<P, D> {
    fn record_launch_error(&mut self, message:String) {
        push_error(&mut self.errors,message.clone());self.launch_error=Some(message);
    }
    fn bootstrap_completed(&mut self) { self.launch_error=None; }
    fn supervisor_interrupted(&mut self) {
        self.supervisor_interrupted=true;
        push_error(&mut self.errors,"Le superviseur a subi une interruption interne ; propriétaires conservés.".into());
    }
    fn replace_client(&mut self, process:P) {
        let previous=self.client.replace(Owned{process,exit:None,observed_live:false,observation_error:None})
            .expect("observed previous client");
        self.retired_clients.push((previous.process.id(),previous.exit.expect("can_resume requires a reaped client")));
    }
    fn current_errors(&self)->Vec<String> {
        let mut errors=Vec::new();
        for (role,owner) in [("Serveur",Some(&self.server)),("Client",self.client.as_ref())] {
            if let Some(owner)=owner {
                if let Some(message)=&owner.observation_error {push_error(&mut errors,message.clone());}
                if let Some(exit)=owner.exit.filter(|exit|!exit.success) {
                    push_error(&mut errors,format!("{role} terminé en erreur : code {:?}",exit.code));
                }
            }
        }
        if let Some(message)=&self.launch_error {push_error(&mut errors,message.clone());}
        if self.supervisor_interrupted {
            push_error(&mut errors,"Le superviseur a subi une interruption interne ; propriétaires conservés.".into());
        }
        if self.server.exit.is_some() && self.client.as_ref().is_some_and(|client|client.exit.is_none()) {
            push_error(&mut errors,"Le serveur est sorti avant le client. Fermez la fenêtre du client pour terminer cette session.".into());
        }
        errors
    }
    fn drain(&mut self) {
        if !self.drain_requested {
            self.drain_requested = true;
            // Closing our pipe asks the server to drain. This does not kill it.
            drop(self.server_stdin.take());
        }
    }
    fn observe(&mut self) {
        if let Some(client) = &mut self.client { client.observe("Client", &mut self.errors); }
        let client_finished=self.client.as_ref().map_or(true,|client|client.exit.is_some());
        let normal_exit=self.client.as_ref().and_then(|client|client.exit).is_some_and(|exit|exit.success);
        // Explicit normal close drains. A failed owned client retains its game
        // and credential; no legacy session silently changes its old policy.
        if client_finished && (self.launch.is_none() || self.client.is_none() || normal_exit) {self.drain();}
        self.server.observe("Serveur", &mut self.errors);
        if self.server.exit.is_some() && self.client.as_ref().is_some_and(|client| client.exit.is_none()) {
            if !self.early_server_reported {
                self.early_server_reported = true;
                push_error(&mut self.errors, "Le serveur est sorti avant le client. Fermez la fenêtre du client pour terminer cette session.".into());
            }
            self.drain();
        }
    }
    fn retired(&self) -> bool {
        self.server.exit.is_some() && self.client.as_ref().map_or(true, |client| client.exit.is_some())
    }
    fn can_resume(&self)->bool{
        self.launch.is_some() && !self.drain_requested && self.server.exit.is_none() && self.server.observed_live
            && self.client.as_ref().and_then(|client|client.exit).is_some_and(|exit|!exit.success)
    }
    fn can_abandon(&self)->bool{
        self.launch.is_some() && !self.drain_requested && self.server.exit.is_none()
            && self.client.as_ref().map_or(true,|client|client.exit.is_some())
    }
    fn status(&self) -> serde_json::Value {
        let retired = self.retired();
        let current_errors=self.current_errors();
        let state = if !current_errors.is_empty() { "error" } else if retired { "idle" }
            else if self.drain_requested { "draining" } else if self.can_resume(){"reconnecting"} else { "playing" };
        let base = if retired { "Session terminée. Une nouvelle partie peut être ouverte." }
            else if self.drain_requested { "Fermeture de la session : attente du départ des participants et de la sauvegarde du résultat." }
            else if self.can_resume(){"Client interrompu. La partie locale est conservée ; vous pouvez reprendre ou abandonner."}
            else { "Partie locale ouverte." };
        let message = if current_errors.is_empty() { base.to_string() }
            else { format!("{base} {}", current_errors.join(" | ")) };
        let exit = |value: Option<Exit>| value.map(|value| serde_json::json!({"code":value.code,"success":value.success}));
        serde_json::json!({"state":state,"message":message,"can_play":retired,"can_resume":self.can_resume(),"can_abandon":self.can_abandon(),
            "generation":self.generation,"address":ADDRESS,"drain_requested":self.drain_requested,
            "server_pid":self.server.process.id(),"client_pid":self.client.as_ref().map(|c|c.process.id()),
            "server_exit":exit(self.server.exit),"client_exit":exit(self.client.as_ref().and_then(|c|c.exit)),
            "retired_clients":self.retired_clients.iter().map(|(pid,value)|serde_json::json!({"pid":pid,"code":value.code,"success":value.success})).collect::<Vec<_>>(),
            "errors":self.errors,"current_errors":current_errors})
    }
}
struct State {
    next_generation: u64,
    run: Option<Run<Child, ChildStdin>>,
    joined: Option<JoinedRun<Child>>,
    last: serde_json::Value,
}
impl State {
    fn new() -> Self {
        Self { next_generation:1, run:None, joined:None, last:serde_json::json!({
            "state":"idle","message":"Prêt à ouvrir une partie locale.","can_play":true,"can_resume":false,"can_abandon":false,
            "generation":0,"address":ADDRESS,"errors":[],"current_errors":[]}) }
    }
    fn observe(&mut self) {
        if let Some(joined) = &mut self.joined {
            joined.observe();
            if joined.retired() { self.last = joined.status(); self.joined = None; }
        }
        if let Some(run) = &mut self.run {
            run.observe();
            if run.retired() { self.last = run.status(); self.run = None; }
        }
    }
    fn has_session(&self)->bool {self.run.is_some() || self.joined.is_some()}
    fn status(&self) -> serde_json::Value {
        let mut status=if let Some(joined)=&self.joined {joined.status()}
            else {self.run.as_ref().map_or_else(|| self.last.clone(), Run::status)};
        if self.run.is_some() {status["mode"]="owned_host".into();status["server_owned"]=true.into();}
        status["can_join"]=(!self.has_session()).into();
        status
    }
    fn block_joined_launcher_exit(&mut self)->bool {
        if self.joined.is_none() {return false;}
        self.observe();
        self.joined.as_mut().is_some_and(JoinedRun::block_launcher_exit)
    }
}
pub struct Sessions { state: Arc<Mutex<State>> }
impl Sessions {
    pub fn new() -> io::Result<Self> {
        let state = Arc::new(Mutex::new(State::new()));
        let observed = Arc::clone(&state);
        thread::Builder::new().name("openleague-sessions".into()).spawn(move || loop {
            let launcher_gone = Arc::strong_count(&observed) == 1;
            let finished = {
                let mut state = match observed.lock() {
                    Ok(state) => state,
                    Err(poison) => {
                        let mut state = poison.into_inner();
                        if let Some(run) = &mut state.run {
                            run.supervisor_interrupted();
                        }
                        if let Some(joined)=&mut state.joined {joined.supervisor_interrupted();}
                        state
                    }
                };
                if launcher_gone {
                    if let Some(run) = &mut state.run { run.drain(); }
                    if let Some(joined) = &mut state.joined { joined.launcher_detached(); }
                }
                state.observe();
                launcher_gone && !state.has_session()
            };
            if finished { break; }
            thread::sleep(POLL);
        })?;
        Ok(Self { state })
    }
    pub fn status(&self) -> Result<serde_json::Value, String> {
        self.state.lock().map(|state| state.status()).map_err(|e|format!("État du superviseur inaccessible : {e}"))
    }
    // Normal close/exit callbacks retain a joined child until try_wait confirms
    // its exit. This does not guard a forced OS process termination.
    pub fn block_joined_launcher_exit(&self)->bool {
        match self.state.lock() {
            Ok(mut state)=>state.block_joined_launcher_exit(),
            Err(poison)=>{
                let mut state=poison.into_inner();
                if let Some(joined)=&mut state.joined {joined.supervisor_interrupted();}
                state.block_joined_launcher_exit()
            }
        }
    }
    pub fn resume(&self)->Result<String,String>{
        let mut state=self.state.lock().map_err(|_|"Superviseur inaccessible")?;state.observe();
        if let Some(joined)=&mut state.joined {return joined.resume();}
        let run=state.run.as_mut().ok_or("Aucune partie détenue à reprendre")?;
        if !run.can_resume(){return Err("Reprise impossible tant que le client précédent n’est pas sorti ou que la session se ferme.".into());}
        let launch=run.launch.as_ref().ok_or("Capacité de reprise indisponible")?;
        let bytes=launch.payload(true)?;
        // Retain the old Child and all errors if spawn fails. It has already
        // been reaped by try_wait; no PID may be reopened or replaced blindly.
        let client=match launch.command().spawn(){Ok(client)=>client,Err(error)=>{
            let message=format!("Redémarrage du client impossible : {error}");run.record_launch_error(message.clone());return Err(message);
        }};
        run.replace_client(client);
        let pipe=run.client.as_mut().unwrap().process.stdin.take();
        let result=pipe.ok_or_else(||"Canal privé du client absent".to_string()).and_then(|pipe|write_bootstrap(pipe,&bytes));
        if let Err(error)=result{run.record_launch_error(error.clone());return Err(error);}
        run.bootstrap_completed();
        Ok("Client relancé. Vérification de la même partie et attente de la libération de l’ancien endpoint.".into())
    }
    pub fn abandon(&self)->Result<String,String>{
        let mut state=self.state.lock().map_err(|_|"Superviseur inaccessible")?;state.observe();
        if state.joined.is_some() {
            return Err("Reprenez puis fermez le client rejoint pour quitter la partie. Ce launcher ne possède pas le serveur.".into());
        }
        let run=state.run.as_mut().ok_or("Aucune partie détenue à abandonner")?;
        if !run.can_abandon(){return Err("Fermez le client avant d’abandonner depuis le launcher.".into());}
        run.drain();Ok("Abandon demandé : attente du départ des participants et de la sauvegarde du résultat.".into())
    }
    pub fn join_local(&self,root:&Path,champion:&str,summoners:&str)->Result<String,String> {
        let mut state=self.state.lock().map_err(|_|"Superviseur inaccessible")?;
        state.observe();
        if state.has_session() {return Err(state.status()["message"].as_str().unwrap_or("Session encore active.").into());}
        let launch=LaunchSpec::new(root,champion,summoners)?;
        let bootstrap=launch.payload(false)?;
        if !root.join("target/debug/openleague-client.exe").is_file() {
            return Err("L’exécutable du client doit être construit avant lancement.".into());
        }
        let generation=state.next_generation;
        state.next_generation=state.next_generation.checked_add(1).ok_or("Compteur de sessions épuisé")?;
        // No server spawn, address probe, process discovery or server pipe.
        let client=launch.command().spawn().map_err(|error|format!("Démarrage du client impossible : {error}"))?;
        state.joined=Some(JoinedRun::new(generation,launch,client));
        // Adopt immediately, before touching the private pipe or writing it.
        state.joined.as_mut().expect("joined client just adopted").bootstrap(&bootstrap)?;
        Ok("Client lancé vers la partie locale ; admission à vérifier dans la fenêtre du jeu.".into())
    }
    pub fn play(&self, root:&Path, champion:&str, summoners:&str) -> Result<String,String> {
        let mut state=self.state.lock().map_err(|e|format!("Superviseur inaccessible : {e}"))?;
        state.observe();
        if state.has_session() { return Err(state.status()["message"].as_str().unwrap_or("Session encore active.").into()); }
        // Generate both private capabilities before spawning any child. Failure
        // never substitutes predictable bytes or opens a legacy session.
        let launch=LaunchSpec::new(root,champion,summoners)?;
        let bootstrap=launch.payload(false)?;
        let server_path=root.join("target/debug/openleague-server.exe");
        let client_path=root.join("target/debug/openleague-client.exe");
        if !server_path.is_file() || !client_path.is_file() { return Err("Les exécutables du jeu doivent être construits avant lancement.".into()); }
        // The probe and both children use this same explicit address. A bind race
        // can still make our server exit; observation must expose that failure.
        let port=std::net::UdpSocket::bind(ADDRESS).map_err(|error|format!("Le port local est indisponible ({ADDRESS}) : {error}"))?;
        let generation=state.next_generation;
        state.next_generation=state.next_generation.checked_add(1).ok_or("Compteur de sessions épuisé")?;
        let mut server_command=Command::new(server_path);
        server_command.current_dir(root).env("OPENLEAGUE_SERVER",ADDRESS)
            .env("OPENLEAGUE_OWNED_STDIN","1").stdin(Stdio::piped());
        #[cfg(windows)] {
            use std::os::windows::process::CommandExt;
            server_command.creation_flags(0x08000000);
        }
        drop(port);
        let server=server_command.spawn().map_err(|error|format!("Démarrage du serveur impossible : {error}"))?;
        // Adopt before extracting the pipe or attempting the client spawn.
        state.run=Some(Run { generation,server:Owned {process:server,exit:None,observed_live:false,observation_error:None},client:None,
            server_stdin:None,drain_requested:false,early_server_reported:false,launch:Some(launch),retired_clients:Vec::new(),errors:Vec::new(),launch_error:None,supervisor_interrupted:false });
        let run=state.run.as_mut().expect("server just adopted");
        run.server_stdin=run.server.process.stdin.take();
        if run.server_stdin.is_none() {
            let error="Le serveur enfant ne possède pas le canal de fermeture attendu.".to_string();
            run.record_launch_error(error.clone());run.drain();return Err(error);
        }
        let result=run.launch.as_ref().expect("owned launch spec").command().spawn();
        match result {
            Ok(client) => {
                run.client=Some(Owned {process:client,exit:None,observed_live:false,observation_error:None});
                let pipe=run.client.as_mut().unwrap().process.stdin.take();
                let result=pipe.ok_or_else(||"Canal privé du client absent".to_string()).and_then(|pipe|write_bootstrap(pipe,&bootstrap));
                if let Err(error)=result{run.record_launch_error(error.clone());return Err(error);}
                run.bootstrap_completed();
                Ok("Partie locale ouverte.".into())
            }
            Err(error) => {
                let error=format!("Démarrage du client impossible : {error}");
                run.record_launch_error(error.clone());run.drain();Err(error)
            }
        }
    }
}

#[cfg(test)] mod tests {
    use super::*;
    use std::{collections::VecDeque,sync::atomic::{AtomicUsize,Ordering}};
    struct Fake { id:u32, answers:VecDeque<io::Result<Option<Exit>>>, polls:usize }
    impl Process for Fake {
        fn id(&self)->u32 { self.id }
        fn observe(&mut self)->io::Result<Option<Exit>> { self.polls+=1;self.answers.pop_front().unwrap_or(Ok(None)) }
    }
    struct Pipe(Arc<AtomicUsize>);
    impl Drop for Pipe { fn drop(&mut self) { self.0.fetch_add(1,Ordering::SeqCst); } }
    fn done(code:i32)->io::Result<Option<Exit>> { Ok(Some(Exit {code:Some(code),success:code==0})) }
    fn fake(id:u32, answers:Vec<io::Result<Option<Exit>>>)->Owned<Fake> { Owned { process:Fake {id,answers:answers.into(),polls:0},exit:None,observed_live:false,observation_error:None } }
    fn run(server:Vec<io::Result<Option<Exit>>>,client:Option<Vec<io::Result<Option<Exit>>>>)->(Run<Fake,Pipe>,Arc<AtomicUsize>) {
        let drops=Arc::new(AtomicUsize::new(0));
        (Run {generation:7,server:fake(11,server),client:client.map(|a|fake(22,a)),server_stdin:Some(Pipe(drops.clone())),drain_requested:false,early_server_reported:false,launch:None,retired_clients:vec![],errors:vec![],launch_error:None,supervisor_interrupted:false},drops)
    }
    #[test] fn session_waits_for_server_after_client_and_closes_only_one_pipe() {
        let (mut r,drops)=run(vec![Ok(None),Ok(None),done(0)],Some(vec![Ok(None),done(0)]));
        r.observe();assert_eq!(r.status()["state"],"playing");assert_eq!(drops.load(Ordering::SeqCst),0);
        r.observe();assert_eq!(r.status()["state"],"draining");assert!(!r.retired());assert_eq!(drops.load(Ordering::SeqCst),1);
        r.observe();assert!(r.retired());assert_eq!(r.status()["can_play"],true);r.observe();
        assert_eq!(drops.load(Ordering::SeqCst),1);assert_eq!(r.client.unwrap().process.polls,2);assert_eq!(r.server.process.polls,3);
    }
    #[test] fn observation_error_retains_owner_and_history_until_retry_retires_it() {
        let (mut r,drops)=run(vec![Ok(None),Ok(None),done(0)],Some(vec![Err(io::Error::other("client fault")),done(7)]));
        r.observe();assert_eq!(r.status()["state"],"error");assert!(r.client.as_ref().unwrap().exit.is_none());assert_eq!(drops.load(Ordering::SeqCst),0);
        r.observe();assert!(!r.retired());assert_eq!(drops.load(Ordering::SeqCst),1);
        r.observe();assert!(r.retired());assert_eq!(r.errors.len(),2);assert_eq!(r.status()["client_exit"]["code"],7);
    }
    #[test] fn server_observation_failure_never_releases_pending_owner() {
        let (mut r,_)=run(vec![Err(io::Error::other("server fault")),done(0)],Some(vec![done(0)]));
        r.observe();assert!(r.server.exit.is_none());assert!(!r.retired());assert_eq!(r.status()["can_play"],false);
        r.observe();assert!(r.retired());assert!(r.errors[0].contains("server fault"));
    }
    #[test] fn early_server_exit_keeps_live_client_and_reports_error() {
        let (mut r,drops)=run(vec![done(0)],Some(vec![Ok(None),Ok(None),done(0)]));
        r.observe();assert!(!r.retired());assert_eq!(r.status()["state"],"error");assert_eq!(drops.load(Ordering::SeqCst),1);
        r.observe();assert_eq!(r.errors.len(),1);assert_eq!(r.server.process.polls,1);r.observe();assert!(r.retired());
    }
    #[test] fn failed_client_spawn_drains_server_and_preserves_primary_error() {
        let (mut r,drops)=run(vec![Ok(None),done(0)],None);r.record_launch_error("client spawn failed".into());r.drain();
        r.observe();assert!(!r.retired());assert_eq!(r.status()["state"],"error");r.observe();assert!(r.retired());
        assert_eq!(r.errors,["client spawn failed"]);assert_eq!(drops.load(Ordering::SeqCst),1);
    }
    // Executed only as an owned child by the real-process test below.
    #[test] #[ignore]
    fn owned_child_fixture() {
        if std::env::var("OPENLEAGUE_SESSION_TEST_CHILD").as_deref()==Ok("wait") {
            use std::io::Read;
            let mut bytes=Vec::new();std::io::stdin().read_to_end(&mut bytes).unwrap();
        } else { assert_eq!(std::env::var("OPENLEAGUE_SESSION_TEST_CHILD").as_deref(),Ok("exit")); }
    }
    // Every test child is adopted immediately, including when a later spawn or
    // assertion panics. Cleanup only closes our pipes and polls our handles.
    struct TestChild(Child);
    impl Process for TestChild {
        fn id(&self)->u32 { self.0.id() }
        fn observe(&mut self)->io::Result<Option<Exit>> { self.0.observe() }
    }
    impl Drop for TestChild {
        fn drop(&mut self) {
            drop(self.0.stdin.take());
            let deadline=std::time::Instant::now()+Duration::from_secs(15);
            loop {
                match self.0.try_wait() {
                    Ok(Some(_))=>return,
                    Ok(None)=>{},
                    Err(error)=>eprintln!("Test child {} observation failed: {error}",self.0.id()),
                }
                if std::time::Instant::now()>=deadline {
                    eprintln!("Test child {} did not retire after its owned pipe closed; no kill attempted",self.0.id());
                    return;
                }
                thread::sleep(Duration::from_millis(10));
            }
        }
    }
    struct RealRun { session:Run<TestChild,ChildStdin>, witness:TestChild }
    impl RealRun {
        fn close_pipes(&mut self) {
            self.session.drain();
            drop(self.session.server.process.0.stdin.take());
            if let Some(client)=&mut self.session.client { drop(client.process.0.stdin.take()); }
            drop(self.witness.0.stdin.take());
        }
    }
    impl Drop for RealRun {
        fn drop(&mut self) { self.close_pipes(); }
    }
    #[test] fn real_owned_server_eof_leaves_other_child_untouched() {
        fn spawn(mode:&str)->TestChild {
            let mut command=Command::new(std::env::current_exe().unwrap());
            command.args(["--exact","sessions::tests::owned_child_fixture","--ignored","--test-threads=1"])
                .env("OPENLEAGUE_SESSION_TEST_CHILD",mode).stdin(Stdio::piped()).stdout(Stdio::null()).stderr(Stdio::null());
            #[cfg(windows)] { use std::os::windows::process::CommandExt;command.creation_flags(0x08000000); }
            TestChild(command.spawn().unwrap())
        }
        let witness=spawn("wait");
        let mut server=spawn("wait");let client=spawn("exit");
        // Keep stdin inside its guarded Child until every fallible spawn ends.
        let pipe=server.0.stdin.take();
        let mut owned=RealRun { session:Run {generation:1,server:Owned {process:server,exit:None,observed_live:false,observation_error:None},client:Some(Owned {process:client,exit:None,observed_live:false,observation_error:None}),
            server_stdin:pipe,drain_requested:false,early_server_reported:false,launch:None,retired_clients:vec![],errors:vec![],launch_error:None,supervisor_interrupted:false},witness };
        let deadline=std::time::Instant::now()+Duration::from_secs(15);
        while !owned.session.retired() && std::time::Instant::now()<deadline {owned.session.observe();thread::sleep(Duration::from_millis(10));}
        let retired=owned.session.retired();let witness_alive=owned.witness.observe().unwrap().is_none();
        // Close all pipes before any bounded cleanup wait, also on unwind.
        owned.close_pipes();
        let deadline=std::time::Instant::now()+Duration::from_secs(15);
        let witness_exit=loop {if let Some(exit)=owned.witness.observe().unwrap(){break Some(exit);}if std::time::Instant::now()>=deadline{break None;}thread::sleep(Duration::from_millis(10));};
        assert!(retired);assert!(owned.session.errors.is_empty());assert!(witness_alive);assert!(witness_exit.is_some_and(|exit|exit.success));
    }
}

#[cfg(test)]
#[path="session_recovery_tests.rs"]
mod recovery_tests;

#[cfg(test)]
#[path="session_status_tests.rs"]
mod status_tests;
