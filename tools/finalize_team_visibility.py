from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 4 passed;' in (r/'logs/native-projectile-team-visibility-tests.log').read_text(encoding='utf-8-sig')
a=load('data/4.20/projectile_team_visibility_contract.json');b=load('data/4.20/projectile_visibility_activation_contract.json');assert len(a['cases'])==192 and len(b['cases'])==48
receipt='docs/native_projectile_team_visibility_progress.json';next_action='Porter la séquence native d’activation/désactivation et raccorder la suppression de visibilité au client Annie ; qualifier les appelants, l’ordonnancement et les producteurs équipe/FOW, puis poursuivre les24domaines/114tâches.'
files=['tools/probe_native_projectile_team_visibility.py','tools/probe_native_projectile_visibility_activation.py','data/4.20/projectile_team_visibility_contract.json','data/4.20/projectile_visibility_activation_contract.json','crates/core/src/native_projectile_owner_properties.rs','logs/native-projectile-team-visibility-tests.log']
proof=dict(updated_utc=now,passed=True,complete=False,native_sha256=a['native_sha256'],native_team_cases=192,native_activation_sequences=48,focused_core_tests_passed=4,full_suites_rerun=False,client_visibility_integrated=False,current_runtime_capture=False,findings=a['findings']+b['findings'],adapters=a['adapters']+b['adapters'],limits=a['limits']+b['limits'],artifacts_sha256={p:sha(p) for p in files},next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('team-visibility-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;d=load('docs/'+name);shutil.copy2(p,h/name);d.update(updated_utc=now,native_projectile_team_visibility_progress=receipt)
 changes=dict(native_projectile_team_visibility_cases=192,native_projectile_visibility_activation_sequences=48,native_projectile_team_visibility_core_tests=4,native_projectile_visibility_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Visibilité par équipe et activation</h2><p>Callback natif6CA0A0 vérifié sur192cas et porté en Rust ; quatre tests ciblés réussis.48séquences natives confirment chargement12C=1, activation158=1 avec mise à jour immédiate, puis désactivation158=0 appliquée à la mise à jour suivante. Les appelants, le raccordement graphique et les producteurs équipe/FOW restent à qualifier.</p><a href="native_projectile_team_visibility_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
