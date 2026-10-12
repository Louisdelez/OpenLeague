"""Execute original simple-emitter constructor; adapt heap allocation and stack cookie only."""
from pathlib import Path
import sys,struct,json,hashlib,datetime
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')")
exec(compile(source,'native setup','exec'))
object_address=heap+0x1000;allocation_cursor=heap+0x5000;calls=[];visited=set()
native_code_ranges=[(p.OPTIONAL_HEADER.ImageBase+s.VirtualAddress,p.OPTIONAL_HEADER.ImageBase+s.VirtualAddress+s.Misc_VirtualSize) for s in p.sections if s.Characteristics&0x20000000]
def hook(uc,a,size,user):
    global allocation_cursor
    visited.add(a)
    if a==0xc975f5:finish();return
    if a==0xc98528:
        pointer=read32(u.reg_read(UC_X86_REG_ESP)+4)
        assert pointer==0 or heap+0x5000<=pointer<allocation_cursor
        calls.append({'adapter':hex(a),'operation':'free','null':pointer==0});finish();return
    if a in [0xc9f39b,0x9933e0]:
        n=read32(u.reg_read(UC_X86_REG_ESP)+4);assert 0<n<4096
        assert allocation_cursor+n<heap+0xf000
        out=allocation_cursor;allocation_cursor+=(n+31)&~15
        u.mem_write(out,b'\xa5'*n);calls.append({'adapter':hex(a),'bytes':n});finish(eax=out);return
    # All constructor/vector initialization instructions execute natively.
    assert any(lo<=a<hi for lo,hi in native_code_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
offsets=[0x17c,0x158,0x15c,0x1d4,0x1d8,0x1dc]
cases=[]
for previous_bits in [0,0x3f400000,0xa5a5a5a5]:
    allocation_cursor=heap+0x5000
    u.mem_write(object_address,b'\0'*0x410) # Valid empty vector/string storage prerequisite.
    for offset in offsets:write32(object_address+offset,previous_bits)
    u.mem_write(object_address+0x150,bytes([previous_bits&255]))
    u.mem_write(object_address+0x160,bytes([previous_bits&255])*2)
    sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,object_address)
    u.emu_start(0x91c0c0,end,count=100000)
    assert u.reg_read(UC_X86_REG_EIP)==end
    state=bytes(u.mem_read(object_address,0x410))
    fields={hex(offset):struct.unpack_from('<I',state,offset)[0] for offset in offsets}
    flags={hex(offset):state[offset] for offset in [0x150,0x160,0x161]}
    assert flags=={'0x150':1,'0x160':0,'0x161':0}
    assert fields=={'0x17c':0,'0x158':0,'0x15c':0,'0x1d4':0x3f800000,'0x1d8':0x3f800000,'0x1dc':0}
    cases.append({'previous_bits':previous_bits,'fields_raw':fields,'flags_raw':flags})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'complete':False,'passed':True,'entry':'0x91c0c0','storage_precondition':'Empty vector/string storage; scalar fields seeded with three different prior values. Surrounding object constructor not executed.','original_instruction_addresses':len(visited-{0xc975f5,0xc98528,0xc9f39b,0x9933e0}),'allocation_adapters':calls,'cases':cases,'fields_raw':cases[0]['fields_raw'],'limits':['Original simple-emitter defaults initializer, vector reserve and memory-copy instructions executed; only heap allocation/free and stack-cookie calls adapted.','Valid empty storage provided explicitly; full surrounding object constructor and reader were not executed.','Field meanings tied to separately archived native reader offsets; no emitted-particle runtime, orientation or lifetime behavior claimed.']}
proof['flags_raw']=cases[0]['flags_raw']
(r/'data/4.20/simple_emitter_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(proof))
