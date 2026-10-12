from pathlib import Path
import json, hashlib, datetime, shutil
r=Path('E:/OpenLeague'); stage=Path('E:/mapslol3v3')
def load(p): return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p): return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '345 passed; 0 failed' in (r/'logs/native-hud-cooldown-client-tests.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in (r/'logs/native-hud-cooldown-client-build.log').read_text(encoding='utf-8',errors='replace')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
artifacts=['crates/client/src/native_hud_cooldown_text.rs','crates/client/src/native_hud_widgets.rs','crates/client/src/native_hud_live_probe.rs','crates/client/src/main.rs','data/4.20/native_hud_cooldown_text_contract.json','logs/native-hud-cooldown-client-tests.log','logs/native-hud-cooldown-client-build.log','target/debug/openleague-client.exe']
runs=[]
for backend in ['vulkan','dx12']:
 prefix=f'logs/native-hud-cooldown-live-{backend}-annie'; run=load(prefix+'-run.json')
 assert run['passed'] and run['client_sha256']==sha('target/debug/openleague-client.exe')
 captures=[x for x in run['probe']['records'] if x['kind']=='capture_requested']
 assert [x['label'] for x in captures]==['baseline','purchased','precast','cast','regenerated','ready']
 for c in captures:
  hud=c['hud_draw_trace']; assert hud['cooldown_mode']==1
  active=c['label'] in ['cast','regenerated']
  assert ('SpellCooldown2' in hud['values'])==active
  source=next(x for x in hud['sources'] if x['name']=='SpellCooldown2');assert source['active']==active
  if active:
   assert hud['values']['SpellCooldown2'].isdigit() and 1<=int(hud['values']['SpellCooldown2'])<=10
  p=prefix+'-'+c['label']+'.png';assert sha(p)==run['capture_sha256'][c['label']];artifacts.append(p)
 for suffix in ['-run.json','-probe.json','-trace.json','-spells-trace.json','-bars-trace.json','-portrait-trace.json','-panels-trace.json','-client.stdout.log','-client.stderr.log','-server.stdout.log','-server.stderr.log']:artifacts.append(prefix+suffix)
 runs.append(run)
proof=dict(updated_utc=now,passed=True,complete=False,client_tests_passed=345,native_formatter_cases=84,client_binary_sha256=sha('target/debug/openleague-client.exe'),runs=runs,visually_inspected_phases=['cast','ready'],visually_inspected_backends=['vulkan','dx12'],actual_capture_count=12,findings=['Original formatter branch and argument selection executed for84cases. Mode0 hides numbers; modes1/2/3 format seconds, minutes:seconds, or minutes. Below0.7seconds uses one decimal; otherwise rounds up.','Nine native Text sources integrated; four cooldown sources keep original rectangles, fonts, binding indices, colors and layers. Active authoritative cooldown enables its original Text flag; expiry disables it.','Ordinary Annie purchase/learn/cast and expiry captured with actual GPU glyphs in Vulkan and DX12. NumericCooldownFormat read from merged native settings.'],limits=['Original CRT printf byte/localization equivalence not proven: intercepted printf uses Python formatting in the reference contract.','Mode0/2/3 and boundary branches checked against original instructions and Rust tests; ordinary GPU run covers only configured mode1 and AnnieE. Other champions, slots, resize/DPI, death, resource/cost modifiers and localization remain unqualified.','Native original actor cooldown producer, client clock interpolation, cooldown ring/pulses, rank pips, hotkeys, learning buttons and interactions remain open.','Asynchronous screenshots may lag capture trace. No complete native framebuffer equivalence; all24domains and full champion kits remain open.'],next_action='Intégrer les rangs/pips, touches, boutons d’apprentissage et anneaux de recharge du HUD natif ; qualifier leurs interactions, puis poursuivre la carte restaurée, Garen et la partie complète à six clients ainsi que tous les domaines du plan.')
proof['artifacts_sha256']={p:sha(p) for p in artifacts}
history=r/'docs/plan_history'/('hud-cooldown-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
(r/'docs/native_hud_cooldown_text_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_cooldown_text_progress='docs/native_hud_cooldown_text_progress.json')
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=345,client_tests_passed=345,current_source_progress='docs/native_hud_cooldown_text_progress.json',ordinary_client_build_matches_current_source=True,latest_client_build_sha256=proof['client_binary_sha256'],native_cooldown_formatter_cases=84,native_hud_text_sources=9,native_cooldown_text_gpu_backends=['vulkan','dx12'])
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':
  d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':
    domain.update(progress_updated_utc=now,current_state='Cadres, portraits, HP/MP, XP initial, icônes/états QWER et chiffres de recharge partiellement intégrés. E Annie et disparition du compteur observés Vulkan/DX12. Rangs, touches, boutons, anneaux, objets, minimap et interactions ouverts.')
    domain.setdefault('progress_evidence',[]).append('docs/native_hud_cooldown_text_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt']:
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('343 tests client','345 tests client').replace('19 polices et 5 textes intégrés','19 polices et 9 textes intégrés').replace('QWER : 486 icônes intégrées.','QWER : 486 icônes et compteur E intégré (84 cas natifs).');assert len(s)<=4000;p.write_text(s,encoding='utf-8');(stage/name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=345,objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'),latest_source_progress='docs/native_hud_cooldown_text_progress.json',next_steps=[proof['next_action']]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="native-hud-cooldown-text-progress"' not in s;s=s.replace('</body>','<section id="native-hud-cooldown-text-progress"><h2>Chiffres de recharge natifs</h2><p>345 tests client ; 84 cas de formatage issus des instructions originales. Neuf textes natifs intégrés. Compteur du E d’Annie visible après lancement puis masqué à disponibilité, captures réelles Vulkan/DX12. Anneaux, rangs, boutons et interactions restent ouverts.</p><a href="native_hud_cooldown_text_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['run_native_hud_cooldown_live.ps1','record_native_hud_cooldown_text.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps({'tests':345,'native_formatter_cases':84,'actual_captures':12,'complete':False}))
