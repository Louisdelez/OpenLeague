from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/structure_animation_clock.rs';s=p.read_text();assert 'pub fn clamp_finished' not in s
s=s.replace('struct Clock {speed:f32,repeat:bool}','struct Clock {speed:f32,repeat:bool,gltf_endpoint:f32}')
s+='''
/// Native one-shot nodes retain the final frame after their update returns false.
pub fn clamp_finished(model:&str,role:&str,active:&mut bevy::animation::ActiveAnimation) {
 if !active.is_finished(){return;}
 if let Some(clock)=catalog().models.get(model).and_then(|m|m.get(role)) {
  if !clock.repeat {active.seek_to(clock.gltf_endpoint);}
 }
}
''';p.write_text(s)
p=r/'crates/client/src/animation.rs';s=p.read_text();s+='''
pub fn synchronize_finished_structure_clocks(mut actors:Query<(&mut AnimationPlayer,&Actor)>) {
 for (mut player,actor) in &mut actors {
  for (_,active) in player.playing_animations_mut() {
   crate::structure_animation_clock::clamp_finished(&actor.playback.model_name,&actor.role,active);
  }
 }
}
''';p.write_text(s)
p=r/'crates/client/src/main.rs';s=p.read_text();old='.add_systems(PostUpdate, animation::destruction_probe.after(bevy::animation::animate_targets))';assert old in s
s=s.replace(old,'.add_systems(PostUpdate, animation::synchronize_finished_structure_clocks.after(bevy::animation::advance_animations).before(bevy::animation::animate_targets))\n        '+old);p.write_text(s)
print('Finished native one-shot frame retained before target evaluation.')
