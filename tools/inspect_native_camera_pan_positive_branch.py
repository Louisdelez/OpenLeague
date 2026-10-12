from pathlib import Path
s=Path('E:/mapslol3v3/inspect_native_camera_pan_controller.py').read_text(encoding='utf-8').replace('[(0x565e00,512),(0x6a68c0,256)]','[(0x565edd,768),(0x566490,256)]').replace('native_camera_pan_controller_instructions.json','native_camera_pan_positive_branch_instructions.json')
exec(compile(s,'native-camera-pan-positive-duration','exec'))
