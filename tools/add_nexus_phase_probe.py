from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/nexus_ceremony.rs';s=p.read_text(encoding='utf-8');assert 'pub fn probe(' not in s
s+=r'''
/// Readonly, explicitly enabled diagnostic of the live root and loaded GLTF model.
pub fn probe(state:Res<Match>,clock:Res<endgame_timeline::Clock>,time:Res<Time>,roots:Query<&animation::Playback>,mut previous:Local<f64>) {
 let Ok(path)=std::env::var("OPENLEAGUE_NEXUS_SKIN_PROBE") else{return};
 let now=time.elapsed_secs_f64();if now-*previous<0.1{return;}*previous=now;
 let Some(result)=state.snapshot.as_ref().and_then(|s|s.result.as_ref()) else{return};
 let Some(nexus)=result.destroyed_nexus.as_ref() else{return};
 let entity=state.visuals.get(&nexus.id).copied();
 let row=serde_json::json!({"age":clock.age(now),"now":now,"id":nexus.id,"destroyed":state.destroyed_structures.get(&nexus.id),"entity":entity.map(|e|format!("{e:?}")),"loaded_model":entity.and_then(|e|roots.get(e).ok()).map(|p|p.model_name()),"tick":state.snapshot.as_ref().map(|s|s.tick)});
 use std::io::Write;if let Ok(mut f)=std::fs::OpenOptions::new().create(true).append(true).open(path){let _=writeln!(f,"{row}");}
}
'''
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');needle='        .add_systems(Update, nexus_ceremony::update.after(endgame_timeline::update).before(animation::load_models).before(animation::animate))';assert needle in s;s=s.replace(needle,needle+'\n        .add_systems(Update, nexus_ceremony::probe.after(nexus_ceremony::update).after(animation::load_models).before(render_probe::capture))');p.write_text(s,encoding='utf-8')
print('Readonly native nexus phase observer added')
