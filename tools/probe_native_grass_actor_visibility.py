from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
actor=terrain+0x2000;source=terrain+0x5000;service=terrain+0x6000;table=terrain+0x7000;gate_api=0xc9f3a0
write32(0x2d787b8,service);write32(service,table);write32(table+0xb0,gate_api)
sequence=[];calls=[]
def boundary(uc,a,size,user):
 if a==gate_api:
  assert u.reg_read(UC_X86_REG_ECX)==service
  value=sequence[min(len(calls),len(sequence)-1)];calls.append(value)
  s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,0xaabbcc00|value)
  u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
for override,seq,flag24,flag2c,flags5ea,selector,mask in itertools.product([0,128],[[0,0],[128,128],[128,0]],[0,128],[0,128],[0,1,2],[-2,-1,0,1,31,32,33,-3],[0,1,2,0x80000000]):
 sequence=seq;calls.clear();u.mem_write(actor,bytes(0x800));u.mem_write(source,bytes(0x40))
 write32(actor+0x17c,source);u.mem_write(0x14b1b80,bytes([override]));u.mem_write(actor+0x5ea,bytes([flags5ea]))
 u.mem_write(source+0x24,bytes([flag24]));u.mem_write(source+0x2c,bytes([flag2c]));write32(source+0x28,mask);write32(0x1223ebc,selector&0xffffffff)
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.emu_start(0x617f10,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(override_byte=override,service_sequence=seq,source_flag24=flag24,source_flag2c=flag2c,actor_flags5ea=flags5ea,selector=selector,source_mask28=mask,service_calls=list(calls),result=bool(u.reg_read(UC_X86_REG_EAX)&255)))
simple=[]
for value in range(256):
 u.mem_write(actor+0x5ea,bytes([value]));write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.emu_start(0x647d00,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end
 simple.append(dict(actor_flags5ea=value,result=bool(u.reg_read(UC_X86_REG_EAX)&255)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x617f10',source_selector='0x6b2c30',simple_entry='0x647d00',native_addresses=len(visited),cases=cases,simple_cases=simple,runtime_adapters=['Global service virtual+B0 boundary supplies explicit noncanonical return bytes and records exact call order, including changed second return.'],limits=['Original617F10 gate and nested6B2C30 selector execute, including selector-1/-2 and x86 shift-count masking. Actor/source fields explicitly supplied.','Class names and flag meanings are not inferred. Original service+B0 producer, source flags/mask producers, other actor subclasses and live collector integration remain open.'])
(r/'data/4.20/grass_actor_visibility_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),simple_cases=len(simple),native_addresses=len(visited))))
