from pathlib import Path
from datetime import datetime,timezone
import sys,json,struct,hashlib,io
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);binary=raw[28+n:];sha=lambda b:hashlib.sha256(b).hexdigest()
assert raw[:4]==b'glTF' and struct.unpack_from('<I',raw,8)[0]==len(raw)
native_path=Path(json.loads((r/'docs/environment_vertex_source_validation.json').read_text(encoding='utf-8-sig'))['native_nvr']);native=native_path.read_bytes();count=struct.unpack_from('<i',native,8)[0];off=28;source={}
native_by_index={}
for i in range(count):
 name=native[off:off+260].split(b'\0')[0].decode('utf-8');typ,flags=struct.unpack_from('<iI',native,off+260);start=off+268
 texture=native[start+16:start+276].split(b'\0')[0].decode('utf-8');formatted='NVRMaterial_'+('AlphaTest_' if flags&4 else '')+name;source[formatted]={'type':typ,'flags':flags,'diffuse':texture};native_by_index[i]=source[formatted];off+=268+8*340
ownership=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text(encoding='utf-8-sig'))
assert ownership['native_nvr_sha256']==sha(native) and ownership['map_glb_sha256']==sha(raw)
owners={p['gltf_material_index']:p for p in ownership['gltf_materials_matched']}
images={};image_entries=[];errors=[]
for i,entry in enumerate(d['images']):
 try:
  v=d['bufferViews'][entry['bufferView']];offset=v.get('byteOffset',0);payload=binary[offset:offset+v['byteLength']];assert len(payload)==v['byteLength'];im=Image.open(io.BytesIO(payload)).convert('RGBA');im.load();images[i]=im
  image_entries.append({'index':i,'name':entry.get('name'),'size':list(im.size),'rgba_sha256':sha(im.tobytes()),'payload_sha256':sha(payload)})
 except Exception as e:errors.append({'image':i,'error':str(e)})
materials=[];source_cache={};differences=[];missing=[];other=[]
for i,m in enumerate(d['materials']):
 texture=m.get('pbrMetallicRoughness',{}).get('baseColorTexture');entry={'index':i,'name':m.get('name'),'alpha_mode':m.get('alphaMode','OPAQUE')}
 if texture is None:entry['error']='no diffuse texture';missing.append(entry);materials.append(entry);continue
 index=d['textures'][texture['index']]['source'];entry['image']=index
 if index not in images:entry['error']='diffuse image decode failed';missing.append(entry);materials.append(entry);continue
 native_m=source.get(m.get('name'));owner=owners.get(i)
 if owner:
  assert owner['name']==m.get('name');native_m=native_by_index[owner['native_material_index']];entry['mapping_method']=owner['mapping_method']
 entry['native_nvr_material']=native_m is not None
 if native_m:
  path=native_path.parent/'Textures'/native_m['diffuse'];entry.update(native_type=native_m['type'],native_flags=native_m['flags'],source=str(path))
  if path.exists():
   if path not in source_cache:
    b=path.read_bytes();im=Image.open(io.BytesIO(b)).convert('RGBA');im.load();source_cache[path]=(im,sha(b))
   original,native_sha=source_cache[path];actual=images[index];entry.update(source_sha256=native_sha,source_size=list(original.size),size=list(actual.size),pixels_equal=original.size==actual.size and original.tobytes()==actual.tobytes())
   if not entry['pixels_equal']:
    entry['changed_pixels']=sum(a!=b for a,b in zip(original.getdata(),actual.getdata())) if original.size==actual.size else None;differences.append(entry)
  else:entry['source_missing']=True;missing.append(entry)
 else:other.append(entry)
 materials.append(entry)
bad_primitives=[]
for mesh in d['meshes']:
 for p in mesh['primitives']:
  if 'material' not in p or not 0<=p['material']<len(materials):bad_primitives.append({'mesh':mesh.get('name'),'material':p.get('material')})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'map_sha256':sha(raw),'native_nvr_sha256':sha(native),'images_decoded':len(images),'image_decode_errors':errors,'materials':materials,'native_diffuse_equal':sum(m.get('pixels_equal',False) for m in materials),'native_diffuse_differences':differences,'missing_native_diffuse_or_binding':missing,'non_nvr_materials':other,'invalid_primitive_materials':bad_primitives,'images':image_entries,'limits':['Compares active embedded GLB diffuse pixels against original Map10 NVR slot0 DDS. Native terrain alternate layers, shader selection, gamma, lighting, fog and actual complete-map framebuffer fidelity are separate.','Non-NVR prop materials require their own native model/skin sources; not treated as missing or verified by this NVR-only check.']}
(r/'docs/current_map_texture_audit.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:len(v) if isinstance(v,list) else v for k,v in proof.items() if k in ['map_sha256','images_decoded','image_decode_errors','native_diffuse_equal','native_diffuse_differences','missing_native_diffuse_or_binding','non_nvr_materials','invalid_primitive_materials']}))
for e in differences+missing:print(json.dumps(e,ensure_ascii=True))
