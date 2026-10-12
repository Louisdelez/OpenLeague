from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '87 passed; 0 failed' in (r/'logs/fow-ray-clip-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-ray-clip-build.log').read_text(encoding='utf-8-sig')
clip=load('data/4.20/fow_ray_clip_contract.json');terrain=load('data/4.20/fow_terrain_ray_contract.json');assert len(clip['cases'])==40 and len(terrain['cases'])==48
shutil.copy2(Path('E:/mapslol3v3/probe_fow_terrain_ray.py'),r/'tools/probe_fow_terrain_ray.py')
paths=['data/4.20/fow_ray_clip_contract.json','data/4.20/fow_terrain_ray_contract.json','crates/client/src/fow_ray_clip.rs','tools/probe_fow_ray_clip.py','tools/probe_fow_terrain_ray.py','logs/fow-ray-clip-tests.log','logs/fow-ray-clip-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':87,'client_build_passed':True,'native_ray_clip_cases':40,'native_terrain_ray_cases':48,'native_clip_addresses':clip['original_instruction_addresses'],'native_terrain_addresses':terrain['original_instruction_addresses'],'live_fow_gpu_bound':False,'current_client_graphical_rerun':False,'findings':['Original6B0DB0 ray clipping ported preserving sequential branch arithmetic, min1/maxN-1 boundaries and epsilon0.01; all recorded origin/delta bits match.','Original6B09E0 terrain traversal and actual circle predicate executed without adapters over48diagnostic flag-column configurations; output mask words archived.','Native terrain traversal uses packed56byte cells, flag word at+0x32 and oversampling2.5; these observations are not yet a qualified Map10 loader or a Rust traversal port.'],'limits':clip['limits']+terrain['limits']+['Ray clipping proof explicitly intercepts terrain boundary6B09E0; separate traversal proof executes that routine without interception.','Current graphical client not rerun; real FOW remains unbound.','Source-flag brush interpretation and terrain height/origin providers still require qualification.'],'next_actions':['Port native terrain traversal6B09E0 against48recorded masks, preserving opaque flags and arithmetic order.','Qualify radial fan6B1140 and original Map10 packed56byte terrain loader; recover source-flag/height providers.','Connect actual source collection and lifecycle to raw visibility, upload/fade/blur/overlay and qualify normal gameplay rendering.'],'files_sha256':{p:sha(p) for p in paths}}
save('docs/projected_fow_ray_clip_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_ray_clip_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=87;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=87,current_build_receipt='docs/projected_fow_ray_clip_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — découpe et parcours des rayons</h2><p>87 tests client et compilation réussis.40découpes de rayons portées et comparées bit par bit.48parcours natifs du terrain exécutés sur grille de test ; leur port Rust et leur liaison à Map10 restent ouverts. Aucun brouillard réel validé en partie.</p><a href="projected_fow_ray_clip_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_ray_clip.py'),r/'tools/record_fow_ray_clip.py')
print(json.dumps({'client_tests':87,'clip_cases':40,'native_traversal_cases':48,'live_fow_bound':False,'complete':False}))
