from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert '67 passed; 0 failed' in (r/'logs/projected-baseline-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/projected-baseline-build.log').read_text(encoding='utf-8-sig')
p=json.loads((r/'data/4.20/projected_baseline_contract.json').read_text())
assert p['passed'] and p['final_state']['25']==7 and p['final_state']['23']==4
paths=['data/4.20/projected_baseline_contract.json','tools/probe_native_projected_baseline.py','crates/client/src/particle_render_state.rs','crates/client/src/projected_render.rs','assets/shaders/projected_terrain.wgsl','logs/projected-baseline-tests.log','logs/projected-baseline-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':67,'native_instruction_addresses':p['original_instruction_addresses'],'current_build_gpu_rerun':False,'last_gpu_capture':'docs/projected_normal_capture_v4.json','findings':['Original reset loop and manager/material helpers confirm baseline depth LESS_EQUAL with depth write disabled, cull NONE and inherited alpha ADD.','Production material now uses verified baseline helpers; reverse-Z compare GreaterEqual preserves the existing Bevy depth behavior.','Original alpha test is GREATEREQUAL at reference0, not GREATER: no transparent-texel discard introduced.','67 client tests and compilation passed; baseline refactor preserves pipeline values, so previous Vulkan evidence retains its original executable hash.'],'limits':['Only baseline state sequence executed, not full interleaved world renderer or later material/skin mutations.','Native GPU API and stack cookie are adapted in the native instruction probe.','Exact owner provider, FOW texture/coordinates, receiver coverage, other alpha references and visual fidelity remain incomplete.'],'enum_source':'https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dcmpfunc','files_sha256':{str(p):sha(r/p) for p in paths}}
(r/'docs/projected_baseline_progress.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 f=r/'docs'/name;shutil.copy2(f,backup/name);d=json.loads(f.read_text(encoding='utf-8-sig'));d['updated_utc']=now;d['projected_baseline_progress']=receipt
 if name=='resume_checkpoint.json':d['last_verified']['client_tests']=67;d['next_projected_action']='Qualify native projected FOW texture/coordinate binding and exact owner provider; preserve full24domain scope.'
 else:
  d['current_evidence']['client_tests_passed']=67;d['current_evidence']['current_build_receipt']='docs/projected_baseline_progress.json';d['current_evidence']['current_client_sha256']=sha(r/'target/debug/openleague-client.exe');d['current_evidence']['projected_current_binary_vulkan_verified']=False
 f.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
f=r/'docs/completion_plan.html';shutil.copy2(f,backup/f.name);s=f.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projection — états natifs de base</h2><p>67 tests et compilation réussis. Profondeur, absence de culling et addition alpha reliées au reset et aux helpers natifs. Le test alpha accepte zéro. Le brouillard, le propriétaire et les mutations ultérieures restent ouverts. Aucun domaine complet.</p><p><a href="projected_baseline_progress.json">Preuves et limites</a></p></section></body>');f.write_text(s,encoding='utf-8')
for name in ['install_projected_baseline.py','record_projected_baseline.py']:shutil.copy2(w/name,r/'tools'/name)
print(json.dumps({'tests':67,'build':'passed','baseline_native_addresses':p['original_instruction_addresses'],'game_complete':False}))
