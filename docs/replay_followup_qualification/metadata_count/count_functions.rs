///728150 returns only AL. Counts above48 fail before entering the lock;
///unknown IDs still enter and leave it when the count passes that check.
pub fn set_count(b: &mut impl Boundary, p: u32, id: u32, count: u32) -> Result<u8, Error> {
    if count > 48 {
        return Ok(0);
    }
    let lock = add(p, 0x1c8)?;
    b.enter_lock(lock).map_err(Error::Boundary)?;
    let result = (|| -> Result<u8, Error> {
        let offset = match id {
            100 => 0x1a0,
            200 => 0x1a4,
            _ => return Ok(0),
        };
        put(b, p, offset, count)?;
        Ok(1)
    })();
    let unlock = b.leave_lock(lock).map_err(Error::Boundary);
    match (result, unlock) {
        (Ok(value), Ok(())) => Ok(value),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
///7281C0 takes no lock and selects the counter bank using only selector's
///low byte. An unknown ID returns zero without touching metadata memory.
pub fn get_count(b: &mut impl Boundary, p: u32, id: u32, selector: u32) -> Result<u32, Error> {
    let offset = match (id, selector as u8 != 0) {
        (100, false) => 0x1a8,
        (200, false) => 0x1ac,
        (100, true) => 0x1a0,
        (200, true) => 0x1a4,
        _ => return Ok(0),
    };
    w(b, p, offset)
}
