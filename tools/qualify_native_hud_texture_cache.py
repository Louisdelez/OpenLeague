from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'texture cache prerequisites','exec'))
u.mem_map(0x50000000,0x10000);head=0x50000000;manager=vector+0x14000;query=vector+0x6000
def h(name):
 value=0
 for c in name.lower():
  value=((value<<4)+c)&0xffffffff;high=value&0xf0000000
  if high:value^=high^(high>>24)
 return value
source=json.loads((r/'data/4.20/native_hud_file_loop_contract.json').read_text(encoding='utf-8'));names=set()
for case in source['cases']:
 for record in case['accepted']:
  b=bytes.fromhex(record['output_hex']);kind=int.from_bytes(b[0x40:0x44],'little')
  for off in ([0x1e0] if kind==1 else [0x21c,0x23c] if kind==2 else []):
   name=b[off:off+32].split(b'\0')[0]
   if name:names.add(name)
names=sorted(names);assert names;registry=names+[b'aq'];assert len({h(n) for n in registry})==len(registry)
resources={name:head+0x4000+i*0x80 for i,name in enumerate(registry)};u.mem_write(head,b'\0'*0x10000);u.mem_write(head+0xd,b'\1');w(manager+8,head);counter=0
def tree(rows):
 global counter
 if not rows:return head
 mid=len(rows)//2;node=head+0x100+counter*0x20;counter+=1
 w(node,tree(rows[:mid]));w(node+8,tree(rows[mid+1:]));w(node+0x10,rows[mid][0]);w(node+0x14,rows[mid][1]);return node
w(head+4,tree(sorted((h(n),p) for n,p in resources.items())))
for name,ptr in resources.items():u.mem_write(ptr,name+b'\0');w(ptr+0x24,h(name))
missing=False
def hook(uc,address,size,user):
 global missing
 if address==0x99e0af:missing=True;uc.reg_write(UC_X86_REG_EIP,end);return
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x14ae664,0);w(0x1222f40,0);cases=[]
for key in names+[n.upper() for n in names]+[b'aq',b'ba',b'',b'NoSuchTexture']:
 missing=False;u.mem_write(query,key+b'\0');before={n:bytes(u.mem_read(p,0x80)) for n,p in resources.items()}
 w(stack,end);w(stack+4,query);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x99e040,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 matches=[n for n in registry if h(n)==h(key)];assert missing==(not bool(matches))
 if matches:assert u.reg_read(UC_X86_REG_EAX)==resources[matches[0]]
 assert all(bytes(u.mem_read(resources[n],0x80))==b for n,b in before.items())
 cases.append(dict(query_hex=key.hex(),hash=h(key),allocation_boundary_entered=missing,matched_name=matches[0].decode() if matches else None,resource_storage_unchanged=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),source_texture_names=[n.decode() for n in names],case_count=len(cases),cases=cases,limits=['Original99E040hash/tree/cache-hit and name comparison execute on supplied ordered tree/resource storage. Comparison result ignored after hash match; no renaming.','Missing key stops at99E0AFbefore allocation and texture loader; not a missing-texture rendering fallback qualification.','Texture creation/loading, native GPU handles, assignment and lifecycle remain open.'])
(r/'data/4.20/native_hud_texture_cache_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,source_texture_names=len(names),cases=len(cases),native_addresses=len(visited))))
