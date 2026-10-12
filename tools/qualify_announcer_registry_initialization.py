from pathlib import Path
import json,struct,itertools
root=Path('E:/OpenLeague');bootstrap=root/'tools/qualify_native_audio_legacy_paths.py';__file__=str(bootstrap)
exec(compile(bootstrap.read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)',''),__file__,'exec'))
arena=0x34000000;u.mem_map(arena,0x10000);cursor=arena
allocations=[];registrations=[];fail_top=False;poison=0
def capture(uc,address,size,user):
    global cursor
    sp=u.reg_read(UC_X86_REG_ESP)
    if address==0x9933e0:
        count=read32(sp+4);pointer=0 if fail_top and count==36 else cursor
        if pointer:u.mem_write(pointer,bytes([poison])*count);cursor+=(count+31)&~15
        allocations.append({'bytes':count,'pointer':pointer});finish(eax=pointer)
    elif address==0xc97e4c:
        registrations.append(read32(sp+4));finish()
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[]
for cached,flag,shutdown,fail_top,poison in itertools.product([False,True],[0,1,2,255],[0,1,2,255],[False,True],[0,165]):
    cursor=arena;write32(0x2d789c0,heap+0x8000 if cached else 0);u.mem_write(0x2d78974,bytes([flag]));u.mem_write(0x2d78969,bytes([shutdown]));steps=[]
    for invocation in range(2):
        allocations.clear();registrations.clear();sp=stack+0xe000;u.mem_write(sp-0x100,bytes([poison])*0x100);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp)
        u.emu_start(0x661410,end,count=100000)
        assert u.reg_read(UC_X86_REG_EIP)==end
        manager=read32(0x2d789c0);words=[]
        if manager and not cached:
            words=[[manager+i,read32(manager+i)] for i in range(4,36,4)]
            sentinel=read32(manager+4);words += [[sentinel+i,read32(sentinel+i)] for i in range(0,16,4)]
            begin,finish_pointer,capacity=read32(manager+12),read32(manager+16),read32(manager+20)
            assert finish_pointer-begin==64 and capacity-begin==64
            words += [[i,read32(i)] for i in range(begin,finish_pointer,4)]
            assert read32(manager+8)==0 and read32(manager+24)==7 and read32(manager+28)==8 and read32(manager+32)==0x40800000
            assert all(read32(i)==sentinel for i in range(begin,finish_pointer,4))
        lookups=[]
        if words:
            for key in [0,42,999,0xffffffff]:
                result=heap+0x9000;key_pointer=heap+0x9010;write32(key_pointer,key)
                sp=stack+0xe000;u.mem_write(sp,struct.pack('<III',end,result,key_pointer));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
                u.emu_start(0x5c6830,end,count=10000)
                assert u.reg_read(UC_X86_REG_EIP)==end and read32(result)==sentinel
                lookups.append({'key':key,'node':read32(result)})
        steps.append({'manager':manager,'initialization_flag':u.mem_read(0x2d78974,1)[0],'shutdown_flag':u.mem_read(0x2d78969,1)[0],'allocations':list(allocations),'atexit_registrations':list(registrations),'words':words,'empty_lookups':lookups})
    cases.append({'cached':cached,'flag':flag,'shutdown':shutdown,'fail_top':fail_top,'poison':poison,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual661410,664E50,5C7240 and bucket vector constructor executed for128 repeated initialization sequences256calls. Allocation and atexit registration supplied; initialized manager36bytes,16byte sentinel and64byte bucket storage observed.', 'Only top-level null allocation path qualified. Nested allocation exceptions, actual destructor, concurrency and live registry mutation remain open. Uninitialized/padding bytes are recorded without invented semantic meaning.']}
(root/'data/4.20/audio_announcer_registry_initialization_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_sequences':len(cases),'native_calls':sum(len(c['steps']) for c in cases),'passed':True}))
