from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 1 passed;' in (r/'logs/entity-visibility-merge-tests.log').read_text(encoding='utf-8-sig')
a=load('data/4.20/entity_visibility_merge_contract.json');assert len(a['cases'])==576
receipt='docs/entity_visibility_merge_progress.json';next_action='Composer le volume caméra natif déjà qualifié avec la requête spatiale95EBA0/9601C0, puis raccorder les transitions de visibilité71A785 au client ; poursuivre les producteurs équipe/FOW et les24domaines/114tâches.'
files=['tools/probe_native_entity_visibility_merge.py','data/4.20/entity_visibility_merge_contract.json','crates/core/src/entity_visibility_merge.rs','crates/core/src/lib.rs','logs/entity-visibility-merge-tests.log']
proof=dict(updated_utc=now,passed=True,complete=False,native_sha256=a['native_sha256'],native_cases=576,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,full_suites_rerun=False,client_registry_visibility_integrated=False,current_runtime_capture=False,findings=a['findings'],adapters=a['adapters'],limits=a['limits']+['Camera builder9863A0 already has480isolated reference cases in camera_culling_contract.json; composition into this spatial query/merge remains open.','Previous v22 runtime evidence retains its original executable hash and scope; this new module is not connected to the client.'],artifacts_sha256={p:sha(p) for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('entity-visibility-merge-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,entity_visibility_merge_progress=receipt)
 changes=dict(entity_visibility_merge_cases=576,entity_visibility_merge_core_tests=1,entity_visibility_merge_runtime_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Transitions natives des listes de visibilité</h2><p>576cas natifs vérifiés et port Rust testé : entrées nouvelles activées, entrées sorties désactivées, éléments inchangés conservés. Filtres activité/type200, éléments absents et doublons couverts. Requête spatiale et raccordement au client encore ouverts.</p><a href="entity_visibility_merge_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
