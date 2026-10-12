from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
addresses=[0x10c9bf4,0x10c1f34,0x10c9c48,0x10c9c5c,0x10c9c18,0x10c9c34,0x10c9c78,0x10c9c94,0x10c9c64,0x108bf70,0x10c9c6c,0x10c9cac,0x10c9cb4,0x10c9c9c,0x10c9ca4,0x10c9ce0,0x10c9ce8,0x10c9cc4,0x10c9cd4,0x10c9d14]
for a in addresses:print(hex(a),image[a-base:].split(b'\0',1)[0])
