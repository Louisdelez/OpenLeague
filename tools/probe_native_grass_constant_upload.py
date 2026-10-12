from pathlib import Path
import struct,json,hashlib,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'));u.mem_map(0,0x1000)
device=a+0x36000;devicevt=a+0x37000;constant_api=a+0x38000;sampler_api=a+0x38010
w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt);w(driver+0x14,device);w(device,devicevt);w(devicevt+0x178,constant_api);w(devicevt+0x114,sampler_api)
w(0x2c,a+0x39000);w(a+0x39000,a+0x39100);w(0x14bef38,default);w(manager+0x2035c,0xffffffff)
for slot in counts:w(vt+slot,callbacks+slot)
w(vt+0x8c,0x9c30f0);w(vt+0x70,0x9c2270)
uploads=[];samplers=[];visited=set()
def capture(uc,addr,size,user):
 if addr==constant_api:
  receiver,start,data,n=args(4);assert receiver==device
  uploads.append(dict(start=start,count=n,words=list(struct.unpack('<'+'I'*(n*4),u.mem_read(data,n*16)))));finish(16);return
 if addr==sampler_api:
  receiver,stage,key,value=args(4);assert receiver==device;samplers.append([stage,key,value]);finish(16);return
 if callbacks<=addr<callbacks+0x100:
  slot=addr-callbacks;values=args(counts[slot])
  if slot==0x94:w(values[0],1)
  finish(counts[slot]*4);return
 if addr==0x983cb0:finish(8);return
 if addr==0x9844c0:finish(4);return
 if addr in [0x5f6620,0xc975f5]:finish(value=u.reg_read(UC_X86_REG_EAX));return
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
quad=json.loads((r/'data/4.20/grass_quad_contract.json').read_text(encoding='utf-8'))
matrix=json.loads((r/'data/4.20/grass_screen_matrix_contract.json').read_text(encoding='utf-8'))
matrices={c['api_flag']:c['matrix_bits'] for c in matrix['cases'] if c['width']==803 and c['height']==607}
cases=[]
for i,c in enumerate(quad['cases']):
 for filters in [[1,1,0],[2,2,2]]:
  uploads=[];samplers=[]
  u.mem_write(rect,struct.pack('<4i',*c['destination_rectangle']));u.mem_write(uvrect,struct.pack('<4i',*c['source_rectangle']));w(color,0xffffffff)
  w(0x1225c58,c['api_flag']);w(0x2d9101c,int(c['offset_cache_warm']));w(0x2d90ff4,c['initial_cached_offset_bits'])
  size=c['source_size']
  if size:w(context+0x60,size[0]);w(context+0x64,size[1])
  u.mem_write(manager+0x244,struct.pack('<16I',*matrices[c['api_flag']]))
  for key in range(8):w(driver+0x164+key*4,0)
  for key,value in zip([4,5,6],filters):w(driver+0x164+key*4,value)
  w(stack,end);w(stack+4,uvrect);w(stack+8,color);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,rect);u.reg_write(UC_X86_REG_EDX,context if size else 0)
  u.emu_start(0x986760,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  expected=[dict(start=0,count=4,words=matrices[c['api_flag']]),dict(start=4,count=1,words=c['destination_xywh_bits']),dict(start=5,count=1,words=c['source_uv_origin_span_bits']),dict(start=6,count=1,words=c['color_rgba_bits'])]
  assert uploads==expected
  assert samplers==[[0,1,3],[0,2,3],[0,1,1],[0,2,1]]
  final=[read(driver+0x164+key*4) for key in [4,5,6]];assert final==filters
  cases.append(dict(quad_case=i,inherited_filter_cache=filters,final_filter_cache=final,uploads=list(uploads),device_sampler_calls=list(samplers)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x986760',constant_driver='0x9c30f0 ->0x9c63c0 ->D3DSetVertexShaderConstantF',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['D3Dvertexconstant andsampler API boundaries recordrawwords/arguments andreturnS_OK.','Otherdriverbuffer/state/drawcallbacks, pixelshaderselector, texturebinding andprofiling helpers recordingadapters.','Explicit renderer/context/cache/viewport/nativeAPIflag andTLS prerequisites.'],limits=['Actual quadarithmetic, nativeconstantdispatch andsamplertranslation execute; inheritedfiltersremainunchanged in thisscope. Earlierpixelshaderselection/texturebinding producers mocked, so finalsceneinheritedfilters notqualified.','No originalGPU; actor/cameraproviders and normalgrassintegration remainopen.'])
(r/'data/4.20/grass_constant_upload_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),constant_submissions=len(cases)*4,sampler_submissions=len(cases)*4)))
