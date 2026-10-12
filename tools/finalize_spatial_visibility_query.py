from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 1 passed;' in (r/'logs/spatial-visibility-query-tests.log').read_text(encoding='utf-8-sig')
a=load('data/4.20/spatial_visibility_query_contract.json');assert len(a['cases'])==108
receipt='docs/spatial_visibility_query_progress.json';next_action='Qualifier la sélection de racine95EE00 et la conversion des bornes95EBA0, composer le volume caméra puis la requête9601C0 et le tri vers les transitions71A785 ; intégrer au client et poursuivre les24domaines/114tâches.'
files=['tools/probe_native_spatial_visibility_query.py','data/4.20/spatial_visibility_query_contract.json','crates/core/src/spatial_visibility_query.rs','crates/core/src/native_troy_scratch.rs','crates/core/src/lib.rs','logs/spatial-visibility-query-tests.log']
proof=dict(updated_utc=now,passed=True,complete=False,native_sha256=a['native_sha256'],native_cases=108,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,full_suites_rerun=False,client_spatial_visibility_integrated=False,current_runtime_capture=False,findings=a['findings'],adapters=a['adapters'],limits=a['limits']+['Small finite axis-aligned planes and coordinates; broader numeric/oblique camera composition remains unqualified.','Previous v22 runtime captures retain their original executable and scope. No new graphical build claimed.'],artifacts_sha256={p:sha(p) for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('spatial-visibility-query-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,spatial_visibility_query_progress=receipt)
 changes=dict(spatial_visibility_query_cases=108,spatial_visibility_query_core_tests=1,spatial_visibility_query_runtime_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Requête spatiale de visibilité</h2><p>108configurations natives avec parcours récursif et tests de plans réels, comparées au port Rust. Sélection de racine, conversion des bornes, construction de l’arbre et raccordement caméra/client encore ouverts.</p><a href="spatial_visibility_query_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
