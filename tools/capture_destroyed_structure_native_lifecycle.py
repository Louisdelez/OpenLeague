from pathlib import Path
s=Path('E:/mapslol3v3/capture_destroyed_animation_probe.py').read_text(encoding='utf-8')
s=s.replace('16047','16075').replace('destroyed-animation-runtime','destroyed-structure-lifecycle-runtime').replace('destroyed_animation_runtime.json','destroyed_structure_lifecycle_runtime.json')
exec(compile(s,'destroyed-structure-native-lifecycle-runtime','exec'))
