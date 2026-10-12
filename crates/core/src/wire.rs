//! Bounded application fragments; each UDP state datagram stays within 1200 bytes.
const HEADER: usize = 28;
const CHUNK: usize = 1200 - HEADER;
const MAX_FRAME: usize = 1024 * 1024;
pub fn state_datagrams(snapshot: &crate::Snapshot) -> Result<Vec<Vec<u8>>, serde_json::Error> {
    let payload = serde_json::to_vec(&crate::ServerPacket::State(snapshot.clone()))?;
    Ok(fragment(&payload, snapshot.session, snapshot.tick))
}
fn fragment(payload: &[u8], session: u64, tick: u64) -> Vec<Vec<u8>> {
    assert!(
        payload.len() <= MAX_FRAME,
        "snapshot exceeds bounded protocol frame"
    );
    if payload.len() <= 1200 {
        return vec![payload.to_vec()];
    }
    let count = payload.len().div_ceil(CHUNK);
    let mut datagrams = Vec::with_capacity(count);
    for (index, part) in payload.chunks(CHUNK).enumerate() {
        let mut d = Vec::with_capacity(HEADER + part.len());
        d.extend(b"OLST");
        d.extend(session.to_le_bytes());
        d.extend(tick.to_le_bytes());
        d.extend((index as u16).to_le_bytes());
        d.extend((count as u16).to_le_bytes());
        d.extend((payload.len() as u32).to_le_bytes());
        d.extend(part);
        datagrams.push(d);
    }
    datagrams
}
#[derive(Default)]
pub struct StateAssembler {
    key: Option<(u64, u64)>,
    parts: Vec<Option<Vec<u8>>>,
    length: usize,
}
impl StateAssembler {
    pub fn reset(&mut self) {
        *self = Self::default();
    }
    pub fn push(&mut self, data: &[u8], expected_session: Option<u64>) -> Option<Vec<u8>> {
        if !data.starts_with(b"OLST") {
            return Some(data.to_vec());
        }
        if data.len() < HEADER || data.len() > 1200 {
            return None;
        }
        let session = u64::from_le_bytes(data[4..12].try_into().ok()?);
        let tick = u64::from_le_bytes(data[12..20].try_into().ok()?);
        let index = u16::from_le_bytes(data[20..22].try_into().ok()?) as usize;
        let count = u16::from_le_bytes(data[22..24].try_into().ok()?) as usize;
        let length = u32::from_le_bytes(data[24..28].try_into().ok()?) as usize;
        if expected_session != Some(session)
            || length <= 1200
            || length > MAX_FRAME
            || count != length.div_ceil(CHUNK)
            || index >= count
        {
            return None;
        }
        let expected = (length - index * CHUNK).min(CHUNK);
        if data.len() - HEADER != expected {
            return None;
        }
        if self
            .key
            .is_some_and(|(old_session, old_tick)| old_session == session && old_tick > tick)
        {
            return None;
        }
        if self.key != Some((session, tick)) {
            self.key = Some((session, tick));
            self.parts = vec![None; count];
            self.length = length;
        }
        if self.parts.len() != count || self.length != length {
            return None;
        }
        self.parts[index] = Some(data[HEADER..].to_vec());
        if self.parts.iter().any(|p| p.is_none()) {
            return None;
        }
        let mut result = Vec::with_capacity(length);
        for part in &mut self.parts {
            result.extend(part.take()?);
        }
        Some(result)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn large_unicode_frames_round_trip_in_reverse_order_with_bounded_datagrams() {
        let original = "texture et animation 🕷️".repeat(4000).into_bytes();
        let frames = fragment(&original, 4, 8);
        assert!(frames.iter().all(|f| f.len() <= 1200));
        let mut assembler = StateAssembler::default();
        let mut result = None;
        for f in frames.iter().rev() {
            if let Some(value) = assembler.push(f, Some(4)) {
                result = Some(value);
            }
        }
        assert_eq!(result.unwrap(), original);
    }
    #[test]
    fn missing_fragment_and_other_session_are_not_accepted() {
        let frames = fragment(&vec![5; 5000], 9, 20);
        let mut a = StateAssembler::default();
        for f in &frames[..frames.len() - 1] {
            assert!(a.push(f, Some(9)).is_none());
        }
        assert!(a.push(frames.last().unwrap(), Some(10)).is_none());
        assert!(a.push(frames.last().unwrap(), Some(9)).is_some());
    }
    #[test]
    fn malformed_lengths_and_indices_are_rejected() {
        let mut frames = fragment(&vec![1; 5000], 1, 1);
        let mut a = StateAssembler::default();
        frames[0][20..22].copy_from_slice(&65535u16.to_le_bytes());
        assert!(a.push(&frames[0], Some(1)).is_none());
        frames[1][24..28].copy_from_slice(&u32::MAX.to_le_bytes());
        assert!(a.push(&frames[1], Some(1)).is_none());
    }
    #[test]
    fn stale_frames_cannot_replace_a_newer_incomplete_frame() {
        let old = fragment(&vec![1; 5000], 1, 2);
        let new = fragment(&vec![2; 5000], 1, 3);
        let mut a = StateAssembler::default();
        assert!(a.push(&new[0], Some(1)).is_none());
        for f in old {
            assert!(a.push(&f, Some(1)).is_none());
        }
        let mut value = None;
        for f in &new[1..] {
            value = a.push(f, Some(1));
        }
        assert_eq!(value.unwrap(), vec![2; 5000]);
    }
}
