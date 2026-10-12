"""Fresh native90AD00 attempt using the confined real-filesystem bridge."""
from pathlib import Path
import sys,uuid,json,hashlib,collections
sys.dont_write_bytecode=True
from isolated_io import Bridge,Rejected
OUT=Path(__file__).resolve().parent
FROZEN=Path('E:/mapslol3v3/loading_resource_provider_next/probe_provider.py')
# Read-only prerequisite machine setup; the frozen main/body does not execute.
prelude=FROZEN.read_text().split("\nproof={'source'")[0]
exec(compile(prelude,str(FROZEN)+'::prerequisites','exec'))
bridge=Bridge(OUT/('native_root_'+uuid.uuid4().hex[:10]))
def stop_before_uninitialized_crt(uc,pc,size,user):
    global stop
    if pc==0xcabda8:
        sp=u.reg_read(UC_X86_REG_ESP)
        stop={'kind':'uninitialized_crt_dispatch','address':pc,'return_pc':read32(sp),
            'required_native_initializers':['C9A0B9/CABDE8','CA92CB','CB0378','CAFF53'],
            'detail':'Stop before indirect dispatch through uninitialized encoded CRT pointer; no formatting/INI result supplied.'}
        u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_before_uninitialized_crt)
def api_import(pc):
    global stop
    item=imports[pc];name=item['name'];sp=u.reg_read(UC_X86_REG_ESP)
    arg=lambda i:read32(sp+4*i)
    try:
        if name=='GetCurrentDirectoryA':
            capacity,out=arg(1),arg(2);value=str(bridge.cwd).encode('ascii')
            if capacity>len(value):u.mem_write(out,value+b'\0');result=len(value)
            else:result=len(value)+1
            bridge.events.append({'api':name,'declared_virtual_cwd':str(bridge.cwd),'result':result})
            finish(result,8);return
        if name=='GetFileAttributesA':finish(bridge.attributes(cstr(arg(1))),4);return
        if name=='CreateDirectoryA':
            if arg(2):raise Rejected('non-null SECURITY_ATTRIBUTES unsupported')
            finish(bridge.mkdir(cstr(arg(1))),8);return
        if name=='FindFirstFileA':
            label,data=bridge.find_first(cstr(arg(1)))
            if data:u.mem_write(arg(2),data)
            finish(label,8);return
        if name=='FindNextFileA':
            ok,data=bridge.find_next(arg(1))
            if data:u.mem_write(arg(2),data)
            finish(ok,8);return
        if name=='FindClose':finish(bridge.find_close(arg(1)),4);return
        if name=='GetLastError':finish(bridge.last_error);return
        if name=='CreateFileA':
            if arg(4) or arg(7):raise Rejected('SECURITY_ATTRIBUTES/template file unsupported')
            finish(bridge.open(cstr(arg(1)),arg(2),arg(3),arg(5),arg(6)),28);return
        if name=='ReadFile':
            if arg(5) or not arg(4):raise Rejected('overlapped/null out count unsupported')
            ok,data=bridge.read(arg(1),arg(3))
            if data:u.mem_write(arg(2),data)
            write32(arg(4),len(data));finish(int(ok),20);return
        if name=='WriteFile':
            if arg(5) or not arg(4) or arg(3)>0x100000:raise Rejected('overlapped/null/big write unsupported')
            ok,n=bridge.write(arg(1),bytes(u.mem_read(arg(2),arg(3))));write32(arg(4),n);finish(int(ok),20);return
        if name=='CloseHandle':finish(bridge.close(arg(1)),4);return
    except Exception as error:
        stop={'kind':'io_boundary_failure','import':item,'error':repr(error),'args':[arg(i) for i in range(1,8)]};u.emu_stop();return
    stop={'kind':'unimplemented_import','import':item,'args':[arg(i) for i in range(1,8)]};u.emu_stop()

result={'passed':False,'complete':False,'source':str(EXE),'source_sha256':digest,
    'io_profile':'declared scratch virtual CWD; source read mapping; initially empty isolated Config',
    'virtual_root':str(bridge.root),'virtual_cwd':str(bridge.cwd),'phases':[]}
try:
    write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
    phase='context_default_fragment';context=allocate(148);frame=STACK+0x10000;sp=STACK+0xe000
    u.mem_write(frame-0x140,bytes(0x140));write32(0x2d78f20,0)
    for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESI,context),(UC_X86_REG_EDI,0),(UC_X86_REG_EBX,0)]:u.reg_write(reg,value)
    u.emu_start(0x906487,0x9065d8,count=2000000)
    assert u.reg_read(UC_X86_REG_EIP)==0x9065d8 and read32(0x2d78f20)==context
    result['phases'].append({'name':phase,'completed':True})
    phase='manager';write32(0x2d78f1c,0)
    for initial in [0x531a50,0x531a90,0x531ad0,0x531b10]:call(initial)
    call(0x90b7c0);manager=read32(0x2d78f1c);u.reg_write(UC_X86_REG_EAX,manager);u.emu_start(0x592e49,0x592e6a,count=1000)
    result['phases'].append({'name':phase,'completed':True})
    phase='input';query=H+0x100;make_string(query,b'Ahri')
    phase='provider_miss';stop=None;call(0x90ad00,manager,[query,0,0])
    result['phases'].append({'name':phase,'completed':True});result['passed']=True
except Exception as error:
    result.update(error=repr(error),phase=phase,pc=hex(u.reg_read(UC_X86_REG_EIP)),trail=list(trail))
finally:
    result.update(stop=stop,allocations=allocations,frees=frees,live_snapshot=snap(),events=events,
        shutdown_callbacks=shutdown_callbacks,executed_instruction_addresses=sorted(visited),
        primitive_hooks=sorted(PRIMITIVES|{0xc97e4c,0xca1d00}),io_events=list(bridge.events),
        shadow_roots=sorted(bridge.shadow_roots),open_handles_at_stop=len(bridge.handles)+len(bridge.finds))
    bridge.cleanup();result['open_host_handles_after_cleanup']=len(bridge.handles)+len(bridge.finds)
    result['limits']=['Failed/stopped native calls are not completed providers. Emulated allocations at the boundary have not undergone native teardown.',
        'Host handle cleanup is separate from native lifecycle. Native INI/provider callbacks remain real or an explicit stop.',
        'Scratch Config is an explicit empty profile; existing D: Config is preserved. Full startup and archives not qualified.',
        'Confinement assumes no concurrent external mutation of the private filesystem tree; hostile cross-process rename/link races are outside this probe.']
    (OUT/'native_io_oracle.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'phase':phase,'stop':stop,'error':result.get('error'),
        'instructions':len(visited),'io':dict(collections.Counter(e['api'] for e in bridge.events))}))
