from pathlib import Path
import json,itertools,sys
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_owner_metadata_lifecycle.py').read_text().split('\ncases=[]')[0]
exec(compile(source,'native shared pair prerequisites','exec'))
destination=heap+0xa000;source_pair=heap+0xa010;first_control=heap+0xa100;second_control=heap+0xa200
events=[];mutate=False;shared_vt=heap+0xa300
def boundary(uc,address,size,user):
 if address not in [end+0x8000,end+0x8100]:return
 p=u.reg_read(UC_X86_REG_ECX)
 events.append({'op':'dispose' if address==end+0x8000 else 'release','control':p,'strong':read32(p+4),'weak':read32(p+8)})
 if mutate and address==end+0x8000:write32(source_pair,0xfefefefe);write32(source_pair+4,0)
 finish()
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
write32(shared_vt,end+0x8000);write32(shared_vt+4,end+0x8100)
def snapshot():return [[p+i,read32(p+i)] for p,n in [(destination,8),(source_pair,8),(first_control,12),(second_control,12)] for i in range(0,n,4)]
def setup(strong,weak):
 events.clear()
 for p in [first_control,second_control]:write32(p,shared_vt);write32(p+4,strong);write32(p+8,weak)
cases=[]
for strong,weak,new,old,alias,mutate in itertools.product([0,1,2,0xffffffff],[0,1,2],[0,first_control],[0,first_control,second_control],[False,True],[False,True]):
 setup(strong,weak);write32(destination,0x1234);write32(destination+4,old);write32(source_pair,0x87654321);write32(source_pair+4,new)
 src=destination if alias else source_pair;before=snapshot();call(0x5cc070,destination,[src]);copied=snapshot();copy_events=list(events);events.clear();call(0x5bd3c0,destination,[])
 cases.append({'strong':strong,'weak':weak,'new':new,'old':old,'alias':alias,'mutate':mutate,'source':src,'before':before,'copied':copied,'copy_events':copy_events,'destroyed':snapshot(),'destroy_events':list(events)})
accessors=[];manager=heap+0xb000;nested=heap+0xb100
for strong,weak,present,obj,ctrl in itertools.product([0,1,0xffffffff],[0,1,2],[False,True],[0,0x1234],[0,first_control]):
 setup(strong,weak);write32(manager+0x30,nested if present else 0);write32(nested+0x6c,obj);write32(nested+0x70,ctrl);write32(destination,0xaaaaaaaa);write32(destination+4,0xbbbbbbbb)
 result=call(0x729cf0,manager,[destination]);assert result==destination
 accessors.append({'strong':strong,'weak':weak,'present':present,'object':obj,'control':ctrl,'result':result,'pair':[read32(destination),read32(destination+4)],'counts':[read32(first_control+4),read32(first_control+8)],'events':list(events)})
proof={'passed':True,'complete':False,'native_sha256':digest,'destination':destination,'source':source_pair,'controls':[first_control,second_control],'vtable':shared_vt,'manager':manager,'nested':nested,'cases':cases,'accessors':accessors,'limits':['Actual5CC070,5BD3C0,729CF0 and738AC0 run including native lockedXADD. Terminal control disposal/release are explicit recording boundaries retaining bytes, optionally mutating source pair; no shared pair/helper return adapters. Self/alias copy and counter wrap are qualified normal-return preconditions, not claims of validity of arbitrary runtime ownership.','Accessor output must be fresh storage; native overwrites old bytes without release. Real actor/world lifetimes, control-specific virtual methods, object-manager trees, threads inside native emulator, exceptions and unwind remain separate requirements.']}
out=Path(sys.argv[1]) if len(sys.argv)>1 else root/'data/4.20/replay_shared_pair_contract.json';out.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'shared_pair_lifetimes':len(cases),'accessors':len(accessors)}))
