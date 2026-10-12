from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 2 passed;' in (r/'logs/spatial-visibility-root-tests.log').read_text(encoding='utf-8-sig')
a=load('data/4.20/spatial_visibility_root_contract.json');b=load('data/4.20/spatial_visibility_grid_contract.json');assert len(a['cases'])==768 and len(b['cases'])==324
receipt='docs/spatial_visibility_root_progress.json';next_action='Porter la conversion grille95EBA0 vérifiée sur324cas, puis composer caméra9863A0, sélection95EE00, requête9601C0 et tri vers les transitions71A785 ; intégrer au client et poursuivre les24domaines/114tâches.'
files=['tools/probe_native_spatial_visibility_root.py','tools/probe_native_spatial_visibility_grid.py','data/4.20/spatial_visibility_root_contract.json','data/4.20/spatial_visibility_grid_contract.json','crates/core/src/spatial_visibility_root.rs','crates/core/src/lib.rs','logs/spatial-visibility-root-tests.log']
proof=dict(updated_utc=now,passed=True,complete=False,native_sha256=a['native_sha256'],native_root_cases=768,native_grid_cases=324,grid_rust_port_complete=False,focused_core_tests_passed=2,spatial_query_regression_cases=108,full_suites_rerun=False,client_spatial_visibility_integrated=False,current_runtime_capture=False,findings=a['findings']+b['findings'],adapters=a['adapters']+b['adapters'],limits=['Root selection port matches768original cases; existing recursive query regression108cases passes.','Grid conversion has324native finite reference cases, but no Rust consumer yet.','Camera/root/grid/query/merge composition and tree construction/maintenance remain open.','Nonfinite grid values, alternate FP modes and legacy CRT paths remain unqualified.','Previous v22 graphical captures retain their original executable/scope; no new graphical build or full-game acceptance.'],artifacts_sha256={p:sha(p) for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('spatial-visibility-root-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,spatial_visibility_root_progress=receipt)
 changes=dict(spatial_visibility_root_cases=768,spatial_visibility_grid_native_cases=324,spatial_visibility_root_core_tests=2,spatial_visibility_root_runtime_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Racine spatiale et coordonnées de grille</h2><p>Sélection de racine portée et vérifiée sur768cas ; régression du parcours108cas réussie. Conversion des bornes enregistrée sur324cas natifs, port Rust encore à faire. Composition avec caméra et intégration au client restent ouvertes.</p><a href="spatial_visibility_root_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
