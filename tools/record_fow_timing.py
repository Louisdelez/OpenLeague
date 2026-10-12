from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '80 passed; 0 failed' in (r/'logs/fow-timing-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-timing-build.log').read_text(encoding='utf-8-sig')
paths=['data/4.20/fow_fade_parameters_contract.json','data/4.20/fow_cadence_contract.json','data/4.20/fow_upload_cadence_contract.json','crates/client/src/fow_timing.rs','logs/fow-timing-tests.log','logs/fow-timing-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':80,'client_build_passed':True,'native_fade_parameter_cases':10,'native_fade_cadence_cases':8,'native_upload_gate_cases':8,'live_fow_gpu_bound':False,'current_client_graphical_rerun':False,'findings':['Ported native fade parameters: first frame threshold0, subsequent threshold1.1, reveal2*elapsed and conceal0.5*elapsed; third component0 unused by shader.','Ported strict elapsed>0.0333 gate and native SUBSS/x87 remainder update, matched bitwise including large clock values.','Ported strict elapsed>0.2 gate for fourfold texture uploader; no clock mutation before caller draw/upload.'],'limits':['Clock inputs/guards outside supplied native cases are explicit Rust validation, not original runtime behavior proof.','Full original GPU texture allocation/initialization/formats, transfer failure behavior, ping-pong draws and binding remain open.','Prior 44-case GPU diagnostic remains separate from current client; native visibility source and normal graphical rerun still absent.','All24domains remain unfinished.'],'next_actions':['Qualify native texture formats/allocation/initialization, upload failure behavior and ping-pong stage order.','Qualify production128-cell expansion and native visibility stencil generation.','Resolve Map10 extent/config and connect the true visibility provider with upload, fade, blur and overlay to normal rendering.'],'files_sha256':{p:sha(p) for p in paths}}
save('docs/projected_fow_timing_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_timing_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=80;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=80,current_build_receipt='docs/projected_fow_timing_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — paramètres et rythme</h2><p>80 tests client et compilation réussis. Paramètres du fondu vérifiés sur 10 cas natifs ; cadence et reste de temps sur 8 cas, seuil de transfert sur 8 cas. Initialisation, formats de textures, transferts et liaison à la visibilité réelle restent ouverts.</p><a href="projected_fow_timing_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_timing.py'),r/'tools/record_fow_timing.py')
print(json.dumps({'client_tests':80,'build':True,'live_fow_gpu_bound':False,'complete':False}))
