from pathlib import Path
import json,hashlib,datetime,shutil
from collections import Counter
import sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
contract=load('data/4.20/native_world_clear_contract.json');assert contract['passed'] and len(contract['cases'])==128 and contract['map10_expected_clear_rgb']==[34,62,84]
binary=r/'target/debug/openleague-client.exe';old=load('docs/native_nexus_skin_progress.json');assert hashlib.sha256(binary.read_bytes()).hexdigest()==old['files_sha256']['target/debug/openleague-client.exe']
frame=r/'logs/native-nexus-skin.png';im=Image.open(frame).convert('RGB');pixels=Counter(im.crop((900,80,1220,480)).getdata());cyan=pixels[(34,62,84)];assert cyan>0
receipt=dict(updated_utc=now,complete=False,contract='data/4.20/native_world_clear_contract.json',native_clear_cases=128,native_addresses=contract['native_addresses_executed'],map10_clear_rgb=[34,62,84],application_binary_unchanged=True,product_rendering_changed=False,prior_frame=str(frame),prior_frame_sha256=hashlib.sha256(frame.read_bytes()).hexdigest(),prior_frame_crop=[900,80,1220,480],prior_frame_exact_clear_pixels=cyan,findings=contract['findings'],limits=contract['limits']+['Screenshot is prior current-binary diagnostic winner evidence, not a new capture or ordinary six-client match.'])
save('docs/native_world_clear_progress.json',receipt)
archive=r/'docs/plan_history'/('native-world-clear-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
action='Attribuer les pixels de fond visibles de la base Chaos avec la caméra réellement enregistrée : géométrie de fond, visibilité/culling, alpha et composition des passes ; couleur cyan qualifiée par128cas natifs, ne pas la remplacer arbitrairement.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_world_clear_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=action+' '+d.get('next_projected_action',''));d['last_verified']['native_world_clear_cases']=128
 else:
  d['current_evidence'].update(native_world_clear_cases=128,native_world_clear_submission_verified=True,full_native_frame_composition_verified=False,chaos_base_visual_defect_fixed=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+[x for x in d.get('next_execution_steps',[]) if x!=action]
 save(p,d)
p='data/4.20/map_visual_settings.json';d=load(p);d['usage']='Native Map10 RGB retained. Isolated original world clear0x73c6c0/color helper0x987790/backend0x9c2510/D3D wrapper0x9c57e0 qualified128cases. Supplied enabled fog and native opacity1 yield exactRGB34,62,84; original loader linkage/full frame composition remain unqualified.';d['clear_submission_contract']='data/4.20/native_world_clear_contract.json';save(p,d)
for name in ['inspect_native_clear_callers.py','locate_native_clear_world_calls.py','qualify_native_world_clear.py','record_native_world_clear_progress.py']:shutil.copy2(stage/name,r/'tools'/name)
# Copied read-only inspection helpers currently refer to staging imports; preserve those dependencies too.
for name in ['inspect_native_clear_backend.py','inspect_native_clear_globals.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Fond de carte : qualification native</h2><p>128cas exécutés dans le code original : la couleur cyan34,62,84 est cohérente avec le brouillard Map10 et son opacité1. Les zones visibles dans la base Chaos restent à corriger par attribution géométrique et qualification des passes. Aucun changement du rendu ni nouvelle capture.</p><a href="native_world_clear_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(native_clear_cases=128,prior_frame_exact_clear_pixels=cyan,binary_unchanged=True,complete=False)))
