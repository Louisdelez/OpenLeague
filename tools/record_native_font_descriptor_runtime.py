from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest();load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
assert '311 passed; 0 failed' in (r/'logs/native-font-descriptor-tests.log').read_text(encoding='utf-8')
assert 'Finished `dev` profile' in (r/'logs/native-font-descriptor-build.log').read_text(encoding='utf-8')
captures=[]
for backend in ['vulkan','dx12']:
 path='docs/native-font-descriptor-loading-'+backend+'-capture.json';c=load(path)
 assert c['font_size_runtime_observed'] and c['source_text_bindings_runtime_observed']==154 and c['unique_font_descriptors']==19
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and c['capture_sha256']==hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()
 # Invoke only after inspecting both actual images.
 c['visual_inspected']=True;c['visual_observation']='Map scene visible, blue regions still present, original HUD widgets absent. Font file loading/sizing/descriptor preparation observed in logs; glyph rendering not verified.'
 (r/path).write_text(json.dumps(c,indent=2)+'\n',encoding='utf-8');captures.append(c)
proof=load('docs/native_font_descriptor_progress.json');proof.update(updated_utc=now,last_qualified_application_tests=311,current_binary_sha256=sha('target/debug/openleague-client.exe'),application_rebuilt_after_changes=True,runtime_application_observed=True,source_text_descriptor_bindings_runtime_observed=154,unique_font_descriptors_runtime_observed=19,font_size_runtime_observed=True,backend_captures=captures)
face_contract='data/4.20/native_font_face_sizing_contract.json';face=load(face_contract);assert face['passed'] and face['case_count']==384
proof.update(native_face_sizing_adjustment_branch_cases=384,native_face_sizing_adjustment_rust_ported=False,native_face_metrics_provider_qualified=False)
proof['artifacts'].append(face_contract);proof['hashes'][face_contract]=sha(face_contract)
proof['limits'].append('384original face sizing adjustment cases now executed with explicit supplied metrics/DPI profiles; actual metric producer/rasterization, zero/extreme/error cases and Rust port remain open.')
proof['next_action']='Porter les384cas de boucle native de dimensionnement des polices, identifier version/configuration de rasterisation et qualifier métriques/glyphes GPU ; textures/effets/widgets HUD, carte restaurée et tous les domaines.'
proof['limits']=[v for v in proof['limits'] if not v.startswith('New source not rebuilt;')]+['Current311-test application rebuilt and observed Vulkan/DX12;154source text bindings and19logical descriptors prepared. Native face sizing adjustment, glyph rendering, widgets and map defects remain open. Diagnostic captures are not a complete match.']
(r/'docs/native_font_descriptor_progress.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-font-descriptor-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_font_descriptor_progress=proof)
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=311,current_client_application_tests=311,client_test_source_matches_current_build=True,current_source_progress='docs/native_font_descriptor_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=proof['next_action'])
 if name=='completion_plan.json':d['next_execution_steps']=[proof['next_action']]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');marker='<section id="native-font-descriptor-progress">';start=s.index(marker);end=s.index('</section>',start)+len('</section>');s=s[:start]+marker+'<h2>Descripteurs de polices HUD</h2><p>311tests, reconstruction et observations Vulkan/DX12 :154bindings de textes et19descripteurs préparés. Captures inspectées. Ajustement de métriques/DPI, glyphes etwidgets ouverts ; zones bleues visibles.</p><a href="native_font_descriptor_progress.json">Preuves et limites</a></section>'+s[end:];p.write_text(s,encoding='utf-8')
destination=r/'tools'/Path(__file__).name
if Path(__file__).resolve()!=destination.resolve():shutil.copy2(Path(__file__),destination)
print(json.dumps(dict(tests=311,backends=2,texts=154,descriptors=19,client_sha256=proof['current_binary_sha256'],complete=False)))
