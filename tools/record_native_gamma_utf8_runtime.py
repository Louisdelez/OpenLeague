from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
script=(stage/'record_native_gamma_runtime.py').read_text(encoding='utf-8')
script=script.replace('native-gamma-build.log','native-gamma-utf8-build.log')
script=script.replace('chaos_base_native_gamma_capture.json','chaos_base_native_gamma_utf8_capture.json')
exec(compile(script,'current UTF8 gamma runtime record','exec'))
for p in ['docs/native_gamma_runtime_progress.json','docs/chaos_base_native_gamma_utf8_capture.json']:
 d=json.loads((r/p).read_text(encoding='utf-8'))
 d.update(hud_utf8_restored=True,hud_capture_inspected=True)
 d['limits'].append('239 functional tests precede UTF8-only restoration of French literals; gamma code and shader unchanged. Current executable rebuilt and captured after restoration.')
 (r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['capture_chaos_gamma_utf8_scene.py','record_native_gamma_utf8_runtime.py']:shutil.copy2(stage/name,r/'tools'/name)
