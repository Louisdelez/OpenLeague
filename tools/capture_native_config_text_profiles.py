from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');user=r/'Config/Game.cfg';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
# Existing user settings must never be overwritten by this controlled probe.
assert not user.exists(),'Existing user Game.cfg: preserve it and adapt the probe before running.'
user.parent.mkdir(exist_ok=True);results=[];last_owned_sha=None;restored=False
helper=(r/'tools/capture_chaos_base_scene.py').read_text(encoding='utf-8')
try:
 for name,value,expected in [('default',None,3),('low',1,1),('high',4,4)]:
  if value is not None:
   if last_owned_sha is None:assert not user.exists()
   else:assert user.exists() and sha(user)==last_owned_sha,'Config changed externally; keep user change.'
   user.write_bytes(f'[Performance]\nEnvironmentQuality = {value}\n'.encode('ascii'));last_owned_sha=sha(user)
  prefix='chaos-base-config-text-flow-'+name+'-scene';receipt='chaos_base_config_text_flow_'+name+'_capture.json'
  code=helper.replace('chaos-base-normal-scene',prefix).replace('chaos_base_scene_capture.json',receipt)
  ns={};exec(compile(code,'native user settings '+name+' frame capture','exec'),ns)
  log=(r/'logs'/f'{prefix}.client.log').read_text(encoding='utf-8',errors='replace')
  match=re.search(r'Game.cfg defaults=(.+?) user=(.+?) loaded=(true|false) parser_warnings=(\d+) environment_quality=(-?\d+)',log);assert match, 'Game.cfg load receipt missing'
  assert int(match.group(5))==expected and match.group(3)==('false' if value is None else 'true')
  assert 'panicked at' not in log and 'ShaderValidationError' not in log
  merged=re.search(r'Game.cfg text_loaded=(true|false) defaults_loaded=(true|false) merged_entries=(\d+)',log);assert merged
  assert merged.group(1)=='true' and merged.group(2)=='true' and int(merged.group(3))==387
  assert 'Game.cfg layout_mode=0 layout_scores=[2, 0, 1]' in log
  ns['proof'].update(native_text_merge_loaded=True,default_text_loaded=True,merged_entries=387,actual_layout_mode=0,actual_layout_scores=[2,0,1])
  proof=ns['proof'];proof.update(configuration_profile=name,user_input_quality=value,actual_environment_quality=int(match.group(5)),actual_user_file_loaded=match.group(3)=='true',config_input_sha256=None if value is None else last_owned_sha,default_config_path=match.group(1),user_config_path=match.group(2),config_parser_warnings=int(match.group(4)),visual_inspected=False)
  (r/'docs'/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');results.append(proof)
  print(json.dumps(dict(profile=name,loaded_user=proof['actual_user_file_loaded'],quality=proof['actual_environment_quality'],capture=proof['capture'])),flush=True)
finally:
 if last_owned_sha is not None:
  if user.exists():
   assert sha(user)==last_owned_sha,'Config changed externally: original absence not restored; preserve user change.'
   assert user.resolve().parent==r.resolve()/'Config';user.unlink()
 restored=not user.exists()
summary=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,captures=results,initial_user_file_present=False,final_user_file_present=user.exists(),configuration_restored=restored,application_user_file_load_verified=any(p['actual_user_file_loaded'] for p in results),client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),map_sha256=sha(r/'assets/maps/twisted_treeline.glb'),limits=['Actual client captures with normal server, fixed diagnostic camera and screenshot timing. No ordinary six-client completed match.','Quality input/profile startup and rendered scene qualified; menu/live persistence, complete native cache/overlays/LOD and original framebuffer equivalence remain open.'])
(r/'docs/native_config_text_profiles_capture.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(configuration_restored=restored,profiles=len(results),client_sha256=summary['client_sha256'])),flush=True)
