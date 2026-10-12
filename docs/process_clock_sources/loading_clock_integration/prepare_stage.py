from pathlib import Path
import json,hashlib,shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/loading_clock_integration');B=S.parent;P=S/'production';C=Path('crates/core/src')
base={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def put(rel,raw):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(raw if isinstance(raw,bytes) else raw.encode('utf-8'));base[str(rel).replace('\\','/')]=sha(R/rel) if (R/rel).exists() else None
def source(rel):return (R/rel).read_text(encoding='utf-8')
for name in ['audio_native_process_clock.rs','audio_native_process_clock_tests.rs','audio_windows_fifo_mutex.rs','audio_replay_windows_clock_host.rs']:
 text=(S/name).read_text(encoding='utf-8')
 if name.endswith('_tests.rs'):
  text=text.replace('include_str!("native_clock_results.json")','&crate::audio_test_fixture("data/4.20/native_clock_results.json")').replace('include_str!("clock_x87_hardware.json")','&crate::audio_test_fixture("data/4.20/clock_x87_hardware.json")')
 put(C/name,text)
for name in ['audio_clock_once.rs','audio_clock_once_tests.rs']:put(C/name,(B/'loading_clock_sync_agent'/name).read_bytes())
for name in ['audio_loading_screen_packet.rs','audio_loading_screen_packet_tests.rs','audio_replay_windows_loading_packets.rs','audio_replay_windows_loading_packets_tests.rs']:
 text=(B/'loading_empty_integration'/name).read_text(encoding='utf-8')
 if name=='audio_replay_windows_loading_packets_tests.rs':text+='\n'+(B/'loading_empty_integration_extra/addition_tests.rs.txt').read_text(encoding='utf-8')
 put(C/name,text)
for folder,name in [('loading_clock_integration','native_clock_results.json'),('loading_clock_integration','clock_x87_hardware.json'),('loading_clock_sync_agent','clock_sync_probe.json'),('loading_empty_integration','loading_standard_empty_name_probe.json')]:put(Path('data/4.20')/name,(B/folder/name).read_bytes())
for name in ['audio_replay_windows_clock.rs','audio_replay_windows_clock_tests.rs']:
 text=(B/'loading_clock_client_adapter'/name).read_text(encoding='utf-8')
 if name=='audio_replay_windows_clock.rs':
  text=text.replace('    shared: Arc<Shared<N>>,','    pub(super) shared: Arc<Shared<N>>,')
  text=text.replace('clock::sample_raw(self).map_err(|e| self.failure(e, "native process clock sample failed"))','self.clock_preflight()?;\n        clock::sample_raw(self).map_err(|e| self.clock_failed(e))')
 put(C/name,text)
text=source(C/'audio_replay_windows_loading_metadata.rs');old='Err("native process clock993CE0 producer is not connected to the loading screen")';assert old in text;put(C/'audio_replay_windows_loading_metadata.rs',text.replace(old,'self.native_clock_f32_bits()'))
text=source(C/'audio_crt_windows_engine_worker.rs');old='impl Bridge {\n';assert text.count(old)==1;put(C/'audio_crt_windows_engine_worker.rs',text.replace(old,old+(S/'bridge_clock_methods.rs.txt').read_text(encoding='utf-8')))
text=source(C/'audio_replay_windows_transport.rs')
assert 'mod clock_host;' not in text
text=text.replace('#[path = "audio_replay_windows_configuration.rs"]','#[path = "audio_replay_windows_clock.rs"]\nmod process_clock;\n#[path = "audio_replay_windows_clock_host.rs"]\nmod clock_host;\npub use process_clock::ClockHandle;\npub use clock_host::ProcessClockSnapshot;\n#[path = "audio_replay_windows_configuration.rs"]',1)
text=text.replace('    bank: Mutex<Bank>,','    bank: Mutex<Bank>,\n    clock: Mutex<clock_host::HostState>,',1)
text=text.replace('                locks: Mutex::new(locks),','                clock: Mutex::new(clock_host::HostState::default()),\n                locks: Mutex::new(locks),',1)
text=text.replace('        if !self.shared.bank.lock().unwrap().owned.is_empty() {','        b.shutdown_process_clock()?;\n        if !self.shared.bank.lock().unwrap().owned.is_empty() {',1)
put(C/'audio_replay_windows_transport.rs',text)
text=source(C/'lib.rs');assert 'pub mod audio_native_process_clock;' not in text
text+='\npub mod audio_native_process_clock;\npub mod audio_clock_once;\n#[cfg(windows)] pub mod audio_windows_fifo_mutex;\n';put(C/'lib.rs',text)
additions=[('process_clock_origin_and_frequency',1,0x14bef48,16),('process_clock_frequency_ready',1,0x2d79080,1),('process_clock_frequency_cache',1,0x2d79158,8),('process_clock_once_flag',1,0x2d75530,4),('process_clock_callback_vtable',1,0x10de608,4),('process_clock_mutex_ready',1,0x14af61c,1),('process_clock_mutex_pointer',1,0x14af620,4),('process_clock_outer_state_and_section',1,0x14b1840,28)]
text=source(Path('tools/extract_replay_runtime_image.py'));needle=" ('replay_packet_object_vtable',1,0x10d6048,12),";assert needle in text
text=text.replace(needle,needle+'\n'+''.join(' (%r,%d,0x%x,%d),\n'%row for row in additions));text=text.replace("stage=Path('E:/mapslol3v3/loading_metadata_stage')","stage=Path('E:/mapslol3v3/loading_clock_integration')");put(Path('tools/extract_replay_runtime_image.py'),text)
text=source(C/'audio_replay_runtime_image.rs');text=text.replace('; 53]','; 61]');needle='    (1, 0x10d6048, 12),';assert needle in text
text=text.replace(needle,needle+'\n'+''.join('    (%d, 0x%x, %d),\n'%(g,a,n) for _,g,a,n in additions));put(C/'audio_replay_runtime_image.rs',text)
# Client receives the handle from its existing application, before Plugin build.
put(Path('crates/client/src/native_effect_clock.rs'),(B/'loading_clock_client_adapter/native_effect_clock.rs').read_bytes())
text=source(Path('crates/client/src/main.rs'));needle='    app.insert_non_send_resource(runtime);';assert text.count(needle)==1
text=text.replace(needle,'    let process_clock = runtime.transport()?.clock_handle()?;\n    app.insert_resource(native_effect_clock::EffectClock::with_process_clock(process_clock));\n'+needle);put(Path('crates/client/src/main.rs'),text)
text=source(Path('crates/client/src/annie_ready.rs'));needle='let mut app=App::new();app.add_plugins(crate::native_effect_clock::Plugin);';assert text.count(needle)==1
put(Path('crates/client/src/annie_ready.rs'),text.replace(needle,'let mut app=App::new();crate::native_effect_clock::install_test_clock(&mut app);app.add_plugins(crate::native_effect_clock::Plugin);'))
(S/'base_hashes.json').write_text(json.dumps(base,indent=2)+'\n',encoding='utf-8')
(S/'image_additions.json').write_text(json.dumps(additions,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'staged_files':len(base),'image_regions':61}))
