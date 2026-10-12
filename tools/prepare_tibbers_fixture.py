from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/server/examples/tibbers_fixture.rs';p.parent.mkdir(exist_ok=True)
s=(r/'crates/server/src/main.rs').read_text(encoding='utf-8');s='//! Diagnostic UDP fixture: seeds level6 and positions at join. Not an ordinary match proof.\n'+s
s=s.replace('127.0.0.1:5896','127.0.0.1:5964').replace('println!("OpenLeague server on','println!("DIAGNOSTIC level6 fixture on')
old='''                                    Ok(player) => {
                                        clients.insert'''
new='''                                    Ok(player) => {
                                        game.award_experience(player,2525.).map_err(std::io::Error::other)?;
                                        let seed=openleague_core::Point{x:7700.-if game.players[&player].team==0 {100.} else {0.},z:7000.};
                                        let point=game.navigation.nearest_walkable(seed).ok_or("fixture point unavailable")?;
                                        game.players.get_mut(&player).unwrap().position=point;
                                        clients.insert'''
assert old in s;s=s.replace(old,new,1);p.write_text(s,encoding='utf-8');print('Created separate diagnostic UDP example; production server source unchanged')
