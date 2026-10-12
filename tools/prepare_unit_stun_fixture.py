from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'crates/server/examples/tibbers_fixture.rs').read_text(encoding='utf-8');s='//! Diagnostic pet stun event injected by this example only; no production spell producer implied.\n'+s
s=s.replace('    let mut next = Instant::now();','    let mut stunned_pets=std::collections::HashSet::new();\n    let mut next = Instant::now();',1)
s=s.replace('            game.advance();','''            game.advance();
            let pets:Vec<_>=game.units.values().filter(|u|u.pet.is_some()&&u.health>0.).map(|u|u.id).collect();
            for id in pets {if stunned_pets.insert(id) {game.grant_stun(None,id,"diagnostic_npc_stun",60).map_err(std::io::Error::other)?;}}
''',1)
s=s.replace('127.0.0.1:5964','127.0.0.1:5972');(r/'crates/server/examples/unit_stun_fixture.rs').write_text(s,encoding='utf-8');print('Prepared separate NPC stun diagnostic fixture; production packet authority unchanged')
