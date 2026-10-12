//! Original FogOfWar shader arithmetic and native blur-kernel constructor.
//! Live team-visibility inputs and parameter providers are separate contracts.
pub struct GaussianKernel {pub center:f32,pub paired:f32,pub offset:f32}
impl GaussianKernel {
    pub fn native(sigma:f32,upscale:bool)->Result<Self,&'static str> {
        if !sigma.is_finite() {return Err("nonfinite fog sigma");}
        let kernel=if sigma<0. {
            Self {center:f32::from_bits(if upscale {0x3e9696e6}else{0x3f666666}),paired:f32::from_bits(if upscale {0x3eb4b5dd}else{0x3d4ccccd}),offset:f32::from_bits(0x3faaa993)}
        } else {
            let sigma=sigma as f64;let inverse=1./(2.*sigma*sigma);
            let prefactor=1./((f32::from_bits(0x40c90fdb) as f64)*sigma*sigma).sqrt();
            let g0=(prefactor*(-0.*inverse).exp()) as f32;
            let g1=(prefactor*(-inverse).exp()) as f32;
            let g2=(prefactor*(-4.*inverse).exp()) as f32;
            let pair=g1+g2;let sum=pair*2.+g0;let center=g0/sum;
            Self {center,paired:(1.-center)*0.5,offset:1.+g2/pair}
        };
        if !kernel.center.is_finite() || !kernel.paired.is_finite() || !kernel.offset.is_finite() {return Err("native fog kernel produces nonfinite coefficients");}
        Ok(kernel)
    }
}
/// Fade.ps_2_0 does not use PARAMETERS.z despite its documented min-visibility label.
pub fn fade(target:f32,current:f32,parameters:[f32;4])->f32 {
    if target>=parameters[3] {target}
    else if current<target {(current+parameters[0]).min(target)}
    else if current>target {(current-parameters[1]).max(target)}
    else {target}
}
pub fn sample_linear(bytes:&[u8],width:usize,height:usize,uv:[f32;2])->f32 {
    let x=uv[0]*width as f32-0.5;let y=uv[1]*height as f32-0.5;
    let ix=x.floor() as i32;let iy=y.floor() as i32;let tx=x-x.floor();let ty=y-y.floor();
    let at=|x:i32,y:i32|bytes[y.clamp(0,height as i32-1) as usize*width+x.clamp(0,width as i32-1) as usize] as f32/255.;
    let a=at(ix,iy)*(1.-tx)+at(ix+1,iy)*tx;let b=at(ix,iy+1)*(1.-tx)+at(ix+1,iy+1)*tx;
    a*(1.-ty)+b*ty
}
pub fn blur(bytes:&[u8],width:usize,height:usize,uv:[f32;2],parameters:[f32;4])->f32 {
    let mut value=sample_linear(bytes,width,height,uv)*parameters[2];
    value+=sample_linear(bytes,width,height,[uv[0]+parameters[0],uv[1]+parameters[1]])*parameters[3];
    value+=sample_linear(bytes,width,height,[uv[0]-parameters[0],uv[1]-parameters[1]])*parameters[3];value
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn gaussian_kernel_matches_original_constructor_in_both_resolution_modes() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_gaussian_contract.json")).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let kernel=GaussianKernel::native(c["sigma"].as_f64().unwrap() as f32,c["upscale"].as_bool().unwrap());
            if !c["finite"].as_bool().unwrap() {assert!(kernel.is_err());continue;}
            let k=kernel.unwrap();for (actual,key) in [(k.center,"center_weight"),(k.paired,"paired_weight"),(k.offset,"sample_offset")] {assert!((actual-c[key].as_f64().unwrap() as f32).abs()<0.000001,"native {c}, {key}, {actual}");}
        }
    }
    #[test] fn fade_hits_target_without_overshoot_and_respects_instant_threshold() {
        assert_eq!(fade(1.,0.,[0.01,0.01,0.,0.95]),1.);
        assert!((fade(0.8,0.6,[0.05,0.1,0.,0.95])-0.65).abs()<0.000001);
        assert_eq!(fade(0.8,0.7,[0.3,0.1,0.,0.95]),0.8);
        assert!((fade(0.2,0.8,[0.05,0.1,0.,0.95])-0.7).abs()<0.000001);
        assert_eq!(fade(0.2,0.3,[0.05,0.5,0.,0.95]),0.2);
        assert_eq!(fade(0.5,0.5,[0.1,0.1,0.9,0.95]),0.5);
    }
}
