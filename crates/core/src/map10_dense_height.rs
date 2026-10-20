//! Immutable Map10 sampled-height data for explicit core consumers.
//!
//! This API validates the recovered dense grid once. It does not initialize an
//! Ezreal missile, change navigation, infer actor/bone height, or claim native
//! floating-point parity. Source SHA pins are build/adoption provenance, not a
//! claim that this module recomputes a cryptographic hash at runtime.

use crate::dense_height_grid::{DenseHeightGrid, Error as GridError, GridSpec};
use serde::Deserialize;
use std::{fmt, sync::OnceLock};

pub const METADATA_SOURCE_SHA256: &str =
    "98903341b52e204145eafc92a949394712257abc352bc3dad5e5fe204f1c1321";
pub const PAYLOAD_SOURCE_SHA256: &str =
    "c5b68a89eaadf3efb632ecf783d898ae78dff8fc5818cdc26aa0def577c5d8aa";
pub const PAYLOAD_BYTES: usize = 635_068;

const METADATA: &str = include_str!("../../../data/4.20/map10_dense_height/navigation_metadata.json");
const PAYLOAD: &[u8] = include_bytes!("../../../data/4.20/map10_dense_height/sampled_heights.bin");
const MIN_BITS: [u32; 3] = [0x426f_ed78, 0xc2e5_f07d, 0x457a_93d8];
const MAX_BITS: [u32; 3] = [0x466f_f6d0, 0x4333_20ec, 0x4623_3366];
const SPACING_BITS: [u32; 2] = [0x41c7_f860, 0x41c7_8dc4];

#[derive(Debug)]
pub struct Binding {
    grid: DenseHeightGrid<'static>,
}

impl Binding {
    /// Native X/Z, including terrain under blocked traversal cells.
    pub fn sample_local_f32(&self, xz: [f32; 2]) -> Result<f32, GridError> {
        self.grid.sample_local_f32(xz)
    }

    /// Borrow the validated immutable grid; no loading or scanning per sample.
    pub fn grid(&self) -> &DenseHeightGrid<'static> {
        &self.grid
    }
}

#[derive(Clone, Debug, PartialEq)]
pub enum LoadError {
    Metadata(String),
    UnexpectedMetadata { field: &'static str },
    Grid(GridError),
}

impl fmt::Display for LoadError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Metadata(error) => write!(f, "Map10 sampled-height metadata: {error}"),
            Self::UnexpectedMetadata { field } =>
                write!(f, "Map10 sampled-height resource field changed: {field}"),
            Self::Grid(error) => write!(f, "Map10 sampled-height payload: {error}"),
        }
    }
}

impl std::error::Error for LoadError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self { Self::Grid(error) => Some(error), _ => None }
    }
}

#[derive(Deserialize)]
struct Metadata {
    source: String,
    version: String,
    min: [f32; 3],
    max: [f32; 3],
    #[serde(rename = "sampledHeights")]
    sampled: SampledMetadata,
}

#[derive(Deserialize)]
struct SampledMetadata {
    width: usize,
    height: usize,
    distance: [f32; 2],
    file: String,
    format: String,
}

fn parse_grid<'a>(metadata: &str, bytes: &'a [u8]) -> Result<DenseHeightGrid<'a>, LoadError> {
    let m: Metadata = serde_json::from_str(metadata)
        .map_err(|error| LoadError::Metadata(error.to_string()))?;
    let require = |ok: bool, field| {
        if ok { Ok(()) } else { Err(LoadError::UnexpectedMetadata { field }) }
    };
    require(m.source == "Map10/AIPath.aimesh_ngrid", "source")?;
    require(m.version == "3.1", "version")?;
    require(m.min.map(f32::to_bits) == MIN_BITS, "min")?;
    require(m.max.map(f32::to_bits) == MAX_BITS, "max")?;
    require([m.sampled.width, m.sampled.height] == [613, 259], "sampledHeights dimensions")?;
    require(m.sampled.distance.map(f32::to_bits) == SPACING_BITS, "sampledHeights.distance")?;
    // This descriptor is checked, never used to construct/open a filesystem path.
    require(m.sampled.file == "TwistedTreeline_NavigationGrid.sampled-heights.bin", "sampledHeights.file")?;
    require(m.sampled.format == "row-major f32le", "sampledHeights.format")?;
    DenseHeightGrid::parse(GridSpec {
        min_xz: [m.min[0], m.min[2]],
        max_xz: [m.max[0], m.max[2]],
        dimensions: [m.sampled.width, m.sampled.height],
        spacing_xz: m.sampled.distance,
    }, bytes).map_err(LoadError::Grid)
}

/// Shared Map10 data API. Success and failure are both retained; no fallback.
/// A map consumer must select Map10 explicitly. This does not attach Map10 to
/// every Simulation::new(Navigation), whose input can describe another grid.
pub fn binding() -> Result<&'static Binding, &'static LoadError> {
    static DATA: OnceLock<Result<Binding, LoadError>> = OnceLock::new();
    DATA.get_or_init(|| parse_grid(METADATA, PAYLOAD).map(|grid| Binding { grid })).as_ref()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn changed(change: impl FnOnce(&mut serde_json::Value)) -> String {
        let mut value: serde_json::Value = serde_json::from_str(METADATA).unwrap();
        change(&mut value);
        serde_json::to_string(&value).unwrap()
    }

    #[test]
    fn embedded_binding_is_shared_and_actual_corners_keep_axis_order() {
        let first = binding().unwrap();
        let second = binding().unwrap();
        assert!(std::ptr::eq(first, second));
        assert!(std::ptr::eq(first.grid(), second.grid()));
        assert_eq!(PAYLOAD.len(), PAYLOAD_BYTES);
        let spec = first.grid().spec();
        assert_eq!(spec.dimensions, [613, 259]);
        for (xz, bits) in [
            (spec.min_xz, 0x4315_7f68),
            ([spec.max_xz[0], spec.min_xz[1]], 0x4316_2d1e),
            ([spec.min_xz[0], spec.max_xz[1]], 0x431e_d564),
            (spec.max_xz, 0x4323_4ea3),
        ] {
            assert_eq!(first.sample_local_f32(xz).unwrap().to_bits(), bits);
        }
    }

    #[test]
    fn actual_blocked_first_traversal_cell_still_has_dense_height() {
        // Exact first 11-byte cell from the recovered navigation stream:
        // SHA beeeff7df5b236e7617cacf0c848b850c1114e007253434ce59d7ad6410b7e72.
        // A one-cell slice is enough to exercise the real Navigation::ground
        // rejection, without embedding the unrelated full traversal payload.
        let cell = [0u8, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0];
        let nav = crate::Navigation::load(
            r#"{"min":[59.981903,-114.9697,4009.2402],"cellSize":50,"width":1,"height":1}"#,
            &cell,
        ).unwrap();
        let spec = binding().unwrap().grid().spec();
        let point = crate::Point { x: spec.min_xz[0] + 25.0, z: spec.min_xz[1] + 25.0 };
        assert_eq!(nav.ground(point), None);
        let dense = binding().unwrap().sample_local_f32([point.x, point.z]).unwrap();
        assert!(dense.is_finite() && dense > 0.0);
    }

    #[test]
    fn metadata_cannot_substitute_traversal_dimensions_or_spacing() {
        for (text, field) in [
            (changed(|m| { m["sampledHeights"]["width"] = 306.into();
                           m["sampledHeights"]["height"] = 129.into(); }), "sampledHeights dimensions"),
            (changed(|m| m["sampledHeights"]["distance"] = serde_json::json!([50,50])), "sampledHeights.distance"),
        ] {
            assert_eq!(parse_grid(&text, PAYLOAD).unwrap_err(), LoadError::UnexpectedMetadata { field });
        }
        let absent = changed(|m| { m.as_object_mut().unwrap().remove("sampledHeights"); });
        assert!(matches!(parse_grid(&absent, PAYLOAD), Err(LoadError::Metadata(_))));
    }

    #[test]
    fn resource_identity_bounds_and_descriptor_changes_are_rejected() {
        for (text, field) in [
            (changed(|m| m["source"] = "Map11/AIPath.aimesh_ngrid".into()), "source"),
            (changed(|m| m["version"] = "3.2".into()), "version"),
            (changed(|m| m["min"][0] = 60.into()), "min"),
            (changed(|m| m["max"][2] = 10445.into()), "max"),
            (changed(|m| m["sampledHeights"]["file"] = "../different.bin".into()), "sampledHeights.file"),
            (changed(|m| m["sampledHeights"]["format"] = "f64be".into()), "sampledHeights.format"),
        ] {
            assert_eq!(parse_grid(&text, PAYLOAD).unwrap_err(), LoadError::UnexpectedMetadata { field });
        }
    }

    #[test]
    fn corrupt_or_nonfinite_embedded_resource_input_has_explicit_error() {
        assert!(matches!(parse_grid("not json", PAYLOAD), Err(LoadError::Metadata(_))));
        assert_eq!(parse_grid(METADATA, &PAYLOAD[..PAYLOAD.len()-1]).unwrap_err(),
            LoadError::Grid(GridError::PayloadLength { expected: PAYLOAD_BYTES, actual: PAYLOAD_BYTES-1 }));
        let mut extra = PAYLOAD.to_vec(); extra.push(0);
        assert_eq!(parse_grid(METADATA, &extra).unwrap_err(),
            LoadError::Grid(GridError::PayloadLength { expected: PAYLOAD_BYTES, actual: PAYLOAD_BYTES+1 }));
        for bits in [f32::NAN.to_bits(), f32::INFINITY.to_bits(), f32::NEG_INFINITY.to_bits()] {
            let mut invalid = PAYLOAD.to_vec(); invalid[..4].copy_from_slice(&bits.to_le_bytes());
            assert_eq!(parse_grid(METADATA, &invalid).unwrap_err(),
                LoadError::Grid(GridError::NonFiniteSample { index: 0, bits }));
        }
    }

    #[test]
    fn public_binding_preserves_query_errors_without_height_fallback() {
        let data = binding().unwrap(); let spec = data.grid().spec();
        assert_eq!(data.sample_local_f32([f32::NAN, spec.min_xz[1]]),
            Err(GridError::NonFiniteCoordinate { axis: crate::dense_height_grid::Axis::X }));
        assert_eq!(data.sample_local_f32([spec.min_xz[0]-1.0, spec.min_xz[1]]),
            Err(GridError::OutsideBounds { axis: crate::dense_height_grid::Axis::X }));
    }
}
