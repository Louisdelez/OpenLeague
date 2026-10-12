from pathlib import Path
import json, hashlib, datetime, shutil
r=Path('E:/OpenLeague'); stage=Path('E:/mapslol3v3')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '340 passed; 0 failed' in (r/'logs/native-hud-xp-client-tests.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in (r/'logs/native-hud-xp-client-build.log').read_text(encoding='utf-8',errors='replace')
runs=[]
artifacts=['data/4.20/native_hud_experience_contract.json','data/4.20/experience_curve_map10.json','crates/client/src/native_hud_experience.rs','crates/client/src/main.rs','logs/native-hud-xp-client-tests.log','logs/native-hud-xp-client-build.log','target/debug/openleague-client.exe']
for backend,champion in [('vulkan','garen'),('dx12','ahri')]:
 p=f'logs/native-hud-xp-{backend}-{champion}';run=load(p+'-run.json');xp=load(p+'-xp-trace.json')
 assert run['passed'] and run['client_sha256']==sha('target/debug/openleague-client.exe')
 assert xp['fraction']==0 and xp['entities']==4
 assert {e['name'] for e in xp['elements']}=={'XPBar','XPBarOverlay','XPBarEndCapLeft','XPBarEndCapRight'}
 fill=next(e for e in xp['elements'] if e['name']=='XPBar');assert fill['fraction']==0
 runs.append(run)
 for suffix in ['.png','-run.json','-xp-trace.json','-trace.json','-bars-trace.json','-portrait-trace.json','-panels-trace.json','-client.stdout.log','-client.stderr.log','-server.stdout.log','-server.stderr.log']:artifacts.append(p+suffix)
proof=dict(updated_utc=now,passed=True,complete=False,client_tests_passed=340,native_fraction_cases=64,client_binary_sha256=sha('target/debug/openleague-client.exe'),runs=runs,visually_inspected_backends=['vulkan','dx12'],findings=['Four original XP icons from ShadowIslesChampionLeft are integrated with source rectangles, layers, colors, alpha modes and HUDAtlas UVs.','Experience from authoritative snapshots and the native map10 cumulative curve drives the source XPBar width fraction. Ordinary clients start at level1 with empty XP; source overlay and both caps rendered.','Real simulation snapshots test XP gain, level boundary reset, new-level progress and maximum-level full width. Native clamp/division and max branch match64 original executable cases.'],limits=['Graphical earned XP, level-up, max-level transitions and resize/DPI variations are not yet exercised. Screenshot evidence covers ordinary initial XP only.','XPBarHighlight is disabled in the source and not integrated; tooltip, input and level-up effects remain open. Original actor accessor and full controller/framebuffer identity are unqualified.','All24domains, complete champion kits, complete map and six graphical clients full match remain open.'],next_action='Qualifier graphiquement gains XP, montée de niveau, dégâts/soins/mort/réapparition ; intégrer icônes/rangs/délais de compétences, objets, minimap et interactions ; achever la carte restaurée puis tous les domaines du plan intégral.')
proof['artifacts_sha256']={p:sha(p) for p in artifacts}
history=r/'docs/plan_history'/('hud-xp-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
(r/'docs/native_hud_experience_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_experience_progress='docs/native_hud_experience_progress.json')
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=340,client_tests_passed=340,current_source_progress='docs/native_hud_experience_progress.json',ordinary_client_build_matches_current_source=True,latest_client_build_sha256=proof['client_binary_sha256'],native_xp_fraction_cases=64,native_xp_graphical_startup_backends=['vulkan','dx12'])
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':
  d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':
    domain.update(progress_updated_utc=now,current_state='Cadres, portraits, textes HP/MP et barre XP natifs partiellement intégrés ; XP initial observé Vulkan/DX12. Compétences, objets, minimap, effets et interactions HUD restent ouverts.')
    domain.setdefault('progress_evidence',[]).append('docs/native_hud_experience_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt']:
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('Barre XP native intégrée et testée ; compilation finale et observation GPU à faire.','Barre XP native testée et XP initial observé Vulkan/DX12.');assert len(s)<=4000;p.write_text(s,encoding='utf-8');(stage/name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=340,objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'),latest_source_progress='docs/native_hud_experience_progress.json',next_steps=[proof['next_action']]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');assert 'id="native-hud-experience-progress"' not in s;s=s.replace('</body>','<section id="native-hud-experience-progress"><h2>Barre d’expérience native</h2><p>340 tests client ; 64 cas sur les instructions originales. Quatre éléments XP intégrés, état initial observé Vulkan et DX12. Gains XP et montée de niveau à qualifier à l’écran ; HUD et jeu complets restent ouverts.</p><a href="native_hud_experience_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['install_native_hud_experience.py','qualify_native_hud_experience.py','run_native_hud_xp.ps1','record_native_hud_xp.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps({'client_tests':340,'native_xp_cases':64,'graphical_startup_captures':2,'complete':False}))
