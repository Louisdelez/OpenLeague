from pathlib import Path
import json,ast,struct
r=Path('E:/OpenLeague');report=json.loads((r/'docs/structure_spatial_geometry_matches.json').read_text());deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');inventory=[]
parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
for name in ['altar_l','altar_r']:
 row=next(x for x in report['models'] if x['name']==name);assert len(row['source_matches'])==1;mesh=Path(row['source_matches'][0]['mesh']);character='TT_Buffplat_L' if name=='altar_l' else 'TT_Buffplat_R';config=deploy/'DATA/Characters'/character/(character+'.inibin');props=parser['ini'](config)
 assert props.get(parser['hashkey']('MeshSkin','SimpleSkin'))==mesh.name
 inventory.append(dict(kind='champion',status='exported',asset=name,mesh=str(mesh),source_config=str(config),skin_scale=props.get(parser['hashkey']('MeshSkin','SkinScale'))))
 print(json.dumps(dict(name=name,character=character,shared_mesh=mesh.name,skin_scale=inventory[-1]['skin_scale'])))
s=(r/'tools/probe_native_grass_model_bounds.py').read_text();old="records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))";assert old in s;s=s.replace(old,'records=[];inventory='+repr(inventory)).replace('assert len(records)==122','assert len(records)==2')
s=s.replace('grass_model_bounds_contract.json','grass_altar_model_bounds_contract.json').replace('native_grass_model_bounds.json','native_grass_altar_model_bounds.json').replace('122 base champion resources','2 altar identities using the original shared mesh and separate left/right configurations')
exec(compile(s,'native-altar-model-box-probe','exec'))
