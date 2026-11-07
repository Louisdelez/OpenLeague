//! Selected pickup force producers: original 93B2F0 population and 93BBD0
//! frame advance for world-space acceleration and final-axis descriptors.
//! Definitions and parameters come from the native reader; resource IDs remain
//! caller owned. This module does not create a pickup event or admit GPU draws.
use openleague_core::{
    native_particle_force_body as body,
    native_particle_force_graph as graph,
    native_random::Rng55,
    native_vector_parameter::VectorParameter,
};

#[derive(Clone, Debug)]
pub struct Descriptor {
    pub resource: u32,
    pub parameter: VectorParameter,
    pub local_space: bool,
}

#[derive(Clone, Debug)]
struct Instance {
    descriptor: Descriptor,
    multiplier: [f32; 3],
}

#[derive(Clone, Debug, Default)]
pub struct Population {
    acceleration: Vec<Instance>,
    axes: Vec<Instance>,
}

impl Population {
    /// 93B2F0 visits acceleration descriptors before final-axis descriptors.
    /// Each instance samples X/Y/Z multipliers once through original 9492F0's
    /// existing Rust port. Population and RNG commit together after admission.
    pub fn create(
        acceleration: &[Descriptor],
        axes: &[Descriptor],
        rng: &mut Rng55,
    ) -> Result<Self, &'static str> {
        if acceleration.len() > 1 || axes.len() > 1 {
            return Err("pickup force topology outside qualified descriptors");
        }
        let mut keys = std::collections::BTreeSet::new();
        for source in acceleration.iter().chain(axes) {
            if source.resource == 0 || !keys.insert(source.resource) {
                return Err("pickup force descriptor resource absent or duplicated");
            }
            if source.local_space {
                return Err("pickup local-space field producer is not qualified");
            }
            if source.parameter.table.is_empty()
                || source.parameter.table.iter().flatten().any(|v| !v.is_finite())
                || source.parameter.probabilities.iter().any(|p| {
                    !p.constant || !p.constant_value.is_finite()
                })
            {
                return Err("pickup force parameter outside qualified finite constant probabilities");
            }
        }
        let mut next_rng = rng.clone();
        let mut populate = |sources: &[Descriptor]| {
            sources.iter().map(|descriptor| Instance {
                multiplier: descriptor.parameter.create_instance_multiplier([1.; 3], &mut next_rng),
                descriptor: descriptor.clone(),
            }).collect::<Vec<_>>()
        };
        let result = Self { acceleration: populate(acceleration), axes: populate(axes) };
        if result.acceleration.iter().chain(&result.axes)
            .flat_map(|i| i.multiplier).any(|v| !v.is_finite()) {
            return Err("pickup force instance multiplier became nonfinite");
        }
        *rng = next_rng;
        Ok(result)
    }

    pub fn is_empty(&self) -> bool { self.acceleration.is_empty() && self.axes.is_empty() }

    /// 93AF70 and 93C700 sample the descriptor table at emitter progress and
    /// multiply by the previously stored instance variation. Authored pickup
    /// fields are world-space, so the owner matrix is not read in these paths.
    pub fn frame(&self, progress: f32) -> Result<OwnedFrame, &'static str> {
        if !progress.is_finite() { return Err("pickup force progress is nonfinite"); }
        let sample = |instance: &Instance| {
            instance.descriptor.parameter.sample_instance_age(progress, instance.multiplier)
                .map_err(|_| "pickup force vector sample failed")
        };
        let acceleration = if self.acceleration.is_empty() {
            None
        } else {
            // Original aggregate begins at +0 and adds each current child.
            let mut sum = [0f32; 3];
            for instance in &self.acceleration {
                let vector = sample(instance)?;
                for axis in 0..3 { sum[axis] += vector[axis]; }
            }
            if sum.iter().any(|v| !v.is_finite()) {
                return Err("pickup acceleration aggregate became nonfinite");
            }
            Some(sum.map(f32::to_bits))
        };
        let mut axis_ids = Vec::with_capacity(self.axes.len());
        let mut axes = Vec::with_capacity(self.axes.len());
        for instance in &self.axes {
            let vector = normalize_axis(sample(instance)?)?;
            axis_ids.push(instance.descriptor.resource);
            axes.push((instance.descriptor.resource, vector.map(f32::to_bits)));
        }
        Ok(OwnedFrame { acceleration, axis_ids, axes })
    }
}

#[derive(Clone, Debug)]
pub struct OwnedFrame {
    pub acceleration: Option<[u32; 3]>,
    pub axis_ids: Vec<u32>,
    pub axes: Vec<(u32, [u32; 3])>,
}

impl OwnedFrame {
    /// The graph consumer replaces delta with the actual particle frame delta.
    /// Orbit descriptors enter final_children, never the circular movement flag.
    pub fn graph(&self) -> graph::Input<'_> {
        graph::Input {
            body: body::Input {
                acceleration: self.acceleration,
                points: &[], dampings: &[], children: &[],
                final_children: &self.axis_ids, delta: 0,
            },
            random_forces: &[], axis_forces: &self.axes,
        }
    }
}

/// Original 93C863..93C8EC normalizes using 5FA7C0's approximate square root.
/// Multiplication order and reciprocal division preserve its unit-Y output
/// 0x3f800001; ordinary sqrt/normalize would produce a different axis.
fn normalize_axis(vector: [f32; 3]) -> Result<[f32; 3], &'static str> {
    if vector.iter().any(|v| !v.is_finite()) {
        return Err("pickup axis sample is nonfinite");
    }
    let squared = (vector[0] * vector[0] + vector[1] * vector[1]) + vector[2] * vector[2];
    if !squared.is_finite() { return Err("pickup axis squared norm overflow"); }
    let estimate = inverse_estimate(squared)?;
    let mut length = ((3. - ((estimate * squared) * estimate)) * (estimate * 0.5)) * squared;
    if squared == 0. { length = 0.; }
    let result = if length != 0. {
        let reciprocal = 1. / length;
        vector.map(|v| v * reciprocal)
    } else { vector };
    if result.iter().any(|v| !v.is_finite()) { return Err("pickup normalized axis is nonfinite"); }
    Ok(result)
}

fn inverse_estimate(value: f32) -> Result<f32, &'static str> {
    #[cfg(target_arch = "x86_64")]
    { use std::arch::x86_64::*; Ok(unsafe { _mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value))) }) }
    #[cfg(target_arch = "x86")]
    { use std::arch::x86::*; Ok(unsafe { _mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value))) }) }
    #[cfg(not(any(target_arch = "x86", target_arch = "x86_64")))]
    { let _ = value; Err("native pickup axis norm requires qualified x86 CPU") }
}
