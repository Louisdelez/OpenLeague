from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '124 passed; 0 failed' in (r/'logs/native-event-creation-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-event-creation-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_event_creation_contract.json');assert proof['passed'] and len(proof['cases'])==2
assert all(c['event_count']==1 and c['subscriber_count']==1 and c['callbacks']==1 and c['counts_zero_after_removal'] for c in proof['cases'])
receipt=dict(updated_utc=now,complete=False,client_tests_passed=124,client_build_passed=True,native_event_creations_and_callbacks=2,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original6B3B80/66D460 constructs/registers a view on an empty supplied dispatcher sentinel. Original66CA40/66C970/66D240 create the event object/control and first subscriber storage; original tree insertion changes event count0->1. No precreated event/list/control supplied.','InitializeCriticalSection import identified through PE import table atFA41A0. Original call site66D282 is explicitly adapted to supplied24-byte critical-section storage. Other original event, registry, buffer and subscriber construction logic executes.','Source retirement invokes the newly created event/subscriber and native view callback, retiring counts/pixels. Rust ViewRegistry tracks lazy typed retirement-event creation separately from its subscriber slots. Native constructor/event/callback comparison and full124client tests pass; build passed.'],
 limits=proof['limits']+['Rust ports typed retirement event presence and dispatch semantics; native red-black map layout and generic unrelated event types are not reimplemented.','Only first subscriber/list growth and one event key qualified here. Repeated subscriptions, list expansion, ordering and concurrent delivery remain open. Mutex adaptation qualifies this single-thread probe only.','No ordinary source/view activation, live server/GPU fog binding or current graphical rerun.'],
 next_actions=['Qualify repeated subscriptions/list growth and pending-source view destruction.','Qualify extent/camera/configuration and entity field producers; activate native source/view lifecycle in ordinary gameplay.','Bind qualified masks to authoritative filtering and GPU rendering and verify current restored Map10 gameplay.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_event_creation_contract.json','tools/probe_fow_event_creation.py','tools/probe_fow_event_creation_generated.py','crates/client/src/fow_view_registry.rs','logs/native-event-creation-tests.log','logs/native-event-creation-build.log','target/debug/openleague-client.exe']})
save('docs/native_event_creation_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_event_creation_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=124;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=124,current_test_receipt='docs/native_event_creation_progress.json',current_build_receipt='docs/native_event_creation_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — création native de l’événement</h2><p>124 tests client et compilation réussis.2séquences depuis un répartiteur vide : création de l’événement, premier abonnement et callback de retrait. Appel Windows de synchronisation adapté explicitement ; listes multiples et activation réelle restent ouvertes.</p><a href="native_event_creation_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('123 tests réussis','124 tests réussis').replace('qualifier la création des événements, les listes d’abonnements et la destruction avec sources en attente, puis l’activation des vues','qualifier l’extension des listes d’abonnements et la destruction avec sources en attente, puis l’activation des vues')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_event_creation.py',r/'tools/record_event_creation.py')
print(json.dumps(dict(client_tests=124,native_event_cases=2,complete=False)))
