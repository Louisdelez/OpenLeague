from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '123 passed; 0 failed' in (r/'logs/native-view-destruction-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-view-destruction-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_view_destruction_contract.json');assert proof['passed'] and len(proof['cases'])==4
assert all(c['callbacks']==0 and c['subscriber_count_after']==0 and c['self_control_strong_after']==0 and c['self_control_weak_after']==1 for c in proof['cases'] if c['destroy_first'])
receipt=dict(updated_utc=now,complete=False,client_tests_passed=123,client_build_passed=True,native_view_lifecycle_cases=4,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original view construction/registration and source creation execute for four cases: two extents, with view alive or destroyed before source retirement.','Original6B3D70 requests release of pixel/count/scratch buffers and self-wrapper. Its shared control becomes strong0/weak1 while the event slot initially remains. Later original source dispatch skips the expired view and erases its subscription: zero callbacks and zero event slots. Live views instead receive one callback and retire counts/pixels.','Rust ViewRegistry now removes expired weak subscriptions during dispatch, retaining live-view order; dropping the last view owner expires its reference. Retirement report preserves whether an applied region remained when no view callback ran. Native lifecycle comparison and full123client tests pass; build passed.'],
 limits=proof['limits']+['Deallocation adapter records free requests without unmapping memory. Buffer contents after destruction are stale storage; zero/nonzero bytes there are not live fog output.','Only one constructed subscriber and empty pending view heap qualified in these lifecycle cases. Destroying a view with pending sources, absent-event creation, multiple subscriptions/order and concurrent dispatch remain open.','No ordinary source/view activation, server/GPU fog binding or current graphical rerun.'],
 next_actions=['Qualify absent-event creation and callback-list growth, then pending-source view destruction and multiple subscriptions.','Qualify extent/camera/configuration and entity field producers; activate native source/view lifecycle in ordinary gameplay.','Bind qualified masks to authoritative visibility and GPU rendering and verify current restored Map10 gameplay.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_view_destruction_contract.json','tools/probe_fow_view_destruction.py','tools/probe_fow_view_destruction_generated.py','crates/client/src/fow_view_registry.rs','logs/native-view-destruction-tests.log','logs/native-view-destruction-build.log','target/debug/openleague-client.exe']})
save('docs/native_view_destruction_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_view_destruction_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=123;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=123,current_test_receipt='docs/native_view_destruction_progress.json',current_build_receipt='docs/native_view_destruction_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — destruction et expiration des vues</h2><p>123 tests client et compilation réussis.4séquences natives : vue active ou détruite, callback ignoré et abonnement expiré supprimé au dispatch. Création des événements, listes multiples et activation réelle restent ouvertes.</p><a href="native_view_destruction_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('122 tests réussis','123 tests réussis').replace('qualifier la destruction des vues, l’expiration des références et la création des événements, puis l’activation des vues','qualifier la création des événements, les listes d’abonnements et la destruction avec sources en attente, puis l’activation des vues')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_view_destruction.py',r/'tools/record_view_destruction.py')
print(json.dumps(dict(client_tests=123,native_lifecycle_cases=4,complete=False)))
