from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();receipt='docs/annie_spatial_selection_progress.json'
assert 'test result: ok. 7 passed;' in (r/'logs/annie-spatial-selection-client-tests.log').read_text(encoding='utf-8-sig')
next_action='Verifier la compilation graphique session83529 puis executer les captures v23_spatial DX12/Vulkan et analyser les paires de pixels. Selection spatiale branchee sur projected_live ; ordonnancement natif complet et FOW restent ouverts. Poursuivre les24domaines/114taches.'
files=['crates/client/src/projected_live.rs','crates/client/src/main.rs','crates/client/src/effect_spatial_registry.rs','crates/client/src/camera_native.rs','logs/annie-spatial-selection-client-tests.log']
proof=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests_passed=7,spatial_selection_consumer_integrated=True,graphical_validation=False,build_session=83529,build_log='logs/annie-spatial-selection-client-build.log',limits=['Stable local effect identities and current-owner position/frame scheduling adapt original providers.','Native camera, group-vis bounds, tree ownership and visibility query/merge now drive activation; source suppression remains native.','Root/team filter disabled; FOW producers and hidden-frame pause/resume still unqualified.','No new graphical build/captures accepted yet.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');h=r/'docs/plan_history'/('annie-spatial-selection-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,annie_spatial_selection_progress=receipt)
 changes=dict(annie_spatial_selection_client_tests=7,annie_spatial_selection_integrated=True,annie_spatial_selection_graphically_verified=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action,active_graphical_build=dict(session_id=83529,log='logs/annie-spatial-selection-client-build.log'))
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Activation spatiale Annie</h2><p>Registre et volume camera raccordes aux effets ; sept regressions passent. Construction graphique et captures en cours de verification.</p><a href="annie_spatial_selection_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
