use super::*;
fn game(enabled:bool)->(Simulation,u32,u32) {
    let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=u64::MAX-7;s.enable_map10().unwrap();s.units.clear();
    if enabled {s.enable_map10_cast_ground().unwrap();}
    let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for id in [a,b] {let p=s.players.get_mut(&id).unwrap();p.health=10000.;p.max_health=10000.;}
    let p=s.players.get_mut(&a).unwrap();p.level=2;p.ranks[1]=1;p.mana=2000.;
    s.ezreal_w.session=Some(s.session);s.ezreal_w.next_ordinal=(1u64<<53)+7;(s,a,b)
}
fn cast(s:&mut Simulation,a:u32) {let p=s.players[&a].position;
    s.command(a,Action::CastAt{slot:1,point:Point{x:p.x+1000.,z:p.z}}).unwrap();}
fn until(s:&mut Simulation,t:u64) {while s.tick<t {s.tick+=1;s.advance_ezreal_w();}}
fn rows(s:&Simulation,viewer:u32)->Vec<crate::ezreal_w_projectile_view::Row> {
    s.ezreal_w_current_projection(viewer).map(|v|crate::ezreal_w_projectile_view::decode(&v).unwrap()).unwrap_or_default()
}
#[test]
fn atomic_current_xyz_matches_real_dense_samples_and_never_changes_gameplay() {
    let(mut s,a,b)=game(true);cast(&mut s,a);assert!(rows(&s,a).is_empty());until(&mut s,8);
    let before=format!("{:?}|{:?}",s.players,s.ezreal_w);
    let first=rows(&s,a);assert_eq!(first.len(),1);
    assert_eq!(first[0].y_native.to_bits(),s.map10_cast_ground.unwrap()
        .sample_local_f32([first[0].position.x,first[0].position.z]).unwrap().to_bits());
    assert_eq!(format!("{:?}|{:?}",s.players,s.ezreal_w),before);
    assert!(s.snapshot().ezreal_w_current_missiles.is_none());
    assert!(s.snapshot_for(a).unwrap().ezreal_w_current_missiles.is_none());
    let snap=s.snapshot_for_atomic(a).unwrap();let wire=serde_json::to_vec(&snap).unwrap();
    let snap:Snapshot=serde_json::from_slice(&wire).unwrap();
    assert_eq!(snap.session,u64::MAX-7);assert_eq!(crate::ezreal_w_projectile_view::decode(snap.ezreal_w_current_missiles.as_ref().unwrap()).unwrap()[0].ordinal,(1u64<<53)+7);
    until(&mut s,9);let current=s.ezreal_w.flights[0].shot.view().position;
    s.players.get_mut(&b).unwrap().position=current;
    assert_ne!(rows(&s,b)[0].position,first[0].position);
    s.players.get_mut(&a).unwrap().health=0.;assert_eq!(rows(&s,b).len(),1);
    s.players.get_mut(&b).unwrap().position=Point{x:14321.,z:7235.};assert!(rows(&s,b).is_empty());
    s.players.get_mut(&b).unwrap().position=current;assert_eq!(rows(&s,b)[0].position,current);
    s.winner=Some(0);assert!(rows(&s,b).is_empty());
}
#[test]
fn unavailable_context_stale_tick_bad_census_and_departure_never_publish_fallback() {
    let(mut s,a,_)=game(false);cast(&mut s,a);until(&mut s,8);assert!(rows(&s,a).is_empty());
    assert!(s.enable_map10_cast_ground().is_err()); // public context is startup-only
    let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);assert_eq!(rows(&s,a).len(),1);
    s.tick+=1;assert!(rows(&s,a).is_empty());s.tick-=1;
    s.ezreal_w.flights[0].direction.x=f32::NAN;assert!(rows(&s,a).is_empty());
    let(mut s,a,b)=game(true);cast(&mut s,a);until(&mut s,8);
    s.ezreal_w.next_ordinal=s.ezreal_w.flights[0].shot.view().identity.ordinal;assert!(rows(&s,a).is_empty());
    s.remove_player(a);assert!(rows(&s,b).is_empty());
}
#[test]
fn disabled_projection_and_repeated_queries_preserve_damage_buffs_and_flight_expiry() {
    let(mut a,owner,_)=game(false);let(mut b,owner_b,_)=game(true);assert_eq!(owner,owner_b);
    cast(&mut a,owner);cast(&mut b,owner);
    for tick in 1..=30 {
        until(&mut a,tick);until(&mut b,tick);
        for _ in 0..3 {let _=b.snapshot_for_atomic(owner);}
        assert_eq!(format!("{:?}|{:?}",a.players,a.ezreal_w),format!("{:?}|{:?}",b.players,b.ezreal_w));
    }
    assert!(rows(&b,owner).is_empty());
}

#[test]
fn complete_census_duplicates_capacity_and_outside_dense_domain_never_emit_partial_rows(){
    let(mut s,a,_)=game(true);cast(&mut s,a);until(&mut s,8);
    let first=s.ezreal_w.flights.remove(0);let start=first.shot.view().position;
    let base=first.shot.view().identity.ordinal;
    let make=|ordinal:u64,origin:Point| {
        let id=Identity{session:s.session,owner:a,team:0,ordinal};
        let shot=Shot::new(id,origin,Point{x:origin.x+1000.,z:origin.z},Params{speed_units_per_second:SPEED,
            tick_rate:TICK_RATE as u32,max_distance:RANGE,projectile_radius:RADIUS,launch_tick:8,expires_at_tick:28,
            mode:Mode::Pierce,limits:Limits{targets_per_step:MAX_TARGETS,unique_hits:MAX_TARGETS}}).unwrap();
        Flight{shot,raw:70.,rank:1,origin,initial_owner_radius:first.initial_owner_radius,self_armed:false,direction:Point{x:1.,z:0.}}
    };
    let mut flights:Vec<_>=(0..MAX_CASTS).map(|i|make(base+i as u64,start)).collect();
    let overflow=make(base+MAX_CASTS as u64,start);let duplicate=make(base,start);
    let outside=make(base,Point{x:-1000.,z:start.z});
    s.ezreal_w.next_ordinal=base+MAX_CASTS as u64+1;s.ezreal_w.flights=std::mem::take(&mut flights);
    assert_eq!(rows(&s,a).len(),64);s.ezreal_w.flights.push(overflow);assert!(rows(&s,a).is_empty());
    s.ezreal_w.flights.pop();s.ezreal_w.flights[63]=duplicate;assert!(rows(&s,a).is_empty());
    // Even with FoW disabled for this narrow fixture, dense out-of-domain stays unavailable.
    s.interactions=None;s.ezreal_w.flights=vec![outside];assert!(rows(&s,a).is_empty());
}
