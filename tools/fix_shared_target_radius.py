from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/core/src/annie_w.rs'
s=p.read_text(encoding='utf-8')
old='''/// Community loader defaults; never replace the optional native profile value.
pub(crate) fn body_radius(native:Option<f32>)->f32 {
 let loaded=native.unwrap_or(65.);
 if loaded>0. {loaded} else {40.}
}'''
assert old in s
s=s.replace(old,'pub(crate) use crate::collision::body_radius;')
p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/collision.rs'
s=p.read_text(encoding='utf-8')
needle='#[derive(Deserialize)]\nstruct UnitProfile'
assert needle in s
s=s.replace(needle,'''/// Community loader defaults; the original optional native field remains unchanged.
/// These are gameplay body radii, not selection or pathfinding radii.
pub(crate) fn body_radius(native: Option<f32>) -> f32 {
    let loaded = native.unwrap_or(65.);
    if loaded > 0. { loaded } else { 40. }
}

'''+needle)
p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/world.rs'
s=p.read_text(encoding='utf-8')
old='''team: p.team,
                radius: 0.,'''
assert old in s
s=s.replace(old,'''team: p.team,
                radius: collision::body_radius(collision::profile(&p.champion).gameplay_radius),''',1)
p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/annie_r_tests.rs'
with p.open('a',encoding='utf-8') as f:
 f.write('''
#[test]
fn pet_attack_range_uses_champion_body_and_preserves_native_radius_fields() {
 for (distance, attacks) in [(189.,true),(190.,true),(191.,false)] {
  let(mut s,a,b,point)=game();let pet=summon(&mut s,a,point);
  s.players.get_mut(&b).unwrap().position=Point{x:point.x+distance,z:point.z};
  s.units.get_mut(&pet).unwrap().pet.as_mut().unwrap().order=Order::Attack{target:b};
  assert_eq!(s.target_info(b).unwrap().radius,65.);
  assert_eq!(collision::profile("garen").gameplay_radius,None);
  s.advance_pet_orders();s.advance_world();
  assert_eq!(s.units[&pet].next_attack>0,attacks,"distance {distance}");
  if attacks {assert_eq!(s.units[&pet].position,point);}
 }
 let(mut s,a,b,point)=game();s.players.get_mut(&b).unwrap().champion="annie".into();
 assert_eq!(s.target_info(b).unwrap().radius,55.);
 let pet=summon(&mut s,a,point);
 s.players.get_mut(&b).unwrap().position=Point{x:point.x+181.,z:point.z};
 s.units.get_mut(&pet).unwrap().pet.as_mut().unwrap().order=Order::Attack{target:b};
 s.advance_pet_orders();s.advance_world();assert_eq!(s.units[&pet].next_attack,0);
}
''')
