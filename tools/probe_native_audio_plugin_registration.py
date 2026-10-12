from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x1000;calls=[];regions=[(0xb09590,0xb09606),(0xb09610,0xb096a6)]
def guard(uc,a,n,d):
 if a==0xaf95a0:calls.append({'kind':'grow_failure','registry':u.reg_read(UC_X86_REG_ECX),'increment':read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]});ret(0,4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for kind,company,id,profile,creators,full in itertools.product([0,3,31],[0,65535],[0,129,0xffffffff],['empty','duplicate','other'],[(0,0),(0x1000,0),(0,0x2000),(0x1000,0x2000)],[False,True]):
 packed=((((id<<12)+company)<<4)+(kind&15))&0xffffffff;entries=[]if profile=='empty'else[(packed if profile=='duplicate'else packed^0x10000000,0x3333,0x4444)];u.mem_write(table,b'\xa5'*96)
 for i,e in enumerate(entries):put(table+i*12,'III',*e)
 put(0x14a7abc,'III',table,len(entries),len(entries)if full else 8);before=bytes(u.mem_read(table,96)).hex();calls.clear();sp=stack+0x8000;put(sp,'IIIIII',trap,kind,company,id,*creators);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xb09590,trap,count=1000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'kind':kind,'company':company,'id':id,'packed_id':packed,'profile':profile,'creators':creators,'full':full,'count_before':len(entries),'count_after':read(0x14a7ac0,'I')[0],'before':before,'after':bytes(u.mem_read(table,96)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual registration B09590 and no-growth insertion B09610 execute; capacity growth is explicit failure interface AF95A0.'],'findings':['Packed ID is wrapping (((id<<12)+company)<<4)+(type&15), company not masked separately.','Duplicate packed ID returns2 before validating creators; missing either creator returns31.','Valid new registration appends id/effect/parameter triple; capacity-growth failure returns2 without entry/count mutation.'],'limits':['Preparatory producer evidence; no Rust registration port yet.','Successful capacity reallocation, allocator ownership, initialization of complete native registrations and concurrent lifetime remain open.']}
(r/'data/4.20/audio_plugin_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual plugin registration/insertion cases')
