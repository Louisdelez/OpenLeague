from pathlib import Path
import json,hashlib,datetime,shutil
exec(Path('E:/mapslol3v3/qualify_structure_native_pose.py').read_text().split('reports=[]')[0])
now=datetime.datetime.now(datetime.timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
p='docs/normal_structure_finished_animation_validation.json';d=load(p)
assert d['normal_server'] and not d['diagnostic_fixture'] and d['destruction_observed'] and d['initial_health']==2050.
assert d['health_history'][-1]['health']==0 and any(x['roster']==6 for x in d['health_history'])
assert d['client_sha256']==sha('target/debug/openleague-client.exe') and d['server_sha256']==sha('target/debug/openleague-server.exe')
assert 'Finished `dev`' in (r/'logs/structure-normal-server-build.log').read_text(encoding='utf-8-sig')
prefix='logs/normal-structure-finished-animation';rows=[json.loads(line) for line in (r/(prefix+'.jsonl')).read_text().splitlines()]
actors=[a for row in rows for a in row['actors'] if a['id']==d['target_id'] and a['model']=='TT_ChaosTurret2_destroyed' and a['role']=='death'];assert len(actors)>10
binding=load('data/4.20/structure_clip_playback.json')['models']['TT_ChaosTurret2_destroyed']['death'];assert not binding['repeat']
finished=[a for a in actors if len(a['active_clips'])==1 and a['active_clips'][0]['finished']];assert len(finished)>5
source=next(m for m in sources if m['alias']=='DestroyedTower');raw=Path(source['clip']).read_bytes();assert hashlib.sha256(raw).hexdigest()==source['clip_sha256'];resource,hashes,frames,step,adapter=parsed_resource(raw);g,b=glb(r/'assets'/source['asset']);names=[g['nodes'][node]['name'] for node in g['skins'][0]['joints']];indices=[hashes.index(elf(name)) for name in names];errors=[]
for a in finished:
 active=a['active_clips'][0];assert active['completions']==1 and abs(active['seek_time']-binding['gltf_endpoint'])<1e-6
 frame=active['seek_time']/binding['gltf_time_step'];poses_native=execute(resource,f32(frame*step),indices);actual={j['name']:j for j in a['joint_pose']}
 for name,pose in zip(names,poses_native):
  observed_joint=actual[name];translation=max(abs(x-y) for x,y in zip(pose[:3],observed_joint['translation']));nq=normalized(pose[6:]);aq=normalized(observed_joint['rotation']);rotation=min(max(abs(x-y) for x,y in zip(nq,aq)),max(abs(x+y) for x,y in zip(nq,aq)));assert translation<.001 and rotation<1e-5;errors.append((translation,rotation))
tail=finished[-5:];assert len({json.dumps(a['active_clips'],sort_keys=True) for a in tail})==1
d.update(animation_finished=True,animation_completions=1,retained_seek_time=tail[-1]['active_clips'][0]['seek_time'],retained_pose_native_comparison=True,native_pose_adapter=adapter,finished_samples=len(finished),joint_pose_samples=len(errors),max_translation_error=max(x[0] for x in errors),max_normalized_quaternion_error=max(x[1] for x in errors),probe_sha256=sha(prefix+'.jsonl'),visual_inspected=True,visual_inspection_required=False)
d['limits']=[x for x in d['limits'] if not x.startswith('Existing server executable')]+['Normal server rebuilt from current sources before this run. Six-player roster observed; five UDP controls plus one graphical client remain narrower than six graphical clients and full match qualification.','Original destruction materials/events, other structures, respawn/protection and victory/results remain incomplete.'];save(p,d)
paths=[p,prefix+'.jsonl',prefix+'.png',prefix+'.client.log',prefix+'.server.log','logs/structure-normal-server-build.log','target/debug/openleague-server.exe','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,normal_structure_destruction_verified=True,current_binary_retained_final_pose_verified=True,client_tests_passed=226,client_build_passed=True,target_name=d['target_name'],target_id=d['target_id'],initial_health=d['initial_health'],death_tick=d['health_history'][-1]['tick'],finished_samples=len(finished),joint_pose_samples=len(errors),max_translation_error=d['max_translation_error'],max_normalized_quaternion_error=d['max_normalized_quaternion_error'],files_sha256={p:sha(p) for p in paths},limits=d['limits'])
audit=json.loads(Path('E:/mapslol3v3/map10_inhibitor_timer_source_audit.json').read_text());assert audit['qualified_barrack_spawn_disable_seconds']==240 and audit['qualified_native_inhibitor_respawn_seconds'] is None
save('data/4.20/map10_inhibitor_timer_source_audit.json',audit);receipt['files_sha256']['data/4.20/map10_inhibitor_timer_source_audit.json']=sha('data/4.20/map10_inhibitor_timer_source_audit.json');receipt['barrack_spawn_disable_seconds']=240;receipt['native_inhibitor_respawn_qualified']=False
save('docs/normal_structure_finished_animation_progress.json',receipt)
actions=['Finish native structure materials/FX and ordinary inhibitor respawn/protection/nexus victory/results; current outer tower destruction and retained native-equivalent final pose verified on current client/server.','Qualify native legacy ANM/resource/skeleton loaders and full BLND state selection; full simple constructor and uncompressed pose calculations already executed with explicit resource adapters.','Connect vision to normal brush mask/WALL and complete all122champion kits, all24domains, six graphical clients through victory/results and autonomous delivery.']
archive=r/'docs/plan_history'/('normal-structure-finished-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,archive/name);plan=load(path);plan.update(updated_utc=now,complete=False,normal_structure_finished_animation_progress=receipt)
 if name=='resume_checkpoint.json':plan.update(saved_utc=now,pending_native_jobs=[],next_projected_action=' '.join(actions))
 else:plan['current_evidence'].update(current_binary_normal_turret_destruction_verified=True,current_binary_normal_destroyed_final_pose_verified=True)
 if name=='completion_plan.json':plan['next_execution_steps']=actions
 save(path,plan)
objective=r/'docs/goal_objective_current_request.txt';text=objective.read_text(encoding='utf-8');i=text.index('PROCHAINE ÉTAPE :');j=text.index('\n\nOUTILS :',i)
text=text[:i]+'PROCHAINE ÉTAPE : achever matériaux/effets natifs, réapparition/protection des inhibiteurs, victoire et résultats. Une tour normale détruite sur les binaires actuels à six joueurs : modèle remplacé, animation terminée après une lecture et pose finale comparée au calcul natif. Construction simple de48états et poses de16modèles qualifiées avec adaptateurs explicites. Délai de suppression des vagues de240secondes retrouvé ; réapparition native des inhibiteurs et chargeurs/sélection BLND complète restent ouverts.226tests client et compilation réussis ; tous les24domaines et la livraison restent inachevés.'+text[j:];objective.write_text(text,encoding='utf-8')
import html
(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>Goal actualisé</title><pre>'+html.escape(text)+'</pre></html>',encoding='utf-8')
page=r/'docs/completion_plan.html';text=page.read_text(encoding='utf-8');page.write_text(text.replace('</body>','<section><h2>Destruction normale et pose finale</h2><p>Tour détruite par les commandes ordinaires sur les exécutables actuels ; débris capturés, animation terminée après une lecture, pose finale stable et comparée au calculateur natif. Six joueurs comprennent cinq contrôleurs UDP et un client graphique. Réapparitions, effets, victoire et résultats restent ouverts.</p><a href="normal_structure_finished_animation_progress.json">Preuves et limites</a></section></body>'),encoding='utf-8')
for name in ['verify_normal_structure_finished_animation.py','record_normal_structure_finished_animation.py','verify_normal_structure_finished_animation_v2.py','record_normal_structure_finished_animation_v2.py','audit_native_map10_inhibitor_timers.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(normal_tower_destruction=True,death_tick=receipt['death_tick'],finished_samples=len(finished),joint_pose_samples=len(errors),full_goal_complete=False)))
