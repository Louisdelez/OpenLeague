from pathlib import Path
import json,struct,ast,hashlib,subprocess,datetime,math,shutil
r=Path('E:/OpenLeague');exe=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.exe');audit=json.loads((r/'docs/intact_structure_clip_audit.json').read_text(encoding='utf-8'));bounds=json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text(encoding='utf-8'));manifest_path=r/'data/4.20/world_animation_manifest.json';manifest=json.loads(manifest_path.read_text(encoding='utf-8'));parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');archive=r/'docs/plan_history'/('intact-animation-bind-'+stamp);archive.mkdir(parents=True);shutil.copy2(manifest_path,archive/manifest_path.name);records=[]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def glb(p):
 b=p.read_bytes();size=struct.unpack_from('<I',b,12)[0];return json.loads(b[20:20+size]),b[28+size:]
def values(g,b,index):
 a=g['accessors'][index];v=g['bufferViews'][a['bufferView']];components={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[a['type']];fmt={5121:'B',5123:'H',5125:'I',5126:'f'}[a['componentType']];size=struct.calcsize('<'+fmt*components);stride=v.get('byteStride',size);start=v.get('byteOffset',0)+a.get('byteOffset',0);return [struct.unpack_from('<'+fmt*components,b,start+i*stride) for i in range(a['count'])]
for source in audit['records']:
 alias=source['alias'];m=bounds[alias.lower()];config=Path(m['config']);props=parser['ini'](config);get=lambda key:props.get(parser['hashkey']('MeshSkin',key));rig=Path(source['rig']['path']);clip=Path(source['clip']['path']);assert sha(rig)==source['rig']['sha256'] and sha(clip)==source['clip']['sha256']
 def locate(filename):
  candidates=[config.parent/filename,rig.parent/filename]
  found=[p for p in candidates if p.is_file()];assert found,(alias,filename,candidates)
  return found[0]
 mesh=locate(get('SimpleSkin'));texture=locate(get('Texture'));target=r/'assets/structures'/('native_intact_'+alias.lower()+'.glb');assert not target.exists(),target
 proc=subprocess.run([str(exe),str(mesh),str(rig),str(texture),str(target),clip.stem,str(clip)],capture_output=True,text=True);assert proc.returncode==0,proc.stdout+proc.stderr
 g,b=glb(target);assert len(g['animations'])==1 and g['animations'][0]['name']==clip.stem and all('bufferView' in image for image in g['images'])
 assert len(g['skins'])==1;skin=g['skins'][0];joints=skin['joints'];assert len(joints)==source['audit']['matching_joints']
 max_influence=-1
 for gm in g['meshes']:
  for primitive in gm['primitives']:
   indices=values(g,b,primitive['attributes']['JOINTS_0']);weights=values(g,b,primitive['attributes']['WEIGHTS_0']);assert len(indices)==len(weights)
   for ids,ws in zip(indices,weights):
    assert all(math.isfinite(w) and w>=0 for w in ws) and abs(sum(ws)-1)<1e-4
    for index,weight in zip(ids,ws):
     if weight>0:assert index<len(joints);max_influence=max(max_influence,index)
 animation=g['animations'][0];assert all(ch['target']['node'] in joints for ch in animation['channels'])
 times=[t[0] for sampler in animation['samplers'] for t in values(g,b,sampler['input'])];assert times and all(math.isfinite(t) for t in times);duration=max(times);assert duration>0
 old=manifest[alias];oldg,oldb=glb(r/'assets'/old['asset']);old_positions=[p for meshg in oldg['meshes'] for prim in meshg['primitives'] for p in values(oldg,oldb,prim['attributes']['POSITION'])];new_positions=[p for meshg in g['meshes'] for prim in meshg['primitives'] for p in values(g,b,prim['attributes']['POSITION'])]
 manifest[alias]=dict(asset='structures/'+target.name,scale=old['scale'],clips=[clip.stem],roles={'idle':0},duration_ticks={'idle':math.ceil(duration*30)})
 record=dict(alias=alias,previous_asset=old['asset'],asset=manifest[alias]['asset'],glb_sha256=sha(target),mesh=str(mesh),mesh_sha256=sha(mesh),rig=str(rig),rig_sha256=sha(rig),texture=str(texture),texture_sha256=sha(texture),clip=str(clip),clip_sha256=sha(clip),config=str(config),config_sha256=sha(config),joints=len(joints),max_nonzero_influence_index=max_influence,channels=len(animation['channels']),duration_seconds=duration,geometry_same_as_previous=old_positions==new_positions,old_vertex_count=len(old_positions),new_vertex_count=len(new_positions),source_geometry_matches_qualified_bound_resource=sha(mesh)==m['mesh_sha256'],scale=old['scale']);records.append(record)
 print(json.dumps(dict(alias=alias,joints=len(joints),duration=duration,geometry_unchanged=record['geometry_same_as_previous'],matches_bbox_resource=record['source_geometry_matches_qualified_bound_resource'])),flush=True)
manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
(r/'docs/intact_structure_animation_binding.json').write_text(json.dumps(dict(updated_utc=stamp,complete=False,records=records,manifest_sha256=sha(manifest_path),limits=['Native ANM/SKL and MeshSkin mesh/texture filenames resolved from config/graph folders. Skinning indices, weights and target joints checked; native shared search ordering remains unqualified.','Only authored idle clips bound. Native BLND Default/state/time/loop/event semantics, effects and original runtime pose comparison remain open.']),indent=2)+'\n',encoding='utf-8')
