mod owned_session;
mod pause;
mod clock_delivery;
mod result_store;
mod reconnect;
mod session_host;
use openleague_core::{ClientPacket, Navigation, ServerPacket, Simulation, TICK_RATE};
use std::{
    collections::HashMap,
    fs,
    net::{SocketAddr, UdpSocket},
    path::PathBuf,
    time::{Duration, Instant},
};
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let navigation = Navigation::load(
        &fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json"))?,
        &fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin"))?,
    )
    .map_err(std::io::Error::other)?;
    openleague_core::map10_dense_height::binding().map_err(|error| {
        std::io::Error::other(format!("Map10 dense-height initialization failed: {error}"))
    })?;
    let mut game = Simulation::new(navigation).map_err(std::io::Error::other)?;
    game.enable_map10().map_err(std::io::Error::other)?;
    game.enable_map10_cast_ground().map_err(std::io::Error::other)?;
    game.session = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)?
        .as_nanos() as u64;
    let address = std::env::var("OPENLEAGUE_SERVER").unwrap_or_else(|_| "127.0.0.1:5896".into());
    let socket = UdpSocket::bind(&address)?;
    socket.set_nonblocking(true)?;
    println!("OpenLeague server on {address}, 122 champion definitions, {TICK_RATE} Hz");
    let mut clients: HashMap<SocketAddr, (u32, u64, Instant)> = HashMap::new();
    let mut buffer = [0u8; 4096];
    let allow_pause=std::env::var("OPENLEAGUE_ALLOW_PAUSE").as_deref()==Ok("1");
    let pause_epoch=Instant::now();let mut pause=pause::Pause::default();
    let mut clock_delivery=clock_delivery::Delivery::default();
    let mut sessions=session_host::Host::new(game.session)
        .map_err(|_| std::io::Error::other("session registry initialization failed"))?;
    let mut session_entropy=session_host::OsEntropy;
    let mut next_clock_delivery=Instant::now();
    let mut owner = owned_session::Owner::from_environment()?;
    let mut owner_error = None;
    let mut departures = owned_session::Departures::default();
    let mut result_saved=false;
    let mut next_result_attempt=Instant::now();
    let mut next = Instant::now();
    let mut next_snapshot = Instant::now();
    loop {
        let draining = match owner.poll() {
            Ok(value) => value,
            Err(error) => {
                eprintln!("Launcher ownership channel failed: {error}; draining existing peers before exit");
                owner_error = Some(error);
                true
            }
        };
        // Revoke offline reservations before accepting any packet after owner EOF.
        sessions.poll(pause_epoch.elapsed(),draining,&mut game,&mut clock_delivery)
            .map_err(std::io::Error::other)?;
        loop {
            match socket.recv_from(&mut buffer) {
                Ok((n, peer)) => {
                    // Capability-bearing messages are wire-only. Never log raw buffers,
                    // serde errors, or the serialized response (Welcome contains a key).
                    if let Ok(message)=serde_json::from_slice::<openleague_core::session_transport::ClientMessage>(&buffer[..n]) {
                        use openleague_core::session_transport::{ClientMessage as Input,ServerMessage,Rejection,RejectionCode};
                        let nonce=match &message {
                            Input::JoinResumable(r)=>Some(r.request_nonce),Input::Resume(r)=>Some(r.request_nonce),
                            Input::ContextQuery(r)=>Some(r.request_nonce),Input::Session(_)=>None,
                        };
                        let response=match sessions.handle(message,peer,clients.contains_key(&peer),
                            &mut game,&mut clock_delivery,&mut pause,pause_epoch.elapsed(),allow_pause,&mut session_entropy) {
                            Ok(response)=>response,
                            Err(reason)=>{
                                eprintln!("Local session transport failed: {reason}");
                                Some(ServerMessage::SessionRejected(Rejection{request_nonce:nonce,
                                    context:None,reason:RejectionCode::Unavailable}))
                            }
                        };
                        if let Some(response)=response {let _=socket.send_to(&serde_json::to_vec(&response)?,peer);}
                        continue;
                    }
                    // Legacy packets can never control a peer previously admitted securely.
                    if sessions.forbids_legacy(peer) {continue;}
                    let packet = match serde_json::from_slice::<ClientPacket>(&buffer[..n]) {
                        Ok(p) => p,
                        Err(_) => {
                            if clients.contains_key(&peer) {
                                let response = ServerPacket::Rejected {
                                    reason: "malformed or unsupported packet".into(),
                                };
                                let _ = socket.send_to(&serde_json::to_vec(&response)?, peer);
                            }
                            continue;
                        }
                    };
                    let response = match packet {
                        ClientPacket::Leave { session, player, sequence } => {
                            let peer_state = clients.get(&peer).map(|(id, last, _)| (*id, *last));
                            if owned_session::may_leave(game.session, session, player, sequence, peer_state) {
                                if let Err(reason) = departures.record(peer) {
                                    let response = ServerPacket::Rejected { reason: reason.into() };
                                    let _ = socket.send_to(&serde_json::to_vec(&response)?, peer);
                                    continue;
                                }
                                clients.remove(&peer);
                                game.remove_player(player);
                                clock_delivery.remove(player);
                                println!("Player {player} left session {}", game.session);
                            }
                            continue;
                        }
                        ClientPacket::PauseRequest{sequence,paused}=>{
                            let Some((player,last,last_seen))=clients.get_mut(&peer) else{continue;};
                            *last_seen=Instant::now();if sequence<=*last{continue;}*last=sequence;
                            let outcome=if !allow_pause {Err("pause disabled by local match host")}
                              else if game.final_results().is_some(){Err("match already finished")}
                              else {pause.request(*player,paused,pause_epoch.elapsed(),&mut clock_delivery)};
                            match outcome{Ok(())=>continue,Err(reason)=>ServerPacket::Rejected{reason:reason.into()}}
                        }
                        ClientPacket::ClockAck{session,ordinal}=>{
                            if session==game.session {if let Some((player,_,last_seen))=clients.get_mut(&peer){
                                *last_seen=Instant::now();if let Err(error)=clock_delivery.acknowledge(*player,ordinal){eprintln!("Clock acknowledgment rejected: {error}");}
                            }}continue;
                        }
                        ClientPacket::Join {
                            champion,
                            summoners,
                        } => {
                            if let Some((player, _, last)) = clients.get_mut(&peer) {
                                *last = Instant::now();
                                ServerPacket::Welcome {
                                    player: *player,
                                    session: game.session,
                                }
                            } else if draining {
                                ServerPacket::Rejected { reason: "local session is closing".into() }
                            } else if let Err(reason) = departures.can_join(&peer, clients.len()) {
                                ServerPacket::Rejected { reason: reason.into() }
                            } else {
                                match game.join_with_summoners(&champion, summoners) {
                                    Ok(player) => {
                                        clients.insert(peer, (player, 0, Instant::now()));
                                        clock_delivery.register(player);
                                        pause.bootstrap(player,pause_epoch.elapsed(),&mut clock_delivery).map_err(std::io::Error::other)?;
                                        ServerPacket::Welcome {
                                            player,
                                            session: game.session,
                                        }
                                    }
                                    Err(reason) => ServerPacket::Rejected { reason },
                                }
                            }
                        }
                        ClientPacket::Command { sequence, action } => {
                            let Some((player, last, last_seen)) = clients.get_mut(&peer) else {
                                continue;
                            };
                            *last_seen = Instant::now();
                            if sequence <= *last {
                                continue;
                            }
                            *last = sequence;
                            match if pause.is_paused(){Err("match is paused".into())}else{game.command(*player, action)} {
                                Ok(()) => continue,
                                Err(reason) => ServerPacket::Rejected { reason },
                            }
                        }
                    };
                    let _ = socket.send_to(&serde_json::to_vec(&response)?, peer);
                }
                Err(e) if e.kind() == std::io::ErrorKind::WouldBlock => break,
                Err(e) if e.kind() == std::io::ErrorKind::ConnectionReset => continue,
                Err(e) => return Err(e.into()),
            }
        }
        let now = Instant::now();
        clients.retain(|_, (player, _, last)| {
            if now.duration_since(*last) > Duration::from_secs(30) {
                game.remove_player(*player);
                clock_delivery.remove(*player);
                false
            } else {
                true
            }
        });
        sessions.poll(pause_epoch.elapsed(),draining,&mut game,&mut clock_delivery)
            .map_err(std::io::Error::other)?;
        if pause.poll(pause_epoch.elapsed(),&mut clock_delivery).map_err(std::io::Error::other)? {next=Instant::now()+Duration::from_secs_f64(1./TICK_RATE as f64);}
        if now>=next_clock_delivery {
            next_clock_delivery=now+Duration::from_millis(100);
            for (peer,message) in sessions.clocks(&clock_delivery) {
                let _=socket.send_to(&serde_json::to_vec(&message)?,peer);
            }
            for (peer,(player,_,_)) in &clients {for event in clock_delivery.pending(*player){
                let message=ServerPacket::ClockControl{session:game.session,ordinal:event.ordinal,opcode:event.opcode,payload:event.payload.clone()};
                let _=socket.send_to(&serde_json::to_vec(&message)?,peer);
            }}
        }
        let mut catchup = 0;
        if pause.is_paused(){next=Instant::now()+Duration::from_secs_f64(1./TICK_RATE as f64);}
        while !pause.is_paused() && Instant::now() >= next && catchup < 5 {
            game.advance();
            next += Duration::from_secs_f64(1. / TICK_RATE as f64);
            catchup += 1;
        }
        if !result_saved && Instant::now()>=next_result_attempt {
            if let Some(result)=game.final_results() {
                match result_store::save(&root.join("runtime/matches"),result) {
                    Ok(path)=>{result_saved=true;println!("Match result saved: {}",path.display());}
                    Err(error)=>{eprintln!("Match result save failed: {error}");next_result_attempt=Instant::now()+Duration::from_secs(5);}
                }
            }
        }
        if owned_session::can_stop(draining, clients.len()+sessions.participants(), game.final_results().is_some(), result_saved) {
            println!("Owned local session {} closed; all peers departed and results settled", game.session);
            break;
        }
        if (catchup > 0 || pause.is_paused()) && Instant::now() >= next_snapshot {
            next_snapshot = Instant::now() + Duration::from_millis(100);
            for (peer,packets) in sessions.states(&game,&clock_delivery).map_err(std::io::Error::other)? {
                for packet in packets {let _=socket.send_to(&packet,peer);}
            }
            for (peer, (player, _, _)) in &clients {
                let Some(snapshot) = game.snapshot_for(*player) else {
                    continue;
                };
                let packets = openleague_core::wire::state_datagrams(&snapshot)?;
                for packet in &packets {
                    let _ = socket.send_to(packet, peer);
                }
            }
        }
        std::thread::sleep(Duration::from_millis(1));
    }
    if let Some(error) = owner_error { return Err(error.into()); }
    Ok(())
}
