from pathlib import Path
import json,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_grass_actor_visibility.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native gate prerequisites','exec'))
related=terrain+0x8000;holder=terrain+0xa800;control=terrain+0xb000;global_obj=terrain+0xc000;global_table=terrain+0xd000;id_pointer=terrain+0xe000;id_api=0xc9f3a4
id_calls=0
def id_hook(uc,a,size,user):
 global id_calls
 if a==id_api:
  assert u.reg_read(UC_X86_REG_ECX)==global_obj+0x124;id_calls+=1
  s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,id_pointer);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
u.hook_add(unicorn.UC_HOOK_CODE,id_hook)
def execute(entry):
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 return bool(u.reg_read(UC_X86_REG_EAX)&255)
def setup(mode):
 u.mem_write(actor,bytes(0x2600));u.mem_write(related,bytes(0x800));u.mem_write(control,bytes(16))
 write32(control+4,0 if mode=='expired' else 10);write32(control+8,10)
 write32(actor+0x22a0,0 if mode=='empty' else holder);write32(actor+0x22a4,0 if mode=='empty' else control)
 write32(holder,0 if mode=='null_pointee' else related);write32(related+0x1c,0 if mode=='wrong_flags' else 0x400)
 write32(actor+0x17c,source);write32(related+0x17c,source+0x100)
 write32(0x1223ebc,0);u.mem_write(0x14b1b80,b'\0')
source_cases=[]
for mode in ['empty','expired','null_pointee','wrong_flags','valid']:
 setup(mode);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.emu_start(0x62df30,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read32(control+4)==(0 if mode=='expired' else 10) and read32(control+8)==10
 source_cases.append(dict(mode=mode,result_present=u.reg_read(UC_X86_REG_EAX)==related,refcounts=[read32(control+4),read32(control+8)]))
id_cases=[]
for global_present,actor_id,target_id,flags2314,flags5ea,override in itertools.product([False,True],[0,17],[17,99],[0,4],[0,1],[0,128]):
 setup('valid');u.mem_write(source,bytes(0x40));u.mem_write(source+0x24,b'\x80')
 write32(0x2d77f48,global_obj if global_present else 0);write32(global_obj+0x124,global_table);write32(global_table+0x10,id_api);write32(id_pointer,target_id)
 write32(actor+0x23a5,actor_id);write32(actor+0x2314,flags2314);u.mem_write(actor+0x5ea,bytes([flags5ea]));u.mem_write(0x14b1b80,bytes([override]))
 sequence=[0];calls.clear();id_calls=0;result=execute(0x644e40)
 id_cases.append(dict(global_present=global_present,actor_id=actor_id,target_id=target_id,flags2314=flags2314,actor_flags5ea=flags5ea,override_byte=override,result=result,id_calls=id_calls,service_calls=list(calls)))
linked_cases=[]
for mode,seq,related_flags,primary_flags,selector,mask in itertools.product(['empty','expired','null_pointee','wrong_flags','valid'],[[0],[128],[128,0,128,0]],[(0,0),(128,0),(0,128),(128,128)],[(0,0),(128,0),(0,128),(128,128)],[-2,-1,0],[0,1]):
 setup(mode);u.mem_write(source,bytes(0x140));write32(0x1223ebc,selector&0xffffffff)
 for address,values in [(source,primary_flags),(source+0x100,related_flags)]:
  u.mem_write(address+0x24,bytes([values[0]]));u.mem_write(address+0x2c,bytes([values[1]]));write32(address+0x28,mask)
 sequence=seq;calls.clear();result=execute(0x62dc80)
 assert read32(control+4)==(0 if mode=='expired' else 10) and read32(control+8)==10
 linked_cases.append(dict(mode=mode,service_sequence=seq,related_flags=list(related_flags),primary_flags=list(primary_flags),selector=selector,mask28=mask,service_calls=list(calls),result=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),source_cases=source_cases,id_cases=id_cases,linked_cases=linked_cases,runtime_adapters=['Global service+B0 raw byte sequence and identifier virtual+10 pointer supplied; other methods execute original instructions.'],limits=['Original62DF30 and5BD6F0/5EC2A0 acquisition/drop execute; retained references avoid final destructor paths. Weak storage and actor fields supplied.','Original644E40 and62DC80 plus nested617F10/6B2C30 execute. Global service/ID and field producers, AABB/camera and live collector/render integration remain open.'])
(r/'data/4.20/grass_actor_subclasses_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(source_cases=len(source_cases),id_cases=len(id_cases),linked_cases=len(linked_cases),native_addresses=len(visited))))
