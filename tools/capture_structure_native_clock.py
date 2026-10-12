from pathlib import Path
s=Path('E:/mapslol3v3/capture_intact_structure_animations.py').read_text(encoding='utf-8');s=s.replace('16059','16063').replace('intact-structure-runtime','structure-clock-runtime').replace('intact_structure_animation_runtime.json','structure_clock_runtime.json');exec(compile(s,'structure-native-clock-runtime','exec'))
