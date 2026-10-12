from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_announcer_registry_insertion.py').read_text(encoding='utf-8').split('cases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_registry_insertion.py'),'exec'))
actor=heap+0x4000;vtable=heap+0x5000;getter=end+0x700;ids=[];calls=[];diagnostics=[]
write32(actor+0x128,vtable);write32(vtable+4,getter);write32(0x14cd324,0xffffffff)
def registration_hook(uc,address,size,user):
    sp=u.reg_read(UC_X86_REG_ESP)
    if address==getter:
        result=read32(sp+4);value=ids[len(calls)];calls.append(value);write32(result,value);finish(4,result)
    elif address==0x991e60:
        diagnostics.append([read32(sp+i) for i in [4,8,12,16,20]]);finish()
    elif address==0x62a1f5:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,registration_hook)
cases=[]
for existed,first,second,poison in itertools.product([False,True],[0,42,0xffffffff,0x80000000],[0,42,0xffffffff,0x80000000],[0,165]):
    cursor=arena;write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(0x14bef40,0)
    if existed:
        call(0x661410,0,[]);manager=read32(0x2d789c0);pair=heap+0xa000;result=heap+0xa100;write32(pair,second);write32(pair+4,0x11223344);call(0x65e6f0,manager,[result,pair]);prior_node=read32(result)
    else:prior_node=None
    allocations.clear();freed.clear();ids=[first,second];calls.clear();diagnostics.clear()
    sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x62a140,end,count=500000)
    assert u.reg_read(UC_X86_REG_EIP)==0x62a1f5 and calls==[first,second]
    manager=read32(0x2d789c0);assert read32(manager+8)==1;assert len(diagnostics)==int(first==0xffffffff)
    assert call(0x62b380,0,[second])==actor
    head=read32(manager+4);node=read32(head);assert read32(node+8)==second and read32(node+12)==actor
    if existed:assert node==prior_node and not allocations
    else:assert [x['bytes'] for x in allocations]==[36,16,64,16]
    cases.append({'existed':existed,'first_id':first,'second_id':second,'poison':poison,'getter_calls':list(calls),'diagnostics':list(diagnostics),'manager':manager,'node':node,'actor':actor,'allocations':list(allocations),'freed':list(freed),'count':read32(manager+8),'stored_value':read32(node+12)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual62A140 admission segment, two virtual ID calls, invalid-ID diagnostic, lazy661410 and original lookup/insertion execute until62A1F5, immediately after actor value store.64 cases cover existing vs absent, changed ID getters and allocator poison.','Virtual ID getter, diagnostic and malloc/free imports supplied; no lookup/insertion result adapters. Remaining62A140 registration callbacks, field/table ownership, actor lifetime, locking and playback remain incomplete.']}
(root/'data/4.20/audio_announcer_actor_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_registration_cases':len(cases),'passed':True}))
