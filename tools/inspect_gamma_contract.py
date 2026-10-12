from pathlib import Path
import ast
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for a in [0x10876cc,0x10b20e0,0x10b20ec,0x10b2114]:
 print(hex(a), image[a-base:a-base+80].split(b'\0')[0].decode('ascii'))
for a in [0x1138a2c,0x1138ba4]: print(hex(a), struct.unpack_from('<f',image,a-base)[0])
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'))
parser={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
path=Path(source).parent/'LEVELS/Map10/Gamma.inibin'
print('CONFIG',len(path.read_bytes()),parser['ini'](path))
for key in ['Gamma','Brightness','Contrast','Exposure']:
 print('KEY',key,parser['hashkey']('Gamma',key))
for start,end in [(0x739750,0x739940),(0x835d5a,0x835d85)]:
 print('RANGE',hex(start))
 for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
