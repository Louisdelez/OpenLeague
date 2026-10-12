from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_endgame_ui.rs';s=p.read_text(encoding='utf-8');assert 'pub fn phase_probe' not in s
s+='''
/// Opt-in observation of actual UI state and native deadlines. Disabled during ordinary play.
pub fn phase_probe(state:Res<Match>,time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,view:Res<View>,roots:Query<&Node,With<Splash>>,mut next:Local<f64>){
 if std::env::var("OPENLEAGUE_ENDGAME_PHASE_PROBE").as_deref()!=Ok("1"){return;}
 let Some(result)=state.snapshot.as_ref().and_then(|s|s.result.as_ref()) else{return;};let now=time.elapsed_secs_f64();if now<*next{return;}*next=now+0.1;
 let record=serde_json::json!({"session":result.session,"ended_tick":result.ended_tick,"local_time":now,"age":clock.age(now),"native_scoreboard_deadline":crate::endgame_timeline::schedule().scoreboard(),"due":clock.scoreboard_due(now),"dismissed":view.dismissed,"splash_visible":roots.iter().any(|n|n.display==Display::Flex)});
 use std::io::Write;let path=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../logs/endgame-timeline-runtime.jsonl");let mut file=std::fs::OpenOptions::new().create(true).append(true).open(path).expect("diagnostic phase log");writeln!(file,"{record}").expect("diagnostic phase record");
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');needle='.add_systems(Update, native_endgame_ui::update.after(receive).before(match_results_ui::update))';assert needle in s;s=s.replace(needle,needle+'\n        .add_systems(Update, native_endgame_ui::phase_probe.after(native_endgame_ui::update).before(render_probe::capture))',1);p.write_text(s,encoding='utf-8')
print('actual native phase/UI diagnostic observer integrated')
