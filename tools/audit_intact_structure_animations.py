from pathlib import Path
import json,hashlib,datetime,ast,struct
r=Path('E:/OpenLeague');deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');bounds=json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text(encoding='utf-8'));manifest=json.loads((r/'data/4.20/world_animation_manifest.json').read_text(encoding='utf-8'));records=[]
parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for key,m in bounds.items():
 config=Path(m['config']);props=parser['ini'](config);get=lambda field:props.get(parser['hashkey']('MeshSkin',field));folder=config
 while folder.parent.name!='Characters':folder=folder.parent
 files=[dict(path=str(p),sha256=sha(p),kind=p.suffix) for p in sorted(folder.rglob('*')) if p.suffix.lower() in ['.anm','.blnd']]
 alias=next(name for name in manifest if name.lower()==key.lower());entry=manifest[alias]
 records.append(dict(alias=alias,source_folder=str(folder),selected_mesh=m['mesh'],skeleton=get('Skeleton'),animation_graph=get('AnimationGraphData'),animation=get('Animation'),files=files,current_clips=entry.get('clips',[]),current_roles=entry.get('roles',{})))
 print(json.dumps(dict(alias=alias,skeleton=get('Skeleton'),animation_graph=get('AnimationGraphData'),animations=[Path(f['path']).name for f in files])),flush=True)
(r/'docs/intact_structure_animation_inventory.json').write_text(json.dumps(dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,records=records,limits=['Original file inventory and selected MeshSkin fields; no native state semantics or actual in-game death/attack event qualification.']),indent=2)+'\n',encoding='utf-8')
