//! Native 8B9390 ZIP data-offset/cache calculation. Mounting/inflate remain separate.
#[derive(Clone, Copy, Debug)]
pub struct Entry {
    pub local_offset: u32,
    pub cached_data_offset: u32,
    pub method: u32,
    pub compressed_size: u32,
    pub uncompressed_size: u32,
    pub crc: u32,
}
impl Entry {
    /// A nonzero cache bypasses the stream, as in the original function.
    /// Truncated reads return an explicit error instead of consuming undefined stack bytes.
    pub fn data_offset(&mut self, header: Option<&[u8]>) -> Result<u32, &'static str> {
        if self.cached_data_offset != 0 { return Ok(self.cached_data_offset); }
        let h = header.ok_or("ZIP local header unavailable")?;
        if h.len() < 4 { return Err("truncated ZIP signature"); }
        let word = |p| u16::from_le_bytes([h[p], h[p+1]]) as u32;
        let dword = |p| u32::from_le_bytes([h[p], h[p+1], h[p+2], h[p+3]]);
        if dword(0) != 0x04034b50 { return Ok(0); }
        if h.len() < 30 { return Err("truncated ZIP local header"); }
        if dword(18) != self.compressed_size || word(8) != self.method
            || dword(22) != self.uncompressed_size || dword(14) != self.crc {
            return Ok(0);
        }
        self.cached_data_offset = self.local_offset.wrapping_add(30)
            .wrapping_add(word(26)).wrapping_add(word(28));
        Ok(self.cached_data_offset)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn offset_validation_and_cache_match_original_instructions() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/native_zip_local_header_contract.json")).unwrap();
        assert_eq!(proof["passed"], true);
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 216);
        for c in cases {
            let n = |key: &str| c[key].as_u64().unwrap() as u32;
            let mut e = Entry { local_offset:n("offset"), cached_data_offset:n("cached"),
                method:n("method"), compressed_size:n("compressed"),
                uncompressed_size:n("uncompressed"), crc:n("crc") };
            let header: Vec<u8> = c["header"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();
            let input = if e.cached_data_offset == 0 {Some(header.as_slice())} else {None};
            assert_eq!(e.data_offset(input).unwrap(), n("result"), "{c}");
            assert_eq!(e.cached_data_offset, n("cached_after"));
        }
    }
}
