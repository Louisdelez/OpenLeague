from pathlib import Path
import ast
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));parser={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
print('CONFIG',parser['ini'](Path(source).parent/'LEVELS/Map10/clouds.inibin'))
for a in [0x10b1ebc,0x10b1ed8,0x10b1ed0,0x10b1ee0]:print('PROPERTY',hex(a),image[a-base:a-base+80].split(b'\0')[0].decode('ascii'))
for k in ['Size','Scale','SpeedX','SpeedY','Texture']:
 print('HASH',k,parser['hashkey']('Clouds',k))
for name in ['Clouds','clouds.ini','CloudsTexture','Texture','TextureName']:
 start=0
 while True:
  off=image.find(name.encode()+b'\0',start)
  if off<0:break
  start=off+1;addr=base+off;print('STRING',name,hex(addr));needle=struct.pack('<I',addr);ref=0;count=0
  while True:
   ref=image.find(needle,ref)
   if ref<0:break
   print('REF',hex(base+ref));ref+=1;count+=1
   if count==15:break
