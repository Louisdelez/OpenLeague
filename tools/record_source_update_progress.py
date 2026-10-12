from pathlib import Path
import json, datetime, hashlib, shutil
r=Path('E:/OpenLeague')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '96 passed; 0 failed' in (r/'logs/native-source-update-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-source-update-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_source_update_contract.json')
assert proof['passed'] and len(proof['cases'])==216 and proof['runtime_adapters']==[]
files=['crates/client/src/fow_source_update.rs','crates/client/src/main.rs','data/4.20/fow_source_update_contract.json','tools/probe_fow_source_update.py','logs/native-source-update-tests.log','logs/native-source-update-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=96,client_build_passed=True,native_source_update_cases=216,map10_source_mask_cases=24,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Ported native6198F0 source parameter updates, missing-character-data fallback100, strict-positive metric overrides, percent/flat modifiers and dirty-state preservation.','All216 original cases compare bit-for-bit, including live, expired and absent references. Original weak-reference acquisition/release retained reference counts; destruction paths remain untested.','Updated source parameters feed existing occluded circle mask composition;24Map10 cases compare to previously executed original generator masks.'],
 limits=proof['limits']+['The new source update is available to mask composition but is not yet called by ordinary gameplay source lifecycle. Actual source creation/team/position/eligibility, actor field producers, full buff aggregation and live GPU binding remain unqualified.','Native probes cover supplied finite values; no complete qualification of nonfinite actor parameter inputs.','Core427tests and10UDPchecks are prior unchanged-core/server results, not newly rerun. Current client96tests and build are fresh; current graphical gameplay remains unverified.','All24domains remain unfinished.'],
 next_actions=['Qualify native source position/team/creation/removal and eligibility; map actual Rust source lifecycle without inventing actor fields.','Qualify actor CharacterData cache, metric field producers and stat/buff application/removal.','Qualify world extent and terrain initialization; reconcile native masks with authoritative server filtering and bind counted fog plus GPU processing into ordinary rendering.'],files_sha256={p:sha(p) for p in files})
save('docs/native_source_update_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_source_update_progress']=receipt
 if name=='resume_checkpoint.json':
  d['saved_utc']=now;d['last_verified']['client_tests']=96;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:
  d['current_evidence'].update(client_tests_passed=96,current_build_receipt='docs/native_source_update_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — paramètres des sources</h2><p>96 tests client et compilation réussis. Portage comparé aux 216 mises à jour natives et aux 24 masques Map10. Position, équipe, création, suppression, activation, producteurs des champs et branchement au rendu ordinaire restent à terminer.</p><a href="native_source_update_progress.json">Preuves et limites actuelles</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_source_update_progress.py'),r/'tools/record_source_update_progress.py')
print(json.dumps(dict(client_tests=96,native_cases=216,map10_masks=24,complete=False)))
