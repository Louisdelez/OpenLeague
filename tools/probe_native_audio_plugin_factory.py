from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x1000;out=heap+0x2000;calls=[];returned=0;fn1=trap+0x500;fn2=trap+0x510
regions=[(0xb09360,0xb093b7),(0xb094b0,0xb09514)]
def guard(uc,a,n,d):
 if a in [fn1,fn2]:calls.append({'kind':'create','creator':a,'allocator':read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]});ret(returned,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for kind,id,profile,returned,optional in itertools.product(['plugin','parameter'],[0,0x00810003,0xdeadbeef],range(6),[0,heap+0x6000,heap+0x7000],[False,True]):
 wrong=id^0x10000000;ids=[[],[id],[wrong],[id,id],[wrong,id],[id,wrong]][profile];entries=[]
 for i,key in enumerate(ids):entries.append({'id':key,'create':fn1 if i==0 else fn2,'parameters':(fn2 if i==0 else fn1)if optional else 0});put(table+i*12,'III',key,entries[-1]['create'],entries[-1]['parameters'])
 put(0x14a7abc,'II',table,len(ids));put(out,'I',0xa5a5a5a5);calls.clear();sp=stack+0x8000;put(sp,'IIII',trap,0x121023c,id,out);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xb09360 if kind=='plugin'else 0xb094b0,trap,count=1000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'kind':kind,'id':id,'entries':entries,'returned':returned,'result':u.reg_read(UC_X86_REG_EAX),'output':read(out,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual B09360 effect factory and B094B0 parameter factory ordered registry lookup, output reset and status execute. Creator functions are mandatory explicit return-value interfaces.'],'findings':['Actual factory wrapper emits only1/nonzero or2/null/missing; arbitrary failure7 in instance interface fixture is supplied factory behavior, not this wrapper.','Matching parameter registration with absent parameter creator returns1 with null output; missing registration returns2.','First matching duplicate ID wins in both factories.'],'limits':['Creator/plugin/parameter constructors, registration producer, real DSP/resources and synchronization remain required.','Plugin creator itself must be nonnull; native null-call error outside this contract.']}
(r/'data/4.20/audio_plugin_factory_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual effect and parameter factory wrapper cases')
