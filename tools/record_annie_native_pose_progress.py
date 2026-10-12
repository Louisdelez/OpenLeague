from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_pose_consumer_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/projectile_pose_composition_contract.json');assert a['passed'] and len(a['cases'])==180
core_log='logs/native-projectile-pose-composition-tests.log';client_log='logs/annie-native-pose-consumer-tests.log'
assert 'test result: ok. 2 passed; 0 failed;' in (r/core_log).read_text(encoding='utf-8-sig')
assert 'test result: ok. 4 passed; 0 failed;' in (r/client_log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_pose_composition_contract.json','tools/probe_native_projectile_pose_composition.py','crates/core/src/native_projectile_factory_pose.rs','crates/core/src/native_missile_owner_pose.rs','crates/client/src/projected_live.rs','crates/client/src/annie_q_vfx.rs',core_log,client_log]
next_action='Recompiler Annie avec la pose native et vérifier deux tirs/leur nettoyage en DX12 et Vulkan ; poursuivre acquisition propriétaire, ordonnancement et les 24 domaines du plan complet.'
proof=dict(updated_utc=now,complete=False,passed=True,native_sha256=a['native_sha256'],native_cases=180,native_instruction_addresses=a['native_instruction_addresses'],actual_cpu_rsqrt_operations=a['actual_cpu_rsqrt_operations'],focused_core_tests_passed=2,prior_native_binding_profiles=72,focused_client_tests_passed=4,native_client_pose_profiles=45,native_client_owner_end_frames=50,full_suites_rerun=False,graphical_client_rebuilt=False,current_runtime_capture=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings']+['Annie projection now consumes native moving position directly, preserving exact words instead of divide20/multiply20 round-trip.','Native motion direction retained and passed to provider orientation gate; initial factory flags0 use native constructor matrix.','Client pose bridge compared to45 live original composition profiles, plus50 owner-end frames and resource release controls.'],adapters=a['adapters'],limits=a['limits']+['Rust composition test uses original before-state for final owner phase; complete bound-wrapper scheduling and property updates are not ported as a single full frame.','Client connects finite pose/orientation subset, not primary/secondary owner status or deferred callback queues. Initial flags0 are verified; later flag producers still open.','Network disappearance supplies end trigger; bone launch, target acquisition, weak ownership, ordinary source timing and registry scheduling remain unqualified.','New source differs from current v18 executable; graphical rebuild and current captures pending.','Zero accepted domains; all24domains114tasks retained.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-native-pose-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_pose_consumer_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,annie_native_pose_cases=180,annie_native_pose_focused_core_tests=2,annie_native_pose_focused_client_tests=4,annie_source_matches_graphical_binary=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Pose native raccordée à Annie</h2><p>180 compositions natives et72 liaisons contrôlées en core ;45 poses originales et50 frames de fin de vie contrôlées dans le client. Position transmise sans conversion aller-retour. Nouveau build et qualification graphique encore ouverts.</p><a href="annie_native_pose_consumer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
