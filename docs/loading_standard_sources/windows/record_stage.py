from pathlib import Path
import difflib
import hashlib
import json

HERE=Path(__file__).resolve().parent
CORE=Path('E:/OpenLeague/crates/core/src')
EXISTING=['audio_replay_windows_transport.rs','audio_replay_windows_loading_packets.rs',
          'audio_replay_windows_loading_packets_tests.rs']
NEW=['audio_replay_windows_loading_retirement.rs','audio_replay_windows_loading_retirement_tests.rs']

def record(path):
    path=Path(path);raw=path.read_bytes()
    return {'path':str(path),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}

baselines=[];patch=[]
for name in EXISTING:
    source=CORE/name;baseline=HERE/('base_'+name+'.txt')
    if baseline.exists():
        assert baseline.read_bytes()==source.read_bytes(),f'Production drift: {name}'
    else:
        baseline.write_bytes(source.read_bytes())
    baselines.append(record(baseline))
    patch.extend(difflib.unified_diff(source.read_text(encoding='utf-8').splitlines(True),
        (HERE/name).read_text(encoding='utf-8').splitlines(True),fromfile='a/'+name,tofile='b/'+name))
old=(CORE/EXISTING[2]).read_text(encoding='utf-8')
new=(HERE/EXISTING[2]).read_text(encoding='utf-8')
start='#[test]\nfn audio_replay_windows_loading_standard_matches64_empty_names_through_real_metadata()'
assert old[old.index(start):]==new[new.index(start):], 'Existing empty/tutorial tests were changed'
tests=(HERE/NEW[1]).read_text(encoding='utf-8')
assert tests.count('#[test]')==3
generic=HERE.parent/'generic/stage_manifest.json'
assert generic.exists()
(HERE/'changes.patch').write_text(''.join(patch),encoding='utf-8')
manifest={
    'kind':'windows_standard_loading_typed_ownership_candidate',
    'complete':False,'production_integrated':False,'rust_compiled':False,'rust_tests_run':False,
    'client_executed':False,'ui_qualified':False,'normal_recipient_factory_qualified':False,
    'new_windows_tests_prepared':3,'empty64_and_tutorial4_tests_text_unchanged':True,
    'scope':'standard prefix and typed temporary ownership; existing pre-name/tutorial/cache error contracts unchanged',
    'dependencies':{'generic_manifest':record(generic),
        'atomic_release_source':record(CORE/'audio_announcer_registry_init.rs'),
        'existing_scratch_source':record(CORE/'audio_replay_windows_events.rs')},
    'baselines':baselines,'files':[record(HERE/name) for name in EXISTING+NEW],
    'artifacts':[record(HERE/name) for name in ['README.md','changes.patch','record_stage.py']],
}
path=HERE/'stage_manifest.json';path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':record(path),'files':len(EXISTING+NEW),'new_windows_tests_prepared':3,
                  'rust_compiled':False,'rust_tests_run':False}))
