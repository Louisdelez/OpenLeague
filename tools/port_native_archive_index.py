from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_archive_index.rs',r/'crates/client/src/native_archive_index.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_archive_index;' not in text:text='mod native_archive_index;\n'+text
p.write_text(text,encoding='utf-8')
for name in ['native_archive_index.rs','port_native_archive_index.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native archive lookup ported for valid supplied indexes/C locale; ZIP index mounting/insertion/decompression remains open.')
