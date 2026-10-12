//! Private msvcrt FILE operations. No fopen/fclose/fprintf linker symbols are
//! imported, so the executable's default UCRT imports retain their own binding.
use std::ffi::{c_char, c_int, c_void};
use std::sync::OnceLock;

#[link(name = "kernel32")]
unsafe extern "system" {
    fn LoadLibraryExW(name: *const u16, file: *mut c_void, flags: u32) -> *mut c_void;
    fn GetProcAddress(module: *mut c_void, name: *const u8) -> *mut c_void;
    fn FreeLibrary(module: *mut c_void) -> i32;
}

type Open = unsafe extern "C" fn(*const c_char, *const c_char) -> *mut c_void;
type Close = unsafe extern "C" fn(*mut c_void) -> c_int;
type Print = unsafe extern "C" fn(*mut c_void, *const c_char, ...) -> c_int;

struct ModuleReference(usize);
impl Drop for ModuleReference {
    fn drop(&mut self) {
        unsafe {
            FreeLibrary(self.0 as *mut c_void);
        }
    }
}

pub(super) struct Api {
    // On lookup failure the local reference is released. On success the static
    // OnceLock below retains this one owned reference until process termination.
    _process_module_reference: ModuleReference,
    pub(super) fopen: Open,
    pub(super) fclose: Close,
    pub(super) fprintf: Print,
}

fn load() -> Result<Api, &'static str> {
    const LOAD_LIBRARY_SEARCH_SYSTEM32: u32 = 0x00000800;
    let wide: Vec<u16> = "msvcrt.dll\0".encode_utf16().collect();
    let handle = unsafe {
        LoadLibraryExW(
            wide.as_ptr(),
            std::ptr::null_mut(),
            LOAD_LIBRARY_SEARCH_SYSTEM32,
        )
    };
    if handle.is_null() {
        return Err("recording msvcrt.dll could not be loaded from System32");
    }
    let module = ModuleReference(handle as usize);
    let open = unsafe { GetProcAddress(handle, b"fopen\0".as_ptr()) };
    if open.is_null() {
        return Err("recording msvcrt.dll export fopen is missing");
    }
    let close = unsafe { GetProcAddress(handle, b"fclose\0".as_ptr()) };
    if close.is_null() {
        return Err("recording msvcrt.dll export fclose is missing");
    }
    let print = unsafe { GetProcAddress(handle, b"fprintf\0".as_ptr()) };
    if print.is_null() {
        return Err("recording msvcrt.dll export fprintf is missing");
    }
    // These exact non-null exports were resolved from the same referenced DLL.
    Ok(Api {
        _process_module_reference: module,
        fopen: unsafe { std::mem::transmute::<*mut c_void, Open>(open) },
        fclose: unsafe { std::mem::transmute::<*mut c_void, Close>(close) },
        fprintf: unsafe { std::mem::transmute::<*mut c_void, Print>(print) },
    })
}

pub(super) fn get() -> Result<&'static Api, &'static str> {
    // Static values are not dropped at program exit. Every live File stores a
    // reference to this Api, keeping fopen/fprintf/fclose in the same CRT domain.
    static PROCESS_MSVCRT_API: OnceLock<Result<Api, &'static str>> = OnceLock::new();
    PROCESS_MSVCRT_API
        .get_or_init(load)
        .as_ref()
        .map_err(|e| *e)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::ffi::CString;

    // Resolve these through the executable's default CRT, deliberately forcing
    // a normal fclose import alongside our private msvcrt function pointers.
    // Never attach raw-dylib msvcrt to these symbols: FILE layouts differ.
    unsafe extern "C" {
        fn fopen_s(file: *mut *mut c_void, path: *const c_char, mode: *const c_char) -> c_int;
        fn fclose(file: *mut c_void) -> c_int;
    }

    fn default_crt_roundtrip(path: &CString, mode: &CString) {
        let mut file = std::ptr::null_mut();
        assert_eq!(
            unsafe { fopen_s(&mut file, path.as_ptr(), mode.as_ptr()) },
            0
        );
        assert!(!file.is_null());
        assert_eq!(unsafe { fclose(file) }, 0);
    }

    #[test]
    fn audio_replay_windows_private_msvcrt_files_coexist_with_default_ucrt_fopen_s_and_fclose() {
        let path = std::env::temp_dir().join(format!(
            "openleague-crt-domain-{}-{}.log",
            std::process::id(),
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap()
                .as_nanos()
        ));
        let name = CString::new(path.to_str().unwrap()).unwrap();
        default_crt_roundtrip(&name, &CString::new("wb").unwrap());
        let mut files = super::super::Files::default();
        let first = files.open(&name, &CString::new("wc").unwrap()).unwrap();
        assert_ne!(first, 0);
        let message = CString::new("first %n %s\n").unwrap();
        assert!(files.message(first, &message).unwrap() > 0);
        assert_eq!(files.close(first).unwrap(), 0);
        let second = files.open(&name, &CString::new("ac").unwrap()).unwrap();
        assert_ne!(second, 0);
        assert!(
            files
                .message(second, &CString::new("second\n").unwrap())
                .unwrap()
                > 0
        );
        assert_eq!(files.close(second).unwrap(), 0);
        assert_eq!(files.statistics(), (2, 2, 2, 0));
        default_crt_roundtrip(&name, &CString::new("rb").unwrap());
        assert_eq!(std::fs::read(&path).unwrap(), b"first %n %s\r\nsecond\r\n");
        std::fs::remove_file(path).unwrap();
    }
}
