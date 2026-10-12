from pathlib import Path
import json,datetime,hashlib,shutil,sys
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
artifacts=['crates/client/src/native_texture_filename.rs','crates/client/src/native_hud_atlases.rs','crates/client/src/native_hud_rect.rs','crates/client/src/native_hud_uv.rs','crates/client/src/native_zip_provider.rs','data/4.20/native_texture_filename_contract.json','data/4.20/native_hud_defaults_contract.json','data/4.20/native_hud_layout_source_audit.json','data/4.20/native_hud_rect_math_contract.json','data/4.20/native_hud_uv_property_contract.json']
action='Terminer la compilation/test client en cours (session23480), corriger si nécessaire, reconstruire puis vérifier les cinq atlas HUD DDS sur GPU et les octets du ShadowIslesHUDAtlas par lecture GPU. Rect natifs qualifiés sur144cas et portés dans les sources ; découpage/rendu des widgets et disposition native encore ouverts. Qualifier UV/Anchor/Scale puis appliquer le HUD historique ; poursuivre carte, gameplay et tous les domaines.'
receipt=dict(updated_utc=now,complete=False,source_changes=True,application_rebuilt=False,client_test_source_matches_current_build=False,last_qualified_tests=273,last_qualified_build_receipt='docs/native_zip_fallback_build_receipt.json',current_binary_sha256=sha('target/debug/openleague-client.exe'),native_texture_filename_cases=608,native_texture_filename_ported=True,native_hud_defaults_cases=4,native_hud_layout_files=32,native_hud_layout_elements=703,native_hud_rect_cases=144,native_hud_rect_ported=True,hud_layout_applied=False,gpu_atlas_runtime_verified=False,artifacts=artifacts,hashes={p:sha(p) for p in artifacts},next_action=action,limits=['Source port pending full client test/build/runtime qualification.','Rect formatted scanner supplied as a boundary adapter; original scanning grammar remains open.','Layout inventory is not a native parser or widget/rendering proof.','Map blue regions, complete six-client graphical match and all24domains remain open.'])
artifacts.extend(['crates/client/src/native_hud_anchor.rs','data/4.20/native_hud_anchor_contract.json'])
build_pending='--build' in sys.argv
receipt.update(native_hud_uv_cases=240,native_hud_uv_ported=True,native_hud_anchor_cases=96,native_hud_anchor_ported=True,artifacts=artifacts,hashes={p:sha(p) for p in artifacts})
if build_pending:
 assert '279 passed; 0 failed' in (r/'logs/native-hud-atlases-tests.log').read_text(encoding='utf-8')
 receipt.update(client_source_tests_passed=279,client_test_log='logs/native-hud-atlases-tests.log')
 receipt['next_action']=receipt['next_action'].replace('Terminer la compilation/test client en cours (session23480), corriger si nécessaire, reconstruire','279tests client passent ; terminer la reconstruction en cours (session35684)')
receipt['next_action']=receipt['next_action'].replace('Qualifier UV/Anchor/Scale','UV9A2590 qualifié sur240cas et porté, Anchor96cas qualifié et porté ; qualifier Scale et intégrer Rect/UV/Anchor')
action=receipt['next_action']
p=r/'docs/native_hud_atlases_pending.json';p.write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('native-hud-atlases-pending-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_atlases_progress=receipt)
 evidence=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];evidence.update(client_test_source_matches_current_build=False,pending_client_build=True,native_hud_atlases_progress='docs/native_hud_atlases_pending.json')
 if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[dict(session_id=35684 if build_pending else 23480,type='cargo-client-build' if build_pending else 'cargo-client-tests',log='logs/native-hud-atlases-build.log' if build_pending else 'logs/native-hud-atlases-tests.log',state='running_confirmed_at_checkpoint')])
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>HUD natif : qualification en cours</h2><p>Sources DDS/normalisation portées ;144cas Rect natifs qualifiés et portés. Compilation/tests en cours.703éléments inventoriés, disposition et rendu historique encore ouverts.</p><a href="native_hud_atlases_pending.json">Etat et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(native_uv_cases=144,source_ported=True,application_rebuilt=False)))

