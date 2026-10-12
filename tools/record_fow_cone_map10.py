from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '92 passed; 0 failed' in (r/'logs/fow-cone-map10-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-cone-map10-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_map10_cone_contract.json');assert len(proof['cases'])==96
assert hashlib.sha256(Path(proof['terrain']['source']).read_bytes()).hexdigest()==proof['terrain']['sha256']
files=['data/4.20/fow_map10_cone_contract.json','crates/client/src/fow_occluded.rs','crates/client/src/fow_shapes.rs','tools/probe_fow_map10_cone.py','logs/fow-cone-map10-tests.log','logs/fow-cone-map10-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=92,client_build_passed=True,native_map10_occluded_cone_masks=96,original_instruction_addresses=proof['original_instruction_addresses'],terrain=proof['terrain'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Shared original circle/occluded-cone composition with exact native approximate angular predicate, radial fan, clipping and terrain traversal.','Rust matches96full original cone masks on actual Map10 cells and nonzero origins, including four terrain corners, cardinal/diagonal directions and two angular thresholds.','Source flags computed through qualified Rust provider; native comparison executes actual query. Counters and flipped texture pixels checked for every output mask.','Owner scale/bias reader6B17E0 inspected: owner resolution717D10, pointer equality to source+34, generation field owner+18 versus source+30, owner virtual70 followed by returned object virtual120. Those actual providers are not yet qualified.'],
 limits=[v.replace('actor providers, cones, lifecycle','actor providers, lifecycle') for v in proof['limits']]+['Cone directions and thresholds are supplied prerequisites; actual actor/ability configuration providers remain open.','All24game domains unfinished; newly compiled graphical client not rerun.'],
 next_actions=['Trace owner resolver717D10 and virtual70/120 providers used by6B17E0; qualify source scale/bias, metric/radius and world extent against actual native actor configurations.','Trace terrain constructor inverse/half-cell initialization and live source collection/lifecycle before binding source updates.','Integrate counted visibility and native-timed GPU upload/fade/blur/overlays into ordinary client rendering and verify actual gameplay.'],files_sha256={p:sha(p) for p in files})
save('docs/projected_fow_cone_map10_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_cone_map10_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=92;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=92,current_build_receipt='docs/projected_fow_cone_map10_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — cônes avec obstacles sur Map10</h2><p>92 tests client et compilation réussis.96masques de cônes originaux comparés à Rust : directions cardinales/diagonales, deux angles, deux rayons, cellules réelles et quatre coins du terrain. Compteurs et pixels compris. Fournisseurs liés aux acteurs et intégration au rendu réel restent ouverts.</p><a href="projected_fow_cone_map10_progress.json">Preuves et limites actuelles</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_cone_map10.py'),r/'tools/record_fow_cone_map10.py')
print(json.dumps(dict(client_tests=92,native_cone_masks=96,complete=False,live_fow_bound=False)))
