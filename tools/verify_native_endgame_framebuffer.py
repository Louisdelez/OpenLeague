from pathlib import Path
s=Path('E:/mapslol3v3/verify_results_framebuffer.py').read_text(encoding='utf-8')
s=s.replace('match-results-visual','native-endgame-visual').replace('match_results_visual_validation.json','native_endgame_visual_validation.json')
exec(compile(s,'native-eog-framebuffer','exec'))
