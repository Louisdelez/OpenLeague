//! Whole944540 and9442F0/9444B0/9443D0 attribute policies.
fn extended_mul_add(value:f32,multiplier:f32,offset:f32)->Result<f32,&'static str> {
    #[cfg(any(target_arch="x86_64",target_arch="x86"))]
    {
        let mut previous=0u16;let control=0x037fu16;let mut result=0f32;
        // Original speed policy keeps multiplication/addition on the x87 stack.
        // Preserve the host control word and use the qualified 64-bit precision.
        unsafe {std::arch::asm!("fnstcw [{previous}]","fldcw [{control}]","fld dword ptr [{value}]","fmul dword ptr [{multiplier}]","fadd dword ptr [{offset}]","fstp dword ptr [{result}]","fldcw [{previous}]",previous=in(reg) &mut previous,control=in(reg) &control,value=in(reg) &value,multiplier=in(reg) &multiplier,offset=in(reg) &offset,result=in(reg) &mut result,options(nostack));}
        Ok(result)
    }
    #[cfg(not(any(target_arch="x86_64",target_arch="x86")))]
    {let _=(value,multiplier,offset);Err("native attribute x87 requires qualified x86 CPU")}
}
pub fn update(mode:u32,multiplier:u32,offset:u32,ages:&[u32],velocities:&[[u32;3]],auxiliary:&[u32],output:&mut [u32])->Result<(),&'static str> {
    if mode>3{return Ok(());}
    if ages.len()!=output.len() || (mode==2 && ages.len()!=velocities.len()) || (mode==3 && ages.len()!=auxiliary.len()){return Err("mismatched native attribute arrays");}
    let mul=f32::from_bits(multiplier);let add=f32::from_bits(offset);let mut values=output.to_vec();
    for i in 0..ages.len() {
        let age=f32::from_bits(ages[i]);if !(1.>age){continue;}
        if !mul.is_finite() || (mode!=0 && !add.is_finite()){return Err("unqualified native attribute coefficients");}
        values[i]=match mode {
            0=>multiplier,
            1=>(age*mul+add).to_bits(),
            2=>{
                let v=velocities[i].map(f32::from_bits);
                if !v.iter().all(|v|v.is_finite()){return Err("unqualified native attribute velocity");}
                let squared=(v[0]*v[0]+v[1]*v[1])+v[2]*v[2];
                if !squared.is_finite(){return Err("unqualified native attribute norm overflow");}
                let q=crate::native_particle_force_body::inverse_estimate(squared)?;
                let speed=if squared==0. {0.}else{((3.-((q*squared)*q))*(q*0.5))*squared};
                extended_mul_add(speed,mul,add)?.to_bits()
            },
            3=>{
                let value=f32::from_bits(auxiliary[i]);if !value.is_finite(){return Err("unqualified native auxiliary attribute");}
                (value*mul+add).to_bits()
            },_=>unreachable!()
        };
    }
    output.copy_from_slice(&values);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn all_attribute_policies_match504_original_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_attribute_policy_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),504);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let ages=words(&r["ages"]);let velocities=words(&r["velocities"]).chunks_exact(3).map(|v|v.try_into().unwrap()).collect::<Vec<_>>();let auxiliary=words(&r["auxiliary"]);let mut output=words(&r["initial"]);
            update(r["mode"].as_u64().unwrap() as u32,r["multiplier"].as_u64().unwrap() as u32,r["offset"].as_u64().unwrap() as u32,&ages,&velocities,&auxiliary,&mut output).unwrap();assert_eq!(output,words(&r["cpu"]["output"]),"output case{i}");
            assert_eq!(ages,words(&r["cpu"]["ages"]));assert_eq!(auxiliary,words(&r["cpu"]["auxiliary"]));assert_eq!(velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&r["cpu"]["velocities"]));
        }
        let mut output=[123];update(99,0,0,&[],&[],&[],&mut output).unwrap();assert_eq!(output,[123]);
        assert!(update(2,0,0,&[0],&[],&[],&mut output).is_err());assert_eq!(output,[123]);
    }
}
