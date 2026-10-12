from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_critical_sections.rs';s=p.read_text().replace('fn EnterCriticalSection(p:*mut Native);','fn TryEnterCriticalSection(p:*mut Native)->i32;fn EnterCriticalSection(p:*mut Native);');s=s.replace(' pub fn enter(self:&Arc<Self>)->Guard',' pub fn try_enter(self:&Arc<Self>)->Option<Guard>{if unsafe{TryEnterCriticalSection(self.pointer())}==0{return None;}let mut state=self.state.lock().unwrap_or_else(|p|p.into_inner());state.owner=unsafe{GetCurrentThreadId()};state.depth+=1;drop(state);Some(Guard{section:self.clone(),_thread:PhantomData})}\n pub fn enter(self:&Arc<Self>)->Guard');s+=r'''
#[cfg(test)]mod tests{
 use super::*;
 #[test]fn audio_windows_critical_sections_real_initialize_recursion_guard_lifetime_duplicate_and_delete_ownership(){for flags in[None,Some(0)]{for spin in[0,4000]{let mut bank=Bank::default();assert_eq!(bank.initialize(123,spin,flags),Ok(1));assert_eq!(bank.initialize(123,spin,flags),Err(Failure::Duplicate(123)));let section=bank.section(123).unwrap();let first=section.enter();let second=section.try_enter().unwrap();assert_eq!(bank.delete(123),Err(Failure::Busy(123)));drop(second);drop(first);assert_eq!(bank.delete(123),Err(Failure::Busy(123)));drop(section);bank.delete(123).unwrap();assert!(bank.is_empty());assert_eq!(bank.enter(123),Err(Failure::Missing(123)));assert!(bank.report().failures().is_empty());}}}
 #[test]fn audio_windows_critical_sections_actual_cross_thread_try_blocking_entry_and_contended_non_atomic_increment(){
  let mut bank=Bank::default();bank.initialize(456,4000,Some(0)).unwrap();let section=bank.section(456).unwrap();let guard=section.enter();let s=section.clone();let(ready,wait)=std::sync::mpsc::channel();let(entered,entry)=std::sync::mpsc::channel();let worker=std::thread::spawn(move||{assert!(s.try_enter().is_none());ready.send(()).unwrap();let _guard=s.enter();entered.send(()).unwrap();});wait.recv().unwrap();assert!(entry.try_recv().is_err());drop(guard);entry.recv_timeout(std::time::Duration::from_secs(5)).unwrap();worker.join().unwrap();
  let count=Arc::new(std::sync::atomic::AtomicU32::new(0));let mut workers=vec![];for _ in 0..4{let s=section.clone();let c=count.clone();workers.push(std::thread::spawn(move||{for _ in 0..1000{let _guard=s.enter();let value=c.load(std::sync::atomic::Ordering::Relaxed);std::thread::yield_now();c.store(value+1,std::sync::atomic::Ordering::Relaxed);}}));}for worker in workers{worker.join().unwrap();}assert_eq!(count.load(std::sync::atomic::Ordering::Relaxed),4000);drop(section);bank.delete(456).unwrap();assert!(bank.report().failures().is_empty());
 }
 #[test]fn audio_windows_critical_sections_wrong_thread_leave_is_rejected_and_owned_drop_retains_storage_with_failure_report(){
  let mut bank=Bank::default();bank.initialize(789,4000,None).unwrap();bank.enter(789).unwrap();let mut bank=std::thread::spawn(move||{assert_eq!(bank.leave(789),Err(Failure::WrongThread));bank}).join().unwrap();assert_eq!(bank.delete(789),Err(Failure::Busy(789)));bank.leave(789).unwrap();bank.delete(789).unwrap();
  let mut bank=Bank::default();let report=bank.report();bank.initialize(900,4000,Some(0)).unwrap();bank.enter(900).unwrap();drop(bank);assert!(matches!(report.failures().as_slice(),[Failure::OwnedAtDrop{reference:900,depth:1,..}]));
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_shared_fls_tests.rs';s=p.read_text();s+=r'''
#[test]fn audio_windows_shared_fls_production_real_locks_callback_safe_shutdown_matches12_original_global_record_and_lock_table_final_banks(){
 use crate::audio_crt_windows_critical_sections::{Provider,Bank};let p=fixture();let mut count=0;
 for row in p["cases"].as_array().unwrap().iter().filter(|r|r["layout"]=="all"&&r["reverse"]==false){for natural in[false,true]{
  let memory=input(&p,&row["after_second_constructor"]);let mut locks=Bank::default();for j in 0..36{let reference=crate::audio_path_source_virtual_cleanup::get(&memory,&BTreeSet::new(),0x1223580+j*8,4).unwrap();if reference!=0&&locks.section(reference).is_err(){locks.initialize(reference,4000,Some(0)).unwrap();}}assert!(!locks.is_empty());let report=locks.report();
  let context=Arc::new(SharedContext::new(Context{memory,dead:BTreeSet::new(),services:Provider{inner:Api::new(&p,row,true),locks}}));let slot=SharedSlot::new().unwrap();slot.publish_index(&context).unwrap();let mut workers=vec![];
  for record in[0x40012000,0x40013000]{let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{s.bind_current(c,record).unwrap();ready.send(()).unwrap();rx.recv().unwrap();});wait.recv().unwrap();workers.push((tx,worker));}
  if natural{for(tx,worker)in workers.drain(..){tx.send(()).unwrap();worker.join().unwrap();}}
  slot.shutdown_crt(&context).unwrap();slot.shutdown_crt(&context).unwrap();for(tx,worker)in workers{tx.send(()).unwrap();worker.join().unwrap();}
  assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(2,2,None));assert!(report.failures().is_empty());context.with(|c|{
   assert!(c.services.locks.is_empty());assert_eq!(c.services.inner.events.iter().map(|(r,_)|*r).collect::<Vec<_>>(),vec![0x40012000,0x40013000]);
   // Captured 32-bit opaque CS storage is represented by separately pinned host
   // OS objects. Compare all other native bytes; never invent/copy DD host data.
   let mut expected=bank(&p,&row["after"]);for(a,raw)in &mut expected{for(j,v)in raw.iter_mut().enumerate(){let at=*a+j as u32;if(0x14ae988..0x14ae988+36*24).contains(&at){*v=crate::audio_path_memory::read(&c.memory,at,1).unwrap()[0];}}}check(&c.memory,&expected,false);
   assert_eq!(crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,0x12230cc,4).unwrap(),u32::MAX);
  }).unwrap();count+=1;
 }}assert_eq!(count,12);
}
''';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_windows_critical_sections_tests.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('actual OS recursion/contention/ownership and callback-safe complete lock-table retirement tests added')
