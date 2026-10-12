"""Native caller prefix; stops before diagnostic991E60 or provider90AD00.
Neither boundary returns a fabricated result. Cleanup is a separately measured
explicit jump to native57DCAE after discarding only the unconsumed call args.
"""
from pathlib import Path
import sys, json, hashlib, itertools, traceback, struct
ROOT = Path(r'E:\OpenLeague')
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT/'tools/pythonlibs'))
exec(compile((ROOT/'tools/probe_replay_metadata.py').read_text(encoding='utf-8').split('\ncases=[]')[0], 'native metadata prerequisites', 'exec'))
OUT = Path(r'E:\mapslol3v3\loading_standard_ui_next')
DIAG = 0x36000000
assert all(DIAG+0x10000 <= lo or DIAG > hi for lo,hi,_ in u.mem_regions())
u.mem_map(DIAG, 0x10000)
RECIP, SERVICE, PACKET, COMMAND, STRING, TEXT = [DIAG+i for i in (0x100,0x1000,0x2000,0x2100,0x2200,0x2300)]
OVERRIDE = RECIP+0x1a8
phase = None
events, executed = [], set()
output_ptr = record_ptr = prefix_sp = stop = None
CHAIN = [0x57d650,0x5be170,0x72ad90,0x729c80,0x728410,0x729ec0,0x729730,0x738ac0,0x8f8cf0,0x72ae40,0x728500,0x564af0,0x564f30]
FORBIDDEN = [0x991e60,0x90ad00,0x57c590,0x98a7f0,0x815cf0,0x5ce3a0,0x98f2f0,0x9879d0,0x993ce0]
def string_value(p):
    length, cap = read32(p+16), read32(p+20)
    data = read32(p) if cap >= 16 else p
    assert length <= cap and cap < 0x10000
    return {'address':p, 'hex':bytes(u.mem_read(p,24)).hex(), 'length':length,
            'capacity':cap,'data':data,'text_hex':bytes(u.mem_read(data,length)).hex()}
def regs():
    return {n:u.reg_read(r) for n,r in [('eax',UC_X86_REG_EAX),('ebx',UC_X86_REG_EBX),('ecx',UC_X86_REG_ECX),('edx',UC_X86_REG_EDX),('esi',UC_X86_REG_ESI),('edi',UC_X86_REG_EDI),('esp',UC_X86_REG_ESP),('ebp',UC_X86_REG_EBP),('eip',UC_X86_REG_EIP)]}
def observe(uc, pc, size, user):
    global output_ptr, record_ptr, prefix_sp, stop, record_before
    if phase is None:return
    assert pc not in FORBIDDEN, ('unqualified boundary entered',hex(pc))
    executed.add(pc)
    if pc in CHAIN:
        e={'op':'call','method':pc,'this':u.reg_read(UC_X86_REG_ECX),'phase':phase}
        sp=u.reg_read(UC_X86_REG_ESP)
        if pc==0x72ad90:
            output_ptr=read32(sp+4);e.update(output=output_ptr,key=read32(sp+8))
        elif pc==0x72ae40:e['key']=read32(sp+4)
        elif pc==0x564af0:e['arguments']=[read32(sp+i) for i in (4,8,12)]
        events.append(e)
    if pc==0x57d6a6:
        record_ptr=u.reg_read(UC_X86_REG_EAX)
        record_before=bytes(u.mem_read(record_ptr,120))
    if pc==0x57d6fe:
        prefix_sp=u.reg_read(UC_X86_REG_ESP)
        events.append({'op':'prefix_entry','registers':regs(),'string':string_value(output_ptr)})
    if pc==0x57d730:
        events.append({'op':'extra_return','value':u.reg_read(UC_X86_REG_EAX)})
    if pc in (0x57d74c,0x57d775):
        sp=u.reg_read(UC_X86_REG_ESP)
        words=5 if pc==0x57d74c else 3
        stop={'address':pc,'before_call':0x991e60 if words==5 else 0x90ad00,
              'registers':regs(),'arguments':[read32(sp+i*4) for i in range(words)],
              'string':string_value(output_ptr)}
        events.append({'op':'explicit_stop',**stop})
        u.emu_stop()
    if pc in (0x57dcae,0x57dce6):events.append({'op':'cleanup_entry' if pc==0x57dcae else 'epilogue'})
def access(uc, typ, p, n, value, user):
    if phase is None:return
    ranges=[(RECIP+0x1a0,RECIP+0x1c0),(PACKET,PACKET+25),(0x2d787b8,0x2d787bc),(0x2d78f1c,0x2d78f20),(SERVICE,SERVICE+4),(0x10afed4,0x10afedc)]
    if output_ptr is not None:ranges.append((output_ptr,output_ptr+24))
    if record_ptr is not None:ranges.append((record_ptr,record_ptr+120))
    if any(p<hi and p+n>lo for lo,hi in ranges):
        events.append({'op':'read' if typ==unicorn.UC_MEM_READ else 'write','pc':u.reg_read(UC_X86_REG_EIP),
                       'pointer':p,'bytes':n,'value':int.from_bytes(u.mem_read(p,n),'little') if typ==unicorn.UC_MEM_READ else value,'phase':phase})
u.hook_add(unicorn.UC_HOOK_CODE, observe)
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE, access)
name_profiles=[('short_none',b'Anivia',b''),('short_short',b'Anivia',b'Ahri'),
               ('short_15',b'Anivia',b'X'*15),('short_16',b'Anivia',b'Y'*16),
               ('heap_none',b'Original champion name longer than fifteen bytes',b''),
               ('heap_short',b'Original champion name longer than fifteen bytes',b'Ashe'),
               ('heap_reuse',b'Original champion name longer than fifteen bytes',b'R'*20),
               ('heap_growth',b'Original champion name longer than fifteen bytes',b'G'*120)]
skin_profiles=[(0,0xffffffff),(17,0),(0x7fffffff,0x80000000),(0,17),
               (0x80000000,0xffffffff),(0x80000000,0),(0xffffffff,17),(0xffffffff,0x80000000)]
cases=[]
try:
    for case_index,(fill,(profile,name,override),(skin,skin_override)) in enumerate(itertools.product([0,165],name_profiles,skin_profiles)):
        poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear()
        write32(0x14bef40,0);write32(0x14bef58,0);write32(0x2d78f1c,0)
        u.mem_write(DIAG,bytes([fill])*0x10000)
        parent=call(0x9933e0,0,[68]);call(0x728e20,parent,[]);write32(0x2d78520,parent)
        assert call(0x728fd0,parent,[])&255==1
        nested=read32(parent+0x30);index=call(0x9933e0,0,[48]);call(0x8f8810,index,[])
        call(0x9019a0,nested+0x6c,[index]);index_control=read32(nested+0x70)
        metadata=read32(parent+0x34);metadata_control=read32(parent+0x38)
        identifier=[73,0xffffffff,0x80000000][case_index%3]
        add_object=case_index%3!=2
        low,high=(0xdeadbeef,0x80000000) if add_object else (0,0)
        if add_object:
            u.mem_write(COMMAND,b'\0');write32(COMMAND+4,identifier);write32(COMMAND+8,low);write32(COMMAND+12,high)
            assert call(0x72c780,0,[0,0,0,0,COMMAND])&255==1
        write32(STRING+16,0);write32(STRING+20,15);u.mem_write(STRING,b'\0')
        u.mem_write(TEXT,name+b'\0');call(0x564c20,STRING,[TEXT,len(name)])
        call(0x7285b0,metadata,[low,high,STRING,skin]);call(0x564900,STRING,[])
        write32(RECIP,0x1084ea4);u.reg_write(UC_X86_REG_ESI,RECIP);u.reg_write(UC_X86_REG_ESP,stack+0xe000)
        u.emu_start(0x57ce5c,0x57ce72,count=50000);assert u.reg_read(UC_X86_REG_EIP)==0x57ce72
        write32(OVERRIDE+16,0);write32(OVERRIDE+20,15);u.mem_write(OVERRIDE,b'\0')
        u.mem_write(TEXT,override+b'\0');call(0x564c20,OVERRIDE,[TEXT,len(override)])
        write32(RECIP+0x1a0,skin_override)
        write32(SERVICE,0x10afe8c);write32(0x2d787b8,SERVICE)
        prepared=capture()
        flags=[0,1,128,255][case_index%4]
        payload=bytearray((j*37+flags)&255 for j in range(25))
        payload[:4]=identifier.to_bytes(4,'little');payload[24]=flags;u.mem_write(PACKET,bytes(payload))
        events.clear();output_ptr=record_ptr=prefix_sp=stop=None;record_before=None
        before_counts=[read32(index_control+4),read32(metadata_control+4)]
        sp=stack+0xe000;u.mem_write(sp,struct.pack('<II',end,PACKET));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,RECIP)
        phase='prefix'
        try:u.emu_start(0x57d650,end,count=500000)
        finally:phase=None
        assert stop is not None and output_ptr is not None and record_ptr is not None
        negative=bool(skin&0x80000000)
        assert stop['address']==(0x57d74c if negative else 0x57d775)
        assert bytes.fromhex(stop['string']['text_hex'])==(override or name)
        expected=bytearray(record_before);expected[:25]=payload
        if flags&1:expected[16:20]=bytes(4)
        assert bytes(u.mem_read(record_ptr,120))==expected
        assert bytes(u.mem_read(PACKET,25))==payload
        assert [read32(index_control+4),read32(metadata_control+4)]==before_counts==[1,1]
        calls=[e['method'] for e in events if e['op']=='call']
        assert all(target in calls for target in [0x57d650,0x5be170,0x72ad90,0x728410,0x729ec0,0x729730,0x738ac0,0x8f8cf0,0x72ae40,0x728500])
        assert len([e for e in events if e['op']=='read' and e['pointer']==0x2d787b8])==1
        assert next(e for e in events if e['op']=='extra_return')['value']==skin
        reads=[e['pointer'] for e in events if e['op']=='read']
        if negative:
            assert stop['arguments']==[0x10899d8,0x1085b2d,0,0x1085b2d,0x1085b2d]
            assert 0x2d78f1c not in reads and RECIP+0x1a0 not in reads
        else:
            assert stop['arguments'][:2]==[output_ptr,skin if skin_override==0xffffffff else skin_override]
            assert stop['registers']['ecx']==0
            assert reads.index(0x2d78f1c)<reads.index(RECIP+0x1a0)
        assert stop['registers']['esp']==prefix_sp-(20 if negative else 12)
        at_boundary=capture()
        # Do not supply a diagnostic/provider return. Explicitly abandon this
        # continuation and measure its owned temporary retirement separately.
        native_string_before=bytes(u.mem_read(output_ptr,24))
        events.append({'op':'explicit_cleanup_reentry','from_stop':stop['address'],'entry':0x57dcae,
                       'discarded_argument_bytes':20 if negative else 12,'restored_esp':prefix_sp})
        u.reg_write(UC_X86_REG_ESP,prefix_sp);phase='cleanup'
        try:u.emu_start(0x57dcae,end,count=500000)
        finally:phase=None
        assert u.reg_read(UC_X86_REG_EIP)==end
        assert bytes(u.mem_read(output_ptr,24))==native_string_before
        assert freed==([stop['string']['data']] if stop['string']['capacity']>=16 else [])
        after_cleanup=capture()
        assert bytes(u.mem_read(record_ptr,120))==expected
        steps=list(events)
        call(0x564900,OVERRIDE,[]);call(0x57d1e0,RECIP+0x1c,[])
        write32(0x2d787b8,0);call(0x728ea0,parent,[1]);write32(0x2d78520,0)
        shutdown=capture();assert not live,live
        cases.append({'fill':fill,'profile':profile,'identifier':identifier,'object_exists':add_object,
                      'metadata_key':[low,high],'name_hex':name.hex(),'override_hex':override.hex(),
                      'skin':skin,'skin_override':skin_override,'flags':flags,'payload_hex':payload.hex(),
                      'parent':parent,'metadata':metadata,'index':index,'recipient':RECIP,'service_diagnostic':SERVICE,
                      'prepared':prepared,'prefix_stop':stop,'state_at_boundary':at_boundary,
                      'cleanup':after_cleanup,'shutdown':shutdown,'events':steps,
                      'record_before_hex':record_before.hex(),'record_after_hex':expected.hex(),
                      'reference_counts':before_counts})
    proof={'passed':True,'complete':False,'native_sha256':digest,'native_provider_results_simulated':False,
           'cases':cases,'executed_instruction_addresses':sorted(executed),'forbidden_entries':FORBIDDEN,
           'limits':['128 composed original caller entries stop before90AD00 or before991E60. Neither unqualified body executes or receives a substituted return. No successful loading UI continuation is claimed.',
                     'Actual57D650,5BE170,72AD90,728410,72AE40,728500,729EC0,729730,738AC0,8F8CF0 and564AF0/564F30 run from the source PE. Missing identifiers resolve through the real zero-key metadata row.',
                     'Parent/metadata/index/control and record tree producers execute. Recipient uses actual57CE5C..57CE72 tree constructor snippet plus explicit diagnostic fields and real564C20 override strings; full recipient/service factories and normal global publication are not executed.',
                     'Negative skins stop before diagnostic991E60 and before reading package global or skin override, even when override is valid. Diagnostic formatting/consumer remains unqualified.',
                     'Cleanup is a separate explicit native57DCAE reentry after restoring the pre-argument ESP. This proves temporary retirement in isolation, not native exception unwinding or a normal return from either stopped callee.',
                     'Existing single-thread OS locks, engine allocation and memory primitives are supplied. The package global is its real initial zero and is never dereferenced. No renderer, UI assets, resource provider, QPC or network runs.',
                     'Source/destination equality and overlapping string assignment are outside this composed caller layout. OOM, allocator callback mutation and exception rollback remain unqualified.']}
except Exception as problem:
    traceback.print_exc()
    proof={'passed':False,'complete':False,'native_sha256':digest,'error':repr(problem),'pc':hex(u.reg_read(UC_X86_REG_EIP)),
           'cases_completed':len(cases),'cases':cases,'last_events':events[-60:]}
(OUT/'prefix_native_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
summary={'passed':proof['passed'],'lifetimes':len(cases),'stops_before_resource':sum(c['prefix_stop']['address']==0x57d775 for c in cases),
         'stops_before_diagnostic':sum(c['prefix_stop']['address']==0x57d74c for c in cases),
         'native_provider_results_simulated':False,'events':sum(len(c['events']) for c in cases)}
(OUT/'prefix_native_result.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
print(json.dumps(summary))
if not proof['passed']:sys.exit(1)
