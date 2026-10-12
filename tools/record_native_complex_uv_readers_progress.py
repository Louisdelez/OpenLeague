from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_uv_readers_progress.json';log='logs/native-complex-uv-readers-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 490 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_uv_readers_contract.json');assert len(native['cases'])==256
next_action='Achever les échantillonnages UV à la naissance, la modulation de couleur par distance, les mises à jour mouvement/surface et les transformations propriétaires ; intégrer les 52 groupes et 244 placements Map10 au rendu, reconstruire les applications et poursuivre les 24 domaines.'
files=['data/4.20/complex_uv_readers_contract.json','tools/probe_native_complex_uv_readers.py','tools/check_scale_sse_cpu.py','crates/core/src/native_complex_uv_parameters.rs','crates/core/src/lib.rs',log]
executables=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
files.append(str(max(executables,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':490,'native_uv_reader_cases':256,'actual_map_uv_field_cases':216,'actual_map_independent_uv_fields':108,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original e-uvoffset/e-uvoffset-mult and p-uvscroll-rgb/p-uvscroll-rgb-mult caller fragments pass default[0,0].256cases include216Map10reads with legal zero/one prior table. Full2Dfield reader,256-sample baker, axis probabilities and caller fallback execute.','Rust four-parameter configuration matches table bits and probability objects in all256cases. Missing fields retain onezero pair and null probability pointers.','Independent current27Map10groups reproduce108UVfield configurations matching native outputs. No birth/runtime probability consumer or renderer binding is implied.'],'adapters':native['adapters'],'limits':native['limits']+['490core source tests passed. Ordinary graphical applications not rebuilt; GPU/material/texture binding and whole particle lifecycle incomplete.','No domain/complete champion kit, full map, six graphical clients or final game/package qualified.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-uv-readers-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_uv_readers_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=490,core_source_tests_passed=490,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=490,latest_native_execution_progress=receipt,complex_uv_reader_cases=256,actual_map_uv_field_cases=216,actual_map_independent_uv_fields=108,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=490;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('488 tests moteur','490 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-uv-readers"><h2>Lecture des paramètres UV</h2><p>256 lectures natives comparées et 108 champs UV actuels vérifiés. 490 tests moteur passent. Les tirages UV à la naissance, le cycle complet et le raccordement graphique restent à terminer.</p><a href="native_complex_uv_readers_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-uv-readers">.*?</section>',section,s,flags=re.S) if 'id="native-complex-uv-readers"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':490,'complete':False}))
