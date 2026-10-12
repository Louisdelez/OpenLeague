from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '125 passed; 0 failed' in (r/'logs/native-multiple-views-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-multiple-views-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_multiple_views_contract.json');assert proof['passed'] and len(proof['cases'])==34
assert all(c['callback_order']==[i for i in range(c['view_count']) if not c['expired_mask']&(1<<i)] and not any(c['pending_counts_after']) for c in proof['cases'])
receipt=dict(updated_utc=now,complete=False,client_tests_passed=125,client_build_passed=True,native_multiple_view_sequences=34,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original empty-event insertion,2/3/6view constructors and subscriber vector growth/relocation execute in34cases, with mixed expired views and one-entry/empty pending queues.','Source dispatch erases expired subscribers while keeping callback registration order. Every live constructed view receives its original6B4860 callback and removes the pending source identity. Destroyed views request pending storage deallocation and retain no pending vector entries. Event count remains1 even when every subscriber expires.','Rust ViewRegistry event retention, expiration pruning, callback entry order and pending cleanup match native sequences. An optional callback-entry observer supports ordering comparison without retaining extra views.125client tests and build passed.'],
 limits=proof['limits']+['Pending queue storage supplied preallocated; original source heap insertion/removal executes, but queue capacity growth is not qualified here. Empty/pending heap destruction tested; arbitrary multi-source queue destruction and allocation failures remain open.','No source stencil applied across distinct views in these cases. Cross-view vision count ownership must not be inferred from subscriber-order qualification.','Only one event type/key, single-thread synchronization adapters and no gameplay activation/server/GPU fog binding or graphical rerun.'],
 next_actions=['Qualify the actual view creation caller and its extent/camera/configuration inputs, and remaining pending queue/lifetime boundaries.','Qualify entity field/registry producers and activate native source/view lifecycle on ordinary gameplay entities.','Bind qualified masks to authoritative visibility and GPU rendering and verify current restored Map10 gameplay.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_multiple_views_contract.json','tools/probe_fow_multiple_views.py','crates/client/src/fow_view_registry.rs','logs/native-multiple-views-tests.log','logs/native-multiple-views-build.log','target/debug/openleague-client.exe']})
save('docs/native_multiple_views_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_multiple_views_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=125;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=125,current_test_receipt='docs/native_multiple_views_progress.json',current_build_receipt='docs/native_multiple_views_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — listes multiples et sources en attente</h2><p>125 tests client et compilation réussis.34séquences natives avec2/3/6vues : croissance des listes, ordre, expiration et nettoyage des sources en attente. Producteurs de création, activation réelle et GPU restent ouverts.</p><a href="native_multiple_views_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('124 tests réussis','125 tests réussis').replace('qualifier l’extension des listes d’abonnements et la destruction avec sources en attente, puis l’activation des vues','qualifier l’appelant réel de création des vues et ses entrées, puis l’activation des vues et sources')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_multiple_views.py',r/'tools/record_multiple_views.py')
print(json.dumps(dict(client_tests=125,native_sequences=34,complete=False)))
