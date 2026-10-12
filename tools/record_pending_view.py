from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '109 passed; 0 failed' in (r/'logs/native-pending-view-tests.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_pending_release_contract.json');assert proof['passed'] and len(proof['cases'])==192
assert all(step['final_weak_count']==0 and step['control_deallocation_requested'] for c in proof['cases'] for step in c['steps'])
files=['data/4.20/fow_pending_release_contract.json','tools/probe_fow_pending_release.py','tools/probe_fow_pending_release_generated.py','tools/probe_fow_multi_source_release.py','crates/client/src/fow_pending.rs','crates/client/src/fow_source_factory.rs','crates/client/src/main.rs','logs/native-pending-source-tests.log','logs/native-pending-view-tests.log']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=109,native_sequences=192,native_removals=576,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,findings=['Original pending heap insertion6BBFB0, pop adjustment6BD740 and full view callback6B4860 execute across192sequences/576removals, including duplicates, absent identities, equal priorities, NaN, signed zeros and infinity.','Pending entries are raw source identities plus opaque32bit float priorities. Native removal drains the heap, drops every matching identity, then reinserts retained entries; repeated observer callbacks can reorder tied priorities.','Rust PendingSources and CircleView integration match initial and per-removal heap identities/priority bits, visibility counts/pixels, manager compaction, callback applied flags and reference expiration.','Final native weak-control release requests deallocation after all576removals; allocator/free/mutex boundaries explicitly adapted.'],limits=proof['limits']+['Source priority producers, enqueue scheduling, complete view initialization/registration, multiple distinct views and concurrency remain unknown.','CircleView callback is ported and qualified against fixtures; it is not yet driven by ordinary gameplay or bound to GPU fog.','109client tests are current. Earlier427core tests/10UDPchecks are unchanged-core/server evidence. Current delivered executable has not been rebuilt or graphically checked for this change. All24domains remain unfinished.'],next_actions=['Qualify complete native view initialization/subscription and source priority/enqueue producers.','Connect native source creation/update/removal to ordinary entities, authoritative mask filtering and GPU fog; verify the rebuilt gameplay executable.'],files_sha256={p:sha(p) for p in files})
assert 'Finished `dev`' in (r/'logs/native-pending-view-build.log').read_text(encoding='utf-8-sig')
receipt['client_build_passed']=True
receipt['files_sha256']['logs/native-pending-view-build.log']=sha('logs/native-pending-view-build.log')
receipt['files_sha256']['target/debug/openleague-client.exe']=sha('target/debug/openleague-client.exe')
receipt['limits']=[v.replace('Current delivered executable has not been rebuilt or graphically checked for this change.','Current executable rebuilt but not graphically checked for this change.') for v in receipt['limits']]
save('docs/native_pending_view_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_pending_view_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=109;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=109,current_test_receipt='docs/native_pending_view_progress.json',current_build_receipt='docs/native_pending_view_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — file des sources en attente</h2><p>109 tests client réussis.192séquences/576suppressions natives : insertion, vidage et reconstruction du tas, doublons, égalités et valeurs flottantes particulières. Callback Rust unifié : masque puis file. Producteurs de priorité, initialisation complète et activation en partie/GPU restent ouverts.</p><a href="native_pending_view_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_pending_view.py',r/'tools/record_pending_view.py')
print(json.dumps(dict(client_tests=109,sequences=192,removals=576,complete=False)))
