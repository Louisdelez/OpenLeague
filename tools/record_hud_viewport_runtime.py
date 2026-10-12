from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
assert '299 passed; 0 failed' in (r/'logs/native-hud-viewport-tests.log').read_text(encoding='utf-8')
assert 'Finished `dev` profile' in (r/'logs/native-hud-viewport-build.log').read_text(encoding='utf-8')
captures=[]
for backend in ['vulkan','dx12']:
 path='docs/hud-viewport-loading-'+backend+'-capture.json';c=load(path)
 assert c['viewport_bounds_runtime_observed'] and c['viewport_events'][0]['refreshed']==41
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Only invoke after actual image inspection of both new captures.
 c['visual_inspected']=True;c['visual_observation']='Scene visible; blue map regions remain; original HUD widgets absent. Screenshot is diagnostic fixed camera, not a completed match.'
 (r/path).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
proof=load('docs/native_hud_viewport_progress.json');proof.update(updated_utc=now,last_qualified_application_tests=299,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=True,runtime_application_observed=True,backend_captures=captures,native_resize_gate_cases=96,native_texture_cache_cases=172,native_texture_names=84,next_action='Porter et qualifier création/résolution des textures/polices/effets et widgets HUD ; poursuivre cycle natif resize/réglages et groupes manquants ; corriger carte/zones bleues, six clients graphiques puis24domaines.')
proof['limits']=[v for v in proof['limits'] if not v.startswith('Source suite passed;')]+['Application299test build observed Vulkan/DX12,41sourcegroups refreshed; widgets absent, blue map regions visible. Diagnostic captures do not qualify full match or original visual fidelity.','172native cache lookup cases cover84source texture names with supplied cache tree/resources; creation/loading/GPU assignment not qualified.']
(r/'docs/native_hud_viewport_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-viewport-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_viewport_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=299,current_client_application_tests=299,client_test_source_matches_current_build=True,current_source_progress='docs/native_hud_viewport_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-viewport-progress">';start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+marker+'<h2>Viewport HUD</h2><p>299tests et reconstruction réussis ; viewport réel et41groupes observés Vulkan/DirectX12, captures inspectées.172cas de cache de textures natifs qualifiés. Widgets, ressources et cycle natif complet restent ouverts ; zones bleues visibles.</p><a href="native_hud_viewport_progress.json">Preuves</a></section>'+s[end:];p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tests=299,client_sha=proof['current_binary_sha256'],backends=2,complete=False)))
