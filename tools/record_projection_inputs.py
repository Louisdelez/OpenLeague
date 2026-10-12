from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
test=(r/'logs/projected-input-tests.log').read_text(encoding='utf-8-sig');build=(r/'logs/projected-input-build.log').read_text(encoding='utf-8-sig')
assert '60 passed; 0 failed' in test and 'Finished `dev`' in build
for name in ['probe_projection_scale_defaults.py','record_projection_inputs.py']:shutil.copy2(w/name,r/'tools'/name)
proof=json.loads((r/'data/4.20/projected_inputs_contract.json').read_text());pose=json.loads((r/'data/4.20/simple_owner_pose_contract.json').read_text())
assert len(proof['cases'])==36 and proof['runtime_adapters']==[] and len(pose['cases'])==24
assert all(f['current_scale']==[500.] and f['current_rotation']==[0.] for f in pose['frames'])
paths=['data/4.20/projected_inputs_contract.json','data/4.20/projected_scale_defaults_contract.json','data/4.20/simple_owner_pose_contract.json','data/4.20/simple_cycle_contract.json','docs/simple_scale_fixture_correction.json','crates/client/src/projected_inputs.rs','crates/client/src/simple_owner_pose.rs','crates/client/src/main.rs','tools/probe_native_projection_inputs.py','tools/probe_projection_scale_defaults.py','logs/projected-input-tests.log','logs/projected-input-build.log','target/debug/openleague-client.exe']
receipt={'updated_utc':now,'complete':False,'client_tests_passed':60,'native_render_input_cases':36,'native_owner_pose_cases':24,'native_owner_pose_frames':9,'native_scale_default_cases':3,'runtime_annie_projected_emitter_bound':False,'current_build_gpu_rerun':False,'findings':['Original owner setters preserve matrix orientation and clear translation; 24 native cases and 9 full particle frames match Rust.','Original projected render input multiplies particle scale by emitter scale, then system C0*BC, then each axis bias; 36 original arithmetic segment cases match Rust.','Original constructor field stores initialize emitter scale and system C0/BC to one; 3 previous-memory patterns verified. Full constructors and subsequent setters remain separate.','Corrected fixture uses particle scale D8=500 and rotation velocity108=0; all 9 owner-pose frames report scale500/angle0. Previous fixture labels were incorrect; earlier position/lifetime evidence remains valid.'],'limits':['Prepared arithmetic and owner pose are not yet attached to normal Annie projected rendering.','No current GPU/audio acceptance; prior captures retain their original executable hashes.','Runtime factor setters, exact missile owner interface, receiver selection, FOW and native blend/depth/sampler state remain open.'],'files_sha256':{p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths}}
(r/'docs/projected_inputs_progress.json').write_text(json.dumps(receipt,indent=2)+'\n')
next_step='Connect verified owner pose, corrected scale/angle and particle lifecycle to normal Annie projected rendering; qualify runtime factor setters and visual cleanup. Full 24-domain scope remains unfinished.'
for filename in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/filename;d=json.loads(p.read_text(encoding='utf-8-sig'))
 backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True);shutil.copy2(p,backup/p.name)
 d['updated_utc']=now;d['projected_inputs_progress']=receipt
 if filename=='resume_checkpoint.json':d['last_verified']['client_tests']=60;d['next_projected_action']=next_step
 else:
  d['current_evidence']['client_tests_passed']=60
  d['current_evidence']['current_build_receipt']='docs/projected_inputs_progress.json'
  d['current_evidence']['current_client_sha256']=receipt['files_sha256']['target/debug/openleague-client.exe']
 if filename=='completion_plan.json':
  d['goal_refresh_request']['latest_test_observation']={'passed':60,'log':'logs/projected-input-tests.log','scope':'After corrected fixtures and native render-input module; compilation also passed.'}
  for domain in d['domains']:
   if str(domain.get('id','')).endswith('15'):
    domain['current_state']+=' Pose propriétaire vérifiée sur 24 cas et 9 frames ; entrées de projection sur 36 cas, facteurs initiaux sur 3 cas ; 60 tests client et compilation réussis après correction taille/rotation. Raccordement au rendu normal toujours incomplet.'
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text();s=s.replace('</body>','<section><h2>Dernière vérification des projections</h2><p>60 tests client et compilation réussis après correction taille/rotation. Pose propriétaire : 24 cas et 9 frames natives ; entrées de projection : 36 cas ; facteurs initiaux : 3 cas. Intégration au rendu normal et qualification visuelle encore à faire. Aucun domaine terminé.</p><p><a href="projected_inputs_progress.json">Preuves, empreintes et limites actuelles</a></p></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps({'client_tests':60,'native_input_cases':36,'receipt':'docs/projected_inputs_progress.json','game_complete':False}))
