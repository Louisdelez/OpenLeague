//! Original 9394FB..93972D. The owner matrix and motion record are native inputs.
use crate::{camera_view, native_simple_type11_draw, native_complex_surface_rotation};
#[derive(Clone,Copy,Debug)]
pub struct Input {
    pub owner_matrix:[f32;16],
    pub motion_matrix:[f32;16],
    pub motion_vector:[f32;3],
    pub direct:bool,
}
#[derive(Clone,Copy,Debug)]
pub struct Prepared {pub matrix:[f32;16],pub vector:[f32;3]}
pub fn prepare(input:Input)->Result<Prepared,native_simple_type11_draw::Error> {
    if !input.owner_matrix.iter().chain(&input.motion_matrix).chain(&input.motion_vector).all(|v|v.is_finite()) {
        return Err(native_simple_type11_draw::Error::NonFinite);
    }
    if input.direct {
        let mut matrix=input.motion_matrix;
        for axis in 0..3 {matrix[12+axis]=input.owner_matrix[12+axis]+matrix[12+axis];}
        Ok(Prepared {matrix,vector:input.motion_vector})
    } else {
        // 8DF790 receives output in ECX, motion matrix in EDX, owner matrix
        // on the stack. It is a three-operand helper, not an in-place multiply.
        let matrix=camera_view::multiply(&input.motion_matrix,&input.owner_matrix);
        let q=native_simple_type11_draw::matrix_quaternion(input.owner_matrix)?;
        Ok(Prepared {matrix,vector:native_complex_surface_rotation::rotate_vector(q,input.motion_vector)})
    }
}
