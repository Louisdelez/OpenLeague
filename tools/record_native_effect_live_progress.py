from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_effect_live_creation_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/impact_effect_factory_live_contract.json');assert a['passed'] and len(a['cases'])==192
log='logs/native-effect-live-creation-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier la résolution native des noms/alias et la copie de position du projectile vers son propriétaire10B0D20, puis raccorder les poses au rendu normal ; poursuivre collisions, scale/alpha/récepteurs terrain et les24domaines.'
files=['data/4.20/impact_effect_factory_live_contract.json','tools/probe_native_impact_effect_factory_live.py','crates/core/src/native_effect_live_creation.rs','crates/core/src/native_effect_pending_creation.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],live_factory_cases=192,native_instruction_addresses=950,actual_cpu_rsqrt_operations=288,focused_core_tests_passed=1,filtered_core_tests=601,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Whole751BE0 invokes concreteTroy10D6DB4 callbacks for flags,scalars,direction matrix and final scalar3C. Native weak acquisition handles live/expired linked objects.','192profiles cover flags8/18/28/88,sixdirections,scalars180/140,live/expiredTroy. Original6AB330/6AB520/8DE500 arithmetic and actualTroy54/9285B0 execute.','Rust matches flags24,dirty144,scalars148/5C/3C and all16matrix raw words. Impact direction matrix keeps world up and normalizes right/forward separately; not the projectile719D20 owner basis.','288physical CPU RSQRTSS operations. One focused core test passes;601filtered, no full-suite/client result.'],adapters=a['adapters'],limits=a['limits']+['Rust module is core-only. Linked nativeTroy memory callbacks do not prove rendered image or resource availability.','24domains114tasks retained;zero domains closed.'],next_action=next_action)

(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('effect-live-creation-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_effect_live_creation_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_effect_live_creation_cases=192,native_effect_live_creation_focused_tests=1,native_missile_owner_live_bound=False)
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
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>Fabrique native avec récepteur Troy :192cas, sixdirections et rattachement valide/expiré comparés en Rust.288RSQRTSS CPU. Un test ciblé passe,601filtrés. Résolution de ressource et rendu normal restent ouverts.</p><a href="native_effect_live_creation_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,live_factory_cases=192,complete=False)))

