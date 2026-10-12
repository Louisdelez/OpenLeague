from pathlib import Path
import sys,json,datetime,hashlib,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import numpy as np
from PIL import Image
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
build=(r/'logs/native-fog-consumer-build.log').read_text(encoding='utf-8-sig');assert 'Finished `dev` profile' in build
tests=(r/'logs/native-fog-consumer-client-tests.log').read_text(encoding='utf-8-sig');assert '238 passed; 0 failed' in tests
capture=load('docs/chaos_base_native_fog_capture.json');binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary==capture['client_sha256']
im=Image.open(capture['capture']).convert('RGB');prior=Image.open(r/'logs/chaos-base-normal-scene.png').convert('RGB');crop=np.array(im.crop((900,80,1220,480)));cyan=int(np.all(crop==[34,62,84],axis=2).sum());assert cyan>0
diff=np.abs(np.asarray(im,dtype=np.int16)[:650]-np.asarray(prior,dtype=np.int16)[:650]);comparison=dict(region=[0,0,1280,650],changed_pixels=int(np.any(diff!=0,axis=2).sum()),maximum_channel_difference=int(diff.max()),limits='Two fixed-camera captures at different live ticks; not a deterministic original-renderer equivalence test.')
capture.update(visual_inspected=True,clear_background_defect_still_present=True,exact_clear_pixels_in_crop=cyan,crop=[900,80,1220,480],prior_scene_comparison=comparison);save('docs/chaos_base_native_fog_capture.json',capture)
receipt=load('docs/native_fog_consumer_progress.json');receipt.update(updated_utc=now,application_binary_rebuilt=True,application_binary_sha256=binary,pending_jobs=[],client_tests_passed=238,current_capture='docs/chaos_base_native_fog_capture.json',current_capture_inspected=True,base_chaos_defect_fixed=False,gamma_pipeline_candidates='data/4.20/native_gamma_pipeline_candidates.json');receipt['limits']=[x for x in receipt['limits'] if not x.startswith('Old executable')];receipt['limits'].append('Current native-parameter build captured under normal local server and fixed camera; earlier nexus/endgame/ordinary-tower runtime proofs refer to prior executable hashes and were not rerun.');save('docs/native_fog_consumer_progress.json',receipt)
action='Qualifier le créateur de table gamma original0x7411e0, ses paramètres Gamma.ini chargés par0x741130 et son activation/passe0x741640 ; PS_GAMMA remappe séparément R/G/B via table et force alpha1. Éviter de supposer que la table supprime les trous ; vérifier la composition complète. Zones cyan toujours ouvertes. Puis poursuivre les24domaines, cérémonie/réseau/launcher et qualification normale à six clients graphiques.'
archive=r/'docs/plan_history'/('native-fog-current-capture-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_fog_consumer_progress=receipt)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=action);d['last_verified'].update(client_tests=238,current_client_sha256=binary,native_fog_new_binary_capture_inspected=True)
 else:d['current_evidence'].update(client_tests=238,current_client_sha256=binary,native_fog_parameter_new_binary_captured=True,chaos_base_visual_defect_fixed=False,current_binary_endgame_runtime_requalified=False,current_binary_normal_structure_runtime_requalified=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p='docs/build_receipt.json';d=load(p);archive_name=archive/'build_receipt.json';shutil.copy2(r/p,archive_name);d['current_client_build']=dict(updated_utc=now,path='target/debug/openleague-client.exe',sha256=binary,bytes=(r/'target/debug/openleague-client.exe').stat().st_size,build_log='logs/native-fog-consumer-build.log',client_tests=238,test_log='logs/native-fog-consumer-client-tests.log',capture='docs/chaos_base_native_fog_capture.json',only_client_rebuilt=True,other_top_level_receipt_values_historical=True);d['game_complete']=False;save(p,d)
for name in ['capture_chaos_native_fog_scene.py','locate_native_gamma_pipeline.py','inspect_native_gamma_values.py','record_native_fog_current_capture.py']:shutil.copy2(stage/name,r/'tools'/name)
shutil.copy2(stage/'inspect_native_clear_callers.py',r/'tools/inspect_native_clear_callers.py')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');p.write_text(s.replace('</body>','<section><h2>Nouvel exécutable et capture inspectée</h2><p>238tests client réussis. Client recompilé avec constantes natives, capture Vulkan inspectée avec serveur normal et caméra fixe. Les zones cyan persistent. Suite : qualifier création, paramètres et activation de la table gamma, puis composition du rendu. Jeu incomplet.</p><a href="chaos_base_native_fog_capture.json">Capture et empreintes</a></section></body>'),encoding='utf-8')
print(json.dumps(dict(client_tests=238,binary_sha256=binary,crop_clear_pixels=cyan,comparison=comparison,pending_jobs=[],complete=False)))
