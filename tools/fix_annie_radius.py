from pathlib import Path
root=Path('E:/OpenLeague')
p=root/'crates/core/src/annie_w.rs'
s=p.read_text(encoding='utf-8')
old='''    // Missing native body radius stays absent in profiles. Only this cone uses
    // the supplied community ObjAIBase fallback40, explicitly reconstructed.
    (p.id,p.position,collision::profile(&p.champion).gameplay_radius.unwrap_or(40.))'''
new='''    // Missing native radius remains absent in profiles. Community CharData
    // loads absent values as65; ObjAIBase uses40 only for nonpositive values.
    // This cone policy is reconstructed, not recovered Riot server behavior.
    (p.id,p.position,body_radius(collision::profile(&p.champion).gameplay_radius))'''
assert old in s
s=s.replace(old,new)
marker='impl Simulation {'
helper='''/// Community loader defaults; never replace the optional native profile value.
fn body_radius(native:Option<f32>)->f32 {
 let loaded=native.unwrap_or(65.);
 if loaded>0. {loaded} else {40.}
}
'''
s=s.replace(marker,helper+marker,1)
marker=' #[test] fn invalid_geometry_and_ground_cast_guards_are_atomic() {'
test=''' #[test] fn community_radius_default_affects_cone_contact_without_mutating_native_profiles() {
  assert_eq!(body_radius(None),65.);assert_eq!(body_radius(Some(0.)),40.);assert_eq!(body_radius(Some(-1.)),40.);assert_eq!(body_radius(Some(55.)),55.);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  assert_eq!(collision::profile("annie").gameplay_radius,Some(55.));
  let(mut s,a,b)=game();let enemy_annie=s.join("annie").unwrap();
  // Fourth join is enemy team1; third join above is allied and not used.
  let enemy_annie2=s.join("annie").unwrap();assert_ne!(s.players[&a].team,s.players[&enemy_annie2].team);
  let angle=(value("half_angle")+7.).to_radians();let center=Point{x:100.+500.*angle.cos(),z:100.+500.*angle.sin()};
  s.players.get_mut(&b).unwrap().position=center;s.players.get_mut(&enemy_annie2).unwrap().position=center;
  let garen_hp=s.players[&b].health;let annie_hp=s.players[&enemy_annie2].health;
  assert!(!intersects(s.players[&a].position,Point{x:1.,z:0.},center,40.,625.,value("half_angle")));
  s.cast_at(a,1,aim()).unwrap();s.tick=8;s.advance_annie_w();
  assert!(s.players[&b].health<garen_hp);assert_eq!(s.players[&enemy_annie2].health,annie_hp);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  assert_eq!(s.players[&enemy_annie].team,s.players[&a].team);
 }
'''
assert marker in s
p.write_text(s.replace(marker,test+marker,1),encoding='utf-8')
print('Corrected missing-radius cone contact and added regression check')
