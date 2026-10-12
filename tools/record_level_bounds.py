from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '126 passed; 0 failed' in (r/'logs/native-level-bounds-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-level-bounds-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_level_bounds_contract.json');assert proof['passed'] and len(proof['cases'])==6
receipt=dict(updated_utc=now,complete=False,client_tests_passed=126,client_build_passed=True,native_bounds_cases=6,native_addresses=proof['native_addresses'],map10_view_extent=15398.671875,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original86FA49 bounds arithmetic matches Rust for six inputs, including non-square bounds, negative coordinates, signed zero and float rounding.','Original Map10 __LevelSize_.SCB2.2 header supplies X extent15398.671875. Native view center Y is zero; header maxY is zero while vertex Y is negative. Rust reads authored header rather than recomputing vertex extrema.','Rust view geometry is exercised through registered-view construction. Full126client tests and build passed; ordinary-gameplay caller activation remains open.'],limits=proof['limits'],
 next_actions=['Execute full resource registration/lookup and actual view creation caller; qualify extent, camera and configuration producers.','Activate native source/view lifecycle for ordinary entities, bind masks to authoritative visibility and GPU rendering.','Verify restored Map10 in a current six-client game and continue all completion-plan domains.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_level_bounds_contract.json','tools/probe_fow_level_bounds.py','assets/maps/tt_level_size.scb','crates/client/src/fow_level_bounds.rs','logs/native-level-bounds-tests.log','logs/native-level-bounds-build.log','target/debug/openleague-client.exe']})
save('docs/native_level_bounds_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_level_bounds_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=126;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=126,current_test_receipt='docs/native_level_bounds_progress.json',current_build_receipt='docs/native_level_bounds_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — dimensions natives de Map10</h2><p>126 tests client et compilation réussis. Six calculs de bornes exécutés par le binaire original et comparés au Rust. Étendue Map10 : 15398,671875 unités, issue du fichier SCB original. Chargement complet, activation en partie et liaison GPU restent ouverts.</p><a href="native_level_bounds_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('125 tests réussis','126 tests réussis');p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_level_bounds.py',r/'tools/record_level_bounds.py')
print(json.dumps(dict(client_tests=126,native_bounds_cases=6,complete=False)))
