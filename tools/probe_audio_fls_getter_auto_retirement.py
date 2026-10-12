from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/probe_audio_windows_process_heap_contexts.py').read_text()
s=s.replace('tools/hardware/process_heap_contexts','tools/hardware/getter_auto_retirement').replace('audio_windows_process_heap_context_hardware_validation.json','audio_fls_getter_auto_retirement_validation.json').replace('tools/probe_audio_windows_process_heap_contexts.py','tools/probe_audio_fls_getter_auto_retirement.py')
prefix='''type Actual=audio_crt_windows_critical_sections::Provider<audio_crt_windows_process_heap::Provider<Control>>;
fn retire(c:&mut audio_crt_windows_fls_slot::Context<Actual>)->Result<(),Error>{c.services.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).map(|_|()).map_err(|_|Error::Backend("retirement rejected"))}
'''
s=s.replace('fn main(){use',prefix+'fn main(){use').replace('let slot=SharedSlot::new().unwrap();','let slot=SharedSlot::new_with_retirement(retire).unwrap();')
old='assert!(c.dead.contains(&record)&&c.dead.contains(&0x40012000));';new='assert!(!c.dead.contains(&record)&&!c.dead.contains(&0x40012000));assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&0x40012000));assert_eq!(c.services.inner.heap.retained_mirrors(),0);';assert old in s;s=s.replace(old,new).replace('if *a==0x40013000{continue;}','if *a==0x40013000||*a==0x40012000{continue;}')
s=s.replace('shutdown cases;','shutdown with getter-created automatic retirement cases;').replace('Canonical mirrors synchronized at native boundary and retained after free for forensic comparisons; normal mirror retirement, full root/global bootstrap','Canonical mirrors synchronized at native boundary then automatically removed after successful callbacks, including original getter-created records; full root/global bootstrap')
exec(compile(s,'getter-automatic-retirement-proof','exec'))
