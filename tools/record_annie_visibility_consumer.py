from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 7 passed;' in (r/'logs/annie-visibility-client-tests.log').read_text(encoding='utf-8-sig')
receipt='docs/annie_visibility_consumer_progress.json';next_action='Terminer la reconstruction du client puis qualifier deux tirs/activation/suppression/nettoyage en DX12 et Vulkan ; poursuivre l’ordonnancement masqué, les appelants natifs et producteurs équipe/FOW, puis les24domaines/114tâches.'
files=['data/4.20/projectile_visibility_activation_contract.json','data/4.20/projectile_team_visibility_contract.json','crates/client/src/projected_live.rs','crates/core/src/native_projectile_owner_properties.rs','crates/core/src/native_troy_frame_gate.rs','logs/annie-visibility-client-tests.log','tools/capture_projected_core_cycle_v22_visibility_dx12.py','tools/capture_projected_core_cycle_v22_visibility_vulkan.py','tools/analyze_annie_visibility_pair.py']
proof=dict(updated_utc=now,complete=False,passed=True,status='client_tests_passed_graphical_build_running',native_activation_sequences=48,focused_client_tests_passed=7,full_suites_rerun=False,visibility_source_integrated=True,graphical_client_rebuilt=False,current_runtime_capture=False,build_session_id=int(sys.argv[1]),previous_client_sha256=sha('target/debug/openleague-client.exe'),artifacts_sha256={p:sha(p) for p in files},limits=['Source tests qualify48original activation/deactivation sequences and six prior lifecycle/pose/scale/cleanup regressions.','Local creation invokes the native activation port; original registry caller and frame ordering remain unqualified.','Native source suppression predicate controls the mesh footprint; Bevy supplies camera culling. Native frustum producer and hidden-frame skip/pause/resume simulation remain open.','Local root filter is explicitly disabled; native team/FOW filter producers and visibility rasterization remain open.','No graphical build/capture completion or full-game acceptance claimed; previous v21 executable remains historical evidence until build and captures finish.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-visibility-consumer-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,annie_visibility_consumer_progress=receipt)
 changes=dict(annie_visibility_client_tests=7,annie_visibility_activation_sequences=48,annie_visibility_source_integrated=True,annie_source_matches_graphical_binary=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action,active_graphical_build=dict(session_id=int(sys.argv[1]),log='logs/annie-visibility-client-build.log',consumer_progress=receipt))
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Activation et suppression dans le client Annie</h2><p>Sept tests ciblés réussis, dont48séquences natives. La source active la projection et le drapeau natif peut masquer son empreinte. Reconstruction graphique en cours ; contrôles DX12/Vulkan à refaire. Producteurs équipe/FOW, appelants et ordonnanceur masqué encore ouverts.</p><a href="annie_visibility_consumer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
