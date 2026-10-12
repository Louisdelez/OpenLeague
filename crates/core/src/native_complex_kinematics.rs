//! Original 938AE1..938D66 acceleration, base velocity and drag limiter.
//! Normalized table samples and native per-particle frame delta are caller inputs.
#[derive(Clone,Copy,Debug)]
pub struct Input {
    pub acceleration:[f32;3],pub birth_acceleration:[f32;3],
    pub velocity:[f32;3],pub birth_velocity:[f32;3],
    pub drag:[f32;3],pub birth_drag:[f32;3],
    pub stored_velocity:[f32;3],pub delta:f32,
}
#[derive(Clone,Copy,Debug)]
pub struct Output {pub stored_velocity:[f32;3],pub velocity:[f32;3]}
pub fn update(input:Input)->Output {
    let mut stored=input.stored_velocity;
    let mut velocity=[0.;3];let mut drag=[0.;3];
    for i in 0..3 {
        let acceleration=input.acceleration[i]+input.birth_acceleration[i];
        stored[i]=(acceleration*input.delta)+stored[i];
        velocity[i]=stored[i]+(input.velocity[i]+input.birth_velocity[i]);
        drag[i]=input.birth_drag[i]+input.drag[i];
    }
    if drag.iter().any(|v|*v!=0.) {
        for i in 0..3 {
            let product=drag[i]*velocity[i];
            let negative=f32::from_bits(product.to_bits()^0x80000000);
            let mut correction=negative*input.delta;
            if (correction+velocity[i])*velocity[i]<0. {
                correction=f32::from_bits(velocity[i].to_bits()^0x80000000);
            }
            stored[i]+=correction;velocity[i]=correction+velocity[i];
        }
    }
    Output {stored_velocity:stored,velocity}
}
