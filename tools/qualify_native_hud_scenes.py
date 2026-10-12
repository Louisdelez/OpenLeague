from pathlib import Path
import json,struct,hashlib,datetime,zipfile
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD scenes prerequisites','exec'))
u.mem_map(0x50000000,0x100000);source_ptr=0x50000000;arena=0x50040000;slots_base=0x50060000;manager=vector+0x6000;cursor=vector+0x7000;named_node=vector+0x8000;groups_vector=vector+0x14000
next_obj=arena;slots={};created=[]
def cbytes(ptr):return bytes(u.mem_read(ptr,32)).split(b'\0')[0]
def h(name):
 value=0
 for c in name.lower():
  value=((value<<4)+c)&0xffffffff;high=value&0xf0000000
  if high:value^=high^(high>>24)
 return value
def hook(uc,address,size,user):
 global next_obj
 sp=uc.reg_read(UC_X86_REG_ESP)
 if address==0x9a91c0:
  name=cbytes(read(sp+4));ptr=read(slots[h(name)]) if h(name) in slots else 0
  finish(ptr,4);return
 if address==0x9aab60:
  ptr=next_obj;next_obj+=0x100;created.append(ptr);u.mem_write(ptr,b'\xa5'*0x100);uc.reg_write(UC_X86_REG_ECX,ptr);uc.reg_write(UC_X86_REG_EIP,0x9a74e0);return
 if address==0x5bd9b0:
  key=read(read(sp+4))
  if key not in slots:slots[key]=slots_base+len(slots)*4;w(slots[key],0)
  finish(slots[key],4);return
 if address==0x9a6250:finish(named_node,4);return
 scanner_hook(uc,address,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
with zipfile.ZipFile(r/'data/4.20/archives/menu/HUD.zip') as z:original=z.read('HUD/Scenes.ini')
inputs=[('original Scenes.ini',original)]
for enabled in ['0','1','-1','4294967295','invalid']:
 for atlased,dynamic,alpha in [('0','0','0'),('1','1','1'),('2','3','4')]:
  inputs.append((enabled+':'+atlased+dynamic+alpha,('////////\nName: Example\nEnabled: '+enabled+'\nLayer: -1\nAtlased: '+atlased+'\nDynamic: '+dynamic+'\nAlpha: '+alpha+'\n').encode()))
inputs += [('missing optional','//\nName: Example\nLayer: 2\n'.encode()),('invalid header',b'//\nInvalid: Foo\nEnabled: 1\n'),('duplicate update',b'//\nName: Example\nEnabled: 1\nLayer: 1\nAtlased: 1\nDynamic: 1\nAlpha: 1\n//\nName: Example\nEnabled: 0\nLayer: 2\nAtlased: 0\nDynamic: 0\nAlpha: 0\n')]
cases=[]
for label,data in inputs:
 slots.clear();created.clear();next_obj=arena;u.mem_write(source_ptr,data+b'\0'*1024);u.mem_write(manager,b'\0'*0x100);w(manager+0x1c,groups_vector);w(manager+0x20,groups_vector);w(manager+0x24,groups_vector+0x2000);w(cursor,source_ptr);w(cursor+4,len(data));steps=[]
 while True:
  start=read(cursor)-source_ptr;w(stack,end);w(stack+4,cursor);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.reg_write(UC_X86_REG_FPCW,0x027f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x9a9240,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  accepted=bool(u.reg_read(UC_X86_REG_EAX)&255);steps.append(dict(start=start,consumed=read(cursor)-source_ptr-start,accepted=accepted))
  if not accepted:break
  assert len(steps)<200 and read(cursor)-source_ptr>start,(label,len(steps),steps[-3:],hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_EAX)))
 groups=[]
 for ptr in created:
  groups.append(dict(name=cbytes(ptr+0x25).decode(),name_storage_hex=bytes(u.mem_read(ptr+0x25,32)).hex(),hash=read(ptr+0x48),flags=read(ptr+0x1c),layer=read(ptr+0x18),alpha_flags=read(ptr+0x20),enabled_marker=bytes(u.mem_read(ptr+0x24,1)).hex(),storage_hex=bytes(u.mem_read(ptr,0xd8)).hex()))
 assert (read(manager+0x20)-read(manager+0x1c))//4==len(created)
 cases.append(dict(label=label,input_hex=data.hex(),calls=steps,consumed=read(cursor)-source_ptr,remaining=read(cursor+4),manager_flags=read(manager+8),groups=groups))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source_sha256=hashlib.sha256(original).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original9A9240parser/9A9100factory/9A74E0constructor/header/integer scanf/copy/hash/vector execute.','Pool allocation redirected to original constructor; named registry/tree insertion/lookup supplied, qualified lookup behavior separate.','C locale/CRT thread context supplied; full file-provider prefix, settings, bounds/layout/clock lifecycle and drawing remain open.'])
(r/'data/4.20/native_hud_scenes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(cases),original_groups=len(cases[0]['groups']),native_addresses=len(visited))))
