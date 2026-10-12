from pathlib import Path
import json,hashlib,datetime,shutil,html
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
tests=(r/'logs/native-camera-pan-tests.log').read_text(encoding='utf-8-sig')
for count in [430,233,1]:assert f'test result: ok. {count} passed; 0 failed' in tests
for name in ['native-camera-pan-build.log','native-camera-pan-observer-build.log']:assert 'Finished `dev`' in (r/'logs'/name).read_text(encoding='utf-8-sig')
visual=load('docs/native_camera_pan_visual_validation.json')
assert visual['native_controller_bit_exact_samples']==visual['runtime_samples'] and visual['stable_endpoint']
visual.update(visual_inspected=True,visual_observation='Victory banner and full Continue button visible; camera over losing Chaos base. Exposed flat cyan regions and dark geometry remain visible around the environment and require scene investigation. This is not complete map fidelity.')
save('docs/native_camera_pan_visual_validation.json',visual)
paths=['crates/core/src/camera_pan.rs','crates/core/src/match_results.rs','crates/client/src/camera_native.rs','crates/client/src/main.rs','crates/client/src/native_endgame_ui.rs','data/4.20/native_camera_pan_contract.json','logs/native-camera-pan-tests.log','logs/native-camera-pan-build.log','logs/native-camera-pan-observer-build.log','logs/endgame-camera-pan-runtime.jsonl','logs/native-camera-pan.png','target/debug/openleague-client.exe','target/debug/openleague-server.exe','target/debug/examples/match_results_fixture.exe']
receipt=dict(updated_utc=now,complete=False,core_tests_passed=430,client_tests_passed=233,server_store_tests_passed=1,native_controller_cases=176,runtime_native_comparisons=visual['runtime_samples'],visual=visual,files_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths},limits=['Diagnostic fixture injects winner; no ordinary complete six graphical client victory proved.','Original request/update/curve/cleanup executed with isolated allocator, camera/service descriptors and preallocated vector; growth path and follow-lock side effect bypassed. Lua point conversion, owner resolution and full renderer initialization not executed.','233 functional client tests precede readonly pan_now observer addition; final observer build and runtime comparisons verified separately.','First-receipt local phase clock; latency, authoritative phase messages, reconnect and native configuration overrides remain open.','Delayed nexus skin, audio/minion fades, losing minion no-render and launcher Continue callback remain unfinished.','Scene capture shows exposed cyan regions requiring visual investigation; map fidelity not complete.','Previous ordinary turret/final-pose proof belongs to its recorded older executable; current binary not qualified by that old proof.'])
save('docs/native_camera_pan_progress.json',receipt)
actions=['Raccorder le changement de skin du nexus à3,5s, les fondus audio/minions et l’arrêt de rendu selon les sources natives.','Examiner les régions cyan et géométries sombres visibles dans la capture de la base Chaos ; vérifier ressources, transparence et chargement du décor.','Achever Continue/launcher/services, événements de cérémonie et reconnexion ; qualifier une partie réelle à six clients graphiques.','Poursuivre les exigences des24domaines jusqu’à livraison complète vérifiée.']
archive=r/'docs/plan_history'/('native-camera-pan-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_camera_pan_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions));d['last_verified'].update(core_tests=430,client_tests=233,native_camera_pan_controller_cases=176,native_camera_pan_runtime_samples=visual['runtime_samples'])
 else:d['current_evidence'].update(core_tests=430,client_tests=233,native_camera_pan_runtime_verified=True,current_binary_normal_turret_destruction_verified=False,current_binary_normal_destroyed_final_pose_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=actions
 save(p,d)
text=(stage/'goal-openleague-nouveau-2026-10-05.txt').read_text(encoding='utf-8')
text=text.replace('rendu actuel encore à qualifier','rendu comparé sur248positions et capture inspectée').replace('1. Vérifier la caméra rendue du client compilé contre le contrôleur natif et inspecter la capture.','1. Corriger les défauts visuels observés dans le décor de la base Chaos ; caméra qualifiée sur le rendu actuel.')
(r/'docs/goal_objective_current_request.txt').write_text(text,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(text)+'</pre></html>',encoding='utf-8')
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');p.write_text(text.replace('</body>','<section><h2>Caméra native de fin de partie</h2><p>176 cas natifs et248positions réelles comparés.430tests cœur,233client,1persistance serveur. Capture inspectée ; défauts de décor visibles à corriger. Victoire ordinaire à six clients, cérémonie complète et retour launcher restent ouverts.</p><a href="native_camera_pan_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['qualify_native_camera_pan.py','inspect_native_camera_pan_update.py','integrate_native_camera_pan.py','record_exact_pan_clock.py','verify_native_camera_pan_runtime.py','record_native_camera_pan_progress.py']:shutil.copy2(stage/name,r/'tools'/name)
for name in ['native_camera_pan_update_instructions.json']:shutil.copy2(stage/name,r/'data/4.20'/name)
print(json.dumps(dict(core_tests=430,client_tests=233,runtime_samples=visual['runtime_samples'],complete=False)))
