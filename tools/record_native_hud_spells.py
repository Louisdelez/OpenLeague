from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '343 passed; 0 failed' in (r/'logs/native-hud-spells-client-tests.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in (r/'logs/native-hud-spells-client-build.log').read_text(encoding='utf-8',errors='replace')
runs=[];expected={'baseline':[2,2,2,2],'purchased':[2,2,2,2],'precast':[2,2,0,2],'cast':[2,2,4,2],'regenerated':[2,2,4,2],'ready':[2,2,0,2]}
artifacts=['crates/client/src/native_hud_spells.rs','crates/client/src/main.rs','crates/client/src/native_hud_live_probe.rs','data/4.20/native_spell_icons.json','data/4.20/native_hud_spell_states_contract.json','logs/native-hud-spells-client-tests.log','logs/native-hud-spells-client-tests-initial-failed.log','logs/native-hud-spells-client-build.log','target/debug/openleague-client.exe']
for backend in ['vulkan','dx12']:
 prefix=f'logs/native-hud-spells-live-{backend}-annie';run=load(prefix+'-run.json');assert run['passed'] and run['client_sha256']==sha('target/debug/openleague-client.exe');assert run['probe']['stage']==9
 captures=[e for e in run['probe']['records'] if e['kind']=='capture_requested'];assert [e['label'] for e in captures]==list(expected)
 for c in captures:
  trace=c['spells_draw_trace'];assert trace['loaded_primary_icons']==486 and trace['entities']==8 and trace['states']==expected[c['label']]
  assert {e['name'] for e in trace['elements']}=={f'{name}{slot}' for name in ['Spell','SpellOverlay'] for slot in range(4)}
  for e in trace['elements']:
   if e['name'].startswith('SpellOverlay'):
    want=0x80404040 if e['state'] in [2,3] else 0x640000ff if e['state']==4 else 0x00ffffff
    assert e['color']==want
  p=prefix+'-'+c['label']+'.png';assert sha(p)==run['capture_sha256'][c['label']];artifacts.append(p)
 commands=[e['packet']['Command']['action'] for e in run['probe']['records'] if e['kind']=='command'];assert commands==[{'Buy':{'item':1027}},{'Learn':{'slot':2}},{'Cast':{'slot':2,'target':None}}]
 for suffix in ['-run.json','-probe.json','-trace.json','-spells-trace.json','-bars-trace.json','-portrait-trace.json','-panels-trace.json','-client.stdout.log','-client.stderr.log','-server.stdout.log','-server.stderr.log']:artifacts.append(prefix+suffix)
 runs.append(run)
proof=dict(updated_utc=now,passed=True,complete=False,client_tests_passed=343,state_native_cases=384,palette_native_cases=192,client_binary_sha256=sha('target/debug/openleague-client.exe'),runs=runs,visually_inspected_phases=['baseline','precast','cast','ready'],visually_inspected_backends=['vulkan','dx12'],actual_capture_count=12,findings=['Four original QWER icon rectangles, full source UVs, source Opaque mode and overlay Alpha mode are rendered using original DDS resources and native Spells palette.','Primary486DDS payloads are CPU decoded and GPU loaded. Annie four icons visually observed in both backends; other champion icon rendering is not yet qualified.','Ordinary purchase, learning and casting commands drive the native overlay. Annie E observed dim/unlearned, bright/learned, blue/cooldown and bright/ready after authoritative cooldown expiry. No snapshot injection or privileged stat grants.','Original state ordering and palette selector match384state and192color executable cases with explicitly supplied getter/controller results.'],limits=['Native texture lookup precedence and dynamic InventoryIcon variants, forms, toggles/recasts remain open. AmumuW/NunuR have different native candidate files; one Heimerdinger variant is absent.','Original actor availability/mask/cost producers not executed here. Authoritative health/stun/rank/cooldown plus native base mana cost supply current UI states; cost modifiers and special policies remain partial.','Only icon and static overlay states implemented. Cooldown ring/text, pip ranks, hotkeys, learn buttons, tooltip, pointer/cursor interaction and pulse/hover effects remain open.','343tests cover icon integration and simulation state changes. Small optional capture instrumentation was added afterward; final build and both ordinary command/GPU scenarios verify that added capture path.','Screenshots are asynchronous; trace recorded at capture request. No full original framebuffer equivalence claimed. All24domains and complete champion kits remain unclosed.'],next_action='Intégrer rangs/pips, touches, chiffres/anneaux de délai, boutons d’apprentissage et interactions HUD natifs ; qualifier le chargement/variantes des icônes, puis terminer la carte restaurée, Garen et la partie complète à six clients avant tous les autres domaines.')
proof['artifacts_sha256']={p:sha(p) for p in artifacts}
history=r/'docs/plan_history'/('hud-spells-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
(r/'docs/native_hud_spells_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_spells_progress='docs/native_hud_spells_progress.json')
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=343,client_tests_passed=343,current_source_progress='docs/native_hud_spells_progress.json',ordinary_client_build_matches_current_source=True,latest_client_build_sha256=proof['client_binary_sha256'],native_spell_state_cases=384,native_spell_palette_cases=192,native_qwer_primary_icons_loaded=486,native_qwer_graphical_transition_backends=['vulkan','dx12'])
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':
  d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':
    domain.update(progress_updated_utc=now,current_state='Cadres, portraits, HP/MP, XP initial et icônes QWER/surcouches partiellement intégrés ; E Annie non appris/appris/délai/disponible observé Vulkan/DX12. Rangs, délais animés, touches, apprentissage, objets, minimap, effets et interactions restent ouverts.')
    domain.setdefault('progress_evidence',[]).append('docs/native_hud_spells_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt']:
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('340 tests client','343 tests client');s=s.replace('Barre XP native testée et XP initial observé Vulkan/DX12.','XP initial et états du E d’Annie observés Vulkan/DX12. QWER : 486 icônes intégrées.');assert len(s)<=4000;p.write_text(s,encoding='utf-8');(stage/name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=343,objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'),latest_source_progress='docs/native_hud_spells_progress.json',next_steps=[proof['next_action']]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');assert 'id="native-hud-spells-progress"' not in s;s=s.replace('</body>','<section id="native-hud-spells-progress"><h2>Icônes et états QWER natifs</h2><p>343 tests client ; 384 cas d’état et 192 couleurs sur les instructions originales. 486 icônes chargées. E d’Annie non appris, appris, en délai puis disponible : captures réelles Vulkan/DX12. Interactions, rangs, délais animés, variantes et jeu complet restent ouverts.</p><a href="native_hud_spells_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['run_native_hud_spells_live.ps1','record_native_hud_spells.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps({'tests':343,'native_state_cases':384,'native_palette_cases':192,'actual_captures':12,'complete':False}))
