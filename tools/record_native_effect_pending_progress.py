from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_effect_pending_creation_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/impact_effect_factory_pending_contract.json');assert a['passed'] and len(a['cases'])==192
log='logs/native-effect-pending-creation-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier la fabrique751BE0 avec effet actif et orientation non nulle, puis la copie de position vers le propriétaire10B0D20 et le rendu normal ; poursuivre les ressources/alias, collisions, scale/alpha/récepteurs terrain et les24domaines.'
files=['data/4.20/impact_effect_factory_pending_contract.json','tools/probe_native_impact_effect_factory_pending.py','crates/core/src/native_effect_pending_creation.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],pending_factory_cases=192,native_instruction_addresses=337,focused_core_tests_passed=1,filtered_core_tests=600,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Whole751BE0 orchestration executes with a supplied pending wrapper. Native6C9A90/6C9080/6C96F0, weak acquisition and unbound747BE0 remain original.','192profiles cover flags8/9/18/28/88/B8,source/secondarypositions,scalars180/140,actor present/absent. Rust matches pending flags144,scalar fields,secondary131/135/139,marker184 andflag130.','Initial resource position is passed to7172B0; secondary position is a separate field. This does not qualify the graphics/resource constructor.','Initial adapter failed to preserve EAX at security-cookie check; corrected before accepted native receipt.','One focused core test passes;600filtered, no new full-suite/client result.'],adapters=a['adapters'],limits=a['limits']+['Rust configuration is core-only, no resource allocation or live particle/audio creation.','24domains114tasks retained;zero domains closed.'],next_action=next_action)

(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('effect-pending-creation-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_effect_pending_creation_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_effect_pending_creation_cases=192,native_effect_pending_creation_focused_tests=1,native_missile_owner_live_bound=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15'] and receipt not in dom.setdefault('progress_evidence',[]):dom['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():
  s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>Fabrique native751BE0 :192configurations avant rattachement comparées en Rust. Un test ciblé passe,600filtrés. Résolution de ressource, effet actif, orientation et rendu normal restent ouverts.</p><a href="native_effect_pending_creation_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,pending_factory_cases=192,complete=False)))

