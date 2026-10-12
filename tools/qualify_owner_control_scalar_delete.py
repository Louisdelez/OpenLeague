from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_control_factory.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_control_factory.py'),'exec'))
custom=end+0xf00;context=heap+0xd000;routes=[]
def custom_free(uc,address,size,user):
 if address==custom:
  sp=u.reg_read(UC_X86_REG_ESP);pointer=read32(sp+4);ctx=read32(sp+8);assert ctx==context;freed.append(pointer);routes.append({'pointer':pointer,'context':ctx});finish()
u.hook_add(unicorn.UC_HOOK_CODE,custom_free)
cases=[]
for poison,flags,custom_route in itertools.product([0,165],[0,1,2,3,255,256,257,258,0xffffffff],[False,True]):
 cursor=arena;write32(0x14bef40,0);write32(0x14bef44,context);write32(pair,0);write32(pair+4,0);fail=False;call(0x5d1fa0,pair,[heap+0x7000]);selected=read32(pair+4)
 allocations.clear();freed.clear();routes.clear();write32(0x14bef40,custom if custom_route else 0);result=call(0x5d6840,selected,[flags]);assert result==selected and freed==([selected] if flags&1 else []) and read32(selected)==0x107c834
 cases.append({'poison':poison,'flags':flags,'custom_free':custom_route,'control':selected,'result':result,'freed':list(freed),'custom_routes':list(routes),'live_words':[[selected+i,read32(selected+i)] for i in [0,4,8,12]] if not freed else []})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual5D6840 scalar control delete executes on native5D1FA0 controls in36 cases, returning original label, rewriting header to107C834, freeing only flags bit0, and selecting standard/custom free after header write. Wide flag values verify low-byte behavior.','Malloc/free/custom callback supplied; no post-free control snapshots retained. Object disposal is a separate virtual function. Exceptions and live concurrency remain open.']}
(root/'data/4.20/audio_announcer_owner_control_scalar_delete_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_scalar_delete_cases':len(cases),'passed':True}))
