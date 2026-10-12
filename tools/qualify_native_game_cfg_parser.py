from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(prefix,'native cfg parser prerequisites','exec'))
u.mem_map(0x41000000,0x400000);frame=stack+0x800;owner=vector+0x6000;sentinel=vector+0x6100;heap=0x41000000;allocation=heap;slots={};records=[];warnings=0;exception=None
def alloc(data):
 global allocation
 p=allocation;allocation+=((len(data)+16+15)//16)*16;assert allocation<heap+0x400000;u.mem_write(p,data+b'\0');return p
def cbytes(p):
 out=bytearray()
 while True:
  b=u.mem_read(p,1)[0]
  if b==0:return bytes(out)
  out.append(b);p+=1;assert len(out)<100000
def ssoread(p):return bytes(u.mem_read(read(p) if read(p+20)>=16 else p,read(p+16)))
def ssowrite(p,data):
 u.mem_write(p,b'\0'*24)
 if len(data)<16:u.mem_write(p,data+b'\0');w(p+20,15)
 else:w(p,alloc(data));w(p+20,max(31,len(data)))
 w(p+16,len(data))
def native_hook(uc,a,size,user):
 global warnings,exception
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a in [0x5c06f0,0x5c0540,0x6e1e10,0x6e1e50,0x5bc9d0]:
  data=ssoread(this);needle=cbytes(read(sp+4));start=read(sp+8)
  if a in [0x5c06f0,0x5c0540]:needle=bytes(u.mem_read(read(sp+4),read(sp+12)))
  if a==0x5c0540:value=data.find(needle,start) if start<=len(data) else -1
  elif a==0x6e1e50:value=next((i for i in range(min(start,len(data)-1),-1,-1) if data[i] not in needle),-1)
  else:
   invert=a in [0x5c06f0,0x6e1e10]
   value=next((i for i in range(min(start,len(data)),len(data)) if (data[i] not in needle) if invert),-1) if invert else next((i for i in range(min(start,len(data)),len(data)) if data[i] in needle),-1)
  finish(value,12 if a in [0x5c06f0,0x5c0540] else 8);return
 if a==0x5bca50:
  dest=read(sp+4);start=read(sp+8);count=read(sp+12);data=ssoread(this)
  if start>len(data):exception='substring_out_of_range';uc.emu_stop();return
  ssowrite(dest,data[start:] if count==0xffffffff else data[start:start+count]);finish(dest,12);return
 if a==0x5fadb0:ssowrite(this,ssoread(read(sp+4)));finish(this,4);return
 if a==0x564900:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x5c6830:
  dest=read(sp+4);key=read(read(sp+8));w(dest,slots.get(key,sentinel));finish(dest,8);return
 if a==0x6eb780:
  key=read(read(sp+4));assert key not in slots;slot=alloc(b'\0'*24);slots[key]=slot;ssowrite(slot,b'')
  records.append(dict(hash=key,section=ssoread(frame-0x70).decode('latin1'),key=ssoread(frame-0x58).decode('latin1'),value=ssoread(frame-0x28).decode('latin1')))
  finish(slot,4);return
 if a==0x564af0:
  data=ssoread(read(sp+4));start=read(sp+8);count=read(sp+12);ssowrite(this,data[start:] if count==0xffffffff else data[start:start+count]);finish(this,12);return
 if a in [0x5642d0,0x5fa170]:
  if a==0x5fa170:warnings+=1
  finish(0);return
 assert 0x8aed5d<=a<0x8af242 or 0x8e5210<=a<0x8e5251 or 0x8e50b0<=a<0x8e51a0,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,native_hook)
def parse(data,flag):
 global allocation,warnings,exception
 allocation=heap;slots.clear();records.clear();warnings=0;exception=None
 u.mem_write(frame-0xc0,b'\0'*0xc0);ssowrite(frame-0x40,data+b'\0');w(frame-0xa8,owner);w(frame-0x9c,0);w(frame-0x90,alloc(b'probe.cfg'));w(owner+4,sentinel);w(frame+12,flag)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x100)
 u.reg_write(UC_X86_REG_EAX,len(data)+1);u.emu_start(0x8aed5d,0x8af242,count=500000)
 assert exception or u.reg_read(UC_X86_REG_EIP)==0x8af242
 for record in records:assert ssoread(slots[record['hash']]).decode('latin1')==record['value']
 return dict(entries=[dict(row) for row in records],warnings=warnings,error=exception)
samples=[b'',b'[Performance]\nEnvironmentQuality=3\n',b'[Performance]\nEnvironmentQuality=1\nEnvironmentQuality=4\n',b'Key=3\n[Performance]\nEnvironmentQuality=4\n',b'[Performance]\nEnvironmentQuality=\n',b'[Performance]\nEnvironmentQuality=',b'[Performance]\nEnvironmentQuality=true',b'[ Performance ]\nEnvironmentQuality=2\n',b'[Performance\nEnvironmentQuality=3\n',b'[Performance]\n   = 4\n',b'[Performance]\n# comment\n; comment\n\' comment\nEnvironmentQuality=4\n']
for name,value,endline in itertools.product([b'EnvironmentQuality',b'environmentquality',b' EnvironmentQuality ',b'\tEnvironmentQuality\t'],[b'3',b' true ',b'"4"',b"'4'",b'"4;5"',b'3#note',b'3;note',b'4=5',b' ',b'\t'],[b'\n',b'\r\n',b'']):samples.append(b'[Performance]\n'+name+b'='+value+endline)
samples=list(dict.fromkeys(samples));cases=[]
for data,flag in itertools.product(samples,[0,1]):cases.append(dict(bytes=list(data),flag=flag,result=parse(data,flag)))
source=r/'data/4.20/configuration/defaults/Game.cfg';raw_config=source.read_bytes();actual=parse(raw_config,0)
assert actual['error'] is None
env=[row for row in actual['entries'] if row['section']=='Performance' and row['key']=='EnvironmentQuality'];assert len(env)==1 and env[0]['value']=='3'
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8aed5d',stop='0x8af242',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),case_count=len(cases),cases=cases,actual_game_cfg=dict(source=str(source),sha256=hashlib.sha256(raw_config).hexdigest(),result=actual),adapters=['Loop entered after I/O with actual source bytes plus native trailing NUL and initialized string frame.','Standard string search/substr/assignment/destruction and map find/insert adapted; original parsing branches and section/key hash arithmetic execute.','Diagnostic output adapted; substring out-of-range reports boundary exception without executing native CRT throw machinery.'],limits=['Parser loop scope; original file/cache/constructor/encoding and map/string allocator implementation not executed.','Actual default file parsed; user path, runtime options/menu/persistence and full game acceptance still open.'])
(r/'data/4.20/native_game_cfg_parser_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),native_default_entries=len(actual['entries']),native_default_warnings=actual['warnings'],environment=env[0])))
