from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_uv_birth_progress.json';log='logs/native-complex-uv-birth-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 491 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_uv_birth_contract.json');assert len(native['cases'])==528 and len(native['profiles'])==33
next_action='Achever le transfert des UV et autres attributs de naissance vers les buffers de particules, la modulation de couleur par distance, les mises à jour mouvement/surface et les transformations propriétaires ; intégrer les 52 groupes et 244 placements Map10 au rendu, reconstruire les applications et poursuivre les 24 domaines.'
files=['data/4.20/complex_uv_birth_contract.json','tools/probe_native_complex_uv_birth.py','data/4.20/complex_uv_readers_contract.json','data/4.20/probability_curve_contract.json','crates/core/src/native_random.rs','crates/core/src/native_complex_uv_parameters.rs','crates/core/src/lib.rs',log]
executables=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
files.append(str(max(executables,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':491,'native_uv_birth_cases':528,'native_uv_birth_profiles':33,'actual_map_uv_birth_profiles':27,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original9360D8..9361FAproduces one stored f32 fraction. Four936C95..936D6EUVcalls share its address for all8axis evaluations, making no additional RNGdraws.','528composed fragment cases across33profiles, including27Map10groups and generic probability curves. Native949680selects tables and evaluates provided shared parameter; original output bits/full55RNGstates captured.','Rust sample_birth returns immutable origin/rate pairs from four qualified configurations.528results and RNGstates match; shared fraction belongs to caller and remains available to other birth consumers.'],'adapters':native['adapters'],'limits':native['limits']+['491core source tests passed; no ordinary graphical app rebuild/visual acceptance. No whole birth sequence, complete map, champion kit, domain or final game/package qualified.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-uv-birth-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_uv_birth_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=491,core_source_tests_passed=491,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=491,latest_native_execution_progress=receipt,complex_uv_birth_cases=528,complex_uv_birth_profiles=33,actual_map_uv_birth_profiles=27,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=491;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('490 tests moteur','491 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-uv-birth"><h2>Tirage partagé des UV à la naissance</h2><p>528 cas et 27 groupes actuels comparés aux fragments natifs. Un seul nombre aléatoire partagé par les quatre paramètres UV. 491 tests moteur passent. Le transfert vers les buffers, le cycle complet et le rendu restent à terminer.</p><a href="native_complex_uv_birth_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-uv-birth">.*?</section>',section,s,flags=re.S) if 'id="native-complex-uv-birth"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':491,'complete':False}))
