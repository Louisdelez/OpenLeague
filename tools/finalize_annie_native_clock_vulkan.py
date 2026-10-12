from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_clock_vulkan_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
capture=load('docs/projected_core_cycle_capture_v17_native_clock_vulkan.json');pair=load('docs/projected_pair_control_v17_native_clock_vulkan.json');pipeline=load('logs/projected-core-cycle-v17-native-clock-vulkan-pipeline.json')['frames']
assert capture['client_sha256']==sha('target/debug/openleague-client.exe')
assert load('docs/annie_native_clock_runtime_progress.json')['client_sha256']==capture['client_sha256']
assert len(capture['measurements'])==2 and capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0
assert all(m['native_clock_binding'] for m in capture['measurements'])
assert pair['same_frame_attribution_gate_passed'] and pair['strict_baseline_equal']
assert all(d['pipeline_states'] and all(x=='ready' for x in d['pipeline_states']) and d['fow_ready']==1 for f in pipeline for d in f['draws'])
next_action='Raccorder la pose et l’arrêt natifs d’Annie ; poursuivre les 24 domaines du plan après les contrôles DX12 et Vulkan du même exécutable.'
files=['target/debug/openleague-client.exe','logs/annie-native-clock-client-build.log','logs/annie-native-clock-consumer-tests.log','docs/projected_core_cycle_capture_v17_native_clock_vulkan.json','docs/projected_pair_control_v17_native_clock_vulkan.json','logs/projected-core-cycle-v17-native-clock-vulkan-pipeline.json','crates/client/src/projected_live.rs','crates/client/src/annie_q_vfx.rs','crates/core/src/native_troy_clock.rs','crates/core/src/native_troy_resource_initial.rs']
proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=capture['client_sha256'],backend='vulkan',backends_verified=['dx12','vulkan'],graphical_client_rebuilt=True,current_runtime_capture=True,native_clock_consumer_runtime_executed=True,focused_client_tests_passed=3,native_reference_frames=50,full_client_suite_rerun=False,casts=2,cleaned=2,active_draws_final=0,baseline=pair['baseline'],instances=pair['instances'],pipeline_frames=len(pipeline),artifacts_sha256={p:sha(p) for p in files},visual_inspection=dict(inspected=True,human_fidelity_acceptance=False,observed='Terrain and actors visible; projected on/off contribution isolated in same-frame captures. Two cast captures and cleanup inspected.'),limits=['Seeded diagnostic fixture; not complete ordinary progression or original LoL fidelity acceptance.','Clock/start consumers connected to local Bevy time source with default parameters; original source, pause/speed transitions, native stop/owner interface remain unqualified.','Identity orientation/default factors/FOW1; complete rendering and Q behavior remain open.','DX12 and Vulkan verified on same current binary for this diagnostic only; full performance and fidelity acceptance open. Zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_native_clock_consumer_progress.json';consumer=load('docs/annie_native_clock_consumer_progress.json');consumer.pop('build_session_id',None);consumer.update(updated_utc=now,status='terminal_build_and_vulkan_capture_passed',graphical_client_rebuilt=True,current_runtime_capture=True,runtime_progress=receipt);consumer['limits']=[x for x in consumer['limits'] if not x.startswith('Graphical executable building')];p.write_text(json.dumps(consumer,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-clock-vulkan-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_clock_vulkan_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,annie_native_clock_frames=50,annie_native_clock_focused_client_tests=3,annie_source_matches_graphical_binary=True,current_client_sha256=proof['client_sha256'],annie_native_clock_runtime_casts=2)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Horloge native d’Annie — vérification graphique</h2><p>Même client que DX12, deux tirs Vulkan capturés et nettoyés. Contrôle des pixels on/off sur les mêmes frames. Pose, arrêt natif et fidélité complète encore ouverts.</p><a href="annie_native_clock_vulkan_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)


