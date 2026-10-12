from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_impact_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_impact_callback_contract.json');assert a['passed'] and len(a['cases'])==192
log='logs/native-missile-impact-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier le consommateur d’impact76F0D0 et la copie de position vers le propriétaire10B0D20, puis raccorder au rendu normal ; poursuivre les collisions, scale/alpha/récepteurs terrain et les24domaines.'
files=['data/4.20/missile_impact_callback_contract.json','tools/probe_native_missile_impact_callback.py','crates/core/src/native_missile_impact.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],impact_callback_cases=192,actual_cpu_rsqrt_operations=144,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,filtered_core_tests=598,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Whole7631D0 invokes7647B0 and actual763740 no-bone target selection. Empty target span uses stored fallback; present target adds native target height.','Impact request76F0D0 receives normalized direction while body still has original direction and updated impact position. Only after request does7631D0 zero direction and returnfalse.','192original cases cover8direction profiles,3positions,present/absent targets,flags0/400 andheight0/100. Rust matches original position,direction,request and callback order.','One focused core test passed;598filtered. No full-suite/client/GPU/audio claim.'],adapters=a['adapters'],limits=a['limits']+['Rust port is core-only; consumer76F0D0, object deletion and live renderer binding remain incomplete.','24domains114tasks retained; zero domains closed.'],next_action=next_action)

(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-impact-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_impact_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_impact_cases=192,native_missile_impact_focused_tests=1,native_missile_owner_live_bound=False)
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
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>Rappel natif d’impact :192cas comparés en Rust,144RSQRTSS CPU. Position d’impact, direction normalisée transmise avant annulation et retourfalse conformes. Un test ciblé passe,598filtrés. Consommateur d’effet, suppression et rendu normal restent ouverts.</p><a href="native_missile_impact_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,impact_cases=192,complete=False)))

