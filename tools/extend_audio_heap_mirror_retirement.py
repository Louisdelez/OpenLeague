from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_process_heap.rs';s=p.read_text()
start=s.index('  loop{let end=reference.checked_add(span)')
end=s.index('\n  let Some(block)=',start)
s=s[:start]+'''  loop{let end=reference.checked_add(span).ok_or(Failure::AddressSpace)?;
   let occupied=m.iter().map(|(&a,v)|(a,v.raw.len())).chain(self.blocks.iter().map(|(&a,b)|(a,b.size))).chain(self.retired.iter().map(|(&a,&size)|(a,size)));
   if let Some((a,size))=occupied.filter(|(a,size)|(reference as u64)<*a as u64+(*size).max(1)as u64&&(*a as u64)<end as u64).next(){reference=(a as u64+size.max(1)as u64+15).try_into().map_err(|_|Failure::AddressSpace)?;reference&=!15;}else{break;}
  }'''+s[end:]
old='let raw=&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw;let mut block='
new='''let raw=&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw;
 let end=reference as u64+raw.len().max(1)as u64;if end>u32::MAX as u64{return Err(Failure::AddressSpace);}
 if self.blocks.iter().map(|(&a,b)|(a,b.size)).chain(self.retired.iter().map(|(&a,&size)|(a,size))).any(|(a,size)|(a as u64)<end&&(reference as u64)<a as u64+size.max(1)as u64){return Err(Failure::InvalidReference);}
 let mut block='''
assert old in s;s=s.replace(old,new)
test='''
 #[test]fn audio_windows_process_heap_post_callback_mirror_retirement_is_atomic_and_bounded(){
  let mut m=BTreeMap::new();let mut d=BTreeSet::from([0x60000000]);defaults(&mut m);let baseline=m.len();let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();let report=heap.report();
  for _ in 0..256{let mut refs=Vec::new();for size in[1,944,8192]{let a=heap.allocate(0x71000000,8,size,&mut m,&mut d).unwrap();refs.push(a);heap.free(0x71000000,0,a,&m,&mut d).unwrap();}let a=refs[0];let b=refs[2];m.get_mut(&b).unwrap().raw.push(0);assert_eq!(heap.retire_mirrors(&mut m,&mut d),Err(Failure::RetirementConflict(b)));assert!(m.contains_key(&a)&&d.contains(&a));m.get_mut(&b).unwrap().raw.pop();assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),3);assert_eq!(heap.retained_mirrors(),0);assert_eq!(m.len(),baseline);assert_eq!(d,BTreeSet::from([0x60000000]));}
  assert_eq!((report.allocations(),report.frees()),(768,768));assert!(report.failures().is_empty());
 }
 #[test]fn audio_windows_process_heap_reserves_live_and_retired_ranges_even_without_mirrors(){
  let mut m=BTreeMap::new();let mut d=BTreeSet::new();defaults(&mut m);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();m.insert(0x50000000,Memory{reference:0x50000000,raw:vec![0;32]});heap.adopt(0x50000000,&m).unwrap();let saved=m.remove(&0x50000000).unwrap();let a=heap.allocate(0x71000000,8,16,&mut m,&mut d).unwrap();assert_eq!(a,0x50000020);m.insert(0x50000010,Memory{reference:0x50000010,raw:vec![0;16]});assert_eq!(heap.adopt(0x50000010,&m),Err(Failure::InvalidReference));m.remove(&0x50000010);m.insert(0x50000000,saved);heap.free(0x71000000,0,0x50000000,&m,&mut d).unwrap();heap.free(0x71000000,0,a,&m,&mut d).unwrap();assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),2);
 }
'''
s=s.rstrip();assert s.endswith('}');s=s[:-1]+test+'}\n'
# Keep native forensic comparison first; retire only once both callbacks completed.
needle='assert_eq!((heap_report.allocations(),heap_report.frees()),(2,2));'
replacement='''context.with(|c|{assert_eq!(c.services.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).unwrap(),2);assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&0x40012000));assert!(!c.dead.contains(&record)&&!c.dead.contains(&0x40012000));}).unwrap();'''+needle
assert needle in s;s=s.replace(needle,replacement)
p.write_text(s,encoding='utf-8');(r/'tools/extend_audio_heap_mirror_retirement.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Added core bounded/atomic/reservation checks and actual FLS post-callback retirement')
