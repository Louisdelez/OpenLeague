//! Native8A92A0 debugger naming, with a small MSVC SEH boundary. The payload
//! contains a real host string pointer, never a truncated PE32 canonical label.
use std::ffi::CStr;
#[cfg(target_env = "msvc")]
unsafe extern "C" {
    fn ol_engine_debug_name(text: *const std::ffi::c_char);
}
pub fn name_current(name: &CStr) -> Result<(), &'static str> {
    #[cfg(target_env = "msvc")]
    {
        unsafe { ol_engine_debug_name(name.as_ptr()) };
        Ok(())
    }
    #[cfg(not(target_env = "msvc"))]
    {
        let _ = name;
        Err("native debugger naming requires the Windows MSVC SEH bridge")
    }
}
#[cfg(all(test, target_env = "msvc"))]
mod tests {
    use super::*;
    use std::{cell::Cell, ffi::c_void};
    #[repr(C)]
    struct Record {
        code: u32,
        flags: u32,
        parent: *const Record,
        address: *const c_void,
        count: u32,
        values: [usize; 15],
    }
    #[repr(C)]
    struct Pointers {
        record: *const Record,
        context: *const c_void,
    }
    #[link(name = "kernel32")]
    unsafe extern "system" {
        fn AddVectoredExceptionHandler(
            first: u32,
            handler: unsafe extern "system" fn(*const Pointers) -> i32,
        ) -> *mut c_void;
        fn RemoveVectoredExceptionHandler(handler: *mut c_void) -> u32;
    }
    thread_local! {static EXPECTED:Cell<usize>=const{Cell::new(0)};static OBSERVED:Cell<u32>=const{Cell::new(0)};static RAW:Cell<[usize;8]>=const{Cell::new([0;8])};}
    unsafe extern "system" fn observe(p: *const Pointers) -> i32 {
        if p.is_null() {
            return 0;
        }
        let record = unsafe { (*p).record };
        if record.is_null() {
            return 0;
        }
        let record = unsafe { &*record };
        RAW.with(|v| {
            v.set([
                record.code as usize,
                record.flags as usize,
                record.count as usize,
                record.values[0],
                record.values[1],
                record.values[2],
                record.values[3],
                EXPECTED.with(Cell::get),
            ])
        });
        // Windows may add internal dispatch flags (observed0x80 on this host).
        // RaiseException's input flag0 specifies a continuable exception; only
        // EXCEPTION_NONCONTINUABLE is part of that public input contract.
        if record.code == 0x406d1388 && record.flags & 1 == 0 {
            EXPECTED.with(|expected| {
                let pointer = expected.get();
                if pointer != 0
                    && record.values[0] as u32 == 0x1000
                    && record.values[1] == pointer
                    && record.values[2] == 0xffffffff
                    && record.count
                        == if cfg!(target_pointer_width = "64") {
                            3
                        } else {
                            4
                        }
                    && (!cfg!(target_pointer_width = "32") || record.values[3] == 0)
                {
                    OBSERVED.with(|v| v.set(v.get() + 1));
                }
            });
        }
        // Observe only; the original-style local SEH handler must catch it.
        0
    }
    struct Handler(*mut c_void);
    impl Drop for Handler {
        fn drop(&mut self) {
            assert_ne!(unsafe { RemoveVectoredExceptionHandler(self.0) }, 0);
        }
    }
    #[test]
    fn audio_windows_engine_thread_name_raises_original_debugger_exception_with_full_width_pointer_and_local_seh_recovers_on8_threads(
    ) {
        let handle = unsafe { AddVectoredExceptionHandler(1, observe) };
        assert!(!handle.is_null());
        let _handler = Handler(handle);
        let threads = (0..8)
            .map(|i| {
                std::thread::spawn(move || {
                    let name = std::ffi::CString::new(if i == 0 {
                        String::new()
                    } else {
                        format!("Enet::SystemInitThread/{i}")
                    })
                    .unwrap();
                    EXPECTED.with(|v| v.set(name.as_ptr() as usize));
                    OBSERVED.with(|v| v.set(0));
                    name_current(&name).unwrap();
                    assert_eq!(
                        OBSERVED.with(Cell::get),
                        1,
                        "raw exception {:x?}",
                        RAW.with(Cell::get)
                    );
                    EXPECTED.with(|v| v.set(0));
                })
            })
            .collect::<Vec<_>>();
        for worker in threads {
            worker.join().unwrap();
        }
    }
}
