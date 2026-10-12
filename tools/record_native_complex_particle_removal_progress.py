from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_particle_removal_progress.json';log='logs/native-complex-particle-removal-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 496 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_particle_removal_contract.json');assert native['passed'] and len(native['cases'])==360
files=['data/4.20/complex_particle_removal_contract.json','tools/probe_native_complex_particle_removal.py','crates/core/src/native_complex_particle_storage.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier les copies x87 non finies lors de la suppression, puis les ressources de traînée vivantes et leurs callbacks ; achever les sources de mouvement, transformations propriétaires et mises à jour mouvement/surface/couleur ; raccorder les 52 groupes et 244 placements Map10 au rendu et reconstruire les applications, puis poursuivre les 24 domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':496,'native_particle_removal_cases':360,'native_buffers':13,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole937F30 and93A7E0 captured: kinds0..11, all valid indices in1/4particles, empty/preallocated append capacity and0/1/4null trail slots.','Kinds4/5/9 shift particle attributes in order; other kinds swap the last particle. Rust matches all13active buffers and live count in360finite cases.','Live trail resource handles are rejected before mutation until release and owner-index callbacks are bound. Invalid indices return an error.'],'adapters':native['adapters'],'limits':native['limits']+['No domain or champion kit complete; source tests do not prove ordinary graphical integration or full game completion.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-particle-removal-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_particle_removal_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=496,core_source_tests_passed=496,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=496,latest_native_execution_progress=receipt,complex_particle_removal_cases=360,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=496;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('494 tests moteur','496 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-particle-removal"><h2>Suppression des particules</h2><p>360 cas natifs comparés aux 13 buffers Rust. Les types 4, 5 et 9 conservent leur ordre ; les autres remplacent la particule supprimée par la dernière. 496 tests moteur passent. Les traînées vivantes, les copies non finies et le raccordement graphique restent à qualifier.</p><a href="native_complex_particle_removal_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':496,'native_cases':360,'complete':False}))
