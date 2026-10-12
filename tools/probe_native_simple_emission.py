"""Execute original 4.20 Simple emission gate/count prefix without math adapters."""
from pathlib import Path
import struct,json,datetime,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')")
exec(compile(source,'native setup','exec'))
instance=heap+0x1000;definition=heap+0x2000;system=heap+0x3000;context=heap+0x4000;table=heap+0x5000
native_ranges=[(0x400000+s.VirtualAddress,0x400000+s.VirtualAddress+s.Misc_VirtualSize) for s in p.sections if s.Characteristics&0x20000000]
visited=set();result=None
def hook(uc,a,size,user):
    global result
    visited.add(a)
    if a==0x9420b9:
        result=read32(u.reg_read(UC_X86_REG_EBP)-0x60);u.emu_stop();return
    if a==0x9432ec:
        result=0;u.emu_stop();return
    assert any(lo<=a<hi for lo,hi in native_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def f(a,v):u.mem_write(a,struct.pack('<f',v))
cases=[]
def run(single,latch,rate,age,delay=0.,period=100.,window=100.,previous=10.,life=1.):
    global result
    for a,n in [(instance,0x200),(definition,0x410),(system,0x200),(context,0x200)]:u.mem_write(a,b'\0'*n)
    write32(instance,system);write32(instance+4,definition);write32(instance+0x140,context)
    f(instance+0x10,life);f(instance+0xd8,previous);u.mem_write(instance+0xd4,bytes([latch]))
    f(system+0xa8,10.);f(context+0xec,1.)
    write32(definition+0x17c,single);f(definition+0x164,delay);f(definition+0x170,period);f(definition+0x174,window)
    write32(definition+0x74,table);write32(definition+0x78,table+4);write32(definition+0x7c,table+4);f(table,rate)
    sp=stack+0x8000;write32(sp,end);f(sp+4,10.+age);f(sp+8,0.5)
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);result=None
    u.emu_start(0x941f00,end,count=100000)
    assert result is not None,'native instruction limit reached'
    cases.append(dict(single=single,latch=latch,rate=rate,age=age,delay=delay,period=period,window=window,previous=previous,life=life,count=result,stop=hex(u.reg_read(UC_X86_REG_EIP))))
for args in itertools.product([0,1],[0,1],[0.,1.,2.9,20.],[0.,0.1,0.5,1.]):run(*args)
for age in [0.125,0.25,0.5,0.75,1.,1.125,1.25,1.5]:
    for single,latch in itertools.product([0,1],[0,1]):run(single,latch,20.,age,delay=.25,period=1.,window=.5,life=2.)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,entry='0x941f00',passed=True,complete=False,original_instruction_addresses=len(visited),adapters=[],cases=cases,limits=['Only original emission gate and count prefix executed. Stop before particle creation or function exit epilogue.','Explicit valid runtime storage and constant curve table supplied; native scalar curve sampler and original fmod helper executed.','Latch mutation, particle lifetime, placement, orientation, random curves and owner destruction remain unqualified.'])
(r/'data/4.20/simple_emission_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'instructions':len(visited),'sample':cases[:8]}))
