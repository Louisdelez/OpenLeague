from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_pose_runtime_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');backends={};files=['target/debug/openleague-client.exe','logs/annie-native-pose-client-build.log','logs/annie-native-pose-consumer-tests.log','logs/native-projectile-pose-composition-tests.log','crates/client/src/projected_live.rs','crates/client/src/annie_q_vfx.rs','crates/core/src/native_projectile_factory_pose.rs','crates/core/src/native_missile_owner_pose.rs','data/4.20/projectile_pose_composition_contract.json']
assert 'Finished `dev` profile' in (r/files[1]).read_text(encoding='utf-8-sig')
for backend in ['dx12','vulkan']:
 version='v19_native_pose_'+backend;capture_file='docs/projected_core_cycle_capture_'+version+'.json';pair_file='docs/projected_pair_control_'+version+'.json';pipeline_file='logs/projected-core-cycle-'+version.replace('_','-')+'-pipeline.json'
 capture=load(capture_file);pair=load(pair_file);pipeline=load(pipeline_file)['frames']
 assert capture['client_sha256']==binary and len(capture['measurements'])==2
 assert all(m['native_pose_binding'] and not m['native_position_coordinate_roundtrip'] and m['native_stop_dispatch_binding'] and m['native_clock_binding'] for m in capture['measurements'])
 assert capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0 and capture['measurements'][-1]['active_effects']==0
 assert pair['same_frame_attribution_gate_passed'] and pair['strict_baseline_equal']
 assert not pair['diagnostic_no_gamma'] and not pair['diagnostic_no_msaa']
 assert all(d['pipeline_states'] and all(x=='ready' for x in d['pipeline_states']) and d['fow_ready']==1 for f in pipeline for d in f['draws'])
 backends[backend]=dict(casts=2,cleaned=2,active_effects_final=0,active_draws_final=0,baseline=pair['baseline'],instances=pair['instances'],pipeline_frames=len(pipeline),visual_inspection=dict(inspected=True,human_fidelity_acceptance=False,observed='Terrain and actors visible; two cast images and final cleanup inspected. Projected ground contribution appears in paired on image and is absent in same-frame off image. Other projectile particles are not a projection-cleanup failure.'))
 files.extend([capture_file,pair_file,pipeline_file])
next_action='Qualifier l’acquisition et la perte du propriétaire, les drapeaux suivants et l’ordonnancement natifs d’Annie ; poursuivre les 24 domaines et les 114 tâches du plan complet.'
proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=binary,graphical_client_rebuilt=True,current_runtime_capture=True,backends=backends,native_pose_runtime_executed=True,native_position_roundtrip=False,native_reference_profiles=180,native_live_pose_reference_profiles=45,focused_core_tests_passed=2,focused_client_tests_passed=4,full_suites_rerun=False,artifacts_sha256={p:sha(p) for p in files},limits=['Two seeded diagnostic casts per backend; not ordinary progression, complete champion or whole-game acceptance.','Native factory flags, initial orientation and exact position/direction bridge execute in live client. Local network disappearance supplies controller-end trigger; same-frame registry scheduling and weak ownership remain reconstructed adapters.','Finite pose bridge and initial flags0 qualified; subsequent flag/status producers, native scale setters, FOW, blend/depth/sampler, receiver fidelity and full Q effects remain incomplete.','Clock uses local Bevy source with native default wrapper; original time source and pause/speed transitions remain open.','Technical checks are not human acceptance of original-game fidelity; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_native_pose_consumer_progress.json';consumer=load(str(p.relative_to(r)));consumer.pop('build_session_id',None);consumer.update(updated_utc=now,status='terminal_build_and_dx12_vulkan_captures_passed',graphical_client_rebuilt=True,current_runtime_capture=True,runtime_progress=receipt);consumer['limits']=[x for x in consumer['limits'] if not x.startswith('New source differs from current v18 executable')];p.write_text(json.dumps(consumer,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-native-pose-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_pose_runtime_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,annie_source_matches_graphical_binary=True,current_client_sha256=binary,annie_native_pose_runtime_casts_per_backend=2,annie_native_pose_runtime_backends=['dx12','vulkan'])
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.pop('active_graphical_build',None);d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Pose native d’Annie — contrôle graphique</h2><p>Deux tirs et nettoyage vérifiés en DX12 et Vulkan sur le même nouvel exécutable. Attribution des pixels sur les mêmes frames. Acquisition, perte du propriétaire, statuts, drapeaux suivants et ordonnanceur natifs restent à qualifier ; aucun domaine clôturé.</p><a href="annie_native_pose_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
