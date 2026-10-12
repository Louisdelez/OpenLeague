"""Recover complete native ambient models and exact restored-map placements."""
from pathlib import Path
import json,struct,hashlib,re,subprocess,datetime,shutil,numpy as np
r=Path(__file__).resolve().parents[1];old=Path('E:/mapslol3v3/output/TwistedTreeline_Animated_v3');records=json.loads((old/'asset_inventory.json').read_text());by_name={x['name']:x for x in records};props=json.loads((r/'docs/map_blender_prop_sources.json').read_text())['props'];dest=r/'assets/ambient';dest.mkdir(exist_ok=True);converter=Path('E:/mapslol3v3/StructureExport/bin/Release/net8.0/StructureExport.dll');assert converter.exists()
raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();jl=struct.unpack_from('<I',raw,12)[0];mapdoc=json.loads(raw[20:20+jl]);node_names={x.get('name') for x in mapdoc['nodes']}
primary={'TT_Shopkeeper':'shopkeeper_TT_Idle','TT_Chains_Bot_Lane':'TT_Chains_Bot_Lane_Idle','TT_Nexus_Gears':'TT_Nexus_Gears_Idle','TT_Brazier':'TT_Brazier_Idle','TT_Speedshrine_Gears':'TT_Speedshrine_Gears_Idle','TT_Chains_Order_Base':'TT_Chains_Order_Base_Idle1','TT_Chains_Xaos_Base':'TT_Chains_Xaos_Base_Idle1','TT_Chains_Order_Periph':'TT_Chains_Order_Periph_Idle1'}
assets={};proofs=[]
for name in sorted(primary):
 record=by_name[name];folder=Path(record['mesh']).parent;clips=[next(p for p in folder.rglob('*') if p.is_file() and p.suffix.lower()=='.anm' and p.stem.lower()==clip.lower()) for clip in record['animations']];out=dest/(name.lower()+'.glb');args=['dotnet',str(converter),record['mesh'],record['rig'],record['texture'],str(out)]
 for p in clips:args+=[p.stem,str(p)]
 result=subprocess.run(args,capture_output=True,text=True);assert result.returncode==0,(name,result.stdout,result.stderr)
 b=out.read_bytes();n=struct.unpack_from('<I',b,12)[0];d=json.loads(b[20:20+n]);blob=b[28+n:]
 durations=[]
 for a in d.get('animations',[]):
  duration=0.
  for sm in a['samplers']:
   ac=d['accessors'][sm['input']];view=d['bufferViews'][ac['bufferView']];v=np.frombuffer(blob,dtype='<f4',count=ac['count'],offset=view.get('byteOffset',0)+ac.get('byteOffset',0));assert np.isfinite(v).all();duration=max(duration,float(v.max()))
  durations.append(duration)
 names=[a['name'] for a in d.get('animations',[])];assert sorted(names)==sorted(p.stem for p in clips);index=names.index(primary[name]);assert durations[index]>0
 # Preserve the installed restored-map alpha policy, pending full native shader qualification.
 prop=next(x for x in props if x['native_asset']==name);node=next(x for x in mapdoc['nodes'] if x.get('name')==prop['mesh_objects'][0]);oldmat=mapdoc['materials'][mapdoc['meshes'][node['mesh']]['primitives'][0]['material']]
 for m in d['materials']:
  m['alphaMode']=oldmat.get('alphaMode','OPAQUE')
  if m['alphaMode']=='MASK':m['alphaCutoff']=oldmat.get('alphaCutoff',.5)
 encoded=json.dumps(d,separators=(',',':')).encode();encoded+=b' '*((-len(encoded))%4);result_glb=struct.pack('<4sII',b'glTF',2,28+len(encoded)+len(blob))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+struct.pack('<II',len(blob),0x004e4942)+blob;out.write_bytes(result_glb)
 blnds=list(folder.glob('*.blnd'));refs=[]
 for p in blnds:
  data=p.read_bytes();refs.extend(s.decode('ascii') for s in re.findall(rb'[ -~]{6,}',data) if b'.anm' in s.lower())
 asset={'asset':'ambient/'+out.name,'primary_clip':index,'primary_name':primary[name],'duration':durations[index],'clips':names,'durations':durations,'sha256':hashlib.sha256(result_glb).hexdigest()};assets[name]=asset
 proof={'native_asset':name,**asset,'sources':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in [Path(record['mesh']),Path(record['rig']),Path(record['texture']),*clips,*blnds]],'blend_animation_references':refs,'alpha_policy':{'mode':oldmat.get('alphaMode','OPAQUE'),'cutoff':oldmat.get('alphaCutoff')},'converter':str(converter),'converter_sha256':hashlib.sha256(converter.read_bytes()).hexdigest()};proofs.append(proof);print('NATIVE AMBIENT MODEL',name,len(names),durations[index],flush=True)
C=np.array([[1,0,0,0],[0,0,1,0],[0,-1,0,0],[0,0,0,1]],float);mirror=np.diag([.05,.05,-.05,1]);mirror[2,3]=15398.6719/20;placements=[]
for prop in props:
 assert prop['placement_parent'] in node_names,prop['placement_parent']
 if prop['native_asset'] not in assets:continue
 matrix=mirror@C@np.array(prop['parent_matrix_world'])@C.T;placements.append({'id':prop['placement_parent'],'native_asset':prop['native_asset'],'matrix':matrix.T.reshape(-1).tolist(),'original_meshes':prop['mesh_objects'],'original_armature':prop['armature'],'original_action':prop['active_action'],'primary_name':assets[prop['native_asset']]['primary_name']})
assert len(placements)==17
manifest={'assets':assets,'placements':placements,'hidden_embedded_roots':[x['placement_parent'] for x in props],'excluded_duplicate_altar_roots':['altar_west_Animated','altar_east_Animated'],'diagnostic_policy':'Full-model ambient props hidden only in environment-only probes; original embedded props suppressed in all modes.','limits':['Native primary idle animations retained in full; secondary idle selection/blend graph/event FX/audio and fidelity remain incomplete.','Alpha metadata retained from restored map; native skin shader policy remains unqualified.','Placement preserves original restored Blender parent matrix; full source placement/collision/visual acceptance remains incomplete.']};(r/'data/4.20/map_ambient_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'map_sha256':hashlib.sha256(raw).hexdigest(),'source_blend':'docs/map_blender_prop_sources.json','models':proofs,'placements':placements,'native_models':len(assets),'native_animation_clips':sum(len(x['clips']) for x in assets.values()),'ambient_instances':len(placements),'embedded_roots_suppressed':len(props),'complete':False,'limits':manifest['limits']};(r/'docs/map_ambient_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('NATIVE AMBIENT SOURCES',len(assets),len(placements))

# The original exporter may truncate Fps*Duration: restore bounded native final samples.
import sys
subprocess.run([sys.executable, str(r/'tools/repair_ambient_animation_endpoints.py')], check=True)
