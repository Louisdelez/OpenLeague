from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/annie_q_vfx.rs'
s=p.read_text(encoding='utf-8')
backup=r/'docs/plan_history'/('annie-motion-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True,exist_ok=True);shutil.copy2(p,backup/p.name)
s=s.replace('    launch: Vec3,\n    distance: f32,','    moving_native: [f32; 3],\n    target_native: [f32; 3],\n    last_update: f64,')
s=s.replace('                    launch,\n                    distance: launch.xz().distance(target.xz()),','                    moving_native: (launch * 20.).to_array(),\n                    target_native: (target * 20. - Vec3::Y * 100.).to_array(),\n                    last_update: now,')
start=s.index('        let horizontal = Vec2::new(m.position.x, m.position.z) / 20.;')
end=s.index('        for pool in &mut shot.pools {',start)
s=s[:start]+'''        let target_native = (target * 20. - Vec3::Y * 100.).to_array();
        let dt = (now - shot.last_update) as f32;
        let motion = match native_flight_step(shot.moving_native, shot.target_native, Some(target_native), dt) {
            Ok(motion) => motion,
            Err(error) => { warn!("Annie native missile motion rejected: {error}"); continue; }
        };
        shot.moving_native = motion.moving_position;
        shot.target_native = motion.target;
        shot.last_update = now;
        let anchor = Vec3::from_array(motion.moving_position) / 20.;
'''+s[end:]
helper='''// Disintegrate native profile: speed/min/max1400, height100, zero gravity/acceleration.
// Bone transform, target lifetime, collisions and server end signal remain separate boundaries.
fn native_flight_step(moving:[f32;3],fallback:[f32;3],target:Option<[f32;3]>,dt:f32)
    -> Result<openleague_core::native_missile_motion::Motion, &'static str> {
    let mut motion=openleague_core::native_missile_motion::unobstructed1400(moving,fallback,target,dt)?;
    motion.moving_position=openleague_core::native_missile_position_sync::synchronize(motion.moving_position,0.,target.is_some())?;
    Ok(motion)
}
'''
s=s.replace('struct Shot {',helper+'struct Shot {')
needle='    fn native_emission_probability_and_color_lifetime_are_bounded() {'
test='''    fn native_flight_consumer_matches384_original_moving_target_frames() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_motion_sequences_contract.json")).unwrap();
        let sequences=p["sequences"].as_array().unwrap();assert_eq!(sequences.len(),48);
        for(n,c) in sequences.iter().enumerate(){
            let v=|row:&serde_json::Value,k:&str|std::array::from_fn(|i|row[k][i].as_f64().unwrap() as f32);
            let mut moving=v(c,"origin");let mut fallback=v(c,"destination");
            for(j,f) in c["frames"].as_array().unwrap().iter().enumerate(){
                let a=native_flight_step(moving,fallback,f["live_target"].as_bool().unwrap().then(||v(f,"target_position")),c["dt"].as_f64().unwrap() as f32).unwrap();
                for(k,values) in [("moving_position_words",a.moving_position),("direction_words",a.direction),("target_words",a.target)]{
                    for i in 0..3{assert_eq!(values[i].to_bits(),f[k][i].as_u64().unwrap() as u32,"sequence{n} frame{j} {k} axis{i}");}
                }
                moving=a.moving_position;fallback=a.target;
            }
        }
    }
    #[test]
'''
s=s.replace(needle,test+needle)
assert 'shot.launch' not in s and 'shot.distance' not in s
p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native motion connected to Annie visual flight consumer')
