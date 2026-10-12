from pathlib import Path
s=Path('E:/mapslol3v3/inspect_native_endgame_getter_bodies.py').read_text(encoding='utf-8').replace('native_endgame_getter_locations.json','native_endgame_camera_client_locations.json').replace('native_endgame_getter_bodies.json','native_endgame_camera_client_bodies.json').replace('pos-32','pos-96')
exec(compile(s,'full-camera-registration-window','exec'))
