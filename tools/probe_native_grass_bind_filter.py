from pathlib import Path
import struct,json,hashlib,datetime
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_grass_constant_upload.py').read_text(encoding='utf-8').split('quad=json.loads')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,capture)','first_hook=u.hook_add(unicorn.UC_HOOK_CODE,capture)')
exec(compile(source,'compound quad setup','exec'));u.hook_del(first_hook)
texture_object=a+0xb000;texture_vt=a+0xc000;raw_texture=a+0xd000;texture_api=a+0x38020
w(texture_object,texture_vt);w(texture_vt,callbacks+0xa0);w(texture_vt+4,callbacks+0xa4);w(texture_vt+0xc,callbacks+0xa8)
for handle in [context,default]:w(handle+0x8c,texture_object);w(handle+0xc,1234)
for slot in [0x68,0x6c,0x90]:w(vt+slot,read(0x10e2f30+slot))
w(devicevt+0x104,texture_api)
textures=[];ref_calls=[]
def bind_capture(uc,addr,size,user):
 if addr==callbacks+0x94:w(args(1)[0],int(shader_override));finish(4);return
 if addr==texture_api:
  receiver,stage,texture=args(3);assert receiver==device;textures.append([stage,texture]);finish(12);return
 if addr in [callbacks+0xa0,callbacks+0xa4,callbacks+0xa8]:ref_calls.append(hex(addr-callbacks));finish(value=raw_texture if addr==callbacks+0xa8 else 1);return
 if addr in [0x983cb0,0x9844c0]:visited.add(addr);return
 capture(uc,addr,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,bind_capture)
quad=json.loads((r/'data/4.20/grass_quad_contract.json').read_text(encoding='utf-8'));cases=[]
matrix=json.loads((r/'data/4.20/grass_screen_matrix_contract.json').read_text(encoding='utf-8'))
matrices={c['api_flag']:c['matrix_bits'] for c in matrix['cases'] if c['width']==803 and c['height']==607}
for i,c in enumerate(quad['cases']):
 for filters in [[1,1,0],[2,2,2]]:
  for shader_index,shader_override in [(-1,False),(0,False),(1,False),(-1,True),(0,True),(1,True)]:
   uploads=[];samplers=[];textures=[];ref_calls=[]
   u.mem_write(rect,struct.pack('<4i',*c['destination_rectangle']));u.mem_write(uvrect,struct.pack('<4i',*c['source_rectangle']));w(color,0xffffffff)
   w(0x1225c58,c['api_flag']);w(0x2d9101c,int(c['offset_cache_warm']));w(0x2d90ff4,c['initial_cached_offset_bits']);size=c['source_size']
   if size:w(context+0x60,size[0]);w(context+0x64,size[1])
   u.mem_write(manager+0x244,struct.pack('<16I',*matrices[c['api_flag']]))
   for key in range(8):w(driver+0x164+key*4,0)
   for key,value in zip([4,5,6],filters):w(driver+0x164+key*4,value)
   w(driver+0x58,0);w(driver+0xa8,0xabcdef);w(0x2d77ad0,0);w(0x14beef8,0xffffffff)
   w(manager+0x20374+8,shader_index);w(manager+0x2d8,0x12345000);w(manager+0x2d8+128,0)
   w(stack,end);w(stack+4,uvrect);w(stack+8,color);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,rect);u.reg_write(UC_X86_REG_EDX,context if size else 0)
   u.emu_start(0x986760,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
   final=[read(driver+0x164+key*4) for key in [4,5,6]];assert final==filters
   assert textures==[[0,raw_texture]]
   assert read(driver+0x58)==texture_object
   expected_shader=0xabcdef if shader_override else (0 if shader_index==-1 else (0x12345000 if shader_index==0 else 0xabcdef))
   assert read(driver+0xa8)==expected_shader
   cases.append(dict(quad_case=i,shader_index=shader_index,shader_override=shader_override,inherited_filter_cache=filters,final_filter_cache=final,texture_api_calls=list(textures),shader_cached_handle=read(driver+0xa8),device_sampler_calls=list(samplers)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x986760',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Opaque texture refcount/release/GetInterface methods supply rawhandle; originalmanager/driverbindings execute throughD3DSetTextureAPIboundaryreturnS_OK.','Otherstate/buffer/drawcallbacks recordingadapters; shaderselector9844C0 andtexturebinding983CB0 nowexecute unchanged.','Explicit validrenderer/shaderregistry/textureobject/cache/TLS prerequisites; earliermaskshadernameproducer remainsseparate.'],limits=['Qualifies quad texturebinding andfallbackshaderselection withoutfiltermutation, not upstreammaskpassshader/setup or drawtimecompiledprogramflush.','OpaqueCOMownership notqualified, suppliedhandles notactualGPUresources; no livegrass/camera/actors.'])
(r/'data/4.20/grass_bind_filter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),texture_submissions=len(cases),filters_preserved=True)))
