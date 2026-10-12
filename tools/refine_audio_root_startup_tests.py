from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_root_startup.rs';s=p.read_text()
s=s.replace('use crate::audio_crt_windows_global_services::{NativeGlobal,Event};','use crate::audio_crt_windows_global_services::{NativeGlobal,Event};use crate::audio_global_float_default_power::Windows;')
s=s.replace(' fn compare(p:&Value,row:&Value,c:&Context<Owned>,record:Option<u32>)'," struct View<'a>{memory:&'a BTreeMap<u32,Memory>,dead:&'a BTreeSet<u32>,services:&'a Owned}\n fn compare(p:&Value,row:&Value,c:View<'_>,record:Option<u32>)")
s=s.replace('compare(&p,row,c,Some(record))','compare(&p,row,View{memory:&c.memory,dead:&c.dead,services:&c.services},Some(record))')
old='let view=Context{memory:BTreeMap::new(),dead:BTreeSet::new(),services:NativeGlobal::new(0x73000000).unwrap()};let _view=view;'
assert old in s;s=s.replace(old,'compare(&p,row,View{memory:&c.memory,dead:&c.dead,services:&c.services.inner},started.initial_record);')
s=s.replace('let cookie=row["cookie"].as_u64().unwrap()as u32;let _cookie=cookie;','')
p.write_text(s,encoding='utf-8');(r/'tools/refine_audio_root_startup_tests.py').write_text(Path(__file__).read_text(),encoding='utf-8')
