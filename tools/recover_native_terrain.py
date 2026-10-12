"""Recover Map10 height-blend layers and tile UVs from authoritative NVR."""
import ast,datetime,hashlib,json,re,struct,sys
from pathlib import Path
import numpy as np
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
import pefile,capstone
DEPLOY=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy')
MAP=DEPLOY/'LEVELS/Map10';NVR=MAP/'scene/room.nvr'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
ns={'struct':struct};tree=ast.parse(Path(r'E:\mapslol3v3\tools\import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns)
config=ns['ini'](MAP/'terrain.inibin');assert config[ns['hashkey']('HeightBlending','Enable')] is True
scales=[float(config[ns['hashkey']('HeightBlending',f'layer{i}_scale')]) for i in range(4)]
exe=DEPLOY/'League of Legends.exe';b=exe.read_bytes();pe=pefile.PE(data=b);base=pe.OPTIONAL_HEADER.ImageBase
half_offset=pe.get_offset_from_rva(0x1110b04-base);half=struct.unpack_from('<f',b,half_offset)[0];assert abs(half-.1)<1e-7
# Confirm constant is loaded into HEIGHTBLEND_DATA.a, uploaded to pixel c25.
off=pe.get_offset_from_rva(0x95a6d7-base);code=b[off:off+58];dis=list(capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32).disasm(code,0x95a6d7))
assert any(x.mnemonic=='movss' and x.op_str=='xmm0, dword ptr [0x1110b04]' for x in dis)
assert any(x.mnemonic=='movss' and x.op_str=='dword ptr [ebp - 0xc], xmm0' for x in dis)
assert any(x.mnemonic=='push' and x.op_str=='0x19' for x in dis)
n=NVR.read_bytes();ma,vbc,ibc,mc,nc=struct.unpack_from('<5i',n,8);off=28;native_mats=[]
for i in range(ma):
 name=n[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',n,off+260);channels=[]
 for slot in range(8):
  c=off+268+slot*340;channels.append({'texture':n[c+16:c+276].split(b'\0')[0].decode(),'transform':list(struct.unpack_from('<16f',n,c+276))})
 native_mats.append({'name':name,'type':typ,'flags':flags,'channels':channels});off+=268+8*340
vbs=[]
for i in range(vbc):
 size=struct.unpack_from('<i',n,off)[0];off+=4;vbs.append(off);off+=size
for i in range(ibc):
 size,fmt=struct.unpack_from('<2i',n,off);off+=8+size
native_meshes={}
for i in range(mc):
 mo=off+i*100;mid=struct.unpack_from('<i',n,mo+48)[0]
 if native_mats[mid]['type']!=3:continue
 vbi,sv,vc,ibi,si,ic=struct.unpack_from('<6i',n,mo+52)
 rows=np.frombuffer(n,dtype='<f4',count=vc*11,offset=vbs[vbi]+sv*44).reshape(vc,11)
 native_meshes[i]=(mid,rows)
p=ROOT/'assets/maps/twisted_treeline.glb';backup=ROOT/'assets/maps/twisted_treeline.before_native_uv.glb';raw=(backup if backup.exists() else p).read_bytes();jl=struct.unpack_from('<I',raw,12)[0];doc=json.loads(raw[20:20+jl]);blob=bytearray(raw[28+jl:]);original_binary_len=len(blob)
def accessor(index):
 a=doc['accessors'][index];v=doc['bufferViews'][a['bufferView']];assert a['componentType']==5126
 cols={'VEC2':2,'VEC3':3,'VEC4':4}[a['type']]
 return np.ndarray((a['count'],cols),dtype='<f4',buffer=blob,offset=v.get('byteOffset',0)+a.get('byteOffset',0),strides=(v.get('byteStride',4*cols),4)).copy()
def append_uv(uv):
 blob.extend(b'\0'*((-len(blob))%4));start=len(blob);data=uv.astype('<f4').tobytes();blob.extend(data);vi=len(doc['bufferViews']);doc['bufferViews'].append({'buffer':0,'byteOffset':start,'byteLength':len(data),'target':34962});ai=len(doc['accessors']);doc['accessors'].append({'bufferView':vi,'componentType':5126,'count':len(uv),'type':'VEC2'});return ai
changes=[];fallbacks={}
for mesh in doc['meshes']:
 for prim in mesh['primitives']:
  name=doc['materials'][prim.get('material',0)].get('name','')
  if name not in ['NVRMaterial_TT_Jungle1','NVRMaterial_TT_Lanes1']:continue
  match=re.search(r'MapGeo_Instance_(\d+)',mesh['name'])
  if not match:
   if name not in fallbacks:
    copy=json.loads(json.dumps(doc['materials'][prim['material']]));copy['name']='ReconstructedTerrainFallback_'+name;fallbacks[name]=len(doc['materials']);doc['materials'].append(copy)
   prim['material']=fallbacks[name]
   continue
  mi=int(match[1]);mid,rows=native_meshes[mi];assert name=='NVRMaterial_'+native_mats[mid]['name']
  pos=accessor(prim['attributes']['POSITION']);uv=np.empty((len(pos),2),np.float32);max_delta=0.;ambiguous=0
  for j,point in enumerate(pos):
   ds=np.sum((rows[:,:3]-point)**2,axis=1);matches=np.flatnonzero(ds<.0025);assert len(matches),(mesh['name'],j,float(ds.min()))
   selected=matches[np.argmin(ds[matches])];uv[j]=rows[selected,6:8];max_delta=max(max_delta,float(np.sqrt(ds[selected])))
   assert np.allclose(rows[matches,6:8],uv[j],atol=1e-5),(mesh['name'],j,'ambiguous UV seam')
  prim['attributes']['TEXCOORD_0']=append_uv(uv)
  # Spatial transform retained from previous export until native c233 binding is qualified.
  prim['attributes']['TEXCOORD_1']=append_uv(pos[:,[0,2]]/15360.)
  changes.append({'mesh':mesh['name'],'native_mesh':mi,'vertices':len(pos),'native_position_max_error':max_delta})
assert changes
out=ROOT/'assets/maps/terrain_native';out.mkdir(exist_ok=True)
files={}
for mid in [1,2]:
 mat=native_mats[mid];assert mat['type']==3
 layers=[]
 for slot in [0,2,4,6]:
  src=MAP/'scene/Textures'/mat['channels'][slot]['texture'];dest=out/(src.stem+'.png');Image.open(src).convert('RGBA').save(dest);files[str(dest.relative_to(ROOT/'assets'))]={'native':str(src),'native_sha256':sha(src),'png_sha256':sha(dest)};layers.append(str(dest.relative_to(ROOT/'assets')).replace('\\','/'))
 mat['layer_paths']=layers
for src in [MAP/'terrainHeightScale.dds',MAP/'compositeColorMap.dds']:
 dest=out/(src.stem+'.png');Image.open(src).convert('RGBA').save(dest);files[str(dest.relative_to(ROOT/'assets'))]={'native':str(src),'native_sha256':sha(src),'png_sha256':sha(dest)}
backup=ROOT/'assets/maps/twisted_treeline.before_native_uv.glb'
if not backup.exists():backup.write_bytes(raw)
doc['buffers'][0]['byteLength']=len(blob);encoded=json.dumps(doc,separators=(',',':')).encode();encoded+=b' '*((-len(encoded))%4);blob.extend(b'\0'*((-len(blob))%4));result=struct.pack('<4sII',b'glTF',2,28+len(encoded)+len(blob))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+struct.pack('<II',len(blob),0x004e4942)+blob
assert blob[:original_binary_len]==raw[28+jl:]
p.write_bytes(result)
settings={'enabled':True,'layer_scales':scales,'half_blend_area':half,'terrain_materials':[{'name':'NVRMaterial_'+native_mats[i]['name'],'layers':native_mats[i]['layer_paths']} for i in [1,2]],'height_map':'maps/terrain_native/terrainHeightScale.png','colormap':'maps/terrain_native/compositeColorMap.png','spatial_uv_policy':'Native position xz / 15360 retained from earlier export; exact c233 transform not yet qualified.','lighting_policy':'MOD2X_COLORMAP with shadows disabled: composite map * 4; native variant/gamma/fog/shadow qualification incomplete.'}
(ROOT/'data/4.20/terrain_materials.json').write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8')
shaders=DEPLOY/'DATA/Shaders/HLSL';source_paths=[shaders/'HeightBlending/HeightBlending.hls',shaders/'Environment/LIT_PS.ps_2_0',shaders/'Environment/LIT_VS.vs_2_0']
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'nvr':str(NVR),'nvr_sha256':sha(NVR),'terrain_config_sha256':sha(MAP/'terrain.inibin'),'native_executable_sha256':sha(exe),'height_blending_enabled':True,'layer_scales':scales,'half_blend_area':half,'half_blend_constant_file_offset':half_offset,'pixel_c25_upload_instructions':[f'{x.address:x}: {x.mnemonic} {x.op_str}' for x in dis],'shader_sources':[{'path':str(x),'sha256':sha(x)} for x in source_paths],'textures':files,'native_uv_meshes':changes,'map_before_sha256':hashlib.sha256(raw).hexdigest(),'map_after_sha256':sha(p),'original_binary_bytes_unchanged':True,'limits':[settings['spatial_uv_policy'],settings['lighting_policy'],'Native HLSL height-blend math recovered; full map/game remains incomplete.']}
(ROOT/'docs/terrain_native_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_uv_meshes':len(changes),'native_uv_vertices':sum(x['vertices'] for x in changes),'max_position_error':max(x['native_position_max_error'] for x in changes),'scales':scales,'half_blend_area':half,'map_sha256':sha(p)}))
