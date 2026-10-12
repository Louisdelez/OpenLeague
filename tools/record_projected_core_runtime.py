from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
c=load('docs/projected_core_cycle_capture_v1.json');sha=lambda f:hashlib.sha256((r/f).read_bytes()).hexdigest()
assert c['client_sha256']==sha('target/debug/openleague-client.exe')
assert len(c['measurements'])==2
for n,m in enumerate(c['measurements'],1):assert m['spawned']==n and m['cleaned']==n and m['active_effects']==0 and m['active_draws']==0 and m['max_visible_draws']>0
receipt='docs/native_projected_core_runtime_progress.json'
e=dict(current_client_sha256=c['client_sha256'],annie_projection_core_frame_current_runtime_executed=True,annie_projection_core_frame_repeat_cleanup_checks=2,annie_projection_current_graphical_binary_qualified=False,annie_projection_pixel_attribution_qualified=False,latest_projected_runtime_progress=receipt)
files=['target/debug/openleague-client.exe','target/debug/examples/annie_ready_fixture.exe','crates/client/src/native_projected_cycle.rs','crates/client/src/projected_live.rs','crates/client/src/simple_projected_config.rs','logs/native-projected-core-cycle-client-build.log','logs/native-projected-core-cycle-fixture-build.log','docs/projected_core_cycle_capture_v1.json','docs/native_projected_core_cycle_progress.json','tools/capture_projected_core_cycle.py']+[x['path'] for x in c['captures']]
save(receipt,dict(updated_utc=now,complete=False,**e,artifacts_sha256={f:sha(f) for f in files},visual_inspection=dict(inspected=True,findings='Baseline and on show terrain and both champions; projection contribution cannot be confidently identified. Off contains separate red Fire/Fire_Head particles, so cleanup screenshot is not a clean visual isolation of projection. No pixel attribution or original fidelity acceptance.'),limits=c['limits']+['Draw visibility/counters are CPU observations. Two casts and repeat resource cleanup passed; on/off image timing and pipeline warmup require stronger diagnostics. No audio or full kit/game acceptance.']))
next_action='Renforcer les captures par lancement et l’attribution des pixels de la projection sur le client reconstruit ; qualifier les fournisseurs et facteurs de rendu/audio, puis poursuivre les 24 domaines.'
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json']:
 d=load('docs/'+name);d.update(updated_utc=now,native_projected_core_runtime_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_projected_runtime_progress=receipt,next_steps=[next_action])
 else:
  target=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];target.update(e)
  if name=='resume_checkpoint.json':d.pop('pending_projected_core_build',None);d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':d['next_execution_steps']=[next_action]+d['next_execution_steps'][1:]
 save('docs/'+name,d)
p=load('docs/native_projected_core_build_pending.json');p.update(updated_utc=now,status='build_passed_runtime_capture_completed',graphical_runtime_qualified=False,capture='docs/projected_core_cycle_capture_v1.json');save('docs/native_projected_core_build_pending.json',p)
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(runtime_casts=2,pixel_attribution_qualified=False,receipt=receipt)))
