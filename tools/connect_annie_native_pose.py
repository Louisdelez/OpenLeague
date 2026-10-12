from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/annie_q_vfx.rs';s=p.read_text(encoding='utf-8')
assert 'direction_native: [f32; 3]' not in s
s=s.replace('moving_native: [f32; 3],','moving_native: [f32; 3],\n    direction_native: [f32; 3],')
s=s.replace('Vec3,bool)> {','Vec3,Vec3,bool)> {')
s=s.replace('(*key,shot.started,shot.previous,shot.ended.is_some())','(*key,shot.started,Vec3::from_array(shot.moving_native),Vec3::from_array(shot.direction_native),shot.ended.is_some())')
s=s.replace('moving_native: (launch * 20.).to_array(),','moving_native: (launch * 20.).to_array(),\n                    direction_native: [0.;3],')
s=s.replace('shot.moving_native = motion.moving_position;','shot.moving_native = motion.moving_position;\n        shot.direction_native = motion.direction;')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/projected_live.rs';s=p.read_text(encoding='utf-8')
marker='struct Lifetime {cycle:';idx=s.index(marker)
helper='''// Concrete projectile owner orientation719D20, gated by actual Troy flags.
// Native moving position is passed without a /20 then *20 coordinate round-trip.
fn native_pose(position:Vec3,direction:Vec3,flags:u32,mut matrix:Mat4,extent:f32)->Result<SimpleOwnerPose,&'static str>{
    if flags&0x10!=0 && flags&0x20==0 {
        let (ok,m)=openleague_core::native_missile_effect_owner::orientation(Some(direction.to_array()))?;
        if ok {matrix=Mat4::from_cols_array(&m);}
    }
    SimpleOwnerPose::new(position,matrix,extent)
}
'''
s=s[:idx]+helper+s[idx:]
s=s.replace('Wrapper,requests:u32}', 'Wrapper,requests:u32,pose_flags:u32,pose_matrix:Mat4}')
s=s.replace('// Native projectile orientation is recovered in core; its live direction producer is not yet qualified. Identity remains an explicit reconstructed adapter.\n        let pose=SimpleOwnerPose::new(native_position,Mat4::IDENTITY,c.scale)?;', '''// Original missile7172B0 uses flags0 and the fresh wrapper has pending flags0.
        let mut setup=openleague_core::native_projectile_factory_pose::Setup::load(0,0,native_position.to_array(),true)?;
        setup.first_update(true);
        let pose_matrix=Mat4::from_cols_array(&setup.troy_matrix.map(f32::from_bits));
        let pose=native_pose(Vec3::from_array(setup.troy_position.map(f32::from_bits)),Vec3::ZERO,setup.troy_flags,pose_matrix,c.scale)?;''')
s=s.replace('ended:0,linked:true},requests:0})','ended:0,linked:true},requests:0,pose_flags:setup.troy_flags,pose_matrix})')
s=s.replace('source_now:f64,native_position:Vec3,ended:bool','source_now:f64,native_position:Vec3,native_direction:Vec3,ended:bool')
s=s.replace('let pose=SimpleOwnerPose::new(native_position,Mat4::IDENTITY,c.scale)?;', 'let pose=native_pose(native_position,native_direction,self.pose_flags,self.pose_matrix,c.scale)?;\n        self.pose_matrix=pose.orientation;')
s=s.replace('|(key,_,_,_)|','|(key,_,_,_,_)|').replace('for (key,started,position,ended) in owners','for (key,started,position,direction,ended) in owners')
s=s.replace('Lifetime::new(position*20.,&c,started)','Lifetime::new(position,&c,started)').replace('frame(now,position*20.,ended,&c)','frame(now,position,direction,ended,&c)')
s=s.replace('network end trigger and registry scheduling reconstructed, identity orientation','native factory flags and provider orientation gate; network end trigger and registry scheduling reconstructed')
s=s.replace('Identity orientation/default factor1/FOW1;', 'Native initial flags0 retain constructor orientation; later flag producers/default factor1/FOW1;')
s=s.replace('"native_stop_dispatch_binding":true','"native_pose_binding":true,"native_position_coordinate_roundtrip":false,"native_stop_dispatch_binding":true')
s=s.replace('current projectile anchor remain reconstructed adapters.', 'owner status and weak ownership remain reconstructed adapters; pose now consumes exact native moving-position/direction fields.')
s=s.replace('Vec3::new(100.,200.,300.),false,&c)', 'Vec3::new(100.,200.,300.),Vec3::ZERO,false,&c)').replace('Vec3::new(112.5,200.,300.),false,&c)', 'Vec3::new(112.5,200.,300.),Vec3::ZERO,false,&c)').replace('Vec3::new(125.,200.,300.),true,&c)', 'Vec3::new(125.,200.,300.),Vec3::ZERO,true,&c)')
s=s.replace('position(f),f["owner_end_flag"]','position(f),Vec3::ZERO,f["owner_end_flag"]')
test='''
    #[test]
    fn native_pose_bridge_matches45_live_original_factory_provider_profiles(){
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_pose_composition_contract.json")).unwrap();let mut count=0;
        for row in proof["cases"].as_array().unwrap().iter().filter(|r|r["effect_live"]==true && r["owner_live"]==true){
            let vec=|key:&str|Vec3::from_array(std::array::from_fn(|i|row[key][i].as_f64().unwrap() as f32));
            let matrix=Mat4::from_cols_array(&std::array::from_fn(|i|f32::from_bits(row["before"]["source_matrix"][i].as_u64().unwrap() as u32)));
            let pose=native_pose(vec("position"),vec("direction"),row["flags"].as_u64().unwrap() as u32,matrix,500.).unwrap();
            assert_eq!(pose.position.to_array().map(f32::to_bits),std::array::from_fn(|i|row["result"]["source_position"][i].as_u64().unwrap() as u32));
            assert_eq!(pose.orientation.to_cols_array().map(f32::to_bits),std::array::from_fn(|i|row["result"]["source_matrix"][i].as_u64().unwrap() as u32));count+=1;
        }assert_eq!(count,45);
    }
'''
idx=s.rfind('}');s=s[:idx]+test+s[idx:];p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
