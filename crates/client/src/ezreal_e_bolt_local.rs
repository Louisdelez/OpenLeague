//! Explicit local binding for the restored E current-ground channel. Native
//! algorithms receive documented archived defaults, not an old process clock.
use openleague_core::{native_complex_timing::Timing,native_probability_curve::ProbabilityCurve,
    native_random::Rng55,native_scalar_parameter::ScalarParameter,native_vector_parameter::VectorParameter,
    native_simple_emission_sources as sources,native_simple_birth_factors as factors};
use crate::{ezreal_e_bolt_presentation::CurrentE,
    ezreal_e_simple_parameters::{Group,Missing,Parameters},
    ezreal_e_simple_simulation::{Dynamics,Emission,Frame,Pose}};

pub(crate) const POLICY:&str="map10_e_current_episode_archived_config_v1";
pub(crate) const CONFIG:&str=include_str!("../../../data/4.20/configuration/defaults/Game.cfg");

fn probability_one()->ProbabilityCurve {
    // Absent P means a constant multiplier1 and consumes no random number.
    ProbabilityCurve::read_numeric("P",|_|None).expect("empty probability descriptor")
}
pub(crate) fn scalar(value:f32)->ScalarParameter {
    ScalarParameter{table:vec![value],maximum:value,probability:probability_one()}
}
fn vector_zero()->VectorParameter {
    VectorParameter{table:vec![[0.;3]],probabilities:std::array::from_fn(|_|probability_one())}
}
/// This policy selects only the recovered archived baseline and no overlay.
/// Changed content containing the key is rejected rather than parsed as a new
/// hidden runtime override. It is not a claim about the historical game's VFS.
fn global_life(config:&str)->Result<f32,&'static str> {
    if config.to_ascii_lowercase().contains("default-e-life") {
        return Err("E archived configuration policy changed");
    }
    Ok(-1.)
}
pub(crate) fn complex_timing()->Result<Timing,&'static str> {
    Ok(Timing::from_scalars(None,None,None,None,Some(global_life(CONFIG)?)))
}

pub(crate) struct Simple {
    pub parameters:Parameters,
    scalar_over_life:ScalarParameter,
}
impl Simple {
    pub(crate) fn load(group:Group)->Result<Self,&'static str> {
        // Source91C0C0 tables C4/108/11C/A8 are0; loader91DC70
        // supplies p-xscale base1. Exact authored data takes precedence.
        let missing=Missing{provenance:POLICY,quad_rotation:Some(scalar(0.)),
            angular_velocity:Some(scalar(0.)),size_over_life_base:1.,
            size_over_life:Some(scalar(1.)),offset:Some(vector_zero()),
            position_offset:vector_zero()};
        Ok(Self{parameters:Parameters::load(group,missing)?,scalar_over_life:scalar(1.)})
    }
    pub(crate) fn frame(&self,ordinal:u64,time:f32,pose:Pose)->Result<Frame<'_>,&'static str> {
        if !time.is_finite()||time<0. {return Err("E local relative clock invalid");}
        let life=self.parameters.authored_emitter_life;
        let progress=time/life;
        if !progress.is_finite(){return Err("E local progress invalid");}
        Ok(Frame{ordinal,time,pose,
            emission:Emission{enabled:time<life,start:0.,life,delay:0.,period:f32::MAX,window:f32::MAX,
                single:0,progress,rate_factor:1.,
                attributes:sources::Attributes{life:None,position:None,velocity:None,rotation:None,offset:None},
                factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],
                    life_multiplier:None,offset_attribute:None,size_attribute:None},
                rotations:&[],rate_attribute:None},
            dynamics:Dynamics{
                // No stopped-emitter phase is authorized by CurrentE. Its loss
                // destroys the whole episode; p-linger is not a pre-stop cap.
                particle_cap:f32::MAX,bounds_flag:1,sticky:0,local:0,circular:0,direction:0,
                force_resource:0,force_graph:None,scalar_enabled:0,scalar_over_life:&self.scalar_over_life,
                terrain:0}})
    }
}

/// Wrapper6C8C31 sets pending144=0, E factory passes flags0, and the
/// original mapping leaves Troy owner-orientation bits10/20 clear. Thus the
/// native owner phase supplies position/direction without a facing rotation.
/// Group-authored emitter rotations belong to their respective engines.
pub(crate) fn pose(sample:&CurrentE)->Result<[u32;16],&'static str> {
    let values=[sample.position.x,sample.y_native,sample.position.z,
        sample.direction.x,sample.direction.z];
    if !values.iter().all(|v|v.is_finite())
        ||(sample.direction.x.hypot(sample.direction.z)-1.).abs()>0.0001 {
        return Err("E local atomic pose invalid");
    }
    let mut matrix=[1f32,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];
    matrix[12..15].copy_from_slice(&values[..3]);Ok(matrix.map(f32::to_bits))
}
pub(crate) fn translated_inverse(matrix:[u32;16])->Result<[u32;16],&'static str> {
    let identity=[1f32,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.].map(f32::to_bits);
    if matrix.iter().enumerate().any(|(i,v)|!f32::from_bits(*v).is_finite()
        ||(!(12..15).contains(&i)&&*v!=identity[i])) {
        return Err("E local owner matrix outside closed translation policy");
    }
    let mut inverse=matrix;
    for value in &mut inverse[12..15]{*value=(-f32::from_bits(*value)).to_bits();}
    Ok(inverse)
}
/// Relative subtraction stays in f64 until conversion, avoiding long-session
/// absolute-f32 precision loss. The caller retires on any rejected step.
pub(crate) fn age(start:f64,now:f64)->Result<f32,&'static str> {
    if !start.is_finite()||!now.is_finite()||start<0.||now<start {
        return Err("E local episode clock regressed");
    }
    let elapsed=(now-start) as f32;
    if !elapsed.is_finite(){return Err("E local episode clock overflow");}Ok(elapsed)
}
/// Named local seed. All u64 identity bytes participate; this does not attempt
/// to reproduce the original shared process RNG or its unknown seed time.
pub(crate) fn random(sample:&CurrentE)->Rng55 {
    let mut hash=0xcbf29ce484222325u64;
    for value in [sample.key.session,sample.epoch,u64::from(sample.key.owner),
        u64::from(sample.key.team),sample.key.ordinal,sample.incarnation] {
        for byte in value.to_le_bytes(){hash^=u64::from(byte);hash=hash.wrapping_mul(0x100000001b3);}
    }
    Rng55::seeded((hash as u32)^((hash>>32) as u32))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ezreal_e_bolt_presentation::Key;
    use openleague_core::Point;
    fn sample()->CurrentE {CurrentE{key:Key{session:u64::MAX,owner:2,team:0,ordinal:u64::MAX-1},
        epoch:u64::MAX-2,incarnation:9,position:Point{x:123.,z:456.},y_native:78.,
        direction:Point{x:1.,z:0.},sample_tick:12,sample_frame:20,authorization_frame:21}}
    #[test]
    fn archived_configuration_absence_uses_native_negative_sentinel_and_rejects_override(){
        assert_eq!(global_life(CONFIG).unwrap(),-1.);
        let timing=complex_timing().unwrap();assert_eq!(timing.life.to_bits(),f32::MAX.to_bits());
        assert_eq!(timing.time_offset,0.);assert_eq!(timing.active,f32::MAX);assert_eq!(timing.period,f32::MAX);
        assert!(global_life("[Hacks]\nDEFAULT-E-LIFE=2\n").is_err());
    }
    #[test]
    fn constructor_flags_keep_owner_basis_identity_while_xyz_moves(){
        let a=sample();let m=pose(&a).unwrap();
        let mut b=a;b.position.x+=10.;b.y_native+=7.;b.direction=Point{x:0.,z:1.};
        let n=pose(&b).unwrap();assert_eq!(&m[..12],&n[..12]);
        assert_eq!(n[12..15],[133f32,85.,456.].map(f32::to_bits));
        assert_eq!(translated_inverse(n).unwrap()[12..15],[-133f32,-85.,-456.].map(f32::to_bits));
        let mut bad=n;bad[0]=2f32.to_bits();assert!(translated_inverse(bad).is_err());
    }
    #[test]
    fn local_age_preserves_short_steps_in_long_sessions_and_rejects_regression(){
        assert_eq!(age(1e12,1e12+0.125).unwrap(),0.125);
        assert!(age(2.,1.).is_err());assert!(age(0.,f64::INFINITY).is_err());assert!(age(-1.,0.).is_err());
    }
    #[test]
    fn local_seed_uses_high_identity_bits_and_ignores_permission_only_refresh(){
        let a=sample();let expected=random(&a);
        let mut refresh=a;refresh.authorization_frame+=1;refresh.sample_frame+=1;
        assert_eq!(random(&refresh).words,expected.words);
        for which in 0..4 {let mut b=a;match which{0=>b.key.session^=1<<48,1=>b.epoch^=1<<48,
            2=>b.key.ordinal^=1<<48,_=>b.incarnation+=1};assert_ne!(random(&b).words,expected.words);}
    }
    #[test]
    fn simple_binding_keeps_authored_fields_and_never_uses_linger_as_live_cap(){
        let magic=Simple::load(Group::Magicdust).unwrap();let dust=Simple::load(Group::Dust).unwrap();
        assert_eq!(magic.parameters.authored_emitter_life,0.6);assert_eq!(magic.parameters.authored_particle_linger,4.);
        assert_eq!(dust.parameters.authored_emitter_life,3.);assert_eq!(dust.parameters.authored_particle_linger,1.);
        let m=pose(&sample()).unwrap();let p=Pose{previous:m,current:m,previous_inverse:translated_inverse(m).unwrap()};
        let before=magic.frame(1,0.5,p).unwrap();let after=magic.frame(2,0.6,p).unwrap();
        assert!(before.emission.enabled);assert!(!after.emission.enabled);
        assert_eq!(before.dynamics.particle_cap,f32::MAX);assert_eq!(after.dynamics.particle_cap,f32::MAX);
        assert_eq!(before.dynamics.terrain,0);assert!(before.dynamics.force_graph.is_none());
    }
}
