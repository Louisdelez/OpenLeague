from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_recording_file.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'recording preparation prerequisites','exec'))
old_preparation=types.FunctionType(boundary.__code__,globals())
def preparation_boundary(uc,address,size,user):
 global resource
 if address==0x8f8e10:resource=u.reg_read(UC_X86_REG_ECX)
 if address==0x8c59f0:finish(eax=0x2d8bac0);return
 if address==0x8c5e90:
  assert u.reg_read(UC_X86_REG_ECX)==0x2d8bac0
  path=read32(u.reg_read(UC_X86_REG_ESP)+4)
  events.append({'op':'register_path','path':path})
  finish(pop=4);return
 return old_preparation(uc,address,size,user)
boundary.__code__=preparation_boundary.__code__
cases=[]
try:
 for poison,flag,has_path,profile in itertools.product([0,165],[0,1,256,257],[False,True],[0,1,2]):
  write_result=0;close_result=0;write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,b'\0\0');snapshot();baseline=set(live);events.clear();resource=0
  stream=heap+0xa000;path=heap+0xc000
  u.mem_write(stream,bytes([poison])*64)
  for off in [0x30,0x34,0x38,0x3c]:write32(stream+off,0)
  u.mem_write(path,b'E:/OpenLeague/logs/supplied-preparation.txt\0')
  result=call(0x8fb650,stream,[path if has_path else 0,flag,0,0])&255
  assert result==1
  prepared={'snapshot':snapshot(),'events':list(events),'stream_pairs':[read32(stream+i) for i in [0x30,0x34,0x38,0x3c]],'file':read32(resource+32) if resource else None,'enabled':int(u.mem_read(resource+36,1)[0]) if resource else None}
  events.clear()
  if resource:call(0x8f8f90,resource,[])
  call(0x5bd3c0,stream+0x30,[])
  destroyed={'snapshot':snapshot(),'events':list(events)};events.clear()
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown={'snapshot':snapshot(),'events':list(events)}
  assert set(live)==baseline
  cases.append({'fill':poison,'flag':flag,'has_path':has_path,'profile':profile,'stream':stream,'path':path,'resource':resource,'return_byte':result,'prepared':prepared,'destroyed':destroyed,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['48 direct original8FB650 preparation lifetimes cover low-byte flags0/1/256/257, fills0/A5, null/non-null paths and all three fopen outcomes. Actual resource constructor, logger composite, control901630/5D1620, move8C3480 and logger-ready586220 execute.','Caller64-byte storage has only its two shared pairs initialized empty. Metadata input is an empty by-value pair. The tests compose the enabled branch helper with the separately implemented caller low-byte gate; no full stream construction, parent manager, frames or network is proven.','CRT fopen/fprintf/fclose are explicit supplied boundaries. Path registration8C59F0/8C5E90 is one explicit observable boundary, called even on file failure; singleton behavior is qualified separately.','Every resource is explicitly closed before control release, then the logger is immediately retired. Repeated replacement of an existing recording resource is not qualified.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'error':repr(e),'cases_completed':len(cases),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'native_calls':call_trail[-16:],'windows_calls':windows_calls[-8:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
