from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_audio_windows_process_heap_contexts.py').read_text()
s=s.replace("tools/hardware/process_heap_contexts", "tools/hardware/process_heap_context_retirement")
s=s.replace("audio_windows_process_heap_context_hardware_validation.json", "audio_heap_mirror_context_retirement_validation.json")
s=s.replace("tools/probe_audio_windows_process_heap_contexts.py", "tools/probe_audio_heap_mirror_context_retirement.py")
needle='assert_eq!((heap_report.allocations(),heap_report.frees()),(2,2));'
replacement='''context.with(|c|{assert_eq!(c.services.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).unwrap(),2);assert_eq!(c.services.inner.heap.retained_mirrors(),0);assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&0x40012000));assert!(!c.dead.contains(&record)&&!c.dead.contains(&0x40012000));}).unwrap();'''+needle
assert needle in s;s=s.replace(needle,replacement)
s=s.replace('shutdown cases;', 'shutdown and post-callback mirror retirement cases;')
# Execute the original proof generator with the additional source assertions.
exec(compile(s,'context-retirement-proof','exec'))
(r/'tools/probe_audio_heap_mirror_context_retirement.py').write_text(Path(__file__).read_text(),encoding='utf-8')
