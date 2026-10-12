from pathlib import Path
import json,struct,hashlib,datetime,itertools,math,re,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native typed integer prerequisites','exec'))
obj=vector+0x8000;output=vector+0x9000;string_buffer=vector+0xa000;errno=vector+0xb000;requests=[];sources={}
u.mem_map(0,0x1000)
def typed_hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a in [0x8af330,0x8af470,0x8af7b0,0x8af290]:
  assert read(sp+4)==123;dest=read(sp+8);kind={0x8af330:'integer',0x8af470:'float',0x8af7b0:'boolean',0x8af290:'string'}[a];requests.append(kind);value=sources[kind]
  if value is not None:
   if kind=='integer':w(dest,value)
   elif kind=='float':u.mem_write(dest,struct.pack('<f',value))
   elif kind=='boolean':u.mem_write(dest,bytes([value]))
   else:
    u.mem_write(dest,b'\0'*24)
    if len(value)<16:u.mem_write(dest,value+b'\0');w(dest+20,15)
    else:u.mem_write(string_buffer,value+b'\0');w(dest,string_buffer);w(dest+20,max(31,len(value)))
    w(dest+16,len(value))
  finish(int(value is not None),8);return
 if a==0x564900:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc9b780:finish(errno);return
 assert any(begin<=a<stop for begin,stop in [(0x8ae340,0x8ae430),(0xc998cc,0xc998e9),(0xc9b7d4,0xc9ba24),(0xc97ea8,0xc97f50)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,typed_hook)
def atoi(data):
 m=re.match(rb'[\x09-\x0d\x20]*([+-]?)([0-9]+)',data.split(b'\0',1)[0]);value=int(m.group(2))*(-1 if m.group(1)==b'-' else 1) if m else 0;return max(-2147483648,min(2147483647,value))
cases=[]
floats=[None,-3.75,0.,4.75,float('nan'),float('inf'),float('-inf'),2147483648.,2147483520.]
for integer,floating,boolean,text in itertools.product([None,-3,0,4],floats,[None,0,1,2,255],[None,b'',b'true',b'-3.9tail',b'2147483648',b'  +4',b'long string without a number']):
 sources=dict(integer=integer,float=floating,boolean=boolean,string=text);requests.clear();u.mem_write(obj,b'\0'*0x180);w(output,0xcccccccc);w(errno,0);w(stack,end);w(stack+4,123);w(stack+8,output)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x8ae340,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected_requests=[];expected=None
 for kind in ['integer','float','boolean','string']:
  expected_requests.append(kind);value=sources[kind]
  if value is None:continue
  if kind=='integer':expected=value
  elif kind=='float':expected=int(value) if math.isfinite(value) and -2147483648<=value<2147483648 else -2147483648
  elif kind=='boolean':expected=int(value!=0)
  else:expected=atoi(value)
  break
 actual=read(output);actual=actual if actual<0x80000000 else actual-0x100000000;found=bool(u.reg_read(UC_X86_REG_EAX)&255)
 assert requests==expected_requests and found==(expected is not None) and actual==(expected if expected is not None else -858993460),(sources,actual,expected,requests)
 cases.append(dict(integer=integer,float_bits=None if floating is None else struct.unpack('<I',struct.pack('<f',floating))[0],boolean=boolean,text=None if text is None else list(text),initial=-858993460,value=actual,found=found,reads=list(requests)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8ae340',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Underlying int/float/bool/string typed storage reads supplied; original ordered lookup/conversion and CRT decimal conversion execute.','String destruction, security cookie and errno accessor adapted; mapped zero-page supplies FS exception-chain cell, without actual Windows thread exception machinery.'],limits=['Typed integer conversion scope; underlying typed INIBIN storage/lookup and complete cache/population remain open.','Float cvttss2si uses native x86 SSE semantics, including NaN/infinity/out-of-range INT32_MIN; alternate hardware/FP modes remain unqualified.'])
(r/'data/4.20/native_typed_config_integer_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
