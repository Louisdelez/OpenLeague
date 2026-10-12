"""Preserve native mesh vertices and face-corner UVs without inventing poses."""
from pathlib import Path
import json,hashlib,re,math,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sha=lambda b:hashlib.sha256(b).hexdigest();catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text(encoding='utf-8'));deploy=Path(catalog['particles_source']).parents[2];refs={}
for definition in catalog['definitions']:
 doc=json.loads((r/definition['asset']).read_text(encoding='utf-8'))
 active={g['name'] for g in definition['groups']}
 for field in doc['fields']:
  v=field['value']
  if isinstance(v,str) and v.lower().endswith(('.sco','.scb')):refs.setdefault(v,[]).append({'definition':definition['reference'],'section':field['section'],'field':field['name'],'native_hash':field['native_hash'],'declared_group':field['section'] in active})
 for h,field in doc['unknown_hashes'].items():
  v=field['value']
  if isinstance(v,str) and v.lower().endswith(('.sco','.scb')):refs.setdefault(v,[]).append({'definition':definition['reference'],'native_hash':int(h),'field_unknown':True})
files={}
for p in deploy.rglob('*.sco'):files.setdefault(p.name.lower(),[]).append(p)
out=r/'assets/particles/map10_native/meshes';out.mkdir(exist_ok=True);entries=[];missing=[];ambiguous=[];failed=[]
for ref,uses in sorted(refs.items()):
 paths=files.get(Path(ref.replace('\\','/')).name.lower(),[])
 if not paths:missing.append({'reference':ref,'uses':uses});continue
 if len({sha(p.read_bytes()) for p in paths})!=1:ambiguous.append({'reference':ref,'paths':[str(p) for p in paths]});continue
 path=sorted(paths)[0]
 try:
  payload=path.read_bytes();lines=payload.decode('utf-8-sig').splitlines();assert lines[0].strip()=='[ObjectBegin]'
  vi=next(i for i,l in enumerate(lines) if l.startswith('Verts='));count=int(lines[vi].split('=',1)[1]);assert 0<count<100000
  vertices=[[float(v) for v in line.split()] for line in lines[vi+1:vi+1+count]];assert len(vertices)==count and all(len(v)==3 and all(math.isfinite(c) for c in v) for v in vertices)
  fi=vi+1+count;assert lines[fi].startswith('Faces=');n=int(lines[fi].split('=',1)[1]);assert 0<n<100000;faces=[]
  for line in lines[fi+1:fi+1+n]:
   tokens=line.split();assert len(tokens)==11 and tokens[0]=='3';indices=[int(v) for v in tokens[1:4]];uv=[float(v) for v in tokens[5:]];assert all(0<=i<count for i in indices) and all(math.isfinite(v) for v in uv)
   faces.append({'vertex_indices':indices,'material_name':tokens[4],'uv':[[uv[i],uv[i+1]] for i in range(0,6,2)]})
  assert len(faces)==n;assert [l.strip() for l in lines[fi+1+n:] if l.strip()]==['[ObjectEnd]']
  header={l.split('=',1)[0].strip():l.split('=',1)[1].strip() for l in lines[1:vi]};original=out/(path.stem.lower()+'.sco');asset=original.with_suffix('.json');original.write_bytes(payload)
  mesh={'native_file':str(path),'source_sha256':sha(payload),'header':header,'vertices_native_xyz':vertices,'faces':faces,'native_pose_qualified':False,'limits':['Source positions and each triangle corner UV retained without recentering, axis conversion, UV flipping, smoothing, tint or guessed placement.','Emitter scale, orientation, owner pose and render-state binding need native execution qualification before ordinary game rendering.']};asset.write_text(json.dumps(mesh,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');back=json.loads(asset.read_text(encoding='utf-8'));assert back['vertices_native_xyz']==vertices and back['faces']==faces and original.read_bytes()==payload
  entries.append({'reference':ref,'uses':uses,'source':str(path),'source_candidates':[str(p) for p in paths],'source_sha256':sha(payload),'mesh_asset':str(asset.relative_to(r/'assets')).replace('\\','/'),'original_asset':str(original.relative_to(r/'assets')).replace('\\','/'),'mesh_asset_sha256':sha(asset.read_bytes()),'vertex_count':count,'triangle_count':n,'face_uv_count':n*3,'roundtrip_equal':True})
 except Exception as e:failed.append({'reference':ref,'source':str(path),'error':str(e)})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'catalog_sha256':sha((r/'data/4.20/map10_particle_catalog.json').read_bytes()),'references':len(refs),'entries':entries,'missing':missing,'ambiguous':ambiguous,'decode_failures':failed,'renderer_changed':False};(r/'data/4.20/map10_particle_meshes.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve() != (r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'references':len(refs),'recovered':len(entries),'vertices':sum(e['vertex_count'] for e in entries),'triangles':sum(e['triangle_count'] for e in entries),'missing':missing,'ambiguous':ambiguous,'decode_failures':failed}))
