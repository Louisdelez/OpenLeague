//! Original 93986C..939A30 and 939A8C..939AF3 surface composition.
//! Matrix preparation, probability sampling and optional terrain projection
//! belong to their native producers and are explicit inputs here.
#[derive(Clone, Copy, Debug)]
pub struct Input {
    pub prepared_matrix: [f32; 16],
    pub rotated_motion_vector: [f32; 3],
    pub accumulated_owner_translation: [f32; 3],
    pub owner_delta: [f32; 3],
    pub owner_extra_offset: [f32; 3],
    pub default_vector: [f32; 3],
    pub sampled_vector: [f32; 3],
    pub sampled_bind: f32,
    pub particle_life: f32,
    pub frame_delta: f32,
}
#[derive(Clone, Copy, Debug)]
pub struct Output {
    pub world_matrix: [f32; 16],
    pub surface_vector: [f32; 3],
    pub accumulated_owner_translation: [f32; 3],
}
pub fn compose_without_terrain(input: Input) -> Output {
    let mut accumulated = input.accumulated_owner_translation;
    let mut extra = input.default_vector;
    if input.sampled_bind > 0.0 && input.frame_delta > 0.0 {
        for axis in 0..3 {
            accumulated[axis] += input.owner_delta[axis] * input.sampled_bind;
            extra[axis] = input.owner_extra_offset[axis] * input.sampled_bind;
        }
    }
    let mut matrix = input.prepared_matrix;
    let mut vector = [0.0; 3];
    for axis in 0..3 {
        let life_vector = input.sampled_vector[axis] * input.particle_life;
        // Preserve the native two multiplications and addition order.
        let displacement = life_vector * input.particle_life;
        let translated = accumulated[axis] + displacement;
        matrix[12 + axis] += translated;
        vector[axis] = (life_vector + extra[axis]) + input.rotated_motion_vector[axis];
    }
    Output { world_matrix: matrix, surface_vector: vector,
             accumulated_owner_translation: accumulated }
}
