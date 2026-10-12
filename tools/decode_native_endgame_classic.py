from pathlib import Path
s=Path('E:/mapslol3v3/decode_native_endgame_layout.py').read_text(encoding='utf-8')
s=s.replace('deploy/DATA/Menu_SC4','deploy/DATA/menu').replace("p=root/'EndOfGame_Default.gfx'","p=root/'EndOfGame.gfx'").replace('native_endgame_layout.json','native_endgame_classic_layout.json')
exec(compile(s,'classic-eog','exec'))
