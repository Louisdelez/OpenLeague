from pathlib import Path
import json,hashlib,datetime,shutil,html
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
runtime=load('docs/destroyed_animation_runtime.json');assert runtime['diagnostic_fixture'] and len(runtime['destroyed_models'])==4
rows=[json.loads(x) for x in (r/'logs/destroyed-animation-runtime.jsonl').read_text(encoding='utf-8').splitlines()]
summaries={}
for model in runtime['destroyed_models']:
 samples=[a for row in rows for a in row['actors'] if a['model']==model and a['role']=='death']
 elapsed=[c['elapsed'] for a in samples for c in a['active_clips']];counts=[c['completions'] for a in samples for c in a['active_clips']]
 assert len(elapsed)>2 and max(elapsed)>min(elapsed) and max(counts)>1
 summaries[model]=dict(samples=len(samples),first_elapsed=min(elapsed),last_elapsed=max(elapsed),max_completions=max(counts),loop_observed=True,native_loop_semantics_verified=False)
assert '223 passed; 0 failed' in (r/'logs/destroyed-animation-probe-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/destroyed-animation-probe-build.log').read_text(encoding='utf-8-sig')
runtime.update(visual_inspection_required=False,visual_inspected=True,animation_players=summaries,visual_observations=['Actual Vulkan client framebuffer inspected: four relocated original destroyed resources rendered with textures on restored Map10, champion and development HUD visible.','Tower/nexus rubble in foreground and two inhibitor variants behind. Diagnostic placements can overlap authored scenery.','AnimationPlayer elapsed time and repeated completions observed for all four death roles; screenshot alone does not establish joint motion or native fidelity.'])
save('docs/destroyed_animation_runtime.json',runtime)
paths=['crates/client/src/animation.rs','crates/client/src/main.rs','crates/server/examples/destroyed_animation_fixture.rs','logs/destroyed-animation-probe-tests.log','logs/destroyed-animation-probe-build.log','logs/destroyed-animation-runtime.jsonl','logs/destroyed-animation-runtime.png','docs/destroyed_animation_runtime.json','target/debug/openleague-client.exe','target/debug/examples/destroyed_animation_fixture.exe','data/4.20/world_animation_manifest.json']
hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths};assert hashes['target/debug/openleague-client.exe']==runtime['client_sha256']
actions=['Qualify original BLND state/clip loop and event flags against the native reader; actual client presently repeats shared idle/death clip. Verify actual joint poses and native material/FX response.','Verify ordinary combat destruction lifecycle and native model/skin producers, then connect eligibility/camera/collector to normal brush mask/WALL.','Continue all24 domains, champion kits, six-client complete victory/results and delivered package qualification.']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=223,client_build_passed=True,diagnostic_rendered_destroyed_models=4,runtime=runtime,files_sha256=hashes,next_actions=actions,limits=runtime['limits']+['Four model transitions and playback verified in explicit diagnostic fixture; no ordinary combat destruction or six-client victory qualification.','No native BLND loop semantic qualification, no separate joint pose motion comparison.'])
save('docs/destroyed_animation_runtime_progress.json',receipt)
archive=r/'docs/plan_history'/('destroyed-animation-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,destroyed_animation_runtime_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions));d['last_verified']['client_tests']=223
 else:d['current_evidence'].update(client_tests_passed=223,current_test_receipt='docs/destroyed_animation_runtime_progress.json',current_build_receipt='docs/destroyed_animation_runtime_progress.json',current_client_sha256=hashes['target/debug/openleague-client.exe'],destroyed_structure_animation_diagnostic_runtime_verified=True,destroyed_structure_animation_runtime_verified=False,current_binary_hud_visual_verified=False,current_spatial_registry_vulkan_capture_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=actions
 save(p,d)
objective=(r/'docs/goal_objective_current_request.txt').read_text(encoding='utf-8');i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier les règles natives BLND de boucle/événements, poses et effets ; vérifier la destruction par combat normal. Les quatre modèles détruits apparaissent dans le client Vulkan ; remplacement réseau, rôle death et lecture répétée des clips observés dans un scénario diagnostique explicite.223 tests et compilation réussis. Masque/rendu WALL, tous les kits, six clients jusqu’à victoire et tous les24domaines restent ouverts.'+objective[j:]
(r/'docs/goal_objective_current_request.txt').write_text(objective,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Débris animés dans le client Vulkan</h2><p>4 modèles et lectures de clips vérifiés dans un scénario diagnostique réseau explicite.223 tests et compilation réussis. Destruction par combat normal et fidélité des boucles restent ouvertes.</p><a href="destroyed_animation_runtime_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['install_destroyed_animation_probe.py','capture_destroyed_animation_probe.py','record_destroyed_animation_runtime.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(models=4,client_tests=223,diagnostic_fixture=True,full_goal_complete=False,hashes=len(hashes))))
