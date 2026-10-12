from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
age=load('data/4.20/complex_emitter_age_contract.json');birth=load('data/4.20/complex_birth_color_contract.json');log='logs/native-complex-age-core-tests.log'
assert age['passed'] and birth['passed'] and len(age['cases'])==3064 and len(birth['cases'])==312
assert '461 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_age_progress.json';next_action='Qualifier les sources e-period/e-active/lifetime et l’âge propre de chaque particule, puis les mises à jour couleur/pose ; compléter le cycle Complex et relier les52groupes Map10 et244placements au rendu. Âge émetteur et sa sélection de couleur de naissance sont portés et comparés aux fragments originaux. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
files=['data/4.20/complex_emitter_age_contract.json','data/4.20/complex_birth_color_contract.json','tools/probe_native_complex_age.py','tools/probe_native_complex_birth_color.py','crates/core/src/native_complex_age.rs','crates/core/src/native_color_consumers.rs','crates/core/src/lib.rs',log,'logs/native-complex-age-initial-failure.log','target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
proof={'updated_utc':now,'complete':False,'native_sha256':age['native_sha256'],'core_tests_passed':461,'last_client_tests_passed':364,'emitter_age_cases':3064,'composed_birth_color_cases':312,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Native duration selection uses ordered COMISS/JA followed by COMISS/CMOVBE; signed zeros and unordered comparisons are preserved. Age subtracts owner start then configured offset before division.','3064original emitter-age outputs match Rust bits, including zero/negative durations, infinity and NaN. Initial NaN payload mismatch was corrected by explicit native SSE operand priority/quieting; failure log retained.','312composed original fragments qualify age producer → Complex e-rgba table selection → caller arguments/full birth RGBA helper/RNG. Rust matches duration/age, selected color, output color and all55RNG words/indices.','Original constructor references statically identify config308 as e-period and config30C as e-active; raw field names remain in Rust until getter defaults and field sources are dynamically qualified.'],'limits':age['limits']+birth['limits']+['461full core tests pass. Other fields and global RNG calls between composed fragments remain excluded; no entire birth/update or graphical parity claim.','No new ordinary client build/render/GPU check. Full per-particle age and rendered lifecycle remain incomplete; no domain/champion/map or six-client match closed.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-age-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_age_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,complex_emitter_age_cases=3064,complex_birth_color_cases=312,core_tests_passed=461,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=461);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-age"><h2>Âge émetteur et couleur de naissance Complex</h2><p>3064calculs d’âge natifs et312chemins composés âge/table/couleur/aléatoire vérifiés dans Rust.461tests moteur passent. Âge propre de la particule, sources de durée et raccordement graphique restent à terminer.</p><a href="native_complex_age_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-age">.*?</section>',section,s,flags=re.S) if 'id="native-complex-age"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('459 moteur','461 moteur');text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier sources des durées, âge propre et mise à jour des particules ; intégrer les52groupes et244placements Map10 au rendu. Âge émetteur :3064cas ; naissance couleur composée :312cas vérifiés. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=461,core_tests_passed=461,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':461,'emitter_age_cases':3064,'composed_birth_color_cases':312,'complete':False}))
