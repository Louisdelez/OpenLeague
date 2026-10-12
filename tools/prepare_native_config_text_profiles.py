from pathlib import Path
r=Path('E:/OpenLeague');stage=Path(__file__).parent
text=(r/'tools/capture_native_user_settings_profiles.py').read_text(encoding='utf-8')
text=text.replace('chaos-base-user-settings-','chaos-base-config-text-flow-').replace('chaos_base_user_settings_','chaos_base_config_text_flow_').replace('native_user_settings_profiles_capture.json','native_config_text_profiles_capture.json')
marker="  proof=ns['proof'];proof.update("
addition="""  merged=re.search(r'Game.cfg text_loaded=(true|false) defaults_loaded=(true|false) merged_entries=(\\d+)',log);assert merged
  assert merged.group(1)=='true' and merged.group(2)=='true' and int(merged.group(3))==387
  assert 'Game.cfg layout_mode=0 layout_scores=[2, 0, 1]' in log
  ns['proof'].update(native_text_merge_loaded=True,default_text_loaded=True,merged_entries=387,actual_layout_mode=0,actual_layout_scores=[2,0,1])
"""
assert marker in text;text=text.replace(marker,addition+marker)
(stage/'capture_native_config_text_profiles.py').write_text(text,encoding='utf-8')
print('Distinct capture paths prepared; preserves preceding build captures and existing user Game.cfg.')
