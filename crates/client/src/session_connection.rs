//! Local authenticated session host; legacy UDP remains an explicit separate mode.
//! No capability is ever returned to UI/log/probe code. Socket silence is recoverable.
use std::{net::UdpSocket, time::{Duration, Instant}};
use openleague_core::{Action, ClientPacket, ServerPacket, Snapshot, session_transport as t};
use crate::{Connection, session_client::{Client, WelcomeOutcome}};

const RETRANSMIT: Duration = Duration::from_secs(2);
const SILENCE: Duration = Duration::from_secs(5);

pub struct Link {
    client: Option<Client>,
    last_received: Instant,
    last_sent: Instant,
    retry_at: Instant,
    recover_socket: bool,
    closed: bool,
    fatal: Option<&'static str>,
}
impl Default for Link { fn default()->Self { Self::legacy() } }
impl Link {
    pub fn legacy()->Self { Self { client:None, last_received:Instant::now(),
        last_sent:Instant::now()-RETRANSMIT, retry_at:Instant::now(),
        recover_socket:false,closed:false,fatal:None } }
    pub fn new(client:Option<Client>)->Self {Self{client,..Self::legacy()}}
}

pub enum Incoming {
    Welcome { session:u64, player:u32, epoch:Option<t::Context> },
    State { snapshot:Snapshot, delivery:Option<(t::Context,u64)> },
    Clock { session:u64, ordinal:u64, opcode:u16, payload:Vec<u8>, secure:Option<t::Context> },
    Rejected(String),
}

fn nonce()->Result<t::RequestNonce,&'static str> {
    openleague_core::session_random::bytes::<16>().map(t::RequestNonce)
}
/// Select only a loopback source, with the resolved endpoint family.
/// Keep the existing IPv4 source preference whenever DNS offers IPv4; this
/// preserves legacy IPv4 behavior without granting external-session authority.
/// An all-IPv6 result needs ::1 because an IPv4 socket cannot connect to it.
pub fn loopback_bind_address_for_resolved_peers(peers:&[std::net::SocketAddr])->Result<std::net::SocketAddr,&'static str> {
    use std::net::{Ipv4Addr,Ipv6Addr,SocketAddr};
    let peer=peers.iter().find(|peer|peer.is_ipv4()).or_else(||peers.first())
        .ok_or("No resolved server endpoint")?;
    Ok(match peer {
        SocketAddr::V4(_)=>SocketAddr::from((Ipv4Addr::LOCALHOST,0)),
        SocketAddr::V6(_)=>SocketAddr::from((Ipv6Addr::LOCALHOST,0)),
    })
}

/// Check the OS-resolved UDP peer before any secure capability is emitted.
pub fn validate_endpoint(peer:std::net::SocketAddr)->Result<(),&'static str> {
    if peer.ip().is_loopback() {Ok(())} else {Err("Private session endpoint is not local")}
}
fn datagram(socket:&UdpSocket, bytes:&[u8])->Result<(),&'static str> {
    let sent=socket.send(bytes).map_err(|_|"Session network send failed")?;
    if sent!=bytes.len() {return Err("Session datagram was incomplete");}
    Ok(())
}

/// Same function used by main and the clock-boundary tests. The actual native
/// EffectClock application, not mere packet receipt, supplies the ACK ordinal.
pub fn apply_clock(connection:&mut Connection,clock:&mut crate::native_effect_clock::EffectClock,
    context:Option<t::Context>,session:u64,ordinal:u64,opcode:u16,payload:&[u8])->Result<(),&'static str> {
    connection.validate_clock(context,session,ordinal,opcode,payload)?;
    clock.receive(ordinal,opcode,payload)?;
    connection.clock_applied(context,session,clock.acknowledged_ordinal())
}

impl Connection {
    pub fn resumable(&self)->bool {self.link.client.is_some()}
    pub fn ready(&self)->bool {
        !self.link.closed && self.link.fatal.is_none() && !self.link.recover_socket
            && match &self.link.client {Some(c)=>c.ready(),None=>self.id.is_some()}
    }
    /// Public gesture identity only; no access/recovery credential escapes.
    pub(crate) fn inventory_input_identity(&self)->Option<(u64,u32,Option<u64>)> {
        if !self.ready() {return None;}
        let (session,player)=(self.session?,self.id?);
        let epoch=match &self.link.client {
            Some(client)=>{let context=client.context()?;if context.session!=session || context.player!=player {return None;}Some(context.epoch)},
            None=>None,
        };
        Some((session,player,epoch))
    }
    pub fn session_status(&self)->&str {
        if self.link.fatal.is_some() {return "Synchronisation impossible. Revenez au lanceur pour reprendre ou quitter la partie.";}
        if self.link.closed {return "Partie quittée.";}
        if let Some(client)=&self.link.client {
            if client.failure().is_some() {return "Reconnexion indisponible. Revenez au lanceur pour quitter cette partie.";}
            if self.link.recover_socket || client.context().is_none() {
                return "Reconnexion en cours… Les commandes seront réactivées après synchronisation de la partie.";
            }
            if !client.ready() {return "Synchronisation de la partie… Les commandes seront bientôt réactivées.";}
        }
        if self.id.is_none() {"Connexion à la partie…"} else {"Connecté."}
    }
    pub fn report(&mut self, error:&str) {
        // Callers supply fixed protocol errors, or a bounded server gameplay reason.
        if self.rejection!=error {bevy::log::warn!("Session: {error}");self.rejection=error.to_owned();}
    }
    pub fn fail_session(&mut self,error:&'static str) {
        self.link.fatal=Some(error);self.report(error);
    }
    pub fn network_interrupted(&mut self) {
        if self.resumable() && !self.link.closed && self.link.fatal.is_none() {
            self.link.recover_socket=true;
            self.report("Network interrupted; recovering the same player");
        } else if !self.resumable() {self.report("Local network unavailable");}
    }
    fn send_secure(&mut self,message:&t::ClientMessage)->Result<(),&'static str> {
        let bytes=serde_json::to_vec(message).map_err(|_|"Session message serialization failed")?;
        let result=datagram(&self.socket,&bytes);
        if result.is_err() {self.network_interrupted();}
        result
    }
    /// Commands from keyboard, shop, learning and probes all pass this barrier.
    /// Returned JSON is public metadata ONLY, never the transport packet/key.
    pub fn send_action(&mut self,action:Action)->Result<serde_json::Value,String> {
        if !self.ready() {return Err(self.session_status().to_owned());}
        if let Some(client)=&mut self.link.client {
            let message=client.input(t::Input::Command(action)).map_err(str::to_owned)?;
            let public=message.public_log();self.send_secure(&message).map_err(str::to_owned)?;Ok(public)
        } else {
            let sequence=self.sequence.checked_add(1).ok_or("command sequence overflow")?;
            let packet=ClientPacket::Command{sequence,action};
            let bytes=serde_json::to_vec(&packet).map_err(|_|"Command serialization failed")?;
            // A failed send may still have reached the kernel. Never reuse its sequence.
            self.sequence=sequence;datagram(&self.socket,&bytes).map_err(str::to_owned)?;
            Ok(serde_json::to_value(&packet).map_err(|_|"Command metadata unavailable")?)
        }
    }
    pub fn send_pause(&mut self,paused:bool)->Result<(),&'static str> {
        if !self.ready() {return Err("Session bootstrap is not ready");}
        if let Some(client)=&mut self.link.client {
            let message=client.input(t::Input::PauseRequest{paused})?;self.send_secure(&message)
        } else {
            let sequence=self.sequence.checked_add(1).ok_or("pause sequence overflow")?;
            let packet=ClientPacket::PauseRequest{sequence,paused};
            let bytes=serde_json::to_vec(&packet).map_err(|_|"Pause serialization failed")?;
            self.sequence=sequence;datagram(&self.socket,&bytes)
        }
    }
    /// Run on each receive system invocation. Pending request bytes use the same
    /// nonce/context until a matching server response changes the state machine.
    pub fn maintain_session(&mut self) {
        if self.link.closed || self.link.fatal.is_some() {return;}
        if self.link.client.is_none() {
            if self.last_join.elapsed()>=RETRANSMIT {
                let packet=ClientPacket::Join{champion:self.champion.clone(),summoners:self.summoners};
                self.last_join=Instant::now();
                if let Ok(bytes)=serde_json::to_vec(&packet) {if let Err(error)=datagram(&self.socket,&bytes) {self.report(error);}}
            }
            return;
        }
        let now=Instant::now();
        if self.link.client.as_ref().is_some_and(|c|c.context().is_some())
            && now.duration_since(self.link.last_received)>=SILENCE {self.network_interrupted();}
        if self.link.recover_socket {
            if now<self.link.retry_at {return;}
            self.link.retry_at=now+RETRANSMIT;
            let replacement=(||->Result<UdpSocket,&'static str>{
                let peer=self.socket.peer_addr().map_err(|_|"Session endpoint unavailable")?;
                validate_endpoint(peer)?;
                let local=loopback_bind_address_for_resolved_peers(std::slice::from_ref(&peer))?;
                let socket=UdpSocket::bind(local).map_err(|_|"Recovery socket unavailable")?;
                socket.connect(peer).map_err(|_|"Recovery connect failed")?;
                socket.set_nonblocking(true).map_err(|_|"Recovery socket configuration failed")?;
                self.link.client.as_mut().unwrap().recover(nonce()?)?;
                Ok(socket)
            })();
            match replacement {
                Ok(socket)=>{self.socket=socket;self.link.recover_socket=false;
                    self.link.last_sent=now-RETRANSMIT;self.link.last_received=now;}
                Err(error)=>{self.report(error);return;}
            }
        }
        if now.duration_since(self.link.last_sent)<RETRANSMIT {return;}
        let client=self.link.client.as_mut().unwrap();
        if client.failure().is_some() {return;}
        let message=if let Some(request)=client.pending_request() {request.clone()}
            else {match client.input(t::Input::Heartbeat) {Ok(m)=>m,Err(e)=>{self.fail_session(e);return;}}};
        self.link.last_sent=now;
        if let Err(error)=self.send_secure(&message) {self.report(error);}
    }
    pub fn decode_datagram(&mut self,bytes:&[u8])->Result<Option<Incoming>,&'static str> {
        if self.link.closed || self.link.fatal.is_some() {return Ok(None);}
        let Some(client)=&mut self.link.client else {
            let Some(payload)=self.assembler.push(bytes,self.session) else {return Ok(None);};
            return match serde_json::from_slice::<ServerPacket>(&payload) {
                Ok(ServerPacket::Welcome{session,player})=>Ok(Some(Incoming::Welcome{session,player,epoch:None})),
                Ok(ServerPacket::State(snapshot))=>Ok(Some(Incoming::State{snapshot,delivery:None})),
                Ok(ServerPacket::ClockControl{session,ordinal,opcode,payload})=>Ok(Some(Incoming::Clock{session,ordinal,opcode,payload,secure:None})),
                Ok(ServerPacket::Rejected{reason}) if reason.len()<=512=>Ok(Some(Incoming::Rejected(reason))),
                _=>Err("Legacy server packet rejected"),
            };
        };
        if self.link.recover_socket {return Ok(None);}
        if bytes.starts_with(b"OLSR") {
            let previous=client.received_frame_ordinal();
            let result=client.frame(bytes);
            if result.is_ok() && client.received_frame_ordinal()>previous {self.link.last_received=Instant::now();}
            else if client.failure().is_some() {self.network_interrupted();}
            return result.map(|_|None);
        }
        let message=serde_json::from_slice::<t::ServerMessage>(bytes).map_err(|_|"Session server packet rejected")?;
        let result=match message {
            t::ServerMessage::SessionWelcome(w)=>match client.welcome(w)? {
                WelcomeOutcome::Duplicate=>None,
                WelcomeOutcome::ResetClock(c)=>Some(Incoming::Welcome{session:c.session,player:c.player,epoch:Some(c)}),
            },
            t::ServerMessage::SessionContext(response)=>{
                let fresh=if response.availability==t::Availability::Detached {nonce()?} else {t::RequestNonce([0;16])};
                client.context_response(&response,fresh)?;
                self.link.last_sent=Instant::now()-RETRANSMIT;None
            }
            t::ServerMessage::SessionRejected(rejection)=>{
                client.rejection(&rejection,nonce()?)?;None
            }
            t::ServerMessage::SessionClockControl(clock)=>{
                client.validate_clock(&clock)?;
                Some(Incoming::Clock{session:clock.context.session,ordinal:clock.ordinal,opcode:clock.opcode,
                    payload:clock.payload,secure:Some(clock.context)})
            }
            t::ServerMessage::SessionGameplayRejected(rejection)=>{
                if client.context()!=Some(rejection.context) || rejection.reason.len()>512 {return Err("Foreign gameplay rejection");}
                Some(Incoming::Rejected(rejection.reason))
            }
            t::ServerMessage::SessionState(_)=>return Err("Unframed session state is not accepted"),
        };
        self.link.last_received=Instant::now();Ok(result)
    }
    pub fn take_ready_states(&mut self)->Vec<Incoming> {
        if self.link.closed || self.link.fatal.is_some() || self.link.recover_socket {return Vec::new();}
        self.link.client.as_mut().map(|c|c.take_ready_states().into_iter().map(|s|
            Incoming::State{snapshot:s.snapshot,delivery:Some((s.context,s.frame_ordinal))}).collect()).unwrap_or_default()
    }
    /// Validate *again* at the actual EffectClock call boundary.
    pub fn validate_clock(&self,context:Option<t::Context>,session:u64,ordinal:u64,opcode:u16,payload:&[u8])->Result<(),&'static str> {
        if self.link.closed || self.link.fatal.is_some() || self.link.recover_socket {return Err("Clock endpoint unavailable");}
        match (&self.link.client,context) {
            (Some(client),Some(context))=>client.validate_clock(&t::ClockEnvelope{context,ordinal,opcode,payload:payload.to_vec()}),
            (None,None) if self.session==Some(session)=>Ok(()),
            _=>Err("Foreign clock context"),
        }
    }
    pub fn clock_applied(&mut self,context:Option<t::Context>,session:u64,ordinal:u64)->Result<(),&'static str> {
        if let (Some(client),Some(context))=(&mut self.link.client,context) {
            if let Some(message)=client.clock_applied(context,ordinal)? {self.send_secure(&message)?;}
            Ok(())
        } else if !self.resumable() && self.session==Some(session) {
            let bytes=serde_json::to_vec(&ClientPacket::ClockAck{session,ordinal}).map_err(|_|"Clock ACK serialization failed")?;
            datagram(&self.socket,&bytes)
        } else {Err("Clock ACK context mismatch")}
    }
    pub fn presented(&mut self,delivery:Option<(t::Context,u64)>)->Result<(),&'static str> {
        match (&mut self.link.client,delivery) {
            (Some(client),Some((context,frame)))=>client.presented(context,frame),
            (None,None)=>Ok(()),_=>Err("Presented frame context mismatch"),
        }
    }
    /// Secure mode calls this only for an explicit successful exit. Legacy keeps
    /// its historical AppExit behavior. Socket silence never calls it.
    pub fn depart(&mut self)->Result<(),String> {
        if self.link.closed {return Ok(());}
        self.link.closed=true;
        if let Some(client)=&mut self.link.client {
            if client.context().is_none() {return Ok(());}
            let message=client.input(t::Input::Leave).map_err(str::to_owned)?;
            self.send_secure(&message).map_err(str::to_owned)
        } else {
            let (Some(session),Some(player))=(self.session,self.id) else {return Ok(());};
            let sequence=self.sequence.checked_add(1).ok_or("departure sequence overflow")?;
            let bytes=serde_json::to_vec(&ClientPacket::Leave{session,player,sequence}).map_err(|_|"Departure serialization failed")?;
            self.sequence=sequence;datagram(&self.socket,&bytes).map_err(str::to_owned)
        }
    }
}

#[cfg(test)]
#[path="session_connection_tests.rs"]
mod tests;
