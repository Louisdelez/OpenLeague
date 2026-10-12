from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_media)','media_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_media)');exec(compile(s,'setup','exec'));local=[(0xb1eed0,0xb1ef4e),(0xb100f0,0xb14000),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4),(0xb3df60,0xb3df96),(0xb3e100,0xb3e1a5),(0xb3e1d0,0xb3e1f2)];regions.extend(local);rtpc=heap+0xe000;record=heap+0x9c00;parameter=heap+0x8000;point=heap+0x9800;allocator_table=heap+0x7900;rows=[]
put(0x121023c,'I',allocator_table);put(allocator_table+4,'I',trap+0x800)
def guard_producer(uc,a,n,d):
 if a==trap+0x800:
  size=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];assert size==32;u.mem_write(parameter,bytes([pattern])*size);allocations.append({'reference':parameter,'size':size,'freed':False});calls.append({'kind':'allocate','method':'virtual','allocator':u.reg_read(UC_X86_REG_ECX),'size':size,'reference':parameter});ret(parameter,4);return
 if any(lo<=a<hi for lo,hi in local):return
 guard_media(uc,a,n,d)
u.hook_del(media_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_producer)
notifications=[]
def trace_meter_notification(uc,a,n,d):
 if a==0xb3e100:
  sp=u.reg_read(UC_X86_REG_ESP);identifier,pointer,length=read(sp+4,'3I');event={'kind':'meter_set_parameter','reference':u.reg_read(UC_X86_REG_ECX),'id':identifier,'bits':read(pointer,'I')[0],'length':length};notifications.append(event);calls.append(event)
u.hook_add(unicorn.UC_HOOK_CODE,trace_meter_notification)
for pattern,param,owner,curve_count,scenario in itertools.product([0,0xa5],[0,1,4],[0,77],[1,2],['equal','signed_zero','local_then_global','allocation_fail']):
 calls.clear();allocations.clear();next_pointer=heap+0xa000;count_allocate=0;fail_nth=0;u.mem_write(rtpc,bytes(0x920));u.mem_write(record,bytes(40));put(record,'3I',123,0,0x41c80000);put(rtpc+(123%193)*4,'I',record);put(rtpc+0x304,'I',1);put(point,'ffIffI',0.,1.,4,100.,2.,4);assert invoke(0xb3df60,[0x121023c],0)==parameter
 def snapshot():return {'rtpc':bytes(u.mem_read(rtpc,0x920)).hex(),'record':bytes(u.mem_read(record,40)).hex(),'parameter':bytes(u.mem_read(parameter,32)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations]}
 before=snapshot();calls.clear();notifications.clear();result=invoke(0xb124e0,[parameter,123,param,500,0,point,2,owner,0],rtpc);assert result==1
 if curve_count==2:
  put(point,'ffIffI',0.,2.,4,100.,4.,4);assert invoke(0xb124e0,[parameter,123,param,501,0,point,2,owner+99,0],rtpc)==1
 registered=snapshot();registration_calls=list(calls);calls.clear();notifications.clear();transition=heap+0x9a00;put(transition,'2I',0,4);steps=[]
 operations={'equal':[(owner,0x41c80000,0),(owner,0x41c80000,0)],'signed_zero':[(owner,0x80000000,0),(owner,0,0)],'local_then_global':[(77,0x42c80000,0),(0,0,0),(77,0x41c80000,0)],'allocation_fail':[(owner,0x42c80000,1)]}[scenario]
 for set_owner,bits,failure in operations:
  fail_nth=failure;count_allocate=0;setter_result=invoke(0xb12320,[123,bits,set_owner,transition,1],rtpc);steps.append({'set_owner':set_owner,'bits':bits,'failure_nth':failure,'result':setter_result,'after':snapshot(),'calls':list(calls),'notifications':list(notifications)});calls.clear();notifications.clear()
 invoke(0xb12e20,[parameter],rtpc);after=snapshot();assert read(rtpc+0x918,'I')[0]==0
 rows.append({'pattern':pattern,'param':param,'owner':owner,'curve_count':curve_count,'scenario':scenario,'before':before,'registered':registered,'registration_calls':registration_calls,'steps':steps,'after':after,'calls':list(calls)})

proof={'passed':True,'complete':False,'case_count':len(rows),'step_count':sum(len(row['steps'])for row in rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Physical allocation/free/mutex/memcpy plus passive native B3E100 entry tracing in ordered calls. SetParam body executes unchanged; no notification shim. Native Meter parameter creator,B124E0 registration,B12320 raw setter and subscriber-owner filtering/notification/native SetParam,B12E20 subscriber release execute. No logical subscription/notification/removal shim.'],'limits':['Global RTPC manager/record seeded in verified layout;normal manager/record registration,owned record destruction,parameter Term/voice composition and Rust producer/replay remain required. Retained reverse-vector allocation belongs to global record,parameter allocation remains live.']}
(r/'data/4.20/audio_rtpc_meter_setter_repeated_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native repeated Meter setters/equality/signed-zero/owner masking/pre-storage failure sequences')
