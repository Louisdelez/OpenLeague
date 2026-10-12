from pathlib import Path
s=Path('E:/mapslol3v3/locate_native_endgame_getters.py').read_text(encoding='utf-8')
a=s.index('for name in [');b=s.index(']:',a)+2
s=s[:a]+"for name in ['MoveCameraFromCurrentPositionToPoint','FadeOutMainSFX','FadeMinions','SetMinionsNoRender']:"+s[b:]
s=s.replace('native_endgame_getter_locations.json','native_endgame_camera_pan_locations.json')
exec(compile(s,'native-camera-pan-symbols','exec'))
s=Path('E:/mapslol3v3/inspect_native_endgame_getter_bodies.py').read_text(encoding='utf-8').replace('native_endgame_getter_locations.json','native_endgame_camera_pan_locations.json').replace('native_endgame_getter_bodies.json','native_endgame_camera_pan_bodies.json')
exec(compile(s,'native-camera-pan-bodies','exec'))
