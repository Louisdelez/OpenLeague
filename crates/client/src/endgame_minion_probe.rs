//! Opt-in observation only. Never changes visibility, clock, snapshot or gameplay.
//! CPU inherited/view visibility is not proof of draw submission or final pixels.
use bevy::prelude::*;

#[derive(Resource,Default)]
struct Journal {next:f64,frames:u64,errors:u64,path:Option<std::path::PathBuf>,enabled:bool}

fn setup(mut journal:ResMut<Journal>){
 let Some(raw)=std::env::var_os("OPENLEAGUE_ENDGAME_MINION_PROBE")else{return;};let path=std::path::PathBuf::from(raw);
 if !path.is_absolute()||!(path.starts_with("E:/mapslol3v3")||path.starts_with("E:/OpenLeague/logs"))||path.components().any(|p|matches!(p,std::path::Component::ParentDir)) {
  warn!("Endgame minion observation requires a fresh path inside scratch or OpenLeague/logs");return;
 }
 match std::fs::OpenOptions::new().write(true).create_new(true).open(&path){Ok(_)=>{journal.path=Some(path);journal.enabled=true;},Err(error)=>warn!("Endgame minion fresh observation path unavailable: {error}")}
}

pub fn observe(world:&mut World) {
 let now=world.get_resource::<Time>().map(|t|t.elapsed_secs_f64()).unwrap_or(0.);
 let mut journal=world.remove_resource::<Journal>().unwrap_or_default();
 if !journal.enabled{world.insert_resource(journal);return;}
 let path=journal.path.clone().expect("enabled fresh journal path");
 if now<journal.next{world.insert_resource(journal);return;}
 journal.next=now+0.1;journal.frames+=1;
 let selected=(|| {
  let identity=world.get_resource::<crate::Connection>()?.inventory_input_identity()?;
  let state=world.get_resource::<crate::Match>()?;let snapshot=state.snapshot.as_ref()?;let result=snapshot.result.as_ref()?;
  if result.winner>1||result.session!=identity.0||snapshot.session!=identity.0||snapshot.winner!=Some(result.winner)
   ||!result.players.iter().any(|p|p.id==identity.1){return None;}
  let age=world.get_resource::<crate::endgame_timeline::Clock>()?.age(now)?;
  let roots:Vec<_>=snapshot.units.iter().filter(|u|u.kind.lane()).map(|u|(
   u.id,u.team,u.definition.clone(),u.health,state.visuals.get(&u.id).copied())).collect();
  Some((result.session,result.ended_tick,result.winner,identity.1,age,roots))
 })();
 if let Some((session,ended_tick,winner,local,age,roots))=selected {
  let mut rows=Vec::new();
  let mut missing=0;
  let mut loser_loaded=0;
  let mut loser_root_hidden=0;
  let mut loser_visible_meshes=0;
  for (id,team,definition,health,root) in roots {
   let Some(root)=root else{missing+=1;rows.push(serde_json::json!({"id":id,"team":team,"definition":definition,"root":null}));continue;};
   let playback=world.get::<crate::animation::Playback>(root);
   let owned=playback.is_some_and(|p|p.network_id()==id&&p.model_name().eq_ignore_ascii_case(&definition))
    &&world.get::<crate::actor_fow::Root>(root).is_some()&&world.get::<ChildOf>(root).is_none();
   let visibility=world.get::<Visibility>(root).copied();
   let inherited=world.get::<InheritedVisibility>(root).map(|v|v.get());
   let view=world.get::<ViewVisibility>(root).map(|v|v.get());
   let mut descendants=Vec::new();let mut queue=vec![root];let mut examined=std::collections::HashSet::new();
   let mut overflow=false;
   while let Some(entity)=queue.pop(){
    if !examined.insert(entity){continue;}
    if examined.len()>2048{overflow=true;break;}
    if let Some(children)=world.get::<Children>(entity){queue.extend(children.iter());}
    if let Some(mesh)=world.get::<Mesh3d>(entity){
     let effective=world.get::<InheritedVisibility>(entity).map(|v|v.get());
     let in_view=world.get::<ViewVisibility>(entity).map(|v|v.get());
     if team==1-winner && owned && (effective==Some(true)||in_view==Some(true)){loser_visible_meshes+=1;}
     descendants.push(serde_json::json!({"entity":format!("{entity:?}"),"mesh":format!("{:?}",mesh.0.id()),
      "visibility":world.get::<Visibility>(entity).map(|v|format!("{v:?}")),"inherited_visible":effective,"view_visible":in_view}));
    }
   }
   if team==1-winner&&owned{
    loser_loaded+=1;if visibility==Some(Visibility::Hidden){loser_root_hidden+=1;}
   }
   rows.push(serde_json::json!({"id":id,"team":team,"definition":definition,"health":health,"root":format!("{root:?}"),
    "owned":owned,"loaded_model":playback.map(|p|p.model_name()),"model_asset_id":playback.map(|p|format!("{:?}",p.model_asset_id())),
    "root_visibility":visibility.map(|v|format!("{v:?}")),"root_inherited_visible":inherited,"root_view_visible":view,
    "mesh_descendants":descendants,"traversal_overflow":overflow}));
  }
  let deadline=crate::endgame_timeline::schedule().skin+crate::endgame_timeline::schedule().minion_fade;
  let errors=world.get_resource::<crate::endgame_minion_no_render::Host>().map(|h|h.issues.clone()).unwrap_or_else(||vec!["actual no-render Host unavailable".into()]);
  let row=serde_json::json!({"schema":1,"session":session,"ended_tick":ended_tick,"winner":winner,"local_player":local,
   "age":age,"native_no_render_deadline":deadline,"due":age>=deadline,"local_time":now,"probe_frames":journal.frames,
   "scheduled_after":"VisibilitySystems::CheckVisibility","missing_roots":missing,"loser_owned_loaded_roots":loser_loaded,
   "loser_hidden_roots":loser_root_hidden,"loser_effective_visible_meshes":loser_visible_meshes,"host_issues":errors,"roots":rows,
   "draw_submission_qualified":false,"pixels_qualified":false});
  use std::io::Write;
  let written=(||->std::io::Result<()>{let mut f=std::fs::OpenOptions::new().create(true).append(true).open(path)?;writeln!(f,"{row}")})();
  if let Err(error)=written{journal.errors+=1;if journal.errors==1{warn!("Endgame minion observation write failed: {error}");}}
 }
 world.insert_resource(journal);
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){app.init_resource::<Journal>().add_systems(Startup,setup).add_systems(PostUpdate,observe.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));}
}
