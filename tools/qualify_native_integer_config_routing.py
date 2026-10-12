from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(prefix,'native config routing prerequisites','exec'))
u.mem_map(0,4096);pair0=vector+0x6000;pair1=vector+0x6010;objects=[vector+0x7000+i*0x100 for i in range(4)];strings=vector+0x8000
u.mem_write(strings,b'Performance\0EnvironmentQuality\0');keyptr=strings+12
pathptr=strings+100;u.mem_write(pathptr,b'Game.cfg\0');requests=[];reads=[];values={};flags=0
def signed(x):return x if x<0x80000000 else x-0x100000000
def native_hash(section,key):
 h=0
 for b in section.lower():h=(h*65599+b)&0xffffffff
 h=(h*65599+42)&0xffffffff
 for b in key.lower():h=(h*65599+b)&0xffffffff
 return h
hashkey=native_hash(b'Performance',b'EnvironmentQuality')
def hook_config(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x8acef0:
  path=string(read(sp+4));flag=read(sp+8);assert flag==flags;assert path in ['DATA/CFG/defaults/Game.cfg','Game.cfg']
  requests.append(dict(path=path,flags=flag));finish(pair0 if len(requests)==1 else pair1,8);return
 if a==0x8af830:
  obj=uc.reg_read(UC_X86_REG_ECX);assert obj in values
  output=read(sp+4);key=read(sp+16);fallback=signed(read(sp+20));assert key==hashkey
  value=values[obj];found=value is not None;result=value if found else fallback;w(output,result)
  reads.append(dict(layer=objects.index(obj),hash=key,default=fallback,found=found,result=result));finish(int(found),20);return
 assert 0x8b1c20<=a<0x8b1dc5 or 0x8e51a0<=a<0x8e520c,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_config)
cases=[]
for baseline,base_overlay,user_value,user_overlay,default,flags,heap in itertools.product([None,-1,2],['absent','missing','four'],[None,0,1],['absent','missing','four'],[-2147483648,0,3,2147483647],[0,1],[False,True]):
 values={objects[0]:baseline,objects[1]:4 if base_overlay=='four' else None,objects[2]:user_value,objects[3]:4 if user_overlay=='four' else None}
 w(pair0,objects[0]);w(pair0+4,0 if base_overlay=='absent' else objects[1]);w(pair1,objects[2]);w(pair1+4,0 if user_overlay=='absent' else objects[3])
 w(0x2d83fb8,1);w(0x2d8a9dc,1);u.mem_write(0x2d8a9c0,b'\0'*24)
 if heap:w(0x2d8a9c0,pathptr);w(0x2d8a9d4,31)
 else:u.mem_write(0x2d8a9c0,b'Game.cfg\0');w(0x2d8a9d4,15)
 w(stack,end);w(stack+4,default);w(stack+8,flags);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,strings);u.reg_write(UC_X86_REG_EDX,keyptr);requests.clear();reads.clear()
 u.emu_start(0x8b1c20,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected_reads=[];result=default
 for primary,overlay,presence in [(0,1,base_overlay),(2,3,user_overlay)]:
  found=False
  if presence!='absent':
   value=values[objects[overlay]];found=value is not None
   expected_reads.append(dict(layer=overlay,hash=hashkey,default=result,found=found,result=value if found else result))
   if found:result=value
  if not found:
   value=values[objects[primary]];found=value is not None
   expected_reads.append(dict(layer=primary,hash=hashkey,default=result,found=found,result=value if found else result))
   if found:result=value
 assert reads==expected_reads and signed(u.reg_read(UC_X86_REG_EAX))==result
 assert requests==[dict(path='DATA/CFG/defaults/Game.cfg',flags=flags),dict(path='Game.cfg',flags=flags)]
 cases.append(dict(baseline=baseline,base_overlay=base_overlay,user_value=user_value,user_overlay=user_overlay,default=default,flags=flags,heap_path=heap,result=result,reads=list(reads)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b1c20',hash_function='0x8e51a0',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),case_count=len(cases),cases=cases,findings=['Original whole integer getter routes baseline defaults Game.cfg before user path, overlay before primary in each pair, and carries prior result as fallback to user reads.','Original section/key hash executes and agrees with independent ASCII lower-case SDBM hash; EnvironmentQuality signed values are not clamped by this getter.','Inline and heap user-path branches execute; supplied flags passed unchanged to both cache queries.'],adapters=['Cache8ACEF0 returns supplied file pairs; typed integer reader8AF830 writes supplied values/defaults and success bits.','Initialized cache globals and user path/string storage supplied; original file loading, parser/lookup/conversion and initialization callbacks not executed.'],limits=['Routing/order/fallback scope only; not full Game.cfg parser or integer text conversion qualification.','No actual user file/menu/persistence or whole settings/raster/game acceptance.'])
(r/'data/4.20/native_integer_config_routing_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),hash=hashkey,complete=False)))
