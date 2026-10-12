from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_source_release.py').read_text().split('\ncases=[]')[0],'native factory prerequisites','exec'))
u.mem_map(0x70000000,0x10000);actor=0x70000000;motion=0x70004000;motion_control=0x70005000;actor_control=0x70006000;descriptor=0x70007000;character=0x70008000
init_calls=[]
def unit_boundary(uc,a,size,user):
 if a==0x617ab0:init_calls.append(a);finish()
u.hook_add(unicorn.UC_HOOK_CODE,unit_boundary)
cases=[]
for radius,flat,tag,position in itertools.product([100.,1200.,1350.],[-.5,0.,2.],[100,200],[[10.,99.,20.],[125.,-40.,-300.]]):
 allocation_cursor=heap+0x19000;init_calls.clear();frees.clear();events.clear()
 for pointer,size in [(manager,64),(entries,32),(actor,0x3000),(motion,0x338),(motion_control,16),(actor_control,16),(descriptor,256),(character,0x300)]:u.mem_write(pointer,bytes(size))
 for address,value in [(manager+4,entries),(manager+8,entries),(manager+0xc,entries+32),(0x2d798ac,manager),(actor,0x1090ea8),(actor+0x128,0x1090e88),(actor+0x3d8,0x1090e14),(actor+0x3e0,0x10924dc),(actor+0x206c,character),(actor+0x17c,descriptor),(descriptor+0x34,678),(actor+0xfc,12345),(actor+8,0x12340002),(actor+0x18,tag),(actor+0x18b8,motion),(actor+0x18bc,motion_control),(motion_control+4,10),(motion_control+8,10),(actor+0xf4,actor),(actor+0xf8,actor_control),(actor_control+4,10),(actor_control+8,10),(motion+0x70,0x1094490),(0x14cd324,0)]:write32(address,value)
 u.mem_write(motion+0x2aa,struct.pack('<3f',*position));u.mem_write(actor+0x60,struct.pack('<3f',500.,66.,800.));f(character+0x1d8,radius);f(actor+0x778,flat);f(actor+0x77c,.75);f(actor+0x37c,64.);f(actor+0x384,128.)
 invoke(0x649040,actor)
 source_object=read32(actor+0x2294);source_control=read32(actor+0x2298)
 assert len(init_calls)==1 and source_object==read32(entries) and read32(manager+8)==entries+8
 assert read32(source_control+4)==1 and read32(source_control+8)==2
 assert read32(actor_control+4)==10 and read32(actor_control+8)==11
 assert read32(motion_control+4)==10 and read32(motion_control+8)==10
 assert read32(source_object+0x38)==actor and read32(source_object+0x3c)==actor_control
 cases.append(dict(character_radius=radius,flat=flat,percent=.75,tag=tag,primary_position=[500.,66.,800.],secondary_position=position,opaque_ids=[12345,678],words={hex(o):read32(source_object+o) for o in [4,8,0xc,0x10,0x14,0x18,0x1c,0x20,0x24,0x28,0x2c,0x30,0x60,0x64]},provider_retained=True,provider_weak_delta=1,source_strong=read32(source_control+4),source_weak=read32(source_control+8),applied=bool(u.mem_read(source_object+0x44,1)[0]),dirty=bool(u.mem_read(source_object+0x45,1)[0]),obstruction=bool(u.mem_read(source_object+0x68,1)[0])))
 u.mem_write(head,bytes(64));u.mem_write(head+0xd,bytes([1]));write32(head+4,head);write32(manager+0x1c,head);write32(0x2d5f468,77)
 invoke(0x6b1f90,manager,struct.pack('<I',entries));assert read32(actor_control+8)==10 and source_object in frees
 invoke(0x585aa0,actor+0x2294);assert source_control in frees and read32(source_control+8)==0
 cases[-1]['provider_weak_delta_after_removal']=read32(actor_control+8)-10;cases[-1]['source_deallocation_requested']=True;cases[-1]['control_deallocation_requested']=True
assert {0x601110,0x617340,0x600f60,0x5fffd0,0x6b1b20,0x6b0790,0x5ed740}.issubset(visited)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x649040',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0xc975f5,0x617ab0}),cases=cases,fields=dict(first_identity='actor+0xfc via601110 interface+128',second_identity='descriptor(actor+17c)+34 via617340 interface+3d8',source_reference='actor+2294/2298',provider_reference='actor+f4/f8 via5ED740',initial_radius='characterRadius*(flat+1)+flat; flat=actor778; actor77C ignored here'),limits=['Whole649040entry/return executes original identity getters, secondary position provider, circle factory, non-null weak provider constructor and weak output assignment.617AB0 pre-initialization boundary skipped; original actor/provider/CharacterData constructors not executed.','Allocator/free boundaries adapted; source manager capacity, actor/descriptor/character fields and retained provider controls supplied.','Original source stamp uses14CD324 and native flags64/65 differ from base constructor; semantic roles and ordinary lifecycle not yet qualified. No gameplay/GPU activation.'])
(r/'data/4.20/fow_ai_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],first=cases[0])))
