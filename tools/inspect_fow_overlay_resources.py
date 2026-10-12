from pathlib import Path
import ast,struct,json,hashlib
r=Path('E:/OpenLeague');deploy=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
ns={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns)
for p in (deploy/'LEVELS/Map10').glob('*.inibin'):
 v=ns['ini'](p);matches={section:v.get(ns['hashkey'](section,'FOWTexture')) for section in ['Data','Fog','World','Level','Environment','Rendering']}
 strings=[str(x) for x in v.values() if isinstance(x,str) and any(t in x.lower() for t in ['fog','overlay'])]
 print(p.name,matches,strings)
print('Map10 root:',[p.name for p in (deploy/'LEVELS/Map10').iterdir() if p.is_file()])
