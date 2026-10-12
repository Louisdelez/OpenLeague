from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_owner_scale_runtime_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');backends={};files=['target/debug/openleague-client.exe','logs/annie-owner-scale-client-build.log','logs/annie-owner-scale-client-tests.log','data/4.20/annie_projected_owner_scale_contract.json','crates/client/src/projected_live.rs','crates/client/src/annie_q_vfx.rs','crates/core/src/native_troy_scalar.rs','crates/client/src/simple_projected_config.rs','tools/probe_annie_projected_owner_scale.py']
assert 'Finished `dev` profile' in (r/files[1]).read_text(encoding='utf-8-sig')
for backend in ['dx12','vulkan']:
 version='v21_owner_scale_'+backend;capture_file='docs/projected_core_cycle_capture_'+version+'.json';pair_file='docs/projected_pair_control_'+version+'.json';pipeline_file='logs/projected-core-cycle-'+version.replace('_','-')+'-pipeline.json'
 capture=load(capture_file);pair=load(pair_file);pipeline=load(pipeline_file)['frames']
 assert capture['client_sha256']==binary and len(capture['measurements'])==2
 assert all(m['native_owner_scale_gate_binding'] and m['native_owner_acquisition_gate_binding'] and m['native_pose_binding'] and not m['native_position_coordinate_roundtrip'] and m['native_stop_dispatch_binding'] and m['native_clock_binding'] for m in capture['measurements'])
 assert capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0 and capture['measurements'][-1]['active_effects']==0
 assert pair['same_frame_attribution_gate_passed'] and pair['strict_baseline_equal']
 assert not pair['diagnostic_no_gamma'] and not pair['diagnostic_no_msaa']
 assert all(d['pipeline_states'] and all(x=='ready' for x in d['pipeline_states']) and d['fow_ready']==1 for f in pipeline for d in f['draws'])
 backends[backend]=dict(casts=2,cleaned=2,active_effects_final=0,active_draws_final=0,baseline=pair['baseline'],instances=pair['instances'],pipeline_frames=len(pipeline),visual_inspection=dict(inspected=True,human_fidelity_acceptance=False,observed='Terrain and actors visible; two cast images and final cleanup inspected. Projected ground contribution appears in paired on image and is absent in same-frame off image. Other projectile particles are not a projection-cleanup failure.'))
 files.extend([capture_file,pair_file,pipeline_file])
next_action='Qualifier la visibilité et ses consommateurs natifs pour Annie ; poursuivre les statuts/drapeaux, durée de vie propriétaire, ordonnancement et les 24 domaines/114 tâches.'
proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=binary,graphical_client_rebuilt=True,current_runtime_capture=True,backends=backends,native_owner_scale_gate_runtime_executed=True,synthetic_owner_loss_graphically_exercised=False,native_client_owner_acquisition_frames=15,native_position_roundtrip=False,native_reference_profiles=10,native_live_pose_reference_profiles=45,focused_client_tests_passed=6,full_suites_rerun=False,artifacts_sha256={p:sha(p) for p in files},limits=['Two seeded diagnostic casts per backend; not ordinary progression, complete champion or whole-game acceptance.','Native factory flags, initial orientation and exact position/direction bridge execute in live client. Local Shot presence supplies owner acquisition; native loss marker retains last pose and delays cleanup until next rejected update. Normal captures do not inject owner loss:15 synthetic frames were tested in client. Original weak lifetime producer and registry scheduling remain open; network disappearance supplies controller-end trigger.','Annie zero coefficient scale gate qualified and rendered: initial child factor1 is retained. System scale mutations, nonzero owner coefficients, visibility/FOW, subsequent flag/status producers, blend/depth/sampler, receiver fidelity and full Q effects remain incomplete.','Clock uses local Bevy source with native default wrapper; original time source and pause/speed transitions remain open.','Technical checks are not human acceptance of original-game fidelity; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_owner_scale_consumer_progress.json';consumer=load(str(p.relative_to(r)));consumer.pop('build_session_id',None);consumer.update(updated_utc=now,status='terminal_build_and_dx12_vulkan_captures_passed',graphical_client_rebuilt=True,current_runtime_capture=True,runtime_progress=receipt);consumer['limits']=[x for x in consumer['limits'] if not x.startswith('Current graphical binary predates this source')];p.write_text(json.dumps(consumer,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-owner-scale-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_owner_scale_runtime_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,annie_source_matches_graphical_binary=True,current_client_sha256=binary,annie_owner_scale_runtime_casts_per_backend=2,annie_owner_scale_runtime_backends=['dx12','vulkan'])
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.pop('active_graphical_build',None);d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Facteur de taille d’Annie — contrôle graphique</h2><p>Deux tirs et nettoyage vérifiés en DX12 et Vulkan sur le même nouvel exécutable. Attribution des pixels sur les mêmes frames. Facteur enfant natif transmis au rendu avec coefficients Annie zéro ; visibilité, durée de vie du propriétaire, statuts, drapeaux suivants et ordonnanceur natifs restent à qualifier ; aucun domaine clôturé.</p><a href="annie_owner_scale_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
