from pathlib import Path
import struct,re,json,hashlib
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
start=0x9c0000;data=image[start-base:start-base+0x20000]
for m in re.finditer(re.escape(b'\xff')+b'[P-W]'+re.escape(b'\x5c'),data):
 pos=m.start();cut=data.rfind(b'\xcc',max(0,pos-240),pos)
 begin=cut+1 if cut>=0 else max(0,pos-25)
 print('D3D_TEXTURE_CANDIDATE',hex(start+pos))
 for i in md.disasm(data[begin:pos+45],start+begin):print(hex(i.address),i.mnemonic,i.op_str)

