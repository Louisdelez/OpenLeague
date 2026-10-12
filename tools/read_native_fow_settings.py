from pathlib import Path
import ast,struct,json,hashlib,datetime
r=Path('E:/OpenLeague');deploy=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
ns={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns)
p=deploy/'LEVELS/Map10/terrain.inibin';v=ns['ini'](p)
values={key:v.get(ns['hashkey']('FoW',key)) for key in ['upscale','fadeStart','fadeFinish','edgeEnhancement','edgeTintPoint','blurKernelSigma','FOWTexture']}
print(json.dumps({'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'native_section':'FoW','values':values,'limits':['Raw original resource values; whole path/property resolution not qualified.']}))
