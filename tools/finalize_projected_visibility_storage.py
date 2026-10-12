from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat();log='logs/projected-visibility-storage-tests.log';result=(r/log).read_text(encoding='utf-8-sig');m=re.search(r'test result: ok\. (\d+) passed; 0 failed;',result);assert m
assert 'projected_visibility_storage_is_deferred_reused_and_expired_without_allocation ... ok' in result
receipt='docs/projected_visibility_storage_progress.json'
next_action='Raccorder native_troy_frame_gate/reset/resume/timing/tail au cycle Projected. Le stockage peut maintenant etre suspendu via pause_for_visibility et reacquis lors de emission ; ne pas remplacer les transitions par un simple masquage. Verifier les sequences visibles/hors champ/reprise et le rendu DX12/Vulkan, puis poursuivre les24domaines/114taches.'
files=['crates/client/src/native_projected_cycle.rs','crates/core/src/native_troy_reset.rs','crates/core/src/native_simple_storage.rs',log]
proof=dict(updated_utc=stamp,passed=True,complete=False,focused_client_tests_passed=int(m[1]),pause_storage_bridge_implemented=True,acquisition_bridge_implemented=True,live_hidden_frame_corrected=False,graphical_build_current=False,findings=['93EF80 SimpleChild mapping: emitted D4, emission timestamp D8, last update DC, storage handle C.','Pause defers owned storage and birth arrays; second pause does not duplicate deferred storage.','Eligible single1/rate1 emission reuses native_simple_storage::acquire; expired emission leaves storage absent.','Cycle now accepts absent storage instead of rejecting the native expired state.'],limits=['Projected constant single1/rate1 profile with local storage handle1/context0; unsupported profiles remain rejected at construction.','New integration test composes separately qualified reset/storage/emission contracts, not a new full native execution oracle.','Parent visibility gate and clock offset transitions not wired into normal lifetime yet; offscreen mismatch remains open.','No new graphical executable/captures; prior v23 evidence retains its original scope.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');h=r/'docs/plan_history'/('projected-visibility-storage-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,projected_visibility_storage_progress=receipt)
 changes=dict(projected_visibility_storage_tests=int(m[1]),projected_visibility_storage_bridge=True,annie_hidden_frame_mismatch_open=True)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);p.write_text(p.read_text(encoding='utf-8').replace('</body>','<section><h2>Stockage des particules hors champ</h2><p>Suspension, mise en attente, reutilisation et expiration sans allocation verifiees dans le cycle Projected. Decisions du parent et rendu dynamique restent a raccorder.</p><a href="projected_visibility_storage_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt,int(m[1]))
