from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '128 passed; 0 failed' in (r/'logs/native-actor-metrics-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-actor-metrics-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_actor_metrics_contract.json');assert proof['passed'] and len(proof['cases'])==72
receipt=dict(updated_utc=now,complete=False,client_tests_passed=128,client_build_passed=True,native_actor_metric_cases=72,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original617970 initializes raw actor37C/380/384 from CharacterData610/60C/614. Original614E40 geometry fallback executes for72cases; missing CharacterData preserves existing state without notification.','Rust preserves raw source metrics separately from resolved model height/radius, native sentinel-derived secondary metric and radius warning conditions. Native6198F0 source update consumes raw37C/384, not resolved actor4C.','Full128client tests and build passed; resource-field readers, model bounds loading and motion update remain open before ordinary source activation.'],
 limits=proof['limits']+['Only supplied finite model bounds/scales qualified here; arbitrary extreme x87 rounding modes/inputs not proven by these72cases.','Final callback/warning consumers adapted; source metrics module is not yet connected to actual CharacterData loader.','Prior127-client Vulkan startup capture remains historical evidence; no current128-client graphical rerun or live source/mask GPU binding claimed.'],
 next_actions=['Qualify CharacterData60C/610/614/618 resource names, defaults and reader producers; derive actual entity metrics from supplied assets.','Qualify motion height provider6061E0 and model bounds/scaling producers, then activate normal gameplay sources on registered Map10 view.','Bind vision masks to authoritative visibility and GPU, verify current gameplay and continue all completion-plan domains.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_actor_metrics_contract.json','tools/probe_fow_actor_metrics.py','crates/client/src/fow_actor_metrics.rs','logs/native-actor-metrics-tests.log','logs/native-actor-metrics-build.log','target/debug/openleague-client.exe']})
save('docs/native_actor_metrics_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_actor_metrics_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=128;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=128,current_test_receipt='docs/native_actor_metrics_progress.json',current_build_receipt='docs/native_actor_metrics_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False,map10_startup_view_runtime_verified=False,current_startup_render_receipt='docs/map10_view_startup_capture.json')
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — initialisation des dimensions des unités</h2><p>128 tests client et compilation réussis.72cas originaux qualifient les dimensions brutes et les valeurs calculées depuis les bornes du modèle. Chargement des champs depuis les ressources, mouvement, sources en partie et GPU restent ouverts.</p><a href="native_actor_metrics_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('127 tests réussis','128 tests réussis');p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_actor_metrics.py',r/'tools/record_actor_metrics.py')
print(json.dumps(dict(client_tests=128,native_actor_cases=72,complete=False)))
