from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();log='logs/native-troy-offscreen-flags-tests.log';result=(r/log).read_text(encoding='utf-8-sig');m=re.search(r'test result: ok\. (\d+) passed; 0 failed;',result);assert m
receipt='docs/native_troy_offscreen_flags_progress.json'
next_action='Raccorder pause/reset/resume au cycle Projected : SimpleChild.flag=D4/emission.emitted, times=D8/previous et DC/tail.last_time, resource=C/frame.particles. Deferrer le Storage puis reutiliser native_simple_storage::acquire lors de emission(resource0), actuellement refusee par emit_from_frame. Integrer gate et tail natifs puis verifier camera mobile DX12/Vulkan ; poursuivre les24domaines/114taches.'
files=['tools/probe_native_troy_simulate_every_frame.py','tools/probe_native_troy_simulate_offscreen.py','data/4.20/troy_simulate_every_frame_contract.json','data/4.20/troy_simulate_offscreen_contract.json','crates/core/src/native_troy_simulation_flags.rs',log]
proof=dict(updated_utc=stamp,passed=True,complete=False,resource_flag_cases=81,offscreen_resource_cases=81,focused_core_tests_passed=int(m[1]),offscreen_rust_port=True,client_hidden_frame_corrected=False,findings=['SimulateEveryFrame sets config1BC bit40, forcing one temporal substep when the calculated count is zero.','SimulateWhileOffScreen sets bit1 and controls hidden-frame continuation.','Annie_Q_mis sets EveryFrame=1 but omits WhileOffScreen. Current client cycle still continues offscreen; pause/reset/resume integration remains a known open mismatch.'],limits=['Original native binary readers and bounded callers execute; cache transport and initial flags supplied.','Both EveryFrame and WhileOffScreen mappings now ported and checked against native reads.','Current graphical v23 stationary-camera captures do not cover this mismatch.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');h=r/'docs/plan_history'/('troy-offscreen-flags-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,native_troy_offscreen_flags_progress=receipt)
 changes=dict(troy_simulate_every_frame_cases=81,troy_simulate_offscreen_native_cases=81,troy_simulate_offscreen_rust_cases=81,troy_simulation_flags_core_tests=int(m[1]),annie_hidden_frame_mismatch_open=True)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Simulation hors champ</h2><p>Deux champs natifs distincts portes en Rust sur 81 lectures chacun. Annie ne demande pas de simulation hors champ ; suspension, file de stockage, reprise et cycle client restent a raccorder.</p><a href="native_troy_offscreen_flags_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
