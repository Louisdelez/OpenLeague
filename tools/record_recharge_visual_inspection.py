from pathlib import Path
import json,hashlib
from datetime import datetime,timezone
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));write=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
receipt='docs/native_hud_recharge_live_progress.json';d=load(receipt);scope={'full_frames':['cast','ready'],'E_icon_crops':['precast','cast','regenerated','ready'],'observed':'Both backends show native E icon before cast, colored sector and two-segment boundary during recharge, changed boundary during regeneration and original icon restored on expiry. Other twelve-frame content and whole map not fully visually qualified.','human_acceptance':False}
for run in d['runs']:run.update(visual_inspection_pending=False,visual_inspection=scope)
d['visual_inspected_utc']=datetime.now(timezone.utc).isoformat();d['backend_line_coverage_comparison']='logs/native-hud-recharge-line-backend-comparison.json';d['limits'].append('Isolated line raster differs by1..3edge pixels in14/18cases between Vulkan/DX12;4cases identical. Original D3D9 edge equivalence remains open, no cross-backend pixel identity claimed.');write(receipt,d)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p='docs/'+name;d=load(p);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(recharge_live_visual_inspection_pending=False,recharge_live_visual_inspection_scope=scope);write(p,d)
p='docs/native_hud_recharge_line_gpu_progress.json';d=load(p);comparison='logs/native-hud-recharge-line-backend-comparison.json';d.update(backend_comparison=comparison,gallery_inspection='Vulkan and DX12 galleries inspected; two segments and direction sweep visible. Coverage equality not established.');d['artifacts_sha256'][comparison]=hashlib.sha256((r/comparison).read_bytes()).hexdigest();write(p,d)
print('Scoped actual frame inspection and backend edge differences recorded; objective remains incomplete.')
