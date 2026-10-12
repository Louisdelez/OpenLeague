from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for name in ['FOG_PIXELSHADER_BLEND','FOG_QUALITY_LOW','FOG_TEXTURED_OPACITY','VERTEX_FOG']:
 start=0
 while True:
  off=image.find(name.encode()+b'\0',start)
  if off<0:break
  addr=base+off;print('STRING',name,hex(addr));start=off+1
  needle=struct.pack('<I',addr);ref=0
  while True:
   ref=image.find(needle,ref)
   if ref<0:break
   print('REF',hex(base+ref));s=max(0,ref-80);pad=image[s:ref].rfind(b'\xcc\xcc')
   if pad>=0:s+=pad+2
   for i in md.disasm(image[s:ref+35],base+s):print(hex(i.address),i.mnemonic,i.op_str)
   ref+=1
