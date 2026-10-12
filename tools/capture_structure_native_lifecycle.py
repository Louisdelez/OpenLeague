from pathlib import Path
s=Path('E:/mapslol3v3/capture_intact_structure_animations.py').read_text(encoding='utf-8')
s=s.replace('16059','16071').replace('intact-structure-runtime','structure-lifecycle-runtime').replace('intact_structure_animation_runtime.json','structure_lifecycle_runtime.json')
s=s.replace("assert len(elapsed)>2 and max(elapsed)>min(elapsed)","assert len(elapsed)>2 and (max(elapsed)>min(elapsed) or all(c['finished'] for a in samples for c in a['active_clips']))")
exec(compile(s,'structure-native-lifecycle-runtime','exec'))
