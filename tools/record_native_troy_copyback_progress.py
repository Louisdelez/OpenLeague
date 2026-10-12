from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_copyback_progress.json';log='logs/native-troy-copyback-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 508 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_copyback_contract.json');assert native['passed'] and len(native['cases'])==512
files=['data/4.20/troy_copyback_contract.json','tools/probe_native_troy_copyback.py','crates/core/src/native_troy_copyback.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever le reste du cycle Troy : reset200, carte audio8000, flag enfant10000, activation et mises à jour des émetteurs ; qualifier les producteurs virtuels et les paramètres natifs, composer toutes les phases avec la copie finale et raccorder le cycle complet au rendu normal des52groupes/244placements Map10, reconstruire les applications puis poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':508,'native_troy_copyback_cases':512,'actual_cpu_sse_operations':native['actual_cpu_sse_operations'],'actual_cpu_x87_copies':native['actual_cpu_x87_copies'],'emulator_cpu_case_disagreements':native['emulator_cpu_case_disagreements'],'copyback_phase_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole940D19..940E83 captured in512cases; Rust matches all copied values, output flag bytes/config flags and complete request reset.', 'Source flags copy emitter70; channels, field80, position, colors and min/max bounds pass through x87 FLD/FSTP with signalingNaN quieting. Source58 is emitterC0 multiplied byBC using scalarSSE; source5C/60 copyC0/C4 through x87.', 'Native visibility is flags bit3, output bytes2D/2E/110 are bits1/4/2 respectively. Config flags copy raw1BC. Requests cleared only after all output copies.', '512actualCPU SSE operations and11776actualCPU x87 copies;480VM case differences retained separately. Rust matches CPU reference, not emulator signalingNaN behavior.'],'adapters':native['adapters'],'limits':native['limits']+['507previous core tests and the new property comparison pass; this does not qualify complete game/champion kits or graphical rendering.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-copyback-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_copyback_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=508,core_source_tests_passed=508,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=508,latest_native_execution_progress=receipt,troy_copyback_cases=512,troy_copyback_actual_cpu_sse_operations=512,troy_copyback_actual_cpu_x87_copies=11776,troy_copyback_ported=True,troy_copyback_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=508;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('507 tests moteur','508 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-copyback"><h2>Copie finale Troy</h2><p>Phase940D19..940E83 portée, comparée à512captures natives. Valeurs, flags, bornes et effacement final des requêtes correspondent.512opérations SSE et11776copies x87 vérifiées sur processeur réel.508tests moteur passent. Les autres phases et le raccordement graphique restent à qualifier.</p><a href="native_troy_copyback_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':508,'native_cases':512,'complete':False}))
