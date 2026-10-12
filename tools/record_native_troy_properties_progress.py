from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_properties_progress.json';log='logs/native-troy-properties-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 505 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_properties_contract.json');assert native['passed'] and len(native['cases'])==428
files=['data/4.20/troy_properties_contract.json','tools/probe_native_troy_properties.py','crates/core/src/native_troy_properties.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever les phases suivantes du cycle Troy : reset200, carte audio8000, flag enfant10000, pose propriétaire et reset final des requêtes ; qualifier les producteurs des coefficients et raccorder le cycle complet au rendu normal des52groupes/244placements Map10, reconstruire les applications puis poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':505,'native_troy_properties_cases':428,'actual_cpu_sse_operations':native['actual_cpu_sse_operations'],'actual_cpu_x87_copies':native['actual_cpu_x87_copies'],'emulator_cpu_case_disagreements':native['emulator_cpu_case_disagreements'],'property_phase_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original94071E..9408E8 executes all property branches with whole93FB60/921EC0/8DE500/921F60 and concrete928AE0. Rust matches emitter fields, children and owner callback occurrence in428cases.','Activation ORs bit1; scalar raw BC/C0 retain signalingNaN, scalar C4 argument passes x87 quieting before remap. Color and matrix copies also quiet signalingNaN. Matrix indices12,13,14 zeroed after copy.','Visibility follows source flags bit80 and linked owner first, then request10 raw byte LSB; unrelated emitter flag bits preserved.','Unaligned wrapper2F/33/37 channels transfer raw. Position/bounds use the qualified native helper; direction transfer is raw. Requests remain unchanged in this phase.','1774actual scalar SSE operations and3062actualCPU x87 copies;168emulator discrepancies retained in separate captures.'],'adapters':native['adapters'],'limits':native['limits']+['504previous core tests and the new property comparison pass; this does not qualify complete game/champion kits or graphical rendering.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-properties-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_properties_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=505,core_source_tests_passed=505,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=505,latest_native_execution_progress=receipt,troy_properties_cases=428,troy_properties_actual_cpu_sse_operations=1774,troy_properties_actual_cpu_x87_copies=3062,troy_properties_ported=True,troy_properties_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=505;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('504 tests moteur','505 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-properties"><h2>Propriétés des effets Troy</h2><p>Phase94071E..9408E8 portée et comparée à428captures : activation, paramètres, visibilité, couleur, matrice, canaux, position/bornes et direction.1774opérations SSE et3062copies x87 vérifiées sur processeur réel.505tests moteur passent. Les phases suivantes et le raccordement graphique restent à qualifier.</p><a href="native_troy_properties_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':505,'native_cases':428,'complete':False}))
