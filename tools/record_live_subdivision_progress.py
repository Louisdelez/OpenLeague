from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert '216 passed; 0 failed' in (r/'logs/grass-live-subdivision-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/grass-live-subdivision-build.log').read_text(encoding='utf-8-sig')
runtime=load('docs/grass_live_subdivision_runtime.json');assert runtime['visual_inspected'] and runtime['after_movement']['error'] is None and runtime['after_movement']['queued_subdivisions']==0
audit=load('docs/world_spatial_source_audit.json')
paths=['crates/client/src/grass_live_registry.rs','crates/client/src/grass_subdivision.rs','crates/client/src/grass_object_registry.rs','logs/grass-live-subdivision-tests.log','logs/grass-live-subdivision-build.log','docs/grass_live_subdivision_runtime.json','docs/world_spatial_source_audit.json','logs/grass-live-216.png','target/debug/openleague-client.exe']
hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths}
assert runtime['client_sha256']==hashes['target/debug/openleague-client.exe']
actions=['Qualify bounds and SkinScale for the 16 uniquely associated NPC/summon resources; resolve remaining building/altar sources, and connect actual loaded world actors.','Qualify compounded deep spatial lifecycle against original methods including partial existing children; dynamic actor scale, eligibility/camera/collector and normal brush mask/WALL remain open.','Continue all 24 domains, complete champion kits, six-client victory/results and delivered package qualification.']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=216,client_build_passed=True,live_subdivision_drain_integrated=True,integration_lifecycle_actors=96,native_deep_compound_lifecycle_qualified=False,live_grass_mask_integrated=False,runtime=runtime,world_models_audited=len(audit['models']),world_models_unique_probe_sources=sum(row['ready_for_native_bounds_probe'] for row in audit['models']),findings=['Live synchronize now drains queued subdivisions with registry slot identities and writes moved actor parents and parent_present flags back to owned objects. Recycled storage retains index alignment.','96-actor integration check exercises deep subdivision, opposite-quadrant crossing, half withdrawal, new model/identity slot reuse, complete withdrawal and session reset; checks unique membership, live topology, bounds containment and recycled ownership.','Current executable launches on a normal local server, emits a Vulkan screenshot, and updates spatial center/integer bounds after a real network Move command. This small runtime capture does not exercise the 96-actor test topology.'],limits=['Original standalone queue/subdivision contracts remain compared; compounded live adapter lifecycle and partial existing children have integration coverage but no complete new original-executable comparison.','42 world models audited, only16 currently have unique source mesh/config association. No NPC spatial registration or full world model bounds claim.','Dynamic size effects, skin/form selection, native full configuration lookup and brush eligibility/camera/collector/WALL renderer remain unfinished.','Build emits35 existing warnings; external Vulkan loader warnings remain recorded. No full game or six-client victory/results acceptance.'],next_actions=actions,files_sha256=hashes)
save('docs/grass_live_subdivision_progress.json',receipt)
history=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history.mkdir(parents=True,exist_ok=True)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('215 tests','216 tests').replace('215tests','216tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : récupérer et qualifier dimensions/échelle des modèles NPC et invocations ; résoudre sources des bâtiments et autels, puis raccorder leurs acteurs chargés au registre spatial. Subdivision reliée au registre et cycle de96acteurs vérifié ;216tests client, compilation, lancement Vulkan et déplacement réseau réussis. Comparaison native du cycle profond composé, échelle dynamique, critères de visibilité, caméra, collecteur et masque/rendu WALL restent ouverts. Poursuivre les24domaines du plan.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,history/name);d=load(path);d.update(updated_utc=now,complete=False,grass_live_subdivision_progress=receipt)
 if 'goal_objective_proposed' in d:d['goal_objective_proposed']=objective
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions));d['last_verified']['client_tests']=216
 else:d['current_evidence'].update(client_tests_passed=216,current_test_receipt='docs/grass_live_subdivision_progress.json',current_build_receipt='docs/grass_live_subdivision_progress.json',current_client_sha256=hashes['target/debug/openleague-client.exe'],native_actor_registry_live_subdivision_integrated=True,native_grass_live_mask_integrated=False,current_binary_hud_visual_verified=False,current_spatial_registry_vulkan_capture_verified=True)
 if name=='completion_plan.json':d['next_execution_steps']=actions
 save(path,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Subdivision du registre en partie</h2><p>216 tests réussis et compilation réussie. Cycle intégré de96acteurs vérifié ; lancement Vulkan et déplacement réseau vérifiés sur le nouvel exécutable. NPC et rendu des buissons restent ouverts.</p><a href="grass_live_subdivision_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['goal-openleague-actualise.txt','nouveau-goal-openleague-a-jour.txt','goal-openleague-nouveau-2026-10-05.txt']:(Path('E:/mapslol3v3')/name).write_text(objective,encoding='utf-8')
for p in ['install_live_subdivision.py','capture_live_subdivision.py','audit_world_spatial_sources.py','record_live_subdivision_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/p,r/'tools'/p)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:assert load('docs/'+name)['grass_live_subdivision_progress']==receipt
for p,h in hashes.items():assert hashlib.sha256((r/p).read_bytes()).hexdigest()==h
print(json.dumps(dict(client_tests=216,receipt_hashes_verified=len(hashes),complete=False)))
