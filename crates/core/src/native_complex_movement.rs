//! Original 9389D0 finite motion subset. Optional native branches are explicit.
use crate::{native_complex_kinematics as kinematics,native_particle_euler_matrix as euler};
#[derive(Clone,Copy,Debug)]
pub struct Input {
    pub time:f32,pub birth:f32,pub previous_time:f32,pub initialized:bool,
    pub sampled_acceleration:[f32;3],pub sampled_velocity:[f32;3],pub sampled_drag:[f32;3],
    pub force:bool,pub lifetime_quad_rotation:bool,pub local_rotation:bool,
    pub owner_special_offset:bool,pub attach_owner:bool,pub velocity_alignment:bool,
    pub owner_matrix:Option<[f32;16]>,pub local_matrix:Option<[f32;16]>,

}
pub fn update(input:Input,record:&mut [f32;53])->Result<(),&'static str> {
    if input.force || input.lifetime_quad_rotation || input.owner_special_offset || input.velocity_alignment {
        return Err("Complex optional motion branch needs its native producer");
    }
    if !record.iter().chain([input.time,input.birth,input.previous_time].iter())
        .chain(&input.sampled_acceleration).chain(&input.sampled_velocity).chain(&input.sampled_drag)
        .all(|v|v.is_finite()) {return Err("unqualified nonfinite Complex motion record");}
    if (input.attach_owner && input.owner_matrix.is_none()) || (input.local_rotation && input.local_matrix.is_none()) {
        return Err("original owner/local matrix required");
    }
    for matrix in input.owner_matrix.iter().chain(input.local_matrix.iter()) {
        if matrix.iter().any(|v|!v.is_finite()) {return Err("unqualified nonfinite owner/local matrix");}
    }
    let mut result=*record;
    let v=|offset:usize|[record[offset/4],record[offset/4+1],record[offset/4+2]];
    let previous_position=v(0x30);
    let delta=if !input.initialized || input.previous_time==f32::from_bits(0xff7fffff) {0.}
        else {input.time-input.previous_time};
    let elapsed=input.time-input.birth;
    let k=kinematics::update(kinematics::Input {acceleration:input.sampled_acceleration,
        birth_acceleration:v(0x64),velocity:input.sampled_velocity,birth_velocity:v(0x58),
        drag:input.sampled_drag,birth_drag:v(0x70),stored_velocity:v(0x88),delta});
    result[34..37].copy_from_slice(&k.stored_velocity);
    let mut position=[0.;3];let mut rotation=[0.;3];
    for axis in 0..3 {
        let change=k.velocity[axis]*delta;
        result[37+axis]=if axis==0 {change+record[37+axis]} else {record[37+axis]+change};
        position[axis]=record[19+axis]+result[37+axis];
        // Original birth rotational acceleration, half factor, then elapsed twice.
        let acceleration=record[46+axis]*0.5;
        let speed=if axis==0 {acceleration*elapsed+record[43+axis]}
            else {record[43+axis]+acceleration*elapsed};
        let relative=speed*elapsed;
        rotation[axis]=record[40+axis]+relative;
    }
    result[52]=rotation[0];
    let degrees_to_radians=f32::from_bits(0x3c8efa35);
    let angles=[rotation[1]*degrees_to_radians,rotation[0]*degrees_to_radians,rotation[2]*degrees_to_radians];
    let mut matrix=euler::compose(angles)?;
    if input.local_rotation {matrix=multiply(&matrix,&input.local_matrix.unwrap());}
    matrix[12..15].copy_from_slice(&position);
    if input.attach_owner {matrix=multiply(&matrix,&input.owner_matrix.unwrap());}
    if record[49..52].iter().any(|v|*v!=0.) {
        let orbit=euler::compose([record[50]*elapsed,record[49]*elapsed,record[51]*elapsed])?;
        matrix=multiply(&matrix,&orbit);
    }
    let world_position=[matrix[12],matrix[13],matrix[14]];
    result[..16].copy_from_slice(&matrix);
    for axis in 0..3 {
        result[16+axis]=if input.initialized {
            let factor=1./(delta+f32::from_bits(0x3727c5ac));
            (world_position[axis]-previous_position[axis])*factor
        } else {0.};
    }
    *record=result;Ok(())
}

fn multiply(a:&[f32;16],b:&[f32;16])->[f32;16] {crate::camera_view::multiply(a,b)}
