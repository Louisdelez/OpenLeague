from pathlib import Path
import sys,hashlib,datetime,collections
exec(Path(__file__).with_name('inspect_nvr_geometry_layout.py').read_text().split('profiles={};meshes={}')[0])
baseline_doc=d;baseline_blob=blob
current_raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();jlen=struct.unpack_from('<I',current_raw,12)[0];current=json.loads(current_raw[20:20+jlen]);current_blob=current_raw[28+jlen:]
by_id=lambda doc:{int(m.group(1)):mesh for mesh in doc['meshes'] if (m:=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name','')))}
before=by_id(baseline_doc);after=by_id(current);rows=[];native_count=0;native_positions_checked=0;degenerate_missing=0
def canonical(triangles):
 # Compare unoriented triangle geometry after rounding to 0.01 native units.
 return collections.Counter(tuple(sorted(tuple(np.round(v,2)) for v in tri)) for tri in triangles)
for mi in range(mc):
 mid=struct.unpack_from('<i',n,off+mi*100+48)[0];typ,flags=struct.unpack_from('<iI',n,28+mid*2988+260);vi,sv,vc,ii,si,ic=struct.unpack_from('<6i',n,off+mi*100+52)
 stride=44 if typ==3 else 36 if typ in [1,2] else 40 if flags&16 else 36
 positions=np.ndarray((vc,3),dtype='<f4',buffer=n,offset=vbs[vi][0]+sv*stride,strides=(stride,4)).copy();p=before[mi]['primitives'][0];bp=accessor(baseline_doc,baseline_blob,p['attributes']['POSITION']);assert np.array_equal(positions,bp),(mi,stride)
 ids=ibs[ii][si:si+ic].astype(np.int64);ids-=ids.min();assert ic%3==0 and ids.max()<vc
 bi=accessor(baseline_doc,baseline_blob,p['indices']).reshape(-1);assert np.array_equal(ids,bi),mi
 native_count+=ic//3;native_positions_checked+=vc
 cp=after[mi]['primitives'][0];cpos=accessor(current,current_blob,cp['attributes']['POSITION']);ci=accessor(current,current_blob,cp['indices']).reshape(-1)
 if len(ci)!=ic:
  tris=positions[ids.reshape(-1,3)];ctris=cpos[ci.reshape(-1,3)]
  missing=canonical(tris)-canonical(ctris);extra=canonical(ctris)-canonical(tris)
  detail=[];exact_by_key={}
  for source_tri in tris:
   key=tuple(sorted(tuple(np.round(v,2)) for v in source_tri))
   if key in missing:exact_by_key.setdefault(key,[]).append(source_tri.astype(np.float64))
  for tri,count in missing.items():
   v=exact_by_key[tri][0];area=float(np.linalg.norm(np.cross(v[1]-v[0],v[2]-v[0]))/2);detail.append(dict(vertices=v.tolist(),count=count,area=area,area_uses_unrounded_native_coordinates=True));degenerate_missing+=count if area==0 else 0
  rows.append(dict(native_mesh=mi,native_material_index=mid,type=typ,flags=flags,native_triangles=ic//3,current_triangles=len(ci)//3,missing_geometry=detail,extra_geometry_count=sum(extra.values()),comparison_rounding_native_units=.01))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,native_nvr_sha256=hashlib.sha256(n).hexdigest(),map_sha256=hashlib.sha256(current_raw).hexdigest(),native_meshes=mc,native_vertices_checked=native_positions_checked,baseline_positions_exact=True,baseline_indices_exact=True,native_triangle_count=native_count,current_triangle_count=sum(len(accessor(current,current_blob,m['primitives'][0]['indices']))//3 for m in after.values()),count_mismatch_meshes=rows,degenerate_missing_triangles=degenerate_missing,limits=['All source positions and indices compared directly against original export for2351meshes. Current detailed geometric comparison restricted to meshes whose index counts differ.','Rounded unoriented triangle comparison does not qualify materials, shading, UVs, pass composition or exact original framebuffer.'])
(r/'docs/native_nvr_triangle_audit.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(native_vertices=native_positions_checked,native_triangles=native_count,count_mismatch_meshes=[dict(mesh=x['native_mesh'],native=x['native_triangles'],current=x['current_triangles'],missing=sum(v['count'] for v in x['missing_geometry']),extra=x['extra_geometry_count'],areas=[v['area'] for v in x['missing_geometry']]) for x in rows],degenerate_missing=degenerate_missing)))
