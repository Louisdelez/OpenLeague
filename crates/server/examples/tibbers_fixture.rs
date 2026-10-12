//! Diagnostic UDP fixture: seeds level6 and positions at join. Not an ordinary match proof.
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
    let mut game = Simulation::new(navigation).map_err(std::io::Error::other)?;
    game.enable_map10().map_err(std::io::Error::other)?;
    game.session = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)?
        .as_nanos() as u64;
    let address = std::env::var("OPENLEAGUE_SERVER").unwrap_or_else(|_| "127.0.0.1:5964".into());
    let socket = UdpSocket::bind(&address)?;
    socket.set_nonblocking(true)?;
    println!("DIAGNOSTIC level6 fixture on {address}, 122 champion definitions, {TICK_RATE} Hz");
    let mut clients: HashMap<SocketAddr, (u32, u64, Instant)> = HashMap::new();
    let mut buffer = [0u8; 4096];
    let mut next = Instant::now();
    let mut next_snapshot = Instant::now();
    loop {
        loop {
            match socket.recv_from(&mut buffer) {
                Ok((n, peer)) => {
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
                        ClientPacket::Leave { .. } => ServerPacket::Rejected { reason: "departure unsupported by this diagnostic fixture".into() },
                        ClientPacket::PauseRequest{..}=>ServerPacket::Rejected{reason:"pause unsupported by this diagnostic fixture".into()},
                        ClientPacket::ClockAck{..}=>continue,
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
                            } else {
                                match game.join_with_summoners(&champion, summoners) {
                                    Ok(player) => {
                                        game.award_experience(player,2525.).map_err(std::io::Error::other)?;
                                        let seed=openleague_core::Point{x:7700.-if game.players[&player].team==0 {100.} else {0.},z:7000.};
                                        let point=game.navigation.nearest_walkable(seed).ok_or("fixture point unavailable")?;
                                        game.players.get_mut(&player).unwrap().position=point;
                                        clients.insert(peer, (player, 0, Instant::now()));
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
                            match game.command(*player, action) {
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
                game.players.remove(player);
                false
            } else {
                true
            }
        });
        let mut catchup = 0;
        while Instant::now() >= next && catchup < 5 {
            game.advance();
            next += Duration::from_secs_f64(1. / TICK_RATE as f64);
            catchup += 1;
        }
        if catchup > 0 && Instant::now() >= next_snapshot {
            next_snapshot = Instant::now() + Duration::from_millis(100);
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
}
