from pathlib import Path
import json,struct,hashlib,datetime,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import numpy as np
r=Path('E:/OpenLeague');p=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text());n=Path(p['native_nvr']).read_bytes()
assert hashlib.sha256(n).hexdigest()==p['native_nvr_sha256']
ma,vbc,ibc,mc,nc=struct.unpack_from('<5I',n,8);off=28+ma*2988;vbs=[];ibs=[]
for _ in range(vbc):
 size=struct.unpack_from('<I',n,off)[0];off+=4;vbs.append((off,size));off+=size
for _ in range(ibc):
 size,fmt=struct.unpack_from('<2I',n,off);off+=8;assert fmt in [101,102];ibs.append(np.frombuffer(n,dtype='<u2' if fmt==101 else '<u4',count=size//(2 if fmt==101 else 4),offset=off));off+=size
rows=[]
for i in range(mc):
 mid=struct.unpack_from('<I',n,off+i*100+48)[0];typ,flags=struct.unpack_from('<2I',n,28+mid*2988+260)
 primary=struct.unpack_from('<6I',n,off+i*100+52);secondary=struct.unpack_from('<6I',n,off+i*100+76)
 stride=44 if typ==3 else 36 if typ in [1,2] else 40 if flags&16 else 36
 def decode(g,s):
  vi,sv,vc,ii,si,ic=g;assert sv*s+vc*s<=vbs[vi][1];assert si+ic<=len(ibs[ii]);assert ic%3==0
  pos=np.ndarray((vc,3),dtype='<f4',buffer=n,offset=vbs[vi][0]+sv*s,strides=(s,4));idx=ibs[ii][si:si+ic].astype(np.int64)-sv
  assert idx.min()>=0 and idx.max()<vc,(i,g,s,int(idx.min()),int(idx.max()))
  return pos[idx].reshape(-1,3,3)
 a=decode(primary,stride);b=decode(secondary,12)
 rows.append(dict(mesh=i,primary_triangles=len(a),projection_triangles=len(b),same_ordered_geometry=a.shape==b.shape and bool(np.array_equal(a,b))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,passed=True,nvr_sha256=p['native_nvr_sha256'],meshes=rows,projection_stride=12,all_same_ordered_geometry=all(x['same_ordered_geometry'] for x in rows),limits=['Static resource layout verified with bounds and exact primary/secondary triangle comparison. Native buffer loader and GPU declaration not executed.','No renderer integration or visual qualification claimed.'])
(r/'data/4.20/map10_receiver_geometry_audit.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(meshes=len(rows),same=sum(x['same_ordered_geometry'] for x in rows),primary=sum(x['primary_triangles'] for x in rows),secondary=sum(x['projection_triangles'] for x in rows))))
