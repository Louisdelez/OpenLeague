from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
log=(r/'logs/native-hud-recharge-client-tests.log').read_text(encoding='utf-8',errors='replace');assert '356 passed; 0 failed' in log
load=lambda name:json.loads((r/name).read_text(encoding='utf-8-sig'))
sha=lambda name:hashlib.sha256((r/name).read_bytes()).hexdigest()
c=load('data/4.20/native_hud_recharge_contract.json');assert c['passed'] and c['case_count']==256
next_action='Intégrer le rendu GPU Cooldown/CooldownLine avec les états et la géométrie natifs, transporter la durée totale autoritaire des recharges puis vérifier un cycle complet Vulkan/DX12. Poursuivre animations/survol/infobulles du HUD, carte restaurée, partie à six clients et tous les domaines.'
proof=dict(updated_utc=now,complete=False,passed=True,client_source_tests_passed=356,native_parameter_cases=256,source_effects=4,source_shaders=4,client_build_matches_current_source=False,prior_gameplay_capture_progress='docs/native_hud_learning_progress.json',findings=['Original SSE parameter updates 7D7FFC..8054 and 7D7E4F..7EA8 execute with supplied finite remaining/total values. Adapted virtual setters capture vec4 output, matching Rust bit-for-bit across256cases.','Four SpellCooldownFX source records retain layer3, initialdisabled, original rectangles and effect colors. Four HLSL sources copied byte-for-byte from client4.20.','Native constructor maps SpellCooldownFX to owner+430+slot*4 (rootEBX=owner+380); controller passes remaining/total*original2PI to virtual+38. Static constructor inspected, not emulated.','CPU shader port preserves source angle direction and unclamped gradient output; zero-direction/invalid API input explicitly unqualified/rejected. These tests are not original GPU pixel proof.'],limits=c['limits']+['No live cooldown effect renderer yet; authoritative cooldown total, geometry/render states, source shader bytecode and actual GPU cycle remain unqualified. Prior learning screenshots refer to earlier binaries; current client source has not been rebuilt as ordinary executable.'],next_action=next_action)
files=['crates/client/src/native_hud_recharge.rs','crates/client/src/main.rs','data/4.20/native_hud_recharge_contract.json','logs/native-hud-recharge-client-tests.log']+[s['asset'] for s in c['shaders']]
proof['artifacts_sha256']={f:sha(f) for f in files}
(r/'docs/native_hud_recharge_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('hud-recharge-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_recharge_progress='docs/native_hud_recharge_progress.json');e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=356,client_tests_passed=356,current_source_progress='docs/native_hud_recharge_progress.json',ordinary_client_build_matches_current_source=False,native_recharge_parameter_cases=256,native_recharge_source_shaders=4)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':domain.update(progress_updated_utc=now);domain.setdefault('progress_evidence',[]).append('docs/native_hud_recharge_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt']:
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('353 tests client','356 tests client');assert len(s)<=4000;p.write_text(s,encoding='utf-8');(stage/name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=356,objective_sha256=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'),latest_source_progress='docs/native_hud_recharge_progress.json',next_steps=[next_action]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="native-hud-recharge-progress"' not in s;s=s.replace('</body>','<section id="native-hud-recharge-progress"><h2>Effets de recharge : calcul et sources</h2><p>356 tests client ; 256 calculs natifs. Quatre définitions et quatre shaders d’origine récupérés. Port CPU, rendu GPU et durée autoritaire totale encore à intégrer ; exécutable courant non reconstruit après ce port.</p><a href="native_hud_recharge_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
for name in ['record_native_hud_recharge.py','inspect_native_hud_recharge_draw.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(client_tests=356,native_cases=256,complete=False,ordinary_binary_current=False)))
