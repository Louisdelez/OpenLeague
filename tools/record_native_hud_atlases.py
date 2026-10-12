from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
testlog='logs/native-hud-atlases-tests.log';buildlog='logs/native-hud-atlases-build.log'
tests=re.search(r'test result: ok\. (\d+) passed; 0 failed', (r/testlog).read_text(encoding='utf-8'))
assert tests and int(tests[1])>=279;assert 'Finished' in (r/buildlog).read_text(encoding='utf-8')
capture=load('docs/native_hud_atlases_capture.json');profiles=load('docs/native_hud_atlases_profiles_capture.json');gpu=load('logs/native-hud-atlas-gpu.json');readback=load('logs/native-hud-shadow-atlas-readback.json')
assert profiles['visual_inspected'] and profiles['archive_restored'] and profiles['user_config_unchanged'] and len(profiles['captures'])==2
for c in profiles['captures']:
 assert c['visual_inspected'] and c['client_sha256']==sha('target/debug/openleague-client.exe')
 g=json.loads(Path(c['atlas_gpu_receipt']).read_text());b=json.loads(Path(c['shadow_atlas_readback']).read_text())
 assert g['atlas_count']==5 and b['native_bytes_equal'] and b['bytes']==b['expected_bytes']==4194304
assert capture['visual_inspected'] and capture['client_sha256']==sha('target/debug/openleague-client.exe')
assert gpu['atlas_count']==5 and all(v['gpu_prepared'] for v in gpu['entries'])
assert readback['native_bytes_equal'] and readback['bytes']==readback['expected_bytes']==4194304
assert hashlib.sha256(Path(capture['capture']).read_bytes()).hexdigest()==capture['capture_sha256']
catalog=load('data/4.20/native_zip_catalog.json')
for v in catalog['archives']:
 if v['path'].endswith('/HUD.zip'):
  expected=v.get('sha256')
  if expected:assert sha(v['path'])==expected
artifacts=load('docs/native_hud_atlases_pending.json')['artifacts']+[testlog,buildlog,'docs/native_hud_atlases_capture.json','docs/native_hud_atlases_profiles_capture.json','logs/native-hud-atlas-gpu.json','logs/native-hud-shadow-atlas-readback.json','logs/native-hud-atlas-gpu-missing-eocd.json','logs/native-hud-shadow-atlas-readback-missing-eocd.json']
action='Cinq atlas HUD originaux chargés et préparés sur GPU ; données DDS/mipmaps conservées, ShadowIsles BGRA lu sur GPU et comparé octet par octet. Rect144cas et UV240cas natifs portés. Qualifier le parseur source HUD, Anchor/Scale et la transformation en pixels avant de rendre les703widgets originaux avec interactions. Achever carte/zones bleues, simulation, champions et tous les24domaines.'
receipt=dict(updated_utc=now,complete=False,client_source_tests_passed=int(tests[1]),client_application_rebuilt=True,client_test_source_matches_current_build=True,application_binary_sha256=sha('target/debug/openleague-client.exe'),native_texture_filename_cases=608,native_texture_filename_ported=True,native_hud_defaults_cases=4,native_hud_rect_cases=144,native_hud_uv_cases=240,native_hud_math_ported=True,native_hud_layout_files=32,native_hud_layout_elements=703,hud_layout_applied=False,gpu_atlas_runtime_verified=True,atlas_count=5,shadow_atlas_native_bytes_equal=True,capture=capture,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=['GPU byte equality only for uncompressed ShadowIsles base mip; compressed GPU atlases have allocation/format/mip preparation proof.','Original sampler, gamma, compositing, source scanner grammar, layout, widget visibility and interactions remain open.','Rect/UV mathematical qualification uses supplied formatted-scanner outputs; no complete native parser claim.','Current scene has blue uncovered map regions and development HUD.','No complete six-client graphical match or complete game qualification.'])
receipt.update(native_hud_anchor_cases=96,native_hud_anchor_ported=True,profiles=profiles,archive_restored=True,user_config_unchanged=True)
save('docs/native_hud_atlases_progress.json',receipt)
save('docs/native_hud_atlases_build_receipt.json',dict(updated_utc=now,game_complete=False,client_source_tests=int(tests[1]),test_log=testlog,build_log=buildlog,client_sha256=receipt['application_binary_sha256'],runtime_proof='docs/native_hud_atlases_capture.json',scope='Native HUD atlas loading/GPU preparation, Rect/UV arithmetic; no complete original HUD/game proof.'))
history=r/'docs/plan_history'/('native-hud-atlases-qualified-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_atlases_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_tests=int(tests[1]),client_test_source_matches_current_build=True,pending_client_build=False,native_hud_atlas_runtime=True,current_client_build_receipt='docs/native_hud_atlases_build_receipt.json',native_hud_atlases_progress='docs/native_hud_atlases_progress.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save('docs/'+name,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>',f'<section><h2>Atlas HUD GPU vérifiés</h2><p>{int(tests[1])}tests client passent ;5atlas GPU préparés,4194304octets ShadowIsles comparés sur GPU. Rect144cas/UV240cas portés. Disposition et interface historique encore ouvertes.</p><a href="native_hud_atlases_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_tests=int(tests[1]),atlas_count=5,shadow_gpu_bytes=4194304,layout_applied=False,complete=False)))
