"""Actual57D650 + actual72AD90/728410/729EC0/729730/8F8CF0, empty name.
No service-name, resolver, record-tree or loading-consumer return is supplied.
"""
from pathlib import Path
import sys,json,hashlib,itertools,traceback
ROOT=Path('E:/OpenLeague');OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
exec(compile((ROOT/'tools/probe_replay_metadata.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'metadata native prerequisites','exec'))
OUT=Path('E:/mapslol3v3/loading_standard_empty_agent')
DIAG=0x36000000
assert all(DIAG+0x10000<=lo or DIAG>hi for lo,hi,_ in u.mem_regions())
u.mem_map(DIAG,0x10000)
RECIP=DIAG+0x100;SERVICE=DIAG+0x1000;PACKET=DIAG+0x2000;COMMAND=DIAG+0x2100;STRING=DIAG+0x2200;TEXT=DIAG+0x2300
active_consumer=False;steps_events=[];executed=set();output_ptr=None;record_ptr=None;record_before=None
CHAIN=[0x57d650,0x5be170,0x72ad90,0x729c80,0x728410,0x729ec0,0x729730,0x738ac0,0x8f8cf0]
FORBIDDEN=[0x57d6fe,0x72ae40,0x90ad00,0x57c590,0x98a7f0,0x815cf0,0x5ce3a0,0x98f2f0,0x9879d0,0x78d0d0,0x8b0630,0x993ce0]
FORBIDDEN_RANGES=[(0x14c7630,0x14c7eac),(0x2d78f1c,0x2d78f20),(0x2d7855c,0x2d78560),(0x2d79050,0x2d79058),(RECIP+0x1a0,RECIP+0x1d9)]
def observe(uc,pc,size,user):
 global output_ptr,record_ptr,record_before
 if not active_consumer:return
 executed.add(pc);assert pc not in FORBIDDEN,('unexpected UI/clock branch',hex(pc))
 if pc in CHAIN:
  event={'op':'call','method':pc,'this':u.reg_read(UC_X86_REG_ECX)}
  if pc==0x72ad90:
   sp=u.reg_read(UC_X86_REG_ESP);output_ptr=read32(sp+4);event.update(output=output_ptr,key=read32(sp+8))
  steps_events.append(event)
 if pc==0x57d6a6:
  record_ptr=u.reg_read(UC_X86_REG_EAX);record_before=bytes(u.mem_read(record_ptr,120));steps_events.append({'op':'record_ready','pointer':record_ptr,'before_hex':record_before.hex()})
 if pc==0x57d6e8:
  assert output_ptr is not None and read32(output_ptr+16)==0 and read32(output_ptr+20)==15
  steps_events.append({'op':'provider_return','output':output_ptr,'hex':bytes(u.mem_read(output_ptr,24)).hex()})
 if pc==0x57dcae:steps_events.append({'op':'caller_string_cleanup','pointer':output_ptr})
 if pc==0x57dce6:steps_events.append({'op':'caller_epilogue'})
def access(uc,typ,p,n,value,user):
 if not active_consumer:return
 if typ==unicorn.UC_MEM_READ:
  assert not any(p<hi and p+n>lo for lo,hi in FORBIDDEN_RANGES),('unexpected first UI dependency read',hex(p),hex(u.reg_read(UC_X86_REG_EIP)))
 if (record_ptr is not None and record_ptr<=p<record_ptr+120) or (output_ptr is not None and output_ptr<=p<output_ptr+24):
  steps_events.append({'op':'read' if typ==unicorn.UC_MEM_READ else 'write','pointer':p,'bytes':n,'value':int.from_bytes(u.mem_read(p,n),'little') if typ==unicorn.UC_MEM_READ else value})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,access)
profiles=[('present_empty',73,0xdeadbeef,0x80000000,True,True),('present_missing_metadata',0xffffffff,1,2,True,False),('missing_all',0x80000000,0,0,False,False),('missing_zero_empty',9000,0,0,False,True)]
cases=[]
try:
 for fill,cached_long,(profile,identifier,low,high,add_object,add_name) in itertools.product([0,165],[False,True],profiles):
  poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear();write32(0x14bef40,0);write32(0x14bef58,0)
  u.mem_write(DIAG,bytes([fill])*0x10000)
  parent=call(0x9933e0,0,[68]);call(0x728e20,parent,[]);write32(0x2d78520,parent);assert call(0x728fd0,parent,[])&255==1
  nested=read32(parent+0x30);index=call(0x9933e0,0,[48]);call(0x8f8810,index,[]);call(0x9019a0,nested+0x6c,[index])
  index_control=read32(nested+0x70);metadata=read32(parent+0x34);metadata_control=read32(parent+0x38)
  if add_object:
   u.mem_write(COMMAND,b'\0');write32(COMMAND+4,identifier);write32(COMMAND+8,low);write32(COMMAND+12,high);assert call(0x72c780,0,[0,0,0,0,COMMAND])&255==1
  write32(STRING+16,0);write32(STRING+20,15);u.mem_write(STRING,b'\0')
  if add_name:call(0x7285b0,metadata,[low,high,STRING,0x12345678])
  if cached_long:
   data=b'Old cached metadata name kept on its real heap buffer';u.mem_write(TEXT,data+b'\0');call(0x564c20,metadata+0x1b0,[TEXT,len(data)])
  # Source tree constructor snippet only; full UI recipient factory is not run.
  write32(RECIP,0x1084ea4);u.reg_write(UC_X86_REG_ESI,RECIP);u.reg_write(UC_X86_REG_ESP,stack+0xe000)
  u.emu_start(0x57ce5c,0x57ce72,count=50000);assert u.reg_read(UC_X86_REG_EIP)==0x57ce72
  write32(SERVICE,0x10afe8c);write32(0x2d787b8,SERVICE)
  prepared=capture();steps=[]
  for flags in [0,1,128,255]:
   payload=bytearray((j*37+flags)&255 for j in range(25));payload[:4]=identifier.to_bytes(4,'little');payload[24]=flags;u.mem_write(PACKET,bytes(payload))
   steps_events.clear();output_ptr=None;record_ptr=None;record_before=None
   counts_before=[read32(index_control+4),read32(metadata_control+4)];cached_before=bytes(u.mem_read(metadata+0x1b0,24))
   active_consumer=True
   try:call(0x57d650,RECIP,[PACKET])
   finally:active_consumer=False
   assert record_ptr and record_before is not None and output_ptr
   expected=bytearray(record_before);expected[:25]=payload
   if flags&1:expected[16:20]=bytes(4)
   observed=bytes(u.mem_read(record_ptr,120));assert observed==expected
   assert bytes(u.mem_read(PACKET,25))==payload and read32(record_ptr+0x40)==0
   counts_after=[read32(index_control+4),read32(metadata_control+4)];assert counts_before==counts_after==[1,1]
   assert read32(metadata+0x1b0+16)==0 and not freed
   if cached_long:assert read32(metadata+0x1b0)==int.from_bytes(cached_before[:4],'little') and read32(metadata+0x1b0+20)==int.from_bytes(cached_before[20:24],'little')
   methods=[e['method'] for e in steps_events if e['op']=='call'];assert all(a in methods for a in CHAIN)
   cleanup_i=next(i for i,e in enumerate(steps_events) if e['op']=='caller_string_cleanup');assert steps_events[cleanup_i+1]['op']=='read' and steps_events[cleanup_i+1]['pointer']==output_ptr+20 and steps_events[cleanup_i+1]['value']==15
   assert steps_events[-1]['op']=='caller_epilogue'
   after=capture();assert [e['op'] for e in after['lock_events']]==['enter','leave']
   steps.append({'flags':flags,'payload_hex':payload.hex(),'record':record_ptr,'record_before_hex':record_before.hex(),'record_after_hex':observed.hex(),'temporary_string':output_ptr,'temporary_string_hex':bytes(u.mem_read(output_ptr,24)).hex(),'reference_counts_before':counts_before,'reference_counts_after':counts_after,'events':list(steps_events),'state':after})
  call(0x57d1e0,RECIP+0x1c,[]);call(0x728ea0,parent,[1]);shutdown=capture();assert not live,live
  cases.append({'fill':fill,'cached_long':cached_long,'profile':profile,'identifier':identifier,'parent':parent,'nested':nested,'metadata':metadata,'index':index,'recipient':RECIP,'service_diagnostic':SERVICE,'prepared':prepared,'steps':steps,'shutdown':shutdown})
 proof={'passed':True,'complete':False,'native_sha256':digest,'native_consumer_executed':True,'native_provider_executed':True,'native_resolver_executed':True,'provider_or_resolver_result_simulated':False,'cases':cases,'executed_instruction_addresses':sorted(executed),'forbidden_entries':FORBIDDEN,'forbidden_read_ranges':FORBIDDEN_RANGES,'limits':['Actual57D650 calls real service72AD90, metadata728410, resolver729EC0/729730, index8F8CF0. Empty names arise from actual empty metadata rows or real missing lookups, not substituted return values.','Parent/metadata/index constructors, control producer9019A0 and optional object72C780/text7285B0 producers execute. Standard record header uses original57CE5C..57CE72 snippet and nodes use actual5BE170. Full UI recipient/service factories and normal stream-opening producer are not exercised.','Existing single-thread Win32 lock/engine allocation/memory-copy primitives inherited from loading_metadata_review composition are supplied. No UI/category/resource/clock entry or dependency read is allowed during the consumer.','Empty output always has SSO capacity15: cleanup order and no-free path are observed. The retained heap-backed metadata cache is released during complete native parent shutdown; this does not exercise heap-backed empty consumer output.','No Windows adapter, Rust compile, renderer, asset loader, networking or visible UI is qualified.']}
except Exception as problem:
 traceback.print_exc();proof={'passed':False,'complete':False,'native_sha256':digest,'error':repr(problem),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'cases':cases,'last_events':steps_events[-40:]}
(OUT/'standard_empty_name_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
summary={'passed':proof['passed'],'lifetimes':len(cases),'consumer_calls':sum(len(c['steps']) for c in cases),'events':sum(len(s['events']) for c in cases for s in c['steps']),'provider_or_resolver_result_simulated':False}
(OUT/'native_result.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary))
if not proof['passed']:sys.exit(1)
