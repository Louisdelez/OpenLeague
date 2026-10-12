from pathlib import Path
import json,datetime,hashlib,html
r=Path('E:/OpenLeague');d=r/'docs';now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
c=json.loads((r/'data/4.20/effect_owner_stop_contract.json').read_text())
assert c['passed'] and len(c['cases'])==256 and c['runtime_adapters']==[]
assert '57 passed; 0 failed' in (r/'logs/effect-owner-tests.log').read_text()
assert 'Finished' in (r/'logs/effect-owner-build.log').read_text()
proof={'updated_utc':now,'complete':False,'client_tests_passed':57,'native_effect_owner_masks':256,'native_instruction_addresses':c['original_instruction_addresses'],'native_sha256':c['native_sha256'],'runtime_annie_projected_emitter_bound':False,'current_build_gpu_rerun':False,'findings':['Original7558C0 locks8weak references, sets owner stopping38, dispatches9289B0via vtable offsetA0only to live references. All256live masks execute native weak lock/refcount and setter without adapters.','Rust equivalent uses weak references, preserves other request bits and leaves expired references untouched. Native masks and ownership preservation pass.','Actual effect constructor93FD9A installs vtable10D6DB4; setter is at offsetA0. Adjacent table10D6D60is a different object and is excluded.','Static caller755C0E invokes owner stop when887110returnsfalse. Exact missile-owner identity and full manager processing remain open.'],'limits':c['limits']+['Full game, normal Annie Projected consumer, original manager/audio processing and visual qualification remain incomplete.'],'files_sha256':{n:sha(r/n) for n in ['data/4.20/effect_owner_stop_contract.json','data/4.20/effect_owner_callers_discovery.json','data/4.20/particle_stop_virtual_calls.json','crates/client/src/effect_owner.rs','crates/client/src/main.rs','logs/effect-owner-tests.log','logs/effect-owner-build.log','target/debug/openleague-client.exe']}}
(d/'effect_owner_progress.json').write_text(json.dumps(proof,indent=2)+'\n')
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=d/name;obj=json.loads(p.read_text(encoding='utf-8'))
 if name=='resume_checkpoint.json':
  obj['saved_utc']=now;obj['last_verified']['client_tests']=57
  for executable in obj.get('executables',[]):
   path=r/executable['path']
   if path.is_file():executable['sha256']=sha(path);executable['bytes']=path.stat().st_size
  obj.setdefault('next_actions',[]).insert(0,'Owner stop7558C0qualified256eight-live/expired masks with native weak locking/refcount and request setter9289B0(no adapters). Actual vtable constructor93FD9A=10D6DB4, stopoffsetA0; earlier adjacent table10D6D60does not own this effect. Rust57tests/buildpass. Nativecaller755C0Estopswhen887110false,7557E0destructor/clear also needsqualification. Next trace exact missile owner identity and system pose producer9407xx then normal AnnieProjected andGPU. Receipt docs/effect_owner_progress.json.')
 else:
  obj['current_evidence']['client_tests_passed']=57;obj['current_evidence']['current_build_receipt']='docs/effect_owner_progress.json'
  obj['current_evidence']['native_effect_owner_stop']={'receipt':'docs/effect_owner_progress.json','native_masks':256,'normal_projected_bound':False}
  if name=='completion_plan.json':
   obj['updated_utc']=now;obj['progress_summary']['client_tests_last_recorded']=57
   domain=next(x for x in obj['domains'] if x['id']=='15');oldstate=domain['current_state'];note=' Dispatch natif d’arrêt des huit références d’effets vérifié sur 256 combinaisons ; références expirées ignorées, requêtes préservées. Identification du propriétaire de missile et rendu normal encore ouverts.'
   if note not in oldstate:domain['current_state']+=note
   newstate=domain['current_state'];domain['progress_evidence']=list(dict.fromkeys(domain['progress_evidence']+['docs/effect_owner_progress.json']))
   task=next(x for x in domain['tasks'] if x['id']=='15.1');task['evidence']=list(dict.fromkeys(task['evidence']+['docs/effect_owner_progress.json']))
   obj['latest_projection_evidence']={'receipt':'docs/effect_owner_progress.json','client_checks':57,'native_owner_masks':256,'native_emitter_bound':False,'full_goal_complete':False}
 p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=d/'completion_plan.html';s=p.read_text(encoding='utf-8').replace('56 tests client enregistrés','57 tests client enregistrés').replace(html.escape(oldstate),html.escape(newstate));p.write_text(s,encoding='utf-8')
p=d/'plan_update_receipt.json';obj=json.loads(p.read_text(encoding='utf-8'));obj['latest_evidence_update_utc']=now;obj['files_sha256']={n:sha(d/n) for n in ['completion_plan.json','completion_plan.html','goal_objective.txt']};p.write_text(json.dumps(obj,indent=2)+'\n')
for n in ['record_effect_owner.py','discover_stop_setter_callers.py','inspect_particle_vtable.py','discover_particle_vtable_base.py','discover_particle_stop_virtual_calls.py','discover_effect_owner_callers.py','inspect_owner_end.py']:
 text=(Path('E:/mapslol3v3')/n).read_text(encoding='utf-8').replace('E:/OpenLeague/tools/inspect_owner_end.py','E:/OpenLeague/tools/inspect_owner_end.py').replace('E:/OpenLeague/tools/discover_stop_setter_callers.py','E:/OpenLeague/tools/discover_stop_setter_callers.py')
 (r/'tools'/n).write_text(text,encoding='utf-8')
print('Native256owner masks,57client tests/build recorded; original24domain goal remains incomplete.')
