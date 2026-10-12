//! Initial data bytes extracted directly from the pinned4.20 PE32 executable.
//! This is production resource data, not a capture of initialized runtime state.
use crate::{
    audio_announcer_registry_init::{OwnedMemory, Storage},
    audio_plugin_factory::Memory,
};
use std::collections::BTreeMap;
pub const SOURCE_SHA256: &str = "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862";
pub const PACKAGE: &[u8] = include_bytes!("../../../data/4.20/runtime/replay_runtime_image.bin");
const REGIONS: [(u32, u32, u32); 53] = [
    (0, 0x1222830, 0xf00),
    (0, 0x14ae5b0, 0xc00),
    (0, 0x2da5300, 132),
    (1, 0x2d6ed50, 40),
    (1, 0x2d78ec0, 0x5c),
    (1, 0x1225878, 8),
    (1, 0x1085f2c, 12),
    (1, 0x1086078, 12),
    (1, 0x2d8d358, 2560),
    (1, 0x10d5fa4, 8),
    (1, 0x2d8dd58, 144),
    (1, 0x10dd320, 4168),
    (1, 0x10d6040, 8),
    (1, 0x10d6254, 48),
    (1, 0x10d5fdc, 12),
    (1, 0x10d5f34, 32),
    (1, 0x10d607c, 40),
    (1, 0x1085f4c, 12),
    (1, 0x10d6030, 12),
    (1, 0x10d5fec, 48),
    (1, 0x10d5f64, 12),
    (1, 0x1085f8c, 12),
    (1, 0x2d8bab4, 4),
    (1, 0x2d8bac0, 0x10a8),
    (1, 0x10b00c4, 100),
    (1, 0x10b0138, 4),
    (1, 0x108606c, 12),
    (1, 0x109b2d4, 12),
    (1, 0x10afcfc, 48),
    (1, 0x10afd34, 12),
    (1, 0x10b0128, 8),
    (1, 0x10afe8c, 180),
    (1, 0x1224d84, 32),
    (1, 0x123df84, 4),
    (1, 0x2d78240, 68),
    (1, 0x2d78288, 1),
    (1, 0x2d784e6, 1),
    (1, 0x2d78520, 4),
    (1, 0x2d62a48, 4),
    (1, 0x2d62878, 4),
    (1, 0x2d787b8, 4),
    (1, 0x2d5f448, 4),
    (1, 0x123b12c, 4),
    (1, 0x10a0360, 48),
    (1, 0x58c1ac, 496),
    (1, 0x58c39c, 301),
    (1, 0x14c761c, 8),
    (1, 0x1085e5c, 32),
    (1, 0x1088ab0, 6),
    (1, 0x2d78d08, 4),
    (1, 0x2d77e44, 4),
    (1, 0x14c758b, 1),
    (1, 0x10d6048, 12),
];
pub struct Initial {
    pub crt: BTreeMap<u32, Memory>,
    pub transport: OwnedMemory,
}
fn word(data: &[u8], offset: usize) -> Result<u32, String> {
    let s = data
        .get(offset..offset + 4)
        .ok_or("truncated initial runtime package")?;
    Ok(u32::from_le_bytes(s.try_into().unwrap()))
}
fn decode(data: &[u8]) -> Result<Initial, String> {
    if data.get(..8) != Some(b"OL420RT\0")
        || word(data, 8)? != 1
        || word(data, 12)? != REGIONS.len() as u32
    {
        return Err("unrecognized initial runtime package".into());
    }
    let digest = data
        .get(16..48)
        .ok_or("missing source identity")?
        .iter()
        .map(|v| format!("{v:02x}"))
        .collect::<String>();
    if digest != SOURCE_SHA256 {
        return Err("initial runtime package belongs to another native source".into());
    }
    let mut offset = 48;
    let mut crt = BTreeMap::new();
    let mut transport = OwnedMemory::new(0x39000000, 0);
    for expected in REGIONS {
        let (kind, address, size) = (
            word(data, offset)?,
            word(data, offset + 4)?,
            word(data, offset + 8)?,
        );
        offset += 12;
        if (kind, address, size) != expected {
            return Err("initial runtime package region layout differs".into());
        }
        let raw = data
            .get(offset..offset + size as usize)
            .ok_or("truncated initial runtime bank")?;
        offset += size as usize;
        if kind == 0 {
            crt.insert(
                address,
                Memory {
                    reference: address,
                    raw: raw.to_vec(),
                },
            );
        } else {
            transport
                .reserve_at(address, size)
                .map_err(|e| format!("transport initial storage: {e:?}"))?;
            for (i, b) in raw.iter().enumerate() {
                transport
                    .write_byte(address + i as u32, *b)
                    .map_err(|e| format!("transport initial byte: {e:?}"))?;
            }
        }
    }
    if offset != data.len() {
        return Err("unexpected initial runtime package tail".into());
    }
    Ok(Initial { crt, transport })
}
/// Every load owns distinct mutable banks. No host handle, thread record, mutex
/// initialization, API token or runtime allocator callback is restored from disk.
pub fn load() -> Result<Initial, String> {
    decode(PACKAGE)
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::audio_announcer_object_lookup::Memory as Read;
    #[test]
    fn audio_replay_production_image_contains_original_uninitialized_banks_and_independent_owned_storage(
    ) {
        let mut a = load().unwrap();
        let mut b = load().unwrap();
        assert_eq!(a.crt.len(), 3);
        assert_eq!(
            crate::audio_path_memory::read(&a.crt, 0x1222ed0, 8).unwrap(),
            &[0x4e, 0xe6, 0x40, 0xbb, 0xb1, 0x19, 0xbf, 0x44]
        );
        assert_eq!(
            crate::audio_path_memory::read(&a.crt, 0x12230cc, 4).unwrap(),
            &[255; 4]
        );
        for p in [
            0x2d6ed50, 0x2d6ed54, 0x2d6ed70, 0x2d6ed74, 0x2d78ec4, 0x2d78f04, 0x2d78f10,
        ] {
            assert_eq!(a.transport.word(p).unwrap(), 0);
        }
        assert_eq!(a.transport.word(0x10d5fa4).unwrap(), 0x8fc7b0);
        assert_eq!(a.transport.word(0x10d5fa8).unwrap(), 0x8fc2d0);
        for i in 0..144 {
            assert_eq!(a.transport.read_byte(0x2d8dd58 + i).unwrap(), 0);
        }
        for (p, v) in [
            (0x10d6040, 0x8f6fa0),
            (0x10d6044, 0x8f6d90),
            (0x10d6264, 0x8f6eb0),
            (0x10d5fdc, 0x5d5fd0),
            (0x10dd320, 0x243f6a88),
        ] {
            assert_eq!(a.transport.word(p).unwrap(), v);
        }
        a.transport.write_word(0x2d78f04, 2).unwrap();
        assert_eq!(b.transport.word(0x2d78f04).unwrap(), 0);
        assert!(a.transport.allocations.is_empty() && a.transport.shutdown_callbacks.is_empty());
    }
    #[test]
    fn audio_replay_production_image_rejects_foreign_identity_layout_and_truncation_without_fallback(
    ) {
        for n in [0, 8, 16, 47, 60, PACKAGE.len() - 1] {
            assert!(decode(&PACKAGE[..n]).is_err());
        }
        for i in [0, 8, 12, 16, 48, 52, 56] {
            let mut b = PACKAGE.to_vec();
            b[i] ^= 1;
            assert!(decode(&b).is_err());
        }
        let mut extra = PACKAGE.to_vec();
        extra.push(0);
        assert!(decode(&extra).is_err());
    }
}
