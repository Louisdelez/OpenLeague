from pathlib import Path
import os,json
r=Path('E:/OpenLeague');trace=r/'logs/endgame-timeline-runtime.jsonl';assert not trace.exists()
os.environ['OPENLEAGUE_ENDGAME_PHASE_PROBE']='1'
s=Path('E:/mapslol3v3/verify_results_framebuffer.py').read_text(encoding='utf-8').replace('match-results-visual','native-endgame-timeline').replace('match_results_visual_validation.json','native_endgame_timeline_visual_validation.json');exec(compile(s,'endgame-timeline-runtime','exec'))
rows=[json.loads(line) for line in trace.read_text().splitlines()];assert rows
assert any(row['age']<0.2 and not row['splash_visible'] for row in rows)
assert all(not row['splash_visible'] for row in rows if row['age']<5.5)
visible=[row for row in rows if row['splash_visible']];assert visible and all(row['age']>=5.5 for row in visible)
assert visible[0]['age']<5.85
p=r/'docs/native_endgame_timeline_visual_validation.json';d=json.loads(p.read_text());d.update(runtime_samples=len(rows),first_visible_age=visible[0]['age'],before_deadline_hidden=True,after_deadline_visible=True,probe=str(trace));p.write_text(json.dumps(d,indent=2),encoding='utf-8');print(json.dumps(d))
