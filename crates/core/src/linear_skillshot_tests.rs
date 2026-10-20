//! SOURCE tests only: not executed or compiled during preparation.
use super::*;

fn point(x: f32, z: f32) -> Point { Point { x, z } }
fn identity() -> Identity { Identity { session: 0, owner: 1, team: 0, ordinal: 1 } }
fn params(mode: Mode) -> Params {
    Params { speed_units_per_second: 100., tick_rate: 10, max_distance: 100., projectile_radius: 0.,
        launch_tick: 0, expires_at_tick: 100, mode, limits: Limits { targets_per_step: 16, unique_hits: 16 } }
}
fn circle(id: u32, x: f32, z: f32, radius: f32) -> Circle { Circle { id, center: point(x, z), radius } }
fn shot(p: Params) -> Shot { Shot::new(identity(), point(0., 0.), point(100., 0.), p).unwrap() }
fn close(a: f64, b: f64) { assert!((a-b).abs() < 0.000001, "{a} != {b}"); }

#[test]
fn speed_tick_rate_and_final_range_budget_are_independent_of_aim_length() {
    let mut p = params(Mode::Pierce);p.speed_units_per_second=30.;p.tick_rate=30;p.max_distance=2.5;
    let mut a=shot(p);let mut b=Shot::new(identity(),point(0.,0.),point(1.,0.),p).unwrap();
    for (tick,expected) in [(1,1.),(2,2.),(3,2.5)] {
        let left=a.advance(identity(),tick,&[]).unwrap();let right=b.advance(identity(),tick,&[]).unwrap();
        assert_eq!(left,right);close(left.total_distance,expected);close(f64::from(left.to.x),expected);
    }
    assert_eq!(a.view().phase,Phase::Ended(End::RangeExhausted));
    assert_eq!(a.advance(identity(),4,&[]),Err(Error::AlreadyEnded));
}

#[test]
fn diagonal_and_negative_direction_use_distance_not_axis_or_aim_range() {
    let mut p=params(Mode::Pierce);p.max_distance=5.;
    let mut s=Shot::new(identity(),point(10.,10.),point(7.,6.),p).unwrap();
    let step=s.advance(identity(),1,&[]).unwrap();assert_eq!(step.to,point(7.,6.));close(step.total_distance,5.);
}

#[test]
fn fast_segment_hits_circle_between_endpoints_and_stops_at_first_contact() {
    let mut s=shot(params(Mode::FirstContact));
    let step=s.advance(identity(),1,&[circle(2,5.,0.,1.)]).unwrap();
    assert_eq!(step.to,point(4.,0.));close(step.moved_distance,4.);
    assert_eq!(step.contacts.len(),1);assert_eq!(step.contacts[0].id,2);
    assert_eq!(step.phase,Phase::Ended(End::FirstContact));
}

#[test]
fn first_contact_is_sorted_by_entry_distance_then_id_not_input_or_center_order() {
    let candidates=[circle(8,8.,0.,5.),circle(9,5.,0.,1.),circle(7,4.,0.,1.)];
    let mut a=shot(params(Mode::FirstContact));let mut b=shot(params(Mode::FirstContact));
    let left=a.advance(identity(),1,&candidates).unwrap();
    let right=b.advance(identity(),1,&[candidates[2],candidates[0],candidates[1]]).unwrap();
    assert_eq!(left,right);assert_eq!(left.contacts[0].id,7);close(left.moved_distance,3.);
}

#[test]
fn pierce_orders_multiple_contacts_and_suppresses_same_id_on_later_ticks() {
    let mut s=shot(params(Mode::Pierce));
    let first=s.advance(identity(),1,&[circle(9,8.,0.,1.),circle(2,2.,0.,1.)]).unwrap();
    assert_eq!(first.contacts.iter().map(|c|(c.id,c.ordinal)).collect::<Vec<_>>(),[(2,1),(9,2)]);
    assert_eq!(first.to,point(10.,0.));
    let second=s.advance(identity(),2,&[circle(9,15.,0.,4.),circle(2,11.,0.,5.),circle(3,18.,0.,1.)]).unwrap();
    assert_eq!(second.contacts.iter().map(|c|(c.id,c.ordinal)).collect::<Vec<_>>(),[(3,3)]);
    close(second.contacts[0].total_distance,17.);assert_eq!(s.view().unique_hits,3);
}

#[test]
fn projectile_radius_closed_tangent_and_point_target_have_declared_geometry() {
    let mut p=params(Mode::Pierce);p.projectile_radius=1.;
    let mut s=shot(p);let result=s.advance(identity(),1,&[circle(2,5.,2.,1.),circle(3,6.,2.01,1.),circle(4,8.,0.,0.)]).unwrap();
    assert_eq!(result.contacts.iter().map(|c|c.id).collect::<Vec<_>>(),[2,4]);
    close(result.contacts[0].step_distance,5.);close(result.contacts[1].step_distance,7.);
}

#[test]
fn original_direction_keeps_diagonal_tangencies_and_rejects_near_outside_circles() {
    let mut s=Shot::new(identity(),point(0.,0.),point(3.,4.),params(Mode::Pierce)).unwrap();
    let result=s.advance(identity(),1,&[circle(3,-1.,7.,5.),circle(2,7.,1.,5.),
        circle(4,7.0001,1.,5.),circle(5,-1.0001,7.,5.)]).unwrap();
    assert_eq!(result.contacts.iter().map(|c|c.id).collect::<Vec<_>>(),[2,3]);
    for contact in result.contacts {close(contact.step_distance,5.);assert_eq!(contact.projectile_center,point(3.,4.));}
}

#[test]
fn initially_overlapping_targets_are_zero_distance_sorted_and_can_include_owner() {
    let mut s=shot(params(Mode::Pierce));
    let result=s.advance(identity(),1,&[circle(4,0.,0.,0.),circle(1,1.,0.,2.)]).unwrap();
    assert_eq!(result.contacts.iter().map(|c|c.id).collect::<Vec<_>>(),[1,4]);
    assert!(result.contacts.iter().all(|c|c.step_distance==0.));
    // This deliberately demonstrates that team/self eligibility belongs to the caller.
}

#[test]
fn targets_behind_away_from_line_or_beyond_range_do_not_fake_hits() {
    let mut p=params(Mode::Pierce);p.max_distance=10.;let mut s=shot(p);
    let step=s.advance(identity(),1,&[circle(2,-5.,0.,1.),circle(3,5.,2.,1.),circle(4,12.,0.,1.)]).unwrap();
    assert!(step.contacts.is_empty());assert_eq!(step.phase,Phase::Ended(End::RangeExhausted));
}

#[test]
fn contact_at_range_endpoint_is_included_and_first_contact_reason_has_priority() {
    let mut p=params(Mode::FirstContact);p.max_distance=10.;let mut first=shot(p);
    let r=first.advance(identity(),1,&[circle(2,11.,0.,1.)]).unwrap();
    assert_eq!(r.to,point(10.,0.));assert_eq!(r.phase,Phase::Ended(End::FirstContact));
    p.mode=Mode::Pierce;let mut through=shot(p);let r=through.advance(identity(),1,&[circle(2,11.,0.,1.)]).unwrap();
    assert_eq!(r.contacts.len(),1);assert_eq!(r.phase,Phase::Ended(End::RangeExhausted));
}

#[test]
fn exclusive_expiry_runs_before_motion_and_never_invents_a_launch_tick_hit() {
    let mut p=params(Mode::Pierce);p.speed_units_per_second=10.;p.expires_at_tick=2;let mut s=shot(p);
    let initial=s.view();assert_eq!(s.advance(identity(),0,&[circle(2,0.,0.,1.)]),Err(Error::UnexpectedTick));assert_eq!(s.view(),initial);
    let one=s.advance(identity(),1,&[]).unwrap();assert_eq!(one.to,point(1.,0.));
    let expired=s.advance(identity(),2,&[circle(2,1.5,0.,0.)]).unwrap();
    assert!(expired.contacts.is_empty());assert_eq!(expired.to,point(1.,0.));assert_eq!(expired.moved_distance,0.);
    assert_eq!(expired.phase,Phase::Ended(End::Expired));
}

#[test]
fn repeated_skipped_and_wrong_identity_frames_leave_all_state_unchanged() {
    let mut s=shot(params(Mode::Pierce));let before=s.view();
    assert_eq!(s.advance(identity(),2,&[]),Err(Error::UnexpectedTick));assert_eq!(s.view(),before);
    for key in [Identity{session:1,..identity()},Identity{owner:2,..identity()},Identity{team:1,..identity()},Identity{ordinal:2,..identity()}] {
        assert_eq!(s.advance(key,1,&[]),Err(Error::IdentityMismatch));assert_eq!(s.view(),before);
    }
    s.advance(identity(),1,&[]).unwrap();let after=s.view();
    assert_eq!(s.advance(identity(),1,&[]),Err(Error::UnexpectedTick));assert_eq!(s.view(),after);
}

#[test]
fn every_invalid_target_batch_is_atomic_including_already_seen_targets() {
    let mut s=shot(params(Mode::Pierce));s.advance(identity(),1,&[circle(2,2.,0.,0.)]).unwrap();let before=s.view();
    let bad=[circle(0,15.,0.,1.),circle(3,f32::NAN,0.,1.),circle(3,15.,f32::INFINITY,1.),circle(3,15.,0.,-1.),circle(2,15.,0.,f32::NAN)];
    for target in bad {assert_eq!(s.advance(identity(),2,&[circle(5,12.,0.,1.),target]),Err(Error::InvalidCircle));assert_eq!(s.view(),before);}
    assert_eq!(s.advance(identity(),2,&[circle(3,12.,0.,1.),circle(3,18.,0.,1.)]),Err(Error::DuplicateTarget));assert_eq!(s.view(),before);
}

#[test]
fn input_and_cumulative_hit_capacity_fail_before_any_partial_commit() {
    let mut p=params(Mode::Pierce);p.limits=Limits{targets_per_step:2,unique_hits:1};let mut s=shot(p);let initial=s.view();
    assert_eq!(s.advance(identity(),1,&[circle(2,1.,0.,0.),circle(3,2.,0.,0.),circle(4,3.,0.,0.)]),Err(Error::TargetCapacity));assert_eq!(s.view(),initial);
    assert_eq!(s.advance(identity(),1,&[circle(2,1.,0.,0.),circle(3,2.,0.,0.)]),Err(Error::HitCapacity));assert_eq!(s.view(),initial);
    s.advance(identity(),1,&[circle(2,1.,0.,0.)]).unwrap();let before=s.view();
    assert_eq!(s.advance(identity(),2,&[circle(3,12.,0.,0.)]),Err(Error::HitCapacity));assert_eq!(s.view(),before);
}

#[test]
fn first_mode_needs_only_its_single_committed_hit_capacity() {
    let mut p=params(Mode::FirstContact);p.limits.unique_hits=1;let mut s=shot(p);
    let r=s.advance(identity(),1,&[circle(3,7.,0.,1.),circle(2,4.,0.,1.)]).unwrap();
    assert_eq!(r.contacts.len(),1);assert_eq!(r.contacts[0].id,2);assert_eq!(s.view().unique_hits,1);
}

#[test]
fn caller_cancellation_is_explicit_terminal_and_emits_no_extra_contact() {
    let mut s=shot(params(Mode::Pierce));let before=s.view();
    assert_eq!(s.cancel(Identity{session:1,..identity()}),Err(Error::IdentityMismatch));assert_eq!(s.view(),before);
    s.cancel(identity()).unwrap();assert_eq!(s.view().phase,Phase::Ended(End::CancelledByCaller));
    assert_eq!(s.view().unique_hits,0);assert_eq!(s.advance(identity(),1,&[circle(2,0.,0.,1.)]),Err(Error::AlreadyEnded));
    assert_eq!(s.cancel(identity()),Err(Error::AlreadyEnded));
}

#[test]
fn constructor_rejects_undefined_nonfinite_and_unrepresentable_routes() {
    let p=params(Mode::Pierce);
    assert!(matches!(Shot::new(identity(),point(0.,0.),point(0.,0.),p),Err(Error::UndefinedDirection)));
    assert!(matches!(Shot::new(identity(),point(f32::NAN,0.),point(1.,0.),p),Err(Error::InvalidPoint)));
    assert!(matches!(Shot::new(identity(),point(0.,0.),point(1.,f32::INFINITY),p),Err(Error::InvalidPoint)));
    for key in [Identity{owner:0,..identity()},Identity{team:2,..identity()},Identity{ordinal:0,..identity()}] {
        assert!(matches!(Shot::new(key,point(0.,0.),point(1.,0.),p),Err(Error::InvalidIdentity)));
    }
    let mut huge=p;huge.max_distance=f32::MAX;
    assert!(matches!(Shot::new(identity(),point(f32::MAX/2.,0.),point(f32::MAX,0.),huge),Err(Error::CoordinateOverflow)));
}

#[test]
fn invalid_parameter_and_capacity_values_are_not_silently_defaulted() {
    let good=params(Mode::Pierce);
    let mut cases=Vec::new();
    for value in [0.,-1.,f32::NAN,f32::INFINITY] {let mut p=good;p.speed_units_per_second=value;cases.push(p);let mut p=good;p.max_distance=value;cases.push(p);}
    for value in [-1.,f32::NAN,f32::INFINITY] {let mut p=good;p.projectile_radius=value;cases.push(p);}
    let mut p=good;p.tick_rate=0;cases.push(p);let mut p=good;p.expires_at_tick=p.launch_tick;cases.push(p);
    for p in cases {assert!(matches!(Shot::new(identity(),point(0.,0.),point(1.,0.),p),Err(Error::InvalidParams)));}
    for limits in [Limits{targets_per_step:0,unique_hits:1},Limits{targets_per_step:1,unique_hits:0}] {
        let mut p=good;p.limits=limits;assert!(matches!(Shot::new(identity(),point(0.,0.),point(1.,0.),p),Err(Error::InvalidLimits)));
    }
}

#[test]
fn independent_shots_may_hit_same_actor_but_retain_distinct_immutable_associations() {
    let mut a=shot(params(Mode::FirstContact));let other=Identity{session:7,owner:9,team:1,ordinal:5};
    let mut b=Shot::new(other,point(0.,0.),point(100.,0.),params(Mode::FirstContact)).unwrap();
    let left=a.advance(identity(),1,&[circle(2,5.,0.,1.)]).unwrap();let right=b.advance(other,1,&[circle(2,5.,0.,1.)]).unwrap();
    assert_ne!(left.identity,right.identity);assert_eq!(left.contacts,right.contacts);
}
