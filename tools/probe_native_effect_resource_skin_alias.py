from pathlib import Path
import shutil
import sys,struct,json,hashlib,itertools,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0x40000000,0x30000)
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
vector=0x40000000;storage=vector+0x1000;animate=vector+0x2000;cloud=vector+0x3000;vt=vector+0x4000;stack=vector+0x20000;end=vector+0x2f000;visited=set();animate_state=cloud_state=False
def finish(value,args=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+args)
def string(a):return bytes(u.mem_read(a,100)).split(b'\0')[0].decode()
def hook(uc,a,size,user):
 if a==0xc9befc:
  sp=u.reg_read(UC_X86_REG_ESP);value=read(sp+4);buffer=read(sp+8);assert value in [0,1];u.mem_write(buffer,str(value).encode()+b'\0');finish(buffer);return
 if a in [vector+0x5000,vector+0x5010]:finish(int(animate_state if a==vector+0x5000 else cloud_state));return
 assert 0x9593c0<=a<0x9595c5 or 0x9696d0<=a<0x9696e9 or 0x77de90<=a<0x77df05,hex(a);visited.add(a)
u.mem_map(0,4096)
source=vector+0x6000;actor=vector+0x7000;package=vector+0xa000;packagevt=package+0x100;output=vector+0xb000;source_package=vector+0xc000;cfg=vector+0xd000;heapstart=vector+0x18000;heapnext=heapstart
w(0x2d79104,cfg);w(actor+0x3c,package);w(package,packagevt);w(packagevt+0x28,vector+0x5000)
streams={};queries=[]
def cstring(a):return bytes(u.mem_read(a,300)).split(b'\0')[0].decode('ascii')
def strptr(a):return read(a) if read(a+20)>=16 else a
def string_value(a):return bytes(u.mem_read(strptr(a),read(a+16))).decode('ascii')
def assign(a,value):
 global heapnext
 b=value.encode('ascii');u.mem_write(a,b'\0'*24)
 if len(b)>=16:
  dest=heapnext;heapnext+=0x200;w(a,dest);w(a+20,511)
 else:dest=a;w(a+20,15)
 u.mem_write(dest,b+b'\0');w(a+16,len(b))
def hook_alias(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==0x564c20:assign(this,bytes(u.mem_read(read(sp+4),read(sp+8))).decode('ascii'));finish(this,8);return
 if a==0x5648a0:assign(this,cstring(read(sp+4)));finish(this,4);return
 if a==0x564d20:assign(this,cstring(read(sp+4)));finish(this,4);return
 if a==0x564900:finish(0);return
 if a==0x5fad80:out=read(sp+4);w(out,strptr(this)+read(this+16));finish(out,4);return
 if a==0x5fa650:
  begin=u.reg_read(UC_X86_REG_EDX);last=read(sp+4);b=bytes(u.mem_read(begin,last-begin));u.mem_write(begin,b.lower());finish(0);return
 if a==0x5bc990:
  where=string_value(this).find(cstring(read(sp+4)),read(sp+8));finish(where,8);return
 if a==0x5f81e0:streams[this]='';finish(this,8);return
 if a==0x5fd400:
  stream=read(sp+4);streams[stream]+=cstring(read(sp+8));finish(stream);return
 if a==0x5fd260:
  value=read(sp+4);value=value if value<0x80000000 else value-0x100000000;streams[this]+=str(value);finish(this,4);return
 if a==0x5f8070:out=read(sp+4);assign(out,streams[this]);finish(out,4);return
 if a==0x5f8090:finish(0);return
 if a==0x5fa8b0:
  index=read(sp+4);count=read(sp+8);insert=string_value(read(sp+12));old=string_value(this);assign(this,old[:index]+insert+old[index+count:]);finish(this,20);return
 if a==vector+0x5000:queries.append(string_value(read(sp+4)));finish(int(available),4);return
 if a==0xc975f5:finish(u.reg_read(UC_X86_REG_EAX));return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_alias)
cases=[]
for name,skin,available,enabled,owner_kind in itertools.product(['Annie_Q_mis.troy','Annie_Q_base.troy','Annie_Q_BASE.troy','impact.troy','name_without_extension','path.TROY'],[0,1,9,10,20],[False,True],[False,True],['absent','other','avatar']):
 heapnext=heapstart;streams.clear();queries.clear();u.mem_write(source,name.encode()+b'\0');u.mem_write(output,b'\0'*24);w(source_package,123);w(cfg+0x10,0x4000 if enabled else 0);w(actor+0x1c,0x400 if owner_kind=='avatar' else 0);w(actor+0x2134,skin)
 w(stack,end);w(stack+4,output);w(stack+8,source_package);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.reg_write(UC_X86_REG_EDX,0 if owner_kind=='absent' else actor)
 try:u.emu_start(0x7522b0,end,count=5000)
 except Exception:print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),name);raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(name=name,skin=skin,available=available,enabled=enabled,owner_kind=owner_kind,queries=list(queries),resolved_name=string_value(output),source_package_selected=read(source_package)==package))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x7522b0',native_instruction_addresses=len(visited),cases=cases,adapters=['String assignment/search/ASCII lowercase/replacement and stream formatting supplied as explicit standard-library primitives; original alias control flow executes.','Package virtual28 supplies explicit candidate availability and records exact native query. Resource lookup implementation remains unqualified.','Security-cookie adapter preservesEAX.'],limits=['ASCII names,skin0/1/9/10/20; native byte case/locale/exception behavior unqualified.','Availability boundary supplied, not proof of real resource existence or package ownership.','No ordinary runtime/client integration or GPU/audio acceptance.'])
(r/'data/4.20/effect_resource_skin_alias_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited),example=next(c for c in cases if c['name']=='Annie_Q_base.troy' and c['skin']==9 and c['available'] and c['enabled'] and c['owner_kind']=='avatar'))))
