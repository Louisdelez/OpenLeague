from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_visibility_runtime_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
binary=sha('target/debug/openleague-client.exe');backends={}
files=['target/debug/openleague-client.exe','logs/annie-visibility-client-build.log','logs/annie-visibility-client-tests.log','logs/native-troy-visibility-predicate-tests.log','data/4.20/projectile_visibility_activation_contract.json','data/4.20/projectile_team_visibility_contract.json','crates/client/src/projected_live.rs','crates/core/src/native_projectile_owner_properties.rs','crates/core/src/native_troy_frame_gate.rs']
assert 'Finished `dev` profile' in (r/files[1]).read_text(encoding='utf-8-sig')
assert 'test result: ok. 7 passed;' in (r/files[2]).read_text(encoding='utf-8-sig')
assert 'test result: ok. 1 passed;' in (r/files[3]).read_text(encoding='utf-8-sig')
for backend in ['dx12','vulkan']:
 version='v22_visibility_'+backend;capture_file='docs/projected_core_cycle_capture_'+version+'.json';pair_file='docs/projected_pair_control_'+version+'.json';pipeline_file='logs/projected-core-cycle-'+version.replace('_','-')+'-pipeline.json'
 capture=load(capture_file);pair=load(pair_file);pipeline=load(pipeline_file)['frames']
 assert capture['client_sha256']==binary and len(capture['measurements'])==2
 assert all(m['native_visibility_activation_binding'] and m['native_visibility_suppression_binding'] and m['native_owner_scale_gate_binding'] and m['native_owner_acquisition_gate_binding'] and m['native_pose_binding'] and not m['native_position_coordinate_roundtrip'] and m['native_stop_dispatch_binding'] and m['native_clock_binding'] for m in capture['measurements'])
 assert capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0 and capture['measurements'][-1]['active_effects']==0
 assert pair['same_frame_attribution_gate_passed'] and pair['strict_baseline_equal']
 assert not pair['diagnostic_no_gamma'] and not pair['diagnostic_no_msaa']
 assert all(d['pipeline_states'] and all(x=='ready' for x in d['pipeline_states']) and d['fow_ready']==1 for f in pipeline for d in f['draws'])
 backends[backend]=dict(casts=2,cleaned=2,active_effects_final=0,active_draws_final=0,baseline=pair['baseline'],instances=pair['instances'],pipeline_frames=len(pipeline),visual_inspection_required=False,visual_inspection=dict(inspected=True,images_per_backend=5,observed="Two cast images, cleanup and same-frame on/off pair inspected. Warm ground contribution present only in paired on image; other red projectile particles persist separately in cleanup image."),human_fidelity_acceptance=False)
 files.extend([capture_file,pair_file,pipeline_file])
next_action='Qualifier les appelants natifs d’activation, l’ordonnancement masqué et les producteurs équipe/FOW ; poursuivre les statuts/drapeaux du propriétaire puis les24domaines/114tâches.'
proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=binary,graphical_client_rebuilt=True,current_runtime_capture=True,backends=backends,native_visibility_activation_runtime_executed=True,native_visibility_suppression_draw_gate_integrated=True,hidden_visibility_transition_graphically_exercised=False,native_activation_reference_sequences=48,native_team_reference_cases=192,focused_client_tests_passed=7,focused_core_tests_passed=1,native_frame_gate_reference_cases=1280,full_suites_rerun=False,artifacts_sha256={p:sha(p) for p in files},limits=['Two seeded diagnostic casts per backend; not ordinary progression, complete champion or whole-game acceptance.','Local effect creation invokes the native activation port. Original registry activation callers, weak lifetime source and full frame ordering remain open.','Supplied local root filter disabled yields an unsuppressed projection.48native reference sequences test activation/deactivation, but no hidden team transition was injected into these graphical captures.','Native suppression predicate controls the footprint; Bevy camera culling remains an explicit adapter. Native frustum/hidden-frame skip/pause/resume simulation, native team/FOW producers and rasterization remain open.','Other lifecycle/pose/scale/cleanup tests remain targeted; native status/flags, receiver fidelity and full Q effects remain incomplete.','Technical checks are not human acceptance of original-game fidelity; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_visibility_consumer_progress.json';consumer=load(str(p.relative_to(r)));consumer.pop('build_session_id',None);consumer.update(updated_utc=now,status='terminal_build_and_dx12_vulkan_captures_passed',graphical_client_rebuilt=True,current_runtime_capture=True,runtime_progress=receipt);consumer['limits']=[x for x in consumer['limits'] if not x.startswith('No graphical build/capture completion')];p.write_text(json.dumps(consumer,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-visibility-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_visibility_runtime_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,annie_source_matches_graphical_binary=True,current_client_sha256=binary,annie_visibility_runtime_casts_per_backend=2,annie_visibility_runtime_backends=['dx12','vulkan'])
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.pop('active_graphical_build',None);d.pop('active_graphical_capture',None);d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Activation native d’Annie — contrôles graphiques</h2><p>Deux tirs et nettoyage vérifiés en DX12 et Vulkan sur le nouvel exécutable. Le profil local garde le filtre équipe désactivé ; aucune transition graphique vers l’état masqué n’est revendiquée. Producteurs équipe/FOW, appelants et ordonnanceur natifs restent ouverts.</p><a href="annie_visibility_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(receipt)
