from pathlib import Path
import itertools,json,sys,types,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'file resource prerequisites','exec'))
old_boundary=types.FunctionType(boundary.__code__,globals());events=[];resource=0;profile=0;write_result=0;close_result=0
def file_boundary(uc,address,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if address in [0x9941b0,0x994210] and u.reg_read(UC_X86_REG_ECX) in [resource,0x2d78ed0]:
  events.append({'op':'enter' if address==0x9941b0 else 'leave','object':u.reg_read(UC_X86_REG_ECX)})
 if address==0xc9951e:
  path,mode=[read32(sp+i)for i in [4,8]];mode=cbytes(mode);assert mode in [b'wc',b'ac']
  result=(0x76000001 if mode==b'wc' else 0x76000002) if (profile>=1 if mode==b'wc' else profile==2) else 0
  events.append({'op':'open','path_hex':cbytes(path).hex(),'mode':mode.decode(),'result':result});finish(eax=result);return
 if address==0xc99855:
  events.append({'op':'close','file':read32(sp+4),'result':close_result});finish(eax=close_result&0xffffffff);return
 if address==0xc99998:
  file,format,message=[read32(sp+i)for i in [4,8,12]];assert cbytes(format)==b'%s'
  events.append({'op':'write','file':file,'message_hex':cbytes(message).hex(),'result':write_result});finish(eax=write_result&0xffffffff);return
 return old_boundary(uc,address,size,user)
boundary.__code__=file_boundary.__code__
old_windows_file=transport_windows
def transport_windows(dll,name,sp):
 if name=='GetLocalTime':u.mem_write(read32(sp+4),struct.pack('<8H',2014,11,4,20,23,59,58,999));finish(pop=4);return True
 return old_windows_file(dll,name,sp)
def capture():
 v={'snapshot':snapshot(),'events':list(events),'file':read32(resource+32),'enabled':int(u.mem_read(resource+36,1)[0])};events.clear();return v
cases=[]
try:
 for poison,profile,write_result,close_result in itertools.product([0,165],[0,1,2],[0,-1],[0,-1]):
  write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,b'\0\0');snapshot();baseline=set(live);events.clear()
  resource=call(0x9933e0,0,[40]);call(0x8f8e10,resource,[]);initial=capture()
  path=heap+0xc000;message=heap+0xd000;u.mem_write(path,b'E:/OpenLeague/logs/supplied-file.txt\0');u.mem_write(message,b'raw\n%token\xe9\0ignored\0');steps=[]
  for action in ['write_disabled','open','write_null','write','open_again','close','close_again']:
   if action.startswith('write'):result=call(0x8f8ed0,resource,[0 if action=='write_null' else message])&255
   elif action.startswith('open'):result=call(0x8f8f10,resource,[path])&255
   else:result=call(0x8f8f90,resource,[])&255
   steps.append({'action':action,'return_byte':result,'state':capture()})
  call(0x5f9d70,resource,[1]);destroyed={'snapshot':snapshot(),'events':list(events)};events.clear()
  call(0x901c00,0,[]);shutdown={'snapshot':snapshot(),'events':list(events)};assert set(live)==baseline
  cases.append({'fill':poison,'profile':profile,'write_result':write_result,'close_result':close_result,'resource':resource,'path_pointer':path,'message_pointer':message,'initial':initial,'steps':steps,'destroyed':destroyed,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['24 native diagnostic-file resource lifetimes with supplied fopen wc/ac outcomes and fprintf/fclose success/error results. These exercise source construction, recursive logger registration, every file-state branch, repeated open/close, disabled/null-message gates, log formatting, callback dispatch and teardown.','The primitive CRT file functions are explicit supplied boundaries; no disk I/O is claimed by this fixture. The pathname-registration singleton8C59F0/8C5E90 is outside this direct resource contract and remains required for full8FB650 preparation. No replay frame serialization or parent game manager is invoked.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items()if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
