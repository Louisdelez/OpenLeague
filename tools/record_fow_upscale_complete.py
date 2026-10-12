from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '76 passed; 0 failed' in (r/'logs/fow-upscale-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-upscale-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_upscale_complete_contract.json');assert len(proof['cases'])==24 and proof['passed']
files=['data/4.20/fow_upscale_complete_contract.json','crates/client/src/fow_upscale.rs','crates/client/src/fow_upscale_table.rs','tools/probe_fow_upscale_complete.py','logs/fow-upscale-tests.log','logs/fow-upscale-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':76,'client_build_passed':True,'native_complete_expansion_cases':24,'native_instruction_addresses':proof['original_instruction_addresses'],'live_fow_gpu_bound':False,'current_client_graphical_rerun':False,'findings':['Native lookup tiles, four row copies and left/right boundary replication execute without runtime adapters for supplied cases.','Rust expansion matches all native bytes including strict >128 threshold, preserved 2x2 corners and padded pitch bytes.','Buffer/dimension errors are rejected before mutation.'],'limits':['Native cases use dimensions 2,3,8; production dimension128 and texture lock/upload/timing are not yet qualified.','Port preserves native corner history; initial destination allocation contents and first-frame native initialization require qualification.','44 previous isolated GPU fade/blur cases remain separate evidence; live rendering integration and original render-target quantization remain open.','No current graphical client rerun; full game remains incomplete.'],'next_actions':['Qualify dimension128 expansion and destination initialization/texture uploads.','Recover native fade parameter/timing producer and render-target formats.','Resolve Map10 extent/config and stencil providers; bind real visibility textures and postprocessing to normal rendering.'],'files_sha256':{p:sha(p) for p in files}}
save('docs/projected_fow_upscale_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_upscale_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=76;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=76,current_build_receipt='docs/projected_fow_upscale_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — suréchantillonnage natif</h2><p>Port Rust des tuiles et copies de bordures vérifié sur 24 exécutions natives. Seuil 128/129, coins et padding conservés. 76 tests client et compilation réussis. Dimension 128, initialisation, transfert de textures et intégration réelle encore ouverts.</p><a href="projected_fow_upscale_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_upscale_complete.py'),r/'tools/record_fow_upscale_complete.py')
print(json.dumps({'client_tests':76,'native_cases':24,'native_addresses':receipt['native_instruction_addresses'],'live_fow_bound':False,'complete':False}))
