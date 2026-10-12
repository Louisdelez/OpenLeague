from pathlib import Path
import json,re,hashlib,shutil,datetime
r=Path('E:/OpenLeague');archive=r/'data/4.20/archives/menu/HUD.zip';user=r/'Config/Game.cfg'
assert not user.exists(),'Preserve existing Game.cfg; adapt expectations first.'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
original=archive.read_bytes();original_sha=hashlib.sha256(original).hexdigest()
catalog=json.loads((r/'data/4.20/native_zip_catalog.json').read_text(encoding='utf-8'))
expected=next(a['sha256'] for a in catalog['archives'] if a['path'].endswith('/menu/HUD.zip'));assert original_sha==expected
end=original.rfind(b'PK\x05\x06');assert end>=len(original)-399
mutated=bytearray(original);mutated[end]=0;mutated=bytes(mutated);mutated_sha=hashlib.sha256(mutated).hexdigest();assert b'PK\x05\x06' not in mutated[-399:]
helper=(r/'tools/capture_chaos_base_scene.py').read_text(encoding='utf-8');captures=[];owned=False
try:
 for profile in ['default','missing-eocd']:
  if profile!='default':assert sha(archive)==original_sha;archive.write_bytes(mutated);owned=True
  prefix='chaos-base-zip-fallback-'+profile+'-scene';receipt='chaos_base_zip_fallback_'+profile.replace('-','_')+'_capture.json'
  code=helper.replace('chaos-base-normal-scene',prefix).replace('chaos_base_scene_capture.json',receipt);ns={};exec(compile(code,'ZIP fallback '+profile+' capture','exec'),ns)
  log=(r/'logs'/f'{prefix}.client.log').read_text(encoding='utf-8',errors='replace')
  assert 'panicked at' not in log and 'ShaderValidationError' not in log
  assert 'Native ZIP archives=5 entries=1066 unique_names=1065 FastHUD_bytes=1607 Chat_bytes=1773' in log
  assert 'Game.cfg text_loaded=true defaults_loaded=true merged_entries=387' in log and 'environment_quality=3' in log
  actual_sha=sha(archive);assert actual_sha==(original_sha if profile=='default' else mutated_sha)
  proof=ns['proof'];proof.update(zip_profile=profile,archive_input_sha256=actual_sha,archive_original_sha256=original_sha,archive_count=5,archive_entries=1066,unique_archive_names=1065,fast_hud_bytes=1607,chat_bytes=1773,native_hud_layout_applied=False,missing_eocd_in_last399=profile!='default',fallback_selected_from_input_and_qualified_code=profile!='default',internal_fallback_branch_trace_captured=False,merged_config_entries=387,visual_inspected=False)
  proof['limits'].append('Fallback inferred from absent EOCD in the native399-byte scan window and successful current qualified reader; no separate internal branch trace. Native HUD layout/game fidelity remain open.')
  (r/'docs'/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');captures.append(proof)
  print(json.dumps(dict(profile=profile,capture=proof['capture'],archive_input_sha256=actual_sha)),flush=True)
finally:
 if owned:
  assert sha(archive)==mutated_sha,'Archive changed externally; preserve that change.'
  archive.write_bytes(original)
 assert sha(archive)==original_sha and not user.exists()
summary=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,captures=captures,archive_restored=True,user_config_unchanged=True,archive_original_sha256=original_sha,client_sha256=sha(r/'target/debug/openleague-client.exe'),map_sha256=sha(r/'assets/maps/twisted_treeline.glb'),visual_inspected=False)
(r/'docs/native_zip_fallback_profiles_capture.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(archive_restored=True,profiles=len(captures),client_sha256=summary['client_sha256'])),flush=True)
