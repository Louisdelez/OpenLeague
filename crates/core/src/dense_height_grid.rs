//! Local, safe f32 sampler for the separate native sampled-height payload.
//!
//! Source basis: copied Map10 metadata/payload and static scalar getter 0x8efb60.
//! This parses a row-major f32le payload, not the full .aimesh_ngrid container.
//! Coordinates are native X/Z. Bounds come from metadata, not traversal cells.
//!
//! The native getter mixes SSE f32 indexing with x87 interpolation and returns
//! ST0. This implementation deliberately evaluates each interpolation operation
//! as ordinary Rust f32. It does not claim native floating-point bit parity.
//! Invalid/outside input is an error, rather than the native getter's zero path.
//! No walkability mask is accepted: a blocked traversal cell still has height.

use std::fmt;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Axis { X, Z }

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct GridSpec {
    /// [metadata.min[0], metadata.min[2]].
    pub min_xz: [f32; 2],
    /// [metadata.max[0], metadata.max[2]], inclusive.
    pub max_xz: [f32; 2],
    /// sampledHeights.width and sampledHeights.height; not traversal dimensions.
    pub dimensions: [usize; 2],
    /// sampledHeights.distance; not traversal cellSize.
    pub spacing_xz: [f32; 2],
}

#[derive(Clone, Debug, PartialEq)]
pub enum Error {
    DimensionsTooSmall,
    SampleCountOverflow,
    DimensionExceedsF32IndexPrecision { axis: Axis, count: usize },
    InvalidBounds { axis: Axis },
    InvalidSpacing { axis: Axis },
    NonFiniteNormalizedExtent { axis: Axis },
    LastSampleNotCovered { axis: Axis, expected_last: usize, normalized_max: f32 },
    PayloadLength { expected: usize, actual: usize },
    NonFiniteSample { index: usize, bits: u32 },
    NonFiniteCoordinate { axis: Axis },
    OutsideBounds { axis: Axis },
    InvalidNormalizedCoordinate { axis: Axis },
    NonFiniteInterpolation,
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::DimensionsTooSmall => write!(f, "sampled-height dimensions must each be at least two"),
            Self::SampleCountOverflow => write!(f, "sampled-height count or byte length overflows usize"),
            Self::DimensionExceedsF32IndexPrecision { axis, count } => write!(f, "{axis:?} dimension {count} exceeds exact f32 integer index range"),
            Self::InvalidBounds { axis } => write!(f, "{axis:?} bounds must be finite and strictly increasing"),
            Self::InvalidSpacing { axis } => write!(f, "{axis:?} spacing must be finite and positive"),
            Self::NonFiniteNormalizedExtent { axis } => write!(f, "{axis:?} normalized extent is nonfinite"),
            Self::LastSampleNotCovered { axis, expected_last, normalized_max } => write!(f, "{axis:?} maximum normalizes to {normalized_max}, outside final sample index {expected_last}"),
            Self::PayloadLength { expected, actual } => write!(f, "sampled-height payload needs {expected} bytes, received {actual}"),
            Self::NonFiniteSample { index, bits } => write!(f, "sampled-height value {index} is nonfinite (bits {bits:08x})"),
            Self::NonFiniteCoordinate { axis } => write!(f, "{axis:?} coordinate is nonfinite"),
            Self::OutsideBounds { axis } => write!(f, "{axis:?} coordinate is outside inclusive height bounds"),
            Self::InvalidNormalizedCoordinate { axis } => write!(f, "{axis:?} normalized coordinate is outside validated sample indices"),
            Self::NonFiniteInterpolation => write!(f, "local f32 height interpolation produced a nonfinite result"),
        }
    }
}

impl std::error::Error for Error {}

/// Immutable borrowed payload. Parse scans finiteness once and allocates nothing.
#[derive(Clone, Copy, Debug)]
pub struct DenseHeightGrid<'a> {
    spec: GridSpec,
    bytes: &'a [u8],
}

impl<'a> DenseHeightGrid<'a> {
    pub fn parse(spec: GridSpec, bytes: &'a [u8]) -> Result<Self, Error> {
        let [width, height] = spec.dimensions;
        if width < 2 || height < 2 { return Err(Error::DimensionsTooSmall); }
        let expected = width.checked_mul(height)
            .and_then(|count| count.checked_mul(4))
            .ok_or(Error::SampleCountOverflow)?;
        for (i, axis) in [Axis::X, Axis::Z].iter().copied().enumerate() {
            let count = spec.dimensions[i];
            // All integer indices used by the f32 fractional-part subtraction
            // must be exactly representable. This is far above Map10's 613/259.
            if count - 1 > 16_777_216 {
                return Err(Error::DimensionExceedsF32IndexPrecision { axis, count });
            }
            let (min, max, spacing) = (spec.min_xz[i], spec.max_xz[i], spec.spacing_xz[i]);
            if !min.is_finite() || !max.is_finite() || min >= max {
                return Err(Error::InvalidBounds { axis });
            }
            if !spacing.is_finite() || spacing <= 0.0 {
                return Err(Error::InvalidSpacing { axis });
            }
            let extent = max - min;
            let normalized_max = extent / spacing;
            if !normalized_max.is_finite() {
                return Err(Error::NonFiniteNormalizedExtent { axis });
            }
            // Native final-interval policy: when trunc(q) is the final index,
            // use the preceding pair with fraction one. Preserve that plateau
            // if metadata.max lies slightly beyond the last sample knot.
            // Reject missing coverage and an extra row/column instead of clamping.
            if normalized_max.trunc() as usize != count - 1 {
                return Err(Error::LastSampleNotCovered {
                    axis, expected_last: count - 1, normalized_max,
                });
            }
        }
        if bytes.len() != expected {
            return Err(Error::PayloadLength { expected, actual: bytes.len() });
        }
        for (index, chunk) in bytes.chunks_exact(4).enumerate() {
            let bits = u32::from_le_bytes([chunk[0], chunk[1], chunk[2], chunk[3]]);
            if !f32::from_bits(bits).is_finite() {
                return Err(Error::NonFiniteSample { index, bits });
            }
        }
        Ok(Self { spec, bytes })
    }

    pub fn spec(&self) -> GridSpec { self.spec }

    /// Local f32 bilinear height, with native finite-coordinate index/edge policy.
    /// Callers must propagate errors; absent heights must not become zero.
    pub fn sample_local_f32(&self, xz: [f32; 2]) -> Result<f32, Error> {
        let (x0, x1, u) = self.interval(xz[0], 0, Axis::X)?;
        let (z0, z1, v) = self.interval(xz[1], 1, Axis::Z)?;
        let a = 1.0_f32 - u;
        let b = 1.0_f32 - v;
        let h0 = a * self.value(x0, z0) + u * self.value(x1, z0);
        let h1 = a * self.value(x0, z1) + u * self.value(x1, z1);
        let height = b * h0 + v * h1;
        if height.is_finite() { Ok(height) } else { Err(Error::NonFiniteInterpolation) }
    }

    fn interval(&self, value: f32, i: usize, axis: Axis) -> Result<(usize, usize, f32), Error> {
        if !value.is_finite() { return Err(Error::NonFiniteCoordinate { axis }); }
        if value < self.spec.min_xz[i] || value > self.spec.max_xz[i] {
            return Err(Error::OutsideBounds { axis });
        }
        let offset = value - self.spec.min_xz[i];
        let q = offset / self.spec.spacing_xz[i];
        if !q.is_finite() || q < 0.0 {
            return Err(Error::InvalidNormalizedCoordinate { axis });
        }
        let index = q.trunc() as usize;
        let count = self.spec.dimensions[i];
        if index >= count { return Err(Error::InvalidNormalizedCoordinate { axis }); }
        if index == count - 1 {
            Ok((index - 1, index, 1.0))
        } else {
            Ok((index, index + 1, q - index as f32))
        }
    }

    fn value(&self, column: usize, row: usize) -> f32 {
        // Private call sites use validated intervals. parse checked the complete
        // width*height*4 product and exact payload length, so these cannot overflow.
        let offset = (row * self.spec.dimensions[0] + column) * 4;
        f32::from_le_bytes([
            self.bytes[offset], self.bytes[offset + 1],
            self.bytes[offset + 2], self.bytes[offset + 3],
        ])
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn spec() -> GridSpec {
        GridSpec { min_xz: [10.0, 20.0], max_xz: [12.0, 24.0],
            dimensions: [2, 2], spacing_xz: [2.0, 4.0] }
    }
    fn payload(values: &[f32]) -> Vec<u8> {
        values.iter().flat_map(|value| value.to_le_bytes()).collect()
    }
    fn parse_error(spec: GridSpec, bytes: &[u8]) -> Error {
        DenseHeightGrid::parse(spec, bytes).unwrap_err()
    }

    #[test]
    fn little_endian_row_order_and_inclusive_four_corners() {
        // Explicit f32le words 0,4,8,12: distinct axes catch row/column transposition.
        let bytes = [0,0,0,0, 0,0,128,64, 0,0,0,65, 0,0,64,65];
        let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        for (point, expected) in [([10.0,20.0],0.0), ([12.0,20.0],4.0),
                                 ([10.0,24.0],8.0), ([12.0,24.0],12.0)] {
            assert_eq!(grid.sample_local_f32(point), Ok(expected));
        }
    }

    #[test]
    fn hand_computed_nonboolean_interior_fractions() {
        let bytes = payload(&[0.0, 4.0, 8.0, 12.0]);
        let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        // u=1/4,v=3/4; H0=1,H1=9; (1/4)*1+(3/4)*9=7.
        assert_eq!(grid.sample_local_f32([10.5,23.0]), Ok(7.0));
        // u=v=1/2; (0+4+8+12)/4=6.
        assert_eq!(grid.sample_local_f32([11.0,22.0]), Ok(6.0));
    }

    #[test]
    fn last_column_and_last_row_use_the_preceding_pair() {
        let mut meta = spec(); meta.dimensions = [3,2]; meta.max_xz[0] = 14.0;
        let bytes = payload(&[0.0,4.0,20.0, 8.0,12.0,28.0]);
        let grid = DenseHeightGrid::parse(meta, &bytes).unwrap();
        // Last column: 3/4*20 + 1/4*28=22, not a row-wrapped pair.
        assert_eq!(grid.sample_local_f32([14.0,21.0]), Ok(22.0));
        // Last row: midpoint between8 and12=10.
        assert_eq!(grid.sample_local_f32([11.0,24.0]), Ok(10.0));
        assert_eq!(grid.sample_local_f32([14.0,24.0]), Ok(28.0));
    }

    #[test]
    fn one_ulp_outside_each_boundary_is_an_error() {
        let bytes = payload(&[0.0,4.0,8.0,12.0]);
        let meta = spec(); let grid = DenseHeightGrid::parse(meta, &bytes).unwrap();
        for (i, axis) in [Axis::X,Axis::Z].iter().copied().enumerate() {
            let mut below = meta.min_xz;
            below[i] = f32::from_bits(meta.min_xz[i].to_bits() - 1);
            assert_eq!(grid.sample_local_f32(below), Err(Error::OutsideBounds { axis }));
            let mut above = meta.max_xz;
            above[i] = f32::from_bits(meta.max_xz[i].to_bits() + 1);
            assert_eq!(grid.sample_local_f32(above), Err(Error::OutsideBounds { axis }));
        }
    }

    #[test]
    fn nonfinite_query_coordinates_are_explicit_errors() {
        let bytes = payload(&[0.0,4.0,8.0,12.0]);
        let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        for invalid in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY] {
            assert_eq!(grid.sample_local_f32([invalid,22.0]), Err(Error::NonFiniteCoordinate { axis: Axis::X }));
            assert_eq!(grid.sample_local_f32([11.0,invalid]), Err(Error::NonFiniteCoordinate { axis: Axis::Z }));
        }
    }

    #[test]
    fn no_nonfinite_payload_value_is_silently_replaced() {
        for invalid in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY] {
            let bytes = payload(&[0.0,4.0,invalid,12.0]);
            assert_eq!(parse_error(spec(), &bytes), Error::NonFiniteSample { index: 2, bits: invalid.to_bits() });
        }
    }

    #[test]
    fn payload_length_is_exact_including_no_trailing_bytes() {
        for length in [0,1,15,17,20] {
            assert_eq!(parse_error(spec(), &vec![0;length]), Error::PayloadLength { expected: 16, actual: length });
        }
    }

    #[test]
    fn dimension_overflow_and_insufficient_lattices_are_rejected() {
        for dimensions in [[0,2],[2,0],[1,2],[2,1]] {
            let mut meta = spec(); meta.dimensions = dimensions;
            assert_eq!(parse_error(meta, &[]), Error::DimensionsTooSmall);
        }
        let mut meta = spec(); meta.dimensions = [usize::MAX,2];
        assert_eq!(parse_error(meta, &[]), Error::SampleCountOverflow);
        meta.dimensions = [16_777_218,2];
        assert_eq!(parse_error(meta, &[]), Error::DimensionExceedsF32IndexPrecision { axis: Axis::X, count: 16_777_218 });
    }

    #[test]
    fn invalid_metadata_never_creates_a_grid() {
        for (i, axis) in [Axis::X,Axis::Z].iter().copied().enumerate() {
            for invalid in [0.0,-1.0,f32::NAN,f32::INFINITY] {
                let mut meta = spec(); meta.spacing_xz[i] = invalid;
                assert_eq!(parse_error(meta, &[]), Error::InvalidSpacing { axis });
            }
            for invalid in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY] {
                let mut meta = spec(); meta.min_xz[i] = invalid;
                assert_eq!(parse_error(meta, &[]), Error::InvalidBounds { axis });
                let mut meta = spec(); meta.max_xz[i] = invalid;
                assert_eq!(parse_error(meta, &[]), Error::InvalidBounds { axis });
            }
            let mut meta = spec(); meta.max_xz[i] = meta.min_xz[i];
            assert_eq!(parse_error(meta, &[]), Error::InvalidBounds { axis });
        }
    }

    #[test]
    fn impossible_normalized_extents_are_rejected_before_indexing() {
        let mut meta = spec(); meta.min_xz[0] = -f32::MAX; meta.max_xz[0] = f32::MAX;
        assert_eq!(parse_error(meta, &[]), Error::NonFiniteNormalizedExtent { axis: Axis::X });
        let mut meta = spec(); meta.spacing_xz[0] = f32::from_bits(1);
        assert_eq!(parse_error(meta, &[]), Error::NonFiniteNormalizedExtent { axis: Axis::X });
        for (max, q) in [(11.0,0.5),(14.0,2.0)] {
            let mut meta = spec(); meta.max_xz[0] = max;
            assert_eq!(parse_error(meta, &[]), Error::LastSampleNotCovered { axis: Axis::X, expected_last: 1, normalized_max: q });
        }
    }

    #[test]
    fn final_interval_metadata_preserves_native_plateau_without_extrapolation() {
        let mut meta = spec(); meta.max_xz[0] = 13.0; // qmax=1.5, final trunc index1.
        let bytes = payload(&[0.0,4.0,8.0,12.0]);
        let grid = DenseHeightGrid::parse(meta, &bytes).unwrap();
        assert_eq!(grid.sample_local_f32([12.0,22.0]), Ok(8.0));
        assert_eq!(grid.sample_local_f32([13.0,22.0]), Ok(8.0));
    }

    #[test]
    fn adjacent_cells_join_continuously_for_a_hand_computed_plane() {
        let meta = GridSpec { min_xz: [0.0,0.0], max_xz: [2.0,2.0],
            dimensions: [3,3], spacing_xz: [1.0,1.0] };
        // Plane h=4*x+8*z. The middle knot lies on two adjacent row/column pairs.
        let bytes = payload(&[0.0,4.0,8.0, 8.0,12.0,16.0, 16.0,20.0,24.0]);
        let grid = DenseHeightGrid::parse(meta, &bytes).unwrap();
        let below = f32::from_bits(1.0_f32.to_bits()-1);
        let above = f32::from_bits(1.0_f32.to_bits()+1);
        for (point, expected) in [([1.0,0.25],6.0),([0.25,1.0],9.0)] {
            assert_eq!(grid.sample_local_f32(point), Ok(expected));
        }
        for point in [[below,0.25],[above,0.25],[0.25,below],[0.25,above]] {
            let expected = 4.0*point[0] + 8.0*point[1];
            assert!((grid.sample_local_f32(point).unwrap()-expected).abs() <= 0.000002);
        }
    }

    #[test]
    fn negative_heights_and_real_zero_samples_remain_valid() {
        let bytes = payload(&[-8.0,-4.0,0.0,4.0]);
        let grid = DenseHeightGrid::parse(spec(), &bytes).unwrap();
        assert_eq!(grid.sample_local_f32([11.0,22.0]), Ok(-2.0));
        assert_eq!(grid.sample_local_f32([10.0,24.0]), Ok(0.0));
    }
}
