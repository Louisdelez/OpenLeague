"""Native manager producer/destructor and provider cache lookup.

Only allocator/free/memory primitives are supplied. Providers in the lookup
fixture are opaque borrowed tokens, never a simulated constructed provider.
Misses stop at the real90B520 entry before its body; direct String24 retirement
is an explicitly separate abandoned-call cleanup, not a native exception path.
"""
from pathlib import Path
import sys, json, struct, hashlib, traceback, collections
from extract_resource import EXE, raw, digest, pe, image, BASE, OUT, read
import unicorn
from unicorn.x86_const import *
H=0x30000000; STACK=0x31000000; END=0x32000000; ARENA=0x33000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(BASE,(len(image)+0xfff)&~0xfff);u.mem_write(BASE,image)
u.mem_map(0,0x10000);u.mem_map(H,0x10000);u.mem_map(STACK,0x20000);u.mem_map(END,0x10000);u.mem_map(ARENA,0x400000)
cursor=ARENA;poison=0;allocations=[];frees=[];live={};visited=set();events=[];phase='';stop=None;name_copy=None;copy_before_cleanup=None;trail=collections.deque(maxlen=45)
def read32(a):return int.from_bytes(u.mem_read(a,4),'little')
def write32(a,v):u.mem_write(a,(v&0xffffffff).to_bytes(4,'little'))
def finish(value=None,pop=0):
    sp=u.reg_read(UC_X86_REG_ESP);ret=read32(sp)
    if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
    u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,ret)
def allocate(n):
    global cursor
    assert 0<n<0x100000
    p=cursor;cursor+=(n+31)&~15;assert cursor<ARENA+0x400000
    u.mem_write(p,bytes([poison])*n);live[p]=n;allocations.append({'pointer':p,'bytes':n,'phase':phase});return p
def release(p):
    if not p:return
    assert p in live,('free of unowned pointer',hex(p),phase)
    del live[p];frees.append({'pointer':p,'phase':phase})
PRIMITIVES={0x9933e0,0xc9f39b,0xc98528,0xca1ef0,0xca1f20}
def hook(uc,pc,size,user):
    global stop,name_copy,copy_before_cleanup
    sp=u.reg_read(UC_X86_REG_ESP)
    if pc in (0x9933e0,0xc9f39b):finish(allocate(read32(sp+4)));return
    if pc==0xc98528:release(read32(sp+4));finish();return
    if pc in (0xca1ef0,0xca1f20):
        dst,src,n=[read32(sp+i) for i in (4,8,12)];assert n<0x100000
        u.mem_write(dst,bytes(u.mem_read(src,n)));finish(dst);return
    assert BASE<=pc<BASE+len(image),('unexpected external execution',hex(pc),phase)
    assert bytes(u.mem_read(pc,size))==read(pc,size),('source modified',hex(pc))
    trail.append(hex(pc))
    visited.add(pc)
    if phase.startswith('lookup') and pc==0x99a310:name_copy=u.reg_read(UC_X86_REG_ECX)
    if phase=='lookup_hit' and pc==0x90adb1:copy_before_cleanup=string(name_copy)
    if phase=='lookup_miss' and pc==0x90b520:
        visited.discard(pc)
        stop={'address':pc,'this':u.reg_read(UC_X86_REG_ECX),'arguments':[read32(sp+4),read32(sp+8)],'copy':string(name_copy),'live':dict(live),'esp':sp};u.emu_stop();return
    if pc in (0x90b7c0,0x90a4c0,0x90a760,0x90a800,0x90ad00,0x90cef0,0x90e0c0,0x90e190,0x5c2ab0,0x5c2ce0):events.append({'phase':phase,'entry':pc,'this':u.reg_read(UC_X86_REG_ECX),'global':read32(0x2d78f1c)})
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(a,this=0,args=(),edx=0):
    sp=STACK+0x1d000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.reg_write(UC_X86_REG_EDX,edx)
    u.emu_start(a,END,count=3000000)
    assert u.reg_read(UC_X86_REG_EIP)==END,('incomplete call',hex(a),hex(u.reg_read(UC_X86_REG_EIP)))
    return u.reg_read(UC_X86_REG_EAX)
def string(p):
    n=read32(p+16);cap=read32(p+20);assert n<=cap<0x10000
    data=read32(p) if cap>=16 else p
    return {'pointer':p,'data':data,'length':n,'capacity':cap,'bytes_hex':bytes(u.mem_read(data,n)).hex(),'object_hex':bytes(u.mem_read(p,24)).hex()}
def make_string(p,value):
    u.mem_write(p,bytes([poison])*24);write32(p+16,0);write32(p+20,15);u.mem_write(p,b'\0');u.mem_write(H+0x4000,value+b'\0')
    call(0x564c20,p,[H+0x4000,len(value)])
def snap():return {'blocks':[{'pointer':p,'size':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())],'global':read32(0x2d78f1c)}
def tree(manager):
    head=read32(manager+12);nodes=[]
    def walk(p):
        if u.mem_read(p+13,1)[0]:assert p==head;return
        assert p not in [x['node'] for x in nodes]
        walk(read32(p));nodes.append({'node':p,'name':string(p+16),'skin':read32(p+40),'provider':read32(p+44),'hex':bytes(u.mem_read(p,48)).hex()});walk(read32(p+8))
    walk(read32(head+4));assert len(nodes)==read32(manager+16)
    return {'head':head,'count':len(nodes),'nodes':nodes}
cases=[]
try:
    for fill in [0,165]:
        poison=fill;cursor=ARENA;live.clear();allocations.clear();frees.clear();events.clear();write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d78f1c,0)
        phase='static_hash_initializers'
        for initializer in [0x531a50,0x531a90,0x531ad0,0x531b10]:call(initializer)
        phase='manager_producer';call(0x90b7c0);manager=read32(0x2d78f1c);assert manager in live and live[manager]==172
        assert len(live)==14,len(live);initial=snap()
        assert all(e['global']==0 for e in events)
        assert read32(manager)==0x10d6450 and read32(manager+0x20)==4
        offsets=[4,12,20,28,44,64,84,112,136]
        sentinels=[read32(manager+i) for i in offsets];assert len(set(sentinels))==9
        phase='caller_postpublication_backpointers';u.reg_write(UC_X86_REG_EAX,manager)
        u.emu_start(0x592e49,0x592e6a,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x592e6a
        assert all(read32(manager+i)==manager for i in [0x28,0x3c,0x50,0x6c,0x84,0x98]) and u.mem_read(manager+0xa8,1)==b'\1'
        after_backpointers=snap()
        # Produce cache nodes with the actual native key/node constructors and
        # red-black insertion. Payloads stay opaque borrowed addresses.
        keys=[(b'Anivia',0),(b'Anivia',0xffffffff),(b'Ahri',0x80000000),(b'A',17),(b'X'*15,1),(b'Y'*16,2),(b'Z'*80,0x7fffffff),(b'embedded\0suffix',9),(b'\x80\xff',0),(b'Anivia',0x7fffffff),(b'Anivia',0x80000000)]
        key=H+0x100;query=H+0x200;expected={}
        phase='cache_setup'
        for ix,(name,skin) in enumerate(keys):
            make_string(query,name);call(0x99a310,key,edx=query);assert bytes.fromhex(string(key)['bytes_hex'])==name.lower()
            write32(key+24,skin);slot=call(0x90cef0,manager+12,[key]);token=H+0x6000+ix*64;u.mem_write(token,bytes([0x5a])*56);write32(slot,token);expected[name.lower(),skin]=token;call(0x564900,key);call(0x564900,query)
        prepared=snap();native_tree=tree(manager);queries=[]
        for ix,(name,skin) in enumerate(keys+list(reversed(keys))+[(n.swapcase(),s) for n,s in keys]):
            phase='query_input';make_string(query,name);source=string(query);before=snap();na=len(allocations);nf=len(frees)
            phase='lookup_hit';name_copy=None;copy_before_cleanup=None;result=call(0x90ad00,manager,[query,skin,0xdeadbeef]);assert result==expected[name.lower(),skin]
            assert snap()==before and string(query)==source
            fresh=allocations[na:];released=frees[nf:]
            assert bytes.fromhex(copy_before_cleanup['bytes_hex'])==name.lower()
            assert len(fresh)==len(released)==int(len(name)>=16)
            assert not fresh or fresh[0]['pointer']==released[0]['pointer']
            queries.append({'name_hex':name.hex(),'skin':skin,'result':result,'copy':copy_before_cleanup,'temporary_allocations':fresh,'temporary_frees':released,'borrowed_source_unchanged':True,'tree_unchanged':True})
            phase='query_input_retirement';call(0x564900,query)
        assert snap()==prepared
        misses=[]
        for name,skin in [(b'Missing',0),(b'Anivia',1),(b'Long missing provider name',0xffffffff),(b'',0)]:
            phase='query_input';make_string(query,name);before=snap();na=len(allocations);nf=len(frees);source=string(query)
            phase='lookup_miss';stop=None;name_copy=None;sp=STACK+0x1d000;u.mem_write(sp,struct.pack('<4I',END,query,skin,0xa5a5a5a5));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x90ad00,END,count=3000000)
            assert stop is not None and stop['arguments']==[query,skin] and stop['this']==manager and string(query)==source
            # Standalone destruction, not return injection into90AD00. A lower
            # scratch stack preserves the outstanding native call frame.
            phase='abandoned_copy_cleanup';cleanup_sp=STACK+0x9000;u.mem_write(cleanup_sp,struct.pack('<I',END));u.reg_write(UC_X86_REG_ESP,cleanup_sp);u.reg_write(UC_X86_REG_ECX,name_copy);u.emu_start(0x564900,END,count=3000000);assert u.reg_read(UC_X86_REG_EIP)==END
            assert snap()==before
            misses.append({'name_hex':name.hex(),'skin':skin,'stop':stop,'temporary_allocations':allocations[na:],'temporary_frees':frees[nf:],'cleanup_explicitly_abandons_call':True})
            # Restore fs chain abandoned by the native call, fixture maintenance.
            write32(0,0);phase='query_input_retirement';call(0x564900,query)
        # The real manager owns populated providers and invokes their virtual0.
        # Our opaque lookup payloads are deliberately not providers. Erase the
        # diagnostic native nodes using real string/tree cleanup first; manager
        # lifecycle below is therefore the empty-provider-cache lifetime only.
        phase='diagnostic_cache_erase';head=read32(manager+12);call(0x5c2ab0,manager+12,[H+0x5000,read32(head),head]);assert tree(manager)['count']==0
        phase='manager_destructor';before_destroy=snap();assert call(0x90a760,manager,[1])==manager;assert not live,live
        # The source destructor itself does not clear the global; outer shutdown
        # stores zero only after virtual destruction. Probe clears it explicitly.
        assert read32(0x2d78f1c)==manager;write32(0x2d78f1c,0)
        cases.append({'fill':fill,'manager':manager,'initial':initial,'after_bounded_backpointer_fragment':after_backpointers,'prepared':prepared,'cache_tree':native_tree,'hits':queries,'misses':misses,'before_destroy':before_destroy,'all_owned_allocations_freed':not live,'destructor_global_clear_is_outer':True,'events':list(events),'allocations':list(allocations),'frees':list(frees)})
    proof={'passed':True,'complete':False,'source_sha256':digest,'cases':cases,'executed_instruction_addresses':sorted(visited),'primitive_hooks':sorted(PRIMITIVES),'limits':['Opaque borrowed provider tokens test cache keys and ownership; they are not constructed providers and are never invoked. Native90CEF0/90E0C0/90E190 construct all cache nodes, then separate native5C2AB0 erases this diagnostic tree before manager destruction. Populated-provider destruction is not qualified.', 'Native531A50/531A90/531AD0/531B10 static hash producers and90B7C0/90A4C0 manager producer and90A760/90A800 empty-provider-cache retirement execute. Only the standalone592E49..592E6A backpointer fragment executes from the caller; the full startup function and runtime root context initialization9063E0 do not execute.', 'Cache misses stop at90B520 before its first instruction; no provider factory/path/INI result is supplied. Outstanding temporary is destroyed by separate564900 call with explicit abandoned stack/FS chain.', 'Name normalization is actual99A310/5FA650/C98719 with the PE initial C locale14AE870==0; non-C localeC985D6 unqualified.', 'Allocation succeeds and no concurrency, callbacks mutating allocator state, OOM, SEH unwind, GPU renderer or normal loading UI is qualified.']}
except Exception as e:
    traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'phase':phase,'source_sha256':digest,'cases':cases,'live':live,'last_events':events[-20:],'trail':list(trail),'query':string(H+0x200)}
(OUT/'native_resource_oracle.json').write_text(json.dumps(proof,indent=2)+'\n')
summary={'passed':proof['passed'],'complete':False,'lifetimes':len(cases),'hits':sum(len(c['hits']) for c in cases),'misses_stopped_before_factory':sum(len(c['misses']) for c in cases),'native_addresses':len(visited)}
(OUT/'native_resource_summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary))
if not proof['passed']:sys.exit(1)
