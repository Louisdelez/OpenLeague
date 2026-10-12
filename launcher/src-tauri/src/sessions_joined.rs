//! A joined launcher owns its client only. No server handle, pipe or PID lookup.
//! Credentials stay in memory; normal client exit sends the existing Leave.
use super::*;

pub(super) struct JoinedRun<P> {
    generation:u64,
    client:Owned<P>,
    launch:LaunchSpec,
    retired_clients:Vec<(u32,Exit)>,
    errors:Vec<String>,
    launch_error:Option<String>,
    supervisor_interrupted:bool,
    close_notice:bool,
    launcher_gone:bool,
}
impl<P:Process> JoinedRun<P> {
    pub(super) fn new(generation:u64,launch:LaunchSpec,process:P)->Self {
        Self {generation,client:Owned{process,exit:None,observed_live:false,observation_error:None},launch,
            retired_clients:Vec::new(),errors:Vec::new(),launch_error:None,
            supervisor_interrupted:false,close_notice:false,launcher_gone:false}
    }
    pub(super) fn observe(&mut self) {self.client.observe("Client",&mut self.errors);}
    pub(super) fn retired(&self)->bool {
        self.client.exit.is_some_and(|exit|exit.success || self.launcher_gone)
    }
    fn can_resume(&self)->bool {
        !self.launcher_gone && self.client.exit.is_some_and(|exit|!exit.success)
    }
    pub(super) fn block_launcher_exit(&mut self)->bool {
        let blocked=self.client.exit.is_none();
        if blocked {self.close_notice=true;}
        blocked
    }
    pub(super) fn launcher_detached(&mut self) {self.launcher_gone=true;}
    pub(super) fn supervisor_interrupted(&mut self) {
        self.supervisor_interrupted=true;
        push_error(&mut self.errors,"Le superviseur a subi une interruption interne ; client conservé.".into());
    }
    fn record_launch_error(&mut self,message:String) {
        push_error(&mut self.errors,message.clone());self.launch_error=Some(message);
    }
    fn complete_bootstrap(&mut self,result:Result<(),String>)->Result<(),String> {
        match result {
            Ok(())=>{self.launch_error=None;Ok(())}
            Err(error)=>{self.record_launch_error(error.clone());Err(error)}
        }
    }
    fn resume_payload(&self)->Result<Vec<u8>,String> {
        if !self.can_resume() {
            return Err("Reprise impossible tant que la sortie du client précédent n’est pas confirmée.".into());
        }
        // ContextQuery/recovery with the same key; never a new Join fallback.
        self.launch.payload(true)
    }
    fn replace_client(&mut self,process:P) {
        assert!(self.can_resume(),"joined replacement requires an observed failed exit");
        let previous=std::mem::replace(&mut self.client,
            Owned{process,exit:None,observed_live:false,observation_error:None});
        self.retired_clients.push((previous.process.id(),previous.exit.expect("observed exit")));
        self.close_notice=false;
    }
    fn restart_with(&mut self,spawn:impl FnOnce(&LaunchSpec)->Result<P,String>,
        bootstrap:impl FnOnce(&mut P,&[u8])->Result<(),String>)->Result<String,String> {
        let bytes=self.resume_payload()?;
        let process=match spawn(&self.launch) {
            Ok(process)=>process,
            Err(error)=>{self.record_launch_error(error.clone());return Err(error);}
        };
        self.replace_client(process);
        let result=bootstrap(&mut self.client.process,&bytes);
        self.complete_bootstrap(result)?;
        Ok("Client relancé ; reprise à vérifier dans la fenêtre du jeu.".into())
    }
    pub(super) fn status(&self)->serde_json::Value {
        let mut current_errors=Vec::new();
        if let Some(error)=&self.client.observation_error {push_error(&mut current_errors,error.clone());}
        if let Some(exit)=self.client.exit.filter(|exit|!exit.success) {
            push_error(&mut current_errors,format!("Client terminé en erreur : code {:?}",exit.code));
        }
        if let Some(error)=&self.launch_error {push_error(&mut current_errors,error.clone());}
        if self.supervisor_interrupted {
            push_error(&mut current_errors,"Le superviseur a subi une interruption interne ; client conservé.".into());
        }
        let retired=self.retired();
        let state=if !current_errors.is_empty(){"error"}else if retired{"idle"}else{"playing"};
        let base=if retired {"Client rejoint fermé. Le serveur reste géré par son hôte."}
            else if self.can_resume() {"Client interrompu : Reprendre reste disponible ici. Fermer ce launcher perd la reprise et peut laisser une place réservée jusqu’à la fermeture de la partie par l’hôte."}
            else if self.close_notice {"Fermez d’abord le client rejoint. Ce launcher conserve son processus."}
            else {"Client ouvert vers la partie locale ; admission à vérifier dans la fenêtre du jeu."};
        let message=if current_errors.is_empty(){base.to_string()}else{format!("{base} {}",current_errors.join(" | "))};
        let exit=|value:Exit|serde_json::json!({"code":value.code,"success":value.success});
        serde_json::json!({"state":state,"message":message,"mode":"joined_client","server_owned":false,
            "can_play":retired,"can_join":retired,"can_resume":self.can_resume(),"can_abandon":false,
            "generation":self.generation,"address":ADDRESS,"drain_requested":false,
            "server_pid":null,"server_exit":null,"client_pid":self.client.process.id(),"client_exit":self.client.exit.map(exit),
            "retired_clients":self.retired_clients.iter().map(|(pid,value)|serde_json::json!({"pid":pid,"code":value.code,"success":value.success})).collect::<Vec<_>>(),
            "errors":self.errors,"current_errors":current_errors})
    }
}
impl JoinedRun<Child> {
    pub(super) fn bootstrap(&mut self,bytes:&[u8])->Result<(),String> {
        let result=bootstrap_child(&mut self.client.process,bytes);
        self.complete_bootstrap(result)
    }
    pub(super) fn resume(&mut self)->Result<String,String> {
        // Retain the old observed exit until a replacement actually exists;
        // immediately adopt the new Child before private bootstrap I/O.
        self.restart_with(|launch|launch.command().spawn().map_err(|error|format!("Redémarrage du client impossible : {error}")),bootstrap_child)
    }
}
fn bootstrap_child(client:&mut Child,bytes:&[u8])->Result<(),String> {
    let pipe=client.stdin.take();
    pipe.ok_or_else(||"Canal privé du client absent".to_string()).and_then(|pipe|write_bootstrap(pipe,bytes))
}

#[cfg(test)]
#[path="sessions_joined_tests.rs"]
mod tests;
