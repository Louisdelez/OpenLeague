from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '97 passed; 0 failed' in (r/'logs/native-position-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-position-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_position_contract.json');assert proof['passed'] and len(proof['cases'])==48
files=['data/4.20/fow_position_contract.json','tools/probe_fow_position.py','crates/client/src/fow_position.rs','crates/client/src/main.rs','logs/native-position-tests.log','logs/native-position-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=97,client_build_passed=True,native_position_cases=48,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Executed original6B1860 with original owner resolver, virtual self/shared-reference getters and circle no-op refresh;48cases and160native addresses without adapters.','Ported primary X/Z position refresh with nativeepsilon, shared parameter dirty flag and invalid-owner clearing/lifetime34000000.','Generation mismatch alone does not invalidate this position method, unlike previously qualified modifier resolution.'],
 limits=proof['limits']+['Primary refresh is qualified only when the secondary shared-position provider is absent; non-null provider and its position getter remain open.','Registry/source state is supplied in comparisons; ordinary gameplay source lifecycle and GPU fog binding remain unimplemented.','97client tests and build are current;427core tests and10UDPchecks remain prior unchanged-core/server evidence.','All24domains remain unfinished.'],
 next_actions=['Qualify the non-null secondary position object and native pose getter, source team/creation/activation and lifetime consumption/destruction.','Connect qualified position and parameter updates to actual Rust source identities, with native field producers and buff aggregation.','Qualify world extent and terrain initialization; reconcile fog masks with authoritative visibility and bind GPU fog to ordinary rendering.'],files_sha256={p:sha(p) for p in files})
save('docs/native_fow_position_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_fow_position_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=97;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=97,current_build_receipt='docs/native_fow_position_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — position propriétaire</h2><p>97 tests client et compilation réussis.48cas natifs pour position X/Z, tolérance, référence absente et durée restante. Fournisseur de position secondaire, équipe, création, suppression et branchement au rendu ordinaire restent ouverts.</p><a href="native_fow_position_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_position.py'),r/'tools/record_fow_position.py')
print(json.dumps(dict(client_tests=97,native_position_cases=48,complete=False)))
