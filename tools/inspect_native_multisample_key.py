from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for address in [0x1088764,0x1088760,0x10868c8]:print(hex(address),image[address-base:address-base+90].split(b'\0')[0].decode())
