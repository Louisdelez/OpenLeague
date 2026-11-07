//! OriginalComplextype2 selector924908 andwhole922760 packet; sourceproducers explicit.
#[derive(Clone,Copy)]pub struct Input {pub camera:[f32;3],pub center:[f32;3],pub motion_point:[f32;3],pub scales:[f32;3],pub rgba:[f32;4],pub frame:f32,pub uv:[f32;2],pub lookup:[f32;2],pub channel_corners:bool}
#[derive(Clone,Copy,Debug)]pub struct Packet {pub words:[[u32;12];4]}
fn norm(squared:f32)->Result<f32,&'static str>{
 #[cfg(target_arch="x86_64")]let q={use std::arch::x86_64::*;unsafe{_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(squared)))}};
 #[cfg(target_arch="x86")]let q={use std::arch::x86::*;unsafe{_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(squared)))}};
 #[cfg(not(any(target_arch="x86_64",target_arch="x86")))]return Err("nativeRSQRTSS requiresx86");
 #[cfg(any(target_arch="x86_64",target_arch="x86"))]Ok(if squared==0.{0.}else{((3.-((q*squared)*q))*(q*0.5))*squared})
}
pub fn packet(i:Input)->Result<Packet,&'static str>{
 if i.camera.into_iter().chain(i.center).chain(i.motion_point).chain(i.scales).chain(i.rgba).chain([i.frame]).chain(i.uv).chain(i.lookup).any(|v|!v.is_finite())||i.rgba.iter().any(|v|!(0. ..=1.).contains(v)){return Err("type2inputoutsidequalifiedfiniteRGBA");}
 let [x,y,z]=std::array::from_fn::<_,3,_>(|a|i.center[a]-i.motion_point[a]);
 let [cx,cy,cz]=std::array::from_fn::<_,3,_>(|a|i.camera[a]-i.motion_point[a]);
 //9227DD..922832 crossorientation andspecificsquareadditionorder.
 let mut cross=[cz*y-cy*z,cx*z-cz*x,cy*x-cx*y];
 let length=norm((cross[1]*cross[1]+cross[0]*cross[0])+cross[2]*cross[2])?;
 if length!=0.{let inverse=1./length;for value in &mut cross{*value*=inverse;}}
 let mut line=[x,y,z];let length=norm((y*y+x*x)+z*z)?;
 if length!=0.{let inverse=1./length;for value in &mut line{*value*=inverse;}}
 let rear: [f32;3]=std::array::from_fn(|a|line[a]*i.scales[2]+i.center[a]);
 let front: [f32;3]=std::array::from_fn(|a|line[a]*i.scales[1]+rear[a]);
 let width=cross.map(|v|(v*i.scales[0])*f32::from_bits(0x3f000000));
 let positions=[std::array::from_fn::<_,3,_>(|a|front[a]-width[a]),std::array::from_fn(|a|width[a]+front[a]),std::array::from_fn(|a|width[a]+rear[a]),std::array::from_fn(|a|rear[a]-width[a])];
 let channels=i.rgba.map(|v|(f64::from(v)*255.+0.5).trunc() as u32);let argb=(channels[3]<<24)|(channels[0]<<16)|(channels[1]<<8)|channels[2];
 let corners:[[f32;2];4]=[[0.,0.],[1.,0.],[1.,1.],[0.,1.]];let mut output=Packet{words:[[0;12];4]};
 for (j,[x,y]) in corners.into_iter().enumerate(){let uv=[if x==0.{i.uv[0]}else{i.uv[0]+1.},if y==0.{i.uv[1]}else{1.+i.uv[1]}];let flag=f32::from(u8::from(i.channel_corners));let lookup=[if x==0.{i.lookup[0]}else{i.lookup[0]+flag},if y==0.{i.lookup[1]}else{flag+i.lookup[1]}];output.words[j]=[positions[j][0].to_bits(),positions[j][1].to_bits(),positions[j][2].to_bits(),argb,uv[0].to_bits(),uv[1].to_bits(),i.frame.to_bits(),0,lookup[0].to_bits(),lookup[1].to_bits(),x.to_bits(),y.to_bits()];}
 Ok(output)
}
