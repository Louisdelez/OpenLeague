from pathlib import Path
import struct,json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'))
vb=a+0x5000;ib=a+0x6000;vbdata=a+0x7000;ibdata=a+0x8000;buffervt=a+0x9000
w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt)
w(vt+0x38,callbacks+0x38);w(vt+0x4c,callbacks+0x4c)
w(vb,buffervt);w(ib,buffervt);w(buffervt+0x10,callbacks+0x10);w(buffervt+0x14,callbacks+0x14);w(buffervt+4,callbacks+4)
events=[];visited=set();failure=0
def capture(uc,addr,size,user):
 if addr in [callbacks+0x38,callbacks+0x4c]:
  n=4 if addr==callbacks+0x38 else 5;values=args(n);events.append(dict(factory=hex(addr-callbacks),arguments=values))
  handle=vb if n==4 else ib;w(values[-1],0 if failure==(1 if n==4 else 2) else handle);finish(n*4);return
 if addr==callbacks+0x10:
  values=args(4);handle=u.reg_read(UC_X86_REG_ECX);events.append(dict(lock='vertex' if handle==vb else 'index',arguments=values))
  w(values[2],vbdata if handle==vb else ibdata);finish(16);return
 if addr in [callbacks+0x14,callbacks+4]:events.append(dict(buffer_operation=hex(addr-callbacks),handle=u.reg_read(UC_X86_REG_ECX)));finish();return
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[]
for sentinel,disabled,failure in itertools.product([0,0xaa,0x55],[False,True],[0,1,2]):
 events=[];u.mem_write(vbdata,bytes([sentinel])*96);u.mem_write(ibdata,bytes([sentinel])*8)
 w(manager+0x20304,0);w(manager+0x20308,0);u.mem_write(manager+0x20301,bytes([int(disabled)]))
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager)
 u.emu_start(0x983040,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 vertices=list(struct.unpack('<24I',u.mem_read(vbdata,96)));indices=list(struct.unpack('<4H',u.mem_read(ibdata,8)))
 if not disabled and failure!=1:
  expected=[0,0,0,0xffffffff,0,0,0x3f800000,0,0,0xffffffff,0x3f800000,0,0,0x3f800000,0,0xffffffff,0,0x3f800000,0x3f800000,0x3f800000,0,0xffffffff,0x3f800000,0x3f800000]
  assert vertices==expected
 if not disabled and failure!=2:assert indices==[0,1,2,3]
 cases.append(dict(initial_byte=sentinel,disabled=disabled,failure_adapter=failure,events=list(events),vertex_words=vertices,indices_u16=indices,return_byte=u.reg_read(UC_X86_REG_EAX)&255))
decl=bytes(u.mem_read(0x10d3fb4,32));elements=[list(struct.unpack('<HH4B',decl[i:i+8])) for i in range(0,32,8)]
primitive=read(0x10e2b0c+4)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x983040',original_instruction_addresses=len(visited),vertex_stride=24,vertex_count=4,index_count=4,index_format_bits=16,native_declaration_address='0x10d3fb4',native_declaration_elements=elements,abstract_draw_primitive=1,d3d_draw_primitive=primitive,cases=cases,runtime_adapters=['Buffer factory virtual38/4C supplies handles or null; lock virtual10 supplies explicit writable memory; unlock/release recording boundaries.'],limits=['OriginalCPUvertex/indexinitializer and originalPE declaration/primitive tables qualified; realD3Dbufferallocation/declarationcreation and draw API not yet executed.','Factory failure doesnotsetrenderererrorbyte in adapter; native successfulreturn is not a real allocation guarantee.','No livegrass render or originalGPU reference.'])
assert elements==[[0,0,2,0,0,0],[0,12,4,0,6,0],[0,16,1,0,4,0],[255,0,8,0,0,0]],elements
proof['limits'].append('Declaration bytes are abstract driver enums, not direct D3D enums; native translation remains to qualify. Initial direct-D3D interpretation rejected by observed original values.')
assert primitive==5
(r/'data/4.20/grass_buffers_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),declaration=elements,d3d_primitive=primitive)))
