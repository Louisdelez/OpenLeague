from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/annie_q_vfx.rs';s=p.read_text(encoding='utf-8')
h=r/'docs/plan_history'/('annie-target-fallback-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True);shutil.copy2(p,h/p.name)
old='''        let Some(target) = target else {
            continue;
        };
        if !flights.shots.contains_key(&key) {'''
new='''        if !flights.shots.contains_key(&key) {
            // A new flight requires an observed target. Existing flights retain the
            // last native target when it disappears from the current snapshot.
            let Some(target) = target else { continue; };'''
assert old in s;s=s.replace(old,new,1)
old='''        let target_native = (target * 20. - Vec3::Y * 100.).to_array();
        let dt = (now - shot.last_update) as f32;
        let motion = match native_flight_step(shot.moving_native, shot.target_native, Some(target_native), dt) {'''
new='''        let target_native = target.map(|target| (target * 20. - Vec3::Y * 100.).to_array());
        let dt = (now - shot.last_update) as f32;
        let motion = match native_flight_step(shot.moving_native, shot.target_native, target_native, dt) {'''
assert old in s;s=s.replace(old,new,1)
p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Existing flight now routes absent target to native fallback')
