from pathlib import Path
import difflib
root=Path(__file__).parent
previous=Path('E:/mapslol3v3/replay_callback12_agent')
production=Path('E:/OpenLeague/crates/core/src')
baseline=(previous/'audio_replay_callbacks.rs').read_text(encoding='utf-8')
additions=(root/'invocation_additions.rs').read_text(encoding='utf-8')
assert baseline.count('#[cfg(test)]')==1
combined=baseline.replace('#[cfg(test)]',additions+'\n#[cfg(test)]').replace('Members remain explicit boundaries; invoke12 ports only source5CCEB0.','Members remain explicit boundaries; wrappers preserve their native signatures.')
(root/'audio_replay_callbacks.rs').write_text(combined,encoding='utf-8')
for filename in ['audio_replay_events.rs','callback12_tests.rs','callback12_native_probe.json']:
    (root/filename).write_bytes((previous/filename).read_bytes())
names=['audio_announcer_object_lookup','audio_announcer_registry_init','audio_announcer_registry_remove','audio_announcer_owner_metadata','audio_replay_events','audio_replay_callbacks']
lines=[]
for name in names:
    source=root/(name+'.rs') if(root/(name+'.rs')).exists() else production/(name+'.rs')
    text=source.read_text(encoding='utf-8').split('#[cfg(test)]')[0]
    out=root/('body_'+name+'.rs');out.write_text(text,encoding='utf-8')
    lines.append(f'#[path="{out.name}"]mod {name};')
lines+=['#[cfg(test)]#[path="callback12_tests.rs"]mod callback12_tests;','#[cfg(test)]#[path="signatures_tests.rs"]mod signatures_tests;']
(root/'signatures_harness.rs').write_text('\n'.join(lines)+'\n',encoding='utf-8')
for label,original in [('after_callback12',baseline),('production',(production/'audio_replay_callbacks.rs').read_text(encoding='utf-8'))]:
    (root/('callback_signatures_'+label+'.patch')).write_text(''.join(difflib.unified_diff(original.splitlines(keepends=True),combined.splitlines(keepends=True),fromfile='a/crates/core/src/audio_replay_callbacks.rs',tofile='b/crates/core/src/audio_replay_callbacks.rs')),encoding='utf-8')
print('Prepared combined callback module, two baseline patches, standalone harness with8 new tests and3 preserved callback12 tests.')
