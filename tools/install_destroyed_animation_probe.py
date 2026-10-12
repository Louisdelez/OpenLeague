from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/animation.rs';s=p.read_text(encoding='utf-8');assert 'pub fn destruction_probe(' not in s
s+='''
/// Optional observation of actual AnimationPlayers; never alters gameplay or playback.
pub fn destruction_probe(time: Res<Time>, state: Res<Match>, actors: Query<(&AnimationPlayer, &Actor)>, mut last: Local<f32>) {
    let Ok(path)=std::env::var("OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE") else {return;};
    if time.elapsed_secs()-*last<0.2 {return;}
    *last=time.elapsed_secs();
    let rows:Vec<_>=actors.iter().filter(|(_,a)|a.playback.model_name.contains("Turret")||a.playback.model_name.contains("Inhibitor")||a.playback.model_name.contains("Nexus")).map(|(player,actor)| {
        let clips:Vec<_>=player.playing_animations().map(|(_,a)|serde_json::json!({"elapsed":a.elapsed(),"seek_time":a.seek_time(),"completions":a.completions(),"finished":a.is_finished()})).collect();
        serde_json::json!({"id":actor.playback.id,"model":actor.playback.model_name,"role":actor.role,"active_clips":clips})
    }).collect();
    if rows.is_empty() {return;}
    let record=serde_json::json!({"time":time.elapsed_secs(),"tick":state.snapshot.as_ref().map(|s|s.tick),"actors":rows});
    use std::io::Write;
    if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path) {let _=writeln!(file,"{record}");}
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');needle='.add_systems(Update, grass_live_registry::update';assert needle in s
s=s.replace(needle,'.add_systems(PostUpdate, animation::destruction_probe.after(bevy::animation::advance_animations))\n        '+needle);p.write_text(s,encoding='utf-8')
s=(r/'crates/server/examples/annie_ready_fixture.rs').read_text(encoding='utf-8')
s=s.replace('//! Diagnostic visual fixture: seeds level6, center positions and Annie readiness. Not ordinary progression.','//! Diagnostic visual fixture: authored model identity, relocated structures and outgoing health transition. Does not qualify ordinary combat destruction.')
s=s.replace('let Some(snapshot) = game.snapshot_for(*player)', 'let Some(mut snapshot) = game.snapshot_for(*player)')
needle='let packets = openleague_core::wire::state_datagrams(&snapshot)?;'
replace='''// Explicit diagnostic: expose four real structure identities next to the focus.
                let wanted=["TT_OrderTurret1","OrderNexus","TT_OrderInhibitor","TT_ChaosInhibitor"];
                let mut selected=Vec::new();
                for (i,name) in wanted.iter().enumerate() {
                    if let Some(source)=game.units.values().find(|u|u.definition==*name) {
                        let mut unit=source.clone();
                        unit.position=openleague_core::Point{x:7500.+(i%2) as f32*650.,z:6800.+(i/2) as f32*650.};
                        unit.height=game.players[player].height;
                        unit.health=if game.tick>=450 {0.} else {unit.max_health};
                        unit.team=0;unit.target=None;unit.destination=None;
                        selected.push(unit);
                    }
                }
                snapshot.units=selected;
                let packets = openleague_core::wire::state_datagrams(&snapshot)?;'''
assert needle in s;s=s.replace(needle,replace);(r/'crates/server/examples/destroyed_animation_fixture.rs').write_text(s,encoding='utf-8')
print('Installed optional AnimationPlayer observer and explicit UDP destruction render fixture.')
