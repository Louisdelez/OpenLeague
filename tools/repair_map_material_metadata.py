"""Repair NVR decal alpha metadata; preserve every geometry and texture byte."""
import ast,datetime,hashlib,io,json,struct
from pathlib import Path
from PIL import Image
r=Path(__file__).resolve().parents[1];deploy=Path(json.loads((r/'docs/heal_source_validation.json').read_text(encoding='utf-8'))['native_source']).parents[2];native_root=deploy/'LEVELS/Map10';nvr=native_root/'scene/room.nvr';native=nvr.read_bytes();count=struct.unpack_from('<i',native,8)[0];assert 0<count<10000
materials={};off=28
for i in range(count):
 name=native[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',native,off+260);start=off+268
 texture=native[start+16:start+276].split(b'\0')[0].decode();formatted='NVRMaterial_'+('AlphaTest_' if flags&4 else '')+name
 materials[formatted]={'type':typ,'flags':flags,'texture':texture};off+=268+8*340
assert off<=len(native)
path=r/'assets/maps/twisted_treeline.glb';raw=path.read_bytes();assert raw[:4]==b'glTF' and struct.unpack_from('<I',raw,8)[0]==len(raw)
n=struct.unpack_from('<I',raw,12)[0];doc=json.loads(raw[20:20+n]);tail=raw[20+n:];binary=raw[28+n:];changes=[];native_pixels=[]
for index,m in enumerate(doc['materials']):
 source=materials.get(m.get('name'))
 if not source:continue
 if source['type']==1:
  before={k:m[k] for k in ('alphaMode','alphaCutoff') if k in m}
  m['alphaMode']='BLEND';m.pop('alphaCutoff',None)
  changes.append({'material':m['name'],'index':index,'native_type':1,'native_flags':source['flags'],'before':before,'after':'BLEND'})
 if source['type']==1 or 'web' in m['name'].lower():
  texture=doc['textures'][m['pbrMetallicRoughness']['baseColorTexture']['index']];image=doc['images'][texture['source']];view=doc['bufferViews'][image['bufferView']];start=view.get('byteOffset',0);im=Image.open(io.BytesIO(binary[start:start+view['byteLength']])).convert('RGBA');dds=native_root/'scene/Textures'/source['texture']
  if dds.exists():
   original=Image.open(dds).convert('RGBA');equal=im.size==original.size and im.tobytes()==original.tobytes();assert equal,(m['name'],'native pixels mismatch')
   native_pixels.append({'material':m['name'],'source':str(dds),'native_sha256':hashlib.sha256(dds.read_bytes()).hexdigest(),'pixels_identical':equal,'dimensions':im.size})
  else:native_pixels.append({'material':m['name'],'source':str(dds),'native_source_missing':True})
assert len(changes)==3
before_doc=json.loads(raw[20:20+n]);assert doc['meshes']==before_doc['meshes'] and doc['nodes']==before_doc['nodes'] and doc['images']==before_doc['images'] and doc['accessors']==before_doc['accessors']
backup=r/'assets/maps/twisted_treeline.before_decal_alpha.glb'
if not backup.exists():backup.write_bytes(raw)
encoded=json.dumps(doc,separators=(',',':')).encode();encoded+=b' '*((-len(encoded))%4);result=struct.pack('<4sII',b'glTF',2,20+len(encoded)+len(tail))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+tail
path.write_bytes(result)
ns={'struct':struct};tree=ast.parse(Path(r'E:\mapslol3v3\tools\import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns)
terrain=native_root/'terrain.inibin';values=ns['ini'](terrain);rgb=[int(values[ns['hashkey']('Fog',channel)]) for channel in ('Red','Green','Blue')];enabled=values[ns['hashkey']('Fog','Enable')];assert rgb==[34,62,84] and enabled
settings={'native_fog_rgb':rgb,'native_fog_enabled':enabled,'source':str(terrain),'source_sha256':hashlib.sha256(terrain.read_bytes()).hexdigest(),'usage':'Use native fog RGB as background clear color; background/fog association is reconstructed, full native fog shader/distance/masks not implemented.'}
(r/'data/4.20/map_visual_settings.json').write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8')
proof={'passed':True,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_nvr':str(nvr),'native_nvr_sha256':hashlib.sha256(native).hexdigest(),'before_sha256':hashlib.sha256(raw).hexdigest(),'after_sha256':hashlib.sha256(result).hexdigest(),'backup':str(backup),'changes':changes,'binary_chunks_unchanged':tail==result[20+len(encoded):],'nodes_meshes_accessors_images_unchanged':True,'native_texture_pixels':native_pixels,'native_fog_settings':settings,'limits':['Three native type-1 decals use standard glTF blend to retain intermediate alpha; exact original shader/vertex tint/depth bias still unqualified.','Native spider web geometry/materials retained; bright webs are not missing branch textures.','Original Blender export and old projects unchanged; this OpenLeague GLB is a derivative with documented alpha metadata repair.','Full fog renderer, four-layer terrain shader, shadows, weather, original visual equivalence and complete map remain incomplete.']}
(r/'docs/map_material_repair.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'decal_changes':len(changes),'native_textures_verified':sum(x.get('pixels_identical',False) for x in native_pixels),'fog_rgb':rgb,'binary_unchanged':proof['binary_chunks_unchanged'],'map_sha256':proof['after_sha256']}))
