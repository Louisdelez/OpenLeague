from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/simple_cycle.rs'
s=p.read_text(encoding='utf-8')
s=s.replace('//! Upstream pose and owner-end policy are separate prerequisites for activation.','//! Upstream pose and owner-end flag/time producers remain prerequisites for activation.')
s=s.replace('pub struct SingleParticleCycle {','/// Explicit native system fields supplied by the caller; not an inferred missile timer.\npub struct OwnerEnd {\n    pub system_start:f32,\n    pub emitter_linger:f32,\n    pub particle_linger:f32,\n}\npub struct SingleParticleCycle {')
s=s.replace('life_cap<=0.', 'life_cap<0.')
old='''            let p=simple_attachment::bind_position(self.position,self.normalized_age,self.bind,self.locked,self.previous_pose.w_axis.truncate(),pose.w_axis.truncate())?;
            self.position=simple_attachment::local_position(p,self.normalized_age,self.local,self.previous_pose.inverse(),pose)?;'''
new='''            // Native944600/944760 skip inactive ages, including +Infinity from a zero cap.
            if self.active_count!=0 {
                let p=simple_attachment::bind_position(self.position,self.normalized_age,self.bind,self.locked,self.previous_pose.w_axis.truncate(),pose.w_axis.truncate())?;
                self.position=simple_attachment::local_position(p,self.normalized_age,self.local,self.previous_pose.inverse(),pose)?;
            }'''
assert old in s;s=s.replace(old,new)
marker='''        Ok(())
    }
}
#[cfg(test)]'''
new='''        Ok(())
    }
    pub fn step_with_owner_end(&mut self,now:f32,pose:Mat4,end:Option<&OwnerEnd>)->Result<(),&'static str> {
        let (expired,cap)=match end {
            None=>(now-self.birth>self.emitter_life,f32::MAX),
            Some(end)=>{
                if ![end.system_start,end.emitter_linger,end.particle_linger].iter().all(|x|x.is_finite()) || end.system_start>now || end.emitter_linger<0. || end.particle_linger<0. {
                    return Err("unsupported native owner-end fields");
                }
                //943814 uses age relative to the explicit system start, not time since flag change.
                let expired=now-end.system_start>end.emitter_linger;
                (expired,if expired {end.particle_linger} else {f32::MAX})
            }
        };
        self.step(now,pose,cap)?;
        self.finished=expired && self.active_count==0;
        Ok(())
    }
}
#[cfg(test)]'''
assert marker in s;s=s.replace(marker,new)
test='''
    #[test]
    fn native_owner_end_caps_match_all_fifty_original_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_end_contract.json")).unwrap();
        let vec=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_f64().unwrap() as f32).collect::<Vec<_>>();
        for case in proof["cases"].as_array().unwrap() {
            let frames=case["frames"].as_array().unwrap();
            assert_eq!(case["birth_calls"],serde_json::json!([[10.,2.]]));
            let pose=Mat4::from_cols_array(&vec(&frames[0]["previous_matrix"]).try_into().unwrap());
            let mut cycle=SingleParticleCycle::new(10.,2.,1.,Vec3::new(100.,200.,300.),pose,Vec2::ZERO,true,false).unwrap();
            let end=OwnerEnd {system_start:10.,emitter_linger:case["emitter_linger"].as_f64().unwrap() as f32,particle_linger:case["particle_linger"].as_f64().unwrap() as f32};
            for frame in frames {
                let pose=Mat4::from_cols_array(&vec(&frame["previous_matrix"]).try_into().unwrap());
                cycle.step_with_owner_end(10.+frame["age"].as_f64().unwrap() as f32,pose,frame["owner_end_flag"].as_bool().unwrap().then_some(&end)).unwrap();
                assert_eq!(cycle.normalized_age.to_bits(),frame["normalized_age_bits"][0].as_u64().unwrap() as u32);
                assert_eq!(cycle.position,Vec3::from_slice(&vec(&frame["position"])));
                assert_eq!(cycle.active_count,frame["active_count"].as_u64().unwrap() as u32);
                assert_eq!(cycle.finished,frame["emitter_finished"]==1);
                assert_eq!(cycle.particle_life,frame["life"][0].as_f64().unwrap() as f32);
                assert_eq!(cycle.previous_time.unwrap(),frame["last_update"].as_f64().unwrap() as f32);
            }
        }
    }
'''
s=s.rstrip();assert s.endswith('}');s=s[:-1]+test+'}\n';p.write_text(s,encoding='utf-8')
for n in ['probe_native_simple_owner_end.py','implement_simple_owner_end.py']:shutil.copyfile(Path('E:/mapslol3v3')/n,r/'tools'/n)
shutil.copyfile(p,Path('E:/mapslol3v3/simple_cycle.rs'))
print('Owner-end cap implemented; native producer binding remains open.')
