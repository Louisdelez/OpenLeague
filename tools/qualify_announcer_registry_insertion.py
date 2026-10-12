from pathlib import Path
import json,struct,itertools,random
root=Path('E:/OpenLeague');bootstrap=root/'tools/qualify_native_audio_legacy_paths.py';__file__=str(bootstrap)
exec(compile(bootstrap.read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)',''),__file__,'exec'))
arena=0x34000000;u.mem_map(arena,0x100000);cursor=arena;allocations=[];freed=[];poison=0
def capture(uc,address,size,user):
    global cursor
    sp=u.reg_read(UC_X86_REG_ESP)
    if address==0x9933e0:
        count=read32(sp+4);pointer=cursor;cursor+=(count+31)&~15;assert cursor<arena+0x100000
        u.mem_write(pointer,bytes([poison])*count);allocations.append({'bytes':count,'pointer':pointer});finish(eax=pointer)
    elif address==0xc98528:freed.append(read32(sp+4));finish()
    elif address==0xc97e4c:finish()
u.hook_add(unicorn.UC_HOOK_CODE,capture)
def call(entry,ecx,args):
    sp=stack+0xe000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),end,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx)
    try:u.emu_start(entry,end,count=500000)
    except Exception:
        print(json.dumps({'failure_pc':hex(u.reg_read(UC_X86_REG_EIP)),'entry':hex(entry),'allocations':allocations[-5:]}));raise
    assert u.reg_read(UC_X86_REG_EIP)==end
    return u.reg_read(UC_X86_REG_EAX)
cases=[]
for order,poison in itertools.product(['ascending','descending','mixed'],[0,165]):
    cursor=arena;allocations.clear();freed.clear();write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(0x14bef40,0)
    call(0x661410,0,[]);manager=read32(0x2d789c0);keys=list(range(60))+[0x7fffffff,0x80000000,0xdeadbeef,0xffffffff]
    if order=='descending':keys.reverse()
    if order=='mixed':random.Random(420).shuffle(keys)
    steps=[];values={}
    for key in keys:
        allocations.clear();freed.clear();value=heap+0x6000+len(values)*32;pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,value)
        call(0x65e6f0,manager,[result,pair]);node=read32(result);assert read32(node+8)==key;assert read32(node+12)==value
        values[key]=value;assert read32(manager+8)==len(values)
        queries=[]
        for query in list(values)+[999,0xfffffffe]:
            observed=call(0x62b380,0,[query]);assert observed==values.get(query,0),(order,key,query,observed,values.get(query,0))
            queries.append({'key':query,'value':observed})
        head=read32(manager+4);bucket_begin=read32(manager+12);bucket_end=read32(manager+16)
        words=[[manager+i,read32(manager+i)] for i in range(4,36,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(bucket_begin,bucket_end,4)]
        current=read32(head);seen=set()
        while current!=head:
            assert current not in seen;seen.add(current);words.extend([[current+i,read32(current+i)] for i in range(0,16,4)]);current=read32(current)
        assert len(seen)==len(values)
        steps.append({'key':key,'value':value,'node':node,'mask':read32(manager+24),'maximum':read32(manager+28),'allocations':list(allocations),'freed':list(freed),'words':words,'lookups':queries})
    duplicates=[]
    for key in [42,0,0xffffffff,42,0,0xffffffff]:
        allocations.clear();freed.clear();pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,0x3000abcd);count_before=read32(manager+8)
        call(0x65e6f0,manager,[result,pair]);node=read32(result)
        assert read32(manager+8)==count_before and read32(node+8)==key and read32(node+12)==values[key]
        observed=call(0x62b380,0,[key]);assert observed==values[key]
        duplicates.append({'key':key,'supplied_value':0x3000abcd,'returned_node':node,'retained_value':read32(node+12),'inserted_byte':u.mem_read(result+4,1)[0],'count':read32(manager+8),'allocations':list(allocations),'freed':list(freed)})
    removals=[]
    for inserted in reversed(steps):
        key=inserted['key'];node=inserted['node'];allocations.clear();freed.clear();expected_next=read32(node);result=heap+0xa100
        call(0x64dd60,manager,[result,node]);assert read32(result)==expected_next;assert freed==[node];del values[key]
        assert read32(manager+8)==len(values)
        queries=[]
        for query in list(values)+[key,999,0xfffffffe]:
            observed=call(0x62b380,0,[query]);assert observed==values.get(query,0)
            queries.append({'key':query,'value':observed})
        words=[[manager+i,read32(manager+i)] for i in range(4,36,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(bucket_begin,bucket_end,4)]
        current=read32(head);seen=set()
        while current!=head:
            assert current not in seen;seen.add(current);words.extend([[current+i,read32(current+i)] for i in range(0,16,4)]);current=read32(current)
        assert len(seen)==len(values)
        removals.append({'key':key,'node':node,'returned_next':expected_next,'freed':list(freed),'words':words,'lookups':queries})
    assert read32(head)==head and read32(head+4)==head
    cases.append({'order':order,'poison':poison,'manager':manager,'steps':steps,'duplicate_steps':duplicates,'removal_steps':removals})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual native initialization,65E6F0/6680F0/663710 insertion and original lookup executed for six64-node sequences384 insertions. Malloc/free/atexit boundaries supplied.','Unique keys, valid contexts and normal-return default allocation only. Duplicate admission, exceptional allocation, locking, actors and actual playback remain open.']}
(root/'data/4.20/audio_announcer_registry_insertion_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'sequences':len(cases),'insertions':sum(len(c['steps']) for c in cases),'max_mask':max(s['mask'] for c in cases for s in c['steps']),'passed':True}))
