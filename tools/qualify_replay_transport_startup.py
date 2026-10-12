from pathlib import Path
import itertools,json,sys
root=Path('E:/OpenLeague');local=Path(__file__).parent
source=local/'probe_replay_transport_threads.py'
if not source.exists():source=root/'tools/probe_replay_transport_threads.py'
exec(compile(source.read_text().split('\nstream=call(')[0],str(source),'exec'))
addresses=[0x2d78f04,0x2d78f10,0x2d78f0c,0x2d78f08,0x2d78f14,0x2d78efc,0x2d78f18,0x1225878,0x122587c]
events=[];recording=False
class Events(list):
 def append(self,value):
  super().append(value)
  if recording:events.append(value.copy())
network_events=Events()
def observe(uc,pc,size,user):
 if not recording:return
 if pc in [0x9941b0,0x994210]:events.append({'op':'lock' if pc==0x9941b0 else 'unlock','address':u.reg_read(UC_X86_REG_ECX)})
 if pc==0x8f92b0:
  sp=u.reg_read(UC_X86_REG_ESP);assert read32(sp+8)==0 and read32(sp+12)==0
  events.append({'op':'log','logger':u.reg_read(UC_X86_REG_ECX),'message':cbytes(read32(sp+4)).decode('ascii')});finish(pop=12)
def observe_write(uc,access,address,size,value,user):
 if recording and address in addresses:
  assert size==4;events.append({'op':'write','address':address,'value':value&0xffffffff})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
u.hook_add(unicorn.UC_HOOK_MEM_WRITE,observe_write)
call(0x901a70,0,[]);logger=read32(0x2d78ec4)
def prepare(refs,status,seed):
 global recording
 recording=False
 for index,address in enumerate(addresses):write32(address,(seed+index*0x1010101)&0xffffffff)
 write32(0x2d78f10,refs);write32(0x2d78f04,status);events.clear();network_events.clear()
 before=[read32(p) for p in addresses];recording=True;return before
def after():
 global recording
 recording=False;return {'words':[read32(p) for p in addresses],'events':list(events)}
profiles=[{'startup_code':0,'version':0x202,'cleanup_code':0,'begin_code':0,'end_code':0},
 {'startup_code':10091,'version':0x202,'cleanup_code':0,'begin_code':0,'end_code':0},
 {'startup_code':0,'version':0x201,'cleanup_code':0xffffffff,'begin_code':0,'end_code':0},
 {'startup_code':0,'version':0x102,'cleanup_code':0,'begin_code':0,'end_code':0},
 {'startup_code':0,'version':0xabcd0202,'cleanup_code':0xffffffff,'begin_code':97,'end_code':97}]
workers=[]
for refs,status,profile in itertools.product([0,1,0xfffffffe,0xffffffff],[0,3],profiles):
 network_profile=profile.copy();before=prepare(refs,status,0xa5a5a5a5);call(0x8fc100,0,[])
 workers.append({'before':before,'profile':profile,'after':after()})
shutdowns=[]
for refs,status,seed,failures in itertools.product([0,1,2,0xffffffff],[1,2],[0,0xa5a5a5a5],[False,True]):
 network_profile={'startup_code':0,'version':0x202,'cleanup_code':0xffffffff if failures else 0,'begin_code':0,'end_code':97 if failures else 0}
 before=prepare(refs,status,seed);call(0x8fc500,0,[])
 shutdowns.append({'before':before,'profile':network_profile.copy(),'after':after()})
network=[]
for profile in profiles:
 network_profile=profile.copy();before=prepare(0,0,0);code=call(0x900e00,0,[]);network.append({'profile':profile,'result':code,'before':before,'after':after()})
proof={'passed':True,'complete':False,'native_sha256':digest,'addresses':addresses,'logger':logger,'failure_message':cbytes(0x10d5cbc).decode('ascii'),'shutdown_format':cbytes(0x10d5d98).decode('ascii'),'workers':workers,'shutdowns':shutdowns,'network':network,'limits':[
 'Actual8FC100,900E00 and8FC500 bodies execute with explicit global words and supplied Winsock/timer outcomes. Memory writes, engine mutex ordering and logging arguments are captured.5 network profiles,40 worker cases and32 releases include mismatch, API errors, existing references and32-bit wraparound.',
 'Native logger initialization executes before the cases. Only terminal8F92B0 logging is captured at its documented ABI; formatting before that call is native.9941B0/994210 remain supplied normal-return mutex boundaries. No concurrency, socket I/O, replay event delivery or full-game completion is claimed.'
]}
assert any(e['op']=='lock' for e in workers[0]['after']['events'])
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'worker_cases':len(workers),'shutdown_cases':len(shutdowns),'network_cases':len(network),'failure_message':proof['failure_message'],'shutdown_format':proof['shutdown_format'],'first_worker':workers[0],'last_shutdown':shutdowns[-1]}))
