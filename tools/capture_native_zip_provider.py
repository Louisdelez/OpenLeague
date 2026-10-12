from pathlib import Path
import json,re,hashlib,shutil
r=Path('E:/OpenLeague');prefix='chaos-base-zip-provider-scene';receipt='chaos_base_zip_provider_capture.json'
assert not (r/'Config/Game.cfg').exists(),'Preserve user Game.cfg and adapt expected quality before capturing.'
helper=(r/'tools/capture_chaos_base_scene.py').read_text(encoding='utf-8').replace('chaos-base-normal-scene',prefix).replace('chaos_base_scene_capture.json',receipt)
ns={};exec(compile(helper,'native ZIP provider runtime capture','exec'),ns)
log=(r/'logs'/f'{prefix}.client.log').read_text(encoding='utf-8',errors='replace')
assert 'panicked at' not in log and 'ShaderValidationError' not in log
match=re.search(r'Native ZIP archives=(\d+) entries=(\d+) unique_names=(\d+) FastHUD_bytes=(\d+) Chat_bytes=(\d+)',log);assert match
values=list(map(int,match.groups()));assert values[0:2]==[5,1066] and values[3:]==[1607,1773]
assert 'Game.cfg text_loaded=true defaults_loaded=true merged_entries=387' in log
assert 'Game.cfg layout_mode=0 layout_scores=[2, 0, 1]' in log and 'environment_quality=3' in log
proof=ns['proof'];proof.update(archive_count=values[0],archive_entries=values[1],unique_archive_names=values[2],fast_hud_bytes=values[3],chat_bytes=values[4],native_hud_layout_applied=False,game_cfg_archive_first_provider=True,merged_config_entries=387,user_config_unchanged=not (r/'Config/Game.cfg').exists(),visual_inspected=False)
proof['limits'].append('Five recovered archives mounted and original HUD configuration read; native HUD layout/aliases/fallback scanner and complete game remain open.')
(r/'docs'/receipt).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(archives=values[0],entries=values[1],unique_names=values[2],capture=proof['capture'],client_sha256=proof['client_sha256'])),flush=True)
