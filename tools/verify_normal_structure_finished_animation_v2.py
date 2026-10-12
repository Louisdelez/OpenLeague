from pathlib import Path
s=Path('E:/mapslol3v3/verify_normal_structure_combat.py').read_text(encoding='utf-8')
s=s.replace('16051','16083').replace("logs/normal-structure-combat'","logs/normal-structure-finished-animation-v2'").replace('normal_structure_combat_validation.json','normal_structure_finished_animation_v2_validation.json').replace('time.monotonic()+300','time.monotonic()+600').replace("OPENLEAGUE_SCREENSHOT_DELAY='180'","OPENLEAGUE_SCREENSHOT_DELAY='300'")
needle="if not destroyed and now-last_action.get((i,'order'),0)>2:"
assert needle in s;s=s.replace(needle,"if not destroyed and unit and now-last_action.get((i,'q'),0)>10:\n     command(i,{'Cast':{'slot':0,'target':None}});last_action[(i,'q')]=now\n    "+needle)
needle='if destroyed and png.exists() and png.stat().st_size>10000:break';assert needle in s
s=s.replace(needle,"if destroyed and png.exists() and png.stat().st_size>10000 and probe.exists():\n    samples=[json.loads(line) for line in probe.read_text(encoding='utf-8').splitlines()]\n    if sum(a['id']==target and a['role']=='death' and any(c['finished'] and c['completions']==1 for c in a['active_clips']) for row in samples for a in row['actors'])>=12:break")
s=s.replace('Only ordinary Join/Buy/Learn/Move/Attack/Heal packets used','Only ordinary Join/Buy/Learn/Move/Attack/CastQ/Heal packets used')
exec(compile(s,'normal-structure-finished-animation-v2-wrapper','exec'))
