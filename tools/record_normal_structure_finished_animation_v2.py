from pathlib import Path
s=Path('E:/mapslol3v3/record_normal_structure_finished_animation.py').read_text(encoding='utf-8')
s=s.replace('normal-structure-finished-animation','normal-structure-finished-animation-v2').replace('normal_structure_finished_animation_validation.json','normal_structure_finished_animation_v2_validation.json')
exec(compile(s,'normal-structure-finished-animation-v2-recorder','exec'))
