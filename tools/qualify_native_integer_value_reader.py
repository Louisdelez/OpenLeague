from pathlib import Path
import json,struct,hashlib,datetime,itertools,re,shutil
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(prefix,'native integer value reader prerequisites','exec'))
obj=vector+0x8000;output=vector+0x9000;text_buffer=vector+0xa000;errno=vector+0xb000
assert read(0x14ae870)==0
typed=None;authored=None;requests=[]
def read_string(p):return bytes(u.mem_read(p,200)).split(b'\0',1)[0]
def sso(p,data):
 u.mem_write(p,b'\0'*24)
 if len(data)<16:u.mem_write(p,data+b'\0');w(p+20,15)
 else:u.mem_write(text_buffer,data+b'\0');w(p,text_buffer);w(p+20,max(31,len(data)))
 w(p+16,len(data))
def conversion(data):
 m=re.match(rb'[\x09-\x0d\x20]*([+-]?)([0-9]+)',data.split(b'\0',1)[0])
 value=int(m.group(2))*(-1 if m.group(1)==b'-' else 1) if m else 0
 return max(-2147483648,min(2147483647,value)) or int(data.lower()==b'true')
def hook_reader(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xc9b780:finish(errno);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x8ae340:
  assert read(sp+4)==123;dest=read(sp+8)
  requests.append('typed')
  if typed is not None:w(dest,typed)
  finish(int(typed is not None),8);return
 if a==0xc9811c:
  dest=read(sp+4);assert read_string(read(sp+8))==b'%d';value=read(sp+12);value=value if value<0x80000000 else value-0x100000000
  data=str(value).encode();u.mem_write(dest,data+b'\0');finish(len(data));return
 if a==0x8ae0e0:
  assert read(sp+16)==123;dest=read(sp+4);fallback=read_string(read(sp+20));data=authored if authored is not None else fallback;sso(dest,data);requests.append('text');finish(int(authored is not None),24);return
 assert any(start<=a<end for start,end in [(0x8af830,0x8af990),(0xc998cc,0xc998e9),(0xc9b7d4,0xc9ba24),(0xc97ea8,0xc97f50),(0x5fa650,0x5fa779),(0x5f9e90,0x5f9ecd),(0xc98719,0xc98737)]),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_reader)
cases=[]
samples=[None,b'',b'0',b'00',b'true',b'TrUe',b' true',b'true ',b'false',b'1.5',b'  -4tail',b'2147483648',b'-2147483649',b'999999999999999999999',b'xtrue']
for binary_enabled,typed_enabled,text_enabled,typed,authored,default in itertools.product([False,True],[False,True],[False,True],[None,-3,0,4],samples,[-1,0,3]):
 u.mem_write(obj,b'\0'*0x180);u.mem_write(obj+0x148,bytes([binary_enabled,typed_enabled,text_enabled]));w(output,0xcccccccc);w(errno,0)
 w(stack,end)
 for index,value in enumerate([output,0,0,123,default]):w(stack+4+index*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);requests.clear()
 u.emu_start(0x8af830,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=default;found=False;expected_requests=[]
 if text_enabled:
  if typed_enabled:
   expected_requests.append('typed')
   if typed is not None:expected=typed;found=True
  expected_requests.append('text')
  data=authored if authored is not None else str(expected).encode();expected=conversion(data);found=found or authored is not None
 elif binary_enabled:
  expected_requests.append('typed')
  if typed is not None:expected=typed;found=True
 result=read(output);result=result if result<0x80000000 else result-0x100000000
 assert result==expected and bool(u.reg_read(UC_X86_REG_EAX)&255)==found,(binary_enabled,typed_enabled,text_enabled,typed,authored,default,result,expected)
 assert requests==expected_requests
 cases.append(dict(binary_enabled=binary_enabled,typed_enabled=typed_enabled,text_enabled=text_enabled,typed=typed,text=None if authored is None else list(authored),default=default,value=result,found=found,reads=list(requests)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8af830',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),case_count=len(cases),cases=cases,findings=['Original integer reader enabled/typed/text branches, found-flag composition and C-locale numeric conversion execute.','Text true (case-insensitive ASCII exact literal) produces1; whitespace around true is not removed by this reader. Numeric prefixes and overflow follow native CRT rules.','Existing typed result is formatted as text fallback; found success is OR of typed and text reads. Without text, only binary-enabled path attempts typed lookup.'],adapters=['Typed8AE340 and text8AE0E0 lookup boundaries supply fixtures; original storage/parser lookup not executed.','CRT%d formatting, cookie validation and errno accessor adapted; actual atoi/strtol, lower-case transform and string comparison execute unchanged.','Configuration flags and short/long string storage supplied; original population/encoding not qualified.'],limits=['Value-reader composition scope; file/cache/typed lookup and entire configuration pipeline still open.','Static C locale only; no actual user configuration/menu/persistence or original framebuffer/game completion proof.'])
(r/'data/4.20/native_integer_value_reader_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),literal_true=1)))
