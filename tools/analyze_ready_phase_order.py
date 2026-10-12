from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');v=sys.argv[1]
d=json.loads((r/f'docs/annie_ready_pause_{v}.json').read_text());ids={q['entity'] for q in d['frozen_samples'][0]['quads']}
frames={x['gpu_frame'] for x in d['gpu_findings']['raw_frames']}
trace=[json.loads(line) for line in (r/f'logs/annie-ready-pause-{v}-pixels.phase.jsonl').read_text().splitlines()]
selected=[]
for row in trace:
 if row['gpu_frame'] not in frames:continue
 views={view['view']:[item for item in view['items'] if item['entity'] in ids] for view in row['views']}
 selected.append({'gpu_frame':row['gpu_frame'],'effect_time_bits':row['effect_time_bits'],'views':views})
assert len(selected)==2 and selected[0]['effect_time_bits']==selected[1]['effect_time_bits']
keys=set(selected[0]['views'])|set(selected[1]['views']);comparisons=[]
for view in sorted(keys):
 a=selected[0]['views'].get(view,[]);b=selected[1]['views'].get(view,[])
 comparisons.append({'view':view,'counts':[len(a),len(b)],'entity_order_equal':[x['entity'] for x in a]==[x['entity'] for x in b],'all_phase_fields_equal':a==b})
assert any(x['counts'][0]>0 for x in comparisons),'trace did not capture selected Ready entities'
result={'complete':False,'version':v,'frames':selected,'comparisons':comparisons,'limits':['Post-render CPU phase records; GPU draw/instance order may require further capture.','No causal conclusion from entity order alone.']}
(r/f'docs/ready_phase_order_{v}.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(comparisons))
