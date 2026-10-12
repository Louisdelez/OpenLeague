from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
binding=load('data/4.20/structure_clip_playback.json');native=load('data/4.20/structure_native_lifecycle_contract.json');assert native['passed']
assert '226 passed; 0 failed' in (r/'logs/structure-lifecycle-tests.log').read_text(encoding='utf-8-sig');assert 'Finished `dev`' in (r/'logs/structure-lifecycle-build.log').read_text(encoding='utf-8-sig')
reports=['docs/structure_lifecycle_runtime.json','docs/destroyed_structure_lifecycle_runtime.json'];probes=['logs/structure-lifecycle-runtime.jsonl','logs/destroyed-structure-lifecycle-runtime.jsonl'];measurements={}
for report,probe in zip(reports,probes):
 d=load(report);rows=[json.loads(line) for line in (r/probe).read_text(encoding='utf-8').splitlines()];group={}
 for row in rows:
  for actor in row['actors']:
   c=binding['models'].get(actor['model'],{}).get(actor['role'])
   if c:group.setdefault((actor['model'],actor['role']),[]).append(actor)
 for (model,role),actors in group.items():
  c=binding['models'][model][role];clips=[clip for a in actors for clip in a['active_clips']];assert clips
  completed=[clip for clip in clips if clip['finished']]
  if c['repeat']:
   required_cycles=2 if report=='docs/structure_lifecycle_runtime.json' else 1
   assert not completed,(model,role,'loop incorrectly finished');assert max(clip['completions'] for clip in clips)>=required_cycles,(model,role,'loop not observed')
  else:
   assert completed,(model,role,'one shot never finished')
   for clip in completed:
    assert clip['completions']==1,(model,role,'inherited loop')
    assert abs(clip['seek_time']-c['gltf_endpoint'])<1e-6,(model,role,'final frame not retained',clip)
   tail=[a for a in actors[-5:] if all(clip['finished'] for clip in a['active_clips'])];assert len(tail)==5,(model,role,'final pose not persistent')
   # Finished clips have zero advancement and retain their sampled skeleton transforms.
   assert len({json.dumps(a['active_clips'],sort_keys=True) for a in tail})==1,(model,role,'finished clock still advances')
   assert len({json.dumps(a['joint_pose'],sort_keys=True) for a in tail})==1,(model,role,'finished pose still advances')
  measurements[model+'/'+role]=dict(native_model=c['native_model'],repeat=c['repeat'],samples=len(clips),finished_samples=len(completed),max_completions=max(clip['completions'] for clip in clips),final_seek_time=clips[-1]['seek_time'],gltf_endpoint=c['gltf_endpoint'])
 d.update(lifecycle_measurements={k:v for k,v in measurements.items() if any(a['model']+'/'+a['role']==k for actors in group.values() for a in actors)},limits=['Diagnostic fixture modifies outgoing positions/health/team. Ordinary combat and full match not proved.','Native simple-node repeat/stop/end timing qualified separately and bound to these roles. General blend/state selection, events, native ANM interpolation and materials/FX remain open.','Bevy elapsed is elapsed wall time; qualified retained GLTF seek_time is mapped to the native frame clock.'])
 d.update(visual_inspection_required=False,visual_inspected=True,visual_observations=['Actual Vulkan capture inspected: recovered structure textures and rubble visible.','Diagnostic placement and camera/scenery occlusion limit appearance coverage; full HUD/ordinary gameplay fidelity not validated.'])
 save(report,d)
assert len({v['native_model'] for v in measurements.values()})==16
paths=['crates/client/src/structure_animation_clock.rs','crates/client/src/animation.rs','crates/client/src/main.rs','data/4.20/structure_native_lifecycle_contract.json','data/4.20/structure_clip_playback.json','logs/structure-lifecycle-tests.log','logs/structure-lifecycle-build.log','target/debug/openleague-client.exe','logs/structure-lifecycle-runtime.png','logs/destroyed-structure-lifecycle-runtime.png']+reports+probes
hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths}
for report in reports:assert load(report)['client_sha256']==hashes['target/debug/openleague-client.exe']
actions=['Qualify full native BLND derived construction/state selection and native ANM interpolation, then integrate original structure materials/FX. Simple-node loop/stop/end update now executed; engine stop/continuation callers remain open.','Verify remaining ordinary structure destruction, inhibitor respawn/protection, nexus victory/results on the current binary; diagnostic fixtures do not close gameplay acceptance.','Connect visibility to normal brush mask/WALL; complete all champion kits and all24domains, six-client victory/results and final delivery.']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=226,client_build_passed=True,native_state_cases=48,native_update_cases=960,bound_role_policies=48,diagnostic_native_models_measured=16,lifecycle_measurements=measurements,files_sha256=hashes,next_actions=actions,limits=native['limits']+['Actual loop/end/final pose checks use explicit network diagnostic fixtures. Full controllers, native pose equivalence and ordinary full-game victory/results remain incomplete.'])
save('docs/structure_native_lifecycle_progress.json',receipt)
archive=r/'docs/plan_history'/('structure-native-lifecycle-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,structure_native_lifecycle_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions));d['last_verified']['client_tests']=226
 else:d['current_evidence'].update(client_tests_passed=226,current_test_receipt='docs/structure_native_lifecycle_progress.json',current_build_receipt='docs/structure_native_lifecycle_progress.json',current_client_sha256=hashes['target/debug/openleague-client.exe'],structure_native_simple_loop_end_bound=True,structure_native_controller_complete=False,current_binary_hud_visual_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=actions
 save(p,d)
p=r/'docs/goal_objective_current_request.txt';objective=p.read_text(encoding='utf-8').replace('224 tests','226 tests').replace('224tests','226tests');i=objective.index('PROCHAINE ÉTAPE :');j=objective.index('\n\nOUTILS :',i)
objective=objective[:i]+'PROCHAINE ÉTAPE : qualifier construction et sélection des états BLND complets, interpolation ANM originale, matériaux et effets ; vérifier destructions, réapparitions et victoire en partie. Boucles/fin/arrêt du nœud simple exécutés sur48états et960cas ; règles liées à48rôles et fin/boucles observées sur16modèles diagnostiques.226tests client et compilation réussis. Tous les kits, masque/rendu WALL, six clients jusqu’à victoire et tous les24domaines restent ouverts.'+objective[j:];p.write_text(objective,encoding='utf-8')
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(objective)+'</pre></html>',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Fin et boucles des animations des bâtiments</h2><p>48états et960cas natifs exécutés ;48règles liées au client. Fin, frame finale et boucles observées sur16modèles diagnostiques.226tests et compilation réussis. Contrôleurs complets, effets, destructions ordinaires et match complet restent ouverts.</p><a href="structure_native_lifecycle_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['bind_structure_native_lifecycle.py','clamp_structure_finished_clock.py','capture_structure_native_lifecycle.py','capture_destroyed_structure_native_lifecycle.py','record_structure_native_lifecycle_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(client_tests=226,native_update_cases=960,measured_native_models=16,full_goal_complete=False)))
