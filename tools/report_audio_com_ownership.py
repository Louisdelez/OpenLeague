from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src');p=r/'audio_crt_windows_global_services.rs';s=p.read_text()
s=s.replace('InitializationOwnership}','InitializationOwnership,ModuleRelease(u32)}')
needle='pub struct NativeGlobal{';assert needle in s
report='''
#[derive(Default)]pub struct ComReport{loads:std::sync::atomic::AtomicUsize,releases:std::sync::atomic::AtomicUsize,initializations:std::sync::atomic::AtomicUsize,uninitializations:std::sync::atomic::AtomicUsize,failures:std::sync::Mutex<Vec<Failure>>}
impl ComReport{pub fn loads(&self)->usize{self.loads.load(std::sync::atomic::Ordering::Acquire)}pub fn releases(&self)->usize{self.releases.load(std::sync::atomic::Ordering::Acquire)}pub fn initializations(&self)->usize{self.initializations.load(std::sync::atomic::Ordering::Acquire)}pub fn uninitializations(&self)->usize{self.uninitializations.load(std::sync::atomic::Ordering::Acquire)}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}fn fail(&self,e:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(e);}}
'''
s=s.replace(needle,report+needle).replace('ro_counts:BTreeMap<u32,u32>}','ro_counts:BTreeMap<u32,u32>,com_report:std::sync::Arc<ComReport>}').replace('ro_counts:BTreeMap::new()}','ro_counts:BTreeMap::new(),com_report:std::sync::Arc::new(ComReport::default())}')
s=s.replace('pub fn loaded_module_count','pub fn com_report(&self)->std::sync::Arc<ComReport>{self.com_report.clone()}\n pub fn loaded_module_count')
s=s.replace('self.owned_modules.push(pointer);self.register','self.owned_modules.push(pointer);self.com_report.loads.fetch_add(1,std::sync::atomic::Ordering::AcqRel);self.register')
s=s.replace('if result>=0{self.ro_counts.insert(thread,count+1);}','if result>=0{self.ro_counts.insert(thread,count+1);self.com_report.initializations.fetch_add(1,std::sync::atomic::Ordering::AcqRel);}')
s=s.replace('if count==1{self.ro_counts.remove(&thread);}','self.com_report.uninitializations.fetch_add(1,std::sync::atomic::Ordering::AcqRel);if count==1{self.ro_counts.remove(&thread);}')
s=s.replace('if !self.ro_counts.is_empty(){return;}','if !self.ro_counts.is_empty(){self.com_report.fail(Failure::InitializationOwnership);return;}')
s=s.replace('unsafe{FreeLibrary(pointer as*mut c_void)};','if unsafe{FreeLibrary(pointer as*mut c_void)}==0{self.com_report.fail(Failure::ModuleRelease(unsafe{GetLastError()}));}else{self.com_report.releases.fetch_add(1,std::sync::atomic::Ordering::AcqRel);}')
s=s.replace('std::thread::spawn(||{let mut native=NativeGlobal::new(0x76000000).unwrap();','let report=std::thread::spawn(||{let mut native=NativeGlobal::new(0x76000000).unwrap();let report=native.com_report();')
s=s.replace('}).join().unwrap();\n }\n}', 'report\n  }).join().unwrap();assert_eq!((report.loads(),report.releases(),report.initializations(),report.uninitializations()),(1,1,2,2));assert!(report.failures().is_empty());\n }\n}')
p.write_text(s,encoding='utf-8');Path('E:/OpenLeague/tools/report_audio_com_ownership.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('COM ownership report retains module release and unbalanced initialization failures; test verifies post-drop balances')
