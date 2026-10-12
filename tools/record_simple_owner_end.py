from pathlib import Path
import json,datetime,hashlib,html,shutil
r=Path('E:/OpenLeague');d=r/'docs';now=datetime.datetime.now(datetime.timezone.utc).isoformat()
contract=json.loads((r/'data/4.20/simple_owner_end_contract.json').read_text());reader=json.loads((r/'data/4.20/simple_linger_defaults_contract.json').read_text())
assert contract['passed'] and contract['runtime_adapters']==[] and sum(len(c['frames']) for c in contract['cases'])==50
assert '54 passed; 0 failed' in (r/'logs/simple-owner-end-tests.log').read_text()
assert 'Finished' in (r/'logs/simple-owner-end-build.log').read_text()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
proof={'updated_utc':now,'complete':False,'client_tests_passed':54,'native_sha256':contract['native_sha256'],'native_owner_end_cases':5,'native_owner_end_frames':50,'native_linger_reader_cases':6,'runtime_annie_projected_emitter_bound':False,'current_build_gpu_rerun':False,'findings':['Original full frame update makes zero-cap particles inactive and finished immediately when emitter-end condition holds; +Infinity age stays internal, position update skipped.','Lifetime cap mutates the stored particle lifetime; cap is measured from particle birth, not a new countdown from owner-end flag change.','Native reader call-site defaults p-linger10/e-linger0; values outside[0,10] replaced by10. Authored Annie Projected p-linger0, missing e-linger gives0.','Rust matches all50frame states bit-for-bit for age/life and matches position, count, finished and time;6reader configurations match.'],'limits':contract['limits']+reader['limits']+['Normal Projected binding and final visual fidelity remain incomplete.'],'files_sha256':{n:sha(r/n) for n in ['data/4.20/simple_owner_end_contract.json','data/4.20/simple_linger_defaults_contract.json','data/4.20/simple_linger_reader_contract.json','crates/client/src/simple_cycle.rs','crates/client/src/simple_projected_config.rs','logs/simple-owner-end-tests.log','logs/simple-owner-end-build.log','target/debug/openleague-client.exe']}}
(d/'simple_owner_end_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
oldstate=None;newstate=None
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=d/name;obj=json.loads(p.read_text(encoding='utf-8'))
 if name=='resume_checkpoint.json':
  obj['saved_utc']=now;obj['last_verified']['client_tests']=54
  for executable in obj.get('executables',[]):
   path=r/executable['path']
   if path.is_file():executable['sha256']=sha(path);executable['bytes']=path.stat().st_size
  obj.setdefault('next_actions',[]).insert(0,'Owner-end consumer verified50native frames and Rust54tests. p/e linger native defaults10/0and clamp verified6cases with config-reader adapter. Zero cap supported, inactive infinite age never passed to position updates. Next trace producer of system flag1DCbit0x10 and system startA8 on owner disappearance, qualify missile/bone pose then normal Projected integration and GPU evidence. See docs/simple_owner_end_progress.json.')
 else:
  obj['current_evidence']['client_tests_passed']=54;obj['current_evidence']['current_build_receipt']='docs/simple_owner_end_progress.json'
  obj['current_evidence']['native_simple_owner_end']={'receipt':'docs/simple_owner_end_progress.json','native_frames':50,'native_reader_cases':6,'normal_projected_bound':False}
  if name=='completion_plan.json':
   obj['updated_utc']=now;obj['progress_summary']['client_tests_last_recorded']=54
   domain=next(x for x in obj['domains'] if x['id']=='15');oldstate=domain['current_state']
   domain['current_state']=oldstate.replace('disparition anticipée du propriétaire encore à qualifier.','consommateur de fin anticipée vérifié sur 50 frames ; producteur du signal de disparition et intégration normale encore à qualifier.')
   newstate=domain['current_state'];domain['progress_evidence']=list(dict.fromkeys(domain['progress_evidence']+['docs/simple_owner_end_progress.json']))
   task=next(x for x in domain['tasks'] if x['id']=='15.1');task['evidence']=list(dict.fromkeys(task['evidence']+['docs/simple_owner_end_progress.json']))
   obj['latest_projection_evidence']={'receipt':'docs/simple_owner_end_progress.json','client_checks':54,'native_frames':50,'native_emitter_bound':False,'full_goal_complete':False}
 p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=d/'completion_plan.html';s=p.read_text(encoding='utf-8').replace('52 tests client enregistrés','54 tests client enregistrés').replace(html.escape(oldstate),html.escape(newstate));p.write_text(s,encoding='utf-8')
p=d/'plan_update_receipt.json';obj=json.loads(p.read_text(encoding='utf-8'));obj['latest_evidence_update_utc']=now;obj['files_sha256']={n:sha(d/n) for n in ['completion_plan.json','completion_plan.html','goal_objective.txt']};p.write_text(json.dumps(obj,indent=2)+'\n')
shutil.copyfile(Path('E:/mapslol3v3/record_simple_owner_end.py'),r/'tools/record_simple_owner_end.py')
print('Native50frame owner-end and6reader contracts,54client tests recorded; full goal remains incomplete.')
