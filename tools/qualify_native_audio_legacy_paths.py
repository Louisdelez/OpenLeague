"""Execute original7042C0/6F7360/8E45D0; adapt strings/CRT/provider only."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [0,heap,stack,end]:u.mem_map(a,0x10000)
def read32(a):return struct.unpack('<I',u.mem_read(a,4))[0]
def write32(a,v):u.mem_write(a,struct.pack('<I',v))
def cbytes(a):
 out=bytearray()
 for i in range(4097):
  b=u.mem_read(a+i,1)[0]
  if not b:return bytes(out)
  out.append(b)
 raise AssertionError('unbounded cstring')
def string(a):return cbytes(read32(a) if read32(a+20)>=16 else a).decode('ascii')
def put(a,value):
 global cursor
 b=value.encode('ascii');u.mem_write(a,b'\0'*24)
 if len(b)<16:u.mem_write(a,b+b'\0');write32(a+20,15)
 else:
  write32(a,cursor);u.mem_write(cursor,b+b'\0');cursor+=(len(b)+32)&~15;write32(a+20,len(b))
 write32(a+16,len(b))
def finish(pop=0,eax=0):
 sp=u.reg_read(UC_X86_REG_ESP);dest=read32(sp);u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,dest)
provider=end+0x100;calls=[];response='';cursor=heap+0x4000
u.mem_write(0x2d78b90,struct.pack('<I',heap+0x500));write32(heap+0x500,heap+0x600)
write32(0x2d78b9c,heap+0x300);write32(heap+0x300,heap+0x400);write32(heap+0x410,provider)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==provider:
  out,namespace,filename,prefix=[read32(sp+i) for i in (4,8,12,16)]
  assert string(namespace)=='';calls.append({'namespace':string(namespace),'filename':string(filename),'prefix':string(prefix)});put(out,response);finish(16,out);return
 if a in (0xc98c70,0xc99c00,0xc9c850):
  src=read32(sp+4);b=cbytes(src);arg=read32(sp+8)
  if a==0xc98c70:i=b.find(cbytes(arg))
  elif a==0xc99c00:i=b.find(bytes([arg&255]))
  else:i=b.rfind(bytes([arg&255]))
  finish(eax=src+i if i>=0 else 0);return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);assert n<=4096;put(ecx,bytes(u.mem_read(src,n)).decode('ascii'));finish(8,ecx);return
 if a==0x5648a0:put(ecx,cbytes(read32(sp+4)).decode('ascii'));finish(4,ecx);return
 if a==0x564af0:
  assert read32(sp+8)==0 and read32(sp+12)==0xffffffff;put(ecx,string(read32(sp+4)));finish(12,ecx);return
 if a in (0x564900,0xc975f5):finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x7042c0<=a<=0x704465 or 0x6f7360<=a<0x6f73f0 or 0x8e45d0<=a<=0x8e4612,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def native_hash(value):
 u.mem_write(heap+0x2000,value.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap+0x2000);u.emu_start(0x8e45d0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;return u.reg_read(UC_X86_REG_EAX)
def expected_hash(s):
 h=0
 for b in s.encode('ascii'):
  if 65<=b<=90:b+=32
  h=((h<<4)+b)&0xffffffff;high=h&0xf0000000
  if high:h^=(high>>24)^high
 return h
hash_inputs=['',*map(chr,range(1,128)),'ABCxyz','a'*1000,'DATA/Sounds/Dialogue/Announcer/Classic/Welcome.mp3']
hashes=[]
for text in hash_inputs:
 observed=native_hash(text);assert observed==expected_hash(text);hashes.append({'input':text,'hash':observed})
paths=['','Play_Welcome','Data/Sounds/Dialogue/Announcer/Classic/Welcome.mp3','/Dialogue/Announcer/Classic/Welcome.mp3','/Dialogue/Announcer/CLASSIC/Welcome.MP3','/dialogue/announcer/Classic/Welcome.mp3','/Dialogue/Announcer//Welcome.mp3','/Dialogue/Announcer/Classic/folder/Welcome.test.mp3','/Dialogue/Announcer/Classic/','/Dialogue/Announcer/Classic/.mp3','/Dialogue/Announcer/Classic/a..b.wav','/Dialogue/Announcer/LongAnnouncerPrefixLong/VeryLongAnnouncementFilename.mp3','x/Dialogue/Announcer/One/File.wav/Dialogue/Announcer/Two/Other.ogg','/Dialogue/Announcer/A/path\\file.wav','/Dialogue/Announcer/A/no_extension','/Dialogue/Announcer/A/UPPER.CASE.WAV']
cases=[]
for path,mode,response in itertools.product(paths,['empty','hit','casefold_hit','neighbors'],['','Explicit_Announcer_Event']):
 cursor=heap+0x4000;key=native_hash(path);cache={}
 if mode in ('hit','casefold_hit'):cache[native_hash(path.swapcase()) if mode=='casefold_hit' else key]='Cached_Event_With_Long_Name'
 elif mode=='neighbors':
  cache[(key-1)&0xffffffff]='Lower';cache[(key+1)&0xffffffff]='Upper'
 head=heap+0x600;u.mem_write(head,b'\0'*64);u.mem_write(head+13,b'\1')
 nodes=[]
 for index,(k,v) in enumerate(sorted(cache.items())):
  a=heap+0x1000+index*0x100;u.mem_write(a,b'\0'*64);write32(a+16,k);put(a+20,v);nodes.append(a)
 def tree(items,parent):
  if not items:return head
  i=len(items)//2;a=items[i];write32(a,tree(items[:i],a));write32(a+4,parent);write32(a+8,tree(items[i+1:],a));return a
 write32(head+4,tree(nodes,head));u.mem_write(heap,path.encode('ascii')+b'\0');put(heap+0x200,'Before');calls=[]
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<III',end,heap+0x200,heap));u.reg_write(UC_X86_REG_ESP,sp)
 try:u.emu_start(0x7042c0,end,count=100000)
 except Exception:
  print(path,mode,hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_EAX)),hex(u.reg_read(UC_X86_REG_ECX)),hex(read32(heap+0x300)),hex(read32(heap+0x410)));raise
 assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)==heap+0x200
 output=string(heap+0x200);expected_calls=[]
 if key in cache:expected=cache[key]
 elif '/Dialogue/Announcer/' not in path:expected=''
 else:
  remainder=path.split('/Dialogue/Announcer/',1)[1];assert '/' in remainder
  expected_calls=[{'namespace':'','filename':remainder.rsplit('/',1)[1].replace('.','_'),'prefix':remainder.split('/',1)[0]}];expected=response
 assert output==expected and calls==expected_calls,(path,mode,output,calls)
 cases.append({'path':path,'cache':{str(k):v for k,v in cache.items()},'provider_result':response,'output':output,'provider_calls':calls})
proof={'passed':True,'native_sha256':digest,'hash_cases':hashes,'cases':cases,'complete':False,'limits':['Original hash, cache lookup, parser, dot replacement and provider invocation executed. CRT/string storage/security and service virtual10 explicitly adapted.','Service event composition, actual cache population and announcer playback remain unqualified. No invented event-name format.','ASCII/no-NUL paths only; malformed matched paths without a subsequent slash excluded (native unsafe pointer subtraction).']}
(r/'data/4.20/audio_legacy_paths_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original legacy paths {len(cases)} cases / {len(hashes)} hash cases passed')
