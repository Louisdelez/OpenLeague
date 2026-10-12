from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
curves=load('data/4.20/color_curve_contract.json');callers=load('data/4.20/complex_color_contract.json')
assert curves['passed'] and callers['passed'] and len(curves['field_cases'])==35 and len(callers['cases'])==66
assert all(c['arguments']['default']==[1.,1.,1.,1.] for c in callers['cases'])
log='logs/native-complex-color-core-tests.log'
assert '457 passed; 0 failed' in (r/log).read_text()
receipt='docs/native_complex_color_progress.json'
next_action='Qualifier la consommation native RGBA des probabilités et la normalisation de l’âge ; compléter les paramètres scalaires/lifetime Complex, puis intégrer émission/naissance/pose/couleurs/vecteurs au rendu des52groupes Map10 et244placements. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle et vérifier six clients ; poursuivre les24domaines.'
files=['data/4.20/color_curve_contract.json','data/4.20/complex_color_contract.json','tools/probe_native_color_curve.py','tools/probe_native_complex_color.py','crates/core/src/native_color_curve.rs','crates/core/src/native_complex_color.rs','crates/core/src/lib.rs',log,'target/debug/deps/openleague_core-5b2a9def275dcedd.exe']
catalog=load('data/4.20/map10_particle_catalog.json')
files+=sorted({d['asset'] for d in catalog['definitions'] if any(g['declared_type']!='Simple' for g in d['groups'])})
proof={'updated_utc':now,'complete':False,'native_sha256':callers['native_sha256'],'core_tests_passed':457,'last_client_tests_passed':364,'field_reader_cases':35,'bake_cases':66,'baked_rgba_values':2836,'direct_samples':151,'full_color_caller_cases':66,'native_map_caller_cases':54,'actual_map_complex_colors_verified':27,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Rust RGBA reader/interpolation/baking match original field values and all captured f32 output bits. Authored e-rgba base normalizes by1/255; absent base defaults remain unnormalized.','Original Complex caller supplies opaque-white default and fallback; missing/short base leaves channel probability pointers null.','Full reader visits RGBA probability keys independently; Rust configuration matches66caller outcomes. Actual27Map10Complex color sections independently compared to original outputs.'],'limits':callers['limits']+['Only sorted finite nonempty curve knots supported.','No RGBA probability draw/update consumer port yet; the scalar/vector draw order cannot be assumed for RGBA.','Latest457full core tests pass. Ordinary client was not rebuilt or visually verified. No complete map/champion/domain or six-client match claim.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-color-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_complex_color_progress=receipt)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence']
 e.update(latest_native_execution_progress=receipt,complex_color_caller_cases=66,actual_map_complex_colors=27,core_tests_passed=457,core_tests_scope='Current core source suite; ordinary graphical application not rebuilt')
 if name=='resume_checkpoint.json':e.update(core_tests=457);d.update(saved_utc=now,next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id'] in ('03','10','15'):
    domain.setdefault('progress_evidence',[])
    if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
    domain['progress_updated_utc']=now
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-color"><h2>Couleurs RGBA Complex de Map10</h2><p>Lecteur/courbes RGBA natifs portés dans Rust :2836couleurs calculées,151échantillons directs,66appels complets,27groupes Map10vérifiés.457tests moteur réussis. Âge et consommation graphique restent à terminer.</p><a href="native_complex_color_progress.json">Preuves et limites</a></section>'
s=re.sub(r'<section id="native-complex-color">.*?</section>',section,s,flags=re.S) if 'id="native-complex-color"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 if p.exists():
  text=p.read_text(encoding='utf-8-sig').replace('452 moteur','457 moteur')
  text=text.split('PROCHAINE ÉTAPE :')[0]+'PROCHAINE ÉTAPE : qualifier les consommateurs RGBA, âge et paramètres Complex restants ; intégrer les52groupes et244placements Map10 au rendu. Vecteurs :600appels,270champs vérifiés. RGBA :66appels,27groupes vérifiés. Reconstruire les exécutables, résoudre TT_Mist_circle/fogcircle, vérifier six clients, puis poursuivre les24domaines.\n'
  p.write_text(text,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';shutil.copy2(p,history/p.name);d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_native_execution_progress=receipt,core_source_tests_passed=457,core_tests_passed=457,next_steps=[next_action],objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests_passed':457,'actual_map_colors_verified':27,'complete':False}))
