from pathlib import Path
import ast,difflib,hashlib,json
ROOT=Path(__file__).resolve().parent
PROJECT=Path('E:/OpenLeague')
sha=lambda b:hashlib.sha256(b).hexdigest()
for p in ROOT.glob('*.py'):ast.parse(p.read_text(encoding='utf-8'))
source=PROJECT/'crates/client/src/annie_ready.rs';raw=source.read_bytes();before=raw.decode().replace('\r\n','\n')
old='let mut app=App::new();app.add_plugins(crate::native_effect_clock::Plugin);app.update();app.update();'
new='let mut app=App::new();crate::native_effect_clock::install_test_clock(&mut app);app.add_plugins(crate::native_effect_clock::Plugin);app.update();app.update();'
assert before.count(old)==1
after=before.replace(old,new)
(ROOT/'annie_ready_test.patch').write_text(''.join(difflib.unified_diff(before.splitlines(keepends=True),after.splitlines(keepends=True),fromfile='a/crates/client/src/annie_ready.rs',tofile='b/crates/client/src/annie_ready.rs')),encoding='utf-8')
inputs=['crates/client/src/main.rs','crates/client/src/annie_ready.rs',
        'crates/core/src/audio_replay_windows_application.rs','crates/core/src/audio_replay_windows_transport.rs',
        'crates/core/src/audio_replay_windows_events.rs','crates/core/src/audio_replay_windows_loading_metadata.rs',
        'crates/core/src/audio_crt_windows_shared_fls.rs','crates/core/src/native_game_clock.rs']
snapshots=[]
for rel in inputs:
    src=PROJECT/rel;contents=src.read_bytes();path=ROOT/'source_snapshots'/Path(rel).name
    path.write_bytes(contents);snapshots.append(dict(source=str(src),snapshot=path.relative_to(ROOT).as_posix(),bytes=len(contents),sha256=sha(contents)))
(ROOT/'input_sources.json').write_text(json.dumps(snapshots,indent=2)+'\n')
client=(ROOT/'native_effect_clock.rs').read_text()
assert all(x not in client for x in ['fn counter()', 'fn frequency()', 'QueryPerformanceCounter', 'QueryPerformanceFrequency', 'Instant::', 'self.origin', 'self.frequency'])
handle=(ROOT/'audio_replay_windows_clock.rs').read_text()
assert 'Arc<Shared<N>>' in handle and 'clock::sample_raw(self)' in handle
assert 'Instant::' not in handle and 'Application::new' not in handle
records=[]
for p in sorted(ROOT.rglob('*')):
    if p.is_file() and p.name!='manifest.json':
        contents=p.read_bytes();records.append(dict(path=p.relative_to(ROOT).as_posix(),bytes=len(contents),sha256=sha(contents)))
proof=dict(schema=1,status='Stage analysé ; Rust non compilé',rust_compilation_attempted=False,rust_tests_run=False,production_integrated=False,
           public_api=['Runtime::clock_handle','Runtime::raw_clock_sample','ClockHandle::raw_clock_sample','ClockHandle::wall_clock_f32_bits'],
           backend_api=['Backend::raw_clock_sample','Backend::native_clock_f32_bits'],
           client_api=['EffectClock::with_process_clock'],new_planned_integration_tests=3,
           dependencies=['Root RawSample/sample_raw API','Root clock::Boundary for Backend<N>','Qualified native once/ConCRT lifecycle','Canonical clock/once PE regions and teardown'],
           limits=['No successful Windows producer claimed; the normal client must not switch until synchronization is qualified.',
                   'First/Bevy native frame scheduling remains an existing host adaptation, not qualified here.',
                   'No compiler used. No tests in this stage have passed yet.'],files=records)
(ROOT/'manifest.json').write_text(json.dumps(proof,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
for r in records:
    contents=(ROOT/r['path']).read_bytes();assert len(contents)==r['bytes'] and sha(contents)==r['sha256']
print(json.dumps(dict(verified=True,files=len(records),rust_compiled=False,manifest_sha256=sha((ROOT/'manifest.json').read_bytes()),client_sha256=sha((ROOT/'native_effect_clock.rs').read_bytes()),child_sha256=sha((ROOT/'audio_replay_windows_clock.rs').read_bytes()))))
