from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_announcer_registry_insertion.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_registry_insertion.py'),'exec'))
locks=[];diagnostics=[]
def boundary(uc,address,size,user):
    global cursor
    if address in [0x9941b0,0x994210]:
        locks.append({'op':'enter' if address==0x9941b0 else 'leave','object':u.reg_read(UC_X86_REG_ECX)});finish()
    elif address==0x991e60:
        diagnostics.append([read32(u.reg_read(UC_X86_REG_ESP)+offset) for offset in [4,8,12,16,20]]);finish()
    elif address==0x5cc6b0:
        count=u.reg_read(UC_X86_REG_ECX)*4;pointer=cursor;cursor+=(count+31)&~15;u.mem_write(pointer,bytes([poison])*count);allocations.append({'bytes':count,'pointer':pointer,'allocator':'owner_pointer_array'});finish(eax=pointer)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
for kind,prior,key,actor,poison in itertools.product(['secondary','owner'],[None,0,0x3000aaaa],[0,77,0x80000000,0xffffffff],[0,0x30004000,0x30004178],[0,165]):
    cursor=arena;write32(0x14bef40,0);manager=0x2110a10 if kind=='secondary' else 0x2d5f470;entry=0x64c270 if kind=='secondary' else 0x6b59f0;query=0x5bdd80 if kind=='secondary' else 0x6b5990
    opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
    for offset in [36,40,44]:write32(manager+offset,0)
    if prior is not None:
        pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,prior);call(0x65e750,manager,[result,pair])
    steps=[]
    for invocation in range(2):
        allocations.clear();freed.clear();locks.clear();diagnostics.clear();before=call(query,0,[key]);returned=call(entry,0,[actor,key]);after=call(query,0,[key]);assert after==(actor if before==0 else before)
        assert returned&255==int(before==0);assert len(locks)==2*int(before==0);assert len(diagnostics)==int(actor==0)
        assert read32(manager+8)==1
        head=read32(manager+4);begin=read32(manager+12);end_pointer=read32(manager+16);vector=manager+36;vector_begin=read32(vector);vector_end=read32(vector+4)
        words=[[manager+i,read32(manager+i)] for i in range(4,48,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(begin,end_pointer,4)];node=read32(head)
        words += [[node+i,read32(node+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(vector_begin,vector_end,4)]
        steps.append({'before':before,'return_low_byte':returned&255,'after':after,'allocations':list(allocations),'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'words':words,'vector_values':[read32(i) for i in range(vector_begin,vector_end,4)]})
    cases.append({'kind':kind,'prior':prior,'key':key,'actor':actor,'poison':poison,'manager':manager,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual secondary5BDD80/64C270 and owner6B5990/6B59F0 helpers execute with raw-key5C3160/65E750 identity-bucket insertion, original vector append/growth and physical pointer stores.144 sequences288 registrations cover absent, existing-null and existing-nonnull values, unsigned keys, null actor diagnostics and repeat calls. No registry/helper result adapters.','Malloc/free, engine pointer-array allocator5CC6B0, lock entry/exit and returning diagnostic imports supplied. Native global table construction initialized through actual664E50; live lock objects, engine allocator internals, reentrant/throwing boundaries, threshold diagnostics, table ownership/destruction and playback remain open.']}
(root/'data/4.20/audio_announcer_secondary_owner_registries_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_sequences':len(cases),'native_registrations':sum(len(c['steps']) for c in cases),'passed':True}))
