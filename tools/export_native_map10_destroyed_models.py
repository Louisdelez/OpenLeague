from pathlib import Path
import json,ast,struct,hashlib,subprocess,datetime,shutil,math
r=Path('E:/OpenLeague');deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');selection=json.loads((r/'docs/map10_destroyed_model_selection.json').read_text());parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text());exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
exporter=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.exe');assert exporter.is_file();records={}
def locate(folder,name,suffix):
 if name:matches=[p for p in folder.rglob('*'+suffix) if p.name.lower()==str(name).lower()]
 else:matches=list(folder.glob('*'+suffix))
 assert len(matches)==1,(folder,name,suffix,len(matches));return matches[0]
for name in sorted({row['model'] for row in selection['structures']}):
 folder=deploy/'DATA/Characters'/name;config=folder/(name+'.inibin');base=folder/'Skins/Base/Base.inibin'
 if base.is_file():config=base
 props=parser['ini'](config);get=lambda key:props.get(parser['hashkey']('MeshSkin',key));mesh=locate(folder,get('SimpleSkin'),'.skn');rig=locate(folder,get('Skeleton'),'.skl');texture=locate(folder,get('Texture'),'.dds')
 target=r/'assets/structures'/('native_'+name.lower()+'.glb')
 args=[str(exporter),str(mesh),str(rig),str(texture),str(target)]
 result=subprocess.run(args,capture_output=True,text=True);assert result.returncode==0,result.stdout+result.stderr
 b=target.read_bytes();g=json.loads(b[20:20+struct.unpack_from('<I',b,12)[0]]);assert g['meshes'] and g.get('images');assert all('bufferView' in image for image in g['images'])
 records[name]=dict(name=name,mesh=str(mesh),mesh_sha256=hashlib.sha256(mesh.read_bytes()).hexdigest(),rig=str(rig),rig_sha256=hashlib.sha256(rig.read_bytes()).hexdigest(),texture=str(texture),texture_sha256=hashlib.sha256(texture.read_bytes()).hexdigest(),source_config=str(config),config_sha256=hashlib.sha256(config.read_bytes()).hexdigest(),skin_scale=get('SkinScale'),asset='structures/'+target.name,glb_sha256=hashlib.sha256(b).hexdigest(),embedded_images=len(g['images']),animations=len(g.get('animations',[])))
 print(json.dumps(dict(model=name,asset=target.name,embedded_images=len(g['images']))),flush=True)
manifest_path=r/'data/4.20/world_animation_manifest.json';manifest=json.loads(manifest_path.read_text());archive=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');archive.mkdir(parents=True,exist_ok=True);shutil.copy2(manifest_path,archive/manifest_path.name)
aliases=[]
for definition,choice in selection['profiles'].items():
 record=records[choice['model']];key=definition+'_destroyed';assert key in manifest;old=manifest[key];scale=1. if record['skin_scale'] is None else float(record['skin_scale']);assert math.isfinite(scale) and scale>0.,(key,scale)
 manifest[key]=dict(asset=record['asset'],scale=scale,clips=[],roles={});aliases.append(dict(alias=key,selected_model=choice['model'],previous_asset=old['asset'],asset=record['asset'],scale=scale))
manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8');report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,original_selection='map10_destroyed_model_selection.json',exporter_sha256=hashlib.sha256(exporter.read_bytes()).hexdigest(),models=records,aliases=aliases,limits=['Original meshes, rigs and diffuse DDS embedded by existing LeagueToolkit exporter. Texture shader/material response and original animation bindings remain unqualified.','Model choices recovered from original ObjectCFG and tower-default consumer. Full native skin enumeration, descriptor construction and destruction trigger remain open.'])
(r/'docs/map10_destroyed_asset_recovery.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(models_exported=len(records),aliases_corrected=len(aliases))))
