from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD registry prerequisites','exec'))
owner=vector+0x6000;sentinel=vector+0xf000;next_node=sentinel+0x100;registered=[];pending=None
w(owner+0x1c4,sentinel);w(owner+0x1c8,0);w(sentinel,sentinel);w(sentinel+4,sentinel)
def pair(ptr):
 name_ptr=read(ptr);name=bytes(u.mem_read(name_ptr,80)).split(b'\0')[0].decode('ascii')
 return dict(name=name,callback=hex(read(ptr+4)))
def registry_hook(uc,a,size,user):
 global next_node,pending
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x9ab4b0:
  pending=pair(read(sp+12));node=next_node;next_node+=0x40;w(node+4,sentinel);finish(node,12);return
 if a==0x6f0320:
  assert uc.reg_read(UC_X86_REG_ECX)==owner+0x1c0
  actual=pair(read(sp+4));assert actual==pending;registered.append(actual);pending=None;finish(0,12);return
 if a==0x9ab3b0:
  assert uc.reg_read(UC_X86_REG_ECX)==owner+0x1c0
  registered.append(pair(read(sp+8)));finish(read(sp+4),8);return
 assert 0x9a10d0<=a<=0x9a195d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,registry_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
u.emu_start(0x9a10d0,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
candidate=json.loads((r/'data/4.20/native_hud_property_registry_candidates.json').read_text(encoding='utf-8'))
expected=[dict(name=p['name'],callback=p['callback']) for p in candidate['registration_candidates']];assert registered==expected and len(registered)==28
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a10d0',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),property_count=len(registered),registrations=registered,runtime_adapters=['Node allocation/list linking insertion and hash registry insertion helpers adapted to receive native property/callback pairs; native registration routine executes.','Empty owner registry supplied; original container storage/collision/lifetime/lookup not qualified.'],limits=['Association and ordering of28properties to native callback addresses proved at insertion boundary only.','Actual property callbacks, structural parser integration and runtime rendering still incomplete.'])
(r/'data/4.20/native_hud_property_registry_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,properties=len(registered),native_addresses=len(visited))))
