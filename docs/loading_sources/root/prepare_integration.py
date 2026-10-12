from pathlib import Path
import json,hashlib,shutil
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;B=S.parent;P=S/'production'
def save(rel,text):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
def copy(src,rel):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,p)
for folder,prefix in [('loading_record_tree_agent','audio_loading_record_tree'),('loading_consumer_agent','audio_loading_screen_packet'),('loading_owner_agent','audio_replay_loading_owner'),('loading_metadata_stage','audio_loading_metadata')]:
 for suffix in ['.rs','_tests.rs']:copy(B/folder/(prefix+suffix),'crates/core/src/'+prefix+suffix)
for folder,prefix in [('loading_owner_agent/windows_adapter','audio_replay_windows_loading'),('loading_metadata_stage','audio_replay_windows_loading_metadata')]:
 for suffix in ['.rs','_tests.rs']:copy(B/folder/(prefix+suffix),'crates/core/src/'+prefix+suffix)
fixtures={'loading_record_tree_agent':['replay_loading_record_tree_probe.json','loading_record_tree_sources.json'],
 'loading_consumer_agent':['tutorial_first_name_probe.json','x87_copy_hardware.json','loading_consumer_sources.json'],
 'replay_loading_record_probe':['replay_loading_existing_record_probe.json'],
 'loading_owner_agent':['loading_owner_probe.json'],
 'loading_metadata_stage':['loading_metadata_probe.json','loading_metadata_sources.json']}
for folder,names in fixtures.items():
 for name in names:copy(B/folder/name,'data/4.20/'+name)
lib=(R/'crates/core/src/lib.rs').read_text(encoding='utf-8')
for name in ['audio_loading_record_tree','audio_loading_screen_packet','audio_replay_loading_owner','audio_loading_metadata']:
 assert f'pub mod {name};' not in lib;lib+=f'\npub mod {name};\n'
save('crates/core/src/lib.rs',lib)
t=(R/'crates/core/src/audio_replay_windows_transport.rs').read_text(encoding='utf-8')
anchor='#[path = "audio_replay_windows_recording.rs"]'
t=t.replace(anchor,'#[path = "audio_replay_windows_loading.rs"]\nmod loading_owner;\n#[path = "audio_replay_windows_loading_metadata.rs"]\nmod loading_metadata;\n'+anchor,1)
anchor="    fn dispose(&mut self, p: u32, f: u32) -> Result<(), &'static str> {"
assert t.count(anchor)==1
t=t.replace(anchor,anchor+'''
        if f == crate::audio_replay_loading_owner::WRAPPER_DISPOSE {
            return crate::audio_replay_loading_owner::dispose_wrapper(self, p)
                .map_err(|e| self.failure(e, "loading wrapper disposal failed"));
        }
        if f == crate::audio_replay_loading_owner::RECIPIENT_DISPOSE {
            return crate::audio_replay_loading_owner::dispose_recipient(self, p)
                .map_err(|e| self.failure(e, "loading recipient disposal failed"));
        }''',1)
save('crates/core/src/audio_replay_windows_transport.rs',t)
t=(R/'crates/core/src/audio_crt_windows_engine_worker.rs').read_text(encoding='utf-8')
anchor='impl Bridge {';assert anchor in t
t=t.replace(anchor,anchor+'''
    /// Read the loading constructor's locale predicate from its canonical CRT bank.
    pub(crate) fn loading_c_locale_is_default(&self) -> Result<bool, String> {
        self.root.context.with(|c| {
            crate::audio_path_source_virtual_cleanup::get(&c.memory, &c.dead, 0x14ae870, 4)
                .map(|v| v == 0)
        }).map_err(|e| format!("loading CRT context: {e:?}"))?
          .map_err(|e| format!("loading CRT locale flag: {e:?}"))
    }
''',1)
save('crates/core/src/audio_crt_windows_engine_worker.rs',t)
additions=json.loads((B/'loading_owner_agent/windows_adapter/runtime_image_additions.json').read_text())['regions']
additional=[(x['label'],x['kind'],x['address'],x['size']) for x in additions]+[('loading_tutorial_constructor_flag',1,0x14c758b,1),('replay_packet_object_vtable',1,0x10d6048,12)]
t=(R/'tools/extract_replay_runtime_image.py').read_text(encoding='utf-8')
anchor=" ('packet95_receiver_pair',1,0x14c761c,8),"
assert t.count(anchor)==1;t=t.replace(anchor,anchor+'\n'+''.join(f" ('{label}',{kind},{hex(a)},{n}),\n" for label,kind,a,n in additional))
t=t.replace("stage=Path('E:/mapslol3v3/replay_receive_stage')",f"stage=Path('{S.as_posix()}')")
save('tools/extract_replay_runtime_image.py',t)
t=(R/'crates/core/src/audio_replay_runtime_image.rs').read_text(encoding='utf-8');assert '; 47]' in t
t=t.replace('; 47]','; 53]').replace('    (1, 0x14c761c, 8),','    (1, 0x14c761c, 8),\n'+''.join(f'    ({kind}, {hex(a)}, {n}),\n' for _,kind,a,n in additional))
save('crates/core/src/audio_replay_runtime_image.rs',t)
print(json.dumps({'staged_files':len([p for p in P.rglob('*') if p.is_file()]),'consumer_adapter_pending':True,'image_regions':53}))
