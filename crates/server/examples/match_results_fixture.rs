//! Diagnostic terminal snapshot for framebuffer verification, not a real match victory.
use openleague_core::{Navigation,Simulation,ClientPacket,ServerPacket};
use std::{fs,net::UdpSocket,time::{Instant,Duration},path::PathBuf};
fn main()->Result<(),Box<dyn std::error::Error>> {
 let root=PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
 let nav=Navigation::load(&fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json"))?,&fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin"))?).map_err(std::io::Error::other)?;
 let mut game=Simulation::new(nav).map_err(std::io::Error::other)?;game.enable_map10().map_err(std::io::Error::other)?;game.session=420_700;
 for _ in 0..6 {game.join("garen").map_err(std::io::Error::other)?;}
 let player=game.players.values().find(|p|p.team==0).unwrap().id;
 game.tick=36_900;game.winner=Some(0);game.advance();
 let snapshot=game.snapshot_for(player).ok_or("snapshot")?;let packets=openleague_core::wire::state_datagrams(&snapshot)?;
 let socket=UdpSocket::bind(std::env::var("OPENLEAGUE_SERVER")?)?;socket.set_nonblocking(true)?;
 let mut buffer=[0u8;4096];let mut peer=None;let mut next=Instant::now();
 println!("DIAGNOSTIC terminal result fixture; winner injected; no ordinary victory qualification");
 loop {
  match socket.recv_from(&mut buffer) {
   Ok((n,address))=>if matches!(serde_json::from_slice::<ClientPacket>(&buffer[..n]),Ok(ClientPacket::Join{..})){peer=Some(address);socket.send_to(&serde_json::to_vec(&ServerPacket::Welcome{player,session:game.session})?,address)?;},
   Err(error) if matches!(error.kind(),std::io::ErrorKind::WouldBlock|std::io::ErrorKind::ConnectionReset)=>{},Err(error)=>return Err(error.into())
  }
  if Instant::now()>=next {if let Some(peer)=peer {for packet in &packets{socket.send_to(packet,peer)?;}}next=Instant::now()+Duration::from_millis(100);}
  std::thread::sleep(Duration::from_millis(1));
 }
}
