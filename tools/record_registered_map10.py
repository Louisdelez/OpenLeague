from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '117 passed; 0 failed' in (r/'logs/native-registered-map10-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-registered-map10-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_registered_map10_contract.json');assert proof['passed'] and len(proof['cases'])==32
assert sum(len(c['frames']) for c in proof['cases'])==128
assert all('mask_generation_boundary' not in f['adapters'] for c in proof['cases'] for f in c['frames'])
receipt=dict(updated_utc=now,complete=False,client_tests_passed=117,client_build_passed=True,native_sequences=32,native_frames=128,native_addresses=proof['native_addresses'],native_source_queries=sum(len(f['source_queries']) for c in proof['cases'] for f in c['frames']),live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original6B3FA0 complete Map10 frames execute two-stage identity/handle lookup, registered actor flags and team getters, original circle generation6B14E0, terrain query8F3390, fan/rays, native counters and heap scheduling. No lookup or mask generation adapters.','32 sequences/128 frames cover actor-present/absent, radius200/800, force/non-force, applied/unapplied, slow/fast frame budgets; changing flags remove/re-enable actors, change a neutral actor to team100 and exclude a third actor. Sources also move and change radius.100 source queries executed.','Rust CircleView.enqueue_local_source joins resolution/filter/withdrawal with scheduling in native order. Full frame comparison checks all128x128 counters and pixels,512 mask words per source, bounds, dirty/applied/pending flags, priorities, source query count and generated order. All117client tests and build passed.'],
 limits=proof['limits']+['Actor/descriptor flag and team producers, registry insertion/resize/lifetime and constructors are supplied rather than executed. Only source tag100 and non-spectator local filtering is qualified.','The new joined source pass is not yet called by ordinary gameplay entities; native view registration/camera/extent initialization and authoritative/GPU fog integration remain incomplete. Current executable has no graphical rerun.'],
 next_actions=['Qualify other-team/spectator view filtering and actual view initialization/subscriptions.','Qualify registry/actor field producers and connect native source creation, updates and retirement to ordinary gameplay entities.','Integrate native fog masks with server visibility and GPU rendering; verify the current restored Map10 and gameplay executable.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_registered_map10_contract.json','tools/probe_fow_registered_map10.py','tools/probe_fow_registered_map10_generated.py','crates/client/src/fow_registered_filter.rs','crates/client/src/fow_source_factory.rs','logs/native-registered-map10-tests.log','logs/native-registered-map10-build.log','target/debug/openleague-client.exe']})
save('docs/native_registered_map10_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_registered_map10_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=117;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=117,current_test_receipt='docs/native_registered_map10_progress.json',current_build_receipt='docs/native_registered_map10_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — cycles complets Map10 avec unités enregistrées</h2><p>117 tests client et compilation réussis.32séquences/128cycles natifs,100requêtes de terrain, filtres et masques complets comparés. Entrée Rust regroupant sélection et planification ; intégration de partie et GPU encore ouverte.</p><a href="native_registered_map10_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('116 tests réussis','117 tests réussis').replace('qualifier les filtres avec unités enregistrées dans les cycles complets Map10 et les chemins spectateur','qualifier les filtres des autres équipes et les chemins spectateur, puis la création des vues')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_registered_map10.py',r/'tools/record_registered_map10.py')
print(json.dumps(dict(client_tests=117,native_frames=128,complete=False)))
