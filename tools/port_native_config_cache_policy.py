from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_config_cache.rs',r/'crates/client/src/native_config_cache.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_config_cache;' not in text:text='mod native_config_cache;\n'+text
p.write_text(text,encoding='utf-8')
for name in ['port_native_config_cache_policy.py','native_config_cache.rs']:shutil.copy2(stage/name,r/'tools'/name)
print('Native cache decision ported; complete reload/constructor integration remains open.')
