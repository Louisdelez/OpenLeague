from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.isoformat()
log=r/'logs/spatial-visibility-composition-tests.log'
assert 'test result: ok. 5 passed;' in log.read_text(encoding='utf-8-sig')
receipt='docs/spatial_visibility_composition_progress.json'
next_action='Relier camÃ©ra9863A0, requÃªte spatiale Rust qualifiÃ©e sur120cas, tri natif et transitions71A785 ; intÃ©grer au client avec gestion des entitÃ©s, puis poursuivre les24domaines/114tÃ¢ches.'
files=['tools/probe_native_entity_visibility_sort.py','data/4.20/entity_visibility_sort_contract.json','crates/core/src/spatial_visibility.rs','crates/core/src/spatial_visibility_grid.rs','data/4.20/spatial_visibility_grid_contract.json','data/4.20/spatial_visibility_composition_contract.json','logs/spatial-visibility-composition-tests.log']
proof=dict(updated_utc=stamp,passed=True,complete=False,grid_rust_cases=324,composition_native_cases=120,native_sort_cases=50,composition_rust_verified=True,focused_tests_passed=5,client_integrated=False,full_suites_rerun=False,limits=['Finite coordinates under qualified SSE mode only.','Camera/tree maintenance/sort/visibility transitions and client integration remain open.','No new graphical build or full-game acceptance.'],artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('spatial-composition-'+now.strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=json.loads(p.read_text(encoding='utf-8-sig'));shutil.copy2(p,h/name);d.update(updated_utc=stamp,spatial_visibility_composition_progress=receipt)
 changes=dict(spatial_visibility_grid_rust_cases=324,spatial_visibility_composition_native_cases=120,spatial_visibility_composition_rust_cases=120,spatial_visibility_grid_runtime_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=stamp,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>RequÃªte spatiale composÃ©e Rust</h2><p>Composition Rust vÃ©rifiÃ©e sur 120 cas natifs ; rÃ©gressions grille 324, racine 768 et parcours 108 cas rÃ©ussies. CamÃ©ra, tri, transitions et intÃ©gration client Ã  poursuivre.</p><a href="spatial_visibility_composition_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
