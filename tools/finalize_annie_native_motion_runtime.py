from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_motion_runtime_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
capture=load('docs/projected_core_cycle_capture_v16_native_motion_dx12.json');pair=load('docs/projected_pair_control_v16_native_motion_dx12.json')
pipeline=load('logs/projected-core-cycle-v16-native-motion-dx12-pipeline.json')['frames']
assert pair['same_frame_attribution_gate_passed'] and pair['strict_baseline_equal']
assert len(capture['measurements'])==2 and capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0
assert capture['client_sha256']==sha('target/debug/openleague-client.exe')
assert all(d['pipeline_states'] and all(x=='ready' for x in d['pipeline_states']) and d['fow_ready']==1 for f in pipeline for d in f['draws'])
next_action='Raccorder la direction et la pose propriétaire natives à la projection d’Annie ; traiter la disparition de cible, collisions et arrêt, vérifier Vulkan sur le nouvel exécutable, puis poursuivre les24domaines.'
files=['target/debug/openleague-client.exe','logs/annie-native-motion-client-build.log','docs/projected_core_cycle_capture_v16_native_motion_dx12.json','docs/projected_pair_control_v16_native_motion_dx12.json','logs/projected-core-cycle-v16-native-motion-dx12-pipeline.json','crates/client/src/annie_q_vfx.rs']
proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=capture['client_sha256'],graphical_build_complete=True,backend='dx12',native_motion_consumer_runtime_executed=True,casts=2,cleaned=2,active_draws_final=0,baseline=pair['baseline'],instances=pair['instances'],pipeline_frames=len(pipeline),nonready_pipeline_frames=0,diagnostic_no_gamma=pair['diagnostic_no_gamma'],diagnostic_no_msaa=pair['diagnostic_no_msaa'],artifacts_sha256={p:sha(p) for p in files},visual_inspection=dict(inspected=True,images=['shot1','shot2','off','same-frame pair2 on/off'],observed='Subtle warm projection visible on ground in on image, absent in paired off image; actors and terrain remain visible. Second ordinary capture also shows red particles.',human_fidelity_acceptance=False),limits=['Diagnostic seeded fixture; two local casts do not prove complete ordinary progression or original LoL GPU fidelity.','Native motion is connected, but projection orientation remains identity and owner clock/launch offsets/target disappearance/collisions/server end remain incompletely qualified.','Only DX12 rerun on this new executable; prior Vulkan evidence belongs to older binary.','No full-suite rerun; all24domains114tasks remain open.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_native_motion_build_pending.json';pending=load('docs/annie_native_motion_build_pending.json');pending.pop('build_session_id',None);pending.update(updated_utc=now,status='terminal_build_and_dx12_capture_passed',runtime_progress=receipt,next_action=next_action);p.write_text(json.dumps(pending,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_native_motion_consumer_progress.json';d=load('docs/annie_native_motion_consumer_progress.json');d.update(graphical_client_rebuilt=True,current_runtime_capture=True,runtime_progress=receipt);d['limits']=[x for x in d['limits'] if not x.startswith('Test binary compiled')];p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-motion-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_motion_runtime_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(current_client_sha256=proof['client_sha256'],latest_native_execution_progress=receipt,annie_native_motion_runtime_casts=2,annie_projection_full_original_fidelity_qualified=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Trajectoire native — vérification graphique</h2><p>Client reconstruit puis deux tirs capturés en DX12. Nettoyage complet des deux effets ;33images de référence identiques. Contributions des projections :67686 et70924pixels au maximum. Images inspectées. Orientation native, collisions, arrêt et fidélité complète restent ouverts.</p><a href="annie_native_motion_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
shutil.copy2(Path('E:/mapslol3v3/analyze_annie_native_motion_pair.py'),r/'tools/analyze_annie_native_motion_pair.py')
print(json.dumps(dict(receipt=receipt,client_sha256=proof['client_sha256'],casts=2,complete=False)))
