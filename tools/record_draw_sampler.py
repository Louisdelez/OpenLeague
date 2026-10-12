from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
for name in ['inspect_projected_fow.py','probe_projected_draw_sampler.py','record_draw_sampler.py']:shutil.copy2(w/name,r/'tools'/name)
p=json.loads((r/'data/4.20/projected_draw_sampler_contract.json').read_text());assert p['passed']
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 f=r/'docs'/name;d=json.loads(f.read_text(encoding='utf-8'));d['updated_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();d['projected_draw_sampler_progress']={'receipt':'data/4.20/projected_draw_sampler_contract.json','original_instruction_addresses':p['original_instruction_addresses'],'cases':len(p['cases']),'complete':False,'finding':'Per-draw stage0 clamp and mipNONE; post-draw restores all16filters and stage0wrap. FOW remains separate and incomplete.'}
 if name=='resume_checkpoint.json':d['next_projected_action']='Trace receiver95BFF0/957160 and native shader FOW texture/coordinates;92DDF0 is sampler setup, not FOW binding. Exact owner and full24domains remain open.'
 f.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Native per-draw/restoration evidence recorded; FOW binding still open.')
