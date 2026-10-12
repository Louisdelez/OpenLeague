from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '102 passed; 0 failed' in (r/'logs/native-retirement-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-retirement-build.log').read_text(encoding='utf-8-sig')
retirement=load('data/4.20/fow_source_retirement_contract.json');counted=load('data/4.20/fow_map10_counted_lifecycle_contract.json')
assert retirement['passed'] and len(retirement['cases'])==72 and counted['passed'] and len(counted['cases'])==6
assert counted['mask_proof_sha256']==sha(counted['mask_proof'])
constructor=load('data/4.20/fow_source_constructor_contract.json');assert constructor['passed'] and len(constructor['cases'])==24
files=['data/4.20/fow_source_retirement_contract.json','data/4.20/fow_map10_counted_lifecycle_contract.json','data/4.20/fow_map10_owned_contract.json','data/4.20/fow_owner_contract.json','data/4.20/fow_source_constructor_contract.json','tools/probe_fow_source_constructor.py','tools/probe_fow_source_retirement.py','tools/probe_fow_map10_counted_lifecycle.py','crates/client/src/fow_regions.rs','crates/client/src/fow_shapes.rs','crates/client/src/fow_owner.rs','crates/client/src/fow_occluded.rs','logs/native-retirement-tests.log','logs/native-retirement-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=102,client_build_passed=True,native_retirement_cases=72,native_map10_counted_sequences=6,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Executed original source retirement6B3EF0 and region removal6B2E60 twice per case in72cases without adapters; applied flag clears, repeated retire is inert, overlap counts remain visible and unselected rectangle pixels refresh.','Fixed Rust remove_from to clear the applied flag; renamed StencilRegion.dirty to applied, distinct from source generation_dirty. Added native retirement guard.','CountedLayer stores applied masks by source key, replaces old contribution before adding new mask, retires once and preserves overlapping sources. Six Map10 sequences match original add/remove counts and vertically flipped pixels at every step.','Corrected owner/reference field name generation to owner_tag: native comparison is actor+18 versus source+30. Static source selection at6B4165 and6B43AD compares the latter with local actor+18 and100/200; this suggests a team tag, not an identity-generation counter. Existing720resolver and24Map10owned comparisons still pass. Historical proof mode names generation_mismatch are retained as original labels, not current semantic claims.'],
 limits=retirement['limits']+counted['limits']+['CountedLayer is not yet driven by ordinary source creation/team selection/scheduling; raw native tag and flag producers, removal queue and final destruction remain unqualified.','102client tests and build are current;427core tests and10UDPchecks remain prior unchanged-core/server evidence. Current graphical client and fog GPU binding remain unverified.','All24domains remain unfinished.'],
 next_actions=['Port base source initialization from the24executed native constructor cases; qualify derived circle/cone constructors, creation callers, non-null weak provider, team tag and actor field producers. Reconcile Rust owner identity/team mapping with actor+18/source+30 rather than treating it as a generation.','Qualify removal queue and count-update scheduling, then connect actual source lifecycle/position/parameter changes to CountedLayer.','Qualify world extent and terrain initialization; connect counted native fog to authoritative filtering and ordinary GPU rendering, then verify real gameplay.'],files_sha256={p:sha(p) for p in files})
receipt['native_base_constructor_cases']=24
receipt['base_constructor_rust_port_complete']=False
receipt['findings'].append('Executed complete native base constructor6B0790 in24cases without adapters, with null weak provider and supplied cached owner. Source starts unapplied with generation invalidation set; radius, metrics, lifetime, tags and owner handle are initialized. Rust constructor port and derived creation paths remain open.')
receipt['limits']+=constructor['limits']
save('docs/native_counted_fow_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_counted_fow_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=102;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=102,current_build_receipt='docs/native_counted_fow_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — retrait et compteurs de sources</h2><p>102 tests client et compilation réussis.72scénarios natifs de retrait répété et six séquences Map10 de chevauchement/remplacement/suppression. Drapeau appliqué corrigé ; tag propriétaire renommé sans supposer un compteur de génération. Sources de partie, sélection par équipe, suppression complète et rendu ordinaire restent ouverts.</p><a href="native_counted_fow_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_counted_fow_layer.py'),r/'tools/record_counted_fow_layer.py')
print(json.dumps(dict(client_tests=102,retirement_cases=72,map10_sequences=6,complete=False)))
