from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_motion_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_motion_contract.json');assert a['passed'] and len(a['cases'])==72
log='logs/native-missile-motion-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier les séquences de déplacement avec cible mobile et franchissement de fin de course, puis la copie de position vers le propriétaire10B0D20 et le rendu normal ; poursuivre scale/alpha/récepteurs terrain et les24domaines.'
files=['data/4.20/missile_motion_contract.json','tools/probe_native_missile_motion.py','crates/core/src/native_missile_motion.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],motion_cases=72,actual_cpu_rsqrt_operations=216,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,filtered_core_tests=595,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Whole75F130 follows valid target position or stored fallback, adds height100, normalizes direction, scales horizontal speed1400 and advances moving position544 by frame delta.','72original executions and Rust outputs match direction/moving position/target raw words; zero acceleration/gravity/travel time, unobstructed terrain.','Physical CPU supplies216RSQRTSS operands; native66D6E0/75EF50/75EC90/75F840/5F76F0 execute.','First Rust comparison detected stale emulator code-cache for target validity; changed provider to read data memory, reran all72cases successfully.'],adapters=a['adapters'],limits=['Clock and target validity/radius explicitly supplied; terrain query returns unobstructed and finite classification is adapted.','Target motion across frames, collision geometry, positive travel time/acceleration, end crossing/lifecycle and current-position copy remain unqualified.','No client rebuild, live binding, GPU/audio or full-suite qualification.','One focused Cargo test;595filtered.24domains114tasks retained; zero domains closed.'],next_action=next_action)

(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-motion-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_motion_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_motion_cases=72,native_missile_motion_focused_tests=1,native_missile_owner_live_bound=False)
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
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>Déplacement natif75F130 porté en Rust :72cas en terrain libre comparés bit à bit,216RSQRTSS CPU. Un test ciblé passe,595filtrés. Cible mobile, collision, fin de course et rendu normal restent ouverts.</p><a href="native_missile_motion_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,motion_cases=72,complete=False)))
