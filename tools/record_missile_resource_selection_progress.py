from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_resource_selection_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_resource_selection_contract.json');assert a['passed'] and len(a['cases'])==192
log='logs/native-missile-resource-selection-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier les drapeaux Troy issus de la création7172B0 du projectile (flags0), raccorder la pose propriétaire et les variantes/skins au rendu ; poursuivre les24domaines.'
files=['data/4.20/missile_resource_selection_contract.json','tools/probe_native_missile_resource_selection.py','crates/core/src/native_missile_resource_selection.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=192,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Native763536 resource selection matches Rust across192profiles: default/own/enemy name precedes skin alias resolution.','Count-positive/local-player-ID route selects own variant; otherwise differing teams select enemy variant when available; default name is fallback.','Native7172B0 constructor request receives flags0 on projectile route. Generic751BE0 flags8 assumptions cannot be applied to this creation path without qualification.'],adapters=a['adapters'],limits=a['limits']+['Core-only; actual variant/package/skin loading and owner orientation flags remain incomplete.','No full-suite/client/runtime qualification; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-resource-selection-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_resource_selection_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,native_missile_resource_selection_cases=192,native_missile_resource_selection_focused_tests=1)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Variantes natives des effets du projectile</h2><p>192sélections natives de variante comparées en Rust. Création du projectile avec flags0, distincte de la fabrique générique. Raccordement des ressources et orientation encore ouverts.</p><a href="native_missile_resource_selection_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
