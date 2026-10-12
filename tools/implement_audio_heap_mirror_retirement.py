from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/core/src/audio_crt_windows_process_heap.rs'
s=p.read_text()
s=s.replace('WrongSize,MirrorAllocation,Windows','WrongSize,MirrorAllocation,RetirementConflict(u32),Windows')
s=s.replace('blocks:BTreeMap<u32,Block>,report:', 'blocks:BTreeMap<u32,Block>,retired:BTreeMap<u32,usize>,report:')
s=s.replace('blocks:BTreeMap::new(),report:', 'blocks:BTreeMap::new(),retired:BTreeMap::new(),report:')
s=s.replace('self.blocks.contains_key(&reference){', 'self.blocks.contains_key(&reference)||self.retired.contains_key(&reference){')
s=s.replace('self.blocks.remove(&reference);d.insert(reference);Ok(1)', 'let size=self.blocks.remove(&reference).unwrap().size;self.retired.insert(reference,size);d.insert(reference);Ok(1)')
anchor=' pub fn outstanding(&self)->usize{self.blocks.len()}'
addition='''
 /// Call only after the original callback and any diagnostic snapshot readers
 /// have finished. The canonical map must not replace an owned allocation
 /// between allocation, free and retirement. This operation owns only the
 /// entries freed by this heap; unrelated dead memory remains untouched.
 pub fn retire_mirrors(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<usize,Failure>{
  // Preflight the complete batch before changing either memory or tombstones.
  for (&reference,&size) in &self.retired{
   let v=m.get(&reference).ok_or(Failure::RetirementConflict(reference))?;
   if self.blocks.contains_key(&reference)||!d.contains(&reference)||v.reference!=reference||v.raw.len()!=size{return Err(Failure::RetirementConflict(reference));}
   let end=reference as u64+size.max(1)as u64;
   if m.iter().any(|(&a,v)|a!=reference&&(a as u64)<end&&(reference as u64)<a as u64+v.raw.len().max(1)as u64){return Err(Failure::RetirementConflict(reference));}
  }
  let count=self.retired.len();for &reference in self.retired.keys(){m.remove(&reference);d.remove(&reference);}self.retired.clear();Ok(count)
 }
 pub fn retained_mirrors(&self)->usize{self.retired.len()}
'''
assert anchor in s
s=s.replace(anchor,anchor+addition)
# Reserve live physical ranges even if an external adapter removed their mirror.
old='else{break;}}'
new='''else if let Some((&a,b))=self.blocks.iter().find(|(a,b)|(reference as u64)<**a as u64+b.size.max(1)as u64&&(**a as u64)<end as u64){reference=(a as u64+b.size.max(1)as u64+15).try_into().map_err(|_|Failure::AddressSpace)?;reference&=!15;}else{break;}}'''
assert old in s
s=s.replace(old,new,1)
p.write_text(s,encoding='utf-8')
(r/'tools/implement_audio_heap_mirror_retirement.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Implemented atomic post-callback mirror retirement and live physical range reservation')
