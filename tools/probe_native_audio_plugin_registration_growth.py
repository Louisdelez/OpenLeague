from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x1000;new=heap+0x2000;calls=[];failure=False
regions=[(0xb09590,0xb09606),(0xb09610,0xb096a6),(0xaf95a0,0xaf9623)]
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool,size=read(sp+4,'II');calls.append({'kind':'allocate','allocator':pool,'size':size,'reference':0 if failure else new});ret(0 if failure else new,0);return
 if a==0xada3e0:
  pool,ref=read(sp+4,'II');calls.append({'kind':'free','allocator':pool,'reference':ref});ret(0,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for direct,kind,company,id,profile,creators,full,fail in itertools.product([False,True],[0,3,31],[0,65535],[0,129,0xffffffff],['empty','duplicate','other'],[(0,0),(0x1000,0),(0,0x2000),(0x1000,0x2000)],[False,True],[False,True]):
 failure=fail;packed=((((id<<12)+company)<<4)+(kind&15))&0xffffffff;entries=[]if profile=='empty'else[(packed if profile=='duplicate'else packed^0x10000000,0x3333,0x4444)]
 capacity=len(entries)if full else 8
 u.mem_write(table,b'\xa5'*96);u.mem_write(new,b'\xcc'*96)
 for i,e in enumerate(entries):put(table+i*12,'III',*e)
 put(0x14a7abc,'III',table,len(entries),capacity);put(0x12100dc,'I',0xffffffff);before=bytes(u.mem_read(table,96)).hex();calls.clear();sp=stack+0x8000
 if direct:put(sp,'IIII',trap,packed,*creators);u.reg_write(UC_X86_REG_ECX,0x14a7abc);address=0xb09610
 else:put(sp,'IIIIII',trap,kind,company,id,*creators);address=0xb09590
 u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(address,trap,count=2000);assert u.reg_read(UC_X86_REG_EIP)==trap
 pointer,count,cap=read(0x14a7abc,'III')
 rows.append({'direct':direct,'kind':kind,'company':company,'id':id,'packed_id':packed,'creators':creators,'failure':fail,'capacity_before':capacity,'count_before':len(entries),'before':before,'old_after':bytes(u.mem_read(table,96)).hex(),'new_after':bytes(u.mem_read(new,96)).hex(),'pointer_after':pointer,'count_after':count,'capacity_after':cap,'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Only physical pool allocation ADA670 and free ADA3E0 are boundaries. Actual AF95A0 growth copies ordered 12-byte entries, frees old allocation and publishes new pointer/capacity.'],'limits':['Controlled non-null old table,small valid counts/capacities; allocation/free errors and arithmetic overflow not qualified. Complete builtin registrations and normal HIRC resource path remain open.']}
(r/'data/4.20/audio_plugin_registration_growth_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual registration/insertion/growth cases')
