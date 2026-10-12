from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '106 passed; 0 failed' in (r/'logs/native-source-release-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-source-release-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_source_release_contract.json');assert proof['passed'] and len(proof['cases'])==12
for c in proof['cases']:
 assert c['after_strong']==0 and c['after_weak']==1 and c['weak_expired'] and c['source_freed']
 if c['observer']:
  callback=next(i for i,e in enumerate(c['trace']) if e['kind']=='callback');release=next(i for i,e in enumerate(c['trace']) if e['kind']=='free' and e['source']);assert callback<release
files=['data/4.20/fow_source_release_contract.json','tools/probe_fow_source_release.py','data/4.20/fow_circle_factory_contract.json','data/4.20/fow_map10_owned_contract.json','crates/client/src/fow_source_factory.rs','crates/client/src/fow_regions.rs','logs/native-source-release-tests.log','logs/native-source-release-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=106,client_build_passed=True,native_release_cases=12,source_owned_map10_mask_cases=24,live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Executed original circular creation/removal6B1B20/6B1F90, event dispatch64E8D0, subscriber constructor68CF70, view callback6B4860, region rollback, source destructor and failed weak promotion in12cases/1316native addresses. Heap/free/mutex OS boundaries explicitly adapted.','Original removal notification is synchronous, not a deferred queue: callback sees source strong count1 and removes applied region before destructor requests source deallocation. Without observer there is no visibility rollback. Source weak reference becomes expired with native strong0/weak1.','Rust CircleFactory.retire notifies while manager still owns source, then erases owner. Twelve native case outputs match counts/pixels and weak expiration; expired source cannot notify twice.','Source-owned mask cache now carries the applied flag; CountedLayer external replacement/retirement operates on that exact cache. Existing24Map10 factory mask checks now apply/withdraw through source state instead of duplicating cached region ownership.'],
 limits=proof['limits']+['Source/control deallocation requests are recorded at allocator boundary; emulator memory is retained. Final retained weak-control release not executed. This is not original OS allocator/mutex qualification.','Only one source, one optional observer and an empty pending-source heap are exercised. Multiple source compaction, multiple observers, view initialization/registration, concurrency and pending heap removal remain open.','Ordinary actor/team/identity producers, non-null constructor provider, cone creation, mask scheduling/world extent/terrain initialization, authoritative mask filtering and GPU binding remain incomplete.','106client tests and build are current;427core tests and10UDPchecks remain prior unchanged-core/server evidence. Current graphical gameplay remains unverified.','All24domains remain unfinished.'],
 next_actions=['Qualify multi-source removal/compaction, multiple observer dispatch and pending-source heap cleanup; execute final retained weak-control release and view subscription initialization.','Qualify actual actor/team/opaque identity producers and source generation scheduling; drive unified source caches and counters from real gameplay entities.','Qualify world extent/terrain initialization, reconcile native mask visibility with server filtering and bind fog texture processing to ordinary rendering; verify current gameplay.'],files_sha256={p:sha(p) for p in files})
save('docs/native_source_release_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_source_release_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=106;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=106,current_build_receipt='docs/native_source_release_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Vision — notification de retrait et référence expirée</h2><p>106 tests client et compilation réussis.12scénarios natifs : notification synchrone, retrait du masque avant destructeur, puis référence faible expirée. Cache de région unifié avec les compteurs ;24masques Map10 vérifiés par cette voie. Plusieurs sources/abonnés, initialisation complète, activation de partie et GPU restent ouverts.</p><a href="native_source_release_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_source_release.py'),r/'tools/record_fow_source_release.py')
print(json.dumps(dict(client_tests=106,native_release_cases=12,map10_masks=24,complete=False)))
