from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_zip_archive.rs',r/'crates/client/src/native_zip_archive.rs')
for name in ['native_zip_archive.rs','port_native_zip_fallback.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native fallback local-header scanner ported and connected to archive open.')
