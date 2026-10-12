from pathlib import Path
import itertools,json,sys,types
source=Path(__file__).with_name('probe_replay_recording_file.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(source,'file path registration prerequisites','exec'))
previous_path_boundary=types.FunctionType(boundary.__code__,globals());host_calls=[];path_calls=[]
def path_boundary(uc,address,size,user):
 if address==0x8fd6a0:
  host_calls.append({'function':address,'supplied_result':0});finish(eax=0);return
 if address in [0x8c59f0,0x8c5a50,0x8c5e90,0x8c5bb0]:path_calls.append({'function':address,'this':u.reg_read(UC_X86_REG_ECX)})
 return previous_path_boundary(uc,address,size,user)
boundary.__code__=path_boundary.__code__
cases=[]
try:
 for poison,mode in itertools.product([0,165],[0,1]):
  profile=2;write_result=0;close_result=0;network_profile['startup_code']=0
  write32(0x2d78f04,0);write32(0x2d78f10,0);write32(0x2d78ec4,0);write32(0x2d8bab4,0);u.mem_write(0x2d78ec1,b'\0\0');snapshot();baseline=set(live)
  events.clear();host_calls.clear();path_calls.clear();stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);initial=snapshot()
  path=heap+0xc000;key=heap+0xd000;host=heap+0xd100
  u.mem_write(path,b'E:/OpenLeague/logs/supplied-stream-file.txt\0');u.mem_write(key,bytes(range(16)));u.mem_write(host,b'127.0.0.1\0')
  result=scheduled_call(0x8f68d0,stream,[0,1,0,key,host,12345,mode,0,0,path,1]);assert result==0
  opened=snapshot();singleton_hex=bytes(u.mem_read(0x2d8bac0,0x10a8)).hex();resource=read32(stream+0x30)
  started=scheduled_call(0x8f6af0,stream,[1,2,3,4,5,6]);assert started==(0 if mode else 6)
  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot()
  assert read32(0x2d78f10)==0
  call(0x901c00,0,[]);call(0x8c5bb0,0,[]);shutdown=snapshot();assert set(live)==baseline,sorted(set(live)-baseline)
  cases.append({'fill':poison,'mode':mode,'stream':stream,'resource':resource,'initial':initial,'opened':opened,'singleton_hex':singleton_hex,'start_code':started,'destroyed':destroyed,'shutdown':shutdown,'file_events':list(events),'path_calls':list(path_calls),'host_calls':list(host_calls)})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Four full native opening/start/active-destruction lifetimes with nonnull diagnostic filename, actual8C59F0/8C5A50/8C5E90 default pathname-registration singleton and8C5BB0 teardown. Source recording resource writes use explicit supplied CRT I/O outcomes.','Derived active host creation is explicitly supplied failure0, no-op uses actual methods. No live network or disk output is proven by this native oracle. Active pathname-registration flags and populated singleton trees remain outside this default-initialization fixture.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'native_calls':call_trail[-16:],'windows_calls':windows_calls[-8:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items()if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
