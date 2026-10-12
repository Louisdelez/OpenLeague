//! Native98F710 key schedule and98F890 two-word transform.
//! Initial tables are read from the pinned native image, not regenerated constants.
use crate::{
    audio_announcer_object_lookup as read,
    audio_announcer_registry_init::{self as init, Storage},
};
pub const TABLES: u32 = 0x10dd320;
pub const TABLE_BYTES: usize = 0x1048;
pub const OBJECT_BYTES: usize = 0x1058;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    EmptyKey,
    Tables,
    Read(read::Error),
    Write(init::Error),
    Overflow,
}
#[derive(Clone)]
pub struct Key {
    iv: [u32; 4],
    p: [u32; 18],
    s: [[u32; 256]; 4],
}
impl Key {
    pub fn derive(key: &[u8], iv: [u32; 2], initial: &[u8]) -> Result<Self, Error> {
        if key.is_empty() {
            return Err(Error::EmptyKey);
        }
        if initial.len() != TABLE_BYTES {
            return Err(Error::Tables);
        }
        let key = &key[..key.len().min(56)];
        let mut out = Self {
            iv: [iv[0], iv[1], iv[0], iv[1]],
            p: [0; 18],
            s: [[0; 256]; 4],
        };
        let mut words = initial
            .chunks_exact(4)
            .map(|v| u32::from_le_bytes(v.try_into().unwrap()));
        for p in &mut out.p {
            *p = words.next().unwrap();
        }
        for s in &mut out.s {
            for v in s {
                *v = words.next().unwrap();
            }
        }
        let mut index = 0;
        for p in &mut out.p {
            let mut v = 0;
            for _ in 0..4 {
                v = (v << 8) | u32::from(key[index]);
                index = (index + 1) % key.len();
            }
            *p ^= v;
        }
        let mut block = [0; 2];
        for i in (0..18).step_by(2) {
            block = out.transform(block);
            out.p[i..i + 2].copy_from_slice(&block);
        }
        for box_index in 0..4 {
            for i in (0..256).step_by(2) {
                block = out.transform(block);
                out.s[box_index][i..i + 2].copy_from_slice(&block);
            }
        }
        Ok(out)
    }
    fn round(&self, x: u32) -> u32 {
        (self.s[0][(x >> 24) as usize].wrapping_add(self.s[1][((x >> 16) & 255) as usize])
            ^ self.s[2][((x >> 8) & 255) as usize])
            .wrapping_add(self.s[3][(x & 255) as usize])
    }
    pub fn transform(&self, block: [u32; 2]) -> [u32; 2] {
        let mut l = block[0] ^ self.p[0];
        let mut r = block[1];
        for i in (1..17).step_by(2) {
            r ^= self.round(l) ^ self.p[i];
            l ^= self.round(r) ^ self.p[i + 1];
        }
        [r ^ self.p[17], l]
    }
    pub fn bytes(&self) -> Vec<u8> {
        self.iv
            .iter()
            .chain(self.p.iter())
            .chain(self.s.iter().flatten())
            .flat_map(|v| v.to_le_bytes())
            .collect()
    }
}
pub fn initialize(b: &mut impl Storage, p: u32, key: &[u8], iv: [u32; 2]) -> Result<(), Error> {
    let mut tables = Vec::with_capacity(TABLE_BYTES);
    for i in (0..TABLE_BYTES).step_by(4) {
        tables.extend_from_slice(
            &b.word(TABLES + i as u32)
                .map_err(Error::Read)?
                .to_le_bytes(),
        );
    }
    let key = Key::derive(key, iv, &tables)?;
    for (i, v) in key.bytes().chunks_exact(4).enumerate() {
        let address = p.checked_add(i as u32 * 4).ok_or(Error::Overflow)?;
        Storage::write_word(b, address, u32::from_le_bytes(v.try_into().unwrap()))
            .map_err(Error::Write)?;
    }
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bytes(s: &str) -> Vec<u8> {
        s.as_bytes()
            .chunks_exact(2)
            .map(|v| u8::from_str_radix(std::str::from_utf8(v).unwrap(), 16).unwrap())
            .collect()
    }
    #[test]
    fn audio_replay_key_matches22_native_complete_schedules_and88_two_word_transforms() {
        let p: serde_json::Value = serde_json::from_str(&crate::audio_test_fixture(
            "data/4.20/replay_key_probe.json",
        ))
        .unwrap();
        assert_eq!(p["passed"], true);
        let seed = bytes(p["initial_tables_hex"].as_str().unwrap());
        let cases = p["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 22);
        for c in cases {
            let iv = std::array::from_fn(|i| c["iv"][i].as_u64().unwrap() as u32);
            let k = Key::derive(&bytes(c["key_hex"].as_str().unwrap()), iv, &seed).unwrap();
            assert_eq!(k.bytes(), bytes(c["object_hex"].as_str().unwrap()));
            for block in c["blocks"].as_array().unwrap() {
                assert_eq!(
                    serde_json::json!(k
                        .transform(std::array::from_fn(
                            |i| block["input"][i].as_u64().unwrap() as u32
                        ))),
                    block["output"]
                );
            }
        }
        assert!(matches!(
            Key::derive(&[], [0; 2], &seed),
            Err(Error::EmptyKey)
        ));
        assert!(matches!(
            Key::derive(&[1], [0; 2], &seed[..seed.len() - 1]),
            Err(Error::Tables)
        ));
    }
}
