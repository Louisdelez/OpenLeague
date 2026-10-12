from pathlib import Path
r=Path('E:/OpenLeague');stage=Path(__file__).parent
text=(r/'tools/capture_native_config_text_profiles.py').read_text(encoding='utf-8')
text=text.replace('chaos-base-config-text-flow-','chaos-base-filesystem-provider-').replace('chaos_base_config_text_flow_','chaos_base_filesystem_provider_').replace('native_config_text_profiles_capture.json','native_filesystem_profiles_capture.json')
(stage/'capture_native_filesystem_profiles.py').write_text(text,encoding='utf-8')
print('Distinct filesystem-provider captures prepared; prior frames preserved.')
