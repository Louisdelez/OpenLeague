// Uses fresh native-qualified CRT roots. Engine storage is shared between the
// real parent/worker, while global transport state is exclusively worker-owned.
use super::*;
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_registry_init as init,
    audio_announcer_registry_remove as removal, audio_crt_windows_critical_sections as cs,
    audio_crt_windows_engine_worker as bridge, audio_crt_windows_worker_thread as os,
    audio_replay_engine_thread as engine, audio_replay_transport_startup as transport,
    audio_replay_transport_thread as thread,
};
use init::Storage;
use read::Memory as Read;
use std::sync::Mutex;
type Runtime = transport::tests::Harness<transport::windows::WindowsNetwork>;
#[derive(Default)]
struct ResultBank {
    names: Vec<Vec<u8>>,
    workers: Vec<Runtime>,
}
struct Backend {
    memory: Arc<Mutex<init::OwnedMemory>>,
    locks: Arc<Mutex<cs::Bank>>,
    bridge: Option<Arc<bridge::Bridge>>,
    thread: Option<os::Thread>,
    results: Arc<Mutex<ResultBank>>,
    held: Vec<(u32, cs::Guard)>,
    last: u32,
}
impl Backend {
    fn worker(&self) -> Self {
        Self {
            memory: self.memory.clone(),
            locks: self.locks.clone(),
            bridge: None,
            thread: None,
            results: self.results.clone(),
            held: vec![],
            last: 0,
        }
    }
    fn options(&mut self, name: &[u8]) -> u32 {
        let mut m = self.memory.lock().unwrap();
        let p = 0x3000e100;
        m.reserve_at(p, 40).unwrap();
        for i in 0..40 {
            m.write_byte(p + i, 0).unwrap();
        }
        for (i, b) in b"EnetSysInit\0".iter().enumerate() {
            m.write_byte(p + i as u32, *b).unwrap();
        }
        let data = if name.len() >= 16 {
            m.reserve_at(0x3000f000, name.len() as u32 + 1).unwrap();
            m.write_word(p + 16, 0x3000f000).unwrap();
            0x3000f000
        } else {
            p + 16
        };
        for (i, b) in name.iter().chain(std::iter::once(&0)).enumerate() {
            m.write_byte(data + i as u32, *b).unwrap();
        }
        m.write_word(p + 32, name.len() as u32).unwrap();
        m.write_word(
            p + 36,
            if name.len() < 16 {
                15
            } else {
                name.len() as u32 | 15
            },
        )
        .unwrap();
        p
    }
}
impl Read for Backend {
    fn word(&mut self, a: u32) -> Result<u32, read::Error> {
        self.memory.lock().unwrap().word(a)
    }
}
impl Storage for Backend {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        self.memory.lock().unwrap().allocate(n)
    }
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), init::Error> {
        self.memory.lock().unwrap().write_word(a, v)
    }
    fn write_byte(&mut self, a: u32, v: u8) -> Result<(), init::Error> {
        self.memory.lock().unwrap().write_byte(a, v)
    }
    fn register_shutdown(&mut self, _: u32) -> Result<(), init::Error> {
        Err(init::Error::Backend(
            "no shutdown callbacks in engine factory",
        ))
    }
}
impl removal::Backend for Backend {
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), removal::Error> {
        Storage::write_word(self, a, v).map_err(removal::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<removal::Deallocator, removal::Error> {
        Ok(removal::Deallocator::Standard)
    }
    fn free(&mut self, p: u32, _: removal::Deallocator) -> Result<(), removal::Error> {
        self.memory
            .lock()
            .unwrap()
            .release(p)
            .map_err(removal::Error::Owned)
    }
}
impl crate::audio_announcer_owner_component_destructor::ControlBoundary for Backend {
    fn decrement_reference(&mut self, _: u32) -> Result<u32, &'static str> {
        Err("direct engine fixture has no control")
    }
    fn dispose(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("direct engine fixture has no control")
    }
    fn release_control(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("direct engine fixture has no control")
    }
}
#[link(name = "kernel32")]
unsafe extern "system" {
    fn GetCurrentThreadId() -> u32;
}
impl thread::Boundary for Backend {
    fn current_thread_id(&mut self) -> Result<u32, &'static str> {
        Ok(unsafe { GetCurrentThreadId() })
    }
    fn wait_handle(&mut self, h: u32, ms: u32) -> Result<u32, &'static str> {
        let t = self.thread.as_ref().ok_or("no owned physical handle")?;
        assert_eq!(h, t.label());
        match t.wait_only(ms) {
            Ok(true) => Ok(0),
            Ok(false) => Ok(258),
            Err(os::Failure::Windows { code, .. }) => {
                self.last = code;
                Ok(u32::MAX)
            }
            Err(os::Failure::UnexpectedWait(v)) => Ok(v),
            Err(_) => Err("unavailable wait"),
        }
    }
    fn close_handle(&mut self, h: u32) -> Result<u32, &'static str> {
        let t = self.thread.as_mut().ok_or("no owned physical handle")?;
        assert_eq!(h, t.label());
        match t.close() {
            Ok(()) => Ok(1),
            Err(os::Failure::Windows { code, .. }) => {
                self.last = code;
                Ok(0)
            }
            Err(_) => Err("unavailable close"),
        }
    }
    fn last_error(&mut self) -> Result<u32, &'static str> {
        Ok(self.last)
    }
    fn mutex(&mut self, a: u32, enter: bool) -> Result<(), &'static str> {
        if enter {
            let section = self
                .locks
                .lock()
                .unwrap()
                .section(a + 8)
                .map_err(|_| "uninitialized engine lock")?;
            let guard = section.enter();
            self.held.push((a, guard));
        } else {
            let (address, guard) = self.held.pop().ok_or("missing engine lock guard")?;
            assert_eq!(address, a);
            drop(guard);
        }
        Ok(())
    }
    fn delete_critical_section(&mut self, a: u32) -> Result<(), &'static str> {
        self.locks
            .lock()
            .unwrap()
            .delete(a)
            .map_err(|_| "engine lock deletion failed")
    }
    fn create_worker(&mut self, _: &thread::Launch) -> Result<u32, &'static str> {
        Err("direct factory invoked")
    }
    fn exchange_status(&mut self, _: u32) -> Result<u32, &'static str> {
        Err("global transport state is worker-owned in this test")
    }
}
impl engine::Boundary for Backend {
    fn allocate_engine(&mut self, n: u32) -> Result<u32, &'static str> {
        self.allocate(n).map_err(|_| "engine allocation failed")
    }
    fn byte(&mut self, a: u32) -> Result<u8, &'static str> {
        self.memory
            .lock()
            .unwrap()
            .read_byte(a)
            .map_err(|_| "missing engine byte")
    }
    fn initialize_critical_section(&mut self, a: u32) -> Result<(), &'static str> {
        self.locks
            .lock()
            .unwrap()
            .initialize(a, 0, None)
            .map(|_| ())
            .map_err(|_| "engine critical-section initialization failed")
    }
    fn create_crt_worker(
        &mut self,
        callback: u32,
        capsule: u32,
    ) -> Result<engine::Handle, &'static str> {
        assert_eq!(callback, engine::CAPSULE_CALLBACK);
        // Guards are thread-affine. Capture shared storage, then create the worker's
        // own backend/guard stack after Windows has actually started that worker.
        let (memory, locks, results) = (
            self.memory.clone(),
            self.locks.clone(),
            self.results.clone(),
        );
        let t = self
            .bridge
            .as_ref()
            .ok_or("no CRT bridge")?
            .spawn(
                capsule,
                Box::new(move || {
                    let mut b = Backend {
                        memory,
                        locks,
                        bridge: None,
                        thread: None,
                        results,
                        held: vec![],
                        last: 0,
                    };
                    engine::run_capsule(&mut b, capsule)
                        .map_err(|e| format!("engine capsule: {e:?}"))
                }),
            )
            .map_err(|_| "CRT producer failed before starting a worker")?;
        match t {
            Some(t) => {
                let h = engine::Handle {
                    handle: t.label(),
                    id: t.id(),
                };
                assert!(self.thread.replace(t).is_none());
                Ok(h)
            }
            None => Ok(engine::Handle { handle: 0, id: 0 }),
        }
    }
    fn name_current_thread(&mut self, p: u32) -> Result<(), &'static str> {
        let mut name = vec![];
        for i in 0..128 {
            let b = engine::Boundary::byte(self, p + i)?;
            if b == 0 {
                self.results.lock().unwrap().names.push(name);
                return Ok(());
            }
            name.push(b);
        }
        Err("unterminated engine thread name")
    }
    fn invoke(&mut self, f: u32, a: u32) -> Result<(), &'static str> {
        assert_eq!((f, a), (0x8fc100, 0));
        let mut runtime = Runtime::new(transport::windows::WindowsNetwork::default());
        transport::worker(&mut runtime).map_err(|_| "real transport worker failed")?;
        self.results.lock().unwrap().workers.push(runtime);
        Ok(())
    }
}
#[test]
fn audio_replay_engine_48_actual_crt_workers_copy_names_execute_transport_join_and_retire_capsules_thread_objects_and_real_locks(
) {
    let p = fixture();
    let mut count = 0;
    for row in p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .filter(|v| v["layout"] == "all" && v["failure"] == "none")
    {
        let mut c = prepare(&p, row);
        c.memory.insert(
            0x14ae5f8,
            Memory {
                reference: 0x14ae5f8,
                raw: vec![0; 16],
            },
        );
        c.memory.insert(
            0x122343c,
            Memory {
                reference: 0x122343c,
                raw: u32::MAX.to_le_bytes().to_vec(),
            },
        );
        let heap = c.services.inner.heap.report();
        let root = Arc::new(initialize(c, Some(retire)).unwrap());
        let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
        let report = bridge.report();
        for name in [
            vec![],
            vec![b'A'],
            vec![b'A'; 15],
            vec![b'A'; 16],
            b"Enet::SystemInitThread".to_vec(),
            vec![b'A'; 31],
            vec![b'A'; 32],
            vec![b'A'; 63],
        ] {
            let memory = Arc::new(Mutex::new(init::OwnedMemory::new(0x39000000, 0xa5)));
            let locks = Arc::new(Mutex::new(cs::Bank::default()));
            let results = Arc::new(Mutex::new(ResultBank::default()));
            let mut b = Backend {
                memory: memory.clone(),
                locks: locks.clone(),
                bridge: Some(bridge.clone()),
                thread: None,
                results: results.clone(),
                held: vec![],
                last: 0,
            };
            let options = b.options(&name);
            let object = engine::create(&mut b, 0x8fc100, 0, options).unwrap();
            assert_ne!(object, 0);
            let tid = b.thread.as_ref().unwrap().id();
            assert_eq!(b.word(object + 0x24).unwrap(), tid);
            assert_eq!(thread::join(&mut b, object, 10000).unwrap(), 0);
            assert_eq!(b.word(object).unwrap(), 0);
            assert_eq!(b.word(object + 0x24).unwrap(), 0);
            assert!(b.thread.as_ref().unwrap().is_closed());
            thread::destroy(&mut b, object).unwrap();
            assert!(b.held.is_empty());
            assert!(locks.lock().unwrap().is_empty());
            assert!(locks.lock().unwrap().report().failures().is_empty());
            let m = memory.lock().unwrap();
            assert_eq!(m.allocations.len(), if name.len() < 16 { 2 } else { 4 });
            assert_eq!(
                m.released_labels.iter().copied().collect::<BTreeSet<_>>(),
                m.allocations.iter().map(|(_, p)| *p).collect()
            );
            drop(m);
            let mut r = results.lock().unwrap();
            assert_eq!(
                r.names,
                vec![if name.is_empty() {
                    b"EnetSysInit".to_vec()
                } else {
                    name.clone()
                }]
            );
            assert_eq!(r.workers.len(), 1);
            let runtime = &mut r.workers[0];
            assert_eq!(runtime.words[&transport::STATUS], 2);
            assert_eq!(runtime.words[&transport::REFERENCES], 1);
            assert_eq!(runtime.network.outstanding(), (1, 1));
            transport::release(runtime).unwrap();
            assert_eq!(runtime.network.outstanding(), (0, 0));
            let completion = report.completions().last().unwrap().clone();
            assert_eq!(completion.thread_id, tid);
            assert_eq!(completion.code, 0);
            root.context
                .with(|c| {
                    assert!(!c.memory.contains_key(&completion.packet));
                    assert!(!c.memory.contains_key(&0x41000000));
                    assert_eq!(c.services.inner.inner.pending_ro_initializations(), 0);
                })
                .unwrap();
            count += 1;
        }
        assert_eq!((report.threads.created(), report.threads.closed()), (8, 8));
        assert_eq!(report.completions().len(), 8);
        assert!(report.failures().is_empty() && report.threads.failures().is_empty());
        drop(bridge);
        root.shutdown().unwrap();
        root.context
            .with(|c| {
                assert_eq!(c.services.inner.heap.outstanding(), 0);
                assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
                assert!(c.services.locks.is_empty());
            })
            .unwrap();
        assert_eq!((heap.allocations(), heap.frees()), (9, 9));
        assert!(heap.failures().is_empty());
    }
    assert_eq!(count, 48);
}
#[test]
fn audio_replay_engine_crt_bridge_prestart_overlap_failure_and_worker_callback_error_preserve_ownership_without_parent_worker_deadlock(
) {
    let p = fixture();
    let row = p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["layout"] == "all" && v["failure"] == "none")
        .unwrap();
    let mut c = prepare(&p, row);
    c.memory.insert(
        0x14ae5f8,
        Memory {
            reference: 0x14ae5f8,
            raw: vec![0; 16],
        },
    );
    c.memory.insert(
        0x122343c,
        Memory {
            reference: 0x122343c,
            raw: u32::MAX.to_le_bytes().to_vec(),
        },
    );
    let heap = c.services.inner.heap.report();
    let root = Arc::new(initialize(c, Some(retire)).unwrap());
    let invalid = bridge::Bridge::new(root.clone(), 0x122343c, 0x73000000).unwrap();
    assert!(invalid
        .spawn(
            17,
            Box::new(|| panic!("overlapping call frame must not start"))
        )
        .is_err());
    assert_eq!(invalid.report().threads.created(), 0);
    drop(invalid);
    let bridge = bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap();
    let report = bridge.report();
    let (send, receive) = std::sync::mpsc::channel();
    let mut thread = bridge
        .spawn(
            73,
            Box::new(move || {
                receive
                    .recv_timeout(std::time::Duration::from_secs(5))
                    .map_err(|_| "spawning caller was blocked by its own worker".to_string())?;
                Err("intentional worker callback error".into())
            }),
        )
        .unwrap()
        .unwrap();
    send.send(()).unwrap();
    assert_eq!(
        thread.wait(10000).unwrap(),
        os::Wait::Exited(bridge::FAILED)
    );
    thread.close().unwrap();
    drop(thread);
    assert_eq!(report.failures(), vec!["intentional worker callback error"]);
    assert_eq!(report.completions().len(), 1);
    assert_eq!(report.completions()[0].code, bridge::FAILED);
    assert_eq!((report.threads.created(), report.threads.closed()), (1, 1));
    assert!(report.threads.failures().is_empty());
    drop(bridge);
    root.shutdown().unwrap();
    assert_eq!((heap.allocations(), heap.frees()), (2, 2));
    assert!(heap.failures().is_empty());
}
