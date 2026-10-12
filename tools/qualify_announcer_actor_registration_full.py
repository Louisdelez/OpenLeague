from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_announcer_actor_registration.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
source=source.replace('    elif address==0x62a1f5:uc.emu_stop()','')
exec(compile(source,str(root/'tools/qualify_announcer_actor_registration.py'),'exec'))
resource_key=77;metadata=heap+0x5500;owner_storage=heap+0x5600;invalid_owner=0xffffffff
write32(actor+8,resource_key);write32(actor+0x17c,metadata);write32(metadata+0x30,owner_storage);write32(0x2d5f448,invalid_owner)
tail_calls=[];secondary_present=False;owner_result=0
def tail_hook(uc,address,size,user):
    sp=u.reg_read(UC_X86_REG_ESP)
    if address==0x5bdd80:
        key=read32(sp+4);tail_calls.append({'op':'secondary_lookup','key':key});finish(4,int(secondary_present))
    elif address==0x64c270:
        supplied_actor,key=read32(sp+4),read32(sp+8);tail_calls.append({'op':'secondary_register','actor':supplied_actor,'key':key});finish(8)
    elif address==0x6b59f0:
        component,owner=read32(sp+4),read32(sp+8);tail_calls.append({'op':'owner_register','component':component,'owner':owner,'result':owner_result});finish(8,owner_result)
u.hook_add(unicorn.UC_HOOK_CODE,tail_hook)
cases=[]
for existed,first,second,poison,secondary_present,owner_id,owner_result in itertools.product([False,True],[0,42,0xffffffff,0x80000000],[0,42,0xffffffff,0x80000000],[0,165],[False,True],[invalid_owner,42],[0,1,256,257]):
    cursor=arena;write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(0x14bef40,0);write32(owner_storage,owner_id)
    if existed:
        call(0x661410,0,[]);manager=read32(0x2d789c0);pair=heap+0xa000;result=heap+0xa100;write32(pair,second);write32(pair+4,0x11223344);call(0x65e6f0,manager,[result,pair])
    allocations.clear();freed.clear();ids=[first,second];calls.clear();diagnostics.clear();tail_calls.clear()
    sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x62a140,end,count=500000)
    assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4
    assert calls==[first,second];assert len(diagnostics)==int(first==0xffffffff)+int(owner_id!=invalid_owner and owner_result&255==0)
    assert len(tail_calls)==1+int(not secondary_present)+int(owner_id!=invalid_owner)
    manager=read32(0x2d789c0);assert call(0x62b380,0,[second])==actor
    cases.append({'existed':existed,'first_id':first,'second_id':second,'poison':poison,'secondary_present':secondary_present,'resource_key':resource_key,'owner_id':owner_id,'invalid_owner':invalid_owner,'owner_result':owner_result,'actor':actor,'getter_calls':list(calls),'diagnostics':list(diagnostics),'tail_calls':list(tail_calls),'manager':manager,'count':read32(manager+8),'allocations':list(allocations),'freed':list(freed),'stack_delta':4})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual complete62A140 returns normally in1024 cases. Original primary registry initialization/lookup/insertion and actor publication execute without result adapters. Tail secondary lookup/register and owner registration boundaries supplied; AL-only owner success, sentinel-owner skip, diagnostics and cdecl return verified.','Virtual ID getter, returning diagnostics, malloc/free and secondary/owner helper results supplied. Their internal registries/resource provenance, actor destruction/concurrency, exceptions and actual playback remain open.']}
(root/'data/4.20/audio_announcer_actor_registration_full_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_full_registration_cases':len(cases),'passed':True}))
