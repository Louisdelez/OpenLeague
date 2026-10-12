from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '348 passed; 0 failed' in (r/'logs/native-hud-ranks-client-tests.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in (r/'logs/native-hud-ranks-client-build.log').read_text(encoding='utf-8',errors='replace')
contract=load('data/4.20/native_hud_ranks_contract.json');assert contract['passed']
now=datetime.datetime.now(datetime.timezone.utc).isoformat();runs=[]
artifacts=['crates/client/src/native_hud_ranks.rs','crates/client/src/native_hud_live_probe.rs','crates/client/src/main.rs','data/4.20/native_hud_ranks_contract.json','logs/native-hud-ranks-client-tests.log','logs/native-hud-ranks-client-build.log','target/debug/openleague-client.exe']
for backend in ['vulkan','dx12']:
 prefix=f'logs/native-hud-ranks-live-{backend}-annie';run=load(prefix+'-run.json');assert run['passed'] and run['client_sha256']==sha('target/debug/openleague-client.exe')
 captures=[x for x in run['probe']['records'] if x['kind']=='capture_requested'];assert [x['label'] for x in captures]==['baseline','purchased','precast','cast','regenerated','ready']
 for c in captures:
  t=c['ranks_draw_trace'];learned=c['label'] not in ['baseline','purchased'];assert t['ranks']==([0,0,1,0] if learned else [0,0,0,0]);assert t['maximum']==[5,5,5,3] and t['source_count']==26 and t['entities']==(19 if learned else 18)
  elements=t['elements'];assert len([x for x in elements if x['name'].startswith('PipDivider')])==14
  fills=[x for x in elements if x['name'].startswith('PipBar')];assert len(fills)==int(learned)
  if learned:assert fills[0]['name']=='PipBar2' and .18<fills[0]['fraction']<.20
  assert len([x for x in elements if x['name'].startswith('SpellHotKeyBG')])==4
  p=prefix+'-'+c['label']+'.png';assert sha(p)==run['capture_sha256'][c['label']];artifacts.append(p)
 for suffix in ['-run.json','-probe.json','-trace.json','-spells-trace.json','-ranks-trace.json','-bars-trace.json','-portrait-trace.json','-panels-trace.json','-client.stdout.log','-client.stderr.log','-server.stdout.log','-server.stderr.log']:artifacts.append(prefix+suffix)
 runs.append(run)
proof=dict(updated_utc=now,passed=True,complete=False,client_tests_passed=348,native_getter_cases=40,native_fraction_cases=364,native_divider_cases=66,source_count=26,client_binary_sha256=sha('target/debug/openleague-client.exe'),runs=runs,actual_capture_count=12,visually_inspected_phases=['baseline','precast'],visually_inspected_backends=['vulkan','dx12'],findings=['Native max-rank getter executed with supplied table contents on both routes. Original SSE/x87 rank-fill math qualified for364cases, including native rank-minus0.5 gap weighting. Divider x positions qualified for66cases.','Four original hotkey backgrounds, four pip bars, sixteen divider templates and two dummy references read without replacement. Fourteen dividers rendered for5/5/5/3 scheme. Rank0 fill hidden; ordinary AnnieE learning enables original pip fill with native fraction.','Baseline and post-learning actual screenshots inspected on Vulkan/DX12. Ordinary server commands and authoritative snapshots drive rank changes; no forced rank injection.'],limits=['Native champion max-rank table population not recovered. Drawing currently restricted to Annie/Garen standard scheme matching existing authoritative progression. Other champions/special rank schemes remain open.','Native source getter/setter wrappers and preceding divider segment calculation inspected but not executed in this contract. Supplied logical source rectangles transported through qualified native layout/icon geometry; original full framebuffer identity not proven.','GPU captures cover Annie E rank0-to1 only at1280x800/DPI1; higher ranks, R, Garen, resizing/DPI and changed input bindings remain unqualified.','Hotkey letters/input configuration, learn buttons, cooldown ring, hover/click, passive/summoner slots, item/minimap HUD and all other24-domain completion requirements remain open.'],next_action='Intégrer les touches des sorts depuis les raccourcis réels et les boutons d’apprentissage natifs, puis les anneaux de recharge et interactions HUD. Continuer la carte restaurée, Garen, la partie complète à six clients et tous les domaines du plan.')
proof['artifacts_sha256']={p:sha(p) for p in artifacts}
history=r/'docs/plan_history'/('hud-ranks-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
(r/'docs/native_hud_ranks_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_ranks_progress='docs/native_hud_ranks_progress.json')
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=348,client_tests_passed=348,current_source_progress='docs/native_hud_ranks_progress.json',ordinary_client_build_matches_current_source=True,latest_client_build_sha256=proof['client_binary_sha256'],native_rank_getter_cases=40,native_rank_fraction_cases=364,native_rank_divider_cases=66,native_rank_gpu_backends=['vulkan','dx12'])
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':
  d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':
    domain.update(progress_updated_utc=now,current_state='Cadres, portraits, HP/MP, XP initial, icônes/états QWER, chiffres de recharge et rangs partiellement intégrés. Apprentissage E Annie rang0→1 observé Vulkan/DX12. Touches, boutons, anneaux, objets, minimap et interactions ouverts.')
    domain.setdefault('progress_evidence',[]).append('docs/native_hud_ranks_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt']:
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('345 tests client','348 tests client').replace('QWER : 486 icônes et compteur E intégré (84 cas natifs).','QWER : 486 icônes, compteur E et rangs intégrés.');assert len(s)<=4000;p.write_text(s,encoding='utf-8');(stage/name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=348,objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'),latest_source_progress='docs/native_hud_ranks_progress.json',next_steps=[proof['next_action']]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="native-hud-ranks-progress"' not in s;s=s.replace('</body>','<section id="native-hud-ranks-progress"><h2>Rangs de compétences natifs</h2><p>348 tests client ; 40 cas de lecture, 364 remplissages et 66 positions natifs. Apprentissage E d’Annie rang0→1 : sprites et captures réelles Vulkan/DX12. Autres schémas, raccourcis, boutons et interactions restent ouverts.</p><a href="native_hud_ranks_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['run_native_hud_ranks_live.ps1','record_native_hud_ranks.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps({'client_tests':348,'native_cases':470,'actual_captures':12,'complete':False}))
