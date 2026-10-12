"""Prepare standalone sources; intentionally never starts rustc or cargo."""
from pathlib import Path
import difflib
root=Path(__file__).parent
production=Path('E:/OpenLeague/crates/core/src')
names=['audio_announcer_object_lookup','audio_announcer_registry_init','audio_announcer_registry_remove','audio_announcer_owner_metadata','audio_replay_events','audio_replay_callbacks']
lines=[]
for name in names:
    source=root/(name+'.rs') if (root/(name+'.rs')).exists() else production/(name+'.rs')
    text=source.read_text(encoding='utf-8').split('#[cfg(test)]')[0]
    output=root/('body_'+name+'.rs');output.write_text(text,encoding='utf-8')
    lines.append(f'#[path="{output.name}"]mod {name};')
lines.append('#[cfg(test)]#[path="callback12_tests.rs"]mod tests;')
(root/'callback12_harness.rs').write_text('\n'.join(lines)+'\n',encoding='utf-8')
(root/'callback12.patch').write_text(''.join(difflib.unified_diff(
    (production/'audio_replay_callbacks.rs').read_text(encoding='utf-8').splitlines(keepends=True),
    (root/'audio_replay_callbacks.rs').read_text(encoding='utf-8').splitlines(keepends=True),
    fromfile='a/crates/core/src/audio_replay_callbacks.rs',tofile='b/crates/core/src/audio_replay_callbacks.rs')),encoding='utf-8')
print('Prepared standalone sources; no compilation executed.')
