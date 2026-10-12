from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/annie_q_vfx.rs';s=p.read_text(encoding='utf-8')
s=s.replace('    texture: Handle<Image>,\n}', '    texture: Handle<Image>,\n    #[uniform(4)] atlas:Vec4,\n    #[uniform(5)] lookup:Vec4,\n    #[texture(6)] #[sampler(7)] color_texture:Option<Handle<Image>>,\n}',1)
s=s.replace('fn new(texture: Handle<Image>) -> Self {','fn new(texture: Handle<Image>,color_texture:Option<Handle<Image>>,g:&serde_json::Value) -> Self {')
s=s.replace('            texture,\n','            texture,\n            atlas:Vec4::new(vector2(g,"p-texdiv").x.max(1.),vector2(g,"p-texdiv").y.max(1.),0.,scalar(g,"p-uvscroll-no-alpha",0.)),\n            lookup:Vec4::new(0.,0.5,if color_texture.is_some(){1.}else{0.},scalar(g,"rendermode",0.)),\n            color_texture,\n',1)
s=s.replace('"shaders/annie_ready.wgsl"','"shaders/annie_q_particles.wgsl"')
s=s.replace('    scale: Vec3,\n}', '    scale: Vec3,\n    seed:u64,\n    frame:u32,\n}',1)
s=s.replace('        position: position + vector(g, "p-offset", Vec3::ZERO) / 20.,','        position: position + vector(g,"p-offset",Vec3::ZERO)*Vec3::new(probability(g,"p-offsetX",seed,5),probability(g,"p-offsetY",seed,6),probability(g,"p-offsetZ",seed,7))/20.,')
s=s.replace('        velocity: vector(g, "p-vel", Vec3::ZERO) / 20.,','        velocity: vector(g,"p-vel",Vec3::ZERO)*Vec3::new(probability(g,"p-velX",seed,8),probability(g,"p-velY",seed,9),probability(g,"p-velZ",seed,10))/20.,')
s=s.replace('        scale: scale / 20.,','        scale: scale / 20.,\n        seed,frame:if scalar(g,"p-randomstartframe",0.)>0.{(random(seed,11)*vector2(g,"p-texdiv").element_product()).floor() as u32}else{scalar(g,"p-startframe",0.) as u32},')
s=s.replace('    bones: Query<(&Name, &GlobalTransform)>,','    bones: Query<(&Name, &GlobalTransform)>,\n    cameras:Query<&GlobalTransform,With<Camera3d>>,')
s=s.replace('flights.shots.iter()', 'flights.shots.iter()')
s=s.replace('.filter(|(_, shot)| shot.ended.is_some_and(|end| now - end >= 2.))','.filter(|(_,shot)|shot.ended.is_some_and(|end|now-end>=2.)&&shot.pools.iter().all(|pool|pool.slots.iter().all(|(_,_,p)|p.is_none())))')
s=s.replace('["Fire", "Fire_Head"]\n', '["Fire", "Fire_Head", "Embers"]\n')
s=s.replace('QMaterial::new(flights.texture.as_ref().unwrap().clone())','QMaterial::new(if name=="Embers"{terrain_material::image(&assets,"particles/annie/sparks_BW.png".into(),false)}else{flights.texture.as_ref().unwrap().clone()},if name=="Embers"{Some(terrain_material::image(&assets,"particles/annie/Annie_Embers_RGB.png".into(),false))}else{None},group(name))')
s=s.replace('                        *t = pose;','''                        *t = pose;
                        if scalar(group(pool.name),"p-type",0.)==0. {
                         if let Some(camera)=cameras.iter().next(){let rotation=camera.rotation();t.rotation=rotation;
                          if let Some(particle)=p.as_ref(){if scalar(group(pool.name),"p-vecalign",0.)>0.{let vx=particle.velocity.dot(rotation*Vec3::X);let vy=particle.velocity.dot(rotation*Vec3::Y);t.rotation=rotation*Quat::from_rotation_z((-vx).atan2(vy));let stretch=(particle.velocity.length()*20.*scalar(group(pool.name),"p-vec-velocity-scale",0.)).max(scalar(group(pool.name),"p-vec-velocity-minscale",1.));t.scale.y*=stretch;}}
                         }
                        }'''.replace('\n+ ','\n '))
s=s.replace('                            mat.set(color, uv);','''                            mat.set(color, uv);
                            if let Some(particle)=p.as_ref(){mat.atlas.z=particle.frame as f32;let age=((now-particle.birth) as f32/particle.life).clamp(0.,1.);mat.lookup.x=age;mat.lookup.y=random(particle.seed,12);}
'''.replace('\n+ ','\n '))
s=s.replace('Fire/Fire_Head native fields; Glow path ambiguity, Embers/Projected','Fire/Fire_Head/Embers native fields; Glow path ambiguity, Projected')
s=s.replace('"rendered_groups":["Fire","Fire_Head"]','"rendered_groups":["Fire","Fire_Head","Embers"]')
s+='''
#[cfg(test)] mod ember_tests {use super::*;
 #[test]fn native_ember_spawn_offsets_atlas_lifetimes_and_velocity_ranges(){let g=group("Embers");assert_eq!(capacity(g),391);for index in 0..500 {let p=born(g,index,(1,2,3),0.,Vec3::ZERO);assert!((0.65..=2.6).contains(&p.life));assert!(p.frame<4);assert!((-1. ..=1.).contains(&p.position.x));assert!((-1. ..=1.).contains(&p.position.y));assert!((0.75..=2.25).contains(&p.velocity.x));assert!((15. ..=30.).contains(&p.velocity.y));assert!(pose(g,&p,p.life as f64,Vec3::ZERO).is_none());}}
}
'''.replace('\n+ ','\n ')
p.write_text(s,encoding='utf-8');shutil.copyfile('E:/mapslol3v3/annie_q_particles.wgsl',r/'assets/shaders/annie_q_particles.wgsl')
print('Integrated nativeEmbers texture/atlas/LUT with explicit reconstructed RNG and lookup coordinates; fullVFX open.')
