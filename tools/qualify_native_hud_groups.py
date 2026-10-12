from pathlib import Path
import json,struct,hashlib,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD groups prerequisites','exec'))
u.mem_map(0x50000000,0x10000);manager=vector+0x14000;query=vector+0x6000;element=vector+0x7000;owner=vector+0x8000
head=0x50000000;nodes_start=head+0x100;groups_start=head+0x4000;group_by_name={};current_frame=vector+0x1b000
def h(name):
 value=0
 for c in name.lower():
  value=((value<<4)+c)&0xffffffff;high=value&0xf0000000
  if high:value^=high^(high>>24)
 return value
def make_tree(names):
 global group_by_name
 u.mem_write(head,b'\0'*0x10000);group_by_name={name:groups_start+i*0x100 for i,name in enumerate(names)}
 ordered=sorted([(h(name),group_by_name[name]) for name in names]);assert len({v[0] for v in ordered})==len(ordered)
 w(manager+0x28,head);u.mem_write(head+0xd,b'\1');counter=0
 def subtree(entries):
  nonlocal counter
  if not entries:return head
  mid=len(entries)//2;ptr=nodes_start+counter*0x20;counter+=1
  w(ptr,subtree(entries[:mid]));w(ptr+8,subtree(entries[mid+1:]));w(ptr+0x10,entries[mid][0]);w(ptr+0x14,entries[mid][1]);return ptr
 w(head+4,subtree(ordered))
def hook(uc,address,size,user):
 if address==0x9a32fd:uc.reg_write(UC_X86_REG_EIP,end);return
 if address==vector+0x5000:finish(current_frame);return
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x14ae664,0);w(0x1222f40,0)
source=json.loads((r/'data/4.20/native_hud_file_loop_contract.json').read_text(encoding='utf-8'))
names=sorted({bytes.fromhex(e['output_hex'])[32:64].split(b'\0')[0] for c in source['cases'] for e in c['accepted']});assert len(names)==42
registry=names+[b'aq'];make_tree(registry);lookup_cases=[]
for key in names+[n.upper() for n in names]+[b'aq',b'ba',b'',b'NoSuchGroup',b'HUDCenterExtra']:
 for name,ptr in group_by_name.items():u.mem_write(ptr+0x25,b'\xa5'*32)
 u.mem_write(query,key+b'\0');w(stack,end);w(stack+4,query);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x9a91c0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);matches=[n for n in registry if h(n)==h(key)];assert result==(group_by_name[matches[0]] if matches else 0)
 lookup_cases.append(dict(query_hex=key.hex(),hash=h(key),matched_name=matches[0].decode() if matches else None,name_storage_hex=bytes(u.mem_read(result+0x25,32)).hex() if result else None))
make_tree([b'old',b'new']);old=group_by_name[b'old'];new=group_by_name[b'new'];binding_cases=[]
clock_owner=vector+0x19000;clock_obj=vector+0x1a000;clock_vt=vector+0x1c000
w(0x2d79078,clock_owner);w(clock_owner+0x14,clock_obj);w(clock_obj,clock_vt);w(clock_vt+0x100,vector+0x5000)
for previous,target,old_clock,new_clock,invalid,initial_flags,owner_flags,frame in itertools.product(['none','absent','front','middle','last'],['missing','old','new'],[False,True],[False,True],[False,True],[0,8],[0,2],[0,17]):
 previous_ptr=0 if previous=='none' else old;target_ptr={'missing':0,'old':old,'new':new}[target]
 members=[101,102] if previous in ['none','absent'] else [element,101,102] if previous=='front' else [101,element,102] if previous=='middle' else [101,102,element]
 for ptr,clock,storage,items in [(old,old_clock,vector+0x17000,members),(new,new_clock,vector+0x18000,[201,202])]:
  u.mem_write(ptr,b'\0'*0x100);w(ptr+0x10,int(clock));w(ptr+0x14,99);w(ptr+0x1c,initial_flags);w(ptr+0x4c,storage);w(ptr+0x50,storage+len(items)*4);w(ptr+0x54,storage+0x400)
  for i,item in enumerate(items):w(storage+i*4,item)
 u.mem_write(element,b'\0'*0x100);u.mem_write(element+0x20,target.encode()+b'\0');w(element+0x50,previous_ptr);w(element+0x4c,123);w(owner+0x10,manager);w(manager+8,owner_flags);w(current_frame+4,frame);w(current_frame+8,int(invalid))
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x800);u.reg_write(UC_X86_REG_EBX,owner);u.reg_write(UC_X86_REG_EDI,element);u.emu_start(0x9a35c3,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 def state(ptr):
  return dict(flags=read(ptr+0x1c),last_frame=read(ptr+0x14),members=[0 if read(p)==element else read(p) for p in range(read(ptr+0x4c),read(ptr+0x50),4)])
 actual_ptr=read(element+0x50);assert actual_ptr in [0,old,new]
 binding_cases.append(dict(previous=previous,target=target,old_clock=old_clock,new_clock=new_clock,clock_invalid=invalid,initial_flags=initial_flags,owner_flags=owner_flags,frame=frame,output=dict(group='none' if actual_ptr==0 else 'old' if actual_ptr==old else 'new',index=read(element+0x4c),owner_flags=read(manager+8),old=state(old),new=state(new))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),registry=[dict(name=n.decode(),hash=h(n)) for n in registry],source_groups=42,lookup_cases=lookup_cases,binding_cases=binding_cases,lookup_case_count=len(lookup_cases),binding_case_count=len(binding_cases),limits=['Original9A91C0/hash/name-copy and9A35C3binding/9A78D0removal/vector push/memmove execute; prebuilt ordered tree and group/vector storage supplied.','Frame virtual getter supplied; upstream clock/group construction, settings, lifetime, bounds and drawing remain open.','Creation/replacement file loading and resource handles are separate; isolated qualified group state transitions only.'])
(r/'data/4.20/native_hud_groups_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,source_groups=42,lookup_cases=len(lookup_cases),binding_cases=len(binding_cases),native_addresses=len(visited))))
