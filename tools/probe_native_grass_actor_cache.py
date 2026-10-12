from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
actor=terrain+0x2000;motion=terrain+0x8000
assert read32(0x1094490)==0x5fffd0
query_calls=[];response=0
def boundary(uc,a,size,user):
    if a==0x8f3390:
        assert u.reg_read(UC_X86_REG_ECX)==terrain
        s=u.reg_read(UC_X86_REG_ESP)
        query_calls.append(list(struct.unpack('<3I',u.mem_read(s+4,12))))
        u.reg_write(UC_X86_REG_EAX,0xaabbcc00|response)
        u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+16)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
positions=[[0.,7.,0.],[0.000005,7.,0.],[0.00001,7.,0.],[0.00002,7.,0.],[0.,999.,0.],[0.,7.,float('nan')]]
for override,cached_radius,position,response in itertools.product([0.,-1.,2.,float('nan'),float('inf')],[2.,2.000005,2.00002,float('nan'),float('inf')],positions,[0,0x7f]):
    u.mem_write(actor,bytes(0x2100));u.mem_write(motion,bytes(0x338))
    write32(actor+0x18b8,motion);write32(motion+0x70,0x1094490)
    u.mem_write(motion+0x2aa,struct.pack('<3f',*position))
    f(actor+0x20b8,override);f(actor+0x37c,2.);f(actor+0x20c8,cached_radius)
    f(actor+0x20c0,0.);f(actor+0x20c4,0.);u.mem_write(actor+0x20cc,b'\x80')
    initial=list(struct.unpack('<3I',u.mem_read(actor+0x20c0,12)))
    query_calls.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
    u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
    u.emu_start(0x6197b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
    cases.append(dict(override_bits=struct.unpack('<I',struct.pack('<f',override))[0],fallback_bits=0x40000000,position_bits=list(struct.unpack('<3I',struct.pack('<3f',*position))),initial_cache_bits=initial,initial_result=128,query_response=response,query_calls=list(query_calls),final_cache_bits=list(struct.unpack('<3I',u.mem_read(actor+0x20c0,12))),result=u.reg_read(UC_X86_REG_EAX)&255))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6197b0',position_getter='0x5fffd0',epsilon_bits=read32(0x11389ac),cases=cases,native_addresses=len(visited),runtime_adapters=['Terrain query8F3390 boundary records original X/Z/radius argument bits and supplies arbitrary byte result; terrain predicate itself not qualified.'],limits=['Actual cache method and original motion position getter execute; actor/provider fields explicitly supplied.','Actor classes, radius and position producers, terrain query semantics and live grass integration remain open.'])
(r/'data/4.20/grass_actor_cache_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),epsilon_bits=proof['epsilon_bits'])))
