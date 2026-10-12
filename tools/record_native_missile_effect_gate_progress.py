from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_impact_effect_gate_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/missile_impact_effect_gate_contract.json');assert a['passed'] and len(a['cases'])==48
log='logs/native-missile-impact-effect-gate-tests.log';assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Qualifier la création d’effet de la branche d’impact et le contexte751BE0, puis la copie de position vers le propriétaire10B0D20 et le rendu normal ; poursuivre les collisions, scale/alpha/récepteurs terrain et les24domaines.'
files=['data/4.20/missile_impact_effect_gate_contract.json','tools/probe_native_missile_impact_effect_gate.py','crates/core/src/native_missile_impact.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],effect_gate_cases=48,native_instruction_addresses=36,focused_core_tests_passed=2,filtered_core_tests=598,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings']+['Rust selects none/hit-branch/after-request using native raw fields;48original routes match. The192impact-callback cases still pass in the same module run.','HaveHitEffect andHaveAfterEffect are independent activation bits. Merely finding a named texture/Troy does not authorize automatic effect emission.'],adapters=a['adapters'],limits=a['limits']+['Fixture key point_flag is a synthetic label for raw SpellData37D bit2; it is not HavePointEffect. Native HavePointEffect is inner34C bit2, outer380 bit2. Raw gate property semantic name remains unqualified.','Hit branch effects, downstream751BE0 creation and other76F0D0 behavior remain unqualified.','Core-only; no client rebuild or live rendering. Two focused tests,598filtered;24domains114tasks retained,zero domains closed.'],next_action=next_action)

(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-impact-effect-gate-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_impact_effect_gate_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_impact_effect_gate_cases=48,native_missile_impact_focused_tests=2,native_missile_owner_live_bound=False)
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
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Projectile ciblé d’Annie</h2><p>Activation des effets d’impact :48branches natives comparées en Rust. Le rappel192cas reste conforme. Deux tests ciblés passent,598filtrés. Création complète d’effet, suppression et rendu normal restent ouverts.</p><a href="native_missile_impact_effect_gate_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,effect_gate_cases=48,complete=False)))

