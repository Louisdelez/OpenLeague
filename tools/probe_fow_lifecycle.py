from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
owner=terrain+0x2000;table=terrain+0x1000;manager=terrain+0x5000;entries=terrain+0x5100;handle=0x12340002
write32(0x2d628c0,table);write32(0x2d628c4,4)
def setup(mode):
 u.mem_write(obj,bytes(0x80));u.mem_write(owner,bytes(0x2000));u.mem_write(table,bytes(16));write32(obj,0x10a03d0);write32(owner,0x1090ea8)
 write32(owner+8,handle+0x10000 if mode=='handle_mismatch' else handle);write32(owner+0x18,8 if mode=='generation_mismatch' else 7)
 u.mem_write(owner+0x60,struct.pack('<3f',10.,99.,20.));write32(table+8,0 if mode=='empty_slot' else owner)
 write32(obj+0x24,0 if mode=='no_owner' else handle);write32(obj+0x34,0 if mode=='uncached' else owner);write32(obj+0x30,7);u.mem_write(obj+4,struct.pack('<2f',10.,20.))
def execute(entry):
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
eligibility=[]
for mode,flag_ad,flag_118 in itertools.product(['valid','no_owner','empty_slot','handle_mismatch','generation_mismatch','uncached'],[False,True],[False,True]):
 setup(mode);u.mem_write(owner+0xad,bytes([flag_ad]));u.mem_write(owner+0x118,bytes([flag_118]));u.reg_write(UC_X86_REG_ECX,obj)
 execute(0x6b0980);eligibility.append(dict(mode=mode,flag_ad=flag_ad,flag_118=flag_118,result=bool(u.reg_read(UC_X86_REG_EAX)&255)))
eligibility_addresses=len(visited);visited.clear();removal_calls=[]
def removal_boundary(uc,a,size,user):
 if a==0x6b1f90:
  assert u.reg_read(UC_X86_REG_ECX)==manager
  argument=read32(u.reg_read(UC_X86_REG_ESP)+4);assert argument==entries
  removal_calls.append(read32(argument));write32(manager+8,entries);finish(4)
u.hook_add(unicorn.UC_HOOK_CODE,removal_boundary)
lifetime=[]
for mode,initial,delta in itertools.product(['valid','no_owner','uncached'],[-1.,-0.,0.00000011920928955078125,0.01,0.2,1.,2.],[0.,0.01,0.2,1.,3.]):
 setup(mode);u.mem_write(obj+0x20,struct.pack('<f',initial));u.mem_write(manager,bytes(0x40));write32(manager+4,entries);write32(manager+8,entries+8);write32(entries,obj);write32(entries+4,0)
 before=len(removal_calls);u.mem_write(sp+4,struct.pack('<f',delta));u.reg_write(UC_X86_REG_ECX,manager);execute(0x6b2110)
 removed=read32(manager+8)==entries;assert len(removal_calls)-before==int(removed)
 lifetime.append(dict(mode=mode,initial_bits=struct.unpack('<I',struct.pack('<f',initial))[0],delta_bits=struct.unpack('<I',struct.pack('<f',delta))[0],result_bits=read32(obj+0x20),removed=removed,result_cached_owner=bool(read32(obj+0x34))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,eligibility_entry='0x6b0980',eligibility_native_addresses=eligibility_addresses,eligibility_adapters=[],eligibility=eligibility,lifetime_entry='0x6b2110',lifetime_native_addresses=len(visited-{0x6b1f90}),lifetime=lifetime,runtime_adapters=['6B1F90 removal boundary records selected source and erases the single supplied vector entry; original removal queue, allocator and destructors are not executed.'],limits=['Eligibility fields actor+AD and+118 are supplied raw boolean flags; their native producers and semantic labels remain unqualified. Uncached sources return eligible. Generation is not checked here.','Original lifetime manager calls original position update before testing zero sentinel and consuming elapsed time. Eligibility executes without adapters; lifetime deletion dispatch is adapted explicitly.','Zero lifetime remains persistent; negative finite lifetime removes for supplied nonnegative dt. Final source removal, counted visibility rollback, team/creation/activation and rendering remain open.'])
(r/'data/4.20/fow_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(eligibility_cases=len(eligibility),lifetime_cases=len(lifetime),eligibility_addresses=eligibility_addresses,lifetime_addresses=proof['lifetime_native_addresses'])))
