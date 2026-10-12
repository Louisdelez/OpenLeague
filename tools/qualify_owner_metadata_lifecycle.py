from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_control_factory.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_control_factory.py'),'exec'))
def callback_allocation(uc,address,size,user):
 global cursor
 if address==0xc9f39b:
  sp=u.reg_read(UC_X86_REG_ESP);count=read32(sp+4);pointer=cursor;cursor+=(count+31)&~15;u.mem_write(pointer,bytes([poison])*count);allocations.append({'bytes':count,'pointer':pointer,'allocator':'callback_clone_new'});finish(eax=pointer)
u.hook_add(unicorn.UC_HOOK_CODE,callback_allocation)
cases=[]
for poison,actor_arg,owner_arg,global_value,flags in itertools.product([0,165],[0,heap+0x4000],[0,heap+0x5600],[0,0x3f800000,0xffffffff],[0,1,256,257]):
 cursor=arena;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d787b8,0);write32(0x123b12c,global_value);fail=False;allocations.clear();freed.clear();metadata=call(0x9933e0,0,[56]);result=call(0x6b26f0,metadata,[actor_arg,owner_arg]);assert result==metadata
 constructed=[[metadata+i,read32(metadata+i)] for i in range(0,56,4)];handler_words=[]
 for offset in [4,12,20,28]:
  handler=read32(metadata+offset);assert handler!=0;handler_words.extend([[handler+i,read32(handler+i)] for i in [0,4,8]])
 constructor_allocations=list(allocations);constructor_freed=list(freed);scalar=read32(0x10a0384);allocations.clear();freed.clear();returned=call(scalar,metadata,[flags]);assert returned==metadata and (metadata in freed)==bool(flags&1)
 cases.append({'poison':poison,'actor_argument':actor_arg,'owner_argument':owner_arg,'global_value':global_value,'flags':flags,'metadata':metadata,'scalar_destructor':scalar,'constructor_allocations':constructor_allocations,'constructor_freed':constructor_freed,'constructed_words':constructed,'handler_words':handler_words,'destructor_freed':list(freed),'destructor_allocations':list(allocations),'result':returned,'live_words':[[metadata+i,read32(metadata+i)] for i in range(0,56,4)] if not flags&1 else []})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual6B26F0 metadata constructor, four native listener-base constructors, native callback clone/scalar delete and real10A0384 metadata scalar destructor execute in96 lifetimes.56-byte metadata allocation, handler construction/disposal, exact padding/field widths, borrowed actor/owner arguments, global default field and scalar free flag validated. No metadata/listener helper-result adapters.','Native game-service manager2D787B8 explicitly absent. Allocator startup flag2D77B20 preconfigured1 with default clone allocator14BEF58=0; engine allocator startup remains open. Service-present listener registration/unregistration and callback delivery remain required. Malloc/free/atexit and C9F39B operator-new primitive supplied. No post-free metadata snapshot retained; exceptions, live ownership and game-event integration remain open.']}
(root/'data/4.20/audio_announcer_owner_metadata_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_metadata_lifetimes':len(cases),'native_metadata_scalar_destructor':cases[0]['scalar_destructor'],'passed':True}))
