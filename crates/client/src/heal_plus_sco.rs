//! Exact TT_Heal_Plus ASCII resource recovery, not a generic/native SCO loader.
//! Admission is byte equality with the separately pinned original asset.
//! No emitter, pose, material, texture, timing or rendering activation is chosen.
use super::{Corner, Geometry, HEAL_PLUS_SOURCE};

pub(super) const SOURCE_SHA256: &str =
    "b7d941af9d76b44834f513717eeb4aaf6067b1fe61124559de38518239caa2e3";
const VERTICES: usize = 24;
const TRIANGLES: usize = 44;

fn next<'a>(lines: &mut std::str::Lines<'a>) -> Result<&'a str, &'static str> {
    lines.next().ok_or("Heal_Plus SCO ended before its pinned geometry")
}
fn exact(lines: &mut std::str::Lines<'_>, expected: &str) -> Result<(), &'static str> {
    if next(lines)?.trim() == expected { Ok(()) }
    else { Err("Heal_Plus SCO pinned header differs") }
}
fn scalar(text: &str) -> Result<f32, &'static str> {
    let value = text.parse::<f32>().map_err(|_| "Heal_Plus SCO invalid f32 token")?;
    if value.is_finite() { Ok(value) }
    else { Err("Heal_Plus SCO nonfinite numeric token") }
}
fn vector<const N: usize>(text: &str) -> Result<[f32; N], &'static str> {
    let mut fields = text.split_whitespace();
    let mut result = [0.; N];
    for value in &mut result {
        *value = scalar(fields.next().ok_or("Heal_Plus SCO missing vector field")?)?;
    }
    if fields.next().is_some() { return Err("Heal_Plus SCO extra vector field"); }
    Ok(result)
}
fn header_vector(lines: &mut std::str::Lines<'_>, key: &str)
    -> Result<[f32; 3], &'static str> {
    let line = next(lines)?;
    vector(line.strip_prefix(key).ok_or("Heal_Plus SCO vector header differs")?)
}

struct Parsed {
    geometry: Geometry,
    // Kept separately: the native SCO pivot-to-render-object mapping is unknown.
    pivot: [f32; 3],
}
fn parse_pinned(bytes: &[u8]) -> Result<Parsed, &'static str> {
    if bytes != HEAL_PLUS_SOURCE {
        return Err("Heal_Plus SCO differs from the exact pinned original");
    }
    let text = std::str::from_utf8(bytes).map_err(|_| "Heal_Plus SCO is not ASCII/UTF-8")?;
    if !text.is_ascii() { return Err("Heal_Plus SCO contains non-ASCII data"); }
    let mut lines = text.lines();
    exact(&mut lines, "[ObjectBegin]")?;
    exact(&mut lines, "Name= pCube1")?;
    let centre = header_vector(&mut lines, "CentralPoint=")?;
    let pivot = header_vector(&mut lines, "PivotPoint=")?;
    if centre.map(f32::to_bits) != [0, 0, 0]
        || pivot.map(f32::to_bits) != [0, 0, 0x80000000] {
        return Err("Heal_Plus SCO centre/pivot is outside the exact zero-centred source");
    }
    exact(&mut lines, "Verts= 24")?;
    let mut positions = [[0.; 3]; VERTICES];
    for position in &mut positions { *position = vector(next(&mut lines)?)?; }
    exact(&mut lines, "Faces= 44")?;
    let mut corners = Vec::with_capacity(TRIANGLES * 3);
    for _ in 0..TRIANGLES {
        let fields: Vec<_> = next(&mut lines)?.split_whitespace().collect();
        if fields.len() != 11 || fields[0] != "3" || fields[4] != "lambert1" {
            return Err("Heal_Plus SCO requires its original triangular lambert1 faces");
        }
        for corner in 0..3 {
            let index = fields[1 + corner].parse::<usize>()
                .map_err(|_| "Heal_Plus SCO invalid vertex index")?;
            let position = *positions.get(index)
                .ok_or("Heal_Plus SCO vertex index outside the pinned mesh")?;
            let uv = [scalar(fields[5 + corner * 2])?, scalar(fields[6 + corner * 2])?];
            corners.push(Corner {
                position,
                uv,
                // SCO has NO authored VertexColors block. This required field is
                // a transport sentinel only: Geometry::bake never reads Corner.rgb.
                // It must not be interpreted as a recovered native vertex color.
                rgb: [0; 3],
            });
        }
    }
    exact(&mut lines, "[ObjectEnd]")?;
    if lines.any(|line| !line.trim().is_empty()) {
        return Err("Heal_Plus SCO unexpected data after ObjectEnd");
    }
    Ok(Parsed { geometry: Geometry { corners, centre }, pivot })
}

pub(super) fn decode(bytes: &[u8]) -> Result<Geometry, &'static str> {
    let parsed = parse_pinned(bytes)?;
    // Validate and retain the signed-zero pivot above. No pivot transform is
    // applied: both source coordinates are numerically zero in this sole asset.
    let _source_pivot = parsed.pivot;
    Ok(parsed.geometry)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn source_words_digest(geometry: &Geometry) -> u64 {
        // Independent source-data golden covers ALL positions, UVs and order.
        // This is an ASCII recovery check, not a native f32 conversion oracle.
        let mut digest = 0xcbf29ce484222325u64;
        for value in geometry.centre.iter().copied().chain(geometry.corners.iter()
            .flat_map(|c| c.position.into_iter().chain(c.uv))) {
            for byte in value.to_bits().to_le_bytes() {
                digest = (digest ^ u64::from(byte)).wrapping_mul(0x100000001b3);
            }
        }
        digest
    }

    #[test]
    fn heal_plus_sco_exact_source_preserves_all_corner_words_and_signed_zero_pivot() {
        let parsed = parse_pinned(HEAL_PLUS_SOURCE).unwrap();
        assert_eq!(SOURCE_SHA256.len(), 64);
        assert_eq!(parsed.geometry.corners.len(), 132);
        assert_eq!(parsed.geometry.centre.map(f32::to_bits), [0, 0, 0]);
        assert_eq!(parsed.pivot.map(f32::to_bits), [0, 0, 0x80000000]);
        assert_eq!(source_words_digest(&parsed.geometry), SOURCE_WORDS_GOLDEN);
        assert!(parsed.geometry.corners.iter().all(|corner| corner.rgb == [0; 3]));
    }

    #[test]
    fn heal_plus_sco_rejects_changed_truncated_extended_and_foreign_inputs() {
        let mut modified = HEAL_PLUS_SOURCE.to_vec();
        modified[0] ^= 1;
        assert!(decode(&modified).is_err());
        assert!(decode(&HEAL_PLUS_SOURCE[..HEAL_PLUS_SOURCE.len() - 1]).is_err());
        let mut extended = HEAL_PLUS_SOURCE.to_vec();
        extended.push(b' ');
        assert!(decode(&extended).is_err());
        assert!(decode(super::super::SOURCE).is_err());
        assert!(decode(b"[ObjectBegin]\nVerts= 0\nFaces= 0\n[ObjectEnd]\n").is_err());
    }

    #[test]
    fn heal_plus_sco_geometry_admission_keeps_existing_four_SCB_branches() {
        assert_eq!(Geometry::decode(HEAL_PLUS_SOURCE).unwrap().corners.len(), 132);
        for (source, corners) in [(super::super::SOURCE, 108),
            (super::super::SPARKLE_SOURCE, 504),
            (super::super::CROWN_SOURCE, 480),
            (super::super::PICKUP_SOURCE, 240)] {
            assert_eq!(Geometry::decode(source).unwrap().corners.len(), corners);
        }
        assert!(Geometry::decode(b"foreign mesh").is_err());
    }

    // Replaced by the source-stage builder from independently archived face data.
    const SOURCE_WORDS_GOLDEN: u64 = 0x1a1a3e139b9c5bf0;
}
