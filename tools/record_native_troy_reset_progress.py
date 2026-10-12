from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_reset_progress.json';log='logs/native-troy-reset-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 512 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier le caller reset200 et le préchauffage avec le reset porté, les émetteurs à la mort, la carte audio8000, le flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':512,'native_reset_cases':432,'actual_cpu_sse_operations':432,'actual_cpu_x87_copies':1296,'emulator_cpu_case_disagreements':192,'reset_without_death_emitters_ported':True,'death_emitters_supported':False,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole93E6F0 reset port matches432CPU-corrected native captures: audio release order, three clocks, x87 previous-position copies, flags, both child families, all13particle buffers and Simple retirement queue.','Concrete trail reference graphs and callback order match, including expired/null handles. Queued Simple resource destruction and actual audio endpoints remain adapters.','All Complex child configurations prevalidated before audio or state mutation; unsupported death emitters rejected explicitly.','Original caller9408E8 threshold at1138AC8 read as3DCCCCCD (0.1seconds); caller/prewarm still to qualify.'],'adapters':native['adapters'],'limits':native['limits']+['Full frame, graphical/audio integration and domain acceptance remain incomplete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-reset-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_reset_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=512,core_source_tests_passed=512,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=512,latest_native_execution_progress=receipt,troy_reset_cases=432,troy_reset_without_death_emitters_ported=True,troy_reset_death_emitters_supported=False,troy_reset_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=512;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('510 tests moteur','512 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-reset"><h2>Réinitialisation des effets Troy</h2><p>Fonction93E6F0 portée et comparée à432captures natives corrigées par le CPU réel : horloges, position, ordre audio, enfants Complex/Simple,13buffers, références et file de retrait.512tests moteur passent. Émetteurs à la mort, caller200, préchauffage et raccordement graphique/audio restent à qualifier.</p><a href="native_troy_reset_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':512,'native_cases':432,'complete':False}))
