from pathlib import Path
source=Path('E:/OpenLeague/tools/capture_chaos_base_scene.py').read_text(encoding='utf-8')
source=source.replace('chaos-base-normal-scene','chaos-base-native-fog-profile-scene').replace('chaos_base_scene_capture.json','chaos_base_native_fog_profile_capture.json')
exec(compile(source,'native fog profile client capture','exec'))
