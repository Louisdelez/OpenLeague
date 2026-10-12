from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
log=(r/'logs/native-projectile-wrapper-visibility-tests.log').read_text(encoding='utf-8-sig');assert 'test result: ok. 3 passed;' in log
contract=load('data/4.20/projectile_wrapper_visibility_contract.json');assert len(contract['cases'])==32
receipt='docs/native_projectile_wrapper_visibility_progress.json'
next_action='Qualifier le callback de visibilité natif6CA0A0 et les producteurs des champs wrapper158/12C avant intégration au rendu d’Annie ; poursuivre les24domaines/114tâches.'
files=['tools/probe_native_projectile_wrapper_visibility.py','data/4.20/projectile_wrapper_visibility_contract.json','crates/core/src/native_projectile_owner_properties.rs','logs/native-projectile-wrapper-visibility-tests.log']
proof=dict(updated_utc=now,passed=True,complete=False,native_sha256=contract['native_sha256'],native_cases=32,native_instruction_addresses=contract['native_instruction_addresses'],focused_core_tests_passed=3,full_suites_rerun=False,client_visibility_integrated=False,current_runtime_capture=False,findings=contract['findings'],adapters=contract['adapters'],limits=contract['limits'],artifacts_sha256={p:sha(p) for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('wrapper-visibility-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,native_projectile_wrapper_visibility_progress=receipt)
 changes=dict(native_projectile_wrapper_visibility_cases=32,native_projectile_wrapper_visibility_core_tests=3,native_projectile_wrapper_visibility_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Visibilité des effets — suppression native</h2><p>32 profils natifs vérifiés, calcul de suppression porté en Rust et trois tests ciblés réussis. La valeur1 masque la projection ; les champs du constructeur et les fournisseurs de visibilité restent à qualifier avant raccordement au rendu. Aucun domaine clôturé.</p><a href="native_projectile_wrapper_visibility_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
