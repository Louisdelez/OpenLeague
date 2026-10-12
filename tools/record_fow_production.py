from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '82 passed; 0 failed' in (r/'logs/fow-production-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-production-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_upscale_production_contract.json');assert len(proof['cases'])==4
missing=load('data/4.20/fow_missing_upload_contract.json');assert len(missing['cases'])==16
files=['data/4.20/fow_upscale_production_contract.json','data/4.20/fow_missing_upload_contract.json','crates/client/src/fow_upscale.rs','crates/client/src/fow_timing.rs','tools/probe_fow_upscale_production.py','tools/probe_fow_missing_upload.py','logs/fow-production-tests.log','logs/fow-production-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':82,'client_build_passed':True,'native128_expansion_cases':4,'native_missing_upload_cases':16,'native128_instruction_addresses':proof['original_instruction_addresses'],'live_fow_gpu_bound':False,'current_client_graphical_rerun':False,'findings':['Native128-cell expansion to512-pixel texture matches every byte in Rust for zero/full/alternating-column/alternating-row patterns, with padded pitch519.','Missing texture keeps timestamp in both uploaders; missing interface keeps timestamp in native unscaled uploader but advances it in fourfold uploader when due.','Explicitly ported this difference; no generic success-on-failure policy is substituted.'],'limits':['Source patterns and previous buffer bytes90 are controlled prerequisites; raw texture initial contents are still unqualified.','Actual LockRect failure with valid interface and successful GPU transfer remain unqualified.','Native visibility source geometry/rasterization and Map10 providers remain open; live FOW is not bound.','Previous96-stage GPU diagnostic does not qualify current ordinary client rendering or whole-game completion.'],'next_actions':['Recover native source shape predicates and radius virtual methods used by6B14E0; port generation of region bitmasks from real source positions.','Qualify raw texture initialization and valid-interface lock/upload outcomes.','Resolve Map10 extent/config and integrate actual visibility, native expansion/timing and quantized GPU stages; qualify ordinary client rendering.'],'files_sha256':{p:sha(p) for p in files}}
save('docs/projected_fow_production_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_production_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=82;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=82,current_build_receipt='docs/projected_fow_production_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — taille native et reprise</h2><p>82 tests client et compilation réussis. Quatre comparaisons natives de textures 512 pixels issues de128cellules, octet par octet ;16cas de reprise sans interface GPU. Génération des zones de vision, initialisation et liaison au rendu ordinaire restent ouvertes.</p><a href="projected_fow_production_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_production.py'),r/'tools/record_fow_production.py')
print(json.dumps({'client_tests':82,'native128_cases':4,'missing_interface_cases':16,'live_fow_bound':False,'complete':False}))
