from pathlib import Path
s=Path('E:/mapslol3v3/verify_normal_structure_combat.py').read_text(encoding='utf-8')
s=s.replace('16051','16055').replace("logs/normal-structure-combat'","logs/normal-structure-combat-q'").replace('normal_structure_combat_validation.json','normal_structure_combat_q_validation.json').replace('time.monotonic()+300','time.monotonic()+600').replace("OPENLEAGUE_SCREENSHOT_DELAY='180'","OPENLEAGUE_SCREENSHOT_DELAY='240'")
needle="if not destroyed and now-last_action.get((i,'order'),0)>2:"
s=s.replace(needle,"if not destroyed and unit and now-last_action.get((i,'q'),0)>10:\n     command(i,{'Cast':{'slot':0,'target':None}});last_action[(i,'q')]=now\n    "+needle)
s=s.replace("if destroyed and png.exists() and png.stat().st_size>10000:break","if destroyed and png.exists() and png.stat().st_size>10000 and probe.exists():\n    samples=[json.loads(line) for line in probe.read_text(encoding='utf-8').splitlines()]\n    if any(a['id']==target and a['role']=='death' and any(c['elapsed']>2 for c in a['active_clips']) for row in samples for a in row['actors']):break")
s=s.replace('Only ordinary Join/Buy/Learn/Move/Attack/Heal packets used','Only ordinary Join/Buy/Learn/Move/Attack/CastQ/Heal packets used')
exec(compile(s,'normal-structure-combat-q','exec'))
