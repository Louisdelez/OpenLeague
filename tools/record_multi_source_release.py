from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '107 passed; 0 failed' in (r/'logs/native-multi-source-release-tests.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_multi_source_release_contract.json');assert proof['passed'] and len(proof['cases'])==36
assert all(step['final_weak_count']==0 and step['control_deallocation_requested'] for c in proof['cases'] for step in c['steps'])
shutil.copy2('E:/mapslol3v3/probe_fow_multi_source_release.py',r/'tools/probe_fow_multi_source_release.py')
receipt=dict(updated_utc=now,complete=False,client_tests_passed=107,native_sequences=36,native_removals=108,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,findings=['Three original native circular sources removed in all six permutations, with zero, one or two observers of the same view; 36 sequences and108removals. Original creation, mask addition, removal, dispatch, callback, rollback, destruction request and failed weak promotion executed.','Rust comparison matches exact initial/per-step counts and pixels, manager source order, callback applied-state transitions and surviving ownership. Duplicate callbacks withdraw once; retired weak references cannot notify again.'],limits=proof['limits']+['Final weak-control release, pending-source heap, distinct views and complete subscription initialization remain open.','107client tests are current. Earlier427core tests/10UDPchecks are unchanged-core/server evidence. All24domains remain unfinished.'],next_actions=['Qualify pending-source heap removal/reordering, final weak-control release and complete view initialization/subscription.','Qualify real entity source creation and identity/team producers; connect authoritative visibility masks and normal GPU fog rendering; verify current gameplay.'],files_sha256={p:sha(p) for p in ['data/4.20/fow_multi_source_release_contract.json','tools/probe_fow_multi_source_release.py','crates/client/src/fow_source_factory.rs','logs/native-multi-source-release-tests.log']})
receipt['final_weak_releases']=108
assert '1 passed; 0 failed' in (r/'logs/native-multi-source-release-final-weak-tests.log').read_text(encoding='utf-8-sig')
receipt['final_weak_contract_rust_recheck_passed']=True
receipt['files_sha256']['logs/native-multi-source-release-final-weak-tests.log']=sha('logs/native-multi-source-release-final-weak-tests.log')
receipt['findings'].append('Original weak destructor585AA0 reduces retained weak count1 to0, then control deleter5D5B40 requests deallocation in all108removals; allocator boundary adapted, emulator memory retained.')
receipt['limits']=[v.replace('Final weak-control release, pending-source heap, distinct views','Pending-source heap, distinct views') for v in receipt['limits']]
receipt['next_actions'][0]='Qualify pending-source heap removal/reordering and complete view initialization/subscription.'
save('docs/native_multi_source_release_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_multi_source_release_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=107;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=107,current_test_receipt='docs/native_multi_source_release_progress.json',projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — plusieurs sources et abonnés</h2><p>107 tests client réussis.36séquences/108suppressions natives et comparaison Rust : compteurs, pixels, ordre des sources restantes, expiration et retrait unique malgré plusieurs callbacks. Initialisation complète, file des sources et intégration de partie/GPU restent ouvertes.</p><a href="native_multi_source_release_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_multi_source_release.py',r/'tools/record_multi_source_release.py')
print(json.dumps(dict(client_tests=107,sequences=36,removals=108,complete=False)))
