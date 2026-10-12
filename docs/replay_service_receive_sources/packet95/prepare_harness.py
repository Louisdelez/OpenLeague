from pathlib import Path
import re
out=Path(__file__).resolve().parent;src=Path('E:/OpenLeague/crates/core/src')
needed={'audio_replay_packet95'};done={};extra=set()
while needed:
    name=needed.pop()
    if name in done:continue
    path=(out if name=='audio_replay_packet95' else src)/(name+'.rs')
    text='';files=[path];done[name]=path;seen=set()
    while files:
        p=files.pop()
        if p in seen:continue
        seen.add(p);part=p.read_text();text+='\n'+part
        for match in re.findall(r'#\[path\s*=\s*"([^"]+)"\]',part):
            child=p.parent/match
            if child.exists():files.append(child)
    for n in re.findall(r'crate::(audio_\w+)',text):
        if n!='audio_test_fixture' and n not in done:needed.add(n)
lines=['#![allow(dead_code)]']+[f'#[path="{p.as_posix()}"] mod {name};' for name,p in sorted(done.items())]
lines.append('fn audio_test_fixture(path:&str)->String{let name=std::path::Path::new(path).file_name().unwrap();let root=if name=="replay_packet95_probe.json"{"E:/mapslol3v3/replay_packet95_agent"}else{"E:/OpenLeague/data/4.20"};std::fs::read_to_string(std::path::Path::new(root).join(name)).unwrap()}')
(out/'packet95_harness.rs').write_text('\n'.join(lines)+'\n')
print(f'harness: {len(done)} real modules, no production edits')
