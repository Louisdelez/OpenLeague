import ast,struct,json,hashlib,datetime,sys,re
from pathlib import Path
import numpy as np
from PIL import Image
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs');import pefile,capstone
r=Path(r'E:\OpenLeague');deploy=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy');m=deploy/'LEVELS/Map10';ns={'struct':struct};tree=ast.parse(Path(r'E:\mapslol3v3\tools\import_all_champions.py').read_text(encoding='utf-8'));exec(compile(ast.Module(body=[x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name in ('ini','hashkey')],type_ignores=[]),'parser','exec'),ns);v=ns['ini'](m/'terrain.inibin')
props=['Enable','min_height','max_height','min_opaque_height','max_opaque_height','min_radius','max_radius','opacity','useOpacityMap'];native={p:v[ns['hashkey']('Fog',p)] for p in props};rgb=[int(v[ns['hashkey']('Fog',p)]) for p in ['Red','Green','Blue']];hmin=float(native['min_height']);hmax=float(native['max_height']);omin=float(native['min_opaque_height']);omax=float(native['max_opaque_height']);rmin=float(native['min_radius']);rmax=float(native['max_radius']);opacity=float(native['opacity']);hmin=min(hmin,hmax-.1);rmin=min(rmin,rmax-.01)
fog0=[1/(hmax-hmin),-hmin/(hmax-hmin),1/(rmax-rmin),-rmin/(rmax-rmin)];fog1=[1-opacity,-1/(omax-omin),1+omin/(omax-omin),0]
# Preserve the qualified native SSE arithmetic and screen-radius convention.
consumer=json.loads((r/'data/4.20/native_fog_consumer_contract.json').read_text(encoding='utf-8'))
assert consumer['passed'] and consumer['source_sha256']==hashlib.sha256((m/'terrain.inibin').read_bytes()).hexdigest()
fog0=consumer['shader_field_vectors']['0x14beed4'];fog1=consumer['shader_field_vectors']['0x14beee4']
b=(deploy/'League of Legends.exe').read_bytes();pe=pefile.PE(data=b);base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);offset=pe.get_offset_from_rva(0x987480-base);ins=list(md.disasm(b[offset:offset+381],0x987480));assert any(i.address==0x98757b and i.mnemonic=='subss' and i.op_str=='xmm0, xmm4' for i in ins);assert any(i.mnemonic=='push' and i.op_str=='0xec' for i in ins)
fogsrc=m/'fogLightingMap.dds';dest=r/'assets/maps/terrain_native/fogLightingMap.png';im=Image.open(fogsrc).convert('RGBA');im.save(dest);print('fog texture',im.size,'mean',np.asarray(im).mean((0,1)).tolist());n=(m/'scene/room.nvr').read_bytes();materials=[]
for i in range(struct.unpack_from('<i',n,8)[0]):
 off=28+i*(268+8*340);name=n[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',n,off+260)
 # Native background flag selects shaders separately; retain those unchanged.
 if flags&32 and not flags&64:continue
 materials.append('NVRMaterial_'+('AlphaTest_' if flags&4 else '')+name)
glb=(r/'assets/maps/twisted_treeline.glb').read_bytes();glb_len=struct.unpack_from('<I',glb,12)[0];gltf=json.loads(glb[20:20+glb_len]);aliases=[]
ma,vb,ib,mc,nc=struct.unpack_from('<5i',n,8);mesh_offset=28+ma*(268+8*340)
for i in range(vb):mesh_offset+=4+struct.unpack_from('<i',n,mesh_offset)[0]
for i in range(ib):mesh_offset+=8+struct.unpack_from('<i',n,mesh_offset)[0]
native_names=[]
for i in range(ma):
 off=28+i*(268+8*340);name=n[off:off+260].split(b'\0')[0].decode();flags=struct.unpack_from('<I',n,off+264)[0];native_names.append('NVRMaterial_'+('AlphaTest_' if flags&4 else '')+name)
for material_index,material in enumerate(gltf['materials']):
 name=material.get('name','')
 if not name.startswith('NVRMaterial_') or name in materials:continue
 references=[]
 for mesh in gltf['meshes']:
  match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
  if not match or not any(p.get('material')==material_index for p in mesh['primitives']):continue
  mi=int(match[1]);mid=struct.unpack_from('<i',n,mesh_offset+mi*100+48)[0];references.append({'native_mesh':mi,'native_material_id':mid,'native_material':native_names[mid]})
 assert references,(name,'no authoritative native geometry reference')
 candidates=sorted(set(x['native_material'] for x in references));assert all(x in materials for x in candidates),(name,candidates)
 aliases.append({'exported_name':name,'native_materials':candidates,'native_geometry_references':references,'policy':'Exported material mapped through authoritative NVR mesh material IDs, including ambiguous truncated prefixes.'})
materials.extend(x['exported_name'] for x in aliases)
settings={'enabled':bool(native['Enable']),'native_config':native,'native_fog_rgb':rgb,'fog_data0':fog0,'fog_data1':fog1,'fog_lighting':'maps/terrain_native/fogLightingMap.png','environment_materials':materials,'verified_truncated_material_aliases':aliases,'native_units_per_world_unit':20.,'native_z_mirror_origin':15398.6719,'spatial_denominator':15360.,'policy':'Opaque far-height fog integrated. Native top-layer opacity is not identically zero: at opacity1 it equals1-heightFog for Map10 radial coefficients. Native PE initial fog quality2 selects dual-layer textured-opacity fog; clouds/high layer integrated into current runtime; see docs/native_high_fog_progress.json for scope and limits.','limits':['Fog lighting UV uses existing reconstructed xz/15360 mapping; original FOG_OF_WAR_PARAMS c230 remains unqualified.','Native shader variant, fog of war coupling, clouds, actor fog, samplers and gamma remain incomplete.','Environment material routing follows NVR flags; complete renderer fidelity unproven.']}
(r/'data/4.20/map_fog_settings.json').write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8')
shader=deploy/'DATA/Shaders/HLSL/Fog/Fog.hls';proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_config_path':str(m/'terrain.inibin'),'native_config_sha256':hashlib.sha256((m/'terrain.inibin').read_bytes()).hexdigest(),'native_executable_sha256':hashlib.sha256(b).hexdigest(),'shader':str(shader),'shader_sha256':hashlib.sha256(shader.read_bytes()).hexdigest(),'native_config':native,'fog_data0':fog0,'fog_data1':fog1,'native_c236_upload_instructions':[f'{i.address:x}: {i.mnemonic} {i.op_str}' for i in ins],'fog_texture_sha256':hashlib.sha256(fogsrc.read_bytes()).hexdigest(),'fog_texture_dimensions':im.size,'material_routing_count':len(materials),'verified_truncated_material_aliases':aliases,'limits':settings['limits']}
(r/'docs/map_fog_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'fog_data0':fog0,'fog_data1':fog1,'routing_materials':len(materials),'opaque_heights':[omin,omax]}))
