from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native prerequisites','exec'))
child=0x40008000;parent=0x40008100;query=0x40008200;cursor=0x40008300
def sso(at,text):
 global cursor
 b=text.encode('ascii');u.mem_write(at,bytes(24));write32(at+0x10,len(b))
 if len(b)<16:u.mem_write(at,b+b'\0');write32(at+0x14,15)
 else:write32(at,cursor);u.mem_write(cursor,b+b'\0');cursor+=0x100;write32(at+0x14,len(b))
def provider(at,entries,ancestor=0):
 global cursor
 head=cursor;cursor+=0x100;u.mem_write(at,bytes(32));write32(at,0x10d6380);write32(at+8,head);write32(at+0x10,ancestor)
 u.mem_write(head,bytes(64));u.mem_write(head+0xd,b'\1');write32(head,head);write32(head+4,head);write32(head+8,head)
 # Explicit balanced resource tree fixture: loader/enumeration not adapted as proven native state.
 def tree(items):
  global cursor
  if not items:return head
  mid=len(items)//2;node=cursor;cursor+=0x100;u.mem_write(node,bytes(64));sso(node+0x10,items[mid][0]);sso(node+0x28,items[mid][1]);write32(node,tree(items[:mid]));write32(node+8,tree(items[mid+1:]));return node
 write32(head+4,tree(sorted(entries.items(),key=lambda item:item[0].lower())))
def text(at):
 ptr=read32(at) if read32(at+0x14)>=16 else at
 return bytes(u.mem_read(ptr,read32(at+0x10))).decode('ascii')
write32(0x2d8de80,1);u.mem_write(0x2d8de30,bytes(24));write32(0x2d8de44,15)
cases=[]
fixtures=[('empty',{},{}),('map-file',{'terrain.ini':'Levels/Map10/terrain.ini'},{}),('parent-file',{}, {'terrain.ini':'Levels/terrain.ini'}),('map-over-parent',{'terrain.ini':'Levels/Map10/terrain.ini'},{'terrain.ini':'Levels/terrain.ini','FOWTexture':'Levels/FOWTexture'}),('explicit-overlay',{'FOWTexture':'Levels/Map10/FOWTexture'}, {}),('empty-path-still-exists',{'FOWTexture':''},{'FOWTexture':'Levels/FOWTexture'})]
for name,local,inherited in fixtures:
 for key in ['terrain.ini','FOWTexture','missing.dds','TERRAIN.INI','fowtexture']:
  cursor=0x40008300;provider(parent,inherited);provider(child,local,parent if inherited else 0);sso(query,key)
  invoke(0x90a4a0,child,struct.pack('<I',query));present=bool(u.reg_read(UC_X86_REG_EAX)&255)
  invoke(0x90a480,child,struct.pack('<I',query));resolved=text(u.reg_read(UC_X86_REG_EAX))
  local_fold={k.lower():v for k,v in local.items()};parent_fold={k.lower():v for k,v in inherited.items()};expected=local_fold.get(key.lower(),parent_fold.get(key.lower(),''));exists=key.lower() in local_fold or key.lower() in parent_fold
  assert present==exists and resolved==expected,(name,key,present,resolved,expected)
  cases.append(dict(name=name,local=local,parent=inherited,key=key,present=present,resolved=resolved))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,cases=cases,native_addresses=len(visited),methods={'path':'0x90A480','exists':'0x90A4A0','lower_bound':'0x90D1D0','vtable':'0x10D6380'},limits=['Original provider virtual methods, tree lookup, string comparison and parent recursion execute on explicitly constructed resource tables. No lookup/string comparison adapters.','Actual filesystem/archive enumeration, table insertion and Map10 inherited table contents are not proved. Fixture paths are diagnostic values, not inferred production selections.','Lazy empty-string initialization bypassed with initialized native layout; allocation/IO/constructors are separate contracts.'])
(r/'data/4.20/map_resource_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
