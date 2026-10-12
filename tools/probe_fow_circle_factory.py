from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0],'native prerequisites','exec'))
owner=heap+0x15000;manager=heap+0x16000;entries=heap+0x17000;output=heap+0x18000;table=heap+0x14000;handle=0x12340002
write32(0x2d628c0,table);write32(0x2d628c4,4);u.mem_write(0x2d77b20,bytes([1]));write32(0x14bef58,0);write32(0x14bef40,0)
allocation_cursor=heap+0x19000;allocations=[]
def factory_boundary(uc,a,size,user):
 global allocation_cursor
 if a in [0xc9f39b,0x9933e0]:
  amount=read32(u.reg_read(UC_X86_REG_ESP)+4);assert 0<amount<1024
  pointer=allocation_cursor;allocation_cursor+=(amount+31)&~15;assert allocation_cursor<heap+0x1f000
  u.mem_write(pointer,bytes([0xcc])*amount);allocations.append(dict(address=hex(a),bytes=amount));finish(eax=pointer)
 elif a==0xc975f5:finish()
u.hook_add(unicorn.UC_HOOK_CODE,factory_boundary)
cases=[]
for tag,lifetime,has_owner,radius in itertools.product([100,200],[0.,0.2,2.],[False,True],[200.,1350.]):
 allocation_cursor=heap+0x19000;before=len(allocations);u.mem_write(owner,bytes(0x1000));write32(owner+8,handle);write32(table+8,owner)
 u.mem_write(manager,bytes(0x40));u.mem_write(entries,bytes(16));u.mem_write(output,bytes(8));write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+16)
 args=struct.pack('<5IfI5f',output,0,55,66,tag,radius,owner if has_owner else 0,128.,64.,lifetime,7684.,6934.)
 write32(sp,end);u.mem_write(sp+4,args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x6b1b20,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==output
 obj=read32(output);control=read32(output+4)
 assert read32(obj)==0x10a03d0 and read32(manager+8)==entries+8 and read32(entries)==obj and read32(entries+4)==control
 cases.append(dict(owner_tag=tag,lifetime=lifetime,has_owner=has_owner,radius=radius,source_handle=read32(obj+0x24),source_tag=read32(obj+0x30),source_vtable=hex(read32(obj)),strong_count=read32(control+4),weak_count=read32(control+8),manager_source_count=(read32(manager+8)-read32(manager+4))//8,applied=bool(u.mem_read(obj+0x44,1)[0]),generation_dirty=bool(u.mem_read(obj+0x45,1)[0]),allocations=allocations[before:]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b1b20',base_constructor='0x6b0790',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc975f5}),runtime_adapters=['C9F39B/9933E0 allocation boundaries return preallocated storage; stack cookie boundary C975F5 adapted if visited.'],cases=cases,limits=['Complete original circle factory, base constructor, shared control and manager vector append execute; allocator boundaries adapted and manager capacity supplied.','Weak-provider parameter is null. Team/tag and opaque identity producers, actor/provider construction and real creation callers remain unqualified.','Retains manager ownership and returned weak handle; original removal queue, final destruction, count scheduling and live GPU binding remain open.'])
(r/'data/4.20/fow_circle_factory_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],first=cases[0])))
