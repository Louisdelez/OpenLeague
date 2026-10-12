from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(n):return json.loads((r/'docs'/n).read_text(encoding='utf-8-sig'))
def save(n,d):(r/'docs'/n).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
results=[]
for version in ['v14_native_dx12','v15_native_vulkan']:
 p=load('projected_pair_control_'+version+'.json');capture=load('projected_core_cycle_capture_'+version+'.json');assert p['same_frame_attribution_gate_passed'] and p['strict_baseline_equal'];assert not p['diagnostic_no_gamma'] and not p['diagnostic_no_msaa']
 prefix='projected-core-cycle-'+version.replace('_','-');log=r/'logs'/(prefix+'-client.log');assert 'Native General/Antialiasing=0 MSAA_samples=0 quality=0' in log.read_text(encoding='utf-8-sig')
 pipeline=r/'logs'/(prefix+'-pipeline.json');frames=json.loads(pipeline.read_text())['frames'];assert all(d['pipeline_states'] and all(s=='ready' for s in d['pipeline_states']) and d['fow_ready']==1 for f in frames for d in f['draws'])
 assert len(capture['measurements'])==2 and capture['measurements'][-1]['cleaned']==2 and capture['measurements'][-1]['active_draws']==0
 results.append(dict(version=version,baseline=p['baseline'],instances=p['instances'],pair_receipt='docs/projected_pair_control_'+version+'.json',capture_receipt='docs/projected_core_cycle_capture_'+version+'.json',pipeline_frames=len(frames),nonready_pipeline_frames=0,client_log_sha256=hashlib.sha256(log.read_bytes()).hexdigest(),pipeline_sha256=hashlib.sha256(pipeline.read_bytes()).hexdigest(),client_sha256=capture['client_sha256']))
assert results[0]['client_sha256']==results[1]['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
receipt='native_multisample_runtime_progress.json';proof=dict(updated_utc=now,complete=False,passed=True,client_sha256=results[0]['client_sha256'],build_log='logs/native-multisample-client-build.log',build_log_sha256=hashlib.sha256((r/'logs/native-multisample-client-build.log').read_bytes()).hexdigest(),native_selection_progress='docs/native_multisample_selection_progress.json',native_default_selection_runtime_observed=True,diagnostic_sampling_override=False,gamma_override=False,reconstructed_projection_consumer_attribution_passed_both_backends=True,original_gpu_fidelity_qualified=False,runs=results,visual_inspection=dict(inspected=True,versions=['v14_native_dx12','v15_native_vulkan'],observed='On/off paired images visually inspected: warm ground glow appears with projection, absent in off image; actor silhouettes remain visible.',human_fidelity_acceptance=False),limits=['Paired offscreen cameras clone the ordinary camera configuration; difference attribution is scoped to reconstructed projection consumer and diagnostic seeded fixture.', 'Default Antialiasing0 applied to ordinary camera; user2x/4x selection tested as source but not graphically rerun here.', 'Core native particle cycle is implemented; native missile owner pose/scale/factors and complete original GPU blend/sampler/receiver fidelity remain open.', 'Optional native FXAA shader source recovered but GPU implementation still missing; full Annie kit, audio, 24 domains and complete game remain incomplete.'])
save(receipt,proof)
p=load('native_multisample_pending.json');p.pop('session_id',None);p.update(updated_utc=now,status='terminal_build_and_both_graphical_captures_passed',progress='docs/'+receipt);save('native_multisample_pending.json',p)
p=load('native_multisample_selection_progress.json');p.update(updated_utc=now,build_complete=True,ordinary_camera_current_executable_qualified=True,gpu_capture_qualified=True,runtime_progress='docs/'+receipt,limits=proof['limits']);save('native_multisample_selection_progress.json',p)
next_action='Qualifier la pose native du propriétaire de la projection d’Annie, ses facteurs de scale/alpha et les récepteurs terrain ; poursuivre la fidélité GPU/audio, intégrer le shader FXAA optionnel puis exécuter tous les travaux des 24 domaines.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=load(name);p.update(updated_utc=now,native_multisample_runtime_progress='docs/'+receipt)
 if name=='resume_checkpoint.json':p.pop('pending_native_multisample',None);p.update(saved_utc=now,next_projected_action=next_action)
 elif name=='completion_plan.json':p['next_execution_steps'][0]=next_action
 elif name=='goal_plan_revision.json':p['next_steps']=[next_action]
 if name!='goal_plan_revision.json':
  evidence=p['last_verified'] if name=='resume_checkpoint.json' else p['current_evidence'];evidence.update(current_client_sha256=proof['client_sha256'],ordinary_camera_msaa_runtime_qualified=True,annie_projection_reconstructed_dx12_pixel_attribution_qualified=True,annie_projection_reconstructed_vulkan_pixel_attribution_qualified=True,annie_projection_full_original_fidelity_qualified=False)
 save(name,p)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 text=path.read_text(encoding='utf-8');path.write_text(re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)','PROCHAINE ÉTAPE : '+next_action,text,flags=re.S),encoding='utf-8')
for name in ['completion_plan.json','goal_plan_revision.json']:
 p=load(name)
 if name=='completion_plan.json':p['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8')
 else:p['objective_sha256']=hashlib.sha256((r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_bytes()).hexdigest()
 save(name,p)
html=r/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');html.write_text(text.replace('</body>','<section><h2>Rendu avec MSAA natif — vérification graphique</h2><p>Client recompilé, puis quatre lancements de sort sur le même exécutable. DirectX 12 : 32 références identiques ; Vulkan : 61 références identiques. Contributions des deux projections isolées sur chaque backend, nettoyage observé. 26 images de pipeline prêtes et brouillard lié. Images avant/après inspectées. Réglage natif utilisé, sans override diagnostic de gamma ou MSAA. La pose native complète, le shader FXAA optionnel et la fidélité au GPU original restent à qualifier.</p><p><a href="native_multisample_runtime_progress.json">Preuves graphiques et limites</a></p></section></body>'),encoding='utf-8')
for n in ['inspect_native_msaa_pipeline.py','finalize_native_multisample_runtime.py']:shutil.copy2(Path('E:/mapslol3v3')/n,r/'tools'/n)
print(json.dumps(dict(passed=True,client_sha256=proof['client_sha256'],dx12_baseline=32,vulkan_baseline=61,casts=4,full_game_complete=False)))
