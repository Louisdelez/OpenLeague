from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();receipt='docs/annie_spatial_selection_runtime_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
exe=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();backends={};files=['logs/annie-spatial-selection-client-build.log','logs/annie-spatial-selection-client-tests.log']
for backend in ['dx12','vulkan']:
 cap=f'docs/projected_core_cycle_capture_v23_spatial_{backend}.json';pair=f'docs/projected_pair_control_v23_spatial_{backend}.json';c=load(cap);p=load(pair)
 assert c['client_sha256']==exe and p['same_frame_attribution_gate_passed'] and p['strict_baseline_equal']
 assert not p['diagnostic_no_gamma'] and not p['diagnostic_no_msaa']
 assert len(c['measurements'])==2
 for i,m in enumerate(c['measurements'],1):assert m['native_spatial_selection_binding'] and m['spawned']==i and m['cleaned']==i and m['active_effects']==0 and m['active_draws']==0
 backends[backend]=dict(casts=2,cleaned=2,remaining_effects=0,baseline_frames=p['baseline']['frames'],attribution_passed=True,visual_inspection='Both casts, cleanup and second-entity paired on/off inspected. Warm ground contribution present only with projection; separate red Q particles persist independently at cleanup.')
 files.extend([cap,pair]);files.extend(x['path'] for x in c['captures']);files.extend(k for k in p['artifacts_sha256'] if k.endswith('.png'))
next_action='Verifier graphiquement la sortie et le retour de la projection dans le champ camera, puis raccorder le comportement natif de pause/reprise hors champ et les producteurs FOW/equipe. Poursuivre les24domaines/114taches.'
proof=dict(updated_utc=stamp,passed=True,complete=False,client_sha256=exe,focused_client_tests_passed=7,backends=backends,visual_inspection_complete=True,limits=['Controlled local fixture starts level6 with cast readiness; normal progression not qualified.','Stable local effect identities/current-owner frame scheduling remain adapters.','Camera stationary in these captures; dynamic exit/reentry only covered by registry integration tests.','Root/team filtering disabled and native hidden-frame pause/resume remain open. No full Q or game acceptance.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in dict.fromkeys(files)},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
p=r/'docs/annie_spatial_selection_progress.json';d=load(str(p.relative_to(r)));d.update(build_complete=True,graphical_validation=True,graphical_validation_scope='Two stationary-camera casts per DX12/Vulkan; no dynamic camera exit/reentry',runtime_receipt=receipt,next_action=next_action);p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-spatial-runtime-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=stamp,annie_spatial_selection_runtime_progress=receipt)
 changes=dict(annie_spatial_selection_client_tests=7,annie_spatial_selection_graphically_verified=True,annie_spatial_selection_dynamic_camera_verified=False,annie_spatial_selection_exe_sha256=exe)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action);d.pop('active_graphical_build',None);d.pop('active_graphical_capture',None)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Activation spatiale : captures DX12 et Vulkan</h2><p>Deux sorts affiches et nettoyes par moteur graphique. Attribution de pixels et inspection des images terminees. Camera en mouvement, pause/reprise et FOW restent ouverts.</p><a href="annie_spatial_selection_runtime_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,exe)
