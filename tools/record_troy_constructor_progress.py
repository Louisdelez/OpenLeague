from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_troy_constructor_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/troy_constructor_contract.json');assert a['passed'] and len(a['cases'])==36
log='logs/native-troy-constructor-tests.log';assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier les changements de drapeaux Troy pendant le chargement des ressources du projectile, puis raccorder sa pose et son cycle de vie au rendu ; poursuivre les 24 domaines.'
files=['data/4.20/troy_constructor_contract.json','tools/probe_native_troy_constructor.py','crates/core/src/native_effect_live_creation.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=36,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=2,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings']+['Rust Troy::default now uses verified constructor values. Existing192 factory cases explicitly preserve their supplied synthetic initial state; both regressions pass.'],adapters=a['adapters'],limits=a['limits']+['No client consumer currently instantiates this Troy model; graphical behavior unchanged by this core correction.','Full objective remains incomplete, zero domains accepted.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('troy-constructor-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_constructor_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,native_troy_constructor_cases=36,native_troy_constructor_focused_tests=2)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Création native des effets Troy</h2><p>36 exécutions du constructeur original : drapeaux nuls, échelles à 1, matrice identité. Valeurs par défaut Rust corrigées, avec régression des 192 cas de fabrique conservée. Drapeaux après chargement et rendu encore à qualifier.</p><a href="native_troy_constructor_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
