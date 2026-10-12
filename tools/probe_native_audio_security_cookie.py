from pathlib import Path
import itertools,json
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_environment_macros.py').read_text();exec(compile(source.split('\nu.hook_add(')[0],'native-cookie-setup','exec'))
calls=[];active={};imports={vector+0x28000+i*16:name for i,name in enumerate(['GetSystemTimeAsFileTime','GetCurrentThreadId','GetCurrentProcessId','QueryPerformanceCounter'])}
for address,target in zip([0xfa4308,0xfa4378,0xfa4370,0xfa4134],imports):w(address,target)
def hook(uc,a,z,user):
 if a in imports:
  name=imports[a];sp=u.reg_read(UC_X86_REG_ESP)
  if name=='GetSystemTimeAsFileTime':
   target=read(sp+4);initial=[read(target),read(target+4)];assert target==active['local_reference']-8;assert initial==[0,0];value=active['time_value'];calls.append({'kind':name,'initial':initial,'value':value});w(target,value[0]);w(target+4,value[1]);finish(0,4)
  elif name=='GetCurrentThreadId':calls.append({'kind':name,'result':active['thread_id']});finish(active['thread_id'])
  elif name=='GetCurrentProcessId':calls.append({'kind':name,'result':active['process_id']});finish(active['process_id'])
  else:
   target=read(sp+4);assert target==active['local_reference']-16;initial=[read(target),read(target+4)];counter=active['counter'];assert initial==active['initial_counter'];
   if counter['writes']:w(target,counter['value'][0]);w(target+4,counter['value'][1])
   value=[read(target),read(target+4)];calls.append({'kind':name,'initial':initial,'value':value,'result':counter['result']});finish(counter['result'],4)
  return
 assert 0xcb65b4<=a<=0xcb664f,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for old,mix,policy,initial,sp in itertools.product([0,1,0xffff,0xbb40e64e,0x12340000,0x11223344,0xffffffff],[0,1,0x4711,0xffff,0xbb40e64e,0xbb40e64f,0x12345678,0xffffffff],[(0,True),(1,True),(0xffffffff,True),(0,False)],[[0,0],[0x11223344,0x55667788]],[0x40020000,0x40021000]):
 local=sp-8;counter={'result':policy[0],'writes':policy[1],'value':[0x89abcdef,0x76543210]};used=counter['value']if counter['writes']else initial;tid=0x12345678;pid=0x87654321;high=0x11223344;low=mix^high^tid^pid^used[0]^used[1]^local
 active={'local_reference':local,'initial_counter':initial,'counter':counter,'time_value':[low,high],'thread_id':tid,'process_id':pid};calls.clear();u.mem_write(sp-0x100,bytes([0xa5])*0x120);w(sp,end);w(local-16,initial[0]);w(local-12,initial[1]);w(0x1222ed0,old);w(0x1222ed4,0xa5a5a5a5);before=bytes(u.mem_read(0x1222ed0,8)).hex()
 for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,0x1234abcd),(UC_X86_REG_ESI,0x76543210),(UC_X86_REG_EDI,0xfedcba98)]:u.reg_write(reg,value)
 u.emu_start(0xcb65b4,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_ESP)==sp+4;assert u.reg_read(UC_X86_REG_EBP)==0x1234abcd and u.reg_read(UC_X86_REG_ESI)==0x76543210 and u.reg_read(UC_X86_REG_EDI)==0xfedcba98
 rows.append(dict(active,initial_cookie=old,raw_mix_input=mix,before=before,after=bytes(u.mem_read(0x1222ed0,8)).hex(),calls=list(calls),stack_delta=4))
p={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry_reference':0xcb65b4,'case_count':len(rows),'cases':rows,'limits':['Original complete x86 producer executed with supplied four Windows entropy boundaries. Local stack references and initial QPC words explicit; raw QPC results0/1/MAX and untouched-on-failure output exercised.','Existing valid-cookie early path, default collision avoidance, high16 promotion and complement outputs come from native execution, not a Rust formula. No claim these controlled inputs measure live entropy quality or actual OS QPC failure.']}
(r/'data/4.20/audio_security_cookie_preparation.json').write_text(json.dumps(p,indent=2)+'\n');(r/'tools/probe_native_audio_security_cookie.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Captured',len(rows),'complete native security-cookie executions and exact entropy call order')
