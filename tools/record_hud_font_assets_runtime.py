from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
assert '307 passed; 0 failed' in (r/'logs/native-hud-font-assets-tests.log').read_text(encoding='utf-8')
assert 'Finished `dev` profile' in (r/'logs/native-hud-font-assets-build.log').read_text(encoding='utf-8')
captures=[]
for backend in ['vulkan','dx12']:
 path='docs/hud-font-assets-loading-'+backend+'-capture.json';c=load(path)
 assert c['source_font_assets_startup_observed'] and c['active_font_family']=='Gill Sans MT Pro Medium'
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Run only after inspecting both actual captures.
 c['visual_inspected']=True;c['visual_observation']='Map scene visible; blue regions remain and original HUD widgets are absent. Font asset loading observed in logs; GPU glyph fidelity not verified.'
 (r/path).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
proof=load('docs/native_hud_font_assets_progress.json');proof.update(updated_utc=now,last_qualified_application_tests=307,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=True,runtime_application_observed=True,backend_captures=captures,next_action='Qualifier et porter taille/cycle natif des polices et glyphes GPU ; résoudre textures/effets et dessiner les widgets HUD avec états/interactions ; corriger carte/zones bleues puis six clients et tous les domaines.')
proof['limits']=[v for v in proof['limits'] if not v.startswith('Tests cover current source;')]+['Current 307-test application rebuilt and observed Vulkan/DX12. Font startup asset observed; glyph drawing not yet connected to native HUD widgets. Diagnostic captures do not qualify complete match or original visual fidelity.']
(r/'docs/native_hud_font_assets_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-font-assets-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_font_assets_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=307,current_client_application_tests=307,client_test_source_matches_current_build=True,current_source_progress='docs/native_hud_font_assets_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-hud-font-assets-progress">';start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+marker+'<h2>Polices HUD source</h2><p>307 tests, reconstruction et chargement observé Vulkan/DirectX12. Captures inspectées. Glyphes et widgets ouverts ; zones bleues visibles.</p><a href="native_hud_font_assets_progress.json">Preuves et limites</a></section>'+s[end:];p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(tests=307,backends=2,client_sha256=proof['current_binary_sha256'],complete=False)))
