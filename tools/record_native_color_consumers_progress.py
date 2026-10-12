from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
native=load('data/4.20/color_consumer_contract.json');log='logs/native-color-consumers-core-tests.log'
assert native['passed'] and len(native['cases'])==48 and len(native['samples'])==624
assert '459 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_color_consumers_progress.json';next_action='Qualifier les appels/lifecycle RGBA réels et leur âge normalisé ; compléter les paramètres/lifetime Complex et relier le rendu des52groupes Map10 et244placements. Les multiplicateurs de naissance et le lecteur RGBA avec tirage à chaque appel sont maintenant deux chemins Rust distincts et qualifiés. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.'
files=['data/4.20/color_consumer_contract.json','tools/probe_native_color_consumers.py','crates/core/src/native_color_consumers.rs','crates/core/src/native_complex_color.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':459,'last_client_tests_passed':364,'birth_cases':48,'birth_steps':384,'sample_cases':624,'sample_steps':1248,'product_rust_sources_changed':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original949550 birth helper executes RGBA order, skips draws for null/constants, and draws once for each variable channel. Rust matches384outputs and all55RNG words/indices after every step.','Original949420 selects/clamps the baked table before applying RGBA probabilities, drawing fresh values on each call for variable channels. Rust matches1248outputs and full RNG states, including repeated calls.','Selector includes count1/3/16/256, normal boundaries, negative zero, NaN, positive/negative infinity and maximum finite values. A distinct public API prevents conflating sampled probabilities with stored birth multipliers.'],'limits':native['limits']+['Full459core tests passed; no new ordinary client build/render/GPU verification.','No map/champion/domain or six-client match complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('color-consumers-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_color_consumers_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(latest_native_execution_progress=receipt,rgba_birth_outputs_verified=384,rgba_sample_outputs_verified=1248,core_tests_passed=459,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=459);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-color-consumers"><h2>Consommateurs RGBA natifs</h2><p>384sorties naissance et1248sorties du lecteur de table comparées aux instructions originales, avec tous les états aléatoires. Les chemins sont distincts.459tests moteur passent. Âge réel, lifecycle et raccordement graphique restent à terminer.</p><a href="native_color_consumers_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-color-consumers">.*?</section>',section,s,flags=re.S) if 'id="native-color-consumers"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('457 moteur','459 moteur');text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier âge/lifecycle RGBA et paramètres Complex restants ; intégrer les52groupes et244placements Map10 au rendu. Vecteurs :600appels,270champs vérifiés. RGBA :27groupes,384sorties naissance,1248sorties échantillonnées vérifiées. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients et poursuivre les24domaines.\n';p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=459,core_tests_passed=459,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':459,'rgba_birth_steps':384,'rgba_sample_steps':1248,'complete':False}))
