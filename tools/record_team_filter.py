from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '118 passed; 0 failed' in (r/'logs/native-team-filter-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-team-filter-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_team_filter_contract.json');assert proof['passed'] and len(proof['cases'])==864
assert all(not c['generated'] and not c['before_processing']['pending'] and all(v==c['initial_applied'] for v in c['applied_after']) for c in proof['cases'] if c['source_tag']!=100)
receipt=dict(updated_utc=now,complete=False,client_tests_passed=118,client_build_passed=True,native_team_filter_frames=864,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original6B3FA0 executes864frames crossing source tags100/200/300, registration absent/actor absent/actor present, actor teams100/200/300, actorAD/118 and descriptor24/2C flags, initially applied/unapplied masks. Original actor lookups/getters execute for local sources.','When source tag differs from local player tag and spectator query is false, original6B4175/6B418F skips the source at6B4350. It does not withdraw an applied mask or enqueue an update.576 nonlocal cases establish this preservation, including with invalid/missing actors.','Rust CircleView.select_local_source now returns false for unmatched source tags while retaining their existing masks. Previous local actor gates remain in place.864native comparisons check queue, priority, applied/pending flags and cell counts before/after processing; all118client tests and build passed.'],
 limits=proof['limits']+['Spectator false supplied at five original virtual call sites; spectator true, view initialization and tag mutation producers remain unqualified.','Source tags/masks are supplied and cache generation is adapted for these864frames. Prior128 full Map10 frames with registered actors are separate local-source generation evidence.','No ordinary entity source activation, server/GPU fog binding or current graphical rerun.'],
 next_actions=['Qualify spectator modes and original view initialization/subscriptions.','Qualify registry/actor field producers and connect native source creation, update and retirement to ordinary entities.','Integrate qualified fog masks into authoritative filtering and GPU rendering, then verify restored Map10 gameplay.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_team_filter_contract.json','tools/probe_fow_team_filter.py','tools/probe_fow_team_filter_generated.py','crates/client/src/fow_registered_filter.rs','logs/native-team-filter-tests.log','logs/native-team-filter-build.log','target/debug/openleague-client.exe']})
save('docs/native_team_filter_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_team_filter_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=118;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=118,current_test_receipt='docs/native_team_filter_progress.json',current_build_receipt='docs/native_team_filter_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — sources des autres équipes</h2><p>118 tests client et compilation réussis.864cycles natifs, dont576sources non locales : ignorées sans retirer leur masque préexistant. Spectateur, activation de partie et GPU restent ouverts.</p><a href="native_team_filter_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('117 tests réussis','118 tests réussis').replace('qualifier les filtres des autres équipes et les chemins spectateur, puis la création des vues','qualifier les chemins spectateur et la création des vues')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_team_filter.py',r/'tools/record_team_filter.py')
print(json.dumps(dict(client_tests=118,native_frames=864,complete=False)))
