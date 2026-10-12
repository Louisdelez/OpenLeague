from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_lifetime_color_progress.json';log='logs/native-complex-lifetime-color-core-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 482 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
reader=load('data/4.20/complex_lifetime_color_contract.json');update=load('data/4.20/complex_lifetime_color_update_contract.json');assert len(reader['cases'])==66 and len(update['cases'])==864
next_action='Achever la modulation de couleur par distance, les corps de mise à jour mouvement/surface et les transformations propriétaires ; intégrer les52groupes/244placements Map10 au rendu, reconstruire les applications et poursuivre les24domaines.'
files=['data/4.20/complex_lifetime_color_contract.json','data/4.20/complex_lifetime_color_update_contract.json','tools/probe_native_complex_lifetime_color.py','tools/probe_native_complex_lifetime_color_update.py','crates/core/src/native_complex_color.rs','crates/core/src/native_color_consumers.rs',log]
exe=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
if exe:files.append(str(max(exe,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':reader['native_sha256'],'core_tests_passed':482,'native_lifetime_color_reader_cases':66,'actual_map_lifetime_color_groups':27,'native_lifetime_color_update_cases':864,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original9151F6..915271caller reads p-xrgba with default[1,1,1,1] into field340. Full reader/baker/probabilities and missing fallback captured in66cases including27Map10groups with prior zero/one table.','Rust from_lifetime_group matches all66native caller results and independently reads actual27currentMap10resource groups. Fallback preserves null probability pointers.','update_lifetime_color composes configuration with individual-age/sample/RNG/stored-birth multiplication.864native composed updates match exact color bits and all55RNGwords; birth RGBA remains unchanged.'],'limits':reader['limits']+update['limits']+['482core source tests passed. Reader and first update stage are qualified; distance modulation, full material/color update and whole lifecycle still incomplete.','No ordinary graphical application rebuild/visual acceptance, completed map, champion kit, domain, six-client match or delivery.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-lifetime-color-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_lifetime_color_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=482,core_source_tests_passed=482,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=482,latest_native_execution_progress=receipt,complex_lifetime_color_reader_cases=66,actual_map_lifetime_color_groups=27,complex_lifetime_color_update_cases=864,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=482;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('479 tests moteur','482 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-lifetime-color"><h2>Courbes p-xrgba des particules</h2><p>66 lecteurs natifs et27groupes actuels vérifiés ;864 mises à jour composées comparées.482 tests moteur passent. Modulation par distance, cycle complet et intégration graphique restent à terminer.</p><a href="native_complex_lifetime_color_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-lifetime-color">.*?</section>',section,s,flags=re.S) if 'id="native-complex-lifetime-color"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':482,'complete':False}))
