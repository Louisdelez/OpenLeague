from pathlib import Path
import json,struct,hashlib,datetime
prefix=Path('E:/mapslol3v3/probe_native_environment_shader_selection.py').read_text().split('cases=[]')[0];exec(compile(prefix,'native environment selector prerequisites','exec'))
nvr=p.parent/'LEVELS/Map10/scene/room.nvr';data=nvr.read_bytes();count=struct.unpack_from('<I',data,8)[0];assert 0<count<1000
src=context+0x8000;profiles=[];copy_addresses=set()
for index in range(count):
 record=data[28+index*2988:28+(index+1)*2988];assert len(record)==2988
 u.mem_write(src,record);u.mem_write(material,bytes(0x1000));w(stack,end);w(stack+4,src);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,material);visited.clear();u.emu_start(0x958900,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert bytes(u.mem_read(material,2988))==record,index;copy_addresses.update(visited)
 name=record[:260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',record,260);assert read(material+0x104)==typ and read(material+0x108)==flags
 selections=[]
 for emissive in [False,True]:
  selected.clear();textures.clear();w(material+0xbb0,111 if emissive else 0);w(context+0x54,0);w(0x2d90f30,0);w(0x2d78fb0,0);w(stack,end);w(stack+4,material);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(0x95a730,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
  selections.append({'emissive_handle_present':emissive,'selected':selected.copy()})
 profiles.append({'native_material_index':index,'name':name,'gltf_name':'NVRMaterial_'+('AlphaTest_' if flags&4 else '')+name,'type':typ,'flags':flags,'record_sha256':hashlib.sha256(record).hexdigest(),'native_copy_bytes_equal':True,'selector0':selections})
glb=r/'assets/maps/twisted_treeline.glb';raw_glb=glb.read_bytes();jlen=struct.unpack_from('<I',raw_glb,12)[0];doc=json.loads(raw_glb[20:20+jlen]);by_name={x['gltf_name']:x for x in profiles};matched=[];unmatched=[]
# Blender truncates long names. Recover exact record ownership through retained native mesh indices.
import re
_,vbc,ibc,mc,nc=struct.unpack_from('<5i',data,8);offset=28+count*2988
for _ in range(vbc):size=struct.unpack_from('<I',data,offset)[0];offset+=4+size
for _ in range(ibc):size=struct.unpack_from('<I',data,offset)[0];offset+=8+size
owners={}
for mesh in doc['meshes']:
 match=re.search(r'MapGeo_Instance_(\d+)',mesh.get('name',''))
 if not match:continue
 mi=int(match[1]);assert mi<mc;mid=struct.unpack_from('<I',data,offset+mi*100+48)[0];assert mid<count
 for primitive in mesh['primitives']:
  gi=primitive['material'];owners.setdefault(gi,set()).add(mid)
assert all(len(ids)==1 for ids in owners.values())
for index,m in enumerate(doc['materials']):
 name=m.get('name','');native_material=by_name.get(name);method='exact_name'
 if index in owners:
  mid=next(iter(owners[index]));assert native_material is None or native_material['native_material_index']==mid
  native_material=profiles[mid];method='native_mesh_material_reference'
 if native_material:matched.append({'gltf_material_index':index,'name':name,'native_material_index':native_material['native_material_index'],'type':native_material['type'],'flags':native_material['flags'],'mapping_method':method,'native_name':native_material['name']})
 else:unmatched.append({'index':index,'name':name})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':hashlib.sha256(raw).hexdigest(),'native_nvr_sha256':hashlib.sha256(data).hexdigest(),'native_nvr':str(nvr),'map_glb_sha256':hashlib.sha256(raw_glb).hexdigest(),'material_copy_entry':'0x958900','material_copy_native_addresses':len(copy_addresses),'native_material_record_bytes':2988,'native_material_count':count,'profiles':profiles,'gltf_materials_matched':matched,'gltf_materials_unmatched':unmatched,'findings':['Original2988byte native material copy executes on every actual Map10 NVR material, preserving entire record byte-for-byte.','NVR type at260 and flags at264 transfer directly to runtime offsets0x104/0x108 consumed by native selector95A730.','Selector0 material pairs executed for each actual record under both absent/present supplied emissive handle.'],'limits':['Emissive runtime handle producer and actual source texture load not qualified; both input states supplied, no assumption which applies in original gameplay.','Pass-selector0 meaning and complete render frame routing still unqualified.','Static record match does not implement original lighting/alpha/fog/death/shadow variant pixels.','Any non-NVR GLB material remains separately sourced; no fabricated binding.']}
(r/'data/4.20/map10_shader_material_fields.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'native_materials':count,'copy_addresses':len(copy_addresses),'gltf_matched':len(matched),'gltf_unmatched':unmatched,'types':sorted({x['type'] for x in profiles}),'flags':sorted({x['flags'] for x in profiles})}))
