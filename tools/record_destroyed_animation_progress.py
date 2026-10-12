from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
binding=load('docs/destroyed_animation_binding.json');assert len(binding['models'])==4
build=(r/'logs/destroyed-animation-build.log').read_text(encoding='utf-8-sig');assert 'Finished `dev`' in build
test=(r/'logs/destroyed-animation-tests-excerpt.log').read_text(encoding='utf-8');assert '223 passed; 0 failed' in test
paths=['data/4.20/world_animation_manifest.json','docs/destroyed_animation_source_audit.json','docs/destroyed_animation_binding.json','logs/destroyed-animation-build.log','logs/destroyed-animation-tests-excerpt.log','target/debug/openleague-client.exe']+['assets/'+m['asset'] for m in binding['models'].values()]
hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths}
assert hashes['data/4.20/world_animation_manifest.json']==binding['manifest_sha256']
for m in binding['models'].values():assert hashes['assets/'+m['asset']]==m['glb_sha256']
actions=['Qualify native BLND loop/event semantics and verify actual destroyed-building animation/death transition in the current graphical client; materials/FX and native multi-skin destruction producers remain open.','Connect actual eligibility/camera/collector to normal brush mask/WALL rendering; qualify dynamic scale and compounded spatial lifecycle.','Continue all24 domains and complete champion kits, six-client victory/results and final delivery.']
receipt=dict(updated_utc=now,complete=False,original_clips_exported=4,destroyed_aliases_bound=12,client_tests_passed=223,client_build_passed=True,runtime_destruction_qualified=False,source_report='docs/destroyed_animation_source_audit.json',binding_report='docs/destroyed_animation_binding.json',files_sha256=hashes,next_actions=actions,limits=binding['limits']+['Tests cover existing client suite; no new graphical animation/death capture. Test journal is a captured output excerpt; build journal is complete. Previous startup/gallery receipts describe earlier executable/assets.'])
save('docs/destroyed_animation_progress.json',receipt)
archive=r/'docs/plan_history'/('destroyed-animation-progress-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,destroyed_animation_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions));d['last_verified']['client_tests']=223
 else:
  d['current_evidence'].update(client_tests_passed=223,current_test_receipt='docs/destroyed_animation_progress.json',current_build_receipt='docs/destroyed_animation_progress.json',current_client_sha256=hashes['target/debug/openleague-client.exe'],current_binary_hud_visual_verified=False,current_spatial_registry_vulkan_capture_verified=False,destroyed_structure_original_clips_bound=4,destroyed_structure_animation_runtime_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=actions
 save(p,d)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8').replace('216 tests','223 tests')
i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : vérifier les règles natives de répétition/événements BLND et la destruction animée dans le client réel. Quatre clips originaux exportés et liés aux douze références de débris ; 223 tests client et compilation réussis. Matériaux/effets, transition complète en partie, masque/rendu WALL, tous les kits et tous les 24 domaines restent ouverts.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Animations originales des débris Map10</h2><p>4 clips intégrés aux 12 références.223 tests client et compilation réussis. Répétition native, effets et destruction complète en partie restent à qualifier.</p><a href="destroyed_animation_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['recover_destroyed_animations.py','bind_destroyed_animations.py','record_destroyed_animation_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(complete=False,original_clips=4,aliases=12,client_tests=223,hashes=len(hashes))))
