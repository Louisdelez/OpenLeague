from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for e in pe.DIRECTORY_ENTRY_IMPORT:
 if 'd3d' in e.dll.decode().lower():print(e.dll.decode(),[(i.name.decode() if i.name else i.ordinal,hex(i.address)) for i in e.imports])
