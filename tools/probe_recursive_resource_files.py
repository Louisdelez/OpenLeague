from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native prerequisites','exec'))
folder=0x40008000;pattern=0x40008100;mapping=0x40008200;iterator=0x40008400;vtable=0x40008500
allocation_cursor=0x70000000;rows=[];index=0
def cstr(at):
 out=bytearray()
 while True:
  b=u.mem_read(at+len(out),1)[0]
  if not b:return out.decode('ascii')
  out.append(b);assert len(out)<2048
def sso(at,value,storage):
 b=value.encode('ascii');u.mem_write(at,bytes(24));write32(at+0x10,len(b))
 if len(b)<16:u.mem_write(at,b+b'\0');write32(at+0x14,15)
 else:write32(at,storage);u.mem_write(storage,b+b'\0');write32(at+0x14,len(b))
def string(at):
 return bytes(u.mem_read(read32(at) if read32(at+0x14)>=16 else at,read32(at+0x10))).decode('ascii')
for offset,address in [(0,0x901ed0),(4,0x901ee0),(8,0x901ef0),(0xc,0x901f00),(0x1c,0x901f30)]:write32(vtable+offset,address)
write32(iterator,vtable)
def iterator_boundary(uc,a,size,user):
 global index
 if a==0x8b4b30:
  top=u.reg_read(UC_X86_REG_ESP);assert cstr(read32(top+4))=='*'
  wrapper=u.reg_read(UC_X86_REG_ECX);write32(wrapper,iterator);write32(wrapper+4,0);index=0;finish(eax=wrapper)
 elif a==0x901ed0:finish(eax=int(index<len(rows)))
 elif a==0x901ee0:index+=1;finish()
 elif a==0x901ef0:
  u.mem_write(0x4000e000,rows[index]['name'].encode('ascii')+b'\0');finish(eax=0x4000e000)
 elif a==0x901f00:finish(eax=int(rows[index].get('directory',False)))
 elif a==0x901f30:
  u.mem_write(0x4000f000,rows[index]['folder'].encode('ascii')+b'\0');finish(eax=0x4000f000)
u.hook_add(unicorn.UC_HOOK_CODE,iterator_boundary)
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
paths=sorted(p for p in (source/'DATA/Shared').rglob('*') if p.is_file())[:6]
native_rows=[{'name':p.name,'folder':str(p.parent.relative_to(source)).replace('\\','/')} for p in paths]
cases=[]
fixtures=[('empty',[]),('nested-routing',[{'name':'terrain.inibin','folder':'DATA/Shared/one'},{'name':'fog.dds','folder':'DATA/Shared/two'},{'name':'skip.dds','folder':'DATA/Shared/two','directory':True}]),('duplicate-base-name',[{'name':'same.dds','folder':'DATA/Shared/one'},{'name':'same.dds','folder':'DATA/Shared/two'}]),('actual-shared-files',native_rows)]
for first,second in [('same.inibin','same.inibin'),('same.dat','same.dat'),('same.dds','same.tga'),('same.tga','same.dds'),('same.scb','same.sco'),('same.sco','same.scb'),('same.gfx','same.swf'),('same.swf','same.gfx'),('same.DDS','same.dds')]:
 fixtures.append((first+'-then-'+second,[{'name':first,'folder':'DATA/Shared/one'},{'name':second,'folder':'DATA/Shared/two'}]))
for name,rows in fixtures:
 allocation_cursor=0x70000000;u.mem_write(mapping,bytes(16));invoke(0x6542a0,mapping);write32(mapping,u.reg_read(UC_X86_REG_EAX));sso(folder,'DATA/Shared',0x40009000);sso(pattern,'*',0x40009200)
 write32(sp,end);write32(sp+4,mapping);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder);u.reg_write(UC_X86_REG_EDX,pattern)
 u.emu_start(0x905810,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end
 head=read32(mapping);entries={}
 def walk(node):
  if node==head:return
  walk(read32(node));entries[string(node+0x10)]=string(node+0x28);walk(read32(node+8))
 walk(read32(head+4));cases.append({'name':name,'iterator_rows':rows,'entries':entries})
assert cases[1]['entries']['terrain.ini']=='DATA/Shared/one/terrain.ini'
assert cases[1]['entries']['fog.tga']=='DATA/Shared/two/fog.dds' and 'skip.dds' not in cases[1]['entries']
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x905810',native_addresses=len(visited),cases=cases,sources=[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],limits=['Original recursive collector loop, native full-folder/filename string copies, directory skipping and905090insertion execute. Iterator8B4B30/virtual accessors explicitly adapted to supplied rows.','Recursive iterator enumeration/order/ownership constructed as external IO adapter; original iterator factory/destructor and OS/archive traversal unqualified.','Actual Shared sample uses six extracted files; not full Shared or global table. Duplicate path precedence is observed for supplied row order only.'])
(r/'data/4.20/recursive_resource_files_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'native_addresses':len(visited),'cases':cases}))
