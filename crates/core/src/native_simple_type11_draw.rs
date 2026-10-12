//! Native92FCC0 type11 scalar transform, through the962C60 draw boundary.
//! No GPU, provider lookup, skeleton construction or arbitrary affine decomposition.
//! The caller supplies a real post-hierarchy/post-inverse-bind palette and owner inverse.
use crate::native_simple_type11_pose::{Joint, Pose};

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error {
    NonFinite,
    Unsupported(&'static str),
    Allocation,
    JointCount,
    ParentIndex,
    ParentCycle,
}
fn finite(values: &[f32]) -> Result<(), Error> {
    if values.iter().all(|v| v.is_finite()) { Ok(()) } else { Err(Error::NonFinite) }
}
/// Raw T3/S3/Q4. It is not a local joint transform or a general affine matrix.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Transform(pub [u32; 10]);
impl Transform {
    pub fn from_joint(joint: &Joint) -> Self {
        Self(std::array::from_fn(|i| u32::from_le_bytes(joint[i*4..i*4+4].try_into().unwrap())))
    }
    pub fn to_joint(self) -> Joint {
        let mut result=[0u8;40];
        for (i,word) in self.0.iter().enumerate() { result[i*4..i*4+4].copy_from_slice(&word.to_le_bytes()); }
        result
    }
}
/// Particle arguments to92FCC0. `matrix` is the caller's actual row-major matrix;
/// neither identity nor actor transform may be substituted when that caller is unknown.
#[derive(Debug, Clone, Copy)]
pub struct Frame {
    pub position: [u32; 3],
    pub right: [u32; 3],
    pub up: [u32; 3],
    pub scale: u32,
    pub matrix: [u32; 16],
}

/// Original SSE arithmetic expects masked exceptions, nearest rounding and no
/// FTZ/DAZ. Status flags are not the control mode and do not prevent an operation.
fn check_sse_mode() -> Result<(), Error> {
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let mut mode=0u32;
        unsafe { std::arch::asm!("stmxcsr [{p}]",p=in(reg) &mut mode,options(nostack,preserves_flags)); }
        if mode & 0xffc0 != 0x1f80 { return Err(Error::Unsupported("type11 SSE control mode differs from native oracle")); }
        Ok(())
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    { Err(Error::Unsupported("type11 native scalar operations require qualified x86 SSE")) }
}
///5FA7C0 /8DF410 /885600 use the already-ported physical CPU RSQRTSS estimate.
/// This intentionally is not f32::sqrt. Unicorn and actual CPU estimates may differ.
fn length(squared:f32) -> Result<f32,Error> {
    finite(&[squared])?;
    if squared==0. { return Ok(0.); } // native AND mask removes the NaN produced by zero rsqrt
    if squared<0. { return Err(Error::Unsupported("negative native squared length")); }
    let e=crate::native_particle_force_body::inverse_estimate(squared).map_err(Error::Unsupported)?;
    let value=((3.-((e*squared)*e))*(e*0.5))*squared;
    finite(&[value])?; Ok(value)
}

//66E970 returns x87 extended precision. Keep it in a ten-byte value through the
//native *.5 and subsequent operations, avoiding an invented f64/f32 rounding step.
//Each asm block restores the caller's control word; native CW037F is local here.
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn inverse_factor(value:f32) -> Result<[u8;10],Error> {
    if !value.is_finite() || value<=0. {return Err(Error::Unsupported("native quaternion inverse-sqrt domain"))}
    let guess=f32::from_bits(0x5f3759dfu32.wrapping_sub(((value.to_bits() as i32)>>1) as u32));
    let half=0.5f32; let onehalf=1.5f32;let cw=0x037fu16;let mut saved=0u16;let mut out=[0u8;10];
    unsafe {std::arch::asm!(
        "fnstcw word ptr [{saved}]", "fldcw word ptr [{cw}]",
        "fld dword ptr [{value}]", "fmul dword ptr [{half}]", "fld dword ptr [{guess}]",
        "fmul st(1), st(0)", "fmul st(1), st(0)", "fld dword ptr [{onehalf}]",
        "fsubrp st(2), st(0)", "fmulp st(1), st(0)", "fmul dword ptr [{half}]",
        "fstp tbyte ptr [{out}]", "fldcw word ptr [{saved}]",
        saved=in(reg)&mut saved,cw=in(reg)&cw,value=in(reg)&value,half=in(reg)&half,
        guess=in(reg)&guess,onehalf=in(reg)&onehalf,out=in(reg)&mut out,
        out("st(0)") _,out("st(1)") _,out("st(2)") _,options(nostack,preserves_flags));}
    Ok(out)
}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn factor_values(factor:&[u8;10]) -> (f32,f32) {
    let quarter=0.25f32;let cw=0x037fu16;let mut saved=0u16;let mut out=[0f32;2];
    unsafe {std::arch::asm!(
        "fnstcw word ptr [{saved}]", "fldcw word ptr [{cw}]", "fld tbyte ptr [{factor}]",
        "fst dword ptr [{out}]", "fdivr dword ptr [{quarter}]", "fstp dword ptr [{out} + 4]",
        "fldcw word ptr [{saved}]",saved=in(reg)&mut saved,cw=in(reg)&cw,factor=in(reg)factor.as_ptr(),
        quarter=in(reg)&quarter,out=in(reg)out.as_mut_ptr(),out("st(0)") _,options(nostack,preserves_flags));}
    (out[0],out[1])
}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn extended_difference(a:f32,b:f32,c:f32,d:f32,factor:&[u8;10])->f32 {
    let inputs=[a,b,c,d];let cw=0x037fu16;let mut saved=0u16;let mut out=0f32;
    unsafe {std::arch::asm!(
        "fnstcw word ptr [{saved}]", "fldcw word ptr [{cw}]",
        "fld dword ptr [{input}]", "fmul dword ptr [{input} + 4]",
        "fld dword ptr [{input} + 8]", "fmul dword ptr [{input} + 12]",
        "fsubp st(1), st(0)", "fld tbyte ptr [{factor}]", "fmulp st(1), st(0)",
        "fstp dword ptr [{out}]", "fldcw word ptr [{saved}]",
        saved=in(reg)&mut saved,cw=in(reg)&cw,input=in(reg)inputs.as_ptr(),factor=in(reg)factor.as_ptr(),
        out=in(reg)&mut out,out("st(0)") _,out("st(1)") _,options(nostack,preserves_flags));}
    out
}

///8DF170 finite branches, including its RAW diagonal comparison and rotated
///reciprocal-scale scratch indexing in the nonpositive-trace branch.
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
pub(crate) fn matrix_quaternion(m:[f32;16])->Result<[f32;4],Error> {
    let scales=[length((m[0]*m[0]+m[1]*m[1])+m[2]*m[2])?,
                length((m[4]*m[4]+m[5]*m[5])+m[6]*m[6])?,
                length((m[8]*m[8]+m[9]*m[9])+m[10]*m[10])?];
    let eps=f32::from_bits(0x358637bd);
    if scales.iter().any(|v|(-eps..=eps).contains(v)){return Ok([0.,0.,0.,1.]);}
    let (rx,ry,rz)=(1./scales[0],1./scales[1],1./scales[2]);
    let trace=(m[0]*rx+m[5]*ry)+m[10]*rz;
    let mut q=[0f32;4];
    if trace>0. {
        let f=inverse_factor(trace+1.)?;
        q[3]=factor_values(&f).1;
        q[0]=extended_difference(m[6],ry,m[9],rz,&f);
        q[1]=extended_difference(m[8],rz,m[2],rx,&f);
        q[2]=extended_difference(m[1],rx,m[4],ry,&f);
    } else {
        let mut i=if m[5]>m[0]{1usize}else{0};if m[10]>m[i*5]{i=2;}
        let next=[1usize,2,0];let j=next[i];let k=next[j];
        let f=inverse_factor(((m[i*5]-m[j*5])-m[k*5])+1.)?;
        let (factor,principal)=factor_values(&f);
        let r=[ry,rz,rx];q[i]=principal;
        q[j]=((m[i+j*4]*r[j])+(m[j+i*4]*r[i]))*factor;
        q[k]=((m[i+k*4]*r[k])+(m[k+i*4]*r[i]))*factor;
        q[3]=((m[k+j*4]*r[j])-(m[j+k*4]*r[k]))*factor;
    }
    finite(&q)?;
    let squared=((q[0]*q[0]+q[3]*q[3])+q[1]*q[1])+q[2]*q[2];
    if squared>f32::from_bits(0x219392ee) {
        let inv=1./length(squared)?;q=q.map(|v|v*inv);
    } else {
        //8856CD literal fallback, not a generic normalized identity.
        let g=f32::from_bits(0x5f3759df-(3f32.to_bits()>>1));
        let v=(1.5-((g*1.5)*g))*g;q=[v,v,v,0.];
    }
    finite(&q)?;Ok(q)
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
pub(crate) fn matrix_quaternion(_: [f32;16])->Result<[f32;4],Error>{Err(Error::Unsupported("native type11 x87 quaternion construction unavailable"))}

pub fn prepare_frame(frame:Frame)->Result<Transform,Error> {
    check_sse_mode()?;
    let right=frame.right.map(f32::from_bits);let up=frame.up.map(f32::from_bits);
    let position=frame.position.map(f32::from_bits);let scale=f32::from_bits(frame.scale);
    let caller=frame.matrix.map(f32::from_bits);
    finite(&right)?;finite(&up)?;finite(&position)?;finite(&caller)?;finite(&[scale])?;
    let mut forward=[right[1]*up[2]-right[2]*up[1],up[0]*right[2]-right[0]*up[2],right[0]*up[1]-up[0]*right[1]];
    let len=length((forward[1]*forward[1]+forward[0]*forward[0])+forward[2]*forward[2])?;
    if len!=0. {let inv=1./len;forward=forward.map(|v|v*inv);}
    let basis=[right[0],right[1],right[2],0.,up[0],up[1],up[2],0.,forward[0],forward[1],forward[2],0.,0.,0.,0.,1.];
    let combined=crate::camera_view::multiply(&basis,&caller);
    finite(&combined)?;let q=matrix_quaternion(combined)?;
    Ok(Transform([position[0],position[1],position[2],scale,scale,scale,q[0],q[1],q[2],q[3]].map(f32::to_bits)))
}

///8E4340(child,parent,result,1); independent inputs preserve alias-safe source order.
pub fn compose(child:Transform,parent:Transform)->Result<Transform,Error> {
    check_sse_mode()?;let c=child.0.map(f32::from_bits);let p=parent.0.map(f32::from_bits);
    finite(&c)?;finite(&p)?;Ok(Transform(compose_native(c,p)?.map(f32::to_bits)))
}
///8991F0/8992D0 local TRS hierarchy followed by899380 inverse-bind TRS.
///The native visited set has256 bits; this interface requires dense joint IDs in
///palette order and validated original parent/inverse-bind tables, not guessed IDs.
///No affine/global-matrix decomposition occurs, including nonuniform scale.
pub fn build_palette(local:&[Joint],parents:&[i16],inverse_bind:&[Joint],owner:Transform)->Result<Vec<Joint>,Error>{
    check_sse_mode()?;
    let n=local.len();if n>256 || parents.len()!=n || inverse_bind.len()!=n {return Err(Error::JointCount)}
    finite(&owner.0.map(f32::from_bits))?;
    for &p in parents {if p < -1 || p >= n as i16{return Err(Error::ParentIndex)}}
    let mut globals:Vec<Option<Transform>>=Vec::new();globals.try_reserve_exact(n).map_err(|_|Error::Allocation)?;globals.resize(n,None);
    let mut stack=Vec::new();stack.try_reserve_exact(n).map_err(|_|Error::Allocation)?;
    let mut visiting=[false;256];
    for start in 0..n {
        let mut current=start;
        while globals[current].is_none() {
            if visiting[current] {return Err(Error::ParentCycle)}
            visiting[current]=true;stack.push(current);
            let p=parents[current];if p<0 {break} current=p as usize;
        }
        while let Some(index)=stack.pop() {
            let parent=if parents[index]<0 {owner}else{globals[parents[index] as usize].ok_or(Error::ParentCycle)?};
            globals[index]=Some(compose(Transform::from_joint(&local[index]),parent)?);visiting[index]=false;
        }
    }
    let mut palette=Vec::new();palette.try_reserve_exact(n).map_err(|_|Error::Allocation)?;
    for i in 0..n {
        let ib=Transform::from_joint(&inverse_bind[i]).0.map(f32::from_bits);finite(&ib)?;
        let global=globals[i].ok_or(Error::ParentCycle)?.0.map(f32::from_bits);
        palette.push(Transform(inverse_bind_native(ib,global)?.map(f32::to_bits)).to_joint());
    }
    Ok(palette)
}
///Native loop92FF50 using an already prepared combined frame. Allocates a private
///palette, never mutates the source. Thus no source restore can be forgotten by a
///failed renderer. Does not claim to reproduce native backup allocation/refcounts.
pub fn transform_palette(combined:Transform,source:&[Joint])->Result<Vec<Joint>,Error> {
    check_sse_mode()?;if source.len()>u16::MAX as usize{return Err(Error::JointCount)}
    let p=combined.0.map(f32::from_bits);finite(&p)?;
    let mut out=Vec::new();out.try_reserve_exact(source.len()).map_err(|_|Error::Allocation)?;
    for joint in source {let c=Transform::from_joint(joint).0.map(f32::from_bits);finite(&c)?;
        out.push(Transform(palette_joint_native(c,p)?.map(f32::to_bits)).to_joint());}
    Ok(out)
}
#[derive(Debug,Clone)]
pub struct Prepared {pub skeleton:u64,pub frame:Transform,pub combined:Transform,pub palette:Vec<Joint>}
pub fn prepare(frame:Frame,inverse_owner:Transform,source:&Pose)->Result<Prepared,Error>{
    let frame=prepare_frame(frame)?;let combined=compose(inverse_owner,frame)?;
    let palette=transform_palette(combined,source.joints())?;
    Ok(Prepared{skeleton:source.skeleton(),frame,combined,palette})
}
include!("native_simple_type11_draw_scalar.rs");
#[cfg(test)]
#[path="native_simple_type11_draw_tests.rs"]
mod tests;

// Add to the integration copy of native_simple_type11_draw.rs, not the frozen source.
#[cfg(test)]
#[path = "native_simple_type11_palette_tests.rs"]
mod palette_native_tests;
