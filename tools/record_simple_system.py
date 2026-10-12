from pathlib import Path
import json,datetime,hashlib,html,shutil
r=Path('E:/OpenLeague');d=r/'docs';now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
c=json.loads((r/'data/4.20/particle_stop_contract.json').read_text())
assert c['passed'] and len(c['cases'])==512 and c['runtime_adapters']==[]
assert '56 passed; 0 failed' in (r/'logs/simple-system-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-system-build.log').read_text()
proof={'updated_utc':now,'complete':False,'client_tests_passed':56,'native_stop_states':512,'native_sha256':c['native_sha256'],'runtime_annie_projected_emitter_bound':False,'current_build_gpu_rerun':False,'findings':['Native93FA10 preserves startA8, writes stop148 once, clears persistent bit0and sets end/stopped bits0x50. Already-stopped bit0x40 preserves fields.','Rust stop state matches512native states; drives all50previous native emitter frames without resetting system time.','Static setter9289B0 sets request400; caller940719 invokes93FA10 after consuming this bit. Missile-owner call chain remains unqualified.'],'limits':c['limits']+['Full first-stop audio and manager bookkeeping not executed; normal gameplay binding and GPU fidelity remain incomplete.'],'files_sha256':{n:sha(r/n) for n in ['data/4.20/particle_stop_contract.json','data/4.20/particle_stop_request_setters.json','crates/client/src/simple_system.rs','crates/client/src/main.rs','logs/simple-system-tests.log','logs/simple-system-build.log','target/debug/openleague-client.exe']}}
(d/'simple_system_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=d/name;obj=json.loads(p.read_text(encoding='utf-8'))
 if name=='resume_checkpoint.json':
  obj['saved_utc']=now;obj['last_verified']['client_tests']=56
  for executable in obj.get('executables',[]):
   path=r/executable['path']
   if path.is_file():executable['sha256']=sha(path);executable['bytes']=path.stat().st_size
  obj.setdefault('next_actions',[]).insert(0,'Native stop93FA10qualified512states: startA8preserved, stop148once, flags0x50and clearbit0; repeatstop40is idempotent. Rust56tests/build pass. Static request setter9289B0sets400 ->940719calls93FA10. Next qualify caller chain from missile/owner end and system/bone pose producer, then normal Annie Projected integration/GPU. Receipt docs/simple_system_progress.json. First stop audio/manager side effects remain unqualified.')
 else:
  obj['current_evidence']['client_tests_passed']=56;obj['current_evidence']['current_build_receipt']='docs/simple_system_progress.json'
  obj['current_evidence']['native_simple_system_stop']={'receipt':'docs/simple_system_progress.json','native_states':512,'normal_projected_bound':False}
  if name=='completion_plan.json':
   obj['updated_utc']=now;obj['progress_summary']['client_tests_last_recorded']=56
   domain=next(x for x in obj['domains'] if x['id']=='15');oldstate=domain['current_state']
   note=' État natif d’arrêt vérifié sur 512 cas, début conservé et heure d’arrêt enregistrée une seule fois ; chaîne du propriétaire et rendu normal encore à qualifier.'
   if note not in oldstate:domain['current_state']+=note
   newstate=domain['current_state'];domain['progress_evidence']=list(dict.fromkeys(domain['progress_evidence']+['docs/simple_system_progress.json']))
   task=next(x for x in domain['tasks'] if x['id']=='15.1');task['evidence']=list(dict.fromkeys(task['evidence']+['docs/simple_system_progress.json']))
   obj['latest_projection_evidence']={'receipt':'docs/simple_system_progress.json','client_checks':56,'native_stop_states':512,'native_emitter_bound':False,'full_goal_complete':False}
 p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=d/'completion_plan.html';s=p.read_text(encoding='utf-8').replace('54 tests client enregistrés','56 tests client enregistrés').replace(html.escape(oldstate),html.escape(newstate));p.write_text(s,encoding='utf-8')
p=d/'plan_update_receipt.json';obj=json.loads(p.read_text(encoding='utf-8'));obj['latest_evidence_update_utc']=now;obj['files_sha256']={n:sha(d/n) for n in ['completion_plan.json','completion_plan.html','goal_objective.txt']};p.write_text(json.dumps(obj,indent=2)+'\n')
for n in ['record_simple_system.py','discover_particle_owner_end.py','discover_particle_stop_requests.py','find_stop_request_setters.py','inspect_owner_end.py']:shutil.copyfile(Path('E:/mapslol3v3')/n,r/'tools'/n)
print('Native stop512states; client56tests/build; full goal remains active and incomplete.')
