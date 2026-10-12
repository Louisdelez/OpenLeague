from pathlib import Path
import itertools,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native archive prerequisites','exec'))
provider=0x40010000;table=provider+0x14;head=0x40011000;buckets=0x40012000;nodes=0x40013000;out=0x40014000;queryptr=0x41010000;cookie=0xc975f5;queries=[]
def hkey(data):
 h=0
 for b in data.split(b'\0',1)[0].lower():h=(h*65599+(b if b<128 else b-256))&0xffffffff
 return h
def normalize(data):
 data=data.split(b'\0',1)[0];out=bytearray();i=0
 while i<len(data):
  b=data[i]
  if b==47:out.append(92)
  elif data[i:i+2]==b'\\\\':out.append(92);i+=1
  else:out.append(b)
  i+=1
 return bytes(out).rstrip(b' ')
def archive_hook(uc,a,size,user):
 if a==cookie:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x8ba8c0:queries.append(cbytes(read(read(uc.reg_read(UC_X86_REG_ESP)+8))))
 assert any(begin<=a<stop for begin,stop in [(0x8b7a10,0x8b7ae1),(0x8ba8c0,0x8ba963),(0x8e50f0,0x8e5126),(0x8b68a0,0x8b68fc),(0xc9cef8,0xc9cf78)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,archive_hook);w(0x14ae870,0)
tables=[[],[(b'DATA\\CFG\\Game.cfg',0x10005)],[(b'DATA\\CFG\\Game.cfg',0x10005),(b'DATA\\CFG\\defaults\\Game.cfg',0x20010),(b'X',0xffff1234),(b'DATA\\\xff.cfg',0x30002)],[(b'A',1),(b'B',2),(b'C',3),(b'D',4),(b'E',5),(b'F',6)]]
paths=[None,b'',b'DATA\\CFG\\Game.cfg',b'data\\cfg\\game.CFG',b'DATA/CFG/Game.cfg',b'DATA\\\\CFG\\\\Game.cfg',b'DATA/CFG/Game.cfg  ',b'DATA/CFG/defaults/Game.cfg',b'DATA\\CFG\\defaults\\Game.cfg',b'DATA/\xff.cfg',b'X',b'x',b'Missing',b'A',b'b',b'F',b'z',b'X\0ignored']
cases=[]
for rows,path,enabled,(mask,count) in itertools.product(tables,paths,[False,True],[(1,2),(7,8),(7,5),(15,16),(15,10)]):
 u.mem_write(provider,b'\0'*0x40);w(provider+0x10,int(enabled));w(table,head);w(table+8,buckets);w(table+0x14,mask);w(table+0x18,count);groups=[[] for _ in range(count)];queries.clear();allocation=0x41000000
 for key,value in rows:
  bucket=hkey(key)&mask
  if bucket>=count:bucket-= (mask>>1)+1
  groups[bucket].append((key,value))
 arranged=[row for group in groups for row in sorted(group,key=lambda row:row[0].lower())];addresses={key:nodes+i*16 for i,(key,value) in enumerate(arranged)}
 for i,(key,value) in enumerate(arranged):
  p=nodes+i*16;next_p=nodes+(i+1)*16 if i+1<len(arranged) else head;prev_p=nodes+(i-1)*16 if i else head;keyptr=allocation;u.mem_write(keyptr,key+b'\0');allocation+=len(key)+16;w(p,next_p);w(p+4,prev_p);w(p+8,keyptr);w(p+12,value)
 w(head,nodes if arranged else head);w(head+4,nodes+(len(arranged)-1)*16 if arranged else head)
 for i,group in enumerate(groups):group=sorted(group,key=lambda row:row[0].lower());w(buckets+i*8,addresses[group[0][0]] if group else head);w(buckets+i*8+4,addresses[group[-1][0]] if group else head)
 if path is not None:u.mem_write(queryptr,path+b'\0')
 w(out,0xfeedface);w(stack,end);w(stack+4,0 if path is None else queryptr);w(stack+8,out);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,provider);u.emu_start(0x8b7a10,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 wanted=None;expected_queries=[]
 if path is not None and enabled:
  for key in [path.split(b'\0',1)[0],normalize(path)]:
   expected_queries.append(key);wanted=next((value for name,value in rows if name.lower()==key.lower()),None)
   if wanted is not None:break
 assert queries==expected_queries and bool(u.reg_read(UC_X86_REG_EAX)&255)==(wanted is not None)
 assert read(out)==(0xfeedface if wanted is None else wanted)
 cases.append(dict(entries=[dict(key=list(key),packed_id=value) for key,value in rows],requested=None if path is None else list(path),enabled=enabled,mask=mask,bucket_count=count,queries=[list(key) for key in queries],found=wanted is not None,result=wanted,output_unchanged_on_miss=wanted is None))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b7a10 + 0x8ba8c0',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original archive lookup, raw-name/normalized-name fallback, hash, unordered bucket search and C-locale case-insensitive comparison execute; only security cookie adapted.','Valid ordered bucket/node structures and resource IDs supplied; native insertion/resize/archive mounting not executed. Global CRT locale-change flag forced0.'],limits=['Lookup scope with supplied valid tables; actual ZIP index insertion, duplicate precedence, archive mounting/decompression and non-C locale remain open.','Path inputs bounded below native temporary buffer size; oversized names and empty-normalization boundary defect not qualified as supported inputs.','SDBM hash folds ASCII uppercase and adds signed8-bit bytes; comparison folds ASCII but compares unsigned byte values.','No full resource/cache/menu/game proof.'])
(r/'data/4.20/native_archive_index_lookup_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
