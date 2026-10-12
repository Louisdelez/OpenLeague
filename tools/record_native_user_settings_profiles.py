from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
from PIL import Image
import numpy as np
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
captures=load('docs/native_user_settings_profiles_capture.json');assert captures['configuration_restored'] and not (r/'Config/Game.cfg').exists()
assert [p['actual_environment_quality'] for p in captures['captures']]==[3,1,4]
assert [p['actual_user_file_loaded'] for p in captures['captures']]==[False,True,True]
binary=sha('target/debug/openleague-client.exe');assert binary==captures['client_sha256']
assert 'Finished `dev` profile' in (r/'logs/native-user-settings-build.log').read_text(encoding='utf-8')
arrays={};artifacts=['logs/native-user-settings-build.log','logs/native-user-settings-tests.log','crates/client/src/native_user_settings.rs','crates/client/src/main.rs','assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl']
for capture in captures['captures']:
 name=capture['configuration_profile'];assert capture['client_sha256']==binary
 path=Path(capture['capture']);assert sha(path.relative_to(r).as_posix())==capture['capture_sha256']
 with Image.open(path) as img:assert img.size==(1280,800);arrays[name]=np.asarray(img.convert('RGB')).astype(np.int16)
 capture.update(visual_inspected=True,inspection_notes=['Map base, terrain, structures and readable French HUD render.','Low/high scene fog appearance differs; blue background gaps around base remain visible.','No original framebuffer reference or full map visual acceptance established.'])
 save(f'docs/chaos_base_user_settings_{name}_capture.json',capture)
 artifacts.extend([path.relative_to(r).as_posix(),f'logs/chaos-base-user-settings-{name}-scene.client.log',f'docs/chaos_base_user_settings_{name}_capture.json'])
delta=np.abs(arrays['low'][:670]-arrays['high'][:670]);metrics=dict(scope='RGB map region y0..669 excludes HUD; effects/cloud clock timing not synchronized.',mean_absolute_channel_delta=float(delta.mean()),pixels_any_channel_delta_over_8=int((delta.max(axis=2)>8).sum()),compared_pixels=1280*670)
assert metrics['pixels_any_channel_delta_over_8']>1000
captures.update(visual_inspected=True,low_high_image_difference=metrics);save('docs/native_user_settings_profiles_capture.json',captures);artifacts.append('docs/native_user_settings_profiles_capture.json')
action='Client reconstruit e7a98a et trois captures réelles inspectées : Game.cfg absent donne3 ; fichier utilisateur niveau1 puis4 effectivement lu et rendu. Configuration restaurée ; suite source255tests et mêmes sources construites, preuve runtime ciblée. Zones bleues près de la base persistent ; fidélité globale de carte encore ouverte. Qualifier cache8ACEF0/classifieur8B3140/noms localisés, relier menu/persistance et toutes variantes/LOD ; poursuivre passe Wall_of_Grass/options globales, référence/rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
receipt=dict(updated_utc=now,complete=False,application_rebuilt=True,application_binary_sha256=binary,application_configuration_file_load_verified=True,application_profiles_verified=[3,1,4],actual_user_file_loaded_verified=True,configuration_restored=True,captures_visual_inspected=True,client_source_tests_passed=255,client_test_source_matches_current_build=True,client_tests_current_binary=False,client_tests_current_binary_reason='255 tests execute in separate test executable; current production binary has targeted runtime captures.',known_blue_background_gaps_visible=True,ordinary_six_graphical_client_match_complete=False,configuration_cache_qualified=False,native_mode_classifier_qualified=False,localized_settings_filenames_qualified=False,option_menu_and_live_persistence_complete=False,low_high_image_difference=metrics,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},limits=captures['limits']+['Native setting read and current rendered profile verified, not every quality-dependent LOD/material/global option or full native cache/filesystem equivalence.','External Vulkan loader reports stale TikTok layer JSON path; current scenes still render.','Existing environment-quality log text says original PE initial profile even when actual Game.cfg quality is loaded; initial Game.cfg trace and captured actual_quality fields are authoritative.'],next_action=action)
save('docs/native_user_settings_runtime_progress.json',receipt)
archive=r/'docs/plan_history'/('native-user-settings-runtime-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_user_settings_runtime_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=255,client_tests_current_binary=False,client_test_source_matches_current_build=True,client_binary_sha256=binary,user_config_application_capture_verified=True,user_config_runtime_profiles=[3,1,4],user_config_restored_after_probe=True,user_config_captures_inspected=True)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
p=r/'docs/completion_plan.html';text=p.read_text(encoding='utf-8');text=text.replace('</body>','<section><h2>Game.cfg vérifié sur le nouveau client</h2><p>Client reconstruit ; trois captures inspectées : valeurs par défaut3, utilisateur1 puis4. Chargement réel et effet visuel du profil vérifiés ; configuration initiale restaurée. Suite source255tests. Les zones bleues près de la base persistent ; cache, classifieur natif, noms localisés, menu, persistance et carte/jeu complets restent ouverts.</p><a href="native_user_settings_runtime_progress.json">Preuves et limites</a></section></body>');p.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_sha256=binary,profiles=[3,1,4],configuration_restored=True,visual_inspected=True,mean_delta=metrics['mean_absolute_channel_delta'],complete=False)))
