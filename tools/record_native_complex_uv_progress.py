from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_uv_progress.json';log='logs/native-complex-uv-scroll-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 488 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_uv_update_contract.json');assert len(native['cases'])==512 and len(native['flag_cases'])==64
next_action='Achever les lecteurs et échantillonnages des UV, la modulation de couleur par distance, les mises à jour mouvement/surface et les transformations propriétaires ; intégrer les 52 groupes et 244 placements Map10 au rendu, reconstruire les applications et poursuivre les 24 domaines.'
files=['data/4.20/complex_uv_update_contract.json','tools/probe_native_complex_uv_update.py','tools/check_scale_sse_cpu.py','crates/core/src/native_complex_uv_scroll.rs','crates/core/src/lib.rs',log]
executables=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
files.append(str(max(executables,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':488,'native_uv_update_cases':512,'native_uv_flag_write_cases':64,'actual_map_unclamped_groups':27,'emulator_cpu_disagreements':native['emulator_cpu_disagreements'],'actual_cpu_arithmetic_instructions':4096,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original939DBE..939F75 applies distinct stored RGB/multiplicative RGB origins and rates to elapsed particle time. Flags2/4 select ordered[-1,1] clamp or signed fractional part through original CRT.','Native raw bool packing preserves other bits and uses low bit, not raw byte!=0. All64captured flag updates match. Actual27Map10groups have both clamp fields absent and use defaultzero.','512updates match real processor MULSS/ADDSS plus original CRT fractional outputs, retaining negative zero, infinities and NaN. Original emulated outputs and16NaN payload disagreements retained separately. Stored UV origins/rates remain unchanged.'],'adapters':native['adapters']+['CRT thread-context getterCA91A9 supplies legal zeroed per-thread errno storage. Native math/error handling executes; Windows TLS/runtime initialization itself is not qualified.'],'limits':native['limits']+['Ordinary applications are not rebuilt and this port has no visual acceptance. UV rate/offset readers, birth sampling, owner/material/texture binding, full lifecycle and rendering remain incomplete.','0 domains/0 champion kits closed; whole map, six graphical clients, full game and installer remain unqualified.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-uv-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_uv_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=488,core_source_tests_passed=488,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=488,latest_native_execution_progress=receipt,complex_uv_update_cases=512,complex_uv_flag_write_cases=64,actual_map_unclamped_groups=27,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=488;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('485 tests moteur','488 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-uv"><h2>Défilement UV des particules</h2><p>512 mises à jour et 64 combinaisons de drapeaux comparées au calcul natif ; 27 groupes de la carte utilisent la répétition. 488 tests moteur passent. Les lecteurs UV, le cycle complet et le raccordement graphique restent à terminer.</p><a href="native_complex_uv_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-uv">.*?</section>',section,s,flags=re.S) if 'id="native-complex-uv"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':488,'complete':False}))
