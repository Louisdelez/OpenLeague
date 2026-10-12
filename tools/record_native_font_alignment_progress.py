from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '22 passed; 0 failed' in (r/'logs/native-font-alignment-raster-tests.log').read_text(encoding='utf-8')
c=load('data/4.20/native_font_alignment_contract.json');assert c['passed'] and c['case_count']==3072
proof=load('docs/native_font_quad_progress.json');proof.update(updated_utc=now,font_raster_tests_passed=22,native_alignment_cases=3072,native_alignment_addresses=99,native_alignment_ported=True)
for p in ['data/4.20/native_font_alignment_contract.json','tools/qualify_native_font_alignment.py','logs/native-font-alignment-raster-tests.log']:
 if p not in proof['artifacts']:proof['artifacts'].append(p)
proof['hashes']={p:sha(p) for p in proof['artifacts']};proof['limits']+=c['limits'];proof['next_action']='Qualifier et porter la séquence native8BE4C0 : espaces, bearing, baseline, kerning, avances et paramètres de scale. Puis raccorder les textes et widgets HUD réels, vérifier Vulkan/DX12 et poursuivre tous les domaines.'
history=r/'docs/plan_history'/('native-font-alignment-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
shutil.copy2(r/'docs/native_font_quad_progress.json',history/'native_font_quad_progress.json');(r/'docs/native_font_quad_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
gp=r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt';shutil.copy2(gp,history/gp.name);goal=gp.read_text(encoding='utf-8').replace('319 tests client et 21 tests FreeType réussis.','319 tests client et 22 tests FreeType réussis.').replace('port des quads testé séparément.','quads/alignement testés séparément.');assert len(goal)<=4000;gp.write_text(goal,encoding='utf-8');Path('E:/mapslol3v3/GOAL-OPENLEAGUE-ACTUALISE.txt').write_text(goal,encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_font_quad_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(font_raster_tests_passed=22,client_test_source_matches_current_build=False,current_source_progress='docs/native_font_quad_progress.json')
 if 'goal_plan_revision' in d:d['goal_plan_revision'].update(font_raster_tests_passed=22,objective_sha256=hashlib.sha256(goal.encode()).hexdigest())
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['goal_objective_proposed']=goal;d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section id="native-font-alignment-progress"><h2>Alignement natif des textes</h2><p>Original8BE3C0 :3072cas/99adresses, origine comparée bit à bit au port Rust.22tests backend réussis. Placement des glyphes/kerning/widgets ordinaires toujours ouverts.</p><a href="native_font_quad_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,font_raster_tests_passed=22,objective_sha256=hashlib.sha256(goal.encode()).hexdigest());p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['port_native_font_alignment.py','record_native_font_alignment_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'native_alignment_cases':3072,'native_quad_cases':216,'source_font_tests':22,'ordinary_hud_complete':False,'complete':False}))
