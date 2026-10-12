from pathlib import Path
import json,struct,hashlib,math,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sha=lambda b:hashlib.sha256(b).hexdigest();mp=r/'data/4.20/map10_particle_meshes.json';proof=json.loads(mp.read_text(encoding='utf-8'));c=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text(encoding='utf-8'));deploy=Path(c['particles_source']).parents[2];reference=r/'tools/references/league-toolkit-static';entries=[];left=[]
for missing in proof['missing']:
 ref=missing['reference'];paths=list(deploy.rglob(Path(ref).stem+'.SCB'))
 if not paths:left.append(missing);continue
 assert len({sha(p.read_bytes()) for p in paths})==1;source=sorted(paths)[0];data=source.read_bytes();cursor=0;packed=[]
 def take(fmt):
  global cursor
  size=struct.calcsize('<'+fmt);assert cursor+size<=len(data);result=struct.unpack_from('<'+fmt,data,cursor);cursor+=size;packed.append(struct.pack('<'+fmt,*result));return result
 assert take('8s')[0]==b'r3d2Mesh';major,minor=take('2H');assert (major,minor)==(2,2),('unqualified SCB version',major,minor)
 name=take('128s')[0].split(b'\0',1)[0].decode('ascii');nv,nf,flags=take('2iI');assert 0<nv<100000 and 0<nf<100000 and flags&~3==0
 box=list(take('6f'));vertices=[list(take('3f')) for _ in range(nv)];center=list(take('3f'));faces=[]
 for _ in range(nf):
  indices=list(take('3I'));material=take('64s')[0].split(b'\0',1)[0].decode('ascii');uv=take('6f');assert all(i<nv for i in indices)
  faces.append({'vertex_indices':indices,'material_name':material,'uv':[[uv[i],uv[i+3]] for i in range(3)]})
 if flags&1:
  for f in faces:f['corner_rgb_u8']=[list(take('3B')) for _ in range(3)]
 assert cursor==len(data) and b''.join(packed)==data
 assert all(math.isfinite(v) for p in vertices for v in p) and all(math.isfinite(v) for f in faces for pair in f['uv'] for v in pair)
 out=r/'assets/particles/map10_native/meshes';binary=out/(source.stem.lower()+'.scb');target=binary.with_suffix('.json');binary.write_bytes(data)
 document={'native_file':str(source),'source_sha256':sha(data),'format':{'magic':'r3d2Mesh','version':[major,minor],'flags':flags,'bounding_box':box,'central_point':center,'name':name},'vertices_native_xyz':vertices,'faces':faces,'native_pose_qualified':False,'binary_roundtrip_equal':True,'byte_count_consumed':cursor,'original_reference':ref,'reference_extension_resolution_qualified':False,'reader_reference':{'repository':'https://github.com/LeagueToolkit/league-toolkit','revision':'3f49b76488b6ff0623b7ea24aaad61c700552f0b','source_sha256':{p.name:sha(p.read_bytes()) for p in reference.glob('*.rs')}},'limits':['SCB candidate has the original referenced basename; original native .sco to .scb loader selection is not yet qualified.','All native positions, face-corner UVs and RGB colors retained. No smoothing, axis conversion, white replacement or guessed emitter pose applied.','Full stream consumed and reconstructed byte-for-byte. This validates the decoded encoding, not native rasterization.']}
 target.write_text(json.dumps(document,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');back=json.loads(target.read_text(encoding='utf-8'));assert back['vertices_native_xyz']==vertices and back['faces']==faces and binary.read_bytes()==data
 entries.append({'reference':ref,'uses':missing['uses'],'source':str(source),'source_candidates':[str(p) for p in paths],'source_sha256':sha(data),'mesh_asset':str(target.relative_to(r/'assets')).replace('\\','/'),'original_asset':str(binary.relative_to(r/'assets')).replace('\\','/'),'mesh_asset_sha256':sha(target.read_bytes()),'vertex_count':nv,'triangle_count':nf,'face_uv_count':nf*3,'roundtrip_equal':True,'binary_roundtrip_equal':True,'reference_extension_resolution_qualified':False})
proof['entries']+=entries;proof.update(missing=left,updated_utc=datetime.now(timezone.utc).isoformat());mp.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve() != (r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'recovered_scb':len(entries),'vertices':sum(e['vertex_count'] for e in entries),'triangles':sum(e['triangle_count'] for e in entries),'missing':[e['reference'] for e in left],'complete':False}))
