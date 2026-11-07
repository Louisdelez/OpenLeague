//! Selected numeric source factory and owned rotation-list producer.
//! Native DX namespace/binding and historical trigger order remain external.
use openleague_core::{native_random::Rng55,native_probability_curve::{ProbabilityCurve,apply_probability},
    native_scalar_parameter::{ScalarParameter,baked_scalar_index},native_complex_vectors::Field,
    native_complex_particle_storage::GlobalVectors,native_simple_rotation_list as rotation};
use crate::{relic_pickup_complex_profiles as profiles,relic_pickup_complex_simulation as complex,
    relic_pickup_seven_host as seven,relic_pickup_complex_source_matrix as matrix};
use serde_json::Value;

#[derive(Clone,Debug)]
pub struct RotationSource {pub scalar:ScalarParameter,pub axis:[u32;3]}
#[derive(Clone,Debug)]
pub struct Definition {
    pub index:usize,pub primary:matrix::PrimaryFields,pub modulation:[f32;4],
    pub provider_capability:bool,
    pub primary_mult_texture_pointer:u32,
    pub life:f32,pub life_scaled:bool,pub local_emitter:bool,pub limit:i32,
    pub single:u32,pub end_override:f32,pub rotations:Vec<RotationSource>,
    pub native_instance_channels:[u32;10],
}
fn word(value:&Value)->Result<u32,String>{value.as_u64().filter(|v|*v<=u32::MAX as u64).map(|v|v as u32).ok_or("invalid native source word".into())}
fn words<const N:usize>(value:&Value)->Result<[u32;N],String>{
    let values=value.as_array().ok_or("missing native source vector")?;
    if values.len()!=N{return Err("native source vector width".into());}
    values.iter().map(word).collect::<Result<Vec<_>,_>>()?.try_into().map_err(|_|"native source vector width".into())
}
fn floats<const N:usize>(value:&Value)->Result<[f32;N],String>{
    let values=words::<N>(value)?.map(f32::from_bits);
    if values.iter().any(|v|!v.is_finite()){return Err("nonfinite native source vector".into());}Ok(values)
}
fn probability(value:&Value)->Result<ProbabilityCurve,String>{
    let scalar=|key:&str|word(&value[key]).map(f32::from_bits);
    let vector=|key:&str|value[key].as_array().ok_or("missing native probability knots").and_then(|v|v.iter().map(|n|word(n).map(f32::from_bits).map_err(|_|"native probability word")).collect::<Result<Vec<_>,_>>());
    let result=ProbabilityCurve {present:true,constant:value["constant"].as_bool().ok_or("probability constant flag")?,
        constant_value:scalar("constant_word")?,fast:value["fast"].as_bool().ok_or("probability fast flag")?,
        begin:scalar("begin_word")?,difference:scalar("difference_word")?,times:vector("times_words")?,values:vector("values_words")?};
    if result.times.len()!=result.values.len() || result.times.iter().chain(&result.values)
        .chain([result.constant_value,result.begin,result.difference].iter()).any(|v|!v.is_finite()) {return Err("native probability unsupported".into());}
    Ok(result)
}
impl Definition {
    /// These are actual reader/constructor configuration outputs, not particle
    /// packet expected results. The external resource capability is mandatory.
    pub fn from_native_document(document:&Value,index:usize,provider_capability:bool)->Result<Self,String>{
        let group=*profiles::GROUPS.get(index).ok_or("Complex source group")?;
        let row=document["cases"].as_array().ok_or("native source cases")?.iter()
            .find(|v|v["group"]==group && v["provider_capability"]==provider_capability).ok_or("qualified source/capability absent")?;
        if document["passed"]!=true || document["actual_cpu_rsqrt_operations"].as_array().is_none(){return Err("physical x86 source admission absent".into());}
        let scalar=|key:&str|word(&row["primary_scalars"][key]);
        let primary=matrix::PrimaryFields {position:words(&row["primary_fields"]["position"])?,
            rotation_degrees:words(&row["primary_fields"]["rotation_degrees"])?,scale:words(&row["primary_fields"]["scale"])?};
        matrix::compose(primary).map_err(str::to_owned)?;
        let mut rotations=Vec::new();
        for input in row["rotation_list"].as_array().ok_or("source rotation list")? {
            let table=input["table_words"].as_array().ok_or("source scalar table")?.iter().map(|v|word(v).map(f32::from_bits)).collect::<Result<Vec<_>,_>>()?;
            if table.len()!=1 || !table[0].is_finite(){return Err("selected source retention table scope".into());}
            rotations.push(RotationSource {scalar:ScalarParameter {maximum:table[0],table,probability:probability(&input["probability"])?},axis:words(&input["axis"])?});
        }
        if rotations.len()>1{return Err("selected source rotation-list scope".into());}
        Ok(Self {index,primary,modulation:floats(&row["source_modulation_rgba_a4"])? ,provider_capability,primary_mult_texture_pointer:scalar("0x40")?,
            life:f32::from_bits(scalar("0x2f0")?),life_scaled:scalar("0x2f4")?&255!=0,
            local_emitter:scalar("0x2e8")?&255!=0,limit:scalar("0x314")? as i32,
            single:scalar("0x334")?,end_override:f32::from_bits(scalar("0x33c")?),rotations,
            native_instance_channels:words(&row["native_instance_c0_table_source_words"])?})
    }
    /// 912E5F..9130DE samples a one-entry list only for zero retention. The
    /// Scalar object is retained; this temporary random angle is discarded.
    pub fn retained(&self,rng:&mut Rng55)->Result<Vec<RotationSource>,&'static str>{
        let mut next=rng.clone();let mut retained=Vec::new();
        for source in &self.rotations {
            let temporary=apply_probability(Some(&source.scalar.probability),source.scalar.table[0],&mut next);
            if !temporary.is_finite(){return Err("source retention became nonfinite");}
            if temporary!=0. {retained.push(source.clone());}
        }
        *rng=next;Ok(retained)
    }
}
/// Explicit selected local actor/storage context. The original global actor
/// and source activation chain are not silently replaced with these inputs.
#[derive(Clone,Copy)]
pub struct LocalPolicy {pub life_owner_scale:f32,pub actor_rate_scale:f32,pub globals:GlobalVectors,
    pub motion_scratch:[u32;3],pub owner_flags:u32,pub owner_extra:[f32;3],pub scale_owner:f32}
impl LocalPolicy {
    fn check(self)->Result<(),String>{
        if [self.life_owner_scale,self.actor_rate_scale,self.scale_owner].iter().chain(&self.owner_extra).any(|v|!v.is_finite()) {
            return Err("nonfinite explicit local source policy".into());
        }
        if self.owner_flags!=0 || self.owner_extra!=[0.;3] || self.motion_scratch!=[0;3] {
            return Err("selected source policy outside no-attribute/shape/trail scope".into());
        }
        if self.globals.unit.iter().chain(&self.globals.scale).chain(&self.globals.anchor).any(|v|!f32::from_bits(*v).is_finite()) {
            return Err("nonfinite supplied source storage globals".into());
        }
        Ok(())
    }
}
#[derive(Clone,Debug)]
pub struct Context {pub definition:Definition,pub retained:Vec<RotationSource>,pub start:f32,
    pub binding:[u64;2],pub instance_matrix:[u32;16],pub system_scales:[u32;3],
    pub distance:f32,pub last_birth_position:Option<[f32;3]>}
#[derive(Clone)]
pub struct Sources {pub definitions:[Definition;3],pub policy:LocalPolicy}
impl Sources {
    pub fn new(document:&Value,provider_capabilities:[bool;3],policy:LocalPolicy)->Result<Self,String>{
        policy.check()?;
        let definitions=(0..3).map(|i|Definition::from_native_document(document,i,provider_capabilities[i])).collect::<Result<Vec<_>,_>>()?
            .try_into().map_err(|_|"source group count")?;
        Ok(Self {definitions,policy})
    }
}
fn multiply(left:[f32;16],right:[f32;16])->[f32;16]{
    std::array::from_fn(|i| {let row=(i/4)*4;let col=i%4;let mut v=right[col]*left[row];
        v+=right[4+col]*left[row+1];v+=right[8+col]*left[row+2];v+=right[12+col]*left[row+3];v})
}
fn native_identity()->[f32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.})}
/// Whole5FA7C0 finite SSE refinement. RSQRTSS executes on the qualified x86 CPU.
fn native_sqrt(value:f32)->Result<f32,&'static str>{
    if !value.is_finite() || value<0. {return Err("birth distance norm unsupported");}
    #[cfg(target_arch="x86_64")]
    let estimate=unsafe {use std::arch::x86_64::*;_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value)))};
    #[cfg(target_arch="x86")]
    let estimate=unsafe {use std::arch::x86::*;_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value)))};
    #[cfg(not(any(target_arch="x86_64",target_arch="x86")))]
    return Err("birth distance requires qualified x86 CPU");
    #[cfg(any(target_arch="x86_64",target_arch="x86"))]
    {Ok(if value==0. {0.}else{((3.-((estimate*value)*estimate))*(estimate*0.5))*value})}
}
fn check_context(context:&Context,group:usize,owner:seven::Owner)->Result<(),&'static str>{
    if context.definition.index!=group || context.binding!=[owner.root_token,owner.model_token] {return Err("Complex source owner/group binding changed");}
    if owner.matrix.iter().chain(&owner.position).any(|v|!f32::from_bits(*v).is_finite()){return Err("Complex source owner pose nonfinite");}Ok(())
}
impl seven::Sources for Sources {
    type Context=Context;
    fn create(&self,group:usize,owner:seven::Owner,time:f32,rng:&mut Rng55)->Result<seven::Created<Context>,String>{
        if !time.is_finite(){return Err("Complex source start nonfinite".into());}
        self.policy.check()?;
        if owner.matrix.iter().chain(&owner.position).any(|v|!f32::from_bits(*v).is_finite()){return Err("Complex source owner pose nonfinite".into());}
        let definition=self.definitions.get(group).ok_or("Complex source group")?.clone();
        let retained=definition.retained(rng).map_err(str::to_owned)?;
        // Whole933000 initializes zero stop flags and no counters; duration uses
        // the actual e-life/e-life-scale reader outputs and supplied actor scale.
        let instance=complex::Instance {duration:openleague_core::native_complex_instance_life::initial_duration(definition.life,definition.life_scaled,self.policy.life_owner_scale),
            rate_owner_scale:self.policy.actor_rate_scale,life_owner_scale:self.policy.life_owner_scale,
            life_coefficients:[0.;3],life_symmetry:0,limit:definition.limit,single_flag:definition.single,
            stopped_flag:0,past_end:false,globals:self.policy.globals,motion_scratch:self.policy.motion_scratch};
        let instance_matrix=matrix::compose(definition.primary).map_err(str::to_owned)?.words();
        // Actual93DB40/empty93DF20 local Troy instance scales BC/C0/C4.
        let system_scales=openleague_core::native_troy_resource_initial::empty_instance(0,[0;3],0.).map_err(str::to_owned)?.scales;
        Ok(seven::Created {instance,context:Context {definition,retained,start:time,binding:[owner.root_token,owner.model_token],instance_matrix,system_scales,distance:f32::MIN,last_birth_position:None}})
    }
    fn prepare_birth(&self,group:usize,context:&mut Context,_:complex::Instance,owner:seven::Owner,birth:&complex::SampledBirth,
        emitter_ordinal:u32,rng:&mut Rng55)->Result<complex::PreparedBirth,&'static str>{
        check_context(context,group,owner)?;
        if birth.schedule.position.iter().chain(birth.vectors.iter().flatten()).any(|v|!v.is_finite()){
            return Err("Complex sampled birth source nonfinite");
        }
        let mut next_rng=rng.clone();
        let mut pose=native_identity();
        if context.definition.local_emitter {
            pose[..12].copy_from_slice(&std::array::from_fn::<_,12,_>(|i|f32::from_bits(owner.matrix[i])));pose[15]=f32::from_bits(owner.matrix[15]);
        }
        pose[12..15].copy_from_slice(&birth.schedule.position);
        pose=multiply(pose,context.instance_matrix.map(f32::from_bits));
        // Raw sampling9350C1 consumes no RNG. Probability936239 follows the
        // ordinary shared UV draw, once per birth. Its matrix transforms local
        // p-offset; it is separate from the packet's emitter/owner pose.
        let elements=context.retained.iter().map(|s| {
            let at=baked_scalar_index(s.scalar.table.len(),birth.emitter_age).map_err(|_|"rotation raw sample")?;
            Ok(rotation::Element {angle:s.scalar.table[at].to_bits(),axis:s.axis,probability:Some(&s.scalar.probability)})
        }).collect::<Result<Vec<_>,&'static str>>()?;
        let evaluated=rotation::evaluate(&elements,&mut next_rng)?;
        let raw=birth.vectors[Field::Offset as usize].map(f32::to_bits);
        let (offset,_)=evaluated.apply(raw,birth.vectors[Field::Velocity as usize].map(f32::to_bits))?;
        let merged_offset=std::array::from_fn(|a|f32::from_bits(offset[a])+birth.vectors[Field::PostOffset as usize][a]);
        let point:[f32;3]=pose[12..15].try_into().unwrap();
        let distance=if context.distance<0. {0.}else{
            let previous=context.last_birth_position.ok_or("native birth distance position absent")?;
            let delta:[f32;3]=std::array::from_fn(|i|point[i]-previous[i]);
            let squared=(delta[0]*delta[0]+delta[1]*delta[1])+delta[2]*delta[2];
            // Original9368BA x87 adds the stored f32 anchor, then stores f32.
            (f64::from(native_sqrt(squared)?)+f64::from(context.distance)) as f32
        };
        if pose.iter().chain(&merged_offset).chain([distance].iter()).any(|v|!v.is_finite()){return Err("Complex prepared birth source nonfinite");}
        context.distance=distance;context.last_birth_position=Some(point);*rng=next_rng;
        Ok(complex::PreparedBirth {pose,merged_offset,world_acceleration:[0.;3],orbit_secondary:[0.;3],uv_aux:[0.;2],
            rate_multiplier:1.,distance_anchor:distance,emitter_ordinal})
    }
    fn frame(&self,group:usize,context:&mut Context,mut instance:complex::Instance,previous:seven::Owner,current:seven::Owner,time:f32,_:&mut Rng55)
        ->Result<seven::FrameSource,String>{
        check_context(context,group,current).map_err(str::to_owned)?;
        check_context(context,group,previous).map_err(str::to_owned)?;
        context.instance_matrix=matrix::compose(context.definition.primary).map_err(str::to_owned)?.words();
        instance.past_end=openleague_core::native_complex_instance_life::evaluate_end_flag(time,context.start,instance.duration,
            self.policy.owner_flags,context.definition.end_override).past_end;
        let profile=profiles::Profile::load(group).map_err(str::to_owned)?;
        Ok(seven::FrameSource {instance,particles:complex::FrameInputs {
            owner_delta:std::array::from_fn(|a|f32::from_bits(current.position[a])-f32::from_bits(previous.position[a])),
            owner_extra:self.policy.owner_extra,default_vector:std::array::from_fn(|i|f32::from_bits(context.definition.native_instance_channels[i])),
            scale_owner:self.policy.scale_owner,lookup_modes:profile.lookup.modes,lookup_scale:profile.lookup.scale,lookup_offset:profile.lookup.offset,
            surface_direct:false,local_matrix:None,attach_matrix:None}})
    }
}
