from pathlib import Path
s=Path('E:/mapslol3v3/verify_normal_structure_combat_q.py').read_text(encoding='utf-8')
s=s.replace("exec(compile(s,'normal-structure-combat-q','exec'))", "s=s.replace('16055','16079').replace('normal-structure-combat-q','normal-structure-finished-animation').replace('normal_structure_combat_q_validation.json','normal_structure_finished_animation_validation.json').replace(\"c['elapsed']>2\",\"c['finished'] and c['completions']==1\")\nexec(compile(s,'normal-structure-finished-animation','exec'))")
exec(compile(s,'normal-structure-finished-animation-wrapper','exec'))
