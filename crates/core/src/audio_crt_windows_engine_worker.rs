//! Owned CRT worker bridge for native engine callback capsules. The caller supplies
//! an initialized CRT root and a job; no fixture, packet or readiness is fabricated.
use crate::audio_path_source_virtual_cleanup::{live, put};
use crate::{
    audio_crt_windows_root_startup as root, audio_crt_windows_worker_thread as thread,
    audio_crt_worker_entry::Entry, audio_crt_worker_packet as packet, audio_plugin_factory::Memory,
};
use std::{
    cell::RefCell,
    ffi::c_void,
    sync::{Arc, Mutex},
};
pub type Services = crate::audio_crt_windows_critical_sections::Provider<
    crate::audio_crt_windows_process_heap::Provider<
        crate::audio_crt_windows_global_services::NativeGlobal,
    >,
>;
pub type Root = root::Startup<Services>;
pub type Job = Box<dyn FnOnce() -> Result<u32, String> + Send + 'static>;
pub const FAILED: u32 = 0xffff_fffe;
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Completion {
    pub packet: u32,
    pub thread_id: u32,
    pub code: u32,
}
#[derive(Default)]
pub struct Report {
    pub threads: Arc<thread::Report>,
    completions: Mutex<Vec<Completion>>,
    failures: Mutex<Vec<String>>,
}
impl Report {
    fn fail(&self, error: impl Into<String>) {
        self.failures
            .lock()
            .unwrap_or_else(|p| p.into_inner())
            .push(error.into());
    }
    pub fn failures(&self) -> Vec<String> {
        self.failures
            .lock()
            .unwrap_or_else(|p| p.into_inner())
            .clone()
    }
    pub fn completions(&self) -> Vec<Completion> {
        self.completions
            .lock()
            .unwrap_or_else(|p| p.into_inner())
            .clone()
    }
}
struct Current {
    argument: u32,
    job: Job,
    report: Arc<Report>,
}
thread_local! { static CURRENT: RefCell<Option<Current>> = const { RefCell::new(None) }; }
unsafe extern "system" fn callback(argument: u32) -> u32 {
    let Some(current) = CURRENT.with(|c| c.borrow_mut().take()) else {
        return FAILED;
    };
    if argument != current.argument {
        current
            .report
            .fail("CRT callback argument differs from owning capsule");
        return FAILED;
    }
    match std::panic::catch_unwind(std::panic::AssertUnwindSafe(current.job)) {
        Ok(Ok(code)) => code,
        Ok(Err(error)) => {
            current.report.fail(error);
            FAILED
        }
        Err(_) => {
            current
                .report
                .fail("engine worker panicked; CRT cleanup still requested");
            FAILED
        }
    }
}
struct Capsule {
    root: Arc<Root>,
    packet: u32,
    argument: u32,
    job: Job,
    report: Arc<Report>,
}
#[link(name = "kernel32")]
unsafe extern "system" {
    fn ExitThread(code: u32) -> !;
    fn SetLastError(code: u32);
    fn GetCurrentThreadId() -> u32;
}
unsafe extern "system" fn entry(parameter: *mut c_void) -> u32 {
    let data = unsafe { Box::from_raw(parameter.cast::<Capsule>()) };
    let Capsule {
        root,
        packet,
        argument,
        job,
        report,
    } = *data;
    let outcome =
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| -> Result<u32, String> {
            match root
                .initialize_worker_packet(packet)
                .map_err(|e| format!("CRT worker entry: {e:?}"))?
            {
                Entry::Exit { code } => {
                    report.fail(format!("CRT worker publication failed, exit {code}"));
                    return Ok(code);
                }
                Entry::Ready { .. } => {}
            }
            CURRENT.with(|c| {
                *c.borrow_mut() = Some(Current {
                    argument,
                    job,
                    report: report.clone(),
                })
            });
            let result = root
                .prepare_worker_body_exit()
                .map_err(|e| format!("CRT worker body/retirement: {e:?}"));
            if CURRENT.with(|c| c.borrow_mut().take()).is_some() {
                report.fail("CRT worker did not consume its callback");
            }
            let code = result?.code;
            report
                .completions
                .lock()
                .unwrap_or_else(|p| p.into_inner())
                .push(Completion {
                    packet,
                    thread_id: unsafe { GetCurrentThreadId() },
                    code,
                });
            Ok(code)
        }));
    let code = match outcome {
        Ok(Ok(code)) => code,
        Ok(Err(error)) => {
            report.fail(error);
            FAILED
        }
        Err(_) => {
            report.fail("CRT worker entry panicked");
            FAILED
        }
    };
    CURRENT.with(|c| c.borrow_mut().take());
    // ExitThread does not unwind Rust locals. All owned host capsules and roots
    // are retired explicitly before the native terminal call.
    drop(root);
    drop(report);
    unsafe { ExitThread(code) }
}
pub struct Bridge {
    root: Arc<Root>,
    callback: u32,
    scratch: u32,
    next_label: Mutex<u32>,
    report: Arc<Report>,
}
impl Bridge {
    /// Access the single canonical CRT bank; no mutable clock copy is kept here.
    pub(crate) fn clock_crt_read(&self, address: u32, width: u32) -> Result<u32, String> {
        if !matches!(width, 1 | 4) {
            return Err("invalid clock CRT read width".into());
        }
        self.root
            .context
            .with(|c| {
                crate::audio_path_source_virtual_cleanup::get(
                    &c.memory,
                    &c.dead,
                    address,
                    width as usize,
                )
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
            .map_err(|e| format!("clock CRT read: {e:?}"))
    }
    pub(crate) fn clock_crt_write(
        &self,
        address: u32,
        width: u32,
        value: u32,
    ) -> Result<(), String> {
        if !matches!(width, 1 | 4) {
            return Err("invalid clock CRT write width".into());
        }
        self.root
            .context
            .with(|c| {
                crate::audio_path_source_virtual_cleanup::put(
                    &mut c.memory,
                    &c.dead,
                    address,
                    width as usize,
                    value,
                )
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
            .map_err(|e| format!("clock CRT write: {e:?}"))
    }
    pub(crate) fn clock_validate_cs_dispatch(&self, function: u32) -> Result<(), String> {
        if function == 0 {
            return Ok(());
        }
        self.root
            .context
            .with(|c| {
                crate::audio_crt_windows_dispatch_resolver::Lookup::export_pointer(
                    &c.services,
                    function,
                    "InitializeCriticalSectionEx",
                )
                .map(|_| ())
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
            .map_err(|e| format!("clock critical-section dispatch: {e:?}"))
    }
    pub(crate) fn clock_crt_calloc(&self, count: u32, size: u32) -> Result<u32, String> {
        self.root
            .context
            .with(|c| {
                crate::audio_crt_heap::calloc(
                    &mut c.memory,
                    &mut c.dead,
                    count,
                    size,
                    &mut c.services.inner,
                )
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
            .map_err(|e| format!("clock CRT calloc: {e:?}"))
    }
    pub(crate) fn clock_crt_release(&self, address: u32) -> Result<(), String> {
        self.root
            .context
            .with(|c| -> Result<(), String> {
                crate::audio_crt_heap::free(
                    &mut c.memory,
                    &mut c.dead,
                    address,
                    &mut c.services.inner,
                )
                .map_err(|e| format!("clock CRT free: {e:?}"))?;
                if address != 0 && !c.dead.contains(&address) {
                    return Err("clock CRT block was not freed".into());
                }
                Ok(())
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
    }
    pub(crate) fn clock_crt_retire(&self) -> Result<(), String> {
        self.root
            .context
            .with(|c| {
                c.services
                    .inner
                    .heap
                    .retire_mirrors(&mut c.memory, &mut c.dead)
                    .map(|_| ())
            })
            .map_err(|e| format!("clock CRT context: {e:?}"))?
            .map_err(|e| format!("clock CRT mirror retirement: {e:?}"))
    }
    pub(crate) fn clock_crt_free(&self, address: u32) -> Result<(), String> {
        self.clock_crt_release(address)?;
        self.clock_crt_retire()
    }

    /// Read the loading constructor's locale predicate from its canonical CRT bank.
    pub(crate) fn loading_c_locale_is_default(&self) -> Result<bool, String> {
        self.root
            .context
            .with(|c| {
                crate::audio_path_source_virtual_cleanup::get(&c.memory, &c.dead, 0x14ae870, 4)
                    .map(|v| v == 0)
            })
            .map_err(|e| format!("loading CRT context: {e:?}"))?
            .map_err(|e| format!("loading CRT locale flag: {e:?}"))
    }

    /// scratch identifies an unused eight-byte PE32 call-frame bank. The handle
    /// label pool belongs exclusively to this bridge and never contains host pointers.
    pub fn new(root: Arc<Root>, scratch: u32, first_handle: u32) -> Result<Self, String> {
        if root.status != 1 || scratch == 0 || scratch.checked_add(8).is_none() || first_handle == 0
        {
            return Err("invalid initialized CRT root, call frame or handle pool".into());
        }
        let callback = root
            .context
            .with(|c| unsafe { c.services.inner.inner.register_worker_callback(callback) })
            .map_err(|e| format!("callback context: {e:?}"))?
            .map_err(|e| format!("callback registration: {e:?}"))?;
        Ok(Self {
            root,
            callback,
            scratch,
            next_label: Mutex::new(first_handle),
            report: Arc::new(Report::default()),
        })
    }
    pub fn report(&self) -> Arc<Report> {
        self.report.clone()
    }
    /// Err guarantees no Windows thread was started. Ok(None) is the native
    /// beginthreadex zero result. Ok(Some) transfers the job to the worker and
    /// the physical handle to the caller, even if later bookkeeping fails.
    pub fn spawn(&self, argument: u32, job: Job) -> Result<Option<thread::Thread>, String> {
        // Avoid concurrent users of the same borrowed call-frame bank. This
        // lock is never acquired by a worker or held while joining a worker.
        let mut next = self
            .next_label
            .lock()
            .map_err(|_| "worker handle pool poisoned")?;
        let label = *next;
        let following = label
            .checked_add(16)
            .ok_or("worker handle pool exhausted")?;
        self.root
            .context
            .with(|c| -> Result<(), String> {
                let end = u64::from(self.scratch) + 8;
                if c.memory.iter().any(|(&p, b)| {
                    u64::from(p) < end
                        && u64::from(p) + b.raw.len() as u64 > u64::from(self.scratch)
                }) || c.dead.contains(&self.scratch)
                {
                    return Err("worker call frame overlaps existing storage".into());
                }
                c.memory.insert(
                    self.scratch,
                    Memory {
                        reference: self.scratch,
                        raw: vec![0; 8],
                    },
                );
                Ok(())
            })
            .map_err(|e| format!("worker call frame: {e:?}"))??;
        *next = following;
        let request = packet::Request {
            security: 0,
            stack_size: 0,
            callback: self.callback,
            argument,
            flags: 0,
            thread_id_output: self.scratch,
            callback_slot: self.scratch + 4,
        };
        let mut job = Some(job);
        let mut owned = None;
        let result = self
            .root
            .create_worker_packet(request, |q, services, memory, dead| {
                live(memory, dead, q.thread_id_output, 4)?;
                services
                    .inner
                    .heap
                    .synchronize(q.packet, memory)
                    .map_err(|_| {
                        crate::audio_bus_bank::Error::Backend(
                            "worker packet synchronization failed",
                        )
                    })?;
                let capsule = Box::into_raw(Box::new(Capsule {
                    root: self.root.clone(),
                    packet: q.packet,
                    argument,
                    job: job.take().ok_or(crate::audio_bus_bank::Error::Backend(
                        "worker job consumed twice",
                    ))?,
                    report: self.report.clone(),
                }));
                match unsafe {
                    thread::Thread::spawn(
                        label,
                        q,
                        entry,
                        capsule.cast(),
                        self.report.threads.clone(),
                    )
                } {
                    Ok(thread) => {
                        let id = thread.id();
                        owned = Some(thread);
                        // Preflight above guarantees this bank; never report a
                        // pre-start failure after ownership moved to the OS worker.
                        if let Err(e) = put(memory, dead, q.thread_id_output, 4, id) {
                            self.report
                                .fail(format!("started worker ID publication: {e:?}"));
                        }
                        // Producer reads no outputs after this syscall. Retire the
                        // call frame while the parent still owns the CRT context;
                        // the worker body may wait for its spawning caller.
                        memory.remove(&self.scratch);
                        Ok(label)
                    }
                    Err(error) => {
                        unsafe {
                            drop(Box::from_raw(capsule));
                        }
                        match error {
                            thread::Failure::Windows { code, .. } => {
                                unsafe { SetLastError(code) };
                                Ok(0)
                            }
                            _ => Err(crate::audio_bus_bank::Error::Backend(
                                "invalid Windows worker adapter request",
                            )),
                        }
                    }
                }
            });
        if let Some(thread) = owned {
            if let Err(e) = result {
                self.report.fail(format!("started worker producer: {e:?}"));
            }
            return Ok(Some(thread));
        }
        self.root
            .context
            .with(|c| {
                c.memory.remove(&self.scratch);
            })
            .map_err(|e| format!("worker call-frame retirement: {e:?}"))?;
        match result {
            Ok(0) => Ok(None),
            Ok(_) => Err("CRT returned a handle without Windows ownership".into()),
            Err(e) => Err(format!("CRT worker producer: {e:?}")),
        }
    }
}
