//! Original8FD3F0 address preparation used by8FCA30 with keep_port=1.
//! Numeric conversion, localhost lookup and address formatting remain real OS
//! boundaries. Caller-supplied sockaddr bytes retain native unwritten stack data.
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Boundary(&'static str),
    InvalidCapacity,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Record {
    pub family: u32,
    pub socket: Option<[u8; 16]>,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Lookup {
    pub code: u32,
    pub records: Vec<Record>,
}
pub trait Boundary {
    /// Writes to the native validation scratch at2D8DDD8.
    fn validation_byte(&mut self, offset: usize, value: u8) -> Result<(), &'static str>;
    fn inet_addr(&mut self, text: &[u8]) -> Result<u32, &'static str>;
    /// Original gethostbyname("localhost") -> first IPv4 -> inet_ntoa -> inet_addr.
    fn localhost(&mut self) -> Result<u32, &'static str>;
    /// getaddrinfo("",decimal_port,AI_PASSIVE/AF_INET/SOCK_DGRAM/IPPROTO_UDP).
    /// The boundary owns/freeaddrinfo's list and returns copied record bytes.
    fn passive_lookup(&mut self, service: &[u8]) -> Result<Lookup, &'static str>;
    fn address_to_string(
        &mut self,
        socket: &[u8; 16],
        text: &mut [u8],
        capacity: &mut u32,
    ) -> Result<u32, &'static str>;
}
fn cstr(bytes: &[u8]) -> &[u8] {
    &bytes[..bytes.iter().position(|v| *v == 0).unwrap_or(bytes.len())]
}
///8FD2B0 accepts empty and exact lowercase localhost before touching scratch.
pub fn valid_host(b: &mut impl Boundary, host: &[u8]) -> Result<bool, Error> {
    let host = cstr(host);
    if host.is_empty() || host == b"localhost" {
        return Ok(true);
    }
    for i in 0..16 {
        b.validation_byte(i, if i == 0 { 2 } else { 0 })
            .map_err(Error::Boundary)?;
    }
    if !host.first().is_some_and(|v| v.is_ascii_digit()) {
        return Ok(false);
    }
    let address = b.inet_addr(host).map_err(Error::Boundary)?;
    if address == u32::MAX {
        return Ok(false);
    }
    for (i, v) in address.to_le_bytes().into_iter().enumerate() {
        b.validation_byte(4 + i, v).map_err(Error::Boundary)?;
    }
    Ok(true)
}
///8FCF20 hashes the two port bytes then four IPv4 bytes, complements and swaps
/// byte order. The polynomial matches every entry of the native table10D3300.
pub fn uid(socket: &[u8; 16]) -> u32 {
    let mut value = u32::MAX;
    for byte in &socket[2..8] {
        value ^= *byte as u32;
        for _ in 0..8 {
            value = (value >> 1) ^ if value & 1 != 0 { 0xedb88320 } else { 0 };
        }
    }
    (!value).swap_bytes()
}
/// The requested port is range-checked; numeric address conversion8FD060 still
/// writes port0 in the sockaddr. Preserve this source behavior, including UID0.
pub fn resolve(
    b: &mut impl Boundary,
    host: &[u8],
    port: u16,
    socket: &mut [u8; 16],
    text: &mut [u8],
    capacity: &mut u32,
) -> Result<u32, Error> {
    if *capacity as usize > text.len() {
        return Err(Error::InvalidCapacity);
    }
    socket[..2].copy_from_slice(&2u16.to_le_bytes());
    let host = cstr(host);
    if !valid_host(b, host)? || port != 0 && port < 1024 {
        return Ok(0);
    }
    if host == b"localhost" {
        socket[4..8].copy_from_slice(&b.localhost().map_err(Error::Boundary)?.to_le_bytes());
    } else if host.is_empty() {
        let result = b
            .passive_lookup(port.to_string().as_bytes())
            .map_err(Error::Boundary)?;
        if result.code != 0 {
            return Ok(0);
        }
        if let Some(record) = result.records.iter().find(|v| v.family == 2) {
            if let Some(address) = record.socket {
                socket[..8].copy_from_slice(&address[..8]);
            }
        }
    } else {
        socket.fill(0);
        socket[..2].copy_from_slice(&2u16.to_le_bytes());
        if !host.first().is_some_and(|v| v.is_ascii_digit()) {
            return Ok(0);
        }
        let address = b.inet_addr(host).map_err(Error::Boundary)?;
        if address == u32::MAX {
            return Ok(0);
        }
        socket[4..8].copy_from_slice(&address.to_le_bytes());
    }
    if b.address_to_string(socket, text, capacity)
        .map_err(Error::Boundary)?
        != 0
    {
        return Ok(0);
    }
    Ok(uid(socket))
}
#[cfg(windows)]
pub mod windows {
    use super::*;
    use std::ffi::{c_char, c_void, CStr, CString};
    #[repr(C)]
    struct HostEnt {
        name: *mut c_char,
        aliases: *mut *mut c_char,
        family: i16,
        length: i16,
        addresses: *mut *mut u8,
    }
    #[repr(C)]
    struct AddrInfo {
        flags: i32,
        family: i32,
        socktype: i32,
        protocol: i32,
        address_length: usize,
        canonical: *mut c_char,
        address: *mut u8,
        next: *mut AddrInfo,
    }
    #[repr(C, align(4))]
    struct Socket([u8; 16]);
    #[link(name = "ws2_32")]
    unsafe extern "system" {
        fn inet_addr(text: *const c_char) -> u32;
        fn inet_ntoa(address: u32) -> *const c_char;
        fn gethostbyname(name: *const c_char) -> *const HostEnt;
        fn getaddrinfo(
            name: *const c_char,
            service: *const c_char,
            hints: *const AddrInfo,
            result: *mut *mut AddrInfo,
        ) -> i32;
        fn freeaddrinfo(result: *mut AddrInfo);
        fn WSAAddressToStringA(
            address: *mut c_void,
            size: u32,
            protocol: *mut c_void,
            text: *mut c_char,
            capacity: *mut u32,
        ) -> i32;
    }
    struct List(*mut AddrInfo);
    impl Drop for List {
        fn drop(&mut self) {
            unsafe {
                freeaddrinfo(self.0);
            }
        }
    }
    /// The enclosing transport owns WSAStartup/WSACleanup. This adapter does not
    /// acquire an extra implicit reference or initiate a socket connection.
    pub struct Windows {
        pub validation_scratch: [u8; 16],
    }
    impl Boundary for Windows {
        fn validation_byte(&mut self, i: usize, v: u8) -> Result<(), &'static str> {
            *self
                .validation_scratch
                .get_mut(i)
                .ok_or("invalid validation byte")? = v;
            Ok(())
        }
        fn inet_addr(&mut self, text: &[u8]) -> Result<u32, &'static str> {
            let text = CString::new(text).map_err(|_| "interior NUL address")?;
            Ok(unsafe { inet_addr(text.as_ptr()) })
        }
        fn localhost(&mut self) -> Result<u32, &'static str> {
            let host = unsafe { gethostbyname(c"localhost".as_ptr()) };
            if host.is_null() {
                return Err("native localhost lookup returned null");
            }
            let host = unsafe { &*host };
            if host.family != 2 || host.length != 4 || host.addresses.is_null() {
                return Err("native localhost result is not an IPv4 list");
            }
            let first = unsafe { *host.addresses };
            if first.is_null() {
                return Err("native localhost address list is empty");
            }
            let address = u32::from_le_bytes(
                unsafe { std::slice::from_raw_parts(first, 4) }
                    .try_into()
                    .unwrap(),
            );
            let formatted = unsafe { inet_ntoa(address) };
            if formatted.is_null() {
                return Err("native localhost formatting returned null");
            }
            let text = unsafe { CStr::from_ptr(formatted) }.to_bytes().to_vec();
            self.inet_addr(&text)
        }
        fn passive_lookup(&mut self, service: &[u8]) -> Result<Lookup, &'static str> {
            let service = CString::new(service).map_err(|_| "interior NUL service")?;
            let hints = AddrInfo {
                flags: 1,
                family: 2,
                socktype: 2,
                protocol: 17,
                address_length: 0,
                canonical: std::ptr::null_mut(),
                address: std::ptr::null_mut(),
                next: std::ptr::null_mut(),
            };
            let mut pointer = std::ptr::null_mut();
            let code =
                unsafe { getaddrinfo(c"".as_ptr(), service.as_ptr(), &hints, &mut pointer) } as u32;
            if code != 0 {
                return Ok(Lookup {
                    code,
                    records: vec![],
                });
            }
            let _list = List(pointer);
            let mut records = vec![];
            while !pointer.is_null() {
                let item = unsafe { &*pointer };
                let socket = if item.family == 2 && !item.address.is_null() {
                    if item.address_length < 16 {
                        return Err("native IPv4 address is truncated");
                    }
                    Some(
                        unsafe { std::slice::from_raw_parts(item.address, 16) }
                            .try_into()
                            .unwrap(),
                    )
                } else {
                    None
                };
                records.push(Record {
                    family: item.family as u32,
                    socket,
                });
                pointer = item.next;
            }
            Ok(Lookup { code, records })
        }
        fn address_to_string(
            &mut self,
            address: &[u8; 16],
            text: &mut [u8],
            capacity: &mut u32,
        ) -> Result<u32, &'static str> {
            if *capacity as usize > text.len() {
                return Err("native formatter capacity exceeds owned storage");
            }
            let mut address = Socket(*address);
            Ok(unsafe {
                WSAAddressToStringA(
                    (&mut address as *mut Socket).cast(),
                    16,
                    std::ptr::null_mut(),
                    text.as_mut_ptr().cast(),
                    capacity,
                )
            } as u32)
        }
    }
}
#[cfg(test)]
#[path = "audio_replay_address_tests.rs"]
mod tests;
