from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '127 passed; 0 failed' in (r/'logs/native-view-caller-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-view-caller-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_view_caller_contract.json');assert proof['passed'] and len(proof['cases'])==24
receipt=dict(updated_utc=now,complete=False,client_tests_passed=127,client_build_passed=True,native_caller_cases=24,native_addresses=proof['native_addresses'],map10_startup_view_implemented=True,map10_startup_view_runtime_verified=False,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original6B3462 caller fragment passes global X extent into original6B3B80 constructor in24cases. Two independently supplied config floats are saved separately and do not change extent. Constructor creates original empty event/subscription and zero mask buffers.','Rust Map10VisionView reads authored SCB geometry and constructs its registered view. Main startup inserts this resource and places restored map from its native extent instead of a duplicated constant.','Full127client tests and build passed. Startup resource and native caller correspondence are unit tested; no current graphical runtime acceptance claimed.'],
 limits=proof['limits']+['Client source/view runtime activation remains partial: startup creates the registered view, but no normal entity source production, authoritative mask binding or GPU fog output is connected to it.','Current executable has not been launched graphically for this change; startup code integration is not runtime or visual acceptance.'],
 next_actions=['Verify actual client startup and restored Map10 placement with the current executable and capture.','Qualify complete resource lookup, configuration/camera producers and native runtime creation callers.','Connect ordinary gameplay sources to registered views, authoritative visibility and GPU rendering; continue all completion-plan domains.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_view_caller_contract.json','tools/probe_fow_view_caller.py','assets/maps/tt_level_size.scb','crates/client/src/map10_vision_view.rs','crates/client/src/main.rs','logs/native-view-caller-tests.log','logs/native-view-caller-build.log','target/debug/openleague-client.exe']})
save('docs/native_view_caller_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_view_caller_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=127;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=127,current_test_receipt='docs/native_view_caller_progress.json',current_build_receipt='docs/native_view_caller_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — appel de création et démarrage Map10</h2><p>127 tests client et compilation réussis.24appels du binaire original confirment le transfert de la dimension native au constructeur. Le client initialise maintenant sa vue depuis le SCB Map10. Vérification du démarrage, sources de jeu et GPU restent ouverts.</p><a href="native_view_caller_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('126 tests réussis','127 tests réussis');p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_view_caller.py',r/'tools/record_view_caller.py')
print(json.dumps(dict(client_tests=127,native_caller_cases=24,complete=False)))
