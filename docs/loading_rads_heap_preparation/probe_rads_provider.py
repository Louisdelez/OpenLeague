"""Fresh native90AD00 attempt using the confined real-filesystem bridge."""
from pathlib import Path
import sys,uuid,json,hashlib,collections,argparse
sys.dont_write_bytecode=True
from isolated_io import Bridge,Rejected
from crt_os import CrtOs
from diagnostic_pipe_open import DiagnosticPipeOpen,PATH as DIAGNOSTIC_PIPE
from pe_x86_loader import Image, MappedModule
from callback_batches import drain_one_batch
from process_profile import ProcessProfile
from sync_os import SyncOs
from native_slist import NativeSList
from verify_inputs import verify
verified_inputs=verify()
OUT=Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--environment',choices=('empty','controlled'),default='empty')
environment_variant=parser.parse_args().environment
environment_entries=() if environment_variant=='empty' else (('OL_PROFILE','resource_probe'),('OL_VALUE','caf\u00e9'),('OL_EMPTY',''))
FROZEN=Path('E:/mapslol3v3/loading_resource_provider_next/probe_provider.py')
# Read-only prerequisite machine setup; the frozen main/body does not execute.
prelude=FROZEN.read_text().split("\nproof={'source'")[0]
prelude=prelude.replace("if pc==0xc98528:release(read32(sp+4));finish();return","if pc==0xc98528:\n        crt.release_primitive(read32(sp+4))\n        finish();return")
prelude=prelude.replace("if pc==0x8b0630:","if False: # former audit-only INI entry stop; execute genuine body now")
prelude=prelude.replace("assert BASE<=pc<BASE+len(image),('unexpected external execution',hex(pc),phase)","assert_source_instruction(pc,size)")
prelude=prelude.replace("assert bytes(u.mem_read(pc,size))==read(pc,size),('source modified',hex(pc))", "# Both PE images are validated by assert_source_instruction above.")
exec(compile(prelude,str(FROZEN)+'::prerequisites','exec'))
rads_image=Image();rads=MappedModule(rads_image);pending_attach=False
native_slist=NativeSList()

def assert_source_instruction(pc,size):
    if BASE<=pc<BASE+len(image):expected=read(pc,size)
    elif rads_image.base<=pc<rads_image.base+rads_image.size:expected=rads_image.instruction_bytes(pc,size)
    elif native_slist.contains(pc,size):expected=native_slist.instruction_bytes(pc,size)
    else:raise AssertionError(('unexpected external execution',hex(pc),phase))
    assert bytes(u.mem_read(pc,size))==expected,('source modified',hex(pc))
bridge=Bridge(OUT/('native_root_'+uuid.uuid4().hex[:10]))
virtual_executable=bridge.cwd/EXE.name
assert bridge.resolve(str(virtual_executable))[0].resolve()==EXE.resolve()
process_profile=ProcessProfile(u,virtual_executable,environment=environment_entries)
crt=CrtOs(globals(),bridge)
from native_strlen_tail import NativeStrlenTail
native_strlen_tail=NativeStrlenTail(crt.mirrors)
sync=SyncOs(globals(),bridge)
interrupted_callbacks=[]
diagnostic_pipe=DiagnosticPipeOpen()
u.mem_map(0x3e000000,0x10000)
crt_phases=[]
ini_observations=[]
environment_native_observations=[]
environment_native_return=None
dll_crt_returns=[]
dll_initializer_calls=[]
DLL_CRT_RETURNS={0x100f2b03:'low_io100FB602',0x100f2b13:'argv100FF3FC',0x100f2b1c:'environment_table100FF62B',0x100f2b27:'initializers100F40E1'}
def observe_ini(uc,pc,size,user):
    global environment_native_return
    if pc in DLL_CRT_RETURNS:dll_crt_returns.append({'stage':DLL_CRT_RETURNS[pc],'return_pc':pc,'eax':u.reg_read(UC_X86_REG_EAX)})
    if pc in (0x100f41fc,0x100f41d8):
        dll_initializer_calls.append({'kind':'C' if pc==0x100f41fc else 'C++','call_pc':pc,
            'slot':u.reg_read(UC_X86_REG_ESI),'target':u.reg_read(UC_X86_REG_ECX if pc==0x100f41fc else UC_X86_REG_EAX),
            'return_pc':pc+2,'stack_before':u.reg_read(UC_X86_REG_ESP),'returned':False})
    if pc in (0x100f41fe,0x100f41da):
        pending=next((item for item in reversed(dll_initializer_calls) if not item['returned'] and item['return_pc']==pc and item['stack_before']==u.reg_read(UC_X86_REG_ESP)),None)
        if pending is not None:pending.update(returned=True,eax_after=u.reg_read(UC_X86_REG_EAX))
    if pc==0x100ff7ae:
        sp=u.reg_read(UC_X86_REG_ESP);environment_native_return=read32(sp)
        environment_native_observations.append({'stage':'converter_entry','pc':pc,'return_pc':environment_native_return,'crt_event_start':len(crt.events)})
    if environment_native_return is not None and pc==environment_native_return:
        pointer=u.reg_read(UC_X86_REG_EAX)
        start=environment_native_observations[-1]['crt_event_start']
        conversions=[e for e in crt.events[start:] if e['api']=='WideCharToMultiByte']
        n=conversions[-1]['result'] if conversions else 0
        environment_native_observations.append({'stage':'converter_return','pointer':pointer,'converted_bytes':n,
            'hex':bytes(u.mem_read(pointer,n)).hex() if pointer and n else None,'conversions':conversions})
        environment_native_return=None
    if pc==0x8b0630:
        sp=u.reg_read(UC_X86_REG_ESP)
        ini_observations.append({'stage':'entry','section':cstr(u.reg_read(UC_X86_REG_ECX)),
            'key':cstr(u.reg_read(UC_X86_REG_EDX)),'default':cstr(read32(sp+4)),
            'out':read32(sp+8),'count':read32(sp+12),'path':cstr(read32(sp+16)),
            'argument5':read32(sp+20),'return_pc':read32(sp)})
    if pc==0x90b6dc:
        prior=next(v for v in reversed(ini_observations) if v['stage']=='entry')
        ini_observations.append({'stage':'return','value':cstr(prior['out']),'eax':u.reg_read(UC_X86_REG_EAX)})
u.hook_add(unicorn.UC_HOOK_CODE,observe_ini)
def api_import(pc):
    global stop,pending_attach
    item=imports[pc];name=item['name'];sp=u.reg_read(UC_X86_REG_ESP)
    arg=lambda i:read32(sp+4*i)
    try:
        if name=='GetCommandLineA':
            pointer=process_profile.get_command_line_a()
            bridge.events.append({'api':name,'profile':'explicit virtual game executable only','pointer':pointer})
            finish(pointer);return
        if name=='GetEnvironmentStringsW':finish(process_profile.get_environment_strings_w());return
        if name=='FreeEnvironmentStringsW':finish(process_profile.free_environment_strings_w(arg(1)),4);return
        if name=='InitializeSListHead':native_slist.dispatch(u,arg(1));return
        if name=='LoadLibraryA':
            path=crt.strz(arg(1));physical,_,_=bridge.resolve(path)
            if physical.resolve()!=rads_image.path.resolve():raise Rejected('unqualified native DLL path')
            if rads.state=='attached':finish(rads.module_handle(),4);return
            if rads.state!='prepared':raise Rejected('recursive/partial RADS load is not qualified')
            rads.map_into(u);imports.update(rads.bindings);pending_attach=True
            u.emu_stop();return
        if name=='GetProcAddress' and arg(1)==rads_image.base:
            symbol=crt.strz(arg(2));target=rads.get_export(arg(1),symbol)
            rads.events.append({'operation':'GetProcAddress','module':arg(1),'name':symbol,'target':target})
            finish(target,8);return
        if crt.dispatch(name):return
        if sync.dispatch(name):return
        if name=='GetFileAttributesExW':
            ok,data=bridge.attributes_ex(crt.strz(arg(1),True),arg(2))
            if ok:u.mem_write(arg(3),data)
            finish(ok,12);return
        if name=='GetModuleFileNameA':
            if arg(1) not in (0,BASE):raise Rejected('unknown native executable module')
            virtual=bridge.cwd/EXE.name;physical,_,_=bridge.resolve(str(virtual))
            if physical.resolve()!=EXE.resolve():raise Rejected('module mapping differs from pinned PE')
            value=str(virtual).encode('ascii')
            if arg(3)<=len(value):raise Rejected('truncated native module path not qualified')
            u.mem_write(arg(2),value+b'\0')
            bridge.events.append({'api':name,'declared_virtual_executable':str(virtual),'physical_path':str(physical),'result':len(value)})
            finish(len(value),12);return
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
        if name in ('CreateFileA','CreateFileW'):
            if arg(4) or arg(7):raise Rejected('SECURITY_ATTRIBUTES/template file unsupported')
            path=crt.strz(arg(1),True) if name.endswith('W') else cstr(arg(1))
            if name=='CreateFileA' and path==DIAGNOSTIC_PIPE:
                attempted=diagnostic_pipe.attempt(path,[arg(i) for i in range(2,8)])
                bridge.last_error=attempted['last_error']
                if attempted['succeeded']:
                    stop={'kind':'diagnostic_pipe_opened_no_data','attempt':attempted,'caller':hex(read32(sp))}
                    u.emu_stop();return
                finish(attempted['native_result'],28);return
            finish(bridge.open(path,arg(2),arg(3),arg(5),arg(6)),28);return
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
        stop={'kind':'io_boundary_failure','import':item,'error':repr(error),'args':[arg(i) for i in range(1,8)]}
        if name in ('CreateFileA','CreateFileW','CreateDirectoryA','RemoveDirectoryA'):stop['path']=crt.strz(arg(1),name.endswith('W'))
        u.emu_stop();return
    stop={'kind':'unimplemented_import','import':item,'args':[arg(i) for i in range(1,8)]}
    if name in ('LoadLibraryA','LoadLibraryW','RemoveDirectoryA'):stop['path']=crt.strz(arg(1),name.endswith('W'))
    u.emu_stop()

depth=0
original_call=call
def call(address,this=0,args=(),edx=0):
    global depth,pending_attach
    depth+=1
    try:
        sp=STACK+0x1d000-(depth-1)*0x6000
        u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args))
        u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.reg_write(UC_X86_REG_EDX,edx)
        next_pc=address
        while True:
            u.emu_start(next_pc,END,count=5000000)
            if pending_attach:
                pending_attach=False;saved=u.context_save()
                entry,arguments=rads.begin_attach()
                native_result=call(entry,args=arguments)
                rads.complete_native_attach(native_result)
                u.context_restore(saved);finish(rads.module_handle(),4)
                next_pc=u.reg_read(UC_X86_REG_EIP);continue
            if not crt.pending:break
            returned=getattr(crt,'pending_return',None);crt.pending_return=None
            saved=u.context_save()
            def invoke_pending(entry):
                before=set(live);call(entry['callback'],args=[entry['value']])
                crt.events.append(dict(api='native_fls_callback_completed',**entry,freed=sorted(before-set(live))))
            drain_one_batch(crt.pending,interrupted_callbacks,invoke_pending)
            u.context_restore(saved)
            if returned is not None:finish(*returned)
            next_pc=u.reg_read(UC_X86_REG_EIP)
        assert u.reg_read(UC_X86_REG_EIP)==END,('incomplete call',hex(address),hex(u.reg_read(UC_X86_REG_EIP)))
        native_strlen_tail.observe_return()
        return u.reg_read(UC_X86_REG_EAX)
    finally:depth-=1

def crt_primitives(uc,pc,size,user):
    if pc==0xca8673:
        sp=u.reg_read(UC_X86_REG_ESP);count,n=read32(sp+4),read32(sp+8)
        assert 0<count and 0<n and count*n<0x100000,('unqualified calloc size',count,n)
        p=allocate(count*n);u.mem_write(p,bytes(count*n));crt.events.append({'api':'declared_calloc_primitive','count':count,'size':n,'pointer':p});finish(p)
u.hook_add(unicorn.UC_HOOK_CODE,crt_primitives)
result={'passed':False,'complete':False,'provider_returned':False,'completed_path':False,'cleanup_passed':False,'source':str(EXE),'source_sha256':digest,
    'io_profile':'declared scratch virtual CWD; source read mapping; initially empty isolated Config',
    'virtual_root':str(bridge.root),'virtual_cwd':str(bridge.cwd),'phases':[], 'verified_input_files':verified_inputs,
    'declared_environment_variant':environment_variant}
try:
    write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
    phase='crt_thread_startup';write32(0x14ae87c,crt.heap_label)
    assert call(0xca92cb)==1
    crt_phases.append({'entry':'CA92CB','result':1,'live_allocations':len(live),'slot':read32(0x12230cc)})
    phase='crt_low_io';assert call(0xcaff53)==0
    crt_phases.append({'entry':'CAFF53','result':0,'live_allocations':len(live),
        'lowio_allocated':read32(0x2da52ec),'lowio_blocks':[read32(0x14ae888+4*i) for i in range(64)]})
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
    result['phases'].append({'name':phase,'completed':True});result['provider_returned']=True;result['completed_path']=True
except Exception as error:
    result.update(error=repr(error),phase=phase,pc=hex(u.reg_read(UC_X86_REG_EIP)),trail=list(trail))
finally:
    result.update(stop=stop,allocations=list(allocations),frees=list(frees),live_snapshot=snap(),events=list(events),
        shutdown_callbacks=shutdown_callbacks,executed_instruction_addresses=sorted(visited),
        primitive_hooks=sorted(PRIMITIVES|{0xc97e4c,0xca1d00,0xca8673}),io_events=list(bridge.events),
        shadow_roots=sorted(bridge.shadow_roots),open_handles_at_stop=len(bridge.handles)+len(bridge.finds))
    result['rads_module']={'state':rads.state,'source':str(rads_image.path),'sha256':rads_image.sha256,'image_base':rads_image.base,'entry':rads_image.entry,'events':list(rads.events)}
    result['environment_native_observations']=environment_native_observations
    result['dll_crt_returns']=dll_crt_returns
    result['dll_initializer_calls']=dll_initializer_calls
    result['native_slist']={'source':native_slist.provenance,'events':native_slist.events}
    if rads.state!='prepared':
        try:
            def bounded_string_hex(p):
                raw=bytearray()
                for i in range(1024):
                    v=bytes(u.mem_read(p+i,1));raw.extend(v)
                    if v==b'\0':return raw.hex()
                raise Rejected('diagnostic string exceeds1024bytes')
            argc,argv,env=read32(0x101950cc),read32(0x101950d0),read32(0x101950d8)
            argv_values=[bounded_string_hex(read32(argv+4*i)) for i in range(argc)] if argv and argc<=16 else None
            env_values=[] if env else None
            if env:
                for i in range(16):
                    p=read32(env+4*i)
                    if not p:break
                    env_values.append(bounded_string_hex(p))
                else:raise Rejected('diagnostic environment exceeds16entries')
            result['dll_process_state']={'argc':argc,'argv':argv,'argv_values_hex':argv_values,
                'argv_sentinel':read32(argv+4*argc) if argv and argc<=16 else None,
                'environment_table':env,'environment_values_hex':env_values,'environment_acp_block':read32(0x101950ac),
                'environment_initialized':read32(0x10199ab4),'commandline_pointer':read32(0x10199ab8),
                'lowio_records':read32(0x10199a18),'attach_counter':read32(0x101950a8)}
        except Exception as error:result['dll_process_snapshot_error']=repr(error)
    result['sync_handles_at_stop']={hex(label):{'kind':record['kind'],'state':record['state']} for label,record in sync.handles.items()}
    result['crt_phases']=crt_phases;result['ini_observations']=ini_observations;result['crt_before_host_cleanup']={'slots':list(crt.slots),'locks':len(crt.locks),'lock_depths':dict(crt.lock_depth),'heap_blocks':len(crt.heap_blocks)}
    result['crt_heap_mirrors_at_stop']=crt.mirrors.snapshot()
    native_strlen_tail.abandon('outer native call ended before terminal host cleanup')
    try:
        crt.host_cleanup()
        # Detach the entire batch before invoking any native callback. A nested
        # call drains newly queued callbacks itself, never this original batch.
        while crt.pending:
            def invoke_cleanup(entry):
                call(entry['callback'],args=[entry['value']]);crt.events.append(dict(api='host_cleanup_native_callback_completed',**entry))
            drain_one_batch(crt.pending,interrupted_callbacks,invoke_cleanup)
    except Exception as error:result['host_cleanup_error']=repr(error)
    finally:
        try:crt.release_host_backing()
        except Exception as error:result['host_backing_cleanup_error']=repr(error)
        result['strlen_invocations_abandoned_after_cleanup']=len(native_strlen_tail.stack)
        native_strlen_tail.abandon('terminal host cleanup ended; no native invocation resumes')
    result['sync_cleanup_errors']=sync.cleanup();result['sync_events']=sync.events
    result['sync_handles_after_cleanup']=len(sync.handles)
    bridge.cleanup();result['open_host_handles_after_cleanup']=len(bridge.handles)+len(bridge.finds)
    diagnostic_pipe.cleanup();result['diagnostic_pipe_events']=diagnostic_pipe.events
    result['diagnostic_pipe_handles_after_cleanup']=int(diagnostic_pipe.handle is not None)
    result['crt_heap_mirrors_after_cleanup']=crt.mirrors.snapshot()
    result['crt_heap_mirror_events']=crt.mirrors.events
    result['crt_heap_bounds_events']=crt.mirrors.bounds_events
    result['native_strlen_tail']={'source':native_strlen_tail.provenance,'events':native_strlen_tail.events,
        'physical_reads':native_strlen_tail.reader.events,'unretired_invocations':len(native_strlen_tail.stack)}
    result['crt_heap_mirror_cleanup_errors']=crt.mirrors.cleanup_errors
    result['crt_events']=crt.events;result['crt_host_backing_after_cleanup']={'slots':len(crt.slots),'locks':len(crt.locks),'heap_blocks':len(crt.heap_blocks),'unadopted_heap_blocks':len(crt.unadopted_heap_blocks),'pending_callbacks':len(crt.pending),'interrupted_callbacks':len(interrupted_callbacks),
        'retained_heap_mappings':result['crt_heap_mirrors_after_cleanup']['mapped_regions'],
        'interrupted_heap_owners':len(result['crt_heap_mirrors_after_cleanup']['interrupted'])}
    result['unstarted_callbacks_at_end']=list(crt.pending);result['interrupted_callbacks']=interrupted_callbacks
    result['host_cleanup_native_frees']=frees[len(result['frees']):]
    result['process_profile_at_end']=process_profile.snapshot()
    process_profile.close_after_execution();result['process_profile_retired']=process_profile.closed
    result['emulated_live_count_after_host_cleanup']=len(live)
    result['emulated_allocation_count_scope']='Engine primitive arena only; imported CRT heap mirrors are separately counted in crt_heap_mirrors_after_cleanup.'
    result['cleanup_passed']=not result.get('host_cleanup_error') and not result.get('host_backing_cleanup_error') and not any(result['crt_host_backing_after_cleanup'].values()) and not result['crt_heap_mirror_cleanup_errors'] and not result['open_host_handles_after_cleanup'] and not result['diagnostic_pipe_handles_after_cleanup'] and not result['sync_handles_after_cleanup'] and not result['sync_cleanup_errors']
    result['passed']=result['provider_returned'] and result['cleanup_passed']
    result['limits']=['RADS mapped image may remain partly initialized; no DLL_PROCESS_DETACH or native module teardown is claimed. Failed/stopped native calls are not completed providers. Emulated allocations at the boundary have not undergone native teardown.',
        'Host handle cleanup is separate from native lifecycle. Native INI/provider callbacks remain real or an explicit stop.',
        'The process heap global is explicitly seeded with a labelled real host heap; the selected legacy allocator globals and context fragment906487..9065D8 are probe inputs, not full application startup.',
        'Native FLS callbacks are queued by the host ABI callback and then executed on an isolated emulated stack after the OS function returns. This deferred adaptation and final host hygiene are not normal native CRT teardown.',
        'The sole local LogViewerPipe CreateFileA attempt uses exact native arguments. A successful open stops before any data operation and is closed; the general file bridge accepts no IPC paths.',
        'Scratch Config and Logs are explicit initially empty profiles; existing D: directories are preserved. Full startup and archives not qualified.',
        'Confinement assumes no concurrent external mutation of the private filesystem tree; hostile cross-process rename/link races are outside this probe.']
    result['generator_hashes']={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py',OUT/'heap_mirrors.py',OUT/'native_strlen_tail.py',OUT/'isolated_io.py',OUT/'diagnostic_pipe_open.py',OUT/'verify_inputs.py',OUT/'pe_x86_loader.py',OUT/'callback_batches.py',OUT/'process_profile.py',OUT/'sync_os.py',OUT/'native_slist.py']}
    destination=OUT/('rads_provider_oracle.json' if environment_variant=='empty' else 'rads_provider_controlled_oracle.json')
    if destination.exists():
        attempts=OUT/'attempts';attempts.mkdir(exist_ok=True)
        (attempts/('%03d.json'%(len(list(attempts.glob('*.json')))+1))).write_bytes(destination.read_bytes())
    destination.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'phase':phase,'stop':stop,'error':result.get('error'),
        'instruction_addresses_before_cleanup':len(result['executed_instruction_addresses']),
        'instruction_addresses_including_cleanup':len(visited),'dll_state':rads.state,
        'cleanup_passed':result['cleanup_passed'],'io':dict(collections.Counter(e['api'] for e in bridge.events))}))
